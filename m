Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CE82A371A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgKBXYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:24:18 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3436 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725831AbgKBXYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 18:24:17 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A2NKsYX012797;
        Mon, 2 Nov 2020 15:24:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=UOvWB8J/7MDfMl5B2dXQAuKg+t3zqktlUOq3DMiI7fg=;
 b=pSMD4jwq/ah7eqfviKtjYbrsTb1Cu+2JDvl/tbFJOwy5oij51S8IfoCIlozCYh4s1Lzc
 eKUKTIp7U768D16NEENVCgSZEAjzK+VTvBdoI+1+et8rFA1G4xNeEaBLo+PjAu8NEPDO
 8qfUwRGE4Z7RqeldCc7gVduUKC6Lm0fd+Vw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34jexxc72f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 15:24:02 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 15:24:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdaZWQVqqcJoRgt77Mv+J67AD308idxfw78HeGGXekvEeBlUVZivA59Aa4OtQYGGdVS00g4va7U48hqOhh5zbWKzy/95urweSVv6A1NwemoM2LdsrofUuP/63IBIVuC0MNhPuEP4ZM1Uuv7WiaXmTqK+XfBR/Pnt1zavnfLt6wScJGC16Flb0MsMXTrg4thxcTbyfBm7o/Eq+UR2fzcki+Q9jbw8Yy/N3AYl03oOx3nimWqHrverL5raAcCMZ/vnaOtqLZwPNOrTYQ4xYCxcOge2dGkEnmZJzC/+Huw/Ht9b5fTENdUwFHxSLzku8c4c1Kue6TFrXv+6Lg5O2/aLQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOvWB8J/7MDfMl5B2dXQAuKg+t3zqktlUOq3DMiI7fg=;
 b=B6w5V53VXnpJn/IPNFEoMDzZq5AjOocAX28gExqw+2vBx3z5k5BDrMDC5wup7B6RRtoDlhWufrgL6o0FmQqerJD+m2ecnD1uEJeIjWdvQWqRjdNfI8CFfjKCiYgVloyVasjAEGGU1u+fCPfWO0tWxJ2S/0Lh9mX7dcawa9RZ1CXmHf+rtUGAt2TyOtKP4IWmZy1xG+q0LClpfJI78sRUFCt9lZSMo6M45VBunGgzA9P9Vhf9m3DBFFQxJMDR8jxUOWyq5wcANxzQRtcpddXRDxDCqJ4vRn53OL30qmB21VvSRUcrohhXK/+Pl9yemfq6Bw8aG+E5wDQ0q61Pb4yUdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOvWB8J/7MDfMl5B2dXQAuKg+t3zqktlUOq3DMiI7fg=;
 b=KruVB2mnVvbs/0aIq/I6WIvk/V1OsWNY03weB+7OpsCyaQHtWiZNHztdMnpcu4ubt+PoF95ClmStz7MolcqhQCI204w4hfDJ8pUtqX6ux2kXiZzR1rRnZ10rCA7MqwM24ijJ2ZRN0d8QBAODWCi9RXpbJ3icYgWYxkMiEipY/74=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2774.namprd15.prod.outlook.com (2603:10b6:a03:15d::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Mon, 2 Nov
 2020 23:23:49 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 23:23:49 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 04/11] libbpf: implement basic split BTF support
Thread-Topic: [PATCH bpf-next 04/11] libbpf: implement basic split BTF support
Thread-Index: AQHWrY7LDkOlZjem1EymWH+wL8m9Xqm1g0+A
Date:   Mon, 2 Nov 2020 23:23:49 +0000
Message-ID: <DE5FDF1D-0E5B-409B-80DF-EDA5349FE3A6@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-5-andrii@kernel.org>
In-Reply-To: <20201029005902.1706310-5-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f35e163d-4746-42f0-9141-08d87f865a7a
x-ms-traffictypediagnostic: BYAPR15MB2774:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB27747D1DB60E7F77F6594F9AB3100@BYAPR15MB2774.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7CFW7KuxGq+aaaTgQxO7E3vQjf6D0ThJOMpm9saeUTVa2c/tHiyqsLi7eGipLp8wrJYHqMeD02Zr67kEwmtpHZGl69a4F09GghRTbPFWQiSTvSz8lO/CL347H2KDh01bLARMN3i+kgdnQYpCOdwelY6ecIn8Qcyyjj+S63WEh0Njx3V3InWbg6E9by2s5VRmUSMj6sN5ok9VzAeNdMOhKAHIA9yHpFMORwqtVcp7C5c7Ik6fi6GJQl8+le7SBGlnJuiTEZ1zyKgVyeVLcjg63jztqOVsCsoX+QQ6FIJBz92q5lkEaiIIg+P7RWV6A0OnUkA+cHZDRiniPgDo4F21+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(366004)(39860400002)(186003)(36756003)(91956017)(76116006)(66946007)(478600001)(86362001)(53546011)(6506007)(71200400001)(66476007)(64756008)(66556008)(66446008)(316002)(6512007)(6916009)(8936002)(8676002)(83380400001)(5660300002)(4326008)(33656002)(6486002)(2616005)(2906002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 3CTx5yDpVzl7Dt4Qef+gWwNo26gwH8TwxSYVwceA+uxwgpTCqT+GvkGeamIGhJCjZNtFvwxMDPCboF14v8Lqw+3mG+XaBbAHYM6yS73DVLJd/EbkzTHV7PDsc3h8W+MqR4aC9bF/eo5YV1sxPaKYX5HUfhbWNzEOLXOnAXM0ANiZSL1nPP4bt0MoQa4VAc8pxf7xFW3l30PRJUgoKkCoyO9cqsN2IBBK21yrDDyqP7iBeq2ZOJfuWYH0pzFlB7VTfAakI0QF+Ru3BaEBdlmW6ZHxZ9iIYpglt8CLYkt6NqXaX7gvAIo29pMEo53yzlTeTI6Jr8w5/mZ0X9TbrFOOCk1l/1DyL1lZeb03ZPWVa2jL0G9uIbclMjRi7r/3pbkpyr/7dcf/clU1kkd3PgPcQQd+bcGMXfpFqHxq2aSApK5MevtEC/pRmBN1/eKFpCR1vjsMSka6CoGDRhR7ZVK9IQ5DJvaiwL+AOhQdW+j2Q3uAMg8CnWbIVZgYvya/N34FCrPqELKIOXJ3c5anJUen8iM+XKKLLfCnZ52ktXpOB//SACpd3eRd/jFHjZkuVBjsOUavs7IGPcoHyn5+iYpVrWAFKuYJLf1R+hOut2jOAUArNwMDKMilOLNMcVk1wYPGUOgkjH5RlOD/jk7ihRyg0Mc73wfs7wTbWf9swneFDbBEbcKP1sNWCIrhd+MmD4CP
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CDE92FC9EDA3A147870EF67BCF45C636@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f35e163d-4746-42f0-9141-08d87f865a7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2020 23:23:49.1933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p5BP3e6ZDvpT3X03zUtzlkvI9cUmD2Tcvkgj7YzfW4+zYxDDZ0MEdv8I4l0XFrmQ5mF5YHx4gQp7ZOQkPOoYbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2774
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_16:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011020179
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>=20

[...]

>=20
> BTF deduplication is not yet supported for split BTF and support for it w=
ill
> be added in separate patch.
>=20
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

With a couple nits:

> ---
> tools/lib/bpf/btf.c      | 205 ++++++++++++++++++++++++++++++---------
> tools/lib/bpf/btf.h      |   8 ++
> tools/lib/bpf/libbpf.map |   9 ++
> 3 files changed, 175 insertions(+), 47 deletions(-)
>=20
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index db9331fea672..20c64a8441a8 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -78,10 +78,32 @@ struct btf {
> 	void *types_data;
> 	size_t types_data_cap; /* used size stored in hdr->type_len */
>=20
> -	/* type ID to `struct btf_type *` lookup index */
> +	/* type ID to `struct btf_type *` lookup index
> +	 * type_offs[0] corresponds to the first non-VOID type:
> +	 *   - for base BTF it's type [1];
> +	 *   - for split BTF it's the first non-base BTF type.
> +	 */
> 	__u32 *type_offs;
> 	size_t type_offs_cap;
> +	/* number of types in this BTF instance:
> +	 *   - doesn't include special [0] void type;
> +	 *   - for split BTF counts number of types added on top of base BTF.
> +	 */
> 	__u32 nr_types;

This is a little confusing. Maybe add a void type for every split BTF?=20

> +	/* if not NULL, points to the base BTF on top of which the current
> +	 * split BTF is based
> +	 */

[...]

>=20
> @@ -252,12 +274,20 @@ static int btf_parse_str_sec(struct btf *btf)
> 	const char *start =3D btf->strs_data;
> 	const char *end =3D start + btf->hdr->str_len;
>=20
> -	if (!hdr->str_len || hdr->str_len - 1 > BTF_MAX_STR_OFFSET ||
> -	    start[0] || end[-1]) {
> -		pr_debug("Invalid BTF string section\n");
> -		return -EINVAL;
> +	if (btf->base_btf) {
> +		if (hdr->str_len =3D=3D 0)
> +			return 0;
> +		if (hdr->str_len - 1 > BTF_MAX_STR_OFFSET || end[-1]) {
> +			pr_debug("Invalid BTF string section\n");
> +			return -EINVAL;
> +		}
> +	} else {
> +		if (!hdr->str_len || hdr->str_len - 1 > BTF_MAX_STR_OFFSET ||
> +		    start[0] || end[-1]) {
> +			pr_debug("Invalid BTF string section\n");
> +			return -EINVAL;
> +		}
> 	}
> -
> 	return 0;

I found this function a little difficult to follow. Maybe rearrange it as=20

	/* too long, or not \0 terminated */
	if (hdr->str_len - 1 > BTF_MAX_STR_OFFSET || end[-1])
		goto err_out;

	/* for base btf, .... */
	if (!btf->base_btf && (!hdr->str_len || start[0]))
		goto err_out;

	return 0;
err_out:
	pr_debug("Invalid BTF string section\n");
	return -EINVAL;
}
> }
>=20
> @@ -372,19 +402,9 @@ static int btf_parse_type_sec(struct btf *btf)
> 	struct btf_header *hdr =3D btf->hdr;
> 	void *next_type =3D btf->types_data;
> 	void *end_type =3D next_type + hdr->type_len;
> -	int err, i =3D 0, type_size;

[...]

