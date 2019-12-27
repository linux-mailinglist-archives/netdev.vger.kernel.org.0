Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E2812B1A9
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 07:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfL0GQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 01:16:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47320 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725904AbfL0GQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 01:16:45 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBR6DO3R027965;
        Thu, 26 Dec 2019 22:16:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=lG+XU52dl9idH+AP7JmgFEcBS6kFgklZmiDnyj2DjOA=;
 b=pwKLCC7e7//lfttEtfC1THoDvWJyL9+Y7ZuM+bEJS9QGmtkMv3+SfbaFDOf8LY/8Ehjq
 M7OGpGXynOrr/NN5/WTG2cGQ3a6XPi7rFblEeJRyz7BzZ8lnozW3PYw+G+0yl8cSgpz6
 Z+cbR2GWD4kVhHsNJ5+GSAUpuQbSx6EJUyU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2x4puykxj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 26 Dec 2019 22:16:30 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 26 Dec 2019 22:16:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sg4K71cFULf32LiAZJ1BFvoKTIg45MnQTp1PhHlgv/ev3OqjBIvQrjbIVJfivbKCjXaRukVKRIY2qzlgVcuufu6ijiym6/gMceFNitq8JtDOMjqwrhrhlTuK9/h/lSoANPQOYObGb+nzp/tsmwToXQ9KiiE+Gv3IxKFAinqJR24Y+sFQAOxLIPYew1JyIyBii2sUeIePtrr+fb0K3OuWlRNuXfWKzAoG7PNSBgEvlJdjHYZqCsXRqI4NvFzaxCngLczLwq0jMX6Y8vYW9wLIep6ohrmg+GszipFPaQBvhfVOwu6O353l70K28HAFEXbW1EP1or0G1cCwAOvergppbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lG+XU52dl9idH+AP7JmgFEcBS6kFgklZmiDnyj2DjOA=;
 b=D9BzcuVnwnB0FjKvz2TUF+ck5ILaG2V1BjGk2cCjDzou6nXaj06MNZtb9cV0/fY/q0vIVFuzHCO0t4HjqwRjHGQQBpL92Bdb2Gb2xyLn2OJpJtx0Sczngxmh7KR0rWUiORscXXHiw637Q7iMX7/5LKrZ1yBvrSvmxLgWSBHvIa6zACrs+w5iIvXGwIiXTCN1U2U9lHcGb5H2llG6V/LDX93/Rc7djBI80w8S5Y9JcrXUdeP25coT7vNMLycmfVl2NMTQQohizpEAKp2RjIatssv5Vz0ByfJgSrttDQ4jLXomlm3BpJMiegzj8yCnUg/X5Tf224rWl8y/DBy5crXypQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lG+XU52dl9idH+AP7JmgFEcBS6kFgklZmiDnyj2DjOA=;
 b=BNfeiVj8CxS9Ip7hM5iUBOBdhtOeqrS500FQZh8FVOyC/i1k6gI7KvqtWFP7751TMiVhGddc0PkYa7E/htT2v/B4n/iyPX+8moATSiRq4nSYJtwuPabNUmiMoRoyv2htXbibi7kYBLtA9l823yalKB7Kp4DdBpxMbNJB7h1G3rE=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2800.namprd15.prod.outlook.com (20.179.148.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Fri, 27 Dec 2019 06:16:28 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2559.017; Fri, 27 Dec 2019
 06:16:28 +0000
Received: from kafai-mbp (2620:10d:c090:180::150c) by CO2PR04CA0170.namprd04.prod.outlook.com (2603:10b6:104:4::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Fri, 27 Dec 2019 06:16:26 +0000
From:   Martin Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Topic: [PATCH bpf-next v2 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Index: AQHVt8eKCw0H8YSIj0iyCJPN6l8CHKfIJvAAgAVj04A=
Date:   Fri, 27 Dec 2019 06:16:28 +0000
Message-ID: <20191227061623.fdy5vhau5ea436y3@kafai-mbp>
References: <20191221062556.1182261-1-kafai@fb.com>
 <20191221062608.1183091-1-kafai@fb.com>
 <921201ff-8c8d-b523-5df6-3326f6cd0fd9@fb.com>
In-Reply-To: <921201ff-8c8d-b523-5df6-3326f6cd0fd9@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0170.namprd04.prod.outlook.com
 (2603:10b6:104:4::24) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::150c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79149495-c646-4365-e96e-08d78a944ed5
x-ms-traffictypediagnostic: MN2PR15MB2800:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2800D7400A68702131F2042ED52A0@MN2PR15MB2800.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0264FEA5C3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(366004)(346002)(376002)(136003)(189003)(199004)(81166006)(8676002)(9686003)(55016002)(81156014)(8936002)(33716001)(71200400001)(86362001)(6636002)(4326008)(6862004)(5660300002)(316002)(16526019)(478600001)(52116002)(2906002)(66476007)(6496006)(66946007)(186003)(54906003)(64756008)(66446008)(66556008)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2800;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8LDzhlByx+Dw3faDQfGZIZ7H/6oAWiO2+BqLL0j5Jyyo5FT4z8DrqxkObjIjtcdmlcEREqk4YjfAIwjsurXehRAPW7i4GlfeICESPmoWkpm4HW6xWScE+dJDcgLFuYzw+3lLPS2NxWJ2dh3sEWqYgFnNailxV6D+zfu611Mh4c7RAmhEOCWwlUD22H3nyjEajDewybsojZVABl/vwfwudUb/UjuBWCAtd6LOttkg8UJNNPAKRDIpTSusJsQcaxJEDkObDkBTvMLVfKVPnzSnQYQ3G3AqSZ/3DTSVh0mhFsL2iAjY5iVrfPty3nytIWL2b1xuRs4DkdsCd3yH0BBXV7UUYeAT5Pz02eEpCJFLSFKD/9ftLNJORVH07G1kpAKggQ0v1q71J9fg6mLMS4FFrQZoMwGz2zTTsW6YYSBLXDKxgN5VjcH8UzsjgGln4KLo
Content-Type: text/plain; charset="us-ascii"
Content-ID: <210537B18F18DE438C69A9CB7621C0F5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 79149495-c646-4365-e96e-08d78a944ed5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Dec 2019 06:16:28.4006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qf4GbiYNe6LQz2aGvapa4WunXiP3avDxJkHhjNWufrFFvLAGbjicn3mKpiACqi19
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2800
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-27_01:2019-12-24,2019-12-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912270048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 11:57:48AM -0800, Yonghong Song wrote:
[ ... ]
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
> > +	uvalue =3D (struct bpf_struct_ops_value *)value;
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
> > +		mtype =3D btf_type_by_id(btf_vmlinux, member->type);
> > +		ptype =3D btf_type_resolve_ptr(btf_vmlinux, member->type, NULL);
> > +		if (ptype =3D=3D module_type) {
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
> > +		if (!btf_type_resolve_func_ptr(btf_vmlinux, member->type,
> > +					       NULL)) {
> > +			u32 msize;
> > +
> > +			mtype =3D btf_resolve_size(btf_vmlinux, mtype,
> > +						 &msize, NULL, NULL);
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
> > +	}
>=20
> Should we check whether user indeed provided `module` member or
> not before declaring success?
hmm.... By 'module', you meant the "if (ptype =3D=3D module_type)" logic
at the beginning?  Yes, it should check user passed 0 also.
will fix.

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
> > +	/* Each trampoline costs < 64 bytes.  Ensure one page
> > +	 * is enough for max number of func ptrs.
> > +	 */
> > +	BUILD_BUG_ON(PAGE_SIZE / 64 < BPF_STRUCT_OPS_MAX_NR_MEMBERS);
>=20
> This maybe true for x86 now, but it may not hold up for future other
> architectures. Not sure whether we should get the value for arch call=20
> backs, or we just bail out during map update if we ever grow exceeds
> one page.
I will reuse the existing WARN_ON_ONCE() check in arch_prepare_bpf_trampoli=
ne().
Need to parameterize the end-of-image (i.e. the current PAGE_SIZE / 2 assum=
ption).

