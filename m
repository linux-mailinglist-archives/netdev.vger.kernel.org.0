Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E22F1338C5
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 02:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgAHBxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 20:53:41 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4718 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726492AbgAHBxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 20:53:40 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0081pqZn008771;
        Tue, 7 Jan 2020 17:53:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8dVkPtK2UYjbpFGiwevQ+3xWTteLUABP13TcFTpRsz0=;
 b=hG3Y/pmbYyrw/tBiG4iuNrPqCD/HrOh9nSseYuOLfXC+h8g15davJBIRhxt1/2HAP45d
 uGkmdAYeu006l+dPPuTWZRkEcLaNri9Sidq+R6Vk9jQHChZOsgH48DSIMVXz6ul6AHJ0
 NRS8YVAqG6ECyQiv2W+8aWC3257TznFhD1c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xd2ac12a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 07 Jan 2020 17:53:28 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 7 Jan 2020 17:53:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHv+BtPs6PnE+nsmvcEt+KD/I3CD4tMACsh044ijE9XY33PexDJ57FH7VrKtuFID52fYbSwz3Bvv5Fxbn/hdFNI4Q3mU0vn3MEAe3fwMagDc9ZvOdbhir4fcRZZQQa/RLYFr6VNkhYMum4JMmaEHQfZGWOdEGucWSu+qgq1lZP1hk+ya0+0mE3Ss4YIxlO7geNtO64ZuBUoiRTKjsU0AS1LV/JF2/odbOnziRzx3TpjA3Tleus9G/1iO+qTXlJ3xJZof7fTx8fLxesybvs2adX8e2qxz/5goZ9B9DElVkYiHC6lSz2yKEIktd/eKSnVJWiHZkwCiOC1x2pT/Se/VNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dVkPtK2UYjbpFGiwevQ+3xWTteLUABP13TcFTpRsz0=;
 b=QuuesQGXu4NEe01Sh2T8JNG35C55xKCexzY3K+/LnalSw/Nn0fo88hZ6mg5slBm9er+a2iB5Y91nWMdLnUsOF0PVLwZOTZ6njYo8w7wPPt3KNh4D7ZawC1skFGL+YmGPk3AHPgpdTRoIeX4oY28A7xJ4HerQzu+xwzNlKb53ZEuCwUmDXaoHPeaEufzaoo6ZrgOEiPzoYQeD4fOdeZwJQ5pTqnRSSUd8AWYvQvWC3SWYQgZf3vQ9dCWmCqfvd0whPJGrNmIJ/9pKZljaZeOgBxPVK4cRtzVA5kLOUjrk5UkTzXe3L+G+P0sl+2K00zjHU67I26cjA2KWpKGIEA1l6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dVkPtK2UYjbpFGiwevQ+3xWTteLUABP13TcFTpRsz0=;
 b=F+pwflki9K6tmeayl1Dgpxe5eYSReBIN3aGMScci3e5SUbTH1m5ZVKyHiaeSBYq2hSThSQz+XQZA6FaquH6rBrpLvQY8Tft03fSvDQuShY7dN6mjeHN6HsbCx6EJvlDUoG8p/AEsV/fW4GC4X0kBQDMTZqP9/bDwRqK+zQMCO/w=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3214.namprd15.prod.outlook.com (20.179.20.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Wed, 8 Jan 2020 01:53:27 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.008; Wed, 8 Jan 2020
 01:53:27 +0000
Received: from kafai-mbp (2620:10d:c090:200::2:58) by MWHPR1201CA0017.namprd12.prod.outlook.com (2603:10b6:301:4a::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.13 via Frontend Transport; Wed, 8 Jan 2020 01:53:25 +0000
From:   Martin Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Topic: [PATCH bpf-next v3 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Index: AQHVxXOq69nZ9rtA9EC7c7DX0CNUqqffjSyAgAAvQYCAAEV9gA==
Date:   Wed, 8 Jan 2020 01:53:26 +0000
Message-ID: <20200108015323.oooj47pybplopzqr@kafai-mbp>
References: <20191231062037.280596-1-kafai@fb.com>
 <20191231062050.281712-1-kafai@fb.com>
 <4d0aafe9-75c7-43fe-d9eb-62bb2053b53e@iogearbox.net>
 <20200107185533.d64lkoqggrdfehga@kafai-mbp>
 <ee7a3631-bb47-3d58-7ad2-431b9af40589@iogearbox.net>
In-Reply-To: <ee7a3631-bb47-3d58-7ad2-431b9af40589@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1201CA0017.namprd12.prod.outlook.com
 (2603:10b6:301:4a::27) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec4434e2-5808-4fcc-7d6f-08d793dd8d69
x-ms-traffictypediagnostic: MN2PR15MB3214:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB321439029A8CA0BBAC900375D53E0@MN2PR15MB3214.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(136003)(366004)(396003)(189003)(51914003)(199004)(186003)(316002)(16526019)(5660300002)(478600001)(52116002)(6496006)(54906003)(53546011)(66476007)(66946007)(64756008)(2906002)(66556008)(1076003)(66446008)(8936002)(33716001)(81166006)(6916009)(71200400001)(81156014)(8676002)(55016002)(4326008)(9686003)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3214;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FGs+o0tfy12lD/3wNuJUuK42gbXRK7YtY6BX5q3wm5ypqvEK8rit+/THmnejeh4irR8diPbxU1KtoXCEvgzdmVoBLzSEen5T80D/4SZOKCaPw4SSZ2Oxjvv58pHahN0eJWU4pZrcLpKdDucPoFuNb7FvMbWburJG/Utc55tXi5oRiy1GUPlWEdv6u096dPtDtVqPc7+DZBeL6wgQfdwhNEXBvi+uRXoDLsFqE+5LFT7q0+qs52JoKW+l/dvAlBGVbUkPFKPrjGet722Ryu+5X1w8s64eJBlBkgqJsHiFDdF+ElY426o37Nwo7vuM1SOMxiziEyHHALwk6BLB5oD/0kKeQzDzqu2eAKv+bTAuTrwF29kib1qM8ZuCBESlhhmJdI4D5hD2XNNfQjnepOHkcfYHDKGZDM8J/d+EEQJUNRt0skiv4/rJTVh8mIs6n846Cs5iHrKwFduPvTD+3qCY7CAKK6K196lpg0nGW2T4MGaJ3FtiXtacbBOL/t/BBIub
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5D3C7FECC9AAFB41A6D6E6B1EA123094@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ec4434e2-5808-4fcc-7d6f-08d793dd8d69
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 01:53:26.8639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rKN/WB9yPvxmDzUjx9VmUddHj0YZKrZpA6vZimn7WkyEpNcl4HXiVkkS6L7ucBcy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3214
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-07_08:2020-01-07,2020-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 mlxlogscore=968
 priorityscore=1501 phishscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001080015
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 10:44:41PM +0100, Daniel Borkmann wrote:
> On 1/7/20 7:55 PM, Martin Lau wrote:
> > On Tue, Jan 07, 2020 at 05:00:37PM +0100, Daniel Borkmann wrote:
> > > On 12/31/19 7:20 AM, Martin KaFai Lau wrote:
> > > [...]
> [...]
> > > > +		err =3D arch_prepare_bpf_trampoline(image,
> > > > +						  st_map->image + PAGE_SIZE,
> > > > +						  &st_ops->func_models[i], 0,
> > > > +						  &prog, 1, NULL, 0, NULL);
> > > > +		if (err < 0)
> > > > +			goto reset_unlock;
> > > > +
> > > > +		*(void **)(kdata + moff) =3D image;
> > > > +		image +=3D err;
> > > > +
> > > > +		/* put prog_id to udata */
> > > > +		*(unsigned long *)(udata + moff) =3D prog->aux->id;
> > udata (with all progs' id) will be returned during lookup_elem().
> >=20
> > > > +	}
> > > > +
> > > > +	refcount_set(&kvalue->refcnt, 1);
> > > > +	bpf_map_inc(map);
> > > > +
> > > > +	err =3D st_ops->reg(kdata);
> > > > +	if (!err) {
> > > > +		/* Pair with smp_load_acquire() during lookup */
> > > > +		smp_store_release(&kvalue->state, BPF_STRUCT_OPS_STATE_INUSE);
> > >=20
> > > Is there a reason using READ_ONCE/WRITE_ONCE pair is not enough?
> > The intention is to ensure lookup_elem() can see all the progs' id once
> > the state is set to BPF_STRUCT_OPS_STATE_INUSE.
> >=20
> > Is READ_ONCE/WRITE_ONCE enough to do this?
>=20
> True, given the above udata store, makes sense as-is.
>=20
> > > > +		goto unlock;
> > > > +	}
> > > > +
> > > > +	/* Error during st_ops->reg() */
> > > > +	bpf_map_put(map);
> > > > +
> > > > +reset_unlock:
> > > > +	bpf_struct_ops_map_put_progs(st_map);
> > > > +	memset(uvalue, 0, map->value_size);
> > > > +	memset(kvalue, 0, map->value_size);
> > > > +
> > > > +unlock:
> > > > +	spin_unlock(&st_map->lock);
> > > > +	return err;
> > > > +}
> > > [...]
> > > > +static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *at=
tr)
> > > > +{
> > > > +	const struct bpf_struct_ops *st_ops;
> > > > +	size_t map_total_size, st_map_size;
> > > > +	struct bpf_struct_ops_map *st_map;
> > > > +	const struct btf_type *t, *vt;
> > > > +	struct bpf_map_memory mem;
> > > > +	struct bpf_map *map;
> > > > +	int err;
> > > > +
> > > > +	if (!capable(CAP_SYS_ADMIN))
> > > > +		return ERR_PTR(-EPERM);
> > > > +
> > > > +	st_ops =3D bpf_struct_ops_find_value(attr->btf_vmlinux_value_type=
_id);
> > > > +	if (!st_ops)
> > > > +		return ERR_PTR(-ENOTSUPP);
> > > > +
> > > > +	vt =3D st_ops->value_type;
> > > > +	if (attr->value_size !=3D vt->size)
> > > > +		return ERR_PTR(-EINVAL);
> > > > +
> > > > +	t =3D st_ops->type;
> > > > +
> > > > +	st_map_size =3D sizeof(*st_map) +
> > > > +		/* kvalue stores the
> > > > +		 * struct bpf_struct_ops_tcp_congestions_ops
> > > > +		 */
> > > > +		(vt->size - sizeof(struct bpf_struct_ops_value));
> > > > +	map_total_size =3D st_map_size +
> > > > +		/* uvalue */
> > > > +		sizeof(vt->size) +
> > > > +		/* struct bpf_progs **progs */
> > > > +		 btf_type_vlen(t) * sizeof(struct bpf_prog *);
> > > > +	err =3D bpf_map_charge_init(&mem, map_total_size);
> > > > +	if (err < 0)
> > > > +		return ERR_PTR(err);
> > > > +
> > > > +	st_map =3D bpf_map_area_alloc(st_map_size, NUMA_NO_NODE);
> > > > +	if (!st_map) {
> > > > +		bpf_map_charge_finish(&mem);
> > > > +		return ERR_PTR(-ENOMEM);
> > > > +	}
> > > > +	st_map->st_ops =3D st_ops;
> > > > +	map =3D &st_map->map;
> > > > +
> > > > +	st_map->uvalue =3D bpf_map_area_alloc(vt->size, NUMA_NO_NODE);
> > > > +	st_map->progs =3D
> > > > +		bpf_map_area_alloc(btf_type_vlen(t) * sizeof(struct bpf_prog *),
> > > > +				   NUMA_NO_NODE);
> > > > +	st_map->image =3D bpf_jit_alloc_exec(PAGE_SIZE);
> > > > +	if (!st_map->uvalue || !st_map->progs || !st_map->image) {
> > > > +		bpf_struct_ops_map_free(map);
> > > > +		bpf_map_charge_finish(&mem);
> > > > +		return ERR_PTR(-ENOMEM);
> > > > +	}
> > > > +
> > > > +	spin_lock_init(&st_map->lock);
> > > > +	set_vm_flush_reset_perms(st_map->image);
> > > > +	set_memory_x((long)st_map->image, 1);
> > >=20
> > > Shouldn't this be using text poke as well once you write the image la=
ter on,
> > > otherwise we create yet another instance of W+X memory ... :/
> > Once image is written in update_elem(), it will never be changed.
> > I can set it to ro after it is written.
>=20
> And we could also move the set_memory_x() to that point once image is wri=
tten and
> marked read-only; mid term text poke interface to avoid all this.
I will respin.

Thanks for the review! =20

>=20
> Other than that nothing obvious stands out from reviewing patch 1-8, so n=
o objections
> from my side.
>=20
> > > > +	bpf_map_init_from_attr(map, attr);
> > > > +	bpf_map_charge_move(&map->memory, &mem);
> > > > +
> > > > +	return map;
> > > > +}
> > > > +
> > > > +const struct bpf_map_ops bpf_struct_ops_map_ops =3D {
> > > > +	.map_alloc_check =3D bpf_struct_ops_map_alloc_check,
> > > > +	.map_alloc =3D bpf_struct_ops_map_alloc,
> > > > +	.map_free =3D bpf_struct_ops_map_free,
> > > > +	.map_get_next_key =3D bpf_struct_ops_map_get_next_key,
> > > > +	.map_lookup_elem =3D bpf_struct_ops_map_lookup_elem,
> > > > +	.map_delete_elem =3D bpf_struct_ops_map_delete_elem,
> > > > +	.map_update_elem =3D bpf_struct_ops_map_update_elem,
> > > > +	.map_seq_show_elem =3D bpf_struct_ops_map_seq_show_elem,
> > > > +};
> > > [...]
>=20
