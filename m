Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E14AC62E9F7
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbiKRACT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiKRACJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:02:09 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80042.outbound.protection.outlook.com [40.107.8.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69C870A3D
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 16:02:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSqLr03e2UROUCvFV598VOB2LmKjmqWtumoqjGXI8JqmSrghjqumBAupO4L/dWy4sLXiWYTQlevjbLtqwNAWYaYt51wsTFi6iV1g/O8S3WAN0njNNy47Ka4X82ELIduQZcEbOt8EBXDDVbD4k0HMeU2j5JMfgR/V4E5dkwYQPrMHthtm3iQhgPcL4l08jF4YrKUqSirxkRBmyTRe6bz5KhqEROk71pRfvxzA0Mjk+u45ZlGN9yargblAA3C52t7jh/13140MYF1EyajSQ3yHJ3OMGd7qcVay4sFHK6TWl3RIksVcRjv3Ey159OHZ+Ma9XoSWxMvWrMqwCtTd8FmjWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DEgFNu/12zWZx/LJYWUjjs28ForFgD+UKF3WxHJ1ToU=;
 b=diITORCq26pY26sV2lOyam0nIET4jJNq+74CPBc5R1an4uPa4rerzgJRq+oV5K4X6hNqgutb2xwkK/jDcfyfb93tOx3GteWSN77pkrURAoV05IDEYfW2gaJWcqqNqzf3jME4qXbnM7HCJwKhj4hFhVhtE3uJ0aOgHX+Ow2lBHDHfpqb9FgjyqXAJ1P79KC5cEmPxsfypxWExs0gwGaCUwzgxjMHA4CTbgxREemEo/V8uc/LPpWA08zGbpIBwF+AgukQDR+tUSg4gkKxWXxUoxpZGa5+LA7yACNdNK5Lkbj4Kqym5fQa9uwIgoAjHgpjYa6a1tas5PB71RDVKi28VQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEgFNu/12zWZx/LJYWUjjs28ForFgD+UKF3WxHJ1ToU=;
 b=qbVDhjWDjcqHDS+4Iw6pQm332I47EkUidPBqGmVp8ZYcnl7qDjuB2MsQtsejSraBuBGahNO+lepNQZ4kW6hpm2vMahYEn6KBEGZrl/U5BX3OGbcFITLCM6Ppivau9Ur+5IfLGXeux7M7fKhXdCKL9XImxLRkvFvXK8V9oKak6Ao=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8542.eurprd04.prod.outlook.com (2603:10a6:102:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 18 Nov
 2022 00:02:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Fri, 18 Nov 2022
 00:02:06 +0000
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
Subject: [PATCH v4 net-next 2/8] net: phylink: introduce generic method to query PHY in-band autoneg capability
Date:   Fri, 18 Nov 2022 02:01:18 +0200
Message-Id: <20221118000124.2754581-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 76609c53-5a0f-4708-fbd5-08dac8f8210c
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hxq7KO/lxrs2T4FNCYGB+vfJtlixWJV0mL1b/xoo/lw899elAU5g0LaGuFMEB/JwER+LtLHTyXJZC03tRhwGy9RBFoWCP8WIwnHkgm9neE4dZOm+JkYjr1bhz1o2UmsZlte9xg1KSEVE/uO9BKBmXpC0KUbb+3XFEEwOwncaq1WV9vv0AjSb0TPu1SZZ/DwtmVHZmmnQp0j248soNIfbFOmbrEhxgKTIKI85c1fufDmileCdbwSZtf8pOaq0SkzBcjbhhILXeeWDKm0KnXdvsmbnOX6nfq77hDV63zHn3UXBhc6S51ctW1Q2OkUCF0uKL5r0hW0WIPYsdgqIgn8PQ9cGtDKsryPzIitssBluFak4f0Aa6gaVtIGyvCykrxvfSPcCmJkNKNwlQKFxLvgBhYyfAege+Vhvfn/RVJcZF5aPNu+FgDtvD4MGlB1PBFp53U74DyBmOvGzhSq+8ESo1GJGPUwtgbUkzhdsjWGMu6+x2TEMeq6NzDDppgJ/gb8qr/mF0UulYYMedv+PdU62PawMoeH7lANowWSpyn/IGPJYuhaOJOChpKax4xGdh6XrBermw9NWhITrOioO42+wvqypgFH8XZ8L5NdYDNnMdosl2X5qq40g8DuM4Jyekn2/W8B3Sy8eelvRyY7A5bV7ONzq2fvt1afVmPp3iUUcAJWBXkp2PuLXJnLBF23YqrYgA0hd6X7FcGXQnr/MnngIbYa7ip/0IffRj8uAaM+8eBQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199015)(478600001)(26005)(41300700001)(6506007)(6666004)(36756003)(8676002)(52116002)(6486002)(4326008)(38100700002)(44832011)(7416002)(8936002)(2616005)(66946007)(66556008)(38350700002)(6512007)(66476007)(186003)(316002)(1076003)(2906002)(54906003)(6916009)(86362001)(5660300002)(83380400001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k5fLdKJlLK9l3yxQp91jwULQ26A33y6ABE/EUj12QNLB9LvZ/BRUXbBv2r5a?=
 =?us-ascii?Q?gycA8teYrgMScDr2QpwX3fa1BkrBDdNs43YZDOYgAXfOSW3f5BA2GBjsk1+u?=
 =?us-ascii?Q?q7L01sMJ8CM8ReGKByxuj+bSWT96EW03BLLhL8pydzGlkBGFHdJTHnVJuooa?=
 =?us-ascii?Q?RGS2I4gtKGdXgO2Vw+6h0mFRgim/6WdQxoAk0/BxkpoVnGNeNtb8yd7MoXhc?=
 =?us-ascii?Q?S7cLpRWu+SYkZRqV8K7a4m58xFgpKA79IW236AkiVJgkHE5ROz6Zmfq9CgPx?=
 =?us-ascii?Q?6PdcN9G5dlcdTbHFDtJwggQ6RtYlovE+6o2gIsptLN2tXvk+soIX8uy+D6l3?=
 =?us-ascii?Q?J0Y004f0Yb2An7R4nsWp7NBijW20M1HErJcmMwV81tJ/6uNZ4M08/MQf1CXr?=
 =?us-ascii?Q?KYqAlY1nEeluNRY6Ib158Xqw2qr67MoTvqPEfSQHgXXJw9QsmnZzmBEbtUP/?=
 =?us-ascii?Q?QH4sjyh5+p/rpphKxW5s5ipSDYdM1zB5IwM25F2p0zvwzUrZIY+MRm87rdTc?=
 =?us-ascii?Q?2OMjXbJ6f2t0vg3FqqsegF6kJRUdI+A4O02oQLZM+fS6rKdPkGTOWaBVjmNH?=
 =?us-ascii?Q?EpDMshkzSCPkPGGj5slFdnaVXIilkoHcjSUEhGvU6TMI6eiPj5+/AYtINfny?=
 =?us-ascii?Q?L8QKnpy0Tm3zBzoM7+tKSsdZetFqmtSO8GEQn1m4/Prs1T6KgR6I0+ZNDfwz?=
 =?us-ascii?Q?WXMHZ9fxglf6HlDJVWNg5I/PJ7r9FABq6zO9JDfsEE03WV+aZmUHRBxpdvgU?=
 =?us-ascii?Q?P9uZ08xNzbtM91AHU8qxclpAXHuAev+qpnpP0zFLAwjK86tQXcGlqHaRVQJo?=
 =?us-ascii?Q?PKgnYqmuvZEX3BTM6V6hlnm/Mx9jObwdXGvhbUwznUh9PDvx/QBBdS+/1XWN?=
 =?us-ascii?Q?z1t7HMkVuJ71Vsv1byZDZ/BkI5aZg15Ky04BavPlZ/d8g2x5Wus0i37To4CJ?=
 =?us-ascii?Q?GnuD81ulOjR73qHBrYopA8V8JxpXGadMWjQQiQpdu0Oh/dxchjHj6+aPSDUj?=
 =?us-ascii?Q?zYK+MlX0zlJtSSuAhgqg+Ppl+yYiL6L8Zhm1Ot52DJkdSuoQ//MpinrpfUql?=
 =?us-ascii?Q?ayEwgsRus9vVU8Txu/qHxgi1Ww+meErn2NmMSATbu3S61d8DzE3FveNANoJ5?=
 =?us-ascii?Q?xH7jfcf0LcFJrTGuoF7HSD68YNPmYG0VOihgqrR3lGhs3DxTPAv4CIRRv9yv?=
 =?us-ascii?Q?/SwJe/kslOQLJFCLxCSNsAon88ok0bZf94Oqx8q93EUII7nYNNLephp9+iuY?=
 =?us-ascii?Q?zf09KXmK5SVatS5qwhINeSrqOHw5cOaQ7i5mC+BajrV/Bom6kKA2hrS3RqHb?=
 =?us-ascii?Q?2tejQhQbqUcC9bkbIuVCKvWvEsZfvxgQBQpgqPT1pY3dFQm5ENeURqufY0Mg?=
 =?us-ascii?Q?ESLR1ThcAtETFq4phogOr6rRmIwwT4d8pUTnL1oEUE+1uO7D58I1AJNBe+1D?=
 =?us-ascii?Q?pi49Dgjs8MsW85cnqu1f18AC0sBfZ6Pe0NdsfZ9oFmXgIECWMMpE2BpESSio?=
 =?us-ascii?Q?8Tpf0EfhQoz1yI1JQfp7MprwnbssSuxnS5ks+mo0sp4wnp2xvn6DoyxAusyH?=
 =?us-ascii?Q?vp3eFodN7er5JC+LdazjXXZ7R4v8lnGntWZxUmAd4Zb95szNf+K+VGNizzrL?=
 =?us-ascii?Q?Dg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76609c53-5a0f-4708-fbd5-08dac8f8210c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 00:02:06.0321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E2aniAjS74PulFhnEv1EdBoscGHsTnar9wv5vej3vOGbFj4tnTtKLjqJs15eaRFsxug4NrmcLaYKggXywS/+0A==
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

Currently, phylink requires that fwnodes with links to SFP cages have
the 'managed = "in-band-status"' property, and based on this, the
initial pl->cfg_link_an_mode gets set to MLO_AN_INBAND.

However, some PHYs on SFP modules may have broken in-band autoneg, and
in that case, phylink selects a pl->cur_link_an_mode which is MLO_AN_PHY,
to tell the MAC/PCS side to disable in-band autoneg (link speed/status
will come over the MDIO side channel).

The check for PHY in-band autoneg capability is currently open-coded
based on a PHY ID comparison against the BCM84881. But the same problem
will also be need to solved in another case, where syncing in-band
autoneg will be desired between the MAC/PCS and an on-board PHY.
So the approach needs to be generalized, and eventually what is done for
the BCM84881 needs to be replaced with a more generic solution.

Add new API to the PHY device structure which allows it to report what
it supports in terms of in-band autoneg (whether it can operate with it
on, and whether it can operate with it off). The assumption is that
there is a Clause 37 compatible state machine in the PHY's PCS, and it
requires that the autoneg process completes before the lane transitions
to data mode. If we have a mismatch between in-band autoneg modes, the
system side link will be broken.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4:
- split the SFP cur_link_an_mode fixup to separate patch (this one)
- s/inband_aneg/an_inband/ to be more in line with phylink terminology
- clearer documentation, added kerneldocs
- don't return -EIO in phy_validate_an_inband(), this breaks with the
  Generic PHY driver because the expected return code is a bit mask, not
  a negative integer

 drivers/net/phy/phy.c     | 25 +++++++++++++++++++++++++
 drivers/net/phy/phylink.c | 20 +++++++++++++++++---
 include/linux/phy.h       | 17 +++++++++++++++++
 3 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e5b6cb1a77f9..2abbacf2c7cb 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -733,6 +733,31 @@ static int phy_check_link_status(struct phy_device *phydev)
 	return 0;
 }
 
+/**
+ * phy_validate_an_inband - validate which in-band autoneg modes are supported
+ * @phydev: the phy_device struct
+ * @interface: the MAC-side interface type
+ *
+ * Returns @PHY_AN_INBAND_UNKNOWN if it is unknown what in-band autoneg setting
+ * is required for the given PHY mode, or a bit mask of @PHY_AN_INBAND_OFF (if
+ * the PHY is able to work with in-band AN turned off) and @PHY_AN_INBAND_ON
+ * (if it works with the feature turned on). With the Generic PHY driver, the
+ * result will always be @PHY_AN_INBAND_UNKNOWN.
+ */
+int phy_validate_an_inband(struct phy_device *phydev,
+			   phy_interface_t interface)
+{
+	/* We may be called before phy_attach_direct() force-binds the
+	 * generic PHY driver to this device. In that case, report an unknown
+	 * setting rather than -EIO as most other functions do.
+	 */
+	if (!phydev->drv || !phydev->drv->validate_an_inband)
+		return PHY_AN_INBAND_UNKNOWN;
+
+	return phydev->drv->validate_an_inband(phydev, interface);
+}
+EXPORT_SYMBOL_GPL(phy_validate_an_inband);
+
 /**
  * _phy_start_aneg - start auto-negotiation for this PHY device
  * @phydev: the phy_device struct
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 9e4b2dfc98d8..40b7e730fb33 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2936,10 +2936,24 @@ static int phylink_sfp_config_phy(struct phylink *pl, struct phy_device *phy)
 		return -EINVAL;
 	}
 
-	if (phylink_phy_no_inband(phy))
-		mode = MLO_AN_PHY;
-	else
+	/* Select whether to operate in in-band mode or not, based on the
+	 * capability of the PHY in the current link mode.
+	 */
+	ret = phy_validate_an_inband(phy, iface);
+	if (ret == PHY_AN_INBAND_UNKNOWN) {
+		if (phylink_phy_no_inband(phy))
+			mode = MLO_AN_PHY;
+		else
+			mode = MLO_AN_INBAND;
+
+		phylink_dbg(pl,
+			    "PHY driver does not report in-band autoneg capability, assuming %s\n",
+			    phylink_autoneg_inband(mode) ? "true" : "false");
+	} else if (ret & PHY_AN_INBAND_ON) {
 		mode = MLO_AN_INBAND;
+	} else {
+		mode = MLO_AN_PHY;
+	}
 
 	config.interface = iface;
 	linkmode_copy(support1, support);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9a3752c0c444..56a431d88dd9 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -761,6 +761,12 @@ struct phy_tdr_config {
 };
 #define PHY_PAIR_ALL -1
 
+enum phy_an_inband {
+	PHY_AN_INBAND_UNKNOWN		= BIT(0),
+	PHY_AN_INBAND_OFF		= BIT(1),
+	PHY_AN_INBAND_ON		= BIT(2),
+};
+
 /**
  * struct phy_driver - Driver structure for a particular PHY type
  *
@@ -845,6 +851,15 @@ struct phy_driver {
 	 */
 	int (*config_aneg)(struct phy_device *phydev);
 
+	/**
+	 * @validate_an_inband: Report what types of in-band auto-negotiation
+	 * are available for the given PHY interface type. Returns a bit mask
+	 * of type enum phy_an_inband. Returning negative error codes is not
+	 * permitted.
+	 */
+	int (*validate_an_inband)(struct phy_device *phydev,
+				  phy_interface_t interface);
+
 	/** @aneg_done: Determines the auto negotiation result */
 	int (*aneg_done)(struct phy_device *phydev);
 
@@ -1540,6 +1555,8 @@ void phy_stop(struct phy_device *phydev);
 int phy_config_aneg(struct phy_device *phydev);
 int phy_start_aneg(struct phy_device *phydev);
 int phy_aneg_done(struct phy_device *phydev);
+int phy_validate_an_inband(struct phy_device *phydev,
+			   phy_interface_t interface);
 int phy_speed_down(struct phy_device *phydev, bool sync);
 int phy_speed_up(struct phy_device *phydev);
 
-- 
2.34.1

