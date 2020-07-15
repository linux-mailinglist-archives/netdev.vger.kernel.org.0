Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEA1220820
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 11:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbgGOJEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 05:04:54 -0400
Received: from mail-eopbgr60073.outbound.protection.outlook.com ([40.107.6.73]:41219
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730453AbgGOJEx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 05:04:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcv7AbcSYlFyI04m8vXKM9OW+GpQz+hjVq5zZPR/+S4POiSwfmKuJdGTwTdDffouXvR1RB7AUAqmtqbsOgWHgrmrDNdXvhiQCstW7bV4UteJndLFRvaRaMrg25+DTRB2ntFs8ZYukQl3s/hb7BrxDSPhFqOTXSR8+cf2ZaBB4xCr9kJS3cqAlOB9mXhiQGn06cMNUH7g9B9LChuTahplDcOGDey+lWCp/Q6jSV4dBIB+JeeJY3HzANNuX4JMnUtCEQ5f536XiFKaibTumzB86YrXHmVrJJbVo+WRZzOjz6LgZiCaC+OY/Akwb/sYNzpiPzHo1K9S94v5qn2gkQRDug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sODrw04aGrwduWestRssW7UvryYt3hnrjEEqn4hX1k=;
 b=R2STxK4hrL1C4hRtgRR2jW5wwjw4z98SDSekgVQoRWawIhRj11NL4DDwcgFc+Sr5ncduBx/0iNxMWV3eVPrByQyVxArN/c9fXu7ElzZCqshw4wqPtnnX/hvQJkyWDmUq3d4eo8TzCebtXvhsBhkg0L8Nhv07Z3B0WzIlyfn1EYPMcsGBYpnRaU9LhHXzqKV8H8goRJkvF7ZdkC2VKpfA2TxC/goMf87vqO3cN5oXiX4UkaZi/J9Z9BJuw95R9gDyfRMOVFvo7azgQfjhtowIHEnyn4EB2RdxySy5Y5JB2IIY4qYQWLAr/FMXkE+vOKRDK1dug4sXObJLc+xpQ5XOUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sODrw04aGrwduWestRssW7UvryYt3hnrjEEqn4hX1k=;
 b=Bw4yMHXzGZjWp11BHhHnYOROW6n4EqHnTHfYHcWfUDRCygKEOa4fWkX5+cycj6Tq6iZHbIVAehqu2TS/S2wVS9QvhtOm+z1EQucyyGmM1oOS8qwIBnolOYq7OO6LNsTk8VJWm4Y1KK34WJUEkpG1zp14TWsYsfBwehHRBAhFq9Q=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3763.eurprd04.prod.outlook.com (2603:10a6:208:e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Wed, 15 Jul
 2020 09:04:49 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 09:04:49 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v7 5/6] phylink: introduce phylink_fwnode_phy_connect()
Date:   Wed, 15 Jul 2020 14:33:59 +0530
Message-Id: <20200715090400.4733-6-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0070.apcprd02.prod.outlook.com
 (2603:1096:4:54::34) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0070.apcprd02.prod.outlook.com (2603:1096:4:54::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Wed, 15 Jul 2020 09:04:45 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 647c450f-9360-4950-62a4-08d8289e20ad
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3763:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB37635E77FB4CA93427F4ED9AD27E0@AM0PR0402MB3763.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: juphYzqxgz7pE/h3TgAClHrc+23fEKTDtyrID7/L6F4xRYu9Z+vc1HGEdVckGHg43n09tj3L/TEzeN0T6Dy0722XFBej/Ww+Ktq1aDnX8DnlEThkVMG3U/XpMI2x1NovZnDYcK/j4zMPZenb2RyjkSm80y18Y12U8sSglAPAZicsFWZmNU5xh+sT6Si7cIE9xASnW8urGhXCByE/BDJ8tLqWAR2jjn/au8FvyyFsq7dX/3w4b5yhjPT8+LDjpoFkogEI0Evm2Kp77oK9+wvBPAcOMOnKx8TLDqJ7/wQLWBpXTLS0ymzMXFd5LAUhUViPakUWaT/nHLoocIanPIePHDTKAq6g27iAQTUyH65N1gkoh2aDoqj5NvJErrtQzGJf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(5660300002)(110136005)(2906002)(6512007)(66946007)(6666004)(66476007)(86362001)(1006002)(4326008)(66556008)(52116002)(44832011)(316002)(956004)(26005)(6486002)(2616005)(6636002)(6506007)(55236004)(1076003)(186003)(16526019)(8676002)(8936002)(478600001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WdU/nGdi3z5SLpK+nlDraO14MBf3sD9YxEcmE2OD7JUPNlfQIROOyKlEeB/QR5uhJYDSnYASSW3qPvgGFLZUzyZAELe0pxYjwCGtEZ7GpbUWljyf7h9SSUT7Mm5ZTf+rGUkzT7Zw8Buh5R1xevJ3OzC76H2NDocCcrWGL76dO8rNqUI/ejZYOafqbyMAuedg+AJDSXBRUVFcOXaznCT1Lfr9zMwpS/tv3VeMYKBikFQDJoMXDgDZ47ZJ6dowTvucT+dh8uS7PVJKkTQqygsG0VXFtdOXLRqLbbHzBNAOkrMNWga30hGMUuL0yUdt5kwv+FX/XAi/6DlvoLAX/jJf/DoG3OOoD7DTbLHg1yolWAHWeVMY0tZEZq4r/zgSHW58HbdlMbhahlaORgCogIqIII3pZQudPtxhT876pNzxvFEq94GuTAbVkSwT2aRl2x5u9gL5CoEoYpE2nCcEfO4DDdaxtj0zGo/soQShVjyFDZ6LclMbDAZs9lNY+67I/0IA
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 647c450f-9360-4950-62a4-08d8289e20ad
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 09:04:49.3861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wvBcksVyCXTGNGSLSXmc8mh5RB8ZgqTom9oBNXXGniPU28pUEtIEUGEVj7EAcojhHEWJ+0YmfkCm9rmvorOcOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3763
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define phylink_fwnode_phy_connect() to connect phy specified by
a fwnode to a phylink instance.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

---

Changes in v7:
- assign flags to phy_dev

Changes in v6:
- clean up phylink_fwnode_phy_connect()

Changes in v5:
- return -EINVAL for invalid fwnode

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/phy/phylink.c | 32 ++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 +++
 2 files changed, 35 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index dae6c8b51d7f..ba40d3bfa986 100644
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
@@ -1017,6 +1018,37 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 }
 EXPORT_SYMBOL_GPL(phylink_of_phy_connect);
 
+/**
+ * phylink_fwnode_phy_connect() - connect the PHY specified in the fwnode.
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @fwnode: a pointer to a &struct fwnode_handle.
+ * @flags: PHY-specific flags to communicate to the PHY device driver
+ *
+ * Connect the phy specified @fwnode to the phylink instance specified
+ * by @pl. Actions specified in phylink_connect_phy() will be
+ * performed.
+ *
+ * Returns 0 on success or a negative errno.
+ */
+int phylink_fwnode_phy_connect(struct phylink *pl,
+			       struct fwnode_handle *fwnode,
+			       u32 flags)
+{
+	struct phy_device *phy_dev;
+
+	if (is_of_node(fwnode))
+		return phylink_of_phy_connect(pl, to_of_node(fwnode), flags);
+	if (is_acpi_device_node(fwnode)) {
+		phy_dev = phy_find_by_mdio_handle(fwnode);
+		if (!phy_dev)
+			return -ENODEV;
+		phy_dev->dev_flags |= flags;
+		return phylink_connect_phy(pl, phy_dev);
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(phylink_fwnode_phy_connect);
+
 /**
  * phylink_disconnect_phy() - disconnect any PHY attached to the phylink
  *   instance.
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index b32b8b45421b..b27eed5e49a9 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -368,6 +368,9 @@ void phylink_destroy(struct phylink *);
 
 int phylink_connect_phy(struct phylink *, struct phy_device *);
 int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);
+int phylink_fwnode_phy_connect(struct phylink *pl,
+			       struct fwnode_handle *fwnode,
+			       u32 flags);
 void phylink_disconnect_phy(struct phylink *);
 
 void phylink_mac_change(struct phylink *, bool up);
-- 
2.17.1

