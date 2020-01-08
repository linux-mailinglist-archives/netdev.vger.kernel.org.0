Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6B7134A94
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgAHSmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:42:19 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15452 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725941AbgAHSmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:42:19 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 008IfudI030881;
        Wed, 8 Jan 2020 10:42:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=GuH5wmLXt/sT1GnF7qcBWW72EN5E1v1KRCFpaT0HPa4=;
 b=VAyEeO6nxI0dKxaToVDCkVGbvCkIqKfDBMnTDunfLgBE9nUbaqxkHKEE1WX860SeVFCb
 HoRzMTmKbIU3yxnhgg4WRcVMkaHszulxDHunUNsxzCTJeKJh2Bjj+EjVWDJeZROIdMSE
 DEzNBmXO5g8c5m8+BdmBjPbelH1S0lH+P1w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2xd2265d5t-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 08 Jan 2020 10:42:02 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 8 Jan 2020 10:41:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSNPxQd3z/qwyhh67PlHstZYHJIJ9piGLv5X1akLjmEcbh+16HRqC1d/U+0aAs52fuB6MAbrEWWh3z2wlCUEOFWeUkcb01n5BMswMAY+JZ/HodlrePVvZc3yWolFDHXQNew95AGIN86KUzRLk1IUBAd+048e9pN7/W2vXi4keuUwyFPyhrMu6+upg9SaL0mEFWOxieFk9ul1b7ArBzilYcj2TkxD8E6c1MNaXAe3nA8UwSrVRPvMNaHd/fCXamvPnRa3Vlem4hgrBUXcKT9JBE4zJUV14vjUXnT39zXDwB0hlHP2A2hcH1bkIvuX5WJF1hNewN2+hWCl4lFAoHwqGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GuH5wmLXt/sT1GnF7qcBWW72EN5E1v1KRCFpaT0HPa4=;
 b=AGJUx6VQoKL0gLJHpVotMonHrVqCFClqvMm7vZeYMQ8segNJm8jIHaCPlds270b0FlEaP3/V7nX/j55hCrrv+QM8wvGrM7Z36jC1VdoBTe6FF4WKDKtydWqy8xb+s/lLO86woiRH/tn4t92hwdGFRc9je4pV11utSKP12ya5Hkt9I628aY4wwB623UhygBI0EGtIH5w6NrtCGeQOxKIoiLAMLbI76rpw3fFY7SjU9vMKwe1pguXZ+NtqI8Izftoyk/FiZCbnL+SqbOfA2j5FqxUO7F3Da3zFoOpKVnSglzpve4YSSKNFANq71t5/YiXz6pj8F7zIqGkhaMkTs5kQyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GuH5wmLXt/sT1GnF7qcBWW72EN5E1v1KRCFpaT0HPa4=;
 b=lLoPcxagsXqFc2qc16uVegCTYVT37KYYJhXjFUqtSzQN6vSgndV6ayvGihKROmJl5vxAj3cAOssLqrMFMJcAywa0yShHRjX0CYtRJpx28uNrhTDqig8L9qCGvCetaOL3dZW1SVyekkungF4b+pVHKXdJPjZFVv9iqYy1k18xr+M=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3040.namprd15.prod.outlook.com (20.178.253.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 8 Jan 2020 18:41:41 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.008; Wed, 8 Jan 2020
 18:41:41 +0000
Received: from kafai-mbp (2620:10d:c090:180::a807) by MWHPR22CA0060.namprd22.prod.outlook.com (2603:10b6:300:12a::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9 via Frontend Transport; Wed, 8 Jan 2020 18:41:39 +0000
From:   Martin Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Topic: [PATCH bpf-next v3 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Index: AQHVxbmhzGmX9mEqt0CHVtxru5vAKKfgARaAgAD73QCAAB4cAA==
Date:   Wed, 8 Jan 2020 18:41:40 +0000
Message-ID: <20200108184136.f7fuv7p6scxheirq@kafai-mbp>
References: <20191231062037.280596-1-kafai@fb.com>
 <20191231062050.281712-1-kafai@fb.com>
 <4ea486a8-61cf-3c2e-c72c-96bb4f69d006@iogearbox.net>
 <20200108015223.sdecaqnjeconwpgq@kafai-mbp>
 <20200108165350.GA7014@linux-3.fritz.box>
In-Reply-To: <20200108165350.GA7014@linux-3.fritz.box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0060.namprd22.prod.outlook.com
 (2603:10b6:300:12a::22) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::a807]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd7b6e73-100c-42bb-da91-08d7946a66b0
x-ms-traffictypediagnostic: MN2PR15MB3040:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB304022388AA3E8B8D305DBADD53E0@MN2PR15MB3040.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(189003)(199004)(52314003)(43544003)(81156014)(86362001)(33716001)(6666004)(5660300002)(55016002)(9686003)(81166006)(1076003)(2906002)(8676002)(8936002)(54906003)(66476007)(64756008)(66556008)(66946007)(53546011)(498600001)(6916009)(6496006)(66446008)(186003)(52116002)(4326008)(16526019)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3040;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QWZp+3VYOVv83aEJ0hIe6bytY6NXGMvGRc3uV4U7OIRnhykl7MYXX/gL5nIJDTDnQwoy+VfPxA22Lpo2exrdv5kHD9yf5lvK3rdOvPECobZOIe5JVlOGr5EhK/qbxaVRksXNJ+F4IQh7Q6ybctMJ0iJ2T7ifGK4RSlKW2jUpBLSk6/UZclig/tYq6qXAVjY/XZGz8sH2WJ16NKLUEXfP2bThVK/JsrBHl6I1AIFxkBOdPxc9yZlFpuYZSWNk/ypQ2VUNwD1q5gSCjWa7tB4KzUvUq7wP8FFrZicS24AyBZ6w4CUMPcEHjmSjc/rKHNN68nXULhXI+NNtqGGztwn1tQ9ykwSHqUgKIV7a8G9lYb7HXF/Qy2d22CODc0Z00fRCxvVsBwmch/+97tdWvCLiBQu0dhoQ9tNWYhPwC3pf8nM8zoeWFrBiz+KVJtT0NTYbfcNTXEC62QXc4z2MWStxw3eoWAboamPMpWYOJbK0VDku9ZgMw+pgruiQL6OPTxyNl+yz/jdRc2Zt/ZUUhstZfw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DF66721DD3D41345B76257D6F4EC00A4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bd7b6e73-100c-42bb-da91-08d7946a66b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 18:41:40.8473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /xELwMzss3be2UF9eHF1R04Mb40kVA7+1uPS3eEJhcaqHi8oTcD1FQPHLh2epRSN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3040
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_05:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=1015
 adultscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001080149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 05:53:50PM +0100, Daniel Borkmann wrote:
> On Wed, Jan 08, 2020 at 01:52:26AM +0000, Martin Lau wrote:
> > On Wed, Jan 08, 2020 at 01:21:39AM +0100, Daniel Borkmann wrote:
> > > On 12/31/19 7:20 AM, Martin KaFai Lau wrote:
> > > > The patch introduces BPF_MAP_TYPE_STRUCT_OPS.  The map value
> > > > is a kernel struct with its func ptr implemented in bpf prog.
> > > > This new map is the interface to register/unregister/introspect
> > > > a bpf implemented kernel struct.
> > > >=20
> > > > The kernel struct is actually embedded inside another new struct
> > > > (or called the "value" struct in the code).  For example,
> > > > "struct tcp_congestion_ops" is embbeded in:
> > > > struct bpf_struct_ops_tcp_congestion_ops {
> > > > 	refcount_t refcnt;
> > > > 	enum bpf_struct_ops_state state;
> > > > 	struct tcp_congestion_ops data;  /* <-- kernel subsystem struct he=
re */
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
> > > >=20
> > > > Register a struct_ops to a kernel subsystem:
> > > > 1. Load all needed BPF_PROG_TYPE_STRUCT_OPS prog(s)
> > > > 2. Create a BPF_MAP_TYPE_STRUCT_OPS with attr->btf_vmlinux_value_ty=
pe_id
> > > >     set to the btf id "struct bpf_struct_ops_tcp_congestion_ops" of=
 the
> > > >     running kernel.
> > > >     Instead of reusing the attr->btf_value_type_id,
> > > >     btf_vmlinux_value_type_id s added such that attr->btf_fd can st=
ill be
> > > >     used as the "user" btf which could store other useful sysadmin/=
debug
> > > >     info that may be introduced in the furture,
> > > >     e.g. creation-date/compiler-details/map-creator...etc.
> > > > 3. Create a "struct bpf_struct_ops_tcp_congestion_ops" object as de=
scribed
> > > >     in the running kernel btf.  Populate the value of this object.
> > > >     The function ptr should be populated with the prog fds.
> > > > 4. Call BPF_MAP_UPDATE with the object created in (3) as
> > > >     the map value.  The key is always "0".
> > > >=20
> > > > During BPF_MAP_UPDATE, the code that saves the kernel-func-ptr's
> > > > args as an array of u64 is generated.  BPF_MAP_UPDATE also allows
> > > > the specific struct_ops to do some final checks in "st_ops->init_me=
mber()"
> > > > (e.g. ensure all mandatory func ptrs are implemented).
> > > > If everything looks good, it will register this kernel struct
> > > > to the kernel subsystem.  The map will not allow further update
> > > > from this point.
> > >=20
> > > Btw, did you have any thoughts on whether it would have made sense to=
 add
> > > a new core construct for BPF aside from progs or maps, e.g. BPF modul=
es
> > > which then resemble a collection of progs/ops (given this would not b=
e limited
> > > to tcp congestion control only). Given the possibilities, having a bi=
t of second
> > > thoughts on abusing BPF map interface this way which is not overly pr=
etty. It's
> > > not a map anymore at this point anyway, we're just reusing the syscal=
l interface
> > > since it's convenient though cannot be linked to any prog is just a s=
ingle slot
> > > etc, but technically some sort of BPF module registration would be ni=
cer. Also in
> > > terms of 'bpftool modules' then listing all such currently loaded mod=
ules which
> > > need to be cleaned up this way through explicit removal (similar to i=
nsmod/
> > > lsmod/rmmod); at least feels more natural conceptually than BPF maps =
and the way
> > > you refcount them, and would perhaps also be a fit for BPF lib helper=
s for dynamic
> > > linking to load that way. So essentially similar but more lightweight=
 infrastructure
> > > as with kernel modules. Thoughts?
> > Inventing a new bpf obj type (vs adding new map type like in this patch=
) was
> > one considered (and briefly-tried) option.
> >=20
> > Once BTF was introduced to bpf map,  I see bpf map as an introspectible
> > bpf obj that can store any blob described by BTF.  I don't think
> > creating a new bpf obj type worth it while both of them are basically
> > storing a value described by BTF.
> >=20
> > I did try to create register/unregister interface and new bpf-cmd.
> > At the end, it ends up very similar to update_elem() which is basically
> > updating a blob of a struct described by BTF.  Hence, I tossed that and
> > came back to the current approach.
> >=20
> > Put aside the new bpf obj type needs kernel support like another idr,
> > likely pin-able, fd, get_info...etc,  I suspect most users have already
> > been used to do 'bpftool map dump' to introspect bpf obj that is storin=
g
> > a 'struct'.
> >=20
> > The map type is enough to distinguish the map usage instead of creating
> > another bpf obj type.  The 'bpftool modules' will work on the struct_op=
s
> > map only.
>=20
> Right, but under long-term I'd expect more users of this interface and gi=
ven
> we abuse the map only to keep other entities (here: bpf tcp congctl modul=
e)
> 'alive', but cannot do anything else with this map (as in: usage in the B=
PF
> program),
For now, yes.  In the future, a bpf_prog may want to switch to another
bpf-tcp-cc (could be by looking it up from map-in-map also).  I do not
mean there is an immediate usecase but it is good to keep this
flexibility.

> it feels that this begs for a better interface. Given we need an
> explicit delete operation of the map slot in order to eventually unregist=
er
> the congctl module once no application is using it anymore, how are users
> supposed to operate this considering the loader performs either only a lo=
ad
> or crashes before the map delete happens? If you had 'bpftool modules' li=
ke
> cmdline interface with similar insmod/lsmod/rmmod type operation as we ha=
ve
> for kernel modules, it's pretty obvious and intuitive. Here, you'd need a
> 'bpftool map dump' to get to the concrete ops map, and then perform an
> explicit delete operation for releasing the ops refcount and thus to unlo=
ad
> the set of progs. Such extension for bpftool should be done regardless, e=
ven
A new bpftool command to operate on struct_ops map alone is in the pipeline=
.

The first thing though is to improve bpftool to recognize
btf_vmlinux_value_type_id which could be useful in the future
maps that also store a kernel's struct.

Regarding 'bpftool map show' first to figure out which
'struct_ops' map to delete,  the same is also true for lsmod/rmmod.
I also usually do lsmod to figure out which one I am looking at first
before issuing rmmod.  I suspect even the same lookup and then
delete/rmmod operation will still have to be done for the future
'bpftool modules (or struct_ops)' command.

> if we end up to keep abusing the map interface for this, but API wise fee=
ls
> way cleaner to have a dedicated register/unregister interface.
Other than the BPF syscall command name difference, lets explore how
would register/unregister be different from update/delete.

The first attempt I did on BPF_STRUCT_OPS_REGISTER is to do update alone
which ends-up very close to BPF_MAP_UPDATE_ELEM.

The second attempt I did on register is to do map-create and map-update
together and then return a fd.  However, I still don't see enough
benefit that deserves a separate BPF command to just combine these
two.  The global .rodata map is also map-create, map-update,
and map-freeze which technically it can do all of them under
a new command.

If update-vs-register looks the same, it then logically follows
update-then-delete.  For BPF_STRUCT_OPS_UNREGISTER, I also do not
see any difference except the key can be avoided.  Also, the
struct_ops map has a btf_key_type_id 0 which is "void" and
it is a clean interface to tell the map is key-less.
