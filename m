Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6DD12AE67
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 21:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfLZUZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 15:25:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45110 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726653AbfLZUZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 15:25:50 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBQKPVaO022024;
        Thu, 26 Dec 2019 12:25:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=MjDkqJ7IlrDY+msKMRwXDeqPMKB/Fk4WlTuOXBl6nTg=;
 b=mxHVsvi6zDHu9kQ0dYK0x8ju7csMZbbiQxzGDwsg2KOc+uJ3l4ejzYvfp98eZcIGovOe
 Aq6mxKJctBDIJLSpeNZ61gCF42Ihmie8MyR0SGf4XC0FTtOOVjWFtHt/vYJEbNZqmJrc
 kgMnzhlKcIFThsL0dDhpAruYB84gxojCZ6w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2x3aej9gfc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 26 Dec 2019 12:25:31 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 26 Dec 2019 12:25:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QW6Ak5cQ4Qo/ilar986oruqfSQ9mLQTE134j5YjmWmQS9pRvi8zrKAXyh0cQPmkE87OfKSH2c+x9Q34CSRLR1jzko9YTTZL6AeCuldaz/HAroY3USzc416yLF/yL8yEVzQzGP8bxb/MTgjVtypLufbLPp1LEF55Fjbyd/akqfcj3VQ/E1t751RNi1JnuHTJiZ2BfBfO1UUBDlOm++8bHBLY1SjnJLRFa/E9OCRJkOncPkNMzlgA2CospSXH3/X036qKvV1lveewTnjjMGtHr+Z0HV6BWDhMRZWlOD4KhnJGv8joTGfx5Jiy19jQOTSNY7UssfDCBFY1qKZofhtzmWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MjDkqJ7IlrDY+msKMRwXDeqPMKB/Fk4WlTuOXBl6nTg=;
 b=NP2ImTy116o2uRaBb7VRRR8QGXpxTcDcM3+FgLVLtNGS9XYohH0KbABRb4H4oNE5s7ALYEJOouY8xjLdgRnx5sJ941z8VReDQuhJXkNWo84s2S1G4xPvBHKmwDb2TAF5x6qb05/IRw1ah8V0S3ork7j8St+JdXKgADIBMNIpG2o10SXwbzTyigLOfeefI2Qc1RK4wDJN7QsCApb+13LtQEZ6TV4YsPdUwmnd7KlrqmP8TrbSfgj9O6Dl7Dgo6OkGlNOfTl3uNT9UAl5GHyS8ciWpVJWodPYKO2in7+8o/XJr3i9VCt90m0CCck3UzTR8PI/evJTNf+OJRBh2ucqedw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MjDkqJ7IlrDY+msKMRwXDeqPMKB/Fk4WlTuOXBl6nTg=;
 b=INFDYg/va1D7Hd+M/rEzU5LN3P/BQTSg3OCjrYvmWYT+uHWaVjmCakfj3Ssz1CPCR2AC0Fb6AwNSaxZp3KjAGUCsvULe9ZSXML3Lxwk4gJdhw0N9xVGRUjrHv+qBJf2atn4CUjRWxh9T4QxKpkKLdJfMrnH76MibPIGaPgg79w0=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3150.namprd15.prod.outlook.com (20.178.250.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Thu, 26 Dec 2019 20:25:16 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2559.017; Thu, 26 Dec 2019
 20:25:15 +0000
Received: from kafai-mbp (2620:10d:c090:180::a2c3) by CO1PR15CA0077.namprd15.prod.outlook.com (2603:10b6:101:20::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Thu, 26 Dec 2019 20:25:14 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 11/11] bpf: Add bpf_dctcp example
Thread-Topic: [PATCH bpf-next v2 11/11] bpf: Add bpf_dctcp example
Thread-Index: AQHVueh9eJgyi9Vd8EqEIu9FcYh4uKfIf/YAgABcRoCAAKRSgIADSacAgAAXIAA=
Date:   Thu, 26 Dec 2019 20:25:15 +0000
Message-ID: <20191226202512.abhyhdtetv46z5sd@kafai-mbp>
References: <20191221062556.1182261-1-kafai@fb.com>
 <20191221062620.1184118-1-kafai@fb.com>
 <CAEf4BzZX_TNUXJktJUtqmxgMefDzie=Ta18TbBqBhG0-GSLQMg@mail.gmail.com>
 <20191224013140.ibn33unj77mtbkne@kafai-mbp>
 <CAEf4Bzb2fRZJsccx2CG_pASy+2eMMWPXk6m3d6SbN+o0MSdQPg@mail.gmail.com>
 <20191224165003.oi4kvxad6mlsg5kw@kafai-mbp>
 <CAEf4BzYA=xS7pHPqGxK4LsRHpxN=Y4dLcbG8WNMqGhKpauh7gQ@mail.gmail.com>
In-Reply-To: <CAEf4BzYA=xS7pHPqGxK4LsRHpxN=Y4dLcbG8WNMqGhKpauh7gQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0077.namprd15.prod.outlook.com
 (2603:10b6:101:20::21) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::a2c3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ccd08b1-0e9e-43ca-b0a6-08d78a41b7b8
x-ms-traffictypediagnostic: MN2PR15MB3150:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB31501EA80A2A37D79727020DD52B0@MN2PR15MB3150.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02638D901B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(366004)(346002)(376002)(136003)(189003)(199004)(81166006)(81156014)(8676002)(9686003)(55016002)(8936002)(6916009)(33716001)(71200400001)(86362001)(4326008)(5660300002)(16526019)(316002)(66946007)(53546011)(478600001)(2906002)(66476007)(186003)(6496006)(52116002)(54906003)(1076003)(64756008)(66446008)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3150;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xl5KrsBKuTiGiqmk+SX4SxKD6YRztmoqoh6iZu6mkp4AfmZ1GJ0fXeysdswkWIPP4ExC0C3nBER4I6HzAb8MvKb6WoOBRTs0UWcpOxbfbcZeEM7yuLolJAANhNb0JwBBlcl5KExRwOTV72V3OEoI64BkPdjxAH7YPYs0T7nwy2VJRJVugpr9d3nB3tLo9nFfwtHVEhDFEjBKSxMnDza8+lvp+uHTiUopDulbTUm133Ve4p4ohILr1hEFVHrKsaAZcThmjfdjkLQrHav8oyaUe/5ruZ5geqeKln42LXolHvsiDd5/wVfO4EE368uNjfWrEh+ZxyY/dbpkmtL6Vb8GWN1IunFx4JyHtvPEdYrdvdRdhrdoqOq4tePD4LjeXgZWTVJCPAF3wc2J04dHJdUexL+TBVGD2ylpqIK5u2OaDTPfDVEBtAxsWDbhLHP9So13
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4447D8FC94AE3B43AF33C8D428387A39@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ccd08b1-0e9e-43ca-b0a6-08d78a41b7b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Dec 2019 20:25:15.7265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Mat7IpixwGPNISIPsJKPUWZyCR+U4NX1FKdZUB65lZfNZRbj9Kmm2wb0F/zz0JX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3150
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-26_05:2019-12-24,2019-12-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912260180
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019 at 11:02:26AM -0800, Andrii Nakryiko wrote:
> On Tue, Dec 24, 2019 at 8:50 AM Martin Lau <kafai@fb.com> wrote:
> >
> > On Mon, Dec 23, 2019 at 11:01:55PM -0800, Andrii Nakryiko wrote:
> > > On Mon, Dec 23, 2019 at 5:31 PM Martin Lau <kafai@fb.com> wrote:
> > > >
> > > > On Mon, Dec 23, 2019 at 03:26:50PM -0800, Andrii Nakryiko wrote:
> > > > > On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.com> =
wrote:
> > > > > >
> > > > > > This patch adds a bpf_dctcp example.  It currently does not do
> > > > > > no-ECN fallback but the same could be done through the cgrp2-bp=
f.
> > > > > >
> > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > ---
> > > > > >  tools/testing/selftests/bpf/bpf_tcp_helpers.h | 228 ++++++++++=
++++++++
> > > > > >  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 218 ++++++++++=
+++++++
> > > > > >  tools/testing/selftests/bpf/progs/bpf_dctcp.c | 210 ++++++++++=
++++++
> > > > > >  3 files changed, 656 insertions(+)
> > > > > >  create mode 100644 tools/testing/selftests/bpf/bpf_tcp_helpers=
.h
> > > > > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_=
tcp_ca.c
> > > > > >  create mode 100644 tools/testing/selftests/bpf/progs/bpf_dctcp=
.c
> > > > > >
> > > > > > diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/to=
ols/testing/selftests/bpf/bpf_tcp_helpers.h
> > > > > > new file mode 100644
> > > > > > index 000000000000..7ba8c1b4157a
> > > > > > --- /dev/null
> > > > > > +++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > > > > @@ -0,0 +1,228 @@
> > > > > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > > > > +#ifndef __BPF_TCP_HELPERS_H
> > > > > > +#define __BPF_TCP_HELPERS_H
> > > > > > +
> > > > > > +#include <stdbool.h>
> > > > > > +#include <linux/types.h>
> > > > > > +#include <bpf_helpers.h>
> > > > > > +#include <bpf_core_read.h>
> > > > > > +#include "bpf_trace_helpers.h"
> > > > > > +
> > > > > > +#define BPF_TCP_OPS_0(fname, ret_type, ...) BPF_TRACE_x(0, #fn=
ame"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > +#define BPF_TCP_OPS_1(fname, ret_type, ...) BPF_TRACE_x(1, #fn=
ame"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > +#define BPF_TCP_OPS_2(fname, ret_type, ...) BPF_TRACE_x(2, #fn=
ame"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > +#define BPF_TCP_OPS_3(fname, ret_type, ...) BPF_TRACE_x(3, #fn=
ame"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > +#define BPF_TCP_OPS_4(fname, ret_type, ...) BPF_TRACE_x(4, #fn=
ame"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > +#define BPF_TCP_OPS_5(fname, ret_type, ...) BPF_TRACE_x(5, #fn=
ame"_sec", fname, ret_type, __VA_ARGS__)
> > > > >
> > > > > Should we try to put those BPF programs into some section that wo=
uld
> > > > > indicate they are used with struct opts? libbpf doesn't use or en=
force
> > > > > that (even though it could to derive and enforce that they are
> > > > > STRUCT_OPS programs). So something like
> > > > > SEC("struct_ops/<ideally-operation-name-here>"). I think having t=
his
> > > > > convention is very useful for consistency and to do a quick ELF d=
ump
> > > > > and see what is where. WDYT?
> > > > I did not use it here because I don't want any misperception that i=
t is
> > > > a required convention by libbpf.
> > > >
> > > > Sure, I can prefix it here and comment that it is just a
> > > > convention but not a libbpf's requirement.
> > >
> > > Well, we can actually make it a requirement of sorts. Currently your
> > > code expects that BPF program's type is UNSPEC and then it sets it to
> > > STRUCT_OPS. Alternatively we can say that any BPF program in
> > > SEC("struct_ops/<whatever>") will be automatically assigned
> > > STRUCT_OPTS BPF program type (which is done generically in
> > > bpf_object__open()), and then as .struct_ops section is parsed, all
> > > those programs will be "assembled" by the code you added into a
> > > struct_ops map.
> > Setting BPF_PROG_TYPE_STRUCT_OPS can be done automatically at open
> > phase (during collect_reloc time).  I will make this change.
> >
>=20
> Can you please extend exiting logic in __bpf_object__open() to do
> this? See how libbpf_prog_type_by_name() is used for that.
Does it have to call libbpf_prog_type_by_name() if everything
has already been decided by the earlier
bpf_object__collect_struct_ops_map_reloc()?

>=20
> > >
> > > It's a requirement "of sorts", because even if user doesn't do that,
> > > stuff will still work, if user manually will call
> > > bpf_program__set_struct_ops(prog). Which actually reminds me that it
> > > would be good to add bpf_program__set_struct_ops() and
> > Although there is BPF_PROG_TYPE_FNS macro,
> > I don't see moving bpf_prog__set_struct_ops(prog) to LIBBPF_API is usef=
ul
> > while actually may cause confusion and error.  How could __set_struct_o=
ps()
> > a prog to struct_ops prog_type help a program, which is not used in
> > SEC(".struct_ops"), to be loaded successfully as a struct_ops prog?
> >
> > Assigning a bpf_prog to a function ptr under the SEC(".struct_ops")
> > is the only way for a program to be successfully loaded as
> > struct_ops prog type.  Extra way to allow a prog to be changed to
> > struct_ops prog_type is either useless or redundant.
>=20
> Well, first of all, just for consistency with everything else. We have
> such methods for all prog_types, so I'd like to avoid a special
> snowflake one that doesn't.
Yes, for consistency is fine as I mentioned in the earlier reply,
as long as it is understood the usefulness of it.

> Second, while high-level libbpf API provides all the magic to
> construct STRUCT_OPS map based on .struct_ops section types,
> technically, user might decide to do that using low-level map creation
> API, right?
How?

Correct that the map api is reused as is in SEC(".struct_ops").

For prog, AFAICT, it is not possible to create struct_ops
prog from raw and use it in struct_ops map unless more LIBBPF_API
is added.  Lets put aside the need to find the btf_vmlinux
and its btf-types...etc.  At least, there is no LIBBPF_API to
set prog->attach_btf_id.  Considering the amount of preparation
is needed to create a struct_ops map from raw,  I would like
to see a real use case first before even considering what else
is needed and add another LIBBPF_API that may not be used.
