Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D86366F86
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241651AbhDUPzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:55:02 -0400
Received: from mail-co1nam11on2069.outbound.protection.outlook.com ([40.107.220.69]:54752
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235333AbhDUPx4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:53:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClP2IpdFRPaX0Mb78XJEe+QLKhAY2BI89JEhcazdkjd28uwcTAv+s0Jf4knhtIbHNfvHMke+li32GDmukrxbi2I+cFAnN9XAiFBXoTJ3LUkd5xCRa4ZHagl0bhOFSTEQIIaVF8LcMa931HS0QbxnbdQjUGauiWuQWSz4uyLCMrV7QpNK+F8XKbJUzY4s97zurUXOWYGzomhw71VF2te7gzR8bpLhW5ZAT1QN+Q51qc8NYG1nHpBJaJTFieRH01f6ggOUVbMS6s177HPawPzN79W9sxi6uLGYpF31WK3n4njCAwOaaCplqCMqJG8ofryiIdq/xLwR0tBAspRm9oFj5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQMyxiukSmLRp5rqH5Ch0q79KCPOdOg1wb4fhUALKf0=;
 b=XyQ0J+l8yi+iz+TQzdKFH9xK21lHZp5FXwjkqlHNua5RKC7+ohV85RoDAMnewaUnXr0+otzLjauYA57KBraNkRBUxYcagiXca4pGhabtxxIsQj/naRbJAqXjB61Zyx4fKAuHiSZ8O3bOudmyZ11BoUOdXL13ntBSSI6zaMBSeHa0Npw4nBHKxHszu6lsx8Xsub1db0N3y8jMmoCeIN7UxokzCTTiC5zg0DLgJRSXMtUEzU0sO1MIDMtJ1eDrbLWd0VfEMQ9cyDt2MxmEu6lEd0Rm35vvy795Zp0GFRlYATGrrHtxNUtz+zT6z8ta/hB8H44ZCNad/25rhzn7aeidgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQMyxiukSmLRp5rqH5Ch0q79KCPOdOg1wb4fhUALKf0=;
 b=pYnYz5edRUuqI+kCpIoB7uBKqIsy+y+pD7FWOVQgOaX1sL6kdISOmLM1KkWfAV0YbWCQUrIvWHT5EFYkOj19eQc8z53xNHQBZnO1J+p/uq5Tt5NUMcGhCkq6lbBOPE2SuVVtazym4/sghvUBileXRLHCbruIpNgFTpxTINVdzwcfxEYqctNJP1Aub0yViIbGrSUI6Adr7qPR8ZsHiNeuLkVRNeFniU+FCZ5/RGe5od93HmguwcM9DchmLy6C3oN2SWg4vvEsvfGz+OIbPw8rhneawqT/1AnhtpM7/MyZddoRv4OpJqOTzZN6B/ATo22v/JNcMocMghyNvZYgLMAv7w==
Received: from MW4PR04CA0166.namprd04.prod.outlook.com (2603:10b6:303:85::21)
 by BYAPR12MB3383.namprd12.prod.outlook.com (2603:10b6:a03:dc::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 21 Apr
 2021 15:53:21 +0000
Received: from CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::3b) by MW4PR04CA0166.outlook.office365.com
 (2603:10b6:303:85::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT039.mail.protection.outlook.com (10.13.174.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:21 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 08:53:20 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:18 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 05/18] netdevsim: Implement legacy/switchdev mode for VFs
Date:   Wed, 21 Apr 2021 18:52:52 +0300
Message-ID: <1619020385-20220-6-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 849f494f-a603-40ab-a0b7-08d904dd96e9
X-MS-TrafficTypeDiagnostic: BYAPR12MB3383:
X-Microsoft-Antispam-PRVS: <BYAPR12MB338374AE02BE3866D842F002CB479@BYAPR12MB3383.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fdi/vwQUIkmWzV9Z3ZDXur4fJWqB6N/qqppPGEoO8Ijl3IzjEAwFzPpkbBl83siN9/4UWzdmRyetAE6mhAothC7aI611GqdpVH/4Lpab06wf2/wmzTFS1/WW9sH4rBp+JyGKH83H2iWdPvYn8yGy6tILwDTKaukqaUpCY4pIf7XE5gjoxn80yaAmmQENe/p3ZicEi/K7BWZ7854CvJZqMs6MVerYgViBSrZQU6eJu7Sytu50Krwn1ZOU8ItSba/rC/QG9yaxgN5joJ6bjNgBLQa+BlYdFfYFLZLdAbJW8I7DbFZ4e0FCqBUzKzZVo0s2oMInQFappQgJcESa38ub6RH4L2Imxfd8ym8gOny3DzqPWg5RGLzJCqTRak0dVEy2owa9gB/ZtxBRwzx7IN59Cy2tsZ+hqlQmO+dh5CxyfwPMPgmct8cO6JRzNEunms4tdxzJDQbOXUWxLXw4dNhjgE0r8+EOqWGwLE1vm7uXqKp9Xs8/5JUoA7l8eKigCN4OclWaLW2Bglk+T0r5GHPSeyqwqy9TPHQLiuHMPJ/Z+fcWxWTVVhIKp6ABtXwNRZiK2HdU4j5T0GVP+Dm8Mn0DY17TvgJFvlvXhzm21LlhU76VvgLaWYtdcBhP7bx3cFFXYfoCoGVkVRGeQIRwRFviPRDzkNnkusdPiE8IANrT0Yg=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(396003)(376002)(46966006)(36840700001)(7636003)(356005)(82740400003)(2876002)(2616005)(7696005)(8676002)(36860700001)(186003)(478600001)(26005)(336012)(86362001)(47076005)(5660300002)(6666004)(54906003)(426003)(70586007)(6916009)(82310400003)(70206006)(83380400001)(4326008)(2906002)(107886003)(8936002)(316002)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:21.4633
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 849f494f-a603-40ab-a0b7-08d904dd96e9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3383
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

