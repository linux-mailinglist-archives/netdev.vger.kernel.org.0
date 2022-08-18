Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8348C59894A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345009AbiHRQqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344962AbiHRQqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:46:37 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2080.outbound.protection.outlook.com [40.107.22.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26444C0B61;
        Thu, 18 Aug 2022 09:46:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOK5FDkFZIEI6tUG5CJOx6xDGrNFbrgUp+1ihGWq+vAaFpcGBvbhSNfOkXkGQ84t3cayARWkNgBC886BO3UoJs92o6WaNIIlsjS4lflF8NpsZHbuCxeSwP1VtyfEDlAtc2BNArOGHVnKtIym5fyM8HW3+PrpN+4uZWPdRU39+6JMP0x8SbCbJXjplDIAC+jLBkrLMQajmZn2YBDdzLczMBLir7aE8fxY+/mRJIaXf4spZlW724r3hkUcoGekB1wW/6AL2fN+1DAhmzKnnUqYM7FctW7ubUEt2ThPLc7zGsUoXLPZsWba/IU/bM52I3ecgVtiob9YnrSILWnc47+KcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IaWH7tbDmG6BxoGHHGvyMDT5CLyr/K3DyajS+jXooQs=;
 b=F0+lb8seuLkxiRFY6C728HYvcpwZIPOs9XUXUPqvbqN+7JporUjy+PvYVRx/fpl0D10oSuMcMI6xicB+t4+bvR+4+wfY0CksqpNfTObNKTf/Fe2ZYnTov5vX6zutXlyVIJ85Hys7KLxzGyTSx8glwwbRAhQ9Km4/XZCXnZUwXLbA1qxqCalZ9ZhaDWatGYofEkmTOaB8R63nkURi73l68VINHLjpK4zSrIjcNRUFpYPvFj3IMsJGWzu2DW+qyx451wZrywqebvxaaiZsddYp9HZ5fqu7nFqOSI0gx31ixawNKz/55NDdFQOnkdCqZaQgPmOZT4Z/AZR97P6shg+bZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IaWH7tbDmG6BxoGHHGvyMDT5CLyr/K3DyajS+jXooQs=;
 b=bYOlJMDvUCSb1kwaDetxruSGzjIGTkvivuFt5epdI2FNoM3sQf9Ff3xuQm3MjxxOsMQ7nRz+wOV7Dw8OXYF5TZvf4rlu0Mf8yYRnPRvuDqoYPgh/yNlTpchfg8LbuQtkQPtWryjF4tdo3ZRSu23qvVcQ9OogqSsOib453IiVSfjGUmJItuTvCMDxhgSDDQ1eUHFJ/oLfV4gfMvpol7lVNHFwc++w7+UCJOSHsKWe0jmmbupRDAhYh6JQxohPXnLGbDMAgW6K8Q0rl8htN59yudfBfYUayMaWY+TD7KQ4YZF7QsJMgZJQ26gjSIYwkx1tDc3IV4pC3XXbok47fbXVAw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7649.eurprd03.prod.outlook.com (2603:10a6:102:1dc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:46:35 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:46:35 +0000
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
        Sean Anderson <sean.anderson@seco.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v4 05/10] net: phylink: Add some helpers for working with mac caps
Date:   Thu, 18 Aug 2022 12:46:11 -0400
Message-Id: <20220818164616.2064242-6-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5c9cc86d-a623-405f-e215-08da81393625
X-MS-TrafficTypeDiagnostic: PAXPR03MB7649:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1xUiNy4eqXrIXoEroM2UfulJQtt9yv4Ty2knhZ/6qxBeJ37jpa9Se6GoFOWhQzwJ5KDUOj1fdK5wjgjuiwH7DWQdsy4Ue5N35RlJCNYY1KLTGZKGjse213ctYMey4K+1K4Ukj3iqypxYmAXI5lKpxhCmZTExp7K1OtdGdKcGUZVr2dAfgpJm7kfhCUTtY8wO16cvMd5hEhei9xpX18VjQssLo6G6nJCLB2IHZU7pXr0s1i9ajUt9snJO7dDy2rknttV18e+7+BlA2rGm25mb6IuwroC60+e190cFm36djorFjdymbjBiI3u7W08QqL/3aDEXsDvSkcItmmvDmG9xzxtbjVMBITVqgAl2WTqE0J7voXsZnvVJxh/D5HjofXrEESafXiP9Z1LuEoLXIjwvwCOd7VkyxYTDoiQ3MmqtEt4x3Q4LTzRTDurpFAgV/txCj1qOAvNmP4NUi1ZPdbxJODgDtvgUMtTrgrt3LVDLqvnjTYzCFm0k5h5yDgNCbCZZJRyN5dE3n9iBSoGbFazCie0DaBnkx3u6lGPEq+ovkvlmf2RVwZwSDrbf+hn18fYJ+LASfy0/akS4gnfs66R+EIjaKOm2iVqBpZ7YTSK9nctMk4vwQcGQXfaA6Krr3tcgBKKFK7YGstjulzam2j+2jmEFZNzkdagPwnaVndqQZU5PTT16OQ7ZsL0uVGkMyTWoR88vbDdIqT0hZHdLn0V+oFHvlqswmK81cfCthrvUrGpzk1QonI9r4D+hGvg+wxsMOMFLYDLs0MRExYNUAj+Lh/tVOYqShbZh16S+tY4a06k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(396003)(346002)(376002)(366004)(136003)(66476007)(66946007)(478600001)(66556008)(6486002)(966005)(8676002)(2906002)(41300700001)(6512007)(86362001)(52116002)(4326008)(6666004)(186003)(1076003)(2616005)(7416002)(44832011)(5660300002)(26005)(8936002)(36756003)(54906003)(110136005)(6506007)(38350700002)(38100700002)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uheRL4GZ8xWC0DHj2joO8gvP/XP0izzEB7rGea3li7AI51D7s/Xxk9ZZnrnY?=
 =?us-ascii?Q?h8xk0PUdRBBPBphxvqqwfZND0dmF4fhdCNya+0lqV43mj/hboOqOXhk6Z57S?=
 =?us-ascii?Q?2cpfc9pR7t/7L5SxPr9VFnNfkNuD1tdKm43CsdvJhGzG7tyL3NqPF0Ao7nc4?=
 =?us-ascii?Q?as0p/oqY/q0CMJBVkA4HvHPNkdVVeWtG/KU7eACJZN+PfNT4BsYJyWnjX+vG?=
 =?us-ascii?Q?h27UZ0qohuRDQq0An/sBQ6/rk3aa6GXXxgdAxJKuqQPi4C5ZRwe/j0Yb+600?=
 =?us-ascii?Q?FkncfHso2ieDJ6iqX/Kd17lLmS0r3zHvTLRHRX6dNqrMs0nEC/US3deQHq+F?=
 =?us-ascii?Q?D7jUqp/ZL6Qo1eWq1QJGxEoLnobq+5fsXun3KfHspHzBsM2ZCY3T+fKzsJqY?=
 =?us-ascii?Q?kvK3cGHD3U6JU7ghxmENasXewJgqA/W6PSRAl4q++1g3k6Ed0hs3xPj1P7it?=
 =?us-ascii?Q?gKYgyr3VE+445lTUWWM+5CckEk8tGb/fjRdM/chfOehfRbNPk8fr2Aty33VG?=
 =?us-ascii?Q?zLrK6Z4sfMw+lLk1fK6FviyYXHgWpKPTVX9lF3ODksVG9umG+VjexUfCcKkE?=
 =?us-ascii?Q?I+M1n+rtDrR4ZwjL8jNgfx9iq8VMpCG72dDXQZ+bQDShleQqvTHK6bGLqsry?=
 =?us-ascii?Q?uYKt3V4hpHJUTHwPWdZLpJMRGZSYwmb2C8WQf/F0mtmsCi+PWsIKMptL3ki/?=
 =?us-ascii?Q?m84afseDhiTjgbDLguhANSuKt2KsmhRgeZheSnG4G13pvJ5oMJ8sgYhIBSZb?=
 =?us-ascii?Q?ELBYolAabbOlvXxI/ddqb/YuO/nQTA+z5LMTf7BnIjDa89JY+WNHzBvHif8l?=
 =?us-ascii?Q?JHGxNk9IhGEuXbFjWuE+fdacS4yDMA1IIIEIZzJA9G5CZGo24xlYOBeb+EAs?=
 =?us-ascii?Q?XkBvqBFBsZ2BjDwTbysAnaew8bYCbSlDKz/wBZ525P0Tur1feBXzOGCsN1JR?=
 =?us-ascii?Q?flK4v4T8vDYOZAX9WouY1OQC5SGRcTK+zaBQwE7YpzuwfrJm9SPjAa9JxajW?=
 =?us-ascii?Q?8Yx/sIlg84ioROr0AKZoqrLUumWBnc2q4U4Ykpv0BMvPABBWoFhracSi75o4?=
 =?us-ascii?Q?7JDfCrfvary93/LFgbLFo4sxzGuN9vmFnUyl5iQdfXK2HwRfk5plWHDywRHA?=
 =?us-ascii?Q?9DL0lOCS/otp9dT73Ue2jRablmTuKg1mRSMrkvqffGfABNrWL4xUg7pv8gPM?=
 =?us-ascii?Q?VtCxGFvPpqPFTrTXpUkZKzClmCb1nssd93M7HtdNa5Hk1EWsbnnc3NRwbsiO?=
 =?us-ascii?Q?EGSotLRmVh31Dzz2VNT+1Rfl2Fl0u53T+1wxfX2E21sH0JJI8bQAZx4bAvJL?=
 =?us-ascii?Q?SX4w7SWcCUgtUXo7CiCrYiKSdrUfnim5ihe9d0Az3Q06Dw5q1bWyULprMD6r?=
 =?us-ascii?Q?6t/46MBEpD+4SUPmHm4X4H58XQEvMptm5AV5VKvO24layLEWVYXTj/h+ruN0?=
 =?us-ascii?Q?rSTa1T5Sq0ZhEc6WDbtQIPFe1ZtW/Mg4quWxW6EYK+b/a+gIPH/rQU2Dz+Ei?=
 =?us-ascii?Q?ZBrAOS7HDvd2wcOjHaFMgdnfP2bFoMYf9jT166vKU8so4dZt4/g1exb4dW6f?=
 =?us-ascii?Q?kVRetRQtK9YxcixFzntJBMnfb5N7Vcly9o3BwLaKKaA2nIZ/AZLZwkh0TsKB?=
 =?us-ascii?Q?oA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c9cc86d-a623-405f-e215-08da81393625
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:46:34.9167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z3r+rSxyuQCKv6assLMmoOJgVYOTpg8YjaeKq7i7cq7HN3ZV0sK6sDNNCzmfger17EbOMucnrXdj3Zsnjp8Kig==
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

This adds a table for converting between speed/duplex and mac
capabilities. It also adds a helper for getting the max speed/duplex
from some caps. It is intended to be used by Russell King's DSA phylink
series. The table will be used directly later in this series.

Co-developed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
[ adapted to live in phylink.c ]
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This is adapted from [1].

[1] https://lore.kernel.org/netdev/E1oCNlE-006e3z-3T@rmk-PC.armlinux.org.uk/

Changes in v4:
- Wrap docstring to 80 columns

Changes in v3:
- New

 drivers/net/phy/phylink.c | 57 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  2 ++
 2 files changed, 59 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 68a58ab6a8ed..8a9da7449c73 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -304,6 +304,63 @@ void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps)
 }
 EXPORT_SYMBOL_GPL(phylink_caps_to_linkmodes);
 
+static struct {
+	unsigned long mask;
+	int speed;
+	unsigned int duplex;
+} phylink_caps_params[] = {
+	{ MAC_400000FD, SPEED_400000, DUPLEX_FULL },
+	{ MAC_200000FD, SPEED_200000, DUPLEX_FULL },
+	{ MAC_100000FD, SPEED_100000, DUPLEX_FULL },
+	{ MAC_56000FD,  SPEED_56000,  DUPLEX_FULL },
+	{ MAC_50000FD,  SPEED_50000,  DUPLEX_FULL },
+	{ MAC_40000FD,  SPEED_40000,  DUPLEX_FULL },
+	{ MAC_25000FD,  SPEED_25000,  DUPLEX_FULL },
+	{ MAC_20000FD,  SPEED_20000,  DUPLEX_FULL },
+	{ MAC_10000FD,  SPEED_10000,  DUPLEX_FULL },
+	{ MAC_5000FD,   SPEED_5000,   DUPLEX_FULL },
+	{ MAC_2500FD,   SPEED_2500,   DUPLEX_FULL },
+	{ MAC_1000FD,   SPEED_1000,   DUPLEX_FULL },
+	{ MAC_1000HD,   SPEED_1000,   DUPLEX_HALF },
+	{ MAC_100FD,    SPEED_100,    DUPLEX_FULL },
+	{ MAC_100HD,    SPEED_100,    DUPLEX_HALF },
+	{ MAC_10FD,     SPEED_10,     DUPLEX_FULL },
+	{ MAC_10HD,     SPEED_10,     DUPLEX_HALF },
+};
+
+/**
+ * phylink_caps_find_max_speed() - Find the max speed/duplex of mac capabilities
+ * @caps: A mask of mac capabilities
+ * @speed: Variable to store the maximum speed
+ * @duplex: Variable to store the maximum duplex
+ *
+ * Find the maximum speed (and associated duplex) supported by a mask of mac
+ * capabilities. @speed and @duplex are always set, even if no matching mac
+ * capability was found.
+ *
+ * Return: 0 on success, or %-EINVAL if the maximum speed/duplex could not be
+ *         determined.
+ */
+int phylink_caps_find_max_speed(unsigned long caps, int *speed,
+				unsigned int *duplex)
+{
+	int i;
+
+	*speed = SPEED_UNKNOWN;
+	*duplex = DUPLEX_UNKNOWN;
+
+	for (i = 0; i < ARRAY_SIZE(phylink_caps_params); i++) {
+		if (caps & phylink_caps_params[i].mask) {
+			*speed = phylink_caps_params[i].speed;
+			*duplex = phylink_caps_params[i].duplex;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(phylink_caps_find_max_speed);
+
 /**
  * phylink_get_capabilities() - get capabilities for a given MAC
  * @interface: phy interface mode defined by &typedef phy_interface_t
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 661d1d4fdbec..a5a236cfacb6 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -535,6 +535,8 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 #endif
 
 void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps);
+int phylink_caps_find_max_speed(unsigned long caps, int *speed,
+				unsigned int *duplex);
 unsigned long phylink_get_capabilities(phy_interface_t interface,
 				       unsigned long mac_capabilities);
 void phylink_generic_validate(struct phylink_config *config,
-- 
2.35.1.1320.gc452695387.dirty

