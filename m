Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9074CC448F
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 01:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbfJAXoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 19:44:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38328 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbfJAXon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 19:44:43 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x91Nejmx021510;
        Tue, 1 Oct 2019 16:44:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=EmiGECRlZ5S6469e8D5ZHaqHckyImkaijiQYVjQTcdo=;
 b=ptto0Ten/SuQHNb8A2TRP0TjdNRdp2Em9qCFGUaI6GrwrsQh8Kiqg+lkEcmMowfPBjrY
 RxU5QuTrigVvrPWJosZxiaqA2tR5mqa6BwBb82davQ4rfBf+gC04s+s7tJ/7Val/5wQ1
 r1g4EO73IGOebpv2XisT+tv7RV28KBbcdlM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vc8tatr87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 01 Oct 2019 16:44:29 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 1 Oct 2019 16:44:28 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 1 Oct 2019 16:44:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ictyN6eoZNbLS0/SAItC7ZC1FvrYr6JlNNXgRx2JodAYG6S988ehT3sI9f0UzoKqwF5Mw5LC8KXFoatg302uc3YoCY9PvXfFj3husvzE9OMv1/KjM6tN9/j0wkPrchK29ijYV1L9uckE5L2lmKsRnxhc3ZbgBl0Xb2VWI9ZdMwP+TtMK7jOz6rSL5gNPF5VWwvmBFRFVbllEEnKyUUEtJpXMI0ntsQKAKoIWr4BTOB+dVCaGkieL21EGXq2NX1Hbn7001Go65Nz7zh8zrYdpkyBmfafcC1998JzCwAQ+lGuJ01f/P2qsQvKT9zXG/hNUUEz9dEN70x2JJ7+IXZt0YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmiGECRlZ5S6469e8D5ZHaqHckyImkaijiQYVjQTcdo=;
 b=ayLlY3QsktdW66hvdNf0p7oH+odOkeJZEVOhlNnHP9ABSSi02VjIYkyJKc/ZpUS1YEr7k7ugTjcVRIN4y0D6zmF5G4ZmmdKSR8RIwGSc2+utUbIuHcBRG+La2HvddcXBS9uRnMjLd8nJC2QlDc/t0iQNFJRhFPOUAapGiqwKFR8DPCySb1YWMbe4UdVTyooxdnpEL+hdDhEn/WJ2xSk/PyPD2l+5wyQi9qP0xlgtbYuT9UjIUJs8Mew2rFC1KLOYmPhw3zrnooNuHhRMulpKatUS5y6ian3NrWM0cvtf7WqPWT3gN/I7FWQGA2Lt0yy/BG+7XgRml9QpaAAVQGiyAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmiGECRlZ5S6469e8D5ZHaqHckyImkaijiQYVjQTcdo=;
 b=K66jiuBUxBJgZiISvZHe/AwBxUfNsWbADNS01Rq6EH9tQXYii6eqGxPv4MF/QNw2cyqvmMkKeg6Gu2foxCnpSaCPmMxdyhhyyUyj+GEIZlzB2aEj/khCvijzGRvZHLmiO+F1gezZBPwdYeaDM+PDSW3wi7+IxnytPf7K6wu0Fg0=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1152.namprd15.prod.outlook.com (10.175.3.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Tue, 1 Oct 2019 23:44:27 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.022; Tue, 1 Oct 2019
 23:44:27 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 4/6] libbpf: add BPF_CORE_READ/BPF_CORE_READ_INTO
 helpers
Thread-Topic: [PATCH bpf-next 4/6] libbpf: add
 BPF_CORE_READ/BPF_CORE_READ_INTO helpers
Thread-Index: AQHVd8E8o0MCCq60iESLB2q7s/R4LadGStmAgAADGwCAAAXHgIAAD8CAgAARUwA=
Date:   Tue, 1 Oct 2019 23:44:27 +0000
Message-ID: <7B064E41-189A-427A-82A7-C8BD5B5421A3@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-5-andriin@fb.com>
 <346DCE18-FA64-40CA-86BD-C095935AC089@fb.com>
 <CAEf4BzYyh8TTtw1F+F0zw9ksCqGKFogfAgwK+_CEZ25ASoarVQ@mail.gmail.com>
 <7D24AAB3-32DF-4806-808A-B84E461F6BCD@fb.com>
 <CAEf4BzYodrr1u14XQM04TU57SH3ViSbqh76Lh2d3QtksvS24hA@mail.gmail.com>
In-Reply-To: <CAEf4BzYodrr1u14XQM04TU57SH3ViSbqh76Lh2d3QtksvS24hA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:7bc9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53c29582-d392-4e16-7e3a-08d746c94c12
x-ms-traffictypediagnostic: MWHPR15MB1152:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB11522E0A120395447701D123B39D0@MWHPR15MB1152.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39860400002)(366004)(346002)(376002)(199004)(189003)(229853002)(486006)(86362001)(6486002)(8676002)(4326008)(99286004)(81166006)(81156014)(25786009)(8936002)(66476007)(66556008)(64756008)(66446008)(71200400001)(6436002)(71190400001)(2616005)(476003)(6246003)(54906003)(46003)(102836004)(5660300002)(186003)(478600001)(11346002)(53546011)(7736002)(6116002)(316002)(2906002)(76176011)(6916009)(305945005)(446003)(14444005)(14454004)(256004)(6512007)(33656002)(50226002)(76116006)(66946007)(6506007)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1152;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r2tAAPryX7+0WFoCVeThI6dTSN/aS1XYf/U7FXSiSVmDzGyGeqokjZ/TLT4VaQ+t0EP8TZZAFbvqSVuvAcZRn5dPxZ9tbJ7gbZJTwWuQP3SKRTjuiXW6O1vgrQkNAqiBqkvOGWIWl0UKyqaGlEOslaVM76zebiWWoWehJhZRC6WdjWDtXcdsQYH23FIZhVme4zP2zAaxq/N30Q4zD2f2ZAyjghgBiDHmSJZ8q+Bjp03KfyAOH69UevFcEgymGZyAHiPyOK53IyOg5JT3s6jjKwwhPkIH/ORe60zRC/DbSnQotw8ewgwkS+CVBIoTO/Rh5DKy8y1GJfSpQ6IikaQWnJv4ACE/FNHNxswlZNU0I03gWFmwRWhPVFldIR/JQqoLAcQ3A1Nqf0kUDpUH37W+9k+0MOLeWDkqlT3euiUFw6Q=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0491D60F7315A44D9668DE452EDBFC4B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c29582-d392-4e16-7e3a-08d746c94c12
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2019 23:44:27.3426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sj9oGBMICHpNjxgvkMDTJb88fyh+YJ/YOuXkYRHJfMDrUv/U7TS2D0ZbD6tW75Y1AokTTvzJsr3T99S54Yauhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1152
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-01_10:2019-10-01,2019-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910010202
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 1, 2019, at 3:42 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>=20
> On Tue, Oct 1, 2019 at 2:46 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Oct 1, 2019, at 2:25 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>>>=20
>>> On Tue, Oct 1, 2019 at 2:14 PM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>>=20
>>>>> On Sep 30, 2019, at 11:58 AM, Andrii Nakryiko <andriin@fb.com> wrote:
>>>>>=20
>>>>> Add few macros simplifying BCC-like multi-level probe reads, while al=
so
>>>>> emitting CO-RE relocations for each read.
>>>>>=20
>>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>>>> ---
>>>>> tools/lib/bpf/bpf_helpers.h | 151 +++++++++++++++++++++++++++++++++++=
-
>>>>> 1 file changed, 147 insertions(+), 4 deletions(-)
>>>>>=20
>>>>> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.=
h
>>>>> index a1d9b97b8e15..51e7b11d53e8 100644
>>>>> --- a/tools/lib/bpf/bpf_helpers.h
>>>>> +++ b/tools/lib/bpf/bpf_helpers.h
>>>>> @@ -19,6 +19,10 @@
>>>>> */
>>>>> #define SEC(NAME) __attribute__((section(NAME), used))
>>>>>=20
>>>>> +#ifndef __always_inline
>>>>> +#define __always_inline __attribute__((always_inline))
>>>>> +#endif
>>>>> +
>>>>> /* helper functions called from eBPF programs written in C */
>>>>> static void *(*bpf_map_lookup_elem)(void *map, const void *key) =3D
>>>>>     (void *) BPF_FUNC_map_lookup_elem;
>>>>> @@ -505,7 +509,7 @@ struct pt_regs;
>>>>> #endif
>>>>>=20
>>>>> /*
>>>>> - * BPF_CORE_READ abstracts away bpf_probe_read() call and captures o=
ffset
>>>>> + * bpf_core_read() abstracts away bpf_probe_read() call and captures=
 field
>>>>> * relocation for source address using __builtin_preserve_access_index=
()
>>>>> * built-in, provided by Clang.
>>>>> *
>>>>> @@ -520,8 +524,147 @@ struct pt_regs;
>>>>> * actual field offset, based on target kernel BTF type that matches o=
riginal
>>>>> * (local) BTF, used to record relocation.
>>>>> */
>>>>> -#define BPF_CORE_READ(dst, src)                                     =
         \
>>>>> -     bpf_probe_read((dst), sizeof(*(src)),                          =
 \
>>>>> -                    __builtin_preserve_access_index(src))
>>>>> +#define bpf_core_read(dst, sz, src)                                 =
     \
>>>>> +     bpf_probe_read(dst, sz,                                        =
     \
>>>>> +                    (const void *)__builtin_preserve_access_index(sr=
c))
>>>>> +
>>>>> +/*
>>>>> + * bpf_core_read_str() is a thin wrapper around bpf_probe_read_str()
>>>>> + * additionally emitting BPF CO-RE field relocation for specified so=
urce
>>>>> + * argument.
>>>>> + */
>>>>> +#define bpf_core_read_str(dst, sz, src)                             =
             \
>>>>> +     bpf_probe_read_str(dst, sz,                                    =
     \
>>>>> +                        (const void *)__builtin_preserve_access_inde=
x(src))
>>>>> +
>>>>> +#define ___concat(a, b) a ## b
>>>>> +#define ___apply(fn, n) ___concat(fn, n)
>>>>> +#define ___nth(_1, _2, _3, _4, _5, _6, _7, _8, _9, _10, __11, N, ...=
) N
>>>>=20
>>>> We are adding many marcos with simple names: ___apply(), ___nth. So I =
worry
>>>> they may conflict with macro definitions from other libraries. Shall w=
e hide
>>>> them in .c files or prefix/postfix them with _libbpf or something?
>>>=20
>>> Keep in mind, this is the header that's included from BPF code.
>>>=20
>>> They are prefixed with three underscores, I was hoping it's good
>>> enough to avoid accidental conflicts. It's unlikely someone will have
>>> macros with the same names **in BPF-side code**.
>>=20
>> BPF side code would include kernel headers. So there are many headers
>> to conflict with. And we won't know until somebody want to trace certain
>> kernel structure.
>=20
> We have all the kernel sources at our disposal, there's no need to
> guess :) There is no instance of ___apply, ___concat, ___nth,
> ___arrow, ___last, ___nolast, or ___type, not even speaking about
> other more specific names. There are currently two instances of
> "____last_____" used in a string. And I'm certainly not afraid that
> user code can use triple-underscored identifier with exact those names
> and complain about bpf_helpers.h :)

I worry more about _future_ conflicts, that someone may add ___apply to=20
some kernel header file and break some BPF programs. Since these BPF
programs are not in-tree, it is very difficult to test them properly.
We have had name conflicts from other libraries, so I hope we don't create=
=20
more ourselves.=20

Thanks,
Song=
