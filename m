Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F03F132EBE
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 19:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgAGS4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 13:56:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24192 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728358AbgAGS4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 13:56:02 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 007IrniE005973;
        Tue, 7 Jan 2020 10:55:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=TxNyJqxEUM+yL8S+B+L7u4kDnMJQe043P1RcBDH6UcM=;
 b=ef4m39EkcbrdhLbRZA6AnTYC6ymyaSu2S6O7oSphpLZLmWowipVO8fdu0sqgRY2nrX68
 MmSVG7gX5sjRgcvsC7dWFM6Zce5JjGtXOgDC54Z5QfWfcZVN3Glj5JE1/bgcV5OUvm3H
 nX63tuhUCY3zTWAoIKcycGrYi9n/Df+fCqc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xcr85tey8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 07 Jan 2020 10:55:45 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 7 Jan 2020 10:55:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGt8UX8lz2wQIBxNGZyZt9SEYZ9i8yn6+7NotuE41jH4VnzDEdvFUtI07o/7cHkMTgsOAq6OnhDKaMB5WyfSw28ut8KioGhRpp2aJz2lpB8OqoVcuyyWstJS18nl21+Q+4pZSF/0OvhBHJ9a5Z5NNQ9H2tuTPu4lXSMCVGyVanksrUpAAxlzfJye2FH9wpbPH3e9Litz/NMA+RJu/HHmlrExQ1zXlqJEdaobT5MSbxXGW3wZo9uu6zz3XcpwJ2q6jiCs7ZcdzsOQSqjsfIYSkSOn7Hq4fnLsQZa5pPiznqvE5PNN1R15CXBn/8ifnBUttcnQMWJM/W4hPMo8Xaa0tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TxNyJqxEUM+yL8S+B+L7u4kDnMJQe043P1RcBDH6UcM=;
 b=W/ZCIx4yaLVYGwBumMlZistBhfq+lf3ZumwRaYIsok6NUhmM5MemMdS4hMYmhk4+ij2jYLOydzpeYN/NI5rTW3l5nrhCnKfMxwoXGB8oqOyUA44nKPy6kNSWLP7tOWzDlIB5hAGllzZXCRP6WT/Znnn+XaibLH7/o/JJPNIUO+aQYGjesmBMsrPOPl8FV/LvEj81+J5OnPBK82Yx0Ltk0U9X1uHU0Q6c2iinHDPG5MhIJYZRwoxOKznfi2wqj44OrP4Xtf+zt0sPenj3ZMipTMUk9sMeNfh196zmgf6mgPSPW+iv7F9tTYaHlGYMiJRXStkt21hbfIs7gIhovDsBVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TxNyJqxEUM+yL8S+B+L7u4kDnMJQe043P1RcBDH6UcM=;
 b=WqSBMP8w+KpdDXQ3gc3pANuJWXvJ9uf+a+qv2/nqO9dRwVmz9stquhlcukh6ZvGhzjBzYl0EkvE0ma9SVdHuEhdt7zUEUbVRMTsYXGTFEuMOODXpdRy1cUhEOqke5885v0QtU7CAefExzGBZYUyOG5z7L0/DwbtymY+p3UyBdVg=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3549.namprd15.prod.outlook.com (52.132.173.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Tue, 7 Jan 2020 18:55:37 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.008; Tue, 7 Jan 2020
 18:55:37 +0000
Received: from kafai-mbp (2620:10d:c090:200::2:58) by MWHPR17CA0058.namprd17.prod.outlook.com (2603:10b6:300:93::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.8 via Frontend Transport; Tue, 7 Jan 2020 18:55:35 +0000
From:   Martin Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Topic: [PATCH bpf-next v3 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Index: AQHVxXOq69nZ9rtA9EC7c7DX0CNUqqffjSyA
Date:   Tue, 7 Jan 2020 18:55:36 +0000
Message-ID: <20200107185533.d64lkoqggrdfehga@kafai-mbp>
References: <20191231062037.280596-1-kafai@fb.com>
 <20191231062050.281712-1-kafai@fb.com>
 <4d0aafe9-75c7-43fe-d9eb-62bb2053b53e@iogearbox.net>
In-Reply-To: <4d0aafe9-75c7-43fe-d9eb-62bb2053b53e@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0058.namprd17.prod.outlook.com
 (2603:10b6:300:93::20) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0894d310-5369-40a6-f865-08d793a32ea1
x-ms-traffictypediagnostic: MN2PR15MB3549:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB35492EF4C9B472195006D0A1D53F0@MN2PR15MB3549.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(136003)(39860400002)(366004)(396003)(189003)(199004)(316002)(6916009)(9686003)(16526019)(4326008)(186003)(5660300002)(33716001)(71200400001)(1076003)(55016002)(86362001)(6496006)(478600001)(52116002)(53546011)(54906003)(81156014)(81166006)(64756008)(8676002)(2906002)(8936002)(66446008)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3549;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LZHCi5ekz6TGexE6mM4nGBsiPjAHk+1ne+vN2vIObNAp/FE7zTB/We8lFeYIegnK9TLG5fLCON5fcQZQPKH4zjFQ9PlMTuv+ACK22WwTJlg/IsOUfO9JmCPMIAG9SZNpc4lBpBPN9yrBcEHX8lSQxIwdubOSuqC1r7H29ITfQHMkHK5EczCb81Ie1h/I7ezxfrHmacO8KKGUjQXRoQX7F4coIU2TA6Qbe9JIxTQMb0P8cWmyeF30qje3OUclL/VPOSDrRYW/3jd/9PpC+C6TBK2jxHveZOPxgh+QnneDXwfAY2NnxS7bsbcZ/uFpRJ83LNeOkt0XUFEFh4mYtBChABfiSu36BfcmWkVY9B0Ap52w/hf/oFzpPR0EhWxCzEBc5F4GJt3nWlZym/Gj7G6GGNZvEpLj5AkXtBfLLyOjDld/Dw2/QoanR/4EiNTpMaKp
Content-Type: text/plain; charset="us-ascii"
Content-ID: <936AB9F379B47D4FA08A72CB78FAD00A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0894d310-5369-40a6-f865-08d793a32ea1
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 18:55:36.9522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: celgS5wOVY4eYSwXx2J0DBtHcPvQOmQLREnzMi5Tq0qmoGDHt0Cq7vV7DsX51yp2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3549
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-07_06:2020-01-07,2020-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=811 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001070148
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 05:00:37PM +0100, Daniel Borkmann wrote:
> On 12/31/19 7:20 AM, Martin KaFai Lau wrote:
> [...]
> > +static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *k=
ey,
> > +					  void *value, u64 flags)
> > +{
> > +	struct bpf_struct_ops_map *st_map =3D (struct bpf_struct_ops_map *)ma=
p;
> > +	const struct bpf_struct_ops *st_ops =3D st_map->st_ops;
> > +	struct bpf_struct_ops_value *uvalue, *kvalue;
> > +	const struct btf_member *member;
> > +	const struct btf_type *t =3D st_ops->type;
> > +	void *udata, *kdata;
> > +	int prog_fd, err =3D 0;
> > +	void *image;
> > +	u32 i;
> > +
> > +	if (flags)
> > +		return -EINVAL;
> > +
> > +	if (*(u32 *)key !=3D 0)
> > +		return -E2BIG;
> > +
> > +	err =3D check_zero_holes(st_ops->value_type, value);
> > +	if (err)
> > +		return err;
> > +
> > +	uvalue =3D (struct bpf_struct_ops_value *)value;
> > +	err =3D check_zero_holes(t, uvalue->data);
> > +	if (err)
> > +		return err;
> > +
> > +	if (uvalue->state || refcount_read(&uvalue->refcnt))
> > +		return -EINVAL;
> > +
> > +	uvalue =3D (struct bpf_struct_ops_value *)st_map->uvalue;
> > +	kvalue =3D (struct bpf_struct_ops_value *)&st_map->kvalue;
> > +
> > +	spin_lock(&st_map->lock);
> > +
> > +	if (kvalue->state !=3D BPF_STRUCT_OPS_STATE_INIT) {
> > +		err =3D -EBUSY;
> > +		goto unlock;
> > +	}
> > +
> > +	memcpy(uvalue, value, map->value_size);
> > +
> > +	udata =3D &uvalue->data;
> > +	kdata =3D &kvalue->data;
> > +	image =3D st_map->image;
> > +
> > +	for_each_member(i, t, member) {
> > +		const struct btf_type *mtype, *ptype;
> > +		struct bpf_prog *prog;
> > +		u32 moff;
> > +
> > +		moff =3D btf_member_bit_offset(t, member) / 8;
> > +		ptype =3D btf_type_resolve_ptr(btf_vmlinux, member->type, NULL);
> > +		if (ptype =3D=3D module_type) {
> > +			if (*(void **)(udata + moff))
> > +				goto reset_unlock;
> > +			*(void **)(kdata + moff) =3D BPF_MODULE_OWNER;
> > +			continue;
> > +		}
> > +
> > +		err =3D st_ops->init_member(t, member, kdata, udata);
> > +		if (err < 0)
> > +			goto reset_unlock;
> > +
> > +		/* The ->init_member() has handled this member */
> > +		if (err > 0)
> > +			continue;
> > +
> > +		/* If st_ops->init_member does not handle it,
> > +		 * we will only handle func ptrs and zero-ed members
> > +		 * here.  Reject everything else.
> > +		 */
> > +
> > +		/* All non func ptr member must be 0 */
> > +		if (!ptype || !btf_type_is_func_proto(ptype)) {
> > +			u32 msize;
> > +
> > +			mtype =3D btf_type_by_id(btf_vmlinux, member->type);
> > +			mtype =3D btf_resolve_size(btf_vmlinux, mtype, &msize,
> > +						 NULL, NULL);
> > +			if (IS_ERR(mtype)) {
> > +				err =3D PTR_ERR(mtype);
> > +				goto reset_unlock;
> > +			}
> > +
> > +			if (memchr_inv(udata + moff, 0, msize)) {
> > +				err =3D -EINVAL;
> > +				goto reset_unlock;
> > +			}
> > +
> > +			continue;
> > +		}
> > +
> > +		prog_fd =3D (int)(*(unsigned long *)(udata + moff));
> > +		/* Similar check as the attr->attach_prog_fd */
> > +		if (!prog_fd)
> > +			continue;
> > +
> > +		prog =3D bpf_prog_get(prog_fd);
> > +		if (IS_ERR(prog)) {
> > +			err =3D PTR_ERR(prog);
> > +			goto reset_unlock;
> > +		}
> > +		st_map->progs[i] =3D prog;
> > +
> > +		if (prog->type !=3D BPF_PROG_TYPE_STRUCT_OPS ||
> > +		    prog->aux->attach_btf_id !=3D st_ops->type_id ||
> > +		    prog->expected_attach_type !=3D i) {
> > +			err =3D -EINVAL;
> > +			goto reset_unlock;
> > +		}
> > +
> > +		err =3D arch_prepare_bpf_trampoline(image,
> > +						  st_map->image + PAGE_SIZE,
> > +						  &st_ops->func_models[i], 0,
> > +						  &prog, 1, NULL, 0, NULL);
> > +		if (err < 0)
> > +			goto reset_unlock;
> > +
> > +		*(void **)(kdata + moff) =3D image;
> > +		image +=3D err;
> > +
> > +		/* put prog_id to udata */
> > +		*(unsigned long *)(udata + moff) =3D prog->aux->id;
udata (with all progs' id) will be returned during lookup_elem().

> > +	}
> > +
> > +	refcount_set(&kvalue->refcnt, 1);
> > +	bpf_map_inc(map);
> > +
> > +	err =3D st_ops->reg(kdata);
> > +	if (!err) {
> > +		/* Pair with smp_load_acquire() during lookup */
> > +		smp_store_release(&kvalue->state, BPF_STRUCT_OPS_STATE_INUSE);
>=20
> Is there a reason using READ_ONCE/WRITE_ONCE pair is not enough?
The intention is to ensure lookup_elem() can see all the progs' id once
the state is set to BPF_STRUCT_OPS_STATE_INUSE.

Is READ_ONCE/WRITE_ONCE enough to do this?

>=20
> > +		goto unlock;
> > +	}
> > +
> > +	/* Error during st_ops->reg() */
> > +	bpf_map_put(map);
> > +
> > +reset_unlock:
> > +	bpf_struct_ops_map_put_progs(st_map);
> > +	memset(uvalue, 0, map->value_size);
> > +	memset(kvalue, 0, map->value_size);
> > +
> > +unlock:
> > +	spin_unlock(&st_map->lock);
> > +	return err;
> > +}
> [...]
> > +static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
> > +{
> > +	const struct bpf_struct_ops *st_ops;
> > +	size_t map_total_size, st_map_size;
> > +	struct bpf_struct_ops_map *st_map;
> > +	const struct btf_type *t, *vt;
> > +	struct bpf_map_memory mem;
> > +	struct bpf_map *map;
> > +	int err;
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return ERR_PTR(-EPERM);
> > +
> > +	st_ops =3D bpf_struct_ops_find_value(attr->btf_vmlinux_value_type_id)=
;
> > +	if (!st_ops)
> > +		return ERR_PTR(-ENOTSUPP);
> > +
> > +	vt =3D st_ops->value_type;
> > +	if (attr->value_size !=3D vt->size)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	t =3D st_ops->type;
> > +
> > +	st_map_size =3D sizeof(*st_map) +
> > +		/* kvalue stores the
> > +		 * struct bpf_struct_ops_tcp_congestions_ops
> > +		 */
> > +		(vt->size - sizeof(struct bpf_struct_ops_value));
> > +	map_total_size =3D st_map_size +
> > +		/* uvalue */
> > +		sizeof(vt->size) +
> > +		/* struct bpf_progs **progs */
> > +		 btf_type_vlen(t) * sizeof(struct bpf_prog *);
> > +	err =3D bpf_map_charge_init(&mem, map_total_size);
> > +	if (err < 0)
> > +		return ERR_PTR(err);
> > +
> > +	st_map =3D bpf_map_area_alloc(st_map_size, NUMA_NO_NODE);
> > +	if (!st_map) {
> > +		bpf_map_charge_finish(&mem);
> > +		return ERR_PTR(-ENOMEM);
> > +	}
> > +	st_map->st_ops =3D st_ops;
> > +	map =3D &st_map->map;
> > +
> > +	st_map->uvalue =3D bpf_map_area_alloc(vt->size, NUMA_NO_NODE);
> > +	st_map->progs =3D
> > +		bpf_map_area_alloc(btf_type_vlen(t) * sizeof(struct bpf_prog *),
> > +				   NUMA_NO_NODE);
> > +	st_map->image =3D bpf_jit_alloc_exec(PAGE_SIZE);
> > +	if (!st_map->uvalue || !st_map->progs || !st_map->image) {
> > +		bpf_struct_ops_map_free(map);
> > +		bpf_map_charge_finish(&mem);
> > +		return ERR_PTR(-ENOMEM);
> > +	}
> > +
> > +	spin_lock_init(&st_map->lock);
> > +	set_vm_flush_reset_perms(st_map->image);
> > +	set_memory_x((long)st_map->image, 1);
>=20
> Shouldn't this be using text poke as well once you write the image later =
on,
> otherwise we create yet another instance of W+X memory ... :/
Once image is written in update_elem(), it will never be changed.
I can set it to ro after it is written.

>=20
> > +	bpf_map_init_from_attr(map, attr);
> > +	bpf_map_charge_move(&map->memory, &mem);
> > +
> > +	return map;
> > +}
> > +
> > +const struct bpf_map_ops bpf_struct_ops_map_ops =3D {
> > +	.map_alloc_check =3D bpf_struct_ops_map_alloc_check,
> > +	.map_alloc =3D bpf_struct_ops_map_alloc,
> > +	.map_free =3D bpf_struct_ops_map_free,
> > +	.map_get_next_key =3D bpf_struct_ops_map_get_next_key,
> > +	.map_lookup_elem =3D bpf_struct_ops_map_lookup_elem,
> > +	.map_delete_elem =3D bpf_struct_ops_map_delete_elem,
> > +	.map_update_elem =3D bpf_struct_ops_map_update_elem,
> > +	.map_seq_show_elem =3D bpf_struct_ops_map_seq_show_elem,
> > +};
> [...]
