Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848202ADD62
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 18:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbgKJRuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 12:50:17 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20214 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730473AbgKJRuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 12:50:15 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AAHmjEF025517;
        Tue, 10 Nov 2020 09:49:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=VrSJWdaxDSKmOpTC0lTq1V6nmhsYgzIBEmXnj3g04RE=;
 b=USPMH23DU0Z+zCtMO++amEgzF7TNK1ElnmIixarFoLDHjYRjBKm+Spgxdrww1+mSva7x
 pSucWmNM4sMoCH6hl0TM5+/xzhb+ov1ULrpOE3AnK2+wu5tmgBId1GfNoyhISbVF3MC7
 J93NKhV0dF1FN8fyiQwTj4pFbmlGhdN3Ld0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34pc9qc5fk-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Nov 2020 09:49:59 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 10 Nov 2020 09:49:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoEqgb0R/CnIxlFMQRWGmZ5UM7NroxmyCJFqAGJepuKcpUSeDu5EQnyrBcmcnbCnmifFUtHqrSz+62lEKHFf4wsf+3ct8bFdJSCAiax3h2gj9geofPs68uHKYh19PXDhnWKa874er+ihHwfkCbrBr3VmH1yl8ooDiHSTomwb44qx/RwxB5XOhDS7uCjc3qbByTWrFHUmojfPkorDdio4jiMNJSQr/vTiMbgFleIkvAsF0YK5CsgqA/hKG0p4g7h7H6882HlIO8v7jIjO0I1C9zXJhdx4Ffzag23Ze/BL/Wqoht5xktWACWDL16TUKlzdjblhDhO3BPKP5rrUMo1XwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VrSJWdaxDSKmOpTC0lTq1V6nmhsYgzIBEmXnj3g04RE=;
 b=DAkuexuRV4+jpdZWm7rLcl8+a1Bz5EToa+hzapmJpx08aQjo1H53xv9WsLtsXPAhheunFnELWnl224HOUTvilBR6wFjs9tRD5MtyDvYBM/4FXZftWF3cUEVqRn7qLxmnnLP2kthulyLPl0epIkalU/7FA4yoFkNQCAvn6rtGICrHg38mVorK051OZuo0LCMHHrCzsdlSkZ2zGR5Vu1FokYRhn2wMTjkzwR9ZAk76xR/cHIpFhfOYV5vbtMOEKDWsve1+nx9HNC5iBaOF4Y/rb6X1DWyCaPuSk+FYDTBQFHfhnamgf1roy1jQJDlFz9d9MRVg0kASAyM1qwXWvrcZIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VrSJWdaxDSKmOpTC0lTq1V6nmhsYgzIBEmXnj3g04RE=;
 b=RXuknwzDoGpBccUzhnvblxBtZ8N48Z1pcEQIG9olwtqc8s3dXI+hIlIz53YbDwDl1T2Bz1r9WWLic+pa03lZXYcm66PGkdZv3GT4rYHxrbU1grnib8rJ1TU411j2Cbn6FTj4PpkqoxYpdV4Ql5mV8N2g1icx7v9doy6aPkiTst0=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3094.namprd15.prod.outlook.com (2603:10b6:a03:ff::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.23; Tue, 10 Nov
 2020 17:49:53 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 17:49:53 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 bpf-next 1/5] bpf: add in-kernel split BTF support
Thread-Topic: [PATCH v4 bpf-next 1/5] bpf: add in-kernel split BTF support
Thread-Index: AQHWtwAHoXtpfdzO80ynz0OJjXLTl6nBpcmA
Date:   Tue, 10 Nov 2020 17:49:53 +0000
Message-ID: <695E976D-DECA-4BE1-BFB0-771878B9CFCD@fb.com>
References: <20201110011932.3201430-1-andrii@kernel.org>
 <20201110011932.3201430-2-andrii@kernel.org>
In-Reply-To: <20201110011932.3201430-2-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:3659]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7d949e2-66ab-4dff-150d-08d885a107c8
x-ms-traffictypediagnostic: BYAPR15MB3094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3094524E7561175D8261A129B3E90@BYAPR15MB3094.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sWRaKCNaC+P0fCPd+/u5oSFJKW4MQsNLDcZdsF8WUym7mhxfZdPgNF0out7DtHwsDQnN8x1FOwUPBUpKNeY6EscfHTuASbX5xDP/MusPyyrZ13XhgyYZkdjynKFmLLgQkMe0Z3hei7qjmF2BLcGWClAF5HNaZs4nprxz/5x0+vV1GmELwSbTBjxY0R8rigDgWlFXBfDmoKqX6jqGj9zApx54+bkds1yygHobb/VBZpqCc9d0G0avs2T9bwmUtJYCOMdxj18FDGA1nof++EMrS7MClmVBSAYB2eXtbX4LrFqzyutuEUr6U0B60Rwv7KdtIAuS5qshAAp79HMdzgw/xw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39860400002)(136003)(366004)(6506007)(53546011)(66446008)(76116006)(64756008)(2616005)(36756003)(83380400001)(71200400001)(8676002)(54906003)(86362001)(66476007)(6486002)(6512007)(186003)(316002)(66556008)(2906002)(91956017)(478600001)(66946007)(5660300002)(6916009)(33656002)(4326008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: naNkYaTRxZMUMiHGLh5FPKDMfUEas92/kJXwzArGWHHDDVy502seSZnsNwgb/jdeRwnNDgEOmjQOVwnSuyE+jpnAzDa8NSImq+gjBc5goC7k4p7eXMl6CNxOUJJB0LqcLDwvKKoQjQuqHe8PfcDlH1lebQPFHIrgELQE8lSKlPybibcfzBFAAJZ1Wy8vdtgVP+VS8ghe+WHHrk67DsErEt9DMaq5sj7N0r3BCCulMOG6UXjNoN50YN6szxfAO0M1uUdzB4155wEY+iB5nINscPlgCxfv9H08qF9J7APaTmx99Y6HkkyaEEQ7Snt2BWrRf1Ir9+OkQIk2xDPemHOz+F21DUqCnl6G7OBg2pyOEvezq3kSMsuKxLsjyyiV/7ErBC8vROfRSVNzCdy/+yCjkiVtzbCFm17SQ2jbv6xSgKwBbSxD8rY1AhatpjbxvTd9SGVYvkq8lJnzKrFji/MCzR+SehQmBA2x6q38x1q0nONaLJHYasEmewtcFZQ49Y5xIYxpl8NZcgvKc060xfBMM4nXJfS3mA0WQcj0Ecr4Ur2Ph/3JqTn3paTI927H+kKXwiiwdyCeyCrkP9a2ozzCjZ2PGjjJkVpcXoj/DYLVV3vLaUIiviQiHAlbzouWLJ5auDUiypWVgyPtcTfR5gLgpW3RBHhjRpLWVWBNCI3mrb41bcR+k2IyeOmi+hy2EkzAMYFeQKGKVV/gn+RLAaEylPV2lKSNISBYaolEzwJySAmaAQzW7MwYZOeEWZJaAiqOaLcTxXLLQWoRIzibYM3W6Wb+znpmnCiqu5nBs4yw0Nn63V7FComI8WZyzMpVweBRkWez+ZE8O8jQy3reIr7hnjYB8SWelisUJdR4cfP8V/MRIr+SAEmBPfmXmXPYERtBfd8TKOJJ9LCnOSO2QB4urlXlk6r6JvIifLNC4ydXejw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <012128130996894097D84B39F76C51B6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7d949e2-66ab-4dff-150d-08d885a107c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2020 17:49:53.8098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J7B/7wZrfL7IwRo4Qfym/siokrprsxrrrKfS13j/eKFUv5FkP7WPrvNsTRhI3qT7J/Lk8UkxLX2yhSmTnybpuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3094
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_07:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011100125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 9, 2020, at 5:19 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>=20
> Adjust in-kernel BTF implementation to support a split BTF mode of operat=
ion.
> Changes are mostly mirroring libbpf split BTF changes, with the exception=
 of
> start_id being 0 for in-kernel implementation due to simpler read-only mo=
de.
>=20
> Otherwise, for split BTF logic, most of the logic of jumping to base BTF,
> where necessary, is encapsulated in few helper functions. Type numbering =
and
> string offset in a split BTF are logically continuing where base BTF ends=
, so
> most of the high-level logic is kept without changes.
>=20
> Type verification and size resolution is only doing an added resolution o=
f new
> split BTF types and relies on already cached size and type resolution res=
ults
> in the base BTF.
>=20
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
> kernel/bpf/btf.c | 171 +++++++++++++++++++++++++++++++++--------------
> 1 file changed, 119 insertions(+), 52 deletions(-)
>=20
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 6324de8c59f7..727c1c27053f 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -203,12 +203,17 @@ struct btf {
> 	const char *strings;
> 	void *nohdr_data;
> 	struct btf_header hdr;
> -	u32 nr_types;
> +	u32 nr_types; /* includes VOID for base BTF */
> 	u32 types_size;
> 	u32 data_size;
> 	refcount_t refcnt;
> 	u32 id;
> 	struct rcu_head rcu;
> +
> +	/* split BTF support */
> +	struct btf *base_btf;
> +	u32 start_id; /* first type ID in this BTF (0 for base BTF) */
> +	u32 start_str_off; /* first string offset (0 for base BTF) */
> };
>=20
> enum verifier_phase {
> @@ -449,14 +454,27 @@ static bool btf_type_is_datasec(const struct btf_ty=
pe *t)
> 	return BTF_INFO_KIND(t->info) =3D=3D BTF_KIND_DATASEC;
> }
>=20
> +static u32 btf_nr_types_total(const struct btf *btf)
> +{
> +	u32 total =3D 0;
> +
> +	while (btf) {
> +		total +=3D btf->nr_types;
> +		btf =3D btf->base_btf;
> +	}
> +
> +	return total;
> +}
> +
> s32 btf_find_by_name_kind(const struct btf *btf, const char *name, u8 kin=
d)
> {
> 	const struct btf_type *t;
> 	const char *tname;
> -	u32 i;
> +	u32 i, total;
>=20
> -	for (i =3D 1; i <=3D btf->nr_types; i++) {
> -		t =3D btf->types[i];
> +	total =3D btf_nr_types_total(btf);
> +	for (i =3D 1; i < total; i++) {
> +		t =3D btf_type_by_id(btf, i);
> 		if (BTF_INFO_KIND(t->info) !=3D kind)
> 			continue;
>=20
> @@ -599,8 +617,14 @@ static const struct btf_kind_operations *btf_type_op=
s(const struct btf_type *t)
>=20
> static bool btf_name_offset_valid(const struct btf *btf, u32 offset)
> {
> -	return BTF_STR_OFFSET_VALID(offset) &&
> -		offset < btf->hdr.str_len;
> +	if (!BTF_STR_OFFSET_VALID(offset))
> +		return false;
> +
> +	while (offset < btf->start_str_off)
> +		btf =3D btf->base_btf;

Do we need "if (!btf) return false;" in the while loop? (and some other loo=
ps below)

[...]

