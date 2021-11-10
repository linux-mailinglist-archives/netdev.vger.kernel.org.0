Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B8344CC74
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 23:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhKJWVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 17:21:36 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59552 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233832AbhKJWVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 17:21:06 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1AAMBPfP014858;
        Wed, 10 Nov 2021 14:18:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=Z72vwXrBgIUGIW/3XGwkA18L/ASUqDe9yUxh8FuxdtI=;
 b=HDwjAoqUSVMnovcYZ7hDFMeSDdRmeTodAxGRHctuJkiyrguIwKjz9j9oHF9nrK+vdELA
 jPzz1Z8C4A0fh4vIGEdSgOhb1vy+v6Nsnf3V0QDROXmTBLMAkBFW64w6Soqd467T7TRr
 Ua+gt6F8ql9fEvRxYqM0jUVS0XacgTCzsd4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3c8p6j07tj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 10 Nov 2021 14:18:17 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 10 Nov 2021 14:18:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Szv1Im3EDU0jRLJCV3jRU5LJ3r/h2KQEV/2o1D2kRDw0R4bNh4DusGH5vVVKT4QtA/EpFz+ERwYU9qJnvRR3ckYaY2/PSBFoYm5QlrP7PGjAL7y4vvO53OMDY9vdXHlzJdCXrA06y151xQKihqUmTEawN0nECWC/DpWHieMRVxK/3ax7rLXsxPFkfB22tyhNm0wwjv1OltjyieBm1PzvplCjYuU/2IJYmHExm28C5CsDlLTjICSVhG3E3w6/3/S2/PMYaAST9BELbSiwhXTXXgSgQe0KJU6ES+HHuo+sMm5VARMl4zJ8AEUfVfF5AhjLoCxhp5qK5n82kqjeRsbyuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z72vwXrBgIUGIW/3XGwkA18L/ASUqDe9yUxh8FuxdtI=;
 b=XKx6r6orc69sN/BCXnaHOKHAVgDMAMUJmxcVXOT6wY971OMguPppJuTfCwq1nTQEu0z5LUtm+9AdN9XWhOknxc2WS29307PkChjviLS033cDjelwWuW4R9TOSFNAsDWHxa/VSzl4Ra+xF54sq02gtxjjyZhOExTxg5jq+lMH4q1f3Dst6r0/5iIP63RIVfMtFfwjWQJ062EgFk5PDavegatjKKuMF99b8i26BimTeomI0KdcjO0+ZDs/1sNwLxEEhOnSUP1N57D2u757rS5S0HdlbsF9cCMrldzl21AfL025yVRf75AE6/4qb44rDU+bqDCNpH6k3gV4K0dqghgZxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8)
 by PH7PR15MB5150.namprd15.prod.outlook.com (2603:10b6:510:132::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Wed, 10 Nov
 2021 22:18:14 +0000
Received: from PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::3102:269:96e6:379c]) by PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::3102:269:96e6:379c%9]) with mapi id 15.20.4669.016; Wed, 10 Nov 2021
 22:18:13 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "syzbot+e0d81ec552a21d9071aa@syzkaller.appspotmail.com" 
        <syzbot+e0d81ec552a21d9071aa@syzkaller.appspotmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH bpf-next] bpf: extend BTF_ID_LIST_GLOBAL with parameter
 for number of IDs
Thread-Topic: [PATCH bpf-next] bpf: extend BTF_ID_LIST_GLOBAL with parameter
 for number of IDs
Thread-Index: AQHX1lq3iI8AbMTPnku0RGtvGKCV9qv9UJiAgAACdQCAAAC2gIAAATuA
Date:   Wed, 10 Nov 2021 22:18:13 +0000
Message-ID: <ACBC166D-A05B-4C91-9AA8-50C6BE4186B6@fb.com>
References: <20211110174442.619398-1-songliubraving@fb.com>
 <CAADnVQK5nHGnC_9+m0q__AdhSxuHtE5Uh98epw2JEdjOCP343Q@mail.gmail.com>
 <E3649A44-D11F-426A-A65D-ED40AA3B0214@fb.com>
 <CAADnVQJbqoAd85dHP03kY6geHU+GKg=S2afGT7dzQQyBLn-46A@mail.gmail.com>
In-Reply-To: <CAADnVQJbqoAd85dHP03kY6geHU+GKg=S2afGT7dzQQyBLn-46A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1401bd94-4767-4e2d-b2d9-08d9a497fcea
x-ms-traffictypediagnostic: PH7PR15MB5150:
x-microsoft-antispam-prvs: <PH7PR15MB515080A20CFA88704C491727B3939@PH7PR15MB5150.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4ct7k2kpqWByigm8Rh4FWmI7X4h9GC7QJFWEZKmzTKmM3Rlby7TXX7Wj40kFG/ooRkX2Z1We837AtgV4ylI8y+mVc/JmcRQ9VGt6ES0941fkresoszOR0O4vgniFHVZcA5MNCO5HyrPNo/MZzY+cr+lne28LtG34HZUjwCSPdwVsaX4rucC1bLgsG5N5lMiDstI3mc5v8b+AaQRtfHO9UfAhl+vU8SsSCC466nUsFNd1BwlgAJ0Lb/kNu4OEzHaCWZ9JXa9K4n/aQMFDH5EVkwcydSBRPxDw6PWRkxkloUfl6PUgCIwd0HgDFq2+fr/6i3/Q+hANDEfIpk6bHdqQuxhNf3HZMG382c8OsjxxUbpvl5Iu4+C1jSQMmqO+NeANmvc1wSbYJAmAmf5oUn67EEk+z2mO7+/0ubrjYti08yPohSfdizmDex7TbaV/aqArqYGQM9CqZrTlezOA9X/Zaz339iixdZVFtrm4hkWW9TzlKomC7kVWuY3LhbUXmiC6+5eufOzVnY8lrAzWzgJy3UBCSdUAN8K/CRaThnCoV4e90yN7AeplIgpqrzPdKHEDGSAGKCwj9lCZoaWDOOIzo9voE7k9jgQJLEJpoLfRKVDhlX3IqE3tSi5KL/aZVZOBRg0LYOZPhU0en9G9OKWG8i3Ghj33tSjoQbsdYFCj6Ns3ylRm1CoQanqRlora6qbyqCujqXQEBQfVnujqqMG860a6gl//rBeZ9DwVY5d3BHLUd7yHUSExeeptKI/IgiSxcBdkXHlPJBZelcAXEldrmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5117.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(38100700002)(8676002)(71200400001)(66946007)(64756008)(66556008)(508600001)(66476007)(54906003)(91956017)(66446008)(316002)(6486002)(186003)(8936002)(86362001)(76116006)(6512007)(6916009)(122000001)(4326008)(2616005)(38070700005)(53546011)(5660300002)(33656002)(2906002)(36756003)(21314003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qs5y5Iqg/GYKsOzDkVPKBi0Y+KbarBqkguaXo/iBG/BP+MpVbCyjGlUA5d1o?=
 =?us-ascii?Q?/UVPEZ+Tul2rgia+UiGfrk04cmGhL9eUCd4xVGFDBqciJthOrjIPc9ME37RR?=
 =?us-ascii?Q?RXfQsOnhHceq4vYJSBYcpfS6VFDxsgLHVekZarZYZH78NeCEzeKTu6WXOrXo?=
 =?us-ascii?Q?jwNNfnbNZnJIE9BSiHOZx/cQAl6CrpdlC8MaaLhbQdSp4NsADpJcPa09M1AX?=
 =?us-ascii?Q?kANhP7BVEf1o3Tqc491/A3mVRfCe++RTe9t2boykaucCFv8eIWGtQWK8YEUn?=
 =?us-ascii?Q?SJLJSbZGnnB41L7yJhKB8NJfZT4JumhPgA4xiaF6sl6S0PqoiWpVrKqCmiI7?=
 =?us-ascii?Q?g4snHyBWNpLiHitWivGgs8Mx7zXLWocJGuh3Isy/rEp/zT2kaHNH+cP94CQm?=
 =?us-ascii?Q?5RxNCGB3YZi1grktyZYUzADkIg1049DJeUfiYD0+XCKAqlvBVkItYW060d1j?=
 =?us-ascii?Q?EnWzaHYcACaMk/e5AFXe5joZxI9TUauFQ87F8srD2g1qauP12kg3HgMFPJUV?=
 =?us-ascii?Q?7Bhc9zbnYj07bmQA12C5JGCNESAMnkKr8JEUk7aTcreeDJnbxCCTRsjthRx2?=
 =?us-ascii?Q?YtUyZmrkICJgfux0NlP85pO3edtIgpTTXGVrtqfValMdSEWQdFWLCoaoiH3j?=
 =?us-ascii?Q?A46lIAarmjScwrV8enpwPTdQlLMOav26fH0O3w4Xy66YsKVz+u8W+pwOVFB/?=
 =?us-ascii?Q?7qNOBaVT3W9gHCwyXQsPGFTiZsMd6+Hro1pu7j/XxvMhYj4WADTvCUXeYd13?=
 =?us-ascii?Q?fHt++LnlqW+kiMlIDKpRxNDIR2qEFz27hIURM2VcM4VH7G6fnYMhVJG9SRpM?=
 =?us-ascii?Q?86200B/Gyn43bS4TuH/+DjzInKfuoqz7GXwj6BagF8xSC53Uxcv3t6ac6oqv?=
 =?us-ascii?Q?LZE/SSX4SjsvKOuyhstdxkkm0o93PiTHP8mPYgfPrHu4LMTHDfe2dd1ZAAo+?=
 =?us-ascii?Q?wC11KspAthYp+hYdph77fTOVKhVPvHaaPuTaCkfUiJQWu8F16CAqaTDmhA2L?=
 =?us-ascii?Q?FntvOfMzESVowbRLU+ntYYFiFu77HqpLWmzmvnoeBUTYR4lla59jGv1Pt/ek?=
 =?us-ascii?Q?RauUmNnY2YZ8RRlFauCg1fn3D/6wMvFIlX94F5MxHZJU9Qpk/Ak8TCaFeppO?=
 =?us-ascii?Q?Ca/A6nKheakgxZn2Oz071TE9fDmdujek5s4OZw9It4EZU1OgIeT2dXri3NPS?=
 =?us-ascii?Q?eD/0vNC4Dz554O8MR3FFPr/U/dkSVEciHBdBJMWc//DG2PnO4ZwTLhn5d5Df?=
 =?us-ascii?Q?OOx91+DQ9GeFlhLR8V927Ju2f2lmbite2vLBd5Pzp1DzbVW0+FOVy8jxZbtU?=
 =?us-ascii?Q?wKeilEjY8cfwl9SGYzlVzTy05AymKa19j04WnZ+0G75X4Fl563Pzp3W5tlsO?=
 =?us-ascii?Q?oRkCU7aST4kjsRkgeqNkWlOKkX8nVLRx3Njb73ShaGm5FGvz2v8Fsr84YRBD?=
 =?us-ascii?Q?mN9N5ggvK9J+z/FMyw+iTmKfhFvIxQ7KnjIVPxyleHT6kywoeYWUTe5WNW3U?=
 =?us-ascii?Q?TkiqM7INRYr8bbaIh/LTX+L65WeoQzLC2TOhUtidwzeAxWEXejTshS0/Zrae?=
 =?us-ascii?Q?SjKYzngQDALNqlKD/KXMr2s1PV2YBo/ywicyy91lxSfuNnijBZgz77GaTFLu?=
 =?us-ascii?Q?saIeek+LMrVsRvJnLK/CCJU/JbFMImktbcVRaiw5l0MSEnFeIe2hGg+wGrVx?=
 =?us-ascii?Q?ztaqnQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7BE3CB642CEE9E4D803EDA4B55E73A17@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5117.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1401bd94-4767-4e2d-b2d9-08d9a497fcea
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2021 22:18:13.8886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sn+cwRMDhqfzfOFNPJ/0ZYsTqUQbbRb8/yYnlZ60fgK97kGv/Uq9uzk8rcArvIIkkULqNjh7NlqhG0zI67T9VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5150
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: t3GAqceGsqRhcxi__9UVCC9b5YMoXTUG
X-Proofpoint-ORIG-GUID: t3GAqceGsqRhcxi__9UVCC9b5YMoXTUG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-10_14,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111100107
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 10, 2021, at 2:13 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> On Wed, Nov 10, 2021 at 2:11 PM Song Liu <songliubraving@fb.com> wrote:
>> 
>> 
>> 
>>> On Nov 10, 2021, at 2:02 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>>> 
>>> On Wed, Nov 10, 2021 at 9:47 AM Song Liu <songliubraving@fb.com> wrote:
>>>> 
>>>> -#ifdef CONFIG_DEBUG_INFO_BTF
>>>> -BTF_ID_LIST_GLOBAL(btf_sock_ids)
>>>> +BTF_ID_LIST_GLOBAL(btf_sock_ids, MAX_BTF_SOCK_TYPE)
>>>> #define BTF_SOCK_TYPE(name, type) BTF_ID(struct, type)
>>>> BTF_SOCK_TYPE_xxx
>>>> #undef BTF_SOCK_TYPE
>>>> -#else
>>>> -u32 btf_sock_ids[MAX_BTF_SOCK_TYPE];
>>>> -#endif
>>> 
>>> If we're trying to future proof it I think it would be better
>>> to combine it with MAX_BTF_SOCK_TYPE and BTF_SOCK_TYPE_xxx macro.
>>> (or have another macro that is tracing specific).
>>> That will help avoid cryptic btf_task_struct_ids[0|1|2]
>>> references in the code.
>> 
>> Yeah, this makes sense.
>> 
>> I am taking time off for tomorrow and Friday, so I probably won't
>> have time to implement this before 5.16-rc1. How about we ship
>> this fix as-is, and improve it later?
> 
> It's not rc1 material. It's in bpf-next only. There is no rush, I think.

Aha, I guess I messed up the branches.

Song 
