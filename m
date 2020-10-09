Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8AF28864F
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 11:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733228AbgJIJrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 05:47:49 -0400
Received: from mail-eopbgr130093.outbound.protection.outlook.com ([40.107.13.93]:40325
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725917AbgJIJrs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 05:47:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e79/BeFPI3cX95FAafHFvS0F9yF2t+g3IftE+cx95CM1KYk3Dxv5uW3o6BHc1Zd82xe4uZ2wVkZVvzo2seDGc3DxVNowchNMAbGiaZ3FPDyFvOdO6KWkvbIgVe4xmEsCUZtT9u6vGh5ZyZIUzP4XDpM3Y3H6xZ53bpudmqXSQGDZRrinKCUS7LreasRn34W0nPFgu0hooHJapMnFKFPcgdSJqtnig3h2kfQalI0sR+TinfDbErgHzEnFof8FHT+htlusEYpylmYkoTC46cDyvxtedJacpBBVsZNItliVt4txKg73rewDBPJwzL5WALbr6kaMO+v+tggVT3ye9S1IlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KsSbSryMqVo8vploZbD3HWSqp4g+hYwo1zk7vNoHlG8=;
 b=cixqksox7KudmzZtvSn+zytGI9ka8KlNP+EBh6eSf80CvrZAw9Dt72EKzzJLT7y5RlXRYrVX7skS5HJT+XQZlF3+tSnbxYh3ixS3ZG7JiQxM7YO3k42KiuGqQkQi5GfpZ7kb/NmZCX3k816HB2Mib0a6ZhDZtDANV65ZcNmdwDED05zGhqQoP7llfNMMSIVWcxMDcHBH6DbYEJyF3K1B+UoWJ36AgmzJpLCTJpqfLQRu736VOPce2GPvs8/gVfWVaazAe7OSD5SfFrUZUTT2+xtvwWnx/IppX/FesxlBXyGuVMLCBhsa/WIrT5ceICJjIIBQxReXfQdcr1aD4bOLCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.2.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nokia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nokia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KsSbSryMqVo8vploZbD3HWSqp4g+hYwo1zk7vNoHlG8=;
 b=GLv3j24vd1iSBtJ1j1QFj6IykwxoXpx505E8H2eQSo9AtQLki9AlaThYNKlwmg1Yy0BkXLtgJrq91++aEBZXBRYnjILszMIdjQmS7BvMUrkNyvv0U2Va9KJejQSpgqMuipw+w6kOC/aRZtTFo86bo/1GokpfITwEalrCcxGc0aw=
Received: from DB6PR07CA0172.eurprd07.prod.outlook.com (2603:10a6:6:43::26) by
 VI1PR0701MB2590.eurprd07.prod.outlook.com (2603:10a6:801:11::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11; Fri, 9 Oct
 2020 09:47:44 +0000
Received: from DB5EUR03FT043.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:6:43:cafe::58) by DB6PR07CA0172.outlook.office365.com
 (2603:10a6:6:43::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11 via Frontend
 Transport; Fri, 9 Oct 2020 09:47:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.2.17)
 smtp.mailfrom=nokia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nokia.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia.com designates
 131.228.2.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=131.228.2.17; helo=fihe3nok0735.emea.nsn-net.net;
Received: from fihe3nok0735.emea.nsn-net.net (131.228.2.17) by
 DB5EUR03FT043.mail.protection.outlook.com (10.152.20.236) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.23 via Frontend Transport; Fri, 9 Oct 2020 09:47:44 +0000
Received: from ulegcparamis.emea.nsn-net.net (ulegcparamis.emea.nsn-net.net [10.151.74.146])
        by fihe3nok0735.emea.nsn-net.net (GMO) with ESMTP id 0999lgnY020059;
        Fri, 9 Oct 2020 09:47:42 GMT
From:   Alexander A Sverdlin <alexander.sverdlin@nokia.com>
To:     devel@driverdev.osuosl.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] staging: octeon: repair "fixed-link" support
Date:   Fri,  9 Oct 2020 11:47:39 +0200
Message-Id: <20201009094739.5411-1-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.10.2
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 87eebc71-62a4-4591-a3cf-08d86c385f47
X-MS-TrafficTypeDiagnostic: VI1PR0701MB2590:
X-Microsoft-Antispam-PRVS: <VI1PR0701MB2590701EA6612EE7BCD6285088080@VI1PR0701MB2590.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3CDM2G2oPg8CoWfsmh8SDhRBu9Dg115ZYw1A4PIHj6G3OfyUqHgLpm6IFPv1S/deKJ70+oxNmYD2U5dJtaYqCZlZ9gAmCcauYPHrx9x1O1kf4gDoRhGq2WgTPKrVNdUl/+BetIWWFJTu05VNDt3FRDIijLF/MRkZX5vDlGocRLEKTiMcEKx0InZScPHxJ1BD3MN2a9lDaKShKYkeDQ2AtdG5vrZ0rRMt4FYsFlPkN2cqk9GkqtYg/tRRLV6EKeierpHwbRIp5/U0U2VTCxt0/t2tHYlSfnU6wo16UdJWAl6nuqQRBnhwpqUAGAmjl7n6/d/tx3l9rCJ8LzuW8+ngcstiHZ+tWK4X7gS5t/+PHDV1sCZcykKS3edYpqH2DM0fSUmRWSPXA+6wQ7Np7vC9WM/cq2rhkdH9oEFUjY5Gves=
X-Forefront-Antispam-Report: CIP:131.228.2.17;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fihe3nok0735.emea.nsn-net.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(346002)(136003)(46966005)(34070700002)(8676002)(70586007)(82740400003)(316002)(70206006)(6916009)(36756003)(2906002)(6666004)(47076004)(8936002)(478600001)(1076003)(54906003)(82310400003)(86362001)(81166007)(83380400001)(336012)(26005)(356005)(186003)(5660300002)(4326008)(2616005);DIR:OUT;SFP:1102;
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 09:47:44.4494
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87eebc71-62a4-4591-a3cf-08d86c385f47
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.2.17];Helo=[fihe3nok0735.emea.nsn-net.net]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT043.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2590
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

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

