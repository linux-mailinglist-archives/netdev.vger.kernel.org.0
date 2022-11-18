Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536A962E9FB
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbiKRACn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbiKRACW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:02:22 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80055.outbound.protection.outlook.com [40.107.8.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE97385ED6
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 16:02:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpLS6nKN0/mLULuh4ZVpX7EyAH2Lx/JcnQJwZVSrbUXmfz/pHApHy2tB/x4ariUbodhwWdlv7GAKDkvRjl5Aehl+53YjeohNy67kKzE1fy4a92UTk+9g39spAs+8RT+eoHuj/ChbgQYpIq0sesIpqRp5fVQW+XbKKd1PRZnwaidHj82T2jU26hxnQ1nv9m64xgBsjpJLEh4o1tCWksgyIQh0OzEKKvoVGZ0xs3zx0umsqALw0UWmTgfQLIF6/FuKEE2Fp6OzuUepnWZAx6eEwKBdn4Mrn+qeZNqIa+stRZixyrZb9gaI3pTVMOWOrdLLmwu701EU+AkiKwa/yLG5Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bNELLzRNlgEkIiH2tAt7ZyTWCW71XVxUZU5dY+ux7z4=;
 b=XPegmth1W0EI8+dA7FkZht2C6X11dUBobONpasv4Tk4oAPsCHZfp0yjCUBy0NP4HP7MzNP8uB2b+c4HKN17SpdUYeWcyGWC6pJ4igU3hUsHyNj8Hb7v6qQQbuGUMejyPnu4Qje+PuWscg/zGAcY6VfGeU80TZB4qvz3dj2LuL0Zn0uQsBliwnne+5hYgU/bH3Yfed0tnVAmPVQ0E6sSWj4gqqiyc5bjKsBTowJSyuEcUIvaZ8xvYyAQVVjqqvSfWQWyfXPcNT1ThUe43G1gpykYO9u/3kHGLPC54D7dQg9hNT+8ZOo6D6JX0H0JpR9VZKC/t5Je/PgB46L4eVCFIMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNELLzRNlgEkIiH2tAt7ZyTWCW71XVxUZU5dY+ux7z4=;
 b=SuCiElQK8c0ZIliPRqJeyBcWUc3F8fC5Nfab3q7RcarK2Zom106kOtlBKfbiMXUAjpAWeHOgXzDAWoN0KmlKRSpkz8PD1Xsb1ceC7jNO98Lppf4pUGwC6RVFKcoIAWrXfytqzAdXFNhIZozm/XBd5NBDPJm1wj/anLv30TPYtbg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8542.eurprd04.prod.outlook.com (2603:10a6:102:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 18 Nov
 2022 00:02:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Fri, 18 Nov 2022
 00:02:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: [PATCH v4 net-next 5/8] net: phylink: explicitly configure in-band autoneg for on-board PHYs
Date:   Fri, 18 Nov 2022 02:01:21 +0200
Message-Id: <20221118000124.2754581-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::16)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8542:EE_
X-MS-Office365-Filtering-Correlation-Id: 21470a44-bbfe-4cf7-4d52-08dac8f8247a
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SPO0cxaKeN9wiFiJVmXmWas7mr+kOqabKmPyoTi+16o9u/4r/4W4ExUKzYZiAT4VXstUnt8EpE9bjoyrxJ4e+6z/E2vPffnVitHgZyGkdeBFb28l3TBgd4J9j029fpBnAkY0qKUSDmiBR/zXVhq6MMfFpfKpE6D5ujlxyFO1lYLubQcJYKxKSLffsxwjT6FAzwkEDbe+oxmjmxGzej5UPonbNjo6t8XvdAoL1Idr6sLa/9iPlPaDMjCqLDKuxLOTcy2QxHAXNUcM3cVqDXJaTq1XMtK4cy67u8QtCA6q7pU5wPumO2ZYLxlRkrUV0hb7avA4jz4OdA9Xh8DS+AshgGnZC1oXCK5SPYsxeSp6L/lYFEBpIXJ7xqU7JCxevLVBr7oNkOpvw1k3SI3AXsCcTyvPYpwPFYhPqmGaPxteCyLcnpdvwIK0LVZJNugWJN6QNftaK2/+ptwb3gmY4zh0jRADfdXqbYXDHEkmMOe3wnd00Wy/PX82F89N5vMfyP154LeKY3borZBEz0dA6wJdmU1evib0s5oH7RkeRpYMSPtguBPhpr5Tj+GFDtJcSbDF9U4yCJu4OG/TRzKJ/y2P966L/rxhbmjPsfPJ+VTGp+b51QrgCJ694rPqVR8GYqV2SbgLMSQVNe8qHK7dqF9fNXhoJv4Y6zs6lGoNc9Tu2iuPg+sQy2nlMkJRlu5NbBrf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199015)(478600001)(26005)(41300700001)(6506007)(6666004)(36756003)(8676002)(52116002)(6486002)(4326008)(38100700002)(44832011)(7416002)(8936002)(2616005)(66946007)(66556008)(38350700002)(6512007)(66476007)(186003)(316002)(1076003)(2906002)(54906003)(6916009)(86362001)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KJKSj4tZBa0kAYEzHtU6WaCZGKLg/43/YtDgtOrLBwM21qjknjIu3vgyZrlW?=
 =?us-ascii?Q?RdxPNUTFyDqahgR9yxW9e62YRfmpggHSVJ9jug1jsceqluFRKyy2JqGeFhSo?=
 =?us-ascii?Q?Dgyhqii4vgcJSHeC+TydvBkUd31+RZg9kkiVLtYTmouIqYhkmvGRR6TWvtwN?=
 =?us-ascii?Q?1a13QTVf35WujvgsoOkOionpQm5+UF05E+6LLspGsj1Jrs5s34PCVM2PNL3B?=
 =?us-ascii?Q?upw6T+EKw2988odwQxm2mjyIl08gQShGdLsSuzEBzzmvhTfjKe0+2Y3Wg0EZ?=
 =?us-ascii?Q?JJ5+e36LTDp/OJNRt24JIFtxptW075jHQvXxAgqo5eAPVZ7xvZrtMSEMs7Fd?=
 =?us-ascii?Q?6m4ApR1Z01w8gimupYixu8fDwrK3KuGu+ltHliC8WXLjyw30gJgD30GeWZyU?=
 =?us-ascii?Q?zpwtA0hPXyzK8ZZvhJRw5QvbfyOoAGbYnrlgmxdB0hJYclm6lXNq78ud8A/q?=
 =?us-ascii?Q?5s/8Ky/Snj/d1z5Erioy71fxFQo8b/CjHQtiSokAUqVXRj3VnDLIvDbdcZyb?=
 =?us-ascii?Q?ojXrplkGyqdqjThWqMd7NKRStkyxrDQN7Q8BGj4baCv6yn6WLRrgT0OA0Fm/?=
 =?us-ascii?Q?TcsWQH1/9S0EG1XneGb6f80jP9VYyWBnlcOO2CqJgsROLnPIlC8v72OvhsPW?=
 =?us-ascii?Q?e2jbh1akzFCiHiL9rpi1wiEr9xu3oYFTLXnoPr0Sy55GCjunbyCtvtikN51k?=
 =?us-ascii?Q?NSMjQ3RndWBnGWyuUjqB/71su15JC7n4Nt2BVn8FKxPkmCPzjUizoK7yYPs3?=
 =?us-ascii?Q?MkYiCKdvfYp7dN2rQShhJpQ3MOT9bMiBZvV4JW/18/Gao0fLAJIA3kwS/tsW?=
 =?us-ascii?Q?I2qnholQUVsN20hFnTP9CCqNYItWlPTjANK9+Avw06C0iZ9f9GkogFGQvGuH?=
 =?us-ascii?Q?sXxn+kYJIIwkzQh5F+MFd17wXetlvq15i0JrhVmUr7mE/uLV5iGRHdkv4A6I?=
 =?us-ascii?Q?bjqEjMpzLvTl6bLB9OiZe03zxyfbI0Mq+yW0LEVkcPMNPSUs1YO03rN3ZDKL?=
 =?us-ascii?Q?tLWFub73jg53FPuTdOhkDLXimE3jQ/okBP7oreezNLBoHOV89AsrL5rhfTyQ?=
 =?us-ascii?Q?vmn27eSN0P0BSPYY+da4rcShsYXTl5oy60xo96sUy7IzoqqV1mO/08JD8pOx?=
 =?us-ascii?Q?S3DUCwvFalc53N7fKB1pbJsIPHb6SuE5ptaRJ0gZRO2NZeRGJe2HCMP45MYj?=
 =?us-ascii?Q?qAuW7h/tzfVbRHO1Xt8JDKq+7op65uwcKl9NBoj7VcdVmFI3MrgW96PLa1VO?=
 =?us-ascii?Q?oP3S4X4Ti+fs8fdCRFTb2SJ9FPxIPOhIsB8fWAR5vcIYG7ki2A5wExu2M/Yr?=
 =?us-ascii?Q?kywouNipP6UwmgQP3g98ffB6xL1na8pnLzzQae6uoP5/rqH59gg4oeG+PxJd?=
 =?us-ascii?Q?hIpvVsDVkJPTvrN4lZc0VI6jxd3vMsPWNqxQ2aLwQ8jcWlwi4RjpQUKme/7l?=
 =?us-ascii?Q?auiGZnM8nPb4WWyg7xN6q4iKUsm75OQMCJhwL+6PFBbMCjuUL2bZulrE0HVv?=
 =?us-ascii?Q?jSaNcIodrdZg5QiwGAIKYviwPc78HmJPNVcIonIzEqf5beY0Z96wDfNCjuS7?=
 =?us-ascii?Q?dnGzQyjY7FS26DCVbd49SlXLVmnz3wzmn5D7uA7A7VEcM3ceTKg/wbXM5Cyq?=
 =?us-ascii?Q?Bw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21470a44-bbfe-4cf7-4d52-08dac8f8247a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 00:02:11.8442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kNMqmgrs3fiGVp/eOwZDcR9RWnUPfnpjRWsou5lqUH5th9sVu7jE0jLjCXIS67Czrv3wVEhyY2vlxZIAswplvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8542
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently Linux has no control over whether a MAC-to-PHY interface uses
in-band signaling or not, even though phylink has the
	managed = "in-band-status";
property which denotes that the MAC expects in-band signaling to be used.

The problem is that if the in-band signaling is configurable in both the
PHY and the MAC, there is a risk that they are out of sync unless
phylink manages them both (setting in PHY may have come from out-of-reset
value, or from bootloader configuration). Most in-band autoneg state
machines follow IEEE 802.3 clause 37, which means that they will not
change the operating mode of the SERDES lane from control to data mode
unless in-band AN completed successfully. Therefore traffic will not
work.

To ensure that systems operate under full control of this particular
setting and not depend on what some other entity has done, let's
introduce a new PHY driver method for configuring in-band autoneg.

The first user will be phylink; the main PHY library does not call
phy_config_inband_autoneg(), because it does not know what to configure
it to. Presumably, individual non-phylink drivers can also call
phy_config_inband_autoneg() individually.

To avoid regressions with board device trees which may rely on fragile
mechanisms, gate the phy_config_inband_autoneg() call with the
bool sync_an_inband opt-in. Also skip doing it for PHYs on SFP modules.
I don't see a need for those, so don't risk making a change there.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4:
- s/inband_aneg/an_inband/
- clearer comments, added kerneldocs
- opt-in via phylink_config :: sync_an_inband

 drivers/net/phy/phy.c     | 26 ++++++++++++++++++++++++++
 drivers/net/phy/phylink.c | 12 ++++++++++++
 include/linux/phy.h       | 10 ++++++++++
 3 files changed, 48 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 2abbacf2c7cb..37cdd9afd7e1 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -758,6 +758,32 @@ int phy_validate_an_inband(struct phy_device *phydev,
 }
 EXPORT_SYMBOL_GPL(phy_validate_an_inband);
 
+/**
+ * phy_config_an_inband - modify in-band autoneg setting
+ * @phydev: the phy_device struct
+ * @interface: the MAC-side interface type
+ * @enabled: selects whether in-band autoneg is used or not
+ *
+ * Configures the PHY to enable or disable in-band autoneg for the given
+ * interface type. @enabled can be passed as true only if the bit mask returned
+ * by @phy_validate_an_inband() contains @PHY_AN_INBAND_ON, and false only if
+ * it contains @PHY_AN_INBAND_OFF.
+ *
+ * Returns 0 on success, negative error otherwise.
+ */
+int phy_config_an_inband(struct phy_device *phydev, phy_interface_t interface,
+			 bool enabled)
+{
+	if (!phydev->drv)
+		return -EIO;
+
+	if (!phydev->drv->config_an_inband)
+		return -EOPNOTSUPP;
+
+	return phydev->drv->config_an_inband(phydev, interface, enabled);
+}
+EXPORT_SYMBOL_GPL(phy_config_an_inband);
+
 /**
  * _phy_start_aneg - start auto-negotiation for this PHY device
  * @phydev: the phy_device struct
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 598f5feb661e..ca3facc4f1a7 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1691,6 +1691,18 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 		return ret;
 	}
 
+	if (pl->config->sync_an_inband && !phy_on_sfp(phy)) {
+		bool use_inband = phylink_autoneg_inband(pl->cur_link_an_mode);
+
+		ret = phy_config_an_inband(phy, interface, use_inband);
+		if (ret && ret != -EOPNOTSUPP) {
+			phylink_err(pl,
+				    "failed to configure PHY in-band autoneg: %pe\n",
+				    ERR_PTR(ret));
+			return ret;
+		}
+	}
+
 	phy->phylink = pl;
 	phy->phy_link_change = phylink_phy_change;
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 56a431d88dd9..6f8d5765cf0c 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -860,6 +860,14 @@ struct phy_driver {
 	int (*validate_an_inband)(struct phy_device *phydev,
 				  phy_interface_t interface);
 
+	/**
+	 * @config_an_inband: Enable or disable in-band auto-negotiation for
+	 * the system-side interface if the PHY operates in a mode that
+	 * requires it: (Q)SGMII, USXGMII, 1000Base-X, etc.
+	 */
+	int (*config_an_inband)(struct phy_device *phydev,
+				phy_interface_t interface, bool enabled);
+
 	/** @aneg_done: Determines the auto negotiation result */
 	int (*aneg_done)(struct phy_device *phydev);
 
@@ -1557,6 +1565,8 @@ int phy_start_aneg(struct phy_device *phydev);
 int phy_aneg_done(struct phy_device *phydev);
 int phy_validate_an_inband(struct phy_device *phydev,
 			   phy_interface_t interface);
+int phy_config_an_inband(struct phy_device *phydev, phy_interface_t interface,
+			 bool enabled);
 int phy_speed_down(struct phy_device *phydev, bool sync);
 int phy_speed_up(struct phy_device *phydev);
 
-- 
2.34.1

