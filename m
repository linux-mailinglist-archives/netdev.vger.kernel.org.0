Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0859CC4264
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfJAVOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:14:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1090 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725941AbfJAVOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:14:35 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x91L8piv010656;
        Tue, 1 Oct 2019 14:14:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=HW8txcfiC/SzwoR3GlebtE7HNxgqTA/x2U0q6Gkv7lk=;
 b=gm3h9HyEDYTAjsy1puhAU5r23WmLpFthw0VCAQBDmav3DLf9SgmwLOTFvKdPmCgrkCHj
 a03g38HLLiCEQLZ3Hjy19d7dfBb4dQgWMYQPSB3j58HM8qVBUSAUH9nkRVFafr2mkzWR
 GO8ZP34Cdv0+4hU8dpXmTkuI78onWKA5utI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vce9302np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 01 Oct 2019 14:14:18 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 1 Oct 2019 14:14:18 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 1 Oct 2019 14:14:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neiRDiti3zPkd6IQ2LItnXgcSSRJH25kTEB7DBXtFd3QCeUzBR/69aGYJmk1iU9rBaZLjh4BeWyC+/8ZATQRW1xIZ/73OSFdSc2PiX+5Xqm2ODtlbBFSpuVabX3WybHhkdT6c5Y3FMq5H4ea9vUcsN9t7PUuMcgxiK40MltMQg7wa+Tg0K7XTLIoeFo/KU3f1ZmDZqm908RByHED8CqtzXG5q9Fl6GoTgLUogME7kcTbfYB1ejh0pwatepKysK0sOrXPiHLrldHkfrT8yJDKa1KmNxMOk9/infC9VkNOxFomVYHwVgjiDAJ+ltMmh9Q0UCyqATrMLIVsaqn1o/1VPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HW8txcfiC/SzwoR3GlebtE7HNxgqTA/x2U0q6Gkv7lk=;
 b=ibgP7lg3kKpHLOo1dqTKSssfyXD7ehIf78ONI2zBrMH2J2MijWxhnN08KRc+P+89eSXGazR4tOWZtI5uArvogYq3P4AFWvn2eXkkd8VR5dE0WJq5vdr3zJVIuP3OlJr8LtfwzPnYkCVxRB8mgFV3NH6P+oV0ocGIB/4AuwN2KlB9fO1Ts7Oa+mkgkmgE4rVtTF+c/tr/LQPKYLb1pq/Argg7Oj54Pb8/28hz79EYw/lXVKUGupMt5Z4pCm8CFUvoLprQInyP+7Q0euLY8IgEgnU5cEgpPbOCwSVRiyM6jG3xkRkrEc3uwix+Cx+x7/b0lkAo81SFU3YC3BevcP0iZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HW8txcfiC/SzwoR3GlebtE7HNxgqTA/x2U0q6Gkv7lk=;
 b=jls8fAxhzOUaBedC/c5H8BULUgBNb7iDAdwP3LWY+5DhW707Pir4ZFgJ3E24ReI015H3gaw8gZvIiLAyKa0N3ps0aiR8p6ac+od2wPZhxACKZFwxXi8nXbYh4Nq1cJpGObnXKwMD7j/NITCk3S+Y0U/5TqiSjd31SY8oqNYhXZw=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1664.namprd15.prod.outlook.com (10.175.141.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Tue, 1 Oct 2019 21:14:16 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.022; Tue, 1 Oct 2019
 21:14:16 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 4/6] libbpf: add BPF_CORE_READ/BPF_CORE_READ_INTO
 helpers
Thread-Topic: [PATCH bpf-next 4/6] libbpf: add
 BPF_CORE_READ/BPF_CORE_READ_INTO helpers
Thread-Index: AQHVd8E8o0MCCq60iESLB2q7s/R4LadGStmA
Date:   Tue, 1 Oct 2019 21:14:15 +0000
Message-ID: <346DCE18-FA64-40CA-86BD-C095935AC089@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-5-andriin@fb.com>
In-Reply-To: <20190930185855.4115372-5-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:7bc9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af80e68e-d04d-4ff8-eaa5-08d746b4510a
x-ms-traffictypediagnostic: MWHPR15MB1664:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1664A00E36740C2214A0540EB39D0@MWHPR15MB1664.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39860400002)(376002)(366004)(346002)(199004)(189003)(6486002)(14444005)(6636002)(486006)(476003)(76176011)(11346002)(446003)(6436002)(6246003)(6862004)(6116002)(53546011)(256004)(46003)(4326008)(6506007)(229853002)(71200400001)(71190400001)(2616005)(8676002)(33656002)(81156014)(64756008)(99286004)(25786009)(86362001)(50226002)(8936002)(2906002)(37006003)(5660300002)(36756003)(6512007)(54906003)(7736002)(66476007)(66446008)(102836004)(66946007)(66556008)(186003)(305945005)(478600001)(81166006)(14454004)(76116006)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1664;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XdhH1frj0hd2W3Qx9scuz2ps+FbiOkDCUgdDGawduJvi5IOEwL/x5eNx6MaVVZxB3ogq/QR8RZL/76phRYJg0vkAcabuthIfF9EVKxDulYndJqunL/L84qUdnq243a0bP0oTD+v/ZZQ0dRTVcRh5X4EiOzJVExmbGpIoszfBDfFSKJRzlE2CcrO4Cx76HcBFp2iGrQkv4gafdO4yzXBYiRxJAM04c724PfL4UE98Y/h2u1hq7ZXsHTQTkjMvcc45LyYCAHs9yKvWXqItjOQ1Wg4Xbq+ZR6BhdNuSmkpyFekzyGIliMETkCAZOSuo+//736Gdv+jfT48kmRBOMZIQ7/yUwRbeQVKuRANCPmqdnRdIAwnWhDC8GcXw1FIpGMhSSNfFKWWLrbHs+THktU4ksihqLQmoXJYtpsADIyDu+Fw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FCECB1294D853547983ADC33F403B2FF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: af80e68e-d04d-4ff8-eaa5-08d746b4510a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2019 21:14:15.8854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0cBhJIYz4CsTgI4HACfkJwU9yRFpHTzXgQL3rLFGN7ctJCLmXOB6mXTO3i7y93D4llfgCojqPRha0NxOwtX23Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1664
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-01_09:2019-10-01,2019-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 spamscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910010176
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Sep 30, 2019, at 11:58 AM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Add few macros simplifying BCC-like multi-level probe reads, while also
> emitting CO-RE relocations for each read.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
> tools/lib/bpf/bpf_helpers.h | 151 +++++++++++++++++++++++++++++++++++-
> 1 file changed, 147 insertions(+), 4 deletions(-)
>=20
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index a1d9b97b8e15..51e7b11d53e8 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -19,6 +19,10 @@
>  */
> #define SEC(NAME) __attribute__((section(NAME), used))
>=20
> +#ifndef __always_inline
> +#define __always_inline __attribute__((always_inline))
> +#endif
> +
> /* helper functions called from eBPF programs written in C */
> static void *(*bpf_map_lookup_elem)(void *map, const void *key) =3D
> 	(void *) BPF_FUNC_map_lookup_elem;
> @@ -505,7 +509,7 @@ struct pt_regs;
> #endif
>=20
> /*
> - * BPF_CORE_READ abstracts away bpf_probe_read() call and captures offse=
t
> + * bpf_core_read() abstracts away bpf_probe_read() call and captures fie=
ld
>  * relocation for source address using __builtin_preserve_access_index()
>  * built-in, provided by Clang.
>  *
> @@ -520,8 +524,147 @@ struct pt_regs;
>  * actual field offset, based on target kernel BTF type that matches orig=
inal
>  * (local) BTF, used to record relocation.
>  */
> -#define BPF_CORE_READ(dst, src)						\
> -	bpf_probe_read((dst), sizeof(*(src)),				\
> -		       __builtin_preserve_access_index(src))
> +#define bpf_core_read(dst, sz, src)					    \
> +	bpf_probe_read(dst, sz,						    \
> +		       (const void *)__builtin_preserve_access_index(src))
> +
> +/*
> + * bpf_core_read_str() is a thin wrapper around bpf_probe_read_str()
> + * additionally emitting BPF CO-RE field relocation for specified source
> + * argument.
> + */
> +#define bpf_core_read_str(dst, sz, src)					    \
> +	bpf_probe_read_str(dst, sz,					    \
> +			   (const void *)__builtin_preserve_access_index(src))
> +
> +#define ___concat(a, b) a ## b
> +#define ___apply(fn, n) ___concat(fn, n)
> +#define ___nth(_1, _2, _3, _4, _5, _6, _7, _8, _9, _10, __11, N, ...) N

We are adding many marcos with simple names: ___apply(), ___nth. So I worry
they may conflict with macro definitions from other libraries. Shall we hid=
e
them in .c files or prefix/postfix them with _libbpf or something?

Thanks,
Song

