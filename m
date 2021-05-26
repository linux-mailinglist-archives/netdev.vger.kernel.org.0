Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C105D3916F4
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbhEZMD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:03:26 -0400
Received: from mail-mw2nam12on2042.outbound.protection.outlook.com ([40.107.244.42]:37697
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233298AbhEZMDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:03:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWrcuKQN0AhQjZ6Gw0IiPHJ5WX6UXcDRJ1GcjwNlS9CTlR1heLvFkWQNGhBoBF204eLWAzWmmGM/+YzuNMHr7OIyDyrAInEJ0MQhuxooGEV34Oxy2xCszkyGifZvhFtu7aqzpSP6Pm992n1jLVrltEny+2s02/lRSWfGr6MUfRyn7WUpCOXZWQdVRUjqJnS+PIqRLy6jewT1I3KiROfJOHVkjjvBedPLw2fw+JTV04/vz1DrcP0yYlu95EXjAnWt0fC1EQSrTBul/LDicfLDGNEy2d7inZJ5HHVbyxUDfohfm+9xZjuLRNFqCHNv/X2PbrB48hLG+bw1kLVGi4o35A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQMyxiukSmLRp5rqH5Ch0q79KCPOdOg1wb4fhUALKf0=;
 b=hJjFSutTcKwobHPqtvu2mpQKA3nt2+6Z0cTrypWUFx3qCaHVhcI8WM6x7RWucvEkPirIy0Yr3ipsqzDQakygiseY9b2dG6aKWMVVbn703UaLxI1Z08hImY3thuBq3VpzyGqhEPvB5suCAUDxFcrM/+mfURKSaYNVqO0RH3TCDX0f80/oROSwWCzIHIOVZ/WnNO5SQPZzwjasa8RfaVxLN/pnE/YpD0d5amDrL4BFc0zjmxn0uyQ/WVMdnFJ5kZuuk5hKQPfsTi+rXbEqi8yE8KnhRBcmGIiyl/LqWzBa1eHoJHDXYgWyQfNkJkoVBjBN+t4KcWY3fMFJN2aY8SaoCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQMyxiukSmLRp5rqH5Ch0q79KCPOdOg1wb4fhUALKf0=;
 b=S288AIiaNcnJ6b6YZqKDLEBDH2snjmoOu/rgPi23p4TkFXf35N1bXS5OXTFexzp+LvGXL/dHNzMz54YzSHw4RiKY5yGA5loMoNk8AtEJZ8Qf2lDJRrXp1IT08jz/dsETAhPAECrRYjnHCFfset4/4PlWauLLH7pC07vcuZItat/j1PYZfuHnD1CUzWW50oixvCIgvngCOP3QFUHS//UYsq3i6DkWImrb98SLY/cEAebMzBhqCltzCZ4xuF3hxTn9oeDOiqXcbQS7Ej+qqNpHFApk71yO1lU4Rb4byZXnvrM97V/3ueNHkz8wM9ifhel0NcESc2+ZuvFeSobzhCkV7w==
Received: from DM6PR02CA0165.namprd02.prod.outlook.com (2603:10b6:5:332::32)
 by CY4PR12MB1190.namprd12.prod.outlook.com (2603:10b6:903:39::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Wed, 26 May
 2021 12:01:42 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::69) by DM6PR02CA0165.outlook.office365.com
 (2603:10b6:5:332::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 12:01:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:01:42 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:01:29 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:01:26 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v3 05/18] netdevsim: Implement legacy/switchdev mode for VFs
Date:   Wed, 26 May 2021 15:00:57 +0300
Message-ID: <1622030470-21434-6-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
References: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5baaa01-387c-4a9f-dd0b-08d9203e0705
X-MS-TrafficTypeDiagnostic: CY4PR12MB1190:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1190B60B4CE26EBA69D0D676CB249@CY4PR12MB1190.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0GMXxjlpCZCd8B2d8oIQT2QzcbpN2czScQKaTfEvE8/fpovORtHzATkZOdF7PQQ2vm0XUA8IrQKvcOxoSCP58fh/fTwxIfYMB/XX9diIA7yzubUhNZMpog6vB6K4B0WIgrJpavv+RxmdJL8zyjPodXDxXHfyhFqPliziyw2bHh8u4W7UDobeZ/ETbFJSeZC/aG6IcQSVLCImJ3KiesrGOHej3PSJE/Us0XE1VTze1iy8aVWX6wn3CmNI7FJca5zCqPh9nnMKoYhNlGaempqAvLk9ZB3OMPsssICuqvu8pRDd5CVxoGSD7vvawCCt0s8z3T67ZVjsQ7bsIyuC+IcNf49aOLubuJF/K+x3aeCrts3vMnpZiKjoK8O1JfE5DKr8FIQjtFiaGwQLrNJXEYuWK5v6/mGIoINYVrD/IVya9tL472hSjL4jCwZRn0u7hqv/krdB14E0xqXMFAkG3VZ9VMmp6syb8EkTFzd0j/tk+Lo7sVwUbrT1c+RBi7XmRKOZ2lDz+cv6f5vtSiIf1m8FXL3KOOIoAXs7xzBbmYc814OOXuJZeuWOF9ybcPTvvN5uRzLf+DoGXwAqwD8ZDL7qTP+aiVzotxDJiOUzG9z27xKQg2ladGiSgMKUNpT1LPe9AoglV6A5ExSdBuUhqVFhiOZ2k/FNJfEDZjDp7KNmUkg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(47076005)(83380400001)(7696005)(36756003)(336012)(70206006)(36860700001)(8676002)(70586007)(7636003)(356005)(186003)(82310400003)(498600001)(8936002)(54906003)(26005)(4326008)(5660300002)(426003)(36906005)(6666004)(107886003)(86362001)(2876002)(2906002)(2616005)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:01:42.6352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5baaa01-387c-4a9f-dd0b-08d9203e0705
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1190
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Implement callbacks to set/get eswitch mode value. Add helpers to check
current mode.

Instantiate VFs' net devices and devlink ports on switchdev enabling and
remove them on legacy enabling. Changing number of VFs while in
switchdev mode triggers VFs creation/deletion.

Also disable NDO API callback to set VF rate, since it's legacy API.
Switchdev API to set VF rate will be implemented in one of the next
patches.

Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
---
 drivers/net/netdevsim/bus.c       | 17 +++++++++-
 drivers/net/netdevsim/dev.c       | 69 +++++++++++++++++++++++++++++++++++++++
 drivers/net/netdevsim/netdev.c    |  5 +++
 drivers/net/netdevsim/netdevsim.h | 14 ++++++++
 4 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index e29146d..b56003d 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -27,6 +27,9 @@ static struct nsim_bus_dev *to_nsim_bus_dev(struct device *dev)
 static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
 				   unsigned int num_vfs)
 {
+	struct nsim_dev *nsim_dev;
+	int err = 0;
+
 	if (nsim_bus_dev->max_vfs < num_vfs)
 		return -ENOMEM;
 
@@ -34,12 +37,24 @@ static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
 		return -ENOMEM;
 	nsim_bus_dev->num_vfs = num_vfs;
 
-	return 0;
+	nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
+	if (nsim_esw_mode_is_switchdev(nsim_dev)) {
+		err = nsim_esw_switchdev_enable(nsim_dev, NULL);
+		if (err)
+			nsim_bus_dev->num_vfs = 0;
+	}
+
+	return err;
 }
 
 void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev)
 {
+	struct nsim_dev *nsim_dev;
+
 	nsim_bus_dev->num_vfs = 0;
+	nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
+	if (nsim_esw_mode_is_switchdev(nsim_dev))
+		nsim_esw_legacy_enable(nsim_dev, NULL);
 }
 
 static ssize_t
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 8bd7654..ed9ce08 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -439,6 +439,72 @@ static void nsim_dev_dummy_region_exit(struct nsim_dev *nsim_dev)
 	devlink_region_destroy(nsim_dev->dummy_region);
 }
 
+static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port);
+int nsim_esw_legacy_enable(struct nsim_dev *nsim_dev, struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_port *nsim_dev_port, *tmp;
+
+	mutex_lock(&nsim_dev->port_list_lock);
+	list_for_each_entry_safe(nsim_dev_port, tmp, &nsim_dev->port_list, list)
+		if (nsim_dev_port_is_vf(nsim_dev_port))
+			__nsim_dev_port_del(nsim_dev_port);
+	mutex_unlock(&nsim_dev->port_list_lock);
+	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
+	return 0;
+}
+
+int nsim_esw_switchdev_enable(struct nsim_dev *nsim_dev, struct netlink_ext_ack *extack)
+{
+	struct nsim_bus_dev *nsim_bus_dev = nsim_dev->nsim_bus_dev;
+	int i, err;
+
+	for (i = 0; i < nsim_bus_dev->num_vfs; i++) {
+		err = nsim_dev_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_VF, i);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to initialize VFs' netdevsim ports");
+			pr_err("Failed to initialize VF id=%d. %d.\n", i, err);
+			goto err_port_add_vfs;
+		}
+	}
+	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_SWITCHDEV;
+	return 0;
+
+err_port_add_vfs:
+	for (i--; i >= 0; i--)
+		nsim_dev_port_del(nsim_bus_dev, NSIM_DEV_PORT_TYPE_VF, i);
+	return err;
+}
+
+static int nsim_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
+					 struct netlink_ext_ack *extack)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	int err = 0;
+
+	mutex_lock(&nsim_dev->nsim_bus_dev->vfs_lock);
+	if (mode == nsim_dev->esw_mode)
+		goto unlock;
+
+	if (mode == DEVLINK_ESWITCH_MODE_LEGACY)
+		err = nsim_esw_legacy_enable(nsim_dev, extack);
+	else if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV)
+		err = nsim_esw_switchdev_enable(nsim_dev, extack);
+	else
+		err = -EINVAL;
+
+unlock:
+	mutex_unlock(&nsim_dev->nsim_bus_dev->vfs_lock);
+	return err;
+}
+
+static int nsim_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+
+	*mode = nsim_dev->esw_mode;
+	return 0;
+}
+
 struct nsim_trap_item {
 	void *trap_ctx;
 	enum devlink_trap_action action;
@@ -925,6 +991,8 @@ static int nsim_dev_devlink_trap_init(struct devlink *devlink,
 }
 
 static const struct devlink_ops nsim_dev_devlink_ops = {
+	.eswitch_mode_set = nsim_devlink_eswitch_mode_set,
+	.eswitch_mode_get = nsim_devlink_eswitch_mode_get,
 	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT |
 					 DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
@@ -1177,6 +1245,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 
 	devlink_params_publish(devlink);
 	devlink_reload_enable(devlink);
+	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 	return 0;
 
 err_psample_exit:
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 9352e18..c3aeb15 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -113,6 +113,11 @@ static int nsim_set_vf_rate(struct net_device *dev, int vf, int min, int max)
 	struct netdevsim *ns = netdev_priv(dev);
 	struct nsim_bus_dev *nsim_bus_dev = ns->nsim_bus_dev;
 
+	if (nsim_esw_mode_is_switchdev(ns->nsim_dev)) {
+		pr_err("Not supported in switchdev mode. Please use devlink API.\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (vf >= nsim_bus_dev->num_vfs)
 		return -EINVAL;
 
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index e025c1b..13a0042 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -257,8 +257,22 @@ struct nsim_dev {
 		u32 sleep;
 	} udp_ports;
 	struct nsim_dev_psample *psample;
+	u16 esw_mode;
 };
 
+int nsim_esw_legacy_enable(struct nsim_dev *nsim_dev, struct netlink_ext_ack *extack);
+int nsim_esw_switchdev_enable(struct nsim_dev *nsim_dev, struct netlink_ext_ack *extack);
+
+static inline bool nsim_esw_mode_is_legacy(struct nsim_dev *nsim_dev)
+{
+	return nsim_dev->esw_mode == DEVLINK_ESWITCH_MODE_LEGACY;
+}
+
+static inline bool nsim_esw_mode_is_switchdev(struct nsim_dev *nsim_dev)
+{
+	return nsim_dev->esw_mode == DEVLINK_ESWITCH_MODE_SWITCHDEV;
+}
+
 static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
 {
 	return devlink_net(priv_to_devlink(nsim_dev));
-- 
1.8.3.1

