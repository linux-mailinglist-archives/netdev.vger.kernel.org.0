Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB1325AEA5
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgIBPTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 11:19:34 -0400
Received: from mail-eopbgr140100.outbound.protection.outlook.com ([40.107.14.100]:20302
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726380AbgIBPFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 11:05:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYxvFa6ZCliGi7dI5GS72N1erREyc4EVyV8zD4zor75o6G2QQAHxHSwMhvkwJ/ZtuaHtRpQy56vRo1yFALMi4FhWrlNvxAWiuxJhVeOtG7ney3M4pW6kF5cklkghe+Xs/8QvDmoFbP3WkCoDopf8hz8FiD/SlDm77qF098xlDmG/QuEX+pY3mco01Lwpxt+pAED1F069w0s4ddWKf5x++zphVAg3rlUAq66imCtCMji9WodJMDbJnQf9UMXzX9l986xuJ3Hlj1PxXcqJDdoZlCrfqsqEQW7DAWQZLs+0hSGiYRJ4BblRwVJHCO1dkVafvd6VGHe1zo2L7gI6GCnD2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxfGEe1mLdkDIrhvBvNTyOcqSU3jFt5VEP4sTz3rrwE=;
 b=IKSbZpJ8YDOL0yMAPCGeBFdPGE7cfZ1MbRdFk8zogPNHxEBMKm3rb54cNPE+7Mv4wIFrYLfWWvp/Akn0Mdg4ypmg1agk5Vm+InMrLsvDbyKjMNg4tYWyWIZx5hH2OrvQPZkjNbevqPYW5193WAKuIkNAW6ryyShOupkMqn4Y7Hys/rmae4KGAM2Rrq52H4egXQ8qwRsChv5yaELfFVzD9NDsBJZj3HUyesj4oAIQMKc747QjLNRFDDjeeTwiKSo7P5fNpdbnBbM6YuXp7e3Rg9mTt16F3SpGnhi7dufp2b1rrpI8ZxPKs5vY3f+5ryfVjYJDB58SNPPHDYotNnKyTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxfGEe1mLdkDIrhvBvNTyOcqSU3jFt5VEP4sTz3rrwE=;
 b=o8bJPAgxvK5PcNB3uALd5sb2gZlSRcMrlaDiAp84coQ31uZrpvo0n1KUtsC6cJ8q9bfjZm6y62Oi4FRkT69Xn9Nzz//RcCE/zHgWtJrKn7RNJ7jJvqEluijhhOsWv8RE0/TP32L96q+Wt7qq3G4+gr71rQFIqHSLlsiyL/yP/jQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0058.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:ca::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Wed, 2 Sep 2020 15:05:07 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305%6]) with mapi id 15.20.3326.025; Wed, 2 Sep 2020
 15:05:07 +0000
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
Subject: [PATCH net v6 3/6] net: marvell: prestera: Add basic devlink support
Date:   Wed,  2 Sep 2020 18:04:39 +0300
Message-Id: <20200902150442.2779-4-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200902150442.2779-1-vadym.kochan@plvision.eu>
References: <20200902150442.2779-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0110.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::15) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P193CA0110.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Wed, 2 Sep 2020 15:05:05 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47d2d215-1505-4c45-f679-08d84f519415
X-MS-TrafficTypeDiagnostic: HE1P190MB0058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0058D87CA4F3E8DED94FB6E4952F0@HE1P190MB0058.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 03K3w+jy5PmFSD2QXYHPlnzpX3MD+8vxmsezXwUrp9m+i6ZIGFCgcQwm0/sD0mZdNB0xrUUdpXywSPx6cRDK8Qf0GKode7gHTAhbMas+WcuVPJF7CtxrRrRgHX/tdrwffnYDjfFTVVY2k0NdfSEo97h8t7sjMiWmxgTsitx10p7EaJXJ2ztXuiFIVELQQt9KHefQGnrJaY2VMrHi7E3HG0UftAevxNpbWsdyqEXBOQp4LLil9mTdu2GGe9ChKRNf9u4AxdO/xnZhf9BPy71Rr4YF+/l0TAhfgHMoub/MijJqHUb9Ak7AxEU2cHMCPbDJGDEOJ+5smy0dbf+csDhXj7OoCSzpU8/aEoNXP3Udcq4JRNx07kAArDSa4ojh99rs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(136003)(39830400003)(396003)(346002)(366004)(107886003)(83380400001)(316002)(44832011)(478600001)(54906003)(6512007)(6486002)(6666004)(110136005)(186003)(66476007)(8936002)(4326008)(26005)(36756003)(86362001)(66556008)(2616005)(2906002)(5660300002)(1076003)(16526019)(66946007)(6506007)(956004)(52116002)(8676002)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: eFgbAq71SYrbXqO5vMpqZIp6aXjAvSWuLOAIYwcMCsXgFIT6WuPxW9Jn6awKXCp8/CqAYLFZAsW3b0qrrbZEXoa9yBAF8JD798e8L1hMM5MLBX1xtgo9/i5+2vdRhGu935cX1BKGbkv4iQ13nlcMtUg00tppE26mH4AJJw9ZGZ9koUZoezvq7fv5bLsussvoM9ZJKiaaUBvFkFnON2xRtwvhG5n731t/5eB8BhZ1cAEH2GPFd6Q3EXbhqFG106OLjkBA2XmTJyGziOQ4QOKcP/hJexHXmwgeIG2aAn5ZufQLHdQgInrvF9zW7u+/i5s2ZnBP1UQkLazzxK0dbp8cm4+kRlLzQl0WAWFHh9suZsiwfEIGztvgJMGTKE8kaKBglonOfy0n7BPvXiripcZB+4qqn5Y0RoG60LVFUluVWtLerrAhaFrq7v9G3fPRZYZt9r2wEZuLQLxhnoz44mVHTTqWJq5TMzi1qYr3G9wp3zsITU46rl4OA7dw9lVhswB8ozNDs6CLh32/hVZFdvg+9PqKm+EA8CTF0PJcTclt9wqJ9c6+sftbEEfyIAatK86Wx4cXWzErX9TMkakc15C0Ns+rp0FqVHiOnaTscalGRvZJ87I7/KE4uCuTSKIfe1MqCYIS+pPbKfVZJpurM5vVTQ==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d2d215-1505-4c45-f679-08d84f519415
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2020 15:05:06.9617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6YZyhhfwB8Mv5V6wpK61DgQA25DQWf3eCe7F/11NxZO53fU9LJqxUhoskUUQxQk5T+4wE5DaL2+abixmgnE7ATISXj7RS2KKQMyura6X2/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0058
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
PATCH v5:
    1) Simplified some error path handling by simple return error code in:

       - prestera_dl_info_get(...)

    2) Remove not-needed err assignment in:
       - prestera_dl_info_get(...)

    3) Use dev_err() in prestera_devlink_register(...).

 drivers/net/ethernet/marvell/prestera/Kconfig |   1 +
 .../net/ethernet/marvell/prestera/Makefile    |   2 +-
 .../net/ethernet/marvell/prestera/prestera.h  |   4 +
 .../marvell/prestera/prestera_devlink.c       | 114 ++++++++++++++++++
 .../marvell/prestera/prestera_devlink.h       |  26 ++++
 .../ethernet/marvell/prestera/prestera_main.c |  28 ++++-
 6 files changed, 170 insertions(+), 5 deletions(-)
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
index 2efaa5abc3be..5e890897356e 100644
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
index 000000000000..abbd08dad6ab
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -0,0 +1,114 @@
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
+	int err;
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
+	return devlink_info_version_running_put(req,
+					       DEVLINK_INFO_VERSION_GENERIC_FW,
+					       buf);
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
+	if (err)
+		dev_err(sw->dev->dev, "devlink_register failed: %d\n", err);
+
+	return err;
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
+	return err;
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
index 000000000000..5dd88ec84e38
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/*
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
index 0b4a61703145..3b18f3ae6e9d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -14,6 +14,7 @@
 #include "prestera.h"
 #include "prestera_hw.h"
 #include "prestera_rxtx.h"
+#include "prestera_devlink.h"
 
 #define PRESTERA_MTU_DEFAULT	1536
 
@@ -187,6 +188,7 @@ static const struct net_device_ops prestera_netdev_ops = {
 	.ndo_change_mtu = prestera_port_change_mtu,
 	.ndo_get_stats64 = prestera_port_get_stats64,
 	.ndo_set_mac_address = prestera_port_set_mac_address,
+	.ndo_get_devlink_port = prestera_devlink_get_port,
 };
 
 static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
@@ -250,9 +252,13 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
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
 
@@ -310,11 +316,16 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	if (err)
 		goto err_register_netdev;
 
+	prestera_devlink_port_set(port);
+
 	return 0;
 
 err_register_netdev:
 	prestera_port_list_del(port);
 err_port_init:
+	prestera_devlink_port_unregister(port);
+err_dl_port_register:
+err_port_info_get:
 	free_netdev(dev);
 	return err;
 }
@@ -324,8 +335,10 @@ static void prestera_port_destroy(struct prestera_port *port)
 	struct net_device *dev = port->dev;
 
 	cancel_delayed_work_sync(&port->cached_hw_stats.caching_dw);
+	prestera_devlink_port_clear(port);
 	unregister_netdev(dev);
 	prestera_port_list_del(port);
+	prestera_devlink_port_unregister(port);
 	free_netdev(dev);
 }
 
@@ -447,6 +460,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		goto err_handlers_register;
 
+	err = prestera_devlink_register(sw);
+	if (err)
+		goto err_dl_register;
+
 	err = prestera_create_ports(sw);
 	if (err)
 		goto err_ports_create;
@@ -454,6 +471,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	return 0;
 
 err_ports_create:
+	prestera_devlink_unregister(sw);
+err_dl_register:
 	prestera_event_handlers_unregister(sw);
 err_handlers_register:
 	prestera_rxtx_switch_fini(sw);
@@ -465,6 +484,7 @@ static int prestera_switch_init(struct prestera_switch *sw)
 static void prestera_switch_fini(struct prestera_switch *sw)
 {
 	prestera_destroy_ports(sw);
+	prestera_devlink_unregister(sw);
 	prestera_event_handlers_unregister(sw);
 	prestera_rxtx_switch_fini(sw);
 	prestera_hw_switch_fini(sw);
@@ -475,7 +495,7 @@ int prestera_device_register(struct prestera_device *dev)
 	struct prestera_switch *sw;
 	int err;
 
-	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
+	sw = prestera_devlink_alloc();
 	if (!sw)
 		return -ENOMEM;
 
@@ -484,7 +504,7 @@ int prestera_device_register(struct prestera_device *dev)
 
 	err = prestera_switch_init(sw);
 	if (err) {
-		kfree(sw);
+		prestera_devlink_free(sw);
 		return err;
 	}
 
@@ -497,7 +517,7 @@ void prestera_device_unregister(struct prestera_device *dev)
 	struct prestera_switch *sw = dev->priv;
 
 	prestera_switch_fini(sw);
-	kfree(sw);
+	prestera_devlink_free(sw);
 }
 EXPORT_SYMBOL(prestera_device_unregister);
 
-- 
2.17.1

