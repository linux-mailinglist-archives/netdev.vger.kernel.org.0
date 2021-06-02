Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668D4398938
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhFBMTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:19:32 -0400
Received: from mail-dm6nam10on2068.outbound.protection.outlook.com ([40.107.93.68]:27745
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229904AbhFBMT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:19:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3DMP6EwQsXRC/hAzVVBI3p98X+kLQaZizWZlmLSYuFfcn2uAbeVE/8b7zqWm03p4UtbkoJwCKUioLGO9pwdEM4DRu/+xa9XWwAs7aIQkxOrJO9VhNhVS0dgdumhrpVAcmKKV9M/VmjU7JPYDBGbVfLuC3izGdg27I3Y1ZmT2gA8Rlwa+iuu3pSo45UFlIPabC/UZ3AJkV6Xl92ItMAXmr2OfwIqywO+p7aiDXlRu1IglzhS8xew47oQF0gl0rY0kD+DjHPmlAKRlNDTxBUcHInkmwaN5r5w389me5GGV49hVkA8I3CqIc87yOQByLiL59t30+rN7pYpmhta/MVFpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gl+52mnQcZq3/J+bkNVDr5hRXD9Y1kPYC2Z/Z0abwI0=;
 b=E36YhAeygsFBdXiWp5AF2U+Ul9ArGcFevbGjXi6p1vhAmkFozfQx391iukftxSts2JBpDag4r8jn6+65zUL0V3aGZRfLtJpIUePud8hjF0iQiJ+rNWp8+tdBbv3mv/81MkTIUVdjY5yC7A6psKHDw/v6FvPrfIMWYF9+4nh+R4brLBt3OQkksbFiDdFoOXSt1lrBpt+mqCQK4dZIn/tl+QKv8ABckrVpdXjseM2WbcYtSfCHxD7TAIN0Zi/LlVZ64hGuKUPfl7nuqxKykM+L3NFqESbizGgx+VGIOncSXd8g3TIZp6x/A1m0xFO/WtyaV3sVUsMA7xjqVkn4NWxtLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gl+52mnQcZq3/J+bkNVDr5hRXD9Y1kPYC2Z/Z0abwI0=;
 b=nH5c188V2LrvA0+MvcaY9bEV9Ov8cWtQaY24Py7pRystYe2KW33V/uNXb2vIosInVLAdm0+2M3mnjSaEtPfxw31pvNhSE6DOdT2XhmCdBNMc6D+NjGXwTe+XrYN+xukALM2XaVhHKdvDQ2kiwsA2U1OaLsqdwawUmBmbGVfKflzvlj0MDbN5/U0F96ku3ygPHLdsQcpCAQsI7uvwfOcc2ey8BZ4By+VNgYpJNAjMm/C8LXvfYFI486T7H1HCp+EvyhEsiKbEZu9tyOfJg4+EQf3KvEaRDGpdwxbjG7cUeJtDXYgTV6/bWQTENSrREWl4wci5HlsVdAlY6uvL052H7g==
Received: from BN9PR03CA0562.namprd03.prod.outlook.com (2603:10b6:408:138::27)
 by CY4PR12MB1573.namprd12.prod.outlook.com (2603:10b6:910:d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 12:17:45 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::32) by BN9PR03CA0562.outlook.office365.com
 (2603:10b6:408:138::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend
 Transport; Wed, 2 Jun 2021 12:17:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:17:44 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:17:43 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:17:41 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND net-next v3 03/18] netdevsim: Implement port types and indexing
Date:   Wed, 2 Jun 2021 15:17:16 +0300
Message-ID: <1622636251-29892-4-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7e6f7f6-04a3-4956-5113-08d925c06d6a
X-MS-TrafficTypeDiagnostic: CY4PR12MB1573:
X-Microsoft-Antispam-PRVS: <CY4PR12MB157391B2E53CDA3CE7B785EDCB3D9@CY4PR12MB1573.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ztk25PfR2Kx28DNxfIvCbi8U2Jn1gKQ8plTsG4BDIqeON2sXPFQmX6pI6LGKw+su+Ysi3JudUuLRMgDArAex/tu0XN7netzgtZ2piJnA+uD8nkHurav9gbztqDGWRZ8/i7xT82nQg6crgCua0MwEzoS/Up9CTVyiUJxNdnBnCOQkOF40Xdamzf9wuNspvm9r8IT3nbRoQOKlaAh3Fg5v4aLeF0r0ohKjEdxdhyZWW+CPcs8bBavBKW0rJE1lB7BSb9w0AAejoZaK7jG5UifA5zCrpkPBAhi0AfGxvEWIsbcab24ZU2HcIlb+fPNhstXSXvnnJq4GNozFrruCrrrNgEakg68trWW4weCqeQaY0ZO3bbgznwAPvauiBJNzrcXpjsjOkwwRr5GwinIOz2ybySw5GUmwN4vuMnNsGkoP5ck1Zra28J0rOOEqVS6Din9GjfsqJO+8RlxMOkqVM8M3wo3RXYTu7oKriTBASD5qBAYYejAGQFhT9g2h009mpBCxSUbwfDDQTd6/2Udl8nKThYggRYIqHyGYcxcILDzKq6iMNpGzxgO55uNowwxZGFtVn9rhie7kmWBHaUIMJs9J5Ud56SoeW6pyEo6TsVGzxcDJL2L2gKvWTig+3Rl/le9TTTkSfNBV72lq4+xZmHHQrg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(46966006)(36840700001)(7696005)(4326008)(6916009)(83380400001)(36906005)(2616005)(426003)(26005)(107886003)(82310400003)(36756003)(36860700001)(186003)(70206006)(86362001)(70586007)(8936002)(478600001)(356005)(316002)(8676002)(82740400003)(47076005)(2876002)(2906002)(7636003)(5660300002)(6666004)(336012)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:17:44.7489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e6f7f6-04a3-4956-5113-08d925c06d6a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1573
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Define type of ports, which netdevsim driver currently operates with as
PF. Define new port type - VF, which will be implemented in following
patches. Add helper functions to distinguish them. Add helper function
to get VF index from port index.

Add port indexing logic where PFs' indexes starts from 0, VFs' - from
NSIM_DEV_VF_PORT_INDEX_BASE.
All ports uses same index pool, which means that PF port may be created
with index from VFs' indexes range.
Maximum number of VFs, which the driver can allocate, is limited by
UINT_MAX - BASE.

Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/bus.c       | 10 ++++++++--
 drivers/net/netdevsim/dev.c       | 42 +++++++++++++++++++++++++++++----------
 drivers/net/netdevsim/netdevsim.h | 20 +++++++++++++++++++
 3 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index d5c547c..e29146d 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -141,6 +141,12 @@ ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 		goto unlock;
 	}
 
+	/* max_vfs limited by the maximum number of provided port indexes */
+	if (val > NSIM_DEV_VF_PORT_INDEX_MAX - NSIM_DEV_VF_PORT_INDEX_BASE) {
+		ret = -ERANGE;
+		goto unlock;
+	}
+
 	vfconfigs = kcalloc(val, sizeof(struct nsim_vf_config), GFP_KERNEL | __GFP_NOWARN);
 	if (!vfconfigs) {
 		ret = -ENOMEM;
@@ -178,7 +184,7 @@ ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 
 	mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
 	devlink_reload_disable(devlink);
-	ret = nsim_dev_port_add(nsim_bus_dev, port_index);
+	ret = nsim_dev_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
 	devlink_reload_enable(devlink);
 	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
@@ -207,7 +213,7 @@ ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 
 	mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
 	devlink_reload_disable(devlink);
-	ret = nsim_dev_port_del(nsim_bus_dev, port_index);
+	ret = nsim_dev_port_del(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
 	devlink_reload_enable(devlink);
 	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index cd50c05..93d6f3d 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -35,6 +35,25 @@
 
 #include "netdevsim.h"
 
+static unsigned int
+nsim_dev_port_index(enum nsim_dev_port_type type, unsigned int port_index)
+{
+	switch (type) {
+	case NSIM_DEV_PORT_TYPE_VF:
+		port_index = NSIM_DEV_VF_PORT_INDEX_BASE + port_index;
+		break;
+	case NSIM_DEV_PORT_TYPE_PF:
+		break;
+	}
+
+	return port_index;
+}
+
+static inline unsigned int nsim_dev_port_index_to_vf_index(unsigned int port_index)
+{
+	return port_index - NSIM_DEV_VF_PORT_INDEX_BASE;
+}
+
 static struct dentry *nsim_dev_ddir;
 
 #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
@@ -923,7 +942,7 @@ static int nsim_dev_devlink_trap_init(struct devlink *devlink,
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
 #define NSIM_DEV_TEST1_DEFAULT true
 
-static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
+static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_type type,
 			       unsigned int port_index)
 {
 	struct devlink_port_attrs attrs = {};
@@ -934,7 +953,8 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 	nsim_dev_port = kzalloc(sizeof(*nsim_dev_port), GFP_KERNEL);
 	if (!nsim_dev_port)
 		return -ENOMEM;
-	nsim_dev_port->port_index = port_index;
+	nsim_dev_port->port_index = nsim_dev_port_index(type, port_index);
+	nsim_dev_port->port_type = type;
 
 	devlink_port = &nsim_dev_port->devlink_port;
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
@@ -943,7 +963,7 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 	attrs.switch_id.id_len = nsim_dev->switch_id.id_len;
 	devlink_port_attrs_set(devlink_port, &attrs);
 	err = devlink_port_register(priv_to_devlink(nsim_dev), devlink_port,
-				    port_index);
+				    nsim_dev_port->port_index);
 	if (err)
 		goto err_port_free;
 
@@ -1000,7 +1020,7 @@ static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
 	int i, err;
 
 	for (i = 0; i < port_count; i++) {
-		err = __nsim_dev_port_add(nsim_dev, i);
+		err = __nsim_dev_port_add(nsim_dev, NSIM_DEV_PORT_TYPE_PF, i);
 		if (err)
 			goto err_port_del_all;
 	}
@@ -1216,32 +1236,34 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 }
 
 static struct nsim_dev_port *
-__nsim_dev_port_lookup(struct nsim_dev *nsim_dev, unsigned int port_index)
+__nsim_dev_port_lookup(struct nsim_dev *nsim_dev, enum nsim_dev_port_type type,
+		       unsigned int port_index)
 {
 	struct nsim_dev_port *nsim_dev_port;
 
+	port_index = nsim_dev_port_index(type, port_index);
 	list_for_each_entry(nsim_dev_port, &nsim_dev->port_list, list)
 		if (nsim_dev_port->port_index == port_index)
 			return nsim_dev_port;
 	return NULL;
 }
 
-int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev,
+int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type type,
 		      unsigned int port_index)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	int err;
 
 	mutex_lock(&nsim_dev->port_list_lock);
-	if (__nsim_dev_port_lookup(nsim_dev, port_index))
+	if (__nsim_dev_port_lookup(nsim_dev, type, port_index))
 		err = -EEXIST;
 	else
-		err = __nsim_dev_port_add(nsim_dev, port_index);
+		err = __nsim_dev_port_add(nsim_dev, type, port_index);
 	mutex_unlock(&nsim_dev->port_list_lock);
 	return err;
 }
 
-int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
+int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type type,
 		      unsigned int port_index)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
@@ -1249,7 +1271,7 @@ int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
 	int err = 0;
 
 	mutex_lock(&nsim_dev->port_list_lock);
-	nsim_dev_port = __nsim_dev_port_lookup(nsim_dev, port_index);
+	nsim_dev_port = __nsim_dev_port_lookup(nsim_dev, type, port_index);
 	if (!nsim_dev_port)
 		err = -ENOENT;
 	else
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index a1b49c8..e025c1b 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -197,10 +197,19 @@ static inline void nsim_dev_psample_exit(struct nsim_dev *nsim_dev)
 }
 #endif
 
+enum nsim_dev_port_type {
+	NSIM_DEV_PORT_TYPE_PF,
+	NSIM_DEV_PORT_TYPE_VF,
+};
+
+#define NSIM_DEV_VF_PORT_INDEX_BASE 128
+#define NSIM_DEV_VF_PORT_INDEX_MAX UINT_MAX
+
 struct nsim_dev_port {
 	struct list_head list;
 	struct devlink_port devlink_port;
 	unsigned int port_index;
+	enum nsim_dev_port_type port_type;
 	struct dentry *ddir;
 	struct netdevsim *ns;
 };
@@ -260,8 +269,10 @@ static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
 int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev);
 void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev);
 int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev,
+		      enum nsim_dev_port_type type,
 		      unsigned int port_index);
 int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
+		      enum nsim_dev_port_type type,
 		      unsigned int port_index);
 
 struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
@@ -278,6 +289,15 @@ ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 				   size_t count, loff_t *ppos);
 void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev);
 
+static inline bool nsim_dev_port_is_pf(struct nsim_dev_port *nsim_dev_port)
+{
+	return nsim_dev_port->port_type == NSIM_DEV_PORT_TYPE_PF;
+}
+
+static inline bool nsim_dev_port_is_vf(struct nsim_dev_port *nsim_dev_port)
+{
+	return nsim_dev_port->port_type == NSIM_DEV_PORT_TYPE_VF;
+}
 #if IS_ENABLED(CONFIG_XFRM_OFFLOAD)
 void nsim_ipsec_init(struct netdevsim *ns);
 void nsim_ipsec_teardown(struct netdevsim *ns);
-- 
1.8.3.1

