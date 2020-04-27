Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1685E1BA49D
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgD0NZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:25:27 -0400
Received: from mail-db8eur05on2049.outbound.protection.outlook.com ([40.107.20.49]:33848
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726721AbgD0NZY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:25:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H6AW5Rbur9wMTA5/vl+494E/WOH5z8iu1cJdiURpGWRlhPMolJ/8MVAnddW6FvOd51qLzRIieLSxUgmOZSl2tq+UrSHdOgwfo1d1rtayb7XHYPNsRT8Xz77ZgwdcU4qEFqbqWVw+fGBMm0KZmYKa0ZNbLwADSGwMAISsNInUXpH/TQ15RANgs8Qw93TQP0WhJSCbmtnj2baRpA5rctTI34a4g2KORj4+XxZ9GKiDoyrZzbO3u3w5bmj6gj4j+ISDhMJSCK5U7sCqzbylQV2Zi2gCL7MU06HQtVkiHWzZ1cXfuamM8lEgiUKuK28eQu41DVyyYTD+OYX72ywVVpKNOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Smyu2QabomlLWNqAG8Ri/BK1/sj7FPm9Ho7QY16gSTo=;
 b=R8A7YDVI/4UGBSZ7Nh8fiZkgH0/t1u5XwJqNHBdsjtJRxhh3IN5Mm0iL7nqZ2qOxJMCLP00DVRLUnuwt/2CJj5fna28B7S1RQ4CceM2EWQXMzoYvE7/tQ8r9do08KaCoWZpWmMzhkZ52t6ZufjUhFAmjPJxMMapM4Z8f7pAESAVUWsETdQRrJlqzUnGXVZHZwB9vZcVDL3sk0FNScA0iJ+2uGCSaGPCv6QTxSgxXbx3CLBxtwf7Aptad9kJKO9bmatUIGp7rHRK6E4tydW53yRwVWocGTC6jtnnd3uCJHCffwoXgEaGIcTkV99Q2oSLpZhbUoT49avMAwgFGk6eZ3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Smyu2QabomlLWNqAG8Ri/BK1/sj7FPm9Ho7QY16gSTo=;
 b=T/sxI6U8iTJFq5kePfcu/1JoHXT6YohG0Lz6dg98DLR6tK95y0l6BHZGXd8C3iuZulnG2wvmWD4FIRqWUHjMhlitV1YTILbVYdZvErjX4qgOx7WyiKyTC01r4K7qxfsagG5uU/A3qx1Gvfs4XFYCPWGD1tB2YHtFaqQA6w6qe2o=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6867.eurprd04.prod.outlook.com (2603:10a6:208:182::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 13:25:18 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 13:25:18 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>, linux-kernel@vger.kernel.org,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [net-next PATCH v2 3/3] phylink: Introduce phylink_fwnode_phy_connect()
Date:   Mon, 27 Apr 2020 18:54:09 +0530
Message-Id: <20200427132409.23664-4-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200427132409.23664-1-calvin.johnson@oss.nxp.com>
References: <20200427132409.23664-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0191.apcprd04.prod.outlook.com
 (2603:1096:4:14::29) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0191.apcprd04.prod.outlook.com (2603:1096:4:14::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:25:13 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d757c344-9949-46bb-b21b-08d7eaae6df9
X-MS-TrafficTypeDiagnostic: AM0PR04MB6867:|AM0PR04MB6867:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6867201919B62115D69764E0D2AF0@AM0PR04MB6867.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(86362001)(8936002)(44832011)(2906002)(478600001)(66476007)(81156014)(66556008)(5660300002)(1076003)(66946007)(8676002)(26005)(7416002)(6506007)(2616005)(956004)(6512007)(4326008)(16526019)(110136005)(52116002)(6486002)(186003)(6666004)(316002)(1006002)(54906003)(55236004)(110426005)(921003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tcZ5J0LKf3JjBcGqfhuVFgy+roLgkwJwRtL2YfCwbAhrRAMk8UxheMzFbHEE6fcc9SGvDm/AFGUuybPsMkx/JsOqcmZSi25l87BPADx/I1RVMurb3U/sHvJBMwnbnzOKDb+ZQ9/AdXCDG05ih4QFxKdohH1lr8uCLtUCnv8oUyGsYXKiY19FOJ+eWisgVEg4aVj+I9xeoNEKEofuDMBhrJjgRmhtCukH+AUcvaP/Y5AFdIFvt/yUfhVvN8TznS6XK1CAcJTx2TQQcJMv5+1SAJAs+XcfxPsGxWPCrb2NYD7MM3Sd78xXgXpZdp+fcrEHoFJeRqegVE4NGFvd/Qv/8uolLOlIx1c/dTyYu+y/W46jPrRaPSb+zOyaz+v0n3wbENuTCaoC2jqoWI5qUdsM8iC9H9AG/jXwxsU1vZ0aCeMkts88xW7QKVgSc7GNuLyN2pPvF8UCMJQ0F8bKP8BjbREpgu2UoG9/TImVuzZwMuwE/3A7op8z/Ntf42pQly7TNLRAhc6Ju+zcUFsJBipSaA==
X-MS-Exchange-AntiSpam-MessageData: cryWS9kb44KTNLxKSaIkQ4fL0o9e06RE2XdtzBxv/ItTiA4TE36oDZ0smCV8hFI3ZIs85oFUd0BBo46UV5tAk7NCz65ZrpCUZpTsnpSDa35p1wgkM7g9IApI0iM6aM4Cu9WfTC2taSyPhUVvFP2sJbgWxXHsdTifxnWXVS6HXeM9Ntij6xVYfS8KGjZH4G1C87z6PF5CYaEXSBcEQ6QqqjaY/UYjMqI2d3H6khBUJtKEen5JjTtm7HV3pfcXRcQEKbt3K4KkEJ/awqNLzxILbkjFxk/hnUOjkDxjY1ILlN9xTUwA+teYf3HCMlnD1JfETAwFs/nvRhJd+HTCl98+MJaaJa4Cs76oTgb2hCTTnFMuFPJk+h33DFRD2bJetFfmZ0BU8m2nnrXhNEa3YyJ3HSWaaNfX4JsLFsL0WMbzmfhEp706uGYIvBWuw7OVuUxgsYl13lhn1glQkIhkJLBa3ta6dyekiHU0WA5GNcgNZj4fXQuW4YqQgVpbV9nrvI8KHWZj0aXhdaUGZZGeT7hwIdl4D2BOA0Z1z4n/j63T+UMOQMlhb/WuvDAr3IxuQcrJXB6EnWhGLwbTwcjQdAzH1z4Y4yw6PH8fmwmsUIM2fgYCzBxdAzAtlaJq/eYdMhjNAAvNudigELCctKfsGSZ+nYQ5CpsD41/2hVxykAKCP4uhawapWdiGhhF51LS2Y6Y9ruuI+07qQnaDCITjaX+migPahbkAMsX6UXTHipAA2XpCYxjxVQ1NorUPK0qesxRGz7H1rHi+kod+LvDb6r7nYAbGJ6EOtwkehfE+3t5quB0=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d757c344-9949-46bb-b21b-08d7eaae6df9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:25:18.8043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wIP2sQqOmPMRcyGdMTNUVhL9i+FMG7/RCEJoHfMB8U9U0USRcpuwURhECdRsNPvCB0ERmgoNXB2P/k2ccsY+3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6867
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define phylink_fwnode_phy_connect() to connect phy specified by
a fwnode to a phylink instance. Additionally,
phylink_device_phy_connect() is defined to connect phy specified
by a device to a phylink instance.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2:
  replace of_ and acpi_ code with generic fwnode to get phy-handle.

 drivers/net/phy/phylink.c | 68 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  6 ++++
 2 files changed, 74 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 0f23bec431c1..5eab1eadded7 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -961,6 +961,74 @@ int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
 }
 EXPORT_SYMBOL_GPL(phylink_connect_phy);
 
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
+	struct fwnode_handle *phy_fwnode;
+	struct phy_device *phy_dev;
+	int ret = 0;
+
+	/* Fixed links and 802.3z are handled without needing a PHY */
+	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
+	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
+	     phy_interface_mode_is_8023z(pl->link_interface)))
+		return 0;
+
+	phy_fwnode = fwnode_get_phy_node(fwnode);
+	if ((IS_ERR_OR_NULL(phy_fwnode)) && (pl->cfg_link_an_mode == MLO_AN_PHY))
+		return -ENODEV;
+
+	phy_dev = fwnode_phy_find_device(phy_fwnode);
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
+/**
+ * phylink_device_phy_connect() - connect the PHY specified by the device.
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @dev: a pointer to a &struct device.
+ * @flags: PHY-specific flags to communicate to the PHY device driver
+ *
+ * Connect the phy specified by the device to the phylink instance specified
+ * by @pl. Actions specified in phylink_connect_phy() will be
+ * performed.
+ *
+ * Returns 0 on success or a negative errno.
+ */
+int phylink_device_phy_connect(struct phylink *pl,
+			       struct device *dev,
+			       u32 flags)
+{
+	return phylink_fwnode_phy_connect(pl, dev_fwnode(dev), flags);
+}
+EXPORT_SYMBOL_GPL(phylink_device_phy_connect);
+
 /**
  * phylink_of_phy_connect() - connect the PHY specified in the DT mode.
  * @pl: a pointer to a &struct phylink returned from phylink_create()
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index cc5b452a184e..c2bd0ee9dd9c 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -367,6 +367,12 @@ void phylink_add_pcs(struct phylink *, const struct phylink_pcs_ops *ops);
 void phylink_destroy(struct phylink *);
 
 int phylink_connect_phy(struct phylink *, struct phy_device *);
+int phylink_fwnode_phy_connect(struct phylink *pl,
+			       struct fwnode_handle *fwnode,
+			       u32 flags);
+int phylink_device_phy_connect(struct phylink *pl,
+			       struct device *dev,
+			       u32 flags);
 int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);
 void phylink_disconnect_phy(struct phylink *);
 
-- 
2.17.1

