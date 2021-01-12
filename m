Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9732F3213
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388461AbhALNoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:44:01 -0500
Received: from mail-eopbgr70083.outbound.protection.outlook.com ([40.107.7.83]:38766
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388323AbhALNn6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:43:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjWMj2TkHl5BjAyPWm06PUj96Wl5JHlrOBYqqO49/fb2w/eMS0mW0GAt4VKsfOAtyeu+g42KMIUV9WO6Zg9SJHWotZOFCWK36a9pQKDZRfd49qAx4C47Dv6+IYDcjjHuiJLgePKindoibD0dKpx1HPgrwAWMUC80j1BM64MvbqstFCeWR3Lp/N2h44VCp0s3UsdCgNDRW0qmGlVSNh/MhXy3hl1gU0BbM/JHZXuJ9C8oKBmNtxnEdr/K97RymGn82XEdA5x3C2z1FP+08U64hscSOduC7YFXD84NK5BCZAJQipRAi9M5dguU2+BzhHcsn6hXyEa1RoJfNmIywR45sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ptl58KKlqn7/aQTaIpbfM1YNroxq7pUX0wvLQlVvwkg=;
 b=i2jn/Cup1CDsCagf+5tgiTc9wuEWI+um0D1Zr9XnwpvLybfQBeWuoFkHCmNx6ZeqRsqzFgEDEnLOHq1aHGWpffAlPlk4JlHKy2IpjegfByM1OSlj3z+nJJruChjlQUERHiQz1ESwIAnXD9ATL1nrbiCkmL+JXNB+K5bngZENVtG+p6KHxrNmlHO3MgDgk8mRYFxNR/4XUPpzhcfFHUlG/Xw13TVpTBvc780jSIVDM1OdreTWzGZagZPas9UEiN+Jeg1BPSJnXyGHaDMaun9vrqeGWh42/FehXDrfSWNIooRxyGeAUwjAfBxooLLFpAkrs4h5fGMgV3CuFOcve8le/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ptl58KKlqn7/aQTaIpbfM1YNroxq7pUX0wvLQlVvwkg=;
 b=MV3NOTPt5o1jfhutpa7F+v73ZLnikGZ3XhRZGi87Hwn2Dm7dVG4bc+nfvafkzo0S0FFx/TlBB7N0EuuRMYPF64M7y7G+lf5m84vF8zOA8bZv/5Ezpgz5GBnWmPzfBG7vVpXerbB/daKGR9Mb32Lz3BPB5Dff7Cc+4oHzlttNvKQ=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7937.eurprd04.prod.outlook.com (2603:10a6:20b:248::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 13:43:08 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 13:43:08 +0000
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
Cc:     Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v3 13/15] phylink: introduce phylink_fwnode_phy_connect()
Date:   Tue, 12 Jan 2021 19:10:52 +0530
Message-Id: <20210112134054.342-14-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:3:18::35) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0047.apcprd02.prod.outlook.com (2603:1096:3:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 13:43:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 583250bf-d7fe-4cda-0465-08d8b6ffff33
X-MS-TrafficTypeDiagnostic: AM8PR04MB7937:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB7937005BAC874042E37D4CB7D2AA0@AM8PR04MB7937.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NzHQqq7Z3um0iuFw2B2lAdn9Hcv62h30uCJbjfR3MXBqMYPk6q7Hz3yPDaux15Mj7vCoLYpKbhPrEBf6R8ZAicmIbFk9Y8NJvtYvYH+K1D2HJqiS5KBYNkI7O/pTdaWDHuUxj/bZheqeiXMdCDbts5Ga0EgQGzslvrU5lU3C3o9eJ6257uGD5izdbVpJO5WD7Ch7JssyjAOxcdBT5RJpVDNvYByBimZvyS3QFKe34QmzL3Ow1YIPly6qdrz8un2BIElPwORNvoXO64yrT9EJiJlbM+udkbiPk6p15SUYenMQyAs78Elq9lwFkb+LqNCquISbFlcEhwORglaWd5nhjHGdk1oKPjSs+7hSYJx/kSd6eHUG8FZj7fvB9lqNnxXP7O1j5fwlhlx/9nSu73FojSUmNv0pMDKj5iyxebbNKK1fvkhyJHuysBpv1UU1ZeUIWRDKRRvrkcL4Z96d9zYxgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39850400004)(16526019)(5660300002)(1076003)(86362001)(52116002)(44832011)(66476007)(110136005)(6512007)(55236004)(26005)(186003)(8676002)(66556008)(316002)(8936002)(4326008)(478600001)(921005)(1006002)(6666004)(2616005)(6486002)(54906003)(6506007)(956004)(7416002)(66946007)(2906002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?g45vaXX99LmbWqQd/gHg95kCiV2/B5SxluQ4KmLDbSc4bOOjifDpNgPEPdTD?=
 =?us-ascii?Q?B6sAX0Xg3oeQPTsv1dIfjGU6/QDIIQ16SUfAUhKTfJiQSTqFAa+iQpZV0kQ7?=
 =?us-ascii?Q?Tfv7b/QF70o1xcJBPPFg9Xgunx2nYR6AeFV0Vo7CDeyAtTilbYLhg3DSgBaY?=
 =?us-ascii?Q?mWG3U9MYxaI3mXRuwcNYc1k8KjpJTBqW6iKQqMIZ+qbKgB1dVqhRI24UFFDu?=
 =?us-ascii?Q?RWeVIlCFUuG8pzBDb1KWSriRIPaC/V5y6nohW5iqrS7t1n1Jd97pYJYhoVDw?=
 =?us-ascii?Q?x13q228weap1H/LTKu12CDxgXHn58I35M7n6lItNuw3JqedtLJw1h6aqjXxG?=
 =?us-ascii?Q?GlsMMIFwd9VFR/Xc21Koc2McJrZI+JhZwF3kcbx3kUrB28F5lOZjoJ6nDXo8?=
 =?us-ascii?Q?cZRU/FZiwY9/Gjr+7LxnlJH5DilejlOqHruLOpgmdH5WvMFqYdghLNx0Y/CU?=
 =?us-ascii?Q?oVeoLuLdLHImnSn6LFKaBuMNgm4g53mHi0pAU+dMG+XV9q6iEXTNhi4oq3ru?=
 =?us-ascii?Q?Hzvitw0yL81UsnELkBSH9Rmhcrn9WkjFWoYVhWs/xY39S2sv9MSY4XHd8X9V?=
 =?us-ascii?Q?BIcBmaN0ptJ81pO7rx0pdTwBkuRyOzf3AKCtpi/Cd7jvnXP73NW3c64D+KHX?=
 =?us-ascii?Q?06PcK6XECxckd5O/hw/FRA8bp0ZJX0uK14EiPMDfoxxHxOCifjuvHnzr/9Kt?=
 =?us-ascii?Q?YQblFKcpXaQVoWtZTNXinfe3Q8QZqfwFAmFA8hVDEQLpMaY41HQbrD8IvVIj?=
 =?us-ascii?Q?SXdS++548oCLorJWsDUf9hU1MMFulf+n/b8g+lAGR86uG3pO0eAD1Vl0PydV?=
 =?us-ascii?Q?C1bgkACJux02UCikwTgN+yauh33Qd5IxH4Ra1j+PJZ0rNCsddyi1XcdkUxzO?=
 =?us-ascii?Q?uk+H3cDBGcUEYr9WKVSmMMh2vuz5wmK4t+Mr5CNssKN5WVhSEPTTgk0s3pM1?=
 =?us-ascii?Q?GvsOceAgO4KZMMym9tebP8VUc/h6FA70PXHSAhndlIebHKEcN0XggpZLvbL2?=
 =?us-ascii?Q?hZJj?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 13:43:08.1557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 583250bf-d7fe-4cda-0465-08d8b6ffff33
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Xxdn5TeWvrZE8nOQl25UcGcIOpk6fZle4IJvAT8b4F8PcGU/GZhKwVHDEnz9YvRMPmEyzLgkFVklGsI1ny/lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7937
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define phylink_fwnode_phy_connect() to connect phy specified by
a fwnode to a phylink instance.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v3: None
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

