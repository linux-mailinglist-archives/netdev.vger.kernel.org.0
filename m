Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003243007D5
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbhAVPwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:52:46 -0500
Received: from mail-eopbgr30068.outbound.protection.outlook.com ([40.107.3.68]:58961
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729204AbhAVPsR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:48:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lnk7AyG2GsIg4IUO+AgDuHb+iTAjJnK0igXwLghKT7g2h43/BPGd5+J5ehtM0pSvHTHbek20/6KXC6wob/P5EF3P/zEwhK74rSXhUUZhdNGl0hH9C1ibt12vy6ervMILEoouJyYFUW4fzN981MwqUT4pfVvzorQ2jQ4oNKCzW4QTHNgm0JUvV0jK1RRObdAREVgpxVkr2QAdPA7CL6vUwah5k3gZFTypyL1gbdP7p4I0oJje+oi7B0ew/FBboAXhbrCb7z2bZ7B1mVQCdHfQpy8sDd+k1K/NnUz4WC7bBRalykeF7id3a1VyeDgmvd4WEAsngKIxOddrBt0UzN7r5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hPXicAkotzmCd19tN3aKAQTf20oFbPpqck2oZy6QbN8=;
 b=AX5qJ031uW0Ezk5t/ve6D/eZi9Y6Xzu+t474qRz42vuxhHSb6NptqlzAuGEx5fTEvQ/febaIor4kds5qGc+9dP4YTBhKkFuDcwy3q/pUPB2M/IXFZXJ4sm9tAC8Ac5szzOh56UOwlmhjhFpp14hBbUBI5e87dMAlrF4MAH9dtUerawGm9M0QJuqSfimGKoSc7sdKRJnQRRICdYYOLfD9AAI1V80dP94PqHZQ6ELlUn8NSizNOgD9J0Kf7l8mN433H2yBg7ri2h5qCJwV78Nrl/O17dadlhtnjPW524uKKk+Stayk+EdmULQkKp/LOgN6hg8SyVaWYXWPvSSkVKK+kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hPXicAkotzmCd19tN3aKAQTf20oFbPpqck2oZy6QbN8=;
 b=jYw+5x4CJNTWXcABb3YodAelIU3YAW45/DejnlNS0cqomyDF3QYI1wdSrQfbNOhLf9XaJ1jPCXx0gXvZygP3CzVMzvy4/sBrzr1uwbX9Mpz9w6dt+rfprcqvfk2+tEm9Tdzde+qm6f4bqQAtIV+/U2CW8fTQkyYj8n7I0FyAwHI=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 15:45:19 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 15:45:19 +0000
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
Cc:     linux.cj@gmail.com, Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v4 13/15] phylink: introduce phylink_fwnode_phy_connect()
Date:   Fri, 22 Jan 2021 21:12:58 +0530
Message-Id: <20210122154300.7628-14-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0117.apcprd06.prod.outlook.com
 (2603:1096:1:1d::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0117.apcprd06.prod.outlook.com (2603:1096:1:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 15:45:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a2892d52-168c-4999-693c-08d8beecb88c
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB344366AE6C83A6841E745F50D2A00@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /aH43FXRUxlfFhq0XKZsv6A5Ukve3GFRPuahM95uGk7jzQm/n/G6NaqpJWCl8ZAALhAd28hf7TYk3y4nQjkNnT9xIH2tjtJ/UoDl6H3koXwTIIAbyd9MzINvSoAdf5Gm8tESYQSzpbOjPyNiR6N2dr2BqbPF7NhC32IGCqw77BkHcnzbn4L/sBYyBCK0R6u3yPhSHrNKzSKRP/gOkIBJYq6XNGzaq43cVwkO7GQVyCvQLaxPFBemQLGyygLoWG5SAWu2Fk5X1+S+k33lBWyvLwPyDODy+zf5Syau9xCoLh3Ipvc+NXlDpNzsxx2te4TSXhWmF8uVBnPCRRttM+4f12PP/QJUoAS72Zti777hMyNGaAf06qxN2LeUBLBGgQGq/v4eGcMDmqN+fk4c8oN9pjtA10igojo5u9+RCjrCiW+pkCcfk7HdzzRzgNObdW+jeAqoXizKu1X9Fu/hL2FNmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(2906002)(6506007)(921005)(6512007)(6666004)(186003)(5660300002)(1006002)(16526019)(52116002)(54906003)(956004)(55236004)(8676002)(66556008)(8936002)(66476007)(2616005)(66946007)(1076003)(478600001)(26005)(110136005)(86362001)(316002)(7416002)(4326008)(6486002)(44832011)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AdmRGScw0y1uYSVYP9vPbzmCP98C4LZo039VeCc5HAZvHS6qRUCDT1AXnyv9?=
 =?us-ascii?Q?bm3akotAvjg5s23ZdNJUUYYnX99tkznMheH1jRKIjljzreVLlrzU1JLloKyq?=
 =?us-ascii?Q?TaIhUzK5J58MTA2n1hH34fTlXlUc+RkrkXJOOoOO133PdNvJQFenOMyYV6bj?=
 =?us-ascii?Q?6o3yyQ7gMJr3F8/GoEmZ8Kny0FrSMdTq+xNFvpuKliZ8ZxeW2JHUiW7foM1w?=
 =?us-ascii?Q?5xNKL8resUymjVfQgC/aS6ij706K0vkf+FOrVj/3nvd8S0MQwDQQQcr623GY?=
 =?us-ascii?Q?517GpSRGrn0QoPaCHfVULMbHMbZM1t6x56voJIHO6JdICPHpVpTNosKX13r5?=
 =?us-ascii?Q?i8sgIzQVedqTEPUNLcUDn67Tr3VvSc0qq4rJ0ODsNYaIJFvKGSSQc1KteXVI?=
 =?us-ascii?Q?vGCUwYzoxfspoh/9iD/5fU+J2umMRiIzjTSlxbij1NSJoShEMaqgZaWdjQi0?=
 =?us-ascii?Q?Guwk2JoD234mL0S+Ev/xaN7Q3LSb3EJku3gNSicKMD1aHjbRdsMiAn+HQx6P?=
 =?us-ascii?Q?qI4nPDEWaWpq+pAn6JtUIpu2Yvke6u17AuCQFvCsYMNDri/3I2BDUtjzd3wU?=
 =?us-ascii?Q?p7Fe/RYpuBrGmK/id7gIMjxWWVaTAIQFES7ErtxaUdR51vr+4FRCKm7LnWpe?=
 =?us-ascii?Q?BUGFzdkP5JRR3CIxpFijFc13ReTtMCdWCf5SaFZ5oc7MxWZPBaPVUgXXQdGy?=
 =?us-ascii?Q?Oc8RaTOZfkoRircBc0yjGemy+5gNOC9DEeg2A289GuS2pnfs8S6unyGey/n1?=
 =?us-ascii?Q?+8uYVY4LOOqajzZVsA7Aldqnz0QglkKNM0l1gpzgv7rPgjLxgJyJght17/ZL?=
 =?us-ascii?Q?ohCgNApYEzb/M56gwnpbe+iizlJH3y68jrWz/craH30pGT56Dbj7I5ZWXqGf?=
 =?us-ascii?Q?+nr9heb6KZYs6wc95F1fdV8wcvPjHrLOsvCnkJBZ9Ym3NNB76zEH9kXh7otD?=
 =?us-ascii?Q?yHIJk9D0ksIiDUqarf/eAPWVcG9Gl/jsgmILFXoqFkmxcPfEle65BNJF3D+D?=
 =?us-ascii?Q?llPG3Dn9tPtezmFBx4smnwt5md9s2+O4jIt770RPw3UPoFgOwMfxyvoZiXEx?=
 =?us-ascii?Q?flrg0IBj?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2892d52-168c-4999-693c-08d8beecb88c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 15:45:19.2793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0U0c4BNBRYsnTk+rg8gilpyGc2NlFcrMimylsC2qawCTRIRkHbZOlsmItDwNLUyEbA8zZVsPvArh6WfJEcHN+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define phylink_fwnode_phy_connect() to connect phy specified by
a fwnode to a phylink instance.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v4:
- call phy_device_free() before returning

Changes in v3: None
Changes in v2: None

 drivers/net/phy/phylink.c | 56 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 +++
 2 files changed, 59 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 84f6e197f965..5466e1e6272a 100644
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
@@ -1120,6 +1121,61 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
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
+	if (is_of_node(fwnode)) {
+		/* Fixed links and 802.3z are handled without needing a PHY */
+		if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
+		    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
+		     phy_interface_mode_is_8023z(pl->link_interface)))
+			return 0;
+	}
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

