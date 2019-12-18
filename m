Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6357124E0E
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfLRQld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:41:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29438 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726980AbfLRQld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:41:33 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBIGc3c6024199;
        Wed, 18 Dec 2019 08:41:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=PQO02Bso14LDHjrBTdl9ciClaNg9y86UvTGFnIbdg5o=;
 b=k6VP2UgqS2+3mMYmxJPunqlCeN44r3BGAo2SEMkQwPO+T6svUrgdSMHa3vLOqBMbImR/
 /wJo0zGj9Plyl2RB5b85jEwVpnPXPf1m2yHGYZTQI3lOO2PWnaSffJ4sjOOVrkvQGuLk
 v9EnEYlcXEOiek+/RcUzxj1nCHVSjxd65Go= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2wyc7tau8j-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Dec 2019 08:41:16 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 18 Dec 2019 08:41:15 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 18 Dec 2019 08:41:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fYYclG/xHqoN0VeMFn5KVApJSBloHDKmKih0zgHGSG9s0GoJRe4O7EwV7V+VOdfTgucUDX3Dik/DKxW+gwFLPf5zBSEET9YUCdbMJn548qabOw2caI1MQ+vgFCJ3EkAT0awL/zPwToBOoKKub/HBnStvothjaXAE93ZNYCZW0eDxMMtM0uSWBXpYdO+MNhBwjQGJ+0gX/Fnjc1wQK0FQDDRoLRbkbDIAikig7rdUjB8NnPEXrn7J5d2nKvaFP3u6Z2aJ5TLTX7E1oWwZd4vinoD2jX1m7CA5pOIiqSo60H79VEBhMaVHgGsgnX39BPDMyUSAzkyQ1+KqqKp2CJ4qqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQO02Bso14LDHjrBTdl9ciClaNg9y86UvTGFnIbdg5o=;
 b=nfvKpfgOM7U56PQ6bSBPbID05jXR8Ycb+oHfTH1mYxtkuiLr2WGaGfkBa5EjeqRXJbmueOWOjh7UjnEB8RLSDrCNwEUVMPFeWLCwlGWjr1Zn/XymeqEhxcsymVDzxBCU3LGF70YO9Klk8U+Ud3w3HtTQxuZQfpbFqpqgxqYCgDhO57wMoqNM0vtngoZEMhG2RCIkxTkFQKsn7G1ZmurrP4UK1WUD8ciYioqZ80hkcZTYMFw47CxGGqaJf1KKcdJshZKKtPln54i1Qv5zHyRuTOEVqFL2naVuNKh5xaWpYtMIzsEc0ZncvlmeKsU3dRU0stVfezmw89Js4gh5fe1e9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQO02Bso14LDHjrBTdl9ciClaNg9y86UvTGFnIbdg5o=;
 b=DmxhjHyNu+8s04F9MAE76nHZ/HSHY3JszM/mNlNWH6wOjcMqIskeIY0clmECJwDiyarh9en6E4UAZb8Ba1zqQ5offDDv5D9FaDyjaXbfC3Jc+t7T/NB4eXl2tZ7+BIe7eRDTRq7cJ0CJllt1Bmwj5ziENJtgArGR/rAT77JZqXY=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3040.namprd15.prod.outlook.com (20.178.253.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Wed, 18 Dec 2019 16:41:13 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 16:41:13 +0000
From:   Martin Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 05/13] bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS
Thread-Topic: [PATCH bpf-next 05/13] bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS
Thread-Index: AQHVshgrd/clsK4fI0aOx690c28b0qe93jKAgAJBggA=
Date:   Wed, 18 Dec 2019 16:41:13 +0000
Message-ID: <20191218164108.uxw7eu4lj5tabqj5@kafai-mbp.dhcp.thefacebook.com>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004748.1652668-1-kafai@fb.com>
 <5864844f-db69-d025-1eb3-f856257415be@fb.com>
In-Reply-To: <5864844f-db69-d025-1eb3-f856257415be@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:300:4b::18) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::afeb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2e06ef3-c22d-48a2-08b3-08d783d9181a
x-ms-traffictypediagnostic: MN2PR15MB3040:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB304078E4667BD88ED6B76641D5530@MN2PR15MB3040.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(396003)(376002)(136003)(366004)(51914003)(199004)(189003)(8676002)(81156014)(81166006)(86362001)(6636002)(71200400001)(186003)(4326008)(66946007)(66476007)(66556008)(64756008)(66446008)(2906002)(8936002)(6506007)(478600001)(52116002)(1076003)(6862004)(9686003)(5660300002)(6486002)(54906003)(316002)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3040;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YvitpvoriqEiTUkT5wjawMZ9k4SPdnyY9zI3hzTHMmeP9Jc+66xcSK7jw8gc/ZQTHSX2PdVAJmMxblhif9OWLWVPS9cMtAmrlIYOV/nFiBszJkb4qWTp1KlpXVdD46XOaIJd9VHMgBv9plOqumgS81bp/fjGY/NIGy3ujYtMmkLPNqPps1hBXfFX3+KxP4Tf7guhNARfb5J4+vk+IRZO+HNt5V9q9/K3268+bdCYyw6jCCf+X0Ke2Pqk0XN151NU43p0/kCj0TwFyQpFamdi2QeZL7nEroWCchWL2ct/AZg4a1PCGUd4TwYM4RY6vbp5sF6p55KA5gZjYYm5qGAHdW/97zu0zi+Evr7uVvX/ng64qvktdrdVWSN8O8reqxEAqDGW7Ioqr99iEYRip+p50X30dGa7uSsw/qEfjZkRHYZ2Rxk9V3bGshjl67N987EFGlBBGHHMC/AJ3cU+Td73Zm5Hu/9zMr7xeOx90jy4+B7/zTs01Ag2A5JnZy7YP6vX
Content-Type: text/plain; charset="us-ascii"
Content-ID: <428845437736FA41B135B9CE50B283C6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d2e06ef3-c22d-48a2-08b3-08d783d9181a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 16:41:13.3474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dWLUWlsHDuh0/O5WTSF5XDAk6YgNmFZGWQS/1QFR0oagjreHXGf5ucn4I9VhcY2G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3040
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_05:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 spamscore=0
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180137
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 10:14:09PM -0800, Yonghong Song wrote:

[ ... ]

> > +void bpf_struct_ops_init(struct btf *_btf_vmlinux)
> > +{
> > +	const struct btf_member *member;
> > +	struct bpf_struct_ops *st_ops;
> > +	struct bpf_verifier_log log =3D {};
> > +	const struct btf_type *t;
> > +	const char *mname;
> > +	s32 type_id;
> > +	u32 i, j;
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(bpf_struct_ops); i++) {
> > +		st_ops =3D bpf_struct_ops[i];
> > +
> > +		type_id =3D btf_find_by_name_kind(_btf_vmlinux, st_ops->name,
> > +						BTF_KIND_STRUCT);
> > +		if (type_id < 0) {
> > +			pr_warn("Cannot find struct %s in btf_vmlinux\n",
> > +				st_ops->name);
> > +			continue;
> > +		}
> > +		t =3D btf_type_by_id(_btf_vmlinux, type_id);
> > +		if (btf_type_vlen(t) > BPF_STRUCT_OPS_MAX_NR_MEMBERS) {
> > +			pr_warn("Cannot support #%u members in struct %s\n",
> > +				btf_type_vlen(t), st_ops->name);
> > +			continue;
> > +		}
> > +
> > +		for_each_member(j, t, member) {
> > +			const struct btf_type *func_proto;
> > +
> > +			mname =3D btf_name_by_offset(_btf_vmlinux,
> > +						   member->name_off);
> > +			if (!*mname) {
> > +				pr_warn("anon member in struct %s is not supported\n",
> > +					st_ops->name);
> > +				break;
> > +			}
> > +
> > +			if (btf_member_bitfield_size(t, member)) {
> > +				pr_warn("bit field member %s in struct %s is not supported\n",
> > +					mname, st_ops->name);
> > +				break;
> > +			}
> > +
> > +			func_proto =3D btf_type_resolve_func_ptr(_btf_vmlinux,
> > +							       member->type,
> > +							       NULL);
> > +			if (func_proto &&
> > +			    btf_distill_func_proto(&log, _btf_vmlinux,
> > +						   func_proto, mname,
> > +						   &st_ops->func_models[j])) {
> > +				pr_warn("Error in parsing func ptr %s in struct %s\n",
> > +					mname, st_ops->name);
> > +				break;
> > +			}
> > +		}
> > +
> > +		if (j =3D=3D btf_type_vlen(t)) {
> > +			if (st_ops->init(_btf_vmlinux)) {
>=20
> is it possible that st_ops->init might be a NULL pointer?
Not now.  The check could be added if there would be
struct_ops that does not need init.

>=20
> > +				pr_warn("Error in init bpf_struct_ops %s\n",
> > +					st_ops->name);
> > +			} else {
> > +				st_ops->type_id =3D type_id;
> > +				st_ops->type =3D t;
> > +			}
> > +		}
> > +	}
> > +}

[ ... ]

> > @@ -6343,8 +6353,30 @@ static int check_ld_abs(struct bpf_verifier_env =
*env, struct bpf_insn *insn)
> >   static int check_return_code(struct bpf_verifier_env *env)
> >   {
> >   	struct tnum enforce_attach_type_range =3D tnum_unknown;
> > +	const struct bpf_prog *prog =3D env->prog;
> >   	struct bpf_reg_state *reg;
> >   	struct tnum range =3D tnum_range(0, 1);
> > +	int err;
> > +
> > +	/* The struct_ops func-ptr's return type could be "void" */
> > +	if (env->prog->type =3D=3D BPF_PROG_TYPE_STRUCT_OPS &&
> > +	    !prog->aux->attach_func_proto->type)
> > +		return 0;
> > +
> > +	/* eBPF calling convetion is such that R0 is used
> > +	 * to return the value from eBPF program.
> > +	 * Make sure that it's readable at this time
> > +	 * of bpf_exit, which means that program wrote
> > +	 * something into it earlier
> > +	 */
> > +	err =3D check_reg_arg(env, BPF_REG_0, SRC_OP);
> > +	if (err)
> > +		return err;
> > +
> > +	if (is_pointer_value(env, BPF_REG_0)) {
> > +		verbose(env, "R0 leaks addr as return value\n");
> > +		return -EACCES;
> > +	}
> >  =20
> >   	switch (env->prog->type) {
> >   	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
> > @@ -8010,21 +8042,6 @@ static int do_check(struct bpf_verifier_env *env=
)
> >   				if (err)
> >   					return err;
> >  =20
> > -				/* eBPF calling convetion is such that R0 is used
> > -				 * to return the value from eBPF program.
> > -				 * Make sure that it's readable at this time
> > -				 * of bpf_exit, which means that program wrote
> > -				 * something into it earlier
> > -				 */
> > -				err =3D check_reg_arg(env, BPF_REG_0, SRC_OP);
> > -				if (err)
> > -					return err;
> > -
> > -				if (is_pointer_value(env, BPF_REG_0)) {
> > -					verbose(env, "R0 leaks addr as return value\n");
> > -					return -EACCES;
> > -				}
> > -
> >   				err =3D check_return_code(env);
> >   				if (err)
> >   					return err;
> > @@ -8833,12 +8850,14 @@ static int convert_ctx_accesses(struct bpf_veri=
fier_env *env)
> >   			convert_ctx_access =3D bpf_xdp_sock_convert_ctx_access;
> >   			break;
> >   		case PTR_TO_BTF_ID:
> > -			if (type =3D=3D BPF_WRITE) {
> > +			if (type =3D=3D BPF_READ) {
> > +				insn->code =3D BPF_LDX | BPF_PROBE_MEM |
> > +					BPF_SIZE((insn)->code);
> > +				env->prog->aux->num_exentries++;
> > +			} else if (env->prog->type !=3D BPF_PROG_TYPE_STRUCT_OPS) {
> >   				verbose(env, "Writes through BTF pointers are not allowed\n");
> >   				return -EINVAL;
> >   			}
> > -			insn->code =3D BPF_LDX | BPF_PROBE_MEM | BPF_SIZE((insn)->code);
> > -			env->prog->aux->num_exentries++;
>=20
> Do we need to increase num_exentries for BPF_WRITE as well?
Not needed since it does not need to gen exentry
for this write access for BPF_PROG_TYPE_STRUCT_OPS.

The individual struct_ops (e.g. the bpf_tcp_ca_btf_struct_access()
in patch 7) ensures the write is fine, which is like the
current convert_ctx_access() in filter.c but with the BTF help.

I will add some comments on this.

Thanks for the review!
