Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD7731E5BE
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhBRFha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhBRFdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 00:33:00 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0603.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC5BC06178B;
        Wed, 17 Feb 2021 21:30:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kl4elLuqS0RnXoYsrJRyJSghr5HvSyaOfZ+K1nSk/Kfdtdf53FwZ2jpmJdoyG+yOG9rVhQliyPCBHuTQ5cnyCGW+KEzJirvzOxmfp/YemTLby/Twu5ZsQNPsRu4LOnCU6k/TdLGDpk5DjIhin95JFDFgUPL/KGdaJBV0x9bsNc9q3otveon7HEEbxGAatpHg47z3JGINPyrVAXNvdimq7qYlX3I9wSHgUnH9seMsbdAFa8YgY6Xm9O0IwarCAPYA/wfn1TZTyeo0OT7OWJkcUhKN2eMYWM9zG6woFHzr0RHIxxl0ap3g8SUreOAlRSEiUKzjqFJ++R6Umms6h28BIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sat9k8mmTr2czuiC/WMmPvp2ewbs5H0TYL05hbXyTl0=;
 b=B0Su2rb3ij/NS4ifKHywf/Ge0g5LPxtBIAeJsDfGTAX0BXeKb/GLszXZg/RtKegp4nzVfNkyyTNbGRy2EVH38nQ4bUO8ydLzS/VcSWkyraT/kQDuUZnRD0axalAOLoh3dg1UiK9Airq/pS/oc8jhWaEKzRJWTbCcHMwsSM68VmMaTQ2+ogFIoYOjq9MWEKLjfxoxCyGaUUCn8oW2yM+Ip3vmGWbBGD7dHp1tYl03f2tp23WTkBZuOx08j9v+yU5MhMpapR8w+QcjXCu2zRdR3FzmLWVml4CiVFjirKg7yYfyZ0bcBS6dhJ/gAXHdp/s5BHIc/+wZwaWGJMq0+Z8tqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sat9k8mmTr2czuiC/WMmPvp2ewbs5H0TYL05hbXyTl0=;
 b=gvdBPf/+uY4CI1g6rIMqLQKruAMROkF2AmXYJaHU32lx3gZNXZ4ZI1XFiM8jIqGA3p1PBidCZwPssTpWgudCynzzrlOYESMS7hUQMe6y4HVspi+zZ9janYUbTJyOB1tPYFJvRtq1d4ATcvcvQim9LirKKW3ir/3FKpOAjivKf+M=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7730.eurprd04.prod.outlook.com (2603:10a6:20b:242::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 05:29:02 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 05:29:02 +0000
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
Subject: [net-next PATCH v6 14/15] net: phylink: Refactor phylink_of_phy_connect()
Date:   Thu, 18 Feb 2021 10:56:53 +0530
Message-Id: <20210218052654.28995-15-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 05:28:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 184c9267-b80a-454f-c4b5-08d8d3ce1a05
X-MS-TrafficTypeDiagnostic: AM8PR04MB7730:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB7730F8268F2D90B9EA6CEBBDD2859@AM8PR04MB7730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AEHAX6QytgUN33X7/mmL5wn0Ucj9aNHGTPmQTmVTxth7UThVC7OZCnFwbDiu0C8GkO23s7NxjQBiwxqNgcSL6FCLIUaDVAs4gTqmm+kjPHQ2ZArXkhF5erYGthU0JIkNKw9IYpOEcgpyEu4P8a7UDxY2YAxQ2vAKr5/2J/VuNIXbutqE6plQBQRfcxe2bZFM64TllkwcyTonk99fA+IIHneP/ixafgpWftc0g0AymMFK7vBrrYZTWWx6/iH/pgfSbLg7f/IVJgi7YWwz9r2glQra7qwabZlo+H8k3fmlUPHuEa1nVPoepZ4qcvS+PsJIXuSCFtGccYl/ltgCrgvp97N6TpXR/tygD0HJtqqteANjfor4LkYofOlWVykEH1/fO+PoYX0p+it97CLNj43QaRFmoYlQie2aLW4HuYaxrc3sYzBuQKMn9rPZqZCk/N1q83veCJsfHoyxdq1uik5IuIaMU2Y3TtTTDMLa7vcUH1ba8MuHrywaedwKmXA+j6fdR+rjlhSMcwoscTpcY48nwmAPdoBY9TgUE+Fpr2wJOu/GFMMYQbjHb8cfCn1q0PbfQKO4q+AC7nn6G0tqT/2T2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(26005)(8936002)(52116002)(16526019)(921005)(478600001)(1076003)(6486002)(8676002)(55236004)(83380400001)(5660300002)(186003)(44832011)(110136005)(6512007)(956004)(54906003)(316002)(66946007)(2906002)(2616005)(1006002)(66476007)(86362001)(7416002)(6506007)(6666004)(4326008)(66556008)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7638ZFhu2g5K+hGGpzznaqXVpp+qKiwJHSMyN1nSLC/sKW3LiEzf7Hhg2O+E?=
 =?us-ascii?Q?UF8uzy0YeNw9D0f1zwQQIkkJ78ny5SYsgSBRvlBs53tJkflWX60w3Ajm7ShT?=
 =?us-ascii?Q?EYgGrChDOlURyVXcoX73Lv1btU2n7bRuYcPAZdj+KO6l8TmKUzpgWxuwmbUk?=
 =?us-ascii?Q?sCpIlS0U03VFVSE/nh73NYNWT+DV/ZQuWqIcVKhMDgvq0udyecbS1BK+iQMO?=
 =?us-ascii?Q?8tzWpl6n9dcmN0xniC/s6NQ0Rj4CCSR3K69JB7Hv+Qefshtiv+VF9/FXFN0h?=
 =?us-ascii?Q?Qqk0ivpLVB2B/pgEkB02Zt+QIf9jBNENfWzU3E8ufQFZiVUocjZ+CaCJJutm?=
 =?us-ascii?Q?BAmdP/DfeVKgbV94R8vCetwgLWRgiAvqeiE2zIZcV+Ug+7LitUUetFTRspr/?=
 =?us-ascii?Q?QgT2NsIarOjuGS+RVEa1ORF0S3nDJi280yVh9w+7sF9lnzD+Oqz7pLWG4UKc?=
 =?us-ascii?Q?oYwMoYNhDHi3dhTBg+ak7Qyenrha8p/y2zb/AuGmyfUCjIorEm/zNtpb0ljF?=
 =?us-ascii?Q?/CnJ9KhbIpI+5hqsCF+ONzoHlXWBAX0MYYYzN1NnApf/kBDprLwCNq0Cy0xa?=
 =?us-ascii?Q?w+AoxoDhC9iAm1tVMLni+3LQCtv411kftH52G1EEAuUtHKQ2AFbbfy+ZWWVI?=
 =?us-ascii?Q?uHLVXFOwRqpQ2eIyqO0fLHil1ygcd2GMdgaADd0yRtwUyoAQR8FrGsX/953y?=
 =?us-ascii?Q?T8KKuyomDzGBJA1sHjdxqslPbYeyMS4voPlHMiM9ajXteFPbjX7ut3YId6xv?=
 =?us-ascii?Q?eZr0qyGSMaleQClDsJch5MWZXqkvuO4jzOBmW4aF0R9Atv9oa0gkm6tn6hxv?=
 =?us-ascii?Q?bgdygNq/r9zdslhIl8imLwxh5DhOPYScjl6i7sPWvbiZO6VxBXBdyJy3lJI2?=
 =?us-ascii?Q?iMb+0JNAmibGDxVCutUl++zBsB0A+PS235VD+KSwH3BIlPGEMAMEmX/SsNQW?=
 =?us-ascii?Q?W6wvg7HmWYPz+5ZBgxxdXSW32AYYjrxk63yPjrvuF73Tm8Raq3nLzNv+yOYX?=
 =?us-ascii?Q?UO3y/cetUC+/XEh5tICTLGbpbcyMyn/dgloIPNFJXmgb6AE10drDJvxjOu2W?=
 =?us-ascii?Q?lA0wUoX47bDGTXtOCcr4rmlFtkpalq94k7o6A0SK6k6h/uNeWrZSqoyQlCsN?=
 =?us-ascii?Q?ZdNn+43jxcAb/XnGOAO25j998indSA9YG9cPtpmSci38opsOlU5rBzyMtcNe?=
 =?us-ascii?Q?O7IMEzmWppfPOtOne8I4+zfWd0xBjLTvzTnLCF8uapJFrFFnAMXP8eoy3G8/?=
 =?us-ascii?Q?hDyLBhlYzzLh0Kx03F8TrgoQNx1fhPt3phdk0yNcNSRs+//Rci55djgY2UWI?=
 =?us-ascii?Q?eV6UwHoK0dxE9cp4oaJTH2Cp?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 184c9267-b80a-454f-c4b5-08d8d3ce1a05
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 05:29:02.8113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q00F5iFwyUH011pmMAynJb9y4VEjz4oN9Wgz8CL1JsB+LcvCK4VwZj3Kmu9mTDkJvWIKQAxbeLZv9dMeLPV8vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7730
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor phylink_of_phy_connect() to use phylink_fwnode_phy_connect().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/phy/phylink.c | 39 +--------------------------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 23753f92e0a6..ce7e918430c8 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1084,44 +1084,7 @@ EXPORT_SYMBOL_GPL(phylink_connect_phy);
 int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 			   u32 flags)
 {
-	struct device_node *phy_node;
-	struct phy_device *phy_dev;
-	int ret;
-
-	/* Fixed links and 802.3z are handled without needing a PHY */
-	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
-	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
-	     phy_interface_mode_is_8023z(pl->link_interface)))
-		return 0;
-
-	phy_node = of_parse_phandle(dn, "phy-handle", 0);
-	if (!phy_node)
-		phy_node = of_parse_phandle(dn, "phy", 0);
-	if (!phy_node)
-		phy_node = of_parse_phandle(dn, "phy-device", 0);
-
-	if (!phy_node) {
-		if (pl->cfg_link_an_mode == MLO_AN_PHY)
-			return -ENODEV;
-		return 0;
-	}
-
-	phy_dev = of_phy_find_device(phy_node);
-	/* We're done with the phy_node handle */
-	of_node_put(phy_node);
-	if (!phy_dev)
-		return -ENODEV;
-
-	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
-				pl->link_interface);
-	if (ret)
-		return ret;
-
-	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
-	if (ret)
-		phy_detach(phy_dev);
-
-	return ret;
+	return phylink_fwnode_phy_connect(pl, of_fwnode_handle(dn), flags);
 }
 EXPORT_SYMBOL_GPL(phylink_of_phy_connect);
 
-- 
2.17.1

