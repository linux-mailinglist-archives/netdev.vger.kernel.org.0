Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381F62A3C02
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbgKCFfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:35:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22738 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725980AbgKCFfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:35:55 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A35ZeF9011338;
        Mon, 2 Nov 2020 21:35:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=P6571H64fW0YsC86Zm3QbkvPxa784aaODNcEHT9LyKc=;
 b=FzxZ2huSWoyonhjBxuD+7bq6iGS9Bl/Y2d7hTgqd8YD1ZDFp1S6vUSQGUE4EuR7T7tn7
 22TCcBFTnIvsywqnRTYw9KdHb+a3K3fa2aY/ChasRwPwOI8QNoEFnnKLnkxpIGYEEYsP
 FU2yLialtvp3qurJ7/4NKy2wAj7P/hF05u0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34hr04hb9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 21:35:41 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 21:35:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bfj/tb6FVZ+EV2M6pD5oK7FE3yTp3xzqyMN4g9wnCg6NYHZgh9t1CdRHd2ooTx5E00uDo7oFW9/HHl+NU8FzNPwE0DEVWAPfRusFWfvPveVDk3kVYSatihX1wbjPKQzy3rAqnbJnnltlxmRQj0qg7gzCDq2F2jZAqPza5Dtq/nEGtkH2PiLLZsDNg9RL77R5mxvJZj83b6GSsxo4HBY73AHc14bbuzVwAg/0KnNsDkAtsl+c4Ht8By+uIisFbG9rpaysY7P+bhJw318RWN9KG+ApVbKncIESMHxWJdOjDc3M4WwcTd3SCGZ+Or18tulqBqr9CfSbMbLdjIpl06tPxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6571H64fW0YsC86Zm3QbkvPxa784aaODNcEHT9LyKc=;
 b=lg+5CBD+yrJhZl0Ed+CRkJsJ+x9pMy3aZbMTi9hNqzXxxJGPNr2Ya4ptcOu0rlM4puLI0d5HlhbxLmvXxpj82vnt2H5mcuLy9+a62G8v8/uIByTFSyaUXevTawHn5TZ0MUXasNhTk5DTNLf4tOQTUq7IsFn4+pilkW1vwogKRoXR+j76x/6o9N+WffySUVoPIhscUMqgdU+skXMva5lsYpf2KPhJsbQ9PuS/y5+os8P/0OndUHFC+k2VbUkzRiBaqgLd5iUs3lfdh195Fb1xoGgWmw3oHY6wEJLY0dGR96aiB/CrCQ/aach6wRpRLndoicz33uhczHXjrBdPQ3xEyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6571H64fW0YsC86Zm3QbkvPxa784aaODNcEHT9LyKc=;
 b=idMfy6GXwVj6APSo05Dk4HrbeiOQfJcospm9CUKe+5CAHceSUqOeIQVei7KDjHi5BPoMAFJecVgG1icpbrRHX2fFaZj+aE4LG1+++sNHXT1XSd9J3o7NnGMw3fOld5RNaFc34fV0CBqTgz4ifLSoLBnYWYbg5cnXq0eo+fgUwYY=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2246.namprd15.prod.outlook.com (2603:10b6:a02:8d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 05:35:15 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 05:35:14 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 10/11] selftests/bpf: add split BTF dedup
 selftests
Thread-Topic: [PATCH bpf-next 10/11] selftests/bpf: add split BTF dedup
 selftests
Thread-Index: AQHWrY7ZjPZZk5MObUyN0fT/zS+U16m16xaA
Date:   Tue, 3 Nov 2020 05:35:14 +0000
Message-ID: <23399683-99A4-4E91-9C7B-8B0E3A4083DE@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-11-andrii@kernel.org>
In-Reply-To: <20201029005902.1706310-11-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1ff6e18-3a76-4c53-1765-08d87fba3db5
x-ms-traffictypediagnostic: BYAPR15MB2246:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2246022D6A00F9A29F5EE2E8B3110@BYAPR15MB2246.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RfUNyCMuGiWtBcBct6/ZCwMwoKoStgqmWKPXEka2ldq6kLgtTLdpWI7q+OOCCcR7f6esPA2hmHfsTYyZlzswlB5afbNf0ViO5mqisV5cK87sTIV6YVTe9PL8ka9bPZFJX2Qm9B5ucDMzjT1JclfkyGwE0ggzhpwyF77qdoJCJW9Jyq/b73XdZrkg1T6GXsvji/zP1posl0hM4rFEoHiFlM8HZHY1FUvPYGeO7nbkeBtH9hhC6SdXDwD1WtUJWcPifbkoWcpP7hwYZiNwWiR3gBQOoJ+gjP6m8kVokt9TV+ZV7x1MK/GuXBjxGtfJZeHSGNh6hWGaLFbUzj2cG7KUkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(346002)(136003)(376002)(4326008)(54906003)(2616005)(5660300002)(66446008)(66946007)(64756008)(66476007)(66556008)(76116006)(2906002)(6486002)(478600001)(71200400001)(83380400001)(36756003)(316002)(8676002)(6916009)(53546011)(33656002)(6506007)(8936002)(91956017)(186003)(86362001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: K/UeR4Csq37rQ4WGfvGdRWsULSIIVdufh4jK3GGnpMKokuZ7io9KhBSjuVcK+rbMlhtd8dckop5uHx9ILpRHEJdHQVs+RlwMtB8h6Rm49zRd+ppVOwxuDL913l+LY4LyCH/3if6QiRzna+cE/gX9wrYK9KSlgpOdSA3HFeCur/ouB3Ha4x822bA14oJAl8igEb1RGrEpZnR2jDxb2OYW46LTXi6PoD32gULQFY2MeQtaCkUsFVXjhezApsxIFdGJkg79+7DrRTu0d1duO69/Ctr9xKXvL20Rfm2cxS06LeHhv57S7QTRodob6Gw7iYr55WnpNnoW7BkOoUnaIQCxsSafulfGI3TTTV3SZwx8SiNrWaFKLEyrj2RuWdADRKCwjW7NvM4zWthb5SELIxLzHpA3waif9m3vQEqx4dLtooq76b52CuAGURKbkhcnTyZ0n1dqh7rNh3gfg+CR2rT4R+hbP1FEoClCfKlaOcB5Hi8pDxCVWECGO41JREEfAM60+neqU63i8DJaUBgfPrII00VqakOFeD9oTDlnRcYcmdSX8AdjlzUwPzGKAgUFj3rn5PdX1m1CsZTXV5Twm8Jfy5nnf4CAsHvkFkWlK1EJQe/eA6f1hL5nqwf6r/hPDAdECGyDWKHgEwIfQ8SvBmgVW+VGdTbJcnz3RfeJ2WjMi/5WeMmnKf6XSvR+pelN1O68
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C367475727D52A469409BB4E6A393093@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ff6e18-3a76-4c53-1765-08d87fba3db5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 05:35:14.7348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L0g1acZhItj/WqxgJSg1iCMQz/0PHHlJ205SyDvWQ1XUXGpeULFhWa6Ep5G/dPlJQfLl/gKfDn7vQ0nQ+tRlSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2246
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_02:2020-11-02,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 28, 2020, at 5:59 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>=20
> Add selftests validating BTF deduplication for split BTF case. Add a help=
er
> macro that allows to validate entire BTF with raw BTF dump, not just
> type-by-type. This saves tons of code and complexity.
>=20
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

with a couple nits:

[...]

>=20
> int fprintf_btf_type_raw(FILE *out, const struct btf *btf, __u32 id);
> const char *btf_type_raw_dump(const struct btf *btf, int type_id);
> +int btf_validate_raw(struct btf *btf, int nr_types, const char *exp_type=
s[]);
>=20
> +#define VALIDATE_RAW_BTF(btf, raw_types...)				\
> +	btf_validate_raw(btf,						\
> +			 sizeof((const char *[]){raw_types})/sizeof(void *),\
> +			 (const char *[]){raw_types})
> +
> +const char *btf_type_c_dump(const struct btf *btf);
> #endif
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c b/t=
ools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
> new file mode 100644
> index 000000000000..097370a41b60
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
> @@ -0,0 +1,326 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +#include <test_progs.h>
> +#include <bpf/btf.h>
> +#include "btf_helpers.h"
> +
> +
> +static void test_split_simple() {
> +	const struct btf_type *t;
> +	struct btf *btf1, *btf2 =3D NULL;
> +	int str_off, err;
> +
> +	btf1 =3D btf__new_empty();
> +	if (!ASSERT_OK_PTR(btf1, "empty_main_btf"))
> +		return;
> +
> +	btf__set_pointer_size(btf1, 8); /* enforce 64-bit arch */
> +
> +	btf__add_int(btf1, "int", 4, BTF_INT_SIGNED);	/* [1] int */
> +	btf__add_ptr(btf1, 1);				/* [2] ptr to int */
> +	btf__add_struct(btf1, "s1", 4);			/* [3] struct s1 { */
> +	btf__add_field(btf1, "f1", 1, 0, 0);		/*      int f1; */
> +							/* } */
> +

nit: two empty lines.=20

> +	VALIDATE_RAW_BTF(
> +		btf1,
> +		"[1] INT 'int' size=3D4 bits_offset=3D0 nr_bits=3D32 encoding=3DSIGNED=
",
> +		"[2] PTR '(anon)' type_id=3D1",
> +		"[3] STRUCT 's1' size=3D4 vlen=3D1\n"
> +		"\t'f1' type_id=3D1 bits_offset=3D0");
> +

[...]

> +
> +cleanup:
> +	btf__free(btf2);
> +	btf__free(btf1);
> +}
> +
> +static void test_split_struct_duped() {
> +	struct btf *btf1, *btf2 =3D NULL;

nit: No need to initialize btf2, for all 3 tests.=20

> +	int err;
> +
[...]

