Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F75661E218
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 13:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiKFMbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 07:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiKFMbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 07:31:40 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBD110FC
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 04:31:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xl3zVPL/cT85XP4g7NvFpyop6yL2N1C5o9eTyn18pPVn97yHReshQPuIzYLIfbXn2DkJtABSZPt1jHiMpovp+mG0MiCQ95XIhka0eh4JqnkVsOmUc1QvIOsgnnnO29CzN4yyf8CSsaBHLHdDlB8A6ANzqmfbSpz1/MvBbqN1wWKDV506WaKzsEdSq4FYLsJDrzSvtpSp7QzcBnXk0BDj/07bnA53rIwrvHXGOctXl8eA/HI8YxsQ6uEAk3TXPFUkXzaqlZXQ5OAFQByoDs0zAqFJLiJ3O0G3ttVwynwVcRO4VRtjp3LmWFLJM0CiaIMvxQG2esLJuiGUsadDNSTF9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fH0YuYGr1cO3jYEm8L4tMr70KRStJb1WDunbxzuVSCU=;
 b=AZe9RaXEIUnSQmHkzbkjA8fuaic+qoLA9WgZw7DTk8g3qgvv06wd2gW5oOuqLhn51kngyzrsBNDcL3TMKQckq8KzHeu9u4R8y698icUptw/wgHmX6loyIwMjwXmUNhxMYazXmyXOnJTk5QwOdN5NlStrYsjLcRA5tLL7WJDnYKmBDPlUA71aqt2rrMov4SP18rKnKaNy2p8snASi3OTFi5phTYaQderNtXUuqqPj72eV9HbL5+dgRsLUSYR2qs79senFM0LpD8kgAW1VkSJ1DBNtVK1kiUf05Qv9dApnseD7wjIpaL77WkVpQkhm/xOzSpYjyC5mnwJPR57LZx1oBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fH0YuYGr1cO3jYEm8L4tMr70KRStJb1WDunbxzuVSCU=;
 b=RUOE6omwUiLMnL08nzWrKRRN1AqrrHyHbJ3t7+MIeKjB3Z7poU1z9dWCD6jvAnRbQzWwPjd3MxFmPIZvJQ3cjYGz25OJc61Rz1NXPubloPgBPvp9OCcug/7sz30jnlbrG55nuR/tL4nwIEg0uTyisaNSmOFRl9t9dqEXDHXnjHtWQmPyXTKKAFj6k5CqP5dO6nkgDzObOOjQ9Q+cDYr1+d3/7841OauTQYRj4W1e9Y7qIp7/xYea3Vl7xwnn3mrDYEDYilQrqAw/4IdkR/Uva00oPoGIb/KnOI18cfom7d6WAC3AS3vvkmxWKtJMRHJV4G2r00FUT3ZWC2U6CJYXBQ==
Received: from DM6PR02CA0122.namprd02.prod.outlook.com (2603:10b6:5:1b4::24)
 by IA0PR12MB7775.namprd12.prod.outlook.com (2603:10b6:208:431::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.24; Sun, 6 Nov
 2022 12:31:37 +0000
Received: from DM6NAM11FT079.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::de) by DM6PR02CA0122.outlook.office365.com
 (2603:10b6:5:1b4::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Sun, 6 Nov 2022 12:31:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT079.mail.protection.outlook.com (10.13.173.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 12:31:36 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 6 Nov 2022
 04:31:34 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 6 Nov 2022 04:31:33 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Sun, 6 Nov 2022 04:31:32 -0800
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Jacob Keller <jacob.e.keller@intel.com>,
        "Gal Pressman" <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next v2] ethtool: Fail number of channels change when it conflicts with rxnfc
Date:   Sun, 6 Nov 2022 14:31:27 +0200
Message-ID: <20221106123127.522985-1-gal@nvidia.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT079:EE_|IA0PR12MB7775:EE_
X-MS-Office365-Filtering-Correlation-Id: 385750df-7d2b-4e51-65d0-08dabff2d8ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yJtkbOyHpl62f2qd47o9Qm5nk6j27/lVx8bMubqQEIOACJYv0ubJpqOJ/tqoteg93tmv7KZpDbXiR6ZOWO3ktXbpy5JytozvT8NtDTm0+Ed6Q3QmRbeaMUuNcfMhk0fcfT66SoH6VZPsVgozX8/gm65bJUeHcYmbqCuZjyRD3iP6mjYScoxflmzk2tlRQHCTJRqfLQNJ/cZU4AjZDFNe8VEtN0of5NAOxtvaTZjpV4TFgRDGwlOX+DZxVWO6A1yGKlOv7dnsgSPFhch9GTmjJM2OMkntQkuXzgOxk6i2Ir3QlKQIbylsjo0WPm3PAd5wTo1ZTe6e9B+6X//6FleEz+TgZokNC86PzqZrTW8xOArUv6BjM3QgoVAw0/rYbJ05/xv0q16iAeQ6YZSt6WCTBwj04ffR+gEy2L2SzYMw4uktqDGGC+RYLq/OZNbgpLLu62aH/SlBP0YKnxoXEcu/smM5zbkO1XX2K+yDs/BZhPaIJO+LSdPLhaBCG2IL/UJ2IvoFbJhwVsLXWa816tJ0Y9rVKiZoxxEZIr//5LyWzdOy/teNxwUwiFKjV1wCrhL9t6kzY6tTwDJZQE/Ywd6ICrpb9bOB8duIU2vRJuZZAJVz++YGmVyRmWkWjU0AW/1pBmW4a/GvPieqtudr9zw53oi5GynBh+vHKV/mwVQPzh2UWEcSRtHfrd6abJpONE1FpjmEyYjI4g9Z/wR59zNKGb3xRtl/t7fVa6v94LlpbUIezoBMrFgXGtYBGXjuZUOsVk5KbQNzu9gvjc1oOuL8Re45pw3dqUDW0XbMk4fh/wqHkDQLfLIFFsoPCuNBpzcVcKvujmDJ1Dfb7auvYSMChYQZ4wRKXYFXScbhgKdD9zL8EK1uFTDLD7tEC7MJJkgx
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199015)(46966006)(40470700004)(36840700001)(4326008)(8676002)(316002)(478600001)(54906003)(110136005)(70586007)(8936002)(41300700001)(70206006)(40460700003)(36756003)(1076003)(47076005)(82310400005)(40480700001)(86362001)(426003)(5660300002)(2906002)(82740400003)(336012)(7696005)(356005)(107886003)(6666004)(2616005)(83380400001)(36860700001)(7636003)(966005)(26005)(186003)(17423001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 12:31:36.2951
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 385750df-7d2b-4e51-65d0-08dabff2d8ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT079.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7775
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to what we do with the hash indirection table [1], when network
flow classification rules are forwarding traffic to channels greater
than the requested number of channels, fail the operation.
Without this, traffic could be directed to channels which no longer
exist (dropped) after changing number of channels.

[1] commit d4ab4286276f ("ethtool: correctly ensure {GS}CHANNELS doesn't conflict with GS{RXFH}")

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
Changelog -
v1->v2: https://lore.kernel.org/all/20221031100016.6028-1-gal@nvidia.com/
* Make sure to check ethtool_get_flow_spec_ring_vf() == 0 as pointed out
  by Jakub & Jacob.

n.b:
Another desirable fix would be handling the fact that additional RSS
contexts could be created and point to higher channels.
---
 net/ethtool/channels.c | 19 ++++++++----
 net/ethtool/common.c   | 66 ++++++++++++++++++++++++++++++++++++++++++
 net/ethtool/common.h   |  1 +
 net/ethtool/ioctl.c    | 17 +++++++----
 4 files changed, 92 insertions(+), 11 deletions(-)

diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 403158862011..c7e37130647e 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -116,9 +116,10 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 	struct ethtool_channels channels = {};
 	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
-	u32 err_attr, max_rx_in_use = 0;
+	u32 err_attr, max_rxfh_in_use;
 	const struct ethtool_ops *ops;
 	struct net_device *dev;
+	u64 max_rxnfc_in_use;
 	int ret;
 
 	ret = ethnl_parse_header_dev_get(&req_info,
@@ -189,15 +190,23 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* ensure the new Rx count fits within the configured Rx flow
-	 * indirection table settings
+	 * indirection table/rxnfc settings
 	 */
-	if (netif_is_rxfh_configured(dev) &&
-	    !ethtool_get_max_rxfh_channel(dev, &max_rx_in_use) &&
-	    (channels.combined_count + channels.rx_count) <= max_rx_in_use) {
+	if (ethtool_get_max_rxnfc_channel(dev, &max_rxnfc_in_use))
+		max_rxnfc_in_use = 0;
+	if (!netif_is_rxfh_configured(dev) ||
+	    ethtool_get_max_rxfh_channel(dev, &max_rxfh_in_use))
+		max_rxfh_in_use = 0;
+	if (channels.combined_count + channels.rx_count <= max_rxfh_in_use) {
 		ret = -EINVAL;
 		GENL_SET_ERR_MSG(info, "requested channel counts are too low for existing indirection table settings");
 		goto out_ops;
 	}
+	if (channels.combined_count + channels.rx_count <= max_rxnfc_in_use) {
+		ret = -EINVAL;
+		GENL_SET_ERR_MSG(info, "requested channel counts are too low for existing ntuple filter settings");
+		goto out_ops;
+	}
 
 	/* Disabling channels, query zero-copy AF_XDP sockets */
 	from_channel = channels.combined_count +
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index ee3e02da0013..21cfe8557205 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -512,6 +512,72 @@ int __ethtool_get_link(struct net_device *dev)
 	return netif_running(dev) && dev->ethtool_ops->get_link(dev);
 }
 
+static int ethtool_get_rxnfc_rule_count(struct net_device *dev)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct ethtool_rxnfc info = {
+		.cmd = ETHTOOL_GRXCLSRLCNT,
+	};
+	int err;
+
+	err = ops->get_rxnfc(dev, &info, NULL);
+	if (err)
+		return err;
+
+	return info.rule_cnt;
+}
+
+int ethtool_get_max_rxnfc_channel(struct net_device *dev, u64 *max)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct ethtool_rxnfc *info;
+	int err, i, rule_cnt;
+	u64 max_ring = 0;
+
+	if (!ops->get_rxnfc)
+		return -EOPNOTSUPP;
+
+	rule_cnt = ethtool_get_rxnfc_rule_count(dev);
+	if (rule_cnt <= 0)
+		return -EINVAL;
+
+	info = kvzalloc(struct_size(info, rule_locs, rule_cnt), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->cmd = ETHTOOL_GRXCLSRLALL;
+	info->rule_cnt = rule_cnt;
+	err = ops->get_rxnfc(dev, info, info->rule_locs);
+	if (err)
+		goto err_free_info;
+
+	for (i = 0; i < rule_cnt; i++) {
+		struct ethtool_rxnfc rule_info = {
+			.cmd = ETHTOOL_GRXCLSRULE,
+			.fs.location = info->rule_locs[i],
+		};
+
+		err = ops->get_rxnfc(dev, &rule_info, NULL);
+		if (err)
+			goto err_free_info;
+
+		if (rule_info.fs.ring_cookie != RX_CLS_FLOW_DISC &&
+		    rule_info.fs.ring_cookie != RX_CLS_FLOW_WAKE &&
+		    !(rule_info.flow_type & FLOW_RSS) &&
+		    !ethtool_get_flow_spec_ring_vf(rule_info.fs.ring_cookie))
+			max_ring =
+				max_t(u64, max_ring, rule_info.fs.ring_cookie);
+	}
+
+	kvfree(info);
+	*max = max_ring;
+	return 0;
+
+err_free_info:
+	kvfree(info);
+	return err;
+}
+
 int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max)
 {
 	u32 dev_size, current_max = 0;
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index c1779657e074..b1b9db810eca 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -43,6 +43,7 @@ bool convert_legacy_settings_to_link_ksettings(
 	struct ethtool_link_ksettings *link_ksettings,
 	const struct ethtool_cmd *legacy_settings);
 int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max);
+int ethtool_get_max_rxnfc_channel(struct net_device *dev, u64 *max);
 int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info);
 
 extern const struct ethtool_phy_ops *ethtool_phy_ops;
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 57e7238a4136..4831fd82796a 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1796,7 +1796,8 @@ static noinline_for_stack int ethtool_set_channels(struct net_device *dev,
 {
 	struct ethtool_channels channels, curr = { .cmd = ETHTOOL_GCHANNELS };
 	u16 from_channel, to_channel;
-	u32 max_rx_in_use = 0;
+	u64 max_rxnfc_in_use;
+	u32 max_rxfh_in_use;
 	unsigned int i;
 	int ret;
 
@@ -1827,11 +1828,15 @@ static noinline_for_stack int ethtool_set_channels(struct net_device *dev,
 		return -EINVAL;
 
 	/* ensure the new Rx count fits within the configured Rx flow
-	 * indirection table settings */
-	if (netif_is_rxfh_configured(dev) &&
-	    !ethtool_get_max_rxfh_channel(dev, &max_rx_in_use) &&
-	    (channels.combined_count + channels.rx_count) <= max_rx_in_use)
-	    return -EINVAL;
+	 * indirection table/rxnfc settings */
+	if (ethtool_get_max_rxnfc_channel(dev, &max_rxnfc_in_use))
+		max_rxnfc_in_use = 0;
+	if (!netif_is_rxfh_configured(dev) ||
+	    ethtool_get_max_rxfh_channel(dev, &max_rxfh_in_use))
+		max_rxfh_in_use = 0;
+	if (channels.combined_count + channels.rx_count <=
+	    max_t(u64, max_rxnfc_in_use, max_rxfh_in_use))
+		return -EINVAL;
 
 	/* Disabling channels, query zero-copy AF_XDP sockets */
 	from_channel = channels.combined_count +
-- 
2.26.3

