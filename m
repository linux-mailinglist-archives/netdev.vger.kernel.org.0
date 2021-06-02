Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F5C39893A
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFBMTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:19:41 -0400
Received: from mail-sn1anam02on2068.outbound.protection.outlook.com ([40.107.96.68]:56050
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229938AbhFBMTg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:19:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BGjgvcrsSKat1ZmhFqVHX0RVS0vsZIJM8cl8z8Lg0TWoZAwN5BzYiZQbdwENlmRccFiIu9UenDACMbiQ/eLvyURo2bLyLCRf6WNv5+0JZUc/ma0w3C6UhpWzgmsCHnuJsMex0p7L+Z01SySQSHOpw22aMo8uRvkrsjFi9cZisVxhSRpyIvoVGJaunEJ5dj027GMK3KFF8tt4R3E+JlshsR9ownFOb0nV9a3HJwCdl6qM8+fXmYG1PR17BDpEaQFCPl/k7Ab1NbpzYTfiX/sjLcycbMj5w0lMTt0O2WBs68EsWUvSipnCao2WOPfE6yfLQlbAhOJyTsb89DUGxirPgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aracQJez9omuebwKabD6sX8pDMnJ89hOKSrs9KBu9yQ=;
 b=Przk5i+GbPlUWa36HVPfbmLRAF7LglW+FfXHEibMlVmIMDHgTwrATyXVaMmDZV2upnOSucw3cfCjGPPukbbrZDm4EMQ+GQgirDHljJOT8pAWnvTMX8sW453N65Zml1lWJ14uFsZLH09YhBQelRwJFL1RMz15Fg1d/rQCHCCS5FVfW2tioHXimpc3/MHQke3UmZeH8tm7lRNY9n+JD/5h7CHQPYrvwDkvvSRQ7DrPfBnU+uAp+zytirt4dVzExQd3Ys8IkR5qntVtwWEnToYNh7H97IFup+oAym1bPFv64QpmwaB3th11v4cnbCtPGSBT4asPu9TDbzXZ1SOWR1u7cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aracQJez9omuebwKabD6sX8pDMnJ89hOKSrs9KBu9yQ=;
 b=YD5TRMkl7eMX7Mea9sRdCyp+Ndg2geunCGyYYAvSLQtz/MAQTFvtnJFmCFVlYPfXQ8aexcmopimuOLMh9Cpjf0Ehds6C3TNWutpSCq4sHZA908HDfkRKl68hUCtn8PpAR9VU6xS6tnqh6esiBoYyxpI70DJAvOwWw6T6jJbrUGJgu7M+w/HNFBfD8yc821AoLcbFfbZ62K9lJaKnogTJ8PgyvSpSRqTQFHgTYEs6SgjbJGuWMC92ISF6nA/KCD1d8XioqkYPqEmF61OjOJlKLqaVUiQhqhQN6wrRVfPz33OXx5pGgcI3pPy6inRbLhtrMzVJ1eEKjfoNwY/nen8Eeg==
Received: from CO2PR04CA0134.namprd04.prod.outlook.com (2603:10b6:104::12) by
 CY4PR12MB1445.namprd12.prod.outlook.com (2603:10b6:910:11::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.30; Wed, 2 Jun 2021 12:17:52 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:0:cafe::7f) by CO2PR04CA0134.outlook.office365.com
 (2603:10b6:104::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 2 Jun 2021 12:17:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:17:51 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:17:49 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:17:47 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND net-next v3 05/18] netdevsim: Implement legacy/switchdev mode for VFs
Date:   Wed, 2 Jun 2021 15:17:18 +0300
Message-ID: <1622636251-29892-6-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c09d2de-c9c1-4c37-507c-08d925c07157
X-MS-TrafficTypeDiagnostic: CY4PR12MB1445:
X-Microsoft-Antispam-PRVS: <CY4PR12MB144559E3B0E79D1FB7E46E41CB3D9@CY4PR12MB1445.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: peC+RDooIZZa1YYY2DbX5h7Ft+xCUSXiMSxyHYyOt+YLoryeLv2KM8jdal0hQq1dAD5NeYrDc0+jWkoWi5q34IU6CwHqwYqPY3E8vAHCpg4dwFehUmOlNi39oQvVOrKO00h4ZlVUSA2ln5HsFTZqoVs8oXrfsL/ZlznWZx2E6kNtgWh9VsTuQL++WpuWz1hANxmEsxbQjmEWFCjp5fl4s2vrFGBPrTu7xzU25ksKDSbeYKh3Z4oKt/zxCoiBEeDO0sF47bFklO4iZjjZ7KOoQi2xtAf3fEaWGY60XxMGBYUyqWVM6jj0HPHwamC0x60jDesALhlcSCCBnes5xtbXrWhZ9tvj4ApM6I14SzrUpWBm1edl4xYvCh2vDWIAW7ATVjp4cg3PBgs0uJwsYPD2YMcxQjyV0koAIW8jgfYm32Gw2lmI2c+0Cul+jE3+YqFRXKsY8yJ/3DoSglI5PVPnsJj6LivfKpuillSS6IG/hZJqg6oJqfYyAuNeWe9RDIqvvmsNYu+uEuSQp/47CHgAqyweKlRWwWy/QYL01kSCI88q+CzBtGWP62VJ+xligRvP6tCYKnFSE3cz8XbU4Ld15ycp0Ei8nGTd4TeKzKvVK75tzN6FHsu+vkp4hESd8W5/JjZKTxE5pCehhPoVOmpy1wAJCx2xRjzzgOSJMzIYiKY=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(46966006)(36840700001)(2616005)(26005)(426003)(54906003)(7696005)(6916009)(5660300002)(2876002)(36906005)(478600001)(36860700001)(8936002)(336012)(82740400003)(356005)(70206006)(316002)(70586007)(82310400003)(186003)(36756003)(8676002)(47076005)(86362001)(7636003)(6666004)(83380400001)(107886003)(2906002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:17:51.3942
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c09d2de-c9c1-4c37-507c-08d925c07157
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1445
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
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
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

