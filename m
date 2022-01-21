Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F5D49579E
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 02:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348212AbiAUBGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 20:06:45 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13106 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244885AbiAUBGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 20:06:38 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L060xY003267;
        Thu, 20 Jan 2022 17:06:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=PO2zk2E/r6IjHMa5xwd/q6k+ZCymIjVsakYnvKx23xk=;
 b=hkQEujusQldd6vxPhDJxG6QfFLRpBFYzXZthwlOY7rHT9xh/TqqpfFqrIT62WQu8swA0
 jXqCIw+3rg1FTOh/J5ZYUyP0Y5eGGTkLtLPmgpPiwK8GeZcuNd2b9Md7Bxz1SwLkbCE0
 3CwYNzHv3tZG8Myv/5QSvMe25E+MGKvFzIA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dqj0488g1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Jan 2022 17:06:37 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 20 Jan 2022 17:06:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eyrCAfQIpEunsRIwqL647+DPWT1cio9B1lIs0Sh9oa7kG2pKlqpTS3U72XZpjInf4UYwzFlgBW8Wn611Ui6XZHnJwVH7gXQL9MnaGv9fNOlCBh9GAKOWVi2ukkY0vRXVTexEnnX6pgz7YUY89fv4t0jB1PCQn7pnDbnlGF/c797KPVFyjr2GtQhd3QfIC6sCJlsMPjqg3dTYsQ7KTlfv8Syr3GuU6gdHSZwvD8+tLGe133kr57VfIJnCj1Arh1PJhqSIP1Kr4EPSvAMgKtMCWVIef7MG0R0aJb6cqWnYf99e9s5Ne53MQ5FgUqrc7czO/Y/jVI9F+WY9X16TF2cWfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PO2zk2E/r6IjHMa5xwd/q6k+ZCymIjVsakYnvKx23xk=;
 b=Ex1LNGUofcPOuRv/FbBR+mhx78hE13WXiz3iwAJlLufeJncnuAcA93IO6BdVK1gVknJZjCDBydWzW+Uzxs4caJm6tArJp+5tZnEa/0hDl2T1bLrTfUl1CIicwLGWQvrmjZJoOwummHHZDv67fvnSOitMEyPEeMlsiZNaaQBeyaukRj+XBYBKfAm5pbB0Jw14uOTJlD1Skwhs+UhwF1ENSgKVW0Q28sb8G/hA7Vb0AW5v19XiJjb5zZ8MlzlVPcuSf8tcoxtqXTrSWpS6A9cswDWXPFOnNhKqfuCBQ+ipg+HV0b5LSc1In1T5k4mmJDVPTF4oDCabojEsuwO5tcrlvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8)
 by MN2PR15MB2719.namprd15.prod.outlook.com (2603:10b6:208:12a::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 21 Jan
 2022 01:06:33 +0000
Received: from PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::430:58ba:aa54:45a1]) by PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::430:58ba:aa54:45a1%5]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 01:06:33 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Ziljstra <peterz@infradead.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v5 bpf-next 0/7] bpf_prog_pack allocator
Thread-Topic: [PATCH v5 bpf-next 0/7] bpf_prog_pack allocator
Thread-Index: AQHYDjHK6zwTvlFaXkKfSpJd3u7b6KxsqdyA
Date:   Fri, 21 Jan 2022 01:06:33 +0000
Message-ID: <6B6AC9AB-A09F-43E7-BF53-E0C7DEF45767@fb.com>
References: <20220120191306.1801459-1-song@kernel.org>
In-Reply-To: <20220120191306.1801459-1-song@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 046768ea-3356-409f-d350-08d9dc7a43e5
x-ms-traffictypediagnostic: MN2PR15MB2719:EE_
x-microsoft-antispam-prvs: <MN2PR15MB2719A8A1C6A1D9C5E04BB082B35B9@MN2PR15MB2719.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5NNlfdt4DfvZJWRTo7xRzomhKSqlUdXMJ2Y51EFFVaAY8P//Wm3ruYhb40IA7j6x57vubhnqwAefdk6R7sx7VekA9qLN7/Fthv8bP68LCxB2ipau5crrAKhHGgNxAMWYtBc8uN9Rs+M1foevpCWdmajJIBLc6kDx16Ea5olKf3BgqlllhL8NpVzG1/ZX4+OpJcbFAAfi6HftS0epNN6VOcMQXOVTbCWRJIz+QjW9/FP7v9KFEGBqAsWc6qTh8yyXV2iqw0RfvjnDdz3VsMT3roFXKPrijoYY3fxxZsXZLBaJxl6qW/Ewd+LG3NypQKWDUnIvQbQ1tcpY2W1FO2usZ6Zc9INMuV1+mQ0c4wyu9JlNBdldyWTe9JsxjUVXdAaqWcYfg9QVIbF+fzF8blHWSah4v5rv/IoVGRMsAd2ACKArplF6y2F7n3Dr8idxATC/Ex8eBpoZPcz6cuOTtryVsFtzaSbzeY3dXrcUUMiqAsqDD4EY5UrLqKAUntTW6muWW834gueLAEAf2wVtS5bGKNlA0/qXHj5xzg8TC/Jbe8wnNt7p0/ao7xAMMO4AkYVyMRQH1mzh0DzMFMLlSnQWFkvtz+njAzSPCmYd+qBx9sNoA/N+Y7IyD0bluXyyTjS6ochbZBgVmXD2uT13rvcNXjw3q5WCnWcICqACKNT2liqIIuBSAonN5LqkcuNkVthqPYFnHkE++SrbiE/oG8Uk/Rw8Tr1Ofh5g2gpGh0nIx5YH4MkSEIjTU1hrTh4lqsEj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5117.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(6916009)(186003)(38100700002)(91956017)(38070700005)(36756003)(76116006)(8936002)(54906003)(122000001)(6506007)(86362001)(4326008)(2906002)(71200400001)(33656002)(508600001)(5660300002)(316002)(2616005)(66556008)(66446008)(6486002)(64756008)(66946007)(66476007)(8676002)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QYxr7+Kr3qemE3gPRAPbSwCrm96pyuO1vTEXH7ogzd4HbTqmkip0iGFY3m4P?=
 =?us-ascii?Q?v8lAFH2qk1qNsbTNTZeI6bidqtLp9AlwOF8LfA6pkq7z7i5ww3GeSnyJruq0?=
 =?us-ascii?Q?KcJhkFAfET/J3oatLQ3B7T1UqGU5wSKjYr+81SlL123i50K0PhbOGS/QaGIY?=
 =?us-ascii?Q?34cfkFxDSFMYAiCmNQAgLo8iVsVKV5uk+NHMzdTe1sVV7CDFfUt9we/lqk2w?=
 =?us-ascii?Q?mf0kDIP/k8LJMdZs45hyLlMALtKHn5+8Ap5KgOef2TQr0kJHdl2oSIrwigiO?=
 =?us-ascii?Q?F1JNhpK7hmMkHWbwDjuCaRzQgZnCOnnQjgeuFvrjWJJ8TrwyYwP/K7GuY9uQ?=
 =?us-ascii?Q?j8kQg+WCBQCQXDBKmGEEMSgMi/WR5T7CvgVHgj/zPVxBN71uFP1Kd1IFRRpf?=
 =?us-ascii?Q?CaaoqwJQrt79FsH0hemhX9mm640FWNZFn5nbiu044jh4I96YoogGVT3MK9gG?=
 =?us-ascii?Q?SJz2hSSWLe127slKnSv8XWm2uzTGGYDfBNq4rR7qJHaqdwb/WbvrkpsVXK13?=
 =?us-ascii?Q?+JFj848550YpWxdfmkWDEpw9LFHJcvXlBj8acMR21lKijd1Gg4tL4fB25tF+?=
 =?us-ascii?Q?a2AUY+X5m+N6uTjlSgSrN0t6tCeZUYcaqqnNDcNEDKpXFQ983+0rdHGwCIMW?=
 =?us-ascii?Q?Wo3LdPs/j7nvGcMlBqQBQHwGaHcwSR4H0PVs/yDVXUkMrFLE5pPiT8rCVMLI?=
 =?us-ascii?Q?IFSuLUlieqS7X7YQs/hXE9hTJI7+ItaxMsrwASOuGpbvLuRZixbcobknksCg?=
 =?us-ascii?Q?PKgRtGJ74rev9LGVKyRilRin/6yegoZ1mIpyprt9AHx0H+XOipkTTTNzLgfO?=
 =?us-ascii?Q?B36RBj6OOv8IvLviTg6vbmGjtFQLYOH1QNUDDrLXg2MmjVqd1hvD9dOTWoCy?=
 =?us-ascii?Q?PPeMECvVErmYhjLPEiSmKPHMEPzigDqW562jQL1a0LyfM/ZlbBocQQCTcZR+?=
 =?us-ascii?Q?Zef/chEDN9/saAHufLox+4LHfceo/JMMoLPTuZLcCjySJVwVQ6iIOsN+9W/i?=
 =?us-ascii?Q?77NLUChDhRafs00ywH8U+Dwm0eXZbcNA63Fsbg1McHi9GlS7xUZyCWMJv2hf?=
 =?us-ascii?Q?tU4EopDiSGxRPyE0wtBH2iTLfs0rQyJUxtZSpUwtC+/fQqyqCWlQOq8V7kyB?=
 =?us-ascii?Q?udmvwugw1oyFG00GOSVxNXgIZeSMZwhypcu5gt2Qf3cIpuefohofrTH3llrP?=
 =?us-ascii?Q?vie6Gas8yT2KmRm3OaDqW94qCMF8KpnB/BzzU9a2t+XHJCnvTMg3x9dEMYm/?=
 =?us-ascii?Q?8ZlE0y2PcZiea3afRIq1ox46IM6PZqgkMEyQuu0mYTCGoSTRyXnrwSp50L94?=
 =?us-ascii?Q?xzHPqRKnr0A9UMTA5hRGlmlyrscm1DNRXrXxW9n6KsEW/xr9P/SiYjS7JT2d?=
 =?us-ascii?Q?C4RLiIn6+MRMSmxw05rFcY0Jmw1Xj+lUT4cmzdp88XfXnYdZf6d3cm8ho04I?=
 =?us-ascii?Q?FGvamdydNSJUwj2Wh6X0mP2ffTCNPFgdp/SDdzUOjjBsPjczShLPmtHVrRe7?=
 =?us-ascii?Q?KsrBAuEawBKpXFS+ubY1G3jfNR8YxZ9glCTjo1NK9qodHt57TzPN1VHfk3bQ?=
 =?us-ascii?Q?SUNE4uBMLYaw7evLm91Mxl/HfllL3LHFSi39Lhq2BHqhMvGtN/AgVSav3v70?=
 =?us-ascii?Q?5CCucvIha2e9FBaMtFTjLT7gMPG52U9IboD1SAvOhyvh0nXxMTBeF+nRL6e4?=
 =?us-ascii?Q?rSdmdw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EDBFACBF13F0494D8ADAB5BCE4D939A9@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5117.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 046768ea-3356-409f-d350-08d9dc7a43e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2022 01:06:33.1642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qFy3Q5pcU66o3ZvR0+QAoRqZT5RkFONAS07K3IfRjI50FnOqMPtwPedQew04gUnD8tdtCSXNK1Y3JJdTSV+vJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2719
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: wtCVAVJdmOWGi4fLM6pPOOPqKpiw3Rqz
X-Proofpoint-ORIG-GUID: wtCVAVJdmOWGi4fLM6pPOOPqKpiw3Rqz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-20_10,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=894
 spamscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peter,

> On Jan 20, 2022, at 11:12 AM, Song Liu <song@kernel.org> wrote:
> 
> Changes v4 => v5:
> 1. Do not use atomic64 for bpf_jit_current. (Alexei)
> 
> Changes v3 => v4:
> 1. Rename text_poke_jit() => text_poke_copy(). (Peter)
> 2. Change comment style. (Peter)
> 
> Changes v2 => v3:
> 1. Fix tailcall.
> 
> Changes v1 => v2:
> 1. Use text_poke instead of writing through linear mapping. (Peter)
> 2. Avoid making changes to non-x86_64 code.
> 
> Most BPF programs are small, but they consume a page each. For systems
> with busy traffic and many BPF programs, this could also add significant
> pressure to instruction TLB.
> 
> This set tries to solve this problem with customized allocator that pack
> multiple programs into a huge page.
> 
> Patches 1-5 prepare the work. Patch 6 contains key logic of the allocator.
> Patch 7 uses this allocator in x86_64 jit compiler.
> 
> Song Liu (7):
>  x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
>  bpf: use bytes instead of pages for bpf_jit_[charge|uncharge]_modmem
>  bpf: use size instead of pages in bpf_binary_header
>  bpf: add a pointer of bpf_binary_header to bpf_prog
>  x86/alternative: introduce text_poke_copy
>  bpf: introduce bpf_prog_pack allocator
>  bpf, x86_64: use bpf_prog_pack allocator

Could you please share your feedback for and/or ack this set?

Thanks,
Song

