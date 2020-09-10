Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40621264FD9
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgIJTxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:53:20 -0400
Received: from mail-eopbgr40101.outbound.protection.outlook.com ([40.107.4.101]:14570
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731158AbgIJPEA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 11:04:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwN/fioxUXFo9uYJAX2Y7kSQ/j/Y7AEevKnxlG0Gg7n3B5C4IK44+DEcoNsU1/6tPbwHudaS1LMm613wkfZxqCC6VldCnjIfyZR0RbHK32lFU8+CuL0XXM51uA3ylSrFCsQ1AEsfSafOl0Xu9FInZz7FWJ52h9BnvNRO5NoKVhadH6czjMlYc+axJnW0h1r8RqohofjLN7IPWrPFWZ5hKPdke7hRzIQFXDs4iS2pP2gk3sY0tJWbmpmoKdwZdQm4krH5COOHK5BoweDVFKuUozrYj5FTeYiVY/E1lUf4mz8vN0M6E+FRyT/9Goc+1AsRXfZIuytVUxoxTBNqSdM7WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrlIG/IR76bzXaQC/3BjSBdsixh41LiKBmzIeIv4gmI=;
 b=LYs8OO0dd0YjRgzzP3w/O6F0YDqUvEh2icpI7CxLa5Vvm4U59qDiwNZ8/7CzduokF2Q3UXe2FAOfRmFM5vemlswseIixXWX0JN4RFWu7a/2IbtsXPHqhJ7xBoYdodBKY7qS6WGLnY2xVC1jQRK9SK7iWgpjA9Tcume8zFMtRRBbWrBv8/zPXUYgpU8YrnZTfMD5cN5s7Vd0IqwfqIQp8eNXqPH0Be1nyWh/CJzSGbCBR8JTHNO6kirxrn4pmG38/d/luvfviO+pYLgkqWaZ7xB83ZTdmzNN3D1+1Wn3Zh0AJfP5M7RHUla3CFhKKZYZKpjOGEH1wBCBSxiWSlCeY5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrlIG/IR76bzXaQC/3BjSBdsixh41LiKBmzIeIv4gmI=;
 b=vdMY1xM8qZ/JFavDYCXW5KOJCgNmenXW2O4GRIL+MKxepEjydosWWuIJ0nXtm2F9Dk0mdux2aeN3h7BKyfe9kK6MZhBnYmYEeidRtAjLR5jy0LInuhsfL6wSx3Sc4WlVtmtMyDYOWvRArDURanFa8zNVsDBH9r9P7q+d7ydQkco=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0459.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.19; Thu, 10 Sep 2020 15:01:24 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3348.019; Thu, 10 Sep 2020
 15:01:24 +0000
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
Subject: [net-next v8 4/6] net: marvell: prestera: Add ethtool interface support
Date:   Thu, 10 Sep 2020 18:00:53 +0300
Message-Id: <20200910150055.15598-5-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910150055.15598-1-vadym.kochan@plvision.eu>
References: <20200910150055.15598-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0009.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::19) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by BE0P281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.10 via Frontend Transport; Thu, 10 Sep 2020 15:01:21 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ff8a5ab-14cb-425b-8b3c-08d8559a619a
X-MS-TrafficTypeDiagnostic: HE1P190MB0459:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB04593735B31A2A3D2288652A95270@HE1P190MB0459.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:612;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M30hsPvgHTxc2djnX2CECugYjuVOACzDXvmSx2Sxj/kQtjFwtREtp19QuQ3HzpAtaqKvwZsB0TFqLn5ob9idHCZyVXx39aAafYj245H2ajsCAYlzOW5oZ3XvyxqaK6uqY+qimGfiAhK6Zqhw6Z4+SQvapMOxDkc3NLGnvA8AlRDvQ6divSNCOYICMT2JsKf5V6SkEmx9xJ7jqdeBPnx5F8idpcE/7AbibPZMpriTQM0M94bvu1pRCNKksdX0WwuGyYwP5E12815LJidtW8BkZEYnvo+ECZH7vL6KSaWuk8pu1GFc88Jo0WZ6vxj8h3fZcxAIXqQTpx2TRcT1GSrixHF0MjWQapWFevpsLJkiuD8DlfHfOkHB6D0emA0BKPIWtOo2RqcTkRVqEm+ojOsgCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(39830400003)(396003)(346002)(366004)(376002)(26005)(2906002)(8936002)(110136005)(186003)(16526019)(8676002)(2616005)(83380400001)(44832011)(4326008)(66556008)(66946007)(54906003)(66476007)(30864003)(1076003)(6506007)(5660300002)(6666004)(107886003)(956004)(6486002)(478600001)(86362001)(316002)(6512007)(36756003)(52116002)(333604002)(921003)(579004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ug58lhOSNJwMr+k1gbhdIv/4diQhFpa6FqTJCECvxeYUDpUeNwC0UHQkqDaCWVQzrCUXqfa+yIveR0JJxG5vGYfjn6TaEtsRO+O9jglpjWFnqGODHC3opg8mM1Q+Ixu/iqMoHXEy8EuFauvhZLkAvY1Kyx+cOkycd95KKLWSlXP8tqm5usGSgl4v8+4DdLSV2lk5OHceU3QYpg3Br0NOtktVzLxKkuHD5SYQrG8s2T1oqGrMnnnzg3mu/fc/QFMqv24ryfK4xBAHsBSfAvhuQmhNbAeoYdABLSlJboKIeSnKntgZ8fr3KW8y573vI6Swcqq3g3wG7mvOfhbSYBiR4zQDoiBlzA7l+UBF4X8v3pkYD8qMpTsCDoSbQs1ES2EuGcyDrb5XQ8ULpMMBsBW9AQLMNHXXpf+zNP3Ag+howw6fqauxA6UZrbH69B6HE/OJ6XzG+b9iYc2+h4xuoNWsZyCkg/HFqYs+8wqTwXYmDUUhYnOEtUHeyOXIK5OCPw6ifBHLeqJpF4cvt+dthZPnrVaXwz2XertVhpyu/Ke6WkMvDjF1ynwIZxiCBh3mx70HKreRRDTtYw/QvQUZLhCx2rXs03Af20KC2aPhB130BV/EHqJF8LP8KvZLkPgjCBBlF0BhlPqHF8g0m84Ga9jrRg==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ff8a5ab-14cb-425b-8b3c-08d8559a619a
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 15:01:22.6666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E6HIZr1Y9cnvABPYT1VZDmsYdUsQ91Zggg85pbLlhPLxX6uqR14VbB47aXVKMk0Q8wq0/R7/ViQvZvB8nbGl6OmkcnCXVk6/inhsKXsmsg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0459
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

Co-developed-by: Andrii Savka <andrii.savka@plvision.eu>
Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
Co-developed-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
PATCH v8:
    1) Sorted includes.

    2) Use traditional error handling pattern:

       err = F();
       if (err)
           return err;

    3) Invert '!err ? speed : SPEED_UNKNOWN' into 'err ? SPEED_UNKNOWN : speed'

    4) Return original error code from last called func
       in places where instead other error code was used.

    5) Put license in one line.

    6) Add missing comma for last enum member

    7) Add comma for last member in initialized struct in prestera_hw.c

PATCH v5:

    1) Convert following error check:

        if (func(...))
        or
        if (!func(...))

        to use err variable:

        err = func(...)
        if (err)

    2) Remove "," from terminated enum entry.

PATCH v4:
    1) Export only prestera_ethtool_ops instead of
       each ethtool handler.

    2) Get rid of not needed cast in prestera_ethtool_get_stats(...)
       when doing memcpy.

 .../net/ethernet/marvell/prestera/Makefile    |   2 +-
 .../net/ethernet/marvell/prestera/prestera.h  |   3 +
 .../marvell/prestera/prestera_ethtool.c       | 780 ++++++++++++++++++
 .../marvell/prestera/prestera_ethtool.h       |  11 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 299 +++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  65 ++
 .../ethernet/marvell/prestera/prestera_main.c |  28 +-
 7 files changed, 1182 insertions(+), 6 deletions(-)
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
index 0a34d7ca4823..69628632e2bd 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -169,4 +169,7 @@ void prestera_device_unregister(struct prestera_device *dev);
 struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
 						 u32 dev_id, u32 hw_id);
 
+int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
+			      u64 adver_link_modes, u8 adver_fec);
+
 #endif /* _PRESTERA_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
new file mode 100644
index 000000000000..93a5e2baf808
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
@@ -0,0 +1,780 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
+
+#include <linux/ethtool.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+
+#include "prestera_ethtool.h"
+#include "prestera.h"
+#include "prestera_hw.h"
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
+static void prestera_ethtool_get_drvinfo(struct net_device *dev,
+					 struct ethtool_drvinfo *drvinfo)
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
+
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
+	if (err)
+		return err;
+
+	port->caps.type = type;
+	port->autoneg = false;
+
+	return 0;
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
+
+		if (type != PRESTERA_PORT_TYPE_NONE &&
+		    port_link_modes[mode].port_type != type)
+			continue;
+
+		__set_bit(port_link_modes[mode].eth_mode, eth_modes);
+	}
+
+	for (mode = 0; mode < PRESTERA_PORT_FEC_MAX; mode++) {
+		if ((port_fec_caps[mode].pr_fec & fec) == 0)
+			continue;
+
+		__set_bit(port_fec_caps[mode].eth_mode, eth_modes);
+	}
+}
+
+static void prestera_modes_from_eth(const unsigned long *eth_modes,
+				    u64 *link_modes, u8 *fec, u8 type)
+{
+	u64 adver_modes = 0;
+	u32 fec_modes = 0;
+	u32 mode;
+
+	for (mode = 0; mode < PRESTERA_LINK_MODE_MAX; mode++) {
+		if (!test_bit(port_link_modes[mode].eth_mode, eth_modes))
+			continue;
+
+		if (port_link_modes[mode].port_type != type)
+			continue;
+
+		adver_modes |= port_link_modes[mode].pr_mask;
+	}
+
+	for (mode = 0; mode < PRESTERA_PORT_FEC_MAX; mode++) {
+		if (!test_bit(port_fec_caps[mode].eth_mode, eth_modes))
+			continue;
+
+		fec_modes |= port_fec_caps[mode].pr_fec;
+	}
+
+	*link_modes = adver_modes;
+	*fec = fec_modes;
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
+
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
+	int err;
+
+	err = prestera_hw_port_remote_cap_get(port, &bitmap);
+	if (!err) {
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
+	err = prestera_hw_port_remote_fc_get(port, &pause, &asym_pause);
+	if (err)
+		return;
+
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
+	ecmd->base.speed = err ? SPEED_UNKNOWN : speed;
+}
+
+static void prestera_port_duplex_get(struct ethtool_link_ksettings *ecmd,
+				     struct prestera_port *port)
+{
+	u8 duplex;
+	int err;
+
+	err = prestera_hw_port_duplex_get(port, &duplex);
+	if (err) {
+		ecmd->base.duplex = DUPLEX_UNKNOWN;
+		return;
+	}
+
+	ecmd->base.duplex = duplex == PRESTERA_PORT_DUPLEX_FULL ?
+			    DUPLEX_FULL : DUPLEX_HALF;
+}
+
+static int
+prestera_ethtool_get_link_ksettings(struct net_device *dev,
+				    struct ethtool_link_ksettings *ecmd)
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
+
+		if (duplex != port_link_modes[mode].duplex)
+			continue;
+
+		if (!(port_link_modes[mode].pr_mask &
+		    port->caps.supp_link_modes))
+			continue;
+
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
+	if (err)
+		return err;
+	if (curr_mode >= PRESTERA_LINK_MODE_MAX)
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
+static int
+prestera_ethtool_set_link_ksettings(struct net_device *dev,
+				    const struct ethtool_link_ksettings *ecmd)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	u64 adver_modes;
+	u8 adver_fec;
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
+static int prestera_ethtool_get_fecparam(struct net_device *dev,
+					 struct ethtool_fecparam *fecparam)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	u8 active;
+	u32 mode;
+	int err;
+
+	err = prestera_hw_port_fec_get(port, &active);
+	if (err)
+		return err;
+
+	fecparam->fec = 0;
+
+	for (mode = 0; mode < PRESTERA_PORT_FEC_MAX; mode++) {
+		if ((port_fec_caps[mode].pr_fec & port->caps.supp_fec) == 0)
+			continue;
+
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
+static int prestera_ethtool_set_fecparam(struct net_device *dev,
+					 struct ethtool_fecparam *fecparam)
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
+static int prestera_ethtool_get_sset_count(struct net_device *dev, int sset)
+{
+	switch (sset) {
+	case ETH_SS_STATS:
+		return PRESTERA_STATS_CNT;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void prestera_ethtool_get_strings(struct net_device *dev,
+					 u32 stringset, u8 *data)
+{
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	memcpy(data, prestera_cnt_name, sizeof(prestera_cnt_name));
+}
+
+static void prestera_ethtool_get_stats(struct net_device *dev,
+				       struct ethtool_stats *stats, u64 *data)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	struct prestera_port_stats *port_stats;
+
+	port_stats = &port->cached_hw_stats.stats;
+
+	memcpy(data, port_stats, sizeof(*port_stats));
+}
+
+static int prestera_ethtool_nway_reset(struct net_device *dev)
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
+
+const struct ethtool_ops prestera_ethtool_ops = {
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
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
new file mode 100644
index 000000000000..523ef1f592ce
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved. */
+
+#ifndef __PRESTERA_ETHTOOL_H_
+#define __PRESTERA_ETHTOOL_H_
+
+#include <linux/ethtool.h>
+
+extern const struct ethtool_ops prestera_ethtool_ops;
+
+#endif /* _PRESTERA_ETHTOOL_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index d039053cfec9..4400bc16944e 100644
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
+	PRESTERA_PORT_TP_AUTO,
+};
+
 enum {
 	PRESTERA_PORT_GOOD_OCTETS_RCV_CNT,
 	PRESTERA_PORT_BAD_OCTETS_RCV_CNT,
@@ -82,6 +98,13 @@ enum {
 	PRESTERA_PORT_CNT_MAX
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
 	struct rcu_head rcu;
@@ -137,11 +160,23 @@ struct prestera_msg_port_cap_param {
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
@@ -483,6 +518,238 @@ int prestera_hw_port_cap_get(const struct prestera_port *port,
 	return err;
 }
 
+int prestera_hw_port_remote_cap_get(const struct prestera_port *port,
+				    u64 *link_mode_bitmap)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_REMOTE_CAPABILITY,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+	struct prestera_msg_port_attr_resp resp;
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*link_mode_bitmap = resp.param.cap.link_mode;
+
+	return 0;
+}
+
+int prestera_hw_port_remote_fc_get(const struct prestera_port *port,
+				   bool *pause, bool *asym_pause)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_REMOTE_FC,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+	struct prestera_msg_port_attr_resp resp;
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
+	}
+
+	return 0;
+}
+
+int prestera_hw_port_type_get(const struct prestera_port *port, u8 *type)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_TYPE,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+	struct prestera_msg_port_attr_resp resp;
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*type = resp.param.type;
+
+	return 0;
+}
+
+int prestera_hw_port_fec_get(const struct prestera_port *port, u8 *fec)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_FEC,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+	struct prestera_msg_port_attr_resp resp;
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*fec = resp.param.fec;
+
+	return 0;
+}
+
+int prestera_hw_port_fec_set(const struct prestera_port *port, u8 fec)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_FEC,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {
+			.fec = fec,
+		}
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
+	default:
+		return ETH_TP_MDI_INVALID;
+	}
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
+	default:
+		return PRESTERA_PORT_TP_NA;
+	}
+}
+
+int prestera_hw_port_mdix_get(const struct prestera_port *port, u8 *status,
+			      u8 *admin_mode)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_MDIX,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+	struct prestera_msg_port_attr_resp resp;
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
+		.dev = port->dev_id,
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
+		.param = {
+			.link_mode = mode,
+		}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_port_link_mode_get(const struct prestera_port *port, u32 *mode)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_LINK_MODE,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+	struct prestera_msg_port_attr_resp resp;
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*mode = resp.param.link_mode;
+
+	return 0;
+}
+
+int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_SPEED,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+	struct prestera_msg_port_attr_resp resp;
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*speed = resp.param.speed;
+
+	return 0;
+}
+
 int prestera_hw_port_autoneg_set(const struct prestera_port *port,
 				 bool autoneg, u64 link_modes, u8 fec)
 {
@@ -503,6 +770,38 @@ int prestera_hw_port_autoneg_set(const struct prestera_port *port,
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
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_DUPLEX,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+	struct prestera_msg_port_attr_resp resp;
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*duplex = resp.param.duplex;
+
+	return 0;
+}
+
 int prestera_hw_port_stats_get(const struct prestera_port *port,
 			       struct prestera_port_stats *st)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 5fc923cbb6a5..203c0daa4af1 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -6,19 +6,69 @@
 
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
+
+	PRESTERA_LINK_MODE_MAX
+};
+
 enum {
 	PRESTERA_PORT_TYPE_NONE,
 	PRESTERA_PORT_TYPE_TP,
+	PRESTERA_PORT_TYPE_AUI,
+	PRESTERA_PORT_TYPE_MII,
+	PRESTERA_PORT_TYPE_FIBRE,
+	PRESTERA_PORT_TYPE_BNC,
+	PRESTERA_PORT_TYPE_DA,
+	PRESTERA_PORT_TYPE_OTHER,
 
 	PRESTERA_PORT_TYPE_MAX
 };
 
+enum {
+	PRESTERA_PORT_TCVR_COPPER,
+	PRESTERA_PORT_TCVR_SFP,
+
+	PRESTERA_PORT_TCVR_MAX
+};
+
 enum {
 	PRESTERA_PORT_FEC_OFF,
+	PRESTERA_PORT_FEC_BASER,
+	PRESTERA_PORT_FEC_RS,
 
 	PRESTERA_PORT_FEC_MAX
 };
 
+enum {
+	PRESTERA_PORT_DUPLEX_HALF,
+	PRESTERA_PORT_DUPLEX_FULL,
+};
+
 struct prestera_switch;
 struct prestera_port;
 struct prestera_port_stats;
@@ -47,10 +97,25 @@ int prestera_hw_port_mac_set(const struct prestera_port *port, const char *mac);
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
index 47cd2bc367bf..bb51ee5646cd 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -13,6 +13,7 @@
 #include "prestera_hw.h"
 #include "prestera_rxtx.h"
 #include "prestera_devlink.h"
+#include "prestera_ethtool.h"
 
 #define PRESTERA_MTU_DEFAULT	1536
 
@@ -190,22 +191,38 @@ static const struct net_device_ops prestera_netdev_ops = {
 	.ndo_get_devlink_port = prestera_devlink_get_port,
 };
 
-static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
-				     u64 link_modes, u8 fec)
+int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
+			      u64 adver_link_modes, u8 adver_fec)
 {
 	bool refresh = false;
+	u64 link_modes;
 	int err;
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
@@ -261,6 +278,7 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 
 	dev->features |= NETIF_F_NETNS_LOCAL;
 	dev->netdev_ops = &prestera_netdev_ops;
+	dev->ethtool_ops = &prestera_ethtool_ops;
 
 	netif_carrier_off(dev);
 
-- 
2.17.1

