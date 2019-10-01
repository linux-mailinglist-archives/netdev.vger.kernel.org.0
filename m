Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 302FBC42E5
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfJAVqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:46:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24970 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726681AbfJAVqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:46:22 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x91LhrQ7014019;
        Tue, 1 Oct 2019 14:46:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=C5bhibzX+sh7Mq9pIAkay3pBHvav1OWuOdbWn4aJNio=;
 b=o2S10mQ1ZcmenUFdc6jHA1RUSr8HFSwAs44qvelDxGomOkEDzJIhXVu2H1hvN1Ko8fJw
 5ZLcij9KnlosR+zSxIbznRZsPvGvFa7EDyadrwdZc6r/wUbuy4p2URahGTQvtXBQ7qX5
 7LKrWgr4w/rwmjC3WxvkTTUrfGwvXKI9XsA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vcc6rguuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 01 Oct 2019 14:46:09 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 1 Oct 2019 14:46:08 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 1 Oct 2019 14:46:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJZ6zwA7dH/UyW6MNegGr57mkGsXhGwkJAy5g5+JBVlvqHE5mczR3D/VH/mg/IUsLZvp75qdJnJmpsYYmlVOCyudAc7JZG9gzu1V0c0zSpYsX18UtZfw/CHtqVAsyIucjgFh9MQpPfxAm070vq4uBCN02GxFQHHo/n8HtkJ0kwB9r+wCK95uyCDKh/9S6WNLTjZabX52rJ/9S6/ocZGGWpEhqTf2AFceCHpB74z9M4An9Huu6v9cnwQGiKXA2VVRpyQ23MnuQUyxWbznQsvUQ77IDcgi5omuSkxfXRvqKg4BwRGcA4CbE6MCBVE4LJiWfS0WfRSaLwda151FoL9w1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5bhibzX+sh7Mq9pIAkay3pBHvav1OWuOdbWn4aJNio=;
 b=nNBM7DYqADuEZMdx6oW6gpsB/aK8Ig5VKD92LvIPnacK0hjEPj1IKd8T87ea6+kyu1zIcE565UEebEmzb7OoIhi8t7pRDq830qXTVaPouY2uYWjj5U1oS8qLZ1bJLfsAU+wnG5CN8XfnN5JrPOtwv1wiaD3N19Btnjq2HJJupJzh8B6VJ7dEo2SLu/AX0tKPo9vwUHpffNUaoSZVjJLQEknbtkFbAiugyI9zHgyAaCH/aLFrZGTvYPp5sF937QGTGIbEcKAByWmwM+9lNrpVvha+vtqe/JJhNw3zqCCZFuPqpse8h2nykCQ7RRvSjfTMMY2c8ts7VZD3A9lSeVEAxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5bhibzX+sh7Mq9pIAkay3pBHvav1OWuOdbWn4aJNio=;
 b=eegRSb+quC/jmNPGmPtuWco1vVK4f5D8Dm06pO/Cpk+Lf/MUDAy3YWd8XV3N+T11XDTCPhQfg7QS8h0pc+jspq55l7fzX+WwUJqwht/w91TnryEE72g8l0Q2XeliXc/376dvpKwnyZlgWRbYaIANu97iCmQnEvaldAGvfUImuvo=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1885.namprd15.prod.outlook.com (10.174.254.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Tue, 1 Oct 2019 21:46:05 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.022; Tue, 1 Oct 2019
 21:46:04 +0000
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
Thread-Index: AQHVd8E8o0MCCq60iESLB2q7s/R4LadGStmAgAADGwCAAAXHgA==
Date:   Tue, 1 Oct 2019 21:46:03 +0000
Message-ID: <7D24AAB3-32DF-4806-808A-B84E461F6BCD@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-5-andriin@fb.com>
 <346DCE18-FA64-40CA-86BD-C095935AC089@fb.com>
 <CAEf4BzYyh8TTtw1F+F0zw9ksCqGKFogfAgwK+_CEZ25ASoarVQ@mail.gmail.com>
In-Reply-To: <CAEf4BzYyh8TTtw1F+F0zw9ksCqGKFogfAgwK+_CEZ25ASoarVQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:7bc9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6b52e7f-b4a7-416d-66c9-08d746b8c226
x-ms-traffictypediagnostic: MWHPR15MB1885:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1885FDA1158ED805FBEFB780B39D0@MWHPR15MB1885.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(346002)(376002)(396003)(199004)(189003)(229853002)(8676002)(71190400001)(6486002)(86362001)(14444005)(8936002)(6916009)(6512007)(256004)(99286004)(71200400001)(50226002)(81166006)(81156014)(6116002)(446003)(186003)(46003)(76176011)(11346002)(64756008)(66446008)(91956017)(66476007)(53546011)(305945005)(7736002)(6246003)(66946007)(36756003)(5660300002)(33656002)(2906002)(4326008)(478600001)(54906003)(316002)(76116006)(25786009)(6436002)(14454004)(486006)(2616005)(476003)(102836004)(66556008)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1885;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9m9/4tj+vZpr21Tc/XwbGnX4wsFjhAoW94J/auWnxJC+3BoQGHQhaIi4mfAWq+hcVx1bB1TOoOQigkGn38tRxHCUxL99V4CgvppiZPXk2TPSQZoKPSUbUsHKvRmpAKdCppDvPxlzXFYRU8bWx9n4emLkHwjkGtFROJ4YXe+0Q955lCTE1o5pM/OgcDy/IN8Wcc1J/qCo4KETGnee60blmcGa2F70eM2QjrI5Smwx2LeSqkcP2epJK/pHcDAEUQqUxGaRBsrohRQ6DIHj5GlMhYRd9mhyjjk7mVHsQxDGMDL2L+4EXiv2RRKTNmITJJyegbO1Wrjdxg67GVorl58A2fEwlxScwdBu1aHOq+3wO41QHqzMmoLNwNwNEIkQpNCLPZkXbXEFHMzc+zcxABDPbJpGM3DXh9TIzh++w1zMITk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3BDB46C01FB7BD4E99009B64AB10761A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f6b52e7f-b4a7-416d-66c9-08d746b8c226
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2019 21:46:03.9678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s3QgSCgZzP5foCm4rOIwvrAy4R3P199gimzU8j9HFC5HqmadDbOIp0e0PZCytz8+Zb7os3xaM2jMSC0ArI1CWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1885
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-01_10:2019-10-01,2019-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 bulkscore=0
 phishscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910010180
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 1, 2019, at 2:25 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>=20
> On Tue, Oct 1, 2019 at 2:14 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>> On Sep 30, 2019, at 11:58 AM, Andrii Nakryiko <andriin@fb.com> wrote:
>>>=20
>>> Add few macros simplifying BCC-like multi-level probe reads, while also
>>> emitting CO-RE relocations for each read.
>>>=20
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>> ---
>>> tools/lib/bpf/bpf_helpers.h | 151 +++++++++++++++++++++++++++++++++++-
>>> 1 file changed, 147 insertions(+), 4 deletions(-)
>>>=20
>>> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
>>> index a1d9b97b8e15..51e7b11d53e8 100644
>>> --- a/tools/lib/bpf/bpf_helpers.h
>>> +++ b/tools/lib/bpf/bpf_helpers.h
>>> @@ -19,6 +19,10 @@
>>> */
>>> #define SEC(NAME) __attribute__((section(NAME), used))
>>>=20
>>> +#ifndef __always_inline
>>> +#define __always_inline __attribute__((always_inline))
>>> +#endif
>>> +
>>> /* helper functions called from eBPF programs written in C */
>>> static void *(*bpf_map_lookup_elem)(void *map, const void *key) =3D
>>>      (void *) BPF_FUNC_map_lookup_elem;
>>> @@ -505,7 +509,7 @@ struct pt_regs;
>>> #endif
>>>=20
>>> /*
>>> - * BPF_CORE_READ abstracts away bpf_probe_read() call and captures off=
set
>>> + * bpf_core_read() abstracts away bpf_probe_read() call and captures f=
ield
>>> * relocation for source address using __builtin_preserve_access_index()
>>> * built-in, provided by Clang.
>>> *
>>> @@ -520,8 +524,147 @@ struct pt_regs;
>>> * actual field offset, based on target kernel BTF type that matches ori=
ginal
>>> * (local) BTF, used to record relocation.
>>> */
>>> -#define BPF_CORE_READ(dst, src)                                       =
       \
>>> -     bpf_probe_read((dst), sizeof(*(src)),                           \
>>> -                    __builtin_preserve_access_index(src))
>>> +#define bpf_core_read(dst, sz, src)                                   =
   \
>>> +     bpf_probe_read(dst, sz,                                          =
   \
>>> +                    (const void *)__builtin_preserve_access_index(src)=
)
>>> +
>>> +/*
>>> + * bpf_core_read_str() is a thin wrapper around bpf_probe_read_str()
>>> + * additionally emitting BPF CO-RE field relocation for specified sour=
ce
>>> + * argument.
>>> + */
>>> +#define bpf_core_read_str(dst, sz, src)                               =
           \
>>> +     bpf_probe_read_str(dst, sz,                                      =
   \
>>> +                        (const void *)__builtin_preserve_access_index(=
src))
>>> +
>>> +#define ___concat(a, b) a ## b
>>> +#define ___apply(fn, n) ___concat(fn, n)
>>> +#define ___nth(_1, _2, _3, _4, _5, _6, _7, _8, _9, _10, __11, N, ...) =
N
>>=20
>> We are adding many marcos with simple names: ___apply(), ___nth. So I wo=
rry
>> they may conflict with macro definitions from other libraries. Shall we =
hide
>> them in .c files or prefix/postfix them with _libbpf or something?
>=20
> Keep in mind, this is the header that's included from BPF code.
>=20
> They are prefixed with three underscores, I was hoping it's good
> enough to avoid accidental conflicts. It's unlikely someone will have
> macros with the same names **in BPF-side code**.

BPF side code would include kernel headers. So there are many headers
to conflict with. And we won't know until somebody want to trace certain
kernel structure.=20

> Prefixing with _libbpf is an option, but it will make it super ugly
> and hard to follow (I've spent a bunch of time to even get it to the
> current state), so I'd like to avoid that.

BPF programs will not use these marcos directly, so I feel it is OK to=20
pay the pain of _libbpf prefix, as it is contained within this file.=20

Thanks,
Song=20



