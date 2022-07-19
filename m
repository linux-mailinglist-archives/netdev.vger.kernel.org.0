Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5E357AAA1
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 01:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240190AbiGSXvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 19:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233963AbiGSXuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 19:50:55 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2078.outbound.protection.outlook.com [40.107.20.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F94B4F6B3;
        Tue, 19 Jul 2022 16:50:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZYbXUmr86JuL79PWLOM1sxYZAENI7v1ErxXpEgVWsFwGK76M33sOLkKlzVQLnmpT446yTVJcuMA5ShWfvcxYKd4xlM1y8W7oEfhKNIblC3bUqdFAudEJxFa51MR+n3rBc4BjGglJv4RnWWdedKO2SsOqniuVA0q3UIrzWQw2mRj5/D2NIXwbqNCXFKkknI8jS1OsT/c406ypcbEuSoiI+n8NxUgN3r0EG7m81LOE0WY7zb3S5Lmhp04XOKl8Sz9HlDrbidby1v3PUTdBo2raV6x6WbnlgDrhZ2tubQV/RXcNRYHFC1EiX4qPJ91DOL18fafWEbgBSnuK/eMj3a272A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hfgEXjmmgUTHgHiOHUqZP5+NPPP4N8pVOkbBKMOZSN0=;
 b=R30bfkDRvzd8AxV1Ckn+gFmHRNb+lZtUR4nTvnwsepx8/abI2NKYXVwcnReV1T5gutm0xUiaGhCtx6grSpchtCEWKJ+zKS+oemOFu+pjaIwKHodZoKHygC+qyoxOHPTuw760glT+rN3E3/wcMCSUHZ6+9GSoTu89UzDfe8yMtRWak0p72X2DKbftSZueudL6jmh8CEJc5og0T83g/LEu2HjQqSR+096/NgYWUmEklifyeBRlfNOEgll+60hwF/Wwa3pQZe5R9oX7e8iG7zM9rvDsc7oCosKsu9p6Zz2qiSpGAKHBsdr5Rj1dysscQDQcshtYVacXixDaZW30FN4BTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfgEXjmmgUTHgHiOHUqZP5+NPPP4N8pVOkbBKMOZSN0=;
 b=IgKqBDnlJomNx2bA213osDqsPAJ6SbZnYFKymwNtOlDDkgIt5TDMfEp35JdvvW5EDJcPUjO5eg6CQ9Ku6whVSJQAQoH+eXzP3tO820WLMkSCdklkyQlsFOEv3g0XGW6n7mJ7E6nP3YBxSH7BLZgzi14b2PmjUqOZNehBWQ/NgvrX5qM66rF9iV44q6dkr9ZIzxUgVDarSy30MBNZKcooo9dLmE+sRoEwxFZjBG9hIGY5Z06tyfsfzhCxPNXLJ9w2Z5a9Gr5Esx+iiiXjhCOmPbJBkFeosjp1Q9AISfMEJ38/3TpAULmPIApNw3sm6C+hsr5pAoeiUI8lt6MV9Uzp2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4811.eurprd03.prod.outlook.com (2603:10a6:10:30::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 23:50:29 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 23:50:29 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v2 04/11] net: phylink: Generate caps and convert to linkmodes separately
Date:   Tue, 19 Jul 2022 19:49:54 -0400
Message-Id: <20220719235002.1944800-5-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220719235002.1944800-1-sean.anderson@seco.com>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0227.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e03d630a-d2d0-4015-ae9c-08da69e17614
X-MS-TrafficTypeDiagnostic: DB7PR03MB4811:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w2UnMyPl3j4HxJ3Xfubh3u7ypAKMfRuntOFPG2kv3Gbr5SFh+ZZ7jLS+hslX88fo3Tuc2BQsti0xnxPP6EO5MlQw1fBC+/Q/G/ajQFNhddbFnboytSaRWPPSwoWmPSEON5X8jqinJDgFJbG+xd6IhTFMiPJutrjM3Vm+V8dvwkaOofUgFW4zXIN1PwOminDk52yC0BpT9ZTCfNpna/CYGsJFxWRN5pNmCZtE86lptcThqQbuWZhRaImXIpM/lfytfRnjio8wQO3tI/NsmqNkyh3WIemiD4zk1wuT2dBDhtUav2UtP+cva8NxU1mbtESP64h57UbzxKZ39ZC73V/z2kfROvHg6zf0XZlZL7J8NUjMZXPXPezh52JdQNpXpKXxmeID3LzY7Dqw4J80SvE8GhFvM+LRlnIFaQd4TduPSOKwuSHEA4A1SCxiaaCkJ0ZH3hKkQytvX7z2p0kntdQRh0qZSOBzsuNNRH27WgatB15F1bRtaBQWAHzFyo8EK3eXr5TWFfCpewZ56lPUw59fbEuKSGWirjnGgpebgPAFhdhJtVJ9MULCNCownKql7E5A4dLIC1iRAYHhk8XlBaCyvlMmzcx8WUpYuf1PXzTSVhkiePXH4sqzSdNpue0LNRAFqdeleUbA6ARaKTmGgtp+d5yetnU8yc5sDOOkDJvZ9tGYJqxZYer/hL9H4+jlpFnlycfhGFJ8ZkiEjJsUYALkY9CeKDYVEPxhtDnFZKPSZD7VjCaKstdvAJCx0+IY8t4QEcyHzwyncpWj+tVQ0lLezaG3simYCnDlMvgBSyIa7cEK9nptYV2Pib02JvDySmEw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(39850400004)(396003)(376002)(346002)(54906003)(2906002)(1076003)(83380400001)(186003)(66476007)(66946007)(8676002)(6666004)(4326008)(110136005)(36756003)(66556008)(52116002)(26005)(6512007)(6506007)(2616005)(107886003)(38350700002)(478600001)(86362001)(41300700001)(44832011)(5660300002)(316002)(7416002)(8936002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JPPESdLgtipoFOG9cBqJQ+Ng4fajCQQXBPhELLPKk1WRfkhyevmPx0BJY9Pd?=
 =?us-ascii?Q?nm6oje5HsEgYTmlV5T6vKlhTxcJT+7sSKwxtazQh89BkjLPbSujAEndP27kx?=
 =?us-ascii?Q?uKAFD98rZ4rf8gm6J3WU4h0jg7pBIFMpcT1g/GGjlifAWd3tagbR6FwfcTF1?=
 =?us-ascii?Q?7VmhhN+JkLzHlazIMvG6hwlY+5vzSkcEU5upPApwmdSGSmxqGPBN1uLSvLQK?=
 =?us-ascii?Q?r2iMglwAGGkKWUiBjvE2oBSTKR8X9ViXEKQi0h3y0Icn0xVyuSb66oDoKNhj?=
 =?us-ascii?Q?5pIpOFYN9aB0HV8FoDgNImLKujR16PlLxp5d9hccZA1yoEv/l3Dw9Xigd7TC?=
 =?us-ascii?Q?U/nWP1sB1SE8oFGcKco7oCVaYUs3jI3oTf9TgYXqMlF07peg+tX12iFRrrp8?=
 =?us-ascii?Q?zTrOmF8tAXPhR9cF6Ol0DyOKcFKPKgK81VuXESuXkOLjBlXjYrldLCj+NLxQ?=
 =?us-ascii?Q?AC27ydZYa68k2LtUm2uK8VAaY0sC69Wt6WLbMY3PyIaUMXa1RwzV4PzfXo04?=
 =?us-ascii?Q?XoIQPAoCcHu6iTos1tMFe9/Uy/iJAMtwbEGS3XFlY76cQRECIE6D3Ry1Loyu?=
 =?us-ascii?Q?G6Z/MlL5NUmrCckjwj3U4prlnb0kFXZHG4WexTwits9pAYqgmAH07Jh5RJ+a?=
 =?us-ascii?Q?HcnnVFJ+Dv+uSr9Ui/lY+duWpJ4Tyep3byei2El4neqda55IYMVyM6jAjeNO?=
 =?us-ascii?Q?q7u/23gJf5R8NyE9hPMiPXcTtgZFMwIvfDgdSgOfjdrG4cZArmDJ+6N74MHD?=
 =?us-ascii?Q?a1ewv8tMzZ6FEqGeq239nXLALVGmUqOAIuw1NDyF7RxFzmZVvdsz2DMdd9qp?=
 =?us-ascii?Q?eX5X2HSvi7UR05Gj2ILoHtiMKnHsb3tf5eDUTFkzUWpadyYuyIg7lqJQ0OhP?=
 =?us-ascii?Q?PuNWHnjKKe0fJn9kYdf32mhOGysUO+L1TFzJwXKqCGcTWOez3WQyYLue596i?=
 =?us-ascii?Q?zdGW9qxhvADXyBva7h0oVAarbfoCs8/9NNi5KI8MjxBVmEOVPhlO8Na0ErIS?=
 =?us-ascii?Q?fPpZeWsiMEUkhqh0CkcSSjH2i4ax3J9LtpoML4b7p87NUYjZmjAoA/6k8BSs?=
 =?us-ascii?Q?EkzRjjPzOmdjQ/dhibuUZtbhuUXMXOjORKMPn0RN4gPXih2GSnyoD8on3UP7?=
 =?us-ascii?Q?ATTO5bW4Qf0o0+pvdtuozYTz4uQPLLNTfn5HmO0cSX0j6/VzSkPczw0+0lCZ?=
 =?us-ascii?Q?P69mZ+zjJUptOZ74EwBvaVmB1p64b7uZPHNDpXtaEdua4tGYDRBO9en4hYKa?=
 =?us-ascii?Q?6SHGeKC18gS4sVK/rgQiPBH3BUfjkPFTVPUJBZN50tPd/cURkVSS9SXfPZJg?=
 =?us-ascii?Q?zHLKV7fdW/p1245wD4Wp83yGqrzoIRPYTJ9Wfa2NQO0o/gexHl2gyg+Bkk4o?=
 =?us-ascii?Q?vXi7Hz2d4gdh7qXoYHN4ORcvQOcobfkWwPWOrPMa8fj8YaelZgpm+O8ASVcb?=
 =?us-ascii?Q?PplIVtwbKOSW5njhVgd8rKfkjtWk5LMqj+AlX4Ay2Sz3yfp9F/vqF6YFYG5q?=
 =?us-ascii?Q?D0mCj3PI36iDXt/FMMsd33uyKMhqfJm8HHmJKe/+tzOyZ8OlVZ+QlcXUyNyX?=
 =?us-ascii?Q?nlHV7YKpAIYLhJqG80famqcgwu0KkZEL+pUwXdg4YEne8Q3Ia/HAb2EL0Kfr?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e03d630a-d2d0-4015-ae9c-08da69e17614
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 23:50:29.7065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o6EjeOwYb5Yrf3IrN8r7S9V9fGZbbJKpyguC8g9WVjoij4QVPY76VWiOQj7gMqmSRjCEsPj3gfzv1CVvLBLpnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4811
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 6463bd64eaa4..5008ec3dcade 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -519,8 +519,8 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
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

