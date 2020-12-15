Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F2A2DB1CC
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbgLOQrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:47:02 -0500
Received: from mail-eopbgr20074.outbound.protection.outlook.com ([40.107.2.74]:21124
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730706AbgLOQqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:46:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/WVPCAIs+r8RUBY0ewuhASsR8vb8LQWIFZdPdbHqKkg6lSZTvqzTdt3/Sktt0FwIUbsRYqn0pirEKIjNwrqM/Zy2yyWS0tQf8fJpL3lVFbd58FJ8kpSdykIyVJIF1Rkx42kNEx8lDOKBTV2d7kPK0HmJ1ijYSEQIvH5ElV+HCqnxVOzJ7HNFgGl23Bx/+Y5gULLSg5kGI3zjaqziw/LHBawydj5+T6bhq87csXBQ0dHRPPUfnT+Y4gA5wPMJwOyPv9QL7Eqt16VeEue4S4RUU4CWhCxWQyR7efbFr8XrDZ0BRh2T2MsArGsBjCy0yy5wCqy9tniM7r8jHkNMS75LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cR5uxtAJAfifm5l9IKMnUt7DAtEalUAeBPie9OfBW7k=;
 b=nX5obz3WHHMd6K6vGY40ySHLhppGKapHfn9cLqz/N/35LDMhGE89Xhgpf/v3zbPl6t2LMaPjiHSCkeLouXn0QRRKBnTrdwHXtNOuxeuhw/kqWSjajkQBh1/j4Ij4Czb3KztobeL2px4kkhsMGBEczyvfvGbwSgQ+TXbrobjouaXR/oeIUfNKjxALt+9/Sol2ZbUFvTB19DqJvGrXFl9ayGWLdI7MrReadzqN4T7eWu2SQUF24nIOn8BO4zC2h4IkazUk2qeA3YKwPjvszLPg4+KWlEZSbuR6BCRblMRjyfG+VsuhrbVfsmMK2FDCvQf7uXaGV2EDXdXZ/ZZwSC9gIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cR5uxtAJAfifm5l9IKMnUt7DAtEalUAeBPie9OfBW7k=;
 b=VKEr5Ed5rORCwyHPV2DzKU1FO2ssJvJ7gWAeEmy+eBtLlE0GhFTK7riE4BpdDnk07nVOsGRcgshbJfwe8cVy1/xpFsFx20A5bVI8A5raNgjGaKsk4JJfzZJf8c9aeaQM9Y/3u/FnObn9eSqCWL4twTJzsz4MLWgcggy+Lbhuvpc=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6963.eurprd04.prod.outlook.com (2603:10a6:208:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Tue, 15 Dec
 2020 16:45:02 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Tue, 15 Dec 2020
 16:45:02 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>
Cc:     linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v2 11/14] phylink: introduce phylink_fwnode_phy_connect()
Date:   Tue, 15 Dec 2020 22:13:12 +0530
Message-Id: <20201215164315.3666-12-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0152.apcprd06.prod.outlook.com
 (2603:1096:1:1f::30) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0152.apcprd06.prod.outlook.com (2603:1096:1:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 16:44:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 686d251b-1694-4bd2-1177-08d8a118c4f1
X-MS-TrafficTypeDiagnostic: AM0PR04MB6963:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB69639BC89177A6D3002D0A5BD2C60@AM0PR04MB6963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 68/Lrz3Uj+ZgE5wRKqsVE+zRjfw4C4DB/VRQ1ULbitubz5fi4MIV01quanYdJY91c4lP2YRpEvKsAQvUcIaoFI9oPAJ8Rcnyb9MLGbwZ2pqbgAH7SM3BNiSaaWg2Zj4DdE87mY3PSHa21qmAAcqd2lgmfj4gcMl8mDYhsocDnBJE9GH0YeHTBNn52hIYT27+y05YZ7lhsiVmXm2H/JZl9NaA+Y83cbfGI061XCOeySFKpn/yTVs0wBP0wzLYZslpANUmG0Kh9U4hydrgwYO4NjHUbVTYnuzwKy7F58J+MP+PMgaHqiSNAHVZyghI0wp6T+twlOXdiWuXSSPpjvImD46rddXFK08/NNTjM6UGwscRfeNwQ+BAhPBZNs0gyV/sRtluQcXAwzSONwqLFklpXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(4326008)(6506007)(498600001)(66946007)(921005)(2616005)(956004)(86362001)(52116002)(16526019)(8676002)(2906002)(26005)(6512007)(44832011)(7416002)(186003)(5660300002)(55236004)(1006002)(1076003)(66476007)(110136005)(6486002)(66556008)(6666004)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IVwwQd0qh+dUdRR66h45q/IDgJrr8bdcAsGF/bJTc9N1nhXKPhgwYvr0t5Tx?=
 =?us-ascii?Q?R7m758rZpbi1rzrvX8PyKS0FdOh/bfVtHcNpBVDK/um0+wOYYofUUvtpXlaU?=
 =?us-ascii?Q?OPD3TeJo4LLeMbYpmNN7fP517+avmMg+A5moAWvh4Hb2YbEig+vjinB/9IVU?=
 =?us-ascii?Q?fyEAdwI+8k9hjIyw9U7lSNbbVPCdwVo3HjNMuk4DTf38dEpdXwNsRWdBEW1K?=
 =?us-ascii?Q?jVbt9jQ6uRz7IHBUofv2xncTLaXQGDtPd9UCN/uREJOnO5MCtZV8mbmMuewE?=
 =?us-ascii?Q?2pq5yQRallOr2N2ciknf8XcbzM5Le0ppNZ/p/plFLEVzdpugxMyRHwqlJS8C?=
 =?us-ascii?Q?A5AsS1teX1ZyhfWF4fyhIWDJXK2bRQ2duRv0Pq35q2zuku5zRYmG4Po233dP?=
 =?us-ascii?Q?V4RhwmN+h8XO0xrR4HpxlDkdgIT50vzGBHmHJgRB1RT53Zbre2LP88ZgQJrS?=
 =?us-ascii?Q?/qu2mo+d3M7T0/kot9Y1i1+c76lbyOAUhHHWQ+OChXX80YDiXc5GShXyktGA?=
 =?us-ascii?Q?8SHC080M8s0vEwvp3Hu2JqcJCcIZLQMyNN1n/X9P2cF5Jgn/zZGtv8hPLuMc?=
 =?us-ascii?Q?5H19YLMcLMoJ/nKyzCTir+wWgtaeZ4jkfiL+AS75QJ0o7dnmYa97NikpSVvK?=
 =?us-ascii?Q?8YdkpAPQz/w9y1HKaMPN0+MFsrQZjPTZFA6sJj2pYdxWUE7wyf3/YUfG76vB?=
 =?us-ascii?Q?g6S+XWpi4YE/LEBB9lhXXEF+FQw4tmbDxGXraWUys7ARAQDe/MQECppJIWBR?=
 =?us-ascii?Q?xGNWZYfULVkzRuOTPX8GYZIM1U/NeGwB4Y/AJauj0UilFkkJi0VQn+tXKTNa?=
 =?us-ascii?Q?vGlPfV1AY8jnBfX0/B1nqgwHcyK4W5PIJNJN1L0seYqu5N3pggRqhBoO1+kU?=
 =?us-ascii?Q?j+B5xz7sYaVUS1e1jFQlSOQ7/EktDiEQyv3/4SuhDcEcCeWmaJzzn13Vm6kN?=
 =?us-ascii?Q?RsZaNhzEsybhXtvwdy6IbhJXnfOcgFyUJI1oMcturP46qfJCUfjxFq2ecM75?=
 =?us-ascii?Q?bPfc?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 16:45:02.7355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 686d251b-1694-4bd2-1177-08d8a118c4f1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A+3fatH/X1/YbXPgCJ3SRiXACez+wgxjesK2FFzqQnT1hSDqw+EuwRoX54ia8/fTgne/59M6GlXVVAPA/yH9pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define phylink_fwnode_phy_connect() to connect phy specified by
a fwnode to a phylink instance.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2: None

 drivers/net/phy/phylink.c | 54 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 +++
 2 files changed, 57 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 84f6e197f965..389dc3ec165e 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2015 Russell King
  */
+#include <linux/acpi.h>
 #include <linux/ethtool.h>
 #include <linux/export.h>
 #include <linux/gpio/consumer.h>
@@ -1120,6 +1121,59 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 }
 EXPORT_SYMBOL_GPL(phylink_of_phy_connect);
 
+/**
+ * phylink_fwnode_phy_connect() - connect the PHY specified in the fwnode.
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @fwnode: a pointer to a &struct fwnode_handle.
+ * @flags: PHY-specific flags to communicate to the PHY device driver
+ *
+ * Connect the phy specified @fwnode to the phylink instance specified
+ * by @pl.
+ *
+ * Returns 0 on success or a negative errno.
+ */
+int phylink_fwnode_phy_connect(struct phylink *pl,
+			       struct fwnode_handle *fwnode,
+			       u32 flags)
+{
+	struct fwnode_handle *phy_fwnode;
+	struct phy_device *phy_dev;
+	int ret;
+
+	if (is_of_node(fwnode)) {
+		/* Fixed links and 802.3z are handled without needing a PHY */
+		if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
+		    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
+		     phy_interface_mode_is_8023z(pl->link_interface)))
+			return 0;
+	}
+
+	phy_fwnode = fwnode_get_phy_node(fwnode);
+	if (IS_ERR(phy_fwnode)) {
+		if (pl->cfg_link_an_mode == MLO_AN_PHY)
+			return -ENODEV;
+		return 0;
+	}
+
+	phy_dev = fwnode_phy_find_device(phy_fwnode);
+	/* We're done with the phy_node handle */
+	fwnode_handle_put(phy_fwnode);
+	if (!phy_dev)
+		return -ENODEV;
+
+	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
+				pl->link_interface);
+	if (ret)
+		return ret;
+
+	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
+	if (ret)
+		phy_detach(phy_dev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phylink_fwnode_phy_connect);
+
 /**
  * phylink_disconnect_phy() - disconnect any PHY attached to the phylink
  *   instance.
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index d81a714cfbbd..75d4f99090fd 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -439,6 +439,9 @@ void phylink_destroy(struct phylink *);
 
 int phylink_connect_phy(struct phylink *, struct phy_device *);
 int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);
+int phylink_fwnode_phy_connect(struct phylink *pl,
+			       struct fwnode_handle *fwnode,
+			       u32 flags);
 void phylink_disconnect_phy(struct phylink *);
 
 void phylink_mac_change(struct phylink *, bool up);
-- 
2.17.1

