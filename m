Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86BE0D0317
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 23:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfJHVxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 17:53:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8638 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725879AbfJHVxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 17:53:45 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x98LrKqm021033;
        Tue, 8 Oct 2019 14:53:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : cc : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=aAq5hYJfdkz2ZXuw+T+kpjbF4X+JpQZXJyT3fvNmfk0=;
 b=aenvZbCuMymbXpUyvoobhQtJFx9Za1Vjy76V2BX2dB71jRjfAmqmFWrJEoyDduYwrMWU
 J/Vr9d5ZTnXEgG6UHjYyPM0n0tiqxrn3aHtcJmHRHWZy15H7+ds+lWXk5zXy6pAn/g3S
 JGAsOjAAAfZfys7D4uJb60fbGm6qs7TkaCQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vgpq9kytb-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Oct 2019 14:53:31 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 8 Oct 2019 14:53:25 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 8 Oct 2019 14:53:25 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 8 Oct 2019 14:53:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gk2h+luGY2bjInI7/k7/KTWgwWtpMtnytgIFxr8WA3rU7T2ZP5g/tO3TQF2apjCreW+isVbrPqgFIpHkNffFkaamskR+wV0G0qHrgo3TmEVDUxnSr8wHcKJqqiYyUfVauah2Au1r4KJadne/iNdmtpP+lg5DP485Y0rT3J+tpnoPp8a11bSLV4ugHiQXGPAvGpwZcTPNkRP5G9qRNjdRdLzzkHLRQvqorYfpxbIjmOF7C3/dCwUB5dzj/W1XRyXV+CNX2OXWb9vbzeeTNsaxD1nHK3SQsbFqD2Q09IyX+Ow8SCYEnnMbzW0+68Iuz7mf6lK2FL0sVucgzP7a6Otydw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAq5hYJfdkz2ZXuw+T+kpjbF4X+JpQZXJyT3fvNmfk0=;
 b=i9JZ1UyYyT0REpH0R93TNLutpjTVfBjAUV/FtoeMGumcQq38BBfwH+/UwixKpNgpo5fFXauiW1WOkRjmx+Qu63Q2+ZQnqTBx4o66sWT/smYT+LmApOyvKBfFiAp1iOiiiCZnbc7sZA3gqegNJ6L/ZkvfrLirTPhQIWDdfZMQxmA2X3Lu1GNl7/Cj4XNIvpsiHQkTmQwDBpsKhMVKTRHAE6lLPtcEvkIlnVEIPZ87XHkSs10TQ4M3wLXtUv3IahvxySfn1/MO027x+Rx17JgtpmYjQ9cwTBj9vdCZd0rIhBGagtj4Y/nDRBShMBExHvDpWRSswkwK0gTPepq6b45xFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAq5hYJfdkz2ZXuw+T+kpjbF4X+JpQZXJyT3fvNmfk0=;
 b=KCxMyWmuHN6G7o5OmwkzQNJK9UunmcXZX9swn7ij85+MnAcFKI6fZXNKzvdYVRZyKA4cWf+LVR82EolVexCJNBeyEeGDkyx1v0hZnH0phaqfoi7NpTSXl+ls8Yd0iVB2K2HdclBi81xbI0lJcAO4q42hZsahFyIP/wmqv9sYPD0=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3470.namprd15.prod.outlook.com (20.179.23.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 8 Oct 2019 21:53:24 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2327.023; Tue, 8 Oct 2019
 21:53:24 +0000
From:   Martin Lau <kafai@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: track contents of read-only maps as
 scalars
Thread-Topic: [PATCH bpf-next 1/2] bpf: track contents of read-only maps as
 scalars
Thread-Index: AQHVfhENq5XFICrTfUW95LiPtBist6dRSXeA
Date:   Tue, 8 Oct 2019 21:53:24 +0000
Message-ID: <20191008215321.hrlrbgsdifnziji6@kafai-mbp.dhcp.thefacebook.com>
References: <20191008194548.2344473-1-andriin@fb.com>
 <20191008194548.2344473-2-andriin@fb.com>
In-Reply-To: <20191008194548.2344473-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0155.namprd04.prod.outlook.com (2603:10b6:104::33)
 To MN2PR15MB3213.namprd15.prod.outlook.com (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:c9d3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4c386d9-d303-4f72-55c3-08d74c39f12d
x-ms-traffictypediagnostic: MN2PR15MB3470:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB347066805329677300F72B81D59A0@MN2PR15MB3470.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(366004)(396003)(376002)(39860400002)(189003)(199004)(1671002)(6246003)(71190400001)(71200400001)(109986005)(4326008)(86362001)(9686003)(6512007)(81166006)(81156014)(8676002)(54906003)(8936002)(6436002)(6486002)(229853002)(316002)(486006)(6116002)(476003)(446003)(66946007)(66476007)(66556008)(64756008)(66446008)(25786009)(46003)(11346002)(5660300002)(1076003)(14454004)(256004)(76176011)(52116002)(386003)(14444005)(99286004)(478600001)(305945005)(2906002)(186003)(102836004)(7736002)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3470;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: veE6wJ/LeZsiErc1lSZhckXqpz8f1ZAka6GTMZx4dTJI81qXCZ/Q+q/VupHQUOiRLdjEC+hO+ygcD5KesEp8SSgw3r9ilxFtnz1Ij0gHku3jFqEqMv0tBsjjHs2w5GcPSaWlvorV9i9O+2xiDLxXhTNGTzoQwQVIKQKTpVDlA3ut0NPwEWDrfAsBXXR1weZGOGz45X9ODZr8Pbz2v616VdQutUiyzF2fdKKVfHEdLEPoxUOQqiiBd932fkHyrfNjzH96AqNXHOAzLO4azSbYJmi7WGjaIj7OWvoyb/hD7JvIOmThApOFSWQBD+O2fNrh+NY2bfLP3UttU7bucRrOPIyxD3Ov9+VIEIL2wXb+4ShqBiUYBEn4CdDK657raMBnYdBt3ZT91H3cqoA1tQa8mV90JnC8T1G4MKLJpBMOlMw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A3FF9B5EF86F6D44AF8FCDA04B231902@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f4c386d9-d303-4f72-55c3-08d74c39f12d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 21:53:24.1460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: atCaT0/35AX+aGRtN6VfHxmwHlakVZ97fNP/Ohc51MK7GJ3HtrvhiTcQC/Ov7Hd6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3470
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-08_08:2019-10-08,2019-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 clxscore=1011 adultscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910080170
X-FB-Internal: deliver
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 12:45:47PM -0700, Andrii Nakryiko wrote:
> Maps that are read-only both from BPF program side and user space side
> have their contents constant, so verifier can track referenced values
> precisely and use that knowledge for dead code elimination, branch
> pruning, etc. This patch teaches BPF verifier how to do this.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  kernel/bpf/verifier.c | 58 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 56 insertions(+), 2 deletions(-)
>=20
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index ffc3e53f5300..1e4e4bd64ca5 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -2739,6 +2739,42 @@ static void coerce_reg_to_size(struct bpf_reg_stat=
e *reg, int size)
>  	reg->smax_value =3D reg->umax_value;
>  }
> =20
> +static bool bpf_map_is_rdonly(const struct bpf_map *map)
> +{
> +	return (map->map_flags & BPF_F_RDONLY_PROG) &&
> +	       ((map->map_flags & BPF_F_RDONLY) || map->frozen);
> +}
> +
> +static int bpf_map_direct_read(struct bpf_map *map, int off, int size, u=
64 *val)
> +{
> +	void *ptr;
> +	u64 addr;
> +	int err;
> +
> +	err =3D map->ops->map_direct_value_addr(map, &addr, off + size);
Should it be "off" instead of "off + size"?

> +	if (err)
> +		return err;
> +	ptr =3D (void *)addr + off;
> +
> +	switch (size) {
> +	case sizeof(u8):
> +		*val =3D (u64)*(u8 *)ptr;
> +		break;
> +	case sizeof(u16):
> +		*val =3D (u64)*(u16 *)ptr;
> +		break;
> +	case sizeof(u32):
> +		*val =3D (u64)*(u32 *)ptr;
> +		break;
> +	case sizeof(u64):
> +		*val =3D *(u64 *)ptr;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
>  /* check whether memory at (regno + off) is accessible for t =3D (read |=
 write)
>   * if t=3D=3Dwrite, value_regno is a register which value is stored into=
 memory
>   * if t=3D=3Dread, value_regno is a register which will receive the valu=
e from memory
> @@ -2776,9 +2812,27 @@ static int check_mem_access(struct bpf_verifier_en=
v *env, int insn_idx, u32 regn
>  		if (err)
>  			return err;
>  		err =3D check_map_access(env, regno, off, size, false);
> -		if (!err && t =3D=3D BPF_READ && value_regno >=3D 0)
> -			mark_reg_unknown(env, regs, value_regno);
> +		if (!err && t =3D=3D BPF_READ && value_regno >=3D 0) {
> +			struct bpf_map *map =3D reg->map_ptr;
> +
> +			/* if map is read-only, track its contents as scalars */
> +			if (tnum_is_const(reg->var_off) &&
> +			    bpf_map_is_rdonly(map) &&
> +			    map->ops->map_direct_value_addr) {
> +				int map_off =3D off + reg->var_off.value;
> +				u64 val =3D 0;
> =20
> +				err =3D bpf_map_direct_read(map, map_off, size,
> +							  &val);
> +				if (err)
> +					return err;
> +
> +				regs[value_regno].type =3D SCALAR_VALUE;
> +				__mark_reg_known(&regs[value_regno], val);
> +			} else {
> +				mark_reg_unknown(env, regs, value_regno);
> +			}
> +		}
>  	} else if (reg->type =3D=3D PTR_TO_CTX) {
>  		enum bpf_reg_type reg_type =3D SCALAR_VALUE;
> =20
> --=20
> 2.17.1
>=20
