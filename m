Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D8849884A
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245225AbiAXS1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:27:15 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10090 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241830AbiAXS1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:27:14 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 20OHVlgx020288;
        Mon, 24 Jan 2022 10:27:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=CxIrkjxoSyGhc655r2Z9QdGNwmNaQcBQvA5Q2bI8amU=;
 b=RHbFXdMhX9XnV6Uu/eGtOlAaFgXkCGoUuoj1p/4j8pmB4LZXhBrmgvo7yiFeo3Ae9Kci
 1rSlnmTzMtj30VJ2/RFs2WcXCDQ0iudKyV+TSHWCxr+cBNtEh8sZV1ZOF2awIEGoles6
 vFs5LN/q/HjsrTxk+E0RxzupeD1K3mErHtM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3dsk2q4uhh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 24 Jan 2022 10:27:13 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 24 Jan 2022 10:27:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EF3MH06tYTSl3V6pOreJHhlZ2QLMKcq259RAktAjjo3SgFvh1t8d2c+nXS5fbH+BnA3lMlba/7dsKoAL4i2n/WIieWzkZYXXWIrNSptnRviXMOqJHpDESVHJocCfnTzi2IZprwDyzi9uC+q2uOTrsIpqCAn1v2ECu1QRY4ThpnF1jV4hna8AQpyvD+4+OQlURgJibNaAh9pinVvVVF3oGEeLKxQ9rBg9cysGIzRzb52lTGqXzkhjfcvHqwOBkmgGsJh0M1ZWjkVbUFCovFDy2QKldPzYCay+noTg1zT8eVTgjowj7vZIDN0YbywR/TLwMguQogfUGVjpUvURMuck8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxIrkjxoSyGhc655r2Z9QdGNwmNaQcBQvA5Q2bI8amU=;
 b=DzJlm3qi3p5DGg0yw4yU2TgU7HGqC43UsAUlWIp06FQbmriyneRMQBFX3DdOJJn4aRmGqg9L0lKmksxVrR4NHCot0s+GyW5EXh7pwbXVt7yplqKv90NmtnGHvJYlIK8owG5jG8j4NrQclqzZrxmDct8ka+bFEzZc4dQW0Yt+F0Sy5JR7t6q0GtgCyBPUu/sZlA19AUApkKrkFTKIAsqlr4cgR0T77megaWTEZoTJH0/6iOPe60tF12nkyomDSNY/PRr1uGpsKHCrAWjKVdeaetjy54JWl0i/gBGPSzhwB6o8jMmaHDb1aW5sxix6VJrohvntS4wHohwcVTkPwGZTzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5236.namprd15.prod.outlook.com (2603:10b6:806:238::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Mon, 24 Jan
 2022 18:27:11 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e%7]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 18:27:11 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "Peter Zijlstra" <peterz@infradead.org>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
Thread-Topic: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
Thread-Index: AQHYDwA7v2eTErzZP02KrqTA2Ue2qKxuJqkAgAAH3QCAAAUSgIAABaKAgAAC8wCAAAUaAIAAC8WAgAF+/gCAAlH+gIAAY/cA
Date:   Mon, 24 Jan 2022 18:27:11 +0000
Message-ID: <2AAC8B8C-96F1-400F-AFA6-D4AF41EC82F4@fb.com>
References: <20220121194926.1970172-1-song@kernel.org>
 <20220121194926.1970172-7-song@kernel.org>
 <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com>
 <7393B983-3295-4B14-9528-B7BD04A82709@fb.com>
 <CAADnVQJLHXaU7tUJN=EM-Nt28xtu4vw9+Ox_uQsjh-E-4VNKoA@mail.gmail.com>
 <5407DA0E-C0F8-4DA9-B407-3DE657301BB2@fb.com>
 <CAADnVQLOpgGG9qfR4EAgzrdMrfSg9ftCY=9psR46GeBWP7aDvQ@mail.gmail.com>
 <5F4DEFB2-5F5A-4703-B5E5-BBCE05CD3651@fb.com>
 <CAADnVQLXGu_eF8VT6NmxKVxOHmfx7C=mWmmWF8KmsjFXg6P5OA@mail.gmail.com>
 <5E70BF53-E3FB-4F7A-B55D-199C54A8FDCA@fb.com>
 <adec88f9-b3e6-bfe4-c09e-54825a60f45d@linux.ibm.com>
In-Reply-To: <adec88f9-b3e6-bfe4-c09e-54825a60f45d@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 560658ae-6b67-4da9-9158-08d9df672327
x-ms-traffictypediagnostic: SA1PR15MB5236:EE_
x-microsoft-antispam-prvs: <SA1PR15MB52369D37956EFA8901EBA43DB35E9@SA1PR15MB5236.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UJW44RBGE2Hd0Hpx8PMxDcUmy2o+9Wd55P2f8TrEtGmUXMOBeVC9KsheS8T5WWA3Y94Oq0hifrxDya/JuNcegI0mZanVdXf/fdSJPCYcjyZLHNNIOhgfUlRym0Y9toQhLvdS0/k5xd4e9Gj9rzuqAdAceC3CtLSuYyezLJoMlVATlpRwbOnC1JPlbtn6szkMhUN3MYCYyDOrjl5K4PbwBr0C6VQ3N2zrPciXF73DZacsGk5pos4tv78GWZXI6Iie+ZrwTYvu+czpeDCN8qGvwle/CPTIkN9jyCMra1wwoKcPgLJenYUqJiZTcDi6JijrAqaWwgfMsCqjbtqFlLchbqmo8nMg3YdQWZbgd04Ntv/1o1XOQo6e29OsPFufEplqosSHrPP4+sPBej5orehjMzBe+6e/DZyjK565Y2vnuXz39yGrVijF180S8u2oWPjaynWjZTBkpy+5YsE8Mk2SI7L5MkVO8mBFtKytQFksFImYRs68NiK3pCTJr7iJ0Px9daFCRlvYLt3FudM8mukXVk3xc6vKr1GYFlK32yb1hBA4HSXZS8CLH4k/EK3D70XXEj/TFBvqHNs3doa0j3NViGvQzDyPMgV00bm4mdhpA5efwLS/h9UEccwMBAvyUtvhRzrAJu244b/c6oVltQPu80faKtOQvl0ocVfGRZjGzwb0wjKZsKwA3d4aFYtBMlYjDtW5mEIUBl+R1ytnkOV1WvrN0fRPvWqysrnH0FCHS+8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(8936002)(5660300002)(6486002)(6512007)(7416002)(53546011)(186003)(2906002)(38070700005)(33656002)(6916009)(36756003)(76116006)(316002)(91956017)(83380400001)(2616005)(86362001)(6506007)(66476007)(66946007)(66556008)(64756008)(66446008)(38100700002)(122000001)(54906003)(8676002)(508600001)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hKFSTr4i0BXHA7pzpVdon1ze1NX/KnG/DWqUfrRQQraB8sf8/efyNv0GRUGb?=
 =?us-ascii?Q?E0OHc/CITnwCb90CGZH/LzjEqZTBb7UaOADsH4ONoWy9pS34v8aVGIyWlGYj?=
 =?us-ascii?Q?uz8JYsKdWBFZPjp57GX85uL4pe7GEP8M1CDoi4UCEOpaNTt8xsKm7ICJ8eDA?=
 =?us-ascii?Q?RQKCABWy65HPHIPdfMGisIL/wTYzLKTeXUQYfLv2Tn8G9LbgtQ2ILs9j0bts?=
 =?us-ascii?Q?c+YiwQU/4R7vv95f38KFgaj++RSH2JbTisWeaE9LHx9s7wuvaEJHaKIkL3XI?=
 =?us-ascii?Q?iH/XwM5ALmZWOvGJ/x4GakbC0svintm71PT0X9hLvWSQVjpjofRVH9VWGGfg?=
 =?us-ascii?Q?B5rShvJBk/6QM5m/MagJu/LspUAf23/j1gHptZT4q5/Cr8bRADzsvqo7Z/ri?=
 =?us-ascii?Q?Se2Gn9JV56fjm47qEy5fd4uS53cjBDBq1rFEuD5m8ArZjUTatPptdJRnay00?=
 =?us-ascii?Q?Qgqzt686thsuVJboRdu5qHE60wGB6IM3KylXojFT2ICwnRYgWGG3B9KbT1FU?=
 =?us-ascii?Q?hXqbWZVcfVyPVP4HDnfeEKHbgeqc1m/F1DopOQNluvVi8OfWGr49GQp/zEH+?=
 =?us-ascii?Q?e6afGpY0N3vUv15AzCJzoDIuFsjaDcXxV3YsQUKSBzDnip9b3x6aRA4ODP4h?=
 =?us-ascii?Q?fazoBMEZdjHkraP/NhWoCf1WHiZQlMsEP+dENiCcCD0zE/EJRUi+JGydZaGq?=
 =?us-ascii?Q?djCX3eLsTbJr2+/c3QZvfN25MNNZoYm5Lu2JEUyPr++mjfj8jSbu2WgAHIWx?=
 =?us-ascii?Q?7GhuelRg4NLvvi9xn+EG7h9NujEFsgi9pUEQzSqG/LdhDN8ppFeO8yVibmSq?=
 =?us-ascii?Q?xyWMjy9E2kBeJp0/XKDoZCe4S/nFw0cB3MfpNf3TBeV5B8Em6qiwH7nPs5H0?=
 =?us-ascii?Q?NwUW4cgvqfQ5IoaVjAFGEhxmlFkY+g0Gx5xZ0ohFeDZ0QsJK+n2KShbwDsVO?=
 =?us-ascii?Q?2C6gmEGKGzXUEkFDakgJ3MvKYEpwRM1lmaJq3/hB381vTC71ND6I8yOK6LD0?=
 =?us-ascii?Q?zbd1nTVpoRik/srFPmUOp+fdFkwqXXMhEtQeK7zWGjfTj3m+DVG0I2ibuwzY?=
 =?us-ascii?Q?v8NDFEKkIZAPrud7/eW9WXkuys7cmnk5ynWhrbVWz7hKjb0pNdrXPgcmu38w?=
 =?us-ascii?Q?G1GB4rIHX1q8iRv5rTmrzNUI9xzZzsaID66qH3ILH0J+MM5of5YanxX/UWPk?=
 =?us-ascii?Q?76kicsaI96m8eNpIcNklfEd8UeixH7jzwM4tEOxOkr7Vop/Lmy6tJL2Lb8mV?=
 =?us-ascii?Q?Nw35QxjIca/TVo7gm5adNXUa2usU3P9+cmlO90vOwr58yKy8RV/uijypN9z5?=
 =?us-ascii?Q?W9OzF83+/QPjUC0xjwqWW2yR5pw9dELfQ6OJBiBvMDSRevPk2n0vJZN5FAVB?=
 =?us-ascii?Q?abFi0X2NmxFhlXkYG9hz7AJbSynLZHfkelgmxmFQqhlIiFre4EQRr6w2agF2?=
 =?us-ascii?Q?yCqXgN02+H4Lai80bnF3W/CefIqxSNwbryAjFcLlLfufisjq6t5pSXyPhF2/?=
 =?us-ascii?Q?QbB63+NAWfunnEB0+U+zNSaeEtGDeURo/h6LlgbbRsvUpMyDmpx4YEQb+Syc?=
 =?us-ascii?Q?VkbjuaF6iePd5GUNfXElKy/qal9gCZdtmiCZDvT6Jnfzn67qFVv/NZ7Nd8fJ?=
 =?us-ascii?Q?fBvhwjxpPXZd8Cwv9e1PjKy6zVEyc302ipXByu7WOdCI6oTmD57/gfYhJ+yN?=
 =?us-ascii?Q?rpJqCw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6D0819B5629DEA49A5E0700C1AF0EF6A@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 560658ae-6b67-4da9-9158-08d9df672327
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2022 18:27:11.2963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nxsolLawuEt8pA0Lipja4PU0HJLtNdZwSYSy35fCqtVKYysQoAr5/o7N+Qw2uEc7ON5sk3XuaqBAtBdmqwdYjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5236
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: BKyG5BeRhLr6mO-6hSI7LfOGUb2O-aSj
X-Proofpoint-ORIG-GUID: BKyG5BeRhLr6mO-6hSI7LfOGUb2O-aSj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_09,2022-01-24_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201240121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 24, 2022, at 4:29 AM, Ilya Leoshkevich <iii@linux.ibm.com> wrote:
> 
> 
> 
> On 1/23/22 02:03, Song Liu wrote:
>>> On Jan 21, 2022, at 6:12 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>>> 
>>> On Fri, Jan 21, 2022 at 5:30 PM Song Liu <songliubraving@fb.com> wrote:
>>>> 
>>>> 
>>>> 
>>>>> On Jan 21, 2022, at 5:12 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>>>>> 
>>>>> On Fri, Jan 21, 2022 at 5:01 PM Song Liu <songliubraving@fb.com> wrote:
>>>>>> 
>>>>>> In this way, we need to allocate rw_image here, and free it in
>>>>>> bpf_jit_comp.c. This feels a little weird to me, but I guess that
>>>>>> is still the cleanest solution for now.
>>>>> 
>>>>> You mean inside bpf_jit_binary_alloc?
>>>>> That won't be arch independent.
>>>>> It needs to be split into generic piece that stays in core.c
>>>>> and callbacks like bpf_jit_fill_hole_t
>>>>> or into multiple helpers with prep in-between.
>>>>> Don't worry if all archs need to be touched.
>>>> 
>>>> How about we introduce callback bpf_jit_set_header_size_t? Then we
>>>> can split x86's jit_fill_hole() into two functions, one to fill the
>>>> hole, the other to set size. The rest of the logic gonna stay the same.
>>>> 
>>>> Archs that do not use bpf_prog_pack won't need bpf_jit_set_header_size_t.
>>> 
>>> That's not any better.
>>> 
>>> Currently the choice of bpf_jit_binary_alloc_pack vs bpf_jit_binary_alloc
>>> leaks into arch bits and bpf_prog_pack_max_size() doesn't
>>> really make it generic.
>>> 
>>> Ideally all archs continue to use bpf_jit_binary_alloc()
>>> and magic happens in a generic code.
>>> If not then please remove bpf_prog_pack_max_size(),
>>> since it doesn't provide much value and pick
>>> bpf_jit_binary_alloc_pack() signature to fit x86 jit better.
>>> It wouldn't need bpf_jit_fill_hole_t callback at all.
>>> Please think it through so we don't need to redesign it
>>> when another arch will decide to use huge pages for bpf progs.
>>> 
>>> cc-ing Ilya for ideas on how that would fit s390.
>> I guess we have a few different questions here:
>> 1. Can we use bpf_jit_binary_alloc() for both regular page and shared
>> huge page?
>> I think the answer is no, as bpf_jit_binary_alloc() allocates a rw
>> buffer, and arch calls bpf_jit_binary_lock_ro after JITing. The new
>> allocator will return a slice of a shared huge page, which is locked
>> RO before JITing.
>> 2. The problem with bpf_prog_pack_max_size() limitation.
>> I think this is the worst part of current version of bpf_prog_pack,
>> but it shouldn't be too hard to fix. I will remove this limitation
>> in the next version.
>> 3. How to set proper header->size?
>> I guess we can introduce something similar to bpf_arch_text_poke()
>> for this?
>> My proposal for the next version is:
>> 1. No changes to archs that do not use huge page, just keep using
>>    bpf_jit_binary_alloc.
>> 2. For x86_64 (and other arch that would support bpf program on huge
>>    pages):
>>    2.1 arch/bpf_jit_comp calls bpf_jit_binary_alloc_pack() to allocate
>>        an RO bpf_binary_header;
>>    2.2 arch allocates a temporary buffer for JIT. Once JIT is done,
>>        use text_poke_copy to copy the code to the RO bpf_binary_header.
> 
> Are arches expected to allocate rw buffers in different ways? If not,
> I would consider putting this into the common code as well. Then
> arch-specific code would do something like
> 
>  header = bpf_jit_binary_alloc_pack(size, &prg_buf, &prg_addr, ...);
>  ...
>  /*
>   * Generate code into prg_buf, the code should assume that its first
>   * byte is located at prg_addr.
>   */
>  ...
>  bpf_jit_binary_finalize_pack(header, prg_buf);
> 
> where bpf_jit_binary_finalize_pack() would copy prg_buf to header and
> free it.

I think this should work. 

We will need an API like: bpf_arch_text_copy, which uses text_poke_copy() 
for x86_64 and s390_kernel_write() for x390. We will use bpf_arch_text_copy 
to 
  1) write header->size;
  2) do finally copy in bpf_jit_binary_finalize_pack().

The syntax of bpf_arch_text_copy is quite different to existing 
bpf_arch_text_poke, so I guess a new API is better. 

> 
> If this won't work, I also don't see any big problems in the scheme
> that you propose (especially if bpf_prog_pack_max_size() limitation is
> gone).
> 
> [...]
> 
> Btw, are there any existing benchmarks that I can use to check whether
> this is worth enabling on s390?

Unfortunately, we don't have a benchmark to share. Most of our benchmarks
are shadow tests that cannot run out of production environment. We have 
issues with iTLB misses for most of our big services. A typical system 
may see hundreds of iTLB misses per million instruction. Some sched_cls
programs are often the top triggers of these iTLB misses. 

Thanks,
Song
