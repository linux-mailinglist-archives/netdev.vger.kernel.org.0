Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527B9457240
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 16:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbhKSQB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:01:29 -0500
Received: from mail-vi1eur05on2041.outbound.protection.outlook.com ([40.107.21.41]:7392
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234826AbhKSQB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 11:01:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BiLDocBSrIX5v+NLfozaxuxnXw8CN94DeP+G+qCRi6ec08esCoy/1Zjsb880w3Gdeaveb0JkM6db0rAfHH6ODsNS2n66s8QcY+1hhcKuxeNfv7gsF+N35L5Nz62iHtOcK7jg9cCxzXypd6MsIwkSs1QNI3DBfLBF1Lzte2uN76TcmiAnqKX6t1qk2GJMuqIMCLr4UXsfVQOFkigJABn8X8b0c8C4qT5SEMCtV1fHAwdQh4UNAKXkQ3/mSExkJron9Nc4xFjVCpHomM5uDWXa+dcsnU4DMa5FV2pO8duWPo1xaZ4gKLX6gJaWY3uTqL/7S+Vxwy2NtYtTZH4vRHZ8+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e43PMKFEPvzfICS6FkKMxXeX/CuQZI3Xf/V+thXfTaY=;
 b=FUM9lBbLog18h8X13af9b8xcQzJbsgync+R0/Fm2xBfny8Pfozjylr6qSyr0T09sdOJsrHUT/WVVN7DCSYs9G/pYWChWOC6JQGGUtnf4g/KeYMk5MOVexiWHIV5WB5XgQW+KBrldkkOFKHDJ85HDYcnUxofsfpDVgO0Wt6zYu0GeQ+ZhAw7v4wB0xRYMu6xlStyKolOKWe8VdN+VHpyeM2HsaY+MUGthIytcA2HLkDgA3RjUH1wYMYjz1WST3tryVrQIS3b2utnkDuPtbJeu9hXrZrGOv+MxuhnuuCaIzT6Pe7QAQABDepUdOFfRqSx25pf22YUsza0F0F0n5NmYIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e43PMKFEPvzfICS6FkKMxXeX/CuQZI3Xf/V+thXfTaY=;
 b=Tm0mMKFmEFkhLSPbH9sDyY3km2hQTzBqaefiaxsbcS71gYNM54MFXvl344OrsxbFWVkQmlvQydwVHFjD8c8zi8Q5JnYmM5lSfNgevyVL8ttaq10igXAiV99hEwFsUItsTXMFx3fVIZ6Vl1OWtL4ew/+3wVjdNpDQxkpWxljLdvQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7434.eurprd03.prod.outlook.com (2603:10a6:10:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.19; Fri, 19 Nov
 2021 15:58:23 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 15:58:23 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Cc:     linux-kernel@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v3] net: phylink: Add helpers for c22 registers without MDIO
Date:   Fri, 19 Nov 2021 10:58:09 -0500
Message-Id: <20211119155809.2707305-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0024.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::29) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by BL1P223CA0024.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:2c4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 15:58:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c76cfa5-f6ec-4364-6f29-08d9ab756a70
X-MS-TrafficTypeDiagnostic: DB9PR03MB7434:
X-Microsoft-Antispam-PRVS: <DB9PR03MB74342DC812989BE70F4E07F6969C9@DB9PR03MB7434.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oFDOjY94FVlXcELw2M60tPWyE1ME7+l5ZsoamcR0XWpbDJvHHH2HN51eMNL/HfJumpvtiD2o+QAnznzDZMopmRByJuhaIY+H9wGOSY5Zms1KGjzCVzpgMD+Qs2kyZNHd/8WMHQpySb2wqsc6u7RjERA8KOrxJZPoK94O1LfwKokrTC6KP59/lzokV1BZ8oLKANHATK9Ts6D6zhgHieWdxARvmZp8cMG2Aj+WnXe49UvJ3OJW60E9b+U9JjrK4hnjOQ/XHCTyuntxgYh9SuHXBa5OGTyUodF0UjFzNBK5ZNSWtZIY1mBpwvWbtv0cQ8Ll8xvB6T7OUVjVsgNP8R2OLpOdrstU9yskz4rwvk+JdWiai2YRs/PWzfMRRSrDigcoHwJvIcngMLYSKI+ryci3sKYGp+6XaHg5p/qVF/En6zKuap52GnvEJN/eOQe2tYreUi7wFSOuQhO0rzMNltNLIXfp8X8b7kNb0W8rimlJTZcM/xp5K1MQDDQ+VZdJvgIxaVpdEAm9OaEAwM1W2THSkPhmPfyP+XPHfXSzZcsoeHxdvtgyAkQgJn58Ne3uFpfLCZYI7WwycdyZuRicbSMPBJQp3uHI8D10o23lelZyLLzXB5A+csN4sybu6M2Dkq1RSsst3J3uA7CgfJHyxJsYbQAHiI4BPEkUWhNelzn75MVdzQywq91I3xrXPkdKrkZWCJRLBAxe+MCbiBBgWP2HGpuK9sKlduk2haCiUXvkmYal6hXjjm2VQe1H0m2WLt5T/THf4Cwnj2w7wVUUXJ2Pznjqush7aOHOOLZfHoGTy+w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(44832011)(186003)(956004)(5660300002)(6506007)(86362001)(2616005)(54906003)(66946007)(38100700002)(38350700002)(6916009)(66476007)(52116002)(66556008)(316002)(508600001)(1076003)(83380400001)(8676002)(26005)(36756003)(6666004)(966005)(6512007)(8936002)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yCEgqV1u7DPGGoricYpJ5SLLdBjQ81edOl8fE5FE+YqeMMIUecWoq8Qj+l0d?=
 =?us-ascii?Q?ktLEMuslXeG82T8Gtc7C1wxEgLFQu68+5Sn7gwwC9bi0tKDNiSIWq3b94zVC?=
 =?us-ascii?Q?54cteMs1G9JnxH5K3zsVScEBdx3JNV9ykfxQdLnVQ4yzsLwWcEBVhL3uRM7l?=
 =?us-ascii?Q?r62BG7LNwO3rDpkkUzbOh7TVo/DvGlXS5FHz7Pk8b7kojPzMMBpjlAkfoimK?=
 =?us-ascii?Q?ji2FY4uC89yG2c33SgLG7dXoLj02OXa/kjIWvJxUXfYG4yUwdEam2Mh5widE?=
 =?us-ascii?Q?UyxqM4HKKhceuPKfYx15UJSCszQzSa2YZAFCeM0C/qfQm6Fzw4gwxMRijp5q?=
 =?us-ascii?Q?QR5TqUUeGG69Jvgwgz+NH3wqEHMTKJ0R1ibnEeLVUZnEUt1h2v1vuzJONVJn?=
 =?us-ascii?Q?xeHmT2ViwdoCvQwwjc/3VyoQN+UQi3el7SZWnAs651uF4cnIlmd/NXCUBL95?=
 =?us-ascii?Q?CKWhSXvKzthni98sEYY0Qns5VDiG1ITz1GCw0XKwLB1AK93XJpFOe+opLLHJ?=
 =?us-ascii?Q?6B3zJSbs5Cuq7oP+W0JUNbb5t+GrOaww06oHbYrA+8kSWtcqPlEkHCaJKE/A?=
 =?us-ascii?Q?vr4FHj1V31AkRpMio+H85RwUAH3np+WyWPILhFklpSZThAhgV+IT7Nb4HHE8?=
 =?us-ascii?Q?RONIvKOdAZyEOYPQJBOPeJyi+yf4KfSswdevTvQQxcjpeA/BAouKSi29Xq2E?=
 =?us-ascii?Q?nNC7lZs31TH0oSJdOPqe8E287uin2DW/9WZHI417q4zGn/saZYXi9Cyj7aMR?=
 =?us-ascii?Q?moA+t5weUDw2bYsdMLqgaP5Xr3/7zL3kYrEF4y/ML5P766lvdsChQ1LX6w5o?=
 =?us-ascii?Q?rtzj+XFqU0rErQS+nTz964azJyI2Glw3zETjIu+X2Mkta7aOIFpFlOotFAci?=
 =?us-ascii?Q?X1FMAupEWznpeiDsHs576FAUqUyYs9p+vs66cZNzbBg81r7m8SEIaH2/OFxq?=
 =?us-ascii?Q?8MZ65Z77nzMUZ8ULhQuiPqPLaJFL1v9WmaxKZtxMbyGcjaXVDjwWVygg/QrV?=
 =?us-ascii?Q?YIHDPOR6KiNDWeGXDQzZXWxqFV2Liz/G1aT+rUPsDVV4VXFkVLE9Rq3TkDNn?=
 =?us-ascii?Q?f2guMEw30Em2bDj3s/lpaZjO3Tr+yxe4uS/wK2Rct7mStxXe8syAv9kUh8v8?=
 =?us-ascii?Q?A2/vQ83pf7Y8c5e3ezlgcDYvi4VOG7DOywEoKXzCRoTljhUXSHIYSx/kLOwp?=
 =?us-ascii?Q?xn12iZoMjehGSFim4aG+P2JIurtryLwflvsR1xjppMxnugsGGwiMeCS95T+j?=
 =?us-ascii?Q?4uhVvvfFVep0gjCYURRJM/1sbl+Iw7f9zMfDUTGdo+mXxv1KW7McKhTqzToA?=
 =?us-ascii?Q?IByoD2W2xJcGTOR0TsJ8sixQ08P2tIRJtNwsgS+3a2dwvi5Y1OdqtcbYvDrs?=
 =?us-ascii?Q?sfDSq8wbM3hdyk5FbPRDDFm1OuLZabssGG2i9xjea8dlRjgL3EG4UnLEjq92?=
 =?us-ascii?Q?g8fM4MLJw8oMd0HiEFQxpas+qS9aqJU46PwYfWUc+rEfKbLvyZBM827nSunO?=
 =?us-ascii?Q?IX6pjEFQYMBqumI520PeQ1OIUREfBXqUgW3q8btxp6lzzeH4HTY/fh+5qgj/?=
 =?us-ascii?Q?AGggpakisPhVWPJbGpq/Gt3OnMUO6Hc98uuRLRZn6GUDCK9YhT7jcDILludG?=
 =?us-ascii?Q?QTBscb48YpWBGZowfuNG/qg=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c76cfa5-f6ec-4364-6f29-08d9ab756a70
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 15:58:23.7621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ESiHsyogFpbGGyPMfxV6DwrSVEdOifoU6hSJpuRerHCOQdHOgNd1HepPMxU40phQsnKCqG1Xz9+KjnVXECOaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7434
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some devices expose memory-mapped c22-compliant PHYs. Because these
devices do not have an MDIO bus, we cannot use the existing helpers.
Refactor the existing helpers to allow supplying the values for c22
registers directly, instead of using MDIO to access them. Only get_state
and set_advertisement are converted, since they contain the most complex
logic. Because set_advertisement is never actually used outside
phylink_mii_c22_pcs_config, move the MDIO-writing part into that
function. Because some modes do not need the advertisement register set
at all, we use -EINVAL for this purpose.

Additionally, a new function phylink_pcs_enable_an is provided to
determine whether to enable autonegotiation.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
This series was originally submitted as [1]. Although does it not
include its intended user (macb), I have submitted it separately at the
behest of Russell.

[1] https://lore.kernel.org/netdev/YVtypfZJfivfDnu7@lunn.ch/T/#m50877e4daf344ac0b5efced38c79246ad2b9cb6e

Changes in v3:
- Change adv type from u16 to int

Changes in v2:
- Add phylink_pcs_enable_an
- Also remove set_advertisement
- Use mdiobus_modify_changed

 drivers/net/phy/phylink.c | 120 +++++++++++++++++++++-----------------
 include/linux/phylink.h   |   7 ++-
 2 files changed, 72 insertions(+), 55 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 33462fdc7add..428f9dc02d0e 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2813,6 +2813,52 @@ void phylink_decode_usxgmii_word(struct phylink_link_state *state,
 }
 EXPORT_SYMBOL_GPL(phylink_decode_usxgmii_word);
 
+/**
+ * phylink_mii_c22_pcs_decode_state() - Decode MAC PCS state from MII registers
+ * @state: a pointer to a &struct phylink_link_state.
+ * @bmsr: The value of the %MII_BMSR register
+ * @lpa: The value of the %MII_LPA register
+ *
+ * Helper for MAC PCS supporting the 802.3 clause 22 register set for
+ * clause 37 negotiation and/or SGMII control.
+ *
+ * Parse the Clause 37 or Cisco SGMII link partner negotiation word into
+ * the phylink @state structure. This is suitable to be used for implementing
+ * the mac_pcs_get_state() member of the struct phylink_mac_ops structure if
+ * accessing @bmsr and @lpa cannot be done with MDIO directly.
+ */
+void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
+				      u16 bmsr, u16 lpa)
+{
+	state->link = !!(bmsr & BMSR_LSTATUS);
+	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
+	/* If there is no link or autonegotiation is disabled, the LP advertisement
+	 * data is not meaningful, so don't go any further.
+	 */
+	if (!state->link || !state->an_enabled)
+		return;
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_1000BASEX:
+		phylink_decode_c37_word(state, lpa, SPEED_1000);
+		break;
+
+	case PHY_INTERFACE_MODE_2500BASEX:
+		phylink_decode_c37_word(state, lpa, SPEED_2500);
+		break;
+
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+		phylink_decode_sgmii_word(state, lpa);
+		break;
+
+	default:
+		state->link = false;
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_decode_state);
+
 /**
  * phylink_mii_c22_pcs_get_state() - read the MAC PCS state
  * @pcs: a pointer to a &struct mdio_device.
@@ -2839,55 +2885,26 @@ void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
 		return;
 	}
 
-	state->link = !!(bmsr & BMSR_LSTATUS);
-	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
-	/* If there is no link or autonegotiation is disabled, the LP advertisement
-	 * data is not meaningful, so don't go any further.
-	 */
-	if (!state->link || !state->an_enabled)
-		return;
-
-	switch (state->interface) {
-	case PHY_INTERFACE_MODE_1000BASEX:
-		phylink_decode_c37_word(state, lpa, SPEED_1000);
-		break;
-
-	case PHY_INTERFACE_MODE_2500BASEX:
-		phylink_decode_c37_word(state, lpa, SPEED_2500);
-		break;
-
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_QSGMII:
-		phylink_decode_sgmii_word(state, lpa);
-		break;
-
-	default:
-		state->link = false;
-		break;
-	}
+	phylink_mii_c22_pcs_decode_state(state, bmsr, lpa);
 }
 EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_get_state);
 
 /**
- * phylink_mii_c22_pcs_set_advertisement() - configure the clause 37 PCS
+ * phylink_mii_c22_pcs_encode_advertisement() - configure the clause 37 PCS
  *	advertisement
- * @pcs: a pointer to a &struct mdio_device.
  * @interface: the PHY interface mode being configured
  * @advertising: the ethtool advertisement mask
  *
  * Helper for MAC PCS supporting the 802.3 clause 22 register set for
  * clause 37 negotiation and/or SGMII control.
  *
- * Configure the clause 37 PCS advertisement as specified by @state. This
- * does not trigger a renegotiation; phylink will do that via the
- * mac_an_restart() method of the struct phylink_mac_ops structure.
+ * Encode the clause 37 PCS advertisement as specified by @interface and
+ * @advertising.
  *
- * Returns negative error code on failure to configure the advertisement,
- * zero if no change has been made, or one if the advertisement has changed.
+ * Return: The new value for @adv, or ``-EINVAL`` if it should not be changed.
  */
-int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
-					  phy_interface_t interface,
-					  const unsigned long *advertising)
+int phylink_mii_c22_pcs_encode_advertisement(phy_interface_t interface,
+					     const unsigned long *advertising)
 {
 	u16 adv;
 
@@ -2901,18 +2918,15 @@ int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
 		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
 				      advertising))
 			adv |= ADVERTISE_1000XPSE_ASYM;
-
-		return mdiodev_modify_changed(pcs, MII_ADVERTISE, 0xffff, adv);
-
+		return adv;
 	case PHY_INTERFACE_MODE_SGMII:
-		return mdiodev_modify_changed(pcs, MII_ADVERTISE, 0xffff, 0x0001);
-
+		return 0x0001;
 	default:
 		/* Nothing to do for other modes */
-		return 0;
+		return -EINVAL;
 	}
 }
-EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_set_advertisement);
+EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_encode_advertisement);
 
 /**
  * phylink_mii_c22_pcs_config() - configure clause 22 PCS
@@ -2930,16 +2944,18 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 			       phy_interface_t interface,
 			       const unsigned long *advertising)
 {
-	bool changed;
+	bool changed = 0;
 	u16 bmcr;
-	int ret;
+	int ret, adv;
 
-	ret = phylink_mii_c22_pcs_set_advertisement(pcs, interface,
-						    advertising);
-	if (ret < 0)
-		return ret;
-
-	changed = ret > 0;
+	adv = phylink_mii_c22_pcs_encode_advertisement(interface, advertising);
+	if (adv >= 0) {
+		ret = mdiobus_modify_changed(pcs->bus, pcs->addr,
+					     MII_ADVERTISE, 0xffff, adv);
+		if (ret < 0)
+			return ret;
+		changed = ret;
+	}
 
 	/* Ensure ISOLATE bit is disabled */
 	if (mode == MLO_AN_INBAND &&
@@ -2952,7 +2968,7 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 	if (ret < 0)
 		return ret;
 
-	return changed ? 1 : 0;
+	return changed;
 }
 EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_config);
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 3563820a1765..01224235df0f 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -527,11 +527,12 @@ void phylink_set_port_modes(unsigned long *bits);
 void phylink_set_10g_modes(unsigned long *mask);
 void phylink_helper_basex_speed(struct phylink_link_state *state);
 
+void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
+				      u16 bmsr, u16 lpa);
 void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
 				   struct phylink_link_state *state);
-int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
-					  phy_interface_t interface,
-					  const unsigned long *advertising);
+int phylink_mii_c22_pcs_encode_advertisement(phy_interface_t interface,
+					     const unsigned long *advertising);
 int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 			       phy_interface_t interface,
 			       const unsigned long *advertising);
-- 
2.25.1

