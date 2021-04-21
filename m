Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDE8366F7B
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244168AbhDUPyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:54:31 -0400
Received: from mail-dm3nam07on2064.outbound.protection.outlook.com ([40.107.95.64]:21377
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244150AbhDUPyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:54:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGzMwRPJQdqtiYUezkPWy+/uFchIMoEDksmFxlmQD8GTVVvYA1P///4qCGNI1VRCT8oQuOqucVyJRElxrK1+4egIMFHqcsXCfLmzMUxba7hA3z3eyYkQ7Xzt9L9g7UFWxCjpAEhRuNMOhxLNJZb+q56mUI6ZQnvVZIzWRY16ss/JLqFRaLhSNKdk4rHNzoVMqa3EpbCXs88URZlU9VGRV1+hKqT9qCNOJrAQr0A7s1QgiOsQT1HW4WR5IDwddmYVw6O4EeSIhyLPu8sU3/DEnJZ+Da0nIojYy7pmYN0wW0/nPi9aPXzPLa5NTwrzEIQsqIEf27tiJ5vDOmLWSLBNXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+0AKlKMFkcBr6wS14xi5JBTHdfBtvmB4W6wM08MndY=;
 b=f0Os9TmSZEMydOA6ji0zdyEr4voc/mPrrX+mn3bL3D5ihovGLw78r1gnxmMtX55SqKR5IVTqqX9Gy74yv0+8S0r+LzozSCpD7dy7/gGHT0PwJ++JjfmA6fLu9M9EMAOmFy+DNr00h9tCas6ZQRF1dGxtgI+c1C9Jm9j767aMhDMi82dKsWAM2h8QiEpUk4U5YjaDr/lb3SFF/vBDhEEkaZvz0aKY5sQHqSJSTQzRiT1abhYJG8hxtLL8aB4jE/AOvNtn9/ulr3ev7wV+ZwSbi7vPzlhuLncjHDrUEHWQ8TYZqpxZjTyrX5A89FZ7S+7LcB/D4fw9h3mU4igCwgpRqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+0AKlKMFkcBr6wS14xi5JBTHdfBtvmB4W6wM08MndY=;
 b=F+Sw4lRofdLZR81gGs0XJ1DKsTpJBgSXpOWXkjIIWL3qJb13WHfHxI38bdTvEK04qSqxpCvk1cRsGt4SAi3XZuydXdntthijDXrdK51v44RfzJamMOGsRXLjpVW6GNkmE70mi0Sqgha8ZNQkNjYumUcFfjkN+lCIIOV6EBleSe1EWNt7aQRzAM8lckxu23HWHJUH/YMiuJaa0CxseSbWoRs3pRHN6TcFYZfDONT1dgurbpbSWxEVM3kA2Q/PixP4kGzTgmy6F7u94GBXdJND8lXFVfJ1BN0XsDDALqvKXYNOp31HgPIMbFytiGjhJ+rvPA+ca6EIAYy2bVED+ysV/w==
Received: from MWHPR1701CA0016.namprd17.prod.outlook.com
 (2603:10b6:301:14::26) by BN6PR12MB1330.namprd12.prod.outlook.com
 (2603:10b6:404:1e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 21 Apr
 2021 15:53:34 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:14:cafe::1) by MWHPR1701CA0016.outlook.office365.com
 (2603:10b6:301:14::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:33 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 08:53:33 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:31 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 10/18] netdevsim: Implement devlink rate leafs tx rate support
Date:   Wed, 21 Apr 2021 18:52:57 +0300
Message-ID: <1619020385-20220-11-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac8102b0-736c-40d2-856a-08d904dd9e40
X-MS-TrafficTypeDiagnostic: BN6PR12MB1330:
X-Microsoft-Antispam-PRVS: <BN6PR12MB13308085C5F7B54F5E93625BCB479@BN6PR12MB1330.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:166;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jmy/HHO3IJ8x36j6d64Z52V+/TvrhGTR/o4VrzaSEVpde4Fo0WGbtbXu6dIOAVLKbn8OjUmZeh80Hd19gMJSG1OYSJYtV0XthhgJzD3dLqs84p+uMnexNUxJ4ckYw8S6eG5vpn5jtlFD0WDXfgHvdR6gYhaZP+DDMDo16vNUN9tJ9B0gRaEw+ElC9k0iYzMDka6i/8cm2f3aE1/nmvVT9X6ANTISQRaKamjry0UdNTJO45Pes6m4W0FV0G14JcKVDvUEI5YRKFREpXe3Z0Lk20bIODNDEy3IjYnEszB7rMof6sc4Z+GXAHYxElpgMh6goxRQrcNZUNGrAhiuYSUttSIC2U0n83nmGOGVA3uwN+Nc7ejSNYPoX+AKMbIqQ9NwNlOhkOYvS6EoY5+gbkk1S5A245AkcQddZOcNyEdH7XDfJlv6a5e5Bg7EKXAI5JwItGejQg6xyb6OqDq1apBFO8NTTqQ0LYDxyHx4ygdPmU/Vjud4wND2afA9QVmULV659YMnDiw8kvhMML2x+lBEkMC8vFcHGrezkD1SW4jMgLqDNr9hXhuzIUAlu9VRe193EFMgWETTcEmcg/S4doi+fmUngeHBKodbZhPzZ0f++mba0UVUk0QSFKAdm/dg+z9VntJ5J4OWXMmNyjb3XaE5cS/St6SlR3ilUHvF0xYTkdg=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(36840700001)(46966006)(70206006)(478600001)(6666004)(316002)(83380400001)(2876002)(82310400003)(7696005)(36756003)(2906002)(54906003)(36860700001)(426003)(107886003)(8676002)(26005)(186003)(5660300002)(4326008)(7636003)(356005)(336012)(2616005)(47076005)(82740400003)(8936002)(6916009)(86362001)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:33.7778
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac8102b0-736c-40d2-856a-08d904dd9e40
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1330
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
 drivers/net/netdevsim/dev.c | 77 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 356287a..a6dfa6b6 100644
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
@@ -990,6 +999,66 @@ static int nsim_dev_devlink_trap_init(struct devlink *devlink,
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
+	u64 val = *rate;
+
+	if (val % NSIM_LINK_SPEED_UNIT) {
+		pr_err("%s rate value %lluBps not in link speed units of 1Mbps.\n",
+		       name, val);
+		NL_SET_ERR_MSG_MOD(extack, "TX rate value not in link speed units of 1Mbps.");
+		return -EINVAL;
+	}
+
+	val = div_u64(val, NSIM_LINK_SPEED_UNIT);
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
@@ -1005,6 +1074,8 @@ static int nsim_dev_devlink_trap_init(struct devlink *devlink,
 	.trap_group_set = nsim_dev_devlink_trap_group_set,
 	.trap_policer_set = nsim_dev_devlink_trap_policer_set,
 	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
+	.rate_leaf_tx_share_set = nsim_leaf_tx_share_set,
+	.rate_leaf_tx_max_set = nsim_leaf_tx_max_set,
 };
 
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
-- 
1.8.3.1

