Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7ABD2902B8
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 12:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406609AbgJPKTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 06:19:16 -0400
Received: from mail-eopbgr140128.outbound.protection.outlook.com ([40.107.14.128]:24804
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394906AbgJPKTQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 06:19:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5iN53qJUwHj8TZXM2NeSDvEzobVuT+foqJZmT8uAhe++IoDlA6MgGfdrzK6ewIU0o1kVPg1PvMv9sM4J6IjSyrtClGYtWTXMgn43jFQp0vtJtESrRewT5pIqtUqXJaZ6MjdHHNQI2sJWL91/DAo5+WeY/PiEnhsTc+Y+3WDLTAZKSm8F5mXKkK3mSIpDFwh7cdU2eKV9cSzuo+sqpd3hYVwepXr/3U1W07dEqUa5l32XSpvVYmPtz+kR7s7hNRPeTyWK3fGk7+OykK1o17jBwkCx5n67EjkRC7ctzzraTvuzq4+JJWCTYhNzXvKo9AzVeMpueShj2i82yAqR6C6Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WdYuffyT8QYDXExzgPNCq0pbhVmnFRw4KpJc84GCww=;
 b=SHPhb8tvXP9kD1VPiLVNPN7xn5z26Ipt18Q1eQk31pC45bA5NHYyyszybp2KwGF3XFl34BvTIv0L7Yqn3js/zQ7oKjuq9woNL6pI0WHhtMqUw8zlxm5lp8dBWvQBm9a8mJz5/y84SI4V5p/x6lNaq/TGClZxqpibAerrvhe/iQ/A7s8hI3jy643Ii142YRRF6pfZ0yDv9ZfxgrFco8qwrmgdG3vVKU+ezuutiH1yXyhAhMDKHhtAmKNagOg6V21H+JnQQRQWGN5Q/5whaFBLKA1il8IGdJRHvSR94ZjRu5spGyGKYvSVvQMNAiC5Rslbdja+Oo+/Ma/S82KP3R0ocA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.2.8) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nokia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nokia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WdYuffyT8QYDXExzgPNCq0pbhVmnFRw4KpJc84GCww=;
 b=nfsdrrNv2qx1ny8JVUTQScto0fF+bU8PguRdYmkZploEZOSXoIeCejrgBXTIo/048bujp2z1psbmSeuojagkwSf6xuIXEseeCyCdF+wNv+ZBnRNElT99RiclIYVN7T972DwyZfBJlTn3lrE6cZL/v2+rUcHRJYbASNWL94hdiyo=
Received: from AM5PR0201CA0015.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::25) by VI1PR07MB5245.eurprd07.prod.outlook.com
 (2603:10a6:803:b0::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.4; Fri, 16 Oct
 2020 10:19:09 +0000
Received: from VE1EUR03FT064.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:3d:cafe::53) by AM5PR0201CA0015.outlook.office365.com
 (2603:10a6:203:3d::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.23 via Frontend
 Transport; Fri, 16 Oct 2020 10:19:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.2.8)
 smtp.mailfrom=nokia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nokia.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia.com designates
 131.228.2.8 as permitted sender) receiver=protection.outlook.com;
 client-ip=131.228.2.8; helo=fihe3nok0734.emea.nsn-net.net;
Received: from fihe3nok0734.emea.nsn-net.net (131.228.2.8) by
 VE1EUR03FT064.mail.protection.outlook.com (10.152.19.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.21 via Frontend Transport; Fri, 16 Oct 2020 10:19:09 +0000
Received: from ulegcparamis.emea.nsn-net.net (ulegcparamis.emea.nsn-net.net [10.151.74.146])
        by fihe3nok0734.emea.nsn-net.net (GMO) with ESMTP id 09GAJ3nX002276;
        Fri, 16 Oct 2020 10:19:04 GMT
From:   Alexander A Sverdlin <alexander.sverdlin@nokia.com>
To:     devel@driverdev.osuosl.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v2 net] staging: octeon: repair "fixed-link" support
Date:   Fri, 16 Oct 2020 12:18:57 +0200
Message-Id: <20201016101858.11374-1-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.10.2
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 345fc4b2-7530-4d08-26a3-08d871bceb89
X-MS-TrafficTypeDiagnostic: VI1PR07MB5245:
X-Microsoft-Antispam-PRVS: <VI1PR07MB52451F5F1D688FFD6E51664588030@VI1PR07MB5245.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NdwFFYJj2pzQ86/u3dQGGW0KBHdVS8yog0TvKsBm0OaC8TKd9wJv3k80lhBo6K99cONbZ4oJHFXuZn0i9zc1zsFHQU1zemfGoD/0WycabC2JE/8kkFT7yNl7hJ/xzv4lGZvLX8z1T199BO20ZGseLnHPe/5qcbaMJt5Kn1bQ13KJsPCoRioAVAVDDSakm4k1lH4Ht/Z9jOMbZciUikw/F4kYgtf3u+pBZ6BcH8enkcr6MQ4xY6x6tOH+wH/Ya+bho6jg6TVRzfNR6BVcqxS04hTHtQV7GJEBlEdj4yfO0oQrD8nxVGiPTbvGmbS1I6oWcqD+MA1Kc6lgxxTc6Hd2XQ4SSrtdlsp3nFkhsEhL6MhbbrKeCDJwSay0Zrg1Psn4omTguOj3Bu0gIPItUl0i2a8fKzU3SXDAq4LZjx6SRjjWp0Ybj78fB/uxoedksGx3
X-Forefront-Antispam-Report: CIP:131.228.2.8;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fihe3nok0734.emea.nsn-net.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(136003)(46966005)(336012)(70206006)(70586007)(6916009)(2616005)(86362001)(1076003)(83380400001)(356005)(54906003)(81166007)(186003)(478600001)(36756003)(8676002)(82740400003)(2906002)(6666004)(47076004)(82310400003)(5660300002)(34020700004)(316002)(4326008)(8936002)(26005);DIR:OUT;SFP:1102;
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2020 10:19:09.1310
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 345fc4b2-7530-4d08-26a3-08d871bceb89
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.2.8];Helo=[fihe3nok0734.emea.nsn-net.net]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT064.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB5245
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

The PHYs must be registered once in device probe function, not in device
open callback because it's only possible to register them once.

Fixes: a25e278020 ("staging: octeon: support fixed-link phys")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 drivers/staging/octeon/ethernet-mdio.c | 6 ------
 drivers/staging/octeon/ethernet.c      | 9 +++++++++
 2 files changed, 9 insertions(+), 6 deletions(-)

Changes in v2:
- removed the usage of non-upstream local variable "r"

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
index 204f0b1..5dea6e9 100644
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
@@ -892,6 +893,14 @@ static int cvm_oct_probe(struct platform_device *pdev)
 				break;
 			}
 
+			if (priv->of_node && of_phy_is_fixed_link(priv->of_node)) {
+				if (of_phy_register_fixed_link(priv->of_node)) {
+					netdev_err(dev, "Failed to register fixed link for interface %d, port %d\n",
+						   interface, priv->port);
+					dev->netdev_ops = NULL;
+				}
+			}
+
 			if (!dev->netdev_ops) {
 				free_netdev(dev);
 			} else if (register_netdev(dev) < 0) {
-- 
2.10.2

