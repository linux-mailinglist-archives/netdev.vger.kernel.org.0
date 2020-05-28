Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E371E6599
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 17:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404204AbgE1PNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 11:13:35 -0400
Received: from mail-vi1eur05on2129.outbound.protection.outlook.com ([40.107.21.129]:54914
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404135AbgE1PNa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 11:13:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKq8s+39iKmpmjtqWH3WUcHJ3duPxvK2lx0QuHIVXEfQYcv2Hc6ZZAIq5lOecOrHJusitlTeNLG/FlYa3SbSj/wgOATBnl17nJMVHl5THyIXBf44zyw1Fcv0rXaEpTsen7GcCi+nm+ZvyTl4zIGSju9ZxevcV+TNwjFpiA9pFmUbpf6GHXfIUoRHeiWELayb0SCySXUhG+Uymu4EpGNhw92vE56sWkhvvWPhf93uuYur7lvIG6TkqDzHWoCUVItLupnpJfs0hX/6JiJB5VLD9JeO4YlAopXzh43or8/DrGN4bDJFTbqvqMVmIuqzcfUUI7WJ6CD+7NfXUz4bnVMgBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=994SHS2O/PrS95cifgOXEnIBINDE1NPAkDDi9LRTbSc=;
 b=ZI/ukS3mLxV4LDN6WIgwDD9aYIMJMLgbm5XtVoT87z4XaVx2zgDwIfMe2bTFMHo7jbFAfN3/IUpMVAe2eb+m8XRWU1kGm5OPPcr0j/ZlheC/3+J5py5UrzIxUJQjRwFRcX+RTu3qgq2jL9HJ+Va3I1oeoanTkhOO6IOrQrFkFdQa0F7D6Rv88q2EG9siD3k+CzYfNe19KG6LRv8zMzPU0i/YonHibiE0F+nVJjMV2TWPRQpy85KKP4Vf1vu1wPevrMtsIexlyszAoDIBgz8kFkalhdOhpJde9Byrw8fx5AXijLAWaxo0EJvaQByCFC3v4SMCgvBVCeUOC3MNAELajQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=994SHS2O/PrS95cifgOXEnIBINDE1NPAkDDi9LRTbSc=;
 b=BGDkQ0sfPY2uhojmrTBsC/4Yb6Yd4RhkLdZowmrBUB09KXWQTTAHwuc2CXJkSQOWmBXQ83Ai2Rz9Ft/hHK3TAUrWEAFs0j3FZMdb33XDEyECOv7A+9/E3glUC1bRnOL4DeKtu/mIxNcJLW+Obn3k4hgciWFnwY2AWqmynGZEEI8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0224.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:a4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Thu, 28 May
 2020 15:13:09 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 15:13:09 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [net-next 3/6] net: marvell: prestera: Add basic devlink support
Date:   Thu, 28 May 2020 18:12:42 +0300
Message-Id: <20200528151245.7592-4-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528151245.7592-1-vadym.kochan@plvision.eu>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P191CA0094.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::35) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P191CA0094.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Thu, 28 May 2020 15:13:08 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b0792fc-b380-4361-0cc2-08d80319a1a7
X-MS-TrafficTypeDiagnostic: VI1P190MB0224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB022470B0131E832D553B9A32958E0@VI1P190MB0224.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:428;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UqwgVTBgzkkhl8wzTvVKyKYv5mg5YVWF1O9O3LDJiaK2XXYG8QXb+rFui+g5aDaBCPkGtsk6W7qaZTi5KUmVFPl0EUDWsOWfUnI/tHVwAyJCH/zTbSpGgIdO7r0ihj1jcL61RdzgGC+UCTz+mKhnCQkv/dVX+yndUuIOaM85klsf4rF2Fp/2V0u/IysRcOx2vRRGotjCh4DCxU3NXvsUxb6OIlD+nld3dqDj7gu2Y/YiKCvbuo3hCRRgSpiDxY7DeJ+2XRZA2hHw2k00IcNJ5vCpvHvz7oDLAficnD6Eq1gCn+wR3O4sppZDgE+nWfaCG/fiqS/PFaOt8ImC8HMOUxzcyRwPSEZOkfIOncuukV5Dpxy+pVFbzw3pW6WtSHFP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39830400003)(376002)(366004)(346002)(396003)(66476007)(316002)(66556008)(107886003)(5660300002)(6512007)(2616005)(508600001)(186003)(956004)(4326008)(1076003)(2906002)(16526019)(52116002)(26005)(6486002)(44832011)(54906003)(6506007)(66946007)(8936002)(8676002)(110136005)(86362001)(83380400001)(36756003)(6666004)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: tSxg6mT0DH/npIscwsvcOZ7wgCg2d/aRnHibbchaMcaQ+FpCLd/bKkoCKkj8Q4IDvfBneF125/By0ibQDJYyS50IcpxwMT8GDChjAxKbYyOvAvYJQvGHRsPrwcmSiyyNUV3c373EGXUfSwhsXryq613aizxob4Mm0amRt80M4AKzZtRfx6jL+nGG3FD+E980Ur/E5FPKxFXNy2Qb0KL9ypLsd+yXJikyidmaWEKGv5R3pNWFO/ngqphsdKm2uN8UYE6feyuLQDcF3gClkFNorZ2f4N0OENwS8pLaZjnr17p88UwTkF1G+PNk0xEVOBJpRzvNYhMdV1bOHss55ZW9dGOg7otRzqW/35vfU3cabKJitLqnglhr8rCuOLQh8r9XUBss+HWPbYaAAbllpzw68Vcln+i8GB5w3GeyC5uoWotJ9yt9ofm+dd4r8Wbn+JanM45HEX+LfJdyKpI0dcfbWhZ0Y9tfhNepOY/Q33BYUFw=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b0792fc-b380-4361-0cc2-08d80319a1a7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 15:13:09.6898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 05xedvf0ldLbrpGrLCadfMZRzkq78X0Fu0Hd5sgKt2aI1Pmhi8W6N/pRM1Oh7nzsZttm91YA++Wgh5utoq2+r2cJAEoXDj3sMW7rcE0mXCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0224
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add very basic support for devlink interface:

    - driver name
    - fw version
    - devlink ports

Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/Kconfig |   1 +
 .../net/ethernet/marvell/prestera/Makefile    |   2 +-
 .../net/ethernet/marvell/prestera/prestera.h  |   4 +
 .../marvell/prestera/prestera_devlink.c       | 111 ++++++++++++++++++
 .../marvell/prestera/prestera_devlink.h       |  25 ++++
 .../ethernet/marvell/prestera/prestera_main.c |  27 ++++-
 6 files changed, 165 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.h

diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
index 0848edb272a5..dfd5174d0568 100644
--- a/drivers/net/ethernet/marvell/prestera/Kconfig
+++ b/drivers/net/ethernet/marvell/prestera/Kconfig
@@ -6,6 +6,7 @@
 config PRESTERA
 	tristate "Marvell Prestera Switch ASICs support"
 	depends on NET_SWITCHDEV && VLAN_8021Q
+	select NET_DEVLINK
 	help
 	  This driver supports Marvell Prestera Switch ASICs family.
 
diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
index 2146714eab21..babd71fba809 100644
--- a/drivers/net/ethernet/marvell/prestera/Makefile
+++ b/drivers/net/ethernet/marvell/prestera/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_PRESTERA)	+= prestera.o
 prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
-			   prestera_rxtx.o
+			   prestera_rxtx.o prestera_devlink.o
 
 obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 5079d872e18a..f8abaaff5f21 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -11,6 +11,9 @@
 #include <linux/notifier.h>
 #include <uapi/linux/if_ether.h>
 #include <linux/workqueue.h>
+#include <net/devlink.h>
+
+#define PRESTERA_DRV_NAME	"prestera"
 
 struct prestera_fw_rev {
 	u16 maj;
@@ -63,6 +66,7 @@ struct prestera_port_caps {
 struct prestera_port {
 	struct net_device *dev;
 	struct prestera_switch *sw;
+	struct devlink_port dl_port;
 	u32 id;
 	u32 hw_id;
 	u32 dev_id;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
new file mode 100644
index 000000000000..58021057981b
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
+
+#include <net/devlink.h>
+
+#include "prestera.h"
+#include "prestera_devlink.h"
+
+static int prestera_dl_info_get(struct devlink *dl,
+				struct devlink_info_req *req,
+				struct netlink_ext_ack *extack)
+{
+	struct prestera_switch *sw = devlink_priv(dl);
+	char buf[16];
+	int err = 0;
+
+	err = devlink_info_driver_name_put(req, PRESTERA_DRV_NAME);
+	if (err)
+		return err;
+
+	snprintf(buf, sizeof(buf), "%d.%d.%d",
+		 sw->dev->fw_rev.maj,
+		 sw->dev->fw_rev.min,
+		 sw->dev->fw_rev.sub);
+
+	err = devlink_info_version_running_put(req,
+					       DEVLINK_INFO_VERSION_GENERIC_FW,
+					       buf);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static const struct devlink_ops prestera_dl_ops = {
+	.info_get = prestera_dl_info_get,
+};
+
+struct prestera_switch *prestera_devlink_alloc(void)
+{
+	struct devlink *dl;
+
+	dl = devlink_alloc(&prestera_dl_ops, sizeof(struct prestera_switch));
+
+	return devlink_priv(dl);
+}
+
+void prestera_devlink_free(struct prestera_switch *sw)
+{
+	struct devlink *dl = priv_to_devlink(sw);
+
+	devlink_free(dl);
+}
+
+int prestera_devlink_register(struct prestera_switch *sw)
+{
+	struct devlink *dl = priv_to_devlink(sw);
+	int err;
+
+	err = devlink_register(dl, sw->dev->dev);
+	if (err) {
+		dev_warn(sw->dev->dev, "devlink_register failed: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+void prestera_devlink_unregister(struct prestera_switch *sw)
+{
+	struct devlink *dl = priv_to_devlink(sw);
+
+	devlink_unregister(dl);
+}
+
+int prestera_devlink_port_register(struct prestera_port *port)
+{
+	struct devlink *dl = priv_to_devlink(port->sw);
+	struct prestera_switch *sw;
+	int err;
+
+	sw = port->sw;
+	dl = priv_to_devlink(sw);
+
+	devlink_port_attrs_set(&port->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
+			       port->fp_id, false, 0,
+			       &port->sw->id, sizeof(port->sw->id));
+
+	err = devlink_port_register(dl, &port->dl_port, port->fp_id);
+	if (err)
+		dev_err(sw->dev->dev, "devlink_port_register failed: %d\n", err);
+
+	return 0;
+}
+
+void prestera_devlink_port_unregister(struct prestera_port *port)
+{
+	devlink_port_unregister(&port->dl_port);
+}
+
+void prestera_devlink_port_type_set(struct prestera_port *port)
+{
+	devlink_port_type_eth_set(&port->dl_port, port->dev);
+}
+
+struct devlink_port *prestera_devlink_get_port(struct net_device *dev)
+{
+	struct prestera_port *port = netdev_priv(dev);
+
+	return &port->dl_port;
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.h b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
new file mode 100644
index 000000000000..b46441d1e758
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+ *
+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
+ *
+ */
+
+#ifndef _PRESTERA_DEVLINK_H_
+#define _PRESTERA_DEVLINK_H_
+
+#include "prestera.h"
+
+struct prestera_switch *prestera_devlink_alloc(void);
+void prestera_devlink_free(struct prestera_switch *sw);
+
+int prestera_devlink_register(struct prestera_switch *sw);
+void prestera_devlink_unregister(struct prestera_switch *sw);
+
+int prestera_devlink_port_register(struct prestera_port *port);
+void prestera_devlink_port_unregister(struct prestera_port *port);
+
+void prestera_devlink_port_type_set(struct prestera_port *port);
+
+struct devlink_port *prestera_devlink_get_port(struct net_device *dev);
+
+#endif /* _PRESTERA_DEVLINK_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index b5241e9b784a..ddab9422fe5e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -14,6 +14,7 @@
 #include "prestera.h"
 #include "prestera_hw.h"
 #include "prestera_rxtx.h"
+#include "prestera_devlink.h"
 
 #define PRESTERA_MTU_DEFAULT 1536
 
@@ -185,6 +186,7 @@ static const struct net_device_ops netdev_ops = {
 	.ndo_change_mtu = prestera_port_change_mtu,
 	.ndo_get_stats64 = prestera_port_get_stats64,
 	.ndo_set_mac_address = prestera_port_set_mac_address,
+	.ndo_get_devlink_port = prestera_devlink_get_port,
 };
 
 static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
@@ -234,9 +236,13 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 					&port->hw_id, &port->dev_id);
 	if (err) {
 		dev_err(prestera_dev(sw), "Failed to get port(%u) info\n", id);
-		goto err_port_init;
+		goto err_port_info_get;
 	}
 
+	err = prestera_devlink_port_register(port);
+	if (err)
+		goto err_dl_port_register;
+
 	dev->features |= NETIF_F_NETNS_LOCAL;
 	dev->netdev_ops = &netdev_ops;
 
@@ -295,11 +301,16 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	if (err)
 		goto err_register_netdev;
 
+	prestera_devlink_port_type_set(port);
+
 	return 0;
 
 err_register_netdev:
 	list_del_rcu(&port->list);
 err_port_init:
+	prestera_devlink_port_unregister(port);
+err_dl_port_register:
+err_port_info_get:
 	free_netdev(dev);
 	return err;
 }
@@ -313,6 +324,7 @@ static void prestera_port_destroy(struct prestera_port *port)
 
 	list_del_rcu(&port->list);
 
+	prestera_devlink_port_unregister(port);
 	free_netdev(dev);
 }
 
@@ -435,6 +447,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		return err;
 
+	err = prestera_devlink_register(sw);
+	if (err)
+		goto err_dl_register;
+
 	err = prestera_create_ports(sw);
 	if (err)
 		goto err_ports_create;
@@ -442,6 +458,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	return 0;
 
 err_ports_create:
+	prestera_devlink_unregister(sw);
+err_dl_register:
 	prestera_event_handlers_unregister(sw);
 
 	return err;
@@ -450,6 +468,7 @@ static int prestera_switch_init(struct prestera_switch *sw)
 static void prestera_switch_fini(struct prestera_switch *sw)
 {
 	prestera_destroy_ports(sw);
+	prestera_devlink_unregister(sw);
 	prestera_event_handlers_unregister(sw);
 	prestera_rxtx_switch_fini(sw);
 }
@@ -459,7 +478,7 @@ int prestera_device_register(struct prestera_device *dev)
 	struct prestera_switch *sw;
 	int err;
 
-	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
+	sw = prestera_devlink_alloc();
 	if (!sw)
 		return -ENOMEM;
 
@@ -468,7 +487,7 @@ int prestera_device_register(struct prestera_device *dev)
 
 	err = prestera_switch_init(sw);
 	if (err) {
-		kfree(sw);
+		prestera_devlink_free(sw);
 		return err;
 	}
 
@@ -481,7 +500,7 @@ void prestera_device_unregister(struct prestera_device *dev)
 	struct prestera_switch *sw = dev->priv;
 
 	prestera_switch_fini(sw);
-	kfree(sw);
+	prestera_devlink_free(sw);
 }
 EXPORT_SYMBOL(prestera_device_unregister);
 
-- 
2.17.1

