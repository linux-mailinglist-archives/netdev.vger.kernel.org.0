Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84854F40B6
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 07:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbfKHGoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 01:44:34 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22506 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbfKHGod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 01:44:33 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA86hgoB020086;
        Thu, 7 Nov 2019 22:44:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=O8O22a96Hog94n241KpAIKdMtuFVU+w0rPf1+BeN5ks=;
 b=kYYiEH61C9bFfh3dkEx8dxD31kZtIBa6e7LpOXrT0lODmIorvaDB6b7IYz/Qu807w9vi
 tlMkxB9JcMk5Uh5EXmIW+ywVRZPXex8y0/LdHE5O9eTuCf+PmIV4CHgZb/nSlf8ra/1w
 4dMrCsF7/WQpvaplxAO4pYV51btXYIkSQec= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41vy1we6-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 22:44:21 -0800
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 22:44:07 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 22:44:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0+jI04TmcIr7y3YJIi5dY7jH9jz22d5zL7FFdfvuyxSRvaHcodILrYxhp9NIyfM3n8fRqrHYyb2VhlSFOubvIvVLrSlcis1yLKT9KWZUl4NPZ7QmrygvEcaqe1+n9Uz6L3cTzzTYtMR4NyW9UuCpkHHlg3wje/45MUp4b24mW89t40q9IAtl0sgyhTevrsNLz7SziW1dwT67pmFttNnVzccH2L/pgn08hldVB5sNRPaV36AZKG5NKJzxQ/IV+mDSqZLxePY8UKbkvS86OGL62kobVfBZXi/hN3OaMauYNijs8KHi01Co9gWqFdo7wse5stVSBzp7FGlooynTBHFyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8O22a96Hog94n241KpAIKdMtuFVU+w0rPf1+BeN5ks=;
 b=ERUgZgah7UURRyG3KZwHXkH3+YSiVaXKDqTbyNnjCBOmJvDkuQ7yEkCKaXPJS6xxyTOBZvZNOKK3YyUplaLYY5/Olau2LaDqQpm3Ut2pTrTBsSuaLAv+aYUdOzvVZWqY8MoaidxNldBMHiXrIUvcZW1Q9Y9rXrcBaK4yeBbkkALYaRgxyeem9jrortM5MXHsfkcPwHZmhYGGarhEEiXrZCuY81tdCVnzVWTU4aCEZ+qlxeBRjhJc+3xpPRG42sIgEIjUe8yKSCQPDjnHnXLQrmzsXyUsVTAzOStkPOqWHK1XERG2IIPFQAhBNP41FbDhzw2TPhEnUg7+CvPNcTS54w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8O22a96Hog94n241KpAIKdMtuFVU+w0rPf1+BeN5ks=;
 b=Ad9VL1Phfc9N/UEN6b9y7pKbqaby+c3WrBW57J2SwHOSgUyDXwjytEUWt2g3aTTj22+Y7qJBLS40ClWtKt8ZWoxqNwpBTsylhvZ24EFkoQV5Dea17seH+Q2+URUy7XbqpHStj2rd/ROXp2vpZHPgFgUYqSd/lX3td+vch1P4BS4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1950.namprd15.prod.outlook.com (10.175.2.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Fri, 8 Nov 2019 06:44:06 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 06:44:06 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/3] libbpf: make global data internal arrays
 mmap()-able, if possible
Thread-Topic: [PATCH bpf-next 2/3] libbpf: make global data internal arrays
 mmap()-able, if possible
Thread-Index: AQHVlevohTlDnZgmUUGaDkhWrntPYaeA0/uA
Date:   Fri, 8 Nov 2019 06:44:06 +0000
Message-ID: <A5F17C12-EBB2-4588-863E-69EDE650DE43@fb.com>
References: <20191108042041.1549144-1-andriin@fb.com>
 <20191108042041.1549144-3-andriin@fb.com>
In-Reply-To: <20191108042041.1549144-3-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:180::c4b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d783a8ab-5708-45b0-5662-08d764170d14
x-ms-traffictypediagnostic: MWHPR15MB1950:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1950C3DB87AABC98C99E5AF1B37B0@MWHPR15MB1950.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:167;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(376002)(366004)(346002)(136003)(199004)(189003)(102836004)(71190400001)(71200400001)(53546011)(6506007)(76176011)(7736002)(256004)(6636002)(305945005)(478600001)(36756003)(50226002)(8676002)(81166006)(8936002)(81156014)(33656002)(25786009)(6512007)(6116002)(99286004)(2906002)(14454004)(316002)(86362001)(37006003)(229853002)(54906003)(6436002)(6486002)(6862004)(46003)(76116006)(186003)(5660300002)(11346002)(4326008)(64756008)(2616005)(66946007)(6246003)(486006)(476003)(446003)(66556008)(66476007)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1950;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zTWdUMrAphggwy48SGuJ/FKTFiyO20OEhqLOTizzBc7KDoH5rK0rqYooVrDsN1VtUiu361myL2X+OiFTTN0mNIvgiNJ+HXRz9yI9tLnkmHv8KsWKDcBrjr3DXCBNmK1846CR0r847XxU4AKNOFmdGm9Pc86LNJ7RB4y3z/5Ak01Qjp+gq5X/ukpPeXOrEC1A6RnocBjbcNFDNgMkeh5gh8rnzf2AI0XLYz14lPK3HZ5PzjuppqQ4GkQtZD5SgTYI3ZI19iQU3HqIY3xSEXwGNnHlINmAKWgmsuLJOn8X0g4vbGgtn5DIuQf/hVk8U0tb0KDVwFQmQoJ44KfTUzp8rxwryleNVGH9WOPON9+TPnKqUvHQKQLoo7BwkKV6s07aLzkUT5o0BKrFSylCYY/IDcENSH6cdTM7J06an1D9LdUuWvIW0qRXTkpldBcJoY2z
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A63C3CE72A4BD3449878631A9D9391E0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d783a8ab-5708-45b0-5662-08d764170d14
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 06:44:06.1107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v/AJVTmBCi+d56MO/OUIHSGNrKkP0WI0CaTJz8XxHDueYF+d/khXmBIE1ol+PW2ZKfL+n/943G4E2bL7XbOVuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1950
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080065
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 8:20 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Add detection of BPF_F_MMAPABLE flag support for arrays and add it as an =
extra
> flag to internal global data maps, if supported by kernel. This allows us=
ers
> to memory-map global data and use it without BPF map operations, greatly
> simplifying user experience.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

With nit below.=20

> ---
> tools/lib/bpf/libbpf.c | 31 +++++++++++++++++++++++++++++--
> 1 file changed, 29 insertions(+), 2 deletions(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index fde6cb3e5d41..73607a31a068 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -142,6 +142,8 @@ struct bpf_capabilities {
> 	__u32 btf_func:1;
> 	/* BTF_KIND_VAR and BTF_KIND_DATASEC support */
> 	__u32 btf_datasec:1;
> +	/* BPF_F_MMAPABLE is supported for arrays */
> +	__u32 array_mmap:1;
> };
>=20
> /*
> @@ -855,8 +857,6 @@ bpf_object__init_internal_map(struct bpf_object *obj,=
 enum libbpf_map_type type,
> 		pr_warn("failed to alloc map name\n");
> 		return -ENOMEM;
> 	}
> -	pr_debug("map '%s' (global data): at sec_idx %d, offset %zu.\n",
> -		 map_name, map->sec_idx, map->sec_offset);
>=20
> 	def =3D &map->def;
> 	def->type =3D BPF_MAP_TYPE_ARRAY;
> @@ -864,6 +864,12 @@ bpf_object__init_internal_map(struct bpf_object *obj=
, enum libbpf_map_type type,
> 	def->value_size =3D data->d_size;
> 	def->max_entries =3D 1;
> 	def->map_flags =3D type =3D=3D LIBBPF_MAP_RODATA ? BPF_F_RDONLY_PROG : 0=
;
> +	if (obj->caps.array_mmap)
> +		def->map_flags |=3D BPF_F_MMAPABLE;
> +
> +	pr_debug("map '%s' (global data): at sec_idx %d, offset %zu, flags %u.\=
n",

nit: Better print flags as %x.=20


