Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB3D520D70
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236951AbiEJGCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236952AbiEJGCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:02:18 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E77F291E67
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:58:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hxe1rkvukQ02SIdXVFL2wCT7DSH3K1OtXtpq8+NGnJpqaK5KIChTMSqJ1AvTFBeQMtTma4HaBj1kw9/fEpzmDnD46qBMUIHSmMODTlWXHpbShZO2Vf54059gDR6vpyDFmmF4ftcnbU1w1mpV4wkHXtEEmBHaOJshBrGtlsGdJYZmogme4oa9zyZGQj8PlZ08JyAFn8dDmxLCXeOMTKl9rhtViyBUjuSBy8ox/ymmYalJpDpGod5/oMQT/Hh408xxNB8UNXdt0x1P4WzxOTGsfWdjo9vcm4uNepH80DYREirV6cDP/D9JDwbfvjpIfvMJClYX6HT13tHI1e3UP73qqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJvIwVMnDjjkFSTPgiHqkPxRnqVxzFcOFHNnJssNzzo=;
 b=Lk8Z+SNZwRQfSQDxZf8mphfprjoVRcvHoV8wxA8FilHjdnzpCHkzNYZZjXEd7I0j/dELm+aStJv8DWK77i7ZnQgeqHwCAycS5IB44YpAyOPmX1VQ8aBJ65wmvKwoL7kUrOTbIz3i3Oa0GqL+9l4JwGRKkiTXs6BYmDBghv0Je6ozqdEthaImvbAngtxpwOySElB5CLDDvuUrumwI6VZCyO1UJIz8n67SuUFRGjDI5//59DujSMuudu4FDIZmX+XUl0lh58kMDtMadH6zsmQBi+PY6/YZkfuOzbeMlaGdRNzobuhR0FAsBO5nGsjnC86AqxPh+1p89fNsCP0SHKj7Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJvIwVMnDjjkFSTPgiHqkPxRnqVxzFcOFHNnJssNzzo=;
 b=b/LhN74STEo6zJyApx7iBwN+k8+h/Tm8NS7agMtZhERmb9TJSFkINWGW34nOMQMXpwMBeVC9gfPB7dM1BGqwZahV8oCMC9Z+RmnRAaDeDoDVquTJuwpaa212ZawLr4TxlnN1VnYVCYo0SwlsXBkzhnZdrWCakk3fSJt5b7Cj98E/QtHsyb73PIdsLni2xOnLfI3RLqj4zb7diDs0euzUtqmSTjshmufLiZJzEVzkunP6cul00QVXgij77s6CwG6yTTzu401WHoM1Qq/b8X3/EdIuzPI/wrT3zVswO8uVdzK6+iSA5sKpvRMgMwA35uB4wGuu868Vf675q4bbOMmCIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DM6PR12MB3882.namprd12.prod.outlook.com (2603:10b6:5:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 05:58:16 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 05:58:16 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5: Lag, use buckets in hash mode
Date:   Mon,  9 May 2022 22:57:42 -0700
Message-Id: <20220510055743.118828-15-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510055743.118828-1-saeedm@nvidia.com>
References: <20220510055743.118828-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:a03:40::20) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58d4811f-6b93-4d5d-4867-08da324a135d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3882:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB38822A108FCC4014160CFCA1B3C99@DM6PR12MB3882.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c/iP6WvOsq+r0JX8Z35SXjCfI7cv8HPZ2z8w7WlSa2ULnfirrM+d1hWjbjKOFQ/UXhVVGW3RtwyvL7jBnZxN92G+JeOvtlZ/2AHQmyznvsDeUqlZ/DBCpw63rVrd26I4bsyley22qGllxXkEreBE8VTPGKzQLdw+cttHbxkQ7rAd+w/co3LIgSodreG38OcMT2B0TcA4XoH+tTEoYk9tnLEbb83Ym4Xl4XOFvItLiaY7qe8R4ota1r3+68NP+zXjOdi/yyBY/UlC/BmR0fbcnVbovLhwknlBZEGpfy0Hlox9Ebt/fJUsoMx/EO+964gHy0lvMVdcAtULmRz1OcHu3qvvaMeGBRJDQ9VQGczHl0Fz6UOT2CkVTW9mo0LjpDCqjj/aISJCXWxwo7wUUeijF/L6WTueKkFYJI99xvE5COLqMb3MwKvCa6jb41gInM7Hk8ZH7ULIAkVSkjmWOb95+UTfibchCXMD6N7YOlLa378WgFcerDFnMlaufaWJa1tOHD3dP4yTyqBEzn5OLnmrUh7fbtsiVi33QgYfF+Y9KvmOiLho+1UkWvAg2b1Xx4Iy5VlguOxLDU+mLBV9sxxfBOyBmX6oQdPVbevg0bwaK0KLTtfU8hxKRj+dpos3uEOmTioyntaD6WtrVzJeUtOQMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(2906002)(38100700002)(508600001)(36756003)(5660300002)(8676002)(30864003)(186003)(83380400001)(66556008)(110136005)(8936002)(2616005)(316002)(107886003)(66946007)(4326008)(54906003)(66476007)(86362001)(1076003)(6666004)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FQNVYUFbvPQsRqRcbUtC2w8GoBOQIvRWPdjw6BXDEgfURZX8kKd40WDnEQMH?=
 =?us-ascii?Q?aMnUx4/am2Ikqn7qiqvfWmen8nt98qnCOwxB/MMRyZuV9UG0a904NbETxAVe?=
 =?us-ascii?Q?fpxvuQ74bghd+N1NvNDxJpllaoZKY4GdENIfKkHTyensX2g755fGH8S2K0RI?=
 =?us-ascii?Q?oChjKpobNIcF0zPR6fhftMiE9IUN0mB86+lmwSfB/cUHvQqifsjCX6FcPCby?=
 =?us-ascii?Q?N/1gJ3sAqBEgZstVGQ9Ok4bwNT3/8HeanNeHFa4985tZ0gYzk6DA7HFZFG5P?=
 =?us-ascii?Q?PyMNAU9Nr04M3/NSDTdc3pCtjX4MvO4Lvpb3AVWKBOakZmhJXq478nkJ/hQz?=
 =?us-ascii?Q?0yIj7I/LhInOvEIMeHqut5kOkO3WwxByXTpVxKfTCAxSJPELqmf/VoOb/dRZ?=
 =?us-ascii?Q?6SzgywkQBgeb1TCMSsMhht4NbZHcjN5Tk8jFFp/WivgclFQcy3zIgBWI60oM?=
 =?us-ascii?Q?eLnkrNvxrxhHsjXV5PVYAhAESyetv9Vbaph266ve3dBpI0KWVN4vUrKaywp5?=
 =?us-ascii?Q?jUFDvonZZ+pJTE/0oXDQx5RrONAoctVMbiErloGfbuMXjwFlaRpcNWnEoru0?=
 =?us-ascii?Q?xmogepe5uLuZblIH9rqoortcmSM4SdfjqrDR792xT9uAU/KeF7chjptIfnnB?=
 =?us-ascii?Q?5akd745E9jdwFbP2DGnIEAQE70UjYUqRD5P9NSAOGfcXsS+7At/rGqPu/bIx?=
 =?us-ascii?Q?Z0t+6g/PuFgRP8Wn/jRvbUxLURw4cFamCoFr/QaUhZjJ2s5c1yetKKmCE3fl?=
 =?us-ascii?Q?pTizWMgmVpDQ7oW5uy7B9qxMlar8/FNMJOldDPBoC/Jvc+HwmPeSZYJEFZbU?=
 =?us-ascii?Q?2L1wifktLGYCzMjf+RWuIR6r+5jssRsUSWRRDy1S7t0aX9vFl76kOGhuInVh?=
 =?us-ascii?Q?9o5l1tYWS7F5R7pu2ASBq2bqHr3omwRC0a7evpsYgNbKHu8WvDD6y3jmkQiz?=
 =?us-ascii?Q?T+ih2BNGwV4Wluvl0Qo9+MpVcGd2HepQqPVPVt1Y+Zu6fgAeQ5O3TKLdMlrn?=
 =?us-ascii?Q?v3FhmcjZu+o3mlwWPz/CrOU9lmSm1t4/w2zC35BrpXKE+ehHXY7a8xx2ppHS?=
 =?us-ascii?Q?3ySimJBDHYzvieVdjNLntUmL0WTq1tOzz2hT05B/oSyN0JpkTJV9eAYjczqC?=
 =?us-ascii?Q?sePYXQXXddxaSsZo2y2VsTzkVCGUY3p8kAk7MM2/HPGYDhc4Xo7ZPWQ6ORZZ?=
 =?us-ascii?Q?K5K9eZFtcG5Q/RlR6copizbV7lJIp442iUI5xshEJQdu2V4v92CigcNh4BmV?=
 =?us-ascii?Q?avOyzJlphjLbKNJ/ugNK6O0ZfUl5SPXdXIwtA0uEXTZp/xshWk5MpkbB5Bfs?=
 =?us-ascii?Q?9KA5e3KILylUhDMul6O9mJLtD0ET2eTv72wvkTjkB+Rj8O1EL7fKIbj3/9A8?=
 =?us-ascii?Q?cM1iPxh/Om4laVWsvaQ5zGmUvuCbZT5PNINZAu4Ms1m43TgHQod/8gDQvPGp?=
 =?us-ascii?Q?Zcc/s9xb7V70my2hBag0MX7ZHas6yUDxxRRm7ru3i4NBZAOA/lG2VJBEWeC9?=
 =?us-ascii?Q?ey9wjzwOTzYNag7XXFn+YbUff2qOxGlGXK7Rg6aWAY1uojdLGGJT/+h2ij7J?=
 =?us-ascii?Q?XxYXTS4hWv4A4JwN2wR5Bqzo4J4Fp7ji+iCZ9JJ9v7gDoNHUt5ZOV+DdpZFh?=
 =?us-ascii?Q?aBhDYvgdlZYUrt+j5NqdR3kuK/4nfVtuEV2t3rtBP9lw99rHtLq7RXENg2hi?=
 =?us-ascii?Q?sr/zMM+laIS3pqdWrAdBBXanz7oK57R3aCu3+AfKU8NyefOF+h6XvCVOgbhb?=
 =?us-ascii?Q?j4cakqAShtrHFrNALmh/SdAY4Qla9Uvd/AaBafysE+RKlZqChcVj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58d4811f-6b93-4d5d-4867-08da324a135d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 05:58:16.2696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iNdlBS7l9G4Trid9iR65UgMIiWkBAxY/pfvq5opnmT6j14h9yMH6QpKfUK4h73DOnqDrqSvlSiWdGYjVNCaVSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3882
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

When in hardware lag and the NIC has more than 2 ports when one port
goes down need to distribute the traffic between the remaining
active ports.

For better spread in such cases instead of using 1-to-1 mapping and only
4 slots in the hash, use many.

Each port will have many slots that point to it. When a port goes down
go over all the slots that pointed to that port and spread them between
the remaining active ports. Once the port comes back restore the default
mapping.

We will have number_of_ports * MLX5_LAG_MAX_HASH_BUCKETS slots.
Each MLX5_LAG_MAX_HASH_BUCKETS belong to a different port.
The native mapping is such that:

port 1: The first MLX5_LAG_MAX_HASH_BUCKETS slots are: [1, 1, .., 1]
which means if a packet is hased into one of this slots it will hit the
wire via port 1.

port 2: The second MLX5_LAG_MAX_HASH_BUCKETS slots are: [2, 2, .., 2]
which means if a packet is hased into one of this slots it will hit the
wire via port2.

and this mapping is the same of the rest of the ports.
On a failover, lets say port 2 goes down (port 1, 3, 4 are still up).
the new mapping for port 2 will be:

port 2: The second MLX5_LAG_MAX_HASH_BUCKETS are: [1, 3, 1, 4, .., 4]
which means the mapping was changed from the native mapping to a mapping
that consists of only the active ports.

With this if a port goes down the traffic will be split between the
active ports randomly

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 154 +++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |   4 +-
 .../mellanox/mlx5/core/lag/port_sel.c         |  95 +++++++----
 .../mellanox/mlx5/core/lag/port_sel.h         |   5 +-
 4 files changed, 182 insertions(+), 76 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 90056a3ca89d..8a74c409b501 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -107,14 +107,73 @@ int mlx5_cmd_destroy_vport_lag(struct mlx5_core_dev *dev)
 }
 EXPORT_SYMBOL(mlx5_cmd_destroy_vport_lag);
 
+static void mlx5_infer_tx_disabled(struct lag_tracker *tracker, u8 num_ports,
+				   u8 *ports, int *num_disabled)
+{
+	int i;
+
+	*num_disabled = 0;
+	for (i = 0; i < num_ports; i++) {
+		if (!tracker->netdev_state[i].tx_enabled ||
+		    !tracker->netdev_state[i].link_up)
+			ports[(*num_disabled)++] = i;
+	}
+}
+
+static void mlx5_infer_tx_enabled(struct lag_tracker *tracker, u8 num_ports,
+				  u8 *ports, int *num_enabled)
+{
+	int i;
+
+	*num_enabled = 0;
+	for (i = 0; i < num_ports; i++) {
+		if (tracker->netdev_state[i].tx_enabled &&
+		    tracker->netdev_state[i].link_up)
+			ports[(*num_enabled)++] = i;
+	}
+
+	if (*num_enabled == 0)
+		mlx5_infer_tx_disabled(tracker, num_ports, ports, num_enabled);
+}
+
 static void mlx5_lag_print_mapping(struct mlx5_core_dev *dev,
-				   struct mlx5_lag *ldev)
+				   struct mlx5_lag *ldev,
+				   struct lag_tracker *tracker,
+				   u8 flags)
 {
+	char buf[MLX5_MAX_PORTS * 10 + 1] = {};
+	u8 enabled_ports[MLX5_MAX_PORTS] = {};
+	int written = 0;
+	int num_enabled;
+	int idx;
+	int err;
 	int i;
+	int j;
 
-	mlx5_core_info(dev, "lag map:\n");
-	for (i = 0; i < ldev->ports; i++)
-		mlx5_core_info(dev, "\tport %d:%d\n", i + 1, ldev->v2p_map[i]);
+	if (flags & MLX5_LAG_FLAG_HASH_BASED) {
+		mlx5_infer_tx_enabled(tracker, ldev->ports, enabled_ports,
+				      &num_enabled);
+		for (i = 0; i < num_enabled; i++) {
+			err = scnprintf(buf + written, 4, "%d, ", enabled_ports[i] + 1);
+			if (err != 3)
+				return;
+			written += err;
+		}
+		buf[written - 2] = 0;
+		mlx5_core_info(dev, "lag map active ports: %s\n", buf);
+	} else {
+		for (i = 0; i < ldev->ports; i++) {
+			for (j  = 0; j < ldev->buckets; j++) {
+				idx = i * ldev->buckets + j;
+				err = scnprintf(buf + written, 10,
+						" port %d:%d", i + 1, ldev->v2p_map[idx]);
+				if (err != 9)
+					return;
+				written += err;
+			}
+		}
+		mlx5_core_info(dev, "lag map:%s\n", buf);
+	}
 }
 
 static int mlx5_lag_netdev_event(struct notifier_block *this,
@@ -174,6 +233,7 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 		mlx5_core_err(dev, "Failed to init multipath lag err=%d\n",
 			      err);
 	ldev->ports = MLX5_CAP_GEN(dev, num_lag_ports);
+	ldev->buckets = 1;
 
 	return ldev;
 }
@@ -200,28 +260,25 @@ static bool __mlx5_lag_is_sriov(struct mlx5_lag *ldev)
 	return !!(ldev->flags & MLX5_LAG_FLAG_SRIOV);
 }
 
-static void mlx5_infer_tx_disabled(struct lag_tracker *tracker, u8 num_ports,
-				   u8 *ports, int *num_disabled)
-{
-	int i;
-
-	*num_disabled = 0;
-	for (i = 0; i < num_ports; i++) {
-		if (!tracker->netdev_state[i].tx_enabled ||
-		    !tracker->netdev_state[i].link_up)
-			ports[(*num_disabled)++] = i;
-	}
-}
-
+/* Create a mapping between steering slots and active ports.
+ * As we have ldev->buckets slots per port first assume the native
+ * mapping should be used.
+ * If there are ports that are disabled fill the relevant slots
+ * with mapping that points to active ports.
+ */
 static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
-					   u8 num_ports, u8 *ports)
+					   u8 num_ports,
+					   u8 buckets,
+					   u8 *ports)
 {
 	int disabled[MLX5_MAX_PORTS] = {};
 	int enabled[MLX5_MAX_PORTS] = {};
 	int disabled_ports_num = 0;
 	int enabled_ports_num = 0;
+	int idx;
 	u32 rand;
 	int i;
+	int j;
 
 	for (i = 0; i < num_ports; i++) {
 		if (tracker->netdev_state[i].tx_enabled &&
@@ -231,9 +288,14 @@ static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
 			disabled[disabled_ports_num++] = i;
 	}
 
-	/* Use native mapping by default */
+	/* Use native mapping by default where each port's buckets
+	 * point the native port: 1 1 1 .. 1 2 2 2 ... 2 3 3 3 ... 3 etc
+	 */
 	for (i = 0; i < num_ports; i++)
-		ports[i] = MLX5_LAG_EGRESS_PORT_1 + i;
+		for (j = 0; j < buckets; j++) {
+			idx = i * buckets + j;
+			ports[idx] = MLX5_LAG_EGRESS_PORT_1 + i;
+		}
 
 	/* If all ports are disabled/enabled keep native mapping */
 	if (enabled_ports_num == num_ports ||
@@ -242,9 +304,10 @@ static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
 
 	/* Go over the disabled ports and for each assign a random active port */
 	for (i = 0; i < disabled_ports_num; i++) {
-		get_random_bytes(&rand, 4);
-
-		ports[disabled[i]] = enabled[rand % enabled_ports_num] + 1;
+		for (j = 0; j < buckets; j++) {
+			get_random_bytes(&rand, 4);
+			ports[disabled[i] * buckets + j] = enabled[rand % enabled_ports_num] + 1;
+		}
 	}
 }
 
@@ -317,28 +380,33 @@ static int _mlx5_modify_lag(struct mlx5_lag *ldev, u8 *ports)
 void mlx5_modify_lag(struct mlx5_lag *ldev,
 		     struct lag_tracker *tracker)
 {
+	u8 ports[MLX5_MAX_PORTS * MLX5_LAG_MAX_HASH_BUCKETS] = {};
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
-	u8 ports[MLX5_MAX_PORTS] = {};
+	int idx;
 	int err;
 	int i;
+	int j;
 
-	mlx5_infer_tx_affinity_mapping(tracker, ldev->ports, ports);
+	mlx5_infer_tx_affinity_mapping(tracker, ldev->ports, ldev->buckets, ports);
 
 	for (i = 0; i < ldev->ports; i++) {
-		if (ports[i] == ldev->v2p_map[i])
-			continue;
-		err = _mlx5_modify_lag(ldev, ports);
-		if (err) {
-			mlx5_core_err(dev0,
-				      "Failed to modify LAG (%d)\n",
-				      err);
-			return;
-		}
-		memcpy(ldev->v2p_map, ports, sizeof(ports[0]) *
-		       ldev->ports);
+		for (j = 0; j < ldev->buckets; j++) {
+			idx = i * ldev->buckets + j;
+			if (ports[idx] == ldev->v2p_map[idx])
+				continue;
+			err = _mlx5_modify_lag(ldev, ports);
+			if (err) {
+				mlx5_core_err(dev0,
+					      "Failed to modify LAG (%d)\n",
+					      err);
+				return;
+			}
+			memcpy(ldev->v2p_map, ports, sizeof(ports));
 
-		mlx5_lag_print_mapping(dev0, ldev);
-		break;
+			mlx5_lag_print_mapping(dev0, ldev, tracker,
+					       ldev->flags);
+			break;
+		}
 	}
 
 	if (tracker->tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP &&
@@ -357,6 +425,8 @@ static int mlx5_lag_set_port_sel_mode_roce(struct mlx5_lag *ldev,
 		if (!MLX5_CAP_PORT_SELECTION(dev0->dev, port_select_flow_table))
 			return -EINVAL;
 		*flags |= MLX5_LAG_FLAG_HASH_BASED;
+		if (ldev->ports > 2)
+			ldev->buckets = MLX5_LAG_MAX_HASH_BUCKETS;
 	}
 
 	return 0;
@@ -370,6 +440,7 @@ static int mlx5_lag_set_port_sel_mode_offloads(struct mlx5_lag *ldev,
 	if (MLX5_CAP_PORT_SELECTION(dev0->dev, port_select_flow_table) &&
 	    tracker->tx_type == NETDEV_LAG_TX_TYPE_HASH)
 		*flags |= MLX5_LAG_FLAG_HASH_BASED;
+
 	return 0;
 }
 
@@ -399,7 +470,7 @@ static int mlx5_create_lag(struct mlx5_lag *ldev,
 	u32 in[MLX5_ST_SZ_DW(destroy_lag_in)] = {};
 	int err;
 
-	mlx5_lag_print_mapping(dev0, ldev);
+	mlx5_lag_print_mapping(dev0, ldev, tracker, flags);
 	mlx5_core_info(dev0, "shared_fdb:%d mode:%s\n",
 		       shared_fdb, get_str_port_sel_mode(flags));
 
@@ -439,11 +510,12 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	int err;
 
-	mlx5_infer_tx_affinity_mapping(tracker, ldev->ports, ldev->v2p_map);
 	err = mlx5_lag_set_port_sel_mode(ldev, tracker, &flags);
 	if (err)
 		return err;
 
+	mlx5_infer_tx_affinity_mapping(tracker, ldev->ports, ldev->buckets, ldev->v2p_map);
+
 	if (flags & MLX5_LAG_FLAG_HASH_BASED) {
 		err = mlx5_lag_port_sel_create(ldev, tracker->hash_type,
 					       ldev->v2p_map);
@@ -1265,7 +1337,7 @@ u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
 		}
 	}
 
-	port = ldev->v2p_map[port];
+	port = ldev->v2p_map[port * ldev->buckets];
 
 unlock:
 	spin_unlock(&lag_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 1c8fb3fada0c..0c90d0ed03be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -4,6 +4,7 @@
 #ifndef __MLX5_LAG_H__
 #define __MLX5_LAG_H__
 
+#define MLX5_LAG_MAX_HASH_BUCKETS 16
 #include "mlx5_core.h"
 #include "mp.h"
 #include "port_sel.h"
@@ -46,9 +47,10 @@ struct lag_tracker {
 struct mlx5_lag {
 	u8                        flags;
 	u8			  ports;
+	u8			  buckets;
 	int			  mode_changes_in_progress;
 	bool			  shared_fdb;
-	u8                        v2p_map[MLX5_MAX_PORTS];
+	u8			  v2p_map[MLX5_MAX_PORTS * MLX5_LAG_MAX_HASH_BUCKETS];
 	struct kref               ref;
 	struct lag_func           pf[MLX5_MAX_PORTS];
 	struct lag_tracker        tracker;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
index 478b4ef723f8..d3a3fe4ce670 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
@@ -13,7 +13,7 @@ enum {
 static struct mlx5_flow_group *
 mlx5_create_hash_flow_group(struct mlx5_flow_table *ft,
 			    struct mlx5_flow_definer *definer,
-			    u8 ports)
+			    u8 rules)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_group *fg;
@@ -26,7 +26,7 @@ mlx5_create_hash_flow_group(struct mlx5_flow_table *ft,
 	MLX5_SET(create_flow_group_in, in, match_definer_id,
 		 mlx5_get_match_definer_id(definer));
 	MLX5_SET(create_flow_group_in, in, start_flow_index, 0);
-	MLX5_SET(create_flow_group_in, in, end_flow_index, ports - 1);
+	MLX5_SET(create_flow_group_in, in, end_flow_index, rules - 1);
 	MLX5_SET(create_flow_group_in, in, group_type,
 		 MLX5_CREATE_FLOW_GROUP_IN_GROUP_TYPE_HASH_SPLIT);
 
@@ -45,8 +45,10 @@ static int mlx5_lag_create_port_sel_table(struct mlx5_lag *ldev,
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	struct mlx5_flow_namespace *ns;
 	int err, i;
+	int idx;
+	int j;
 
-	ft_attr.max_fte = ldev->ports;
+	ft_attr.max_fte = ldev->ports * ldev->buckets;
 	ft_attr.level = MLX5_LAG_FT_LEVEL_DEFINER;
 
 	ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_PORT_SEL);
@@ -63,7 +65,7 @@ static int mlx5_lag_create_port_sel_table(struct mlx5_lag *ldev,
 
 	lag_definer->fg = mlx5_create_hash_flow_group(lag_definer->ft,
 						      lag_definer->definer,
-						      ldev->ports);
+						      ft_attr.max_fte);
 	if (IS_ERR(lag_definer->fg)) {
 		err = PTR_ERR(lag_definer->fg);
 		goto destroy_ft;
@@ -73,18 +75,24 @@ static int mlx5_lag_create_port_sel_table(struct mlx5_lag *ldev,
 	dest.vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
 	for (i = 0; i < ldev->ports; i++) {
-		u8 affinity = ports[i];
-
-		dest.vport.vhca_id = MLX5_CAP_GEN(ldev->pf[affinity - 1].dev,
-						  vhca_id);
-		lag_definer->rules[i] = mlx5_add_flow_rules(lag_definer->ft,
-							    NULL, &flow_act,
-							    &dest, 1);
-		if (IS_ERR(lag_definer->rules[i])) {
-			err = PTR_ERR(lag_definer->rules[i]);
-			while (i--)
-				mlx5_del_flow_rules(lag_definer->rules[i]);
-			goto destroy_fg;
+		for (j = 0; j < ldev->buckets; j++) {
+			u8 affinity;
+
+			idx = i * ldev->buckets + j;
+			affinity = ports[idx];
+
+			dest.vport.vhca_id = MLX5_CAP_GEN(ldev->pf[affinity - 1].dev,
+							  vhca_id);
+			lag_definer->rules[idx] = mlx5_add_flow_rules(lag_definer->ft,
+								      NULL, &flow_act,
+								      &dest, 1);
+			if (IS_ERR(lag_definer->rules[idx])) {
+				err = PTR_ERR(lag_definer->rules[idx]);
+				while (i--)
+					while (j--)
+						mlx5_del_flow_rules(lag_definer->rules[idx]);
+				goto destroy_fg;
+			}
 		}
 	}
 
@@ -330,10 +338,16 @@ static void mlx5_lag_destroy_definer(struct mlx5_lag *ldev,
 				     struct mlx5_lag_definer *lag_definer)
 {
 	struct mlx5_core_dev *dev = ldev->pf[MLX5_LAG_P1].dev;
+	int idx;
 	int i;
+	int j;
 
-	for (i = 0; i < ldev->ports; i++)
-		mlx5_del_flow_rules(lag_definer->rules[i]);
+	for (i = 0; i < ldev->ports; i++) {
+		for (j = 0; j < ldev->buckets; j++) {
+			idx = i * ldev->buckets + j;
+			mlx5_del_flow_rules(lag_definer->rules[idx]);
+		}
+	}
 	mlx5_destroy_flow_group(lag_definer->fg);
 	mlx5_destroy_flow_table(lag_definer->ft);
 	mlx5_destroy_match_definer(dev, lag_definer->definer);
@@ -544,31 +558,28 @@ int mlx5_lag_port_sel_create(struct mlx5_lag *ldev,
 	return err;
 }
 
-static int
-mlx5_lag_modify_definers_destinations(struct mlx5_lag *ldev,
-				      struct mlx5_lag_definer **definers,
-				      u8 *ports)
+static int __mlx5_lag_modify_definers_destinations(struct mlx5_lag *ldev,
+						   struct mlx5_lag_definer *def,
+						   u8 *ports)
 {
-	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
 	struct mlx5_flow_destination dest = {};
+	int idx;
 	int err;
-	int tt;
 	int i;
+	int j;
 
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_UPLINK;
 	dest.vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
 
-	for_each_set_bit(tt, port_sel->tt_map, MLX5_NUM_TT) {
-		struct mlx5_flow_handle **rules = definers[tt]->rules;
-
-		for (i = 0; i < ldev->ports; i++) {
+	for (i = 0; i < ldev->ports; i++) {
+		for (j = 0; j < ldev->buckets; j++) {
+			idx = i * ldev->buckets + j;
 			if (ldev->v2p_map[i] == ports[i])
 				continue;
-			dest.vport.vhca_id =
-				MLX5_CAP_GEN(ldev->pf[ports[i] - 1].dev,
-					     vhca_id);
-			err = mlx5_modify_rule_destination(rules[i],
-							   &dest, NULL);
+
+			dest.vport.vhca_id = MLX5_CAP_GEN(ldev->pf[ports[idx] - 1].dev,
+							  vhca_id);
+			err = mlx5_modify_rule_destination(def->rules[idx], &dest, NULL);
 			if (err)
 				return err;
 		}
@@ -577,6 +588,24 @@ mlx5_lag_modify_definers_destinations(struct mlx5_lag *ldev,
 	return 0;
 }
 
+static int
+mlx5_lag_modify_definers_destinations(struct mlx5_lag *ldev,
+				      struct mlx5_lag_definer **definers,
+				      u8 *ports)
+{
+	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
+	int err;
+	int tt;
+
+	for_each_set_bit(tt, port_sel->tt_map, MLX5_NUM_TT) {
+		err = __mlx5_lag_modify_definers_destinations(ldev, definers[tt], ports);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 int mlx5_lag_port_sel_modify(struct mlx5_lag *ldev, u8 *ports)
 {
 	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
index 79852ac41dbc..5ec3af2a3ecd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
@@ -10,7 +10,10 @@ struct mlx5_lag_definer {
 	struct mlx5_flow_definer *definer;
 	struct mlx5_flow_table *ft;
 	struct mlx5_flow_group *fg;
-	struct mlx5_flow_handle *rules[MLX5_MAX_PORTS];
+	/* Each port has ldev->buckets number of rules and they are arrange in
+	 * [port * buckets .. port * buckets + buckets) locations
+	 */
+	struct mlx5_flow_handle *rules[MLX5_MAX_PORTS * MLX5_LAG_MAX_HASH_BUCKETS];
 };
 
 struct mlx5_lag_ttc {
-- 
2.35.1

