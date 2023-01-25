Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B871767B087
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 12:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbjAYLCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 06:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234540AbjAYLCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 06:02:42 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2042.outbound.protection.outlook.com [40.107.21.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C624737F2A
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 03:02:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYl/Qy3h7fNyQR6OQEd3rBJQ9u3zPaiGfvSuRJEz+tZfjGI2tgXmuCkM3QWfeZHwxLHQVSTVOtPgv71vSzPM6uEA4kirTFGFxLLwsEtkMoiqTABB8Femgi7IaSU8FwJVHnK5bOEjYaaDKVf77rEs487id+uCxLeBEEogE7V+SNABlEcFZBCd8gS5s1MIyGCVEt7S0sgjC7r8Qx+Lldo1bfEkG/loRKFBB27IufeiZzwoVFor4gXifdhA1symZWhNM6uTUr7jg2vfPHG4d+dM3lP+AQ9zuMIRek9D4Oky0DBuxFAAqWxBXTBntLljvo9q3iyyu6G2YSuMsITVf2mx8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vmrlRJaGnnXP7w5Egmme2pYtAbJszA3ARLJUQhzBpbA=;
 b=f40dR7XYjzLjGkpgK8iwJ4peT65WWcjNxUCwts6FHis2fEJN3zk61WZ3HMAHRZXypMynxSgyHJVMIA3eew4n6DqWuFwNmD4KM4O41Ynp1g+dpa2SKWK2YPCPdIpNaRGNEuouTUzyDzEpEu+sqXkVB2xK3revtxOcsIpuKtc+G1AwPYecYOEY033Rdg48DwU7mIqXEgAwc3owHFkiIPmkMgvvWkDL9DcRvL9AzotsmYGKgCTDekORhvzWUsGPstZyqwiImrNlMjYQ8uGSq/jk2Gi74+fiqzsqrLVJqrzgM825OhweQNxarxDjW/OIVi1+/m8rBMYW29Qms9SEXMiNmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmrlRJaGnnXP7w5Egmme2pYtAbJszA3ARLJUQhzBpbA=;
 b=Rdr2f8vx7oOeXNwBMInzWeZMiP4Pib2FJtpS3Szm1n/e9+8oPmL1CDtHppIXL/EoI/7Eb0tNw/7NdtuNl9qB9SLfbcYO4EhNwWNVyfLe0PUZqNiaE1UgYgMR1ltSenEwxlgVo9ke9PI+it1+gpuvSku6AMzjZ4XniNmc6NNMi+4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB8009.eurprd04.prod.outlook.com (2603:10a6:10:1ef::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 11:02:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 11:02:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] net: ethtool: provide shims for stats aggregation helpers when CONFIG_ETHTOOL_NETLINK=n
Date:   Wed, 25 Jan 2023 13:02:14 +0200
Message-Id: <20230125110214.4127759-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0166.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:66::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DBBPR04MB8009:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c8dd3c6-0e9d-4ecc-d794-08dafec3aba5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zFy6tPZM3z20lO4C4IjEMTLmYAiOS9bm46KfxL30YQqtjFZPisw8JV81vo89SYxpYAu7cg2cZ78MeDO8BCEVdxkxkxi7OUlhsp5Fa6CMLKQeFs2e9UFJ52Oz+7czLRX0dvdn7ZZBQ3NpyRjgO/Ywt9o3xo63Yn4qtGv99q7dKprXKiUES040htqh2dEMS1l2lYlScTgLVA6/mbbE3p3Y2IdpMUQg1tlnQS+ERBGJ5l5Dq+xzjNFYTirb89I/PEoqdINZU/XCOr6xwNZcZg266hs1HVoli9K9EkzdSlIWo3zouRdKhn4EzpxnQUm9DpDZTc92gNH10/IbdZatVAGn4cctxxXESutsbbPELxXq9Um702jCxBH7eKYxseUCN0Ospt+n2L03lX96h9dQhyfTnP7oHvpcAXqAqWckzsuatj+Ln2P+VEqcaRlFQThUNLh3s68B+JDX9gda/0/ig81hKXaRLdOF/gCAhaVRhYlKTdgEHx09Xdh3oRSq7rP/2ikNkBqOU9WdEXIEG+5qysl4JMFFqa61pJQtBMq1kiynm1vcYwj6eRcjtRUfZtbz942e0PANWdQ5qHF6i60psEdRrRXa1vN85P4qurRF2jG22VgafquBVoCf8QpAtJ0/IeBjkNrQHZnfXMwX0V1KovWD/qLpMjeVOk7CjUXtoJNcRKzfQFhcPr1HTUXiRBZYjeCKiG2Gn+EdRFhncszJBkwwLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199018)(36756003)(38100700002)(1076003)(6512007)(83380400001)(41300700001)(86362001)(44832011)(8936002)(6506007)(26005)(52116002)(66946007)(186003)(6666004)(5660300002)(316002)(66556008)(478600001)(8676002)(66476007)(2906002)(6486002)(38350700002)(6916009)(54906003)(4326008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?enYAf7Y7baAYRBMZCSMmL+tiRtEpZQHVfkP0gG6EsH6Twab1IXKVJKyUkV1H?=
 =?us-ascii?Q?tmjsvGeie8o86K67W/rMS3rzQk7areLnD62ujKEXX5ZloyLId92hR/tRFs4J?=
 =?us-ascii?Q?m2biX9BpWla8MoO6y5SaNdlqgNPEY0Zgil2KGqg51cXR58nhSZj79QlECVxG?=
 =?us-ascii?Q?feU9vr+IYLEd+XhOtp1fVrF0eTy3jepzkiNDzXyx1ayMFK2EFo2ryIIxr7w/?=
 =?us-ascii?Q?ID3vio3R6kMG7z4onVGWjd6shCbnai6/vlhyi3yAyw1m8ZEcluv0cU/mRMev?=
 =?us-ascii?Q?0HjqgYwusTyAlo3NNdzCyIl9NW1P8mUXKNpKi5kVDAHgvpAUzZPfWhnLUE+W?=
 =?us-ascii?Q?II2ukprRLhfVmrR6eOlpNumZPFy21dCCbdY8nb2n5CeWndbtybVtDU38jxVv?=
 =?us-ascii?Q?qVPPZF3kEBcEobgMU2fH6Eyw7w3iZj5hTrixbN5nA90YU4iNZao8i8/u1bft?=
 =?us-ascii?Q?T0zObPtTGrVUIMZgLSYWkqXqoChG6ZAwB90s9G5DGGK2xmV0wQZqg9vDslHh?=
 =?us-ascii?Q?1iRBYy/4Otdw34B05nTL99fHTPH8AlTswLJWxEYRkLfZDe3iX79a0Je3km9C?=
 =?us-ascii?Q?fHj06+zfIn8hQSyyjMbu2goJTcFKtNI+ZVFkkHQcQTmE8B2eWzAjlJN8p7Yp?=
 =?us-ascii?Q?LDOTTP1QcfKWR/vOdxYHCX85x/bL5zv1cfdh7+izYDdbZj+K8i/rZ7ZNBgsN?=
 =?us-ascii?Q?UXU+eBKkxMyq/+0y5Q0oYLG2dYStgmQulQixqh05K26VUd2CUA9DrV5jZ3qK?=
 =?us-ascii?Q?dpqHECVUMlWjt8zhjltOdue+PRhOE98x56W6vKENdeLwHUWd+ohn7dpnf2HS?=
 =?us-ascii?Q?K27oE98ypbPDg76GmjYSqW+db0vM1Kzm+FYCc4zKAzNF3IU+ImTyGGSW5/oy?=
 =?us-ascii?Q?/W9+THPOud6YAbZUmmYd4psjtpE2EQXZcz67neD/ELaXLh3mQBtz3o/bqeUu?=
 =?us-ascii?Q?jkVkTjfLA+QaCN3TGZT2btdB7bvWoZ2fqZOpjx/j3CF98DjodIxs6v31C0gb?=
 =?us-ascii?Q?rJXXA66htDcRLLei5wu7DHT/3sOMzCDzAc6wmGCepjbBydzwtOpSsORhanLv?=
 =?us-ascii?Q?spNgwioMY+I1b4aWUgpvGNC6EDjALv5gBSi6J4bU+asdTlrVJ8Qb0SN95P19?=
 =?us-ascii?Q?//i4yiiAd21xDgkxN+vNcZh1SK26lRj1syvAWtvbadkgdo0h/DUNC/74SB2z?=
 =?us-ascii?Q?vNyuT75PIXeyEtp0MHTcf6QlGVMVN3H2jU+dpJhdyG1IQzL8rHD0Pepr5lA2?=
 =?us-ascii?Q?J3aoO3oSfZAY7yMZ5dnBIgRJo4GRtaGlYcCXxu+1PbqinimErWSX/sm8YxS6?=
 =?us-ascii?Q?TwuJrcadUauMRun0FElkKLX9XuxuDxVwpEsRvRDxgWleW/dtGoCugM/D3n+s?=
 =?us-ascii?Q?BMDKJZIymTTTDITKMqfBIxrBWbpn57/SRilGdud3NOsPSs8KiliOemGkh9Bj?=
 =?us-ascii?Q?jYdPxk3czvTQqg3ZlwqJMLBMjM9tGCFi3tmD4gWsmlrsnd9jvjZe4+3gYeCP?=
 =?us-ascii?Q?LrjmEktrDydgkcjDXmkqPe5vzdiUnUNIg+y8DPbIpVIY3BtOjJ/e7k63tQG/?=
 =?us-ascii?Q?Cfo+sOy+A/Vgfr15JGCabaubnv15OpMAxmKQMzFXJsD1Rf/KCZ4lp2oXV7p4?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c8dd3c6-0e9d-4ecc-d794-08dafec3aba5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 11:02:38.0540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H8kQXXfMF0/qxR9K+HYZ2c8/KgTz3KSW91F4JZL3upk/43Tm6kA8m2Nfou7ntRzA1VcNbO3QX2ZHwKIJ0c6FTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB8009
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool_aggregate_*_stats() are implemented in net/ethtool/stats.c, a
file which is compiled out when CONFIG_ETHTOOL_NETLINK=n. In order to
avoid adding Kbuild dependencies from drivers (which call these helpers)
on CONFIG_ETHTOOL_NETLINK, let's add some shim definitions which simply
make the helpers dead code.

This means the function prototypes should have been located in
include/linux/ethtool_netlink.h rather than include/linux/ethtool.h.

Fixes: 449c5459641a ("net: ethtool: add helpers for aggregate statistics")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_stats.c |  1 +
 include/linux/ethtool.h                  | 11 -------
 include/linux/ethtool_netlink.h          | 42 ++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index f660eef4a287..bdb893476832 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2017 Microsemi Corporation
  * Copyright 2022 NXP
  */
+#include <linux/ethtool_netlink.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 6a8253d3fea8..515c78d8eb7c 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -991,17 +991,6 @@ int ethtool_get_phc_vclocks(struct net_device *dev, int **vclock_index);
 u32 ethtool_op_get_link(struct net_device *dev);
 int ethtool_op_get_ts_info(struct net_device *dev, struct ethtool_ts_info *eti);
 
-void ethtool_aggregate_mac_stats(struct net_device *dev,
-				 struct ethtool_eth_mac_stats *mac_stats);
-void ethtool_aggregate_phy_stats(struct net_device *dev,
-				 struct ethtool_eth_phy_stats *phy_stats);
-void ethtool_aggregate_ctrl_stats(struct net_device *dev,
-				  struct ethtool_eth_ctrl_stats *ctrl_stats);
-void ethtool_aggregate_pause_stats(struct net_device *dev,
-				   struct ethtool_pause_stats *pause_stats);
-void ethtool_aggregate_rmon_stats(struct net_device *dev,
-				  struct ethtool_rmon_stats *rmon_stats);
-
 /**
  * ethtool_mm_frag_size_add_to_min - Translate (standard) additional fragment
  *	size expressed as multiplier into (absolute) minimum fragment size
diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index aba348d58ff6..17003b385756 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -29,6 +29,17 @@ int ethnl_cable_test_amplitude(struct phy_device *phydev, u8 pair, s16 mV);
 int ethnl_cable_test_pulse(struct phy_device *phydev, u16 mV);
 int ethnl_cable_test_step(struct phy_device *phydev, u32 first, u32 last,
 			  u32 step);
+void ethtool_aggregate_mac_stats(struct net_device *dev,
+				 struct ethtool_eth_mac_stats *mac_stats);
+void ethtool_aggregate_phy_stats(struct net_device *dev,
+				 struct ethtool_eth_phy_stats *phy_stats);
+void ethtool_aggregate_ctrl_stats(struct net_device *dev,
+				  struct ethtool_eth_ctrl_stats *ctrl_stats);
+void ethtool_aggregate_pause_stats(struct net_device *dev,
+				   struct ethtool_pause_stats *pause_stats);
+void ethtool_aggregate_rmon_stats(struct net_device *dev,
+				  struct ethtool_rmon_stats *rmon_stats);
+
 #else
 static inline int ethnl_cable_test_alloc(struct phy_device *phydev, u8 cmd)
 {
@@ -70,5 +81,36 @@ static inline int ethnl_cable_test_step(struct phy_device *phydev, u32 first,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline void
+ethtool_aggregate_mac_stats(struct net_device *dev,
+			    struct ethtool_eth_mac_stats *mac_stats)
+{
+}
+
+static inline void
+ethtool_aggregate_phy_stats(struct net_device *dev,
+			    struct ethtool_eth_phy_stats *phy_stats)
+{
+}
+
+static inline void
+ethtool_aggregate_ctrl_stats(struct net_device *dev,
+			     struct ethtool_eth_ctrl_stats *ctrl_stats)
+{
+}
+
+static inline void
+ethtool_aggregate_pause_stats(struct net_device *dev,
+			      struct ethtool_pause_stats *pause_stats)
+{
+}
+
+static inline void
+ethtool_aggregate_rmon_stats(struct net_device *dev,
+			     struct ethtool_rmon_stats *rmon_stats)
+{
+}
+
 #endif /* IS_ENABLED(CONFIG_ETHTOOL_NETLINK) */
 #endif /* _LINUX_ETHTOOL_NETLINK_H_ */
-- 
2.34.1

