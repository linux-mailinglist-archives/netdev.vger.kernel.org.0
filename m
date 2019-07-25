Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 688B574266
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 02:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbfGYAAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 20:00:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47752 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727379AbfGYAAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 20:00:32 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6ONwxd1022623;
        Wed, 24 Jul 2019 17:00:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=TzJuJSUGKFv56M/yMxhF6gq7LXEzhyVD5YdD/hQLDgs=;
 b=Y0obuz6ZelnFKXmumyaGXgtD8LSuPyruiFOhlaflE+LB9csgt2QmTfxVbXOtNGLQrgWr
 aSh14TsXMTZmj1yKqxc3IvbL1okcVFqMCsRixCubAOaAqzn7mwsMwUxBtG6UbFNKltTy
 AhHIjgqybs/1Hdb3yJryA3Wkp6AjDyqr+GY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2txty6smer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 24 Jul 2019 17:00:09 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 24 Jul 2019 17:00:07 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 24 Jul 2019 17:00:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AuDG23DHFrI7l8fGnPUW0A+KQkra6b8FZSClmEOeIJkkQqfPaL4Z5pLFIFRJu+4U/jWvfoROsZ3hmp7fj862wWtBJfiQn2YbP7h3O9877Uiul5lV0jsOaZXIqAPkc5VlR3TcGjiY9yVTircN86zMkA5FED5jzNnHoUy8BVZ6ATT+KoD111SIgaQKGtufEcf6BOQ7SgW+4r73AmV2Rj+NIZgAJQndluI9URh6b3ZTFAb+T8D4h7O3aQv006jZd1VRsgIxPIBNpPrFZU6Ct1GefR/0JXqrwY77sGR/AZJM720cHu0oe2lOuknxX9nZsWecECrdWLvfRT/9zXuj99vs9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzJuJSUGKFv56M/yMxhF6gq7LXEzhyVD5YdD/hQLDgs=;
 b=BLvZC11Jemd7OvWyLmhgNd8aPwZ93WQgIbVd8NzSbZMRHxVlC1ImSizCYKmMoafBFm3nIq/q+B3JTbS4YSCb+jj7/mMdh9SBuYqy+4Mm9xHeWliKQuYdGHlypC+vLqiPehPMb17Ad27mi01wdf8u+htfp5monAO3tLVNMB81wKEkM4v3h16T7orRdcfUCmGVeRO2kvi/8qTOj0SeKPPbOwzDhBsVMpgOZYipX0KXqKdMF+JJrLAk/2XmZhHpqL7Q4ni+/RokB67ieW3cLthRPgG85jBs7yqEvILlDZ0PJdA6IvELFcFDXScYGeUckLBhNsqX0Eapz5UIwKh8Xgmr9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzJuJSUGKFv56M/yMxhF6gq7LXEzhyVD5YdD/hQLDgs=;
 b=bF+JJvscU3BlX+cXljZrclT2mH/LMJML8mB/HYS/gzUYYmCotSxZFyTFK7YCB1K+4UuGSLGNNpNPeyFchKEq63hRVem45W61RYTlZMB8ljIFAa2mYg0OEasuhYyqTcB6jwvq3LYm3p3NNmftsGjiHS4EB274kjh3vgrnFQLn0M4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1119.namprd15.prod.outlook.com (10.175.8.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Thu, 25 Jul 2019 00:00:06 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7%7]) with mapi id 15.20.2094.013; Thu, 25 Jul 2019
 00:00:06 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Yonghong Song" <yhs@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 01/10] libbpf: add .BTF.ext offset relocation
 section loading
Thread-Topic: [PATCH bpf-next 01/10] libbpf: add .BTF.ext offset relocation
 section loading
Thread-Index: AQHVQlYK69qsehsdP0Kkd9QeaocpJKbacyeA
Date:   Thu, 25 Jul 2019 00:00:06 +0000
Message-ID: <B5E772A5-C0D9-4697-ADE2-2A94C4AD37B5@fb.com>
References: <20190724192742.1419254-1-andriin@fb.com>
 <20190724192742.1419254-2-andriin@fb.com>
In-Reply-To: <20190724192742.1419254-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:856f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad7cd75e-c258-4c88-305f-08d710930d52
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1119;
x-ms-traffictypediagnostic: MWHPR15MB1119:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR15MB11195F1BCE6FDF24B01359DBB3C10@MWHPR15MB1119.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:551;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(376002)(136003)(396003)(346002)(189003)(199004)(71200400001)(256004)(6486002)(6246003)(81156014)(8676002)(54906003)(37006003)(6436002)(25786009)(14444005)(8936002)(81166006)(50226002)(76176011)(53936002)(71190400001)(966005)(33656002)(99286004)(316002)(478600001)(6306002)(2906002)(66446008)(6512007)(14454004)(53546011)(446003)(66476007)(486006)(102836004)(66556008)(66946007)(76116006)(186003)(91956017)(5660300002)(68736007)(64756008)(229853002)(6506007)(36756003)(4326008)(476003)(57306001)(86362001)(305945005)(6116002)(11346002)(6636002)(46003)(2616005)(7736002)(6862004)(142923001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1119;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2WbBvrleNsjRq94J+9BRDubDV9eWAQ/uTK20i8f0FResZjEXIa1L+aewByjdJwqcJNII6hzkbyumfzDZdje+4tHIRgMmTG5PG6BXbZ2Alpf9MhcaxOeL0wsPwgMMitL6WDfqy80DrSS+zMlRHvyJ8waZ6wow2zU+kJpfZDvk2aSYwNV7QpOuvcniDBLhSCt+akdZxMSZXXHkNl5Y0HnvxYczUy4TJyW0KWnnmOuuPCbhMLHYoO4do45xvJmpUWSqAVDFBZVJ1G7OeQIB6Hu2yd8SmtHyBteQGNOMOmRVD+bm0yCoGEdokIR0qNb/Kjf6zWQTLjXybVz1F6nxk6+odr0DX64GQQzzttcUL4HperyE3JkNJZrRreTzNES1WUlYGOHjiYBRDjsBmigj0/y7frA6/uItH+PjzGveYIxUfXw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <893F7B341CCC90428B8A9F8C0083A0C4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ad7cd75e-c258-4c88-305f-08d710930d52
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 00:00:06.4040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1119
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-24_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907240259
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 24, 2019, at 12:27 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Add support for BPF CO-RE offset relocations. Add section/record
> iteration macros for .BTF.ext. These macro are useful for iterating over
> each .BTF.ext record, either for dumping out contents or later for BPF
> CO-RE relocation handling.
>=20
> To enable other parts of libbpf to work with .BTF.ext contents, moved
> a bunch of type definitions into libbpf_internal.h.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
> tools/lib/bpf/btf.c             | 64 +++++++++--------------
> tools/lib/bpf/btf.h             |  4 ++
> tools/lib/bpf/libbpf_internal.h | 91 +++++++++++++++++++++++++++++++++
> 3 files changed, 118 insertions(+), 41 deletions(-)
>=20
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 467224feb43b..4a36bc783848 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -42,47 +42,6 @@ struct btf {
> 	int fd;
> };
>=20
> -struct btf_ext_info {
> -	/*
> -	 * info points to the individual info section (e.g. func_info and
> -	 * line_info) from the .BTF.ext. It does not include the __u32 rec_size=
.
> -	 */
> -	void *info;
> -	__u32 rec_size;
> -	__u32 len;
> -};
> -
> -struct btf_ext {
> -	union {
> -		struct btf_ext_header *hdr;
> -		void *data;
> -	};
> -	struct btf_ext_info func_info;
> -	struct btf_ext_info line_info;
> -	__u32 data_size;
> -};
> -
> -struct btf_ext_info_sec {
> -	__u32	sec_name_off;
> -	__u32	num_info;
> -	/* Followed by num_info * record_size number of bytes */
> -	__u8	data[0];
> -};
> -
> -/* The minimum bpf_func_info checked by the loader */
> -struct bpf_func_info_min {
> -	__u32   insn_off;
> -	__u32   type_id;
> -};
> -
> -/* The minimum bpf_line_info checked by the loader */
> -struct bpf_line_info_min {
> -	__u32	insn_off;
> -	__u32	file_name_off;
> -	__u32	line_off;
> -	__u32	line_col;
> -};
> -
> static inline __u64 ptr_to_u64(const void *ptr)
> {
> 	return (__u64) (unsigned long) ptr;
> @@ -831,6 +790,9 @@ static int btf_ext_setup_info(struct btf_ext *btf_ext=
,
> 	/* The start of the info sec (including the __u32 record_size). */
> 	void *info;
>=20
> +	if (ext_sec->len =3D=3D 0)
> +		return 0;
> +
> 	if (ext_sec->off & 0x03) {
> 		pr_debug(".BTF.ext %s section is not aligned to 4 bytes\n",
> 		     ext_sec->desc);
> @@ -934,6 +896,19 @@ static int btf_ext_setup_line_info(struct btf_ext *b=
tf_ext)
> 	return btf_ext_setup_info(btf_ext, &param);
> }
>=20
> +static int btf_ext_setup_offset_reloc(struct btf_ext *btf_ext)
> +{
> +	struct btf_ext_sec_setup_param param =3D {
> +		.off =3D btf_ext->hdr->offset_reloc_off,
> +		.len =3D btf_ext->hdr->offset_reloc_len,
> +		.min_rec_size =3D sizeof(struct bpf_offset_reloc),
> +		.ext_info =3D &btf_ext->offset_reloc_info,
> +		.desc =3D "offset_reloc",
> +	};
> +
> +	return btf_ext_setup_info(btf_ext, &param);
> +}
> +
> static int btf_ext_parse_hdr(__u8 *data, __u32 data_size)
> {
> 	const struct btf_ext_header *hdr =3D (struct btf_ext_header *)data;
> @@ -1004,6 +979,13 @@ struct btf_ext *btf_ext__new(__u8 *data, __u32 size=
)
> 	if (err)
> 		goto done;
>=20
> +	/* check if there is offset_reloc_off/offset_reloc_len fields */
> +	if (btf_ext->hdr->hdr_len < sizeof(struct btf_ext_header))

This check will break when we add more optional sections to btf_ext_header.
Maybe use offsetof() instead?

> +		goto done;
> +	err =3D btf_ext_setup_offset_reloc(btf_ext);
> +	if (err)
> +		goto done;
> +
> done:
> 	if (err) {
> 		btf_ext__free(btf_ext);
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index 88a52ae56fc6..287361ee1f6b 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -57,6 +57,10 @@ struct btf_ext_header {
> 	__u32	func_info_len;
> 	__u32	line_info_off;
> 	__u32	line_info_len;
> +
> +	/* optional part of .BTF.ext header */
> +	__u32	offset_reloc_off;
> +	__u32	offset_reloc_len;
> };
>=20
> LIBBPF_API void btf__free(struct btf *btf);
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_inter=
nal.h
> index 2ac29bd36226..087ff512282f 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -46,4 +46,95 @@ do {				\
> int libbpf__load_raw_btf(const char *raw_types, size_t types_len,
> 			 const char *str_sec, size_t str_len);
>=20
> +struct btf_ext_info {
> +	/*
> +	 * info points to the individual info section (e.g. func_info and
> +	 * line_info) from the .BTF.ext. It does not include the __u32 rec_size=
.
> +	 */
> +	void *info;
> +	__u32 rec_size;
> +	__u32 len;
> +};
> +
> +#define for_each_btf_ext_sec(seg, sec)					\
> +	for (sec =3D (seg)->info;						\
> +	     (void *)sec < (seg)->info + (seg)->len;			\
> +	     sec =3D (void *)sec + sizeof(struct btf_ext_info_sec) +	\
> +		   (seg)->rec_size * sec->num_info)
> +
> +#define for_each_btf_ext_rec(seg, sec, i, rec)				\
> +	for (i =3D 0, rec =3D (void *)&(sec)->data;				\
> +	     i < (sec)->num_info;					\
> +	     i++, rec =3D (void *)rec + (seg)->rec_size)
> +
> +struct btf_ext {
> +	union {
> +		struct btf_ext_header *hdr;
> +		void *data;
> +	};
> +	struct btf_ext_info func_info;
> +	struct btf_ext_info line_info;
> +	struct btf_ext_info offset_reloc_info;
> +	__u32 data_size;
> +};
> +
> +struct btf_ext_info_sec {
> +	__u32	sec_name_off;
> +	__u32	num_info;
> +	/* Followed by num_info * record_size number of bytes */
> +	__u8	data[0];
> +};
> +
> +/* The minimum bpf_func_info checked by the loader */
> +struct bpf_func_info_min {
> +	__u32   insn_off;
> +	__u32   type_id;
> +};
> +
> +/* The minimum bpf_line_info checked by the loader */
> +struct bpf_line_info_min {
> +	__u32	insn_off;
> +	__u32	file_name_off;
> +	__u32	line_off;
> +	__u32	line_col;
> +};
> +
> +/* The minimum bpf_offset_reloc checked by the loader
> + *
> + * Offset relocation captures the following data:
> + * - insn_off - instruction offset (in bytes) within a BPF program that =
needs
> + *   its insn->imm field to be relocated with actual offset;
> + * - type_id - BTF type ID of the "root" (containing) entity of a reloca=
table
> + *   offset;
> + * - access_str_off - offset into corresponding .BTF string section. Str=
ing
> + *   itself encodes an accessed field using a sequence of field and arra=
y
> + *   indicies, separated by colon (:). It's conceptually very close to L=
LVM's
> + *   getelementptr ([0]) instruction's arguments for identifying offset =
to=20
> + *   a field.
> + *
> + * Example to provide a better feel.
> + *
> + *   struct sample {
> + *       int a;
> + *       struct {
> + *           int b[10];
> + *       };
> + *   };
> + *=20
> + *   struct sample *s =3D ...;
> + *   int x =3D &s->a;     // encoded as "0:0" (a is field #0)
> + *   int y =3D &s->b[5];  // encoded as "0:1:5" (b is field #1, arr elem=
 #5)
> + *   int z =3D &s[10]->b; // encoded as "10:1" (ptr is used as an array)
> + *
> + * type_id for all relocs in this example  will capture BTF type id of
> + * `struct sample`.
> + *
> + *   [0] https://llvm.org/docs/LangRef.html#getelementptr-instruction
> + */
> +struct bpf_offset_reloc {
> +	__u32   insn_off;
> +	__u32   type_id;
> +	__u32   access_str_off;
> +};
> +
> #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
> --=20
> 2.17.1
>=20

