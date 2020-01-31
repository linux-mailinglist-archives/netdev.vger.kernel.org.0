Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3139A14EFAC
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgAaPfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:35:46 -0500
Received: from mail-eopbgr150074.outbound.protection.outlook.com ([40.107.15.74]:29963
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728922AbgAaPfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 10:35:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PF9O9O3CEXyLCp4GwpxU8XYrPCFBE3X7DC3uMm2NL1oLwf/B0S1eZWPeTTi14wiXFVswuhmVpvS+bQyAtFDnk2Zf8qJMfMfOhFFptJAU85f8HQNSjYeNzHizi/gAEx4mFdeZ0jsjwPcLWxNLy6OB0qJiuVo9n1UvlNCSrGkxv98JA5wRvPBjo+f8lvKE9/V9EFrXdJY12vK0QTn2h5eUxDHHxoRp7Ny9wAYLVQ/YmAwXRkfJxQwFWsNCCxTXjaWmrsdQrSHX+KK6sai+l3itf6/AkQvbdJuKZCJW3ag210d2q2Ki+ljiOa+0zOD/lodvNl6GcjklySiPshr9L6sEfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+uSZvUff1oHm7jKiZZuawMGO9YRsHaKns2/ko5X4D0=;
 b=HMaYINqOhe5VQjNLzBtdz4z69d6Hr5I3zFUcggdLJCexwH4mOrHGSaUDk+da6uoJs7wPg70+llsZ0U0GVuY64Z18LyxcfOFVBqPVjNfI73YForGQzUX2cnPv8kUer9VBvFok016DTESD0rRYMjvioEVG4s2SbsbBNG1LakhXmKjhG7yG9O1SoEvUnyUPjqHMsqkgpj7jghPkbK1MKnFhHcmlTSJefczckrMRnmniYJ0FWOe7LsOxo4nZpY281h/QGnC+PZEoTV4ANASJ9YSmOk7fgs7eNR1gYiXgxBPqAYQ713hVYh9bWjtCWs5EKKoy/imCPFcOArssMjnMQGZrdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+uSZvUff1oHm7jKiZZuawMGO9YRsHaKns2/ko5X4D0=;
 b=NvvooTt1ZTV90cQJc69JCEqs8lizXAECKHDPdRVAaBvkjitK/cXdOZGoAVC+8o/qG09gw+11u8YlBh5ex2zx6PhQogF24irHcs1IRiWElHQpXse909UmKcJTNCrR8/6GVOfo/GBwf3HdyvbXTxv5fqBQbNxtLYyBUACB8Wj2XFI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@nxp.com; 
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com (20.179.10.153) by
 DB8PR04MB6730.eurprd04.prod.outlook.com (20.179.249.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Fri, 31 Jan 2020 15:35:42 +0000
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::e1be:98ef:d81c:1eef]) by DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::e1be:98ef:d81c:1eef%2]) with mapi id 15.20.2686.025; Fri, 31 Jan 2020
 15:35:42 +0000
From:   Calvin Johnson <calvin.johnson@nxp.com>
To:     linux.cj@gmail.com, Jon Nettleton <jon@solid-run.com>,
        linux@armlinux.org.uk, Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Matteo Croce <mcroce@redhat.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 4/7] device property: fwnode_get_phy_mode: Change API to solve int/unit warnings
Date:   Fri, 31 Jan 2020 21:04:37 +0530
Message-Id: <20200131153440.20870-5-calvin.johnson@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200131153440.20870-1-calvin.johnson@nxp.com>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0061.apcprd02.prod.outlook.com
 (2603:1096:4:54::25) To DB8PR04MB5643.eurprd04.prod.outlook.com
 (2603:10a6:10:aa::25)
MIME-Version: 1.0
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0061.apcprd02.prod.outlook.com (2603:1096:4:54::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.29 via Frontend Transport; Fri, 31 Jan 2020 15:35:36 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e730dad7-979f-44fa-b8ac-08d7a6633b18
X-MS-TrafficTypeDiagnostic: DB8PR04MB6730:|DB8PR04MB6730:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB67308D843C1B026FAD0A762693070@DB8PR04MB6730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 029976C540
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(189003)(199004)(52116002)(7696005)(1006002)(66556008)(66476007)(2906002)(66946007)(8676002)(110136005)(55236004)(8936002)(26005)(81156014)(81166006)(316002)(478600001)(54906003)(7416002)(1076003)(36756003)(6636002)(6486002)(186003)(16526019)(5660300002)(956004)(86362001)(44832011)(2616005)(4326008)(110426005)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6730;H:DB8PR04MB5643.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zq+c6PH4MmAKf0hjZpBpickPVbtKuozuvpJ5hfKQrAGyS4MBGCtVXwKe/E4804tp+r0+Mox52lTgg3FsouTIFyx5FriOs1qHA0pOxCWCVYLpNTDbbec/vJcuoJ3r0dmdmLRzcydsbpqe/4SqbyFTEB6Hb+DgNWCIAvuqmpvOYdxoXPH8qE1vtka35iTFKHJ3A5b5onkC9V4FKxN+8INlzrnlCZjwAT7wwgGftNfdNTfJHcAs0HWdXD/R+mV+KUU5WKJx2zgbYbvf622ZII+zDGhMEy8v9/YOeTf3zvgMJ/IaqfYrqqQb81FI0iNQZUSFcWjHbaQlsQ2/Oh51/2y9ofBc9at4xdRyKHxG0BIxwzOdUkIXxEvBk12pZoXtJoxWq8ZQ8cEzZ2hwPVjvqG9PQ0SF2QZwsfNY/Dwq3h728HrT6WPT3g6wA1VukxzczByKr47JfNkT3s0wn3vJ8vldXyOFIycg8e1CgN1sqyqeC+3O1MnyFG3mAMzLWz6fHPmi42QkrUFqjgFV1VbxaxqLvziP2cxpy+jWAnEGv0fseE4=
X-MS-Exchange-AntiSpam-MessageData: u3Dx5rE3cSGQRw8FKBNRU4WjX6uNVxsNSpkoQ3tw4l86m5oh+P2VZewGnyBZM+Pveej/6hK/g44DEnVPlFT35Z4ducCaouDcjdmL0WjCZpPhKIUGQm/a98mJ/m30qpRTg85PqE2xh1VS5Ru8IWfwjg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e730dad7-979f-44fa-b8ac-08d7a6633b18
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2020 15:35:42.1382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: epWicJ7QVEuq+9s3Vs7JZBstYm1xMPH7OzMYSo6cdiCJvgsQHtjDF93neFubWeX1saskI0zhPIt/oby8jcvjCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6730
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

API fwnode_get_phy_mode is modified to follow the changes made by
Commit 0c65b2b90d13c1 ("net: of_get_phy_mode: Change API to solve
int/unit warnings").

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

 drivers/base/property.c                       | 22 ++++++++++++++-----
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  7 +++---
 include/linux/property.h                      |  4 +++-
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 511f6d7acdfe..fdb79033d58f 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -830,16 +830,20 @@ EXPORT_SYMBOL_GPL(device_get_dma_attr);
 /**
  * fwnode_get_phy_mode - Get phy mode for given firmware node
  * @fwnode:	Pointer to the given node
+ * @interface: Pointer to the result
  *
  * The function gets phy interface string from property 'phy-mode' or
- * 'phy-connection-type', and return its index in phy_modes table, or errno in
- * error case.
+ * 'phy-connection-type'. The index in phy_modes table is set in
+ * interface and 0 returned. In case of error interface is set to
+ * PHY_INTERFACE_MODE_NA and an errno is returned, e.g. -ENODEV.
  */
-int fwnode_get_phy_mode(struct fwnode_handle *fwnode)
+int fwnode_get_phy_mode(struct fwnode_handle *fwnode, phy_interface_t *interface)
 {
 	const char *pm;
 	int err, i;
 
+	*interface = PHY_INTERFACE_MODE_NA;
+
 	err = fwnode_property_read_string(fwnode, "phy-mode", &pm);
 	if (err < 0)
 		err = fwnode_property_read_string(fwnode,
@@ -848,8 +852,10 @@ int fwnode_get_phy_mode(struct fwnode_handle *fwnode)
 		return err;
 
 	for (i = 0; i < PHY_INTERFACE_MODE_MAX; i++)
-		if (!strcasecmp(pm, phy_modes(i)))
+		if (!strcasecmp(pm, phy_modes(i))) {
+			*interface = i;
 			return i;
+		}
 
 	return -ENODEV;
 }
@@ -865,7 +871,13 @@ EXPORT_SYMBOL_GPL(fwnode_get_phy_mode);
  */
 int device_get_phy_mode(struct device *dev)
 {
-	return fwnode_get_phy_mode(dev_fwnode(dev));
+	int ret;
+	phy_interface_t phy_mode;
+
+	ret = fwnode_get_phy_mode(dev_fwnode(dev), &phy_mode);
+	if (!ret)
+		ret = phy_mode;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(device_get_phy_mode);
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 14e372cda7f4..00a0350f4da7 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5209,7 +5209,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	unsigned long flags = 0;
 	bool has_tx_irqs;
 	u32 id;
-	int phy_mode;
+	phy_interface_t phy_mode;
 	int err, i;
 
 	has_tx_irqs = mvpp2_port_has_irqs(priv, port_node, &flags);
@@ -5226,10 +5226,9 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	if (!dev)
 		return -ENOMEM;
 
-	phy_mode = fwnode_get_phy_mode(port_fwnode);
-	if (phy_mode < 0) {
+	err = fwnode_get_phy_mode(port_fwnode, &phy_mode);
+	if (err < 0) {
 		dev_err(&pdev->dev, "incorrect phy mode\n");
-		err = phy_mode;
 		goto err_free_netdev;
 	}
 
diff --git a/include/linux/property.h b/include/linux/property.h
index 48335288c2a9..1998f502d2ed 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -13,6 +13,7 @@
 #include <linux/bits.h>
 #include <linux/fwnode.h>
 #include <linux/types.h>
+#include <linux/phy.h>
 
 struct device;
 
@@ -332,7 +333,8 @@ int device_get_phy_mode(struct device *dev);
 
 void *device_get_mac_address(struct device *dev, char *addr, int alen);
 
-int fwnode_get_phy_mode(struct fwnode_handle *fwnode);
+int fwnode_get_phy_mode(struct fwnode_handle *fwnode,
+			phy_interface_t *interface);
 void *fwnode_get_mac_address(struct fwnode_handle *fwnode,
 			     char *addr, int alen);
 struct fwnode_handle *fwnode_graph_get_next_endpoint(
-- 
2.17.1

