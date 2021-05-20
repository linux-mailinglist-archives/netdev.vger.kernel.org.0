Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AC838B927
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 23:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhETVsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 17:48:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25362 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230343AbhETVsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 17:48:35 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14KLY0uL006346;
        Thu, 20 May 2021 14:46:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=z6PcDwod4PDMdlhheGDlJbYaeMwSliXVnfyWPPyVrU0=;
 b=adPeNp42IBppOI6hR3ONIT3BuiSyUOqZRi7DXrWBhv6LPmedJO/25vlNX8/9Erv5yNBo
 YktBUM30M4sxLWVKmJz8T4+ZkZ+zD7FIJHVUg3odrm6Ukr6UIfzKifkBUGR/DWTC+Mkh
 nHuuQfAVQByhv6MUOL6YwK6G7oKu6Fj99uI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38n6p30ub5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 May 2021 14:46:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 14:46:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=od/Sk7mxPepH91sjJi03Y7bR17HTMG48akdXlzt7c0HbFaMwy1HM2HR7B0F5AHJY+O5R558dG4q3rteodG7iA0WYs21uu70I6UqKzWnGmUtGe4/LWNgq2zlTHVCGw9f0xjM53c9CLd+gWkzi07GwSiCgdK/zfblEI8KMHzrp6Xhco7rY+qI0MKcIBy4Ep8vUozBj5Ygbp+91OfXuA+Dwa8I/EIMJiWSFuMUchXvqqxsmS3spsLBERGY/ZVDrB+tb1vpXi7ejsvZvHROZvGQe6gb8I3qnE9wx1wkisK0Nk1q7Uof6P5j1ZwFpSj9SVE5eaiFm46O+ABWmPfo+eV0TyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6PcDwod4PDMdlhheGDlJbYaeMwSliXVnfyWPPyVrU0=;
 b=h+H2rVqL2Zvvw+ZqvETxVD1tT/XEQ8uIlG4ZSJ4d27Kz9xpkV0iy24AbH81RnAK6n1lAYQ/I4eMVj01RPvJGJCd/CWNzwirGdvSW2ILOXRegPglzG/k1r5n0VsBldX7U+CGKOAQNEh7a975GDGwC2o9yQK77NboM5Zmli/PuTdRHjBxuPf7Bw4+1E662XqACdzo5JU7VsfxmZNZTac2PCFI9z3/TSU1ysZPX9tfCDrFtf2V9SY02JyF3DD2L+wSAETj3PKFQenZf7HsP3TCVnp/9PzK7OQzyrz2M3whJOqbSQGrViZhJJEnj6E2vK4YCjZQXsageeG7ixncgwWtwCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3256.namprd15.prod.outlook.com (2603:10b6:a03:10f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 20 May
 2021 21:46:47 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 21:46:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
Subject: Re: [PATCH 01/23] io_uring: shuffle rarely used ctx fields
Thread-Topic: [PATCH 01/23] io_uring: shuffle rarely used ctx fields
Thread-Index: AQHXTLk17dWezJtB9kirPhycVh7qbKrs6dAA
Date:   Thu, 20 May 2021 21:46:47 +0000
Message-ID: <0339DB35-27AC-4A50-B807-968C72ABB698@fb.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
 <485abb65cf032f4ddf13dcc0bd60e5475638efc2.1621424513.git.asml.silence@gmail.com>
In-Reply-To: <485abb65cf032f4ddf13dcc0bd60e5475638efc2.1621424513.git.asml.silence@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.80.0.2.43)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:fa93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff54c24f-fba8-4010-018b-08d91bd8c4ae
x-ms-traffictypediagnostic: BYAPR15MB3256:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB32565F979973DF008C09CFCBB32A9@BYAPR15MB3256.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:449;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qMTNp2qDnLAwy6LnyjbHTqSjhfFGj5jca17fYWf7GxuF9FHZnr3x+XgwDy3yJJKXw49Rsrfdm2VJEOQpgDjjKI4lUZTcHi+2L8H/VFJNqc3WxqrOpRrbEfdpG/tptjWNflXAHMidTq6rral3IPrYKVBkAnMywLi/t4a4I1rx5IDRkKvuINeG7kirWtWPLq0YVyapTCH2ID56h1PUm49YOrwYqJpwXttgFpIQaHpNnzBbOCOkz1W6FnZUnzo7hsGHS3whWWQXXcC3ZTCKsYgmWT8V/4t6zyUjkcCFzrldxQzFnju0CupM9+63ti1WO9BqTKHEu/00S5e5E5MiugdbE051w+ecc8xjwHlwwg+/CoObxDAgtviFW//kLOygVlXRZh8XBVJFOIbu2IkItIvNgMvOFjTuO7q/PHEyYm9N9jhcZAEqJnCMGPf5YHicenSI0MxQyYLH/pWkaDeb1/KyLS87pAk4TtJjCcz0okxkOSa7MtVg6cZZO73CkF4nAhSJBMidusVLIr8n6Eq0taQbAesIWlUms4XbsHniObx9FuXlYnhnxUJ1hJtLlCue9ctIdIw8SoF9/3p3q82tAGwMFZS54lT438bRWpgwynRoVhuNz8rDtspsJnbY0SblBqGQ8zDHTD5ts8TERH2w19ix/zM/rw0c06cuqgufrMLuwPc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(66556008)(64756008)(66476007)(66446008)(66946007)(478600001)(186003)(91956017)(4326008)(316002)(6486002)(5660300002)(6506007)(53546011)(76116006)(6512007)(6916009)(54906003)(2906002)(38100700002)(122000001)(33656002)(83380400001)(36756003)(86362001)(7416002)(8936002)(8676002)(71200400001)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?UUBot7YMNVFYGsw3/POxiyR9z6GIoScv3Wz8FuHafXTc1UNar0fYgXOS0lIm?=
 =?us-ascii?Q?ybX/o4rXWoiJz73CCnoh/yoqO+eLYeXtNahnA2PIUUF3cNBkBHqZcQ+vMNQt?=
 =?us-ascii?Q?Tu7MRlUG2c9A+C2DMOE0FcOX5hUOYpkpZNccVgWcohaT7eZv+9Tojteo2hqB?=
 =?us-ascii?Q?MCQ+rfGR/HykCx/ooXxkOSxq+1fN6dICDL/nrNEwNbd1k4blZTGCqq2a5lpX?=
 =?us-ascii?Q?wKc41ly9vYKa3KKmSfvrxN/EPz8/KlvIb+N9jTIAiOGKcLqMg3p0O8Bao3/h?=
 =?us-ascii?Q?1TIwrGqrTmazzAgii7og7UKGd5ToX6KRVqS6DhWjAW012vpmUuZ4E0BQZwjB?=
 =?us-ascii?Q?T4aIOwyU0zFvRpiUuY2Whg5MGPQd0vqmPBS/PmcDptvKF4PwOCeL7r1l5uRW?=
 =?us-ascii?Q?nGX2dTXaWj7x/NrL/Qg1Wto+ve0SULbZkPSQMOyHv2UHobf6ZZFt9a3985RS?=
 =?us-ascii?Q?5QD1TWHzNYYd3TxdSAGrInNhaWnJskOc+QLCutLd4gD8fJ4YWkuSNJ5jEnaH?=
 =?us-ascii?Q?0Dy1jeI8654DBDVCoXwBtNPWFalInQzprRAUo1LVPN3SPqOKaH0CdY6EImRB?=
 =?us-ascii?Q?f4VXmJePRlQeXTYzsd8hgqivOgoz94DFAXE7wKFZMLcUGqT6QBhr72EP8c5y?=
 =?us-ascii?Q?9wvnbNaYLGZ85kXy0hnXytF/z0xh/tJAGX7XLW3akzJJ0T/qH5cNnESqTi6/?=
 =?us-ascii?Q?l27auUA9LL2N6g2k5tI9TCwUrjh26UoIwlN1QHzCaLfckZ2kgKjIkPmBi75y?=
 =?us-ascii?Q?Z098/TcLYpcrNogrXZTmIV6S31bYwTS+1ybhluYIwtOgJX/lJNTuRoXk8r+p?=
 =?us-ascii?Q?7wQ7+nzf5YINFxSewBNBdP46iRl0bzyomtg8YxFjJiQUjXuYYaAcW8ELi/SY?=
 =?us-ascii?Q?0VvE4lImdunX/REoth+Aw/9wAW2dxXU/KIQeJD8or2zwVNi18AkGOZjjuge8?=
 =?us-ascii?Q?HM6QMO3Bkf3vzrRLkgDB+D0vE4blWjuySRyJgXFMFhWojeAJlEzcHO4piEeY?=
 =?us-ascii?Q?T8iHI0g6zSI/TZKAd9osRtUUOpiEMdq/rIlm/M+mELzXucRGDp/Wdlv+BBZj?=
 =?us-ascii?Q?XKD8cZ6x0btKnJSMq1g7CwtmZ/UXUYibluJXJln3Q4i2pA+k55gS6+Dhw3a2?=
 =?us-ascii?Q?eJtXpB8TMgL49LFCSZLX91XdV6mH51D7TMj53pzHC8U/6Ztk2cBGUwg6F0fc?=
 =?us-ascii?Q?v2kPhU7uiwhROyHHB2edzBMaeoOePX3jR+blJG16boUyFYVdOsv42Sf5u2aC?=
 =?us-ascii?Q?WG7P+7agGSFg+dKkZn0FVVvdp1Q/L/47enFRA9n2muJ5X5MYPlLMobUkIxTJ?=
 =?us-ascii?Q?kuZemWuJ8X4CUuTRN9xxOGfTelZPKugRJd+U27Qs34suPCYRZsYQ6cHw73+y?=
 =?us-ascii?Q?cBrBE/0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25B8C0346FCD994E878FBEE605F3887C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff54c24f-fba8-4010-018b-08d91bd8c4ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 21:46:47.4480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N19MRrij0jZlLjTltfObV+N1kMIoxVI8zymyqQuuzwvbb4ZyEKcOIJ5xmt8h6fuArzgz6Eag1lcLsf+uCYO5ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3256
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: IV8N-7d_jP2-O8BIySZAfN3M2q_xDKRm
X-Proofpoint-GUID: IV8N-7d_jP2-O8BIySZAfN3M2q_xDKRm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-20_06:2021-05-20,2021-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 suspectscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105200136
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 19, 2021, at 7:13 AM, Pavel Begunkov <asml.silence@gmail.com> wrot=
e:
>=20
> There is a bunch of scattered around ctx fields that are almost never
> used, e.g. only on ring exit, plunge them to the end, better locality,
> better aesthetically.
>=20
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> fs/io_uring.c | 36 +++++++++++++++++-------------------
> 1 file changed, 17 insertions(+), 19 deletions(-)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 9ac5e278a91e..7e3410ce100a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -367,9 +367,6 @@ struct io_ring_ctx {
> 		unsigned		cached_cq_overflow;
> 		unsigned long		sq_check_overflow;
>=20
> -		/* hashed buffered write serialization */
> -		struct io_wq_hash	*hash_map;
> -
> 		struct list_head	defer_list;
> 		struct list_head	timeout_list;
> 		struct list_head	cq_overflow_list;
> @@ -386,9 +383,6 @@ struct io_ring_ctx {
>=20
> 	struct io_rings	*rings;
>=20
> -	/* Only used for accounting purposes */
> -	struct mm_struct	*mm_account;
> -
> 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
> 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
>=20
> @@ -409,14 +403,6 @@ struct io_ring_ctx {
> 	unsigned		nr_user_bufs;
> 	struct io_mapped_ubuf	**user_bufs;
>=20
> -	struct user_struct	*user;
> -
> -	struct completion	ref_comp;
> -
> -#if defined(CONFIG_UNIX)
> -	struct socket		*ring_sock;
> -#endif
> -
> 	struct xarray		io_buffers;
>=20
> 	struct xarray		personalities;
> @@ -460,12 +446,24 @@ struct io_ring_ctx {
>=20
> 	struct io_restriction		restrictions;
>=20
> -	/* exit task_work */
> -	struct callback_head		*exit_task_work;
> -
> 	/* Keep this last, we don't need it for the fast path */
> -	struct work_struct		exit_work;
> -	struct list_head		tctx_list;
> +	struct {

Why do we need an anonymous struct here? For cache line alignment?
Do we need ____cacheline_aligned_in_smp?

> +		#if defined(CONFIG_UNIX)
> +			struct socket		*ring_sock;
> +		#endif
> +		/* hashed buffered write serialization */
> +		struct io_wq_hash		*hash_map;
> +
> +		/* Only used for accounting purposes */
> +		struct user_struct		*user;
> +		struct mm_struct		*mm_account;
> +
> +		/* ctx exit and cancelation */
> +		struct callback_head		*exit_task_work;
> +		struct work_struct		exit_work;
> +		struct list_head		tctx_list;
> +		struct completion		ref_comp;
> +	};
> };
>=20
> struct io_uring_task {
> --=20
> 2.31.1
>=20

