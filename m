Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C73012BC26
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 02:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfL1Bru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 20:47:50 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12772 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725820AbfL1Bru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 20:47:50 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBS1l1B6012546;
        Fri, 27 Dec 2019 17:47:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Vm0qAP7WOQa1jYDwQbJCsFplP/+Wb+t29LeU+vSfKfI=;
 b=rMWbpUvrEfQHeM5AyS49KUREgaMm7+S9Q725yFd1weZSBAqqpcQBXg6yEk0ME9L1+vNI
 MMIrsmoYcKg23SMFBaSrR16+guDNZjB2dtjMqOskIBfAOmfSsadmPSL4glYUaYDGwc+9
 B3n0Wz5VdIxlebYX6h97bo7TiIm4QbshwAU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2x54jqmu71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 27 Dec 2019 17:47:34 -0800
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 27 Dec 2019 17:47:33 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 27 Dec 2019 17:47:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gl1p18BFrRi7xTsj6rJMEkAavbykpVt7RM6mPA6ErXWgNc207j8t27gJ6nPUgi+OeXeeJKDCiyws5b513d5C9t1QU0mxoHEOSID8K4I/F5PWjiWcVmX3f03GdFWhwivkxcJIfb51IWw9RouJAPF6BXc7fXwZyvHek7z5aXAC2di9PoAA+JTc+MRxaeJCgT+hA4/YGWejJHarRPcG8svunzoA8BBLpNOtdPoO276qD053t8b50isGadpQ0/6E3b5BX2o/aVBwi6zDf/03X6dOcQkLFD1pgxgrJwqqSqQ13bW1Odcvdf3juC2qM9a/apKNw0wpZp99GHl71eBpX1+WwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vm0qAP7WOQa1jYDwQbJCsFplP/+Wb+t29LeU+vSfKfI=;
 b=Nh6puNt2JkPYzQcsliysKxTsmdEGtmzXuE/Ssy5yCjyBX6eQd3r1uslTgjlAiaAW1L2umvZNlXIs0ZNyW7iwPgL8fKGF1cmDu9S1MeumG5yNHRQC7xZ3j98F7ODpIeDzwp8JXTzOY7S46PQzrYuIM8KKkjrORvs9HOsKHmFIicHUnTAH78jaaTELqAifsNv0hGVaYogIzsBAjt0KndmtSH01bSOpkDF51LDheXw9cUHj5Bjn2LfyPjF4pp0uSlL99doSSOdpqB9Gcr36lpxIyTcRfa93w37y+slxNonXkB8e/sWTgKgpbtp1/Bfs59klW5N/riZfoufXd6b6i2RJmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vm0qAP7WOQa1jYDwQbJCsFplP/+Wb+t29LeU+vSfKfI=;
 b=kNBuEo/2LfRfxR06x7jEMNEhPmiaYX8buIGgEc1PlqOOE3lgkYKJGZfABU3Hmav/d3qhKwG3nCsoZhL6atJkIqEu9ISiWKDXWmJuHNuTUWqfBugD/0RxLQMMHCalTImrXRrkCuVRvo7s2Liyo+/zjnkfeXgnp3vCbZ2aZf+SofE=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2799.namprd15.prod.outlook.com (20.179.147.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Sat, 28 Dec 2019 01:47:18 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2559.017; Sat, 28 Dec 2019
 01:47:18 +0000
Received: from kafai-mbp (2620:10d:c090:180::1d90) by MWHPR10CA0067.namprd10.prod.outlook.com (2603:10b6:300:2c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Sat, 28 Dec 2019 01:47:16 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Topic: [PATCH bpf-next v2 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Index: AQHVt8eKCw0H8YSIj0iyCJPN6l8CHKfIW0cAgAZ2ngA=
Date:   Sat, 28 Dec 2019 01:47:17 +0000
Message-ID: <20191228014714.kdn4kulywefenf2y@kafai-mbp>
References: <20191221062556.1182261-1-kafai@fb.com>
 <20191221062608.1183091-1-kafai@fb.com>
 <CAEf4BzZ0fb5ecoCJTt+7j2rxoP3QnVBivHjg8GDLofR4sLFU7w@mail.gmail.com>
In-Reply-To: <CAEf4BzZ0fb5ecoCJTt+7j2rxoP3QnVBivHjg8GDLofR4sLFU7w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR10CA0067.namprd10.prod.outlook.com
 (2603:10b6:300:2c::29) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1d90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45b1c4b0-902f-4469-92a1-08d78b37defa
x-ms-traffictypediagnostic: MN2PR15MB2799:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB279943574439A64BB824FFF5D5250@MN2PR15MB2799.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 02652BD10A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(396003)(39860400002)(346002)(366004)(43544003)(189003)(199004)(52116002)(6496006)(55016002)(86362001)(316002)(53546011)(33716001)(6916009)(9686003)(4326008)(54906003)(478600001)(186003)(5660300002)(16526019)(66556008)(71200400001)(64756008)(8936002)(8676002)(66446008)(66476007)(66946007)(81166006)(1076003)(2906002)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2799;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UEltJShYPQo8t/7pthYRxBU5EA+o4/tJdjyO22Vhk9T7nM/HDoKQXdtSi7UO6mlCHNC/15QT/gZghd8/ZiJEzNiBal3UrKyW7sBkupJMIokvP3OKFTQDuu93ZM2XhttISTUc/U/UoAiYnUO4fE3ar/YU1gK/GBQCBv1m3iaXEks3rOix9TpFkZaOmTPLi0HNdxQQlIL03SpSVFrKBGEXA5DZ3FGijNhoOd8KRyIYZUbdjM6EHCnhd0JME/co5Q3ATTKvnXKy0PigqSu/D00cu6rSbG5yU4QzgTPw0d2v1WdSpiDGnBAJox2Iv1f6FQLjwrh49+5lNk0BvW4LB4567CNIOTpbRs6RSWYVLzV1rTewv6ZB/wxRXaA2eTsfWorQch34mZdQwMLLaUNOo6yiR+/5H70YZRdFLnefkvsASFKrzJve7/o+1nYz9Eoa3CH8z2oWU7IHi1FQoIj7DmPLbgwtKYXlUilWUckDQCJmu8A2hYNypY5zNGZDeuAQJG6G
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5807F18E4F872E49BFE669B1FBCCA02A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 45b1c4b0-902f-4469-92a1-08d78b37defa
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2019 01:47:17.8039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xy4S8M2XRIHN9l08JkYwiATYv1ghSnvmuwKiv6c7QpSdpHkCXk0SkbGNfRWoCbF9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2799
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-27_07:2019-12-27,2019-12-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 spamscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912280015
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 03:05:08PM -0800, Andrii Nakryiko wrote:
> On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > The patch introduces BPF_MAP_TYPE_STRUCT_OPS.  The map value
> > is a kernel struct with its func ptr implemented in bpf prog.
> > This new map is the interface to register/unregister/introspect
> > a bpf implemented kernel struct.
> >
> > The kernel struct is actually embedded inside another new struct
> > (or called the "value" struct in the code).  For example,
> > "struct tcp_congestion_ops" is embbeded in:
> > struct bpf_struct_ops_tcp_congestion_ops {
> >         refcount_t refcnt;
> >         enum bpf_struct_ops_state state;
> >         struct tcp_congestion_ops data;  /* <-- kernel subsystem struct=
 here */
> > }
> > The map value is "struct bpf_struct_ops_tcp_congestion_ops".
> > The "bpftool map dump" will then be able to show the
> > state ("inuse"/"tobefree") and the number of subsystem's refcnt (e.g.
> > number of tcp_sock in the tcp_congestion_ops case).  This "value" struc=
t
> > is created automatically by a macro.  Having a separate "value" struct
> > will also make extending "struct bpf_struct_ops_XYZ" easier (e.g. addin=
g
> > "void (*init)(void)" to "struct bpf_struct_ops_XYZ" to do some
> > initialization works before registering the struct_ops to the kernel
> > subsystem).  The libbpf will take care of finding and populating the
> > "struct bpf_struct_ops_XYZ" from "struct XYZ".
> >
> > Register a struct_ops to a kernel subsystem:
> > 1. Load all needed BPF_PROG_TYPE_STRUCT_OPS prog(s)
> > 2. Create a BPF_MAP_TYPE_STRUCT_OPS with attr->btf_vmlinux_value_type_i=
d
> >    set to the btf id "struct bpf_struct_ops_tcp_congestion_ops" of the
> >    running kernel.
> >    Instead of reusing the attr->btf_value_type_id,
> >    btf_vmlinux_value_type_id s added such that attr->btf_fd can still b=
e
> >    used as the "user" btf which could store other useful sysadmin/debug
> >    info that may be introduced in the furture,
> >    e.g. creation-date/compiler-details/map-creator...etc.
> > 3. Create a "struct bpf_struct_ops_tcp_congestion_ops" object as descri=
bed
> >    in the running kernel btf.  Populate the value of this object.
> >    The function ptr should be populated with the prog fds.
> > 4. Call BPF_MAP_UPDATE with the object created in (3) as
> >    the map value.  The key is always "0".
> >
> > During BPF_MAP_UPDATE, the code that saves the kernel-func-ptr's
> > args as an array of u64 is generated.  BPF_MAP_UPDATE also allows
> > the specific struct_ops to do some final checks in "st_ops->init_member=
()"
> > (e.g. ensure all mandatory func ptrs are implemented).
> > If everything looks good, it will register this kernel struct
> > to the kernel subsystem.  The map will not allow further update
> > from this point.
> >
> > Unregister a struct_ops from the kernel subsystem:
> > BPF_MAP_DELETE with key "0".
> >
> > Introspect a struct_ops:
> > BPF_MAP_LOOKUP_ELEM with key "0".  The map value returned will
> > have the prog _id_ populated as the func ptr.
> >
> > The map value state (enum bpf_struct_ops_state) will transit from:
> > INIT (map created) =3D>
> > INUSE (map updated, i.e. reg) =3D>
> > TOBEFREE (map value deleted, i.e. unreg)
> >
> > The kernel subsystem needs to call bpf_struct_ops_get() and
> > bpf_struct_ops_put() to manage the "refcnt" in the
> > "struct bpf_struct_ops_XYZ".  This patch uses a separate refcnt
> > for the purose of tracking the subsystem usage.  Another approach
> > is to reuse the map->refcnt and then "show" (i.e. during map_lookup)
> > the subsystem's usage by doing map->refcnt - map->usercnt to filter out
> > the map-fd/pinned-map usage.  However, that will also tie down the
> > future semantics of map->refcnt and map->usercnt.
> >
> > The very first subsystem's refcnt (during reg()) holds one
> > count to map->refcnt.  When the very last subsystem's refcnt
> > is gone, it will also release the map->refcnt.  All bpf_prog will be
> > freed when the map->refcnt reaches 0 (i.e. during map_free()).
> >
> > Here is how the bpftool map command will look like:
> > [root@arch-fb-vm1 bpf]# bpftool map show
> > 6: struct_ops  name dctcp  flags 0x0
> >         key 4B  value 256B  max_entries 1  memlock 4096B
> >         btf_id 6
> > [root@arch-fb-vm1 bpf]# bpftool map dump id 6
> > [{
> >         "value": {
> >             "refcnt": {
> >                 "refs": {
> >                     "counter": 1
> >                 }
> >             },
> >             "state": 1,
> >             "data": {
> >                 "list": {
> >                     "next": 0,
> >                     "prev": 0
> >                 },
> >                 "key": 0,
> >                 "flags": 2,
> >                 "init": 24,
> >                 "release": 0,
> >                 "ssthresh": 25,
> >                 "cong_avoid": 30,
> >                 "set_state": 27,
> >                 "cwnd_event": 28,
> >                 "in_ack_event": 26,
> >                 "undo_cwnd": 29,
> >                 "pkts_acked": 0,
> >                 "min_tso_segs": 0,
> >                 "sndbuf_expand": 0,
> >                 "cong_control": 0,
> >                 "get_info": 0,
> >                 "name": [98,112,102,95,100,99,116,99,112,0,0,0,0,0,0,0
> >                 ],
> >                 "owner": 0
> >             }
> >         }
> >     }
> > ]
> >
> > Misc Notes:
> > * bpf_struct_ops_map_sys_lookup_elem() is added for syscall lookup.
> >   It does an inplace update on "*value" instead returning a pointer
> >   to syscall.c.  Otherwise, it needs a separate copy of "zero" value
> >   for the BPF_STRUCT_OPS_STATE_INIT to avoid races.
> >
> > * The bpf_struct_ops_map_delete_elem() is also called without
> >   preempt_disable() from map_delete_elem().  It is because
> >   the "->unreg()" may requires sleepable context, e.g.
> >   the "tcp_unregister_congestion_control()".
> >
> > * "const" is added to some of the existing "struct btf_func_model *"
> >   function arg to avoid a compiler warning caused by this patch.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
>=20
> LGTM! Few questions below to improve my understanding.
>=20
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>=20
> >  arch/x86/net/bpf_jit_comp.c |  11 +-
> >  include/linux/bpf.h         |  49 +++-
> >  include/linux/bpf_types.h   |   3 +
> >  include/linux/btf.h         |  13 +
> >  include/uapi/linux/bpf.h    |   7 +-
> >  kernel/bpf/bpf_struct_ops.c | 468 +++++++++++++++++++++++++++++++++++-
> >  kernel/bpf/btf.c            |  20 +-
> >  kernel/bpf/map_in_map.c     |   3 +-
> >  kernel/bpf/syscall.c        |  49 ++--
> >  kernel/bpf/trampoline.c     |   5 +-
> >  kernel/bpf/verifier.c       |   5 +
> >  11 files changed, 593 insertions(+), 40 deletions(-)
> >
>=20
> [...]
>=20
> > +               /* All non func ptr member must be 0 */
> > +               if (!btf_type_resolve_func_ptr(btf_vmlinux, member->typ=
e,
> > +                                              NULL)) {
> > +                       u32 msize;
> > +
> > +                       mtype =3D btf_resolve_size(btf_vmlinux, mtype,
> > +                                                &msize, NULL, NULL);
> > +                       if (IS_ERR(mtype)) {
> > +                               err =3D PTR_ERR(mtype);
> > +                               goto reset_unlock;
> > +                       }
> > +
> > +                       if (memchr_inv(udata + moff, 0, msize)) {
>=20
>=20
> just double-checking: we are ok with having non-zeroed padding in a
> struct, is that right?
Sorry for the delay.

You meant the end-padding of the kernel side struct (i.e. kdata (or kvalue)=
)
could be non-zero?  The btf's struct size (i.e. vt->size) should include
the padding and the whole vt->size is init to 0.

or you meant the user passed in udata (or uvalue)?

>=20
> > +                               err =3D -EINVAL;
> > +                               goto reset_unlock;
> > +                       }
> > +
> > +                       continue;
> > +               }
> > +
>=20
> [...]
>=20
> > +
> > +               err =3D arch_prepare_bpf_trampoline(image,
> > +                                                 &st_ops->func_models[=
i], 0,
> > +                                                 &prog, 1, NULL, 0, NU=
LL);
> > +               if (err < 0)
> > +                       goto reset_unlock;
> > +
> > +               *(void **)(kdata + moff) =3D image;
> > +               image +=3D err;
>=20
> are there any alignment requirements on image pointer for trampoline?
Not that I know of from reading arch_prepare_bpf_trampoline()
which also can generate codes to call multiple bpf_prog.

>=20
> > +
> > +               /* put prog_id to udata */
> > +               *(unsigned long *)(udata + moff) =3D prog->aux->id;
> > +       }
> > +
>=20
> [...]
