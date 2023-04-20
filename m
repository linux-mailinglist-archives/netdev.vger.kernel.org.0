Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30176E9243
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 13:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbjDTLS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 07:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbjDTLSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 07:18:07 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2091.outbound.protection.outlook.com [40.107.220.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A74EB74D
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 04:14:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7lC0QTGCbBJ7BnZ9owkuadU2Hv4lxSzQnffVvByGtPbxZi77VxuSEjZnK8iiuK5Z/JKQqaCQVBzqWefF6ZeHw08B3QAvz+abtiRJxqDq28zIfMoqS03pqDDjI3mR/Rp1UIJmREiv1cmRtgsTbACFbxMgqJjqmZ24rGCjAB4t8wK4T3d8jjXUlTGAX3yb/MLMtA8nSONK5w4CXu4DKKVsmDkI49DeWqq605eOOgeCdutvh0d5jzyyA0nBD8Y2tSgqtJ/+W7UOUessidxV81tYinJBIzhZkEtEgBrH9CqDCo38AjwQcE/qbnR9+z8ZMs1EvMELdDusHQmAZSk7yNTCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JXzPaGCmFl7d1LGVz8gz0DMyFRbO/WvAbGYYd5p1jOg=;
 b=gayK6MkWlfOCEVRM7pGxbmdCk/+QzBrziAFM4XAP4FutgLyN8JDZbJBxaVFZBEtxEnvA2pj2RTZUbWJ1F8B63Qhp+wR7GbbrckSBvjMD0DY+EwgUBVqi33b6OrKNK+KszCzmrBaTtp3HyGAUXzXXsmGu5TdqojV0odX9H+Z659U0f02nFqA649fCt/uMdqruskWdFPXXxQuSHgL28AU+LfH/ZhSGuovEhb8b4b/lggG2xV03rWxbTiuQbieoMub9wMjvgsiOw4mwoCHfeI37wEJiEDyznIXLmBGfpqdKDtZgg7wWHg9XIAH8N2hRipQL/zDX0hEKMSjo5rYSaEmpTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXzPaGCmFl7d1LGVz8gz0DMyFRbO/WvAbGYYd5p1jOg=;
 b=dKF8jz09u51a6JIgdUIfUvfswjQBuSJkr4p7OMXTpW0ccwZmdtuGq9UVbCW/RfJd7sVxza9x1pUVpvkwOsqXKXYfsOE+jRlP1h/2aX4ZU96XLEvZH8iIPnkZBESc5PEh48xPbn43ZEaU7aIBcpc35+RRCeJNvgzS5evF+idxJKI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3718.namprd13.prod.outlook.com (2603:10b6:610:9e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 11:09:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 11:09:30 +0000
Date:   Thu, 20 Apr 2023 13:09:23 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next 3/5] net/mlx5e: Compare all fields in IPv6
 address
Message-ID: <ZEEdY+qtAQQaFbZP@corigine.com>
References: <cover.1681976818.git.leon@kernel.org>
 <269e24dc9fb30549d4f77895532603734f515650.1681976818.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <269e24dc9fb30549d4f77895532603734f515650.1681976818.git.leon@kernel.org>
X-ClientProxiedBy: AM0PR02CA0073.eurprd02.prod.outlook.com
 (2603:10a6:208:154::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3718:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ebade15-9b72-4091-9e56-08db418fb669
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0fOx5hhGncRaaku6hK28FrDCTwXY2S3Wtif8a256Il8uAIGDnsK/qRla9fdfjgf3xK84FgGlOn+BvuM6yOFm0UV8Cvxs8QydPnHZSuyQ21XzsUlBqz6FoYkMicmyspVUGYMoIXhO7tUyvv9OFfzH6fet8qJ3aQPos6nlMv2DQUWNn9Ltln3/YSEXaY4B2GAqKFcqPsglS73kiELASZF+znSaN/zxDvM/GrXGq4zvk+UYktVmtQtzkJ/pfzCtCKRUiyPF8BitfXFLtE+SD79gW+Pgkei7TeuIwBDERNsuZn2V53QsNsHBfVWFyxEl9/zu9Pwjd9D7tfsZAh7QTNTzLhXRoNJLvGIlRL+qRzAqNCWDuYR3ZF2T9ZVlrmBsVc6AbaP+RLDjFacrblB4Cd1UkHAsWEwEpLKs1xQvlFCuEyi/HiIdxaziY8JnSafwX8VsUZg4POiXaAWw9z4K65REVi9THT25NcSlvDsnOZykIPbloX6xU7mwfm9o1sW8SNWpqFHdG0DZIQdrWo8WHbJpxvaAAHVKs9eF8c76sEfWB5/zetUY20fosBEHa414WhjMEi82c0F10g4hsKxmzvdlkdX2ubea9iKiTPieIy1VW9o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(376002)(136003)(346002)(396003)(451199021)(54906003)(83380400001)(478600001)(2616005)(6506007)(6486002)(6512007)(6666004)(66476007)(66556008)(6916009)(41300700001)(66946007)(4326008)(316002)(186003)(7416002)(5660300002)(44832011)(38100700002)(8676002)(2906002)(8936002)(86362001)(36756003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KmdriXPMXiylSP3AOsIMg4hvy270RmY4LGTTTIunykxXX0RtB9UF0hiDDFkp?=
 =?us-ascii?Q?Foz6l0w+OPEg2Y3E5lHoyRJU0G0THW0XwhbAFrmEh0qVfg1XKL5kJuv3JROM?=
 =?us-ascii?Q?LR8AqXpQGkya2YXvC4sgwDzOiFq2hpKcQe5Yr/VBk+6hkeg9q3ZAnTofY5wn?=
 =?us-ascii?Q?MrbRkS3Y9bSHhI4T1dreKSbiSvEZHKUQXq1MgcJryZF6c6ysSp5Rt4461UuW?=
 =?us-ascii?Q?f31ygoBECa/Ii795rdF2P/lQJxLklOFBtje0yLDkJIKf0mDOzm/3hFsvz2ZF?=
 =?us-ascii?Q?CEZq3pTpDZR70D3ybaB34GJemIUCsTbCkKifjFRo1jL2SgGXa8X2XXvdjhVx?=
 =?us-ascii?Q?Jqv7SII6jNz8SqxilsvtgkGx9RLanl3i0G5kYFMntDlOntGOpE7hBx3sF+Qd?=
 =?us-ascii?Q?eqG41XGav5rROH2S6RXZz+9yIO+ba764wFmutrGW1hT2D8HZNehjQ6/Ph8kz?=
 =?us-ascii?Q?PSeeLc4cq6gOiZMLTGRUW9HAD2Hpu9MZsSyz9jvpz51qm7PayjMOSht/B9kZ?=
 =?us-ascii?Q?NUXC4HHAiHtZKq92EMkFCQBRUhAsaqbkFMvgqEHaWA8KAGy8V9jKPdBlcItt?=
 =?us-ascii?Q?km3RUeuhniEPDlZfFc9CC9zmOJJoGM+fXStI4YKBs84ga7lLWE6+6Eo+4rA6?=
 =?us-ascii?Q?agCWZSuk5qkfFNoZbgq0cYvNHjrTKr+wq0HkWh8MBc1ATcNvbk9SihBYcyfj?=
 =?us-ascii?Q?JBfubz18pmeLV+PKHEnk0m1y8PZWB47IZ2WbncsxtQEFv9vRztIC+FJRa2ea?=
 =?us-ascii?Q?iGU0+hu9wdWYSHlaQN95ghTSkhdOKis+PbNG2kkyYZ5GIji2qM4cJ2waPkpr?=
 =?us-ascii?Q?D91A7LFsHP0DZd87CMkU/WRKp5ELV4cDH8yo/wVPwAQPt7oc4DseKIOpU6R6?=
 =?us-ascii?Q?9d94VXS+Yo0AQcj1aRUajhxeyY/fU9KMJ1nq0IjfStHq5+2lMFuN+OCnh6/Q?=
 =?us-ascii?Q?PQv2ucHBPOmAxUIZDmCJ+ogKGWceEkcKwC44as9kNT7T4wRoEtnzBQBV1iY8?=
 =?us-ascii?Q?g3s8k/jrPJG/4TQXEuvLS0WD21dSPNASGnkWeB+2JdwdHJznjgLjC1xGct40?=
 =?us-ascii?Q?mYgDTf+OjGVRK08fa6/sMBMBqaJrtYUVwBmmWkuYJSO3rX/BAKAtDdakaJHj?=
 =?us-ascii?Q?Oo8aMs3XV3v6NKjefqAZfV4cKa7SFkUqLKBQ6oW357yaWbJrDqT6DqE4nYgf?=
 =?us-ascii?Q?Uo1UbcSC/HQFWyub/jxDX9Pgq02flKlOfNzI81kCK0zcj0LCICTMOaRn2CEK?=
 =?us-ascii?Q?y9D8vKOg1pLZetwjMLSR3aj8HZryzy4M0QjBhpeUKQvbjfh9HZILc2sOgla6?=
 =?us-ascii?Q?60KytqzT4XxbdH/J2e4zpwYO46x+e4lWtyf9/NZFwb+kdLoYRrhYtFWELykd?=
 =?us-ascii?Q?hqhMv/WiAnquiAHSReW08IY1IzAdzuvLVKFo9fVdBi9Zu7w8jOgaRl6YEnVM?=
 =?us-ascii?Q?B4TDpOpCZuXZyTZwnNHKgp8iwcb+bKmPsbHBieYsIPYxB2PR9KlzT1BfHNpS?=
 =?us-ascii?Q?xUKbZuUaMnS56ealospQpO8zNzfvBbUUcz6XVRcgsEUR0gxxhXZW+roRB7CY?=
 =?us-ascii?Q?AJP7oBBP8A5ikrUT5HS+bIlOiykEu2LQ6qbZ3j6nAIBXbspcp0M8YkdB0nBO?=
 =?us-ascii?Q?djAIxXGo9FgmId4tPTmN8VL71Yy3eljO4Jp42DWKsTaktfBHNaQ4Pchr/WCK?=
 =?us-ascii?Q?8quhDQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ebade15-9b72-4091-9e56-08db418fb669
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 11:09:30.3527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: InXPjOZ2ZpGSpSJLNnF/hyqbdzEdjgBGiaOsBChBCPZ3WAuLOd89ynPPK+RvXBZ2d3v9/fGmKOTD2bbsXFxcTbSLyDEFaog+L5MkVWA15Yo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3718
X-OriginatorOrg: corigine.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 11:02:49AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Fix size argument in memcmp to compare whole IPv6 address.
> 
> Fixes: b3beba1fb404 ("net/mlx5e: Allow policies with reqid 0, to support IKE policy holes")
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> index f7f7c09d2b32..4e9887171508 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> @@ -287,7 +287,7 @@ static inline bool addr6_all_zero(__be32 *addr6)
>  {
>  	static const __be32 zaddr6[4] = {};
>  
> -	return !memcmp(addr6, zaddr6, sizeof(*zaddr6));
> +	return !memcmp(addr6, zaddr6, sizeof(zaddr6));

1. Perhaps array_size() is appropriate here?
2. It's a shame that ipv6_addr_any() or some other common helper
   can't be used.

>  }
>  #else
>  static inline void mlx5e_ipsec_init(struct mlx5e_priv *priv)
> -- 
> 2.40.0
> 
