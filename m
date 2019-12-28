Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF4712BC92
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 06:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfL1FRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 00:17:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18482 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725857AbfL1FRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 00:17:18 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBS5H3vJ004036;
        Fri, 27 Dec 2019 21:17:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=nLFCmh3KA9ZQrM7kzO3XL8Beb3jv/5bqFihtzVsNS5s=;
 b=npu3HnebjgA0hdnzhl1Rfq1ht/SVaE3g/KdchkadDIr/v2kFIMDD3At5BL4VZedjw7az
 NYu1aqrRczGB09FlclculloSvWrsVTTU6MsQCjx31CkkTm5KWwBYUM0pcVmHDt6fAzCs
 Ww+ZsQdKGWgMyAD4a9NkoCh2acg+f3VP4zA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2x54jqnad7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 27 Dec 2019 21:17:03 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 27 Dec 2019 21:16:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E10p/RawPq0eRlsdPzd33fWBpj9sFp8f5mkEBtKexqw5v4Fc2n3mAQkohbOcWHKnf8h7ezgEn7qBKCo3kFN3+f9/Op/M9XBk6XRx1UAZubK/Cb0mnULpDaavGDqtXByccGGKKzV5BSvn3nNXAGvzL4LDJATapVJhmpHw0NLhfhNSJwmsDSe353nozmTGSWhwd0uKLDr4MVrxcMMFNkr5WL3YWSFaO7sZvny1UYQ9qRpPp1MfN7HV5K16Ig0uIqnxbTITYayvvIeLff1qOiWdEuIPrScxWBew8q/dmGgf72hCBS/xq6ciFTyOiImVNOYkDbw603KFllk6zKnqboBN5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nLFCmh3KA9ZQrM7kzO3XL8Beb3jv/5bqFihtzVsNS5s=;
 b=RsROpYergjKx57KtnKdHl3bOiPgQGrb+Xgm3kQ8jKtbtzo3RTGHCTTF8dG8VxyGfH3HeYOGVZXSpk7/1n07UGh+b7Lq3pptmdml23HUm/tDpENhMekCF/QBFWVA8y5U9y7bWFpV5l1MnQtQ8CYFu8Tvpz4BAHfKRh6ATIEF8pN6rQuaukDa/fj1EgFGGe3WHBuMtencliknJcyjhkJqb9d2TYejX9DBSM7TEgS2k3tVsFtIUdkBVaR81cvt52/VcWlaB1fwBzFJHxm7Utq3BNenOErhDsevr/7fF0zB3bggXhJjAK/UUfjuZVkwJ+9rH/sz1KUQ+XCJ3EEXLt8vmNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nLFCmh3KA9ZQrM7kzO3XL8Beb3jv/5bqFihtzVsNS5s=;
 b=TgscPWftnPGLDLXZ2qYbBJILRMSjPUrAcd4EGLbnr+KF/qgnY51vJVq45NDxGRF2wLpjDsUAYLmt3bSarJghISk7KIeUIhUr8vsB1cMtvQnetV2iR9VHJAJGayaRsnA3q9qKL4wKf+0ikim0iUcOQGbxsv2KkQ1eO14tCJCgEF8=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3149.namprd15.prod.outlook.com (20.178.250.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Sat, 28 Dec 2019 05:16:29 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2559.017; Sat, 28 Dec 2019
 05:16:28 +0000
Received: from kafai-mbp (2620:10d:c090:180::e1bf) by MWHPR15CA0066.namprd15.prod.outlook.com (2603:10b6:301:4c::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Sat, 28 Dec 2019 05:16:26 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Topic: [PATCH bpf-next v2 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Index: AQHVt8eKCw0H8YSIj0iyCJPN6l8CHKfIW0cAgAZ2ngCAAAp3gIAAL/mA
Date:   Sat, 28 Dec 2019 05:16:28 +0000
Message-ID: <20191228051623.sxrnxbmgjwin3tp7@kafai-mbp>
References: <20191221062556.1182261-1-kafai@fb.com>
 <20191221062608.1183091-1-kafai@fb.com>
 <CAEf4BzZ0fb5ecoCJTt+7j2rxoP3QnVBivHjg8GDLofR4sLFU7w@mail.gmail.com>
 <20191228014714.kdn4kulywefenf2y@kafai-mbp>
 <CAEf4Bzapi8uhKmFGf1roVzmnaH3FYDcs9X7qkv-tcQ=Vv__G3A@mail.gmail.com>
In-Reply-To: <CAEf4Bzapi8uhKmFGf1roVzmnaH3FYDcs9X7qkv-tcQ=Vv__G3A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR15CA0066.namprd15.prod.outlook.com
 (2603:10b6:301:4c::28) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::e1bf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b83d899-a9fa-4821-46f2-08d78b5517b4
x-ms-traffictypediagnostic: MN2PR15MB3149:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB31493B4BD5763D9AE7B4AD9AD5250@MN2PR15MB3149.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 02652BD10A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(396003)(39860400002)(366004)(43544003)(189003)(199004)(8936002)(81166006)(52116002)(81156014)(55016002)(9686003)(478600001)(8676002)(86362001)(186003)(4326008)(66476007)(64756008)(66556008)(1076003)(66946007)(6496006)(33716001)(6916009)(66446008)(53546011)(16526019)(54906003)(71200400001)(2906002)(5660300002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3149;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +H5sZ/abuCYL4Jm5E2Il+Q/6elDNHlQQGEi836COmg+rI0tFRfI+PT5gW2+pXGgHnq+9Py/XPUtFbprWoa0LrSh1UKaaXTNguhui9kjUGDXiYKf8DCm0X8KKhZi2ETWqpZmqO2/RVn/7gQ2DxesmuvO03Wh/EIPWnn6R5nRbB9LzX92Zf2KjysfNdffTPJra1qhUUPL3N3PxdiL/pBXo5m5N0Xtj732L1uc6oM8WyFRlQG11bwn5CyaLHx3Vuu5jtaGN3y0ICynELMroKFRYFM4ZZjoLol1wk3Kz2OQ6QWq0OgcTR7lEz7CDATYzrz2NMNhnmW0LwhKQxeQiuY+ZjpDffFQFXXKZhoEo0dbwrJESsfunQCYd2odmlZycT24RuEcxtT9I+3txZrFjm3dvsunT+Q7MB6twQwC5lRjURG2uaMhba3e7u8k6I/tPQlxYWfth2z6CzbKYLRbeNCorUVhQ/EoTC+yE+71rXQntoYTVD6dB6daKUsSwDf+NedJ0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A45DCDB06AA7164B982EEAE248B7B8DF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b83d899-a9fa-4821-46f2-08d78b5517b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2019 05:16:28.5964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WB22vBDClhh6Wr+hOmywaE9U1+2A91NNx5vNJGKwu1l6K27HuQi+Bk0EJYdp/La9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3149
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-27_09:2019-12-27,2019-12-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 spamscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912280047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 06:24:41PM -0800, Andrii Nakryiko wrote:
> On Fri, Dec 27, 2019 at 5:47 PM Martin Lau <kafai@fb.com> wrote:
> >
> > On Mon, Dec 23, 2019 at 03:05:08PM -0800, Andrii Nakryiko wrote:
> > > On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.com> wrot=
e:
> > > >
> > > > The patch introduces BPF_MAP_TYPE_STRUCT_OPS.  The map value
> > > > is a kernel struct with its func ptr implemented in bpf prog.
> > > > This new map is the interface to register/unregister/introspect
> > > > a bpf implemented kernel struct.
> > > >
> > > > The kernel struct is actually embedded inside another new struct
> > > > (or called the "value" struct in the code).  For example,
> > > > "struct tcp_congestion_ops" is embbeded in:
> > > > struct bpf_struct_ops_tcp_congestion_ops {
> > > >         refcount_t refcnt;
> > > >         enum bpf_struct_ops_state state;
> > > >         struct tcp_congestion_ops data;  /* <-- kernel subsystem st=
ruct here */
> > > > }
> > > > The map value is "struct bpf_struct_ops_tcp_congestion_ops".
> > > > The "bpftool map dump" will then be able to show the
> > > > state ("inuse"/"tobefree") and the number of subsystem's refcnt (e.=
g.
> > > > number of tcp_sock in the tcp_congestion_ops case).  This "value" s=
truct
> > > > is created automatically by a macro.  Having a separate "value" str=
uct
> > > > will also make extending "struct bpf_struct_ops_XYZ" easier (e.g. a=
dding
> > > > "void (*init)(void)" to "struct bpf_struct_ops_XYZ" to do some
> > > > initialization works before registering the struct_ops to the kerne=
l
> > > > subsystem).  The libbpf will take care of finding and populating th=
e
> > > > "struct bpf_struct_ops_XYZ" from "struct XYZ".
> > > >
> > > > Register a struct_ops to a kernel subsystem:
> > > > 1. Load all needed BPF_PROG_TYPE_STRUCT_OPS prog(s)
> > > > 2. Create a BPF_MAP_TYPE_STRUCT_OPS with attr->btf_vmlinux_value_ty=
pe_id
> > > >    set to the btf id "struct bpf_struct_ops_tcp_congestion_ops" of =
the
> > > >    running kernel.
> > > >    Instead of reusing the attr->btf_value_type_id,
> > > >    btf_vmlinux_value_type_id s added such that attr->btf_fd can sti=
ll be
> > > >    used as the "user" btf which could store other useful sysadmin/d=
ebug
> > > >    info that may be introduced in the furture,
> > > >    e.g. creation-date/compiler-details/map-creator...etc.
> > > > 3. Create a "struct bpf_struct_ops_tcp_congestion_ops" object as de=
scribed
> > > >    in the running kernel btf.  Populate the value of this object.
> > > >    The function ptr should be populated with the prog fds.
> > > > 4. Call BPF_MAP_UPDATE with the object created in (3) as
> > > >    the map value.  The key is always "0".
> > > >
> > > > During BPF_MAP_UPDATE, the code that saves the kernel-func-ptr's
> > > > args as an array of u64 is generated.  BPF_MAP_UPDATE also allows
> > > > the specific struct_ops to do some final checks in "st_ops->init_me=
mber()"
> > > > (e.g. ensure all mandatory func ptrs are implemented).
> > > > If everything looks good, it will register this kernel struct
> > > > to the kernel subsystem.  The map will not allow further update
> > > > from this point.
> > > >
> > > > Unregister a struct_ops from the kernel subsystem:
> > > > BPF_MAP_DELETE with key "0".
> > > >
> > > > Introspect a struct_ops:
> > > > BPF_MAP_LOOKUP_ELEM with key "0".  The map value returned will
> > > > have the prog _id_ populated as the func ptr.
> > > >
> > > > The map value state (enum bpf_struct_ops_state) will transit from:
> > > > INIT (map created) =3D>
> > > > INUSE (map updated, i.e. reg) =3D>
> > > > TOBEFREE (map value deleted, i.e. unreg)
> > > >
> > > > The kernel subsystem needs to call bpf_struct_ops_get() and
> > > > bpf_struct_ops_put() to manage the "refcnt" in the
> > > > "struct bpf_struct_ops_XYZ".  This patch uses a separate refcnt
> > > > for the purose of tracking the subsystem usage.  Another approach
> > > > is to reuse the map->refcnt and then "show" (i.e. during map_lookup=
)
> > > > the subsystem's usage by doing map->refcnt - map->usercnt to filter=
 out
> > > > the map-fd/pinned-map usage.  However, that will also tie down the
> > > > future semantics of map->refcnt and map->usercnt.
> > > >
> > > > The very first subsystem's refcnt (during reg()) holds one
> > > > count to map->refcnt.  When the very last subsystem's refcnt
> > > > is gone, it will also release the map->refcnt.  All bpf_prog will b=
e
> > > > freed when the map->refcnt reaches 0 (i.e. during map_free()).
> > > >
> > > > Here is how the bpftool map command will look like:
> > > > [root@arch-fb-vm1 bpf]# bpftool map show
> > > > 6: struct_ops  name dctcp  flags 0x0
> > > >         key 4B  value 256B  max_entries 1  memlock 4096B
> > > >         btf_id 6
> > > > [root@arch-fb-vm1 bpf]# bpftool map dump id 6
> > > > [{
> > > >         "value": {
> > > >             "refcnt": {
> > > >                 "refs": {
> > > >                     "counter": 1
> > > >                 }
> > > >             },
> > > >             "state": 1,
> > > >             "data": {
> > > >                 "list": {
> > > >                     "next": 0,
> > > >                     "prev": 0
> > > >                 },
> > > >                 "key": 0,
> > > >                 "flags": 2,
> > > >                 "init": 24,
> > > >                 "release": 0,
> > > >                 "ssthresh": 25,
> > > >                 "cong_avoid": 30,
> > > >                 "set_state": 27,
> > > >                 "cwnd_event": 28,
> > > >                 "in_ack_event": 26,
> > > >                 "undo_cwnd": 29,
> > > >                 "pkts_acked": 0,
> > > >                 "min_tso_segs": 0,
> > > >                 "sndbuf_expand": 0,
> > > >                 "cong_control": 0,
> > > >                 "get_info": 0,
> > > >                 "name": [98,112,102,95,100,99,116,99,112,0,0,0,0,0,=
0,0
> > > >                 ],
> > > >                 "owner": 0
> > > >             }
> > > >         }
> > > >     }
> > > > ]
> > > >
> > > > Misc Notes:
> > > > * bpf_struct_ops_map_sys_lookup_elem() is added for syscall lookup.
> > > >   It does an inplace update on "*value" instead returning a pointer
> > > >   to syscall.c.  Otherwise, it needs a separate copy of "zero" valu=
e
> > > >   for the BPF_STRUCT_OPS_STATE_INIT to avoid races.
> > > >
> > > > * The bpf_struct_ops_map_delete_elem() is also called without
> > > >   preempt_disable() from map_delete_elem().  It is because
> > > >   the "->unreg()" may requires sleepable context, e.g.
> > > >   the "tcp_unregister_congestion_control()".
> > > >
> > > > * "const" is added to some of the existing "struct btf_func_model *=
"
> > > >   function arg to avoid a compiler warning caused by this patch.
> > > >
> > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > ---
> > >
> > > LGTM! Few questions below to improve my understanding.
> > >
> > > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > >
> > > >  arch/x86/net/bpf_jit_comp.c |  11 +-
> > > >  include/linux/bpf.h         |  49 +++-
> > > >  include/linux/bpf_types.h   |   3 +
> > > >  include/linux/btf.h         |  13 +
> > > >  include/uapi/linux/bpf.h    |   7 +-
> > > >  kernel/bpf/bpf_struct_ops.c | 468 ++++++++++++++++++++++++++++++++=
+++-
> > > >  kernel/bpf/btf.c            |  20 +-
> > > >  kernel/bpf/map_in_map.c     |   3 +-
> > > >  kernel/bpf/syscall.c        |  49 ++--
> > > >  kernel/bpf/trampoline.c     |   5 +-
> > > >  kernel/bpf/verifier.c       |   5 +
> > > >  11 files changed, 593 insertions(+), 40 deletions(-)
> > > >
> > >
> > > [...]
> > >
> > > > +               /* All non func ptr member must be 0 */
> > > > +               if (!btf_type_resolve_func_ptr(btf_vmlinux, member-=
>type,
> > > > +                                              NULL)) {
> > > > +                       u32 msize;
> > > > +
> > > > +                       mtype =3D btf_resolve_size(btf_vmlinux, mty=
pe,
> > > > +                                                &msize, NULL, NULL=
);
> > > > +                       if (IS_ERR(mtype)) {
> > > > +                               err =3D PTR_ERR(mtype);
> > > > +                               goto reset_unlock;
> > > > +                       }
> > > > +
> > > > +                       if (memchr_inv(udata + moff, 0, msize)) {
> > >
> > >
> > > just double-checking: we are ok with having non-zeroed padding in a
> > > struct, is that right?
> > Sorry for the delay.
> >
> > You meant the end-padding of the kernel side struct (i.e. kdata (or kva=
lue))
> > could be non-zero?  The btf's struct size (i.e. vt->size) should includ=
e
> > the padding and the whole vt->size is init to 0.
> >
> > or you meant the user passed in udata (or uvalue)?
>=20
> The latter, udata. You check member-by-member, but if there is padding
> between fields or at the end of a struct, nothing is currently
> checking it for zeroes. So probably safer to check those paddings
> inbetween as well.
Agree. Will do.
