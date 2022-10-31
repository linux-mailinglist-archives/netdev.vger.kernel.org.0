Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FF361332D
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiJaKAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiJaKAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:00:54 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F318DF1E
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:00:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmLQuZ0AxtXAxl6tyQFgeOFyNOYRSOnTrHFTVUq4/EQIMqeXiNdRfHPd0LnFLFvVwVR/KXlpqbiqbkcOGfSiqFMJU6S/z3w0nXb8KxRmXM4uQiabrqlKfVtKkVg/cP/oliMJIhTjNQXt7kpyLx+Ojal37D2Ia0i/z/wJ8BmI9VIMi3nN7huV2CkKYkXD8LfcVTGlpHfDD5mLp/3hsB49/F4KpO7N9gc8S27WhNGrzdxGx1nQfOTmWt4SGsL9nsOVF30mZaOygwVnEJGbEsmq9PKX9mrpVjU1YmWRt3ZetcULnqpXKr0P0Q7XDBPVk1VMeHfGSWmIcJjNAmQyDRrobA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q0/Tu2xkk8xt3KlC/28BDZAV44WkKvHGzPmDyITAoa8=;
 b=IuP/unlMGuFuMlK2150gnKMxVOW/Oc6Jcf7ixdoSqbPabqDwwRMZWDNJuGThKCThq/cJEPG1oqjFC4RdvFMP7mUIpDBsJpk2FhKdL4EFbh32dfMVZOMsQ6JieqGt879Wj5WI0an/HSthViHMwI1/ikVr5B282ejCujpZGLebYlOu4XvBypsP0JQv5+qP97VqU8swrZrYqAwQCDHwbi+IFVTo+hS5su/P6zmufjy5d+epSrnfRI2nS1TfvHwvk/6TenDrFKr9fFE1tNkfSocC7Ladge2okwk1TFTUWVqztNL87yxOswWGTpvRTa2OcLF3E1IVJ1gLMxAgwVe/REezQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0/Tu2xkk8xt3KlC/28BDZAV44WkKvHGzPmDyITAoa8=;
 b=lU30H7u+1XqdvUWNGR9yyyTZI1+IqoTri6K6MhgzbAhgNw4w6ESr3eK6dt6qGfeXT1T9PqOhqF5VaKiGk96ZSHFcq0WNSFQqAxe7U2NHvTK15jRppJ/H6Ir/XHET3NUE3wUHPvrJZGYOosnsPRSQkoByy3MEJ6/oZDEF5ZTx7CiVhp2VkS8758crbxO1F4Y6pGlOtdsH6r2XUfQdBzl1lsCJYJ3HedwT16KL5SEpUoB4qlBRRgQ+0aNREhEtfitQvhQQJJ+MEVIjj6R9KcmgGhFiEvhgnmocgm57mvBvAwiXbs90yM+4UBnKB7hNUwOhIB7d0cub5b2CsE6y/od2cQ==
Received: from MW4PR04CA0325.namprd04.prod.outlook.com (2603:10b6:303:82::30)
 by DM8PR12MB5430.namprd12.prod.outlook.com (2603:10b6:8:28::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.19; Mon, 31 Oct 2022 10:00:50 +0000
Received: from CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::7) by MW4PR04CA0325.outlook.office365.com
 (2603:10b6:303:82::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19 via Frontend
 Transport; Mon, 31 Oct 2022 10:00:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT026.mail.protection.outlook.com (10.13.175.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.14 via Frontend Transport; Mon, 31 Oct 2022 10:00:49 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 31 Oct
 2022 03:00:40 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 31 Oct 2022 03:00:39 -0700
Received: from vdi.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 31 Oct 2022 03:00:37 -0700
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Jacob Keller <jacob.e.keller@intel.com>,
        "Gal Pressman" <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next] ethtool: Fail number of channels change when it conflicts with rxnfc
Date:   Mon, 31 Oct 2022 12:00:16 +0200
Message-ID: <20221031100016.6028-1-gal@nvidia.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT026:EE_|DM8PR12MB5430:EE_
X-MS-Office365-Filtering-Correlation-Id: 170c801d-99ae-4dba-914f-08dabb26ca24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MqyeaX6hN77foOjW5v/xnS4+KZWfQWZc0h30oxSP7dx1+pW0IstaBj1HSeb29vD+EBv+IGEzqIaGL2MielYRcfnknYb1704eaGqQi5KWXWRxQpupjMnEPzIF1m+Eq5P7z7JLipaQO73mqApa0ZUvTnApVEREwVlKtZrDaDsUFoiwNL6G4Pc6zjZ5GWvg7BN3MrsXjotdPnYlfqaYrsbDgi9xCi/XUaGdV6qQg3uE8Mhyt74wUgW8aimZp235RqzquB28rpY+bPAEWoocy29kJIpyuS1R6lS4AQXxysDjdtrvSmKpMI0UBAeV7wJV8uSk9nq1dpuX+6UWrmJWdF0bival3PQS2/Bb94/2xpW9NCN2oaX3vL5GhO5r+3n/vue7RErYF/zjdvsxNeXlfbHjhkudRULkWGfa7vU8To23A/jXsVZuoxMoUa9EH4IswgVDz/96kKWP7xtuoPHqI20pM8LcuPqqawGD+/B+xZORMFib8E1HvcDe606/vhsObiMnbGjr2DxgtbE3Cxafk/uFOgDCtUggkI6URAit/Hnamd9FKio1Ic+Q14zp3GMwoBh578navmQvj5c+hoUA2sTc9V/+I7oHIPNA3ZYwnutD5lAmGy88iTsatK9MeCw4KBRoT9D8gL9OOB38R035nPMvJO9XIlv3o4Qol1oGn4E3I8wqr4E9slD0QmzBAeqg8ZMcHJYfRkPboptANbqtjBFz6rZJSyqRgGMyadU5Ulo6Obk/uF2yIMy/ZB+CH67bwjMmTu8xs7nyNjADgTVmEl+y7SWndyRGycONOSIUQGe9w7g=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(376002)(136003)(451199015)(36840700001)(46966006)(40470700004)(36860700001)(47076005)(86362001)(82310400005)(356005)(82740400003)(7636003)(41300700001)(2906002)(40480700001)(8676002)(70586007)(4326008)(70206006)(8936002)(5660300002)(316002)(54906003)(426003)(26005)(2616005)(40460700003)(83380400001)(336012)(1076003)(186003)(7696005)(110136005)(107886003)(478600001)(6666004)(36756003)(17423001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 10:00:49.9954
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 170c801d-99ae-4dba-914f-08dabb26ca24
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5430
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
n.b:
Another desirable fix would be handling the fact that additional RSS
contexts could be created and point to higher channels.
---
 net/ethtool/channels.c | 19 ++++++++----
 net/ethtool/common.c   | 65 ++++++++++++++++++++++++++++++++++++++++++
 net/ethtool/common.h   |  1 +
 net/ethtool/ioctl.c    | 17 +++++++----
 4 files changed, 91 insertions(+), 11 deletions(-)

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
index ee3e02da0013..c2790d29f97c 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -512,6 +512,71 @@ int __ethtool_get_link(struct net_device *dev)
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
+		    !(rule_info.flow_type & FLOW_RSS))
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
2.37.3

