Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD0922EC04
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 14:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgG0MXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 08:23:36 -0400
Received: from mail-eopbgr80110.outbound.protection.outlook.com ([40.107.8.110]:17030
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728384AbgG0MXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 08:23:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JBWGdrve7buKNFeoqucdBRnalQxLrrcp0R3yMCMauEQgxdAUmAkMuepGDqRF7vq1qqGCjFnEtPd3I8/UkwlVHanBqWbB0X3GQvbUYsTSMPwLm7kNar2BbLbAGUHZjnMgjscBy/lUuBfpEyyCU8oskvR+dOKSsf/CTsy6ZGPYUmwCMQFIWcm2jrWhzQSp4mdZJGf9Z/ixpJQhWdVSLmiHmhwvs7qD8p9gmBCazoJhyG+M9FdwRl18sk3rbvf2jJjVpWoY7mp/TwdV6V+1e0PZtlwUzPBpKm/ppYCHmMflmj1l9Jdsdo2J6HcMwaVmhjcR98BetArkGaX6CdyZu78sxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CX3d/ysB09aRaRWzb3JvBW1TmSiSJ27gY3cleazqtaU=;
 b=Q+/+5nIpISURNk9Lc6wjsvYIEZevaLos6l9K5odFxbTp2jGhc3hmyofgDrF2dqm7fmAh9t1FpMixLK5N0PkCawpXsg0UGj3MMSJUTUirk2UYOPK6X/8m3yODnEd2Oa4Nj6ykMuwyoPeKN2t9iyGHl2fjH+v38P1toLm9AZW9fX8DotAjwx/CptMfsLpGSuJY+jz6pBth0cND3PpkN1GTq3sUdSYAMEjn0seL/QA0PGyz8wunM/49cO9giBxkNKsB7rFq6BupWOQVaYyPEmOjM73cSSxdVW0zrzR829bUO/2ApXQkKYs5dx/XMEirQizeXwQW3fvWgoP/5cneQmBMsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CX3d/ysB09aRaRWzb3JvBW1TmSiSJ27gY3cleazqtaU=;
 b=AQzLrI2+RCkRYKHJwTkZ0j5VAlD7cHMNNVpj9HB1nwSr8eKm/lETYYxdw61FC8cS92bo8V/BfQ0CX5KwCOklezYAcHWCnK+t4qxpbj1wVE4QfZm4tj2a5RgAS+YdORgyMjI7EVpHT0tAuBkd22QWi/6pAM+Za9NL0wOPq/DsSdY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:33::15) by
 DB6P190MB0151.EURP190.PROD.OUTLOOK.COM (2603:10a6:4:88::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Mon, 27 Jul 2020 12:23:13 +0000
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d]) by DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d%7]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 12:23:13 +0000
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
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [net-next v4 3/6] net: marvell: prestera: Add basic devlink support
Date:   Mon, 27 Jul 2020 15:22:39 +0300
Message-Id: <20200727122242.32337-4-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200727122242.32337-1-vadym.kochan@plvision.eu>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0602CA0010.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::20) To DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:33::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM5PR0602CA0010.eurprd06.prod.outlook.com (2603:10a6:203:a3::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20 via Frontend Transport; Mon, 27 Jul 2020 12:23:12 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c69d98c6-dc8a-4874-0bf0-08d83227d54f
X-MS-TrafficTypeDiagnostic: DB6P190MB0151:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB0151D512662C3B1A90FCE9BA95720@DB6P190MB0151.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:428;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2PJjZx2CSJU594427pxlTeCAhp+2nfnhL67a2nGkuMZs6BDzX7pRvgY3V9PC37Zf5j1o3r1rmL9A0/IxsaYHOJWseM6dPKpXawaMaTnSWRQeOImhjsxYmesiCB7QQyHeY+S0aIVckbwJhmgM3bhGdtUiiASVsqx/cQQkUO+y7/UA/KfIp4nYnwdyvg0Oq/wOK6ApXP9zuglEE/wllrFjc77fG0WN/+xwtykToakJCcd2AOiNpv5pe70ubPfq0QOYiKtxbVftRR0RENVMlNrXUMS1k+Mn1cdqEYuT5x0dGTxhfAqnf/RbA2xotSWFWM07Sg8V2JrpT4YtfgTZH80nRuTiQYxa+yisGhjHBYE7fpAXSbDLN3BPyr/5sC+dTmkD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0534.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(39830400003)(396003)(136003)(376002)(346002)(366004)(6506007)(508600001)(83380400001)(956004)(52116002)(316002)(66946007)(8936002)(36756003)(26005)(2616005)(8676002)(66476007)(66556008)(186003)(44832011)(54906003)(6486002)(110136005)(16526019)(6512007)(86362001)(1076003)(107886003)(4326008)(6666004)(5660300002)(2906002)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Rq8ZDF+CGCLUDHOAg6bWhCi4s7QgINMzX/PUEeDMI2+gIMNsaO+BcdDxaS/4KsFLWivlJxnb17HemQwa81XWct1mVP55Dia7DKMsTxZ+z1ueBGGRL1p4RPOLvZDIJeYywiWsFmlC8kbHo2m3/Qsw6Yno+Z/jlbZOaokGYdOtjTd01PUjFjV3BHTftNui35A5jCYy7XRlTS1xzrA9ZQ8jNC+mFhvss/IUBj2SADylzHQjAFsiv4DCh5AU0HDG0V2Zz0625ys/UTWf32Iz5c522tXBjd5B0EPSFrawidqdkuyzw3CyPtnWap74cbjU+eZvvYgL8BWbLJARCImxdTPAUuExiMx2hDpl6fNbvHH+DR0PsHDakIo+5bXuq6ERKoaL19U3XTo5hD+utw4VU+iE3prcK1foYmu89XglwMCF9nZ860K5GjeEO8Mli3MEniJwp4puyjA6hf32fTkiiNWPZFe1T2mVlP/7tXycVSMlTug=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: c69d98c6-dc8a-4874-0bf0-08d83227d54f
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 12:23:13.9024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tmi+pDGXN61IKrrhUKWBDv+6/6ot2WNrRDWr4tta9fgYDWhJmlIG06l33xWVBG+2Ou85iSGTdihI2s/VPjnYjJezpVw7PHDUVArAbHGruew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0151
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add very basic support for devlink interface:

    - driver name
    - fw version
    - devlink ports

Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/marvell/prestera/Kconfig |   1 +
 .../net/ethernet/marvell/prestera/Makefile    |   2 +-
 .../net/ethernet/marvell/prestera/prestera.h  |   4 +
 .../marvell/prestera/prestera_devlink.c       | 120 ++++++++++++++++++
 .../marvell/prestera/prestera_devlink.h       |  26 ++++
 .../ethernet/marvell/prestera/prestera_main.c |  28 +++-
 6 files changed, 176 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.h

diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
index 2a5945c455cc..b1fcc44f566a 100644
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
index 000000000000..dd09f6ee1c3e
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -0,0 +1,120 @@
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
+	struct devlink_port_attrs attrs = {};
+	struct prestera_switch *sw;
+	int err;
+
+	sw = port->sw;
+	dl = priv_to_devlink(sw);
+
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	attrs.phys.port_number = port->fp_id;
+	attrs.switch_id.id_len = sizeof(port->sw->id);
+	memcpy(attrs.switch_id.id, &port->sw->id, attrs.switch_id.id_len);
+
+	devlink_port_attrs_set(&port->dl_port, &attrs);
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
+void prestera_devlink_port_set(struct prestera_port *port)
+{
+	devlink_port_type_eth_set(&port->dl_port, port->dev);
+}
+
+void prestera_devlink_port_clear(struct prestera_port *port)
+{
+	devlink_port_type_clear(&port->dl_port);
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
index 000000000000..b0793c948148
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
@@ -0,0 +1,26 @@
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
+void prestera_devlink_port_set(struct prestera_port *port);
+void prestera_devlink_port_clear(struct prestera_port *port);
+
+struct devlink_port *prestera_devlink_get_port(struct net_device *dev);
+
+#endif /* _PRESTERA_DEVLINK_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 656268ba2f9e..6dbb7bb16694 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -14,6 +14,7 @@
 #include "prestera.h"
 #include "prestera_hw.h"
 #include "prestera_rxtx.h"
+#include "prestera_devlink.h"
 
 #define PRESTERA_MTU_DEFAULT 1536
 
@@ -175,6 +176,7 @@ static const struct net_device_ops prestera_netdev_ops = {
 	.ndo_change_mtu = prestera_port_change_mtu,
 	.ndo_get_stats64 = prestera_port_get_stats64,
 	.ndo_set_mac_address = prestera_port_set_mac_address,
+	.ndo_get_devlink_port = prestera_devlink_get_port,
 };
 
 static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
@@ -224,9 +226,13 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 					&port->fp_id);
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
 	dev->netdev_ops = &prestera_netdev_ops;
 
@@ -285,11 +291,16 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	if (err)
 		goto err_register_netdev;
 
+	prestera_devlink_port_set(port);
+
 	return 0;
 
 err_register_netdev:
 	list_del(&port->list);
 err_port_init:
+	prestera_devlink_port_unregister(port);
+err_dl_port_register:
+err_port_info_get:
 	free_netdev(dev);
 	return err;
 }
@@ -299,8 +310,10 @@ static void prestera_port_destroy(struct prestera_port *port)
 	struct net_device *dev = port->dev;
 
 	cancel_delayed_work_sync(&port->cached_hw_stats.caching_dw);
+	prestera_devlink_port_clear(port);
 	unregister_netdev(dev);
 	list_del(&port->list);
+	prestera_devlink_port_unregister(port);
 	free_netdev(dev);
 }
 
@@ -421,6 +434,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		goto err_handlers_register;
 
+	err = prestera_devlink_register(sw);
+	if (err)
+		goto err_dl_register;
+
 	err = prestera_create_ports(sw);
 	if (err)
 		goto err_ports_create;
@@ -428,6 +445,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	return 0;
 
 err_ports_create:
+	prestera_devlink_unregister(sw);
+err_dl_register:
 	prestera_event_handlers_unregister(sw);
 err_handlers_register:
 	prestera_rxtx_switch_fini(sw);
@@ -439,6 +458,7 @@ static int prestera_switch_init(struct prestera_switch *sw)
 static void prestera_switch_fini(struct prestera_switch *sw)
 {
 	prestera_destroy_ports(sw);
+	prestera_devlink_unregister(sw);
 	prestera_event_handlers_unregister(sw);
 	prestera_rxtx_switch_fini(sw);
 	prestera_hw_switch_fini(sw);
@@ -449,7 +469,7 @@ int prestera_device_register(struct prestera_device *dev)
 	struct prestera_switch *sw;
 	int err;
 
-	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
+	sw = prestera_devlink_alloc();
 	if (!sw)
 		return -ENOMEM;
 
@@ -458,7 +478,7 @@ int prestera_device_register(struct prestera_device *dev)
 
 	err = prestera_switch_init(sw);
 	if (err) {
-		kfree(sw);
+		prestera_devlink_free(sw);
 		return err;
 	}
 
@@ -471,7 +491,7 @@ void prestera_device_unregister(struct prestera_device *dev)
 	struct prestera_switch *sw = dev->priv;
 
 	prestera_switch_fini(sw);
-	kfree(sw);
+	prestera_devlink_free(sw);
 }
 EXPORT_SYMBOL(prestera_device_unregister);
 
-- 
2.17.1

