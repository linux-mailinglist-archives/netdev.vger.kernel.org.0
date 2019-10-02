Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F8FC8E50
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfJBQZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:25:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50396 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727614AbfJBQZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:25:53 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x92G8j7W000862;
        Wed, 2 Oct 2019 09:25:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=O2vwMC4fMjirljoayZnPwwOlfug+exWK/ST8eM6Wg6Y=;
 b=h8KWbnq9llF20JBeB7g+gPlBi3QFVm5C01PUYK7/8UEqQlLNRZyzd50urPDJJXPuz2W3
 DGVF1qUP9HknQAFPUu7wNUE+AOTKzdR54kfhnTk9VTA2M47fG7aeLxLBx1DH7x8yR2jz
 Bt9A203f8tyU47ZqvbrF5MdjqWXdUT/LjI4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vcddnmkqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 02 Oct 2019 09:25:40 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 2 Oct 2019 09:25:38 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 2 Oct 2019 09:25:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLuQvX9f5fZEEe7OtD6Su+TN+5dG/Ag5J07mXD+iYBG/OnaKs4nPQWKgys1vRAKJolSZ9N1x3IJNqtFFhxrqOdjfI9ADyzide6QebhCiClkhoaoRujmn+T+y1c5OsitVe58ciTeRTPtyRsWIsd+/CTUZWGawh+PUXiPDaWiXqQvRu+h/hlNkwU+4XolhWK1o0zWKIiGE9pEa84Zz2hL25krZaBAvb22WqZmubyGO+FQTEYoinVtZ+hm/JmsQg1LmkaYzFUFKdXDqxvz3avYcBWE7fL91s8PVlePZ9AVyNDuHpwB9lVEhcAIYKsM4gbOlAsQnFJ7iQY1oG8Xnx7W62w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2vwMC4fMjirljoayZnPwwOlfug+exWK/ST8eM6Wg6Y=;
 b=PRnY0rFxptJgUq7eUjxapci98ZZGfnFHj7L0jRBZQnhnvomEyUzvI3fhy2W0QUdU5V5r35CEFf2wu1vCw9z92wnPoLUTEAC3K8t8KiA4wsPaIw7HntSD/xj9cMjF+OepcSEKyWhNEsk90xfXF+6xpUnTak+U8lEArBapfzfFpMl0f3aC9Yyny5W2knRz5zsALhfQsLRaPXQT+7/3yJbG/HbpI3Yd47YQ5OVBERg/ij98GUYhIL5apk51yFI794njB/9EdkbNB5agLy/ahtpFqcZHfXls+aJacFJl6FjylrlLogAlJ1yRdom6rYGmKzVW/S/rbopHzWVJz5/l2wkTWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2vwMC4fMjirljoayZnPwwOlfug+exWK/ST8eM6Wg6Y=;
 b=eAUWQxvKhUMRzDRHQ1YAoHAXlj5DwTBFk8pru2U8/zaDD1axgEEp7Umfhwr4bxG5M5QvpHZ4XZQoRZiPwmoXSMnvSWJLs8/rI2JN4Tpd3xC8Tbaz92Hc2oGGPa07uzUQpaF0P8KVqRY11hRhzy6g47Km8zBZuTo3dLGFwHj0TNY=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1294.namprd15.prod.outlook.com (10.175.3.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.18; Wed, 2 Oct 2019 16:25:35 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.022; Wed, 2 Oct 2019
 16:25:35 +0000
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
Thread-Index: AQHVd8E8o0MCCq60iESLB2q7s/R4LadGStmAgAADGwCAAAXHgIAAD8CAgAARUwCAAEDGAIAA1vEA
Date:   Wed, 2 Oct 2019 16:25:35 +0000
Message-ID: <1D3ADCBA-0B4E-4833-8F38-F74C4FF646C6@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-5-andriin@fb.com>
 <346DCE18-FA64-40CA-86BD-C095935AC089@fb.com>
 <CAEf4BzYyh8TTtw1F+F0zw9ksCqGKFogfAgwK+_CEZ25ASoarVQ@mail.gmail.com>
 <7D24AAB3-32DF-4806-808A-B84E461F6BCD@fb.com>
 <CAEf4BzYodrr1u14XQM04TU57SH3ViSbqh76Lh2d3QtksvS24hA@mail.gmail.com>
 <7B064E41-189A-427A-82A7-C8BD5B5421A3@fb.com>
 <CAEf4BzbKjSapFmffvsPfX4toaTA=_J4q9WfFtfy_xOHSthTWLQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbKjSapFmffvsPfX4toaTA=_J4q9WfFtfy_xOHSthTWLQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::2338]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b28169db-888b-4b00-04a0-08d747552781
x-ms-traffictypediagnostic: MWHPR15MB1294:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1294DF33375C384379DC5ACDB39C0@MWHPR15MB1294.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(346002)(396003)(136003)(39860400002)(189003)(199004)(316002)(54906003)(186003)(446003)(2906002)(6486002)(81156014)(81166006)(50226002)(476003)(11346002)(8676002)(486006)(8936002)(46003)(6506007)(256004)(14444005)(229853002)(102836004)(86362001)(53546011)(25786009)(6436002)(76176011)(71200400001)(71190400001)(33656002)(4326008)(76116006)(7736002)(6512007)(6916009)(2616005)(14454004)(99286004)(478600001)(6246003)(6116002)(5660300002)(66446008)(36756003)(305945005)(66946007)(64756008)(66556008)(66476007)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1294;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IYihu2hoA4DZtetHtFpda34QInVaOqNStvEfUwO12KsxBfOZcnkOPMjt+zsPhvYRyRXhruXSjTM/C47WMmvBBnrVFi4xStHvFlfymMu/6XmaNmcyZr8yu9y2LoBwhy19/7s17p7I3nzpRhVf0p3wMlGOQg90+gwFSyx0ypaThcZl3BWPfLnqs4J8IpRDk+dLHRYO2Z+T8gnEyzTZQ1FJLQ5wbyriZMV3KnRrqabQaCNw3c2+I2UHhrTQXa7CZYRM4BH2Rw78l436tSYGfwbm3e5kpmiFVnPyrDOVrGq+ArCGftLtTX057PGZmy9mmVharZZEWy0dh375h/yuIJpaU3R6DLxNRqx84T3I7r6qQ1UoW/vViIrNdkyEddx1RB2x1pXOG1ov5nHfTfjAHqjpERXFnwv/eKD1k90n8BZwEqg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2612F6897FC3BE4383BC82C3C8F93118@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b28169db-888b-4b00-04a0-08d747552781
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2019 16:25:35.4554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xbzo92CtTR9Ro57Jmjz1eZqdrMYmEEO8A37xoU6OdzoMpU1ORDBaWd/lLTUrKwxIKJtd+tac4/omkLdPsTDKxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1294
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-02_07:2019-10-01,2019-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910020142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 1, 2019, at 8:36 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>=20
> On Tue, Oct 1, 2019 at 4:44 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Oct 1, 2019, at 3:42 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>>>=20
>>> On Tue, Oct 1, 2019 at 2:46 PM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Oct 1, 2019, at 2:25 PM, Andrii Nakryiko <andrii.nakryiko@gmail.co=
m> wrote:
>>>>>=20
>>>>> On Tue, Oct 1, 2019 at 2:14 PM Song Liu <songliubraving@fb.com> wrote=
:
>>>>>>=20
>>>>>>=20
>>>>>>> On Sep 30, 2019, at 11:58 AM, Andrii Nakryiko <andriin@fb.com> wrot=
e:
>>>>>>>=20
>>>>>>> Add few macros simplifying BCC-like multi-level probe reads, while =
also
>>>>>>> emitting CO-RE relocations for each read.
>>>>>>>=20
>>>>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>>>>>> ---
>>>>>>> tools/lib/bpf/bpf_helpers.h | 151 +++++++++++++++++++++++++++++++++=
++-
>>>>>>> 1 file changed, 147 insertions(+), 4 deletions(-)
>>>>>>>=20
>>>>>>> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helper=
s.h
>>>>>>> index a1d9b97b8e15..51e7b11d53e8 100644
>>>>>>> --- a/tools/lib/bpf/bpf_helpers.h
>>>>>>> +++ b/tools/lib/bpf/bpf_helpers.h
>>>>>>> @@ -19,6 +19,10 @@
>>>>>>> */
>>>>>>> #define SEC(NAME) __attribute__((section(NAME), used))
>>>>>>>=20
>>>>>>> +#ifndef __always_inline
>>>>>>> +#define __always_inline __attribute__((always_inline))
>>>>>>> +#endif
>>>>>>> +
>>>>>>> /* helper functions called from eBPF programs written in C */
>>>>>>> static void *(*bpf_map_lookup_elem)(void *map, const void *key) =3D
>>>>>>>    (void *) BPF_FUNC_map_lookup_elem;
>>>>>>> @@ -505,7 +509,7 @@ struct pt_regs;
>>>>>>> #endif
>>>>>>>=20
>>>>>>> /*
>>>>>>> - * BPF_CORE_READ abstracts away bpf_probe_read() call and captures=
 offset
>>>>>>> + * bpf_core_read() abstracts away bpf_probe_read() call and captur=
es field
>>>>>>> * relocation for source address using __builtin_preserve_access_ind=
ex()
>>>>>>> * built-in, provided by Clang.
>>>>>>> *
>>>>>>> @@ -520,8 +524,147 @@ struct pt_regs;
>>>>>>> * actual field offset, based on target kernel BTF type that matches=
 original
>>>>>>> * (local) BTF, used to record relocation.
>>>>>>> */
>>>>>>> -#define BPF_CORE_READ(dst, src)                                   =
           \
>>>>>>> -     bpf_probe_read((dst), sizeof(*(src)),                        =
   \
>>>>>>> -                    __builtin_preserve_access_index(src))
>>>>>>> +#define bpf_core_read(dst, sz, src)                               =
       \
>>>>>>> +     bpf_probe_read(dst, sz,                                      =
       \
>>>>>>> +                    (const void *)__builtin_preserve_access_index(=
src))
>>>>>>> +
>>>>>>> +/*
>>>>>>> + * bpf_core_read_str() is a thin wrapper around bpf_probe_read_str=
()
>>>>>>> + * additionally emitting BPF CO-RE field relocation for specified =
source
>>>>>>> + * argument.
>>>>>>> + */
>>>>>>> +#define bpf_core_read_str(dst, sz, src)                           =
               \
>>>>>>> +     bpf_probe_read_str(dst, sz,                                  =
       \
>>>>>>> +                        (const void *)__builtin_preserve_access_in=
dex(src))
>>>>>>> +
>>>>>>> +#define ___concat(a, b) a ## b
>>>>>>> +#define ___apply(fn, n) ___concat(fn, n)
>>>>>>> +#define ___nth(_1, _2, _3, _4, _5, _6, _7, _8, _9, _10, __11, N, .=
..) N
>>>>>>=20
>>>>>> We are adding many marcos with simple names: ___apply(), ___nth. So =
I worry
>>>>>> they may conflict with macro definitions from other libraries. Shall=
 we hide
>>>>>> them in .c files or prefix/postfix them with _libbpf or something?
>>>>>=20
>>>>> Keep in mind, this is the header that's included from BPF code.
>>>>>=20
>>>>> They are prefixed with three underscores, I was hoping it's good
>>>>> enough to avoid accidental conflicts. It's unlikely someone will have
>>>>> macros with the same names **in BPF-side code**.
>>>>=20
>>>> BPF side code would include kernel headers. So there are many headers
>>>> to conflict with. And we won't know until somebody want to trace certa=
in
>>>> kernel structure.
>>>=20
>>> We have all the kernel sources at our disposal, there's no need to
>>> guess :) There is no instance of ___apply, ___concat, ___nth,
>>> ___arrow, ___last, ___nolast, or ___type, not even speaking about
>>> other more specific names. There are currently two instances of
>>> "____last_____" used in a string. And I'm certainly not afraid that
>>> user code can use triple-underscored identifier with exact those names
>>> and complain about bpf_helpers.h :)
>>=20
>> I worry more about _future_ conflicts, that someone may add ___apply to
>=20
> You can say the same about pretty much any name that user might use,
> that's just the fact of life with C language without namespaces. I
> don't think that justifies usage of obscure names.
>=20
> Look at SEC macro, for instance. It's also an enum value in
> drivers/sbus/char/oradax.c, but it might some day end up in one of
> driver's headers. This is probably not a reason to rename it, though.
>=20
>> some kernel header file and break some BPF programs. Since these BPF
>> programs are not in-tree, it is very difficult to test them properly.
>> We have had name conflicts from other libraries, so I hope we don't crea=
te
>> more ourselves.
>=20
> Let's agree to come back to this problem when and if we ever encounter
> it. All those ___xxx macro are internal and users shouldn't rely on
> them, which means if we ever get a real conflict, we'll be able to
> rename them to avoid the conflict.

Well, if this really happens, we will have to fix them.=20

I won't block this set just for this. If you insist, let's keep these=20
as-is.=20

Thanks,
Song

