Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8022912A344
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 17:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfLXQuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 11:50:40 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32876 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726168AbfLXQuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 11:50:39 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBOGigPj009065;
        Tue, 24 Dec 2019 08:50:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=441ohU5VrLag8F7kQSffm7yFpz0lf44BIFygxgE9GK4=;
 b=IVXDf1usz6RXdH3hlT/PWdy1Rtjg5TUjZMLGvwenXIrFn/gIqyGjHVdWGyBDnCEZYTer
 DRE3aT/euGFjYK2ShLVcgrh63XOyKsUTVQbQ+nqekLcnZFt3e6+3Z3R8XwLFVm77XKfZ
 cuG84tHDid56uDBWOZfgOXH9izC8ZTaht0o= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2x3h700ydd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 24 Dec 2019 08:50:23 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 24 Dec 2019 08:50:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XsgosN+7wmGhCzs/BT7FpNx6E84f+YqLH8bf+jVxP53Leun9/LlRbo+pBTHyfn7viWqIevGGQaZZDSS/3Bi4zAQ0Lds17KeZwk9iFR0uPz3cJwL9XTPytbfi2VVB68ad4yZP8uHRQVBWUjp32IFBO0Whj8x+lrABtsFAxlg4Bf6fdJ0ZBqpBQ94cKoL9CVPX4MbEhUS4S39BgOoeeHLFMwihfFP4uvJ3/LO/BOWeiHTMYjWy3FV0zDHMi5o/Jfh4+6KWs8gYbaDsVftUWnotFe+cKhfZ9FIeck5wPwOSufBUYv6NEW0U6hTNfsI/516fxQkU+0gcOSwZhWRzliByyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=441ohU5VrLag8F7kQSffm7yFpz0lf44BIFygxgE9GK4=;
 b=kqti6+R4myrW3eRo1YA2KSisuAnTD7rMXJEcuFYhJ2Gc5VZO/ZEmP5b7dfSPBT4lhCF5WgPtW59MizK5ZU5gaplX7Dmqjrc+73U5OcEep0TF+6lNe5QIS4J++R7y7kYJ2nIwr2hohEEur8mOmaxf8LPp+qYWZXfifld9WJ805+FMWsJWcFr/fFdRVNaDOGAUgXrQnUbw/YL5+6onpH6p5jCG83pwycidDzsANA/DxufcWtXUdj/MbkTgTOQgAo5SzCFsjXNBA2LFJXXDRXxkHfGXoJuJ7iTRlPvEbuVBfipyF8QHgsgnym+8223m+eE+h+RR7enIn1cxL4NyuyWamQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=441ohU5VrLag8F7kQSffm7yFpz0lf44BIFygxgE9GK4=;
 b=lXhzNdzrC+sLYdqTQoz2fBtJhdoNKHBV52s0poT58sapnHyKvxCorOyaLLrcc2XY8+8gUi9zzpp05yGyE1YH+wuJfT9Nsk8o4ssaCpIgTweV8zdK1yUPTo5SWQbMwv+XZDuiqbaBlYaCjvwn4CLsr6nMXnx/RCCS2jXi/D8oLT0=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2877.namprd15.prod.outlook.com (20.178.251.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.16; Tue, 24 Dec 2019 16:50:08 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2559.017; Tue, 24 Dec 2019
 16:50:07 +0000
Received: from kafai-mbp (2620:10d:c090:180::1611) by MWHPR15CA0035.namprd15.prod.outlook.com (2603:10b6:300:ad::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Tue, 24 Dec 2019 16:50:06 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 11/11] bpf: Add bpf_dctcp example
Thread-Topic: [PATCH bpf-next v2 11/11] bpf: Add bpf_dctcp example
Thread-Index: AQHVueh9eJgyi9Vd8EqEIu9FcYh4uKfIf/YAgABcRoCAAKRSgA==
Date:   Tue, 24 Dec 2019 16:50:07 +0000
Message-ID: <20191224165003.oi4kvxad6mlsg5kw@kafai-mbp>
References: <20191221062556.1182261-1-kafai@fb.com>
 <20191221062620.1184118-1-kafai@fb.com>
 <CAEf4BzZX_TNUXJktJUtqmxgMefDzie=Ta18TbBqBhG0-GSLQMg@mail.gmail.com>
 <20191224013140.ibn33unj77mtbkne@kafai-mbp>
 <CAEf4Bzb2fRZJsccx2CG_pASy+2eMMWPXk6m3d6SbN+o0MSdQPg@mail.gmail.com>
In-Reply-To: <CAEf4Bzb2fRZJsccx2CG_pASy+2eMMWPXk6m3d6SbN+o0MSdQPg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR15CA0035.namprd15.prod.outlook.com
 (2603:10b6:300:ad::21) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1611]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 500554d9-0559-4c5b-1816-08d7889154d9
x-ms-traffictypediagnostic: MN2PR15MB2877:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2877D004D49A596540B4ABF3D5290@MN2PR15MB2877.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0261CCEEDF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(346002)(396003)(376002)(39860400002)(189003)(199004)(53546011)(8676002)(81156014)(4326008)(71200400001)(55016002)(478600001)(33716001)(186003)(6916009)(9686003)(16526019)(81166006)(86362001)(54906003)(6496006)(64756008)(66446008)(66476007)(5660300002)(1076003)(2906002)(66946007)(52116002)(8936002)(316002)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2877;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WNvn71d8MIM9o1lVVBou6202oCMRZjgMbU15bDUiwNrWnG8PqyzqXiOUR1tV7JYazpt7Dy276NYMwQhzi21g1+TOqJ62DDLeCMGubmoFVqUpISjj56QILDs6xQLrYpHGnZADRKoCrwX5HdOY9s9nRLpChwjV/B05VSuG7RPgF3hphzezPsxmtisrjvCfGqeESs9/UuHD7ILz0G+hxfntdq4Nf06lS2PXN6VVODgC8Ye+MJ6iQzC4TRPDRIl1d01NDAQ0pokhcA+oeT0rUoTOueRHIVn81NhyQxdT460LmM27FhOZHBh/2W/8IiQHagr5KD+T4TzUHmsB/39RlyoYag+nGyIgBAqjTRiUsCJgvXmJOoOlXtyHbI6QdiLd91YordESv/DHEbHroE42S4BJ/5ZF/iH9KZWLhPydJTqLU9QJ46BpnatX3WtKGV8BTHE+
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6FDDCF0DC96B744A933DDCA3D0F24B30@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 500554d9-0559-4c5b-1816-08d7889154d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2019 16:50:07.5231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TlZOd8ATbc40jY9oAFGgyuwQShT/hDAz9fI3SLWQpJbmMnldi+J7DjgzJ0L9yUG2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2877
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-24_04:2019-12-24,2019-12-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 mlxscore=0 suspectscore=0 adultscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 bulkscore=0 phishscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912240146
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 11:01:55PM -0800, Andrii Nakryiko wrote:
> On Mon, Dec 23, 2019 at 5:31 PM Martin Lau <kafai@fb.com> wrote:
> >
> > On Mon, Dec 23, 2019 at 03:26:50PM -0800, Andrii Nakryiko wrote:
> > > On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.com> wrot=
e:
> > > >
> > > > This patch adds a bpf_dctcp example.  It currently does not do
> > > > no-ECN fallback but the same could be done through the cgrp2-bpf.
> > > >
> > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > ---
> > > >  tools/testing/selftests/bpf/bpf_tcp_helpers.h | 228 ++++++++++++++=
++++
> > > >  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 218 ++++++++++++++=
+++
> > > >  tools/testing/selftests/bpf/progs/bpf_dctcp.c | 210 ++++++++++++++=
++
> > > >  3 files changed, 656 insertions(+)
> > > >  create mode 100644 tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_tcp_=
ca.c
> > > >  create mode 100644 tools/testing/selftests/bpf/progs/bpf_dctcp.c
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/=
testing/selftests/bpf/bpf_tcp_helpers.h
> > > > new file mode 100644
> > > > index 000000000000..7ba8c1b4157a
> > > > --- /dev/null
> > > > +++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > > @@ -0,0 +1,228 @@
> > > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > > +#ifndef __BPF_TCP_HELPERS_H
> > > > +#define __BPF_TCP_HELPERS_H
> > > > +
> > > > +#include <stdbool.h>
> > > > +#include <linux/types.h>
> > > > +#include <bpf_helpers.h>
> > > > +#include <bpf_core_read.h>
> > > > +#include "bpf_trace_helpers.h"
> > > > +
> > > > +#define BPF_TCP_OPS_0(fname, ret_type, ...) BPF_TRACE_x(0, #fname"=
_sec", fname, ret_type, __VA_ARGS__)
> > > > +#define BPF_TCP_OPS_1(fname, ret_type, ...) BPF_TRACE_x(1, #fname"=
_sec", fname, ret_type, __VA_ARGS__)
> > > > +#define BPF_TCP_OPS_2(fname, ret_type, ...) BPF_TRACE_x(2, #fname"=
_sec", fname, ret_type, __VA_ARGS__)
> > > > +#define BPF_TCP_OPS_3(fname, ret_type, ...) BPF_TRACE_x(3, #fname"=
_sec", fname, ret_type, __VA_ARGS__)
> > > > +#define BPF_TCP_OPS_4(fname, ret_type, ...) BPF_TRACE_x(4, #fname"=
_sec", fname, ret_type, __VA_ARGS__)
> > > > +#define BPF_TCP_OPS_5(fname, ret_type, ...) BPF_TRACE_x(5, #fname"=
_sec", fname, ret_type, __VA_ARGS__)
> > >
> > > Should we try to put those BPF programs into some section that would
> > > indicate they are used with struct opts? libbpf doesn't use or enforc=
e
> > > that (even though it could to derive and enforce that they are
> > > STRUCT_OPS programs). So something like
> > > SEC("struct_ops/<ideally-operation-name-here>"). I think having this
> > > convention is very useful for consistency and to do a quick ELF dump
> > > and see what is where. WDYT?
> > I did not use it here because I don't want any misperception that it is
> > a required convention by libbpf.
> >
> > Sure, I can prefix it here and comment that it is just a
> > convention but not a libbpf's requirement.
>=20
> Well, we can actually make it a requirement of sorts. Currently your
> code expects that BPF program's type is UNSPEC and then it sets it to
> STRUCT_OPS. Alternatively we can say that any BPF program in
> SEC("struct_ops/<whatever>") will be automatically assigned
> STRUCT_OPTS BPF program type (which is done generically in
> bpf_object__open()), and then as .struct_ops section is parsed, all
> those programs will be "assembled" by the code you added into a
> struct_ops map.
Setting BPF_PROG_TYPE_STRUCT_OPS can be done automatically at open
phase (during collect_reloc time).  I will make this change.

>=20
> It's a requirement "of sorts", because even if user doesn't do that,
> stuff will still work, if user manually will call
> bpf_program__set_struct_ops(prog). Which actually reminds me that it
> would be good to add bpf_program__set_struct_ops() and
Although there is BPF_PROG_TYPE_FNS macro,=20
I don't see moving bpf_prog__set_struct_ops(prog) to LIBBPF_API is useful
while actually may cause confusion and error.  How could __set_struct_ops()
a prog to struct_ops prog_type help a program, which is not used in
SEC(".struct_ops"), to be loaded successfully as a struct_ops prog?

Assigning a bpf_prog to a function ptr under the SEC(".struct_ops")
is the only way for a program to be successfully loaded as
struct_ops prog type.  Extra way to allow a prog to be changed to
struct_ops prog_type is either useless or redundant.

If it is really necessary to have __set_struct_ops() as a API
for completeness, it can be added...

> bpf_program__is_struct_ops() APIs for completeness, similarly to how
is_struct_ops() makes sense.

> BTW, libbpf will emit debug message for every single BPF program it
> doesn't recognize section for, so it is still nice to have it be
> something more or less standardized and recognizable by libbpf.
I can make this debug (not error) message go away too after
setting the BPF_PROG_TYPE_STRUCT_OPS automatically at open time.
