Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE15B288649
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 11:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733204AbgJIJqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 05:46:17 -0400
Received: from mail-eopbgr80117.outbound.protection.outlook.com ([40.107.8.117]:55460
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725917AbgJIJqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 05:46:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8ix2XARI1yLltZxMDtLbeZ/MgRu9eivfB+Q2yUk+RcQ3qBgED2hDG9ye79z4PkuSKRlEae+xkowR5YCzcOumzXI2Z8aqIkFAG1WCaBCvGUSHI5xVwFejgWQ/dN1NLWH/j7YvUPyaLKysLTM7NkZl4pVKl+OVDYUvP+txb+atnWtrBs3LW4rU1qSSeytaJoafRXQpB7aKoF87NFCzdhPQlrVsXZecWgSzxHYCWcRW+s6VaSk5gR/23M+FDCXUYylWgQjAVY2qIZomVuXvnXoE7/l43Wkxk7ldku1bMVfDmt5aeEDOyxuQ9w+tR6MdnUKu6BX7tSN9PXbCcd2fvxQEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hTGct9NfTfqekI72imnJjQuSgWPNuveVYv5BAhdOYLs=;
 b=Xy/XxZkzk/uq2nekndhT3TIvnEEQBAX2tZ7g0ex0whtJryxQx1R6OOBU18KQdDDzg5CogBJlUyCoMp5Rs2l/YxG2iMIxfvb/IXgfKspnOEyVs/SHUh9nyAAVkGxbV4QZaBqz6RuVPq9SFmfxaW/zTNIb0A3EZGW8tRevPB0dswtee3K8FpTPRqGQfO6PzGU+7h94ubLXnmc3pM3/M7eMuhHcQ3uqHrKP89ER26Vx4ZS5oihH4tYLGOGx8+IwPpTCZMhR53ct6kuuONPHJDwK0WLGqjQ/56//ncpT4+Dr0tEva5dGQAn1aVs6TOON7vX59iD7wbvpZ7DOfoO7m8EARA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.2.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nokia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nokia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hTGct9NfTfqekI72imnJjQuSgWPNuveVYv5BAhdOYLs=;
 b=gQ+TychrMWeP/CEfgj65x5k/FBI3SEjwDAFr8QZb9827cm1VrR9rUtu5oxe3xSUH/WkBJmC/6wfuq1QR6SzqJbr8UFVNBemDmxM1bC0lBsL5tf9RME+96zSl5vhQQq25vHt+wi1mY+Eca9kyNyVdNo853Nd6y8TLpsuXFBdL+Yg=
Received: from MR2P264CA0057.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:31::21)
 by AM6PR07MB4742.eurprd07.prod.outlook.com (2603:10a6:20b:19::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.13; Fri, 9 Oct
 2020 09:46:13 +0000
Received: from VE1EUR03FT037.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:500:31:cafe::c4) by MR2P264CA0057.outlook.office365.com
 (2603:10a6:500:31::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend
 Transport; Fri, 9 Oct 2020 09:46:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.2.17)
 smtp.mailfrom=nokia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nokia.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia.com designates
 131.228.2.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=131.228.2.17; helo=fihe3nok0735.emea.nsn-net.net;
Received: from fihe3nok0735.emea.nsn-net.net (131.228.2.17) by
 VE1EUR03FT037.mail.protection.outlook.com (10.152.19.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.23 via Frontend Transport; Fri, 9 Oct 2020 09:46:12 +0000
Received: from ulegcparamis.emea.nsn-net.net (ulegcparamis.emea.nsn-net.net [10.151.74.146])
        by fihe3nok0735.emea.nsn-net.net (GMO) with ESMTP id 0999k8bs018069;
        Fri, 9 Oct 2020 09:46:09 GMT
From:   Alexander A Sverdlin <alexander.sverdlin@nokia.com>
To:     devel@driverdev.osuosl.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>
Subject: [PATCH] staging: octeon: repair "fixed-link" support
Date:   Fri,  9 Oct 2020 11:46:04 +0200
Message-Id: <20201009094605.1525-1-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.10.2
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 6e51d3f1-b7cc-4889-53af-08d86c3828c7
X-MS-TrafficTypeDiagnostic: AM6PR07MB4742:
X-Microsoft-Antispam-PRVS: <AM6PR07MB4742E60F05EB90D292247C4B88080@AM6PR07MB4742.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SLNHDul+DalBS5wM8ZUbEJkHxRDTvec15CgFZMdMkvSzCYHArmAnFDRzrum9Tt9C7nzNVOl0zcaixxIUQ0CY5B/twaz30B6tb00jIsa0eH4IUY/SW1hdGGcgWM2TncShsIUKb/GKpJV4mi2rTl/vDxmZ0r5CeFf7kDXZmVRlAzAQSXIP+etwGq5e69klIsvnpAXqqzOxIcVNU2605YrH+0Z2EiFoBaHNrF7phP8z3fto5tpfPaO/JRmp9X6KMHzodfv9lODOKLHTDYUOjy95hxspiECSS5KNZlo4ETpElFdA4SM6Fk45kVGurRomsuQ7ALzQSF66u58a/ChjfXmpJPpAmLB4KKlfa6lsjSKA3oPo61jBL6nV0nZxMFA8yTNSSUOHl0lSVFrcxMge+ynQlNauhBj6ktyM3lKr3sWSRM4=
X-Forefront-Antispam-Report: CIP:131.228.2.17;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fihe3nok0735.emea.nsn-net.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(396003)(346002)(46966005)(54906003)(6916009)(82740400003)(70206006)(356005)(81166007)(107886003)(36756003)(6666004)(5660300002)(47076004)(1076003)(8676002)(70586007)(26005)(82310400003)(2616005)(86362001)(2906002)(8936002)(336012)(186003)(478600001)(83380400001)(4326008)(316002)(34070700002);DIR:OUT;SFP:1102;
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 09:46:12.9995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e51d3f1-b7cc-4889-53af-08d86c3828c7
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.2.17];Helo=[fihe3nok0735.emea.nsn-net.net]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT037.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR07MB4742
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nsn.com>

The PHYs must be registered once in device probe function, not in device
open callback because it's only possible to register them once.

Fixes: a25e278020 ("staging: octeon: support fixed-link phys")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 drivers/staging/octeon/ethernet-mdio.c |  6 ------
 drivers/staging/octeon/ethernet.c      | 10 ++++++++++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-mdio.c b/drivers/staging/octeon/ethernet-mdio.c
index cfb673a..0bf54584 100644
--- a/drivers/staging/octeon/ethernet-mdio.c
+++ b/drivers/staging/octeon/ethernet-mdio.c
@@ -147,12 +147,6 @@ int cvm_oct_phy_setup_device(struct net_device *dev)
 
 	phy_node = of_parse_phandle(priv->of_node, "phy-handle", 0);
 	if (!phy_node && of_phy_is_fixed_link(priv->of_node)) {
-		int rc;
-
-		rc = of_phy_register_fixed_link(priv->of_node);
-		if (rc)
-			return rc;
-
 		phy_node = of_node_get(priv->of_node);
 	}
 	if (!phy_node)
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index 204f0b1..2b0d05d 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -13,6 +13,7 @@
 #include <linux/phy.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
+#include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
@@ -892,6 +893,15 @@ static int cvm_oct_probe(struct platform_device *pdev)
 				break;
 			}
 
+			if (priv->of_node && of_phy_is_fixed_link(priv->of_node)) {
+				r = of_phy_register_fixed_link(priv->of_node);
+				if (r) {
+					netdev_err(dev, "Failed to register fixed link for interface %d, port %d\n",
+						   interface, priv->ipd_port);
+					dev->netdev_ops = NULL;
+				}
+			}
+
 			if (!dev->netdev_ops) {
 				free_netdev(dev);
 			} else if (register_netdev(dev) < 0) {
-- 
2.10.2

