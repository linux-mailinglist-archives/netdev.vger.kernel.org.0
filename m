Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2F937C0A8
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbhELOvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:51:20 -0400
Received: from mail-dm6nam12on2050.outbound.protection.outlook.com ([40.107.243.50]:19948
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231473AbhELOub (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gvx52PDf5rc0HDmK1EE42mgu5dvVOmpKOcnQhleXd2J57AGeCrMPMrGKCdCNRN1+ndwyjQDDu2QflB0QYYVTpcAJcrWzfqXOByTBooUjM3LMa+tTZSTG+5F1/JMrKPw2/b+2GLolXP6rxkInsQWrMzBcI/GH5c44iyrc5luK2O/PbDBCXtWL/ZaolfSYQH3xKLQ7dYma1yNSMw0KWGtlxjOzl9qqmLtHG+Z8KfP2WioVexgvDsN8GWKGACWJ+Tq6xHDsD4AWc0zBtS05Uq9VFe65z+SGhigu7mzU8AwiIXmMaA6XnRnvvT17qsUxyi14XFjed5ZJJFIfKSuDM1LVXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wt66aTPIoM3XVpKVU/8eW/w+SOJnPQe9QlO9+MlIB/Y=;
 b=KtPDXv5Pcnu2eS07TZBwp4l9P/qLOvA+p3LNdYl8+ppf0vKokVb8KablI7jVuZpBS8iHBY1mkQFYJmq3PTu0oM9fB6VujVq6MLwEEStKwfE/hGnLhFonZQoDm1qXP7nvJ297r65QsiQY0M1FEBiQO45u4QdS7ZOj0yGQx552hR1YCfds9iaMCOmZ67lPqhley9+JZtBNdoGlLI9kUUMMiKcF8bh4HIj8UyiKgt1KYCUbZMK8SRW/DJZaJfmnj70m5FSrw+U8k0G2cATl5popVsCDNU9ZAEGye/vQ3WExV5UAr0oBrsaySP2KOqQFfSJnD3SN3B4u9QBzHQ6UQD/yrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wt66aTPIoM3XVpKVU/8eW/w+SOJnPQe9QlO9+MlIB/Y=;
 b=F/wDokOj48JwRGPa54mvkh+WwSDc8qHIiJNiJCUFToz7WO6RjzReyp3ls+Kmp+S+MaNp2xgy7Ds804cYORvw77IjPse8BUSsNm2l9fXsEpdIemIJlEKRazqCpl2OCHfAtALlzLZe5m0FpEthu/c+wPUJNXGySsyaloDdqIDEpLoWHX74aqnVoMmL5aD3sOexbCBxj1bE2t5rFRNfG2qelowC7WhjZyABouUZVhQAciCF3jd/9wGZoEaSIhca7iJZN4zoJTqsC1ff4e2oxhMAdxoQJb4ByBzHtemtdzrOi58kfBBb6bKLeNojZT7ce4D8JnPA+Wk/38gLEOUck7pcPw==
Received: from BN9PR03CA0101.namprd03.prod.outlook.com (2603:10b6:408:fd::16)
 by BN7PR12MB2707.namprd12.prod.outlook.com (2603:10b6:408:2f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 14:49:21 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::67) by BN9PR03CA0101.outlook.office365.com
 (2603:10b6:408:fd::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 12 May 2021 14:49:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:49:21 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:49:20 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:49:17 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 10/18] netdevsim: Implement devlink rate leafs tx rate support
Date:   Wed, 12 May 2021 17:48:39 +0300
Message-ID: <1620830927-11828-11-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9143bd1-9ed3-4fb6-637f-08d9155520ac
X-MS-TrafficTypeDiagnostic: BN7PR12MB2707:
X-Microsoft-Antispam-PRVS: <BN7PR12MB27072A99220D67C924537584CB529@BN7PR12MB2707.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:166;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oB1MfrlynJ4ffV57ocQrMr47/EF+8jANiLsnjN0v5Ax9EtJpL1TzKz9E+LVdpqyzR6mfxKtgE9jtzlVYVT5EK3stH357Qz95X9au3OhI5/k/9pVtwMR1KzjHeHIWM9ukRD3hXfSUPbuwDBcl5CAd0w/KT1mSfD13170t+l+1ldn1tPyS/MWUrW9XdQ0bCph8zS/oTHxFgkzorV00dq//0Y6oPB7nBHu6jhN5OkkqiqUvlIoez6xXcyvdIehnwk/MlMxbKp/H494SGimZIcoNUgjNXuwNIGaYmy/HpBZCydfM4s8OMriKGIfzvX3d8v6+QVeep5OPBdoRNT9r5vsQtdTB3R+t/hV9+XFHhh8ODlYYHJMcMbFY/zwoSV6iVTumXG2jY1JhbC4DwNmljQjWZmsRSeexcxGIH54IqX6b6SkLIz/8s7qhrE0RibEdnFRFCodTbjdfbCSf/8gxeAIGJoDu+9O+jaIy8nV4n+F8fE5tMWzoHJeHvEP7zEZ88E/7Jzliq4F9ERcbD/aZGQTg/1nlcRfZCMpKh+i/ZfdX2HVaVBZHQ2LiIdevEKYWss55StwWRFATsLRgzCViXOZyWQSmkUXO/JZkR0xfXggwXR7yJ0/F0dYu/hbK08EfQqMdnVJFS/ihwDdxsaTSaD/uLegsH89you3BP/xjCgjmPsA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(376002)(36840700001)(46966006)(7696005)(36756003)(70586007)(70206006)(6666004)(426003)(86362001)(26005)(478600001)(36906005)(186003)(316002)(336012)(54906003)(2906002)(83380400001)(36860700001)(8936002)(107886003)(82310400003)(2876002)(8676002)(82740400003)(356005)(6916009)(7636003)(5660300002)(4326008)(2616005)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:49:21.2338
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9143bd1-9ed3-4fb6-637f-08d9155520ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2707
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Implement new devlink ops that allow shared and max tx rate control for
devlink port rate objects (leafs) through devlink API.

Expose rate values of VF ports to netdevsim debugfs.

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/dev.c | 78 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 75 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 356287a..5be6f7e 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -276,17 +276,26 @@ static void nsim_dev_debugfs_exit(struct nsim_dev *nsim_dev)
 static int nsim_dev_port_debugfs_init(struct nsim_dev *nsim_dev,
 				      struct nsim_dev_port *nsim_dev_port)
 {
+	struct nsim_bus_dev *nsim_bus_dev = nsim_dev->nsim_bus_dev;
+	unsigned int port_index = nsim_dev_port->port_index;
 	char port_ddir_name[16];
 	char dev_link_name[32];
 
-	sprintf(port_ddir_name, "%u", nsim_dev_port->port_index);
+	sprintf(port_ddir_name, "%u", port_index);
 	nsim_dev_port->ddir = debugfs_create_dir(port_ddir_name,
 						 nsim_dev->ports_ddir);
 	if (IS_ERR(nsim_dev_port->ddir))
 		return PTR_ERR(nsim_dev_port->ddir);
 
-	sprintf(dev_link_name, "../../../" DRV_NAME "%u",
-		nsim_dev->nsim_bus_dev->dev.id);
+	sprintf(dev_link_name, "../../../" DRV_NAME "%u", nsim_bus_dev->dev.id);
+	if (nsim_dev_port_is_vf(nsim_dev_port)) {
+		unsigned int vf_id = nsim_dev_port_index_to_vf_index(port_index);
+
+		debugfs_create_u16("tx_share", 0400, nsim_dev_port->ddir,
+				   &nsim_bus_dev->vfconfigs[vf_id].min_tx_rate);
+		debugfs_create_u16("tx_max", 0400, nsim_dev_port->ddir,
+				   &nsim_bus_dev->vfconfigs[vf_id].max_tx_rate);
+	}
 	debugfs_create_symlink("dev", nsim_dev_port->ddir, dev_link_name);
 
 	return 0;
@@ -990,6 +999,67 @@ static int nsim_dev_devlink_trap_init(struct devlink *devlink,
 	return 0;
 }
 
+#define NSIM_LINK_SPEED_MAX     5000 /* Mbps */
+#define NSIM_LINK_SPEED_UNIT    125000 /* 1 Mbps given in bytes/sec to avoid
+					* u64 overflow during conversion from
+					* bytes to bits.
+					*/
+
+static int nsim_rate_bytes_to_units(char *name, u64 *rate, struct netlink_ext_ack *extack)
+{
+	u64 val;
+	u32 rem;
+
+	val = div_u64_rem(*rate, NSIM_LINK_SPEED_UNIT, &rem);
+	if (rem) {
+		pr_err("%s rate value %lluBps not in link speed units of 1Mbps.\n",
+		       name, *rate);
+		NL_SET_ERR_MSG_MOD(extack, "TX rate value not in link speed units of 1Mbps.");
+		return -EINVAL;
+	}
+
+	if (val > NSIM_LINK_SPEED_MAX) {
+		pr_err("%s rate value %lluMbps exceed link maximum speed 5000Mbps.\n",
+		       name, val);
+		NL_SET_ERR_MSG_MOD(extack, "TX rate value exceed link maximum speed 5000Mbps.");
+		return -EINVAL;
+	}
+	*rate = val;
+	return 0;
+}
+
+static int nsim_leaf_tx_share_set(struct devlink_rate *devlink_rate, void *priv,
+				  u64 tx_share, struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_port *nsim_dev_port = priv;
+	struct nsim_bus_dev *nsim_bus_dev = nsim_dev_port->ns->nsim_bus_dev;
+	int vf_id = nsim_dev_port_index_to_vf_index(nsim_dev_port->port_index);
+	int err;
+
+	err = nsim_rate_bytes_to_units("tx_share", &tx_share, extack);
+	if (err)
+		return err;
+
+	nsim_bus_dev->vfconfigs[vf_id].min_tx_rate = tx_share;
+	return 0;
+}
+
+static int nsim_leaf_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
+				u64 tx_max, struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_port *nsim_dev_port = priv;
+	struct nsim_bus_dev *nsim_bus_dev = nsim_dev_port->ns->nsim_bus_dev;
+	int vf_id = nsim_dev_port_index_to_vf_index(nsim_dev_port->port_index);
+	int err;
+
+	err = nsim_rate_bytes_to_units("tx_max", &tx_max, extack);
+	if (err)
+		return err;
+
+	nsim_bus_dev->vfconfigs[vf_id].max_tx_rate = tx_max;
+	return 0;
+}
+
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.eswitch_mode_set = nsim_devlink_eswitch_mode_set,
 	.eswitch_mode_get = nsim_devlink_eswitch_mode_get,
@@ -1005,6 +1075,8 @@ static int nsim_dev_devlink_trap_init(struct devlink *devlink,
 	.trap_group_set = nsim_dev_devlink_trap_group_set,
 	.trap_policer_set = nsim_dev_devlink_trap_policer_set,
 	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
+	.rate_leaf_tx_share_set = nsim_leaf_tx_share_set,
+	.rate_leaf_tx_max_set = nsim_leaf_tx_max_set,
 };
 
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
-- 
1.8.3.1

