Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 188B414EFB0
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgAaPgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:36:07 -0500
Received: from mail-eopbgr150074.outbound.protection.outlook.com ([40.107.15.74]:17057
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728922AbgAaPgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 10:36:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAORbJDUuSzbBg7QJHhcmWCHFS2TApB8zlM7w62RWlhaYdgP2XUGtRggsbjk3hUoGN0reqMSXwvdlSTzvBxsJ8+od/Jwp9DB4NJQwCTHxrCcodGX22c6IXs1trJWOepBVurXWs9bssASaJKyaSEg9oteX6XQJwUyMmgPAPP9U4Y7xamhibuZQ5P2Yp2apAWU9QZrNpYRVqD6/Uh1v2YnylfnASKvvMGewUcSeDidsdUOmkjRjoXy1bVmr/+OuGcgS0BgDc7Pm5XAxXCOUFYatZrF/5yO+0ISKSgbXP1rpqLZvQNxtq/LUbschJSa9cv4AlQlB8QGbGLDwrSAtOfQEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZePI2LWmim/vlpE/5g2V7+bbouRlLEU0BZGBIzWusc=;
 b=n4Ss+409tcOBqowONhM+oNGa6eEvIoEmHb33yHFXtkt47STGO2dYgVKnL0OLC8GaV0/TKIBA6ZgvL97b3cnTrUpW2YykzAPSIS/3hTeQNgbP4C7PPats13oKQjYYosX2uGHEOCfi2IwhMA1WkcKdS471Dj/oRzz5c1MNb8wUJD4LjYrx3OCrEIpGbPEMa2DLA3MYvWKYS6G1zR5oLSA+xq+BhO1jL8oN2FxSYMrr5jnpy6+7YBhfMM7IxDfJxBhJiw34aLzosj1Cff9G3K/BHtLXkYSRj3ii3kRm4+nmiDQoFyIdLbfFRDONy6odjBYH5DcihOoMO1zgDtbw53PjSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZePI2LWmim/vlpE/5g2V7+bbouRlLEU0BZGBIzWusc=;
 b=h2seiSOMKbky4FbaCSVCSqHAlZHgrldmFz2Rix4D5EI0m7QeS7akDTzyNdjHEbU4lBvEUOC1gxWBpQapsuzoZX4dWb8CyGOoB0VL/dVl+XCV0qPjvXodm3j+/G2zgMPM0YOdX2+dqFeZ8okQfVQNGklO0l8QXtuzP9W4w7L7374=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@nxp.com; 
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com (20.179.10.153) by
 DB8PR04MB6730.eurprd04.prod.outlook.com (20.179.249.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Fri, 31 Jan 2020 15:35:51 +0000
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::e1be:98ef:d81c:1eef]) by DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::e1be:98ef:d81c:1eef%2]) with mapi id 15.20.2686.025; Fri, 31 Jan 2020
 15:35:51 +0000
From:   Calvin Johnson <calvin.johnson@nxp.com>
To:     linux.cj@gmail.com, Jon Nettleton <jon@solid-run.com>,
        linux@armlinux.org.uk, Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 6/7] net: phylink: Introduce phylink_fwnode_phy_connect()
Date:   Fri, 31 Jan 2020 21:04:39 +0530
Message-Id: <20200131153440.20870-7-calvin.johnson@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200131153440.20870-1-calvin.johnson@nxp.com>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0061.apcprd02.prod.outlook.com
 (2603:1096:4:54::25) To DB8PR04MB5643.eurprd04.prod.outlook.com
 (2603:10a6:10:aa::25)
MIME-Version: 1.0
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0061.apcprd02.prod.outlook.com (2603:1096:4:54::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.29 via Frontend Transport; Fri, 31 Jan 2020 15:35:47 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8d47e552-2543-4fc1-6ec6-08d7a66340be
X-MS-TrafficTypeDiagnostic: DB8PR04MB6730:|DB8PR04MB6730:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB67308569F850EBE8BDA8740D93070@DB8PR04MB6730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 029976C540
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(189003)(199004)(52116002)(7696005)(1006002)(66556008)(66476007)(2906002)(66946007)(8676002)(110136005)(55236004)(8936002)(26005)(81156014)(81166006)(316002)(6666004)(478600001)(54906003)(1076003)(36756003)(6636002)(6486002)(186003)(16526019)(5660300002)(956004)(86362001)(44832011)(2616005)(4326008)(110426005)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6730;H:DB8PR04MB5643.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OKjZqpX145W4eb8SaNoDGIFqplJkxSBXsRBEljujDfaz6zcVED6eGxDo4P2SPFNe5dWMqkuJAcgwKmRd6kvUyeXAT3qD77F8A3BmvdzR+QUDtN2wunwylTkdsWfYRdKR9l8oaWF54cWctfEhcaJQnwLxi1KEt+O2cdGXVL9yagP/JTgEbpRJHMJXlgu9LtW5aRZgTi/vIxHugRSEGOeDj8G130xZMTOkOmV+9GZQlGV45N38Bep6mlycda2BjVqFUrR6YiR+qWUOYnUMUsJ9W3Pqr/jWk7ILhfVaSXdRUIK00WjLPph6PQXSF7B1LNzNFUjKyNtnfBkhdPsIsIr8pKhqgEcDnrVoIIe0oshLDqMxegq+6SJzMVwLE8HWgBIeGg+dfI0Fm0sAm/0VPRMTvX4ZUVmQ/M4TH1EpFtM05fSSra5fd2eMkixAPrJEpwhmBjAR8Uyt9eih1gJD9a4im96FeZqpZwRJXeShXxbn0xFej1koSDndCyZjWC2OYlQ+MPIsy2AHhX4IOIfmJRF79yKoawGcpaOENMGAq2WNOl0=
X-MS-Exchange-AntiSpam-MessageData: XLLodztX4puJTrLTY7NdDO1z3uOdic4s8mwiedoaRnX4dN0NyZcqRhfqINOA+lv0baNKr6Q9bqB2188sHrFJCvRDsSLqg3tIK8QOeUioDV3wmKW6pMYWN9uOkirUHBx3DPKLCfiXy5fvP29FTaen8w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d47e552-2543-4fc1-6ec6-08d7a66340be
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2020 15:35:51.5918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ntqstVzRYHXXkGSM8r2jIzSkK1uehs4TZn2PQD25YWhxS/Jj8i2QpvHrHEtJVdsLM/3pknJXEvpqCSrDO2jcUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6730
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Introduce phylink_fwnode_phy_connect API to connect the PHY using
fwnode.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

 drivers/net/phy/phylink.c | 64 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  2 ++
 2 files changed, 66 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index ee7a718662c6..f211f62283b5 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -18,6 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
+#include <linux/acpi.h>
 
 #include "sfp.h"
 #include "swphy.h"
@@ -817,6 +818,69 @@ int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
 }
 EXPORT_SYMBOL_GPL(phylink_connect_phy);
 
+/**
+ * phylink_fwnode_phy_connect() - connect the PHY specified in the fwnode.
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @dn: a pointer to a &struct device_node.
+ * @flags: PHY-specific flags to communicate to the PHY device driver
+ *
+ * Connect the phy specified in the device node @dn to the phylink instance
+ * specified by @pl. Actions specified in phylink_connect_phy() will be
+ * performed.
+ *
+ * Returns 0 on success or a negative errno.
+ */
+int phylink_fwnode_phy_connect(struct phylink *pl,
+			       struct fwnode_handle *fwnode,
+			       u32 flags)
+{
+	struct fwnode_handle *phy_node;
+	struct phy_device *phy_dev;
+	int ret;
+	int status;
+	struct fwnode_reference_args args;
+
+	/* Fixed links and 802.3z are handled without needing a PHY */
+	if (pl->link_an_mode == MLO_AN_FIXED ||
+	    (pl->link_an_mode == MLO_AN_INBAND &&
+	     phy_interface_mode_is_8023z(pl->link_interface)))
+		return 0;
+
+	status = acpi_node_get_property_reference(fwnode, "phy-handle", 0,
+						  &args);
+	if (ACPI_FAILURE(status) || !is_acpi_device_node(args.fwnode))
+		status = acpi_node_get_property_reference(fwnode, "phy", 0,
+							  &args);
+	if (ACPI_FAILURE(status) || !is_acpi_device_node(args.fwnode))
+		status = acpi_node_get_property_reference(fwnode,
+							  "phy-device", 0,
+							  &args);
+
+	if (ACPI_FAILURE(status) || !is_acpi_device_node(args.fwnode)) {
+		if (pl->link_an_mode == MLO_AN_PHY)
+			return -ENODEV;
+		return 0;
+	}
+
+	phy_dev = fwnode_phy_find_device(args.fwnode);
+	if (phy_dev)
+		phy_attach_direct(pl->netdev, phy_dev, flags,
+				  pl->link_interface);
+
+	/* refcount is held by phy_attach_direct() on success */
+	put_device(&phy_dev->mdio.dev);
+
+	if (!phy_dev)
+		return -ENODEV;
+
+	ret = phylink_bringup_phy(pl, phy_dev);
+	if (ret)
+		phy_detach(phy_dev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phylink_fwnode_phy_connect);
+
 /**
  * phylink_of_phy_connect() - connect the PHY specified in the DT mode.
  * @pl: a pointer to a &struct phylink returned from phylink_create()
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index fed5488e3c75..cb07cf7a832e 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -240,6 +240,8 @@ void phylink_destroy(struct phylink *);
 
 int phylink_connect_phy(struct phylink *, struct phy_device *);
 int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);
+int phylink_fwnode_phy_connect(struct phylink *pl, struct fwnode_handle *fwnode,
+			       u32 flags);
 void phylink_disconnect_phy(struct phylink *);
 int phylink_fixed_state_cb(struct phylink *,
 			   void (*cb)(struct net_device *dev,
-- 
2.17.1

