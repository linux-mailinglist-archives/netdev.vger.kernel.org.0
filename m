Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9C5124002
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 08:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfLRHEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 02:04:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19060 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbfLRHEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 02:04:06 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBI6xbM7018149;
        Tue, 17 Dec 2019 23:03:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=OWecHGVWNZNCYkAZs5CAWIW52T0wXqBATapQ9Hc5LDk=;
 b=bKCFA2HDTm/WrMMG8d0C+1B/8jZgazSMlQruytekeXCvtot45TdqPCv59XmzUpPek4sw
 Gs7CNebNE1tP3lhgJA0l+Mlx4vgXyIYLUawNsfPuTdF7mHA2HKzjUgrax5j7XaLm5jaX
 AQmLXNnrXmtVoBQlQJMZd9iROKNtTdYqPoc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wy0vt41x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 23:03:49 -0800
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 17 Dec 2019 23:03:48 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 17 Dec 2019 23:03:47 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 17 Dec 2019 23:03:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqbZ1FpgwY50aNygEzOZpiqodAQbVLn5M3b4Bt86pumg4w2PhYdc3M7+fxHsVMcGSczhcRB/LGKCmyEgXHuJ2jVhfFwa4v72wEWo1lgF+w1tgdgy8IOQrnnCvDbWHua1AD6P6+OO5U74IFxpdnU36abkAH2ScnIZOgbdiru1eIDVGbbhKuPfjg8SNBxU6JuSOww5ho0HsoH++80KU/9oJ8WcRnCihgXprxLpkq1GV/uqC6xJ5CTLq9TQFfIYHDpT3qEgS4AZu9I/BDYNDBGMWOpKl/Pic1ae/lHV9r33jippIUE0JvmYhb+BXpPnoU+VK1wJZb/L4+za8FmVFYXWWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWecHGVWNZNCYkAZs5CAWIW52T0wXqBATapQ9Hc5LDk=;
 b=ncSrY4aG2PRZ48K+Mcs6SiMquXYwJTV8FX8av8JjwbW65f9KkeHp7LtMckQw0FTsGrVrOMt5KLldP5isffCvPoa8U+uOKhB3SBPrP+0LCz2wEQbqs++xh61dCTHOHt4JS8BQ5mNhFBQ+sjjPOS5MlpWrcJRTHijrg5ol8HJXPA3XxDsK68sxOlccOPlxZOATcBXp2yVybdk9G75xpUVSiR6yyDkbr07gaLeDaEIRgysi+HDHHU5eEsFExe/hO5QMWqXOdTquzPLNRQxq5hoeYC0qM7CxQrJR904Muidby1Gf2O/uapI7HZw0StlChmPr/l6vDzjrWurchnpIv2bRWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWecHGVWNZNCYkAZs5CAWIW52T0wXqBATapQ9Hc5LDk=;
 b=Yp1KsQO3kk2rn9VJ/6NjEykT59t4muzLvZBhPzxdUmhbNt9MpQsXV8yNiyMCR3C83UUzZohTdydUdkspgbFDVo1WuRYp94E3jUfovEbAtwGi2M99R7Lk3ayNrDWN6iiRB2YwQCgUnUw4jiGM7r8ipw9KYDeZIvHAoSSovaGl8JY=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3598.namprd15.prod.outlook.com (52.132.175.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 07:03:46 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 07:03:46 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 11/13] bpf: libbpf: Add STRUCT_OPS support
Thread-Topic: [PATCH bpf-next 11/13] bpf: libbpf: Add STRUCT_OPS support
Thread-Index: AQHVshgyWEoHfLDvE0Suwi3j+8Waaae/PFiAgABCBoA=
Date:   Wed, 18 Dec 2019 07:03:45 +0000
Message-ID: <20191218070341.fd2ypexmeca5cefa@kafai-mbp.dhcp.thefacebook.com>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004803.1653618-1-kafai@fb.com>
 <CAEf4BzbJoso7A0dn=xhOkFMOcKqZ6wYp=XoqGiL+FO+0VKqh5g@mail.gmail.com>
In-Reply-To: <CAEf4BzbJoso7A0dn=xhOkFMOcKqZ6wYp=XoqGiL+FO+0VKqh5g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0101.namprd05.prod.outlook.com
 (2603:10b6:104:1::27) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::ce61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc3193a7-f164-4232-0255-08d783886c42
x-ms-traffictypediagnostic: MN2PR15MB3598:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB35989E61F9465FBADFA973B3D5530@MN2PR15MB3598.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(346002)(376002)(136003)(396003)(51914003)(199004)(189003)(66556008)(53546011)(316002)(66476007)(8936002)(8676002)(71200400001)(64756008)(2906002)(6506007)(66446008)(66946007)(81166006)(81156014)(5660300002)(478600001)(1076003)(6916009)(86362001)(6512007)(9686003)(186003)(4326008)(52116002)(54906003)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3598;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Srq4CKw+0TXQ49zpbb3S5fiFxIv0I5cAUst/NMSHvVAEd8+3E2lxnrz46F3mF9o9+p2Q+U43/A6lgG6rVzlsK3NllVKUEjmdU4m3O51KrFFdhisJdAMpgt04fHPv9MU8qw4WJPLxPYZP2JzwKgcZUejYBgKuS9MsUqqBLiFr3YbsILRxC46f1KVxRD8sprbPdybI5Psa1aYBOd+Fs/Z5kvWc0IQ+xE/ASKEOvoso+e+VWYFX4pnOZ7DdU46O7vQ+5gyuH8d61QHUlp9L5YAAy2FEyWhsNTf3pTWPFnXU9f9TwQIPC+ntmfUF41rjUZvRBR4A4c/PaU1Yx5bUTGE6vkCc51iYX+6pAWBYxzcKgv7ahqfg45SuAqxMPl9XvMmrV7G9iErfU6RYAP4KmVui8QMq8blm47ibEYj0IyIQa367kMX5awWVNuvg+ta2pT4ClPBGB4hCZ6nKlHwGPjBO6tdoAtwZ1XikrNYGaoB1A8rAB4qOWI3JxCONUtelvU1Q
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C25927E2A44D484693D29D1BB75165EE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cc3193a7-f164-4232-0255-08d783886c42
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 07:03:45.7217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zBSaE3ogRDetj2+hl+2k9eD4LpABPiBA15iRBY5bWxs0dp5U01P0uDoq5KMmuOq1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3598
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_01:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 07:07:23PM -0800, Andrii Nakryiko wrote:
> On Fri, Dec 13, 2019 at 4:48 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch adds BPF STRUCT_OPS support to libbpf.
> >
> > The only sec_name convention is SEC("struct_ops") to identify the
> > struct ops implemented in BPF, e.g.
> > SEC("struct_ops")
> > struct tcp_congestion_ops dctcp =3D {
> >         .init           =3D (void *)dctcp_init,  /* <-- a bpf_prog */
> >         /* ... some more func prts ... */
> >         .name           =3D "bpf_dctcp",
> > };
> >
> > In the bpf_object__open phase, libbpf will look for the "struct_ops"
> > elf section and find out what is the btf-type the "struct_ops" is
> > implementing.  Note that the btf-type here is referring to
> > a type in the bpf_prog.o's btf.  It will then collect (through SHT_REL)
> > where are the bpf progs that the func ptrs are referring to.
> >
> > In the bpf_object__load phase, the prepare_struct_ops() will load
> > the btf_vmlinux and obtain the corresponding kernel's btf-type.
> > With the kernel's btf-type, it can then set the prog->type,
> > prog->attach_btf_id and the prog->expected_attach_type.  Thus,
> > the prog's properties do not rely on its section name.
> >
> > Currently, the bpf_prog's btf-type =3D=3D> btf_vmlinux's btf-type match=
ing
> > process is as simple as: member-name match + btf-kind match + size matc=
h.
> > If these matching conditions fail, libbpf will reject.
> > The current targeting support is "struct tcp_congestion_ops" which
> > most of its members are function pointers.
> > The member ordering of the bpf_prog's btf-type can be different from
> > the btf_vmlinux's btf-type.
> >
> > Once the prog's properties are all set,
> > the libbpf will proceed to load all the progs.
> >
> > After that, register_struct_ops() will create a map, finalize the
> > map-value by populating it with the prog-fd, and then register this
> > "struct_ops" to the kernel by updating the map-value to the map.
> >
> > By default, libbpf does not unregister the struct_ops from the kernel
> > during bpf_object__close().  It can be changed by setting the new
> > "unreg_st_ops" in bpf_object_open_opts.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
>=20
> This looks pretty good to me. The big two things is exposing structops
> as real struct bpf_map, so that users can interact with it using
> libbpf APIs, as well as splitting struct_ops map creation and
> registration. bpf_object__load() should only make sure all maps are
> created, progs are loaded/verified, but none of BPF program can yet be
> called. Then attach is the phase where registration happens.
Thanks for the review.

[ ... ]

> >  static inline __u64 ptr_to_u64(const void *ptr)
> >  {
> >         return (__u64) (unsigned long) ptr;
> > @@ -233,6 +239,32 @@ struct bpf_map {
> >         bool reused;
> >  };
> >
> > +struct bpf_struct_ops {
> > +       const char *var_name;
> > +       const char *tname;
> > +       const struct btf_type *type;
> > +       struct bpf_program **progs;
> > +       __u32 *kern_func_off;
> > +       /* e.g. struct tcp_congestion_ops in bpf_prog's btf format */
> > +       void *data;
> > +       /* e.g. struct __bpf_tcp_congestion_ops in btf_vmlinux's btf
>=20
> Using __bpf_ prefix for this struct_ops-specific types is a bit too
> generic (e.g., for raw_tp stuff Alexei used btf_trace_). So maybe make
> it btf_ops_ or btf_structops_?
Is it a concern on name collision?

The prefix pick is to use a more representative name.
struct_ops use many bpf pieces and btf is one of them.
Very soon, all new codes will depend on BTF and btf_ prefix
could become generic also.

Unlike tracepoint, there is no non-btf version of struct_ops. =20

>=20
>=20
> > +        * format.
> > +        * struct __bpf_tcp_congestion_ops {
> > +        *      [... some other kernel fields ...]
> > +        *      struct tcp_congestion_ops data;
> > +        * }
> > +        * kern_vdata in the sizeof(struct __bpf_tcp_congestion_ops).
>=20
> Comment isn't very clear.. do you mean that data pointed to by
> kern_vdata is of sizeof(...) bytes?
>=20
> > +        * prepare_struct_ops() will populate the "data" into
> > +        * "kern_vdata".
> > +        */
> > +       void *kern_vdata;
> > +       __u32 type_id;
> > +       __u32 kern_vtype_id;
> > +       __u32 kern_vtype_size;
> > +       int fd;
> > +       bool unreg;
>=20
> This unreg flag (and default behavior to not unregister) is bothering
> me a bit.. Shouldn't this be controlled by map's lifetime, at least.
> E.g., if no one pins that map - then struct_ops should be unregistered
> on map destruction. If application wants to keep BPF programs
> attached, it should make sure to pin map, before userspace part exits?
> Is this problematic in any way?
I don't think it should in the struct_ops case.  I think of the
struct_ops map is a set of progs "attach" to a subsystem (tcp_cong
in this case) and this map-progs stay (or keep attaching) until it is
detached.  Like other attached bpf_prog keeps running without
caring if the bpf_prog is pinned or not.

About the "bool unreg;", the default can be changed to true if
it makes more sense.

[ ... ]

>=20
> > +
> > +               kern_data =3D st_ops->kern_vdata + st_ops->kern_func_of=
f[i];
> > +               *(unsigned long *)kern_data =3D prog_fd;
> > +       }
> > +
> > +       map_attr.map_type =3D BPF_MAP_TYPE_STRUCT_OPS;
> > +       map_attr.key_size =3D sizeof(unsigned int);
> > +       map_attr.value_size =3D st_ops->kern_vtype_size;
> > +       map_attr.max_entries =3D 1;
> > +       map_attr.btf_fd =3D btf__fd(obj->btf);
> > +       map_attr.btf_vmlinux_value_type_id =3D st_ops->kern_vtype_id;
> > +       map_attr.name =3D st_ops->var_name;
> > +
> > +       fd =3D bpf_create_map_xattr(&map_attr);
>=20
> we should try to reuse bpf_object__init_internal_map(). This will add
> struct bpf_map which users can iterate over and look up by name, etc.
> We had similar discussion when Daniel was adding  global data maps,
> and we conclusively decided that these special maps have to be
> represented in libbpf as struct bpf_map as well.
I will take a look.

>=20
> > +       if (fd < 0) {
> > +               err =3D -errno;
> > +               pr_warn("struct_ops register %s: Error in creating stru=
ct_ops map\n",
> > +                       tname);
> > +               return err;
> > +       }
> > +
> > +       err =3D bpf_map_update_elem(fd, &zero, st_ops->kern_vdata, 0);
