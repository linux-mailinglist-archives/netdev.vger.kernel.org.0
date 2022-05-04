Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8423D5197D0
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345183AbiEDHHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345196AbiEDHHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:07:12 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4D122B38
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:03:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5WSavId0XlZShxraAp7U68TMWTYGXlc5i3ns7XvFYVEiFAKlmnBSATWp6EIrCikTu4aGGLdP/J78hr6Y7Q9/ZzBnI4DSICxIxRPvNq2dag7go38qjH2lLJkO9nx1dyH2fDoo8f4KGw4jWma3sYtUgRyEG3TntX1YljjFYAiMcAzH4+/6TtmgWqV5rTnjRxQw5MM+bKsZbISESaZPf3kWq+es1qbLLIGkZ83lFQIe99yHpGisAFBuvUfsyXBs1WQRJNx733wl654qJ7lCQoOVkfc1psrcB9ad0BXg4bFSTQAWIQ682aMPt5HL0qKhE2fRCVvZpCyNV13+4zO4JTBhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DI6SUVLleVSOWcOV7yWnd2UKBWNU2/a03LcMBYkZPRk=;
 b=PEPjCPKPEwzag4H2p/Sujd6/8AhVnzbBoFUcO6w2gzpSWxoLIVUKDWiyORLFG4H3kHts/sOkyl3/BDMlOrqgbiGcQ5jat9sDQ8PGA207Y56Ri7Xeal26RxU7l7i4yrWfMBoJOa6+4PvGi9bL73Z1AXbSACJ3Sfhy5GR0H5B1XGSk1TiH90isxDsw4HLErR0X77jXEff2jXS7iILyxcoTRnfwOxS2ySrEt49E7aEgEsGZ9hrfJS5xJWefdNSZ1arLxchiIjs3b90gIokYTvm8MM763Hlkpak5OnNB94aYmc7+f/NzQO+BK+PW+YpIwL2KFBEPK2xrGCQ7xFrOdGTiMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DI6SUVLleVSOWcOV7yWnd2UKBWNU2/a03LcMBYkZPRk=;
 b=qtXU15tjhZ6HgFHyo3rPcZIx8tKoMe7MKj5W1jHep8AZUbnH5yLkgg7Qm0ztVZQKbMFA8w7D+Bf8iJE6+aIJAS1DFz9YwPbSsXuJjVvq7q2pCi08SMVzjnzfbq21PLaYZqPDdfKmt2VIkkTK6Zlvcf1nVvs3XmhJZoZ/oRsGpvoVIV94X3Iu4JHBqlzm4ibDppEpKQpw6SpuJnpx3ZxiDyhwMNGrPXxj+I1WVFGnSawrTmy04HZj6/AwceKsSBryp8FM4D2IYBvW7FGzUL7KrHtTLTdd6s7Af67wLhAB/IPt++JXL1VAhby8NlRoi5AbWSteVAuMu/8kowtSH1sCfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by PH7PR12MB6586.namprd12.prod.outlook.com (2603:10b6:510:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.28; Wed, 4 May
 2022 07:03:19 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:03:19 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/15] net/mlx5e: Lag, Don't skip fib events on current dst
Date:   Wed,  4 May 2022 00:02:48 -0700
Message-Id: <20220504070256.694458-8-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504070256.694458-1-saeedm@nvidia.com>
References: <20220504070256.694458-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0012.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::25) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a54712e2-1175-4dc9-f51c-08da2d9c2baf
X-MS-TrafficTypeDiagnostic: PH7PR12MB6586:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB65865B49F07ED475B04E9B86B3C39@PH7PR12MB6586.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Dnr1dUKY0k08kzzW0Gavmvzwe4Rg+BeYy6NOYjn4tHtOT3HgAkTXebJX/eOqlU4H7EWMoAnFH4DLiKQ2qGA+y+rwinchcTQqBzA8ElCq0JTkAaRObqxv+VDbyROWwtrHLkBdqPvOrmi9y+2D4epMQdFTL//OwRuhour0F9x8S7KdKuNhieAiguwyYCOpoejJEOShNxlUPoeAgC44FX86/SgNG8qIl7MPBR/NMR2ef2/gDKTIcLT56Wm+PHbT8tzgG3DK/N1VqES6fS6l9a8ec5WDvg/f5x1xj5abPG0l1eSwmFqHklnIQcvGo8Pfgf5fYvpgtsxpkQD86OaAcIANBKZJRHAgGJG00WKiWwsuYEwnnPYR+Mf9wHrv0472uCgsXTAaZBB795AnWdCxgWTicBkwI0i9tp9o+ppwFm6+p8TnhXi19wTeuK+C93cdJWjlOgv+fTGniFw/C9SwSqGNuLS1JRCD3lc/VGnE+P724fhzaiZffJWfzynve3BRl81LApKse+Brvyubz7eVYUfgB6vgXJNQj7HNu8lbanW5fJ3oEGTqxX6fMExpzsaw5lWW/Vgo5Y6o9sqJk3dek2RGQLG3FrNgZLxumARpQsiBbF6gkY9FAv9lZpwoaF8inw45i9tQ6C5k/hr75HZiUPL6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(86362001)(83380400001)(36756003)(1076003)(107886003)(186003)(66556008)(66946007)(4326008)(66476007)(8676002)(2616005)(2906002)(8936002)(6512007)(6486002)(38100700002)(5660300002)(110136005)(54906003)(6506007)(508600001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hjii67Mk0XBM+nzESQi0Vea/Y+Zh5HzAc3ntjsFFRW65/d7e1efZqffwscqR?=
 =?us-ascii?Q?/7dd4A55fuKFD4Q8uvGCDR4n9RfPU9AzWAh/BCOSHI++XFK/rulFyx+7Oo2W?=
 =?us-ascii?Q?Ewo027zqh1gat+9O7JHBy5wfiRYKHD0yFs9gS1eKoHI9fax/gqP21iZuvIMU?=
 =?us-ascii?Q?6ve+eZ683tOShe+JaP5NktbHQzsRV/MnDzkPJzAB/lyJQd+fWSyx8o7QiNmX?=
 =?us-ascii?Q?uInvx46BuFtJt0vV91TtAyYkRwMVkQX70tb9DPems0+zThnRB9R2Git68uMo?=
 =?us-ascii?Q?oubwulArTaueCIQO6U3uQuHQ05h8qVsIuvovDuuHAMHicFOCXCABzQfAelvE?=
 =?us-ascii?Q?ZhCMzA16glq8Us9gIOsgADyrGQ37VOcVowZ3Ka7pmBoJtmjYjmda8ionKRG8?=
 =?us-ascii?Q?fl6qKMqV6QbvbWYjryEKlAoNMRMiWblRjNfwWZvpxkSyQgTwFG2rHGYDlRtj?=
 =?us-ascii?Q?0My9F9d80vvlyIjOwCJZQDnJQQUaO2Gjzfqt39edWIn2tinKliRkAeoINgzm?=
 =?us-ascii?Q?ZaGarzJW6XJCK72jF6C7ZHd1yu3T8BhRGq5iqlCX7cC4A4kO6ws09+uwhKDZ?=
 =?us-ascii?Q?Qt57ce1vEEqTAHrF9QdGin6n7MqofzJ7+/kDdwOv/0hVJvvhp5HiixJ+gb4Y?=
 =?us-ascii?Q?lLP/A3lgtllpwo2kVccuGEkvzGUaXFDePAPzW79H9g737iocnRtSxhU3hdkL?=
 =?us-ascii?Q?B9oW1OLwLkJBtLau9bOiyhhrgEaibe3WthPSmrwSOo2vRw3Tfrm8Jo1R6LcK?=
 =?us-ascii?Q?WwZcYli/G8eKseX7oqVb5UP+0lTWILUkLIoGGCUukPNuhRGUt8jAYe0eiOVm?=
 =?us-ascii?Q?MVggzwxYx6G762NANRENMjoupqI9FCuSN9L1BU24kDm4xGFbM5rVNVT9Vlfk?=
 =?us-ascii?Q?X8PH+NNsdAUoJMXLcyaF2erU/Wb4qv9ukWnmnt/v/L6ECf7mJBX7TkWekFs8?=
 =?us-ascii?Q?jYvmZJxygp9NCfvzNWnqRNwbVmIJgouKJd9LTDGH4lVkZNQ2anj1h0ZSaWOe?=
 =?us-ascii?Q?h/5Gy1uFJ7k8Gxa4gPfzaYMoYcZ8/HjqmAuVuiCVWTizOlTyxFVSuE3It193?=
 =?us-ascii?Q?v3dyOFpNO2RdHAbpQNYFi7yWSEUxo24O05rE4sWkuxQ0zVabSVPprTAM9wZF?=
 =?us-ascii?Q?hdPM7PJMqLNjw0YCcYondxMaWCv/Q9o+tvEQztrlxHFCgTbmovPtGIlz33Qr?=
 =?us-ascii?Q?+DWY+Z01liVmFQMLQ0tuyDNnWlKSOffleA/lRD5F8LNxsIWoNgwgYTnEH6xd?=
 =?us-ascii?Q?SF+NjUoqyqFiZxhjYTFM6GDHEwxcZ8P/nW3+zkbkfAnSxWWCRFfrfIrdsmBJ?=
 =?us-ascii?Q?ySgPjBWikZ3nT7ZS4au93BX48itcw2FDTTX257bPIhqhCnybGlWy3S4D4TP0?=
 =?us-ascii?Q?bMSMc0zn1QA7BeS1h1VxO92cfc/u14Zk/aJbHw72d+ZEqH/ALYUher3mjf6d?=
 =?us-ascii?Q?GOOrMzbtUiha58rCdVwFb4qCYAaB+ZBoHssf+IexyS6Q8t1zZdj0HcsO/u2F?=
 =?us-ascii?Q?QhoQZcHMUQCdlG7bObYtKOccbnanjEeiOl6nCKh+pJr/hAXAyus7BAoULXmk?=
 =?us-ascii?Q?j6NcjoG5F0pT04j2t0x/SmQMg4FFiSvUJpQZn5zEuqCkcYU/IYtvnfsFT4IY?=
 =?us-ascii?Q?Qx83zwUsFTMo9YkyjRugF0a0NQIecSpMeAw47jdgKljdhdn3ia4kiJhYVvNH?=
 =?us-ascii?Q?hRyqcK1EvT3dzINXQnC5lrvoxaNhbSmEana/BhzL88+CdXn40PTzidpN2h5m?=
 =?us-ascii?Q?ocxS7f/CQz8jQ1+ye0T/o8Im3StsrkOhh+LzHdYaaT/y3sTCTAzI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a54712e2-1175-4dc9-f51c-08da2d9c2baf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:03:19.8685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UoZOP4yj5ukCqywKkUV6kZMoJlXaXnLDkt4/711ZCnqXl3kk2C6dtb8S9Azqwsvqw4UFx2PLPjgQizCGQN5i8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6586
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Referenced change added check to skip updating fib when new fib instance
has same or lower priority. However, new fib instance can be an update on
same dst address as existing one even though the structure is another
instance that has different address. Ignoring events on such instances
causes multipath LAG state to not be correctly updated.

Track 'dst' and 'dst_len' fields of fib event fib_entry_notifier_info
structure and don't skip events that have the same value of that fields.

Fixes: ad11c4f1d8fd ("net/mlx5e: Lag, Only handle events from highest priority multipath entry")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/mp.c  | 20 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/lag/mp.h  |  2 ++
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index 9a5884e8a8bf..d6c3e6dfd71f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -100,10 +100,12 @@ static void mlx5_lag_fib_event_flush(struct notifier_block *nb)
 	flush_workqueue(mp->wq);
 }
 
-static void mlx5_lag_fib_set(struct lag_mp *mp, struct fib_info *fi)
+static void mlx5_lag_fib_set(struct lag_mp *mp, struct fib_info *fi, u32 dst, int dst_len)
 {
 	mp->fib.mfi = fi;
 	mp->fib.priority = fi->fib_priority;
+	mp->fib.dst = dst;
+	mp->fib.dst_len = dst_len;
 }
 
 struct mlx5_fib_event_work {
@@ -116,10 +118,10 @@ struct mlx5_fib_event_work {
 	};
 };
 
-static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
-				     unsigned long event,
-				     struct fib_info *fi)
+static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev, unsigned long event,
+				     struct fib_entry_notifier_info *fen_info)
 {
+	struct fib_info *fi = fen_info->fi;
 	struct lag_mp *mp = &ldev->lag_mp;
 	struct fib_nh *fib_nh0, *fib_nh1;
 	unsigned int nhs;
@@ -133,7 +135,9 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 	}
 
 	/* Handle multipath entry with lower priority value */
-	if (mp->fib.mfi && mp->fib.mfi != fi && fi->fib_priority >= mp->fib.priority)
+	if (mp->fib.mfi && mp->fib.mfi != fi &&
+	    (mp->fib.dst != fen_info->dst || mp->fib.dst_len != fen_info->dst_len) &&
+	    fi->fib_priority >= mp->fib.priority)
 		return;
 
 	/* Handle add/replace event */
@@ -149,7 +153,7 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 
 			i++;
 			mlx5_lag_set_port_affinity(ldev, i);
-			mlx5_lag_fib_set(mp, fi);
+			mlx5_lag_fib_set(mp, fi, fen_info->dst, fen_info->dst_len);
 		}
 
 		return;
@@ -179,7 +183,7 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 	}
 
 	mlx5_lag_set_port_affinity(ldev, MLX5_LAG_NORMAL_AFFINITY);
-	mlx5_lag_fib_set(mp, fi);
+	mlx5_lag_fib_set(mp, fi, fen_info->dst, fen_info->dst_len);
 }
 
 static void mlx5_lag_fib_nexthop_event(struct mlx5_lag *ldev,
@@ -220,7 +224,7 @@ static void mlx5_lag_fib_update(struct work_struct *work)
 	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_DEL:
 		mlx5_lag_fib_route_event(ldev, fib_work->event,
-					 fib_work->fen_info.fi);
+					 &fib_work->fen_info);
 		fib_info_put(fib_work->fen_info.fi);
 		break;
 	case FIB_EVENT_NH_ADD:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h
index 143226753c3a..056a066da604 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h
@@ -18,6 +18,8 @@ struct lag_mp {
 	struct {
 		const void        *mfi; /* used in tracking fib events */
 		u32               priority;
+		u32               dst;
+		int               dst_len;
 	} fib;
 	struct workqueue_struct   *wq;
 };
-- 
2.35.1

