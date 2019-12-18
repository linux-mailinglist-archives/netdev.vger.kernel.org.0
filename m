Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B15124F68
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 18:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfLRReR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 12:34:17 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49166 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727071AbfLRReQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 12:34:16 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIHPg47006141;
        Wed, 18 Dec 2019 09:33:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ik8vLikVXi39rLBXjGasGnmjD8mARBLl5BsYY11elvI=;
 b=Y39enPDEWmGu9Uas+T9hYIjrNwz1SowmyZJD5KxgZ/qPLzHbipH3GDTt2xUlNG8JEbNQ
 YTon1vkknq/s0vx4Xsjg01x4VSL/AM7i/XbE0cSpMfgl34puKKhomziGI6sqtTHSI/1w
 R+K3yE6W6/kDaxqPtgcnMJsJrLjiKkBvVFM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wyqmcgbpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Dec 2019 09:33:58 -0800
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 18 Dec 2019 09:33:56 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 18 Dec 2019 09:33:55 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 18 Dec 2019 09:33:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6lUmGpc8dTwtEWbz3DJPjd1i4Lctfg68Jj2l6NtL+CEMnfjOtTbCB8cpm7fkT6e/Xy/aQo6xVIJPp1vxtrg6x5QxiRtjgANQvfX2wT7v+kr80CbiZuOjA29K5SwDiJ25exnirekr5Gfev+Pbfb+JMmTTNzd0IMYtXH/HAGgvx1Kkiv4iuqo1yT2z5yvC24IlkD7a7tY7ZjBSB7US7bsf73bKjWE1yOZ12DRiLCa7c/ek7UovvPxcvg6We8UHBgc5FXs+cShHHA1NpBYDBKdodj9jYA0DAFy2yS8jWoKhvqLm//o87xABzzpzbp0MQhdP1V2AeVZOnE9S0vbSaIxgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ik8vLikVXi39rLBXjGasGnmjD8mARBLl5BsYY11elvI=;
 b=GloYIFpUMJsvv8Z6VLjioXHrdVcgD+OmPYKsoblfjcq0E40C4PxCb4zYMBgHYy8jC+LGUV3+ILVVaffMtVjfg46ijW8gWTo1OVmpCbecPe+RF+GrPu+gcmqcnIY6P+/Z2hwMjLuZfb5UcAuoV3VzShRzDGeQmT2CrVHemZJXZjC8G4wWlsDzNwlB6qBydrkoWQh/Gd1o+1EXlB0Z51+VZU54Q6UeZq80hFZqg3SKv/49ackrSsDcWqPe+vgDdzs6s+4QlAtxj7Pti/UYOk0a7d2jiEQDzFK7W0NcwLnGpchfpShurQXTCLumdNiTf4bIiovzsHKkS7W82RaDRGnkuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ik8vLikVXi39rLBXjGasGnmjD8mARBLl5BsYY11elvI=;
 b=bhK81B7o2CMnucDU3tomoTGIhE6ztaBfpbviwh9uTJ99r01Y6iDADVm4FRLFakZIUi7EGnxIvkvcgqo5AZ1wsLztzJsQ5RntFFBqG6073cOYaoYtoxO+MZGYIYf0CLmmNK++kjWmn0uxGN86TKbi8PHWCDrnqS+3Av8B6y3YUQA=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2526.namprd15.prod.outlook.com (20.179.146.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 17:33:54 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 17:33:54 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 11/13] bpf: libbpf: Add STRUCT_OPS support
Thread-Topic: [PATCH bpf-next 11/13] bpf: libbpf: Add STRUCT_OPS support
Thread-Index: AQHVshgyWEoHfLDvE0Suwi3j+8Waaae/PFiAgABCBoCAAJ92gIAAEJoA
Date:   Wed, 18 Dec 2019 17:33:54 +0000
Message-ID: <20191218173350.nll5766abgkptjac@kafai-mbp.dhcp.thefacebook.com>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004803.1653618-1-kafai@fb.com>
 <CAEf4BzbJoso7A0dn=xhOkFMOcKqZ6wYp=XoqGiL+FO+0VKqh5g@mail.gmail.com>
 <20191218070341.fd2ypexmeca5cefa@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzaGcM6ose=2DJJO1qkRkiqEPR7gU4GizCvffADo5M29wA@mail.gmail.com>
In-Reply-To: <CAEf4BzaGcM6ose=2DJJO1qkRkiqEPR7gU4GizCvffADo5M29wA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0179.namprd04.prod.outlook.com
 (2603:10b6:104:4::33) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::afeb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b75d144-bde5-4207-a08c-08d783e07410
x-ms-traffictypediagnostic: MN2PR15MB2526:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2526FF9B3C89831AB68FA61ED5530@MN2PR15MB2526.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(376002)(136003)(39860400002)(199004)(189003)(51914003)(54906003)(52116002)(71200400001)(86362001)(316002)(9686003)(2906002)(6512007)(5660300002)(6506007)(8936002)(6916009)(8676002)(81156014)(53546011)(81166006)(64756008)(66446008)(4326008)(66476007)(66556008)(478600001)(6486002)(66946007)(1076003)(186003)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2526;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZhFYhqK5yiNt9UPW9+vWWKIEu873KXkZsRnRwI6LIMoWM+JvEmWJPoBMksOsgAQmLEhZBWIgN16qniTly9+CBROOspqAKLS/Nhn1uYdNxbTWlCbX6NHTdqOP1HC4zmRu+7v7HOWoAx3/mTejlwaKGRuw6wCgh8Pts9OIvBRYCBHVAhXMbENtjykZnvdGIvcaNNmFfWbNc4XSKYdOc6H1HzafxDAWIdk9fE7qqZ33S5lI6MUhlMDPNJe3j7XbMzNsJAwS8VwxiQ5MUPDWnE5+HMoZUTBEZWFqI6QkEcxV2cdizSezpfF3iLTQfp1uOyDPEg2z5RmeYkj/EViQa8ODq4/s7/MvkR61dSEvD8/q0JAv8SY3ridA1nH+1roHIRVZQzft7vsiFazf74gfBk5nisAx70jo3HVYclbK0NUJMZjEGz0dVuew78TSBMsojOEx6BhgYujyFvcECzRVMz1h4lAk1dv1/zeS8MRWYPNOdALaJFWsNdTHzpNWeeFF5NdJOJalbCGbY0b0GJtg+6b+3Q==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <460D7FCB3023F84EAB350BB63CFB8696@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b75d144-bde5-4207-a08c-08d783e07410
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 17:33:54.1622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ka0a1T5rFVXszx9CBxdev2xLyA5BHz1H/Jxpk23A5ejFFZIEwz/MSXwZur4dLuBG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2526
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_05:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 08:34:25AM -0800, Andrii Nakryiko wrote:
> On Tue, Dec 17, 2019 at 11:03 PM Martin Lau <kafai@fb.com> wrote:
> >
> > On Tue, Dec 17, 2019 at 07:07:23PM -0800, Andrii Nakryiko wrote:
> > > On Fri, Dec 13, 2019 at 4:48 PM Martin KaFai Lau <kafai@fb.com> wrote=
:
> > > >
> > > > This patch adds BPF STRUCT_OPS support to libbpf.
> > > >
> > > > The only sec_name convention is SEC("struct_ops") to identify the
> > > > struct ops implemented in BPF, e.g.
> > > > SEC("struct_ops")
> > > > struct tcp_congestion_ops dctcp =3D {
> > > >         .init           =3D (void *)dctcp_init,  /* <-- a bpf_prog =
*/
> > > >         /* ... some more func prts ... */
> > > >         .name           =3D "bpf_dctcp",
> > > > };
> > > >
> > > > In the bpf_object__open phase, libbpf will look for the "struct_ops=
"
> > > > elf section and find out what is the btf-type the "struct_ops" is
> > > > implementing.  Note that the btf-type here is referring to
> > > > a type in the bpf_prog.o's btf.  It will then collect (through SHT_=
REL)
> > > > where are the bpf progs that the func ptrs are referring to.
> > > >
> > > > In the bpf_object__load phase, the prepare_struct_ops() will load
> > > > the btf_vmlinux and obtain the corresponding kernel's btf-type.
> > > > With the kernel's btf-type, it can then set the prog->type,
> > > > prog->attach_btf_id and the prog->expected_attach_type.  Thus,
> > > > the prog's properties do not rely on its section name.
> > > >
> > > > Currently, the bpf_prog's btf-type =3D=3D> btf_vmlinux's btf-type m=
atching
> > > > process is as simple as: member-name match + btf-kind match + size =
match.
> > > > If these matching conditions fail, libbpf will reject.
> > > > The current targeting support is "struct tcp_congestion_ops" which
> > > > most of its members are function pointers.
> > > > The member ordering of the bpf_prog's btf-type can be different fro=
m
> > > > the btf_vmlinux's btf-type.
> > > >
> > > > Once the prog's properties are all set,
> > > > the libbpf will proceed to load all the progs.
> > > >
> > > > After that, register_struct_ops() will create a map, finalize the
> > > > map-value by populating it with the prog-fd, and then register this
> > > > "struct_ops" to the kernel by updating the map-value to the map.
> > > >
> > > > By default, libbpf does not unregister the struct_ops from the kern=
el
> > > > during bpf_object__close().  It can be changed by setting the new
> > > > "unreg_st_ops" in bpf_object_open_opts.
> > > >
> > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > ---
> > >
> > > This looks pretty good to me. The big two things is exposing structop=
s
> > > as real struct bpf_map, so that users can interact with it using
> > > libbpf APIs, as well as splitting struct_ops map creation and
> > > registration. bpf_object__load() should only make sure all maps are
> > > created, progs are loaded/verified, but none of BPF program can yet b=
e
> > > called. Then attach is the phase where registration happens.
> > Thanks for the review.
> >
> > [ ... ]
> >
> > > >  static inline __u64 ptr_to_u64(const void *ptr)
> > > >  {
> > > >         return (__u64) (unsigned long) ptr;
> > > > @@ -233,6 +239,32 @@ struct bpf_map {
> > > >         bool reused;
> > > >  };
> > > >
> > > > +struct bpf_struct_ops {
> > > > +       const char *var_name;
> > > > +       const char *tname;
> > > > +       const struct btf_type *type;
> > > > +       struct bpf_program **progs;
> > > > +       __u32 *kern_func_off;
> > > > +       /* e.g. struct tcp_congestion_ops in bpf_prog's btf format =
*/
> > > > +       void *data;
> > > > +       /* e.g. struct __bpf_tcp_congestion_ops in btf_vmlinux's bt=
f
> > >
> > > Using __bpf_ prefix for this struct_ops-specific types is a bit too
> > > generic (e.g., for raw_tp stuff Alexei used btf_trace_). So maybe mak=
e
> > > it btf_ops_ or btf_structops_?
> > Is it a concern on name collision?
> >
> > The prefix pick is to use a more representative name.
> > struct_ops use many bpf pieces and btf is one of them.
> > Very soon, all new codes will depend on BTF and btf_ prefix
> > could become generic also.
> >
> > Unlike tracepoint, there is no non-btf version of struct_ops.
>=20
> Not so much name collision, as being able to immediately recognize
> that it's used to provide type information for struct_ops. Think about
> some automated tooling parsing vmlinux BTF and trying to create some
> derivative types for those btf_trace_xxx and __bpf_xxx types. Having
> unique prefix that identifies what kind of type-providing struct it is
> is very useful to do generic tool like that. While __bpf_ isn't
> specifying in any ways that it's for struct_ops.
>=20
> >
> > >
> > >
> > > > +        * format.
> > > > +        * struct __bpf_tcp_congestion_ops {
> > > > +        *      [... some other kernel fields ...]
> > > > +        *      struct tcp_congestion_ops data;
> > > > +        * }
> > > > +        * kern_vdata in the sizeof(struct __bpf_tcp_congestion_ops=
).
> > >
> > > Comment isn't very clear.. do you mean that data pointed to by
> > > kern_vdata is of sizeof(...) bytes?
> > >
> > > > +        * prepare_struct_ops() will populate the "data" into
> > > > +        * "kern_vdata".
> > > > +        */
> > > > +       void *kern_vdata;
> > > > +       __u32 type_id;
> > > > +       __u32 kern_vtype_id;
> > > > +       __u32 kern_vtype_size;
> > > > +       int fd;
> > > > +       bool unreg;
> > >
> > > This unreg flag (and default behavior to not unregister) is bothering
> > > me a bit.. Shouldn't this be controlled by map's lifetime, at least.
> > > E.g., if no one pins that map - then struct_ops should be unregistere=
d
> > > on map destruction. If application wants to keep BPF programs
> > > attached, it should make sure to pin map, before userspace part exits=
?
> > > Is this problematic in any way?
> > I don't think it should in the struct_ops case.  I think of the
> > struct_ops map is a set of progs "attach" to a subsystem (tcp_cong
> > in this case) and this map-progs stay (or keep attaching) until it is
> > detached.  Like other attached bpf_prog keeps running without
> > caring if the bpf_prog is pinned or not.
>=20
> I'll let someone else comment on how this behaves for cgroup, xdp,
> etc,
> but for tracing, for example, we have FD-based BPF links, which
> will detach program automatically when FD is closed. I think the idea
> is to extend this to other types of BPF programs as well, so there is
> no risk of leaving some stray BPF program running after unintended
Like xdp_prog, struct_ops does not have another fd-based-link.
This link can be created for struct_ops, xdp_prog and others later.
I don't see a conflict here.

> crash of userspace program. When application explicitly needs BPF
> program to outlive its userspace control app, then this can be
> achieved by pinning map/program in BPFFS.
If the concern is about not leaving struct_ops behind,
lets assume there is no "detach" and only depends on the very
last userspace's handles (FD/pinned) of a map goes away,
what may be an easy way to remove bpf_cubic from the system:

[root@arch-fb-vm1 bpf]# sysctl -a | egrep congestion
    net.ipv4.tcp_allowed_congestion_control =3D reno cubic bpf_cubic
    net.ipv4.tcp_available_congestion_control =3D reno bic cubic bpf_cubic
    net.ipv4.tcp_congestion_control =3D bpf_cubic

>=20
> >
> > About the "bool unreg;", the default can be changed to true if
> > it makes more sense.
> >
