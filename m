Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEE725E048
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 18:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgIDQx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 12:53:26 -0400
Received: from mail-eopbgr30104.outbound.protection.outlook.com ([40.107.3.104]:16640
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727865AbgIDQxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 12:53:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=azGp/QOemYTC32B1QY6YZpNdCeRvPEU7f9KWB0DukgTWRtdPjawK+OvRbm8hPpjU114Fbw6lJDXN3JrCBCr+v3DqQViRcD17XYb9tCY7hP6HggltzIfTGexvhZ89Pt9kLXg8hGotUPAGJFmst7bOnTuINNhBdwoy/HACAeQf3iibhqn10CvIrfxdk5ae2eXlsWa6NWBjt12PWduwGfH+VD2qx/miC27WtJApYBAEFVJs+kdkSN0tu3a33NETF+t79/nSF3lX0+U7PB9bUrMnIafiyEuAB9BjWxR2YcXFOWSSieNBaVleVcQYjug6/77eaFhLgGkNnCGU66p+6m0/zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ydx03df43d4/A/aLcgbgIcCPdFugKzJYW7YPeEWVpn0=;
 b=JegeS+ifvp/C5rNUmdrmlDQYRZUBwVgG760TVme1e44xua0TDQaKzoCdiY2CRIwIHhF1x++7pkrv+Bl93hJ7bQ8w1Ag4I7P6xUH/lqKyFuyRow0zB3VEEm9lWd65KcUJzyPfmBEaAoEigDFbrDPhINS0sVZWf3RU/TbaeR2mo3XwN0Z9NZ9C8TzRl+f9lrQuHxeu96lNZDD+plxLkMyKSyrrMpjotNHowwRuzbExLbjVG2/Eha6T7/SpAxBT7akUSrIyJNUrcMKdVplhazuPvYcWGX6vmIwhcXQQOPzjpbLRSscexveFBT5NbVVn4mZnyCQIrdwCk/F6fzlJ3tzlOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ydx03df43d4/A/aLcgbgIcCPdFugKzJYW7YPeEWVpn0=;
 b=f0DfdAwKH+omCugo+9iOi75j+odaBLrvg8/SqVJDkPE9NuUlKM0mCmHpsiuftNDIJy2j5nuJhXx8VE94pJ3Kly1K4WSsyRMrPItFKv5AIZr2l94p2X79wkg1CiXq5+NNMqTRPHrFgqOOcyozIhSC58mhLoscL7A9QcUX+Kkg+R0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0535.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:3e::26) by
 DB8P190MB0730.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:12f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16; Fri, 4 Sep 2020 16:52:54 +0000
Received: from DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 ([fe80::9cbe:fafc:3c8a:3765]) by DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 ([fe80::9cbe:fafc:3c8a:3765%4]) with mapi id 15.20.3348.016; Fri, 4 Sep 2020
 16:52:54 +0000
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
Subject: [PATCH net-next v7 3/6] net: marvell: prestera: Add basic devlink support
Date:   Fri,  4 Sep 2020 19:52:19 +0300
Message-Id: <20200904165222.18444-4-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200904165222.18444-1-vadym.kochan@plvision.eu>
References: <20200904165222.18444-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6PR04CA0062.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::39) To DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:3e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR04CA0062.eurprd04.prod.outlook.com (2603:10a6:20b:f0::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Fri, 4 Sep 2020 16:52:53 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc6779a7-be53-4fd8-30df-08d850f2f7f7
X-MS-TrafficTypeDiagnostic: DB8P190MB0730:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8P190MB0730BE9A43A9EA1F979EAF50952D0@DB8P190MB0730.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M14miMLEvuw2M52C8W7WeE2xbPF/SWNsP/ZN00X+ukViIxw7j9Bjmd2Oyup107VdCpLJU/gX/lB7fCo5BxIVIItnkk5Sn9+tX6stv8HC7R0WWX2k9ZYyXcCTQNiX7n1QivdKEvvD7L/3FTqeWpj+JUpxQobpbDABSkpNTQ0iniA5y/pBNxDAUo7jFqmHRoV9SmnEIH4x6G1dKx6Nvd2J/B+47upjIQhpJ6GMY63BTKE9hggDd6DXan8S9Y4jXngkxlddtzoCSgkcZZMD+dQFWVLDb1+R231gdANpEYBS0ALVy8ddhtlduLfgBQVxjLG97qmNeBP95JR6ZCex8nAadD/8Y8GaPCsLAVCo3wayZOgKd3Moe34WgdFaZ825eApy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0535.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(396003)(39830400003)(346002)(36756003)(44832011)(4326008)(2616005)(54906003)(956004)(5660300002)(8676002)(6512007)(66946007)(66476007)(2906002)(83380400001)(110136005)(66556008)(6666004)(478600001)(86362001)(6486002)(107886003)(1076003)(8936002)(16526019)(6506007)(186003)(26005)(52116002)(316002)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: iZ7JuaB5UyLtSRw1XQmf1S43HKWwLtPgPDOQ0s4Rj2sa0kzZcGnKKJLRbFCEa7JHRjg9YF9S7Vq/Qj2HI9UxrjjLUGB7fP+22RHI2/Gc465XTqhReJEFel9Tz2K4mde2HLybzjSjmNLaXoBcdThwXL6IlUK5OZn1Vqs4cssz7nisa3PKsyDcI2viLM6sbNO3yNqEneCbrCtSGxo2vk1pxVP8kjG55+VTT/ra6cUOAxEiTnF2c/c1jnN5jkm/qS+NB/tqzcJJ0YsUIGNHs50gm0sxm6t3Wu+SVXfIQ27MEL+AcPH8+vfw5HkY6uYOpw08qHKAVDvGG8pi7/qzdozMxDIcA+ERo2d8MpPtRrNVqKyAFQA/B7JlnaJLuJlkrj6lfl2WID1AvV4s3F/3Tyifb7zcDeFyCNLmjVw36DzPgYvqoZkv5LHZlJNKjizQ783yY4l5uRW0eg9dKTccAhWQrmMRWyoPjyk8cUCMQyKIwBpbiUsE25Sw00fkRc75bQxPmBIJC+/kWQrfT//yYzIu338cHiyAjCNyatYLhebHsgaxgW/fSfvMA5BUTEJ9vqSmu76hlTMmCaTlBfkH0uU6CYSO45WzYI8rgUtZCezrOx0ygfLyL1q08kueLZ04uJYsAbK/gx1QSNQwl1U7MHQ/TA==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: bc6779a7-be53-4fd8-30df-08d850f2f7f7
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2020 16:52:54.7693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LHtZyqmHnSaBKBZlhZu0SCrTod62Ed5/ZYOOxBKFy/WolPllhbxS6QavDy4M0TjFCziV5OJATIk1+D4qbV/ukRi0A7ar/FmNcESgdUHH6sA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P190MB0730
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
index 7ea093183a28..70249b565660 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -14,6 +14,7 @@
 #include "prestera.h"
 #include "prestera_hw.h"
 #include "prestera_rxtx.h"
+#include "prestera_devlink.h"
 
 #define PRESTERA_MTU_DEFAULT	1536
 
@@ -190,6 +191,7 @@ static const struct net_device_ops prestera_netdev_ops = {
 	.ndo_change_mtu = prestera_port_change_mtu,
 	.ndo_get_stats64 = prestera_port_get_stats64,
 	.ndo_set_mac_address = prestera_port_set_mac_address,
+	.ndo_get_devlink_port = prestera_devlink_get_port,
 };
 
 static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
@@ -253,9 +255,13 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
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
 
@@ -316,11 +322,16 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
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
@@ -330,8 +341,10 @@ static void prestera_port_destroy(struct prestera_port *port)
 	struct net_device *dev = port->dev;
 
 	cancel_delayed_work_sync(&port->cached_hw_stats.caching_dw);
+	prestera_devlink_port_clear(port);
 	unregister_netdev(dev);
 	prestera_port_list_del(port);
+	prestera_devlink_port_unregister(port);
 	free_netdev(dev);
 }
 
@@ -453,6 +466,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		goto err_handlers_register;
 
+	err = prestera_devlink_register(sw);
+	if (err)
+		goto err_dl_register;
+
 	err = prestera_create_ports(sw);
 	if (err)
 		goto err_ports_create;
@@ -460,6 +477,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	return 0;
 
 err_ports_create:
+	prestera_devlink_unregister(sw);
+err_dl_register:
 	prestera_event_handlers_unregister(sw);
 err_handlers_register:
 	prestera_rxtx_switch_fini(sw);
@@ -471,6 +490,7 @@ static int prestera_switch_init(struct prestera_switch *sw)
 static void prestera_switch_fini(struct prestera_switch *sw)
 {
 	prestera_destroy_ports(sw);
+	prestera_devlink_unregister(sw);
 	prestera_event_handlers_unregister(sw);
 	prestera_rxtx_switch_fini(sw);
 	prestera_hw_switch_fini(sw);
@@ -481,7 +501,7 @@ int prestera_device_register(struct prestera_device *dev)
 	struct prestera_switch *sw;
 	int err;
 
-	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
+	sw = prestera_devlink_alloc();
 	if (!sw)
 		return -ENOMEM;
 
@@ -490,7 +510,7 @@ int prestera_device_register(struct prestera_device *dev)
 
 	err = prestera_switch_init(sw);
 	if (err) {
-		kfree(sw);
+		prestera_devlink_free(sw);
 		return err;
 	}
 
@@ -503,7 +523,7 @@ void prestera_device_unregister(struct prestera_device *dev)
 	struct prestera_switch *sw = dev->priv;
 
 	prestera_switch_fini(sw);
-	kfree(sw);
+	prestera_devlink_free(sw);
 }
 EXPORT_SYMBOL(prestera_device_unregister);
 
-- 
2.17.1

