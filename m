Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936B63EF015
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 18:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhHQQTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 12:19:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60256 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230162AbhHQQTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 12:19:03 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17HGFRee000684;
        Tue, 17 Aug 2021 09:18:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=at2TS/GRw6y2ggc6UbmL9amlQmodVAi3y58GjBD2v38=;
 b=MAZMc70np4xJ1niLvM9+1Vjmb1Zcj2iJtJbD9UoXMhtFvu49XbBFLrV+6n1bVno5hJMS
 PshIup2XS5gb6lME9URCuNvo5FNyVmrN7k+73cgcb+Bu91W6QkMqnVuhrATK03I6vHGm
 y1JSA2v8YN1tFVz7H57TE6eqMzWAAV7XhoM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3aftmjqg16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Aug 2021 09:18:14 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 17 Aug 2021 09:18:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mE0mnTDGm7HFZYSqmYw1fODYKeTp2/Zk+JR16AT66tP9DVeidHbK4PShpt8srHOxydOZllk6jTP4PpDxqUN1ZTnq4bhAOP8rkGhrIloUmGIKKqLH45KOX+QueLhyYoMFFdgTq/ouX+am5P/8eXk3q1IV+OkApRi1TPHE6nMfzU1orgTa6/ckmh1IBAQav5c5YTFdAgnm3wB2dkGjNBcs3e5YyihAqHskicWRpCCJVaMd/m98baivJ3ilR9/9eqRbqKp2SPZs+hXFGNjB0DBTU88aVmLDcMQp0+/H6n1ScvNHw9EKZHcq2a+RDkE8yjr5aR4WsqlovTkgA0hzh2L3fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=at2TS/GRw6y2ggc6UbmL9amlQmodVAi3y58GjBD2v38=;
 b=l7hf92YCk6PFFRuUqz6uvp9wf8BW4qHZcza4L7TEgXI5K5h4ST3fIjxQq/Te166pRImU6DWLJTKgbrSopR3bTMHOsUIglh5grmYBWOMddrjDZVWMf1dDRMyalpOwlZ3xCoStnd+GMqiNTQl8UdNw1YY48/ZV/q3nbzI2oyi5EKFjTiUVimY8RjV8u9ZgS/4lMynjBjrgtM0EyKrCwZTrWU70pPDLu37fF04V/LE2hvEnE0yMmc6IzOG+nosjFIlf7E2AruZ4HkoficMGr0URtP1xaELuh+J3towyiQmMe4vetFk40dA6W9Vb9/kVGbEgjgxO8b6QZlpiUk7CprtlQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 16:18:11 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1959:3036:1185:a610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1959:3036:1185:a610%4]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 16:18:11 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Xu Liu <liuxu623@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SOCK_OPS
Thread-Topic: [PATCH] bpf: Allow bpf_get_netns_cookie in
 BPF_PROG_TYPE_SOCK_OPS
Thread-Index: AQHXkoypynyJL9aEeUureyT0dFGeO6t2tYQA
Date:   Tue, 17 Aug 2021 16:18:11 +0000
Message-ID: <16DA85DF-84F7-40EB-B674-CDB07DEB4133@fb.com>
References: <20210816105114.34781-1-liuxu623@gmail.com>
In-Reply-To: <20210816105114.34781-1-liuxu623@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ca20c93-cd29-4901-7e11-08d9619a9bf0
x-ms-traffictypediagnostic: SA1PR15MB5109:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB5109512301A0AB2BFCF6DCC6B3FE9@SA1PR15MB5109.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yOmrv4lFMPYXuJNUyoctXOykrWia6cvhOx8qOem9UrOv4Zgfi2nIP7O/tdLQjxSf+G5l5aNswTGUf9czTnG7xH1NEP18w8pKz3UezwORChjC4WTgXf6+xf7AeADevBcXMXw4DgAEUHMTlTJmSkyEYCsMgjTrz+rofBe77E7LXtJXcl9IQrzYSEgvBonM8IcX+3HQ/N1o03fBe+Pe6bq49ztrQdsRdEcB0pME2avv3I1pvDky/+MdOS5JH31cwDQkDNEW3UyUy8Au+9Zj4mr+msenIMWjAYLvFxLeLjzeySY6s9UQq18wlyA+vj3TrMrefErTTAfGSaa0htTsDjEnsHcbIFf7DvCkhGcIUXO0Tt94PdUbuEx1xLpGCLPbxFv2zDJFsnkCnOebmQfTjyuqOiqnCa5vRAamzdjoJgIr34jmnEGKdwkqQtjgLkOWQBWf/7VbozvXXcsq7R11N1PLKlcTKT2YRFajzy1SIFgoJEE2+/uKHNIYvHXl3f6XdnDgnF87DPvYk5yIPj6QMtPXOKbpemoLTUktF8sa+fsgD1DEcJY50U4ZovHaQsg0XVL9hi2gzd/IsjeSnCfAQk/KF5dQLhEmJFNaaB1cg6LIoinmhSW2fgHiOP9Jn+jBgpD3bTn9WppxrErn7mzoyBI3+3WMYSEF4BbIqbdXRLwttnJhGBjyXTaxm/HroZrgsoW6a9/5O01MZbTB7odOCChjpnqIFTHkj7BnSwaxX6HrKYs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(4326008)(2616005)(71200400001)(66556008)(66476007)(76116006)(91956017)(66946007)(186003)(66446008)(64756008)(316002)(36756003)(8936002)(6486002)(6506007)(53546011)(478600001)(8676002)(2906002)(83380400001)(7416002)(6916009)(6512007)(86362001)(38070700005)(33656002)(54906003)(38100700002)(122000001)(5660300002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kD1UghN+RBJUZwaJsDyo1hk0Qx6nl0ZVZXWYcAxShU441x3UBkhLy4Prrnfc?=
 =?us-ascii?Q?tMPyqUh2BFOivxJLP8oEdRpHnQX45tN4i1cDvD3Mq0RUP7h0h1G4ge3U93OK?=
 =?us-ascii?Q?xnEyjog0N9LDqiH1IVCZHl5c4pGZ+cxp+TEvul6PRRdcqWWxh/94FVD9YUam?=
 =?us-ascii?Q?x7C8YMPuEMVx8qHapXywuGIPCDWm6sc8D8DZaFo3D2p03YrgzDImVh14eypl?=
 =?us-ascii?Q?u/tW1VoDLtLEfcDJTA6MYuEXhX/LOPZXdX8vXMieFUjx+8h74gOxSU0EWiIA?=
 =?us-ascii?Q?ZBKOlWMSUg+HQU/NybK5lsTrznZkTYEuPW+yjT+8DJWw+uX8xkZC1D/RcZ+8?=
 =?us-ascii?Q?gRIfK0Whwb/800Fqaky5MXeR8gOUxQ9pZyu5e4HWba4corshnKoohj8+NRQZ?=
 =?us-ascii?Q?G0tF7lwRWoHnrdaPz6orbsaTM96zkj+PFjeeEhFs+0d98GV65sSKTtD/ZiqV?=
 =?us-ascii?Q?/TZesY7c1J89Mnmd/T1if/FI9UTy7nNodIuzC7fPcIgQ5L76JlF41dAqAimg?=
 =?us-ascii?Q?sajlCN7pe/JBcq7xofxvKIGMqZmfYI/2TqjERci3SvOFKDxLpfuFUyT6Uor8?=
 =?us-ascii?Q?jJHTXgmNlUETtymwcCMa7Uv+GOGPbK4xzwDRZKx5WB6F+iiKh1Zw8843EScN?=
 =?us-ascii?Q?ktAVO1+oYFHXvwY2EYWhWXn3K5+P+Ye+nKkmbf5DxXifrtxnU5+tGfUUl587?=
 =?us-ascii?Q?YCHIzwvkf7vwdfWlj8aGpPHJ0HNgDHSGaoYWZcVGC7bymM0N66d1Q5tvqjNx?=
 =?us-ascii?Q?HDpe1gbHPLB4xwy09ZpbLZIInnc7hKJci5ShGYxRSaMkeN5uZGVdHAZS4wDp?=
 =?us-ascii?Q?ls/k6aZeO5RMCLaldF9gjAzMgrWRRlgp1W8jDgIxkcp1BdeyyoN/VW0T9o4y?=
 =?us-ascii?Q?6HNZe/VYaB+mX2+2DfdYageZffjBVfEmn9rcdUbl+xp2/Tbu7rRd4gEEG39S?=
 =?us-ascii?Q?Sz7H+eopKq9nPrtcUBe3iFsxVPWVkTL/UmmoieJTqw3lf5fxCbTVBKKwQpj8?=
 =?us-ascii?Q?hCTXJo7J2RcG+whxRuDuH4KmMKHVRB9hJa6bbtsefdVbRGkRrL6aH7KZwton?=
 =?us-ascii?Q?d9N8RSHYFa0y45K7YpjxgkaDGtIuRKL3wyNGR9jDZ8BrtYL9YU61McrLKDrO?=
 =?us-ascii?Q?X3i9H/LCzFoOVyyOXt6q5hbpn1fZcJCQBLP90y0SK9wSVo0nC8wg5WZGRAf+?=
 =?us-ascii?Q?JdA5cyesXMNoo5KA7hiHBQ20gZMFoTjTyJLmKdLL8nbilOTISMP3Bg4J+Q+a?=
 =?us-ascii?Q?NNLb6nVNpVVys371PV2yuEfASUKrU8HMJJPTU76uOkdvJfZayw1d1iZe7jMI?=
 =?us-ascii?Q?PbH1khDbU6XBXjrV79nn4L1l+jmz5AEsYEPx0oX6I2cxNNKBUczEHYNB3wht?=
 =?us-ascii?Q?zH3pFEM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9AADF234DB1FEE4E84C6722165322ADD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ca20c93-cd29-4901-7e11-08d9619a9bf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 16:18:11.7568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I5pM6O8xLPGjTXlA+PtopGaNIAtXBzdzxhi2dqq3H0ZbrL63lEQCxq0Bu+ERPoPEtkPzCvaeKCYxLxP3MPuYUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5109
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: vlRJ_WgsA4RhztDcT-HAVTc6tvGmS3Wo
X-Proofpoint-GUID: vlRJ_WgsA4RhztDcT-HAVTc6tvGmS3Wo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-17_05:2021-08-17,2021-08-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 clxscore=1011 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108170101
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xu,=20

> On Aug 16, 2021, at 3:51 AM, Xu Liu <liuxu623@gmail.com> wrote:
>=20
> We'd like to be able to identify netns from sockops hooks
> to accelerate local process communication form different netns.
>=20
> Signed-off-by: Xu Liu <liuxu623@gmail.com>

The change looks good to me. Some logistics issue:

1. Please prefix the subject based on target tree, like [PATCH bpf] or
   [PATCH bpf-next]. This change should target bpf-next. Also, please=20
   include v2 (or v3, v4...) when sending the revisions of the patch.=20
   So the next version of this change should be [PATCH bpf-next v2] or=20
   similar.=20

2. Please add a selftest (see tools/testing/selftests/bpf/) to exercise=20
   this function from sock_ops

Thanks,
Song


> ---
> net/core/filter.c | 14 ++++++++++++++
> 1 file changed, 14 insertions(+)
>=20
> diff --git a/net/core/filter.c b/net/core/filter.c
> index d70187ce851b..34938a537931 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4664,6 +4664,18 @@ static const struct bpf_func_proto bpf_get_netns_c=
ookie_sock_addr_proto =3D {
> 	.arg1_type	=3D ARG_PTR_TO_CTX_OR_NULL,
> };
>=20
> +BPF_CALL_1(bpf_get_netns_cookie_sock_ops, struct bpf_sock_ops_kern *, ct=
x)
> +{
> +	return __bpf_get_netns_cookie(ctx ? ctx->sk : NULL);
> +}
> +
> +static const struct bpf_func_proto bpf_get_netns_cookie_sock_ops_proto =
=3D {
> +	.func		=3D bpf_get_netns_cookie_sock_ops,
> +	.gpl_only	=3D false,
> +	.ret_type	=3D RET_INTEGER,
> +	.arg1_type	=3D ARG_PTR_TO_CTX_OR_NULL,
> +};
> +
> BPF_CALL_1(bpf_get_socket_uid, struct sk_buff *, skb)
> {
> 	struct sock *sk =3D sk_to_full_sk(skb->sk);
> @@ -7445,6 +7457,8 @@ sock_ops_func_proto(enum bpf_func_id func_id, const=
 struct bpf_prog *prog)
> 		return &bpf_sk_storage_get_proto;
> 	case BPF_FUNC_sk_storage_delete:
> 		return &bpf_sk_storage_delete_proto;
> +	case BPF_FUNC_get_netns_cookie:
> +		return &bpf_get_netns_cookie_sock_ops_proto;
> #ifdef CONFIG_INET
> 	case BPF_FUNC_load_hdr_opt:
> 		return &bpf_sock_ops_load_hdr_opt_proto;
> --=20
> 2.28.0
>=20

