Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695BB618A43
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiKCVID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiKCVHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:07:18 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140053.outbound.protection.outlook.com [40.107.14.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223B721259;
        Thu,  3 Nov 2022 14:07:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/JkTg/Itknu0LZ6EsJOkE0QlnIx1Z1ex+iDGWD2ccEEEEfaEK/QuNFMEeW50VWNvGxZqJLg+MKZuYQhNQ+1EzCiiMByZteZTBSBxlGBQpEuG3gbOIoqNw0W8A+8jd/FIl/5cfX06RrteXtQ2RaUIKtz1qEVRtfHxvfB4ZdhggL3FApir9wEoyvC++Nx5WwJ6lUmAhoxGpOIndajfoX/lN3BmHCCnKngeMWrpKoiHskuiuIKmAAiKivUj/EJ7f52qOhBmx7CbQuPIk3Gw9vq5qEVWth+vGdUJpf2QmxfTdnte6YBCoQGPLhXqqfTlJO81RYrvwwODx9yjwSQQO43ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=353ZC1bC98dWQN3Jxynz7tWVUOoRY9sfJHJgIc2n6n4=;
 b=cf7YwYucgMr7QQabDZYdfecA++QCC3MqIo+HNsOXbRiXkKSux249nc+Lp68TZz1RpWzI64I7D2Ms8yy1T+bW4NKmSO+mkvsX+YYSTo9DdM+rdnBmSa5cx/qgGfh23GX0MZ7pz5LFhcCS4UUwlm5puchaX22P2/9Ltk5GLRI6BqqK17/ATRYULG9OGG1NZVdfWEMQRqEhfOc8gFC35jRy2Hl3EHiS7XoUcKRv1YMHyFv6zPBPGCX4+uQqybjfvUYVkoFHY3dXJM0Im3VJACS5xPvrTahQ5Coy8Hgl1Rg1ND6+xQSEEmrCaec0rPS8c9ifWV8Q6fNyU1Ya8xRGr0X1Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=353ZC1bC98dWQN3Jxynz7tWVUOoRY9sfJHJgIc2n6n4=;
 b=X8s8dYyOCQa6oQa0TgFLVPWbFWEVHjUpB1BqdqCSKDUVXsiBknSQ0mmdQi4WjCiZAi1tIdAK6pUJb1Sxu+KQB1kZWLSE5FRNauQioPzg0aAP4GQyNQefZxnTWMusF+l2WNB4sXoAp7SQEIxpk0oA16bKfi9CnxfmRKSNYmRa5xdsso0ryCWeZLD2VPhblvijl58Ea4abkZkqZzfQmggwsrQ0rKqLPlvnoQO75PnEQ6ipnt9r8LFCLkPrno6JZ0czTfOcQ69hYLQyu3m0jW9c7ucc6YR85NSNABFtdGtAmXhDqHFAJCXxE8v3pczXo2184wOEu1tEZxjdN0teUvUm/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7746.eurprd03.prod.outlook.com (2603:10a6:102:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 3 Nov
 2022 21:07:15 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 21:07:15 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 07/11] net: dsa: felix: Convert to use PCS driver
Date:   Thu,  3 Nov 2022 17:06:46 -0400
Message-Id: <20221103210650.2325784-8-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221103210650.2325784-1-sean.anderson@seco.com>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::7) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAXPR03MB7746:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b233f70-9794-4b77-0823-08dabddf6228
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LejXoASdxyakKzN6VLIGCTM6rnfL2tgcAYVa5RCXqhzuBwTmYDBdwRowZJOfsa6qzobWL+WNkMTatkHaZrz/ZS5APctATK+abzLWvD9mIDp5Rk8x6eOQ1tYs+6+1zkH9FZoeEdZqi01YITOIV6uiy70CgXKld2r3W5ZDIwCVbH7mlNFs8v2KaGKV3SYCdr3Oao+v3swFbe7ZX5OyD6OyYpa77TpY3t6xsbux+7mEqBoMP3yXqXQ5LW3YiJDSX8fGScXP6ZcMbb39CaBJ8Art2Fv3BbjSKJozge95lFRkLDPoErzmLNhsTIqblmJd8M8eh+PWpeY6IdSzPSVifzhdlw06QZpDQS8UYJp/eeoJxFSs+v4uudrHRBgxiOSC9fIdFJ0xtwP2LK64LzNTlGWyfGgl1skmNHTT/h5Vn7O2toJdMmqP15WOJ2aO4YPYjGN2BJ6skZ+SelHlkRvYh03qm+KEMwcqeNRKbF5MijSl+CpPe/ZRe7DIiWfB7nJMsdZ2AgeW+ZtXANlW7YMwoedPud4h/Lq2r9iojo8JmLld5l6o/hcg1r2ERRTu6kkUFt5dJPa0FbdCTJb+Nw93VuBGtFEBYBt7wcKgBn6YAHJVjGq19pnJ9hj3RcUspdTZh3pztAP2eDVdRS4l+eob0s/6AL5Tm0fv1RmxV2kqyUKnfP7+sPJlVgHyEkLYih1+3deAvuhDuIMQlZLzyogdM0pFH0jJB/qZXbpUWnfCWa+QMFaJb9k35oBXmTixofZ4qOYJmbbSUbRfWM+js8e9Lta3oA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39850400004)(376002)(346002)(396003)(451199015)(8936002)(86362001)(36756003)(107886003)(478600001)(6486002)(44832011)(5660300002)(2906002)(52116002)(26005)(6512007)(6506007)(1076003)(38350700002)(38100700002)(186003)(83380400001)(2616005)(7416002)(41300700001)(6666004)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LcNufqY87tNXIEtGeZWUHYLQsM46sztL6RXEZ/ddynqY8i9TwfLCtFGqOZ2T?=
 =?us-ascii?Q?eBlUiUSMRTpgWf5mWhVn8A3W6CzhKpOd34wzR5/DEi9S+mDGWNAgriNcOvXD?=
 =?us-ascii?Q?w1yyK33ANlx2X91MhOJvVeAIhUD+9IbQd9TznSPFtbCzrq+kDPJq7BGSXh1d?=
 =?us-ascii?Q?DRJTaPa99cJMTbihJoEeO4dbprTQ1di3bZKP7vAZDVTYnV3tWVY/oL+DTFBe?=
 =?us-ascii?Q?vu/L7g4CI/TYuk8BJla6x0dZ0Zv/3njqhBl0Z5uHTzBrdWuAYjpRQ1uXslIL?=
 =?us-ascii?Q?5A4W8hld3MyqJdYZxsPnlU6KIEX5h3AE3JEkEJH1dZw6b1TPKYMY9f7QVwqU?=
 =?us-ascii?Q?iTEHO/VZ+YT3MhRRMBowMbjWs9AubrodfHlRt7ZIcfZNuFGohA/3j9cYydLD?=
 =?us-ascii?Q?qK2AG0+0Jlqxr68bHyamQpMho0QVxV8OUjrcSNLwBiX/CNkPu0qt2nicb/H5?=
 =?us-ascii?Q?SL2QZX2/wRVZQx5jjURmHvEeUtWobEp3bFTyVxsLrANAPo4F4g8HOQstevyG?=
 =?us-ascii?Q?75OBDQ4ZvqQdVEnu7bu2ouG0HdraUIV08kz0VtF+gYBec+ROpzGhrTKDHY76?=
 =?us-ascii?Q?/hfUuCwUdADDB/0kp3Gsr0V+Pck7Q23EzUBNZtJwIgjOTWdCxp5MqnMAxAc5?=
 =?us-ascii?Q?ikqfGIBj0IO0qL9uMSpcklOb826A41A3jaIBf+477I9frV3iMROfwr3D+NdH?=
 =?us-ascii?Q?8PdgeEqtSC07zrDJXaV8fYFsdHrIKJUXtKI5i2yK4FYTAIKifSKicKqCitiI?=
 =?us-ascii?Q?YCs29aHd9OE94Aaz9jV/uDO8oi8vXytOTsdRWqRNwjmNLRNmhNuxKaf9YhyD?=
 =?us-ascii?Q?S7SaVk7JFaz4D8hz8QFAc6uKuOkX/NuMug2v/o8C9SHpOlPuNIfH2U6P2pIn?=
 =?us-ascii?Q?XzowsllaJ62lwhtlk2/Lm2SIBkZZIFeUgt0Z2kGQOTKlcclbvdm3m5H57ruL?=
 =?us-ascii?Q?s2P2k3To+UAEFgZOtV4y+HETmK9gYvTXkOsjs6v5P8ju1fpr4+KjlMFugTu5?=
 =?us-ascii?Q?U3eb0sQXpjRZyC69LBKsufWA/yE24iRkAwAEzuaiw4b8A0IfJe2Ds66JXXq+?=
 =?us-ascii?Q?d5ye0tTwh3LWp/jqDYQr60W4+73Hm9l7rOqVaPEDA6e+/J2eZUcMCOrH0dqz?=
 =?us-ascii?Q?uTk13ikOY09SnX/v0HcXlJyIAaKzoo5mHz5Ew8zUD+JnEYDr7IdLVi1ond/i?=
 =?us-ascii?Q?DGF6EgA7JwcDzPI6uMtQwTzY5eLnu7DIQ87+hvbeTkkANY+4gaDlMk9PejBh?=
 =?us-ascii?Q?oyAeaeR484Si9D4D0R7Gq6bebnmAjqBoz2wKCge1j3arr3bSmThkRCFLan3r?=
 =?us-ascii?Q?6q0GAxlDFwP5OIhiQmhRBRbQI5F8ome6/Cb8hHClJMmnrbKuVDHjXOx0xnmb?=
 =?us-ascii?Q?bNx/vVsAL438S4o7lhRh4fy8Usr589ymVWzugC5BHJ5fTW1+LH2feKVlXHdx?=
 =?us-ascii?Q?n1BU8X7CqV7cUedEb7pMofMmTJ53etz6IHq1/fISSHVwVzBvLDpaJWJEIvFb?=
 =?us-ascii?Q?5M07dwRmskuEz9MnYKcqu0rRU6oCjlPw+iMxLlHztp/uLWpkWJLjtEFWcufN?=
 =?us-ascii?Q?gFSY2q/8CzK26HIKEoY4ty0sRQo2FH9dgrcM6NMPeoyIlihf7A4gufY240ur?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b233f70-9794-4b77-0823-08dabddf6228
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 21:07:14.9743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IdjPbe+1haJ2x5rtvt6u21wMnnwgg33lvx4sCKFF4Z39wEBjslSmeF3Z6VIJ1lgi7cBhDGuBDmYG//OyRnTvDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7746
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the Ocelot Felix driver to use the Lynx PCS driver,
instead of attaching the Lynx library to an MDIO device.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Split off from the lynx PCS patch

 drivers/net/dsa/ocelot/Kconfig           |  2 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 27 ++++++------------------
 drivers/net/dsa/ocelot/seville_vsc9953.c | 27 ++++++------------------
 3 files changed, 14 insertions(+), 42 deletions(-)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 08db9cf76818..eeba3d35f9ee 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -11,6 +11,7 @@ config NET_DSA_MSCC_FELIX
 	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
 	select FSL_ENETC_MDIO
+	select PCS
 	select PCS_LYNX
 	help
 	  This driver supports the VSC9959 (Felix) switch, which is embedded as
@@ -26,6 +27,7 @@ config NET_DSA_MSCC_SEVILLE
 	select MSCC_OCELOT_SWITCH_LIB
 	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
+	select PCS
 	select PCS_LYNX
 	help
 	  This driver supports the VSC9953 (Seville) switch, which is embedded
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index ba893055b92d..f45c9a3088c8 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -11,6 +11,7 @@
 #include <net/tc_act/tc_gate.h>
 #include <soc/mscc/ocelot.h>
 #include <linux/dsa/ocelot.h>
+#include <linux/pcs.h>
 #include <linux/pcs-lynx.h>
 #include <net/pkt_sched.h>
 #include <linux/iopoll.h>
@@ -1015,7 +1016,6 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 		struct phylink_pcs *phylink_pcs;
-		struct mdio_device *mdio_device;
 
 		if (dsa_is_unused_port(felix->ds, port))
 			continue;
@@ -1023,19 +1023,13 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
 			continue;
 
-		mdio_device = mdio_device_create(felix->imdio, port);
-		if (IS_ERR(mdio_device))
+		phylink_pcs = lynx_pcs_create_on_bus(dev, felix->imdio, port);
+		if (IS_ERR(phylink_pcs))
 			continue;
 
-		phylink_pcs = lynx_pcs_create(mdio_device);
-		if (!phylink_pcs) {
-			mdio_device_free(mdio_device);
-			continue;
-		}
-
 		felix->pcs[port] = phylink_pcs;
 
-		dev_info(dev, "Found PCS at internal MDIO address %d\n", port);
+		dev_info(dev, "Created PCS at internal MDIO address %d\n", port);
 	}
 
 	return 0;
@@ -1046,17 +1040,8 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int port;
 
-	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct phylink_pcs *phylink_pcs = felix->pcs[port];
-		struct mdio_device *mdio_device;
-
-		if (!phylink_pcs)
-			continue;
-
-		mdio_device = lynx_get_mdio_device(phylink_pcs);
-		mdio_device_free(mdio_device);
-		lynx_pcs_destroy(phylink_pcs);
-	}
+	for (port = 0; port < ocelot->num_phys_ports; port++)
+		pcs_put(ocelot->dev, felix->pcs[port]);
 	mdiobus_unregister(felix->imdio);
 	mdiobus_free(felix->imdio);
 }
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 1e1c6cd265fd..99e8043fbc2e 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -9,6 +9,7 @@
 #include <linux/mdio/mdio-mscc-miim.h>
 #include <linux/of_mdio.h>
 #include <linux/of_platform.h>
+#include <linux/pcs.h>
 #include <linux/pcs-lynx.h>
 #include <linux/dsa/ocelot.h>
 #include <linux/iopoll.h>
@@ -946,7 +947,6 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 		struct phylink_pcs *phylink_pcs;
-		struct mdio_device *mdio_device;
 		int addr = port + 4;
 
 		if (dsa_is_unused_port(felix->ds, port))
@@ -955,19 +955,13 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
 			continue;
 
-		mdio_device = mdio_device_create(felix->imdio, addr);
-		if (IS_ERR(mdio_device))
+		phylink_pcs = lynx_pcs_create_on_bus(dev, felix->imdio, addr);
+		if (IS_ERR(phylink_pcs))
 			continue;
 
-		phylink_pcs = lynx_pcs_create(mdio_device);
-		if (!phylink_pcs) {
-			mdio_device_free(mdio_device);
-			continue;
-		}
-
 		felix->pcs[port] = phylink_pcs;
 
-		dev_info(dev, "Found PCS at internal MDIO address %d\n", addr);
+		dev_info(dev, "Created PCS at internal MDIO address %d\n", addr);
 	}
 
 	return 0;
@@ -978,17 +972,8 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int port;
 
-	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct phylink_pcs *phylink_pcs = felix->pcs[port];
-		struct mdio_device *mdio_device;
-
-		if (!phylink_pcs)
-			continue;
-
-		mdio_device = lynx_get_mdio_device(phylink_pcs);
-		mdio_device_free(mdio_device);
-		lynx_pcs_destroy(phylink_pcs);
-	}
+	for (port = 0; port < ocelot->num_phys_ports; port++)
+		pcs_put(ocelot->dev, felix->pcs[port]);
 
 	/* mdiobus_unregister and mdiobus_free handled by devres */
 }
-- 
2.35.1.1320.gc452695387.dirty

