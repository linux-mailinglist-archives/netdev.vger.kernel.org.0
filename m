Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0161338C2
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 02:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbgAHBxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 20:53:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51158 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726411AbgAHBxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 20:53:12 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0081quEp021091;
        Tue, 7 Jan 2020 17:52:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=JYDb7P3YONq88Fruz3jPTmLbLDzOSrjcx3dkL2txoPA=;
 b=Y4lbHN6ddCtMp2fjmIN+M++3MfD7GUrjWA5W5yfTXBQ4ZvX05BaqpDo4dPimXtyvNYYl
 nMldy6+MGyCtEoGtgup38/cP3MqJb5d/yK3ZOBvo7ib7Sih+ytC9GS9rrLiIdHnSEuOQ
 fNce2ZPkTr6N0jZlG1QzvyTsNivTlBS8pzM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xd26d13nm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 07 Jan 2020 17:52:58 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 7 Jan 2020 17:52:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igxSpG73SHNo86P5vn+rawdBwgaADN1HgB0OLSoqA6JHgqTHwOn1jfeciUEX9j4nSIF8ZMxP2MDc/hsUQXUtzsSuByIYoiCKWFRvmhmjBmH0dHvlKcnKLP8i/TLztI1wP/JdOch5+0PMCwXnPKQcfb6PjlvnVD5UrGFir/VANi83tXayq+YoBsZcQ5HuGzIfYjc95qPuYdt/vgVJb9JAhyazPj+FcEyIFuEhXBBsOGznOHQrEQJx0je5osbga7FPceRqooNWmcZv+D9bvEljD0nH5qGCO8R7Oal1K4mpUxK7FM9iTSz0eAOu7B550VZMpNCO/dFfoWI7aGV/lNyihw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JYDb7P3YONq88Fruz3jPTmLbLDzOSrjcx3dkL2txoPA=;
 b=c0WaE/GlKZ9eoVFwKp++bUcX3K7cna92nGLcCzicOC3f1SxYy9P/P63l8ySN3vo8L2lTw8JPNoVTV7QJ/smR4ZSqTtbiOBBc0EyfPk25PN5Wg01sfKnWbgKCiau7fwQm5uxKUhvth+6Nieax4DSajJN9Y/O3BmqZNlO8k6N/zhdrF66D6m7oa4TAB9DnF1h/PySye+PRuL5VN1fZUeypw3DR02su4QeqaKT2Hm1nDd2GY/XmuikRTY2sC/4g/Qbl1xem5PHSnmdchnBLngSA6zdbiHtiKjD6ckbfn0Arn+SqgznCejMI2miwIrxguFpLCbJc3ObGUkTuo9zvoklOUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JYDb7P3YONq88Fruz3jPTmLbLDzOSrjcx3dkL2txoPA=;
 b=frE54hL+9sOBvZtYwVHcTZ6j1ZWBtNlUS5SD0KqnWcOHitaF5rgzpyEnnkyBgQe1+TdSlswfCC7hevy8prvtDt0MKWkBvLxECNIkjnbtPU/bnAx4t69/MFarGEyU3yAaA0FHs0QxwgCUEgDTNE7G3L8UbXiUhtxfFq0FriLOPic=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3214.namprd15.prod.outlook.com (20.179.20.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Wed, 8 Jan 2020 01:52:27 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.008; Wed, 8 Jan 2020
 01:52:26 +0000
Received: from kafai-mbp (2620:10d:c090:200::2:58) by MWHPR1201CA0010.namprd12.prod.outlook.com (2603:10b6:301:4a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.8 via Frontend Transport; Wed, 8 Jan 2020 01:52:25 +0000
From:   Martin Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Topic: [PATCH bpf-next v3 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Index: AQHVxbmhzGmX9mEqt0CHVtxru5vAKKfgARaA
Date:   Wed, 8 Jan 2020 01:52:26 +0000
Message-ID: <20200108015223.sdecaqnjeconwpgq@kafai-mbp>
References: <20191231062037.280596-1-kafai@fb.com>
 <20191231062050.281712-1-kafai@fb.com>
 <4ea486a8-61cf-3c2e-c72c-96bb4f69d006@iogearbox.net>
In-Reply-To: <4ea486a8-61cf-3c2e-c72c-96bb4f69d006@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1201CA0010.namprd12.prod.outlook.com
 (2603:10b6:301:4a::20) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b698c82-a565-4c0d-bfb5-08d793dd69a4
x-ms-traffictypediagnostic: MN2PR15MB3214:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB3214F64DDF85F5CCD748AEF0D53E0@MN2PR15MB3214.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(136003)(366004)(396003)(189003)(199004)(43544003)(52314003)(186003)(316002)(16526019)(5660300002)(478600001)(52116002)(6496006)(54906003)(53546011)(66476007)(66946007)(64756008)(2906002)(66556008)(1076003)(66446008)(3716004)(8936002)(33716001)(81166006)(6916009)(71200400001)(81156014)(8676002)(55016002)(4326008)(9686003)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3214;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tMgt7T2whQ7fU0TGoK9wfNfWNtPFr+0HMaEJMIh2Gf/webBqn/hhjqmaPCzwXGWgBWoq2QTbFjjzHqwjZpVU+W24j8If9mg0ieP8EAs/Z0Jay9We3G+PFtFjXWiJ1mn+uU1Pv/2tUUmhqBcARQcy0qm+xYE5Ddy8xktkqnKwXlgdH8+Dd+VmSORrzIbAwCDinhqYMtZ4hEE98MKfQdVJnEJJKi1QZhN7M90s8YNPoHbtWAw2YylL+MPzbokYJevbMsseGcDHSU+8bJxzB2e2lRQ2R+Mc5tVcgDZrx4Nk3Dr6K/n6uTAGgnRQoR+BwLpUqjkOFBX1ScAEtkKEJDtSP8BspueHnHvT4LCDW04iWlY9UdzCKbz0jPFoWMpwUdBGSnkOmQIK0ojsgTFo92xvQFFwBuF8dEhRdffWZ6y8V9Q5HOZzqpmRB1v+20Hkk30Z4pvdmdJ5uENPA7ACRnMsJ0R4vhZ2Io7QdiaZS5oje3CNobM/Zr3CsQtltEWb2wPSWl9X/B4afEBcZPe++Gx0tg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9DD71C345CE81145908928D20A9F6B46@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b698c82-a565-4c0d-bfb5-08d793dd69a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 01:52:26.7173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2ycz0maQeFMEqNSFBdDQd1OGuNhEcAJMMahcBCBF2jv+EVKWcU7BEr3kBLYnELjd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3214
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-07_08:2020-01-07,2020-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001080015
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 01:21:39AM +0100, Daniel Borkmann wrote:
> On 12/31/19 7:20 AM, Martin KaFai Lau wrote:
> > The patch introduces BPF_MAP_TYPE_STRUCT_OPS.  The map value
> > is a kernel struct with its func ptr implemented in bpf prog.
> > This new map is the interface to register/unregister/introspect
> > a bpf implemented kernel struct.
> >=20
> > The kernel struct is actually embedded inside another new struct
> > (or called the "value" struct in the code).  For example,
> > "struct tcp_congestion_ops" is embbeded in:
> > struct bpf_struct_ops_tcp_congestion_ops {
> > 	refcount_t refcnt;
> > 	enum bpf_struct_ops_state state;
> > 	struct tcp_congestion_ops data;  /* <-- kernel subsystem struct here *=
/
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
> >=20
> > Register a struct_ops to a kernel subsystem:
> > 1. Load all needed BPF_PROG_TYPE_STRUCT_OPS prog(s)
> > 2. Create a BPF_MAP_TYPE_STRUCT_OPS with attr->btf_vmlinux_value_type_i=
d
> >     set to the btf id "struct bpf_struct_ops_tcp_congestion_ops" of the
> >     running kernel.
> >     Instead of reusing the attr->btf_value_type_id,
> >     btf_vmlinux_value_type_id s added such that attr->btf_fd can still =
be
> >     used as the "user" btf which could store other useful sysadmin/debu=
g
> >     info that may be introduced in the furture,
> >     e.g. creation-date/compiler-details/map-creator...etc.
> > 3. Create a "struct bpf_struct_ops_tcp_congestion_ops" object as descri=
bed
> >     in the running kernel btf.  Populate the value of this object.
> >     The function ptr should be populated with the prog fds.
> > 4. Call BPF_MAP_UPDATE with the object created in (3) as
> >     the map value.  The key is always "0".
> >=20
> > During BPF_MAP_UPDATE, the code that saves the kernel-func-ptr's
> > args as an array of u64 is generated.  BPF_MAP_UPDATE also allows
> > the specific struct_ops to do some final checks in "st_ops->init_member=
()"
> > (e.g. ensure all mandatory func ptrs are implemented).
> > If everything looks good, it will register this kernel struct
> > to the kernel subsystem.  The map will not allow further update
> > from this point.
>=20
> Btw, did you have any thoughts on whether it would have made sense to add
> a new core construct for BPF aside from progs or maps, e.g. BPF modules
> which then resemble a collection of progs/ops (given this would not be li=
mited
> to tcp congestion control only). Given the possibilities, having a bit of=
 second
> thoughts on abusing BPF map interface this way which is not overly pretty=
. It's
> not a map anymore at this point anyway, we're just reusing the syscall in=
terface
> since it's convenient though cannot be linked to any prog is just a singl=
e slot
> etc, but technically some sort of BPF module registration would be nicer.=
 Also in
> terms of 'bpftool modules' then listing all such currently loaded modules=
 which
> need to be cleaned up this way through explicit removal (similar to insmo=
d/
> lsmod/rmmod); at least feels more natural conceptually than BPF maps and =
the way
> you refcount them, and would perhaps also be a fit for BPF lib helpers fo=
r dynamic
> linking to load that way. So essentially similar but more lightweight inf=
rastructure
> as with kernel modules. Thoughts?
Inventing a new bpf obj type (vs adding new map type like in this patch) wa=
s
one considered (and briefly-tried) option.

Once BTF was introduced to bpf map,  I see bpf map as an introspectible
bpf obj that can store any blob described by BTF.  I don't think
creating a new bpf obj type worth it while both of them are basically
storing a value described by BTF.

I did try to create register/unregister interface and new bpf-cmd.
At the end, it ends up very similar to update_elem() which is basically
updating a blob of a struct described by BTF.  Hence, I tossed that and
came back to the current approach.

Put aside the new bpf obj type needs kernel support like another idr,
likely pin-able, fd, get_info...etc,  I suspect most users have already
been used to do 'bpftool map dump' to introspect bpf obj that is storing
a 'struct'.

The map type is enough to distinguish the map usage instead of creating
another bpf obj type.  The 'bpftool modules' will work on the struct_ops
map only.

