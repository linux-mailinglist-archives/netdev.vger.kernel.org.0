Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1413D2A377B
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgKCAIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:08:24 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44456 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725910AbgKCAIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 19:08:24 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A305WVx024766;
        Mon, 2 Nov 2020 16:08:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=aSsF5UJbfGx8tr4+w0albPDWJ4L+5AdtmAYBLz0IgCU=;
 b=Gu28nqWWnxHU4T/MZaM8A++u6BJmwPBWcUQWbLl3FIHNCQNeIcWV58OqSkMaqK/Zi56m
 3QG6Bc441x4icQVVFWNtgLN3pU3SeTYtwiKjMUWsVXgr1WufncPspIGZdar22NOOLiav
 xzZuHQfYepd6JXOQnxBZiGz5OddoTdiTRlA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34hqeb86rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 16:08:11 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 16:08:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSH0NyelLEg9jddcHESFiJ9xxAfLabJ1YRS5wetD1lfwTeuY0yaspQQVGe6nSxmbjo9xsZnVFu8dfyicjAmJ6e0SsH/r9TCBfV4IwUGa4alTNYjjzHH9i1tqAZq061QV9SxCRtloZ9Vz3TiepbUGDgC4ip8cEbEBajUUc5zS7ARkN7eIUaHuZ0AJcOaaZ+Tfr14G2dfTqdu/NVnjySBpOrPZ6eAhNeNnv/9+YI6K1qfrbR/OZEVDFj8khszJEaVVnhPLFOTOh2J2HPUpqIDLb/ubqNSE5m04QdVrrLe+4lMR7Sv7VgYjP0ilyJepfdkRI+nY30dkZe2RTeUBffH39A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSsF5UJbfGx8tr4+w0albPDWJ4L+5AdtmAYBLz0IgCU=;
 b=igvDKKoO+PDgD+bPX4Bgy1nX991Xqxha8elluE711Rb7BgOeA6fTaRHid4OTzx19HkABNPyFQqXWvjbXnWlQfKAIaayBSmngdWghF0QRb6DmbBKoSig4xHFK+AbnXz4i4JgBri/4T2cmyPHlYYpaIul5awzQQZp3lN+G47zm8XFYEknxpzFdGJoKbuuuiteuukF0FG4RYR5EiUIv1z/fgamV/ldthn72+8FBr+SewK4A8jgVCZg/Cf0RdeHqWhBhBuFOwQ5gkKto5x2us8sKhn37MkGcu+6nImX7OtV7cFrxlxlbWi3BG0Jb0FYDbkL+dc4/uF1hzfT2cWXy0VrNpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSsF5UJbfGx8tr4+w0albPDWJ4L+5AdtmAYBLz0IgCU=;
 b=dbmixp+Gwn7bAXren3sW9BZXUHLDBP2mqTkLowHkI+0w6a+/D1mop65Qrf9RiHoaXSW6tsvSwZhHoEc6P8EyIJkE9tQN6keCR0i5HqTlItuf6DBtQD1NC8guybgKq2fd2xEktj+jy+PlFYkUhXHdAp/bISuUqY6/3PL3z3Ld9oA=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3302.namprd15.prod.outlook.com (2603:10b6:a03:10f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Tue, 3 Nov
 2020 00:08:08 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 00:08:08 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 06/11] selftests/bpf: add checking of raw type
 dump in BTF writer APIs selftests
Thread-Topic: [PATCH bpf-next 06/11] selftests/bpf: add checking of raw type
 dump in BTF writer APIs selftests
Thread-Index: AQHWrY7Ggw2+ahrOxUa+p1/YeHxTram1j7KA
Date:   Tue, 3 Nov 2020 00:08:08 +0000
Message-ID: <507AB3B7-50BF-43CA-82CA-7C24CD5DF8A4@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-7-andrii@kernel.org>
In-Reply-To: <20201029005902.1706310-7-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8427146d-ddf2-46d2-e658-08d87f8c8b6d
x-ms-traffictypediagnostic: BYAPR15MB3302:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3302D94F9898503404D48809B3110@BYAPR15MB3302.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PywD4aweVl8tzQgbxEOfI53zYyL0dn28jdV//feB+ZLxFqhubHR5vbx2xjYxoucGo+o6X1gArnnxv/VFSSxaELc7PqYVN/75vFlRkHNsIJ+UFDMxNIWcdj6gGhfEoYdEAoGymJEJgaroYwINClBuEddd+OXRVoUmda4qhDZ8wXkwAKTrT7Kx0AjqnLRFERQOWTkXqePDhhgDT6XXcvAqS6h0pxbTUQJHFQbvCdTJlwfmPKW0YBKEKIPd58BB7rJcRTIk/59GVD5G6JWbfTl5DZHIuXDuhTyFE9bcLlrWEvrBOMvtvW3YNRFMgrJLJTFVlcgT1u3beR/9ducZ1XlFCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(366004)(346002)(376002)(76116006)(6506007)(186003)(86362001)(53546011)(36756003)(66446008)(64756008)(8936002)(66556008)(66476007)(6916009)(66946007)(33656002)(6486002)(478600001)(71200400001)(5660300002)(2906002)(8676002)(54906003)(83380400001)(316002)(4326008)(2616005)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: pFOL8M+OSeAVqmZ/ANnPncGh8wuI3NkVzhZHbGPYKzl8ETeAi/6E11/f7NVVuUfaAWVuA28vdjp//CJEFBkIwphN7T9dm7aZn4WfIunFJ/q+JXwTk/P58xFAJx/ilsFyO7U8GLQP3zVdBVVILFuVCdMquHBRj0a3MHZv7A+llozHT7hQ1CU48ibnrjPB9DFMlVcVQ+dmIDDZ6lBiclTEXecI4SL3TGDT7focf1ZvYDJU2TVnxIqvQtHXvmvtiyD/ZB3H41qAxZTRcCppYXjGPFstlJ2IS1kGvY4cpktjwANnzj/XNNFlZGXVCnkycx9OfKJK12pRj+T3qWlMgPkIpgKC0btH4LxYWx/QeIKftDWEEajbA5WxrCapIA3zx/OAcwItDpS93+8HTtCEgOYDaPrPv3SYDLROMmTwu4KmcYlrc3eicliBp+KNQ+9r81wX7D9JnQhwFTQ3+yXZ84zDAbiTO9zRBCKdzCIL4dp+nnYr5Vak2Wum2K+y3/KP8Oul+5/6k9/AtFgrDzYKJPZJpQyiGmZlbZhPw0kFpNG/woUlG7CHkAdvHkyMKRAGL/0P60FVji2PnYGtM6KSFMMJqS1DRPTunZrhZ//MWjuPDqoEoxqFr+Tmc2+VLccco3Qav9bKtBefepWjdRoJmNtOy2hgL+XFVKrM+iyRsPKZ5gIHcguRfiJnoR/31mxmqYqO
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FBF55194407D774D818AC0CE2E195EB3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8427146d-ddf2-46d2-e658-08d87f8c8b6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 00:08:08.3430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jNpx/yV9+wDeJN3/mkp78j1ygkiM+KuqrxQkDxjIs9YdKd5XLjsfhQhsmoF1Sy4tWCZ9aIQuddIP3euyqaxfvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3302
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_16:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 bulkscore=0 malwarescore=0 clxscore=1015 mlxscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011020186
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>=20
> From: Andrii Nakryiko <andriin@fb.com>
>=20
> Add re-usable btf_helpers.{c,h} to provide BTF-related testing routines. =
Start
> with adding a raw BTF dumping helpers.
>=20
> Raw BTF dump is the most succinct and at the same time a very human-frien=
dly
> way to validate exact contents of BTF types. Cross-validate raw BTF dump =
and
> writable BTF in a single selftest. Raw type dump checks also serve as a g=
ood
> self-documentation.
>=20
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

with a couple nits:

[...]

> +
> +/* Print raw BTF type dump into a local buffer and return string pointer=
 back.
> + * Buffer *will* be overwritten by subsequent btf_type_raw_dump() calls
> + */
> +const char *btf_type_raw_dump(const struct btf *btf, int type_id)
> +{
> +	static char buf[16 * 1024];
> +	FILE *buf_file;
> +
> +	buf_file =3D fmemopen(buf, sizeof(buf) - 1, "w");
> +	if (!buf_file) {
> +		fprintf(stderr, "Failed to open memstream: %d\n", errno);
> +		return NULL;
> +	}
> +
> +	fprintf_btf_type_raw(buf_file, btf, type_id);
> +	fflush(buf_file);
> +	fclose(buf_file);
> +
> +	return buf;
> +}
> diff --git a/tools/testing/selftests/bpf/btf_helpers.h b/tools/testing/se=
lftests/bpf/btf_helpers.h
> new file mode 100644
> index 000000000000..2c9ce1b61dc9
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/btf_helpers.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2020 Facebook */
> +#ifndef __BTF_HELPERS_H
> +#define __BTF_HELPERS_H
> +
> +#include <stdio.h>
> +#include <bpf/btf.h>
> +
> +int fprintf_btf_type_raw(FILE *out, const struct btf *btf, __u32 id);
> +const char *btf_type_raw_dump(const struct btf *btf, int type_id);
> +
> +#endif
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf_write.c b/tools/t=
esting/selftests/bpf/prog_tests/btf_write.c
> index 314e1e7c36df..bc1412de1b3d 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf_write.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf_write.c
> @@ -2,6 +2,7 @@
> /* Copyright (c) 2020 Facebook */
> #include <test_progs.h>
> #include <bpf/btf.h>
> +#include "btf_helpers.h"
>=20
> static int duration =3D 0;
>=20
> @@ -11,12 +12,12 @@ void test_btf_write() {
> 	const struct btf_member *m;
> 	const struct btf_enum *v;
> 	const struct btf_param *p;
> -	struct btf *btf;
> +	struct btf *btf =3D NULL;

No need to initialize btf.=20

> 	int id, err, str_off;
>=20
> 	btf =3D btf__new_empty();
> 	if (CHECK(IS_ERR(btf), "new_empty", "failed: %ld\n", PTR_ERR(btf)))
> -		return;
> +		goto err_out;

err_out is not needed either.=20

[...]=
