Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3365212766D
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 08:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfLTHWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 02:22:37 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52184 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726002AbfLTHWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 02:22:37 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBK7Ku9q031630;
        Thu, 19 Dec 2019 23:22:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8ikAxRkEDSy1TDcLXmbDjQxdKg5XTMNWuVBYMZhykfo=;
 b=Zew517vdMplsttiAp9EH6AaTUcr9GpPlR6arHzbb4btNsaQnoAOURszYtitfhtN2HNpe
 +n/AlK2HCBIyVz7dwIwSLi5fe2I3ctXlJaOfxiKSdza0ilk6KX8EoblcHeB0ZO700B8M
 vFNBUw93xYRpr5fmBuaV9x3xsa/sR9hLk4g= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2x0h4gj1bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 23:22:20 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 19 Dec 2019 23:22:19 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 19 Dec 2019 23:22:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dw2JAUpTsd/cj/LG44SuIDXEUQzDeNDdvF7otQNb5dlHjl7IH3sfDhE6KSkvCdOkiL9PaVFmyQDpVO5oTB4z7AvFCD0Gu4fNetcRfRICB0bpSMa5h86d1iNK3MZ7dyhin2YlK9AkOUog3adZhrlv8bBBriSx8Hm8nQTdLf1Ek6WsdXK1xOql44ybxISRQM+46Xvl+MnAETOx88CAANEydgFqbLhKSbiNsuyWT1lCpOvKrjmdOz6YP7+M8UuE6CWpZj+MN/ZZMeInvpKlZAMaST45I9JyByZUhAUFz3aX1w0tTTs7U2nAJWvddwrNvkcXzZr0MdfOFgDBhZW71vA6sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ikAxRkEDSy1TDcLXmbDjQxdKg5XTMNWuVBYMZhykfo=;
 b=Fd2CMgzEpjVvGf79o0Jczptvk4ROPSoMJ7Q8/Med3YxAwfRVbQ4TI2zSWs5xN2iEewGDVqlSLd2+5OcDzXy5WzQqB9A5Z97gP664mU/KeEDHcsM8V8a+7TuYWmGWVJXLySvwMO8BGFzFAmLFUBzic73wqMbbZV4m39+YDazImO62SfgSAxCNH+sy5PWzUpoV2uUuFtFcfSHsU8Y1SKaiWEsWVxVJ7gh+KPmwoOE0uwzvh8rdBXXgjrU8GkKoDmBGpaBHpYtkZPrIH9sgPf+vFzfEbtjpJxmBNYXHRweNG0B0gn+r+A21WtJWFuLxmRv9EnuaWk/uVKpJ2nSOrlMUJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ikAxRkEDSy1TDcLXmbDjQxdKg5XTMNWuVBYMZhykfo=;
 b=PUyZZyegXLnrP4zS+JYj/VKpXr+EHVEKoCOc6hCppAv35iu5f8Vup6uttPo7UDdIV8Lw5h8dEnAk6ahwiRJu/fiUNRdMLkzuqrGeODioAAqopJIDUU9PI8Or8KyHZpvtHw3u4l8nX4910IHeNAqbfF4YzGIDEotozYUrYEUzN+0=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3215.namprd15.prod.outlook.com (20.178.255.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Fri, 20 Dec 2019 07:22:18 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2538.019; Fri, 20 Dec 2019
 07:22:18 +0000
From:   Martin Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 06/13] bpf: Introduce  BPF_MAP_TYPE_STRUCT_OPS
Thread-Topic: [PATCH bpf-next 06/13] bpf: Introduce  BPF_MAP_TYPE_STRUCT_OPS
Thread-Index: AQHVtwY1LJ1bT9dZQEGGVICfqJBmqw==
Date:   Fri, 20 Dec 2019 07:22:17 +0000
Message-ID: <20191220072150.flfxsix4s6jndswn@kafai-mbp>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004751.1652774-1-kafai@fb.com>
 <6ca4e58d-4bb3-bb4b-0fe2-e10a29a53d1f@fb.com>
In-Reply-To: <6ca4e58d-4bb3-bb4b-0fe2-e10a29a53d1f@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR15CA0042.namprd15.prod.outlook.com
 (2603:10b6:300:ad::28) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::e3e5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6be7ed96-8f35-4942-999e-08d7851d5839
x-ms-traffictypediagnostic: MN2PR15MB3215:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB32158318B81A57A8A357E074D52D0@MN2PR15MB3215.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 025796F161
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(39860400002)(376002)(346002)(366004)(396003)(136003)(43544003)(199004)(189003)(30864003)(6636002)(1076003)(6506007)(8936002)(186003)(81156014)(66556008)(66476007)(66946007)(64756008)(53546011)(66446008)(2906002)(5660300002)(8676002)(33716001)(316002)(6862004)(81166006)(9686003)(4326008)(52116002)(54906003)(71200400001)(6486002)(6512007)(478600001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3215;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oBxfZeLZx4OJ5c9pDMMx9FHECJBw93NPc2YRbIXyshBiMXFw4izOawJGfJR4pev0mzEwKc8eI3BnMBW+7B7j2VykneWG8AIQbeSoKknkbRiWuTjYzZuGCcPOkAlGkeCkWwBA+UMKLuNoMiI/eD943K9jwhSE/gcC/y4BXEVNiS1DbQ9snjFlM/4bKVqDJlyo2MlfCC2fHWidYq+qhelpEiNVqFHIqvb4dATZDTXe/OLu18pJKVrmhR6ScKQO16lQyXr000H185VBGc4DhxsnW5Uzw4Y1vY7ZhgVhrRbHzEmWzR3M0DdsixUQ0lhkaFoKgLNfjMjy59HXo8/4PZz+Zw8JrBEHNZOB7TQ1w79/sR58w7fLPKCgLius0ZU8KwnP6yX4ZNW+gRh2pYh7+1uqZ6qWl4YwScc9QR/79k9ieFWPWd3zdPq4ofS637r3ElIQ2rtzQnGLbbjMALiutEr5hWh/xbeW6AZmxpZj6YRpOwe25hxBrxp/zFYtBDakdaE6
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BF33E576E8DCE74D85E6C4A353664402@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be7ed96-8f35-4942-999e-08d7851d5839
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2019 07:22:17.9358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mdqgia3rWKPmeurTT/49z+CLTZ/oEhF22E9+TtjcwF3ERr7CKhpMdNOeTu62chsT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3215
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_08:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 adultscore=0 impostorscore=0 mlxscore=0
 spamscore=0 clxscore=1015 suspectscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=846 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912200057
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 11:48:18PM -0800, Yonghong Song wrote:
>=20
>=20
> On 12/13/19 4:47 PM, Martin KaFai Lau wrote:
> > The patch introduces BPF_MAP_TYPE_STRUCT_OPS.  The map value
> > is a kernel struct with its func ptr implemented in bpf prog.
> > This new map is the interface to register/unregister/introspect
> > a bpf implemented kernel struct.
> >=20
> > The kernel struct is actually embedded inside another new struct
> > (or called the "value" struct in the code).  For example,
> > "struct tcp_congestion_ops" is embbeded in:
> > struct __bpf_tcp_congestion_ops {
> > 	refcount_t refcnt;
> > 	enum bpf_struct_ops_state state;
> > 	struct tcp_congestion_ops data;  /* <-- kernel subsystem struct here *=
/
> > }
> > The map value is "struct __bpf_tcp_congestion_ops".  The "bpftool map d=
ump"
> > will then be able to show the state ("inuse"/"tobefree") and the number=
 of
> > subsystem's refcnt (e.g. number of tcp_sock in the tcp_congestion_ops c=
ase).
> > This "value" struct is created automatically by a macro.  Having a sepa=
rate
> > "value" struct will also make extending "struct __bpf_XYZ" easier (e.g.=
 adding
> > "void (*init)(void)" to "struct __bpf_XYZ" to do some initialization
> > works before registering the struct_ops to the kernel subsystem).
> > The libbpf will take care of finding and populating the "struct __bpf_X=
YZ"
> > from "struct XYZ".
> >=20
> > Register a struct_ops to a kernel subsystem:
> > 1. Load all needed BPF_PROG_TYPE_STRUCT_OPS prog(s)
> > 2. Create a BPF_MAP_TYPE_STRUCT_OPS with attr->btf_vmlinux_value_type_i=
d
> >     set to the btf id "struct __bpf_tcp_congestion_ops" of the running
> >     kernel.
> >     Instead of reusing the attr->btf_value_type_id, btf_vmlinux_value_t=
ype_id
> >     is added such that attr->btf_fd can still be used as the "user" btf
> >     which could store other useful sysadmin/debug info that may be
> >     introduced in the furture,
> >     e.g. creation-date/compiler-details/map-creator...etc.
> > 3. Create a "struct __bpf_tcp_congestion_ops" object as described in
> >     the running kernel btf.  Populate the value of this object.
> >     The function ptr should be populated with the prog fds.
> > 4. Call BPF_MAP_UPDATE with the object created in (3) as
> >     the map value.  The key is always "0".
>=20
> This is really a special one element map. The key "0" should work.
> Not sure whether we should generalize this and maps for global variables
> to a kind of key-less map. Just some thought.
key-less.  I think it mostly means, no key is passed or pass NULL
as a key.  Not sure if it worths the uapi and userspace disruption,
e.g. think about "bpftool map dump".
I did try to add new bpf cmd to do register/unregister
which do not need the key.  I stopped in the middle because
it does not worth it when considering the lookup side also.

Also, like the global value map, the attr->btf_key_type_id is 0
which is a "void" btf-type and I think it is an as good way as
saying it is keyless.  The bpftool is already ready for this keyless
signal.  The difference between passing 0 or NULL to represent
"void" key is also arguably less. =20
In struct_ops case, only btf_vmlinux_value_type_id is added but
not for the key. =20

>=20
> >=20
> > During BPF_MAP_UPDATE, the code that saves the kernel-func-ptr's
> > args as an array of u64 is generated.  BPF_MAP_UPDATE also allows
> > the specific struct_ops to do some final checks in "st_ops->init_member=
()"
> > (e.g. ensure all mandatory func ptrs are implemented).
> > If everything looks good, it will register this kernel struct
> > to the kernel subsystem.  The map will not allow further update
> > from this point.
> >=20
> > Unregister a struct_ops from the kernel subsystem:
> > BPF_MAP_DELETE with key "0".
> >=20
> > Introspect a struct_ops:
> > BPF_MAP_LOOKUP_ELEM with key "0".  The map value returned will
> > have the prog _id_ populated as the func ptr.
> >=20
> > The map value state (enum bpf_struct_ops_state) will transit from:
> > INIT (map created) =3D>
> > INUSE (map updated, i.e. reg) =3D>
> > TOBEFREE (map value deleted, i.e. unreg)
> >=20
> > Note that the above state is not exposed to the uapi/bpf.h.
> > It will be obtained from the btf of the running kernel.
>=20
> It is not really from btf, right? It is from kernel internal
> data structure which will be copied to user space.
>=20
> Since such information is available to bpftool dump and is common
> to all st_ops maps. I am wondering whether we should expose
> this through uapi.
The data is from the kernel-map's value.

The enum's type and its values' "string", meaning "INIT", "INUSE",
and "TOBEFREE" are from the kernel BTF.  These do not need to be
exposed in uapi.  kernel BTF is the way to get them.

[ ... ]

> > +/* __bpf_##_name (e.g. __bpf_tcp_congestion_ops) is the map's value
> > + * exposed to the userspace and its btf-type-id is stored
> > + * at the map->btf_vmlinux_value_type_id.
> > + *
> > + * The *_name##_dummy is to ensure the BTF type is emitted.
> > + */
> > +
> >   #define BPF_STRUCT_OPS_TYPE(_name)				\
> > -extern struct bpf_struct_ops bpf_##_name;
> > +extern struct bpf_struct_ops bpf_##_name;			\
> > +								\
> > +static struct __bpf_##_name {					\
> > +	BPF_STRUCT_OPS_COMMON_VALUE;				\
> > +	struct _name data ____cacheline_aligned_in_smp;		\
> > +} *_name##_dummy;
>=20
> There are other ways to retain types in debug info without
> creating new variables. For example, you can use it in a cast
> like
>      (void *)(struct __bpf_##_name *)v
hmm... What is v?

> Not sure whether we could easily find a place for such casting or not.
>=20
> >   #include "bpf_struct_ops_types.h"
> >   #undef BPF_STRUCT_OPS_TYPE
> >  =20
> > @@ -37,19 +97,46 @@ const struct bpf_verifier_ops bpf_struct_ops_verifi=
er_ops =3D {
> >   const struct bpf_prog_ops bpf_struct_ops_prog_ops =3D {
> >   };
> >  =20
> > +static const struct btf_type *module_type;
> > +
> >   void bpf_struct_ops_init(struct btf *_btf_vmlinux)
> >   {
> > +	char value_name[128] =3D VALUE_PREFIX;
> > +	s32 type_id, value_id, module_id;
> >   	const struct btf_member *member;
> >   	struct bpf_struct_ops *st_ops;
> >   	struct bpf_verifier_log log =3D {};
> >   	const struct btf_type *t;
> >   	const char *mname;
> > -	s32 type_id;
> >   	u32 i, j;
> >  =20
> > +	/* Avoid unused var compiler warning */
> > +#define BPF_STRUCT_OPS_TYPE(_name) (void)(_name##_dummy);
> > +#include "bpf_struct_ops_types.h"
> > +#undef BPF_STRUCT_OPS_TYPE
> > +
> > +	module_id =3D btf_find_by_name_kind(_btf_vmlinux, "module",
> > +					  BTF_KIND_STRUCT);
> > +	if (module_id < 0) {
> > +		pr_warn("Cannot find struct module in btf_vmlinux\n");
> > +		return;
> > +	}
> > +	module_type =3D btf_type_by_id(_btf_vmlinux, module_id);
> > +
> >   	for (i =3D 0; i < ARRAY_SIZE(bpf_struct_ops); i++) {
> >   		st_ops =3D bpf_struct_ops[i];
> >  =20
> > +		value_name[VALUE_PREFIX_LEN] =3D '\0';
> > +		strncat(value_name + VALUE_PREFIX_LEN, st_ops->name,
> > +			sizeof(value_name) - VALUE_PREFIX_LEN - 1);
>=20
> Do we have restrictions on the length of st_ops->name?
> We probably do not want truncation, right?
It is unlikely the following btf_find_by_name_kind() would succeed.

I will add a check here to ensure no truncation.

>=20
> > +		value_id =3D btf_find_by_name_kind(_btf_vmlinux, value_name,
> > +						 BTF_KIND_STRUCT);
> > +		if (value_id < 0) {
> > +			pr_warn("Cannot find struct %s in btf_vmlinux\n",
> > +				value_name);
> > +			continue;
> > +		}
> > +
> >   		type_id =3D btf_find_by_name_kind(_btf_vmlinux, st_ops->name,
> >   						BTF_KIND_STRUCT);
> >   		if (type_id < 0) {

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
>=20
> Do we still want to check whether image out of page boundary or not?
It should never happen.  It would be too late to check here also.

The BPF_STRUCT_OPS_MAX_NR_MEMBERS (which is 64) is picked
based on each trampoline will take less than 64 bytes.
Thus, PAGE_SIZE / 64(bytes) =3D> 64 members

I can add a BUILD_BUG_ON() to ensure the future BPF_STRUCT_OPS_MAX_NR_MEMBE=
RS
change won't violate this.

>=20
> > +
> > +		/* put prog_id to udata */
> > +		*(unsigned long *)(udata + moff) =3D prog->aux->id;
> > +	}
> > +
> > +	refcount_set(&kvalue->refcnt, 1);
> > +	bpf_map_inc(map);
> > +
> > +	err =3D st_ops->reg(kdata);
> > +	if (!err) {
> > +		smp_store_release(&kvalue->state, BPF_STRUCT_OPS_STATE_INUSE);
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
> > +
> > +static int bpf_struct_ops_map_delete_elem(struct bpf_map *map, void *k=
ey)
> > +{
> > +	enum bpf_struct_ops_state prev_state;
> > +	struct bpf_struct_ops_map *st_map;
> > +
> > +	st_map =3D (struct bpf_struct_ops_map *)map;
> > +	prev_state =3D cmpxchg(&st_map->kvalue.state,
> > +			     BPF_STRUCT_OPS_STATE_INUSE,
> > +			     BPF_STRUCT_OPS_STATE_TOBEFREE);
> > +	if (prev_state =3D=3D BPF_STRUCT_OPS_STATE_INUSE) {
> > +		st_map->st_ops->unreg(&st_map->kvalue.data);
> > +		if (refcount_dec_and_test(&st_map->kvalue.refcnt))
> > +			bpf_map_put(map);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> [...]
