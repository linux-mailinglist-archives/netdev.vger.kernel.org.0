Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5270D27EE45
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgI3QFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:05:48 -0400
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:39085
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731063AbgI3QFo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:05:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhWdIkfritXMkDjkbVR29rf2145tzZyBWwQChmkUxjvLZswnKw9txfXaWniHsgVg/rNqBlYa1yTuCHBnlHO8VYzK4V9vGLpV/ZlC5yrg5g+ZFr6lSG/XNvYgQ+YK74l6nerFt+umnbHDR672WyElVLjxA3hLtEXf8NH9C6ez9GsqcTHE4Gm2R8cac+Zf9L4d87vSMbg3YK0KDDWHXn4cICsB1PMZJvjPg/vlPL29CaUNVh5tpWg4NuDB3dL1+9fdza8k+Aaz0txpdHq16ShDGk8uBRIaxBpcEaUaIxvppr4UTdGUKfLTKFZ3BSi3C2wKQX9NOpNxYGrKAu/gZELO0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvuhkCx3lRZ8GvposQdIeMpiQvSYrGhhCoLfujqF/TY=;
 b=cRnhX4qnT34rHOsfJdJ5p42UzDN9iWN2nSeQhYOQvgU8XvyHxdhOeInWQrjkYbBGXb9sDc2tEXZO6GNyAlAQNZKkuqvtDtlL2lmFDB2Vr0vJe3McKKSJSWYUaaUXNh7o5aBavwmNzy5bkL7SIXzvm+eybIG3lZ+lH+3MtxWbIIK+GvjNp2mNNETtaE9H3/d0lBKvU6g870/xkCtd4Byk3yk4NSPGQbRIFdKWFkXW74S053dXRlHRGqO3Z4Ec5ZnINdHuNTqDLDSc+iHKqeOcP81/jYpzFBvqGOBsl7SXSNdDFt3kxU27fDGTvLcT8Y0OHmzIgvjwtDI5ph72YAt7qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvuhkCx3lRZ8GvposQdIeMpiQvSYrGhhCoLfujqF/TY=;
 b=T5OKGQMzk4ByzkAwljqQGo5bHNOR7qou9ojfXYusP5qxAhaqFIreQa1QUWzAbggolCkugltJfyi4LoGgJon5cccxEcSAbQEPCoOjfDKxJ2a0v6mWeBxrZf7fs388jrcXK40cCyPVStEBLUj3mfSzLrM3njtTaOj2jSxmwoxKe+o=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4225.eurprd04.prod.outlook.com (2603:10a6:208:59::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Wed, 30 Sep
 2020 16:05:40 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.032; Wed, 30 Sep 2020
 16:05:40 +0000
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
Subject: [net-next PATCH v1 2/7] net: phy: Introduce phy related fwnode functions
Date:   Wed, 30 Sep 2020 21:34:25 +0530
Message-Id: <20200930160430.7908-3-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0168.apcprd03.prod.outlook.com (2603:1096:4:c9::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.16 via Frontend Transport; Wed, 30 Sep 2020 16:05:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 06c94dc9-82c0-4c1d-7b91-08d8655aad48
X-MS-TrafficTypeDiagnostic: AM0PR04MB4225:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB422537DF4800725B6C6F44FCD2330@AM0PR04MB4225.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KBdusoZ8X5RGhJWYsYdJzvUErZgrJ/Ie0p5OrxgcOyYbxVpb3ZexffViX5AOkU8RuHBrrohGtQolwFwWpVIoIdB2kxAIuPq5QxVHKew4RcasTMN/ZbzFUbpmss57n8w8Gr9Tb8uSL4yyGhl7O0+yo3upPeXbqihpBh3FbwEj5n7p5IEOKDK2qpD2W9PqU4o6YjoCBfNzxG9R8N+N3ux5PuMceO8eC7IG3Oy+AY8b5D3bIptxyyqSE6VNzcsYPCW7T0Spv7xoeNE7frpOqM8dFcTvqLBiO4xejYIfTDz1ABTOylnx2KzVpxAEiSb65ayLiYINyQfoUFKLSNo5HDfo4/2dXFibn/puViS6lFk/rkHhariEUuw4gFo04bHiEkYqbAVVfdkeHXPfRnb2twbgku9PPnxP4odc9OzFZN2TsYXsN1IT/jnpDQ1FO7U5+9C9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(2906002)(8676002)(1076003)(26005)(4326008)(54906003)(6506007)(316002)(478600001)(8936002)(6512007)(55236004)(86362001)(66556008)(66476007)(5660300002)(956004)(52116002)(44832011)(1006002)(6666004)(110136005)(7416002)(2616005)(66946007)(83380400001)(186003)(16526019)(6486002)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vjl1YUh0RzurcNFTEBFBaLiys8NWMzNgMZBQh5eK6UUpEtjWgI1EHa6hpnT+i1aqXfnBW0lpWiWTLEro6D8wFz2jtIysco/85RW8SWXuHuCW6hq/GRT6OTmhqllJkmLtoyT9wpB+X4xIVGltrzPMbYSdL3NfxBdZ2f7fWFnSHuuWj9Ox31Hxq5kPhTv1k57ghiZVeT12aOUDAubDyI1mztbDc9gSwvq6uOkKEsRQiYRcYUvxrLaeTSQyxGZfj9GZGC9rB5PUYiOdTNd82bD9KYB2rexORLdAptZwnotWtv6lZuav+Vdd4SwFw/+9TsPHxb8Ps/i0j/oiePamvI03plFgFz5E8MxGLxdb4fSI/7E3S2c0Zp4ZoYw3Qf1Dbnop5uk15DqV7to+CVju7W2sY7YQOqRxXX2Hz/wFmSbGSTU8CU8bcMdUfWgHF+87KO3xouAx3P+LsqgoSfAdVNFMmjcg/65BU+8L9Jxszhukef5HYLtfsPU3QegE1ZqLupLagtnrRP2F4onxKSYOxgdRYNGiAXNzN2ZE9lWRUtGdkFqbqWWroP2FngDqdwG+24RuzM+/zbKZM7qCF3B+sAvdCjG34ychMTGIXo4fOR+5ZjurG7K2EuARfe06xCCuaBFFKqVg2p6dvexLZJ3G9ZF/ZA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c94dc9-82c0-4c1d-7b91-08d8655aad48
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 16:05:40.3964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ppAQOYJXvQaPpMrD9lRawujuYsgURFs7gSNthpAkhlyR8Rt5oszWNOQbL369uicvPMugFxiuj0ZP0RLRz8tIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4225
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define fwnode_phy_find_device() to iterate an mdiobus and find the
phy device of the provided phy fwnode. Additionally define
device_phy_find_device() to find phy device of provided device.

Define fwnode_get_phy_node() to get phy_node using named reference.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

 drivers/net/phy/phy_device.c | 52 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 20 ++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5dab6be6fc38..c4aec56d0a95 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2818,6 +2818,58 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 	return phydrv->config_intr && phydrv->ack_interrupt;
 }
 
+/**
+ * fwnode_phy_find_device - Find phy_device on the mdiobus for the provided
+ * phy_fwnode.
+ * @phy_fwnode: Pointer to the phy's fwnode.
+ *
+ * If successful, returns a pointer to the phy_device with the embedded
+ * struct device refcount incremented by one, or NULL on failure.
+ */
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
+{
+	struct device *d;
+	struct mdio_device *mdiodev;
+
+	if (!phy_fwnode)
+		return NULL;
+
+	d = bus_find_device_by_fwnode(&mdio_bus_type, phy_fwnode);
+	if (d) {
+		mdiodev = to_mdio_device(d);
+		if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
+			return to_phy_device(d);
+		put_device(d);
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(fwnode_phy_find_device);
+
+/**
+ * device_phy_find_device - For the given device, get the phy_device
+ * @dev: Pointer to the given device
+ *
+ * Refer return conditions of fwnode_phy_find_device().
+ */
+struct phy_device *device_phy_find_device(struct device *dev)
+{
+	return fwnode_phy_find_device(dev_fwnode(dev));
+}
+EXPORT_SYMBOL_GPL(device_phy_find_device);
+
+/**
+ * fwnode_get_phy_node - Get the phy_node using the named reference.
+ * @fwnode: Pointer to fwnode from which phy_node has to be obtained.
+ *
+ * Refer return conditions of fwnode_find_reference().
+ */
+struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
+{
+	return fwnode_find_reference(fwnode, "phy-handle", 0);
+}
+EXPORT_SYMBOL_GPL(fwnode_get_phy_node);
+
 /**
  * phy_probe - probe and init a PHY device
  * @dev: device to probe and init
diff --git a/include/linux/phy.h b/include/linux/phy.h
index eb3cb1a98b45..7b1bf3d46fd3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1378,10 +1378,30 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
+struct phy_device *device_phy_find_device(struct device *dev);
+struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode);
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
 #else
+static inline
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
+{
+	return NULL;
+}
+
+static inline struct phy_device *device_phy_find_device(struct device *dev)
+{
+	return NULL;
+}
+
+static inline
+struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
+{
+	return NULL;
+}
+
 static inline
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 {
-- 
2.17.1

