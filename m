Return-Path: <netdev+bounces-6532-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 501A6716D8A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:29:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B14B280EB1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3808C21CCC;
	Tue, 30 May 2023 19:29:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2411B20683
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:29:36 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2107.outbound.protection.outlook.com [40.107.93.107])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D9AF3;
	Tue, 30 May 2023 12:29:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIdhiAK/DtQTPQOzVeBEf1YILdCFBsVBTiGraLjrUtez4cd+NE/zw3LFxVIQQdyOvXovVCxAeCmqsMYskZR7yVzByKFs/PuOmX4LmPXwZQzcumDIoUyD7DiE+8EbiwDXipzkf8wxLlxNJ9LtHnKl2VH2UqrhsogFznTn5KotDTr9R837WrdwBY0Wqvd2MJ3+hLpTaIqUtSHZXY764Bq3Wu4hazCHSlK6fUVkCCDrmk+wFR2a/XVZUzgGvx4SIEW9M17clxxdY4YQ+I1Pu79MqY8zR6hqJj/5spHk5wH+x6sfAWiGNTybwVMXGpE5njjsoak/Qqmq7u/TqbRWHoIlAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O6afbJuvGQRTxwxzMmCxDgwE3BIik1y1B3zUxzUrjR8=;
 b=UihhdBPGR7+j/qSB3zyNtGTT22sHqioR3B0OyzP2yIq2RhuofK2QKe5yy4/F7z1phMB2DIBWpRR3nA1DH20mNJ29dBHF6Vd3ObJXflccNMCf7dq+F5dz9T7tmrs8o3ALaQOPYwN7jB/VY/LDUdq6cJHRoSa1D/n7qzyiVVVcJYgoygXfmZgQ6Xh8sa/S9+mgQ1gzWpOvkgq1EUfaJDFV8JCwBOCQKSuSHyL8LwprLy0O4bJzHfums8o0Be93T19Mp8behd1lqsvqJdo7aCTjDch4QLNL7unaGdxdUF94GlLhqslXc/N3/b1aVHfH13FdTjsPfch/NiIcLAriNP6mAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6afbJuvGQRTxwxzMmCxDgwE3BIik1y1B3zUxzUrjR8=;
 b=V9/P4ldzAn70QJpexlWkV2u4t+c83K7aPHeJAYu6l9PMfESRYAml8lJ1aWE4GmqeRE/RQ3+w44Kfddr23oT5s/96D7qA3/GOGelT+BobGNjqSp43xw2n38eshdV6eJmMle+1swekv5FuK+4n0lFwsGXGQyyhL3gl+r1GSqYWMTY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5281.namprd13.prod.outlook.com (2603:10b6:510:f1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 19:29:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 19:29:30 +0000
Date: Tue, 30 May 2023 21:29:21 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
	geert+renesas@glider.be, magnus.damm@gmail.com,
	netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net-next 5/5] net: renesas: rswitch: Use per-queue rate
 limiter
Message-ID: <ZHZOkTChN5pAl417@corigine.com>
References: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
 <20230529080840.1156458-6-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529080840.1156458-6-yoshihiro.shimoda.uh@renesas.com>
X-ClientProxiedBy: AS4P192CA0032.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5281:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cdcd828-90bd-4b37-13dd-08db61443054
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zPmQImQL1kcUcx9GCzWJYB3nDcEhgMBA2CsgVRpOycEvUJf3LX+hCXZy1wZPzVgt9Y31WkdasdY5EH6w8pVHordYWUqp51GDoEaYR83QF7dgpAeClgGqZz/iwN3kGa7vzXkZxLZ43KFjTitBlHOQxi/t9+VwX3vGCwigM7wntzXv+1p0qJh7m+3qxrGJzi2MG2zuiXmIzC8up8mluLk5hClAWBkRkK0D4+cpaHq8yy6E51QAWA+UkP3COJECkb01LovBO5+dNSZPzeZZ0y7sVZGvShGkD8JtpOeQIfVYnSGAYZwzj3F5+6atHLyeOPQJBE4FNqRb6rVGKLm3xQEGJjfseigDHiIjtZR/8QYN0kka9O8UkyMR0v8YfNXEDRFhIrbXLjnF+Lb8M3TCj+FIQhmDMFYtO7+pdbZv61mdipZjwChCYOnwNhQjsrLkfvPb9/il6eH5V+5sTE7sZt1lAbnOGxM/mggH4Ugew4fcgy/Hqlcoqgtjkou9gxuYcjCdDKJ1GNNZzBnUTtLL/5Tq5UhnVUGVZ3TYIfGdUzyeCzv9n66OwmFXa906UdjoGY+r
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(39840400004)(346002)(136003)(451199021)(186003)(6512007)(6506007)(2906002)(2616005)(36756003)(83380400001)(6666004)(6916009)(4326008)(316002)(66946007)(66476007)(66556008)(6486002)(41300700001)(38100700002)(478600001)(44832011)(7416002)(86362001)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MaRukyetqrPm00npy7KPHVVXrD1lVq/jKLRyt7Mk9FoXQAEO9uJa35pbUcJ1?=
 =?us-ascii?Q?YrHl++eW26Re6R9L+RydMND9MhH85cjJETC/+/La2VqmHRB1mGbjo5un8B3q?=
 =?us-ascii?Q?3q+6ntG2iT7x1SPvculfllInYHOfkcXI1Fby2rO0WAS3b5kcxYbrPM7IE04J?=
 =?us-ascii?Q?hgrDPDuZNep3NOvZ8+iaj13P65mYk3hqwCx/7zzavZ8/Uk6tYlUPlQNYEmZc?=
 =?us-ascii?Q?2GLJOQ8W7etXy8lseEI5sBRIYXF+sbezmvN0QDbYXHY4Q/8L18Dj9y6PZT6W?=
 =?us-ascii?Q?imuz6KZAZZk5oQ0LXd6BGSCZaIe9OuxMeNfeQOsQcu1Eo6u7czV33ckU+ZIM?=
 =?us-ascii?Q?fw4sP+oHVpQ3H/wnc6HViK+QLGqiRho3VDjYgMgM4raoDL84ONDRHhiBllTR?=
 =?us-ascii?Q?T2/oCxYKtEysxiEeEk4bZh5RDn8qXyeIeK+hB4UACL97VYUSiO7baRBYfuiT?=
 =?us-ascii?Q?3frCGAu6Nv0RyfkvmLQN3mrmdZurQf28EHjKi+OGzNz9AKR60gscvxYlSkhL?=
 =?us-ascii?Q?klaSi1+BQxwhUj43ldhwK9o2kpQXHw36KePsjpFx7ymUMhn8p8ZGHPJR9Wuy?=
 =?us-ascii?Q?zGx5EQZwP/dp+BCg4iQaBYKQjJRoF2W6CPEtaEv/f9niDqYqk1GN5gYwOHTs?=
 =?us-ascii?Q?NJCsOF/PwAMkCD7OMTOpI//ulzvcM01Hx28mykBwAh9dJ+4rgmKM64U+mZSX?=
 =?us-ascii?Q?Jd6k3LvYQYDti3zATK8kQF9ClpWdFfhwFHPBSMzOl/WhzP9NdqeB8qgHjMpL?=
 =?us-ascii?Q?Awpsxc5ka6DGvnSo+aGg2UUKX1P11lFf9JdgjDE9dhoD8dQI62HzpRwLyTg4?=
 =?us-ascii?Q?rBAWo9EDigGBpWBE340PCna+JtbURxBxojNKV33ZcxnLnl5hbtGTIOZSrbZt?=
 =?us-ascii?Q?QLIYkPpaBYlpKwvMTXmUGt895+Lt55ZxU8DIDcVH9xGxUN4rZexa76tehBBf?=
 =?us-ascii?Q?D/H7gpVf/AuJLRpiPyZ6FwnIwSa8v/CGfx6DJTP41qkDlWsYwsygrIv9SIkS?=
 =?us-ascii?Q?CfeK2W5iBkZNfA+oePfjj37w3vubNuWsreTu5vQL75340k6um4bXXTGQowij?=
 =?us-ascii?Q?G4aMh0EEKnR9semoKJaS1mO+Dn+GVR0ZP5PeiqJrdcJt3Xz/IKsuhs6zohW6?=
 =?us-ascii?Q?W6TMwZSL4wgYkffBXZM2fVk+8ynFIm8bHIQ2rLNXeLG5CCdfyHL0uKFQ9KnK?=
 =?us-ascii?Q?ESlTsRz+X5OPpcavz9n3IcQ1VhzkO+MprIAd4X1TXDBfCd5dadA76SJoU5j1?=
 =?us-ascii?Q?HnEwVsnPFPTTfsv5BQiw0phAVDKKqFpDyvfUsXqkQ5Qqbi741uONTGVq1f+d?=
 =?us-ascii?Q?hvcJWYSO3LFoe+4Rf9+iFDGtnMG+hd9z8VGLCEQZ9qG0cDve90UY85pJAO0Z?=
 =?us-ascii?Q?CxK0tOOnmhxG5ysN6neQUoXye2C0fjr5xcK7Rqi/bhLduLNkR6QmxgZBqvqz?=
 =?us-ascii?Q?ESciXO9SHJLz84WD54EUhTdtcWyvQYxMAbb8nKCtI7cvt0oqChqPT9SK9Dp7?=
 =?us-ascii?Q?jGInRMOHkmyxs1rHpYd26v4NWQWeLj3VekfrBLs3Mcb3ShZs6z7EXOno4wI7?=
 =?us-ascii?Q?COmExWgXJ42DXI8pqvTO8T6ZRUrZSOOLFy+83DJrn27AA5ajnk4bj+W9HITd?=
 =?us-ascii?Q?40k0lEOtKm1mG8aMMjMsFk4/SwXoTHTW1BvZglnzVqr24ermAYXc95CUaIrW?=
 =?us-ascii?Q?nB4zxA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cdcd828-90bd-4b37-13dd-08db61443054
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 19:29:30.1233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0znOvAg1ClwJEtA0L0kBp1eB5gOkqxeYstnsJ/zmiQAlVHBxCauq6rtOW5NQ2JjZj90/DqgjvPXixoCFhH+gzVtFpZ8uto/D0j4mCK/4y2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5281
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 05:08:40PM +0900, Yoshihiro Shimoda wrote:
> Use per-queue rate limiter instead of global rate limiter. Otherwise
> TX performance will be low when we use multiple ports at the same time.
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  drivers/net/ethernet/renesas/rswitch.c | 51 +++++++++++++++++---------
>  drivers/net/ethernet/renesas/rswitch.h | 15 +++++++-
>  2 files changed, 47 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
> index 4ae34b0206cd..a7195625a2c7 100644
> --- a/drivers/net/ethernet/renesas/rswitch.c
> +++ b/drivers/net/ethernet/renesas/rswitch.c
> @@ -156,22 +156,31 @@ static int rswitch_gwca_axi_ram_reset(struct rswitch_private *priv)
>  	return rswitch_reg_wait(priv->addr, GWARIRM, GWARIRM_ARR, GWARIRM_ARR);
>  }
>  
> -static void rswitch_gwca_set_rate_limit(struct rswitch_private *priv, int rate)
> +static void rswitch_gwca_set_rate_limit(struct rswitch_private *priv,
> +					struct rswitch_gwca_queue *txq)
>  {
> -	u32 gwgrlulc, gwgrlc;
> +	u64 period_ps;
> +	unsigned long rate;
> +	u32 gwrlc;

Hi Shimoda-san,

a minor not from my side: please use reverse xmas tree order - longest line
to shortest - for local variable declarations in networking code.

	unsigned long rate;
	u64 period_ps;
	u32 gwrlc;

-- 
pw-bot: cr


