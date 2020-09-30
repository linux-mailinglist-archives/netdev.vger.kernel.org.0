Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44F927EE53
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731182AbgI3QGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:06:19 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:11246
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731140AbgI3QGB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:06:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=huJ+t8VQhLwzYVWhimJO0CxNStgAR31Z2YkbTLuDrVLSgKDtJMLvVTpneSzAc0JTayOBscMcIYlRJ5ntQhud4x2coUBmsr7SsEDr2117cj3WKpDKngCWv7074q27R4M9YmBeh7vGk6f3KHF/Nc5OlDthIj5BV8GNRlc9+2cCplgqlB1JgsvEfNfwry0CNmper/U+G2qpUVGUN+SNBx1Er+Z7pOcKwny7KpCL4GNMmFxH4nT0NdZGm7vxSt+GakFvu6fjpsmN22UiGZCyBXMfxpANPT9SbvMEZqlcjGosEu/R0QexrN2mBLIWu+8uP6P1V8zgLwsqSMw6w6BVz51zXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFmMyIB7Zx9V7suMoZ3VxseToPJ27dpe5XUAiZVXv7I=;
 b=lKAohQwjHUJ9xJsgwpmYxbO6j4cJ9GX6LfCNg7F+e3o5S5zItVUAJozb1jr1oVAK19a+ZHd/7gP0hl8QIVAvhQ8r8RZjKiSj/kSUMFrnKGCtuBxHfV3Ap1XTc5KcxHkvxxu6EjzOkB7u50Nvlh8WmronTEq6c7KNZNa0+2XASptNtWs2C2Wg1WGRx0SmCal9PMhw1dhCRQZmg5n8BW3WbLYsk12JA8l7nGa/W0zjJX7GOidB8jA8LwQbSzGUYF8iz9NCol4/OetuvMtZvO9qhdyyKMO+INZfOzax7DV490dX/nLBOmuOImW4LdHsv/D7go6G3XEJPm98WtwZP3gpnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFmMyIB7Zx9V7suMoZ3VxseToPJ27dpe5XUAiZVXv7I=;
 b=J/F8/nV/IymxM9kd4pZtNQJNXJLWFZILkOMgB+/3t9aBDYinxVFXjztoo+KtaDqv/LlWn0mTD2bAj7SkxqjE/el5r3Aj6RTbxXLJQbVGeHvnxSpCLQhLlbLgx1Cs7TyZC5ZWhPDjrlI6z2fw/6eQoDdbkMoCS/OrtJQ5JBiJdao=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4225.eurprd04.prod.outlook.com (2603:10a6:208:59::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Wed, 30 Sep
 2020 16:05:57 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.032; Wed, 30 Sep 2020
 16:05:57 +0000
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
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v1 5/7] phylink: introduce phylink_fwnode_phy_connect()
Date:   Wed, 30 Sep 2020 21:34:28 +0530
Message-Id: <20200930160430.7908-6-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR03CA0168.apcprd03.prod.outlook.com
 (2603:1096:4:c9::23) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0168.apcprd03.prod.outlook.com (2603:1096:4:c9::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.16 via Frontend Transport; Wed, 30 Sep 2020 16:05:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1282ceb7-846f-4094-e0a5-08d8655ab758
X-MS-TrafficTypeDiagnostic: AM0PR04MB4225:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4225DFF641F6B2987C3DCFA4D2330@AM0PR04MB4225.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vyqAg/ozWlInm6T3j8aZTHpYuujDjAsxm9y/n/nJKYwE5gIi5anMjjSuH8BmS8c/wuVhxs9f/uHaEN8FW0LzlBn0/dx1fTnfMfoZpxFyKRN/FYdVbc+0YU7TaRhjWfFcTi3iDzDH0RR0pqK15KVTJOi6CdlfR+/1XizwaBTJv/QQNwZZ8dEKoB783u7AtEVD6vzoRSePduyGVbDdI4Nda6hwuKaDXqqbh23lBzrRD2bIyrofGwXFW5ThAYAqTjnUqU23stnqCcqbEUqGvMrN6rw5suhJ63yPLkwSBDjm0exvCBmTCLL1pi5EfZdCvzWVVNbIiWZkomBa7jj6o/uz1V7Y+pe46Vniu5bsZGXPS/op3zxsYfJcCaNgriXEiW9Z7VAOu0MXaxg3FqyPM2f+QkT7sjKbtxXUCgW8MsnzUMq1rucjJWVPk9Z9ymsJh99C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(2906002)(8676002)(1076003)(26005)(4326008)(54906003)(6506007)(316002)(478600001)(8936002)(6512007)(55236004)(86362001)(66556008)(66476007)(5660300002)(956004)(52116002)(44832011)(1006002)(6666004)(110136005)(7416002)(2616005)(66946007)(186003)(16526019)(6486002)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SXNZHeZ+6pH9ulDd0JHG+eoYx9W6JhJAxVx7n4tVC33J4LBDRNnSmlAHuVu4IXUAAaM9SbGC3oaSdOdTmq+sPkkgNtk8C/I+aEMxCBHE/14xkfYJaO8tdIHPoRVqDwSt+VbinwvtFZcof3KLnNNudRVnhtpwiHQ3uT6LiT5hZqwodcYFNofPqB2ohXGzpDBR5F9eQNxoqqLijiZUAXIWQe8HJfA6TB9GMZDzixvmq6l4RL7TgZDk1K/DYHMtifmgBsdUK9DnGFiCapj8Uj7tBjVlUfS7CpL1xbYIkrsX8fsrfBOsER1WKjZlLXuggjiEoFpPmLmZNsXi4ALSjoBGqmHqA3XSZR9MaGKWJCOc/unAhm6uOjJgEq8Mww+Oj1SLLTI8xzOqrn50OYpCd7RxWqGtUCN06rD9aDgGPDm/8SFjPK5w2IoqCF4WcUUM9ilF7cSuXRq8p4eTjBvc+PwPqBx766qVO05koaEyx0v3qAcDxx9q9HAJk/K2LxCwhQ8XSy3hfbOrpNpOinW5XEdS/Lb1aw3gMZ0ZUA4GDBEKeiK8xqpQfEWDn7jFHLaFpbIulZbEXTfrROlQzCNCuPIGPI9iT8u9Kj0GZJ4Fq0bYGELq/vFKSs3qDEbnjGIzsGawkRAjGSLCMj6vmYJT6XeuAg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1282ceb7-846f-4094-e0a5-08d8655ab758
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 16:05:57.3200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6NllGopYDWmMfjMZLz3UkSQ5v/IZpZ0PXDgrgdS0ltKsXgzu7fpTq1phD5U2e4l0+4G7nff2rr4ruI0CMAWqJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4225
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define phylink_fwnode_phy_connect() to connect phy specified by
a fwnode to a phylink instance.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

 drivers/net/phy/phylink.c | 51 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 +++
 2 files changed, 54 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index fe2296fdda19..ca88bd90d605 100644
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
@@ -1120,6 +1121,56 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
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
+	if (is_of_node(fwnode))
+		return phylink_of_phy_connect(pl, to_of_node(fwnode), flags);
+	if (is_acpi_device_node(fwnode)) {
+		phy_fwnode = fwnode_get_phy_node(fwnode);
+		if (IS_ERR(phy_fwnode)) {
+			if (pl->cfg_link_an_mode == MLO_AN_PHY)
+				return -ENODEV;
+			return 0;
+		}
+
+		phy_dev = fwnode_phy_find_device(phy_fwnode);
+		fwnode_handle_put(phy_fwnode);
+		if (!phy_dev)
+			return -ENODEV;
+
+		ret = phy_attach_direct(pl->netdev, phy_dev, flags,
+					pl->link_interface);
+		if (ret)
+			return ret;
+
+		ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
+		if (ret)
+			phy_detach(phy_dev);
+
+		return ret;
+	}
+
+	return -EINVAL;
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

