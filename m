Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5CAA129B68
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 23:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfLWWPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 17:15:25 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45718 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726817AbfLWWPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 17:15:24 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBNM4vF5005415;
        Mon, 23 Dec 2019 14:15:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=eaYs8P69FbEqgv2Nz/jNZsPinGwZC7eE0x89B0VMUoA=;
 b=DBBFShhp9Zk73Dw0Wtt7WjlcFGMbEUxg0TvzzEcT4KZrgcA/BUHTHOWGTkWrYCcXPP2n
 vSChejoPLim3b3waMbpvgWuhgzzYEWOBGPPhnQl9MiaOJcyB6YjGikxhFKx35lKj18W6
 xVeEjw9yECdmHljT2L8pTGLgOC+sUD+Y5Tk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2x1fs59evd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 Dec 2019 14:15:09 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 23 Dec 2019 14:15:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ed/uhiXYCjYD56hBx3IPLOTLI0b75aMQek6KhyIpL6Oky8yf2apyY4QDKqKORdYZ1GB6g8yYbS5mGNe50sdCX7qkzKu33lSEjc+lTJ+K+a0+Awimqt95/kFjvYzzzQK71+iwFj2ugaftXp0tt62q+3o22j8gC5XRESqvxhaJ3eDwU9edlz0QclUGCpfCg2gOp0YvVExgDBBF+SFbOrZraIUdPEEBFoAMXsYmgxzll6KszFgkmmqjfcy8ge5poCVeQSoLyQXmLFgF+Cqiw3u1wbFuVDxbx5ua7YHzEAEZC1wI3/0nQ8/t5kbyUxzo5YXfPeQ4jcHKXAiVitqc6JDZjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaYs8P69FbEqgv2Nz/jNZsPinGwZC7eE0x89B0VMUoA=;
 b=VFiG/9XAglhk1tg7CGKVtHaW02oFlVy2RwTUIsiJrCro8aNU8CqL214UZ1sw0iJBimqNIndQOz0/ADpPUh9IW+u59nC5BVigQtx0rI2kEtCxCRoBlUGfYiTnVuxG1ZFEzFma7MNlufh0o6mXrp9NQvnsJb+/CDxxQ8ClHA7yz3pkz29dJiTqmltcs4R7Xx2O7cj96QWOzhKncgmIkUUjKZ6isxpdlKZNyToB0fiElrNdBp6LoJLJQRaG1hCCDMWMVYsAUQDxkiUnNZ1ILulGIoXSKPz43WHJ4uHGJiLQ6H2j6Tm+e5MeMzBKbpF5devDHzKAe6VbY9scpmGZh8cGLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaYs8P69FbEqgv2Nz/jNZsPinGwZC7eE0x89B0VMUoA=;
 b=W8UFPkpEp665BiEHN6V5GsFgC7+RYaeYWwb9b4dZLMdKB1uRg3Fcys6ZeHvf7xSdZXry51mhHpZ1mfaeYwHxeomp9Dk1v8zrvYnyel501t0t8d44tWaR/AsMWcgsmy9rSvcb1+wDU88bJRlH+B7bxI1ms0i3BuseZLFQe+5lvYg=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3072.namprd15.prod.outlook.com (20.178.254.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Mon, 23 Dec 2019 22:15:07 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 22:15:07 +0000
Received: from kafai-mbp (2620:10d:c090:180::535) by MWHPR1401CA0008.namprd14.prod.outlook.com (2603:10b6:301:4b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.13 via Frontend Transport; Mon, 23 Dec 2019 22:15:05 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Topic: [PATCH bpf-next v2 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Index: AQHVt8eKCw0H8YSIj0iyCJPN6l8CHKfIJvAAgAAdz4CAAAiJAA==
Date:   Mon, 23 Dec 2019 22:15:07 +0000
Message-ID: <20191223221502.wgjoqqofc44zdxht@kafai-mbp>
References: <20191221062556.1182261-1-kafai@fb.com>
 <20191221062608.1183091-1-kafai@fb.com>
 <921201ff-8c8d-b523-5df6-3326f6cd0fd9@fb.com>
 <CAEf4BzYU723WmF=ik26DOS7fAmpiju2rpgJyEZXB0ENF9VNyeA@mail.gmail.com>
In-Reply-To: <CAEf4BzYU723WmF=ik26DOS7fAmpiju2rpgJyEZXB0ENF9VNyeA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0008.namprd14.prod.outlook.com
 (2603:10b6:301:4b::18) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::535]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c07c5087-6b33-41dd-8f74-08d787f5915b
x-ms-traffictypediagnostic: MN2PR15MB3072:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB3072E219B3B76DE4168B522BD52E0@MN2PR15MB3072.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(346002)(136003)(366004)(39860400002)(43544003)(189003)(199004)(2906002)(66446008)(66556008)(64756008)(66476007)(33716001)(66946007)(6496006)(5660300002)(86362001)(53546011)(52116002)(1076003)(71200400001)(316002)(81156014)(81166006)(8676002)(54906003)(9686003)(110136005)(186003)(55016002)(16526019)(4326008)(6636002)(8936002)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3072;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q69P8gy4B8bx7sxU+XVqrXcphrAGMGtcwam19NcZjFUvKEToxN9NQzlXUWFx9QdpJfbdyQ2g982kj4d/NCYgpJEY0BGQSWZzOFRdZLNwd/MVG0+k3oWXZxIOeSW3xWLs+Qv9TAeqgAlHrEcjden8CIPwb/chN6fAIxbkgINBtCsxCG145zomMthOGjWXwdRlSbM0ISa8p5kVeH1TQk2cKOpI+I55vz4hhDUO7MtWwSTGj78zCGMwVvUu+SHusabmNqUXzrpuWti4ZtckIaLjgiS4olzIG6wkcvHS0U3kjdQz1usOi+Evk/FgH2V101n9KoBR/UeBWZMBkcJp5eSq2ebRybeDmQ7ifbybjwXaAkUJBM8/qu1h+lA5lradJArn+48qWFm3sa/FWGAXc/jpI3Ks/BwoySI0wNb35tIjJF+QFnlDvJ16oTf5fnWSYNR2x2fcrwqxgR0gp1AkYeh8tYkMBxAFyR0snZiODontn2nz2zTepkODo/R18JuS4f6h
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C302F18F51E29F44A7F3C8835EDCB7B2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c07c5087-6b33-41dd-8f74-08d787f5915b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 22:15:07.4287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jLrQB5KOZytjRNHN731w1T2a+IoZ5i0lFf140c7iTj6FtEuO69/iPaWDDEeRe+DY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3072
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_09:2019-12-23,2019-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912230192
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 01:44:29PM -0800, Andrii Nakryiko wrote:
> On Mon, Dec 23, 2019 at 11:58 AM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 12/20/19 10:26 PM, Martin KaFai Lau wrote:
> > > The patch introduces BPF_MAP_TYPE_STRUCT_OPS.  The map value
> > > is a kernel struct with its func ptr implemented in bpf prog.
> > > This new map is the interface to register/unregister/introspect
> > > a bpf implemented kernel struct.
> > >
> > > The kernel struct is actually embedded inside another new struct
> > > (or called the "value" struct in the code).  For example,
> > > "struct tcp_congestion_ops" is embbeded in:
> > > struct bpf_struct_ops_tcp_congestion_ops {
> > >       refcount_t refcnt;
> > >       enum bpf_struct_ops_state state;
> > >       struct tcp_congestion_ops data;  /* <-- kernel subsystem struct=
 here */
> > > }
> > > The map value is "struct bpf_struct_ops_tcp_congestion_ops".
> > > The "bpftool map dump" will then be able to show the
> > > state ("inuse"/"tobefree") and the number of subsystem's refcnt (e.g.
> > > number of tcp_sock in the tcp_congestion_ops case).  This "value" str=
uct
> > > is created automatically by a macro.  Having a separate "value" struc=
t
> > > will also make extending "struct bpf_struct_ops_XYZ" easier (e.g. add=
ing
> > > "void (*init)(void)" to "struct bpf_struct_ops_XYZ" to do some
> > > initialization works before registering the struct_ops to the kernel
> > > subsystem).  The libbpf will take care of finding and populating the
> > > "struct bpf_struct_ops_XYZ" from "struct XYZ".
> > >
> > > Register a struct_ops to a kernel subsystem:
> > > 1. Load all needed BPF_PROG_TYPE_STRUCT_OPS prog(s)
> > > 2. Create a BPF_MAP_TYPE_STRUCT_OPS with attr->btf_vmlinux_value_type=
_id
> > >     set to the btf id "struct bpf_struct_ops_tcp_congestion_ops" of t=
he
> > >     running kernel.
> > >     Instead of reusing the attr->btf_value_type_id,
> > >     btf_vmlinux_value_type_id s added such that attr->btf_fd can stil=
l be
> > >     used as the "user" btf which could store other useful sysadmin/de=
bug
> > >     info that may be introduced in the furture,
> > >     e.g. creation-date/compiler-details/map-creator...etc.
> > > 3. Create a "struct bpf_struct_ops_tcp_congestion_ops" object as desc=
ribed
> > >     in the running kernel btf.  Populate the value of this object.
> > >     The function ptr should be populated with the prog fds.
> > > 4. Call BPF_MAP_UPDATE with the object created in (3) as
> > >     the map value.  The key is always "0".
> > >
> > > During BPF_MAP_UPDATE, the code that saves the kernel-func-ptr's
> > > args as an array of u64 is generated.  BPF_MAP_UPDATE also allows
> > > the specific struct_ops to do some final checks in "st_ops->init_memb=
er()"
> > > (e.g. ensure all mandatory func ptrs are implemented).
> > > If everything looks good, it will register this kernel struct
> > > to the kernel subsystem.  The map will not allow further update
> > > from this point.
> > >
> > > Unregister a struct_ops from the kernel subsystem:
> > > BPF_MAP_DELETE with key "0".
> > >
> > > Introspect a struct_ops:
> > > BPF_MAP_LOOKUP_ELEM with key "0".  The map value returned will
> > > have the prog _id_ populated as the func ptr.
> > >
> > > The map value state (enum bpf_struct_ops_state) will transit from:
> > > INIT (map created) =3D>
> > > INUSE (map updated, i.e. reg) =3D>
> > > TOBEFREE (map value deleted, i.e. unreg)
> > >
> > > The kernel subsystem needs to call bpf_struct_ops_get() and
> > > bpf_struct_ops_put() to manage the "refcnt" in the
> > > "struct bpf_struct_ops_XYZ".  This patch uses a separate refcnt
> > > for the purose of tracking the subsystem usage.  Another approach
> > > is to reuse the map->refcnt and then "show" (i.e. during map_lookup)
> > > the subsystem's usage by doing map->refcnt - map->usercnt to filter o=
ut
> > > the map-fd/pinned-map usage.  However, that will also tie down the
> > > future semantics of map->refcnt and map->usercnt.
> > >
> > > The very first subsystem's refcnt (during reg()) holds one
> > > count to map->refcnt.  When the very last subsystem's refcnt
> > > is gone, it will also release the map->refcnt.  All bpf_prog will be
> > > freed when the map->refcnt reaches 0 (i.e. during map_free()).
> > >
> > > Here is how the bpftool map command will look like:
> > > [root@arch-fb-vm1 bpf]# bpftool map show
> > > 6: struct_ops  name dctcp  flags 0x0
> > >       key 4B  value 256B  max_entries 1  memlock 4096B
> > >       btf_id 6
> > > [root@arch-fb-vm1 bpf]# bpftool map dump id 6
> > > [{
> > >          "value": {
> > >              "refcnt": {
> > >                  "refs": {
> > >                      "counter": 1
> > >                  }
> > >              },
> > >              "state": 1,
> >
> > The bpftool dump with "state" 1 is a little bit cryptic.
> > Since this is common for all struct_ops maps, can we
> > make it explicit, e.g., as enum values, like INIT/INUSE/TOBEFREE?
>=20
> This can (and probably should) be done generically in bpftool for any
> field of enum type. Not blocking this patch set, though.
>=20
> >
> > >              "data": {
> > >                  "list": {
> > >                      "next": 0,
> > >                      "prev": 0
> > >                  },
> > >                  "key": 0,
> > >                  "flags": 2,
> > >                  "init": 24,
> > >                  "release": 0,
> > >                  "ssthresh": 25,
> > >                  "cong_avoid": 30,
> > >                  "set_state": 27,
> > >                  "cwnd_event": 28,
> > >                  "in_ack_event": 26,
> > >                  "undo_cwnd": 29,
> > >                  "pkts_acked": 0,
> > >                  "min_tso_segs": 0,
> > >                  "sndbuf_expand": 0,
> > >                  "cong_control": 0,
> > >                  "get_info": 0,
> > >                  "name": [98,112,102,95,100,99,116,99,112,0,0,0,0,0,0=
,0
> > >                  ],
>=20
> Same here, bpftool should be smart enough to figure out that this is a
> string, not just an array of bytes.

Agree on both above that bpftool can print better strings.
Those are generic improvements to bpftool and not specific
to a particular map type.

>=20
> > >                  "owner": 0
> > >              }
> > >          }
> > >      }
> > > ]
> > >
>=20
> [...]
