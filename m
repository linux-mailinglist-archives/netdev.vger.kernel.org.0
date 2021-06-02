Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB8B39893F
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhFBMTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:19:55 -0400
Received: from mail-mw2nam12on2065.outbound.protection.outlook.com ([40.107.244.65]:27360
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230025AbhFBMTt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:19:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SS9prnkc2o7RGN2yEGSuCUteHHFNLmOOliUypUDrREQUjhvX2vv00habhcE12+9O/GZY4YUMKw79shKAu47CoI/qOBZhEMADRsbkA5XVDYvV2hOFuWEDebYkBvAjAGHBuOU/WG1OA39dR3Xcp75pQeI43pwLkqHFdjotu4Wu68Va7UdOssYdEZXw+rEPdTi59Fepb47tbpAMUESuNObRPQ8Y8Vwj/Rh6k2Of0ZFDs2nhB7gnTC7AWHdaKs7jWA9X83XJi2t7lZQscHBInw2AgIzDNrT5R3kLdXzAWd73+UUfRw3B2xV2MaCLLK92yKsSWFGx/I/7E/Jw3qkSXBTkKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wt66aTPIoM3XVpKVU/8eW/w+SOJnPQe9QlO9+MlIB/Y=;
 b=OMuOEEFaEC+IDbp/qKSzwARjVI5RaZ7Px54kS7MtQ8uDyCGWF60x3YlS/khqLDf501MKZ2BDv1MZsESHOvo8QGiV58MlkgxKeESA7t1CPZOpwd91R5mQIEcK4oMe8w1OgJk8n2J1kb77wit15vIBGZIiBEgSHFL8bEVyIpXKuKQUL5qNLw5yy7oIt+gMMh1gZRJuATnRVNBrGw6to0Ns+KSA2EqgFSdjmG7DSd8+6Rj8s8fXDlVmJRUOJSUOSf8Fp/ySqgHHEmLFL3Qt/kzKGb3KSrvsX/k/IH5cTfpk2BN1zMuDm8T6dYsjIkyWN2cuDBAEls5pqAxQUbloua8H0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wt66aTPIoM3XVpKVU/8eW/w+SOJnPQe9QlO9+MlIB/Y=;
 b=MHfTtEwi/CCHR0sAg6F+loPll+G95eVG6HG5z8fMQfwKj1trlx/3R14YOuS/ws6n0ZII/wPOMf7a3EGKPLuZiTlf9cPzo3hpdHGDFerfA092xBG8fIRTtgnHKS4p5rKag8Icu7+T1TO/S6sS/6LwyajqffFZC8zNCyGIIQ15hfXc9kriIYzSek84qU+Rahp4IlNIpCb2OJvR3KgGylilurxpZKKeF6D/2XO0WDaWeRjZsnF+b0U6PcaMHuZufQ51gIXElDw1Drvr++gkCtqpWYTxS0iptsKt+mnZ37T4fzwOBnBH/3lD6FNC6tLV2jBiG17sI/31wtLQLUnNDltUdA==
Received: from BN7PR02CA0004.namprd02.prod.outlook.com (2603:10b6:408:20::17)
 by BYAPR12MB4709.namprd12.prod.outlook.com (2603:10b6:a03:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 2 Jun
 2021 12:18:05 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::36) by BN7PR02CA0004.outlook.office365.com
 (2603:10b6:408:20::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend
 Transport; Wed, 2 Jun 2021 12:18:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:18:04 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 05:18:03 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:18:01 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND net-next v3 10/18] netdevsim: Implement devlink rate leafs tx rate support
Date:   Wed, 2 Jun 2021 15:17:23 +0300
Message-ID: <1622636251-29892-11-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c296f269-5591-4694-3985-08d925c07958
X-MS-TrafficTypeDiagnostic: BYAPR12MB4709:
X-Microsoft-Antispam-PRVS: <BYAPR12MB47090160A17A357DD4384E2CCB3D9@BYAPR12MB4709.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:166;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oyYL5vNelPv5DEcfAteEcD3LhhJyZHteK208toB7svqr92qq8OJi074qrD7MWKl0YAxQ586mmTEk4qKc8EsppqtewpBYwpRoZb+SzbEoLfFRH8UlA2od+9qnJH3qdELAfZfGDBZV1QBjeiB+IxiY+z+roR4VGZykhfpyAq8IiesgcNOzd75yxBHZrt5hgxxF5OlDSrkIG9djT5PX6zdenzMzlgb3pewuE7TXFfkCOEvy6StXDzQ/HAFQvtO1pIyABIgr5oZUNmFuZtR1jvbBlbVvR4r4dWjNkuwiAPPBc45TMMNyuNyyHI8kHXEiyY6uCT7bz9QiKGJBZpquQMfDLaU18ZmuBBYXnien1uj0E04Xvf2I5Qke39yZL8DCfc1MoE2dKqDA0kdQA7w/95ryhFvFl6zGXm7mirQqTViSNR4wXJIvfHpHXwyu5mDtxWv1A8T/qPW30adQNaDADA5NbPejNb0ARGNC+e0dykuMa/vdYqtqBpln3x3Ho0CeJQ3Nc491pvu/RJ9881eI5kE9SiildEydnwnusX6Ei18Iv9xjcRAz8zUVelXW0x7FXc6iuAuYsBHmjh+NCX6712g28Mn/FV3kUmfdCElWH1pZvnTxMjtzzoHCFC5p/J2X1JpeWVk8ivJU0V8yaXSwZ+KSC4jleCHeVut7zOojyc0tw9w=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(136003)(46966006)(36840700001)(83380400001)(82310400003)(478600001)(107886003)(336012)(5660300002)(8936002)(6916009)(4326008)(2616005)(426003)(2876002)(36756003)(186003)(6666004)(36860700001)(86362001)(54906003)(7696005)(316002)(2906002)(26005)(82740400003)(70586007)(7636003)(356005)(47076005)(8676002)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:18:04.7550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c296f269-5591-4694-3985-08d925c07958
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4709
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

