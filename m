Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F801478E5
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 08:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgAXHVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 02:21:16 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38144 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725817AbgAXHVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 02:21:16 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00O7JEaX030444;
        Thu, 23 Jan 2020 23:21:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4zorDlpVslQk/7yITkJV5V8Pn3I2M0dVnSCgIz7ihB0=;
 b=qjKM5v9KmXawgrhX3DLhrEtLI+hiWOrO3eyRaIHeveO6/bM0Q8LT4QikxDA21bUkcx6B
 t76i7LbsEOnLi/5l4IPMqlLfOTXnnxB5Hvz29CzbakwgcM1bMJDtXBMJd0V4PgCgB9gE
 XaElCedKrXgntpdQWHewoNZXpsrhFK3z+KM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2xqem03d94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Jan 2020 23:21:02 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 23 Jan 2020 23:21:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f26Tz6i6fhAaAgWfJbT5YlOyhQIczT5wP8JtfA3FrWxo6OHPb+zxhXCNsWRfSJNzsJMb8jUvQUzgAREt0PoYPqBrJuxmSyc73VwhayyZhct3GIh6DKRbeKsM19gVzzB5eXfK9/wQnXJgxN62n0GarxsOEYRyigXNHvzY65nuTvAlt4VrBIiy1+hl2o2QmQL5WA0TLaXcSRG6UN/Dt6BQsYdokd3Yd289Wd2taUCV8G/FNXeFA24oAsJM8r7YG5Sl2b7TnTRmtjGCvZd+uHrzOP41tjk9EUIWVWkJP4eRPzAGOfBmNnWANXy89J9U5enGEP8zIfaUiO5eIYXD/INyog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4zorDlpVslQk/7yITkJV5V8Pn3I2M0dVnSCgIz7ihB0=;
 b=Pf3Lo6iRxjSd4gH2s2527vedyvQHKZqLhfiT0MvdByEgRUETG8h5Ztiu0huFl/OT+r3WWxhXlg/lU4cGPq9MFMcuqwHDCKefmYbzGcPOsrtNeDR0RWgGKgAghPMK7b+r9BkPpfvw+lYD54Q6XpDBfhBwGo3bwY2zKbIZYN7FYqrCJ4YYfpDGtg7cAG5uLedUQEOPNa0qLb/etb7zrtK8geNV+yk2I1RILbRXBbKb+JSIlB13MLNSytH2576xYYMJPjSHdZm3q/MCRuaLErJ4N5h1yMaRVY9AWoUouUV+oCkecDK36Nd53Q7aD0nZdOvCgACIdp0fB6/uCpbclA/vKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4zorDlpVslQk/7yITkJV5V8Pn3I2M0dVnSCgIz7ihB0=;
 b=PGbn/l7ZcBk/DE40Qsc8/yvR0LLLtmN6C0bJoKEJUMuQwY06uBapdbVaoZBT1ErigogkAmVulMx96sgWqA24ihXx7q0NuHAbPskN/VTRpXmfcoFzLbXqyW5G3CAGejObK3EazIsQsCdgcl8wt86z4of0qYC54q57WRln6dwZ90g=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3326.namprd15.prod.outlook.com (20.179.23.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Fri, 24 Jan 2020 07:20:59 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.028; Fri, 24 Jan 2020
 07:20:59 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::d6ea) by CO2PR07CA0074.namprd07.prod.outlook.com (2603:10b6:100::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Fri, 24 Jan 2020 07:20:58 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] libbpf: improve handling of
 failed CO-RE relocations
Thread-Topic: [Potential Spoof] [PATCH bpf-next] libbpf: improve handling of
 failed CO-RE relocations
Thread-Index: AQHV0niPDYdGIcPm+U6Ab9Oo5xV7Xqf5aK8A
Date:   Fri, 24 Jan 2020 07:20:59 +0000
Message-ID: <20200124072054.2kr25erckbclkwgv@kafai-mbp.dhcp.thefacebook.com>
References: <20200124053837.2434679-1-andriin@fb.com>
In-Reply-To: <20200124053837.2434679-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR07CA0074.namprd07.prod.outlook.com (2603:10b6:100::42)
 To MN2PR15MB3213.namprd15.prod.outlook.com (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::d6ea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f803f9b9-92ac-468f-db68-08d7a09df5d2
x-ms-traffictypediagnostic: MN2PR15MB3326:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB33266D87B933591D33996394D50E0@MN2PR15MB3326.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(366004)(396003)(136003)(376002)(199004)(189003)(1076003)(4326008)(86362001)(9686003)(8936002)(5660300002)(55016002)(186003)(16526019)(66556008)(8676002)(64756008)(66446008)(66946007)(6506007)(66476007)(6636002)(54906003)(6862004)(7696005)(478600001)(81166006)(81156014)(2906002)(316002)(52116002)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3326;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3tpAFp2JSwMgg9FMNLc/bpI99lJf4Ezurx5iq+MNA04AvZOBmcIx7tC5ZGvDzOqTurBroeac2YjmmLx598O0JYhc227KYTlGHAnFKupN98Qg0MWzZ2lZ25NQ6ACj4Ba6R+p8Wp7wCEQxX1qCpIwE1u0ZJ22ztoLe73BQLSZtWSY7gRpWuN2quDGuqhrF0JJm5MIYjw2mMkMSHn4NN9MyIOlknBAJFtf20pSBcNqm29k2omB3152kkQ16wDFs/OBUgoq4UomVrThnZ+aoVrSr289JSc5sMzHzqNEzPsybeGBYJHP2P/xzmHH8777ymt0XBIgXUSrgKhc2z6kletk1PhCLfV4oXs5bcsOXTv0TnFe7gsYHurcuzdh59+pjDWxYS5Bd/wIwmt0Lm7ATUjqtys8CTtqpUROmcUB3VWxg7+gi6X4ct72yqXdJr8eJolJR
Content-Type: text/plain; charset="us-ascii"
Content-ID: <66B5ED416F1A3D4E9CF3485F18EA8BAF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f803f9b9-92ac-468f-db68-08d7a09df5d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 07:20:59.2799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GeFxR/oXDynLC76hmDwdWlUtUB/aSlLVSeN09NgKiH5lv5Yl2ydphq1s3QQc89UO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3326
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-24_01:2020-01-24,2020-01-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001240059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 09:38:37PM -0800, Andrii Nakryiko wrote:
> Previously, if libbpf failed to resolve CO-RE relocation for some
> instructions, it would either return error immediately, or, if
> .relaxed_core_relocs option was set, would replace relocatable offset/imm=
 part
> of an instruction with a bogus value (-1). Neither approach is good, beca=
use
> there are many possible scenarios where relocation is expected to fail (e=
.g.,
> when some field knowingly can be missing on specific kernel versions). On=
 the
> other hand, replacing offset with invalid one can hide programmer errors,=
 if
> this relocation failue wasn't anticipated.
>=20
> This patch deprecates .relaxed_core_relocs option and changes the approac=
h to
> always replacing instruction, for which relocation failed, with invalid B=
PF
> helper call instruction. For cases where this is expected, BPF program sh=
ould
> already ensure that that instruction is unreachable, in which case this
> invalid instruction is going to be silently ignored. But if instruction w=
asn't
> guarded, BPF program will be rejected at verification step with verifier =
log
> pointing precisely to the place in assembly where the problem is.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c | 95 +++++++++++++++++++++++++-----------------
>  tools/lib/bpf/libbpf.h |  6 ++-
>  2 files changed, 61 insertions(+), 40 deletions(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ae34b681ae82..39f1b7633a7c 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -345,7 +345,6 @@ struct bpf_object {
> =20
>  	bool loaded;
>  	bool has_pseudo_calls;
> -	bool relaxed_core_relocs;
> =20
>  	/*
>  	 * Information when doing elf related work. Only valid if fd
> @@ -4238,25 +4237,38 @@ static int bpf_core_calc_field_relo(const struct =
bpf_program *prog,
>   */
>  static int bpf_core_reloc_insn(struct bpf_program *prog,
>  			       const struct bpf_field_reloc *relo,
> +			       int relo_idx,
>  			       const struct bpf_core_spec *local_spec,
>  			       const struct bpf_core_spec *targ_spec)
>  {
> -	bool failed =3D false, validate =3D true;
>  	__u32 orig_val, new_val;
>  	struct bpf_insn *insn;
> +	bool validate =3D true;
>  	int insn_idx, err;
>  	__u8 class;
> =20
>  	if (relo->insn_off % sizeof(struct bpf_insn))
>  		return -EINVAL;
>  	insn_idx =3D relo->insn_off / sizeof(struct bpf_insn);
> +	insn =3D &prog->insns[insn_idx];
> +	class =3D BPF_CLASS(insn->code);
> =20
>  	if (relo->kind =3D=3D BPF_FIELD_EXISTS) {
>  		orig_val =3D 1; /* can't generate EXISTS relo w/o local field */
>  		new_val =3D targ_spec ? 1 : 0;
>  	} else if (!targ_spec) {
> -		failed =3D true;
> -		new_val =3D (__u32)-1;
> +		pr_debug("prog '%s': relo #%d: substituting insn #%d w/ invalid insn\n=
",
> +			 bpf_program__title(prog, false), relo_idx, insn_idx);
> +		insn->code =3D BPF_JMP | BPF_CALL;
> +		insn->dst_reg =3D 0;
> +		insn->src_reg =3D 0;
> +		insn->off =3D 0;
> +		/* if this instruction is reachable (not a dead code),
> +		 * verifier will complain with the following message:
> +		 * invalid func unknown#195896080
> +		 */
> +		insn->imm =3D 195896080; /* =3D> 0xbad2310 =3D> "bad relo" */
Should this value become a binded contract in uapi/bpf.h so
that the verifier can print a more meaningful name than "unknown#195896080"=
?

> +		return 0;
>  	} else {
>  		err =3D bpf_core_calc_field_relo(prog, relo, local_spec,
>  					       &orig_val, &validate);
