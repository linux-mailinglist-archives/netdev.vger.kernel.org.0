Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A19A1E2823
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388794AbgEZROS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:14:18 -0400
Received: from mail-eopbgr80134.outbound.protection.outlook.com ([40.107.8.134]:17829
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729910AbgEZROJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:14:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bnednN1eEKHLEk8HQW2Sk/D5z29ec9Azn1LGYB9qBtyOSwPdhjvsjPaZap1+Qh8jkU/Rn+SOx8McELL74Rk6eX/lBXWG0I8HzJ+aypdrAeq60HgL+R9iiIW7d/OJtYQj2VkA6rUxCaD99gOv29C3zlcQRtKqng44EQFCWz39V1//Mx+nc1MURoO6LBcwcfcqbxHgkXOToy+emQnOem/VnYnBctfUyJ3oMbyuX1ij4izujYBJSPJ8LBQC7IaU9EfXYO6xXHdzrMW8Ry2+NAgbSdOK8jRp8eaB3yS8Xl9yFEkChZc4TLca5Uxa9KnSwyXXWmKLJlllffAvi54HiEkRAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/vKTtp4lM322VTJbeykefSQcvqlj8u/r/R8G0waq4JY=;
 b=UtLLwPQNIpK69OTz6e779N3gjixrhV4/mnMy3eEqbrhqyj5uqYpA1mr0GYTinaRox4cBuKg+ubLPKJ3TVe7EUmdn9PUVtw0tKGHytOtGohlSmcVjYwQvIkOGhxr+njOiq2z0wXUfBGgrnN8y/z9fvUvzIAfaDCGy5rXliNchMAmosV1HuNfqNdGxgn7urBXmU5Xz8MDIgQmJG9wsFv57cYe86QP38Mb4TGFMj72FWmKGXRXdFHDAimqwaoRp5vmxBVZIfTJYEAiJZf8GfksAPkVnuIseNe7zu7oaoYygRjdflL4XoJAM2iqtavaePrMEyC9oaAuSf1AcQv+Jnv5vOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/vKTtp4lM322VTJbeykefSQcvqlj8u/r/R8G0waq4JY=;
 b=t1Gdk+2C9bAq2USNtE0JhK6eIE2FOlSrWb4emfrQeVoCnwO3sEi4LsKY8O5upXN21zRgG7YymwIVf8GecArLag5DBeQZfUyzRkEOHWzQSJywZMdb3VQ7NEg6tuNC62lSFBPRNMFM2YA4KcyUGvyumlqDN5Eha+Wo1om2/nq33+E=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0431.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Tue, 26 May
 2020 17:13:45 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:13:45 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
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
Subject: [net-next RFC v3 3/6] net: marvell: prestera: Add basic devlink support
Date:   Tue, 26 May 2020 20:12:59 +0300
Message-Id: <20200526171302.28649-4-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200526171302.28649-1-vadym.kochan@plvision.eu>
References: <20200526171302.28649-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P192CA0061.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:82::38) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P192CA0061.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:82::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Tue, 26 May 2020 17:13:43 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2c48971-04ca-4fd7-deeb-08d8019825c8
X-MS-TrafficTypeDiagnostic: VI1P190MB0431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB043124F6ECA179492F0AA05895B00@VI1P190MB0431.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:428;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wp8zKlgrXMmBw6u2pOQozf+Bq1/pS+KuybaYf0COC2kwQUCwHqtm/tevywFjBGIJ1caG+pWxr+DqGH/qGJUXiEvHEZH23ZNanbiBINVjWIBL0AJRVQQmDlF0OB4riCKILKUmIfjM1u+WENbTUZ8XfEOEzAcL7zCAcZ/pl1RRiyh7pscoOQDkwVNrMt6CcrOLF6VDivhMzBmnkt0k1OPGQmvrD9fHUv/75uQKw5YoSST508UZbFtq8RFsD1Cw2YL9cDug5UCW20nJzu4y8oMBerGFKn3LyoOnBu9Zq3s2qs+sZE8jMWonKYU+sK9/MxrstrWx1Ds4mPDCp1nZZXBtJJ6zxOs5pq26Ld3+E007moE7/NoKuMjkEuyXJErk70so
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(376002)(136003)(346002)(39830400003)(508600001)(16526019)(52116002)(2906002)(4326008)(36756003)(6506007)(186003)(86362001)(26005)(6486002)(8676002)(8936002)(316002)(956004)(54906003)(66476007)(2616005)(6666004)(66946007)(5660300002)(110136005)(107886003)(66556008)(44832011)(1076003)(6512007)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 78+F3N/t7BD/bBjptOm8lgy5uRdxABkxR2VXOFwjP8n234183kv1jZ3z4+TRmaUDPOX/qQsHd7fIhjXvpWjCUXy7e9ejkRv/mEUALv+WU858CsJT361xgpFDuR/tOyNAOagLQauo686OUhL3ZD6RR2hXFRVrzi2k4w0PpYqjnr+13sqQeUp/Vh7OyoxjKZwDtXrjlebruT/2Sx0gvfDomknmyHQzlW0B68asdQqleUGndw2ONQ5nDXuVntibxy3pK1p8nPe/fN7XdEDhz8yjCwoJEZlHqBcZoUxJKCAQ8F0sEhBLciZ7vLnUMLocTYMgFg+7NZyvjTiyHWGsuEt+KiMIcNUa9BMbNRMQWgr4x1LSoRa0NPxyvf/95sLsdKBpGSsKGwUfGuxZbGtsNIr5Nb5Dj9LqL6xS6rC7M1EKPnDiXvASNtt57tgWCmgGi70IVnlmQSysrcLPDHDQTc8CxCdj6UzrR+3iKUw+16ongTc=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c48971-04ca-4fd7-deeb-08d8019825c8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:13:45.5082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NFgdXAmdKjLUE26/8EWLXQq2d/HoZbwjFDn5jUChml8B9XGeFQ46zXwBlxvx3rUQ16oNCbEXYRybSBLI49QqJhl2fdZU3ybm6itVuf7nn84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0431
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
 .../marvell/prestera/prestera_devlink.c       | 110 ++++++++++++++++++
 .../marvell/prestera/prestera_devlink.h       |  25 ++++
 .../ethernet/marvell/prestera/prestera_main.c |  27 ++++-
 6 files changed, 164 insertions(+), 5 deletions(-)
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
index 000000000000..7d1e1b807a0d
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
+
+#include <net/devlink.h>
+
+#include "prestera.h"
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

