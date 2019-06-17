Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF32C48FB3
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbfFQTkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:40:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5302 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726151AbfFQTkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:40:22 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5HJdVIa014914;
        Mon, 17 Jun 2019 12:40:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jtfk/RUH4LRVN9GkMM1Y+rKwntO8JWWRgPt/76xXFg0=;
 b=d4pMdwSyV0wOFNMzeTO6cMOjvESR0gXpgzhm0lBle+Ydir0hyjc1jlS+3n1Qr0sm1TQO
 ijtRg1PvfH73Uy3Ti0io7LhgQXGEkbXazbVWQ7YDObv59/wH70uDpR/w74LXkbQh4Ne8
 0KZm28rq6s/k48yNbmLHC6RhYvhrlZDcjoM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2t6fypg92e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 17 Jun 2019 12:40:02 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 17 Jun 2019 12:40:02 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 17 Jun 2019 12:40:02 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 17 Jun 2019 12:40:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jtfk/RUH4LRVN9GkMM1Y+rKwntO8JWWRgPt/76xXFg0=;
 b=DO6M+108FJURNP7IBBtykmL8nBm/0sIP4SkHCajqhzic+RSdNlSMd30uesBINUYAX6FJoa6w8utm10lWOfS2scrlLhCdtjgdRZnnZVx1izA0VsDazYkpJV7jf0tQk3AwsWlJSVsx+TNqN/WCzA4jeeyAtA65JFdfvjjuJMvvEx8=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1119.namprd15.prod.outlook.com (10.175.8.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 19:40:00 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 19:40:00 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 02/11] libbpf: extract BTF loading logic
Thread-Topic: [PATCH v2 bpf-next 02/11] libbpf: extract BTF loading logic
Thread-Index: AQHVJULauRJ/ZIpOikScahrhrnudNqagPl+A
Date:   Mon, 17 Jun 2019 19:40:00 +0000
Message-ID: <180C0D3B-5C58-40C1-B4F1-3A20ECF39788@fb.com>
References: <20190617192700.2313445-1-andriin@fb.com>
 <20190617192700.2313445-3-andriin@fb.com>
In-Reply-To: <20190617192700.2313445-3-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:da81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5dee365-70c9-4ea1-c49f-08d6f35b9627
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1119;
x-ms-traffictypediagnostic: MWHPR15MB1119:
x-microsoft-antispam-prvs: <MWHPR15MB11195E04DE96C29C71BFBAC0B3EB0@MWHPR15MB1119.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(39860400002)(366004)(376002)(189003)(199004)(5660300002)(66446008)(186003)(66556008)(64756008)(14444005)(66476007)(99286004)(66946007)(73956011)(229853002)(46003)(76116006)(6506007)(6486002)(8676002)(86362001)(81166006)(256004)(81156014)(305945005)(6116002)(6436002)(53546011)(8936002)(102836004)(76176011)(4326008)(7736002)(25786009)(68736007)(14454004)(6512007)(486006)(50226002)(36756003)(478600001)(6862004)(37006003)(33656002)(53936002)(11346002)(6246003)(2906002)(2616005)(57306001)(6636002)(316002)(71200400001)(71190400001)(476003)(446003)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1119;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TGN7N0f90IN9yDLw9DiPU9pRn15MqZ1jm3uGJse6ZcFykReCmljvtXAa1zo5YThSnMYzGaJogMK+GNq5CIUKq8WMMFcb6+8jUCOQZwHWwcrhlQBozxyHPtMJbxcseHs0Myl30BV+c6IENH1KsneErAQqAy2ug2r9m8aJp2Gt3AHUaN7KV3vnh3rXCul76AZmTAXtFFDe8oefEjpAMt4wjdM9osjJCQ8GjNUIxKafy+Pc/yqtyVOtD5Wk9bKLH8dgd0yEAQ7Bz2O0NB1RCp308UHCQZyLpSavMecAULuOoaUZhEOGiFr3SB6IyzqqH8FeooEz/9W05p/lVXiHgT2RpckgE1wseLtyIFT+ec0Z5wRhcsA5w8//EqBk4inDkE7VZvv4vBmlJb3z8HILK/U4jAVLW72vC7LXyGJPdYtHK6c=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1D960273C0A0874685FA45A5E02BCC1A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e5dee365-70c9-4ea1-c49f-08d6f35b9627
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:40:00.4944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1119
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 17, 2019, at 12:26 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> As a preparetion fro adding BTF-based BPF map loading, extract .BTF and
> .BTF.ext loading logic.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> tools/lib/bpf/libbpf.c | 93 +++++++++++++++++++++++++-----------------
> 1 file changed, 55 insertions(+), 38 deletions(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index e725fa86b189..49d3a808e754 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1078,6 +1078,58 @@ static void bpf_object__sanitize_btf_ext(struct bp=
f_object *obj)
> 	}
> }
>=20
> +static int bpf_object__load_btf(struct bpf_object *obj,
> +				Elf_Data *btf_data,
> +				Elf_Data *btf_ext_data)
> +{
> +	int err =3D 0;
> +
> +	if (btf_data) {
> +		obj->btf =3D btf__new(btf_data->d_buf, btf_data->d_size);
> +		if (IS_ERR(obj->btf)) {
> +			pr_warning("Error loading ELF section %s: %d.\n",
> +				   BTF_ELF_SEC, err);
> +			goto out;
> +		}
> +		err =3D btf__finalize_data(obj, obj->btf);
> +		if (err) {
> +			pr_warning("Error finalizing %s: %d.\n",
> +				   BTF_ELF_SEC, err);
> +			goto out;
> +		}
> +		bpf_object__sanitize_btf(obj);
> +		err =3D btf__load(obj->btf);
> +		if (err) {
> +			pr_warning("Error loading %s into kernel: %d.\n",
> +				   BTF_ELF_SEC, err);
> +			goto out;
> +		}
> +	}
> +	if (btf_ext_data) {
> +		if (!obj->btf) {
> +			pr_debug("Ignore ELF section %s because its depending ELF section %s =
is not found.\n",
> +				 BTF_EXT_ELF_SEC, BTF_ELF_SEC);
> +			goto out;
> +		}
> +		obj->btf_ext =3D btf_ext__new(btf_ext_data->d_buf,
> +					    btf_ext_data->d_size);
> +		if (IS_ERR(obj->btf_ext)) {
> +			pr_warning("Error loading ELF section %s: %ld. Ignored and continue.\=
n",
> +				   BTF_EXT_ELF_SEC, PTR_ERR(obj->btf_ext));
> +			obj->btf_ext =3D NULL;
> +			goto out;
> +		}
> +		bpf_object__sanitize_btf_ext(obj);
> +	}
> +out:
> +	if (err || IS_ERR(obj->btf)) {
> +		if (!IS_ERR_OR_NULL(obj->btf))
> +			btf__free(obj->btf);
> +		obj->btf =3D NULL;
> +	}
> +	return 0;
> +}
> +
> static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
> {
> 	Elf *elf =3D obj->efile.elf;
> @@ -1212,44 +1264,9 @@ static int bpf_object__elf_collect(struct bpf_obje=
ct *obj, int flags)
> 		pr_warning("Corrupted ELF file: index of strtab invalid\n");
> 		return -LIBBPF_ERRNO__FORMAT;
> 	}
> -	if (btf_data) {
> -		obj->btf =3D btf__new(btf_data->d_buf, btf_data->d_size);
> -		if (IS_ERR(obj->btf)) {
> -			pr_warning("Error loading ELF section %s: %ld. Ignored and continue.\=
n",
> -				   BTF_ELF_SEC, PTR_ERR(obj->btf));
> -			obj->btf =3D NULL;
> -		} else {
> -			err =3D btf__finalize_data(obj, obj->btf);
> -			if (!err) {
> -				bpf_object__sanitize_btf(obj);
> -				err =3D btf__load(obj->btf);
> -			}
> -			if (err) {
> -				pr_warning("Error finalizing and loading %s into kernel: %d. Ignored=
 and continue.\n",
> -					   BTF_ELF_SEC, err);
> -				btf__free(obj->btf);
> -				obj->btf =3D NULL;
> -				err =3D 0;
> -			}
> -		}
> -	}
> -	if (btf_ext_data) {
> -		if (!obj->btf) {
> -			pr_debug("Ignore ELF section %s because its depending ELF section %s =
is not found.\n",
> -				 BTF_EXT_ELF_SEC, BTF_ELF_SEC);
> -		} else {
> -			obj->btf_ext =3D btf_ext__new(btf_ext_data->d_buf,
> -						    btf_ext_data->d_size);
> -			if (IS_ERR(obj->btf_ext)) {
> -				pr_warning("Error loading ELF section %s: %ld. Ignored and continue.=
\n",
> -					   BTF_EXT_ELF_SEC,
> -					   PTR_ERR(obj->btf_ext));
> -				obj->btf_ext =3D NULL;
> -			} else {
> -				bpf_object__sanitize_btf_ext(obj);
> -			}
> -		}
> -	}
> +	err =3D bpf_object__load_btf(obj, btf_data, btf_ext_data);
> +	if (err)
> +		return err;
> 	if (bpf_object__has_maps(obj)) {
> 		err =3D bpf_object__init_maps(obj, flags);
> 		if (err)
> --=20
> 2.17.1
>=20

