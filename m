Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D3B323277
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 21:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbhBWUvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 15:51:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4084 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234490AbhBWUux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 15:50:53 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NKiNpt004119;
        Tue, 23 Feb 2021 12:49:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=wsGnfDrGa9GJ0H8VV961LGJuc+8LH2Ma8djZCWTCPGo=;
 b=VJgWKbjRWNAhGwwwhOYhVxNWaRYtoLdZzFabhT0Q0MP6ukxN2WFvqP+yQvsqOemX82UD
 wOm/Un58lYMaCxczaqWUTqI0WXWba9GYoiyuRfVWnGhRDJwuuknR3tKeja2wqGhAIjZ+
 EtSXW8MEjOjGcO5KtKlhkQFI9A5YIjExfu8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36v9gn9r8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Feb 2021 12:49:49 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Feb 2021 12:49:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByqPwo0mdlBI2LqbA2TJmLpQj33A53oeqL/ol3WwZfhpdnlkZd5FGIWqtlhKBhkDL+MAwoyz1v4iokv9Imk8E0YS6/vNlkZhOvJimRzyxDd5+D1NpNoYlMhq9nwKlKHlJYctE2xV95nAkr0mEGRT+Iu3v4J2neLm0Ckyq/rzGXEYPrDU9mzzL4VM+G6QG1Qq9lWp7Gard6JJibdrVc5pINiGMLTQmhzKPSt2I5tUGT821rf4oQJGOe0kaBYjE88/p40mLeAd8XChPcnucKxpGUNIl8c8roDs+UShTezaR9BzWnORAbwX+9CglBOXnA6SdXMMYemDU8G8vnyMlwwmkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsGnfDrGa9GJ0H8VV961LGJuc+8LH2Ma8djZCWTCPGo=;
 b=gz23DpPeZF6f/JyI3kCKDqwWogyE6eJuNJIj0BYXF8ZD3q1r/qFf6ZOBIpdAwqIBpZEUlzfDcoP6ocugRX/5OKdi0fpyodSCfBS6Gq3cpOocRA87t54saUyzuj3S3K6/Lv27wvAj1cXQjznt5h4FDO7yL02N76tuwnAQAiBZ0BV2TkHx/ZpCfTY+uK8oOuHYGT/+k3d95j77aN2vILcVUPEFGx23fFQZpTLU+RYy4RxQqc8cHHDTlyJaBieqE2wuk+Hf6L4ApzJq7Q6xmLkkJu2KOI78JgGnjGrFotTSQQRZNtpnMX6S9zbsRSCj3bD+5Kn5xtXDuBt548D0f1GJCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BN8PR15MB2995.namprd15.prod.outlook.com (2603:10b6:408:8a::16)
 by BN8PR15MB2849.namprd15.prod.outlook.com (2603:10b6:408:91::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Tue, 23 Feb
 2021 20:49:32 +0000
Received: from BN8PR15MB2995.namprd15.prod.outlook.com
 ([fe80::15e7:9706:a9a9:c13e]) by BN8PR15MB2995.namprd15.prod.outlook.com
 ([fe80::15e7:9706:a9a9:c13e%3]) with mapi id 15.20.3846.041; Tue, 23 Feb 2021
 20:49:32 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 2/6] bpf: prevent deadlock from recursive
 bpf_task_storage_[get|delete]
Thread-Topic: [PATCH v4 bpf-next 2/6] bpf: prevent deadlock from recursive
 bpf_task_storage_[get|delete]
Thread-Index: AQHXCYIynt1KuoobvEWNWRDMRSL2HapllNIAgACi7QA=
Date:   Tue, 23 Feb 2021 20:49:32 +0000
Message-ID: <A6645DA7-41B1-431E-8C5F-1CDAC1445242@fb.com>
References: <20210223012014.2087583-1-songliubraving@fb.com>
 <20210223012014.2087583-3-songliubraving@fb.com>
 <YDThrlixVqfHP7I9@hirez.programming.kicks-ass.net>
In-Reply-To: <YDThrlixVqfHP7I9@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c091:480::1:8f65]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bd29080-ad42-4812-5ef9-08d8d83c8584
x-ms-traffictypediagnostic: BN8PR15MB2849:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB28497B40264A4ECF45333F07B3809@BN8PR15MB2849.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mk+ifTGYCP6CSWqK1H2DsCz8oNYeNbY9Z57WS7eHcC6l8uSNg2k2G2/w3+ZfNPu+OptFws8/CYdIcKeKOGeiwKwfqz3REaJHRH70+TKPSXI0K/vx25CkuOJm74J5NxVugZNdnnX8cxYIb/k3nPLP9wLAxUeOLE1kmpbRnkKufpnMtzU4tOn8xGcsQ8f2zB3UKGpb0RNHTJjC0323H7GHN9wGz7CoEvdDZXjvYvV+De9NoWSuWnPKJlJOlZTpt6S74O3anCfKZsZH958c/40OWHFExfLP0I0yD37kIC+eP2WE2tL/9SOeNjlc92MKvXMYmCZroojlR2otl4sT2OFMs5YGyAqv3vb3aj5fA+8XgkIyV2alfgPqNonk02ryje8jI+hgrTp4UtAiaucbBgMTFFmiYy1oLo3mkp6n0l5d56pPFbhEWabHPwstKH56b6U0urByQUneyjQBDwBhoBnbcDUT8mW/rk1bYDdJj8y18udfFBBuEjb7oicuKtboErhIP8JGHwgJdgqIp46lAUv7zcQQ/fp0o/cn9u07h7E4FdfBb6pxXnUEQBCIU+lK66hO+jw1ppJg4s6CTvUWSypN6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB2995.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(346002)(39860400002)(478600001)(36756003)(86362001)(83380400001)(316002)(186003)(2906002)(54906003)(8936002)(2616005)(4326008)(91956017)(33656002)(6916009)(53546011)(66556008)(4744005)(5660300002)(66476007)(6512007)(76116006)(71200400001)(66446008)(8676002)(6486002)(6506007)(64756008)(66946007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gD6aPOz+HCvoUoF9IuzYFc3K8xn04/vKSPB5HcxaLAbp6NOh7EUB5Cq2XIIO?=
 =?us-ascii?Q?JqQSjH8a9RusNs9aL7pVFB+uMjC531rOoVjuGPUxJI5m9KOQNWXAHnYNkpiO?=
 =?us-ascii?Q?E/Cw4CtptI1XGuv/RtIj6N/WfThpZ4jI3un4UM6s8fLH8SB3mWQ0f4aNOMth?=
 =?us-ascii?Q?leM053Ii0hScbcW9YXV/hmqTBV6XcLwz2khHAuDCxh2PC04rCRHIUhE17nVI?=
 =?us-ascii?Q?Hbi2zwYKZWwzzjUulnOHVSgiv7PjcIaDQDfk0PSfnAqOUIUGOKvHCUmLgcY8?=
 =?us-ascii?Q?5Nd6W/aHNC98CIq+zRPl3kXSfvuqGv8Vz1985U9+us+JMUDkfkAbkAKwv+yO?=
 =?us-ascii?Q?9QMpM4VpItvrodreDLAH+66IG83vHkuQJYVlUxo6KqeMAXNlfOmHS+t04T76?=
 =?us-ascii?Q?YwNgJFB9CgeqD0A8Qj/MP454nxRzqdzGejPGXfqmeTu91p3C16Gc8ftMlfX+?=
 =?us-ascii?Q?FJn3Uthhx+AZ70ymsXZu7ZpLidv/GSQYed4641tlEHSY0tHTSYS0UnpTpIXZ?=
 =?us-ascii?Q?zBCTYGuTANVhXq9MWhIy9wT6q+2EcoTGDy2LMvoT6+N62zhb89ZC872Oy4v9?=
 =?us-ascii?Q?i1kX9YXAB6e7+NTNfGWtUOUO9UrbmeROE5n38bvJczALlM5kMbQkATJ60eb0?=
 =?us-ascii?Q?EdX/OfWGQMnDmm6aBkyAXV4PrA24lLo+igR5ThN92FbKU3mbe9b9pzZslnNa?=
 =?us-ascii?Q?BWzjtXivhiYIqJR8NNK09FeXvgEcZ6qGcK5ETb5Frwm3THiUPbELnUewEiEV?=
 =?us-ascii?Q?OT79bLcw88HEhrSErSDTFV01yUPOtv4NDPu/F0+MDX8IW8FymI7NKemKWlKr?=
 =?us-ascii?Q?beOop9zkHfF/eDdiU2Q7WRv92WGI05AusvXLpRlmE3aVDBYTp6vKWXPaJ7IK?=
 =?us-ascii?Q?PE7f4gQ1OJm9IcKDpb0GQoBoMiXqb3Kopy49YnGnLZpC6qzkwk5J2N4QwVnP?=
 =?us-ascii?Q?yVgBL8Ra2+VmHXo9KQZGzrftLxhWb2CdSOLMcmHOuop7zRbTSdAgWKhnxUpl?=
 =?us-ascii?Q?3xKC068BF0Yu1Ghf4mGsDI6GaQ/a+miN0Ww5M0MCO/HiSujUxRyCNKf44Pmv?=
 =?us-ascii?Q?cLG7XeeQMWdZfRX8Ewcau0Kc/eu0hHINIRNXYHQx64n4O6wbFzBcuEYS1B60?=
 =?us-ascii?Q?kUrcJN6dE3L0PLnnULN36N7KxzS2WoEJAkJaOCgQrBHORhwM4fuq0U2Gl1yv?=
 =?us-ascii?Q?x84OoB+X8YVwVry3Qk9/3m73nfWJBZaVqzKcbNLASPrFGD6dSLbt47P/hwCq?=
 =?us-ascii?Q?CT2g4MjN15FaD96jXNMxaNVo6BIi/eEoWD02Bg24wEFtx6r6gZE1+JYqr3jz?=
 =?us-ascii?Q?Rc+y3IxeGEs3nfYRnH0mPkn+wzerLdC0rKQ0ZvCsjAdBxwNgzgkRsS7mpMqT?=
 =?us-ascii?Q?t/VuWnE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B7FF4B6A2D30E54D9685D7931B363B0C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB2995.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd29080-ad42-4812-5ef9-08d8d83c8584
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 20:49:32.1038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D9HBFmV8p8zCOzGRiZKDIRM7/xiYMo4bI5kA0vzris2CigMGJoIoWlCzVh3IZws4y82QCk2ikxPAi4wUOdu5dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2849
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_08:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=971
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230176
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 23, 2021, at 3:06 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> On Mon, Feb 22, 2021 at 05:20:10PM -0800, Song Liu wrote:
>> BPF helpers bpf_task_storage_[get|delete] could hold two locks:
>> bpf_local_storage_map_bucket->lock and bpf_local_storage->lock. Calling
>> these helpers from fentry/fexit programs on functions in bpf_*_storage.c
>> may cause deadlock on either locks.
>>=20
>> Prevent such deadlock with a per cpu counter, bpf_task_storage_busy, whi=
ch
>> is similar to bpf_prog_active. We need this counter to be global, becaus=
e
>=20
> So bpf_prog_active is one of the biggest turds around, and now you're
> making it worse ?!

bpf_prog_active is a distraction here. We are trying to enable task local=20
storage for fentry/fext programs, which do not use bpf_prog_active.

bpf_task_storage_busy counter is introduced to protect against a specific=20
pattern of deadlocks (attaching fentry/fexit on bpf_task_storage_[get|delet=
e]=20
helpers, then let the programs call these two helpers again).=20

Thanks,
Song=
