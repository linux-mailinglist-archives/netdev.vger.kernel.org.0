Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE299336C3B
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhCKGXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:23:13 -0500
Received: from mail-eopbgr20066.outbound.protection.outlook.com ([40.107.2.66]:53349
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231570AbhCKGWw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 01:22:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCve/NF/CZsq6cU+ddS/5IgnguJppb0XEiv77ePjVCY/p4gS3u3GDOlxbNxzGpRU3fZt5tLDYLkOcGNGPdFXpvkNvG7xByRrBSfUKqt350nAjS5cZa2bmfXnv+SAHxDW/VDUJeVADRbx5SzP7zItNh0xYs6hiontliXpvxXq9frTMHv7y5BCeBScht4PnWjp1CAsX0WbkS+uxunVCCKHB2pULeyybCnAgao1mUUsSQmQ1QDNSHhiNAxpukqdpzEjSqxHVmjW6mXZUAA7mbXrHaSI/mudhLYlxFbdObnCB7335eJvXHO/uLwQm5Nn1nCmqkcNQfJINlQuOZd3lRpO+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5CCUYQ4PNOtdIpFWUnwN02iQqvVrzm5w1kWzIjVu5E=;
 b=i1Lo26b0eAWlj9oFvvOJWNFbhWDO5Eyo+owIa+XLHzsnT8kjG3GFH/DyHv8BFTjzmmcDBw0clku352yqwtvorGsnEWTPRWO6mniIdq0lucmkKfwVpO6g60Ihklk5zbOtg0i/4keRQbyVSMPDzq3GrwBdhzXfkVU8h0NprjUv1JANZRxHn1HCt/5NRBdBDbM2WxGLaVjkLwIOz7X1uItLl5XTfEGyww02pIL+yKYrznOcUsFHC8oBV+Q6pU+wxR8yscfaALsm5Xxgp3FCQi5hY+CfjsSCD7+kF3balOSvUXkRoqFFDfWtYtaDwtn86IoQYhJi3De9Md8H2e/eWrohTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5CCUYQ4PNOtdIpFWUnwN02iQqvVrzm5w1kWzIjVu5E=;
 b=TQx15zqRrAtpJbWPxMpF4PLeU8yUHxEkrD8MmF1kUJqu4A3W5qfheWshR8lfh7oWGg1oo3Eo+QOPWIa9DNvFRazkRCfbJ5aKBdOSF0/dQZYlSM175qC7MycXiAwzem3dztE8drPeLMY9gpHEsMZL+7akFQXbk8Jy5m1eQvWS/7E=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6611.eurprd04.prod.outlook.com (2603:10a6:208:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 06:22:49 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 06:22:49 +0000
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
Cc:     linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v7 14/16] net: phylink: introduce phylink_fwnode_phy_connect()
Date:   Thu, 11 Mar 2021 11:50:09 +0530
Message-Id: <20210311062011.8054-15-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HKAPR03CA0026.apcprd03.prod.outlook.com
 (2603:1096:203:c9::13) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 06:22:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 975bdc41-d9ed-4dbb-6aed-08d8e45617bd
X-MS-TrafficTypeDiagnostic: AM0PR04MB6611:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB661180659650D76772C9B74ED2909@AM0PR04MB6611.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4k/CzVPQsx0YtWAFnhlfcxa2pI357RncH0Csd1N5RaxTSSUHBIz5CJ/MLXASeYuV7lc4Ka9DHZfPkpgS3d9CQJfwWSt+W/ov5Or6jCtEvCaQV7F9EmQ0/zSRxY3EMX7BPVcOw1QTNyg4cI5AyYq5+fDLfWWXyF+aLlU0vrYt58a+r0wZNm+pgk5slc2fdbDrmo6aL/nXHHw8GqmWAKaP17M0wH4GVb4jgUVWJpXBe+pKqelRIMWib2aP+Vtes4W1DHD4LfMZkbTr/jxhP90t8VKagJyNLTXypfWN7PGloXlcfuAzCVf3FDZDmrFQMpBNSFpeSX7DmVElQVLPVpWBanpLLXNairq6BenU4LKUHRO5GvjbVR+2E+kBehuHvE3wRIgqpYQey2RT+FUbqglTa8ewCTETPeJdkuwFUffOgUEPfDgDKJqeA7c5YnPVfBY78/pXiaHobIJn/AwGB0wFyU7sHXd2vlvRGZnJdI0BqI0Iaqlj1EYwfCfNVydMbmp444m2VbrZf42Bb9d/9KT4vYEJjQr2FEQsFK6fdgsDjV3DyjMw44RBPheMc4I4iLHpRHTq2v2aUsJF4mO5UvN79SaiErE64rie9cA09MlmFJs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(2906002)(921005)(16526019)(26005)(186003)(6486002)(8936002)(6506007)(66556008)(66946007)(55236004)(66476007)(44832011)(478600001)(6512007)(2616005)(316002)(54906003)(5660300002)(956004)(1006002)(52116002)(8676002)(6666004)(110136005)(86362001)(4326008)(7416002)(1076003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?d/y2z8slzKSCxOh3yZ+BCH1yXd5lhhKEmfU0bBxe+eUUiO6QEal0XvNDahh4?=
 =?us-ascii?Q?9TZ6A6YeqwAnKS0l9AGtY3QgcbdjyzWrwAGjW6oZ21rVdXQYFfgDZx85hNXs?=
 =?us-ascii?Q?8+0WjmXmQXN0lEjHO2hNMGwnwG+DLk8zwnD15kmCmlvZwKDz2HU07A/hpi+t?=
 =?us-ascii?Q?MaVm+1VNZjjPWjxKp3YygMBLQRozyagpKVIBHWZBBrTXRg2BZTj/hpD8KQJt?=
 =?us-ascii?Q?4cC6oNG7P93MjzPVROP4OjJTSxibXrcUn1DrZmnfV+rVn9+FcNv5+hHzbPN3?=
 =?us-ascii?Q?6x5utPm5TaWmJ9yQcYxldkZlI6EuzVyFkTvPBFxzh0KwDDNAPLVKJaROOMlM?=
 =?us-ascii?Q?v/NrIqfzg7GjoXNiBQSFwUx+5T9++cXixk84YxiKcqo26J0suQ7+5culFSl3?=
 =?us-ascii?Q?8O3EY+0HY9RijoJnWw6U17heg81eqnXZqkgLC+1ZtvGQd+icsDDU/P2lPje/?=
 =?us-ascii?Q?g25lO6BLl8XOrFHI2HIbuSsGT+iCnojmCaHgD666LgBsm0i/Z88wZa0gxuyw?=
 =?us-ascii?Q?mQIcALgwsLkt0nKVi/HZje0HY3Uq9x9WLRdUKs+N9wmTMSfKvPD2uI0INx4D?=
 =?us-ascii?Q?YTzkMaOGELZp4YDCFrH9Iw+EGaQ+lN7Xn5e+Rieg3r4jgXMbjF+KwnWPd1BR?=
 =?us-ascii?Q?CI0vL3xBtwUFvngE5VAb00vi/9FK3cDFHLCSEyD/UmiF2nHvlt8l1UJwSDSr?=
 =?us-ascii?Q?C6vajkchfOkFzOpf+oJlaKMaOsx0RO59FMb8oyRmxcCtJ0t7QyDFbeU+eWe4?=
 =?us-ascii?Q?27Y2D0W/RawtiRNMDciiwAsVlGeGOhEFboPCnP4z7T5B1rU0/swP3BzINa3C?=
 =?us-ascii?Q?wb8GOFyGHItU1C5Vs92NHX1ZzSbS9JBRA8VwNf8hrWr1A8ZZe3GEB4iFvUor?=
 =?us-ascii?Q?RRIYqKKZS/bMnI/g2IDLLgerFSah0iSO7eg9a7Z/f+KMPpAbwiCawu4LvsN2?=
 =?us-ascii?Q?fMtPRA4CvLZ/G9jArlwKtFPaxmp1gkbNps8qP0NIWO08ge4tjcqfAY6VBhOG?=
 =?us-ascii?Q?Y/0/0Hhl498Te3vySirqcdIyLesb8gZBEJdKvBAHL36BvEZY+QJ90DaP+hIk?=
 =?us-ascii?Q?Q60NywxY1JSU8SN9/GoOKM9N/kYwzBIan8VTMTPQGNZag/Eo8SwGXe+N2MTY?=
 =?us-ascii?Q?HttmTq6Imm0oCNki7KMvwegLzc1a31sJOXq0754g2FitSnI8Me6bucawjIRT?=
 =?us-ascii?Q?tnIGNmp4wIg+Ih4xU4N9h7cqoaXzdwrJeLd2ToKf74fIUDfqX3khQJXbp73X?=
 =?us-ascii?Q?Xjeyog5tv5kb/Hnzd5ZqIaGLfsqZnL7ng0OTf4IkAiHmwibLY7xG2ubgerN1?=
 =?us-ascii?Q?U2Um9E5LsoRZeMl/uhw6YCht?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 975bdc41-d9ed-4dbb-6aed-08d8e45617bd
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 06:22:49.3153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TegvOFwmObRKHH3PNyQLvQww8tTgB4lnJBZLUyrcRGMaJSstw2+RPJ20pVIzRUUXo9pyAHhF2XRPjeJ6eOLJsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6611
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define phylink_fwnode_phy_connect() to connect phy specified by
a fwnode to a phylink instance.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v7: None
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

