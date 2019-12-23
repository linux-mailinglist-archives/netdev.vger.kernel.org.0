Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99109129B75
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 23:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfLWWaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 17:30:17 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1142 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726833AbfLWWaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 17:30:16 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBNMT5NM030844;
        Mon, 23 Dec 2019 14:30:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=QhNlLG4MuFgSBUblPcbnia2KZgF/h26IXxhnFmx7OIw=;
 b=l+4FNfYNQ+FFDjNgWhEDK8RuA82TWItL4awRFdy14Znf3au7GQ2lCQcKBSld6GFf5FGD
 6Cpb+cJrPZwr9wLOD9Gce0JwKJ1s0JAvR24147z0Az0Oohl5YE9Y/s07msWH8gX2Mwsk
 PLvJwsfFyKZw91KnY9oMBD+fNSCJVRySjqk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2x23yypba3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 Dec 2019 14:30:01 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 23 Dec 2019 14:30:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAED9lpL5N8D+zjPYPNCyvAUYSxIMcJT9UPv1MbCmJu/vn5U5p6qBuebEGzrIz5uCe4n10VJ8SRfc8kBx15MryHDRsG0w7dkuDcVS900XEmE1Sz7lGIP+Nabmz68dydGR/yOPKIK6wsE5Qeu4FigzNv7B77k1gXLqSHAqU79Dw7X+CKnapxJL7L2zjBLmr7VU5a1vi8YG5F6Yv0gVZr8iCT3aPs52TL4HuqsqYP9ayBplok0dmeznlwHFTD9Cc1haMu3zj/2elP7vGxtAyhlOrqO/rk77EpnHjW1m5TJkqyS2WC5KAdN350B7g+dxkiEB+JLSDYTS5+TZhGqCo3/Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QhNlLG4MuFgSBUblPcbnia2KZgF/h26IXxhnFmx7OIw=;
 b=bG3OX3TkfTlqlcMuB/RyxPymCsrtuV9HpCNJF9cxZj7Z4Bg4Zo6+wrf/wZH+aiZnnoIAYbyl76mqY9rMO83OZlorpWA4VeFi4OyEqAIaQnjmS0obLtLIR78JfvhC8g0GFlskYHwvIhS3nYri8HMy5VIXoAKXj8vHWMHCP10H75sc+LZ5z5XeGlcZioNIpEYuZxUiVZKA8W9YZmgzGSnOeDTiaEBeZJg2yEaSNWING1TkURZdbxoIGxZ4XrJSlmSuazeyLkbdWj/i3A1gx/ykoRvTEj01GvUYowA++fMnDLUZmx0ePxi/jJFPlLU+BtNgx95oTgPxxYQi0bNYDTsjKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QhNlLG4MuFgSBUblPcbnia2KZgF/h26IXxhnFmx7OIw=;
 b=kXCV+1yQWIeZ9ZKfbn0+xVQE+QgHPhksphSwx6VbB/knk9J1gTgzbjwYkDnJpUxJx2VhfhLjs7zRZzgXRNBfOnOSt4z/jSq/5+FWE6MuAATxXBB0z95gsm82ASg2oHFGyHlUpHUnuNwIlpsgzJsn0E6YnVNMmt3qQKs+f1LXBMY=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2686.namprd15.prod.outlook.com (20.179.146.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Mon, 23 Dec 2019 22:29:59 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 22:29:59 +0000
Received: from kafai-mbp (2620:10d:c090:180::535) by MWHPR21CA0041.namprd21.prod.outlook.com (2603:10b6:300:129::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.4 via Frontend Transport; Mon, 23 Dec 2019 22:29:58 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 05/11] bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS
Thread-Topic: [PATCH bpf-next v2 05/11] bpf: Introduce
 BPF_PROG_TYPE_STRUCT_OPS
Thread-Index: AQHVt8eKsaOhn2B0+Ey33KVYlHTW0qfIL9SAgAAhnYA=
Date:   Mon, 23 Dec 2019 22:29:59 +0000
Message-ID: <20191223222955.2d2hxboqzgp7662r@kafai-mbp>
References: <20191221062556.1182261-1-kafai@fb.com>
 <20191221062606.1182939-1-kafai@fb.com>
 <CAEf4BzYF8mBrkzM3=+XtyCwoQrLGvkA-6Uc3KXJ9CWmaKePX8Q@mail.gmail.com>
In-Reply-To: <CAEf4BzYF8mBrkzM3=+XtyCwoQrLGvkA-6Uc3KXJ9CWmaKePX8Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0041.namprd21.prod.outlook.com
 (2603:10b6:300:129::27) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::535]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea80a840-c8af-4680-7e6b-08d787f7a55b
x-ms-traffictypediagnostic: MN2PR15MB2686:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2686980F121704E8016D7953D52E0@MN2PR15MB2686.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(396003)(376002)(366004)(346002)(199004)(189003)(53546011)(71200400001)(8676002)(186003)(64756008)(66556008)(9686003)(66476007)(66446008)(6496006)(81166006)(4326008)(54906003)(316002)(52116002)(81156014)(2906002)(5660300002)(6916009)(478600001)(8936002)(1076003)(66946007)(86362001)(33716001)(55016002)(16526019);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2686;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WK6T2FMSeZo3NdTLU1Fsroj45BivNoEW8YsCVkTRc3BXqvpm6NcWL17ttpSDDtl7Uk+HkIMiUCeQeAleY9udDxC7akyFX0ol0EWTyhOUmkdFC0U1PH8LaRM9OY6LHpIaXp7Ltnpazx+Y572stW8LQriM9s1o2aOzmP+C3Ena/FPUVfExHB2KZz4WXOVxuuvIwhRBBaJsY/RkXhCU30h2X3RSDqiB8l35bUQZn+QI1pO0s9Si8QQyti8p/dpyAivCNStTEJ7tixh8RE24RnrrzbEx1X+nQXeGvWIfLKsBOfW7PSmRJP2msCe927WXCBzqdbH0CbxXVThji/qk6JJ6MfqH1Ia5oJGAj2qAsxeLPebBbFeTLxkTCTeEQ7unpW491Ld6q8jVlT44KWyaUCeQyjgtYDgSwmLQPhYsqMjK+P4WI6HVq3g6Q/LEfKLdDYyo
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F0F37AF5C49D4840AC0762C9860B1C09@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ea80a840-c8af-4680-7e6b-08d787f7a55b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 22:29:59.8222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UjmDJiSRljLrUSVUjO5WoJd9Yk0+81tD+cc+Ntpx8nwBBr9N7Enq0RTJqjsytlQl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2686
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_10:2019-12-23,2019-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=767 phishscore=0
 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912230195
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 12:29:37PM -0800, Andrii Nakryiko wrote:
> On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch allows the kernel's struct ops (i.e. func ptr) to be
> > implemented in BPF.  The first use case in this series is the
> > "struct tcp_congestion_ops" which will be introduced in a
> > latter patch.
> >
> > This patch introduces a new prog type BPF_PROG_TYPE_STRUCT_OPS.
> > The BPF_PROG_TYPE_STRUCT_OPS prog is verified against a particular
> > func ptr of a kernel struct.  The attr->attach_btf_id is the btf id
> > of a kernel struct.  The attr->expected_attach_type is the member
> > "index" of that kernel struct.  The first member of a struct starts
> > with member index 0.  That will avoid ambiguity when a kernel struct
> > has multiple func ptrs with the same func signature.
> >
> > For example, a BPF_PROG_TYPE_STRUCT_OPS prog is written
> > to implement the "init" func ptr of the "struct tcp_congestion_ops".
> > The attr->attach_btf_id is the btf id of the "struct tcp_congestion_ops=
"
> > of the _running_ kernel.  The attr->expected_attach_type is 3.
> >
> > The ctx of BPF_PROG_TYPE_STRUCT_OPS is an array of u64 args saved
> > by arch_prepare_bpf_trampoline that will be done in the next
> > patch when introducing BPF_MAP_TYPE_STRUCT_OPS.
> >
> > "struct bpf_struct_ops" is introduced as a common interface for the ker=
nel
> > struct that supports BPF_PROG_TYPE_STRUCT_OPS prog.  The supporting ker=
nel
> > struct will need to implement an instance of the "struct bpf_struct_ops=
".
> >
> > The supporting kernel struct also needs to implement a bpf_verifier_ops=
.
> > During BPF_PROG_LOAD, bpf_struct_ops_find() will find the right
> > bpf_verifier_ops by searching the attr->attach_btf_id.
> >
> > A new "btf_struct_access" is also added to the bpf_verifier_ops such
> > that the supporting kernel struct can optionally provide its own specif=
ic
> > check on accessing the func arg (e.g. provide limited write access).
> >
> > After btf_vmlinux is parsed, the new bpf_struct_ops_init() is called
> > to initialize some values (e.g. the btf id of the supporting kernel
> > struct) and it can only be done once the btf_vmlinux is available.
> >
> > The R0 checks at BPF_EXIT is excluded for the BPF_PROG_TYPE_STRUCT_OPS =
prog
> > if the return type of the prog->aux->attach_func_proto is "void".
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  include/linux/bpf.h               |  30 +++++++
> >  include/linux/bpf_types.h         |   4 +
> >  include/linux/btf.h               |  34 ++++++++
> >  include/uapi/linux/bpf.h          |   1 +
> >  kernel/bpf/Makefile               |   2 +-
> >  kernel/bpf/bpf_struct_ops.c       | 122 +++++++++++++++++++++++++++
> >  kernel/bpf/bpf_struct_ops_types.h |   4 +
> >  kernel/bpf/btf.c                  |  88 ++++++++++++++------
> >  kernel/bpf/syscall.c              |  17 ++--
> >  kernel/bpf/verifier.c             | 134 +++++++++++++++++++++++-------
> >  10 files changed, 372 insertions(+), 64 deletions(-)
> >  create mode 100644 kernel/bpf/bpf_struct_ops.c
> >  create mode 100644 kernel/bpf/bpf_struct_ops_types.h
> >
>=20
> All looks good, apart from the concern with partially-initialized
> bpf_struct_ops.
>=20
> [...]
>=20
> > +const struct bpf_prog_ops bpf_struct_ops_prog_ops =3D {
> > +};
> > +
> > +void bpf_struct_ops_init(struct btf *_btf_vmlinux)
>=20
> this is always get passed vmlinux's btf, so why not call it short and
> sweet "btf"? _btf_vmlinux is kind of ugly and verbose.
>=20
> > +{
> > +       const struct btf_member *member;
> > +       struct bpf_struct_ops *st_ops;
> > +       struct bpf_verifier_log log =3D {};
> > +       const struct btf_type *t;
> > +       const char *mname;
> > +       s32 type_id;
> > +       u32 i, j;
> > +
>=20
> [...]
>=20
> > +static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
> > +{
> > +       const struct btf_type *t, *func_proto;
> > +       const struct bpf_struct_ops *st_ops;
> > +       const struct btf_member *member;
> > +       struct bpf_prog *prog =3D env->prog;
> > +       u32 btf_id, member_idx;
> > +       const char *mname;
> > +
> > +       btf_id =3D prog->aux->attach_btf_id;
> > +       st_ops =3D bpf_struct_ops_find(btf_id);
>=20
> if struct_ops initialization fails, type will be NULL and type_id will
> be 0, which we rely on here to not get partially-initialized
> bpf_struct_ops, right? Small comment mentioning this would be helpful.
>=20
>=20
> > +       if (!st_ops) {
> > +               verbose(env, "attach_btf_id %u is not a supported struc=
t\n",
> > +                       btf_id);
> > +               return -ENOTSUPP;
> > +       }
> > +
>=20
> [...]
>=20
> >  static int check_attach_btf_id(struct bpf_verifier_env *env)
> >  {
> >         struct bpf_prog *prog =3D env->prog;
> > @@ -9520,6 +9591,9 @@ static int check_attach_btf_id(struct bpf_verifie=
r_env *env)
> >         long addr;
> >         u64 key;
> >
> > +       if (prog->type =3D=3D BPF_PROG_TYPE_STRUCT_OPS)
> > +               return check_struct_ops_btf_id(env);
> > +
>=20
> There is a btf_id =3D=3D 0 check below, you need to check that for
> STRUCT_OPS as well, otherwise you can get partially-initialized
> bpf_struct_ops struct in check_struct_ops_btf_id.
This btf_id =3D=3D 0 check is done at the beginning of bpf_struct_ops_find(=
).
Hence, bpf_struct_ops_find() won't try to search if btf_id is 0.

st_ops fields is only set when everything passed, so individual st_ops
will not be partially initialized.


>=20
> >         if (prog->type !=3D BPF_PROG_TYPE_TRACING)
> >                 return 0;
> >
> > --
> > 2.17.1
> >
