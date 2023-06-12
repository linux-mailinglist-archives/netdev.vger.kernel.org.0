Return-Path: <netdev+bounces-10106-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E00FA72C483
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:39:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A0741C20B47
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA4EA154BC;
	Mon, 12 Jun 2023 12:39:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46C6134A2
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 12:39:25 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on20712.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8c::712])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8424E10E6
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 05:38:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PfjbBCVnSUgTP1j5kCXyfNqBqJ6gWU92cbcdEoA+cn8tRFHxYrKvvIqYlYjNfNRHXARtyJWUIRzC3unZa/oFqwyLbji2uYHCI38Tino3tkLZwdrXkcE72ht9CohAMADBv04o9u2bpS7S/3Cw440OgrWetmC/3zL/kaUS6CecK3RF0IQ1DO5W/mwjqA8srYSCl7uRxDPmRDYVibjx4uuv5vJ/YvC3TaTDhhivh1gXAobMwMRtiC9sAOo14IDo0XXXq83mE3oiwIqxdDR0AGQrNjGi+2NAjTq8MPNXIlO/zJVdbB2yM7WAXL92XeJoYsUVjjEkVmbtFSOhU0fuobUL4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZNhsPXWW042qsoTJw6itd++NpjNTrxL1PGXtwCuCKI=;
 b=E/0NTFqpU9o14QNRnZsIKPBioEJrDuwyGbUz703VYtiOgG5TYri/SiHpnVy2odp+hvOph/gYYqOx9yibzQLfBF4TaJdD2L7km9rn2Tsgh7W7iq+WDm55l1EFabSR/FceWYLp5XZMthliTY7B43nkV1oCPX00TBqOOfpw9fhWYmxNVtXTT2UiNGcWph9Q9PElBQP1CoD/MpIaGN94MvXrv5WsRm5Qd0XRiSpI5/gVsG/w8AYLWBQMyUdsqnuS9Hy96kwm4Azg9vXNZ3zMgIkNPhQ4kp4qIJ4UoQ6+AiY4LGKLCNZsM9mRtP8tmmvPb2uRhcLGVSWvDbYI0IHgvoypNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZNhsPXWW042qsoTJw6itd++NpjNTrxL1PGXtwCuCKI=;
 b=ZwrKmky99lu/rv2Abrp+RLBWNeS0H7puoXO/+Cw6w29oCGtKnsx1R6KwZSB8sjFLbkxrODLEmz2/FsPI/Qq1/GeViFKg7k7DfVnpWLJ5C/wmbvXsjrURGYeh5joFV7NcrlADXLju67lydH/U2Rj5UOutHkWOQLLNp6ZrhKpJ/uc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5640.namprd13.prod.outlook.com (2603:10b6:510:12b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Mon, 12 Jun
 2023 12:38:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Mon, 12 Jun 2023
 12:38:34 +0000
Date: Mon, 12 Jun 2023 14:38:28 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next] netdevsim: add dummy macsec offload
Message-ID: <ZIcRxM/xvozZ+H9c@corigine.com>
References: <0b87a0b7f9faf82de05c5689fbe8b8b4a83aa25d.1686494112.git.sd@queasysnail.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b87a0b7f9faf82de05c5689fbe8b8b4a83aa25d.1686494112.git.sd@queasysnail.net>
X-ClientProxiedBy: AM0PR04CA0110.eurprd04.prod.outlook.com
 (2603:10a6:208:55::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5640:EE_
X-MS-Office365-Filtering-Correlation-Id: d50cd9ff-4d8e-4643-74ce-08db6b41ef8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	U7yHwwLcmeNErCwHjs7UQ0TJhV+vmQhKXEDY3AFaBYsg+pcQdVrUmTDYuClz04CJSvIeAJUV5sSEJsjCCwml9FMIMwLdxP12aUNEHFit8FQIzLIV9wVftizKFjfF09fcq4ykpNsIfa7xkBgG8nzC8ADdjJg1zmuFjkKfbp4u8ugKwFuy7tv+S94C/0SgI6KZu46ebLbnyzIgHWyNrGq1qZ+pdj0tfOi0Ktq6W4KrYOfcglr9I2gfqH/iPhSCG9ykddesVe9VLn2bHJF0r0EPYD8BPg6IP7XZl7tZ7/5FV+FkVnxubD63N/sP26bLyd1okvjt8iv/FOvPZOh1kyJs8rxN8fYUBP4Wsdr8Tq/BLOkQ5lVT/T8dW9l2MdmJ4I6Cwf1LO2JUgiyRi7w5bhxk/8vIECJEDQp5Yu3T10j0UOq5gKV5ajloaEOdQ5Qr25mn6xzr0WJ6GLwY9sYx6/TUc/i6S+QHrgTrhxmpRnddJjLRLVy2NWGrkdKa7M/ktNjskjwZY2N+jd/O5Y+JuWtLKQipjes9pYlPnmqnc7Vwcc0idfIGsQSiUFJApO5EMJoy
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(346002)(39830400003)(376002)(451199021)(4326008)(36756003)(316002)(66476007)(66556008)(41300700001)(38100700002)(6486002)(6506007)(6666004)(6512007)(6916009)(66946007)(2906002)(86362001)(44832011)(5660300002)(8936002)(8676002)(2616005)(478600001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Qu/fPTOrdGTM/JrmRwutruGDP/ZUDHsnq+Zs+LrjhfZl4QwNbhSG3TpQB88m?=
 =?us-ascii?Q?2NIw6ZplRLTc1VxR8qkXwXgFKDKXYYEioPS4mjR0QzUfBW3nd539/jzSWWrI?=
 =?us-ascii?Q?iUyRRUN3ZBgxyvNtxnc3mwkwmBc5YhRiixXTlU2YLmRGdqBIEMg0mGFjcT7E?=
 =?us-ascii?Q?0ODSlylGM1Qs1omZ1LSFg+wvR8SBZhTaYZT4amJejBhG98IuXjZqKjZL08KE?=
 =?us-ascii?Q?FiKSr6xbltdoLbCKuJw5XcpwGJE9YZ36ovFMTsdAfhfo1+okSd2r6GxyFmPo?=
 =?us-ascii?Q?11ZS7z2qUcRRWkfOpkq6Bij1/IBthADNGNX+hHu+kMZm6JWRFx/ZaxrP+EIi?=
 =?us-ascii?Q?xObIY92qWZMaU6fXJiLnUE5pJ5iqtqTCt94duMejhj3yfoRtWSM0OHob76Vx?=
 =?us-ascii?Q?/gcREXPS/5FOxq5LuAF0+2iGGYk+kQMhIC46Ze4MokH9crFEJfCA+yyNgKk7?=
 =?us-ascii?Q?IFnH2u+giaNIIIOuBw4ynOFKm43wTJjhzhXKcmN3PCH+7y0TOG3Gn5lwpnY5?=
 =?us-ascii?Q?kEGM3qnkIs2BEP9iNsWAii9atZN+4eBtwpRQhf0gjiyKJyYAx+TGcaEMxaWW?=
 =?us-ascii?Q?rV7tUMcNB6nlSy/cG/g7FZA+sFmp17KU/COb5s8s3+sCj5gxOlPOMXXOiUr/?=
 =?us-ascii?Q?UTH5HjumQcv/0dUJeAvFjBki4Q/NE6wdPOxUrZbBBSGX8UmW77oFQhlJEUJw?=
 =?us-ascii?Q?g1TZeOpDD+cmIW49FXJC3zHX1dRMXBRKuKS/vWsdd0d1PJHMNCxQq9ou1vUy?=
 =?us-ascii?Q?2cSrWowByF9qQM1oUxIhnUUEnVDzbiY96sYU/5twJRcOxUby1EfhvngToUwR?=
 =?us-ascii?Q?cBb5eDVnmekr+V3gva5TXIQ2h0qoleQRaKo4U9zEsIfXFn2h3/1x4XqinPpm?=
 =?us-ascii?Q?7S3r7SzHfw0a7zKmFM9h5aztXaa0bJlA4m0SKkSgZTeexq3i0/TL+7ZgAVBD?=
 =?us-ascii?Q?p6kd5sCnlfhTxKP9U/BehIFXJkaqm55fuulYW3BkvHUiiiV6SdkoBf4Albf8?=
 =?us-ascii?Q?9VqoaSN3fFhukbMRSNo1mogj15ZbV1+mSNoB+LNvXvGt/H5C7Pj08xzpRM4R?=
 =?us-ascii?Q?B4pyHB19Wt9jxk6WptXOjRfHVB5BocG/RpAUzUOiyva0iKWpC8otGbZdMWr/?=
 =?us-ascii?Q?ARfpt8R1ISrTC/z89aCd3/FuWfK3c1Rz3eQddUi7/uJol0tQR5GsHilLMBgl?=
 =?us-ascii?Q?L8kf6HyM7QL2UMFpl2GvZpDmMWD7XSnvH3QfHTVIoDR1Vl6/R9gxYQl8druG?=
 =?us-ascii?Q?PNeHUlD/NvLnK5M/2XCWR0i+odZpU4WjLHHtx3w6HyjsTMpq3p7cb1YfuzYt?=
 =?us-ascii?Q?Y7zjXdr6/f4V4bDufGeQfIvk8tW7y4+cgpCLk8EHuEgT3gdMpu4/lJYDwzOM?=
 =?us-ascii?Q?Nf03Vm86dvXDW7m9VYivzg//dsuRFcd6MjeGGidIcp7hYup6LHIe7KgJ1H4D?=
 =?us-ascii?Q?7HVXvmsJ6gb+YZUm21kVXqaH+01LQsKR7TCmOH5qTOH+AcwrrbQbU6ZEXGn5?=
 =?us-ascii?Q?+odthyUO5fUQ5SuoLg95ydgPSY6uazq9HMMgAc5Dv74eb3IU4mxraVM47GM4?=
 =?us-ascii?Q?DQYGBOKmnuU4O5ZnY3sIqWFqz8eo9dgS2hWYcWbZtKE0Kcau+6g0vHJOLQOS?=
 =?us-ascii?Q?4cQGBqO6RLWNLINPcNec/Hb5c6/t8ksCIR5MVjdUhXZROsNge1WrjkKQc5zc?=
 =?us-ascii?Q?QZyYOQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d50cd9ff-4d8e-4643-74ce-08db6b41ef8a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 12:38:34.0687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7tMte1EYKz9qOZQqR8VVlTpJd6PVQ6nc1p5V3JJVS0ila2cxhHPdoXq0iya/nsUBY6UUMtiJ0G2PaU6THoTxM8feYVynJb4xYNMX2Is1nbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5640
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 11, 2023 at 05:45:33PM +0200, Sabrina Dubroca wrote:

...

> diff --git a/drivers/net/netdevsim/macsec.c b/drivers/net/netdevsim/macsec.c
> new file mode 100644
> index 000000000000..355ba2f313df
> --- /dev/null

...

> +static int nsim_macsec_add_secy(struct macsec_context *ctx)
> +{
> +	struct netdevsim *ns = netdev_priv(ctx->netdev);
> +	int idx;
> +
> +	if (ns->macsec.nsim_secy_count == NSIM_MACSEC_MAX_SECY_COUNT)
> +		return -ENOSPC;
> +
> +	for (idx = 0; idx < NSIM_MACSEC_MAX_SECY_COUNT; idx++) {
> +		if (!ns->macsec.nsim_secy[idx].used)
> +			break;
> +	}
> +
> +	if (idx == NSIM_MACSEC_MAX_SECY_COUNT)
> +		netdev_err(ctx->netdev, "%s: nsim_secy_count not full but all SecYs used\n",
> +			   __func__);

Hi Sabrina,

It seems that if this condition is met, then ns->macsec.nsim_secy will
overflow below.

> +
> +	netdev_dbg(ctx->netdev, "%s: adding new secy with sci %08llx at index %d\n",
> +		   __func__, be64_to_cpu(ctx->secy->sci), idx);
> +	ns->macsec.nsim_secy[idx].used = true;
> +	ns->macsec.nsim_secy[idx].nsim_rxsc_count = 0;
> +	ns->macsec.nsim_secy[idx].sci = ctx->secy->sci;
> +	ns->macsec.nsim_secy_count++;
> +
> +	return 0;
> +}

...

> +static int nsim_macsec_add_txsa(struct macsec_context *ctx)
> +{
> +	struct netdevsim *ns = netdev_priv(ctx->netdev);
> +	struct nsim_secy *secy;
> +	int idx;
> +
> +	idx = nsim_macsec_find_secy(ns, ctx->secy->sci);
> +	if (idx < 0) {
> +		netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\n",
> +			   __func__, be64_to_cpu(ctx->secy->sci));

Sparse seems pretty unhappy about the type of the argement to be64_to_cpu()
here and elsewhere. I'm unsure what is the best option but one that
sprang to mind would be conversion helpers, that cast appropriately.
f.e. sci_to_cpu()

> +		return -ENOENT;
> +	}
> +	secy = &ns->macsec.nsim_secy[idx];

As also reported by the kernel test robot, a W=1 build complains that secy
is set but unused here and in to other places below.

> +
> +	netdev_dbg(ctx->netdev, "%s: SECY with sci %08llx, AN %u\n",
> +		   __func__, be64_to_cpu(ctx->secy->sci), ctx->sa.assoc_num);
> +
> +	return 0;
> +}
> +
> +static int nsim_macsec_upd_txsa(struct macsec_context *ctx)
> +{
> +	struct netdevsim *ns = netdev_priv(ctx->netdev);
> +	struct nsim_secy *secy;
> +	int idx;
> +
> +	idx = nsim_macsec_find_secy(ns, ctx->secy->sci);
> +	if (idx < 0) {
> +		netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\n",
> +			   __func__, be64_to_cpu(ctx->secy->sci));
> +		return -ENOENT;
> +	}
> +	secy = &ns->macsec.nsim_secy[idx];
> +
> +	netdev_dbg(ctx->netdev, "%s: SECY with sci %08llx, AN %u\n",
> +		   __func__, be64_to_cpu(ctx->secy->sci), ctx->sa.assoc_num);
> +
> +	return 0;
> +}
> +
> +static int nsim_macsec_del_txsa(struct macsec_context *ctx)
> +{
> +	struct netdevsim *ns = netdev_priv(ctx->netdev);
> +	struct nsim_secy *secy;
> +	int idx;
> +
> +	idx = nsim_macsec_find_secy(ns, ctx->secy->sci);
> +	if (idx < 0) {
> +		netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\n",
> +			   __func__, be64_to_cpu(ctx->secy->sci));
> +		return -ENOENT;
> +	}
> +	secy = &ns->macsec.nsim_secy[idx];
> +
> +	netdev_dbg(ctx->netdev, "%s: SECY with sci %08llx, AN %u\n",
> +		   __func__, be64_to_cpu(ctx->secy->sci), ctx->sa.assoc_num);
> +
> +	return 0;
> +}

...

