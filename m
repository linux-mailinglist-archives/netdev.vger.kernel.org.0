Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D1D3814D5
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 03:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234498AbhEOBHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 21:07:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10632 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230092AbhEOBHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 21:07:52 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14F0pACE017780;
        Fri, 14 May 2021 18:06:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Imzbp9dYhQ9s6sEyD77MfP8lHcaJJSkUYeh1JsqDBC0=;
 b=e8/CElpvvuZ5K/Ls4Xz/OjoC6sgBFQKh6N6BieZSr7Flk4VGLRMsardeqEtd7QRpHFqy
 RwtjT/XChtQ8YBfcq9jDmpG1BF9gi5ZuCRi4zt+TKu04r+hKyZYA7xyoSe0SeJwiegGJ
 7iqrdYZXjZe8y1W0YK8wJbH+Ag8ypYPWses= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38hvbw2fr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 14 May 2021 18:06:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 18:06:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTfswh6Y0J6APPdViIC1Q6J3IhpOTs2IgUp28ODb49dFgECajJ3tbGLmCdqUCh03Y3N/kPvDwt+nyQkdAz4IOMFXOYMuMLPjm0zCnDzHMNmBQHTFw79VkjbVnfgDuzguubP7YkM1dVztykJOzYPt7YKdX2ApnS1Duve669GduM7aLi7RTWeE+sucZ/XGtbINU0PSKbZWpkmxg62QcohJ83sUSDdfx8g/0wdAk2tIIqhbqyly/vflNnq/FqgY30cly95kFABiwAUWVJADuKUb6/vWbaax+Jk4nw7s4yL1QrxV4zWGvVauhR21bFsRqVJe0uNhkiJBfI+Y1xABTjDYeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Imzbp9dYhQ9s6sEyD77MfP8lHcaJJSkUYeh1JsqDBC0=;
 b=JfdLwV0Iv5QfGGGmGh9W2Imdq0MIeTaMqkB6vGiU5LyA1qxez87lkZc2ax/jT/OUvHgF6FJVE6pf7xTfjsAmQ5sbiPuvki8WdiqCFCcBukhSbmHz9z2lv74Rtx9pspBq8q8gcAuC4wTHKDBvrie+CnFdMHfPHFwZcp9h+LimXyO7UWjbsCbtfxZrEeL40b8etvzvy0IZWsGOJz4pPVqoStt2Xd0REcqNVYq9T+9UiuevV05opIM25GvRwIxH+ycpYxRNn/+aKtuf2RVi6fPeVHAbQfcByln95F/mLggEBaiwpUTuXc38Avt5ahWHOE0o5G3FCDYPg4yU4h9CMhPhCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3304.namprd15.prod.outlook.com (2603:10b6:a03:10a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.27; Sat, 15 May
 2021 01:06:20 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 01:06:20 +0000
Date:   Fri, 14 May 2021 18:06:16 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 05/11] tcp: Migrate
 TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Message-ID: <20210515010616.uy5szaoqvjrn4qfv@kafai-mbp>
References: <20210510034433.52818-1-kuniyu@amazon.co.jp>
 <20210510034433.52818-6-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210510034433.52818-6-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:717c]
X-ClientProxiedBy: CO2PR04CA0105.namprd04.prod.outlook.com
 (2603:10b6:104:6::31) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:717c) by CO2PR04CA0105.namprd04.prod.outlook.com (2603:10b6:104:6::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Sat, 15 May 2021 01:06:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d61d8ad-dda7-4726-9ed6-08d9173da66b
X-MS-TrafficTypeDiagnostic: BYAPR15MB3304:
X-Microsoft-Antispam-PRVS: <BYAPR15MB33047B06D54D2DAB7437F9F1D52F9@BYAPR15MB3304.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M+598x8P488BWz4P6czf4+bj7ncB9f5tqWpAXicUxeT/taAQHKStWLXuorv0zwOSIULZFDojTRig/YElPBVW53IpBvmyI02d/rVqlahYg38bxmrG0if2a2AGCtkhkZCnZ75BhQwDTdaRT731TOnYMFGkWW9AlBykk+l9/6e6YSTU348ChFkqMcCIQIBeVa3RkfTIhMDzvHoxcRcgbvc9DWhyY7uoTUDA8jSdIR6+zZaAiNr/e3eOcWJ06dU4nmIbTRDfZAEJEqQH0eWgkbPG9Y6r3M5NAgDIhDx4z4Yc+VtC3lVV2MigCeSoQucxZeCcKZVIAe0W7jj34j2eCsd4fIiwrQlmctSd5p4SsshPXTeJYajXl1OODUNV0XluzV+ZSivmkdJdU/mml7KQSZe+UAvZKRoWChBxPSTP36QwZFwq75FIB5QQKtswVjJIs+xtQYweTq6CDa3XA+0cB8mFncXy8vEvyxIdiXJ5bR4SXlwFEN2E8UQ6sndrZnmUjkzGDlDKEP2KYMqodpz8dwsHV9KRighXlUTnmlf0YKVcwzs4xGFjAjbNM0zYDzxC0+xR3zvnPm4S6NRLz72ZiL2fSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(396003)(136003)(366004)(55016002)(33716001)(1076003)(8936002)(316002)(5660300002)(4326008)(9686003)(54906003)(6666004)(7416002)(83380400001)(6916009)(38100700002)(16526019)(478600001)(6496006)(66476007)(2906002)(8676002)(186003)(66556008)(86362001)(66946007)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TvZoxRCKxX3KNJY5y8oqLeetM4RNh6g/a8SAIO1gWHpmULy+Bov9v/wenUMY?=
 =?us-ascii?Q?WCM4f9dSO/K91HNN/ocN4R+aFGe2QhXkNFM0ULGvhX1BH3kHRgORoSXDrBz5?=
 =?us-ascii?Q?bIJQZgj7d2aGYTnZ5q7fY1Fj3EPhi8O66okzsSCw0lnS0y4hDrUBHFyWWgcM?=
 =?us-ascii?Q?bdvJd1IiVNz4ZMpKoS0fjGKYm2CzzuSAW3icU/gZZuDcDGL+NtpwLl8Ttuiz?=
 =?us-ascii?Q?vEZt9zo6+8VKnN7AmS70yxdOo+WP/TDn271NudMZVSKelaT3CgunrZrXJ4HM?=
 =?us-ascii?Q?WFiZIx7MUHFkqxb0cshuLT0FUMgYIZCo6mzf71eUxclkb2yn9siPMHsqfcy0?=
 =?us-ascii?Q?8yZdQuijkwz+3XZywekDlNu399GyDmuWCsNeNxmYjMzP388XdHPFg9T1pfOu?=
 =?us-ascii?Q?OgG2/fytybvaGCK/e2FR7Ny0nyFem2MNDMMRWMFD3yu9EmRczRQjHeVdUgQz?=
 =?us-ascii?Q?N95aD9Jf5XPCBhNLYQp7ifl2zZBrndshxIcs8xKjz6AJVOarjVwjOOropM7h?=
 =?us-ascii?Q?yQPVdi+2hi0tFddOyhmc5B8PnfExLXPpOOqFGtq8bkKDYckFqDi/qp3xMdME?=
 =?us-ascii?Q?UB+VxlYmepm1GlOIZpE107/qsZtHhnPR1YppUx8+1ma4HEHFC4KMDvCURI8V?=
 =?us-ascii?Q?kg+WaelY10JtkZJz/bOAw8kddHEu9xdHSvA0TmXGw/de1QjK1e/kUYmMEd/c?=
 =?us-ascii?Q?njTMirTR1UWixGJWB/7ET7asMhu6o++ysey9b9ar/98yWXNIDEdyTYnzsjnk?=
 =?us-ascii?Q?yRLUjg5XSt3hw3L/fOSTO7BtXO56HgGF8wI/air36jMWJsM8QnGT1/XjBKWY?=
 =?us-ascii?Q?PM2u4i7/+4qufrwczZ2ODkwFZrrnf2RSqftJdYE3oiWy9oNZK48efgg8xC/R?=
 =?us-ascii?Q?U6s/gs/jq1Gc/VvrcZyNiqWq73UK4qkc5Ruq7RGbBSTqRuTwrtsJsD5STeTl?=
 =?us-ascii?Q?GEhpjsv9Mci6JBl+oIm+qCoxfIYRJhS0scS3ziTvNJ8nF0j5/NlZSVDbTshT?=
 =?us-ascii?Q?4STsbTdT9TSw5RGw6cB3/io6oLSkleZnrJgj2wVX3pcE38UPqoZtBMyJ5M3t?=
 =?us-ascii?Q?QZNT1LbH+htTQqlo79HIgD30jRMHYVt0VcF3g4amA6SduWcO2Gllp7yCBZ8Q?=
 =?us-ascii?Q?IEGbMgNWx7z8nYC6PSE/jhxUPKQuTzNdecUnMczD3HCvvm/1EvmNXqwAbifO?=
 =?us-ascii?Q?k+s4krqPZa2CHla+YediAuerSWGn7go9S1I2QoOnizIVruAwdndfGPh9CNQx?=
 =?us-ascii?Q?V4/Jz7wbW26MIiaPkiS49OPO8koi6eiooRu1GUE3ClML1rVu9eS7rrzn70qP?=
 =?us-ascii?Q?7llDLebpbi78FAy2DziiSv9QeAlVEZvpPRA5ASV+8/maJA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d61d8ad-dda7-4726-9ed6-08d9173da66b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 01:06:20.6298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i3hf8t9iX9klOzEoeA7TL9mgpwS2OlgKej5VuoDf3AibL8PafTUqH3hDNuNvhybu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3304
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: IX9lsddgjkDML0a3i3Gk5ELZMaZguidn
X-Proofpoint-ORIG-GUID: IX9lsddgjkDML0a3i3Gk5ELZMaZguidn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-14_11:2021-05-12,2021-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=679
 clxscore=1015 mlxscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 12:44:27PM +0900, Kuniyuki Iwashima wrote:
> diff --git a/net/core/request_sock.c b/net/core/request_sock.c
> index f35c2e998406..7879a3660c52 100644
> --- a/net/core/request_sock.c
> +++ b/net/core/request_sock.c
> @@ -130,3 +130,42 @@ void reqsk_fastopen_remove(struct sock *sk, struct request_sock *req,
>  out:
>  	spin_unlock_bh(&fastopenq->lock);
>  }
> +
> +struct request_sock *reqsk_clone(struct request_sock *req, struct sock *sk)
> +{
> +	struct sock *req_sk, *nreq_sk;
> +	struct request_sock *nreq;
> +
> +	nreq = kmem_cache_alloc(req->rsk_ops->slab, GFP_ATOMIC | __GFP_NOWARN);
> +	if (!nreq) {
> +		/* paired with refcount_inc_not_zero() in reuseport_migrate_sock() */
> +		sock_put(sk);
> +		return NULL;
> +	}
> +
> +	req_sk = req_to_sk(req);
> +	nreq_sk = req_to_sk(nreq);
> +
> +	memcpy(nreq_sk, req_sk,
> +	       offsetof(struct sock, sk_dontcopy_begin));
> +	memcpy(&nreq_sk->sk_dontcopy_end, &req_sk->sk_dontcopy_end,
> +	       req->rsk_ops->obj_size - offsetof(struct sock, sk_dontcopy_end));
> +
> +	sk_node_init(&nreq_sk->sk_node);
> +	nreq_sk->sk_tx_queue_mapping = req_sk->sk_tx_queue_mapping;
> +#ifdef CONFIG_XPS
> +	nreq_sk->sk_rx_queue_mapping = req_sk->sk_rx_queue_mapping;
> +#endif
> +	nreq_sk->sk_incoming_cpu = req_sk->sk_incoming_cpu;
> +	refcount_set(&nreq_sk->sk_refcnt, 0);
> +
> +	nreq->rsk_listener = sk;
> +
> +	/* We need not acquire fastopenq->lock
> +	 * because the child socket is locked in inet_csk_listen_stop().
> +	 */
> +	if (tcp_rsk(nreq)->tfo_listener)
Should IPPROTO_TCP be tested first like other similar situations
in inet_connection_sock.c?

Also, reqsk_clone() is only used in inet_connection_sock.c.
Can it be moved to inet_connection_sock.c instead and renamed to
inet_reqsk_clone()?
