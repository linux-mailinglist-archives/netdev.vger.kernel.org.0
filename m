Return-Path: <netdev+bounces-5252-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0BCF7106B6
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:51:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3B321C20E98
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B304DBE78;
	Thu, 25 May 2023 07:51:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02B4C12D
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:51:10 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2129.outbound.protection.outlook.com [40.107.95.129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E565A8F;
	Thu, 25 May 2023 00:51:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RImZlbFjb9YqyLXFeaQvfmdVvrTyLKkqMr2OOn7BCEcxfJ3mj2ONpuNhEe82gK1tvHTY6ppV/pFwKWsJ+aU7yOZwo3dkyakBPjwcp1Y0Q7D+OaqfWmRs2CVXvCAupNt8POyQn5mzIN3PD6iJPWxa2SzAXJHheCMX+/TTo1q/4mS1vtgHSBSduOryiUzGdCEkuJ4NDwEbiO29DdGImR/Uys5wNgk2MioO+P+0RkfFRNJudOWsie6X+nuoTU0XX6hkX6bBYRtPtL3sjKOs531k94RWyXwTsnlmwEMHAzaIzwRNjzpCt7/iopaWUj2X67Gh+pmQYWrxIQoiZT+nSWc50w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WaTsvVFQJqbECxyg2ThLZu3q0GvciUqzI0alyvYb+qA=;
 b=Zu4SdQnyhmP7V1whPwXkPIc6paXChtHeKoVNsOZDrVrjTRLFnuDGMPbLE9Qj+8dainF/0XNthssoR1lBJ31uqya9LfCMFvb0cD8Pwh2p3UmeHR598acCbJ/kx21A7EByE/RtvigaEnao0eys6bAGAuk9mfYlx6v8KMaUCYFDIwbANwPecbTYCbRuDL60jP9f8U2bTlTHWBhzT6GoURdsr0hVKtc5liQ9nZfGnCVMoiAhHhE8Lb4muQOFrl04s7WO6OS/m5WepAjK8lJQDCJ5M1OCF6ct6L/9RNeIV7iDaDbWfnY2mcn7u8XR4vQznIqR3YYky6VxEtNZ+Vo5dOr2eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WaTsvVFQJqbECxyg2ThLZu3q0GvciUqzI0alyvYb+qA=;
 b=bPuIDE1p+Kh0kE2et8YoYcO9Cu+WviPcx+Xjz33V4FZJJd+fv3l5s1U4NU4VeCqJWK4qIK++tDeq3BrDp1FQnkCCsF+iuS17rdBGgyE/5xcJujMD+wxZ8tF7ljm23R5DCM+RVlAtTsqkA0ZaCEOOro0Out0kYNES51d4Q6rMu/w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5169.namprd13.prod.outlook.com (2603:10b6:610:ea::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16; Thu, 25 May
 2023 07:51:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Thu, 25 May 2023
 07:51:01 +0000
Date: Thu, 25 May 2023 09:50:54 +0200
From: Simon Horman <simon.horman@corigine.com>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ayush Sawal <ayush.sawal@chelsio.com>
Subject: Re: [PATCH net-next 2/4] chelsio: Convert chtls_sendpage() to use
 MSG_SPLICE_PAGES
Message-ID: <ZG8TXgs+36O9AS93@corigine.com>
References: <20230524144923.3623536-1-dhowells@redhat.com>
 <20230524144923.3623536-3-dhowells@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524144923.3623536-3-dhowells@redhat.com>
X-ClientProxiedBy: AM0PR01CA0082.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5169:EE_
X-MS-Office365-Filtering-Correlation-Id: 07b265e0-24fc-44e9-530a-08db5cf4c8be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8bA9ROEvMBzXmxhXswcHYBk+4mi3nMTa9hG2oLDtLDkR5I6muVB0hMNMA6I0ohDbIJ7F4gsjs3rU7+PvMOpRNYAGxYW/LlRYuhOnmc0DVcqjipacGmd+xLLAm0A+00QLv+pDdYGUtoApkMu78WzvLI+fGO874GE6gX4FHv/jGc64rUWIZ/9+rHqSCGgbvW2HdnuLaYcCaAUOpQX3oUWAZEnqJUIeyJlF4cO63EfErWjuP+7b6qfUgn4PhRRvjqIMFG1BX4QXg7K+gZcis0eA/yLLpVn9IGcOw0n0iNjnNRZWxyUFJ1PK5B19EBoGv967z+eOyKPvCX4T+h1995VVRZfFcS/7yl7i94iVMJ4GFDxzGgFMhE/oVIQeBEJ/8FazVYEqD8TyPHDrpwYT4Q4MuDDrODjYDNrwbOVq5tBXYPa2n/ecHHExtlF9+i92K80kYu74nKCP+TzV/ei7IBAyIqX5y0vDefoQMgWEgMUIdnHNPZMVYKf6AOXSJK1vSaScSTqTM2itfuqdDzEG5FPw21LW96EyR7neLpAVLjWqAOnjQlL8/4bl3JJDK1ZgCZTd0Hi5/C/HLtXmDHSutB6jZQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(39840400004)(376002)(366004)(451199021)(36756003)(86362001)(54906003)(4326008)(316002)(6916009)(66946007)(66556008)(66476007)(966005)(478600001)(6486002)(6666004)(8936002)(8676002)(5660300002)(41300700001)(2906002)(7416002)(44832011)(38100700002)(2616005)(6512007)(6506007)(186003)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cYM53YFXJsJy6OvUYO9zIkAB66/S59GeWTcPmnczZ4COKdDns19+PlFDMBt8?=
 =?us-ascii?Q?QeUDbu83t7TpJlsVhXly/zyX5mhsmdRxtJpDk1S0lmJ3weTm3LVUpPIdysyr?=
 =?us-ascii?Q?HygsuatkYc7PAKodGPYiCYEK0gksyke1Wb54q2k1wZ4WuKufuwjCgCMJDuxd?=
 =?us-ascii?Q?bYbGU5xsbBA0R/xwrYxAPgpqqG8hzN6GNmu5gCQX5bhBlZbMyJt1+C3EOmPz?=
 =?us-ascii?Q?ZBmZex5OBHVuQMbD/70jo8FKmg8j7ONkwX1x+QkJq6x9f3Vb+K9SKCHBYaSh?=
 =?us-ascii?Q?g9hK4yQKsHYaROMMcxm5NTKbgK1bo/h+4cyUioEM2S/Op5j14v0iYKfEG1Rx?=
 =?us-ascii?Q?VmBqIohDrEWlX9xpNeO3m+med4Gp44M+sTVcXQTq+J3xpbiQvsDK1Bial9eF?=
 =?us-ascii?Q?z8CATd01ZwTQwKKB8hE5weIfOOam1rbBTM17QHlod919EAz18ax32Q2JnaBB?=
 =?us-ascii?Q?hER7DdPowtmyxlPhOK2rd9B0W7ec/OvkLBuVDj1PXmCKkho5eGT6uaxHb/BB?=
 =?us-ascii?Q?FeUhG04riHzLEV4Pd4gStysbWxiTD7slORI7ZVWgdGUmgC6x+mIwezvim2NH?=
 =?us-ascii?Q?ky7JtA0vrcPU6YzwlSJY1u0vmsO7JcQxlXcJtEro0PPSasZMtmdeo4tTzGxU?=
 =?us-ascii?Q?c/klix3J7FGRuU8Q8Pxo/ncAQi5f8eZg8cW+WY8theB2OdOkfrym0A0Fu+0v?=
 =?us-ascii?Q?L/UsGbuata+7flCHorkBHmH4KTWduVU/N2aTFAwbVbFs5z9l5NdviP14AYCW?=
 =?us-ascii?Q?OZwnBTlOdCnI0PXD8VO4Z5pboI1ZHfjSM55aWwwaMfOGAD7mKxRoQubXUUvO?=
 =?us-ascii?Q?WA4VJP2AxyF3EuSJStcVs39XYjZqwpxwDXx0usR3em6PQvOhcUlVGL5JAe0k?=
 =?us-ascii?Q?y2T3zaTnC4EZZ6poNbsWzSmeGjK9YF+LMdFTyfBtTr6F8zETnLCbVucLKCtT?=
 =?us-ascii?Q?P/1K61SkYdbiax9+NuMKE9absuHl63w1ctL8nyZs6b1pNfQA+ewncK0S3jKv?=
 =?us-ascii?Q?bIAqosXZlYqtIK8BuLlfuN2pWWJfDPUvWVg7Sv9Tzjb0lJife6WcjducEKC8?=
 =?us-ascii?Q?GVZUmxSQT17WAp+89dAXaNTrpawKf9vFNl6D5un1gbGscmu7SocyYGtRBd2b?=
 =?us-ascii?Q?2ylxfFShE2/yWmR8WZTjj2iZOvJTnFFknZuFppxFhpmDcEvk5KrkQiO2jXOE?=
 =?us-ascii?Q?WihLqcqScSKtfhZRIADN2SSMcxQVXNRXQngmCMHuQfChHHzDOBkfaD9n+d7/?=
 =?us-ascii?Q?fB1GD0tGiCJax4x0n9ikfylJUK2xTz9HCray6C5nkM+2/twflxQtcsj8h4oR?=
 =?us-ascii?Q?EALRBe0kwW8W+0LfjecA7jRl4wn+OQFLp+0MbHoekKg41iJKVfKCyfLyPsY0?=
 =?us-ascii?Q?AmrSxvWlKZ3ngqpzqvqV1EggKAmIJ8n0VVIxN9L0qb+1GZboP/NK7esEo+1N?=
 =?us-ascii?Q?wNn98+iUIcbjP6xCFR3AIXqFLaR8n7gC/dyuBEeEVhJ95m8QYlZq3vdEEfqY?=
 =?us-ascii?Q?yIpWDAMipP3HRwFVS/SIArGPW70QwrpnTWulNiSPb+7ZgwjahCoieekCSXU0?=
 =?us-ascii?Q?Ad5jbjovcbHDoWotda2EX6jr4AF+9PXN+XCt+dmY29uCAoLS8EmfYM1A6daU?=
 =?us-ascii?Q?GztUE7ks+LZgQIxCxQONgZtiQMk7mJk1UfsiYTJSYhEkaUajTP13FSN4BAln?=
 =?us-ascii?Q?S7Sgbw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07b265e0-24fc-44e9-530a-08db5cf4c8be
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 07:51:01.5863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KydzZvuvLF1ncS6N3yyn+lHtArDI9MBFsi1qJx89Nh5GVCu2HaAos5s8TOrU2PEkFIxe9Vff/TklDQo524hOahTax7Y3UeN4wEsVCwlzniU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5169
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 03:49:21PM +0100, David Howells wrote:
> Convert chtls_sendpage() to use sendmsg() with MSG_SPLICE_PAGES rather than
> directly splicing in the pages itself.
> 
> This allows ->sendpage() to be replaced by something that can handle
> multiple multipage folios in a single transaction.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Ayush Sawal <ayush.sawal@chelsio.com>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netdev@vger.kernel.org
> ---
>  .../chelsio/inline_crypto/chtls/chtls_io.c    | 109 ++----------------
>  1 file changed, 7 insertions(+), 102 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
> index 1d08386ac916..65efd20ec796 100644
> --- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
> +++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
> @@ -1240,110 +1240,15 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  int chtls_sendpage(struct sock *sk, struct page *page,
>  		   int offset, size_t size, int flags)
>  {
> -	struct chtls_sock *csk;
> -	struct chtls_dev *cdev;
> -	int mss, err, copied;
> -	struct tcp_sock *tp;
> -	long timeo;
> -
> -	tp = tcp_sk(sk);
> -	copied = 0;
> -	csk = rcu_dereference_sk_user_data(sk);
> -	cdev = csk->cdev;
> -	lock_sock(sk);
> -	timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
> +	struct bio_vec bvec;
> +	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES, };
>  

Hi David,

a minor nit, in case you need to repost this series for some other reason.

Please use reverse Xmas tree - longest line to shortest - order for
Networking code. I understand this file doesn't adhere to that, and
we probably don't want churn due to addressing it throughout this file.
But my preference is to move towards this standard, or at least not away
from it.

So in this case:

	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES, };
	struct bio_vec bvec;

This tool can be useful:

	https://github.com/ecree-solarflare/xmastree


