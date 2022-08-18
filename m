Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B36598948
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345043AbiHRQqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345014AbiHRQqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:46:37 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2080.outbound.protection.outlook.com [40.107.22.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0F9BFC67;
        Thu, 18 Aug 2022 09:46:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eeHcxDJjReSkx96j1kaD/0fKF7TRCprADaax5frCG68n+RInyzLLDZBRLPLyus9B1r77RlPEhxrhEjTWf0OigIRxMTfNFNoBBuOTofs8h8V82USSVtwEcib080fDu6Q0EBW/f6NlMpznHiN182GEPVVCXXthmdqK/YsC5GdFMYdyguz416egpMny6F1l/KFDN7KFttW+XDoOsou5YvGWGvYHggaqe8jwNWJlugvtQAx45d5Rsvvsgf4p51gykV8y0uoR5M7NAZyFSwwAj2YhKVCB8TKW/Mee6f5AF4SrrPIMteHPRzK+7wyi9J7TuTmRphrDxKx+EHX/aBwCNx3M1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5iFmrfwwkbvAIW1DiuwmjTQzQA6j27fMaHDaUsHht0=;
 b=H+vBiK+2pR1XK2NG+Tv8orzRlhTWNe5+tb3gPwsIQVJqtP7w9ghd3h//PviVTzd6lGy/+2wT0viU6QYgjfaMwitbdXXw1ZwY2hIoO4u3Zg84C/EC/AvibFIsnvO5AQVnQqkHHCypYWG7YaxC/Kno8uWRKU7t4jGgc3BJ4N1Xm8/pYTHEwewh2GJTSp0YzhQWwmkII6fSXtND+wwHC0Ryto2R0E9LH1FteXiz0B6qhmdLnLeI3oYzPf8uR1JxNmg8V1CtQLELwCkWpDbs2qZpeIULl/BS+narPFv4DcqeeeVOes1nGiMAzptMeBLV0YcEoN2VBN/EAuqzAQDih5GrrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U5iFmrfwwkbvAIW1DiuwmjTQzQA6j27fMaHDaUsHht0=;
 b=Gxhyeev612xdWPVePtk5xZRvQM+B7/1MVlsXRYRr/6GQfH5wAx1jIncewsp/fF6+LrELzt7bZeEGH6vRBoPdyMCD9aRBlJK98UYtle6THKuty5iy9OjaOAWSK9dQy1LslYpq+exHNDyVNSJtLxGmG5HeeZZtSDX3y1xn/72KqbOTosfwqRI3oqVZHgbynLqEVK9L6zZmL2J1dFf8xPamQXTN/qV7/5w4GIHGSr0vCMrpJ6oSRNEPfyjIzUoC2/eBHh8rwqtekBQZunBFHoRAQq3eNcd8/I33Sg4yk1zW03zle2q2m6dzfcnCtMhEEe1MxRNWcNgvBfGlmU5aMDwafg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7649.eurprd03.prod.outlook.com (2603:10a6:102:1dc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:46:33 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:46:33 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v4 04/10] net: phylink: Generate caps and convert to linkmodes separately
Date:   Thu, 18 Aug 2022 12:46:10 -0400
Message-Id: <20220818164616.2064242-5-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818164616.2064242-1-sean.anderson@seco.com>
References: <20220818164616.2064242-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0019.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9128ab41-a051-4d8b-cac5-08da81393526
X-MS-TrafficTypeDiagnostic: PAXPR03MB7649:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D4UJxDuNtAWrHBYbiCZaowD7H/JVqJmunko70lr95FHROgpnSQJGvsb6nlw4a9geiFIlyzceDdLWZpkJiO+0lMTkaIIHiwdxs4I1hHHIugBIStRSbKoV9OdVlaCJCMpYTL8koVpZll2vQhS9nYIPKYtufxmv1ZGf1RyvwaRMFqjX3GWvXZaagchSgcOGAWQehVFvRIqwAGhoFiia7ay8L4j1Sd+VFoYzxC9Y2/nWKYgNnf+HgmGlza2HMLdDcm2zZ8fmVCY3RiYkzjLYpSeLRmjoGZIC8zRQX6tI8ydoOkUakp2Vyn/vs24ZXA+zQwlic8KD/9TWWL3cwoNwZ6VDafElAomSCxveYYsEuCQYlZ0HFEpHYnlXNDcLBYEHII0nByvTORcCk27Q7AJbh/vZU0tbxLjHQDTzrTzz+Gv3OrdyPzh2VqfWUFhsK2z1pIfW1UnXZMsejt1iu1DAToTb8DrDBZ+bHkmmfDsfJS+/5/XGAmC/SJS3WBMT2qD1pcUriS2PyeDFLTldOOwzlmY0rKzkitM6+OZMG5pai+w2SEpcgaCW91t5jAQMfs2m3rqem5fK95MnFVg0Wm7yjBhsJJn3znUotQXHI750lk0JCNh146QtAkDMDFJyk6/Q+llrrvqYi6TG5l/rsPz9eZsxKWGXjfRY+oe/ey5kZfzYL9NBqqfWHVN4OUyF5ZJks1QZ2oLehZKdnef5Bm0gP7YuYxMr+Ot2j/J5tdUgTvIhlJP1HH99qY/fpMWiWUj8AmYcauS8ElgPxo4eCtlcY4qS6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(396003)(346002)(376002)(366004)(136003)(66476007)(66946007)(478600001)(66556008)(6486002)(8676002)(2906002)(41300700001)(107886003)(6512007)(86362001)(52116002)(4326008)(6666004)(186003)(1076003)(2616005)(7416002)(44832011)(5660300002)(26005)(8936002)(36756003)(54906003)(110136005)(6506007)(38350700002)(38100700002)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hyYBn09OHaUBehqhVLQchuWstE3FNMvxjKClryK1a9wby5pv5JbJKGlwLKuy?=
 =?us-ascii?Q?hAUUvJLpqg3ZdW7vTEWujXayN2crcbXLbXvNohI2zbRKxQ1/tVYjZ8pfuY86?=
 =?us-ascii?Q?nZuyFQyGUY3KS52YammjH6jxmFpEdAuggsAOFuoBIy0fC7dyNwzyX+z0TAbm?=
 =?us-ascii?Q?DJQInZqK9zQolDuBgAQHJEDOPmUVj3f7A2i/GuVsiJTtaPAyGbCJZ58M3IJo?=
 =?us-ascii?Q?TgWzYOQLWEo7YHUxF0ewy3ohg48gttJvcu4XifUKy/2Fvgy4XphWgwSJePn3?=
 =?us-ascii?Q?JfolqmqX2QCuJTEbAcpJyL+mYQwg39kn6cezwrEqKafEE5qFpYxPsob+Eihc?=
 =?us-ascii?Q?Jajd2kSJpyOVI9C+gIZkrtS6uk/G3uMcHqJhPxROlcIi4dgrrHdrfNvGoHRL?=
 =?us-ascii?Q?ZNggQRNm7hvlS3+4cLnSDzWZH83nr3OFH/Gdp4qaoQBCP7EDJ3O7R6OoEKhg?=
 =?us-ascii?Q?Z+2p817dCfoqGRBAEJg187qutBe/R725B/XBWamfBJJ40HYcQgnTLKlULwUg?=
 =?us-ascii?Q?5+ndSmFLwNsr2K0x+TpGEpfzuUZuC2pR7sMV6Q64v7P2S00DXrg/zowwxXJv?=
 =?us-ascii?Q?fRxC8JL0AMb8O8TCP4TrLE9FeoWmy4r8J1dFfkrJuBJ3tn0YUorSTNXeEdHW?=
 =?us-ascii?Q?/QD48Egyh5FQSyHff+LvTdmJLAQRzr8EMDd2peFR3XjesSQ9lXTXZ9L1811j?=
 =?us-ascii?Q?LrPv7VosQppYLcX9Mc4NyPsSwUvO1Q6jBhfTnHKfX7MqdX0zF6ewHG7TA+LO?=
 =?us-ascii?Q?xms77ys5XRWyKwKnRM0GzfJ/0DHdt9yOqt8Du1l2mlW0kwYyfCKMI+9a1tNJ?=
 =?us-ascii?Q?D7QnwiCaM2F94L6WO9jnaVUWZIC7b0p1/990ygk9gkiLYX/1pKVtr2r+WnC3?=
 =?us-ascii?Q?tQpUg98v3L8GMa2F4FcGS1Lsi3GAnqqor0Dye2jzO+P+wJcZ2JIw9k6BBobS?=
 =?us-ascii?Q?Ba8eZMXdUyxr8F1lFqRdi4Rbtyy/SC4WtVLRbHk42RFlpvdR4Spua2wbzfIz?=
 =?us-ascii?Q?jeOA7P0lHh4+j7DQfH66A1PJJxZ1ZpcouM44Gfij2uOmqX1tHv5SutNYkZV0?=
 =?us-ascii?Q?8KI/WZyQLdeJMn9GPithhrdcDAjvH/acEW1FOd1+EQfkc+prNpYqVPdAjEut?=
 =?us-ascii?Q?/C/hO8qOgynLnFWPJzzVpcK6tA8yv9F486GBfTgsq4rxJGF8Keo8Z0CjFNAp?=
 =?us-ascii?Q?khOfbQkW3UBpMo43Mt1fO6mQynBtc/i9b7fCLfCkN4PpB3kOHavS3g//Xl/8?=
 =?us-ascii?Q?pGyWWXAmFWtyAmdzk+KRa5x4MhXG//SBqjZ/u6BVzFQnpfrVT13YvUfr1MZ8?=
 =?us-ascii?Q?jdumZSJyKBNqMtefMeX5Gp28L1Y9GOjv+JHsZkK5KGQqDRlDi84Xf/QZvuPD?=
 =?us-ascii?Q?p64HkYKFtA4DzkO9KGAteqnKsbh3D3aNFSkU4V9rFGXEFKCp3cZJo7+c9+aC?=
 =?us-ascii?Q?76B50zxNZtDbxW2aHEEJEwWSlAkAChRcV1C9XUWr4os8pe3UcTliXyghlLjV?=
 =?us-ascii?Q?9pZ99uHtSVYUklCVzMcmScmlP2GL4ZkyGu4RQLDOMXX+M/WS5+Yz0q/rFEbb?=
 =?us-ascii?Q?GgLo6rs8MY7s5aNPSRYBp+So7c95ZL1hkI6PjO5fhOMrrBisiosZIE7+Z894?=
 =?us-ascii?Q?rw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9128ab41-a051-4d8b-cac5-08da81393526
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:46:33.2450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HllbtHbLm/O2t6ZYyQ7VmxzYkhhOKaT4yDSeNIsSPLWJMBPxGZTZLvtqcVJQLQ9voRGSdXbppjosMdF3xARKlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7649
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we call phylink_caps_to_linkmodes directly from
phylink_get_linkmodes, it is difficult to re-use this functionality in
MAC drivers. This is because MAC drivers must then work with an ethtool
linkmode bitmap, instead of with mac capabilities. Instead, let the
caller of phylink_get_linkmodes do the conversion. To reflect this
change, rename the function to phylink_get_capabilities.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/phy/phylink.c | 21 +++++++++++----------
 include/linux/phylink.h   |  4 ++--
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 51e66320526f..68a58ab6a8ed 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -305,17 +305,15 @@ void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps)
 EXPORT_SYMBOL_GPL(phylink_caps_to_linkmodes);
 
 /**
- * phylink_get_linkmodes() - get acceptable link modes
- * @linkmodes: ethtool linkmode mask (must be already initialised)
+ * phylink_get_capabilities() - get capabilities for a given MAC
  * @interface: phy interface mode defined by &typedef phy_interface_t
  * @mac_capabilities: bitmask of MAC capabilities
  *
- * Set all possible pause, speed and duplex linkmodes in @linkmodes that
- * are supported by the @interface mode and @mac_capabilities. @linkmodes
- * must have been initialised previously.
+ * Get the MAC capabilities that are supported by the @interface mode and
+ * @mac_capabilities.
  */
-void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
-			   unsigned long mac_capabilities)
+unsigned long phylink_get_capabilities(phy_interface_t interface,
+				       unsigned long mac_capabilities)
 {
 	unsigned long caps = MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
 
@@ -390,9 +388,9 @@ void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 		break;
 	}
 
-	phylink_caps_to_linkmodes(linkmodes, caps & mac_capabilities);
+	return caps & mac_capabilities;
 }
-EXPORT_SYMBOL_GPL(phylink_get_linkmodes);
+EXPORT_SYMBOL_GPL(phylink_get_capabilities);
 
 /**
  * phylink_generic_validate() - generic validate() callback implementation
@@ -408,11 +406,14 @@ void phylink_generic_validate(struct phylink_config *config,
 			      unsigned long *supported,
 			      struct phylink_link_state *state)
 {
+	unsigned long caps;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
-	phylink_get_linkmodes(mask, state->interface, config->mac_capabilities);
+	caps = phylink_get_capabilities(state->interface,
+					config->mac_capabilities);
+	phylink_caps_to_linkmodes(mask, caps);
 
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 2a6d2f7a7ebb..661d1d4fdbec 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -535,8 +535,8 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 #endif
 
 void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps);
-void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
-			   unsigned long mac_capabilities);
+unsigned long phylink_get_capabilities(phy_interface_t interface,
+				       unsigned long mac_capabilities);
 void phylink_generic_validate(struct phylink_config *config,
 			      unsigned long *supported,
 			      struct phylink_link_state *state);
-- 
2.35.1.1320.gc452695387.dirty

