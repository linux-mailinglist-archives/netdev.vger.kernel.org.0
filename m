Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74F11E659C
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 17:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404223AbgE1PNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 11:13:46 -0400
Received: from mail-vi1eur05on2129.outbound.protection.outlook.com ([40.107.21.129]:54914
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403787AbgE1PNl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 11:13:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQ2pN69vOnbbhByZP5FWenK+Ifzpkx2opHk7FJKRlsenfaiLgV87xrBWn+P421yGNx9ZKoe3HTuXWuV2aALwX4wUvrCdgFjZY0ZqKlz0YHPCSpG/3iJpLc4zuor1e6DmhHXH7DC2BAt+dJmJVDs3X/JN9NuGOqNyD2a971giBQPH+MtskPBkwerPtsd6Zqa5Uru2nh2HBpSXtfWwAb4AmUOxBBSi5FgctAxVTfGKbTNF0qvYEt91uyUHINxWAR49lEP2YQWv/mZWquseqxmZmBvmhrcVnSaoHwS2ItadhUAk7Xw5ln2vy9RlDiJmlBQF0NG6b2LcURh7bc4+vK1skg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFxKxPCGHHh624tdoZPKQRfQF+nbs+tDEJSCw/ZfpN4=;
 b=aqiU+o0uShwgK1awB4izN/Qz0q/KAy4v4Fr36u4B91ni52hiK9eChRLa3xt4HqMUShm7U+KcpbPY0GhlLJ7yL72epX+4Mpqw5LkUYzCUXIFDKUzwbpvNBu9xQ6e3MYFLfSsEgKoKBiItZPcazeQMphexuXpC4gdq8AXfJO9n+wTyFkLagMW7/hB5SIzuimP7m1VAsK3pi53WBLR7xSZZrjmW2bE6LPVT4Vqv/BXp3rJ7izsTffG1aQkbVA1VgR+I04gtFCt75lsaI8logpfIckkpeXzaz8Yz+Dgv/dKSR2fUFrNEeFiqHrcckeSu+J/jjJphiZOnv8WaylIu+NBQKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFxKxPCGHHh624tdoZPKQRfQF+nbs+tDEJSCw/ZfpN4=;
 b=S6H9wzUcAYnmWwZCEySNaVGTWWf6EWIr1nVa2iQWpUr1kUnhR3XiMZGM6nD1UzAEbjU2H/BV7MyJYNYNajukt70nxPXgSCQoBskWXmY6z/CrcL6gfGTtKweFa8IyPylEOoDaunaI+j13eoTxe7RJNJ5KFfHbNW9xy1JXOUAcmMI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0224.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:a4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Thu, 28 May
 2020 15:13:11 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 15:13:11 +0000
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
Subject: [net-next 4/6] net: marvell: prestera: Add ethtool interface support
Date:   Thu, 28 May 2020 18:12:43 +0300
Message-Id: <20200528151245.7592-5-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528151245.7592-1-vadym.kochan@plvision.eu>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P191CA0094.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::35) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P191CA0094.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Thu, 28 May 2020 15:13:09 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d60abaee-92f6-4335-13a7-08d80319a2a0
X-MS-TrafficTypeDiagnostic: VI1P190MB0224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB0224FBCD9F62E909E78BD9B8958E0@VI1P190MB0224.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: owNCkjY7wSVbPEwuL4ct4NSf55zIDglVP0RG8NRWXYq3FukUdQLnulSVrYzXof9AgB+ccMfRUMY/O06916Ld++M/uhdlj8nnbBjNPeojHBjk/MkbQNj1vE+uf26YgYwMmI8ISFjk4r+77qt6eDdFwwKMUudQR1sRTA9l68bMJMoSVV3X6hP8q5fi7s3TmmEqZa0Jm1IAOwpvsmrd/IyzoUPh5Q8Va9qCyUjEftaWIGg0JJD7+5xUK0lbO3VaBbOKo+uBQLOwWEnmTUxZIASaKhVnhcD8JbNBoBXjKapLZk1iT5Le58A7AqxlUuUDpM8OmU/tyl+Z2WvmhGLIqtHzRB5HOLTKnRmkVNsJDMr1OFbwh63akoE55xXGHt8dKmoH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39830400003)(376002)(366004)(346002)(396003)(66476007)(316002)(66556008)(107886003)(5660300002)(6512007)(2616005)(508600001)(186003)(956004)(4326008)(1076003)(2906002)(16526019)(52116002)(26005)(6486002)(44832011)(54906003)(30864003)(6506007)(66946007)(8936002)(8676002)(110136005)(86362001)(83380400001)(36756003)(6666004)(921003)(579004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 1R4dZeHVcRnegyTU8LIgEBrPGekcus0FjuPQHOBlVbHkQM1AVa+FrIyLJVDWE48T9cI6BlrhbQ1QeDOaeHJyVu/rC6cLjl73UksCtK81NkRVM0bvvnr/eG0eeWiuzeSV2COwIs45UcDor4UNIAr8bjZ4Y03I5t+qeimuJdrhYt+nkkrbV1c8F7i5rDsIO8R8XYZEOBlEmNdPhEcvQi93P6+UibzBjscKULzSO6CL+UXynj8yJlJeQKjQ5fwxidhuGKtmlt+yfu2vqXmFUAmV3GW/9z2RWZQ8HYCW+z8WpVvNPIKAFvPLogJITN82+NrMWpgyq1PzPwmzocUxBhfEXXACPn/lwvK2p4/ASWZ0VcqojrQ8xDHYygdtvW+SBCTBuzpGzeX2omFrx5qgpK7RSOgPUxBcgjUOdCh9pF+fO9vDMnVaBqvlqp/05meSXaKrGjDzXIP8xA+GzNBaXKMdvj+9Cb8/qNNc+siaBhzq6aU=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: d60abaee-92f6-4335-13a7-08d80319a2a0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 15:13:11.3758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KAmtXl2ZdpLOcMOzJ32qZL4VCSk5J4sOE76aqN11Dwc8Z3DzhA53ccA9VScvXwiM/MmdiU/ISsL1uMw4ikRwdf5NJHWc68Tem8Bxb5SpwjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0224
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ethtool API provides support for the configuration of the following
features: speed and duplex, auto-negotiation, MDI-x, forward error
correction, port media type. The API also provides information about the
port status, hardware and software statistic. The following limitation
exists:

    - port media type should be configured before speed setting
    - ethtool -m option is not supported
    - ethtool -p option is not supported
    - ethtool -r option is supported for RJ45 port only
    - the following combination of parameters is not supported:

          ethtool -s sw1pX port XX autoneg on

    - forward error correction feature is supported only on SFP ports, 10G
      speed

    - auto-negotiation and MDI-x features are not supported on
      Copper-to-Fiber SFP module

Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 .../net/ethernet/marvell/prestera/Makefile    |   2 +-
 .../net/ethernet/marvell/prestera/prestera.h  |   3 +
 .../marvell/prestera/prestera_ethtool.c       | 737 ++++++++++++++++++
 .../marvell/prestera/prestera_ethtool.h       |  37 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 293 +++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  65 +-
 .../ethernet/marvell/prestera/prestera_main.c |  42 +-
 7 files changed, 1171 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_ethtool.h

diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
index babd71fba809..7684e7047562 100644
--- a/drivers/net/ethernet/marvell/prestera/Makefile
+++ b/drivers/net/ethernet/marvell/prestera/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_PRESTERA)	+= prestera.o
 prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
-			   prestera_rxtx.o prestera_devlink.o
+			   prestera_rxtx.o prestera_devlink.o prestera_ethtool.o
 
 obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index f8abaaff5f21..ee834e824521 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -173,4 +173,7 @@ void prestera_device_unregister(struct prestera_device *dev);
 struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
 						 u32 dev_id, u32 hw_id);
 
+int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
+			      u64 adver_link_modes, u8 adver_fec);
+
 #endif /* _PRESTERA_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
new file mode 100644
index 000000000000..c99d91f2bf62
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
@@ -0,0 +1,737 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
+
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/ethtool.h>
+
+#include "prestera.h"
+#include "prestera_hw.h"
+#include "prestera_ethtool.h"
+
+#define PRESTERA_STATS_CNT \
+	(sizeof(struct prestera_port_stats) / sizeof(u64))
+#define PRESTERA_STATS_IDX(name) \
+	(offsetof(struct prestera_port_stats, name) / sizeof(u64))
+#define PRESTERA_STATS_FIELD(name)	\
+	[PRESTERA_STATS_IDX(name)] = __stringify(name)
+
+static const char driver_kind[] = "prestera";
+
+static const struct prestera_link_mode {
+	enum ethtool_link_mode_bit_indices eth_mode;
+	u32 speed;
+	u64 pr_mask;
+	u8 duplex;
+	u8 port_type;
+} port_link_modes[PRESTERA_LINK_MODE_MAX] = {
+	[PRESTERA_LINK_MODE_10baseT_Half] = {
+		.eth_mode =  ETHTOOL_LINK_MODE_10baseT_Half_BIT,
+		.speed = 10,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_10baseT_Half,
+		.duplex = PRESTERA_PORT_DUPLEX_HALF,
+		.port_type = PRESTERA_PORT_TYPE_TP,
+	},
+	[PRESTERA_LINK_MODE_10baseT_Full] = {
+		.eth_mode =  ETHTOOL_LINK_MODE_10baseT_Full_BIT,
+		.speed = 10,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_10baseT_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_TP,
+	},
+	[PRESTERA_LINK_MODE_100baseT_Half] = {
+		.eth_mode =  ETHTOOL_LINK_MODE_100baseT_Half_BIT,
+		.speed = 100,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_100baseT_Half,
+		.duplex = PRESTERA_PORT_DUPLEX_HALF,
+		.port_type = PRESTERA_PORT_TYPE_TP,
+	},
+	[PRESTERA_LINK_MODE_100baseT_Full] = {
+		.eth_mode =  ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+		.speed = 100,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_100baseT_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_TP,
+	},
+	[PRESTERA_LINK_MODE_1000baseT_Half] = {
+		.eth_mode =  ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
+		.speed = 1000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_1000baseT_Half,
+		.duplex = PRESTERA_PORT_DUPLEX_HALF,
+		.port_type = PRESTERA_PORT_TYPE_TP,
+	},
+	[PRESTERA_LINK_MODE_1000baseT_Full] = {
+		.eth_mode =  ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+		.speed = 1000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_1000baseT_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_TP,
+	},
+	[PRESTERA_LINK_MODE_1000baseX_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+		.speed = 1000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_1000baseX_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_FIBRE,
+	},
+	[PRESTERA_LINK_MODE_1000baseKX_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+		.speed = 1000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_1000baseKX_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_TP,
+	},
+	[PRESTERA_LINK_MODE_2500baseX_Full] = {
+		.eth_mode =  ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
+		.speed = 2500,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_2500baseX_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+	},
+	[PRESTERA_LINK_MODE_10GbaseKR_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+		.speed = 10000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_10GbaseKR_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_TP,
+	},
+	[PRESTERA_LINK_MODE_10GbaseSR_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
+		.speed = 10000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_10GbaseSR_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_FIBRE,
+	},
+	[PRESTERA_LINK_MODE_10GbaseLR_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
+		.speed = 10000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_10GbaseLR_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_FIBRE,
+	},
+	[PRESTERA_LINK_MODE_20GbaseKR2_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_20000baseKR2_Full_BIT,
+		.speed = 20000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_20GbaseKR2_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_TP,
+	},
+	[PRESTERA_LINK_MODE_25GbaseCR_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+		.speed = 25000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_25GbaseCR_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_DA,
+	},
+	[PRESTERA_LINK_MODE_25GbaseKR_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+		.speed = 25000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_25GbaseKR_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_TP,
+	},
+	[PRESTERA_LINK_MODE_25GbaseSR_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
+		.speed = 25000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_25GbaseSR_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_FIBRE,
+	},
+	[PRESTERA_LINK_MODE_40GbaseKR4_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+		.speed = 40000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_40GbaseKR4_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_TP,
+	},
+	[PRESTERA_LINK_MODE_40GbaseCR4_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
+		.speed = 40000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_40GbaseCR4_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_DA,
+	},
+	[PRESTERA_LINK_MODE_40GbaseSR4_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
+		.speed = 40000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_40GbaseSR4_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_FIBRE,
+	},
+	[PRESTERA_LINK_MODE_50GbaseCR2_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_50000baseCR2_Full_BIT,
+		.speed = 50000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_50GbaseCR2_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_DA,
+	},
+	[PRESTERA_LINK_MODE_50GbaseKR2_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_50000baseKR2_Full_BIT,
+		.speed = 50000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_50GbaseKR2_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_TP,
+	},
+	[PRESTERA_LINK_MODE_50GbaseSR2_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_50000baseSR2_Full_BIT,
+		.speed = 50000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_50GbaseSR2_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_FIBRE,
+	},
+	[PRESTERA_LINK_MODE_100GbaseKR4_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+		.speed = 100000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_100GbaseKR4_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_TP,
+	},
+	[PRESTERA_LINK_MODE_100GbaseSR4_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
+		.speed = 100000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_100GbaseSR4_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_FIBRE,
+	},
+	[PRESTERA_LINK_MODE_100GbaseCR4_Full] = {
+		.eth_mode = ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+		.speed = 100000,
+		.pr_mask = 1 << PRESTERA_LINK_MODE_100GbaseCR4_Full,
+		.duplex = PRESTERA_PORT_DUPLEX_FULL,
+		.port_type = PRESTERA_PORT_TYPE_DA,
+	}
+};
+
+static const struct prestera_fec {
+	u32 eth_fec;
+	enum ethtool_link_mode_bit_indices eth_mode;
+	u8 pr_fec;
+} port_fec_caps[PRESTERA_PORT_FEC_MAX] = {
+	[PRESTERA_PORT_FEC_OFF] = {
+		.eth_fec = ETHTOOL_FEC_OFF,
+		.eth_mode = ETHTOOL_LINK_MODE_FEC_NONE_BIT,
+		.pr_fec = 1 << PRESTERA_PORT_FEC_OFF,
+	},
+	[PRESTERA_PORT_FEC_BASER] = {
+		.eth_fec = ETHTOOL_FEC_BASER,
+		.eth_mode = ETHTOOL_LINK_MODE_FEC_BASER_BIT,
+		.pr_fec = 1 << PRESTERA_PORT_FEC_BASER,
+	},
+	[PRESTERA_PORT_FEC_RS] = {
+		.eth_fec = ETHTOOL_FEC_RS,
+		.eth_mode = ETHTOOL_LINK_MODE_FEC_RS_BIT,
+		.pr_fec = 1 << PRESTERA_PORT_FEC_RS,
+	}
+};
+
+static const struct prestera_port_type {
+	enum ethtool_link_mode_bit_indices eth_mode;
+	u8 eth_type;
+} port_types[PRESTERA_PORT_TYPE_MAX] = {
+	[PRESTERA_PORT_TYPE_NONE] = {
+		.eth_mode = __ETHTOOL_LINK_MODE_MASK_NBITS,
+		.eth_type = PORT_NONE,
+	},
+	[PRESTERA_PORT_TYPE_TP] = {
+		.eth_mode = ETHTOOL_LINK_MODE_TP_BIT,
+		.eth_type = PORT_TP,
+	},
+	[PRESTERA_PORT_TYPE_AUI] = {
+		.eth_mode = ETHTOOL_LINK_MODE_AUI_BIT,
+		.eth_type = PORT_AUI,
+	},
+	[PRESTERA_PORT_TYPE_MII] = {
+		.eth_mode = ETHTOOL_LINK_MODE_MII_BIT,
+		.eth_type = PORT_MII,
+	},
+	[PRESTERA_PORT_TYPE_FIBRE] = {
+		.eth_mode = ETHTOOL_LINK_MODE_FIBRE_BIT,
+		.eth_type = PORT_FIBRE,
+	},
+	[PRESTERA_PORT_TYPE_BNC] = {
+		.eth_mode = ETHTOOL_LINK_MODE_BNC_BIT,
+		.eth_type = PORT_BNC,
+	},
+	[PRESTERA_PORT_TYPE_DA] = {
+		.eth_mode = ETHTOOL_LINK_MODE_TP_BIT,
+		.eth_type = PORT_TP,
+	},
+	[PRESTERA_PORT_TYPE_OTHER] = {
+		.eth_mode = __ETHTOOL_LINK_MODE_MASK_NBITS,
+		.eth_type = PORT_OTHER,
+	}
+};
+
+static const char prestera_cnt_name[PRESTERA_STATS_CNT][ETH_GSTRING_LEN] = {
+	PRESTERA_STATS_FIELD(good_octets_received),
+	PRESTERA_STATS_FIELD(bad_octets_received),
+	PRESTERA_STATS_FIELD(mac_trans_error),
+	PRESTERA_STATS_FIELD(broadcast_frames_received),
+	PRESTERA_STATS_FIELD(multicast_frames_received),
+	PRESTERA_STATS_FIELD(frames_64_octets),
+	PRESTERA_STATS_FIELD(frames_65_to_127_octets),
+	PRESTERA_STATS_FIELD(frames_128_to_255_octets),
+	PRESTERA_STATS_FIELD(frames_256_to_511_octets),
+	PRESTERA_STATS_FIELD(frames_512_to_1023_octets),
+	PRESTERA_STATS_FIELD(frames_1024_to_max_octets),
+	PRESTERA_STATS_FIELD(excessive_collision),
+	PRESTERA_STATS_FIELD(multicast_frames_sent),
+	PRESTERA_STATS_FIELD(broadcast_frames_sent),
+	PRESTERA_STATS_FIELD(fc_sent),
+	PRESTERA_STATS_FIELD(fc_received),
+	PRESTERA_STATS_FIELD(buffer_overrun),
+	PRESTERA_STATS_FIELD(undersize),
+	PRESTERA_STATS_FIELD(fragments),
+	PRESTERA_STATS_FIELD(oversize),
+	PRESTERA_STATS_FIELD(jabber),
+	PRESTERA_STATS_FIELD(rx_error_frame_received),
+	PRESTERA_STATS_FIELD(bad_crc),
+	PRESTERA_STATS_FIELD(collisions),
+	PRESTERA_STATS_FIELD(late_collision),
+	PRESTERA_STATS_FIELD(unicast_frames_received),
+	PRESTERA_STATS_FIELD(unicast_frames_sent),
+	PRESTERA_STATS_FIELD(sent_multiple),
+	PRESTERA_STATS_FIELD(sent_deferred),
+	PRESTERA_STATS_FIELD(good_octets_sent),
+};
+
+void prestera_ethtool_get_drvinfo(struct net_device *dev,
+				  struct ethtool_drvinfo *drvinfo)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	struct prestera_switch *sw = port->sw;
+
+	strlcpy(drvinfo->driver, driver_kind, sizeof(drvinfo->driver));
+	strlcpy(drvinfo->bus_info, dev_name(prestera_dev(sw)),
+		sizeof(drvinfo->bus_info));
+	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
+		 "%d.%d.%d",
+		 sw->dev->fw_rev.maj,
+		 sw->dev->fw_rev.min,
+		 sw->dev->fw_rev.sub);
+}
+
+static u8 prestera_port_type_get(struct prestera_port *port)
+{
+	if (port->caps.type < PRESTERA_PORT_TYPE_MAX)
+		return port_types[port->caps.type].eth_type;
+	return PORT_OTHER;
+}
+
+static int prestera_port_type_set(const struct ethtool_link_ksettings *ecmd,
+				  struct prestera_port *port)
+{
+	u32 new_mode = PRESTERA_LINK_MODE_MAX;
+	u32 type, mode;
+	int err;
+
+	for (type = 0; type < PRESTERA_PORT_TYPE_MAX; type++) {
+		if (port_types[type].eth_type == ecmd->base.port &&
+		    test_bit(port_types[type].eth_mode,
+			     ecmd->link_modes.supported)) {
+			break;
+		}
+	}
+
+	if (type == port->caps.type)
+		return 0;
+	if (type != port->caps.type && ecmd->base.autoneg == AUTONEG_ENABLE)
+		return -EINVAL;
+	if (type == PRESTERA_PORT_TYPE_MAX)
+		return -EOPNOTSUPP;
+
+	for (mode = 0; mode < PRESTERA_LINK_MODE_MAX; mode++) {
+		if ((port_link_modes[mode].pr_mask &
+		    port->caps.supp_link_modes) &&
+		    type == port_link_modes[mode].port_type) {
+			new_mode = mode;
+		}
+	}
+
+	if (new_mode < PRESTERA_LINK_MODE_MAX)
+		err = prestera_hw_port_link_mode_set(port, new_mode);
+	else
+		err = -EINVAL;
+
+	if (!err) {
+		port->caps.type = type;
+		port->autoneg = false;
+	}
+
+	return err;
+}
+
+static void prestera_modes_to_eth(unsigned long *eth_modes, u64 link_modes,
+				  u8 fec, u8 type)
+{
+	u32 mode;
+
+	for (mode = 0; mode < PRESTERA_LINK_MODE_MAX; mode++) {
+		if ((port_link_modes[mode].pr_mask & link_modes) == 0)
+			continue;
+		if (type != PRESTERA_PORT_TYPE_NONE &&
+		    port_link_modes[mode].port_type != type)
+			continue;
+		__set_bit(port_link_modes[mode].eth_mode, eth_modes);
+	}
+
+	for (mode = 0; mode < PRESTERA_PORT_FEC_MAX; mode++) {
+		if ((port_fec_caps[mode].pr_fec & fec) == 0)
+			continue;
+		__set_bit(port_fec_caps[mode].eth_mode, eth_modes);
+	}
+}
+
+static void prestera_modes_from_eth(const unsigned long *eth_modes,
+				    u64 *link_modes, u8 *fec, u8 type)
+{
+	u32 mode;
+
+	for (mode = 0; mode < PRESTERA_LINK_MODE_MAX; mode++) {
+		if (!test_bit(port_link_modes[mode].eth_mode, eth_modes))
+			continue;
+		if (port_link_modes[mode].port_type != type)
+			continue;
+		*link_modes |= port_link_modes[mode].pr_mask;
+	}
+
+	for (mode = 0; mode < PRESTERA_PORT_FEC_MAX; mode++) {
+		if (!test_bit(port_fec_caps[mode].eth_mode, eth_modes))
+			continue;
+		*fec |= port_fec_caps[mode].pr_fec;
+	}
+}
+
+static void prestera_port_supp_types_get(struct ethtool_link_ksettings *ecmd,
+					 struct prestera_port *port)
+{
+	u32 mode;
+	u8 ptype;
+
+	for (mode = 0; mode < PRESTERA_LINK_MODE_MAX; mode++) {
+		if ((port_link_modes[mode].pr_mask &
+		    port->caps.supp_link_modes) == 0)
+			continue;
+		ptype = port_link_modes[mode].port_type;
+		__set_bit(port_types[ptype].eth_mode,
+			  ecmd->link_modes.supported);
+	}
+}
+
+static void prestera_port_remote_cap_get(struct ethtool_link_ksettings *ecmd,
+					 struct prestera_port *port)
+{
+	bool asym_pause;
+	bool pause;
+	u64 bitmap;
+
+	if (!prestera_hw_port_remote_cap_get(port, &bitmap)) {
+		prestera_modes_to_eth(ecmd->link_modes.lp_advertising,
+				      bitmap, 0, PRESTERA_PORT_TYPE_NONE);
+
+		if (!bitmap_empty(ecmd->link_modes.lp_advertising,
+				  __ETHTOOL_LINK_MODE_MASK_NBITS)) {
+			ethtool_link_ksettings_add_link_mode(ecmd,
+							     lp_advertising,
+							     Autoneg);
+		}
+	}
+
+	if (prestera_hw_port_remote_fc_get(port, &pause, &asym_pause))
+		return;
+	if (pause)
+		ethtool_link_ksettings_add_link_mode(ecmd,
+						     lp_advertising,
+						     Pause);
+	if (asym_pause)
+		ethtool_link_ksettings_add_link_mode(ecmd,
+						     lp_advertising,
+						     Asym_Pause);
+}
+
+static void prestera_port_speed_get(struct ethtool_link_ksettings *ecmd,
+				    struct prestera_port *port)
+{
+	u32 speed;
+	int err;
+
+	err = prestera_hw_port_speed_get(port, &speed);
+	ecmd->base.speed = !err ? speed : SPEED_UNKNOWN;
+}
+
+static void prestera_port_duplex_get(struct ethtool_link_ksettings *ecmd,
+				     struct prestera_port *port)
+{
+	u8 duplex;
+
+	if (!prestera_hw_port_duplex_get(port, &duplex)) {
+		ecmd->base.duplex = duplex == PRESTERA_PORT_DUPLEX_FULL ?
+				    DUPLEX_FULL : DUPLEX_HALF;
+	} else {
+		ecmd->base.duplex = DUPLEX_UNKNOWN;
+	}
+}
+
+int prestera_ethtool_get_link_ksettings(struct net_device *dev,
+					struct ethtool_link_ksettings *ecmd)
+{
+	struct prestera_port *port = netdev_priv(dev);
+
+	ethtool_link_ksettings_zero_link_mode(ecmd, supported);
+	ethtool_link_ksettings_zero_link_mode(ecmd, advertising);
+	ethtool_link_ksettings_zero_link_mode(ecmd, lp_advertising);
+
+	ecmd->base.autoneg = port->autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
+
+	if (port->caps.type == PRESTERA_PORT_TYPE_TP) {
+		ethtool_link_ksettings_add_link_mode(ecmd, supported, Autoneg);
+
+		if (netif_running(dev) &&
+		    (port->autoneg ||
+		     port->caps.transceiver == PRESTERA_PORT_TCVR_COPPER))
+			ethtool_link_ksettings_add_link_mode(ecmd, advertising,
+							     Autoneg);
+	}
+
+	prestera_modes_to_eth(ecmd->link_modes.supported,
+			      port->caps.supp_link_modes,
+			      port->caps.supp_fec,
+			      port->caps.type);
+
+	prestera_port_supp_types_get(ecmd, port);
+
+	if (netif_carrier_ok(dev)) {
+		prestera_port_speed_get(ecmd, port);
+		prestera_port_duplex_get(ecmd, port);
+	} else {
+		ecmd->base.speed = SPEED_UNKNOWN;
+		ecmd->base.duplex = DUPLEX_UNKNOWN;
+	}
+
+	ecmd->base.port = prestera_port_type_get(port);
+
+	if (port->autoneg) {
+		if (netif_running(dev))
+			prestera_modes_to_eth(ecmd->link_modes.advertising,
+					      port->adver_link_modes,
+					      port->adver_fec,
+					      port->caps.type);
+
+		if (netif_carrier_ok(dev) &&
+		    port->caps.transceiver == PRESTERA_PORT_TCVR_COPPER)
+			prestera_port_remote_cap_get(ecmd, port);
+	}
+
+	if (port->caps.type == PRESTERA_PORT_TYPE_TP &&
+	    port->caps.transceiver == PRESTERA_PORT_TCVR_COPPER)
+		prestera_hw_port_mdix_get(port, &ecmd->base.eth_tp_mdix,
+					  &ecmd->base.eth_tp_mdix_ctrl);
+
+	return 0;
+}
+
+static int prestera_port_mdix_set(const struct ethtool_link_ksettings *ecmd,
+				  struct prestera_port *port)
+{
+	if (ecmd->base.eth_tp_mdix_ctrl != ETH_TP_MDI_INVALID &&
+	    port->caps.transceiver == PRESTERA_PORT_TCVR_COPPER &&
+	    port->caps.type == PRESTERA_PORT_TYPE_TP)
+		return prestera_hw_port_mdix_set(port,
+						 ecmd->base.eth_tp_mdix_ctrl);
+
+	return 0;
+}
+
+static int prestera_port_link_mode_set(struct prestera_port *port,
+				       u32 speed, u8 duplex, u8 type)
+{
+	u32 new_mode = PRESTERA_LINK_MODE_MAX;
+	u32 mode;
+
+	for (mode = 0; mode < PRESTERA_LINK_MODE_MAX; mode++) {
+		if (speed != port_link_modes[mode].speed)
+			continue;
+		if (duplex != port_link_modes[mode].duplex)
+			continue;
+		if (!(port_link_modes[mode].pr_mask &
+		    port->caps.supp_link_modes))
+			continue;
+		if (type != port_link_modes[mode].port_type)
+			continue;
+
+		new_mode = mode;
+		break;
+	}
+
+	if (new_mode == PRESTERA_LINK_MODE_MAX)
+		return -EOPNOTSUPP;
+
+	return prestera_hw_port_link_mode_set(port, new_mode);
+}
+
+static int
+prestera_port_speed_duplex_set(const struct ethtool_link_ksettings *ecmd,
+			       struct prestera_port *port)
+{
+	u32 curr_mode;
+	u8 duplex;
+	u32 speed;
+	int err;
+
+	err = prestera_hw_port_link_mode_get(port, &curr_mode);
+	if (err || curr_mode >= PRESTERA_LINK_MODE_MAX)
+		return -EINVAL;
+
+	if (ecmd->base.duplex != DUPLEX_UNKNOWN)
+		duplex = ecmd->base.duplex == DUPLEX_FULL ?
+			 PRESTERA_PORT_DUPLEX_FULL : PRESTERA_PORT_DUPLEX_HALF;
+	else
+		duplex = port_link_modes[curr_mode].duplex;
+
+	if (ecmd->base.speed != SPEED_UNKNOWN)
+		speed = ecmd->base.speed;
+	else
+		speed = port_link_modes[curr_mode].speed;
+
+	return prestera_port_link_mode_set(port, speed, duplex,
+					   port->caps.type);
+}
+
+int prestera_ethtool_set_link_ksettings(struct net_device *dev,
+					const struct ethtool_link_ksettings *ecmd)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	u64 adver_modes = 0;
+	u8 adver_fec = 0;
+	int err;
+
+	err = prestera_port_type_set(ecmd, port);
+	if (err)
+		return err;
+
+	if (port->caps.transceiver == PRESTERA_PORT_TCVR_COPPER) {
+		err = prestera_port_mdix_set(ecmd, port);
+		if (err)
+			return err;
+	}
+
+	prestera_modes_from_eth(ecmd->link_modes.advertising, &adver_modes,
+				&adver_fec, port->caps.type);
+
+	err = prestera_port_autoneg_set(port,
+					ecmd->base.autoneg == AUTONEG_ENABLE,
+					adver_modes, adver_fec);
+	if (err)
+		return err;
+
+	if (ecmd->base.autoneg == AUTONEG_DISABLE) {
+		err = prestera_port_speed_duplex_set(ecmd, port);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+int prestera_ethtool_get_fecparam(struct net_device *dev,
+				  struct ethtool_fecparam *fecparam)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	u32 mode;
+	u8 active;
+	int err;
+
+	err = prestera_hw_port_fec_get(port, &active);
+	if (err)
+		return err;
+
+	fecparam->fec = 0;
+	for (mode = 0; mode < PRESTERA_PORT_FEC_MAX; mode++) {
+		if ((port_fec_caps[mode].pr_fec & port->caps.supp_fec) == 0)
+			continue;
+		fecparam->fec |= port_fec_caps[mode].eth_fec;
+	}
+
+	if (active < PRESTERA_PORT_FEC_MAX)
+		fecparam->active_fec = port_fec_caps[active].eth_fec;
+	else
+		fecparam->active_fec = ETHTOOL_FEC_AUTO;
+
+	return 0;
+}
+
+int prestera_ethtool_set_fecparam(struct net_device *dev,
+				  struct ethtool_fecparam *fecparam)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	u8 fec, active;
+	u32 mode;
+	int err;
+
+	if (port->autoneg) {
+		netdev_err(dev, "FEC set is not allowed while autoneg is on\n");
+		return -EINVAL;
+	}
+
+	err = prestera_hw_port_fec_get(port, &active);
+	if (err)
+		return err;
+
+	fec = PRESTERA_PORT_FEC_MAX;
+	for (mode = 0; mode < PRESTERA_PORT_FEC_MAX; mode++) {
+		if ((port_fec_caps[mode].eth_fec & fecparam->fec) &&
+		    (port_fec_caps[mode].pr_fec & port->caps.supp_fec)) {
+			fec = mode;
+			break;
+		}
+	}
+
+	if (fec == active)
+		return 0;
+
+	if (fec == PRESTERA_PORT_FEC_MAX)
+		return -EOPNOTSUPP;
+
+	return prestera_hw_port_fec_set(port, fec);
+}
+
+int prestera_ethtool_get_sset_count(struct net_device *dev, int sset)
+{
+	switch (sset) {
+	case ETH_SS_STATS:
+		return PRESTERA_STATS_CNT;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+void prestera_ethtool_get_strings(struct net_device *dev,
+				  u32 stringset, u8 *data)
+{
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	memcpy(data, *prestera_cnt_name, sizeof(prestera_cnt_name));
+}
+
+void prestera_ethtool_get_stats(struct net_device *dev,
+				struct ethtool_stats *stats, u64 *data)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	struct prestera_port_stats *port_stats;
+
+	port_stats = &port->cached_hw_stats.stats;
+
+	memcpy((u8 *)data, port_stats, sizeof(*port_stats));
+}
+
+int prestera_ethtool_nway_reset(struct net_device *dev)
+{
+	struct prestera_port *port = netdev_priv(dev);
+
+	if (netif_running(dev) &&
+	    port->caps.transceiver == PRESTERA_PORT_TCVR_COPPER &&
+	    port->caps.type == PRESTERA_PORT_TYPE_TP)
+		return prestera_hw_port_autoneg_restart(port);
+
+	return -EINVAL;
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
new file mode 100644
index 000000000000..e6a51e9020a4
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+ *
+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
+ *
+ */
+#ifndef __PRESTERA_ETHTOOL_H_
+#define __PRESTERA_ETHTOOL_H_
+
+#include <linux/netdevice.h>
+#include <linux/ethtool.h>
+
+void prestera_ethtool_get_drvinfo(struct net_device *dev,
+				  struct ethtool_drvinfo *drvinfo);
+
+int prestera_ethtool_get_link_ksettings(struct net_device *dev,
+					struct ethtool_link_ksettings *ecmd);
+
+int prestera_ethtool_set_link_ksettings(struct net_device *dev,
+					const struct ethtool_link_ksettings *ecmd);
+
+int prestera_ethtool_get_fecparam(struct net_device *dev,
+				  struct ethtool_fecparam *fecparam);
+
+int prestera_ethtool_set_fecparam(struct net_device *dev,
+				  struct ethtool_fecparam *fecparam);
+
+int prestera_ethtool_get_sset_count(struct net_device *dev, int sset);
+
+void prestera_ethtool_get_strings(struct net_device *dev, u32 stringset,
+				  u8 *data);
+
+void prestera_ethtool_get_stats(struct net_device *dev,
+				struct ethtool_stats *stats, u64 *data);
+
+int prestera_ethtool_nway_reset(struct net_device *dev);
+
+#endif /* _PRESTERA_ETHTOOL_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 3aa3974f957a..ba87279e16e1 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -31,9 +31,18 @@ enum {
 	PRESTERA_CMD_PORT_ATTR_ADMIN_STATE = 1,
 	PRESTERA_CMD_PORT_ATTR_MTU = 3,
 	PRESTERA_CMD_PORT_ATTR_MAC = 4,
+	PRESTERA_CMD_PORT_ATTR_SPEED = 5,
 	PRESTERA_CMD_PORT_ATTR_CAPABILITY = 9,
+	PRESTERA_CMD_PORT_ATTR_REMOTE_CAPABILITY = 10,
+	PRESTERA_CMD_PORT_ATTR_REMOTE_FC = 11,
+	PRESTERA_CMD_PORT_ATTR_LINK_MODE = 12,
+	PRESTERA_CMD_PORT_ATTR_TYPE = 13,
+	PRESTERA_CMD_PORT_ATTR_FEC = 14,
 	PRESTERA_CMD_PORT_ATTR_AUTONEG = 15,
+	PRESTERA_CMD_PORT_ATTR_DUPLEX = 16,
 	PRESTERA_CMD_PORT_ATTR_STATS = 17,
+	PRESTERA_CMD_PORT_ATTR_MDIX = 18,
+	PRESTERA_CMD_PORT_ATTR_AUTONEG_RESTART = 19,
 };
 
 enum {
@@ -47,6 +56,13 @@ enum {
 	PRESTERA_CMD_ACK_MAX
 };
 
+enum {
+	PRESTERA_PORT_TP_NA,
+	PRESTERA_PORT_TP_MDI,
+	PRESTERA_PORT_TP_MDIX,
+	PRESTERA_PORT_TP_AUTO
+};
+
 enum {
 	PRESTERA_PORT_GOOD_OCTETS_RCV_CNT,
 	PRESTERA_PORT_BAD_OCTETS_RCV_CNT,
@@ -82,6 +98,13 @@ enum {
 	PRESTERA_PORT_CNT_MAX,
 };
 
+enum {
+	PRESTERA_FC_NONE,
+	PRESTERA_FC_SYMMETRIC,
+	PRESTERA_FC_ASYMMETRIC,
+	PRESTERA_FC_SYMM_ASYMM,
+};
+
 struct prestera_fw_event_handler {
 	struct list_head list;
 	enum prestera_event_type type;
@@ -136,11 +159,23 @@ struct prestera_msg_port_cap_param {
 	u8  transceiver;
 };
 
+struct prestera_msg_port_mdix_param {
+	u8 status;
+	u8 admin_mode;
+};
+
 union prestera_msg_port_param {
 	u8  admin_state;
 	u8  oper_state;
 	u32 mtu;
 	u8  mac[ETH_ALEN];
+	u32 speed;
+	u32 link_mode;
+	u8  type;
+	u8  duplex;
+	u8  fec;
+	u8  fc;
+	struct prestera_msg_port_mdix_param mdix;
 	struct prestera_msg_port_autoneg_param autoneg;
 	struct prestera_msg_port_cap_param cap;
 };
@@ -472,6 +507,232 @@ int prestera_hw_port_cap_get(const struct prestera_port *port,
 	return err;
 }
 
+int prestera_hw_port_remote_cap_get(const struct prestera_port *port,
+				    u64 *link_mode_bitmap)
+{
+	struct prestera_msg_port_attr_resp resp;
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_REMOTE_CAPABILITY,
+		.port = port->hw_id,
+		.dev = port->dev_id
+	};
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*link_mode_bitmap = resp.param.cap.link_mode;
+
+	return err;
+}
+
+int prestera_hw_port_remote_fc_get(const struct prestera_port *port,
+				   bool *pause, bool *asym_pause)
+{
+	struct prestera_msg_port_attr_resp resp;
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_REMOTE_FC,
+		.port = port->hw_id,
+		.dev = port->dev_id
+	};
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	switch (resp.param.fc) {
+	case PRESTERA_FC_SYMMETRIC:
+		*pause = true;
+		*asym_pause = false;
+		break;
+	case PRESTERA_FC_ASYMMETRIC:
+		*pause = false;
+		*asym_pause = true;
+		break;
+	case PRESTERA_FC_SYMM_ASYMM:
+		*pause = true;
+		*asym_pause = true;
+		break;
+	default:
+		*pause = false;
+		*asym_pause = false;
+	};
+
+	return err;
+}
+
+int prestera_hw_port_type_get(const struct prestera_port *port, u8 *type)
+{
+	struct prestera_msg_port_attr_resp resp;
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_TYPE,
+		.port = port->hw_id,
+		.dev = port->dev_id
+	};
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*type = resp.param.type;
+
+	return err;
+}
+
+int prestera_hw_port_fec_get(const struct prestera_port *port, u8 *fec)
+{
+	struct prestera_msg_port_attr_resp resp;
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_FEC,
+		.port = port->hw_id,
+		.dev = port->dev_id
+	};
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*fec = resp.param.fec;
+
+	return err;
+}
+
+int prestera_hw_port_fec_set(const struct prestera_port *port, u8 fec)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_FEC,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {.fec = fec}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+static u8 prestera_hw_mdix_to_eth(u8 mode)
+{
+	switch (mode) {
+	case PRESTERA_PORT_TP_MDI:
+		return ETH_TP_MDI;
+	case PRESTERA_PORT_TP_MDIX:
+		return ETH_TP_MDI_X;
+	case PRESTERA_PORT_TP_AUTO:
+		return ETH_TP_MDI_AUTO;
+	}
+
+	return ETH_TP_MDI_INVALID;
+}
+
+static u8 prestera_hw_mdix_from_eth(u8 mode)
+{
+	switch (mode) {
+	case ETH_TP_MDI:
+		return PRESTERA_PORT_TP_MDI;
+	case ETH_TP_MDI_X:
+		return PRESTERA_PORT_TP_MDIX;
+	case ETH_TP_MDI_AUTO:
+		return PRESTERA_PORT_TP_AUTO;
+	}
+
+	return PRESTERA_PORT_TP_NA;
+}
+
+int prestera_hw_port_mdix_get(const struct prestera_port *port, u8 *status,
+			      u8 *admin_mode)
+{
+	struct prestera_msg_port_attr_resp resp;
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_MDIX,
+		.port = port->hw_id,
+		.dev = port->dev_id
+	};
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*status = prestera_hw_mdix_to_eth(resp.param.mdix.status);
+	*admin_mode = prestera_hw_mdix_to_eth(resp.param.mdix.admin_mode);
+
+	return 0;
+}
+
+int prestera_hw_port_mdix_set(const struct prestera_port *port, u8 mode)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_MDIX,
+		.port = port->hw_id,
+		.dev = port->dev_id
+	};
+
+	req.param.mdix.admin_mode = prestera_hw_mdix_from_eth(mode);
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_port_link_mode_set(const struct prestera_port *port, u32 mode)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_LINK_MODE,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {.link_mode = mode}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_port_link_mode_get(const struct prestera_port *port, u32 *mode)
+{
+	struct prestera_msg_port_attr_resp resp;
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_LINK_MODE,
+		.port = port->hw_id,
+		.dev = port->dev_id
+	};
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+
+	*mode = resp.param.link_mode;
+
+	return err;
+}
+
+int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed)
+{
+	struct prestera_msg_port_attr_resp resp;
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_SPEED,
+		.port = port->hw_id,
+		.dev = port->dev_id
+	};
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*speed = resp.param.speed;
+
+	return err;
+}
+
 int prestera_hw_port_autoneg_set(const struct prestera_port *port,
 				 bool autoneg, u64 link_modes, u8 fec)
 {
@@ -489,6 +750,38 @@ int prestera_hw_port_autoneg_set(const struct prestera_port *port,
 			    &req.cmd, sizeof(req));
 }
 
+int prestera_hw_port_autoneg_restart(struct prestera_port *port)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_AUTONEG_RESTART,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_port_duplex_get(const struct prestera_port *port, u8 *duplex)
+{
+	struct prestera_msg_port_attr_resp resp;
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_DUPLEX,
+		.port = port->hw_id,
+		.dev = port->dev_id
+	};
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*duplex = resp.param.duplex;
+
+	return err;
+}
+
 int prestera_hw_port_stats_get(const struct prestera_port *port,
 			       struct prestera_port_stats *st)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index acb0e31d6684..af2141834bbf 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -9,19 +9,65 @@
 
 #include <linux/types.h>
 
+enum {
+	PRESTERA_LINK_MODE_10baseT_Half,
+	PRESTERA_LINK_MODE_10baseT_Full,
+	PRESTERA_LINK_MODE_100baseT_Half,
+	PRESTERA_LINK_MODE_100baseT_Full,
+	PRESTERA_LINK_MODE_1000baseT_Half,
+	PRESTERA_LINK_MODE_1000baseT_Full,
+	PRESTERA_LINK_MODE_1000baseX_Full,
+	PRESTERA_LINK_MODE_1000baseKX_Full,
+	PRESTERA_LINK_MODE_2500baseX_Full,
+	PRESTERA_LINK_MODE_10GbaseKR_Full,
+	PRESTERA_LINK_MODE_10GbaseSR_Full,
+	PRESTERA_LINK_MODE_10GbaseLR_Full,
+	PRESTERA_LINK_MODE_20GbaseKR2_Full,
+	PRESTERA_LINK_MODE_25GbaseCR_Full,
+	PRESTERA_LINK_MODE_25GbaseKR_Full,
+	PRESTERA_LINK_MODE_25GbaseSR_Full,
+	PRESTERA_LINK_MODE_40GbaseKR4_Full,
+	PRESTERA_LINK_MODE_40GbaseCR4_Full,
+	PRESTERA_LINK_MODE_40GbaseSR4_Full,
+	PRESTERA_LINK_MODE_50GbaseCR2_Full,
+	PRESTERA_LINK_MODE_50GbaseKR2_Full,
+	PRESTERA_LINK_MODE_50GbaseSR2_Full,
+	PRESTERA_LINK_MODE_100GbaseKR4_Full,
+	PRESTERA_LINK_MODE_100GbaseSR4_Full,
+	PRESTERA_LINK_MODE_100GbaseCR4_Full,
+	PRESTERA_LINK_MODE_MAX,
+};
+
 enum {
 	PRESTERA_PORT_TYPE_NONE,
 	PRESTERA_PORT_TYPE_TP,
-
+	PRESTERA_PORT_TYPE_AUI,
+	PRESTERA_PORT_TYPE_MII,
+	PRESTERA_PORT_TYPE_FIBRE,
+	PRESTERA_PORT_TYPE_BNC,
+	PRESTERA_PORT_TYPE_DA,
+	PRESTERA_PORT_TYPE_OTHER,
 	PRESTERA_PORT_TYPE_MAX,
 };
 
 enum {
-	PRESTERA_PORT_FEC_OFF,
+	PRESTERA_PORT_TCVR_COPPER,
+	PRESTERA_PORT_TCVR_SFP,
+	PRESTERA_PORT_TCVR_MAX,
+};
 
+enum {
+	PRESTERA_PORT_FEC_OFF,
+	PRESTERA_PORT_FEC_BASER,
+	PRESTERA_PORT_FEC_RS,
 	PRESTERA_PORT_FEC_MAX,
 };
 
+enum {
+	PRESTERA_PORT_DUPLEX_HALF,
+	PRESTERA_PORT_DUPLEX_FULL
+};
+
 struct prestera_switch;
 struct prestera_port;
 struct prestera_port_stats;
@@ -49,10 +95,25 @@ int prestera_hw_port_mac_set(const struct prestera_port *port, char *mac);
 int prestera_hw_port_mac_get(const struct prestera_port *port, char *mac);
 int prestera_hw_port_cap_get(const struct prestera_port *port,
 			     struct prestera_port_caps *caps);
+int prestera_hw_port_remote_cap_get(const struct prestera_port *port,
+				    u64 *link_mode_bitmap);
+int prestera_hw_port_remote_fc_get(const struct prestera_port *port,
+				   bool *pause, bool *asym_pause);
+int prestera_hw_port_type_get(const struct prestera_port *port, u8 *type);
+int prestera_hw_port_fec_get(const struct prestera_port *port, u8 *fec);
+int prestera_hw_port_fec_set(const struct prestera_port *port, u8 fec);
 int prestera_hw_port_autoneg_set(const struct prestera_port *port,
 				 bool autoneg, u64 link_modes, u8 fec);
+int prestera_hw_port_autoneg_restart(struct prestera_port *port);
+int prestera_hw_port_duplex_get(const struct prestera_port *port, u8 *duplex);
 int prestera_hw_port_stats_get(const struct prestera_port *port,
 			       struct prestera_port_stats *stats);
+int prestera_hw_port_link_mode_set(const struct prestera_port *port, u32 mode);
+int prestera_hw_port_link_mode_get(const struct prestera_port *port, u32 *mode);
+int prestera_hw_port_mdix_get(const struct prestera_port *port, u8 *status,
+			      u8 *admin_mode);
+int prestera_hw_port_mdix_set(const struct prestera_port *port, u8 mode);
+int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed);
 
 /* Event handlers */
 int prestera_hw_event_handler_register(struct prestera_switch *sw,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index ddab9422fe5e..e536f87724fd 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
+#include <linux/ethtool.h>
 #include <linux/netdev_features.h>
 #include <linux/etherdevice.h>
 #include <linux/jiffies.h>
@@ -15,6 +16,7 @@
 #include "prestera_hw.h"
 #include "prestera_rxtx.h"
 #include "prestera_devlink.h"
+#include "prestera_ethtool.h"
 
 #define PRESTERA_MTU_DEFAULT 1536
 
@@ -189,22 +191,38 @@ static const struct net_device_ops netdev_ops = {
 	.ndo_get_devlink_port = prestera_devlink_get_port,
 };
 
-static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
-				     u64 link_modes, u8 fec)
+int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
+			      u64 adver_link_modes, u8 adver_fec)
 {
 	bool refresh = false;
+	u64 link_modes;
 	int err = 0;
+	u8 fec;
 
 	if (port->caps.type != PRESTERA_PORT_TYPE_TP)
 		return enable ? -EINVAL : 0;
 
-	if (port->adver_link_modes != link_modes || port->adver_fec != fec) {
-		port->adver_fec = fec ?: BIT(PRESTERA_PORT_FEC_OFF);
+	if (!enable)
+		goto set_autoneg;
+
+	link_modes = port->caps.supp_link_modes & adver_link_modes;
+	fec = port->caps.supp_fec & adver_fec;
+
+	if (!link_modes && !fec)
+		return -EOPNOTSUPP;
+
+	if (link_modes && port->adver_link_modes != link_modes) {
 		port->adver_link_modes = link_modes;
 		refresh = true;
 	}
 
-	if (port->autoneg == enable && !(port->autoneg && refresh))
+	if (fec && port->adver_fec != fec) {
+		port->adver_fec = fec;
+		refresh = true;
+	}
+
+set_autoneg:
+	if (port->autoneg == enable && !refresh)
 		return 0;
 
 	err = prestera_hw_port_autoneg_set(port, enable, port->adver_link_modes,
@@ -216,6 +234,19 @@ static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
 	return 0;
 }
 
+static const struct ethtool_ops ethtool_ops = {
+	.get_drvinfo = prestera_ethtool_get_drvinfo,
+	.get_link_ksettings = prestera_ethtool_get_link_ksettings,
+	.set_link_ksettings = prestera_ethtool_set_link_ksettings,
+	.get_fecparam = prestera_ethtool_get_fecparam,
+	.set_fecparam = prestera_ethtool_set_fecparam,
+	.get_sset_count = prestera_ethtool_get_sset_count,
+	.get_strings = prestera_ethtool_get_strings,
+	.get_ethtool_stats = prestera_ethtool_get_stats,
+	.get_link = ethtool_op_get_link,
+	.nway_reset = prestera_ethtool_nway_reset
+};
+
 static int prestera_port_create(struct prestera_switch *sw, u32 id)
 {
 	struct prestera_port *port;
@@ -245,6 +276,7 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 
 	dev->features |= NETIF_F_NETNS_LOCAL;
 	dev->netdev_ops = &netdev_ops;
+	dev->ethtool_ops = &ethtool_ops;
 
 	netif_carrier_off(dev);
 
-- 
2.17.1

