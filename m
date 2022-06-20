Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F8E5520D6
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242149AbiFTP1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242146AbiFTP1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:27:39 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1E4D3
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:27:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvlxD4iBk24xARFvifErQ0xf8EuPyPkW9tDXtuIeE8UP0u8XRVQOXUl2jxszJnjDMnDvNAzcsR95eQ+Q1Tzfx4LSJXkaIVbwZAlzRvR/0j71P4sqTdSBrAMtkK3C+4whcdJrstI39QXaKUFEy9xoqrY1u5c0AxxV5O1iLBeQkxTVFKuCsE9S7B6Cs8s05duV77R+21C/dptfvwuTH2sqA5zNRgyxYjwM7vgrQw3W7fAhNs4JL2W2mraXuohnA6bb+Xufiwl9knVdi5mzF0bK6BBnGmkJ1i+zCAE/1Rvr3FDSfKXziWPPioKc7WpoNH+ok55UQZGef7e5If/WhaTekg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2IkDA7s4raVIaTyWbDni5VG92xByPaaVraDmd9/XFA=;
 b=bXzbdM0n/MEqsdZyIpsXvfO69/pvDKkNwsMHbg8fS7h+52o4DsbmRqG6xO4nJFCP2NKeypL4XKURaM/IXZD6u3n8MZA2Rs4GjXUuFXI9xF7b9eblHJvJAhBS0Xv+ae3A0Ty0lBXN2a95LkmHNUJsxq8vGYzGn76hCxFLDj2/Jkm7fSm18Lo5krMp5QgzyLOBH5nt/6p2Fw5b4xhMingxmsfMZDnwOWI2NcA4++JiBl6buc6C6sBeyffN0RrUHstRvYc5RoiLne20OQnmT5nHxQl4MOt6J0MWztpxxcOxu8/S0Dd/HeoUPHmgFemc4sSCRt4JUJgVKboxrH3rkXOPeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2IkDA7s4raVIaTyWbDni5VG92xByPaaVraDmd9/XFA=;
 b=WqzzbAON4KOsjeEsgch7TSMkGsCuQTiPVoBAFPdtRcAel46U6vM2spDWVn4hb1VydNNklxVie88L/emIOcWlNWcsRqJOhiV6X/8luMkseZgXxfeh2JjFT+ZZJyafm0EC7MEzTMHx+zVuEEADCjqnOrR7FTHVg9L09ACvJNuUaYuhdFs6cyY9/sAwd/xkoppH6EP28iWXv53a/tQtmPOjFQagWcJY65Irv7De0QuqLFBMZu205eVaOZs6WwBWUtizSeGMHgs/0KFATvuzDEEV+EzZD6TMOoo0E0OoeCIVnNr8R7Q3j+NHQ+k3iz9LVk34tSWovpwlKR+ZITm20yUz0g==
Received: from CO2PR04CA0197.namprd04.prod.outlook.com (2603:10b6:104:5::27)
 by SJ1PR12MB6316.namprd12.prod.outlook.com (2603:10b6:a03:455::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Mon, 20 Jun
 2022 15:27:36 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:5:cafe::d9) by CO2PR04CA0197.outlook.office365.com
 (2603:10b6:104:5::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13 via Frontend
 Transport; Mon, 20 Jun 2022 15:27:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 15:27:36 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 20 Jun 2022 15:27:36 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 20 Jun 2022 08:27:35 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 20 Jun 2022 08:27:33 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH net-next 3/5] netdevsim: Support devlink rate limit_type police
Date:   Mon, 20 Jun 2022 18:26:45 +0300
Message-ID: <20220620152647.2498927-4-dchumak@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220620152647.2498927-1-dchumak@nvidia.com>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2db89bb5-1158-4e49-dbf7-08da52d16780
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6316:EE_
X-Microsoft-Antispam-PRVS: <SJ1PR12MB6316883F4A5C83FAA6FCF6F5D5B09@SJ1PR12MB6316.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1lYKU4l+InKKPTW8wfNF00SpDAqGPXcRGvPL+kTkZn/u3Hxs+kZglnmwG6gTutx48J58HhptwJ8oWkJReMPcpPODSf6kyzf4BD/5krnGU1hFq2Xjev8ZF/i+k6qzb4Czq5pyaYYbbzeQvSNq4RpNnUrVx6opDdRLhLMpseFg3ztX9a15OJ49Ra3oJjJO5q0mZqDLYz85KpmT+rTyc7imQNLB6BSH9yJJlRUznhxU3hwwkwCSHESnF6DQE2D9pjUXIYQiYpRkgPILe97zl9sv3mQuWNSVBAQAfvLhJoGU7/dvW9F7iVnhQ/UbiRJCvVS8ZZh04d44IfobXIwSMlzIpUJiwUlYT9KWxQ6UHSrdB9rGxrqFXyCTdImvUqBKUQ4+5k0bGt/MQLT0Eyh6UkySl9JmoOetQWOFSp0v1OOikofgxyCzx44ZplUgzJVECNc2liW7RGl7aoFATrdKIrnWJ86u7+E1QpZcdYNq+q/rePemeSNfLKOeLmqNuyF3pD3nM76j+GjbgEfbKsl6WEfjBxNSRpUssC5dRwE+F3k5QlZkFHMDtbzTm8xQ9M6rWy8T1SasWjmNNUUz66j7Jhz3x/z7MA6p+EQBK3R+tw6+TQqiJuptFJr8e8iUTyZ8I1IpwPSBsIwGKD4KU/WHyJ5cbmjPQb8NUWkW6D5rvqHjpdGqjQfVo+JL0bYYbJET6+114Dk+eCkWDLGIVEoo7rcHYn4e8A3NwQyqgp/T3ga4dUI=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(136003)(39860400002)(36840700001)(46966006)(40470700004)(30864003)(70586007)(426003)(8676002)(1076003)(6666004)(478600001)(47076005)(336012)(82310400005)(316002)(70206006)(83380400001)(81166007)(356005)(8936002)(41300700001)(5660300002)(36756003)(107886003)(7696005)(82740400003)(26005)(2616005)(86362001)(40460700003)(2906002)(186003)(36860700001)(6916009)(54906003)(40480700001)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 15:27:36.3081
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2db89bb5-1158-4e49-dbf7-08da52d16780
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6316
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement devlink_ops that enable setting devlink_rate attributes for
the new DEVLINK_RATE_LIMIT_TYPE_POLICE type of rate objects via devlink
API.

The new rate values of VF ports and rate nodes are exposed to netdevsim
debugfs.

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
---
 drivers/net/netdevsim/dev.c       | 211 ++++++++++++++++++++++++++++--
 drivers/net/netdevsim/netdevsim.h |  11 +-
 2 files changed, 207 insertions(+), 15 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 57a3ac893792..9ac78ab09a58 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -406,10 +406,24 @@ static int nsim_dev_port_debugfs_init(struct nsim_dev *nsim_dev,
 	if (nsim_dev_port_is_vf(nsim_dev_port)) {
 		unsigned int vf_id = nsim_dev_port_index_to_vf_index(port_index);
 
-		debugfs_create_u16("tx_share", 0400, nsim_dev_port->ddir,
+		debugfs_create_u64("tx_share", 0400, nsim_dev_port->ddir,
 				   &nsim_dev->vfconfigs[vf_id].min_tx_rate);
-		debugfs_create_u16("tx_max", 0400, nsim_dev_port->ddir,
+		debugfs_create_u64("tx_max", 0400, nsim_dev_port->ddir,
 				   &nsim_dev->vfconfigs[vf_id].max_tx_rate);
+		debugfs_create_u64("tx_burst", 0400, nsim_dev_port->ddir,
+				   &nsim_dev->vfconfigs[vf_id].tx_burst);
+		debugfs_create_u64("rx_max", 0400, nsim_dev_port->ddir,
+				   &nsim_dev->vfconfigs[vf_id].rx_max);
+		debugfs_create_u64("rx_burst", 0400, nsim_dev_port->ddir,
+				   &nsim_dev->vfconfigs[vf_id].rx_burst);
+		debugfs_create_u64("tx_pkts", 0400, nsim_dev_port->ddir,
+				   &nsim_dev->vfconfigs[vf_id].tx_pkts);
+		debugfs_create_u64("tx_pkts_burst", 0400, nsim_dev_port->ddir,
+				   &nsim_dev->vfconfigs[vf_id].tx_pkts_burst);
+		debugfs_create_u64("rx_pkts", 0400, nsim_dev_port->ddir,
+				   &nsim_dev->vfconfigs[vf_id].rx_pkts);
+		debugfs_create_u64("rx_pkts_burst", 0400, nsim_dev_port->ddir,
+				   &nsim_dev->vfconfigs[vf_id].rx_pkts_burst);
 		nsim_dev_port->rate_parent = debugfs_create_file("rate_parent",
 								 0400,
 								 nsim_dev_port->ddir,
@@ -1192,20 +1206,106 @@ static int nsim_leaf_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
 	int vf_id = nsim_dev_port_index_to_vf_index(nsim_dev_port->port_index);
 	int err;
 
-	err = nsim_rate_bytes_to_units("tx_max", &tx_max, extack);
-	if (err)
-		return err;
+	if (devlink_rate->limit_type == DEVLINK_RATE_LIMIT_TYPE_SHAPING) {
+		err = nsim_rate_bytes_to_units("tx_max", &tx_max, extack);
+		if (err)
+			return err;
+	}
 
 	nsim_dev->vfconfigs[vf_id].max_tx_rate = tx_max;
 	return 0;
 }
 
+static int nsim_leaf_tx_burst_set(struct devlink_rate *rate_leaf, void *priv,
+				  u64 tx_burst, struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_port *nsim_dev_port = priv;
+	struct nsim_dev *nsim_dev = nsim_dev_port->ns->nsim_dev;
+	int vf_id = nsim_dev_port_index_to_vf_index(nsim_dev_port->port_index);
+
+	nsim_dev->vfconfigs[vf_id].tx_burst = tx_burst;
+	return 0;
+}
+
+static int nsim_leaf_rx_max_set(struct devlink_rate *rate_leaf, void *priv,
+				u64 rx_max, struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_port *nsim_dev_port = priv;
+	struct nsim_dev *nsim_dev = nsim_dev_port->ns->nsim_dev;
+	int vf_id = nsim_dev_port_index_to_vf_index(nsim_dev_port->port_index);
+
+	nsim_dev->vfconfigs[vf_id].rx_max = rx_max;
+	return 0;
+}
+
+static int nsim_leaf_rx_burst_set(struct devlink_rate *rate_leaf, void *priv,
+				  u64 rx_burst, struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_port *nsim_dev_port = priv;
+	struct nsim_dev *nsim_dev = nsim_dev_port->ns->nsim_dev;
+	int vf_id = nsim_dev_port_index_to_vf_index(nsim_dev_port->port_index);
+
+	nsim_dev->vfconfigs[vf_id].rx_burst = rx_burst;
+	return 0;
+}
+
+static int nsim_leaf_tx_pkts_set(struct devlink_rate *rate_leaf, void *priv,
+				 u64 tx_pkts, struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_port *nsim_dev_port = priv;
+	struct nsim_dev *nsim_dev = nsim_dev_port->ns->nsim_dev;
+	int vf_id = nsim_dev_port_index_to_vf_index(nsim_dev_port->port_index);
+
+	nsim_dev->vfconfigs[vf_id].tx_pkts = tx_pkts;
+	return 0;
+}
+
+static int nsim_leaf_tx_pkts_burst_set(struct devlink_rate *rate_leaf, void *priv,
+				       u64 tx_pkts_burst, struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_port *nsim_dev_port = priv;
+	struct nsim_dev *nsim_dev = nsim_dev_port->ns->nsim_dev;
+	int vf_id = nsim_dev_port_index_to_vf_index(nsim_dev_port->port_index);
+
+	nsim_dev->vfconfigs[vf_id].tx_pkts_burst = tx_pkts_burst;
+	return 0;
+}
+
+static int nsim_leaf_rx_pkts_set(struct devlink_rate *rate_leaf, void *priv,
+				 u64 rx_pkts, struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_port *nsim_dev_port = priv;
+	struct nsim_dev *nsim_dev = nsim_dev_port->ns->nsim_dev;
+	int vf_id = nsim_dev_port_index_to_vf_index(nsim_dev_port->port_index);
+
+	nsim_dev->vfconfigs[vf_id].rx_pkts = rx_pkts;
+	return 0;
+}
+
+static int nsim_leaf_rx_pkts_burst_set(struct devlink_rate *rate_leaf, void *priv,
+				       u64 rx_pkts_burst, struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_port *nsim_dev_port = priv;
+	struct nsim_dev *nsim_dev = nsim_dev_port->ns->nsim_dev;
+	int vf_id = nsim_dev_port_index_to_vf_index(nsim_dev_port->port_index);
+
+	nsim_dev->vfconfigs[vf_id].rx_pkts_burst = rx_pkts_burst;
+	return 0;
+}
+
 struct nsim_rate_node {
 	struct dentry *ddir;
 	struct dentry *rate_parent;
 	char *parent_name;
-	u16 tx_share;
-	u16 tx_max;
+	u64 tx_share;
+	u64 tx_max;
+	u64 tx_burst;
+	u64 rx_max;
+	u64 rx_burst;
+	u64 tx_pkts;
+	u64 tx_pkts_burst;
+	u64 rx_pkts;
+	u64 rx_pkts_burst;
 };
 
 static int nsim_node_tx_share_set(struct devlink_rate *devlink_rate, void *priv,
@@ -1228,14 +1328,79 @@ static int nsim_node_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
 	struct nsim_rate_node *nsim_node = priv;
 	int err;
 
-	err = nsim_rate_bytes_to_units("tx_max", &tx_max, extack);
-	if (err)
-		return err;
+	if (devlink_rate->limit_type == DEVLINK_RATE_LIMIT_TYPE_SHAPING) {
+		err = nsim_rate_bytes_to_units("tx_max", &tx_max, extack);
+		if (err)
+			return err;
+	}
 
 	nsim_node->tx_max = tx_max;
 	return 0;
 }
 
+static int nsim_node_tx_burst_set(struct devlink_rate *rate_node, void *priv,
+				  u64 tx_burst, struct netlink_ext_ack *extack)
+{
+	struct nsim_rate_node *nsim_node = priv;
+
+	nsim_node->tx_burst = tx_burst;
+	return 0;
+}
+
+static int nsim_node_rx_max_set(struct devlink_rate *rate_node, void *priv,
+				u64 rx_max, struct netlink_ext_ack *extack)
+{
+	struct nsim_rate_node *nsim_node = priv;
+
+	nsim_node->rx_max = rx_max;
+	return 0;
+}
+
+static int nsim_node_rx_burst_set(struct devlink_rate *rate_node, void *priv,
+				  u64 rx_burst, struct netlink_ext_ack *extack)
+{
+	struct nsim_rate_node *nsim_node = priv;
+
+	nsim_node->rx_burst = rx_burst;
+	return 0;
+}
+
+static int nsim_node_tx_pkts_set(struct devlink_rate *rate_node, void *priv,
+				 u64 tx_pkts, struct netlink_ext_ack *extack)
+{
+	struct nsim_rate_node *nsim_node = priv;
+
+	nsim_node->tx_pkts = tx_pkts;
+	return 0;
+}
+
+static int nsim_node_tx_pkts_burst_set(struct devlink_rate *rate_node, void *priv,
+				       u64 tx_pkts_burst, struct netlink_ext_ack *extack)
+{
+	struct nsim_rate_node *nsim_node = priv;
+
+	nsim_node->tx_pkts_burst = tx_pkts_burst;
+	return 0;
+}
+
+static int nsim_node_rx_pkts_set(struct devlink_rate *rate_node, void *priv,
+				 u64 rx_pkts, struct netlink_ext_ack *extack)
+{
+	struct nsim_rate_node *nsim_node = priv;
+
+	nsim_node->rx_pkts = rx_pkts;
+	return 0;
+}
+
+static int nsim_node_rx_pkts_burst_set(struct devlink_rate *rate_node, void *priv,
+				       u64 rx_pkts_burst, struct netlink_ext_ack *extack)
+{
+	struct nsim_rate_node *nsim_node = priv;
+
+	nsim_node->rx_pkts_burst = rx_pkts_burst;
+	return 0;
+}
+
 static int nsim_rate_node_new(struct devlink_rate *node, void **priv,
 			      struct netlink_ext_ack *extack)
 {
@@ -1253,13 +1418,19 @@ static int nsim_rate_node_new(struct devlink_rate *node, void **priv,
 
 	nsim_node->ddir = debugfs_create_dir(node->name, nsim_dev->nodes_ddir);
 
-	debugfs_create_u16("tx_share", 0400, nsim_node->ddir, &nsim_node->tx_share);
-	debugfs_create_u16("tx_max", 0400, nsim_node->ddir, &nsim_node->tx_max);
+	debugfs_create_u64("tx_share", 0400, nsim_node->ddir, &nsim_node->tx_share);
+	debugfs_create_u64("tx_max", 0400, nsim_node->ddir, &nsim_node->tx_max);
+	debugfs_create_u64("tx_burst", 0400, nsim_node->ddir, &nsim_node->tx_burst);
+	debugfs_create_u64("rx_max", 0400, nsim_node->ddir, &nsim_node->rx_max);
+	debugfs_create_u64("rx_burst", 0400, nsim_node->ddir, &nsim_node->rx_burst);
+	debugfs_create_u64("tx_pkts", 0400, nsim_node->ddir, &nsim_node->tx_pkts);
+	debugfs_create_u64("tx_pkts_burst", 0400, nsim_node->ddir, &nsim_node->tx_pkts_burst);
+	debugfs_create_u64("rx_pkts", 0400, nsim_node->ddir, &nsim_node->rx_pkts);
+	debugfs_create_u64("rx_pkts_burst", 0400, nsim_node->ddir, &nsim_node->rx_pkts_burst);
 	nsim_node->rate_parent = debugfs_create_file("rate_parent", 0400,
 						     nsim_node->ddir,
 						     &nsim_node->parent_name,
 						     &nsim_dev_rate_parent_fops);
-
 	*priv = nsim_node;
 	return 0;
 }
@@ -1337,8 +1508,22 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
 	.rate_leaf_tx_share_set = nsim_leaf_tx_share_set,
 	.rate_leaf_tx_max_set = nsim_leaf_tx_max_set,
+	.rate_leaf_tx_burst_set = nsim_leaf_tx_burst_set,
+	.rate_leaf_rx_max_set = nsim_leaf_rx_max_set,
+	.rate_leaf_rx_burst_set = nsim_leaf_rx_burst_set,
+	.rate_leaf_tx_pkts_set = nsim_leaf_tx_pkts_set,
+	.rate_leaf_tx_pkts_burst_set = nsim_leaf_tx_pkts_burst_set,
+	.rate_leaf_rx_pkts_set = nsim_leaf_rx_pkts_set,
+	.rate_leaf_rx_pkts_burst_set = nsim_leaf_rx_pkts_burst_set,
 	.rate_node_tx_share_set = nsim_node_tx_share_set,
 	.rate_node_tx_max_set = nsim_node_tx_max_set,
+	.rate_node_tx_burst_set = nsim_node_tx_burst_set,
+	.rate_node_rx_max_set = nsim_node_rx_max_set,
+	.rate_node_rx_burst_set = nsim_node_rx_burst_set,
+	.rate_node_tx_pkts_set = nsim_node_tx_pkts_set,
+	.rate_node_tx_pkts_burst_set = nsim_node_tx_pkts_burst_set,
+	.rate_node_rx_pkts_set = nsim_node_rx_pkts_set,
+	.rate_node_rx_pkts_burst_set = nsim_node_rx_pkts_burst_set,
 	.rate_node_new = nsim_rate_node_new,
 	.rate_node_del = nsim_rate_node_del,
 	.rate_leaf_parent_set = nsim_rate_leaf_parent_set,
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 0b122872b2c9..2040b95e5f93 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -241,8 +241,15 @@ struct nsim_dev_port {
 
 struct nsim_vf_config {
 	int link_state;
-	u16 min_tx_rate;
-	u16 max_tx_rate;
+	u64 min_tx_rate;
+	u64 max_tx_rate;
+	u64 tx_burst;
+	u64 rx_max;
+	u64 rx_burst;
+	u64 tx_pkts;
+	u64 tx_pkts_burst;
+	u64 rx_pkts;
+	u64 rx_pkts_burst;
 	u16 vlan;
 	__be16 vlan_proto;
 	u16 qos;
-- 
2.36.1

