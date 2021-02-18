Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F3F31E5BC
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhBRFgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbhBRFdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 00:33:00 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0603.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6C9C06178A;
        Wed, 17 Feb 2021 21:30:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJZfZAZASkpuCpSFaXlQiNAEZFHkIriRVVXAj+hzpx+wNzf0t2W5T+NkydhS9cBOOIsMubB2iX+SpCT9UiEJdPCdpVSgPANTZNcFO8jzCReTDWO/wn/fv5umv3nUz340KZgLUUqxIFI/1TSpqqY0VuTBBoZDr4if0z4m8GbktdmjTgnNObjHloJfogG6pCuHXgWBqN1ZKKbCegu1yD8JHBf2dX2GiatRYAFOYKIRTLHpG0CVTAJ2Rd19QnXJ3Llt+mTR9JTZyxvb1tn8DeqdzZxflVmw9US3G7E08x3G8YnjdTdT04yCdhuTRbBaPdHt2cJ6n/YbrgREEv1YLhVNTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ohokba/w7wbcANp2/G1JYz10nCUZvl9JMLZYBMWxhD8=;
 b=Yq6WRkQ3IRfBjn7zJ2ehEO47UdqxfGoyyi/OpBzOGiGalPZnZwrJwtDjgX18SDpqtv3KjWr5TfBCgCP0dH2AjYkHAywkJm0qRfcmuzTSOQCn/c9jSbTXp3Ks3gbwZ80B2Ij9SLX4DaQdwyhY6VQM6n7C+5XdU9RRNVYEYvaWsCs8tgW2vUwWKhS+TR42eXkVc+SKCG2G664v99EtReNtGJwFiOtQGaQXKhRvG7bfOJtIgI3X6PSL8H26/lFePdEYL6hi4zsoofuL3cO2HQ6mCOm9tBbpbURIxSm0KLylDa3OeXklihkjlycg8mM2iumIbSQ+thUv3J91HOOZ+z8Vrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ohokba/w7wbcANp2/G1JYz10nCUZvl9JMLZYBMWxhD8=;
 b=bZn2ii0VUkX0nKorZgJXNQVVdZxzJ8ejGu/W79naXI5wf6sC+jQtZnSTtMK9Kf6MmdPi8zmCv3lTDryAgy69E8hkC3iHvE1MN8nM3RYssyUnYijR1sySKEZrCYq3vQMrRA02LjEJbhIRGJU5uzZnwvYrd82wAX1CDcbl7Or5qfs=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7730.eurprd04.prod.outlook.com (2603:10a6:20b:242::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 05:28:56 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 05:28:56 +0000
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
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux.cj@gmail.com,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v6 13/15] net: phylink: introduce phylink_fwnode_phy_connect()
Date:   Thu, 18 Feb 2021 10:56:52 +0530
Message-Id: <20210218052654.28995-14-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:54::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 05:28:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 948fa1e6-791e-4758-eb30-08d8d3ce1608
X-MS-TrafficTypeDiagnostic: AM8PR04MB7730:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB7730EC7BF1DCF6F7F597B826D2859@AM8PR04MB7730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gASrp7hzPU0VxAYK5N0OKjlbPa9DpF/xWovK9bOt9XaOGwo1HztvCTd3kSRYmnGMKu1epksDN2qS6wsYPUO4Jvp/gx7KS+X9WKzDhlnhR9GUe/nz0d0nk05ScX7VHD6uk1HOtzm52wr/JG6C7FO3X/vb3wgjR/oW9yl6Gf86kKf/nqIRkHl0cP1+HsNHRXX9RXYi2hFUQ7/2FItaSIbJ7ZqCTNovvP+Od3FKuxfSR/kqWAAGLd/kFOtRKrm8id/oi+xoLvj4MG4IzouN8d2ggO30w0xfKcFO8k/pVrrJE1A+yJHWTBtYcNueG1JihU2BtMJR2iMhzpGR2lVAAZMYnpZpQOkeX3ICGRQaXx0PNxDSeUi3xGAgboDHVMN2Tbm6Xe1HU8hNBBwbeuw15yhPC17Ogjv3kqxrBLPxUWLXS72aXM9GkubUUukxunxvlzBflk2pZpDNWUhQLjwkwCz3OqkRc07izzjtB4Ym3OXXWpSbT/a9irASkVeihNKvyKjvNBDJ6K3IKn6RKeyBCRLgjJdiyvRXMiHpyyiK3uEpGvFZ0z0DRecV1UnkacsD6Oex3TqoktEK4/h8rCNXHleowYG/jCWI12s58ucAZ1gAWP0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(26005)(8936002)(52116002)(16526019)(921005)(478600001)(1076003)(6486002)(8676002)(55236004)(5660300002)(186003)(44832011)(110136005)(6512007)(956004)(54906003)(316002)(66946007)(2906002)(2616005)(1006002)(66476007)(86362001)(7416002)(6506007)(6666004)(4326008)(66556008)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xCro8pZlpEgvYfwRXhDIniDClKp28sJzHCebkhr6mBesxEwNBF/ePvVWBwr7?=
 =?us-ascii?Q?hYtuwZxCWfUn9YXosAI7h97eMoDjLsuhSFE+CVS9dQAU3nHPNqySAYtUubLd?=
 =?us-ascii?Q?l4Tc3wYuKMqpFIjWSfLmUx+sLgmqflpLE13PFXqK7c5QU1GmEN1p8UW6lE/4?=
 =?us-ascii?Q?Lm0u2DQithKlCKEg4RK9Z2SFHp8Ryc+ykDNZ6umRBv8tptJoHBqmnSNG6LeZ?=
 =?us-ascii?Q?GnVRxfX3x7dDXoRlKuPkm8Qr4QvJ8BySusVnajBg2/MSghHGSOgV7LZHrH2j?=
 =?us-ascii?Q?+YEzPk2Wut+PgkncuKMMMTF0iUD/zn19uz4q5yPUXntw4gt14Nuy3c5Ew89v?=
 =?us-ascii?Q?qnydlUYfQYgJrR463NW76M4GWZ/XBJxYUtOHpKK+tdTpYSg4iYEyXe6V/VU+?=
 =?us-ascii?Q?LszT9Y4TRx8nTiqFPRc8eiJFxnMAz12rk6mlg64jzI5ab/JwcusHAgAaGXyz?=
 =?us-ascii?Q?CKn36Ush5bKgf3y14Jx3doF/+RL+Fqi1sdflS0Z8AEwPGmQh+CZXeD4WvMeo?=
 =?us-ascii?Q?kC3BS+Z9cmNaczzhCdTFYk+lVuK2dTc8BbTjb8SYqjz5ZWWc5KKVu3vsgFPb?=
 =?us-ascii?Q?tJJVeKsBrL82bxJPzASFWWpQdpb8pvDc91DIS5ttVXqk+a/aMIwY43ot7NAb?=
 =?us-ascii?Q?eCNLSatmvz+x245YiHW0XRt4/vw7bJ9gAzv/jv9EPHBI20meit9aDTGq9kOv?=
 =?us-ascii?Q?Qv3/MiDl/vIh5YRweElkUR0mu1Zt48/bwtpBewyjiuR1lMv047D7af6aztTw?=
 =?us-ascii?Q?4VcRfFk1v118AfrTJQTCP/YnRW8MDq/5kP8BVnbGT62d9t6+4JQIdYqBq1NO?=
 =?us-ascii?Q?gzYZBIYsRY+hXdH1FRL5GO9UKZw9jjqNgdXXh8MkhAiJ/kf5fOxV3wNBYfbu?=
 =?us-ascii?Q?SQHq92D3f1m2175phqmYkKqrEsZqKV6XaaZ2iSa0RPhB0LrmtbPLH36BkhQo?=
 =?us-ascii?Q?dzIF3RdpBwIwdGW3DSxKjjSlkinZPIUFcT3ugfmbkFfTcfUxqNo7Hx/RFn/U?=
 =?us-ascii?Q?SpoiKIDDJXpBqWpC9ixI+YCoWREJNp67mqlP8oKdx71JzsDyZ3ma1qBcniyL?=
 =?us-ascii?Q?DMsArHtNCfZw3RVrrlHqc7bvl4RIOYV41F+FrDmGPxP/ddfv/WDnqC8Q9VnZ?=
 =?us-ascii?Q?2T2lRmpLBRc9qQq0zEP/DXS6reLxRWT9P9PDMnWou2fz2PirH+KJ5Rra/HMR?=
 =?us-ascii?Q?w6A5adfkGF7YH2SzngE+uiyXh8IWmsV+OBqAu3nS2X5GBKGIY8LAe7YMNy0d?=
 =?us-ascii?Q?xLsktXxt9H/Swu9E+sgO4Vsv1suwayicf/pFWIx9fQxsZ2j+degMrwHLsmSc?=
 =?us-ascii?Q?1coDRLRRqfMzWLk8sM5b3Joq?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 948fa1e6-791e-4758-eb30-08d8d3ce1608
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 05:28:56.1341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZxjyILY4yOy4Siubu9DoR9UAZL1D3SAz9YFN1hdp/aUYPAQe4/lABhnBj4cQEN6ggM3d/6NnCkl7ntji0viBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7730
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define phylink_fwnode_phy_connect() to connect phy specified by
a fwnode to a phylink instance.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v6:
- remove OF check for fixed-link

Changes in v5: None
Changes in v4:
- call phy_device_free() before returning

Changes in v3: None
Changes in v2: None

 drivers/net/phy/phylink.c | 54 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 +++
 2 files changed, 57 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 053c92e02cd8..23753f92e0a6 100644
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
@@ -1124,6 +1125,59 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
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
+	/* Fixed links and 802.3z are handled without needing a PHY */
+	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
+	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
+	     phy_interface_mode_is_8023z(pl->link_interface)))
+		return 0;
+
+	phy_fwnode = fwnode_get_phy_node(fwnode);
+	if (IS_ERR(phy_fwnode)) {
+		if (pl->cfg_link_an_mode == MLO_AN_PHY)
+			return -ENODEV;
+		return 0;
+	}
+
+	phy_dev = fwnode_phy_find_device(phy_fwnode);
+	/* We're done with the phy_node handle */
+	fwnode_handle_put(phy_fwnode);
+	if (!phy_dev)
+		return -ENODEV;
+
+	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
+				pl->link_interface);
+	if (ret) {
+		phy_device_free(phy_dev);
+		return ret;
+	}
+
+	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
+	if (ret)
+		phy_detach(phy_dev);
+
+	return ret;
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

