Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A10650AF7
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 12:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiLSLyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 06:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiLSLyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 06:54:11 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2062.outbound.protection.outlook.com [40.107.241.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4EF65C9;
        Mon, 19 Dec 2022 03:54:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nx/neZDftvEcwBCL6uHTCqHZ65g6edcJxm1w03SE2l4cgvww72gUmXN3vRWOfoeV2MV0LJsJu7rPb9ZhTCLCDi2tK4kKTktxjxAjdRASDng3g6fEIjP5EZyLruwYIq1tO66KDX2AC0mxUyhVFN2UYdy4kKs4g+WZa/N78wzErESXOxww4R2BuxeOA+5bNfO4tJUZtkRksAsGUssc84/JiGJEHaPy2kqjwk0GGmF5BebYS/AR/WQdt+pH8DkKclHZ13pkDED6jyvzJElKPkV3Ktt5QA0ZY+yCm7PO0iKvxERcVgbdZCnVCiMBXowEI1BVfnGDcRewWjoso3Bf8yfhYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uYWF5rmGiub9ctQcYYtDRQmJJNUJSxF9VvbR4UIOqQ0=;
 b=HgoeGI7mpvtgAD4mOytWbVHM3WU1WIOyd0cU9IjMHOhi6SIXpZ46iTtD7hmWpqogYJKLC1qw5z81AUgd1oP1vjnckNmZ6m9Rx30K/V336hlobaVtosiIsE1mAFVyz11r+7BCxyATlah+MvhS/Q97UPmCJJ7OlfCIWkqzWHzdBaJ+P89nMS+QoW2HpGbGyyZZZD7NEnVN0qmlwRbXT3ZGnnURCN7Riz3/7HyIkRJDCyOYxo+B3ZDI7enTqAT3xiaXqJJwzbnm7Ti08FMCUl9QOgJujbVxzMiELaQMnLWPWIxpfFLPIFgdLzkYCbSRHwwh+FTLae50jF0pVhCUzkYSgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYWF5rmGiub9ctQcYYtDRQmJJNUJSxF9VvbR4UIOqQ0=;
 b=cTVMOuenowb2GESokx2gDN7+JjERIW3/W/8Bkh/jRaNSko05Bu5W479Et7FAW7qkNspPO9xuqomzJcm+xDs1LtHgAAQydgb0bLHEgmZlsB46CroYuqxo4MLH30dwyUuzF1SFwnDqws2VOgJUNpNct7kdTyPFywbTDxwKTu8D10Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6983.eurprd04.prod.outlook.com (2603:10a6:20b:102::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 11:54:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::7c13:ef9:b52f:47d8]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::7c13:ef9:b52f:47d8%6]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 11:54:07 +0000
Date:   Mon, 19 Dec 2022 13:54:02 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 41/46] net: dpaa2: publish MAC stringset to
 ethtool -S even if MAC is missing
Message-ID: <20221219115402.evv5x2dzrb7tlwmn@skbuf>
References: <20221218161244.930785-1-sashal@kernel.org>
 <20221218161244.930785-41-sashal@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221218161244.930785-41-sashal@kernel.org>
X-ClientProxiedBy: AM4PR0101CA0073.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::41) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB6983:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b724bfa-c9e5-4562-0415-08dae1b7bb8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FPCfpXtutBVu65uZXfK2VqYtYnRCgbd5g02HNlYbU9ClsaUwY9SN1u2EG6xI8oMxGxIkv9r+z7moRVtFGNAgLZZGYvrdJByK70IdiXZfNt7LG3qw7eHmTecEt8Pkz209c2MzOT8maX/K6pnDOwSL3mgga3AhGhCYvxoh4N0mVh3zy7tT4THCUOxwrBEm19wnVB8ixLlYKukk1HZKMzWW4CC08HHqbCU494v9QdPpKeMgIxnBwJT0mG1sxPEK86SCPBZcY1p9QMvg1WkxoHp4e5x5vU9gUCoYp+LFXxDD2l4MvPOhu0enFQ2DCScW9l1mrJ56O017CMkVtdY+kSC39b/doQYj8HvQlLmuJJfdjG7yRQlPCTymo9lVYPJ/nPBJ0DTEhv0LkCLPEK2MiZ0eU3Eo8gT8oHLwQHbtJZFFuHXM9Y0wN8tGC0N56Sy9Nj/fH6a6DfW3cx7XGv5F6tyHCZjjsgwO79+9+SNnsFPEYtRc/KeB6hNa35aYv4xk04H70QFRJOALOqmPCtSte7mIyY1m0YqcsXu47A8nh01S3bX/DVQMzt2ejUGCrWgAIw6HKF0EeHsfrZqteUQ3zpZbHoAExhBJV7ksHY1+8VE8kpzpo32swWOWyJ5HudN+2jzysY/KJnB/pmMlGs0E+Dd6adTbPwRsRPfslwh7NmkJmR4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199015)(478600001)(6666004)(33716001)(966005)(2906002)(186003)(4326008)(8676002)(83380400001)(38100700002)(1076003)(6486002)(44832011)(6512007)(9686003)(6506007)(26005)(316002)(54906003)(5660300002)(6916009)(8936002)(66946007)(86362001)(66556008)(66476007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y9iUhzkDqyeW5vIWG8e23T4npJAR3rznor7UNMU/+Vl7t/AkoevJ2D3fzOXS?=
 =?us-ascii?Q?OLzvqRQV3iCgdP+9k7YFRlKha023uQpa88/x7Xy168gXiKLmdwUS5/fOKV7k?=
 =?us-ascii?Q?EJInOBNl5L5SL2euFykgM3G4roNABz8MyulOC/8LvZi2ywtIWOxnKKQwO3Cc?=
 =?us-ascii?Q?G7lyScAnxSvCvfbVw4PnVWBg93KOvqJoRo3LmuKvXxUjR5pgq7aArqyGMw7o?=
 =?us-ascii?Q?KNcNX8o83+vJNmRiL262r+PvyrNrGyEyzPHbFbwkHtSX6ZNC3TYMf+ucrGlO?=
 =?us-ascii?Q?AG/DZl+we21lvvDDwX+kSZrYVuWGMv3/04+Z1UX0z6+YA92AxMNWNz3CVuez?=
 =?us-ascii?Q?OXn4I9qgAwAR4LN8IPNum/3ZLjD00yzkC9bJxV6A8hbXjsFGY4uxK2Wt9pxX?=
 =?us-ascii?Q?uNuicvfv+yu4dhvFTNulAHna7E0dAvTnAVtarhzEDXzhO40Pl+oFAOnDRduL?=
 =?us-ascii?Q?BRjrtLKBVLwal+itu+ON/z+dzaMp9R6Csy/f/X/VmEzusqkpMh/jKXsxwpEa?=
 =?us-ascii?Q?sP6MowPtu0U/XCrR6jSGGP+9QzDfW3XKAuWR7nlU85YaOM7niWR0PZrOPBXt?=
 =?us-ascii?Q?fO009/of/gJjfUe1YFozrvPuQPBoFhSkhVEQ1CocjpqtIiN92rqA1TYDv8Gf?=
 =?us-ascii?Q?/fEtKP8RZia7Xgk+l8Qv3K5ZoOfnAi5peUHmRgsZ8nXd4KoFTcGEYd0yjGaj?=
 =?us-ascii?Q?v4WtIJiD2jhW33jx2vbkFoA530lbreIIkNyDh5C4dJ8XlEgudWyctVgwR8cI?=
 =?us-ascii?Q?O55qpjFGBLN086xnDR1q0eD252mu18sv5a8Rkb2325ENbGCgxp1clO2nyqQq?=
 =?us-ascii?Q?57dlXdyfVc0+okmMg7pMC1RHyVAJUzN5/EZ5YTzuPCiaKqdpM8GZD9dl7aqo?=
 =?us-ascii?Q?yx/ADWUkmewx9YL+L4mOYxF3p54/FjEd2cNQvC7esAmskL1YZdD5Ta8JU0VF?=
 =?us-ascii?Q?h2N1ZsyxiP+UVXBHTrGAnPHvP/qgGDeqjVZAY6+IIt3Hz1Pd1OY4X0bhRD1f?=
 =?us-ascii?Q?P+DSLfOZVZCVWRF7aCgz8DUmcsp0Xd0Oa77Az2bvG6CL++7IO+w2H0vB5F4Z?=
 =?us-ascii?Q?BAB9zuM6Kqz+3POEpyn8GOifmmAy9ylch/6UHf73EZlSEW82MjWnldQgNhjc?=
 =?us-ascii?Q?rZIMzldt8J72BNLv8odKI+SjZczHXDwYOIBTqB3EKoTH+Q2ktiRIANzuuNcM?=
 =?us-ascii?Q?u2iPqTZCRPxLKqD3wMSlT9s0okEooSzCfFzYA2e+snKFx9PozJoxY0rM0xq+?=
 =?us-ascii?Q?U2hRFeJ78CRgfPIbXaLSg8rCgyr52YqlJ9MImNVAYiuUmEaLxMmOQePUaOD5?=
 =?us-ascii?Q?DOew+DZ103vkWNHAuZbMqxoeUiGmMfDEXwi7vn0WKe571lSC2HwOmTcEqYxa?=
 =?us-ascii?Q?wLaKXWiNDGt4aEoAT+Ix1wCTeoeo1rmhb+Ka3+Czd2eCnVES9WG3lwWDxqJV?=
 =?us-ascii?Q?/V+eY25R9+oDbZie1GiGEHsKW/2+e5JxdrIuCc/ZmqNvTNNoVXTy5aEc4o25?=
 =?us-ascii?Q?PG+e1H+pItbYP0EaaRLflFHjuuJ277qQNhyZaqE3Wd0/aeApqXNLTIUs87iX?=
 =?us-ascii?Q?jViI/vCmocDVSzquFcDwvpOCovAdRBk4EnrvZhplzwv6OIUSuQ0mB/KL0pO4?=
 =?us-ascii?Q?Dw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b724bfa-c9e5-4562-0415-08dae1b7bb8b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 11:54:07.0404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gw6ef2rsyaZeLEkI/kQITS7hI+4+oVxvre3hkqvKdxNVBTJ2TIbPtDKnjYyKxaC+dxJV9NOnl4b3X2JWQ+M3Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6983
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha,

On Sun, Dec 18, 2022 at 11:12:39AM -0500, Sasha Levin wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [ Upstream commit 29811d6e19d795efcf26644b66c4152abbac35a6 ]
> 
> DPNIs and DPSW objects can connect and disconnect at runtime from DPMAC
> objects on the same fsl-mc bus. The DPMAC object also holds "ethtool -S"
> unstructured counters. Those counters are only shown for the entity
> owning the netdev (DPNI, DPSW) if it's connected to a DPMAC.
> 
> The ethtool stringset code path is split into multiple callbacks, but
> currently, connecting and disconnecting the DPMAC takes the rtnl_lock().
> This blocks the entire ethtool code path from running, see
> ethnl_default_doit() -> rtnl_lock() -> ops->prepare_data() ->
> strset_prepare_data().
> 
> This is going to be a problem if we are going to no longer require
> rtnl_lock() when connecting/disconnecting the DPMAC, because the DPMAC
> could appear between ops->get_sset_count() and ops->get_strings().
> If it appears out of the blue, we will provide a stringset into an array
> that was dimensioned thinking the DPMAC wouldn't be there => array
> accessed out of bounds.
> 
> There isn't really a good way to work around that, and I don't want to
> put too much pressure on the ethtool framework by playing locking games.
> Just make the DPMAC counters be always available. They'll be zeroes if
> the DPNI or DPSW isn't connected to a DPMAC.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

I think the algorithm has a problem in that it has a tendency to
auto-pick preparatory patches which eliminate limitations that are
preventing future development from taking place, rather than patches
which fix present issues in the given code base.

In this case, the patch is part of a larger series which was at the
boundary between "next" work and "stable" work (patch 07/12 of this)
https://patchwork.kernel.org/project/netdevbpf/cover/20221129141221.872653-1-vladimir.oltean@nxp.com/

Due to the volume of that rework, I intended it to go to "next", even
though backporting the entire series to "stable" could have its own
merits. But picking just patch 07/12 out of that series is pointless,
so please drop this patch from the queue for 5.15, 6.0 and 6.1, please.

Thanks!
