Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF3D21C2EC
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 08:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgGKG4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 02:56:55 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:51726
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728259AbgGKG4y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 02:56:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VgTMCZr1sZsX1nnCkt7O8fW8QGj3uS316rqtCQraaid/BC/Ckhc+0ePZq/etaF1o7rfL3FRyT1ew/EPTFlI5oGnq+dranLjwKL03+u1hghNfM4jh0TQF0C/t52MQ08K8vzzFXlGYSNuAtsazrejyD6IpZQ4x+U4tCmNIM+/1/shwth9dugGqoG4B+EotcK491p0OLMoVOo+k6gzwVNPOGEbr4hfqK4VcuGderc/be9Pg5IY3eyRF3PmlIwsF/5Og+qhyJuPd6L13LivRxtWHKmv9ibYR6wjfn1+FkREhrFHvT4Dp9Tvq+ChqQBiiwTvUa2efZUm30/FGZARVL1zK5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m2IS6AsiEWh85PPUnoRq7b6YyFrYgIiEbKDhahDL3ZU=;
 b=NrynFMNT87JVbyrwly1qf5FtZIPA8cD6heZVyB8srrkWP9TsHrHTuV5KekKxHi++893TOjQ37fth5LblW1NdIVz+trbxJA9fxaZa2kkFKAq7uMV54r9iGoeTw1EqF2IpfUI4A8RnHt56y2BUsr19UpyFdyi8i4DsK4XMP7gENzbuPscqrTxt6r2PY9LGvPZnoY0lf1ElcKYKNFtIB41zP7FbVOv9sqoJdEMH88rc9VBJCGOU9HxnlaPsRrmz+1X5VV6y1KcK0OrVKVT7m3JdH4EIa3P7GLaw0D+fjXf7rRUOlCZ96ks1z1F2qF5ZRlAWetbJg2oixAOMmGh6+fxJLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m2IS6AsiEWh85PPUnoRq7b6YyFrYgIiEbKDhahDL3ZU=;
 b=WLtWcS0fr6ywFooqHsJsBxODLfChtgke5O+EdQ6POxaiU0rIRHlPogD+QwK6QGkjH75qyQRyAMcgIeOYpuRdnjSQInHVI27NUBJcEXh4B8HUKt/LqKBqv8+goiJ8j+LH5nA3I+U4vXLgftE+k7bUx3/js8oVn0hpTiq4DSQRpLE=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6961.eurprd04.prod.outlook.com (2603:10a6:208:180::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Sat, 11 Jul
 2020 06:56:50 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.023; Sat, 11 Jul 2020
 06:56:50 +0000
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
Subject: [net-next PATCH v6 5/6] phylink: introduce phylink_fwnode_phy_connect()
Date:   Sat, 11 Jul 2020 12:25:59 +0530
Message-Id: <20200711065600.9448-6-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200711065600.9448-1-calvin.johnson@oss.nxp.com>
References: <20200711065600.9448-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0132.apcprd06.prod.outlook.com
 (2603:1096:1:1d::34) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0132.apcprd06.prod.outlook.com (2603:1096:1:1d::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Sat, 11 Jul 2020 06:56:47 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b113733f-c376-4388-5167-08d825679630
X-MS-TrafficTypeDiagnostic: AM0PR04MB6961:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB696150544D36B2F64302E2E0D2620@AM0PR04MB6961.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i2QwmbWQ7Rq1DatjWbr3yrE/A3Fbmu44YPL6UglVdgWIftY7s64+Wyco55Zgk/h/QDjS5rwD5XL0attgFWjz2lq88WhK4/Z/I7XNwlrYlONBn8W+avwsUBFCGH0qdM017nfstkIP7TcM0H6RZH+7TFG6NZQhQ8t/duT0nSCWxMhfgQdESHr5EGRYjteqkRU3SqjYX/zhnQcYpXXyfy++Fd2I2L3l0lEaZj7/zaV5ngwN79c2fumeKOxi3y3QolFpsGBOPmjGS1acMt660OJ50AFgGwOORtSNP9oUMM1dzUVbZ8vIBsG/3sa87uv0AaPFEIcjbfAUCpz0pJ/yZAVlLPY192yFdvexEMk91OidionFVBASbcR8+JDVFJWw1kVH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(26005)(6636002)(16526019)(186003)(110136005)(55236004)(66476007)(44832011)(6666004)(66946007)(66556008)(5660300002)(2616005)(8676002)(52116002)(1006002)(6512007)(316002)(6486002)(6506007)(956004)(1076003)(4326008)(2906002)(478600001)(8936002)(86362001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PsEPscP3nsXs7SsWuF2mo0ebW92bHpLqAmlgsUr+yAcSLdJkdQKQ/9/Soz9GjagSYrQh86q5fkTjS15iWY1eYCwNFIO7vE975aKH6FEhjAAM8z1MoZ42kH8LyyiFl/mcll9AQ5vp9rCaZhAb43PnPzrLGaAZoLo5hsw4By/6JDg3qL1rMtKkQ4YMjC1mxROC5WTg4DRizihaLd+fDgcQvnon2wxVh1z++5vQHTWC/QpGYjIIexIqfm8miR9m2Gnq9PmdJOTnPap5GMOQQYwpX0eXOkzVHjenfHtol/1AKTXT1rOAEc2gOJQNsqKXDCqKbm6uxKYGnUEWUSrl7OdtDIl4VRIEBy61txo5OODIDvJRC5dMAh0AocV2FtQYXvaJ8pojvW8YAbWgJuUKP1GjdcvoeQXTA422oEX5P9Rz9LBrht6bwB0l7by/5HrBvwF82LH9r902TUP1HNj4jbZ39TRRpsk5PLEjhdpRiVFPS9U=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b113733f-c376-4388-5167-08d825679630
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2020 06:56:50.6482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0hEe6Q0pRxJUFCRVST6QlU5Y5VqFfBpFm3a6o3sIEWy2huHFiOdsJQDorDQMKKN7MkOohkVmciADX3t1ekBwGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6961
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define phylink_fwnode_phy_connect() to connect phy specified by
a fwnode to a phylink instance.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

Changes in v6:
- clean up phylink_fwnode_phy_connect()

Changes in v5:
- return -EINVAL for invalid fwnode

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/phy/phylink.c | 31 +++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 +++
 2 files changed, 34 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index dae6c8b51d7f..c59a0b8ff349 100644
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
@@ -1017,6 +1018,36 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
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

