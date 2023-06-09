Return-Path: <netdev+bounces-9559-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 298EE729C21
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:02:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B416B1C208D2
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E1A1775F;
	Fri,  9 Jun 2023 14:02:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75052747F
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 14:02:20 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2090.outbound.protection.outlook.com [40.107.92.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2763A85
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 07:02:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWorUmtztPqmI9NrtweZpNeh5M6rmeBfimu2cUt7ipw8ojHlKuLD06dlgXu8v3ZCKyzh03Z67krDLqN1TU+qywjAYB5tOtuFy4fKf1NvB14Js27SHKnnLhchaI5V8KpgEz0faCiA4lZaK5iJQ0CFXf1JKMWEZkx23zK2V+zajicR1IUffiiokuZjwWixcK7LBY7rIPocdAa0o4Vwc6v5PB/YQooTEW+lqgGGp43fnOvDptQVeC8Vp+b6m5sheOphVgF8JajcWUMKP+VfxGnWpqkIaMzpjB8iY3rPJvzAT2dNsdvvwMf8xk+oYlP71eqEFa10LMwEQ4/vI0E4MNPWhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S78xPRRRDehr6pZ8GIx18aFCe3+Db584UdkyfG9ReMk=;
 b=Pnl2GxrIvi6JagyUWASXZx3YUOTd2T7YUGFjIKP/b56b2yfXUwLgDCrxOWsBCjw8iZKNEuXF0+OXrGIZ3Gq51BFi3U4cI9zc2QnD+TcXnqc9vu9XRixNcC9UNRgR5JBUb3TE08+Zkw16JGeBIKTEykr/8zvnXJSOniU4eVWaEOrNjZ6ykR7q7hokUuEmRzwbeISDTmwErhzJqAjlF2y20PKaoz0u0cT26EhSKsrgPbdlTqMrMjv1/XoN5FA4vgaC68ynbJrhrJVtWbiZw3hLqb9nbDcdv4Uj0dpM27ykCMoJWq0r5XS6CkF9kGrUdEHEtz72VQ7puyOXM/dNbuk7TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S78xPRRRDehr6pZ8GIx18aFCe3+Db584UdkyfG9ReMk=;
 b=oFbOimOFAocOsvn18t2Ug8L8jch65q2Aax9NJQFtTWeMpKUauQ9pOM3FOqIRNQHwOhNihntygW11UvsvAHbx/CPqs3uWfWTh22K/sg9/LyMc/6QjpO8H5mqi44ISuVo56sRvqa25GL76cpPkb5CuZv+0k2qpyfdafwUEXPP+Mmk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5083.namprd13.prod.outlook.com (2603:10b6:610:110::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Fri, 9 Jun
 2023 14:02:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 14:02:15 +0000
Date: Fri, 9 Jun 2023 16:02:09 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
	netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH RFC net-next 3/4] net: mvneta: convert to phylink EEE
 implementation
Message-ID: <ZIMw4XoCg/4biVN9@corigine.com>
References: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
 <E1q7Y9W-00DI8m-Jo@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q7Y9W-00DI8m-Jo@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM3PR07CA0141.eurprd07.prod.outlook.com
 (2603:10a6:207:8::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5083:EE_
X-MS-Office365-Filtering-Correlation-Id: 485be0e6-c2a3-4004-894d-08db68f2214f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	b1Q1JNY+Xw9C8ZEHhWgERCdJwtmSaX0bBsFK9+MfwHLcE/2TUcBNFSBxhB2iug6iyJde4+EwQQxpXomgR2d7mP8H9W8TA4t4rq135T5WVUQZHTOosXivqklGGMFpZQVkKGJqMnMv5RSCg11JaapFNhiYLMRHlAqn/pD5MfhEs5ztLyJzr8c4JfSYwgIJfadfl6PXqQX1TVfEjUVYYJu8DU3UoaNHAroNUeDr6f9Rnnaa1/MLThy+wr+iAMvNK2dFfSdN/46Ebb2yVRi8Ty5MmMQCyXmGRAFnIeF7BkoIfUvrXkqDAwHkqzUb+TJxJrRDWE4sTBxu8HuoizoOz4B5s67p4iimRNAc+gCVTPF2OLBP7gcL4CXgG75wXSu9z6xcN5zcHuwrQJebYPuLU2hr/iGjH+CYFc3nWL4VsxauBhynTT87Q3qW7VM4EBs4dkrUz66xnl0duYgg3gVmilYT6PDhan2P6alZGaNKVInS7HDXrpPCP4QfDduY+geT4oomJbIHLvAGlL851S4HvCKQDjPCXBIcvRww01iuTQfE4Uy9aD68ZzSd1/Zwc9HW4x9HsniLJqfUTu32q4HTNzaDQ6SlD23DvvBeawePGJ5rVxc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(366004)(396003)(39840400004)(451199021)(86362001)(2906002)(8936002)(54906003)(38100700002)(41300700001)(66946007)(44832011)(66476007)(7416002)(316002)(36756003)(66556008)(5660300002)(6486002)(4326008)(6666004)(83380400001)(478600001)(8676002)(186003)(2616005)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tLknt9pS/Rm0292wYt1jO1vEYMtVSsgXM0avhuR/C7z+VFEZ606RZKuVIqGV?=
 =?us-ascii?Q?zWG+c2Nfyizm9tuvVs4oIBBM9aEcTN/+7gHVz2Ta42BSOZ5rca0QQzQEj2qX?=
 =?us-ascii?Q?yowig+h/dAtgOZOrSywD/JfD9u0ILmpYIAiBKmvjDIbqtRlHTKRyd+6mHqC7?=
 =?us-ascii?Q?zXEAHUBAIpdM/s2yU9g1fK3TWHsNu7VyWLxOdybGRKezEkqyIHKk39SUVBqy?=
 =?us-ascii?Q?KvgV0eWtjHdKUo1tqD2DKosqj+HA2JO3JW1ojISi2UNAoolnmL1aCgG19RVx?=
 =?us-ascii?Q?wr5IZTRSigOmONsNJE7cd95HpjZuGoV7aGD+aDdJoGk6DhGva6yG+LUCSrwr?=
 =?us-ascii?Q?P0FJ6BbQzOWivl77H3TGSjoiI9nvLiZxOBjufODQpTJufK1g2kCm84F+ZRzk?=
 =?us-ascii?Q?EYIlOR7jN2j3kL/95s2O2Bo9K7Tm1A9qTff9OWATcpAiqnFr8b14Kj12hTSK?=
 =?us-ascii?Q?oEQnIau3jFW6oDnE4ZwG+NDv+qD/N9VXyX21o7gXQj6P4SsKig88JuFAYGg7?=
 =?us-ascii?Q?gEc8qKVkPYy1IMjsYN39rtqT/jVO8IBH2go3X8OHkeDnl0zZCwbD10jSAx6o?=
 =?us-ascii?Q?vQTb4DRVmjXjOd8QsoL2VCln0p1Lv42G+VWihh+s1LEanFVwtseFA6BFXQ68?=
 =?us-ascii?Q?VoaOWtBGFZh+sS672cy6kb+GfBOCMPz3U5g+T/d+4YQKJt0/IuglaLD1cFV7?=
 =?us-ascii?Q?RNWFRFw8Oa/oeaduCqvzw8yNGciPZH08lf0NRyr6itvMWgOgTZO0hDVILhHG?=
 =?us-ascii?Q?MGVIHNHyXf2G8lYlskSPM/I7os4wrv8FdM359QAUWkHTguexRgt3DdaZyiAl?=
 =?us-ascii?Q?WO7jDBK32X8exC4aS7stnHJmFAzXkU4DgvF0AoMi0rgH+JDUaPmTm/jGnRf2?=
 =?us-ascii?Q?qV4oewLAEzXvgVXZsQ56dhOVcLS3iKfdFDDfwSr4C4TI1weBDsFvFUQC3oKr?=
 =?us-ascii?Q?akkVu4Eg3doM+vmc52BbqkGbp+k2UjCt2abE0SayylPrjG+slUA73yOZERvz?=
 =?us-ascii?Q?TEqyDJGk8Wy6aRKITlfnuI+2U9E2t+xL+MxCH3eS/+I1IAS5SOeVy0PiKUzq?=
 =?us-ascii?Q?QbkQ5kY9OQgGn0/EG2e9v8TPvXpBBUpGq2VXAifR0SNKgBWz7QNgQuYZtoY8?=
 =?us-ascii?Q?/n8ld1A/HyoqMaF1wK3s3TOAEdv8fffl92xr6uTIWcG2S8YLPTZetW4nGHZI?=
 =?us-ascii?Q?LALehyhtoZRP9a11xYclXP6AJ0pyXzgYZtRizjcn4+eFCl0seRmi3J7gV4ZZ?=
 =?us-ascii?Q?Fp2Vip9FpSPi+nvTjOaiisA6mqy/mecpanPmczNK7+qkB5Bx035nQ7rujbqE?=
 =?us-ascii?Q?+NzEfqzcmwvzAyx5OcfqXhjCnwJUYgX+2hVG732YRsCH5tGJUSJXXqrHaUmh?=
 =?us-ascii?Q?8seVDCYBNtDr+REmGfZn7jI6lY25ycPVbeJeNGlSNTtshCH2LYnOvW1EfDsD?=
 =?us-ascii?Q?GWdEPx1dGpcH9MSkPW95SP5v4X7Rj/5uQaNJklwJYvyQoMqg6SpkRgfVFc1e?=
 =?us-ascii?Q?lsRa2aPp15khwC4S5/s33gnNfybkJNaTT3m+OwY/XjIo0bQVgA2ekOGVRT1m?=
 =?us-ascii?Q?x9X7S1HFBYTaMRA3p4VK4Na3FYG4v7ayBKX53uHs0UgYIxBeWPWnd9WCMzSD?=
 =?us-ascii?Q?DdxkHrLovVZytsAdwqvMeT1rXx6Q2wE4Ciw8X8SghYK/cUJUXhbN111++DSK?=
 =?us-ascii?Q?ERnNKA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 485be0e6-c2a3-4004-894d-08db68f2214f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 14:02:15.4608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PmtlpsX0lGCX0iNyJ1FnUCWfAinPK6791z4HBVEXSz8fUXu6e8y55rWj1CX32mZ6VvU1qNu6Y0sosr4epk3JXnbWDDj5vcNV7+5CHaM2n70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5083
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 10:11:26AM +0100, Russell King (Oracle) wrote:
> Convert mvneta to use phylink's EEE implementation, which means we just
> need to implement the two methods for LPI control, and adding the
> initial configuration.
> 
> Disabling LPI requires clearing a single bit. Enabling LPI needs a full
> configuration of several values, as the timer values are dependent on
> the MAC operating speed.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 95 +++++++++++++++++----------
>  1 file changed, 61 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index e2abc00d0472..c634ec5d3f9a 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -284,8 +284,10 @@
>  					  MVNETA_TXQ_BUCKET_REFILL_PERIOD))
>  
>  #define MVNETA_LPI_CTRL_0                        0x2cc0
> +#define      MVNETA_LPI_CTRL_0_TS                0xff << 8

Hi Russell,

maybe GENMASK would be useful here. If not, perhaps (0xffUL << 8)

>  #define MVNETA_LPI_CTRL_1                        0x2cc4
>  #define      MVNETA_LPI_REQUEST_ENABLE           BIT(0)
> +#define      MVNETA_LPI_CTRL_1_TW                0xfff << 4

Likewise here.

>  #define MVNETA_LPI_CTRL_2                        0x2cc8
>  #define MVNETA_LPI_STATUS                        0x2ccc
>  
> @@ -541,10 +543,6 @@ struct mvneta_port {
>  	struct mvneta_bm_pool *pool_short;
>  	int bm_win_id;
>  
> -	bool eee_enabled;
> -	bool eee_active;
> -	bool tx_lpi_enabled;
> -
>  	u64 ethtool_stats[ARRAY_SIZE(mvneta_statistics)];
>  
>  	u32 indir[MVNETA_RSS_LU_TABLE_SIZE];
> @@ -4232,9 +4230,6 @@ static void mvneta_mac_link_down(struct phylink_config *config,
>  		val |= MVNETA_GMAC_FORCE_LINK_DOWN;
>  		mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG, val);
>  	}
> -
> -	pp->eee_active = false;
> -	mvneta_set_eee(pp, false);
>  }

mvneta_set_eee() seems unused after this patch.
Perhaps it can be removed?

...

