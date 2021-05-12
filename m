Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734EB37C0A3
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhELOu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:50:29 -0400
Received: from mail-mw2nam12on2054.outbound.protection.outlook.com ([40.107.244.54]:15539
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231423AbhELOuQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1YZZ2W9EbsRr76zkg6wZ6SZkDKupAWVEaiQybcGp5wcMUf5qAprdnTjFfN/xE0lv+CQolJaP1ze/7H11eQe85RuF+RkA+MMTcD9F4J+3+ib/bpQiameYOGBejev4JokfFgpQBDUPOAyoyn4LJEEqVarcb1vX/arNJG5PZBew5WZZEyA3O44brwTRdQbEzuFd2VNh5cYsU/ostAEb+l9zAB8uQRwIRbPNy5LlpTnexFYQkubk+4aRMtwaOTv6TVNWjQx7+Z9mpiIWcKPnECcuPKpFrgZFGlAQCbaFygiUpqymgQBPNEtLz4hnu2hlFGO+cKJHB+bZAcPKjOxGfHluA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQMyxiukSmLRp5rqH5Ch0q79KCPOdOg1wb4fhUALKf0=;
 b=MDu5tnd8UQ5nL4WJGM+V3ZdXbC8HORUt+u0aFi3Ra1kl7WcEAyaKuKLA4OrsSWVQISZseLi1WqePl7/ZAwhkpkk1aw5X6413nV8/eGnDML7Rz9Eh7Vw96pm119mGX239nhl1U70V3aGDGUfvd4Qi80ZPheMhWsPxBqOZtJaVz8jucNFsf8FoY6FSDXJq1rrl/OH7pM5FeVVUJ6wpFIUdB4U+NWtInLdjU8GI2zto+wKR1/QMi2dUpRf8Xl91Nrz4tHuEELT1wRo2egDA8VI3nWZmLg/mDRy3cS6JghL5Kil0oliXETYBraJblxBivo/v4FKNi4yWe/ZGs1K1v6tahQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQMyxiukSmLRp5rqH5Ch0q79KCPOdOg1wb4fhUALKf0=;
 b=eQMrWW0Aj1ulB2IYoeZTB2+kMQxD2WowTbQB8gX1/fsHJzoCXP1WAHDfqQT/hWcQ+msTJ6kdwZJtdeHgw/LnB/PF0k+edYj9WFhfitppivKMYPFt7kN5TOJuHV0xFGRMvH17BYI0OobRaGjJJYW0sDUWDZu/XmMHqBYVvosSfbbK5u97JyzC/5MICUS+YLOAlkVuMyOZQ6mYqpUWYwl55clVOSq/6+t07WAK6SWkSkvbg/NOoDOUL3XWN/Tfx9DM8PaTsJLshlwRjJURaJqU6qNLJ2Bf0/jcArWqVTECVIpkamIi4Rmvn96psjUHiVVxN/OqBO+L1YkRaf7TXgHMkw==
Received: from DM3PR12CA0090.namprd12.prod.outlook.com (2603:10b6:0:57::34) by
 BL1PR12MB5109.namprd12.prod.outlook.com (2603:10b6:208:309::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Wed, 12 May
 2021 14:49:06 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:57:cafe::84) by DM3PR12CA0090.outlook.office365.com
 (2603:10b6:0:57::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 12 May 2021 14:49:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:49:06 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:49:06 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:49:03 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 05/18] netdevsim: Implement legacy/switchdev mode for VFs
Date:   Wed, 12 May 2021 17:48:34 +0300
Message-ID: <1620830927-11828-6-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60554a83-c7aa-4c3d-5134-08d9155517eb
X-MS-TrafficTypeDiagnostic: BL1PR12MB5109:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5109081ED8CA25733EA020A6CB529@BL1PR12MB5109.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ayH0GpFbKXyzbxV9b0spcocZ1coTueevAhmuSvM8xT0cTS6gh/AHm2lp4xgB+wMAbZwyU9wXV5myTMCHNKMDyZOjAj5/YMH+OL6WkqXVrVxF7kRSxo10m9bgeRYBQ+d8f71be67u8aHBcHq6ffoZZCOydjjPuSoelKiJB60EVSQPqsf62oNUbreM0FtomtaEqQ3Zf1W/wnRcX9uzxiTNPFVgafB1Bjhi3J7RScW8fiulCCy0rlYofcZUItnDIhGCj2eA4nGmesUGtnQdMUkTgeYbKyjd5x02vdKd4wpU6gjnmSRpRgPnm0IN0JEP+y+kvnvdHR5E8gsOOU3QS3oUhvIXhbcRSFzOhbSH6q3uTN9+YF52JRDRAg8PRZxO0JG8brdfQpxbMoHEqLOPalJmswjuoZceXupgdY8wxMpLp3Q8GcKyDsvkv8GboQz6dPdiNsin7Q6FPAcZxThbhyBPSUGAnlw/PN6vl2T3ZHSPxKfmH16r27ANkOJRon558MA35csuqknpOZeBl+OneY9t/1MBdZPKEtS4mV2rh6f3KYK1Qg+aXtWS7bp9BOgp003DQi9TCQmNg0JlKPvQQCBQf8kaI1oIw4eWDJhOIMFoRUVY1wujMKYi+vzUDoz+2JW52ovOihmYaqrvVc/WXgyni/Zeb58K5QfW1ytXT2k0+3A=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(396003)(46966006)(36840700001)(2876002)(54906003)(83380400001)(6666004)(4326008)(426003)(356005)(478600001)(6916009)(36906005)(82740400003)(336012)(2616005)(5660300002)(7636003)(7696005)(86362001)(36860700001)(8676002)(82310400003)(2906002)(70586007)(70206006)(36756003)(316002)(26005)(8936002)(107886003)(47076005)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:49:06.6357
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60554a83-c7aa-4c3d-5134-08d9155517eb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5109
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

