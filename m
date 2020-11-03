Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5AE2A3A93
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 03:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgKCCtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 21:49:51 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34044 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725989AbgKCCtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 21:49:50 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A32nNai003243;
        Mon, 2 Nov 2020 18:49:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vv6DhACQtyefXB+Z4jzbCfD9hxRgV5eAxyBrOPQw9VE=;
 b=N3eunXn7/mn/L1LWbB2Qr3kji9okbQ/YDW1WNQahPqYIlILcd7p23IYT2UhzEtzq9zKS
 N8iopE3WdIbb4aSNAxefAooTrfnlHYxqKU8PTqr6cB7J5CpJRidxGLg0K9l7FcdCXHKe
 kTJADzq0mS8z59bpjPasGm7D+c85PYpX3Ag= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34hqrkrvv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 18:49:35 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 18:49:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkTP+JdVnofr0lEsxo2MwSZOV79lFE3gWiQNPBD7+4xP+ZwfuWz8H9ADAvnNhcjfObK6aJlk2WW7Z0uW56TEJrB0wspk5sAPC8e5APqvIQ6sL++Vjxg1c7khxKkKSoLz5nuuMvjjQoS22bA32MVR62QVo8V8/N77IkJujOlg74BbAT0cNRIr7kszsQfq5dRX+hKzJqO8RI+0aRK/9IOWig8gu3Mdd23QNdeN5lA8prKpdpvMfDHXSMzUAqavqV+5q5A75GQrWBKbrK718bnYp0T5LR7RL4p8CjVgmD0MluHJi4kbit0RkAO/EsYyf6X3YB/QDQd9vbuuddA//1VvHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vv6DhACQtyefXB+Z4jzbCfD9hxRgV5eAxyBrOPQw9VE=;
 b=WycvbFhy8krcp25tExWfnUaPL4abBX1E7ez1eO0J1aN+PtFE+HqiryM1pdFKSHHvEMYjQ7XNjdl9tx5Pm8GdgDVCfMTS+8aXzStBSvJrxpv9Y59ioZNyS/vi3zU5Y6dEjFKjvOuA87lFdxfwLz6okMAoaRmlOtReuQMlDxEk5E3zctfoi0+nJ2RkZhs694K9IZrfqXDMwB3HFbC9bMs8+ML3r7vCUY/J7m5atZOMpwqJSFBzTwet3/M/ZTW2MBTdRaxrydQZc3RBmTF4CvnTXmwdepNy8Kq3/938WMX/177Zp031LASau+8YgVMlG5FSx90tNh4prpZESs7XRF+4zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vv6DhACQtyefXB+Z4jzbCfD9hxRgV5eAxyBrOPQw9VE=;
 b=cA+ppauqnH0DlDd85kwMsJu5f3tXiBGizthASd8PEXGqaU7tLckwUbp8ddPaaYC0pERwgeAfbN7Vsvl+8RwGOEGDc1F1cLSVJTRMl+3Ae8rLONQ90BVYtDlKYKbtcK+6cs9NBOhBky0IO/uhmxbBRbXuICvkFT1Riqsz0Eoms10=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3416.namprd15.prod.outlook.com (2603:10b6:a03:110::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 02:49:25 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 02:49:25 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 08/11] libbpf: support BTF dedup of split BTFs
Thread-Topic: [PATCH bpf-next 08/11] libbpf: support BTF dedup of split BTFs
Thread-Index: AQHWrY7ZXkKOliwbJ0Kq0MPekL/6Ham1vMIA
Date:   Tue, 3 Nov 2020 02:49:24 +0000
Message-ID: <4D4CB508-5358-40B3-878C-30D97BCA4192@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-9-andrii@kernel.org>
In-Reply-To: <20201029005902.1706310-9-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5554564e-8756-4531-1993-08d87fa3132d
x-ms-traffictypediagnostic: BYAPR15MB3416:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3416956ADD9E6EE79FD6FEE1B3110@BYAPR15MB3416.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G/rIGqI51MV+O9DKOl9AuXZVGZFBA6DHxq4IZWwudqGnutDTLChPSkvLVgZez5lEqKM3lIyJgPmrgFVcoawwCa9qzIjCelnqziPPfwnVE2W+twZSdzsEKWxOxMmb0P2z23lDbyb8BJtl30sXBLy4D+ziQN/dPDdlSR+bLUcQNbvXSQenyMDKUPHzCxCy+WGyex16Snws9BionvP7IXSawCtTQKS1IHEBbr8AW3FBQHZTtJ7zvyR53/KojEMwKuHviB3jc2LUHvXvbDlC9wOY/Q7yHmcl1ugA8ujA+YKfz1QDsdZHme9LQcpc2vp84nNW7wCq5HKTx/dqDi8g+3B/1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(396003)(136003)(376002)(4326008)(71200400001)(66556008)(6506007)(64756008)(478600001)(66476007)(66946007)(2906002)(66446008)(5660300002)(2616005)(8676002)(53546011)(76116006)(86362001)(8936002)(316002)(6916009)(54906003)(186003)(91956017)(36756003)(6486002)(33656002)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: zoSf88jG4f7j0PBe5CfkFOlwfYj/ExGTPRquP/OLgljU8wvxpTw+C1N5k2PTFlo7xhAuE4gqitY0ZWk7eiR84XmK7TbWtNP2Z9Gdntg5U3q6sAIq+GfVmTCUXsWhHki8xVuJ0mmKgM26vQ7K2gaAUKul7lqMKiBWvHh4Uy04LeikCsW0ccJUKG2JLmIKDTOlJzHvVbK9zXzCEC1aF1fQ+/uzuwHKGe/Khrt9hQdLKs2UnzkGgnV67M3jP6lC7c9+dUls7RPPwVhTHSKCqatT95GgnuKV4mpJCDV9NGZ6U4S//1oLOg5fJKRbiRTS4gL+luhUnF9Gz26+n1jTEmTy2rHP1YlWYEApSnNMMDxyAC07V3h/E6bR9P9GGUXZgvom0/x9VA0So/917dk8tqK+Hj1Y1cmSkxTexDaOdunFzAcOg1POsPrP4LOjHmvqiZKoFvquRHz+NTVFizEXEptHFzXqcy76BNTImEAltSF2rW77zPvL8RHf03hgV/MeFXlDCEgLhlFwwYvQvboRkxdykztFWBDaOvoGl1RBmfNMizBB3sLAIsx469+Jr02YgN0/C8JdIZ1uG37trVKaMtPFBXKT37nmkfsy2kNGuzfU3cuvkpiji6AQ+4o6iQJhNyMiah/pqUH4IstdIrfs16BGzIB990y4Jw6aOEGQ1aWPg2fEeHbIZXbS2iUoeXKRbcti
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C361FF11BF7F4046983936286EB24884@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5554564e-8756-4531-1993-08d87fa3132d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 02:49:24.9855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +iUhyyo/icb/M3BCzixQMaCl+fZK/HEvQIGYPo+b72wSwNiaz0YS+10bu7UKgbwSSzTHzhGc6m8WR1HE8IMT4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3416
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_16:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 phishscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011030019
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>=20
> Add support for deduplication split BTFs. When deduplicating split BTF, b=
ase
> BTF is considered to be immutable and can't be modified or adjusted. 99% =
of
> BTF deduplication logic is left intact (module some type numbering adjust=
ments).
> There are only two differences.
>=20
> First, each type in base BTF gets hashed (expect VAR and DATASEC, of cour=
se,
> those are always considered to be self-canonical instances) and added int=
o
> a table of canonical table candidates. Hashing is a shallow, fast operati=
on,
> so mostly eliminates the overhead of having entire base BTF to be a part =
of
> BTF dedup.
>=20
> Second difference is very critical and subtle. While deduplicating split =
BTF
> types, it is possible to discover that one of immutable base BTF BTF_KIND=
_FWD
> types can and should be resolved to a full STRUCT/UNION type from the spl=
it
> BTF part.  This is, obviously, can't happen because we can't modify the b=
ase
> BTF types anymore. So because of that, any type in split BTF that directl=
y or
> indirectly references that newly-to-be-resolved FWD type can't be conside=
red
> to be equivalent to the corresponding canonical types in base BTF, becaus=
e
> that would result in a loss of type resolution information. So in such ca=
se,
> split BTF types will be deduplicated separately and will cause some
> duplication of type information, which is unavoidable.
>=20
> With those two changes, the rest of the algorithm manages to deduplicate =
split
> BTF correctly, pointing all the duplicates to their canonical counter-par=
ts in
> base BTF, but also is deduplicating whatever unique types are present in =
split
> BTF on their own.
>=20
> Also, theoretically, split BTF after deduplication could end up with eith=
er
> empty type section or empty string section. This is handled by libbpf
> correctly in one of previous patches in the series.
>=20
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

With some nits:

> ---

[...]

>=20
> 	/* remap string offsets */
> 	err =3D btf_for_each_str_off(d, strs_dedup_remap_str_off, d);
> @@ -3553,6 +3582,63 @@ static bool btf_compat_fnproto(struct btf_type *t1=
, struct btf_type *t2)
> 	return true;
> }
>=20

An overview comment about bpf_deup_prep() will be great.=20

> +static int btf_dedup_prep(struct btf_dedup *d)
> +{
> +	struct btf_type *t;
> +	int type_id;
> +	long h;
> +
> +	if (!d->btf->base_btf)
> +		return 0;
> +
> +	for (type_id =3D 1; type_id < d->btf->start_id; type_id++)
> +	{

Move "{" to previous line?=20

> +		t =3D btf_type_by_id(d->btf, type_id);
> +
> +		/* all base BTF types are self-canonical by definition */
> +		d->map[type_id] =3D type_id;
> +
> +		switch (btf_kind(t)) {
> +		case BTF_KIND_VAR:
> +		case BTF_KIND_DATASEC:
> +			/* VAR and DATASEC are never hash/deduplicated */
> +			continue;

[...]

> 	/* we are going to reuse hypot_map to store compaction remapping */
> 	d->hypot_map[0] =3D 0;
> -	for (i =3D 1; i <=3D d->btf->nr_types; i++)
> -		d->hypot_map[i] =3D BTF_UNPROCESSED_ID;
> +	/* base BTF types are not renumbered */
> +	for (id =3D 1; id < d->btf->start_id; id++)
> +		d->hypot_map[id] =3D id;
> +	for (i =3D 0, id =3D d->btf->start_id; i < d->btf->nr_types; i++, id++)
> +		d->hypot_map[id] =3D BTF_UNPROCESSED_ID;

We don't really need i in the loop, shall we just do=20
	for (id =3D d->btf->start_id; id < d->btf->start_id + d->btf->nr_types; id=
++)
?

>=20
> 	p =3D d->btf->types_data;
>=20
> -	for (i =3D 1; i <=3D d->btf->nr_types; i++) {
> -		if (d->map[i] !=3D i)
> +	for (i =3D 0, id =3D d->btf->start_id; i < d->btf->nr_types; i++, id++)=
 {

ditto

> +		if (d->map[id] !=3D id)
> 			continue;
>=20
[...]

