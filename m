Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED28313717
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhBHPTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:19:54 -0500
Received: from mail-db8eur05on2085.outbound.protection.outlook.com ([40.107.20.85]:53953
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233553AbhBHPQA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 10:16:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Np0LpqZQEu9z1PZ+DPpFRmy0jTTEZdvJnouDp+tnDAQiq9C+z6Ed8xtfxi0gCZ6hSTa1Tqe5xVD++wM5SeSNPbxKyrphZZRQk/66OG3+2y2n1g+uuA2DjTwlA3MGQBpRbEvf742r6MJeUZpq/MxwCBB3R1/1SoIzARGIloYIrExgQiQlxg6NxHqCgRLJXGA9X/oG7smKomllZWOlPYTTQAJRRpdxCQOPNxPkb1ymGverv4soh2etgqSSVUxAEOh8nHsnhH6ih47uV7AbLVgSmJsyaEbug4zgVlQBvbIZzh15bjN19SvcNHMtNx1MHUZDUeSzxG81XUukPQhSkX8SfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lI2dC3Ci7hjN7hVgsGnbhR+T48h87xYPGO9Ze1xFjHY=;
 b=HwHqqQ28kbese6YO37CykEBA3AuYTapIRoeGyMsRxfSDsy9gGAoyJAI3362ZleGAfMyOFQ7ClPerF8gqsuypaucS7OcSAP80Mh39R63+tyUH2K0bWOUVnRrpqydoEdvf1DIRiPpGcQSWo3VxgIl7zDtvkMRFkrGX/Be53OLhKuJbyHbyWhZ/iOUuq1HSRxsSfdQdEuzIyKQ3cjg3sh0YQvwfxNBeQacX8q5yjmyrXZQopX5ANTfgDmhYyy7HJnHttG8qDTpXzmH9U1qJqKQHkxkBeyItS6VD7aCzm4DmeFuHeNL/LUaVBuk/FQIaR14/GgwyIOfEuAb93vXtVi8jag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lI2dC3Ci7hjN7hVgsGnbhR+T48h87xYPGO9Ze1xFjHY=;
 b=PGBDWcfDGi6eVkwsaIyy/eKdTj2ChyBBW77h0W5lVarPsgMqk6I5OsjnTN+rO0Y/+KRhNL/bMfk0S1bwWV6tBjByb7HYkRaVTOBkDahztMujR9jxMEbYxWKfN55tKPI3bjmh8PUJYIGHRqpgnyV0HDGlfI7lFz7b9g9T2+TQbK8=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6435.eurprd04.prod.outlook.com (2603:10a6:208:176::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Mon, 8 Feb
 2021 15:14:47 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:14:47 +0000
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
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v5 13/15] phylink: introduce phylink_fwnode_phy_connect()
Date:   Mon,  8 Feb 2021 20:42:42 +0530
Message-Id: <20210208151244.16338-14-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0176.apcprd04.prod.outlook.com
 (2603:1096:4:14::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0176.apcprd04.prod.outlook.com (2603:1096:4:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 15:14:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0b2bdebc-4c2a-479b-90fd-08d8cc4445ba
X-MS-TrafficTypeDiagnostic: AM0PR04MB6435:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6435CC6310FA80EE58F6DCDDD28F9@AM0PR04MB6435.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eXAYbbHR8w+hBBCb18aofoti3GlM/4kqCrQHnF++vnBNVGe+17msOdjCmzZj0167K8h+MUw3BPVmBDV6b26J6ngivnpcpItw9wJe5QZYhqXZAYnzfaVUBLaMDT83UxqX5tnpeFSZ/qsLav/N8acKmSMVcpZLyhk2Lt9thrgar4aHNiXlU++Kba6l7ONyE4D1+GWjXz/w3g+MALzNrAiBSHiSSwS/60ACFmr1w5EI/mKmDEEidrr7R/Z8rPr5WWiPwCroaW9WW+FDUt180P640Sk6PXkJrQ5LYzCW1pdcMEDp+CDEMDXpGuQ7sMEM4DxtjT7GREcVo6l7M6vR5J6naNL1AlW0huVvg8RzYJjJOjkoX/ggGYtxIie1GglrlLCXGSGmFoGRYRgVwRD70lGAygNESG7W3KRo6vRyMh7LUjrznLuaNkEhNXqEdkIByxfrGh/9myiKDztLA6TlbyXz2z4CGJyQQ6UYwHSJGlJBkF/oIlsnYxqBQuLVH5s387wy3flkwa1VpUbTqpmlU3uWAR4yIP3P4VBwKeD2HCJby1Axizw8yCggVlo2UM1dVe4+/ji9JqPzF93QtMiHTevzqIGNSsNO1ov/73utew3WOgY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(44832011)(86362001)(6506007)(5660300002)(921005)(8676002)(66946007)(2616005)(66556008)(26005)(66476007)(1076003)(52116002)(316002)(110136005)(186003)(16526019)(8936002)(54906003)(7416002)(55236004)(2906002)(4326008)(478600001)(6512007)(1006002)(956004)(6486002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5iDCgS0PzpQMD73c48f64I7HVRFwaKzbHwFHsepiyJtYAJF7hTm9ngngkGNO?=
 =?us-ascii?Q?s5zani7uR+rkryBAtS7OFALVtxzkLlI57YyBF1CvLIb32FIVfXuOlKFJE0Pp?=
 =?us-ascii?Q?AxUgb9V88aoSVYN+Sa7a+riufeLOsdPVkNWUZYpa/iwTEM+pinZaPLShZHE8?=
 =?us-ascii?Q?C3r3wbYDOXlK94A1r+H7wbdtPD69xd4Jxs2YkFgpfWgNQDIWGTaQPSl+LOVG?=
 =?us-ascii?Q?12hASByeSziCIthgVAdm47/A329HCCejk8FLHBJ9639eAdk6J9p7i7sj5ENv?=
 =?us-ascii?Q?bizE0d+SGsU/MbYf1HBiNPjOWMNarnKAhvakfrxRUvftP3b8nRlcCcgVEnNh?=
 =?us-ascii?Q?QbWCdjdPzuEDmMM0ORCEl0OJiSvvmQgnGcK4FcbRc1msRksIdiVyVQmxJpFn?=
 =?us-ascii?Q?DWtGOTm7XgI55MJsjMsar3FUYP8WW6gAOEtOF7UcR4LD+lOygAes+ZYhjASq?=
 =?us-ascii?Q?zBjLD2aqdxEnqDaDpw4Ss36FaBxl1daOwgRUNKHujrCP21/1OcUp7Hz/ygQb?=
 =?us-ascii?Q?MyRDzPrl8zs6f1rwajn6Xv16dyus24tqkGBwSyBBTYxBkIkBUPqSvNQn2PMJ?=
 =?us-ascii?Q?1GRuhuBpFUozZU8Tyjs+0fqDeb4Ui59xaVrhMWurb2icbR4q2BumA9roy/q8?=
 =?us-ascii?Q?h0lRGlCPPEhaw4tDWzSwc+4IwKb3I+Zvv1KJIK3RMiYJyrisSlvbUXbu0ST5?=
 =?us-ascii?Q?YnZ6lO5aVCqDxB4HnUXYQELeGjYv5O/Eq0lD+dUUFPsD2FVx4g6hTjzPTrcK?=
 =?us-ascii?Q?CELerRIhsxtqDh1OlcKlbahtygj8+nRwmwbQdtQZb/3YQW7cTJNteQf1G1m4?=
 =?us-ascii?Q?84lje0AzDXUHUsMTw92eM1ZUgIh8qeEeWoUYWDSg1AM57CCYssFRI4nkGvTx?=
 =?us-ascii?Q?BNQf9JPoVuvKrw+FXY9CE+xitcC4lClG8pJhyuQPmVoCVPMM77/X0Te3X4/r?=
 =?us-ascii?Q?eWxd/gKh2jiadlhA46/TXz2B6v/4bLvM7VtIUiNAtjQiWZviz05WEaMmTgJr?=
 =?us-ascii?Q?rYZa/WgUsFIaPz1O5ZrspC+fv9hvD0VyparVhyiKwwj/etuSWTqrZaSxr72v?=
 =?us-ascii?Q?4EPsDP4RBFol7WfMNPWGdLN1w5aFgxjU4GKDbQ7bvcNhdLmFSku0jjPXKcT/?=
 =?us-ascii?Q?Eem8p0LlcVVa7bEVVBDeelTs335LHkdzdr5a8hyl2wCuFILuMIwLYnwBDDh0?=
 =?us-ascii?Q?fKsLIjSGf2n2S+7jOdrFsFSWQN525uNDw4w2rNKVlOp1u9wJPtcKhW5LBAKJ?=
 =?us-ascii?Q?u8u68Y/X1xEa/D1pYejAX/we0MLk6DNEIGECxPY9Q8n6fKTYnZ9PrRf3euwZ?=
 =?us-ascii?Q?UjJsss/Ky/mCs0SZisWVHDHN?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b2bdebc-4c2a-479b-90fd-08d8cc4445ba
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:14:47.6560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8b2G1Krwp2tvpzMz9e5QswEBX70ExZehhp8azLchr71le77Hj7XvLKLxrK/+uqg0jhKxRrJ1ftwWkI7Zkv4XcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define phylink_fwnode_phy_connect() to connect phy specified by
a fwnode to a phylink instance.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v5: None
Changes in v4:
- call phy_device_free() before returning

Changes in v3: None
Changes in v2: None

 drivers/net/phy/phylink.c | 56 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 +++
 2 files changed, 59 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 84f6e197f965..5466e1e6272a 100644
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
@@ -1120,6 +1121,61 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
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
+	if (ret) {
+		phy_device_free(phy_dev);
+		return ret;
+	}
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

