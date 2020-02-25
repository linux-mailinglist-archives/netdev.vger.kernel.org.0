Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE3F16EB7B
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 17:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731151AbgBYQbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 11:31:15 -0500
Received: from mail-eopbgr20118.outbound.protection.outlook.com ([40.107.2.118]:38414
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731039AbgBYQbO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 11:31:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fyJxEuk31pXoP5Lz76fjTvta8FSjupIOKoR914imTaqn+YzyltUBL8E0Ni3l5kimxL1nRMKM8/ZPwY7VERKu9nssb0CaRoj4PtXjGZUI6749fDoiwY6dDGywV/rybobIAjAb8wESDb7OgWSCaCpkcQu57+lL8dBlggFsBulKe7yyDuJ7tN78fiE/9P5ZBGrY6VgZe5ktCJfkHlM3QjmZejeTH+5VKEIAiB5SP9z7PHUEE/avE9qUOwWLAPJPXsFt7TA4tPlKNiWW0NCliincM7Z75QKyRFWt5o2yxigQbvfMLpkUt6xJp9b+ae/GrO3eJHChXLQbH7HbRXzXiIop8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSZJetptL3e1ypUsoTU0r6WPVeKEp3PDS1rDLOdcuEk=;
 b=TagDzkIZMFpu5J1pRuRD/yfR6BP2FOUVYU996CmpyYQ3kdl2LhyTGFyRF3dXreWqh6Y6m2GET6OfqgL2Q6oYWmmyEdfa8R6gXwSO7vkpdzyI305UgHY8p/E3ALoRGTwVcd7x5zxHksy+GT9OtL+i+0vIBs8VG5xk9nDFoLnm5rzEYEXNuMrnRHPWjDg9ejOspXTAdsyzrMzx7PKFEui1rajJ7p7A11vSCs2AMty2X8pH/S6Vm2ajyR0Ra7g2BJU58SeHXgncVw11flNfwB1Sfjf0HSN2qZlYjl9vk82o15m4waTEVtDEpJM8hiL2HnUQ2bzDmzZq6RbWd+0kazB8mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSZJetptL3e1ypUsoTU0r6WPVeKEp3PDS1rDLOdcuEk=;
 b=If0rWNjAtA3vqFnJ0zws3vzWXUrEw1+OSH1bkrdxo7yBtKLULZoJq4p9tcg67kIbVJQxVww5AlGo9AEJcXcIxUz/JmTfe5SyohxXpa8mSldbLvvgEeHzFTQdkza4JDNJXfR6JbkYNbYOuPl0tSxzxl1PAx5ibnR7xaa69J7I/rM=
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (10.165.195.138) by
 VI1P190MB0351.EURP190.PROD.OUTLOOK.COM (10.165.197.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.22; Tue, 25 Feb 2020 16:30:54 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96%4]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 16:30:54 +0000
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P191CA0030.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8b::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Tue, 25 Feb 2020 16:30:53 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Subject: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver for
 Prestera family ASIC device 98DX325x (AC3x)
Thread-Topic: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
Thread-Index: AQHV6/jzY7yqWky1LUqTk1e6REHYBw==
Date:   Tue, 25 Feb 2020 16:30:54 +0000
Message-ID: <20200225163025.9430-2-vadym.kochan@plvision.eu>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
In-Reply-To: <20200225163025.9430-1-vadym.kochan@plvision.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P191CA0030.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8b::43) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vadym.kochan@plvision.eu; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [217.20.186.93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82776b5e-633f-47f6-13b8-08d7ba101577
x-ms-traffictypediagnostic: VI1P190MB0351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1P190MB0351761ADA5955E94454472F95ED0@VI1P190MB0351.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(136003)(39830400003)(376002)(366004)(189003)(199004)(6512007)(5660300002)(316002)(110136005)(54906003)(4326008)(2906002)(66946007)(6506007)(66446008)(6486002)(66556008)(508600001)(64756008)(52116002)(66476007)(107886003)(8936002)(66574012)(81166006)(86362001)(16526019)(186003)(26005)(30864003)(81156014)(1076003)(36756003)(44832011)(2616005)(71200400001)(8676002)(956004)(559001)(579004)(569008);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1P190MB0351;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: plvision.eu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IPEpENJ/GtTPyXoP1ZoKzcobMPiHzDYcd4WDLlgyYQCDjl+P6EeynYI2EB1ejaf6Ty+vMDSEyQq7qoSnMxk3b6/2fg6+mxwUoMeZzqSAUQzP4ZgvYH5/SPVQWEejZo2mCtmxBFoX8J9ftDjBd3bZmKM+rOg/NPAj1dpxPm/uk3VyZbX+TjV/1c6b5oaWb4TltIvFb7uSjUnXM389PXWkkFRm8YrHsn9YOyWVfnbzI3n7tzxoR/5Fno8JhtRj53u2xbNirLeEs06ouKNdasm+79oYxtSWbodqWvPqFfJSbaXt/tG9AgDXzOTLSG0iNVLf9cUNdbGpFHnuJjnfrSTa+dAZB0Xl3Ak2C0tEGeDfvXnyP7Pm/SCgK/hN0IMP1dFN6yHTsKCEN6a9TeOyQviyN93ONVucV2wlhW+bVXE2SiBB19BATByQcS2Ktuh5Andod3jTCYE+wrmFWXeTxBwkkwN/BQjgflfCYeM0X2mXJIk=
x-ms-exchange-antispam-messagedata: NqJNXFG4eMRrxTafdspqzTbGmOLsiFYtdXKyY/b/RCWSSfnwZUlaIG9KAYP5EnGq9rhl3BNhrXlV24OGEr6S/bgvpf3HgMkTp9amaaLMEGcrF/7k4EwPNbjrnhV8VxP70HcurMagpypU1bJN5O7lDw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 82776b5e-633f-47f6-13b8-08d7ba101577
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2020 16:30:54.2620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 306ZMZmOutMmaHFuyrpMl81kyOV8PLzZC+w6CGFVeBNMleKkxEcLM4QoiGnDXUcBr2wAQOPCeGWROj7FNUFhvCQsKX8BseDF7FysWqK8KgA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
wireless SMB deployment.

This driver implementation includes only L1 & basic L2 support.

The core Prestera switching logic is implemented in prestera.c, there is
an intermediate hw layer between core logic and firmware. It is
implemented in prestera_hw.c, the purpose of it is to encapsulate hw
related logic, in future there is a plan to support more devices with
different HW related configurations.

The following Switchdev features are supported:

    - VLAN-aware bridge offloading
    - VLAN-unaware bridge offloading
    - FDB offloading (learning, ageing)
    - Switchport configuration

Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
---
 drivers/net/ethernet/marvell/Kconfig          |    1 +
 drivers/net/ethernet/marvell/Makefile         |    1 +
 drivers/net/ethernet/marvell/prestera/Kconfig |   13 +
 .../net/ethernet/marvell/prestera/Makefile    |    3 +
 .../net/ethernet/marvell/prestera/prestera.c  | 1502 +++++++++++++++++
 .../net/ethernet/marvell/prestera/prestera.h  |  244 +++
 .../marvell/prestera/prestera_drv_ver.h       |   23 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 1094 ++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  159 ++
 .../marvell/prestera/prestera_switchdev.c     | 1217 +++++++++++++
 10 files changed, 4257 insertions(+)
 create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
 create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_drv_ver.=
h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchde=
v.c

diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/ma=
rvell/Kconfig
index 3d5caea096fb..74313d9e1fc0 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -171,5 +171,6 @@ config SKY2_DEBUG
=20
=20
 source "drivers/net/ethernet/marvell/octeontx2/Kconfig"
+source "drivers/net/ethernet/marvell/prestera/Kconfig"
=20
 endif # NET_VENDOR_MARVELL
diff --git a/drivers/net/ethernet/marvell/Makefile b/drivers/net/ethernet/m=
arvell/Makefile
index 89dea7284d5b..9f88fe822555 100644
--- a/drivers/net/ethernet/marvell/Makefile
+++ b/drivers/net/ethernet/marvell/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_PXA168_ETH) +=3D pxa168_eth.o
 obj-$(CONFIG_SKGE) +=3D skge.o
 obj-$(CONFIG_SKY2) +=3D sky2.o
 obj-y		+=3D octeontx2/
+obj-y		+=3D prestera/
diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/et=
hernet/marvell/prestera/Kconfig
new file mode 100644
index 000000000000..d0b416dcb677
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/Kconfig
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Marvell Prestera drivers configuration
+#
+
+config PRESTERA
+	tristate "Marvell Prestera Switch ASICs support"
+	depends on NET_SWITCHDEV && VLAN_8021Q
+	---help---
+	  This driver supports Marvell Prestera Switch ASICs family.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called prestera_sw.
diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/e=
thernet/marvell/prestera/Makefile
new file mode 100644
index 000000000000..9446298fb7f4
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_PRESTERA)	+=3D prestera_sw.o
+prestera_sw-objs	:=3D prestera.o prestera_hw.o prestera_switchdev.o
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.c b/drivers/net=
/ethernet/marvell/prestera/prestera.c
new file mode 100644
index 000000000000..12d0eb590bbb
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera.c
@@ -0,0 +1,1502 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+ *
+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/netdevice.h>
+#include <linux/netdev_features.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/jiffies.h>
+#include <net/switchdev.h>
+
+#include "prestera.h"
+#include "prestera_hw.h"
+#include "prestera_drv_ver.h"
+
+#define MVSW_PR_MTU_DEFAULT 1536
+
+#define PORT_STATS_CACHE_TIMEOUT_MS	(msecs_to_jiffies(1000))
+#define PORT_STATS_CNT	(sizeof(struct mvsw_pr_port_stats) / sizeof(u64))
+#define PORT_STATS_IDX(name) \
+	(offsetof(struct mvsw_pr_port_stats, name) / sizeof(u64))
+#define PORT_STATS_FIELD(name)	\
+	[PORT_STATS_IDX(name)] =3D __stringify(name)
+
+static struct list_head switches_registered;
+
+static const char mvsw_driver_kind[] =3D "prestera_sw";
+static const char mvsw_driver_name[] =3D "mvsw_switchdev";
+static const char mvsw_driver_version[] =3D PRESTERA_DRV_VER;
+
+#define mvsw_dev(sw)		((sw)->dev->dev)
+#define mvsw_dev_name(sw)	dev_name((sw)->dev->dev)
+
+static struct workqueue_struct *mvsw_pr_wq;
+
+struct mvsw_pr_link_mode {
+	enum ethtool_link_mode_bit_indices eth_mode;
+	u32 speed;
+	u64 pr_mask;
+	u8 duplex;
+	u8 port_type;
+};
+
+static const struct mvsw_pr_link_mode
+mvsw_pr_link_modes[MVSW_LINK_MODE_MAX] =3D {
+	[MVSW_LINK_MODE_10baseT_Half_BIT] =3D {
+		.eth_mode =3D  ETHTOOL_LINK_MODE_10baseT_Half_BIT,
+		.speed =3D 10,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_10baseT_Half_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_HALF,
+		.port_type =3D MVSW_PORT_TYPE_TP,
+	},
+	[MVSW_LINK_MODE_10baseT_Full_BIT] =3D {
+		.eth_mode =3D  ETHTOOL_LINK_MODE_10baseT_Full_BIT,
+		.speed =3D 10,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_10baseT_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_TP,
+	},
+	[MVSW_LINK_MODE_100baseT_Half_BIT] =3D {
+		.eth_mode =3D  ETHTOOL_LINK_MODE_100baseT_Half_BIT,
+		.speed =3D 100,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_100baseT_Half_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_HALF,
+		.port_type =3D MVSW_PORT_TYPE_TP,
+	},
+	[MVSW_LINK_MODE_100baseT_Full_BIT] =3D {
+		.eth_mode =3D  ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+		.speed =3D 100,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_100baseT_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_TP,
+	},
+	[MVSW_LINK_MODE_1000baseT_Half_BIT] =3D {
+		.eth_mode =3D  ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
+		.speed =3D 1000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_1000baseT_Half_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_HALF,
+		.port_type =3D MVSW_PORT_TYPE_TP,
+	},
+	[MVSW_LINK_MODE_1000baseT_Full_BIT] =3D {
+		.eth_mode =3D  ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+		.speed =3D 1000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_1000baseT_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_TP,
+	},
+	[MVSW_LINK_MODE_1000baseX_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+		.speed =3D 1000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_1000baseX_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_FIBRE,
+	},
+	[MVSW_LINK_MODE_1000baseKX_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+		.speed =3D 1000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_1000baseKX_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_TP,
+	},
+	[MVSW_LINK_MODE_10GbaseKR_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+		.speed =3D 10000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_10GbaseKR_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_TP,
+	},
+	[MVSW_LINK_MODE_10GbaseSR_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
+		.speed =3D 10000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_10GbaseSR_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_FIBRE,
+	},
+	[MVSW_LINK_MODE_10GbaseLR_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
+		.speed =3D 10000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_10GbaseLR_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_FIBRE,
+	},
+	[MVSW_LINK_MODE_20GbaseKR2_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_20000baseKR2_Full_BIT,
+		.speed =3D 20000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_20GbaseKR2_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_TP,
+	},
+	[MVSW_LINK_MODE_25GbaseCR_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+		.speed =3D 25000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_25GbaseCR_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_DA,
+	},
+	[MVSW_LINK_MODE_25GbaseKR_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+		.speed =3D 25000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_25GbaseKR_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_TP,
+	},
+	[MVSW_LINK_MODE_25GbaseSR_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
+		.speed =3D 25000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_25GbaseSR_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_FIBRE,
+	},
+	[MVSW_LINK_MODE_40GbaseKR4_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+		.speed =3D 40000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_40GbaseKR4_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_TP,
+	},
+	[MVSW_LINK_MODE_40GbaseCR4_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
+		.speed =3D 40000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_40GbaseCR4_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_DA,
+	},
+	[MVSW_LINK_MODE_40GbaseSR4_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
+		.speed =3D 40000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_40GbaseSR4_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_FIBRE,
+	},
+	[MVSW_LINK_MODE_50GbaseCR2_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_50000baseCR2_Full_BIT,
+		.speed =3D 50000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_50GbaseCR2_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_DA,
+	},
+	[MVSW_LINK_MODE_50GbaseKR2_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_50000baseKR2_Full_BIT,
+		.speed =3D 50000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_50GbaseKR2_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_TP,
+	},
+	[MVSW_LINK_MODE_50GbaseSR2_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_50000baseSR2_Full_BIT,
+		.speed =3D 50000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_50GbaseSR2_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_FIBRE,
+	},
+	[MVSW_LINK_MODE_100GbaseKR4_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+		.speed =3D 100000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_100GbaseKR4_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_TP,
+	},
+	[MVSW_LINK_MODE_100GbaseSR4_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
+		.speed =3D 100000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_100GbaseSR4_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_FIBRE,
+	},
+	[MVSW_LINK_MODE_100GbaseCR4_Full_BIT] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+		.speed =3D 100000,
+		.pr_mask =3D 1 << MVSW_LINK_MODE_100GbaseCR4_Full_BIT,
+		.duplex =3D MVSW_PORT_DUPLEX_FULL,
+		.port_type =3D MVSW_PORT_TYPE_DA,
+	}
+};
+
+struct mvsw_pr_fec {
+	u32 eth_fec;
+	enum ethtool_link_mode_bit_indices eth_mode;
+	u8 pr_fec;
+};
+
+static const struct mvsw_pr_fec mvsw_pr_fec_caps[MVSW_PORT_FEC_MAX] =3D {
+	[MVSW_PORT_FEC_OFF_BIT] =3D {
+		.eth_fec =3D ETHTOOL_FEC_OFF,
+		.eth_mode =3D ETHTOOL_LINK_MODE_FEC_NONE_BIT,
+		.pr_fec =3D 1 << MVSW_PORT_FEC_OFF_BIT,
+	},
+	[MVSW_PORT_FEC_BASER_BIT] =3D {
+		.eth_fec =3D ETHTOOL_FEC_BASER,
+		.eth_mode =3D ETHTOOL_LINK_MODE_FEC_BASER_BIT,
+		.pr_fec =3D 1 << MVSW_PORT_FEC_BASER_BIT,
+	},
+	[MVSW_PORT_FEC_RS_BIT] =3D {
+		.eth_fec =3D ETHTOOL_FEC_RS,
+		.eth_mode =3D ETHTOOL_LINK_MODE_FEC_RS_BIT,
+		.pr_fec =3D 1 << MVSW_PORT_FEC_RS_BIT,
+	}
+};
+
+struct mvsw_pr_port_type {
+	enum ethtool_link_mode_bit_indices eth_mode;
+	u8 eth_type;
+};
+
+static const struct mvsw_pr_port_type
+mvsw_pr_port_types[MVSW_PORT_TYPE_MAX] =3D {
+	[MVSW_PORT_TYPE_NONE] =3D {
+		.eth_mode =3D __ETHTOOL_LINK_MODE_MASK_NBITS,
+		.eth_type =3D PORT_NONE,
+	},
+	[MVSW_PORT_TYPE_TP] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_TP_BIT,
+		.eth_type =3D PORT_TP,
+	},
+	[MVSW_PORT_TYPE_AUI] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_AUI_BIT,
+		.eth_type =3D PORT_AUI,
+	},
+	[MVSW_PORT_TYPE_MII] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_MII_BIT,
+		.eth_type =3D PORT_MII,
+	},
+	[MVSW_PORT_TYPE_FIBRE] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_FIBRE_BIT,
+		.eth_type =3D PORT_FIBRE,
+	},
+	[MVSW_PORT_TYPE_BNC] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_BNC_BIT,
+		.eth_type =3D PORT_BNC,
+	},
+	[MVSW_PORT_TYPE_DA] =3D {
+		.eth_mode =3D ETHTOOL_LINK_MODE_TP_BIT,
+		.eth_type =3D PORT_TP,
+	},
+	[MVSW_PORT_TYPE_OTHER] =3D {
+		.eth_mode =3D __ETHTOOL_LINK_MODE_MASK_NBITS,
+		.eth_type =3D PORT_OTHER,
+	}
+};
+
+static const char mvsw_pr_port_cnt_name[PORT_STATS_CNT][ETH_GSTRING_LEN] =
=3D {
+	PORT_STATS_FIELD(good_octets_received),
+	PORT_STATS_FIELD(bad_octets_received),
+	PORT_STATS_FIELD(mac_trans_error),
+	PORT_STATS_FIELD(broadcast_frames_received),
+	PORT_STATS_FIELD(multicast_frames_received),
+	PORT_STATS_FIELD(frames_64_octets),
+	PORT_STATS_FIELD(frames_65_to_127_octets),
+	PORT_STATS_FIELD(frames_128_to_255_octets),
+	PORT_STATS_FIELD(frames_256_to_511_octets),
+	PORT_STATS_FIELD(frames_512_to_1023_octets),
+	PORT_STATS_FIELD(frames_1024_to_max_octets),
+	PORT_STATS_FIELD(excessive_collision),
+	PORT_STATS_FIELD(multicast_frames_sent),
+	PORT_STATS_FIELD(broadcast_frames_sent),
+	PORT_STATS_FIELD(fc_sent),
+	PORT_STATS_FIELD(fc_received),
+	PORT_STATS_FIELD(buffer_overrun),
+	PORT_STATS_FIELD(undersize),
+	PORT_STATS_FIELD(fragments),
+	PORT_STATS_FIELD(oversize),
+	PORT_STATS_FIELD(jabber),
+	PORT_STATS_FIELD(rx_error_frame_received),
+	PORT_STATS_FIELD(bad_crc),
+	PORT_STATS_FIELD(collisions),
+	PORT_STATS_FIELD(late_collision),
+	PORT_STATS_FIELD(unicast_frames_received),
+	PORT_STATS_FIELD(unicast_frames_sent),
+	PORT_STATS_FIELD(sent_multiple),
+	PORT_STATS_FIELD(sent_deferred),
+	PORT_STATS_FIELD(frames_1024_to_1518_octets),
+	PORT_STATS_FIELD(frames_1519_to_max_octets),
+	PORT_STATS_FIELD(good_octets_sent),
+};
+
+static struct mvsw_pr_port *__find_pr_port(const struct mvsw_pr_switch *sw=
,
+					   u32 port_id)
+{
+	struct mvsw_pr_port *port;
+
+	list_for_each_entry(port, &sw->port_list, list) {
+		if (port->id =3D=3D port_id)
+			return port;
+	}
+
+	return NULL;
+}
+
+static int mvsw_pr_port_state_set(struct net_device *dev, bool is_up)
+{
+	struct mvsw_pr_port *port =3D netdev_priv(dev);
+	int err;
+
+	if (!is_up)
+		netif_stop_queue(dev);
+
+	err =3D mvsw_pr_hw_port_state_set(port, is_up);
+
+	if (is_up && !err)
+		netif_start_queue(dev);
+
+	return err;
+}
+
+static int mvsw_pr_port_get_port_parent_id(struct net_device *dev,
+					   struct netdev_phys_item_id *ppid)
+{
+	const struct mvsw_pr_port *port =3D netdev_priv(dev);
+
+	ppid->id_len =3D sizeof(port->sw->id);
+
+	memcpy(&ppid->id, &port->sw->id, ppid->id_len);
+	return 0;
+}
+
+static int mvsw_pr_port_get_phys_port_name(struct net_device *dev,
+					   char *buf, size_t len)
+{
+	const struct mvsw_pr_port *port =3D netdev_priv(dev);
+
+	snprintf(buf, len, "%u", port->fp_id);
+	return 0;
+}
+
+static int mvsw_pr_port_open(struct net_device *dev)
+{
+	return mvsw_pr_port_state_set(dev, true);
+}
+
+static int mvsw_pr_port_close(struct net_device *dev)
+{
+	return mvsw_pr_port_state_set(dev, false);
+}
+
+static netdev_tx_t mvsw_pr_port_xmit(struct sk_buff *skb,
+				     struct net_device *dev)
+{
+	dev_kfree_skb(skb);
+	return NETDEV_TX_OK;
+}
+
+static int mvsw_is_valid_mac_addr(struct mvsw_pr_port *port, u8 *addr)
+{
+	int err;
+
+	if (!is_valid_ether_addr(addr))
+		return -EADDRNOTAVAIL;
+
+	err =3D memcmp(port->sw->base_mac, addr, ETH_ALEN - 1);
+	if (err)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int mvsw_pr_port_set_mac_address(struct net_device *dev, void *p)
+{
+	struct mvsw_pr_port *port =3D netdev_priv(dev);
+	struct sockaddr *addr =3D p;
+	int err;
+
+	err =3D mvsw_is_valid_mac_addr(port, addr->sa_data);
+	if (err)
+		return err;
+
+	err =3D mvsw_pr_hw_port_mac_set(port, addr->sa_data);
+	if (!err)
+		memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+
+	return err;
+}
+
+static int mvsw_pr_port_change_mtu(struct net_device *dev, int mtu)
+{
+	struct mvsw_pr_port *port =3D netdev_priv(dev);
+	int err;
+
+	if (port->sw->mtu_min <=3D mtu && mtu <=3D port->sw->mtu_max)
+		err =3D mvsw_pr_hw_port_mtu_set(port, mtu);
+	else
+		err =3D -EINVAL;
+
+	if (!err)
+		dev->mtu =3D mtu;
+
+	return err;
+}
+
+static void mvsw_pr_port_get_stats64(struct net_device *dev,
+				     struct rtnl_link_stats64 *stats)
+{
+	struct mvsw_pr_port *port =3D netdev_priv(dev);
+	struct mvsw_pr_port_stats *port_stats =3D &port->cached_hw_stats.stats;
+
+	stats->rx_packets =3D	port_stats->broadcast_frames_received +
+				port_stats->multicast_frames_received +
+				port_stats->unicast_frames_received;
+
+	stats->tx_packets =3D	port_stats->broadcast_frames_sent +
+				port_stats->multicast_frames_sent +
+				port_stats->unicast_frames_sent;
+
+	stats->rx_bytes =3D port_stats->good_octets_received;
+
+	stats->tx_bytes =3D port_stats->good_octets_sent;
+
+	stats->rx_errors =3D port_stats->rx_error_frame_received;
+	stats->tx_errors =3D port_stats->mac_trans_error;
+
+	stats->rx_dropped =3D port_stats->buffer_overrun;
+	stats->tx_dropped =3D 0;
+
+	stats->multicast =3D port_stats->multicast_frames_received;
+	stats->collisions =3D port_stats->excessive_collision;
+
+	stats->rx_crc_errors =3D port_stats->bad_crc;
+}
+
+static void mvsw_pr_port_get_hw_stats(struct mvsw_pr_port *port)
+{
+	mvsw_pr_hw_port_stats_get(port, &port->cached_hw_stats.stats);
+}
+
+static void update_stats_cache(struct work_struct *work)
+{
+	struct mvsw_pr_port *port =3D
+		container_of(work, struct mvsw_pr_port,
+			     cached_hw_stats.caching_dw.work);
+
+	mvsw_pr_port_get_hw_stats(port);
+
+	queue_delayed_work(mvsw_pr_wq, &port->cached_hw_stats.caching_dw,
+			   PORT_STATS_CACHE_TIMEOUT_MS);
+}
+
+static void mvsw_pr_port_get_drvinfo(struct net_device *dev,
+				     struct ethtool_drvinfo *drvinfo)
+{
+	struct mvsw_pr_port *port =3D netdev_priv(dev);
+	struct mvsw_pr_switch *sw =3D port->sw;
+
+	strlcpy(drvinfo->driver, mvsw_driver_kind, sizeof(drvinfo->driver));
+	strlcpy(drvinfo->bus_info, mvsw_dev_name(sw), sizeof(drvinfo->bus_info));
+	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
+		 "%d.%d.%d",
+		 sw->dev->fw_rev.maj,
+		 sw->dev->fw_rev.min,
+		 sw->dev->fw_rev.sub);
+}
+
+static const struct net_device_ops mvsw_pr_netdev_ops =3D {
+	.ndo_open =3D mvsw_pr_port_open,
+	.ndo_stop =3D mvsw_pr_port_close,
+	.ndo_start_xmit =3D mvsw_pr_port_xmit,
+	.ndo_change_mtu =3D mvsw_pr_port_change_mtu,
+	.ndo_get_stats64 =3D mvsw_pr_port_get_stats64,
+	.ndo_set_mac_address =3D mvsw_pr_port_set_mac_address,
+	.ndo_get_phys_port_name =3D mvsw_pr_port_get_phys_port_name,
+	.ndo_get_port_parent_id =3D mvsw_pr_port_get_port_parent_id
+};
+
+bool mvsw_pr_netdev_check(const struct net_device *dev)
+{
+	return dev->netdev_ops =3D=3D &mvsw_pr_netdev_ops;
+}
+
+static int mvsw_pr_lower_dev_walk(struct net_device *lower_dev, void *data=
)
+{
+	struct mvsw_pr_port **pport =3D data;
+
+	if (mvsw_pr_netdev_check(lower_dev)) {
+		*pport =3D netdev_priv(lower_dev);
+		return 1;
+	}
+
+	return 0;
+}
+
+struct mvsw_pr_port *mvsw_pr_port_dev_lower_find(struct net_device *dev)
+{
+	struct mvsw_pr_port *port;
+
+	if (mvsw_pr_netdev_check(dev))
+		return netdev_priv(dev);
+
+	port =3D NULL;
+	netdev_walk_all_lower_dev(dev, mvsw_pr_lower_dev_walk, &port);
+
+	return port;
+}
+
+static void mvsw_modes_to_eth(unsigned long *eth_modes, u64 link_modes, u8=
 fec,
+			      u8 type)
+{
+	u32 mode;
+
+	for (mode =3D 0; mode < MVSW_LINK_MODE_MAX; mode++) {
+		if ((mvsw_pr_link_modes[mode].pr_mask & link_modes) =3D=3D 0)
+			continue;
+		if (type !=3D MVSW_PORT_TYPE_NONE &&
+		    mvsw_pr_link_modes[mode].port_type !=3D type)
+			continue;
+		__set_bit(mvsw_pr_link_modes[mode].eth_mode, eth_modes);
+	}
+
+	for (mode =3D 0; mode < MVSW_PORT_FEC_MAX; mode++) {
+		if ((mvsw_pr_fec_caps[mode].pr_fec & fec) =3D=3D 0)
+			continue;
+		__set_bit(mvsw_pr_fec_caps[mode].eth_mode, eth_modes);
+	}
+}
+
+static void mvsw_modes_from_eth(const unsigned long *eth_modes, u64 *link_=
modes,
+				u8 *fec)
+{
+	u32 mode;
+
+	for (mode =3D 0; mode < MVSW_LINK_MODE_MAX; mode++) {
+		if (!test_bit(mvsw_pr_link_modes[mode].eth_mode, eth_modes))
+			continue;
+		*link_modes |=3D mvsw_pr_link_modes[mode].pr_mask;
+	}
+
+	for (mode =3D 0; mode < MVSW_PORT_FEC_MAX; mode++) {
+		if (!test_bit(mvsw_pr_fec_caps[mode].eth_mode, eth_modes))
+			continue;
+		*fec |=3D mvsw_pr_fec_caps[mode].pr_fec;
+	}
+}
+
+static void mvsw_pr_port_supp_types_get(struct ethtool_link_ksettings *ecm=
d,
+					struct mvsw_pr_port *port)
+{
+	u32 mode;
+	u8 ptype;
+
+	for (mode =3D 0; mode < MVSW_LINK_MODE_MAX; mode++) {
+		if ((mvsw_pr_link_modes[mode].pr_mask &
+		    port->caps.supp_link_modes) =3D=3D 0)
+			continue;
+		ptype =3D mvsw_pr_link_modes[mode].port_type;
+		__set_bit(mvsw_pr_port_types[ptype].eth_mode,
+			  ecmd->link_modes.supported);
+	}
+}
+
+static void mvsw_pr_port_speed_get(struct ethtool_link_ksettings *ecmd,
+				   struct mvsw_pr_port *port)
+{
+	u32 speed;
+	int err;
+
+	err =3D mvsw_pr_hw_port_speed_get(port, &speed);
+	ecmd->base.speed =3D !err ? speed : SPEED_UNKNOWN;
+}
+
+static int mvsw_pr_port_link_mode_set(struct mvsw_pr_port *port,
+				      u32 speed, u8 duplex, u8 type)
+{
+	u32 new_mode =3D MVSW_LINK_MODE_MAX;
+	u32 mode;
+
+	for (mode =3D 0; mode < MVSW_LINK_MODE_MAX; mode++) {
+		if (speed !=3D mvsw_pr_link_modes[mode].speed)
+			continue;
+		if (duplex !=3D mvsw_pr_link_modes[mode].duplex)
+			continue;
+		if (!(mvsw_pr_link_modes[mode].pr_mask &
+		    port->caps.supp_link_modes))
+			continue;
+		if (type !=3D mvsw_pr_link_modes[mode].port_type)
+			continue;
+
+		new_mode =3D mode;
+		break;
+	}
+
+	if (new_mode =3D=3D MVSW_LINK_MODE_MAX) {
+		netdev_err(port->net_dev, "Unsupported speed/duplex requested");
+		return -EINVAL;
+	}
+
+	return mvsw_pr_hw_port_link_mode_set(port, new_mode);
+}
+
+static int mvsw_pr_port_speed_duplex_set(const struct ethtool_link_ksettin=
gs
+					 *ecmd, struct mvsw_pr_port *port)
+{
+	int err;
+	u8 duplex;
+	u32 speed;
+	u32 curr_mode;
+
+	err =3D mvsw_pr_hw_port_link_mode_get(port, &curr_mode);
+	if (err || curr_mode >=3D MVSW_LINK_MODE_MAX)
+		return -EINVAL;
+
+	if (ecmd->base.duplex !=3D DUPLEX_UNKNOWN)
+		duplex =3D ecmd->base.duplex =3D=3D DUPLEX_FULL ?
+			 MVSW_PORT_DUPLEX_FULL : MVSW_PORT_DUPLEX_HALF;
+	else
+		duplex =3D mvsw_pr_link_modes[curr_mode].duplex;
+
+	if (ecmd->base.speed !=3D SPEED_UNKNOWN)
+		speed =3D ecmd->base.speed;
+	else
+		speed =3D mvsw_pr_link_modes[curr_mode].speed;
+
+	return mvsw_pr_port_link_mode_set(port, speed, duplex, port->caps.type);
+}
+
+static u8 mvsw_pr_port_type_get(struct mvsw_pr_port *port)
+{
+	if (port->caps.type < MVSW_PORT_TYPE_MAX)
+		return mvsw_pr_port_types[port->caps.type].eth_type;
+	return PORT_OTHER;
+}
+
+static int mvsw_pr_port_type_set(const struct ethtool_link_ksettings *ecmd=
,
+				 struct mvsw_pr_port *port)
+{
+	int err;
+	u32 type, mode;
+	u32 new_mode =3D MVSW_LINK_MODE_MAX;
+
+	for (type =3D 0; type < MVSW_PORT_TYPE_MAX; type++) {
+		if (mvsw_pr_port_types[type].eth_type =3D=3D ecmd->base.port &&
+		    test_bit(mvsw_pr_port_types[type].eth_mode,
+			     ecmd->link_modes.supported)) {
+			break;
+		}
+	}
+
+	if (type =3D=3D port->caps.type)
+		return 0;
+
+	if (type =3D=3D MVSW_PORT_TYPE_MAX) {
+		pr_err("Unsupported port type requested\n");
+		return -EINVAL;
+	}
+
+	for (mode =3D 0; mode < MVSW_LINK_MODE_MAX; mode++) {
+		if ((mvsw_pr_link_modes[mode].pr_mask &
+		    port->caps.supp_link_modes) &&
+		    type =3D=3D mvsw_pr_link_modes[mode].port_type) {
+			new_mode =3D mode;
+		}
+	}
+
+	if (new_mode < MVSW_LINK_MODE_MAX)
+		err =3D mvsw_pr_hw_port_link_mode_set(port, new_mode);
+	else
+		err =3D -EINVAL;
+
+	if (!err)
+		port->caps.type =3D type;
+
+	return err;
+}
+
+static void mvsw_pr_port_remote_cap_get(struct ethtool_link_ksettings *ecm=
d,
+					struct mvsw_pr_port *port)
+{
+	u64 bitmap;
+
+	if (!mvsw_pr_hw_port_remote_cap_get(port, &bitmap)) {
+		mvsw_modes_to_eth(ecmd->link_modes.lp_advertising,
+				  bitmap, 0, MVSW_PORT_TYPE_NONE);
+	}
+}
+
+static void mvsw_pr_port_duplex_get(struct ethtool_link_ksettings *ecmd,
+				    struct mvsw_pr_port *port)
+{
+	u8 duplex;
+
+	if (!mvsw_pr_hw_port_duplex_get(port, &duplex)) {
+		ecmd->base.duplex =3D duplex =3D=3D MVSW_PORT_DUPLEX_FULL ?
+				    DUPLEX_FULL : DUPLEX_HALF;
+	} else {
+		ecmd->base.duplex =3D DUPLEX_UNKNOWN;
+	}
+}
+
+static int mvsw_pr_port_autoneg_set(struct mvsw_pr_port *port, bool enable=
,
+				    u64 link_modes, u8 fec)
+{
+	bool refresh =3D false;
+	int err =3D 0;
+
+	if (port->caps.type !=3D MVSW_PORT_TYPE_TP)
+		return enable ? -EINVAL : 0;
+
+	if (port->adver_link_modes !=3D link_modes || port->adver_fec !=3D fec) {
+		port->adver_link_modes =3D link_modes;
+		port->adver_fec =3D fec !=3D 0 ? fec : BIT(MVSW_PORT_FEC_OFF_BIT);
+		refresh =3D true;
+	}
+
+	if (port->autoneg =3D=3D enable && !(port->autoneg && refresh))
+		return 0;
+
+	err =3D mvsw_pr_hw_port_autoneg_set(port, enable,
+					  port->adver_link_modes,
+					  port->adver_fec);
+	if (err)
+		return -EINVAL;
+
+	port->autoneg =3D enable;
+	return 0;
+}
+
+static void mvsw_pr_port_mdix_get(struct ethtool_link_ksettings *ecmd,
+				  struct mvsw_pr_port *port)
+{
+	u8 mode;
+
+	if (mvsw_pr_hw_port_mdix_get(port, &mode))
+		return;
+
+	ecmd->base.eth_tp_mdix =3D mode;
+}
+
+static int mvsw_pr_port_mdix_set(const struct ethtool_link_ksettings *ecmd=
,
+				 struct mvsw_pr_port *port)
+{
+	if (ecmd->base.eth_tp_mdix_ctrl)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static int mvsw_pr_port_get_link_ksettings(struct net_device *dev,
+					   struct ethtool_link_ksettings *ecmd)
+{
+	struct mvsw_pr_port *port =3D netdev_priv(dev);
+
+	ethtool_link_ksettings_zero_link_mode(ecmd, supported);
+	ethtool_link_ksettings_zero_link_mode(ecmd, advertising);
+	ethtool_link_ksettings_zero_link_mode(ecmd, lp_advertising);
+
+	ecmd->base.autoneg =3D port->autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
+
+	if (port->caps.type =3D=3D MVSW_PORT_TYPE_TP) {
+		ethtool_link_ksettings_add_link_mode(ecmd, supported, Autoneg);
+		if (netif_running(dev) &&
+		    (port->autoneg ||
+		     port->caps.transceiver =3D=3D MVSW_PORT_TRANSCEIVER_COPPER))
+			ethtool_link_ksettings_add_link_mode(ecmd, advertising,
+							     Autoneg);
+	}
+
+	mvsw_modes_to_eth(ecmd->link_modes.supported,
+			  port->caps.supp_link_modes,
+			  port->caps.supp_fec,
+			  port->caps.type);
+
+	mvsw_pr_port_supp_types_get(ecmd, port);
+
+	if (netif_carrier_ok(dev)) {
+		mvsw_pr_port_speed_get(ecmd, port);
+		mvsw_pr_port_duplex_get(ecmd, port);
+	} else {
+		ecmd->base.speed =3D SPEED_UNKNOWN;
+		ecmd->base.duplex =3D DUPLEX_UNKNOWN;
+	}
+
+	ecmd->base.port =3D mvsw_pr_port_type_get(port);
+
+	if (port->autoneg) {
+		if (netif_running(dev))
+			mvsw_modes_to_eth(ecmd->link_modes.advertising,
+					  port->adver_link_modes,
+					  port->adver_fec,
+					  port->caps.type);
+
+		if (netif_carrier_ok(dev) &&
+		    port->caps.transceiver =3D=3D MVSW_PORT_TRANSCEIVER_COPPER) {
+			ethtool_link_ksettings_add_link_mode(ecmd,
+							     lp_advertising,
+							     Autoneg);
+			mvsw_pr_port_remote_cap_get(ecmd, port);
+		}
+	}
+
+	if (port->caps.type =3D=3D MVSW_PORT_TYPE_TP &&
+	    port->caps.transceiver =3D=3D MVSW_PORT_TRANSCEIVER_COPPER)
+		mvsw_pr_port_mdix_get(ecmd, port);
+
+	return 0;
+}
+
+static bool mvsw_pr_check_supp_modes(const struct mvsw_pr_port_caps *caps,
+				     u64 adver_modes, u8 adver_fec)
+{
+	if ((caps->supp_link_modes & adver_modes) =3D=3D 0)
+		return true;
+	if ((adver_fec & ~caps->supp_fec) !=3D 0)
+		return true;
+
+	return false;
+}
+
+static int mvsw_pr_port_set_link_ksettings(struct net_device *dev,
+					   const struct ethtool_link_ksettings
+					   *ecmd)
+{
+	struct mvsw_pr_port *port =3D netdev_priv(dev);
+	bool is_up =3D netif_running(dev);
+	u64 adver_modes =3D 0;
+	u8 adver_fec =3D 0;
+	int err, err1;
+
+	if (is_up) {
+		err =3D mvsw_pr_port_state_set(dev, false);
+		if (err)
+			return err;
+	}
+
+	err =3D mvsw_pr_port_type_set(ecmd, port);
+	if (err)
+		goto fini_link_ksettings;
+
+	if (port->caps.transceiver =3D=3D MVSW_PORT_TRANSCEIVER_COPPER) {
+		err =3D mvsw_pr_port_mdix_set(ecmd, port);
+		if (err)
+			goto fini_link_ksettings;
+	}
+
+	mvsw_modes_from_eth(ecmd->link_modes.advertising, &adver_modes,
+			    &adver_fec);
+
+	if (ecmd->base.autoneg =3D=3D AUTONEG_ENABLE &&
+	    mvsw_pr_check_supp_modes(&port->caps, adver_modes, adver_fec)) {
+		netdev_err(dev, "Unsupported link mode requested");
+		err =3D -EINVAL;
+		goto fini_link_ksettings;
+	}
+
+	err =3D mvsw_pr_port_autoneg_set(port,
+				       ecmd->base.autoneg =3D=3D AUTONEG_ENABLE,
+				       adver_modes, adver_fec);
+	if (err)
+		goto fini_link_ksettings;
+
+	if (ecmd->base.autoneg =3D=3D AUTONEG_DISABLE) {
+		err =3D mvsw_pr_port_speed_duplex_set(ecmd, port);
+		if (err)
+			goto fini_link_ksettings;
+	}
+
+fini_link_ksettings:
+	err1 =3D mvsw_pr_port_state_set(dev, is_up);
+	if (err1)
+		return err1;
+
+	return err;
+}
+
+static int mvsw_pr_port_get_fecparam(struct net_device *dev,
+				     struct ethtool_fecparam *fecparam)
+{
+	struct mvsw_pr_port *port =3D netdev_priv(dev);
+	u32 mode;
+	u8 active;
+	int err;
+
+	err =3D mvsw_pr_hw_port_fec_get(port, &active);
+	if (err)
+		return err;
+
+	fecparam->fec =3D 0;
+	for (mode =3D 0; mode < MVSW_PORT_FEC_MAX; mode++) {
+		if ((mvsw_pr_fec_caps[mode].pr_fec & port->caps.supp_fec) =3D=3D 0)
+			continue;
+		fecparam->fec |=3D mvsw_pr_fec_caps[mode].eth_fec;
+	}
+
+	if (active < MVSW_PORT_FEC_MAX)
+		fecparam->active_fec =3D mvsw_pr_fec_caps[active].eth_fec;
+	else
+		fecparam->active_fec =3D ETHTOOL_FEC_AUTO;
+
+	return 0;
+}
+
+static int mvsw_pr_port_set_fecparam(struct net_device *dev,
+				     struct ethtool_fecparam *fecparam)
+{
+	struct mvsw_pr_port *port =3D netdev_priv(dev);
+	u8 fec, active;
+	u32 mode;
+	int err;
+
+	if (port->autoneg) {
+		netdev_err(dev, "FEC set is not allowed while autoneg is on\n");
+		return -EINVAL;
+	}
+
+	err =3D mvsw_pr_hw_port_fec_get(port, &active);
+	if (err)
+		return err;
+
+	fec =3D MVSW_PORT_FEC_MAX;
+	for (mode =3D 0; mode < MVSW_PORT_FEC_MAX; mode++) {
+		if ((mvsw_pr_fec_caps[mode].eth_fec & fecparam->fec) &&
+		    (mvsw_pr_fec_caps[mode].pr_fec & port->caps.supp_fec)) {
+			fec =3D mode;
+			break;
+		}
+	}
+
+	if (fec =3D=3D active)
+		return 0;
+
+	if (fec =3D=3D MVSW_PORT_FEC_MAX) {
+		netdev_err(dev, "Unsupported FEC requested");
+		return -EINVAL;
+	}
+
+	return mvsw_pr_hw_port_fec_set(port, fec);
+}
+
+static void mvsw_pr_port_get_ethtool_stats(struct net_device *dev,
+					   struct ethtool_stats *stats,
+					   u64 *data)
+{
+	struct mvsw_pr_port *port =3D netdev_priv(dev);
+	struct mvsw_pr_port_stats *port_stats =3D &port->cached_hw_stats.stats;
+
+	memcpy((u8 *)data, port_stats, sizeof(*port_stats));
+}
+
+static void mvsw_pr_port_get_strings(struct net_device *dev,
+				     u32 stringset, u8 *data)
+{
+	if (stringset !=3D ETH_SS_STATS)
+		return;
+
+	memcpy(data, *mvsw_pr_port_cnt_name, sizeof(mvsw_pr_port_cnt_name));
+}
+
+static int mvsw_pr_port_get_sset_count(struct net_device *dev, int sset)
+{
+	switch (sset) {
+	case ETH_SS_STATS:
+		return PORT_STATS_CNT;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static const struct ethtool_ops mvsw_pr_ethtool_ops =3D {
+	.get_drvinfo =3D mvsw_pr_port_get_drvinfo,
+	.get_link_ksettings =3D mvsw_pr_port_get_link_ksettings,
+	.set_link_ksettings =3D mvsw_pr_port_set_link_ksettings,
+	.get_fecparam =3D mvsw_pr_port_get_fecparam,
+	.set_fecparam =3D mvsw_pr_port_set_fecparam,
+	.get_sset_count =3D mvsw_pr_port_get_sset_count,
+	.get_strings =3D mvsw_pr_port_get_strings,
+	.get_ethtool_stats =3D mvsw_pr_port_get_ethtool_stats,
+	.get_link =3D ethtool_op_get_link
+};
+
+int mvsw_pr_port_learning_set(struct mvsw_pr_port *port, bool learn)
+{
+	return mvsw_pr_hw_port_learning_set(port, learn);
+}
+
+int mvsw_pr_port_flood_set(struct mvsw_pr_port *port, bool flood)
+{
+	return mvsw_pr_hw_port_flood_set(port, flood);
+}
+
+int mvsw_pr_port_pvid_set(struct mvsw_pr_port *port, u16 vid)
+{
+	int err;
+
+	if (!vid) {
+		err =3D mvsw_pr_hw_port_accept_frame_type_set
+		    (port, MVSW_ACCEPT_FRAME_TYPE_TAGGED);
+		if (err)
+			return err;
+	} else {
+		err =3D mvsw_pr_hw_vlan_port_vid_set(port, vid);
+		if (err)
+			return err;
+		err =3D mvsw_pr_hw_port_accept_frame_type_set
+		    (port, MVSW_ACCEPT_FRAME_TYPE_ALL);
+		if (err)
+			goto err_port_allow_untagged_set;
+	}
+
+	port->pvid =3D vid;
+	return 0;
+
+err_port_allow_untagged_set:
+	mvsw_pr_hw_vlan_port_vid_set(port, port->pvid);
+	return err;
+}
+
+struct mvsw_pr_port_vlan*
+mvsw_pr_port_vlan_find_by_vid(const struct mvsw_pr_port *port, u16 vid)
+{
+	struct mvsw_pr_port_vlan *port_vlan;
+
+	list_for_each_entry(port_vlan, &port->vlans_list, list) {
+		if (port_vlan->vid =3D=3D vid)
+			return port_vlan;
+	}
+
+	return NULL;
+}
+
+struct mvsw_pr_port_vlan*
+mvsw_pr_port_vlan_create(struct mvsw_pr_port *port, u16 vid)
+{
+	bool untagged =3D vid =3D=3D MVSW_PR_DEFAULT_VID;
+	struct mvsw_pr_port_vlan *port_vlan;
+	int err;
+
+	port_vlan =3D mvsw_pr_port_vlan_find_by_vid(port, vid);
+	if (port_vlan)
+		return ERR_PTR(-EEXIST);
+
+	err =3D mvsw_pr_port_vlan_set(port, vid, true, untagged);
+	if (err)
+		return ERR_PTR(err);
+
+	port_vlan =3D kzalloc(sizeof(*port_vlan), GFP_KERNEL);
+	if (!port_vlan) {
+		err =3D -ENOMEM;
+		goto err_port_vlan_alloc;
+	}
+
+	port_vlan->mvsw_pr_port =3D port;
+	port_vlan->vid =3D vid;
+
+	list_add(&port_vlan->list, &port->vlans_list);
+
+	return port_vlan;
+
+err_port_vlan_alloc:
+	mvsw_pr_port_vlan_set(port, vid, false, false);
+	return ERR_PTR(err);
+}
+
+static void
+mvsw_pr_port_vlan_cleanup(struct mvsw_pr_port_vlan *port_vlan)
+{
+	if (port_vlan->bridge_port)
+		mvsw_pr_port_vlan_bridge_leave(port_vlan);
+}
+
+void mvsw_pr_port_vlan_destroy(struct mvsw_pr_port_vlan *port_vlan)
+{
+	struct mvsw_pr_port *port =3D port_vlan->mvsw_pr_port;
+	u16 vid =3D port_vlan->vid;
+
+	mvsw_pr_port_vlan_cleanup(port_vlan);
+	list_del(&port_vlan->list);
+	kfree(port_vlan);
+	mvsw_pr_hw_vlan_port_set(port, vid, false, false);
+}
+
+int mvsw_pr_port_vlan_set(struct mvsw_pr_port *port, u16 vid,
+			  bool is_member, bool untagged)
+{
+	return mvsw_pr_hw_vlan_port_set(port, vid, is_member, untagged);
+}
+
+static int mvsw_pr_port_create(struct mvsw_pr_switch *sw, u32 id)
+{
+	struct net_device *net_dev;
+	struct mvsw_pr_port *port;
+	char *mac;
+	int err;
+
+	net_dev =3D alloc_etherdev(sizeof(*port));
+	if (!net_dev)
+		return -ENOMEM;
+
+	port =3D netdev_priv(net_dev);
+
+	INIT_LIST_HEAD(&port->vlans_list);
+	port->pvid =3D MVSW_PR_DEFAULT_VID;
+	port->net_dev =3D net_dev;
+	port->id =3D id;
+	port->sw =3D sw;
+
+	err =3D mvsw_pr_hw_port_info_get(port, &port->fp_id,
+				       &port->hw_id, &port->dev_id);
+	if (err) {
+		dev_err(mvsw_dev(sw), "Failed to get port(%u) info\n", id);
+		goto err_register_netdev;
+	}
+
+	net_dev->features |=3D NETIF_F_NETNS_LOCAL | NETIF_F_HW_L2FW_DOFFLOAD;
+	net_dev->ethtool_ops =3D &mvsw_pr_ethtool_ops;
+	net_dev->netdev_ops =3D &mvsw_pr_netdev_ops;
+
+	netif_carrier_off(net_dev);
+
+	net_dev->mtu =3D min_t(unsigned int, sw->mtu_max, MVSW_PR_MTU_DEFAULT);
+	net_dev->min_mtu =3D sw->mtu_min;
+	net_dev->max_mtu =3D sw->mtu_max;
+
+	err =3D mvsw_pr_hw_port_mtu_set(port, net_dev->mtu);
+	if (err) {
+		dev_err(mvsw_dev(sw), "Failed to set port(%u) mtu\n", id);
+		goto err_register_netdev;
+	}
+
+	/* Only 0xFF mac addrs are supported */
+	if (port->fp_id >=3D 0xFF)
+		goto err_register_netdev;
+
+	mac =3D net_dev->dev_addr;
+	memcpy(mac, sw->base_mac, net_dev->addr_len - 1);
+	mac[net_dev->addr_len - 1] =3D (char)port->fp_id;
+
+	err =3D mvsw_pr_hw_port_mac_set(port, mac);
+	if (err) {
+		dev_err(mvsw_dev(sw), "Failed to set port(%u) mac addr\n", id);
+		goto err_register_netdev;
+	}
+
+	err =3D mvsw_pr_hw_port_cap_get(port, &port->caps);
+	if (err) {
+		dev_err(mvsw_dev(sw), "Failed to get port(%u) caps\n", id);
+		goto err_register_netdev;
+	}
+
+	port->adver_link_modes =3D 0;
+	port->adver_fec =3D 1 << MVSW_PORT_FEC_OFF_BIT;
+	port->autoneg =3D false;
+	mvsw_pr_port_autoneg_set(port, true, port->caps.supp_link_modes,
+				 port->caps.supp_fec);
+
+	err =3D mvsw_pr_hw_port_state_set(port, false);
+	if (err) {
+		dev_err(mvsw_dev(sw), "Failed to set port(%u) down\n", id);
+		goto err_register_netdev;
+	}
+
+	INIT_DELAYED_WORK(&port->cached_hw_stats.caching_dw,
+			  &update_stats_cache);
+
+	err =3D register_netdev(net_dev);
+	if (err)
+		goto err_register_netdev;
+
+	list_add(&port->list, &sw->port_list);
+
+	return 0;
+
+err_register_netdev:
+	free_netdev(net_dev);
+	return err;
+}
+
+static void mvsw_pr_port_vlan_flush(struct mvsw_pr_port *port,
+				    bool flush_default)
+{
+	struct mvsw_pr_port_vlan *port_vlan, *tmp;
+
+	list_for_each_entry_safe(port_vlan, tmp, &port->vlans_list, list) {
+		if (!flush_default && port_vlan->vid =3D=3D MVSW_PR_DEFAULT_VID)
+			continue;
+
+		mvsw_pr_port_vlan_destroy(port_vlan);
+	}
+}
+
+int mvsw_pr_8021d_bridge_create(struct mvsw_pr_switch *sw, u16 *bridge_id)
+{
+	return mvsw_pr_hw_bridge_create(sw, bridge_id);
+}
+
+int mvsw_pr_8021d_bridge_delete(struct mvsw_pr_switch *sw, u16 bridge_id)
+{
+	return mvsw_pr_hw_bridge_delete(sw, bridge_id);
+}
+
+int mvsw_pr_8021d_bridge_port_add(struct mvsw_pr_port *port, u16 bridge_id=
)
+{
+	return mvsw_pr_hw_bridge_port_add(port, bridge_id);
+}
+
+int mvsw_pr_8021d_bridge_port_delete(struct mvsw_pr_port *port, u16 bridge=
_id)
+{
+	return mvsw_pr_hw_bridge_port_delete(port, bridge_id);
+}
+
+int mvsw_pr_switch_ageing_set(struct mvsw_pr_switch *sw, u32 ageing_time)
+{
+	return mvsw_pr_hw_switch_ageing_set(sw, ageing_time);
+}
+
+int mvsw_pr_fdb_flush_vlan(struct mvsw_pr_switch *sw, u16 vid,
+			   enum mvsw_pr_fdb_flush_mode mode)
+{
+	return mvsw_pr_hw_fdb_flush_vlan(sw, vid, mode);
+}
+
+int mvsw_pr_fdb_flush_port_vlan(struct mvsw_pr_port *port, u16 vid,
+				enum mvsw_pr_fdb_flush_mode mode)
+{
+	return mvsw_pr_hw_fdb_flush_port_vlan(port, vid, mode);
+}
+
+int mvsw_pr_fdb_flush_port(struct mvsw_pr_port *port,
+			   enum mvsw_pr_fdb_flush_mode mode)
+{
+	return mvsw_pr_hw_fdb_flush_port(port, mode);
+}
+
+static int mvsw_pr_clear_ports(struct mvsw_pr_switch *sw)
+{
+	struct net_device *net_dev;
+	struct list_head *pos, *n;
+	struct mvsw_pr_port *port;
+
+	list_for_each_safe(pos, n, &sw->port_list) {
+		port =3D list_entry(pos, typeof(*port), list);
+		net_dev =3D port->net_dev;
+
+		cancel_delayed_work_sync(&port->cached_hw_stats.caching_dw);
+		unregister_netdev(net_dev);
+		mvsw_pr_port_vlan_flush(port, true);
+		WARN_ON_ONCE(!list_empty(&port->vlans_list));
+		free_netdev(net_dev);
+		list_del(pos);
+	}
+	return (!list_empty(&sw->port_list));
+}
+
+static void mvsw_pr_port_handle_event(struct mvsw_pr_switch *sw,
+				      struct mvsw_pr_event *evt)
+{
+	struct mvsw_pr_port *port;
+	struct delayed_work *caching_dw;
+
+	port =3D __find_pr_port(sw, evt->port_evt.port_id);
+	if (!port)
+		return;
+
+	caching_dw =3D &port->cached_hw_stats.caching_dw;
+
+	switch (evt->id) {
+	case MVSW_PORT_EVENT_STATE_CHANGED:
+		if (evt->port_evt.data.oper_state) {
+			netif_carrier_on(port->net_dev);
+			if (!delayed_work_pending(caching_dw))
+				queue_delayed_work(mvsw_pr_wq, caching_dw, 0);
+		} else {
+			netif_carrier_off(port->net_dev);
+			if (delayed_work_pending(caching_dw))
+				cancel_delayed_work(caching_dw);
+		}
+		break;
+	}
+}
+
+static void mvsw_pr_fdb_handle_event(struct mvsw_pr_switch *sw,
+				     struct mvsw_pr_event *evt)
+{
+	struct switchdev_notifier_fdb_info info;
+	struct mvsw_pr_port *port;
+
+	port =3D __find_pr_port(sw, evt->fdb_evt.port_id);
+	if (!port)
+		return;
+
+	info.addr =3D evt->fdb_evt.data.mac;
+	info.vid =3D evt->fdb_evt.vid;
+	info.offloaded =3D true;
+
+	rtnl_lock();
+	switch (evt->id) {
+	case MVSW_FDB_EVENT_LEARNED:
+		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
+					 port->net_dev, &info.info, NULL);
+		break;
+	case MVSW_FDB_EVENT_AGED:
+		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
+					 port->net_dev, &info.info, NULL);
+		break;
+	}
+	rtnl_unlock();
+	return;
+}
+
+int mvsw_pr_fdb_add(struct mvsw_pr_port *port, const unsigned char *mac,
+		    u16 vid, bool dynamic)
+{
+	return mvsw_pr_hw_fdb_add(port, mac, vid, dynamic);
+}
+
+int mvsw_pr_fdb_del(struct mvsw_pr_port *port, const unsigned char *mac,
+		    u16 vid)
+{
+	return mvsw_pr_hw_fdb_del(port, mac, vid);
+}
+
+static void mvsw_pr_fdb_event_handler_unregister(struct mvsw_pr_switch *sw=
)
+{
+	mvsw_pr_hw_event_handler_unregister(sw, MVSW_EVENT_TYPE_FDB,
+					    mvsw_pr_fdb_handle_event);
+}
+
+static void mvsw_pr_port_event_handler_unregister(struct mvsw_pr_switch *s=
w)
+{
+	mvsw_pr_hw_event_handler_unregister(sw, MVSW_EVENT_TYPE_PORT,
+					    mvsw_pr_port_handle_event);
+}
+
+static void mvsw_pr_event_handlers_unregister(struct mvsw_pr_switch *sw)
+{
+	mvsw_pr_fdb_event_handler_unregister(sw);
+	mvsw_pr_port_event_handler_unregister(sw);
+}
+
+static int mvsw_pr_fdb_event_handler_register(struct mvsw_pr_switch *sw)
+{
+	return mvsw_pr_hw_event_handler_register(sw, MVSW_EVENT_TYPE_FDB,
+						 mvsw_pr_fdb_handle_event);
+}
+
+static int mvsw_pr_port_event_handler_register(struct mvsw_pr_switch *sw)
+{
+	return mvsw_pr_hw_event_handler_register(sw, MVSW_EVENT_TYPE_PORT,
+						 mvsw_pr_port_handle_event);
+}
+
+static int mvsw_pr_event_handlers_register(struct mvsw_pr_switch *sw)
+{
+	int err;
+
+	err =3D mvsw_pr_port_event_handler_register(sw);
+	if (err)
+		return err;
+
+	err =3D mvsw_pr_fdb_event_handler_register(sw);
+	if (err)
+		goto err_fdb_handler_register;
+
+	return 0;
+
+err_fdb_handler_register:
+	mvsw_pr_port_event_handler_unregister(sw);
+	return err;
+}
+
+static int mvsw_pr_init(struct mvsw_pr_switch *sw)
+{
+	u32 port;
+	int err;
+
+	err =3D mvsw_pr_hw_switch_init(sw);
+	if (err) {
+		dev_err(mvsw_dev(sw), "Failed to init Switch device\n");
+		return err;
+	}
+
+	dev_info(mvsw_dev(sw), "Initialized Switch device\n");
+
+	err =3D mvsw_pr_switchdev_register(sw);
+	if (err)
+		return err;
+
+	INIT_LIST_HEAD(&sw->port_list);
+
+	for (port =3D 0; port < sw->port_count; port++) {
+		err =3D mvsw_pr_port_create(sw, port);
+		if (err)
+			goto err_ports_init;
+	}
+
+	err =3D mvsw_pr_event_handlers_register(sw);
+	if (err)
+		goto err_ports_init;
+
+	return 0;
+
+err_ports_init:
+	mvsw_pr_clear_ports(sw);
+	return err;
+}
+
+static void mvsw_pr_fini(struct mvsw_pr_switch *sw)
+{
+	mvsw_pr_event_handlers_unregister(sw);
+
+	mvsw_pr_switchdev_unregister(sw);
+	mvsw_pr_clear_ports(sw);
+}
+
+int mvsw_pr_device_register(struct mvsw_pr_device *dev)
+{
+	struct mvsw_pr_switch *sw;
+	int err;
+
+	sw =3D kzalloc(sizeof(*sw), GFP_KERNEL);
+	if (!sw)
+		return -ENOMEM;
+
+	dev->priv =3D sw;
+	sw->dev =3D dev;
+
+	err =3D mvsw_pr_init(sw);
+	if (err) {
+		kfree(sw);
+		return err;
+	}
+
+	list_add(&sw->list, &switches_registered);
+
+	return 0;
+}
+EXPORT_SYMBOL(mvsw_pr_device_register);
+
+void mvsw_pr_device_unregister(struct mvsw_pr_device *dev)
+{
+	struct mvsw_pr_switch *sw =3D dev->priv;
+
+	list_del(&sw->list);
+	mvsw_pr_fini(sw);
+	kfree(sw);
+}
+EXPORT_SYMBOL(mvsw_pr_device_unregister);
+
+static int __init mvsw_pr_module_init(void)
+{
+	INIT_LIST_HEAD(&switches_registered);
+
+	mvsw_pr_wq =3D alloc_workqueue(mvsw_driver_name, 0, 0);
+	if (!mvsw_pr_wq)
+		return -ENOMEM;
+
+	pr_info("Loading Marvell Prestera Switch Driver\n");
+	return 0;
+}
+
+static void __exit mvsw_pr_module_exit(void)
+{
+	destroy_workqueue(mvsw_pr_wq);
+
+	pr_info("Unloading Marvell Prestera Switch Driver\n");
+}
+
+module_init(mvsw_pr_module_init);
+module_exit(mvsw_pr_module_exit);
+
+MODULE_AUTHOR("Marvell Semi.");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Marvell Prestera switch driver");
+MODULE_VERSION(PRESTERA_DRV_VER);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net=
/ethernet/marvell/prestera/prestera.h
new file mode 100644
index 000000000000..cbc6b0c78937
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -0,0 +1,244 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+ *
+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
+ *
+ */
+
+#ifndef _MVSW_PRESTERA_H_
+#define _MVSW_PRESTERA_H_
+
+#include <linux/skbuff.h>
+#include <linux/notifier.h>
+#include <uapi/linux/if_ether.h>
+#include <linux/workqueue.h>
+
+#define MVSW_MSG_MAX_SIZE 1500
+
+#define MVSW_PR_DEFAULT_VID 1
+
+#define MVSW_PR_MIN_AGEING_TIME 10
+#define MVSW_PR_MAX_AGEING_TIME 1000000
+#define MVSW_PR_DEFAULT_AGEING_TIME 300
+
+struct mvsw_fw_rev {
+	u16 maj;
+	u16 min;
+	u16 sub;
+};
+
+struct mvsw_pr_bridge_port;
+
+struct mvsw_pr_port_vlan {
+	struct list_head list;
+	struct mvsw_pr_port *mvsw_pr_port;
+	u16 vid;
+	struct mvsw_pr_bridge_port *bridge_port;
+	struct list_head bridge_vlan_node;
+};
+
+struct mvsw_pr_port_stats {
+	u64 good_octets_received;
+	u64 bad_octets_received;
+	u64 mac_trans_error;
+	u64 broadcast_frames_received;
+	u64 multicast_frames_received;
+	u64 frames_64_octets;
+	u64 frames_65_to_127_octets;
+	u64 frames_128_to_255_octets;
+	u64 frames_256_to_511_octets;
+	u64 frames_512_to_1023_octets;
+	u64 frames_1024_to_max_octets;
+	u64 excessive_collision;
+	u64 multicast_frames_sent;
+	u64 broadcast_frames_sent;
+	u64 fc_sent;
+	u64 fc_received;
+	u64 buffer_overrun;
+	u64 undersize;
+	u64 fragments;
+	u64 oversize;
+	u64 jabber;
+	u64 rx_error_frame_received;
+	u64 bad_crc;
+	u64 collisions;
+	u64 late_collision;
+	u64 unicast_frames_received;
+	u64 unicast_frames_sent;
+	u64 sent_multiple;
+	u64 sent_deferred;
+	u64 frames_1024_to_1518_octets;
+	u64 frames_1519_to_max_octets;
+	u64 good_octets_sent;
+};
+
+struct mvsw_pr_port_caps {
+	u64 supp_link_modes;
+	u8 supp_fec;
+	u8 type;
+	u8 transceiver;
+};
+
+struct mvsw_pr_port {
+	struct net_device *net_dev;
+	struct mvsw_pr_switch *sw;
+	u32 id;
+	u32 hw_id;
+	u32 dev_id;
+	u16 fp_id;
+	u16 pvid;
+	bool autoneg;
+	u64 adver_link_modes;
+	u8 adver_fec;
+	struct mvsw_pr_port_caps caps;
+	struct list_head list;
+	struct list_head vlans_list;
+	struct {
+		struct mvsw_pr_port_stats stats;
+		struct delayed_work caching_dw;
+	} cached_hw_stats;
+};
+
+struct mvsw_pr_switchdev {
+	struct mvsw_pr_switch *sw;
+	struct notifier_block swdev_n;
+	struct notifier_block swdev_blocking_n;
+};
+
+struct mvsw_pr_fib {
+	struct mvsw_pr_switch *sw;
+	struct notifier_block fib_nb;
+	struct notifier_block netevent_nb;
+};
+
+struct mvsw_pr_device {
+	struct device *dev;
+	struct mvsw_fw_rev fw_rev;
+	void *priv;
+
+	/* called by device driver to pass event up to the higher layer */
+	int (*recv_msg)(struct mvsw_pr_device *dev, u8 *msg, size_t size);
+
+	/* called by higher layer to send request to the firmware */
+	int (*send_req)(struct mvsw_pr_device *dev, u8 *in_msg,
+			size_t in_size, u8 *out_msg, size_t out_size,
+			unsigned int wait);
+};
+
+enum mvsw_pr_event_type {
+	MVSW_EVENT_TYPE_UNSPEC,
+	MVSW_EVENT_TYPE_PORT,
+	MVSW_EVENT_TYPE_FDB,
+
+	MVSW_EVENT_TYPE_MAX,
+};
+
+enum mvsw_pr_port_event_id {
+	MVSW_PORT_EVENT_UNSPEC,
+	MVSW_PORT_EVENT_STATE_CHANGED,
+
+	MVSW_PORT_EVENT_MAX,
+};
+
+enum mvsw_pr_fdb_event_id {
+	MVSW_FDB_EVENT_UNSPEC,
+	MVSW_FDB_EVENT_LEARNED,
+	MVSW_FDB_EVENT_AGED,
+
+	MVSW_FDB_EVENT_MAX,
+};
+
+struct mvsw_pr_fdb_event {
+	u32 port_id;
+	u32 vid;
+	union {
+		u8 mac[ETH_ALEN];
+	} data;
+};
+
+struct mvsw_pr_port_event {
+	u32 port_id;
+	union {
+		u32 oper_state;
+	} data;
+};
+
+struct mvsw_pr_event {
+	u16 id;
+	union {
+		struct mvsw_pr_port_event port_evt;
+		struct mvsw_pr_fdb_event fdb_evt;
+	};
+};
+
+struct mvsw_pr_bridge;
+
+struct mvsw_pr_switch {
+	struct list_head list;
+	struct mvsw_pr_device *dev;
+	struct list_head event_handlers;
+	char base_mac[ETH_ALEN];
+	struct list_head port_list;
+	u32 port_count;
+	u32 mtu_min;
+	u32 mtu_max;
+	u8 id;
+	struct mvsw_pr_bridge *bridge;
+	struct mvsw_pr_switchdev *switchdev;
+	struct mvsw_pr_fib *fib;
+	struct notifier_block netdevice_nb;
+};
+
+enum mvsw_pr_fdb_flush_mode {
+	MVSW_PR_FDB_FLUSH_MODE_DYNAMIC =3D BIT(0),
+	MVSW_PR_FDB_FLUSH_MODE_STATIC =3D BIT(1),
+	MVSW_PR_FDB_FLUSH_MODE_ALL =3D MVSW_PR_FDB_FLUSH_MODE_DYNAMIC
+				   | MVSW_PR_FDB_FLUSH_MODE_STATIC,
+};
+
+int mvsw_pr_switch_ageing_set(struct mvsw_pr_switch *sw, u32 ageing_time);
+
+int mvsw_pr_port_learning_set(struct mvsw_pr_port *mvsw_pr_port,
+			      bool learn_enable);
+int mvsw_pr_port_flood_set(struct mvsw_pr_port *mvsw_pr_port, bool flood);
+int mvsw_pr_port_pvid_set(struct mvsw_pr_port *mvsw_pr_port, u16 vid);
+struct mvsw_pr_port_vlan *
+mvsw_pr_port_vlan_create(struct mvsw_pr_port *mvsw_pr_port, u16 vid);
+void mvsw_pr_port_vlan_destroy(struct mvsw_pr_port_vlan *mvsw_pr_port_vlan=
);
+int mvsw_pr_port_vlan_set(struct mvsw_pr_port *mvsw_pr_port, u16 vid,
+			  bool is_member, bool untagged);
+
+int mvsw_pr_8021d_bridge_create(struct mvsw_pr_switch *sw, u16 *bridge_id)=
;
+int mvsw_pr_8021d_bridge_delete(struct mvsw_pr_switch *sw, u16 bridge_id);
+int mvsw_pr_8021d_bridge_port_add(struct mvsw_pr_port *mvsw_pr_port,
+				  u16 bridge_id);
+int mvsw_pr_8021d_bridge_port_delete(struct mvsw_pr_port *mvsw_pr_port,
+				     u16 bridge_id);
+
+int mvsw_pr_fdb_add(struct mvsw_pr_port *mvsw_pr_port, const unsigned char=
 *mac,
+		    u16 vid, bool dynamic);
+int mvsw_pr_fdb_del(struct mvsw_pr_port *mvsw_pr_port, const unsigned char=
 *mac,
+		    u16 vid);
+int mvsw_pr_fdb_flush_vlan(struct mvsw_pr_switch *sw, u16 vid,
+			   enum mvsw_pr_fdb_flush_mode mode);
+int mvsw_pr_fdb_flush_port_vlan(struct mvsw_pr_port *port, u16 vid,
+				enum mvsw_pr_fdb_flush_mode mode);
+int mvsw_pr_fdb_flush_port(struct mvsw_pr_port *port,
+			   enum mvsw_pr_fdb_flush_mode mode);
+
+struct mvsw_pr_port_vlan *
+mvsw_pr_port_vlan_find_by_vid(const struct mvsw_pr_port *mvsw_pr_port, u16=
 vid);
+void
+mvsw_pr_port_vlan_bridge_leave(struct mvsw_pr_port_vlan *mvsw_pr_port_vlan=
);
+
+int mvsw_pr_switchdev_register(struct mvsw_pr_switch *sw);
+void mvsw_pr_switchdev_unregister(struct mvsw_pr_switch *sw);
+
+int mvsw_pr_device_register(struct mvsw_pr_device *dev);
+void mvsw_pr_device_unregister(struct mvsw_pr_device *dev);
+
+bool mvsw_pr_netdev_check(const struct net_device *dev);
+struct mvsw_pr_port *mvsw_pr_port_dev_lower_find(struct net_device *dev);
+
+const struct mvsw_pr_port *mvsw_pr_port_find(u32 dev_hw_id, u32 port_hw_id=
);
+
+#endif /* _MVSW_PRESTERA_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_drv_ver.h b/dri=
vers/net/ethernet/marvell/prestera/prestera_drv_ver.h
new file mode 100644
index 000000000000..d6617a16d7e1
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_drv_ver.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+ *
+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
+ *
+ */
+#ifndef _PRESTERA_DRV_VER_H_
+#define _PRESTERA_DRV_VER_H_
+
+#include <linux/stringify.h>
+
+/* Prestera driver version */
+#define PRESTERA_DRV_VER_MAJOR	1
+#define PRESTERA_DRV_VER_MINOR	0
+#define PRESTERA_DRV_VER_PATCH	0
+#define PRESTERA_DRV_VER_EXTRA
+
+#define PRESTERA_DRV_VER \
+		__stringify(PRESTERA_DRV_VER_MAJOR)  "." \
+		__stringify(PRESTERA_DRV_VER_MINOR)  "." \
+		__stringify(PRESTERA_DRV_VER_PATCH)  \
+		__stringify(PRESTERA_DRV_VER_EXTRA)
+
+#endif  /* _PRESTERA_DRV_VER_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/=
net/ethernet/marvell/prestera/prestera_hw.c
new file mode 100644
index 000000000000..c97bafdd734e
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -0,0 +1,1094 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+ *
+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
+ *
+ */
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/netdevice.h>
+#include <linux/list.h>
+
+#include "prestera.h"
+#include "prestera_hw.h"
+
+#define MVSW_PR_INIT_TIMEOUT 30000000	/* 30sec */
+#define MVSW_PR_MIN_MTU 64
+
+enum mvsw_msg_type {
+	MVSW_MSG_TYPE_SWITCH_UNSPEC,
+	MVSW_MSG_TYPE_SWITCH_INIT,
+
+	MVSW_MSG_TYPE_AGEING_TIMEOUT_SET,
+
+	MVSW_MSG_TYPE_PORT_ATTR_SET,
+	MVSW_MSG_TYPE_PORT_ATTR_GET,
+	MVSW_MSG_TYPE_PORT_INFO_GET,
+
+	MVSW_MSG_TYPE_VLAN_CREATE,
+	MVSW_MSG_TYPE_VLAN_DELETE,
+	MVSW_MSG_TYPE_VLAN_PORT_SET,
+	MVSW_MSG_TYPE_VLAN_PVID_SET,
+
+	MVSW_MSG_TYPE_FDB_ADD,
+	MVSW_MSG_TYPE_FDB_DELETE,
+	MVSW_MSG_TYPE_FDB_FLUSH_PORT,
+	MVSW_MSG_TYPE_FDB_FLUSH_VLAN,
+	MVSW_MSG_TYPE_FDB_FLUSH_PORT_VLAN,
+
+	MVSW_MSG_TYPE_LOG_LEVEL_SET,
+
+	MVSW_MSG_TYPE_BRIDGE_CREATE,
+	MVSW_MSG_TYPE_BRIDGE_DELETE,
+	MVSW_MSG_TYPE_BRIDGE_PORT_ADD,
+	MVSW_MSG_TYPE_BRIDGE_PORT_DELETE,
+
+	MVSW_MSG_TYPE_ACK,
+	MVSW_MSG_TYPE_MAX
+};
+
+enum mvsw_msg_port_attr {
+	MVSW_MSG_PORT_ATTR_ADMIN_STATE,
+	MVSW_MSG_PORT_ATTR_OPER_STATE,
+	MVSW_MSG_PORT_ATTR_MTU,
+	MVSW_MSG_PORT_ATTR_MAC,
+	MVSW_MSG_PORT_ATTR_SPEED,
+	MVSW_MSG_PORT_ATTR_ACCEPT_FRAME_TYPE,
+	MVSW_MSG_PORT_ATTR_LEARNING,
+	MVSW_MSG_PORT_ATTR_FLOOD,
+	MVSW_MSG_PORT_ATTR_CAPABILITY,
+	MVSW_MSG_PORT_ATTR_REMOTE_CAPABILITY,
+	MVSW_MSG_PORT_ATTR_LINK_MODE,
+	MVSW_MSG_PORT_ATTR_TYPE,
+	MVSW_MSG_PORT_ATTR_FEC,
+	MVSW_MSG_PORT_ATTR_AUTONEG,
+	MVSW_MSG_PORT_ATTR_DUPLEX,
+	MVSW_MSG_PORT_ATTR_STATS,
+	MVSW_MSG_PORT_ATTR_MDIX,
+	MVSW_MSG_PORT_ATTR_MAX
+};
+
+enum {
+	MVSW_MSG_ACK_OK,
+	MVSW_MSG_ACK_FAILED,
+	MVSW_MSG_ACK_MAX
+};
+
+enum {
+	MVSW_MODE_FORCED_MDI,
+	MVSW_MODE_FORCED_MDIX,
+	MVSW_MODE_AUTO_MDI,
+	MVSW_MODE_AUTO_MDIX,
+	MVSW_MODE_AUTO
+};
+
+enum {
+	MVSW_PORT_GOOD_OCTETS_RCV_CNT,
+	MVSW_PORT_BAD_OCTETS_RCV_CNT,
+	MVSW_PORT_MAC_TRANSMIT_ERR_CNT,
+	MVSW_PORT_BRDC_PKTS_RCV_CNT,
+	MVSW_PORT_MC_PKTS_RCV_CNT,
+	MVSW_PORT_PKTS_64_OCTETS_CNT,
+	MVSW_PORT_PKTS_65TO127_OCTETS_CNT,
+	MVSW_PORT_PKTS_128TO255_OCTETS_CNT,
+	MVSW_PORT_PKTS_256TO511_OCTETS_CNT,
+	MVSW_PORT_PKTS_512TO1023_OCTETS_CNT,
+	MVSW_PORT_PKTS_1024TOMAX_OCTETS_CNT,
+	MVSW_PORT_EXCESSIVE_COLLISIONS_CNT,
+	MVSW_PORT_MC_PKTS_SENT_CNT,
+	MVSW_PORT_BRDC_PKTS_SENT_CNT,
+	MVSW_PORT_FC_SENT_CNT,
+	MVSW_PORT_GOOD_FC_RCV_CNT,
+	MVSW_PORT_DROP_EVENTS_CNT,
+	MVSW_PORT_UNDERSIZE_PKTS_CNT,
+	MVSW_PORT_FRAGMENTS_PKTS_CNT,
+	MVSW_PORT_OVERSIZE_PKTS_CNT,
+	MVSW_PORT_JABBER_PKTS_CNT,
+	MVSW_PORT_MAC_RCV_ERROR_CNT,
+	MVSW_PORT_BAD_CRC_CNT,
+	MVSW_PORT_COLLISIONS_CNT,
+	MVSW_PORT_LATE_COLLISIONS_CNT,
+	MVSW_PORT_GOOD_UC_PKTS_RCV_CNT,
+	MVSW_PORT_GOOD_UC_PKTS_SENT_CNT,
+	MVSW_PORT_MULTIPLE_PKTS_SENT_CNT,
+	MVSW_PORT_DEFERRED_PKTS_SENT_CNT,
+	MVSW_PORT_PKTS_1024TO1518_OCTETS_CNT,
+	MVSW_PORT_PKTS_1519TOMAX_OCTETS_CNT,
+	MVSW_PORT_GOOD_OCTETS_SENT_CNT,
+	MVSW_PORT_CNT_MAX,
+};
+
+struct mvsw_msg_cmd {
+	u32 type;
+} __packed __aligned(4);
+
+struct mvsw_msg_ret {
+	struct mvsw_msg_cmd cmd;
+	u32 status;
+} __packed __aligned(4);
+
+struct mvsw_msg_common_request {
+	struct mvsw_msg_cmd cmd;
+} __packed __aligned(4);
+
+struct mvsw_msg_common_response {
+	struct mvsw_msg_ret ret;
+} __packed __aligned(4);
+
+union mvsw_msg_switch_param {
+	u32 ageing_timeout;
+};
+
+struct mvsw_msg_switch_attr_cmd {
+	struct mvsw_msg_cmd cmd;
+	union mvsw_msg_switch_param param;
+} __packed __aligned(4);
+
+struct mvsw_msg_switch_init_ret {
+	struct mvsw_msg_ret ret;
+	u32 port_count;
+	u32 mtu_max;
+	u8  switch_id;
+	u8  mac[ETH_ALEN];
+} __packed __aligned(4);
+
+struct mvsw_msg_port_autoneg_param {
+	u64 link_mode;
+	u8  enable;
+	u8  fec;
+};
+
+struct mvsw_msg_port_cap_param {
+	u64 link_mode;
+	u8  type;
+	u8  fec;
+	u8  transceiver;
+};
+
+union mvsw_msg_port_param {
+	u8  admin_state;
+	u8  oper_state;
+	u32 mtu;
+	u8  mac[ETH_ALEN];
+	u8  accept_frm_type;
+	u8  learning;
+	u32 speed;
+	u8  flood;
+	u32 link_mode;
+	u8  type;
+	u8  duplex;
+	u8  fec;
+	u8  mdix;
+	struct mvsw_msg_port_autoneg_param autoneg;
+	struct mvsw_msg_port_cap_param cap;
+};
+
+struct mvsw_msg_port_attr_cmd {
+	struct mvsw_msg_cmd cmd;
+	u32 attr;
+	u32 port;
+	u32 dev;
+	union mvsw_msg_port_param param;
+} __packed __aligned(4);
+
+struct mvsw_msg_port_attr_ret {
+	struct mvsw_msg_ret ret;
+	union mvsw_msg_port_param param;
+} __packed __aligned(4);
+
+struct mvsw_msg_port_stats_ret {
+	struct mvsw_msg_ret ret;
+	u64 stats[MVSW_PORT_CNT_MAX];
+} __packed __aligned(4);
+
+struct mvsw_msg_port_info_cmd {
+	struct mvsw_msg_cmd cmd;
+	u32 port;
+} __packed __aligned(4);
+
+struct mvsw_msg_port_info_ret {
+	struct mvsw_msg_ret ret;
+	u32 hw_id;
+	u32 dev_id;
+	u16 fp_id;
+} __packed __aligned(4);
+
+struct mvsw_msg_vlan_cmd {
+	struct mvsw_msg_cmd cmd;
+	u32 port;
+	u32 dev;
+	u16 vid;
+	u8  is_member;
+	u8  is_tagged;
+} __packed __aligned(4);
+
+struct mvsw_msg_fdb_cmd {
+	struct mvsw_msg_cmd cmd;
+	u32 port;
+	u32 dev;
+	u8  mac[ETH_ALEN];
+	u16 vid;
+	u8  dynamic;
+	u32 flush_mode;
+} __packed __aligned(4);
+
+struct mvsw_msg_event {
+	u16 type;
+	u16 id;
+} __packed __aligned(4);
+
+union mvsw_msg_event_fdb_param {
+	u8 mac[ETH_ALEN];
+};
+
+struct mvsw_msg_event_fdb {
+	struct mvsw_msg_event id;
+	u32 port_id;
+	u32 vid;
+	union mvsw_msg_event_fdb_param param;
+} __packed __aligned(4);
+
+union mvsw_msg_event_port_param {
+	u32 oper_state;
+};
+
+struct mvsw_msg_event_port {
+	struct mvsw_msg_event id;
+	u32 port_id;
+	union mvsw_msg_event_port_param param;
+} __packed __aligned(4);
+
+struct mvsw_msg_bridge_cmd {
+	struct mvsw_msg_cmd cmd;
+	u32 port;
+	u32 dev;
+	u16 bridge;
+} __packed __aligned(4);
+
+struct mvsw_msg_bridge_ret {
+	struct mvsw_msg_ret ret;
+	u16 bridge;
+} __packed __aligned(4);
+
+#define fw_check_resp(_response)	\
+({								\
+	int __er =3D 0;						\
+	typeof(_response) __r =3D (_response);			\
+	if (__r->ret.cmd.type !=3D MVSW_MSG_TYPE_ACK)		\
+		__er =3D -EBADE;					\
+	else if (__r->ret.status !=3D MVSW_MSG_ACK_OK)		\
+		__er =3D -EINVAL;					\
+	(__er);							\
+})
+
+#define __fw_send_req_resp(_switch, _type, _request, _response, _wait)	\
+({								\
+	int __e;						\
+	typeof(_switch) __sw =3D (_switch);			\
+	typeof(_request) __req =3D (_request);			\
+	typeof(_response) __resp =3D (_response);			\
+	__req->cmd.type =3D (_type);				\
+	__e =3D __sw->dev->send_req(__sw->dev,			\
+		(u8 *)__req, sizeof(*__req),			\
+		(u8 *)__resp, sizeof(*__resp),			\
+		_wait);						\
+	if (!__e)						\
+		__e =3D fw_check_resp(__resp);			\
+	(__e);							\
+})
+
+#define fw_send_req_resp(_sw, _t, _req, _resp)	\
+	__fw_send_req_resp(_sw, _t, _req, _resp, 0)
+
+#define fw_send_req_resp_wait(_sw, _t, _req, _resp, _wait)	\
+	__fw_send_req_resp(_sw, _t, _req, _resp, _wait)
+
+#define fw_send_req(_sw, _t, _req)	\
+({							\
+	struct mvsw_msg_common_response __re;		\
+	(fw_send_req_resp(_sw, _t, _req, &__re));	\
+})
+
+struct mvsw_fw_event_handler {
+	struct list_head list;
+	enum mvsw_pr_event_type type;
+	void (*func)(struct mvsw_pr_switch *sw, struct mvsw_pr_event *evt);
+};
+
+static int fw_parse_port_evt(u8 *msg, struct mvsw_pr_event *evt)
+{
+	struct mvsw_msg_event_port *hw_evt =3D (struct mvsw_msg_event_port *)msg;
+
+	evt->port_evt.port_id =3D hw_evt->port_id;
+
+	if (evt->id =3D=3D MVSW_PORT_EVENT_STATE_CHANGED)
+		evt->port_evt.data.oper_state =3D hw_evt->param.oper_state;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int fw_parse_fdb_evt(u8 *msg, struct mvsw_pr_event *evt)
+{
+	struct mvsw_msg_event_fdb *hw_evt =3D (struct mvsw_msg_event_fdb *)msg;
+
+	evt->fdb_evt.port_id	=3D hw_evt->port_id;
+	evt->fdb_evt.vid	=3D hw_evt->vid;
+
+	memcpy(&evt->fdb_evt.data, &hw_evt->param, sizeof(u8) * ETH_ALEN);
+
+	return 0;
+}
+
+struct mvsw_fw_evt_parser {
+	int (*func)(u8 *msg, struct mvsw_pr_event *evt);
+};
+
+static struct mvsw_fw_evt_parser fw_event_parsers[MVSW_EVENT_TYPE_MAX] =3D=
 {
+	[MVSW_EVENT_TYPE_PORT] =3D {.func =3D fw_parse_port_evt},
+	[MVSW_EVENT_TYPE_FDB] =3D {.func =3D fw_parse_fdb_evt},
+};
+
+static struct mvsw_fw_event_handler *
+__find_event_handler(const struct mvsw_pr_switch *sw,
+		     enum mvsw_pr_event_type type)
+{
+	struct mvsw_fw_event_handler *eh;
+
+	list_for_each_entry_rcu(eh, &sw->event_handlers, list) {
+		if (eh->type =3D=3D type)
+			return eh;
+	}
+
+	return NULL;
+}
+
+static int fw_event_recv(struct mvsw_pr_device *dev, u8 *buf, size_t size)
+{
+	void (*cb)(struct mvsw_pr_switch *sw, struct mvsw_pr_event *evt) =3D NULL=
;
+	struct mvsw_msg_event *msg =3D (struct mvsw_msg_event *)buf;
+	struct mvsw_pr_switch *sw =3D dev->priv;
+	struct mvsw_fw_event_handler *eh;
+	struct mvsw_pr_event evt;
+	int err;
+
+	if (msg->type >=3D MVSW_EVENT_TYPE_MAX)
+		return -EINVAL;
+
+	rcu_read_lock();
+	eh =3D __find_event_handler(sw, msg->type);
+	if (eh)
+		cb =3D eh->func;
+	rcu_read_unlock();
+
+	if (!cb || !fw_event_parsers[msg->type].func)
+		return 0;
+
+	evt.id =3D msg->id;
+
+	err =3D fw_event_parsers[msg->type].func(buf, &evt);
+	if (!err)
+		cb(sw, &evt);
+
+	return err;
+}
+
+int mvsw_pr_hw_port_info_get(const struct mvsw_pr_port *port,
+			     u16 *fp_id, u32 *hw_id, u32 *dev_id)
+{
+	struct mvsw_msg_port_info_ret resp;
+	struct mvsw_msg_port_info_cmd req =3D {
+		.port =3D port->id
+	};
+	int err;
+
+	err =3D fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_INFO_GET,
+			       &req, &resp);
+	if (err)
+		return err;
+
+	*hw_id =3D resp.hw_id;
+	*dev_id =3D resp.dev_id;
+	*fp_id =3D resp.fp_id;
+
+	return 0;
+}
+
+int mvsw_pr_hw_switch_init(struct mvsw_pr_switch *sw)
+{
+	struct mvsw_msg_switch_init_ret resp;
+	struct mvsw_msg_common_request req;
+	int err =3D 0;
+
+	INIT_LIST_HEAD(&sw->event_handlers);
+
+	err =3D fw_send_req_resp_wait(sw, MVSW_MSG_TYPE_SWITCH_INIT, &req, &resp,
+				    MVSW_PR_INIT_TIMEOUT);
+	if (err)
+		return err;
+
+	sw->id =3D resp.switch_id;
+	sw->port_count =3D resp.port_count;
+	sw->mtu_min =3D MVSW_PR_MIN_MTU;
+	sw->mtu_max =3D resp.mtu_max;
+	sw->dev->recv_msg =3D fw_event_recv;
+	memcpy(sw->base_mac, resp.mac, ETH_ALEN);
+
+	return err;
+}
+
+int mvsw_pr_hw_switch_ageing_set(const struct mvsw_pr_switch *sw,
+				 u32 ageing_time)
+{
+	struct mvsw_msg_switch_attr_cmd req =3D {
+		.param =3D {.ageing_timeout =3D ageing_time}
+	};
+
+	return fw_send_req(sw, MVSW_MSG_TYPE_AGEING_TIMEOUT_SET, &req);
+}
+
+int mvsw_pr_hw_port_state_set(const struct mvsw_pr_port *port,
+			      bool admin_state)
+{
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_ADMIN_STATE,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id,
+		.param =3D {.admin_state =3D admin_state ? 1 : 0}
+	};
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
+}
+
+int mvsw_pr_hw_port_state_get(const struct mvsw_pr_port *port,
+			      bool *admin_state, bool *oper_state)
+{
+	struct mvsw_msg_port_attr_ret resp;
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id
+	};
+	int err;
+
+	if (admin_state) {
+		req.attr =3D MVSW_MSG_PORT_ATTR_ADMIN_STATE;
+		err =3D fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
+				       &req, &resp);
+		if (err)
+			return err;
+		*admin_state =3D resp.param.admin_state !=3D 0;
+	}
+
+	if (oper_state) {
+		req.attr =3D MVSW_MSG_PORT_ATTR_OPER_STATE;
+		err =3D fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
+				       &req, &resp);
+		if (err)
+			return err;
+		*oper_state =3D resp.param.oper_state !=3D 0;
+	}
+
+	return 0;
+}
+
+int mvsw_pr_hw_port_mtu_set(const struct mvsw_pr_port *port, u32 mtu)
+{
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_MTU,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id,
+		.param =3D {.mtu =3D mtu}
+	};
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
+}
+
+int mvsw_pr_hw_port_mtu_get(const struct mvsw_pr_port *port, u32 *mtu)
+{
+	struct mvsw_msg_port_attr_ret resp;
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_MTU,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id
+	};
+	int err;
+
+	err =3D fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
+			       &req, &resp);
+	if (err)
+		return err;
+
+	*mtu =3D resp.param.mtu;
+
+	return err;
+}
+
+int mvsw_pr_hw_port_mac_set(const struct mvsw_pr_port *port, char *mac)
+{
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_MAC,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id
+	};
+	memcpy(&req.param.mac, mac, sizeof(req.param.mac));
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
+}
+
+int mvsw_pr_hw_port_mac_get(const struct mvsw_pr_port *port, char *mac)
+{
+	struct mvsw_msg_port_attr_ret resp;
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_MAC,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id
+	};
+	int err;
+
+	err =3D fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
+			       &req, &resp);
+	if (err)
+		return err;
+
+	memcpy(mac, resp.param.mac, sizeof(resp.param.mac));
+
+	return err;
+}
+
+int mvsw_pr_hw_port_accept_frame_type_set(const struct mvsw_pr_port *port,
+					  enum mvsw_pr_accept_frame_type type)
+{
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_ACCEPT_FRAME_TYPE,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id,
+		.param =3D {.accept_frm_type =3D type}
+	};
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
+}
+
+int mvsw_pr_hw_port_learning_set(const struct mvsw_pr_port *port, bool ena=
ble)
+{
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_LEARNING,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id,
+		.param =3D {.learning =3D enable ? 1 : 0}
+	};
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
+}
+
+int mvsw_pr_hw_event_handler_register(struct mvsw_pr_switch *sw,
+				      enum mvsw_pr_event_type type,
+				      void (*cb)(struct mvsw_pr_switch *sw,
+						 struct mvsw_pr_event *evt))
+{
+	struct mvsw_fw_event_handler *eh;
+
+	eh =3D __find_event_handler(sw, type);
+	if (eh)
+		return -EEXIST;
+	eh =3D kmalloc(sizeof(*eh), GFP_KERNEL);
+	if (!eh)
+		return -ENOMEM;
+
+	eh->type =3D type;
+	eh->func =3D cb;
+
+	INIT_LIST_HEAD(&eh->list);
+
+	list_add_rcu(&eh->list, &sw->event_handlers);
+
+	return 0;
+}
+
+void mvsw_pr_hw_event_handler_unregister(struct mvsw_pr_switch *sw,
+					 enum mvsw_pr_event_type type,
+					 void (*cb)(struct mvsw_pr_switch *sw,
+						    struct mvsw_pr_event *evt))
+{
+	struct mvsw_fw_event_handler *eh;
+
+	eh =3D __find_event_handler(sw, type);
+	if (!eh)
+		return;
+
+	list_del_rcu(&eh->list);
+	synchronize_rcu();
+	kfree(eh);
+}
+
+int mvsw_pr_hw_vlan_create(const struct mvsw_pr_switch *sw, u16 vid)
+{
+	struct mvsw_msg_vlan_cmd req =3D {
+		.vid =3D vid,
+	};
+
+	return fw_send_req(sw, MVSW_MSG_TYPE_VLAN_CREATE, &req);
+}
+
+int mvsw_pr_hw_vlan_delete(const struct mvsw_pr_switch *sw, u16 vid)
+{
+	struct mvsw_msg_vlan_cmd req =3D {
+		.vid =3D vid,
+	};
+
+	return fw_send_req(sw, MVSW_MSG_TYPE_VLAN_DELETE, &req);
+}
+
+int mvsw_pr_hw_vlan_port_set(const struct mvsw_pr_port *port,
+			     u16 vid, bool is_member, bool untagged)
+{
+	struct mvsw_msg_vlan_cmd req =3D {
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id,
+		.vid =3D vid,
+		.is_member =3D is_member ? 1 : 0,
+		.is_tagged =3D untagged ? 0 : 1
+	};
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_VLAN_PORT_SET, &req);
+}
+
+int mvsw_pr_hw_vlan_port_vid_set(const struct mvsw_pr_port *port, u16 vid)
+{
+	struct mvsw_msg_vlan_cmd req =3D {
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id,
+		.vid =3D vid
+	};
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_VLAN_PVID_SET, &req);
+}
+
+int mvsw_pr_hw_port_speed_get(const struct mvsw_pr_port *port, u32 *speed)
+{
+	struct mvsw_msg_port_attr_ret resp;
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_SPEED,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id
+	};
+	int err;
+
+	err =3D fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
+			       &req, &resp);
+	if (err)
+		return err;
+
+	*speed =3D resp.param.speed;
+
+	return err;
+}
+
+int mvsw_pr_hw_port_flood_set(const struct mvsw_pr_port *port, bool flood)
+{
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_FLOOD,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id,
+		.param =3D {.flood =3D flood ? 1 : 0}
+	};
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
+}
+
+int mvsw_pr_hw_fdb_add(const struct mvsw_pr_port *port,
+		       const unsigned char *mac, u16 vid, bool dynamic)
+{
+	struct mvsw_msg_fdb_cmd req =3D {
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id,
+		.vid =3D vid,
+		.dynamic =3D dynamic ? 1 : 0
+	};
+
+	memcpy(req.mac, mac, sizeof(req.mac));
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_FDB_ADD, &req);
+}
+
+int mvsw_pr_hw_fdb_del(const struct mvsw_pr_port *port,
+		       const unsigned char *mac, u16 vid)
+{
+	struct mvsw_msg_fdb_cmd req =3D {
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id,
+		.vid =3D vid
+	};
+
+	memcpy(req.mac, mac, sizeof(req.mac));
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_FDB_DELETE, &req);
+}
+
+int mvsw_pr_hw_port_cap_get(const struct mvsw_pr_port *port,
+			    struct mvsw_pr_port_caps *caps)
+{
+	struct mvsw_msg_port_attr_ret resp;
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_CAPABILITY,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id
+	};
+	int err;
+
+	err =3D fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
+			       &req, &resp);
+	if (err)
+		return err;
+
+	caps->supp_link_modes =3D resp.param.cap.link_mode;
+	caps->supp_fec =3D resp.param.cap.fec;
+	caps->type =3D resp.param.cap.type;
+	caps->transceiver =3D resp.param.cap.transceiver;
+
+	return err;
+}
+
+int mvsw_pr_hw_port_remote_cap_get(const struct mvsw_pr_port *port,
+				   u64 *link_mode_bitmap)
+{
+	struct mvsw_msg_port_attr_ret resp;
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_REMOTE_CAPABILITY,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id
+	};
+	int err;
+
+	err =3D fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
+			       &req, &resp);
+	if (err)
+		return err;
+
+	*link_mode_bitmap =3D resp.param.cap.link_mode;
+
+	return err;
+}
+
+int mvsw_pr_hw_port_mdix_get(const struct mvsw_pr_port *port, u8 *mode)
+{
+	struct mvsw_msg_port_attr_ret resp;
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_MDIX,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id
+	};
+	int err;
+
+	err =3D fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
+			       &req, &resp);
+	if (err)
+		return err;
+
+	switch (resp.param.mdix) {
+	case MVSW_MODE_FORCED_MDI:
+	case MVSW_MODE_AUTO_MDI:
+		*mode =3D ETH_TP_MDI;
+		break;
+
+	case MVSW_MODE_FORCED_MDIX:
+	case MVSW_MODE_AUTO_MDIX:
+		*mode =3D ETH_TP_MDI_X;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int mvsw_pr_hw_port_mdix_set(const struct mvsw_pr_port *port, u8 mode)
+{
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_MDIX,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id
+	};
+
+	switch (mode) {
+	case ETH_TP_MDI:
+		req.param.mdix =3D MVSW_MODE_FORCED_MDI;
+		break;
+
+	case ETH_TP_MDI_X:
+		req.param.mdix =3D MVSW_MODE_FORCED_MDIX;
+		break;
+
+	case ETH_TP_MDI_AUTO:
+		req.param.mdix =3D MVSW_MODE_AUTO;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
+}
+
+int mvsw_pr_hw_port_type_get(const struct mvsw_pr_port *port, u8 *type)
+{
+	struct mvsw_msg_port_attr_ret resp;
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_TYPE,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id
+	};
+	int err;
+
+	err =3D fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
+			       &req, &resp);
+	if (err)
+		return err;
+
+	*type =3D resp.param.type;
+
+	return err;
+}
+
+int mvsw_pr_hw_port_fec_get(const struct mvsw_pr_port *port, u8 *fec)
+{
+	struct mvsw_msg_port_attr_ret resp;
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_FEC,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id
+	};
+	int err;
+
+	err =3D fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
+			       &req, &resp);
+	if (err)
+		return err;
+
+	*fec =3D resp.param.fec;
+
+	return err;
+}
+
+int mvsw_pr_hw_port_fec_set(const struct mvsw_pr_port *port, u8 fec)
+{
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_FEC,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id,
+		.param =3D {.fec =3D fec}
+	};
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
+}
+
+int mvsw_pr_hw_port_autoneg_set(const struct mvsw_pr_port *port,
+				bool autoneg, u64 link_modes, u8 fec)
+{
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_AUTONEG,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id,
+		.param =3D {.autoneg =3D {.link_mode =3D link_modes,
+				      .enable =3D autoneg ? 1 : 0,
+				      .fec =3D fec}
+		}
+	};
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
+}
+
+int mvsw_pr_hw_port_duplex_get(const struct mvsw_pr_port *port, u8 *duplex=
)
+{
+	struct mvsw_msg_port_attr_ret resp;
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_DUPLEX,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id
+	};
+	int err;
+
+	err =3D fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
+			       &req, &resp);
+	if (err)
+		return err;
+
+	*duplex =3D resp.param.duplex;
+
+	return err;
+}
+
+int mvsw_pr_hw_port_stats_get(const struct mvsw_pr_port *port,
+			      struct mvsw_pr_port_stats *stats)
+{
+	struct mvsw_msg_port_stats_ret resp;
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_STATS,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id
+	};
+	u64 *hw_val =3D resp.stats;
+	int err;
+
+	err =3D fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
+			       &req, &resp);
+	if (err)
+		return err;
+
+	stats->good_octets_received =3D hw_val[MVSW_PORT_GOOD_OCTETS_RCV_CNT];
+	stats->bad_octets_received =3D hw_val[MVSW_PORT_BAD_OCTETS_RCV_CNT];
+	stats->mac_trans_error =3D hw_val[MVSW_PORT_MAC_TRANSMIT_ERR_CNT];
+	stats->broadcast_frames_received =3D hw_val[MVSW_PORT_BRDC_PKTS_RCV_CNT];
+	stats->multicast_frames_received =3D hw_val[MVSW_PORT_MC_PKTS_RCV_CNT];
+	stats->frames_64_octets =3D hw_val[MVSW_PORT_PKTS_64_OCTETS_CNT];
+	stats->frames_65_to_127_octets =3D
+		hw_val[MVSW_PORT_PKTS_65TO127_OCTETS_CNT];
+	stats->frames_128_to_255_octets =3D
+		hw_val[MVSW_PORT_PKTS_128TO255_OCTETS_CNT];
+	stats->frames_256_to_511_octets =3D
+		hw_val[MVSW_PORT_PKTS_256TO511_OCTETS_CNT];
+	stats->frames_512_to_1023_octets =3D
+		hw_val[MVSW_PORT_PKTS_512TO1023_OCTETS_CNT];
+	stats->frames_1024_to_max_octets =3D
+		hw_val[MVSW_PORT_PKTS_1024TOMAX_OCTETS_CNT];
+	stats->excessive_collision =3D hw_val[MVSW_PORT_EXCESSIVE_COLLISIONS_CNT]=
;
+	stats->multicast_frames_sent =3D hw_val[MVSW_PORT_MC_PKTS_SENT_CNT];
+	stats->broadcast_frames_sent =3D hw_val[MVSW_PORT_BRDC_PKTS_SENT_CNT];
+	stats->fc_sent =3D hw_val[MVSW_PORT_FC_SENT_CNT];
+	stats->fc_received =3D hw_val[MVSW_PORT_GOOD_FC_RCV_CNT];
+	stats->buffer_overrun =3D hw_val[MVSW_PORT_DROP_EVENTS_CNT];
+	stats->undersize =3D hw_val[MVSW_PORT_UNDERSIZE_PKTS_CNT];
+	stats->fragments =3D hw_val[MVSW_PORT_FRAGMENTS_PKTS_CNT];
+	stats->oversize =3D hw_val[MVSW_PORT_OVERSIZE_PKTS_CNT];
+	stats->jabber =3D hw_val[MVSW_PORT_JABBER_PKTS_CNT];
+	stats->rx_error_frame_received =3D hw_val[MVSW_PORT_MAC_RCV_ERROR_CNT];
+	stats->bad_crc =3D hw_val[MVSW_PORT_BAD_CRC_CNT];
+	stats->collisions =3D hw_val[MVSW_PORT_COLLISIONS_CNT];
+	stats->late_collision =3D hw_val[MVSW_PORT_LATE_COLLISIONS_CNT];
+	stats->unicast_frames_received =3D hw_val[MVSW_PORT_GOOD_UC_PKTS_RCV_CNT]=
;
+	stats->unicast_frames_sent =3D hw_val[MVSW_PORT_GOOD_UC_PKTS_SENT_CNT];
+	stats->sent_multiple =3D hw_val[MVSW_PORT_MULTIPLE_PKTS_SENT_CNT];
+	stats->sent_deferred =3D hw_val[MVSW_PORT_DEFERRED_PKTS_SENT_CNT];
+	stats->frames_1024_to_1518_octets =3D
+		hw_val[MVSW_PORT_PKTS_1024TO1518_OCTETS_CNT];
+	stats->frames_1519_to_max_octets =3D
+		hw_val[MVSW_PORT_PKTS_1519TOMAX_OCTETS_CNT];
+	stats->good_octets_sent =3D hw_val[MVSW_PORT_GOOD_OCTETS_SENT_CNT];
+
+	return 0;
+}
+
+int mvsw_pr_hw_bridge_create(const struct mvsw_pr_switch *sw, u16 *bridge_=
id)
+{
+	struct mvsw_msg_bridge_cmd req;
+	struct mvsw_msg_bridge_ret resp;
+	int err;
+
+	err =3D fw_send_req_resp(sw, MVSW_MSG_TYPE_BRIDGE_CREATE, &req, &resp);
+	if (err)
+		return err;
+
+	*bridge_id =3D resp.bridge;
+	return err;
+}
+
+int mvsw_pr_hw_bridge_delete(const struct mvsw_pr_switch *sw, u16 bridge_i=
d)
+{
+	struct mvsw_msg_bridge_cmd req =3D {
+		.bridge =3D bridge_id
+	};
+
+	return fw_send_req(sw, MVSW_MSG_TYPE_BRIDGE_DELETE, &req);
+}
+
+int mvsw_pr_hw_bridge_port_add(const struct mvsw_pr_port *port, u16 bridge=
_id)
+{
+	struct mvsw_msg_bridge_cmd req =3D {
+		.bridge =3D bridge_id,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id
+	};
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_BRIDGE_PORT_ADD, &req);
+}
+
+int mvsw_pr_hw_bridge_port_delete(const struct mvsw_pr_port *port,
+				  u16 bridge_id)
+{
+	struct mvsw_msg_bridge_cmd req =3D {
+		.bridge =3D bridge_id,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id
+	};
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_BRIDGE_PORT_DELETE, &req);
+}
+
+int mvsw_pr_hw_fdb_flush_port(const struct mvsw_pr_port *port, u32 mode)
+{
+	struct mvsw_msg_fdb_cmd req =3D {
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id,
+		.flush_mode =3D mode,
+	};
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_FDB_FLUSH_PORT, &req);
+}
+
+int mvsw_pr_hw_fdb_flush_vlan(const struct mvsw_pr_switch *sw, u16 vid,
+			      u32 mode)
+{
+	struct mvsw_msg_fdb_cmd req =3D {
+		.vid =3D vid,
+		.flush_mode =3D mode,
+	};
+
+	return fw_send_req(sw, MVSW_MSG_TYPE_FDB_FLUSH_VLAN, &req);
+}
+
+int mvsw_pr_hw_fdb_flush_port_vlan(const struct mvsw_pr_port *port, u16 vi=
d,
+				   u32 mode)
+{
+	struct mvsw_msg_fdb_cmd req =3D {
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id,
+		.vid =3D vid,
+		.flush_mode =3D mode,
+	};
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_FDB_FLUSH_PORT_VLAN, &req);
+}
+
+int mvsw_pr_hw_port_link_mode_get(const struct mvsw_pr_port *port,
+				  u32 *mode)
+{
+	struct mvsw_msg_port_attr_ret resp;
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_LINK_MODE,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id
+	};
+	int err;
+
+	err =3D fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
+			       &req, &resp);
+	if (err)
+		return err;
+
+	*mode =3D resp.param.link_mode;
+
+	return err;
+}
+
+int mvsw_pr_hw_port_link_mode_set(const struct mvsw_pr_port *port,
+				  u32 mode)
+{
+	struct mvsw_msg_port_attr_cmd req =3D {
+		.attr =3D MVSW_MSG_PORT_ATTR_LINK_MODE,
+		.port =3D port->hw_id,
+		.dev =3D port->dev_id,
+		.param =3D {.link_mode =3D mode}
+	};
+
+	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/=
net/ethernet/marvell/prestera/prestera_hw.h
new file mode 100644
index 000000000000..dfae2631160e
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -0,0 +1,159 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+ *
+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
+ *
+ */
+
+#ifndef _MVSW_PRESTERA_HW_H_
+#define _MVSW_PRESTERA_HW_H_
+
+#include <linux/types.h>
+
+enum mvsw_pr_accept_frame_type {
+	MVSW_ACCEPT_FRAME_TYPE_TAGGED,
+	MVSW_ACCEPT_FRAME_TYPE_UNTAGGED,
+	MVSW_ACCEPT_FRAME_TYPE_ALL
+};
+
+enum {
+	MVSW_LINK_MODE_10baseT_Half_BIT,
+	MVSW_LINK_MODE_10baseT_Full_BIT,
+	MVSW_LINK_MODE_100baseT_Half_BIT,
+	MVSW_LINK_MODE_100baseT_Full_BIT,
+	MVSW_LINK_MODE_1000baseT_Half_BIT,
+	MVSW_LINK_MODE_1000baseT_Full_BIT,
+	MVSW_LINK_MODE_1000baseX_Full_BIT,
+	MVSW_LINK_MODE_1000baseKX_Full_BIT,
+	MVSW_LINK_MODE_10GbaseKR_Full_BIT,
+	MVSW_LINK_MODE_10GbaseSR_Full_BIT,
+	MVSW_LINK_MODE_10GbaseLR_Full_BIT,
+	MVSW_LINK_MODE_20GbaseKR2_Full_BIT,
+	MVSW_LINK_MODE_25GbaseCR_Full_BIT,
+	MVSW_LINK_MODE_25GbaseKR_Full_BIT,
+	MVSW_LINK_MODE_25GbaseSR_Full_BIT,
+	MVSW_LINK_MODE_40GbaseKR4_Full_BIT,
+	MVSW_LINK_MODE_40GbaseCR4_Full_BIT,
+	MVSW_LINK_MODE_40GbaseSR4_Full_BIT,
+	MVSW_LINK_MODE_50GbaseCR2_Full_BIT,
+	MVSW_LINK_MODE_50GbaseKR2_Full_BIT,
+	MVSW_LINK_MODE_50GbaseSR2_Full_BIT,
+	MVSW_LINK_MODE_100GbaseKR4_Full_BIT,
+	MVSW_LINK_MODE_100GbaseSR4_Full_BIT,
+	MVSW_LINK_MODE_100GbaseCR4_Full_BIT,
+	MVSW_LINK_MODE_MAX,
+};
+
+enum {
+	MVSW_PORT_TYPE_NONE,
+	MVSW_PORT_TYPE_TP,
+	MVSW_PORT_TYPE_AUI,
+	MVSW_PORT_TYPE_MII,
+	MVSW_PORT_TYPE_FIBRE,
+	MVSW_PORT_TYPE_BNC,
+	MVSW_PORT_TYPE_DA,
+	MVSW_PORT_TYPE_OTHER,
+	MVSW_PORT_TYPE_MAX,
+};
+
+enum {
+	MVSW_PORT_TRANSCEIVER_COPPER,
+	MVSW_PORT_TRANSCEIVER_SFP,
+	MVSW_PORT_TRANSCEIVER_MAX,
+};
+
+enum {
+	MVSW_PORT_FEC_OFF_BIT,
+	MVSW_PORT_FEC_BASER_BIT,
+	MVSW_PORT_FEC_RS_BIT,
+	MVSW_PORT_FEC_MAX,
+};
+
+enum {
+	MVSW_PORT_DUPLEX_HALF,
+	MVSW_PORT_DUPLEX_FULL
+};
+
+struct mvsw_pr_switch;
+struct mvsw_pr_port;
+struct mvsw_pr_port_stats;
+struct mvsw_pr_port_caps;
+
+enum mvsw_pr_event_type;
+struct mvsw_pr_event;
+
+/* Switch API */
+int mvsw_pr_hw_switch_init(struct mvsw_pr_switch *sw);
+int mvsw_pr_hw_switch_ageing_set(const struct mvsw_pr_switch *sw,
+				 u32 ageing_time);
+
+/* Port API */
+int mvsw_pr_hw_port_info_get(const struct mvsw_pr_port *port,
+			     u16 *fp_id, u32 *hw_id, u32 *dev_id);
+int mvsw_pr_hw_port_state_set(const struct mvsw_pr_port *port,
+			      bool admin_state);
+int mvsw_pr_hw_port_state_get(const struct mvsw_pr_port *port,
+			      bool *admin_state, bool *oper_state);
+int mvsw_pr_hw_port_mtu_set(const struct mvsw_pr_port *port, u32 mtu);
+int mvsw_pr_hw_port_mtu_get(const struct mvsw_pr_port *port, u32 *mtu);
+int mvsw_pr_hw_port_mac_set(const struct mvsw_pr_port *port, char *mac);
+int mvsw_pr_hw_port_mac_get(const struct mvsw_pr_port *port, char *mac);
+int mvsw_pr_hw_port_accept_frame_type_set(const struct mvsw_pr_port *port,
+					  enum mvsw_pr_accept_frame_type type);
+int mvsw_pr_hw_port_learning_set(const struct mvsw_pr_port *port, bool ena=
ble);
+int mvsw_pr_hw_port_speed_get(const struct mvsw_pr_port *port, u32 *speed)=
;
+int mvsw_pr_hw_port_flood_set(const struct mvsw_pr_port *port, bool flood)=
;
+int mvsw_pr_hw_port_cap_get(const struct mvsw_pr_port *port,
+			    struct mvsw_pr_port_caps *caps);
+int mvsw_pr_hw_port_remote_cap_get(const struct mvsw_pr_port *port,
+				   u64 *link_mode_bitmap);
+int mvsw_pr_hw_port_type_get(const struct mvsw_pr_port *port, u8 *type);
+int mvsw_pr_hw_port_fec_get(const struct mvsw_pr_port *port, u8 *fec);
+int mvsw_pr_hw_port_fec_set(const struct mvsw_pr_port *port, u8 fec);
+int mvsw_pr_hw_port_autoneg_set(const struct mvsw_pr_port *port,
+				bool autoneg, u64 link_modes, u8 fec);
+int mvsw_pr_hw_port_duplex_get(const struct mvsw_pr_port *port, u8 *duplex=
);
+int mvsw_pr_hw_port_stats_get(const struct mvsw_pr_port *port,
+			      struct mvsw_pr_port_stats *stats);
+int mvsw_pr_hw_port_link_mode_get(const struct mvsw_pr_port *port,
+				  u32 *mode);
+int mvsw_pr_hw_port_link_mode_set(const struct mvsw_pr_port *port,
+				  u32 mode);
+int mvsw_pr_hw_port_mdix_get(const struct mvsw_pr_port *port, u8 *mode);
+int mvsw_pr_hw_port_mdix_set(const struct mvsw_pr_port *port, u8 mode);
+
+/* Vlan API */
+int mvsw_pr_hw_vlan_create(const struct mvsw_pr_switch *sw, u16 vid);
+int mvsw_pr_hw_vlan_delete(const struct mvsw_pr_switch *sw, u16 vid);
+int mvsw_pr_hw_vlan_port_set(const struct mvsw_pr_port *port,
+			     u16 vid, bool is_member, bool untagged);
+int mvsw_pr_hw_vlan_port_vid_set(const struct mvsw_pr_port *port, u16 vid)=
;
+
+/* FDB API */
+int mvsw_pr_hw_fdb_add(const struct mvsw_pr_port *port,
+		       const unsigned char *mac, u16 vid, bool dynamic);
+int mvsw_pr_hw_fdb_del(const struct mvsw_pr_port *port,
+		       const unsigned char *mac, u16 vid);
+int mvsw_pr_hw_fdb_flush_port(const struct mvsw_pr_port *port, u32 mode);
+int mvsw_pr_hw_fdb_flush_vlan(const struct mvsw_pr_switch *sw, u16 vid,
+			      u32 mode);
+int mvsw_pr_hw_fdb_flush_port_vlan(const struct mvsw_pr_port *port, u16 vi=
d,
+				   u32 mode);
+
+/* Bridge API */
+int mvsw_pr_hw_bridge_create(const struct mvsw_pr_switch *sw, u16 *bridge_=
id);
+int mvsw_pr_hw_bridge_delete(const struct mvsw_pr_switch *sw, u16 bridge_i=
d);
+int mvsw_pr_hw_bridge_port_add(const struct mvsw_pr_port *port, u16 bridge=
_id);
+int mvsw_pr_hw_bridge_port_delete(const struct mvsw_pr_port *port,
+				  u16 bridge_id);
+
+/* Event handlers */
+int mvsw_pr_hw_event_handler_register(struct mvsw_pr_switch *sw,
+				      enum mvsw_pr_event_type type,
+				      void (*cb)(struct mvsw_pr_switch *sw,
+						 struct mvsw_pr_event *evt));
+void mvsw_pr_hw_event_handler_unregister(struct mvsw_pr_switch *sw,
+					 enum mvsw_pr_event_type type,
+					 void (*cb)(struct mvsw_pr_switch *sw,
+						    struct mvsw_pr_event *evt));
+
+#endif /* _MVSW_PRESTERA_HW_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/d=
rivers/net/ethernet/marvell/prestera/prestera_switchdev.c
new file mode 100644
index 000000000000..18fa6bbe5ace
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -0,0 +1,1217 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+ *
+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/if_vlan.h>
+#include <linux/if_bridge.h>
+#include <linux/notifier.h>
+#include <net/switchdev.h>
+#include <net/netevent.h>
+#include <net/vxlan.h>
+
+#include "prestera.h"
+
+struct mvsw_pr_bridge {
+	struct mvsw_pr_switch *sw;
+	u32 ageing_time;
+	struct list_head bridge_list;
+	bool bridge_8021q_exists;
+};
+
+struct mvsw_pr_bridge_device {
+	struct net_device *dev;
+	struct list_head bridge_node;
+	struct list_head port_list;
+	u16 bridge_id;
+	u8 vlan_enabled:1, multicast_enabled:1, mrouter:1;
+};
+
+struct mvsw_pr_bridge_port {
+	struct net_device *dev;
+	struct mvsw_pr_bridge_device *bridge_device;
+	struct list_head bridge_device_node;
+	struct list_head vlan_list;
+	unsigned int ref_count;
+	u8 stp_state;
+	unsigned long flags;
+};
+
+struct mvsw_pr_bridge_vlan {
+	struct list_head bridge_port_node;
+	struct list_head port_vlan_list;
+	u16 vid;
+};
+
+struct mvsw_pr_event_work {
+	struct work_struct work;
+	struct switchdev_notifier_fdb_info fdb_info;
+	struct net_device *dev;
+	unsigned long event;
+};
+
+static struct workqueue_struct *mvsw_owq;
+
+static struct mvsw_pr_bridge_port *
+mvsw_pr_bridge_port_get(struct mvsw_pr_bridge *bridge,
+			struct net_device *brport_dev);
+
+static void mvsw_pr_bridge_port_put(struct mvsw_pr_bridge *bridge,
+				    struct mvsw_pr_bridge_port *br_port);
+
+static struct mvsw_pr_bridge_device *
+mvsw_pr_bridge_device_find(const struct mvsw_pr_bridge *bridge,
+			   const struct net_device *br_dev)
+{
+	struct mvsw_pr_bridge_device *bridge_device;
+
+	list_for_each_entry(bridge_device, &bridge->bridge_list,
+			    bridge_node)
+		if (bridge_device->dev =3D=3D br_dev)
+			return bridge_device;
+
+	return NULL;
+}
+
+static bool
+mvsw_pr_bridge_device_is_offloaded(const struct mvsw_pr_switch *sw,
+				   const struct net_device *br_dev)
+{
+	return !!mvsw_pr_bridge_device_find(sw->bridge, br_dev);
+}
+
+static struct mvsw_pr_bridge_port *
+__mvsw_pr_bridge_port_find(const struct mvsw_pr_bridge_device *bridge_devi=
ce,
+			   const struct net_device *brport_dev)
+{
+	struct mvsw_pr_bridge_port *br_port;
+
+	list_for_each_entry(br_port, &bridge_device->port_list,
+			    bridge_device_node) {
+		if (br_port->dev =3D=3D brport_dev)
+			return br_port;
+	}
+
+	return NULL;
+}
+
+static struct mvsw_pr_bridge_port *
+mvsw_pr_bridge_port_find(struct mvsw_pr_bridge *bridge,
+			 struct net_device *brport_dev)
+{
+	struct net_device *br_dev =3D netdev_master_upper_dev_get(brport_dev);
+	struct mvsw_pr_bridge_device *bridge_device;
+
+	if (!br_dev)
+		return NULL;
+
+	bridge_device =3D mvsw_pr_bridge_device_find(bridge, br_dev);
+	if (!bridge_device)
+		return NULL;
+
+	return __mvsw_pr_bridge_port_find(bridge_device, brport_dev);
+}
+
+static struct mvsw_pr_bridge_vlan *
+mvsw_pr_bridge_vlan_find(const struct mvsw_pr_bridge_port *br_port, u16 vi=
d)
+{
+	struct mvsw_pr_bridge_vlan *br_vlan;
+
+	list_for_each_entry(br_vlan, &br_port->vlan_list, bridge_port_node) {
+		if (br_vlan->vid =3D=3D vid)
+			return br_vlan;
+	}
+
+	return NULL;
+}
+
+static struct mvsw_pr_bridge_vlan *
+mvsw_pr_bridge_vlan_create(struct mvsw_pr_bridge_port *br_port, u16 vid)
+{
+	struct mvsw_pr_bridge_vlan *br_vlan;
+
+	br_vlan =3D kzalloc(sizeof(*br_vlan), GFP_KERNEL);
+	if (!br_vlan)
+		return NULL;
+
+	INIT_LIST_HEAD(&br_vlan->port_vlan_list);
+	br_vlan->vid =3D vid;
+	list_add(&br_vlan->bridge_port_node, &br_port->vlan_list);
+
+	return br_vlan;
+}
+
+static void
+mvsw_pr_bridge_vlan_destroy(struct mvsw_pr_bridge_vlan *br_vlan)
+{
+	list_del(&br_vlan->bridge_port_node);
+	WARN_ON(!list_empty(&br_vlan->port_vlan_list));
+	kfree(br_vlan);
+}
+
+static struct mvsw_pr_bridge_vlan *
+mvsw_pr_bridge_vlan_get(struct mvsw_pr_bridge_port *br_port, u16 vid)
+{
+	struct mvsw_pr_bridge_vlan *br_vlan;
+
+	br_vlan =3D mvsw_pr_bridge_vlan_find(br_port, vid);
+	if (br_vlan)
+		return br_vlan;
+
+	return mvsw_pr_bridge_vlan_create(br_port, vid);
+}
+
+static void mvsw_pr_bridge_vlan_put(struct mvsw_pr_bridge_vlan *br_vlan)
+{
+	if (list_empty(&br_vlan->port_vlan_list))
+		mvsw_pr_bridge_vlan_destroy(br_vlan);
+}
+
+static int
+mvsw_pr_port_vlan_bridge_join(struct mvsw_pr_port_vlan *port_vlan,
+			      struct mvsw_pr_bridge_port *br_port,
+			      struct netlink_ext_ack *extack)
+{
+	struct mvsw_pr_port *port =3D port_vlan->mvsw_pr_port;
+	struct mvsw_pr_bridge_vlan *br_vlan;
+	u16 vid =3D port_vlan->vid;
+	int err;
+
+	if (port_vlan->bridge_port)
+		return 0;
+
+	err =3D mvsw_pr_port_flood_set(port, br_port->flags & BR_FLOOD);
+	if (err)
+		return err;
+
+	err =3D mvsw_pr_port_learning_set(port, br_port->flags & BR_LEARNING);
+	if (err)
+		goto err_port_learning_set;
+
+	br_vlan =3D mvsw_pr_bridge_vlan_get(br_port, vid);
+	if (!br_vlan) {
+		err =3D -ENOMEM;
+		goto err_bridge_vlan_get;
+	}
+
+	list_add(&port_vlan->bridge_vlan_node, &br_vlan->port_vlan_list);
+
+	mvsw_pr_bridge_port_get(port->sw->bridge, br_port->dev);
+	port_vlan->bridge_port =3D br_port;
+
+	return 0;
+
+err_bridge_vlan_get:
+	mvsw_pr_port_learning_set(port, false);
+err_port_learning_set:
+	return err;
+}
+
+static int
+mvsw_pr_bridge_vlan_port_count_get(struct mvsw_pr_bridge_device *bridge_de=
vice,
+				   u16 vid)
+{
+	int count =3D 0;
+	struct mvsw_pr_bridge_port *br_port;
+	struct mvsw_pr_bridge_vlan *br_vlan;
+
+	list_for_each_entry(br_port, &bridge_device->port_list,
+			    bridge_device_node) {
+		list_for_each_entry(br_vlan, &br_port->vlan_list,
+				    bridge_port_node) {
+			if (br_vlan->vid =3D=3D vid) {
+				count +=3D 1;
+				break;
+			}
+		}
+	}
+
+	return count;
+}
+
+void
+mvsw_pr_port_vlan_bridge_leave(struct mvsw_pr_port_vlan *port_vlan)
+{
+	struct mvsw_pr_port *port =3D port_vlan->mvsw_pr_port;
+	struct mvsw_pr_bridge_vlan *br_vlan;
+	struct mvsw_pr_bridge_port *br_port;
+	int port_count;
+	u16 vid =3D port_vlan->vid;
+	bool last_port, last_vlan;
+
+	br_port =3D port_vlan->bridge_port;
+	last_vlan =3D list_is_singular(&br_port->vlan_list);
+	port_count =3D
+	    mvsw_pr_bridge_vlan_port_count_get(br_port->bridge_device, vid);
+	br_vlan =3D mvsw_pr_bridge_vlan_find(br_port, vid);
+	last_port =3D port_count =3D=3D 1;
+	if (last_vlan) {
+		mvsw_pr_fdb_flush_port(port, MVSW_PR_FDB_FLUSH_MODE_DYNAMIC);
+	} else if (last_port) {
+		mvsw_pr_fdb_flush_vlan(port->sw, vid,
+				       MVSW_PR_FDB_FLUSH_MODE_DYNAMIC);
+	} else {
+		mvsw_pr_fdb_flush_port_vlan(port, vid,
+					    MVSW_PR_FDB_FLUSH_MODE_DYNAMIC);
+	}
+
+	list_del(&port_vlan->bridge_vlan_node);
+	mvsw_pr_bridge_vlan_put(br_vlan);
+	mvsw_pr_bridge_port_put(port->sw->bridge, br_port);
+	port_vlan->bridge_port =3D NULL;
+}
+
+static int
+mvsw_pr_bridge_port_vlan_add(struct mvsw_pr_port *port,
+			     struct mvsw_pr_bridge_port *br_port,
+			     u16 vid, bool is_untagged, bool is_pvid,
+			     struct netlink_ext_ack *extack)
+{
+	u16 pvid;
+	struct mvsw_pr_port_vlan *port_vlan;
+	u16 old_pvid =3D port->pvid;
+	int err;
+
+	if (is_pvid)
+		pvid =3D vid;
+	else
+		pvid =3D port->pvid =3D=3D vid ? 0 : port->pvid;
+
+	port_vlan =3D mvsw_pr_port_vlan_find_by_vid(port, vid);
+	if (port_vlan && port_vlan->bridge_port !=3D br_port)
+		return -EEXIST;
+
+	if (!port_vlan) {
+		port_vlan =3D mvsw_pr_port_vlan_create(port, vid);
+		if (IS_ERR(port_vlan))
+			return PTR_ERR(port_vlan);
+	}
+
+	err =3D mvsw_pr_port_vlan_set(port, vid, true, is_untagged);
+	if (err)
+		goto err_port_vlan_set;
+
+	err =3D mvsw_pr_port_pvid_set(port, pvid);
+	if (err)
+		goto err_port_pvid_set;
+
+	err =3D mvsw_pr_port_vlan_bridge_join(port_vlan, br_port, extack);
+	if (err)
+		goto err_port_vlan_bridge_join;
+
+	return 0;
+
+err_port_vlan_bridge_join:
+	mvsw_pr_port_pvid_set(port, old_pvid);
+err_port_pvid_set:
+	mvsw_pr_port_vlan_set(port, vid, false, false);
+err_port_vlan_set:
+	mvsw_pr_port_vlan_destroy(port_vlan);
+
+	return err;
+}
+
+static int mvsw_pr_port_vlans_add(struct mvsw_pr_port *port,
+				  const struct switchdev_obj_port_vlan *vlan,
+				  struct switchdev_trans *trans,
+				  struct netlink_ext_ack *extack)
+{
+	bool flag_untagged =3D vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool flag_pvid =3D vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	struct net_device *orig_dev =3D vlan->obj.orig_dev;
+	struct mvsw_pr_bridge_port *br_port;
+	struct mvsw_pr_switch *sw =3D port->sw;
+	u16 vid;
+
+	if (netif_is_bridge_master(orig_dev))
+		return 0;
+
+	if (switchdev_trans_ph_commit(trans))
+		return 0;
+
+	br_port =3D mvsw_pr_bridge_port_find(sw->bridge, orig_dev);
+	if (WARN_ON(!br_port))
+		return -EINVAL;
+
+	if (!br_port->bridge_device->vlan_enabled)
+		return 0;
+
+	for (vid =3D vlan->vid_begin; vid <=3D vlan->vid_end; vid++) {
+		int err;
+
+		err =3D mvsw_pr_bridge_port_vlan_add(port, br_port,
+						   vid, flag_untagged,
+						   flag_pvid, extack);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int mvsw_pr_port_obj_add(struct net_device *dev,
+				const struct switchdev_obj *obj,
+				struct switchdev_trans *trans,
+				struct netlink_ext_ack *extack)
+{
+	int err =3D 0;
+	struct mvsw_pr_port *port =3D netdev_priv(dev);
+	const struct switchdev_obj_port_vlan *vlan;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		vlan =3D SWITCHDEV_OBJ_PORT_VLAN(obj);
+		err =3D mvsw_pr_port_vlans_add(port, vlan, trans, extack);
+		break;
+	default:
+		err =3D -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+static void
+mvsw_pr_bridge_port_vlan_del(struct mvsw_pr_port *port,
+			     struct mvsw_pr_bridge_port *br_port, u16 vid)
+{
+	u16 pvid =3D port->pvid =3D=3D vid ? 0 : port->pvid;
+	struct mvsw_pr_port_vlan *port_vlan;
+
+	port_vlan =3D mvsw_pr_port_vlan_find_by_vid(port, vid);
+	if (WARN_ON(!port_vlan))
+		return;
+
+	mvsw_pr_port_vlan_bridge_leave(port_vlan);
+	mvsw_pr_port_pvid_set(port, pvid);
+	mvsw_pr_port_vlan_destroy(port_vlan);
+}
+
+static int mvsw_pr_port_vlans_del(struct mvsw_pr_port *port,
+				  const struct switchdev_obj_port_vlan *vlan)
+{
+	struct mvsw_pr_switch *sw =3D port->sw;
+	struct net_device *orig_dev =3D vlan->obj.orig_dev;
+	struct mvsw_pr_bridge_port *br_port;
+	u16 vid;
+
+	if (netif_is_bridge_master(orig_dev))
+		return -EOPNOTSUPP;
+
+	br_port =3D mvsw_pr_bridge_port_find(sw->bridge, orig_dev);
+	if (WARN_ON(!br_port))
+		return -EINVAL;
+
+	if (!br_port->bridge_device->vlan_enabled)
+		return 0;
+
+	for (vid =3D vlan->vid_begin; vid <=3D vlan->vid_end; vid++)
+		mvsw_pr_bridge_port_vlan_del(port, br_port, vid);
+
+	return 0;
+}
+
+static int mvsw_pr_port_obj_del(struct net_device *dev,
+				const struct switchdev_obj *obj)
+{
+	int err =3D 0;
+	struct mvsw_pr_port *port =3D netdev_priv(dev);
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err =3D mvsw_pr_port_vlans_del(port,
+					     SWITCHDEV_OBJ_PORT_VLAN(obj));
+		break;
+	default:
+		err =3D -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static int mvsw_pr_port_attr_br_vlan_set(struct mvsw_pr_port *port,
+					 struct switchdev_trans *trans,
+					 struct net_device *orig_dev,
+					 bool vlan_enabled)
+{
+	struct mvsw_pr_switch *sw =3D port->sw;
+	struct mvsw_pr_bridge_device *bridge_device;
+
+	if (!switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	bridge_device =3D mvsw_pr_bridge_device_find(sw->bridge, orig_dev);
+	if (WARN_ON(!bridge_device))
+		return -EINVAL;
+
+	if (bridge_device->vlan_enabled =3D=3D vlan_enabled)
+		return 0;
+
+	netdev_err(bridge_device->dev,
+		   "VLAN filtering can't be changed for existing bridge\n");
+	return -EINVAL;
+}
+
+static int mvsw_pr_port_attr_br_flags_set(struct mvsw_pr_port *port,
+					  struct switchdev_trans *trans,
+					  struct net_device *orig_dev,
+					  unsigned long flags)
+{
+	struct mvsw_pr_bridge_port *br_port;
+	int err;
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	br_port =3D mvsw_pr_bridge_port_find(port->sw->bridge, orig_dev);
+	if (!br_port)
+		return 0;
+
+	err =3D mvsw_pr_port_flood_set(port, flags & BR_FLOOD);
+	if (err)
+		return err;
+
+	err =3D mvsw_pr_port_learning_set(port, flags & BR_LEARNING);
+	if (err)
+		return err;
+
+	memcpy(&br_port->flags, &flags, sizeof(flags));
+	return 0;
+}
+
+static int mvsw_pr_port_attr_br_ageing_set(struct mvsw_pr_port *port,
+					   struct switchdev_trans *trans,
+					   unsigned long ageing_clock_t)
+{
+	int err;
+	struct mvsw_pr_switch *sw =3D port->sw;
+	unsigned long ageing_jiffies =3D clock_t_to_jiffies(ageing_clock_t);
+	u32 ageing_time =3D jiffies_to_msecs(ageing_jiffies) / 1000;
+
+	if (switchdev_trans_ph_prepare(trans)) {
+		if (ageing_time < MVSW_PR_MIN_AGEING_TIME ||
+		    ageing_time > MVSW_PR_MAX_AGEING_TIME)
+			return -ERANGE;
+		else
+			return 0;
+	}
+
+	err =3D mvsw_pr_switch_ageing_set(sw, ageing_time);
+	if (!err)
+		sw->bridge->ageing_time =3D ageing_time;
+
+	return err;
+}
+
+static int mvsw_pr_port_obj_attr_set(struct net_device *dev,
+				     const struct switchdev_attr *attr,
+				     struct switchdev_trans *trans)
+{
+	int err =3D 0;
+	struct mvsw_pr_port *port =3D netdev_priv(dev);
+
+	switch (attr->id) {
+	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
+		err =3D -EOPNOTSUPP;
+		break;
+	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
+		if (attr->u.brport_flags &
+		    ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
+			err =3D -EINVAL;
+		break;
+	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		err =3D mvsw_pr_port_attr_br_flags_set(port, trans,
+						     attr->orig_dev,
+						     attr->u.brport_flags);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
+		err =3D mvsw_pr_port_attr_br_ageing_set(port, trans,
+						      attr->u.ageing_time);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
+		err =3D mvsw_pr_port_attr_br_vlan_set(port, trans,
+						    attr->orig_dev,
+						    attr->u.vlan_filtering);
+		break;
+	default:
+		err =3D -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+static void mvsw_fdb_offload_notify(struct mvsw_pr_port *port,
+				    struct switchdev_notifier_fdb_info *info)
+{
+	struct switchdev_notifier_fdb_info send_info;
+
+	send_info.addr =3D info->addr;
+	send_info.vid =3D info->vid;
+	send_info.offloaded =3D true;
+	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
+				 port->net_dev, &send_info.info, NULL);
+}
+
+static int
+mvsw_pr_port_fdb_set(struct mvsw_pr_port *port,
+		     struct switchdev_notifier_fdb_info *fdb_info, bool adding)
+{
+	struct mvsw_pr_switch *sw =3D port->sw;
+	struct mvsw_pr_bridge_port *br_port;
+	struct mvsw_pr_bridge_device *bridge_device;
+	struct net_device *orig_dev =3D fdb_info->info.dev;
+	int err;
+	u16 vid;
+
+	br_port =3D mvsw_pr_bridge_port_find(sw->bridge, orig_dev);
+	if (!br_port)
+		return -EINVAL;
+
+	bridge_device =3D br_port->bridge_device;
+
+	if (bridge_device->vlan_enabled)
+		vid =3D fdb_info->vid;
+	else
+		vid =3D bridge_device->bridge_id;
+
+	if (adding)
+		err =3D mvsw_pr_fdb_add(port, fdb_info->addr, vid, false);
+	else
+		err =3D mvsw_pr_fdb_del(port, fdb_info->addr, vid);
+
+	return err;
+}
+
+static void mvsw_pr_bridge_fdb_event_work(struct work_struct *work)
+{
+	int err =3D 0;
+	struct mvsw_pr_event_work *switchdev_work =3D
+	    container_of(work, struct mvsw_pr_event_work, work);
+	struct net_device *dev =3D switchdev_work->dev;
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct mvsw_pr_port *port;
+
+	rtnl_lock();
+	if (netif_is_vxlan(dev))
+		goto out;
+
+	port =3D mvsw_pr_port_dev_lower_find(dev);
+	if (!port)
+		goto out;
+
+	switch (switchdev_work->event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		fdb_info =3D &switchdev_work->fdb_info;
+		if (!fdb_info->added_by_user)
+			break;
+		err =3D mvsw_pr_port_fdb_set(port, fdb_info, true);
+		if (err)
+			break;
+		mvsw_fdb_offload_notify(port, fdb_info);
+		break;
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		fdb_info =3D &switchdev_work->fdb_info;
+		mvsw_pr_port_fdb_set(port, fdb_info, false);
+		break;
+	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
+	case SWITCHDEV_FDB_DEL_TO_BRIDGE:
+		break;
+	}
+
+out:
+	rtnl_unlock();
+	kfree(switchdev_work->fdb_info.addr);
+	kfree(switchdev_work);
+	dev_put(dev);
+}
+
+static int mvsw_pr_switchdev_event(struct notifier_block *unused,
+				   unsigned long event, void *ptr)
+{
+	int err =3D 0;
+	struct net_device *net_dev =3D switchdev_notifier_info_to_dev(ptr);
+	struct mvsw_pr_event_work *switchdev_work;
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct switchdev_notifier_info *info =3D ptr;
+	struct net_device *upper_br;
+
+	if (event =3D=3D SWITCHDEV_PORT_ATTR_SET) {
+		err =3D switchdev_handle_port_attr_set(net_dev, ptr,
+						     mvsw_pr_netdev_check,
+						     mvsw_pr_port_obj_attr_set);
+		return notifier_from_errno(err);
+	}
+
+	upper_br =3D netdev_master_upper_dev_get_rcu(net_dev);
+	if (!upper_br)
+		return NOTIFY_DONE;
+
+	if (!netif_is_bridge_master(upper_br))
+		return NOTIFY_DONE;
+
+	switchdev_work =3D kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+	if (!switchdev_work)
+		return NOTIFY_BAD;
+
+	switchdev_work->dev =3D net_dev;
+	switchdev_work->event =3D event;
+
+	switch (event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
+	case SWITCHDEV_FDB_DEL_TO_BRIDGE:
+		fdb_info =3D container_of(info,
+					struct switchdev_notifier_fdb_info,
+					info);
+
+		INIT_WORK(&switchdev_work->work, mvsw_pr_bridge_fdb_event_work);
+		memcpy(&switchdev_work->fdb_info, ptr,
+		       sizeof(switchdev_work->fdb_info));
+		switchdev_work->fdb_info.addr =3D kzalloc(ETH_ALEN, GFP_ATOMIC);
+		if (!switchdev_work->fdb_info.addr)
+			goto out;
+		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
+				fdb_info->addr);
+		dev_hold(net_dev);
+
+		break;
+	case SWITCHDEV_VXLAN_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_VXLAN_FDB_DEL_TO_DEVICE:
+	default:
+		kfree(switchdev_work);
+		return NOTIFY_DONE;
+	}
+
+	queue_work(mvsw_owq, &switchdev_work->work);
+	return NOTIFY_DONE;
+out:
+	kfree(switchdev_work);
+	return NOTIFY_BAD;
+}
+
+static int mvsw_pr_switchdev_blocking_event(struct notifier_block *unused,
+					    unsigned long event, void *ptr)
+{
+	int err =3D 0;
+	struct net_device *net_dev =3D switchdev_notifier_info_to_dev(ptr);
+
+	switch (event) {
+	case SWITCHDEV_PORT_OBJ_ADD:
+		if (netif_is_vxlan(net_dev)) {
+			err =3D -EOPNOTSUPP;
+		} else {
+			err =3D switchdev_handle_port_obj_add
+			    (net_dev, ptr, mvsw_pr_netdev_check,
+			     mvsw_pr_port_obj_add);
+		}
+		break;
+	case SWITCHDEV_PORT_OBJ_DEL:
+		if (netif_is_vxlan(net_dev)) {
+			err =3D -EOPNOTSUPP;
+		} else {
+			err =3D switchdev_handle_port_obj_del
+			    (net_dev, ptr, mvsw_pr_netdev_check,
+			     mvsw_pr_port_obj_del);
+		}
+		break;
+	case SWITCHDEV_PORT_ATTR_SET:
+		err =3D switchdev_handle_port_attr_set
+		    (net_dev, ptr, mvsw_pr_netdev_check,
+		    mvsw_pr_port_obj_attr_set);
+		break;
+	default:
+		err =3D -EOPNOTSUPP;
+	}
+
+	return notifier_from_errno(err);
+}
+
+static struct mvsw_pr_bridge_device *
+mvsw_pr_bridge_device_create(struct mvsw_pr_bridge *bridge,
+			     struct net_device *br_dev)
+{
+	struct mvsw_pr_bridge_device *bridge_device;
+	bool vlan_enabled =3D br_vlan_enabled(br_dev);
+	u16 bridge_id;
+	int err;
+
+	if (vlan_enabled && bridge->bridge_8021q_exists) {
+		netdev_err(br_dev, "Only one VLAN-aware bridge is supported\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	bridge_device =3D kzalloc(sizeof(*bridge_device), GFP_KERNEL);
+	if (!bridge_device)
+		return ERR_PTR(-ENOMEM);
+
+	if (vlan_enabled) {
+		bridge->bridge_8021q_exists =3D true;
+	} else {
+		err =3D mvsw_pr_8021d_bridge_create(bridge->sw, &bridge_id);
+		if (err) {
+			kfree(bridge_device);
+			return ERR_PTR(err);
+		}
+
+		bridge_device->bridge_id =3D bridge_id;
+	}
+
+	bridge_device->dev =3D br_dev;
+	bridge_device->vlan_enabled =3D vlan_enabled;
+	bridge_device->multicast_enabled =3D br_multicast_enabled(br_dev);
+	bridge_device->mrouter =3D br_multicast_router(br_dev);
+	INIT_LIST_HEAD(&bridge_device->port_list);
+
+	list_add(&bridge_device->bridge_node, &bridge->bridge_list);
+
+	return bridge_device;
+}
+
+static void
+mvsw_pr_bridge_device_destroy(struct mvsw_pr_bridge *bridge,
+			      struct mvsw_pr_bridge_device *bridge_device)
+{
+	list_del(&bridge_device->bridge_node);
+	if (bridge_device->vlan_enabled)
+		bridge->bridge_8021q_exists =3D false;
+	else
+		mvsw_pr_8021d_bridge_delete(bridge->sw,
+					    bridge_device->bridge_id);
+
+	WARN_ON(!list_empty(&bridge_device->port_list));
+	kfree(bridge_device);
+}
+
+static struct mvsw_pr_bridge_device *
+mvsw_pr_bridge_device_get(struct mvsw_pr_bridge *bridge,
+			  struct net_device *br_dev)
+{
+	struct mvsw_pr_bridge_device *bridge_device;
+
+	bridge_device =3D mvsw_pr_bridge_device_find(bridge, br_dev);
+	if (bridge_device)
+		return bridge_device;
+
+	return mvsw_pr_bridge_device_create(bridge, br_dev);
+}
+
+static void
+mvsw_pr_bridge_device_put(struct mvsw_pr_bridge *bridge,
+			  struct mvsw_pr_bridge_device *bridge_device)
+{
+	if (list_empty(&bridge_device->port_list))
+		mvsw_pr_bridge_device_destroy(bridge, bridge_device);
+}
+
+static struct mvsw_pr_bridge_port *
+mvsw_pr_bridge_port_create(struct mvsw_pr_bridge_device *bridge_device,
+			   struct net_device *brport_dev)
+{
+	struct mvsw_pr_bridge_port *br_port;
+	struct mvsw_pr_port *port;
+
+	br_port =3D kzalloc(sizeof(*br_port), GFP_KERNEL);
+	if (!br_port)
+		return NULL;
+
+	port =3D mvsw_pr_port_dev_lower_find(brport_dev);
+
+	br_port->dev =3D brport_dev;
+	br_port->bridge_device =3D bridge_device;
+	br_port->stp_state =3D BR_STATE_DISABLED;
+	br_port->flags =3D BR_LEARNING | BR_FLOOD | BR_LEARNING_SYNC |
+				BR_MCAST_FLOOD;
+	INIT_LIST_HEAD(&br_port->vlan_list);
+	list_add(&br_port->bridge_device_node, &bridge_device->port_list);
+	br_port->ref_count =3D 1;
+
+	return br_port;
+}
+
+static void
+mvsw_pr_bridge_port_destroy(struct mvsw_pr_bridge_port *br_port)
+{
+	list_del(&br_port->bridge_device_node);
+	WARN_ON(!list_empty(&br_port->vlan_list));
+	kfree(br_port);
+}
+
+static struct mvsw_pr_bridge_port *
+mvsw_pr_bridge_port_get(struct mvsw_pr_bridge *bridge,
+			struct net_device *brport_dev)
+{
+	struct net_device *br_dev =3D netdev_master_upper_dev_get(brport_dev);
+	struct mvsw_pr_bridge_device *bridge_device;
+	struct mvsw_pr_bridge_port *br_port;
+	int err;
+
+	br_port =3D mvsw_pr_bridge_port_find(bridge, brport_dev);
+	if (br_port) {
+		br_port->ref_count++;
+		return br_port;
+	}
+
+	bridge_device =3D mvsw_pr_bridge_device_get(bridge, br_dev);
+	if (IS_ERR(bridge_device))
+		return ERR_CAST(bridge_device);
+
+	br_port =3D mvsw_pr_bridge_port_create(bridge_device, brport_dev);
+	if (!br_port) {
+		err =3D -ENOMEM;
+		goto err_brport_create;
+	}
+
+	return br_port;
+
+err_brport_create:
+	mvsw_pr_bridge_device_put(bridge, bridge_device);
+	return ERR_PTR(err);
+}
+
+static void mvsw_pr_bridge_port_put(struct mvsw_pr_bridge *bridge,
+				    struct mvsw_pr_bridge_port *br_port)
+{
+	struct mvsw_pr_bridge_device *bridge_device;
+
+	if (--br_port->ref_count !=3D 0)
+		return;
+	bridge_device =3D br_port->bridge_device;
+	mvsw_pr_bridge_port_destroy(br_port);
+	mvsw_pr_bridge_device_put(bridge, bridge_device);
+}
+
+static int
+mvsw_pr_bridge_8021q_port_join(struct mvsw_pr_bridge_device *bridge_device=
,
+			       struct mvsw_pr_bridge_port *br_port,
+			       struct mvsw_pr_port *port,
+			       struct netlink_ext_ack *extack)
+{
+	if (is_vlan_dev(br_port->dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can not enslave a VLAN device to a VLAN-aware bridge");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+mvsw_pr_bridge_8021d_port_join(struct mvsw_pr_bridge_device *bridge_device=
,
+			       struct mvsw_pr_bridge_port *br_port,
+			       struct mvsw_pr_port *port,
+			       struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (is_vlan_dev(br_port->dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Enslaving of a VLAN device is not supported");
+		return -ENOTSUPP;
+	}
+	err =3D mvsw_pr_8021d_bridge_port_add(port, bridge_device->bridge_id);
+	if (err)
+		return err;
+
+	err =3D mvsw_pr_port_flood_set(port, br_port->flags & BR_FLOOD);
+	if (err)
+		goto err_port_flood_set;
+
+	err =3D mvsw_pr_port_learning_set(port, br_port->flags & BR_LEARNING);
+	if (err)
+		goto err_port_learning_set;
+
+	return err;
+
+err_port_learning_set:
+	mvsw_pr_port_flood_set(port, false);
+err_port_flood_set:
+	mvsw_pr_8021d_bridge_port_delete(port, bridge_device->bridge_id);
+	return err;
+}
+
+static int mvsw_pr_port_bridge_join(struct mvsw_pr_port *port,
+				    struct net_device *brport_dev,
+				    struct net_device *br_dev,
+				    struct netlink_ext_ack *extack)
+{
+	struct mvsw_pr_bridge_device *bridge_device;
+	struct mvsw_pr_switch *sw =3D port->sw;
+	struct mvsw_pr_bridge_port *br_port;
+	int err;
+
+	br_port =3D mvsw_pr_bridge_port_get(sw->bridge, brport_dev);
+	if (IS_ERR(br_port))
+		return PTR_ERR(br_port);
+
+	bridge_device =3D br_port->bridge_device;
+
+	if (bridge_device->vlan_enabled) {
+		err =3D mvsw_pr_bridge_8021q_port_join(bridge_device, br_port,
+						     port, extack);
+	} else {
+		err =3D mvsw_pr_bridge_8021d_port_join(bridge_device, br_port,
+						     port, extack);
+	}
+
+	if (err)
+		goto err_port_join;
+
+	return 0;
+
+err_port_join:
+	mvsw_pr_bridge_port_put(sw->bridge, br_port);
+	return err;
+}
+
+static void
+mvsw_pr_bridge_8021d_port_leave(struct mvsw_pr_bridge_device *bridge_devic=
e,
+				struct mvsw_pr_bridge_port *br_port,
+				struct mvsw_pr_port *port)
+{
+	mvsw_pr_fdb_flush_port(port, MVSW_PR_FDB_FLUSH_MODE_ALL);
+	mvsw_pr_8021d_bridge_port_delete(port, bridge_device->bridge_id);
+}
+
+static void
+mvsw_pr_bridge_8021q_port_leave(struct mvsw_pr_bridge_device *bridge_devic=
e,
+				struct mvsw_pr_bridge_port *br_port,
+				struct mvsw_pr_port *port)
+{
+	mvsw_pr_fdb_flush_port(port, MVSW_PR_FDB_FLUSH_MODE_ALL);
+	mvsw_pr_port_pvid_set(port, MVSW_PR_DEFAULT_VID);
+}
+
+static void mvsw_pr_port_bridge_leave(struct mvsw_pr_port *port,
+				      struct net_device *brport_dev,
+				      struct net_device *br_dev)
+{
+	struct mvsw_pr_switch *sw =3D port->sw;
+	struct mvsw_pr_bridge_device *bridge_device;
+	struct mvsw_pr_bridge_port *br_port;
+
+	bridge_device =3D mvsw_pr_bridge_device_find(sw->bridge, br_dev);
+	if (!bridge_device)
+		return;
+	br_port =3D __mvsw_pr_bridge_port_find(bridge_device, brport_dev);
+	if (!br_port)
+		return;
+
+	if (bridge_device->vlan_enabled)
+		mvsw_pr_bridge_8021q_port_leave(bridge_device, br_port, port);
+	else
+		mvsw_pr_bridge_8021d_port_leave(bridge_device, br_port, port);
+
+	mvsw_pr_port_learning_set(port, false);
+	mvsw_pr_port_flood_set(port, false);
+	mvsw_pr_bridge_port_put(sw->bridge, br_port);
+}
+
+static int mvsw_pr_netdevice_port_upper_event(struct net_device *lower_dev=
,
+					      struct net_device *dev,
+					      unsigned long event, void *ptr)
+{
+	struct netdev_notifier_changeupper_info *info;
+	struct mvsw_pr_port *port;
+	struct netlink_ext_ack *extack;
+	struct net_device *upper_dev;
+	struct mvsw_pr_switch *sw;
+	int err =3D 0;
+
+	port =3D netdev_priv(dev);
+	sw =3D port->sw;
+	info =3D ptr;
+	extack =3D netdev_notifier_info_to_extack(&info->info);
+
+	switch (event) {
+	case NETDEV_PRECHANGEUPPER:
+		upper_dev =3D info->upper_dev;
+		if (!netif_is_bridge_master(upper_dev)) {
+			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
+			return -EINVAL;
+		}
+		if (!info->linking)
+			break;
+		if (netdev_has_any_upper_dev(upper_dev) &&
+		    (!netif_is_bridge_master(upper_dev) ||
+		     !mvsw_pr_bridge_device_is_offloaded(sw, upper_dev))) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Enslaving a port to a device that already has an upper device is =
not supported");
+			return -EINVAL;
+		}
+		break;
+	case NETDEV_CHANGEUPPER:
+		upper_dev =3D info->upper_dev;
+		if (netif_is_bridge_master(upper_dev)) {
+			if (info->linking)
+				err =3D mvsw_pr_port_bridge_join(port,
+							       lower_dev,
+							       upper_dev,
+							       extack);
+			else
+				mvsw_pr_port_bridge_leave(port,
+							  lower_dev,
+							  upper_dev);
+		}
+		break;
+	}
+
+	return err;
+}
+
+static int mvsw_pr_netdevice_port_event(struct net_device *lower_dev,
+					struct net_device *port_dev,
+					unsigned long event, void *ptr)
+{
+	switch (event) {
+	case NETDEV_PRECHANGEUPPER:
+	case NETDEV_CHANGEUPPER:
+		return mvsw_pr_netdevice_port_upper_event(lower_dev, port_dev,
+							  event, ptr);
+	}
+
+	return 0;
+}
+
+static int mvsw_pr_netdevice_event(struct notifier_block *nb,
+				   unsigned long event, void *ptr)
+{
+	struct net_device *dev =3D netdev_notifier_info_to_dev(ptr);
+	struct mvsw_pr_switch *sw;
+	int err =3D 0;
+
+	sw =3D container_of(nb, struct mvsw_pr_switch, netdevice_nb);
+
+	if (mvsw_pr_netdev_check(dev))
+		err =3D mvsw_pr_netdevice_port_event(dev, dev, event, ptr);
+
+	return notifier_from_errno(err);
+}
+
+static int mvsw_pr_fdb_init(struct mvsw_pr_switch *sw)
+{
+	int err;
+
+	err =3D mvsw_pr_switch_ageing_set(sw, MVSW_PR_DEFAULT_AGEING_TIME);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int mvsw_pr_switchdev_init(struct mvsw_pr_switch *sw)
+{
+	int err =3D 0;
+	struct mvsw_pr_switchdev *swdev;
+	struct mvsw_pr_bridge *bridge;
+
+	if (sw->switchdev)
+		return -EPERM;
+
+	bridge =3D kzalloc(sizeof(*sw->bridge), GFP_KERNEL);
+	if (!bridge)
+		return -ENOMEM;
+
+	swdev =3D kzalloc(sizeof(*sw->switchdev), GFP_KERNEL);
+	if (!swdev) {
+		kfree(bridge);
+		return -ENOMEM;
+	}
+
+	sw->bridge =3D bridge;
+	bridge->sw =3D sw;
+	sw->switchdev =3D swdev;
+	swdev->sw =3D sw;
+
+	INIT_LIST_HEAD(&sw->bridge->bridge_list);
+
+	mvsw_owq =3D alloc_ordered_workqueue("%s_ordered", 0, "prestera_sw");
+	if (!mvsw_owq) {
+		err =3D -ENOMEM;
+		goto err_alloc_workqueue;
+	}
+
+	swdev->swdev_n.notifier_call =3D mvsw_pr_switchdev_event;
+	err =3D register_switchdev_notifier(&swdev->swdev_n);
+	if (err)
+		goto err_register_switchdev_notifier;
+
+	swdev->swdev_blocking_n.notifier_call =3D
+			mvsw_pr_switchdev_blocking_event;
+	err =3D register_switchdev_blocking_notifier(&swdev->swdev_blocking_n);
+	if (err)
+		goto err_register_block_switchdev_notifier;
+
+	mvsw_pr_fdb_init(sw);
+
+	return 0;
+
+err_register_block_switchdev_notifier:
+	unregister_switchdev_notifier(&swdev->swdev_n);
+err_register_switchdev_notifier:
+	destroy_workqueue(mvsw_owq);
+err_alloc_workqueue:
+	kfree(swdev);
+	kfree(bridge);
+	return err;
+}
+
+static void mvsw_pr_switchdev_fini(struct mvsw_pr_switch *sw)
+{
+	if (!sw->switchdev)
+		return;
+
+	unregister_switchdev_notifier(&sw->switchdev->swdev_n);
+	unregister_switchdev_blocking_notifier
+	    (&sw->switchdev->swdev_blocking_n);
+	flush_workqueue(mvsw_owq);
+	destroy_workqueue(mvsw_owq);
+	kfree(sw->switchdev);
+	sw->switchdev =3D NULL;
+	kfree(sw->bridge);
+}
+
+static int mvsw_pr_netdev_init(struct mvsw_pr_switch *sw)
+{
+	int err =3D 0;
+
+	if (sw->netdevice_nb.notifier_call)
+		return -EPERM;
+
+	sw->netdevice_nb.notifier_call =3D mvsw_pr_netdevice_event;
+	err =3D register_netdevice_notifier(&sw->netdevice_nb);
+	return err;
+}
+
+static void mvsw_pr_netdev_fini(struct mvsw_pr_switch *sw)
+{
+	if (sw->netdevice_nb.notifier_call)
+		unregister_netdevice_notifier(&sw->netdevice_nb);
+}
+
+int mvsw_pr_switchdev_register(struct mvsw_pr_switch *sw)
+{
+	int err;
+
+	err =3D mvsw_pr_switchdev_init(sw);
+	if (err)
+		return err;
+
+	err =3D mvsw_pr_netdev_init(sw);
+	if (err)
+		goto err_netdevice_notifier;
+
+	return 0;
+
+err_netdevice_notifier:
+	mvsw_pr_switchdev_fini(sw);
+	return err;
+}
+
+void mvsw_pr_switchdev_unregister(struct mvsw_pr_switch *sw)
+{
+	mvsw_pr_netdev_fini(sw);
+	mvsw_pr_switchdev_fini(sw);
+}
--=20
2.17.1

