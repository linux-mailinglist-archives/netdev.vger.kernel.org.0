Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E754138BAB2
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 02:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbhEUAIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 20:08:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29972 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234612AbhEUAIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 20:08:47 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14L02dWG019010;
        Thu, 20 May 2021 17:07:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kfcj/exENQRVZ1uZZI7HYwVHaOIvCDPNg7ps0Yorays=;
 b=bXDhKwNwM2wrY/e702kuaxVug2g0gC0eZBTvRdFzcde9NBjvIjqyXg0Ndb5yEcsQJVGt
 sAWYKUMYwz11hWe6yZm7zakmjEd4fDE/BGQaxliCsJZ6trmXuaeFExWtwNqr/EekJqKN
 GDCTMJBtlcXdQfPoO9aV1ryUY7d+MQ1RWUc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38n979rkq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 May 2021 17:07:02 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 17:07:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=beXYi3vbjSBhcxGkBEsff1+GLl1nT1SEj1DgHxjDS5Nbyp3RDiPr+/tXgkav0ws8QcbMFSOqaSC6vmWRymQzQpPdD6naHKtctwce80KCuw6iqqtgEnWfyJVUbtKPsgMSMhyHk7XBbpWG+8z54/FCK7G+YI98qOkkyB/MXqwzOZasp6ZntU/B94VeD5IxxXTdthytPN5TZ9KgtJaIXUv9DZWYM93ViEHiW42rTcD+SzOQYu1lAtozqAnA+6OMA8qPG5uFRmR/dBl3leMFNkYe20jLXXHL4HJBrUAvUAEDYMeV9K4+BlawbWJhODoI5ygyiX2da+ek9fQSDpx8yGfVWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfcj/exENQRVZ1uZZI7HYwVHaOIvCDPNg7ps0Yorays=;
 b=ZiEFZYbbUdvbjh9aVhIv5lIIMjhCD0gb43nIhSc8D8I0P+bvgIlAu7XfeV0nEF3au/kcbx0Wrygd1SvYnLGZ1WV6cnUZ6PX0iXN/MZnaHig9NWtEe//+C9Q8lmBfzYwvFE8JfjDXxGz22MI2O330gkLLwBG0wDp6ukAYMB6fkFYdL0kAV7032rmDQMKUdrCIY9uPmg2iai91b2Fe31K73LmXWiSvtPTmbcYDUftus0MSdq0F3NfDycptTrdMIAB03x5P1iannrPrTqSTnkVqU5plHwV08w+2CMX0ywn+giahGXKDw39mjvMQHrZGtkEfScOOmFxc7eO1Jeeuo4GCUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2886.namprd15.prod.outlook.com (2603:10b6:a03:f7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 00:06:59 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4129.033; Fri, 21 May 2021
 00:06:59 +0000
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
Subject: Re: [PATCH 15/23] io_uring: enable BPF to submit SQEs
Thread-Topic: [PATCH 15/23] io_uring: enable BPF to submit SQEs
Thread-Index: AQHXTLmA+z0jtjqTr0CEF/EO+2xSZ6rtEPsA
Date:   Fri, 21 May 2021 00:06:59 +0000
Message-ID: <71AABD2E-3B7F-4869-B909-D84C612FA18D@fb.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
 <8ec8373d406d1fcb41719e641799dcc5c0455db3.1621424513.git.asml.silence@gmail.com>
In-Reply-To: <8ec8373d406d1fcb41719e641799dcc5c0455db3.1621424513.git.asml.silence@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.80.0.2.43)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:fa93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e78fcd02-b3d7-4265-f292-08d91bec5a97
x-ms-traffictypediagnostic: BYAPR15MB2886:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2886C738A705E07E903DA356B3299@BYAPR15MB2886.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SpnLg33B3YSNmTNSkbhPNhBMI8bMD02XcQ2VaQeXuGejLOEbCuUCUQA3ckjQ9dM/zqoSljODaACRppkhaOC85KnCjBr1zcibqPwJ9khIv/o8xIMxfiV8JQrYvez4doIniq8nPyrDbxbUqhGl82/bfDxDiK2JZu5gH+KgUWTxPG/QvooPTfkRWWCzhRfGnEtlF5UnHr1hiKpPPf9VdjCUbi2KsqEuTOB+J0u/nXnyAaIxNpyhtADcjTLuCIbNJihZPfJxP2mOx0PKONDVlUgCPWalsIzxxUNSWaNVi73aLaT5x0my0OYJo4vZv5jIUrE/1w9zOcqFSabpgOIjxulwJU8BqySslStLrfDOUKOi+Fz79g5ZeuOOeBmMm5imlVue5ZsPBl+AuYbnwjusHg+zIykxFQRjw4ZuqxQaOpQ4K3dc9HY6o/sUenZ2onoleJNrLNvwBdJmM0LGP3r9gKc80O2ZAOgiiiTbRzSiYL8xBKZDD7I3KXT62kWpFSW+tZ+rskRs6/BDwRbI04BREINyuGp1z8q/lFdzPXJcqH/wFZ2CvsexR3RfOCUtkgfqpF60ZzH8gr3s0EdDmAbdnTKTdBT98k7Np4JkaUYqgv1lKFDXQ5nX9OQ36fpAPEzLxI5BoF+Eo20ppBuNxY4chuFnNQuNWhkK1UOKZwfm7Eo7hS0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(86362001)(71200400001)(2616005)(316002)(38100700002)(478600001)(5660300002)(4326008)(36756003)(6512007)(33656002)(64756008)(6916009)(8936002)(8676002)(2906002)(6506007)(76116006)(91956017)(53546011)(186003)(54906003)(83380400001)(66946007)(122000001)(66446008)(6486002)(66556008)(66476007)(7416002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?L9KcPa06R3ZLLNnkXp72ygPBUlofWFWd8kcJBH2ElByMt+KsvvilwmVJmyh3?=
 =?us-ascii?Q?tndS9T/yBNcoNoRq2ux9AZFeXD7EfT1svfhMMpxZSiu/+3kVQda7srehpu80?=
 =?us-ascii?Q?Kwl7cXlHeGsK8W3nY0d74ibRegvLDTcu+MCqctiIPM3e08A8bqLc7Ldv5b2E?=
 =?us-ascii?Q?dHpJK0DrYqps9sqtZRlwQnBvT7+OaQS9nYbqhi0lc1YLN6jDa3aiwxkinFLT?=
 =?us-ascii?Q?/6qzuaPClLPiFvxDXr24naevY+pFfK1kFbgFik85gyfJJmVV/ntIDSegl+XL?=
 =?us-ascii?Q?ki2BZ3QaUez0CUusuE9mYRA+CZwRt6P+xVL6jXm0WUV7nWd2796+M6lqNmU2?=
 =?us-ascii?Q?Gr0vEjQvpadwng/NoHqmLz2IDcaC3S+Kw+TyrC/06Z6kj2vODCnWwkYYEKpT?=
 =?us-ascii?Q?shMna+IFickjjMy1gatr+u/DekfumD48H3n5fEFmdW5k0Bz2bz11LpuTEo1E?=
 =?us-ascii?Q?BjNA0M7uGDXoActMpDD0mpGTSWhmsDfqAJ8+66+zImmtni/hUY3FkuPrfB48?=
 =?us-ascii?Q?T/jzwSu3Veim0Ev82zxEM83V5MLUGXYSC+XXJ5r3Dqm217Pkqkvu7RUTZ/k4?=
 =?us-ascii?Q?49duZexctd9vSpgovaBE/5GGgAxdxZjOk9TVyo+0jxTPSiHo/S6t7pUdIr8Z?=
 =?us-ascii?Q?FWMiuLLFXJFu5xrEcKCNwEIztoviiz9CcguwYR/AE8Qz3jIjd9JjRsxq+95t?=
 =?us-ascii?Q?IOMwvrV5qCJK5Pmm5AFFwGwt8d4Ync8AEhM4bcJdp5ruIDtiQdon+3KNQ/XI?=
 =?us-ascii?Q?mB+xlp+D3d23vVVhbzAHVHMv6AjZZpn9ofm8ywGlzVWGy4/idLikhfJTfYIn?=
 =?us-ascii?Q?Uo+1sD/o2BqzjyXpWyjKGZeorf6tpiDS6Z1tpbT+XAu1RyCd8Fu/4ioIvJJP?=
 =?us-ascii?Q?bum9JmAJJede+ui2Ehr5YrilJF6FBws855MlmWFHuFoNT8tKnYIRV4uMzJtZ?=
 =?us-ascii?Q?G3kEZDdDkO39yIur265HNtPqrEqfB3D6riEUGk2A8Gt+pYESd9oNwJaiGLDj?=
 =?us-ascii?Q?Xmwe3tZBmAtb049b1rCQ8hVJB+frGIB2x6EqZP8GrBGY4mMY2cAlf7wTZDk4?=
 =?us-ascii?Q?+TQzUxfRjmGSwqApW3BPU0SpLcNRq0FkbxYbn+loPVn91arYy5idQ373TZbL?=
 =?us-ascii?Q?LL9nUqoPqo+SWo0d8lgAB61SfWd6BYLQ1i+r5B2SyKUwGvj/OqaXTkPTaknv?=
 =?us-ascii?Q?CYZQlK0tbdgmnLmgncixJD2U7/lYbdSNQ80vYzq/reBKxjLVpTiIy+gqmMsf?=
 =?us-ascii?Q?wWOcVH0di8saFKTWDudhlhfVFDyWy8xEAjLAzNJ4yw6JXfQ+1cmt9OnZAskD?=
 =?us-ascii?Q?jHvk9yuWfcGs+VYfEBXL1izRp9bpYUmBO/kVvgqFw9ISvBsKvpF9imzeP0pt?=
 =?us-ascii?Q?xTkF6MQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E11A3818F8FF5D4489EB042CA6AA7A09@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e78fcd02-b3d7-4265-f292-08d91bec5a97
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2021 00:06:59.5325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GXufTvDNjGbpz4+y6l9/BWev/PQigiwNyjAkmZlBhC9dwDwlOEBL7qp6Dtl8y0rR7RVPM0u8l0xU5gvJjk8+Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2886
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: xgZuqUN_gi7rQ2erfqGiqQb7GibUkgh2
X-Proofpoint-GUID: xgZuqUN_gi7rQ2erfqGiqQb7GibUkgh2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-20_07:2021-05-20,2021-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200157
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 19, 2021, at 7:13 AM, Pavel Begunkov <asml.silence@gmail.com> wrot=
e:
>=20
> Add a BPF_FUNC_iouring_queue_sqe BPF function as a demonstration of
> submmiting a new request by a BPF request.
>=20
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> fs/io_uring.c            | 51 ++++++++++++++++++++++++++++++++++++----
> include/uapi/linux/bpf.h |  1 +
> 2 files changed, 48 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 20fddc5945f2..aae786291c57 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -882,6 +882,7 @@ struct io_defer_entry {
> };
>=20
> struct io_bpf_ctx {
> +	struct io_ring_ctx	*ctx;
> };
>=20
> struct io_op_def {
> @@ -6681,7 +6682,8 @@ static int io_init_req(struct io_ring_ctx *ctx, str=
uct io_kiocb *req,
> 			ret =3D -EBADF;
> 	}
>=20
> -	state->ios_left--;
> +	if (state->ios_left > 1)
> +		state->ios_left--;
> 	return ret;
> }
>=20
> @@ -10345,10 +10347,50 @@ static int __io_uring_register(struct io_ring_c=
tx *ctx, unsigned opcode,
> 	return ret;
> }
>=20
> +BPF_CALL_3(io_bpf_queue_sqe, struct io_bpf_ctx *,		bpf_ctx,
> +			     const struct io_uring_sqe *,	sqe,
> +			     u32,				sqe_len)
> +{
> +	struct io_ring_ctx *ctx =3D bpf_ctx->ctx;
> +	struct io_kiocb *req;
> +
> +	if (sqe_len !=3D sizeof(struct io_uring_sqe))
> +		return -EINVAL;
> +
> +	req =3D io_alloc_req(ctx);
> +	if (unlikely(!req))
> +		return -ENOMEM;
> +	if (!percpu_ref_tryget_many(&ctx->refs, 1)) {
> +		kmem_cache_free(req_cachep, req);
> +		return -EAGAIN;
> +	}
> +	percpu_counter_add(&current->io_uring->inflight, 1);
> +	refcount_add(1, &current->usage);
> +
> +	/* returns number of submitted SQEs or an error */
> +	return !io_submit_sqe(ctx, req, sqe);
> +}
> +
> +const struct bpf_func_proto io_bpf_queue_sqe_proto =3D {
> +	.func =3D io_bpf_queue_sqe,
> +	.gpl_only =3D false,
> +	.ret_type =3D RET_INTEGER,
> +	.arg1_type =3D ARG_PTR_TO_CTX,
> +	.arg2_type =3D ARG_PTR_TO_MEM,
> +	.arg3_type =3D ARG_CONST_SIZE,
> +};
> +
> static const struct bpf_func_proto *
> io_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> {
> -	return bpf_base_func_proto(func_id);
> +	switch (func_id) {
> +	case BPF_FUNC_copy_from_user:
> +		return prog->aux->sleepable ? &bpf_copy_from_user_proto : NULL;
> +	case BPF_FUNC_iouring_queue_sqe:
> +		return prog->aux->sleepable ? &io_bpf_queue_sqe_proto : NULL;
> +	default:
> +		return bpf_base_func_proto(func_id);
> +	}
> }
>=20
> static bool io_bpf_is_valid_access(int off, int size,
> @@ -10379,9 +10421,10 @@ static void io_bpf_run(struct io_kiocb *req, uns=
igned int issue_flags)
> 		     atomic_read(&req->task->io_uring->in_idle)))
> 		goto done;
>=20
> -	memset(&bpf_ctx, 0, sizeof(bpf_ctx));
> +	bpf_ctx.ctx =3D ctx;
> 	prog =3D req->bpf.prog;
>=20
> +	io_submit_state_start(&ctx->submit_state, 1);
> 	if (prog->aux->sleepable) {
> 		rcu_read_lock();
> 		bpf_prog_run_pin_on_cpu(req->bpf.prog, &bpf_ctx);
> @@ -10389,7 +10432,7 @@ static void io_bpf_run(struct io_kiocb *req, unsi=
gned int issue_flags)
> 	} else {
> 		bpf_prog_run_pin_on_cpu(req->bpf.prog, &bpf_ctx);
> 	}
> -
> +	io_submit_state_end(&ctx->submit_state, ctx);
> 	ret =3D 0;
> done:
> 	__io_req_complete(req, issue_flags, ret, 0);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index de544f0fbeef..cc268f749a7d 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4082,6 +4082,7 @@ union bpf_attr {
> 	FN(ima_inode_hash),		\
> 	FN(sock_from_file),		\
> 	FN(check_mtu),			\
> +	FN(iouring_queue_sqe),		\

We need to describe this function in the comment above, just like 20/23 doe=
s.=20

> 	/* */
>=20
> /* integer value in 'imm' field of BPF_CALL instruction selects which hel=
per
> --=20
> 2.31.1
>=20

