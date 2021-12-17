Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C7547928D
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 18:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239720AbhLQRNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 12:13:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51096 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239710AbhLQRNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 12:13:45 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BHAAT8w021635;
        Fri, 17 Dec 2021 09:13:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=ITCB4xLcgYd45hVsBD6sGMUDHizyuCMVG0ho4rmGXnQ=;
 b=dwRas0Fdtqt5M4V26HFOaypzJDgYOa2rvDlFmYimO+2d2SkAr9lMDCkxnHYi4LOjYrAG
 dt6OC90fo8eJWPyQNaHirJN76lAOJnVVvWAAwjoxwjTj9R7nWkerJasP/VrftN9mtZNo
 81NRh4Jqr5IlnijZHqPGNCrcepkBFdrC5Oc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3d0rjn2ep8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 17 Dec 2021 09:13:44 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 17 Dec 2021 09:13:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xq8L3ZXpGEsJTrva5GQinsR7WXBaxCOb+eQUH7vatdbG0VqkiaLMS5F6tfeamFv4iqqf1jgGDeyVBlcFsbLa8vy1u1KxIt9LWP1VNLvTn6u+GcM/sqLhqMXlbogiZyRVLJcjXaV+DbxRtBuZ088ndXk8qzOn1fsjSKrpARxDO3PRrsjFvHN0Wb+YvsU/PXKakIOhrZDt+iZ7Sy590QVfxxkxoZCcOpPegbkwJJw5Pkiu0I9tNNI0Li5Esjkh2aAAJZOIdRdkIClCxxSpLZusGS7P9R5NOuUEftrtAiGmnzRxiLDchaoqws8hJFaH+YnSdEQutt2SsnRg+wV4lokjWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ITCB4xLcgYd45hVsBD6sGMUDHizyuCMVG0ho4rmGXnQ=;
 b=JatCK5f42sXC0d3WANOOu5dRsc0/BoWJSZeLea9Sdehj6JAOv2vt/FseGdgL6EL+MCXjxEOHBTSfHN6uDoEOluF0XO1KGaoA0IkZR+OMOrF7q+WkYdqQR5Kk8MHKqhPJj1N4buM4Xy5wZXt0oFaAaJnsOGtvuWWtuzA2h1vWvNhEmrem0/N3NmOS5PMdscjj/5u256jn66McHxw5NGNd273+nUdc2bd49SgxFdxlVpeBA2Z1sJitj8/EKgeg8dNjgQC6QZM9uv3qZizgFeLbd2T8pEZhEjcQ7+lVzYTDk8dwlKkpHcqyUFHLdteNSY7gnvU3MG9oEGVgmEK9TR/SlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5187.namprd15.prod.outlook.com (2603:10b6:806:237::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.18; Fri, 17 Dec
 2021 17:13:15 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33%6]) with mapi id 15.20.4801.015; Fri, 17 Dec 2021
 17:13:15 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "Peter Ziljstra" <peterz@infradead.org>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v2 bpf-next 0/7] bpf_prog_pack allocator
Thread-Topic: [PATCH v2 bpf-next 0/7] bpf_prog_pack allocator
Thread-Index: AQHX8Xkz/fv1YJcIlkCbgavAsgZfuqw1jcSAgABhLICAAPhJAIAAAC+AgAAIZQA=
Date:   Fri, 17 Dec 2021 17:13:15 +0000
Message-ID: <5AD9F449-6462-4501-9D1D-407956103DD4@fb.com>
References: <20211215060102.3793196-1-song@kernel.org>
 <CAEf4BzaFYPWCycTx+pHefhRHgD2n1WPyy9-L9TDJ8rHyGTaQSQ@mail.gmail.com>
 <DC857926-ECDA-4DF0-8058-C53DD15226AE@fb.com>
 <CAEf4BzbfqSGHCbG6-EC=DLd=yFCwDiKEFWMtG4hbY78dm2OA=Q@mail.gmail.com>
 <CAEf4Bzb3sbf5Ddq4FaBsZpyiqhoFD+PxxbZHP6ips6h01EuNYg@mail.gmail.com>
In-Reply-To: <CAEf4Bzb3sbf5Ddq4FaBsZpyiqhoFD+PxxbZHP6ips6h01EuNYg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dec8ecc0-6c55-440c-f364-08d9c1808356
x-ms-traffictypediagnostic: SA1PR15MB5187:EE_
x-microsoft-antispam-prvs: <SA1PR15MB5187B603A991ED050EBAF4A3B3789@SA1PR15MB5187.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pj4349XqDTfBdqZoV9GkEiu25iRA8Oy9npezhlR9Fvum5s6lYPQyJsQlBkoumg4PjuPqVg5CY+2tsJinY/XVlzoRlkf/WBIixCNodf52urIwIEql70l6CUT+c2vW5dMKof71JC6UrGu6bv58NspBwIgDvHuCNYz9ROnl7a4Ntj/6mktKsSv0xYtGAhp0+enl8ogCk1oNYd8HEXPjKJkaq8ulUU+GqmF9Mfl564kkoz6+hUW0p1wGKN7TaQ6riTWe/HI/ejR7YzrdB5b3QkI6eebG9o79CUaTcF/BJyPZpafP7yYlDxx0OrbmZEK66FXaEIZlkDFjfFJqZNEOLRBjTbHpald0vOlqRU+Qp2PACl0q0HFzXt+hkPkNS8Rq7nmCsarlz/abF2WhYjQa3rSQAvoqMlMWtoCRXLx9iJgSBOqOO4pw12ZxSsXYuNwZA7wWFwBrF0BRZBpJEDr6HgavtX/yo9AKKpoVt2tv1s20e2CcsfuBoNE3a10+m5xLMJ8C/eTNnp3pjvSsk/zsGQVuIcUv+W946XrGfduITZ1Lqaa8IEUH/aqQQMr2VLZm8d8rYjRAebjyQrR5YNua4+B+s+/ky9xj20xxHh7f7Z2AfLsE1Eg5vB29A8CQyREk0nJJ1h47+1aAktxfP3741QmnFN29j4ajG8uCaJca+g4bJFgewrl+Sm0DFHi//9NMCHNpCNiBp+tJ7ZLPIgLEy4+WFAl+UzP2M7HIqUgyQ8oL/RRLsi+R+kdn2uAE7F5FTQAkKGzUSwtnWcGxRPm8KForZTMNyWPia8OiUvTdTUgVPh/9h8YMRxxTQjNnvRuklhS1dn8WIrmP5lUORMkIioO0Sw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(4326008)(66556008)(186003)(8936002)(6486002)(122000001)(66476007)(83380400001)(316002)(8676002)(7416002)(33656002)(5660300002)(91956017)(6506007)(86362001)(66946007)(54906003)(966005)(76116006)(38070700005)(36756003)(2906002)(38100700002)(6916009)(6512007)(66446008)(64756008)(53546011)(71200400001)(508600001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eAbBgYd8jUM0gttKHy7ZyA7th1q7AlYth7stDAdohncP4dnyqWP/3KphRA3B?=
 =?us-ascii?Q?dRagjbKF4ZCoU2VP1hOxQquvu4ZD+hK4DnQFobNrs0P27YJPZvRs3nWPJPhT?=
 =?us-ascii?Q?U5FX0z355U5O5Qb9JkzPeLwsjt7wfP3QgJcrAyETXV5nblydloh7bT84F+Hd?=
 =?us-ascii?Q?/MXy1ZoN8M4ZiaqWo29pNEhPh2fvJ3xIa3bZmDlKvBzmpILmXwLMLGkm4mor?=
 =?us-ascii?Q?bxqnhn58AdTDRQH9+2RjL+nMV9RMVMmNpy++//p9BtF5SFt5PeLfW6av1oRh?=
 =?us-ascii?Q?kRf9bxe/Mdg866mimJqpe8CBWBo1ewuIMebTJBmEFseXB2dtmHs51MRQu+T6?=
 =?us-ascii?Q?c7iVdkL9j7Va9hDQBtiPKdiVMK5ORBip/r5u9RWkjn8XTUe6xFp1d7S/0Cos?=
 =?us-ascii?Q?WEUvGcV5HjGDnjSU5mLm8dPf5toxGpwYJpHXlmQ0EVZ3juUHcNLWRj3D0iKT?=
 =?us-ascii?Q?6mZCxjF567wDnWPhZpCYrN4CKrN4Z/ZR0LISkTogch3oKltEnOTme9gAGJo/?=
 =?us-ascii?Q?XaKPF0R2Yh2ukSakBBuVuy0qjeNl7POpf3IwZ7A+j5b8kNfoP+o19jNVjgsp?=
 =?us-ascii?Q?WXPL2Ip6f0jmvHM0l+gkU8+zMl63vunvb/+cg1poj+hhNPBQl0BuBnl86HiD?=
 =?us-ascii?Q?ZZhzbm3d+Z7JQfJdthBKb5Ub0KX5dPGIEBZtQ84682J0qzt+xZL6bR2cVbtN?=
 =?us-ascii?Q?zo2GqEJr3jqa0tkvssgH4kXIyaca5k6sOEBTSkB5lLJpQf9VFsDECkFnwT8X?=
 =?us-ascii?Q?+Zy2AKaZbuxWcxRnMFTaYjB1NrSpuMVz+mBUhhphk+Dz0TyGC8B35ah9ZptK?=
 =?us-ascii?Q?9t4RdAKU8eYq0C2ODBKnLZUqwcE70XPSDXIg+1sRVVPP+bNeIQWfYF0LJF11?=
 =?us-ascii?Q?ijX4vdMm5v4H1IbizIRRF2aLDRhLK4VMeSMwT7ZEKqz0XgaJ48SzJhXkO3/8?=
 =?us-ascii?Q?8hX6w9+f2QxT6BalJtx1jJzvGHQED5POH3tGwhRho+10EirJfZ0Hr75CdSTz?=
 =?us-ascii?Q?c3LujpQYQXOspXOc5yF3DnUBwDlbxcRcBLs/uE/LXzJd5saRP4dvws+5aF8S?=
 =?us-ascii?Q?YXdzpM0XecoHltEuOABr9hMNFdqC4UfNvwRShqHHHOF6s6TAthaXG7LunTWd?=
 =?us-ascii?Q?7ce56wHxbxhCmX5L/TS3l351u3MHvDYFXG6VF43tnWFysaHTJe3zvUc6VtDp?=
 =?us-ascii?Q?GD1nqpA0r7VE5K57VBI7t18LvHF+Sp54wXoGrsbZo3BhRv8VG46zRyIj4kgy?=
 =?us-ascii?Q?RvREREWdzc9pSeNrP4wDduxD7Y67ePoCNzetiOgn9eTwQ2baceACLgFrxent?=
 =?us-ascii?Q?xU7lLDd7Q+0tz6ETl2nG67ZKOsSdigKZ8jq1Rl1FyY9OlpZALIIOSuwuL2VV?=
 =?us-ascii?Q?n4cqBT7yytzCDPm53JItsjviN6lK4P8+RtPA7mYAvn4DoDMbN3K3S9r6cRSl?=
 =?us-ascii?Q?2TVHuPgdyYvWS3z8k6YgeMTapVfF6cx9uw3IKJSZeWEsnui2h/j5omdhnWJe?=
 =?us-ascii?Q?jJASVNY7oU556Bhgtu6vw/CcfgtBNEExCT99fX126VFvNRZZhWww7wOYf7VJ?=
 =?us-ascii?Q?2hexxbjmoCis59sUkWS0Rc4KGLcJ8fS7jlqpgBJHyvFzhYdEKgKwND15A+ZX?=
 =?us-ascii?Q?vcH8xRs18AizGW/LXXS+REuARkvtTWwrKPtSwyxeDP0gMYPPiuuGcWJYX9SX?=
 =?us-ascii?Q?suVfgA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <41067DE1E1728940BCAC21019611451B@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dec8ecc0-6c55-440c-f364-08d9c1808356
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 17:13:15.1361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yQpO5IkZNoXsE8AdxqC6UPUwX0sVocwoECfR7Ivj52rsWlyukbiGdpiDHPHuZYcnJ4CQ52CMk8yD/nCUj0FtEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5187
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 72ojtpPYuznHsdijx7wAg3_7mefs0olN
X-Proofpoint-GUID: 72ojtpPYuznHsdijx7wAg3_7mefs0olN
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_07,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 spamscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112170099
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 17, 2021, at 8:43 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> 
> On Fri, Dec 17, 2021 at 8:42 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
>> 
>> On Thu, Dec 16, 2021 at 5:53 PM Song Liu <songliubraving@fb.com> wrote:
>>> 
>>> 
>>> 
>>>> On Dec 16, 2021, at 12:06 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>>>> 
>>>> On Tue, Dec 14, 2021 at 10:01 PM Song Liu <song@kernel.org> wrote:
>>>>> 
>>>>> Changes v1 => v2:
>>>>> 1. Use text_poke instead of writing through linear mapping. (Peter)
>>>>> 2. Avoid making changes to non-x86_64 code.
>>>>> 
>>>>> Most BPF programs are small, but they consume a page each. For systems
>>>>> with busy traffic and many BPF programs, this could also add significant
>>>>> pressure to instruction TLB.
>>>>> 
>>>>> This set tries to solve this problem with customized allocator that pack
>>>>> multiple programs into a huge page.
>>>>> 
>>>>> Patches 1-5 prepare the work. Patch 6 contains key logic of the allocator.
>>>>> Patch 7 uses this allocator in x86_64 jit compiler.
>>>>> 
>>>> 
>>>> There are test failures, please see [0]. But I was also wondering if
>>>> there could be an explicit selftest added to validate that all this
>>>> huge page machinery is actually activated and working as expected?
>>> 
>>> We can enable some debug option that dumps the page table. Then from the
>>> page table, we can confirm the programs are running on a huge page. This
>>> only works on x86_64 though. WDYT?
>>> 
>> 
>> I don't know what exactly is involved, so it's hard to say. Ideally
>> whatever we do doesn't complicate our CI setup. Can we use BPF tracing
>> magic to check this from inside the kernel somehow?
>> 
> 
> But I don't feel strongly about this, if it's hard to detect, it's
> fine to not have a specific test (especially that it's very
> architecture-specific)

It will be more or less architecture-specific, as we need somehow walk 
the page table (with debug option or with BPF iterator). I will try 
something. 

Thanks,
Song


> 
>>> Thanks,
>>> Song
>>> 
>>> 
>>>> 
>>>> [0] https://github.com/kernel-patches/bpf/runs/4530372387?check_suite_focus=true
>>>> 
>>>>> Song Liu (7):
>>>>> x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
>>>>> bpf: use bytes instead of pages for bpf_jit_[charge|uncharge]_modmem
>>>>> bpf: use size instead of pages in bpf_binary_header
>>>>> bpf: add a pointer of bpf_binary_header to bpf_prog
>>>>> x86/alternative: introduce text_poke_jit
>>>>> bpf: introduce bpf_prog_pack allocator
>>>>> bpf, x86_64: use bpf_prog_pack allocator
>>>>> 
>>>>> arch/x86/Kconfig                     |   1 +
>>>>> arch/x86/include/asm/text-patching.h |   1 +
>>>>> arch/x86/kernel/alternative.c        |  28 ++++
>>>>> arch/x86/net/bpf_jit_comp.c          |  93 ++++++++++--
>>>>> include/linux/bpf.h                  |   4 +-
>>>>> include/linux/filter.h               |  23 ++-
>>>>> kernel/bpf/core.c                    | 213 ++++++++++++++++++++++++---
>>>>> kernel/bpf/trampoline.c              |   6 +-
>>>>> 8 files changed, 328 insertions(+), 41 deletions(-)
>>>>> 
>>>>> --
>>>>> 2.30.2
>>> 

