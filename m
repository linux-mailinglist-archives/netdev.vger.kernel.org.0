Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7DD3916F5
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbhEZMD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:03:28 -0400
Received: from mail-dm6nam12on2044.outbound.protection.outlook.com ([40.107.243.44]:29217
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233387AbhEZMDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:03:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iF+U3oUUfSo80Ac33VkYgKT9a4vMNuAaphMWFjEmDOkjmzFVWc2Yn1HO3Lnrtbxnif+JvFhUp054Jq6x+6NQYRBn+douZj1ST+yvM+Zx8KJjfrUCeATtD+HNwzsiVNszlg4B2k8BVsi64Yq73w+fftD7BWZoTajQgYws1W5xfgDEGhBjXdKYi7gV4UdI/wjOocZjSqJPbQud+N8Z3/fbSgZhi/ydyvGlR7EBXozzzs9PEoAjiZzeDZweZy+nYM1/lemAX2OszL2nB93xYdukFTYVZHCn+0ApuFOO9zrZ5ghanKQBSoZODYKrig3xfTuUqxmnzbM6R5+hkaOjSPCkAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wt66aTPIoM3XVpKVU/8eW/w+SOJnPQe9QlO9+MlIB/Y=;
 b=c2a7pKnrCUDrD2daf9IDSiocJDj++RdrzgvwHDxwzvedFF2FBr60zZyW74P+mBixEAGzzAiWknkFywjheyi5E4O7enpTRlyKi6wLimZFs2AJ3ufKZxfRi5nWFwv3uU8pCccRuBDcVqcjVOinUZ9bycNmSYZJ5+iQlBAAbiawhqhtQtJtAwhDiZMZanGdik1d88dS/HRBJLsM/HSym3ffCd+Dn9oJ6W7bKJJQioSuZAR441CKpkKnycevEo3YUF1nmTA3Z/dnJYykRxi92lAzjPdp5WmkmN2nhMG9bw33hWsUdYDQWtjm+xs7hA4AkYTp+eME5rIUlzw8vkLLjh3j6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wt66aTPIoM3XVpKVU/8eW/w+SOJnPQe9QlO9+MlIB/Y=;
 b=c/vgcVUdgR7/2wX5lipq3FhZcjjgn6g2G2jalZjitBYq89BzppiyTEc4Cl/IQovpnvsnlL92WgpSDNvCvChCXawuaX8kKS6zJXyxobMrklD1Hm91Q946xVz4u2nJdzlRSpsbCpfxfTJPt3nNVErWBgacNUW7Atw9lg+1GgEXot14tiE67kUa9/QrdlcF+SpWdJID2WCKbcQkyCzWIESK4BQhjFFV/hMQawLxfIP2fMAu9cFfUSDm+BRniivZremCcRmuycaq19ooGNQztCGuFWq3PP12eMZqRI6dO9+WKGxO3dcOusfiEgy3u23oGx6LfFVH4Is/QLZzj0SGjIzKMw==
Received: from DM6PR05CA0048.namprd05.prod.outlook.com (2603:10b6:5:335::17)
 by BY5PR12MB4002.namprd12.prod.outlook.com (2603:10b6:a03:1ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Wed, 26 May
 2021 12:01:44 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::78) by DM6PR05CA0048.outlook.office365.com
 (2603:10b6:5:335::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9 via Frontend
 Transport; Wed, 26 May 2021 12:01:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:01:43 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:01:43 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:01:40 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v3 10/18] netdevsim: Implement devlink rate leafs tx rate support
Date:   Wed, 26 May 2021 15:01:02 +0300
Message-ID: <1622030470-21434-11-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
References: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ca8d985-5b90-455a-641e-08d9203e07c2
X-MS-TrafficTypeDiagnostic: BY5PR12MB4002:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4002740F634ECB1BF226A723CB249@BY5PR12MB4002.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:166;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ItN+64rLhm1aXbahhaVOEUNr83lnmJRS39xW3ryBqcXVlL80nC4gs+ck4RPqjvMBETx+t5PSAogTXuS0+Z+axsMAnCiMlbvwCMMk/BUHKOzxp+toikQ+s7KMlYMaOIzynVEHb7lt5H6tn+bd2TFKRIx9IqIACCRdaBtHwiUTR1x+8qyJXhOgunVbwx2wspUOp2FdVoius8hdmcUOoKQ5sCltRq9pFbmn5mXxZAMD9Ng1+4oDyDWBrs74U0QVMCb1SsWic+fId72Bxrx8qFtLhhHMTO5wAGFiAQXMzdal9W4ZXslp6vJtS3JcSg0HnXRtqg8sJi1ajxcl74nGJNjwEqA6YwN7eCo9pWOLyfPFD5rKacIbujRiT7aeZz/v7WH+IWt7sCrJEa3UR89P71zwv2r4/qJv/ZtEbOCf6EmOKUJa2G8KD9/RG9Ol5QLyI+jp+naYMBh/mlh3BgkiQx11pPpNYCJbTtPz6ww/v6MpYXnLgqLAAEKA99+rY54ssV5U9wu9bR8lkNPEUU/84IGcQZB2hNIoAf00T/dFc+3cXSK51eweOQvaNnTCkDq82InrQRqckWrXr6WMQKljw+06mycxdRCvYWZtoDFifZJ7G7vnC6f1fKdwP1BUfc1x98vGvy6Kl5baXMYwpM263Jvv6QLtBt2WPDgeyl795J/8DAE=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39850400004)(36840700001)(46966006)(82740400003)(107886003)(186003)(316002)(478600001)(8676002)(36906005)(54906003)(8936002)(2616005)(4326008)(70206006)(83380400001)(70586007)(26005)(47076005)(36860700001)(7636003)(356005)(7696005)(36756003)(2876002)(426003)(5660300002)(2906002)(336012)(82310400003)(6666004)(86362001)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:01:43.8697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ca8d985-5b90-455a-641e-08d9203e07c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4002
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

