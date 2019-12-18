Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D506124035
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 08:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfLRHU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 02:20:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55886 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726752AbfLRHUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 02:20:25 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBI7EJVR005842;
        Tue, 17 Dec 2019 23:20:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=hfOerp01VGvDDOZ4sMWAM8J8gn4hPgjCbqCBhM7yZmU=;
 b=KnPuhIOtGFJlPE35Fh6Zt22Fg6zltDNxLlAyfIghvJ01vh0WUsFMGd2uN27U1qmd8hDH
 rjzBM3JJ23IxRCl2LhmKNXkBy8eRvOfzwgFX9g7D2YfhvId6ZBAzDwaCxyGjxcOjG/eB
 bJz7e+sFfGAx2HedGAZKt7W2Y98OSHPwx90= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wy1qrkutr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Dec 2019 23:20:10 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 17 Dec 2019 23:20:08 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 17 Dec 2019 23:20:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqDTK49W0XN6AfXW1kpNVbEgDuCqDsJ7H6KaDgUO2cGahhGvrrqq9+s+awfw8uvr9Qa+p2T9J1hWkOh1W3Uot44KQGcFDXsv2TfNxnMzT4yOpcCt1gVYi2wLZMfrQpldFM8ZKvGW24ukJBSy9Bx/mms3bXBQUNJusOXiquw6iAAqS1d6TyZ0IG3jVTxmmNErKk5MHpa2vQg89e6JB4aDNO/yAET/JNwksAp7+1xdN6c2yjLda3/WVRezbr7WXlzVZBnev3Q2N8QhnnFodPGLrTyqLgrruJ2fhyRet5QDiZaZBhiOXCVRmdxrwwSgYn4lQGKQiFkD6SvceW9px+xR8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfOerp01VGvDDOZ4sMWAM8J8gn4hPgjCbqCBhM7yZmU=;
 b=OxEiM4VBZW1i6ABJ3cRbTYM218/xpgH7R/H0h+30m2oRKe8pWFBz+XofvhnrhNTdFtpqdfvfYdO5XJPxJxi2HzdlpFkIvX9DhPuROdPnw3dAQPneIOAS7yNSaDYp6kbNnsjp9wOkBg94z3+0GNXDHl2bwKCXGtbv6YvmirAJJMEb10zMcquejNwu+Jnkkwz64Wc0Bu+zp3r+h6WWro24dBJlV8gYUHeSOYGLDn5HE/fVhXB8fD88JbDkgVgCBL1aAn7r0UQZpBPCkBxXQgCrlRrIZxuyuZQIvOjiwDfO2c4LcpynGHtiqMGveCDCzJ9j+yYCYLs8Iy0Ial/TacDUxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfOerp01VGvDDOZ4sMWAM8J8gn4hPgjCbqCBhM7yZmU=;
 b=WeSezMrw3kt2E2l0/SoQnj3bxnnSQPHL41hasiSTTdvRRvOKF6OJSihPyzdTPps7hqCUzYVpyPN7+zOUh9trs91umnSRimIcbNW43ZfG/hTGhwrh14cfWCfU7olsL7YNAhtcWWHDaOn+awJ0cVtr8Uw3mxL0hDLlrTtAD60FKn0=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3295.namprd15.prod.outlook.com (20.179.21.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Wed, 18 Dec 2019 07:20:07 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 07:20:07 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 11/13] bpf: libbpf: Add STRUCT_OPS support
Thread-Topic: [PATCH bpf-next 11/13] bpf: libbpf: Add STRUCT_OPS support
Thread-Index: AQHVshgyWEoHfLDvE0Suwi3j+8Waaae/PFiAgABCBoCAAASSgA==
Date:   Wed, 18 Dec 2019 07:20:07 +0000
Message-ID: <20191218072003.yxilrs4mniy6zgrb@kafai-mbp.dhcp.thefacebook.com>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004803.1653618-1-kafai@fb.com>
 <CAEf4BzbJoso7A0dn=xhOkFMOcKqZ6wYp=XoqGiL+FO+0VKqh5g@mail.gmail.com>
 <20191218070341.fd2ypexmeca5cefa@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191218070341.fd2ypexmeca5cefa@kafai-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR15CA0053.namprd15.prod.outlook.com
 (2603:10b6:301:4c::15) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::ce61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72c3b1c5-0143-44bc-f1b5-08d7838ab58d
x-ms-traffictypediagnostic: MN2PR15MB3295:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB3295C516BC5CA8BDAD046504D5530@MN2PR15MB3295.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(366004)(346002)(376002)(39860400002)(51914003)(199004)(189003)(6486002)(2906002)(9686003)(53546011)(6506007)(71200400001)(64756008)(52116002)(54906003)(66946007)(316002)(81156014)(66476007)(66446008)(478600001)(8676002)(66556008)(8936002)(6916009)(5660300002)(4326008)(86362001)(1076003)(81166006)(6512007)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3295;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E274o3eKctAE5MWa3ZBEk/rK0ESrL7atn47KnHd1zvapGfRuAmz5rirJkD38yhlEu+ORWGBc0D4muqegyqTMZvWnGXYFnb2LtyX53qbPMDB5woASd4tDJJJ6wkp0KTfLs+wBZOG5CR3LFxhheANj7bXJwq0E8zG4FGY7hf45seZz9nVKWCUyTVJbxprgpl9XDypNJOicdH2BarcP/TJxOFk5Kezed3w3kXYKyq0eZYaq81QbCXpuHgfayNL2cIM1IJWbB/sRjbZH4MwLkh03NnOTK6yFc4o1HirPjP6ugSo6FKhP9CwVSGaBXU50CV8U5ET36DZeu7MwJJnpPSzTZb9tTWyEMfW2gK+aRywzcx6i8oG33cIEVeR6Tk3Ir0ORFZbyGtfuw7Mq08rn6LWUsA6fNMlO5opHtnhVecFlW1yjzbruPQZZ4jwnk2nAF0qac5t+9ZLlFp6ADPpyXC7Uav5VZEPJdsn7wrosZghE3q5UxZq5/MGWA6PiCVtaiodh
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B7EFD343F62E4047805C215B4DFE0049@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 72c3b1c5-0143-44bc-f1b5-08d7838ab58d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 07:20:07.2647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1DRyVDXgj9Zou7O1QM1HR6EFtbrYwLJqItjtYpapWbjo7ZcyNmbQ/dYAt3df0LJu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3295
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_01:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912180057
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 11:03:45PM -0800, Martin Lau wrote:
> On Tue, Dec 17, 2019 at 07:07:23PM -0800, Andrii Nakryiko wrote:
> > On Fri, Dec 13, 2019 at 4:48 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This patch adds BPF STRUCT_OPS support to libbpf.
> > >
> > > The only sec_name convention is SEC("struct_ops") to identify the
> > > struct ops implemented in BPF, e.g.
> > > SEC("struct_ops")
> > > struct tcp_congestion_ops dctcp =3D {
> > >         .init           =3D (void *)dctcp_init,  /* <-- a bpf_prog */
> > >         /* ... some more func prts ... */
> > >         .name           =3D "bpf_dctcp",
> > > };
> > >
> > > In the bpf_object__open phase, libbpf will look for the "struct_ops"
> > > elf section and find out what is the btf-type the "struct_ops" is
> > > implementing.  Note that the btf-type here is referring to
> > > a type in the bpf_prog.o's btf.  It will then collect (through SHT_RE=
L)
> > > where are the bpf progs that the func ptrs are referring to.
> > >
> > > In the bpf_object__load phase, the prepare_struct_ops() will load
> > > the btf_vmlinux and obtain the corresponding kernel's btf-type.
> > > With the kernel's btf-type, it can then set the prog->type,
> > > prog->attach_btf_id and the prog->expected_attach_type.  Thus,
> > > the prog's properties do not rely on its section name.
> > >
> > > Currently, the bpf_prog's btf-type =3D=3D> btf_vmlinux's btf-type mat=
ching
> > > process is as simple as: member-name match + btf-kind match + size ma=
tch.
> > > If these matching conditions fail, libbpf will reject.
> > > The current targeting support is "struct tcp_congestion_ops" which
> > > most of its members are function pointers.
> > > The member ordering of the bpf_prog's btf-type can be different from
> > > the btf_vmlinux's btf-type.
> > >
> > > Once the prog's properties are all set,
> > > the libbpf will proceed to load all the progs.
> > >
> > > After that, register_struct_ops() will create a map, finalize the
> > > map-value by populating it with the prog-fd, and then register this
> > > "struct_ops" to the kernel by updating the map-value to the map.
> > >
> > > By default, libbpf does not unregister the struct_ops from the kernel
> > > during bpf_object__close().  It can be changed by setting the new
> > > "unreg_st_ops" in bpf_object_open_opts.
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> >=20
> > This looks pretty good to me. The big two things is exposing structops
> > as real struct bpf_map, so that users can interact with it using
> > libbpf APIs, as well as splitting struct_ops map creation and
> > registration. bpf_object__load() should only make sure all maps are
> > created, progs are loaded/verified, but none of BPF program can yet be
> > called. Then attach is the phase where registration happens.
> Thanks for the review.
>=20
> [ ... ]
>=20
> > >  static inline __u64 ptr_to_u64(const void *ptr)
> > >  {
> > >         return (__u64) (unsigned long) ptr;
> > > @@ -233,6 +239,32 @@ struct bpf_map {
> > >         bool reused;
> > >  };
> > >
> > > +struct bpf_struct_ops {
> > > +       const char *var_name;
> > > +       const char *tname;
> > > +       const struct btf_type *type;
> > > +       struct bpf_program **progs;
> > > +       __u32 *kern_func_off;
> > > +       /* e.g. struct tcp_congestion_ops in bpf_prog's btf format */
> > > +       void *data;
> > > +       /* e.g. struct __bpf_tcp_congestion_ops in btf_vmlinux's btf
> >=20
> > Using __bpf_ prefix for this struct_ops-specific types is a bit too
> > generic (e.g., for raw_tp stuff Alexei used btf_trace_). So maybe make
> > it btf_ops_ or btf_structops_?
> Is it a concern on name collision?
>=20
> The prefix pick is to use a more representative name.
> struct_ops use many bpf pieces and btf is one of them.
> Very soon, all new codes will depend on BTF and btf_ prefix
> could become generic also.
>=20
> Unlike tracepoint, there is no non-btf version of struct_ops.
May be bpf_struct_ops_?

It was my early pick but it read quite weird,
bpf_[struct]_<ops>_[tcp_congestion]_<ops>.

Hence, I go with __bpf_<actual-name-of-the-kernel-struct> in this series.
