Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09A957AA9F
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 01:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239236AbiGSXvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 19:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237785AbiGSXuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 19:50:44 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2078.outbound.protection.outlook.com [40.107.20.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C5F4D4DA;
        Tue, 19 Jul 2022 16:50:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chepCmvrReGEEK97zTfgQ4fzIEi/q08cr+uxO0sXe+Tw7k5tjOedeboCjDe6GAFOGCxA//gzsXPGkG3Fdphuu7MEe/0nd2v/kHgB1QliyAvm+MOvvhWz+gIm8G88KUYJV4820tTCYMNMogiVf5grrD0DGHsSmy9m77UvOqntnmyF+0mGOiFYwEe9FUIz2Oi4hPxnY14WEVFquID7ol11IQpdUWtIUQwKajOtRfZdAxKQXvJyfY32sh1s4klEFvDQzlXNqsTA73QtcygzdQ7aEvT5egmbT/XoQDIpqzZKWaKNZUrRSGOo+KgeUsdr9cExgiYw+AAZaPP79MNl37fNUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFDtpGtwbedTvq8d4hMdfkybv2JwhXtyyXNL6eikGRA=;
 b=QfatMWHnW/fvjUn/GYizHCotHdCVbchXbJ7LZlVKjphGHgYKF5jGVtCrvi6HSID14+T4fP66zfrXmMbsgVTUik7Ajvl9bPKhQQuhUyQKDyIB1AeYMwFx7cnWAtBD2fZ/tEj2NVM82wEqleSxO4mN5Fc+P9Foxoivw+3XAE98Y5PNpQ9cx77x5Yu5oFm6G+cO2KphR8W5caM2haBJCTAlv1aUgoxti7tDJbWuUVR0EIqwHFZw2yGH+atSzkbuJws7tdV1+7tl/j9smNFu4jtk/T9i2pzdAcEq6TUSiOmianAflKqG5O7QqV5G3hmzGRCjfb1xjtqfeKU3qej/JxWncg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFDtpGtwbedTvq8d4hMdfkybv2JwhXtyyXNL6eikGRA=;
 b=VkuXFmHgQSwcZLM0Sw3FJDgzz8elR0OkMkl8MBM0CnXvONGqFSNL2LANx/j5m1nbkML0ImUp6KrUnONxX9D6Wj/uSvpcTKgLTP7q6up/9Rx/PUC09AfgrYQeMFBott9IYz6BG7Tndyz0y7vlUri4zsZMEEzRfTaGxVCdaHE7VESFLpixJL/m6rB+jWelC1lC5ZFyu//qWfeNRZcA4m1qP5lTm19PicRiiquBxVj1hXViOUt/WbgTNhi7ETy9oD11daKO+IJKfS0p/GujEx3WQifCzlDpIPngPI6dtt9FQuRHLLMaEM09cRS79teRi1PWK3ZF2dldbq8NzA5/2zJ7gA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4811.eurprd03.prod.outlook.com (2603:10a6:10:30::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 23:50:28 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 23:50:28 +0000
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
Subject: [PATCH v2 03/11] net: phylink: Export phylink_caps_to_linkmodes
Date:   Tue, 19 Jul 2022 19:49:53 -0400
Message-Id: <20220719235002.1944800-4-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 382ab98f-04ef-4db6-80e8-08da69e17540
X-MS-TrafficTypeDiagnostic: DB7PR03MB4811:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1h1bWQZ/z44pdHRptY6oEaCmOjOXEnz4vpY+s/tAm4UqErmhu5F/4HCcFEAe7OOjdFEKFSYI91Bm8cDehPkQV/PLSOc2F1lMZkTtAbRvDraa30dBbdVgePKWhMULEz3xwDHwKMMXsQwGiBKtu8AxnrS1rVAlKElQw9bX7PhSGklEIaJTHTbgYAg2UGxgN3mZK3z4+R//pOve5PNzIEZU4qMrqUL41v5chWIRG7XosZmbGiE26jh0PeYS95XSFeGD460hUdBc2qWm01QmhfuDtqSjq5ScxJ6iDquXa4u5qzLU5ezLGzHebPRbHbIe+E2tcSbWII/e4eWJxqN8UXLcFvmn9y9uCojcun94D541Lvsbi8mRCGToQ1i1WiBQdRrkX+Le5XHDA0DrSZ0QGSqjc+q9WJdjYyjreWyQuiDya3ZeoHyTsjGYwuJtbIubWko4d5EG1FFqgECN5H6Af+ScKi2HoNdoDWC8Oegq7I/3vCGRunSDG8Wl90m5GnYT3/g7hchCsROvatYvK27ILGMXBHFP+1jVRSWlHCz6BbCe5eSQDJ04UXwbWdiwhBvITWRH8hhNswbUR/OCmEhI8AURDPqHyRMCTBh2KPSuQpB0AKYFDDn8KzFJ00dfO0ew9cHapSP24Fdb6KtBYVKgmDXMu1nBQFMsSCn4TzekUD4azfPIWmcey1ILk20enzf0fMeyeWFfv2pqaOB+L9pFsNU7MEiM8z2Ghcytm7WL1SLdY1/6h4xN2OEI7MHmKq6K1gMi03lyi2My9LZWjclKYOp3I4TnzAS87REQMN2ETI4yItNU4JwclaT/e/UNa1ieMcrS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(39850400004)(396003)(376002)(346002)(54906003)(2906002)(1076003)(83380400001)(186003)(66476007)(66946007)(8676002)(6666004)(4326008)(110136005)(36756003)(66556008)(52116002)(26005)(6512007)(6506007)(2616005)(107886003)(38350700002)(478600001)(86362001)(41300700001)(44832011)(5660300002)(316002)(7416002)(8936002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pw55dhqwQBcKqit/g8jRUGvF8819Fq6/oB0oCnQUT4IRUgWGtrnGTV85v9RZ?=
 =?us-ascii?Q?UZEyQYU/KpwY8AphKwctINNRPnV9E9UJLU0iLva/K48hHXqO+cEgEWe0BQgi?=
 =?us-ascii?Q?FRQXtaA02LTb2/l4Xz9AzsrgbJ+7IE6JEyXn9MGCjrgVJadK0fq4sTj4kRzb?=
 =?us-ascii?Q?rSsdSZBMUZYMOiaMActOmPF6cusL8RMQEe6or8vCGNVWVwelxad5m7TdizsC?=
 =?us-ascii?Q?f93xtFInqXFCctr4DGupovcQTD0gYwBrQKIfe/VLmbqxaGmw2aeMLsHzpOQ8?=
 =?us-ascii?Q?xLR+XGakQzDHHv1rqXVZLd4NHAVrVSxX8nuvB/Td1Vz1GWYKiXe236lq7h6D?=
 =?us-ascii?Q?KRcr29iV+gVb12Cpf8gmM9fTZLpJQNHNsXh4PcrAYi75Ej7XvTf4jcJ3yQB4?=
 =?us-ascii?Q?JkLEsUntcxHxeC+jK+cZLmGNj8+ZJxnnMFMp3BVOkcnAFQ8G37SrApOb1QCu?=
 =?us-ascii?Q?qZHNHYe0lQ+7gDYrGZ0XqzrQApGoKmtVkJgA8BzZ/hEE6XOy+UohT56EiQn8?=
 =?us-ascii?Q?dEWzMz+LS8F2RolBolwrSlLvs5rAQiPsJV0UjxjEl0T82lSHEOLM9Xlx2yjv?=
 =?us-ascii?Q?bKCRdSpBFLin+JyEsXnSqXfZX8674IdUMYkyrmfdBxW2C0dIvDSRwQxYFUS3?=
 =?us-ascii?Q?K3Er9Q6kNc78BG/3F9RJH8v0KQ8WC/GdWq8hjZK0FyE1Co0YaRvtm4/yo6kl?=
 =?us-ascii?Q?IQfpJMEVScH0TYzYABmKxJqu5XW/ranCgpjhJ9+fEcE7QQdquSZXLPhFeVeA?=
 =?us-ascii?Q?lQuq0mtT3fp7mTzxuYCmDtrgZrI9xPTo9bfoGRbPva2wET4tPflZtxhElT8X?=
 =?us-ascii?Q?BErNqIlK6QF7ByyjY2K4rduWhs5WQyoiTrubwHLipyGV+hBUwjwnNffmedgl?=
 =?us-ascii?Q?M9n0DkRlEeB3kZDxNJocBkv5IYDeGAiQugaf6kjBXesHm+z4d4sCMsPjx+zn?=
 =?us-ascii?Q?PRPpNRL5KunwQWaxZvkp9GN6RFiXpdaYSx5Z+SX6rKwUZ0GbGbSMcoUGd/eT?=
 =?us-ascii?Q?JUoCn9rSw1ZmWhSOJ+4Rm3HIRy6rpiX0j1ofIsvIZlCfnXrNQ0L66GhSeR1I?=
 =?us-ascii?Q?BS+vMAAcGDZFObgUoEx4jCdRDcXG1GMkVQu7G+A+51gnuto0sJifTA1yklin?=
 =?us-ascii?Q?Di0ox7mzvyZdw0KmpxHxF/a57JRpO477VzMouGag8dzgeU1xQdtmh97aL3Yd?=
 =?us-ascii?Q?MiqbFqJhI5mtLJ/0TtNfDLEWimkp/35yxDKW7QOveWje8wVIGahwpx5EkZY2?=
 =?us-ascii?Q?ODSL1wjOC7kCYjTXjKzfvMmgyxuDU/9Qtoo74oJgQEx9pqmbrQYqpqC4xNOh?=
 =?us-ascii?Q?jqx5MeiOVxXRRUgnXsJQeZbjno+NfrL8mhZGwwORgU70uNZQmESOj7QDmdN9?=
 =?us-ascii?Q?U12NmUUmSZJAMtFj+Wj63A8/JhL/xab/kmbMXwoYjNRTjUARsYDGmGuQe2Jl?=
 =?us-ascii?Q?U1G+yzTKT0nDr0oEIMx3DPR5Xh0HeVF+YdSp/AButA/wbr12wGm08AKNyq44?=
 =?us-ascii?Q?KLB7N+jmknYFo2hNSDgnIzVZepdQ03Ml5w831ls84kfAqpxBXo7OYTaeJ8+2?=
 =?us-ascii?Q?spXxWB+LkvxIXSkBcQ+io9FPICHkAigYEx9ri7au4gu9Ud1e8BCXrS/vDp67?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 382ab98f-04ef-4db6-80e8-08da69e17540
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 23:50:28.2847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0yLVjOeasON3kgARVxXirv1FxIdES4PKJ9UfeqKiMaAAQxv8vJ92WCBpNNJTeZ+7f8NdENnz2bRQN8excJXCUg==
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

This function is convenient for MAC drivers. They can use it to add or
remove particular link modes based on capabilities (such as if half
duplex is not supported for a particular interface mode).

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/phy/phylink.c | 12 ++++++++++--
 include/linux/phylink.h   |  1 +
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index b08716fe22c1..51e66320526f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -155,8 +155,15 @@ static const char *phylink_an_mode_str(unsigned int mode)
 	return mode < ARRAY_SIZE(modestr) ? modestr[mode] : "unknown";
 }
 
-static void phylink_caps_to_linkmodes(unsigned long *linkmodes,
-				      unsigned long caps)
+/**
+ * phylink_caps_to_linkmodes() - Convert capabilities to ethtool link modes
+ * @linkmodes: ethtool linkmode mask (must be already initialised)
+ * @caps: bitmask of MAC capabilities
+ *
+ * Set all possible pause, speed and duplex linkmodes in @linkmodes that are
+ * supported by the @caps. @linkmodes must have been initialised previously.
+ */
+void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps)
 {
 	if (caps & MAC_SYM_PAUSE)
 		__set_bit(ETHTOOL_LINK_MODE_Pause_BIT, linkmodes);
@@ -295,6 +302,7 @@ static void phylink_caps_to_linkmodes(unsigned long *linkmodes,
 		__set_bit(ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT, linkmodes);
 	}
 }
+EXPORT_SYMBOL_GPL(phylink_caps_to_linkmodes);
 
 /**
  * phylink_get_linkmodes() - get acceptable link modes
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..6463bd64eaa4 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -518,6 +518,7 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 		 phy_interface_t interface, int speed, int duplex);
 #endif
 
+void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps);
 void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 			   unsigned long mac_capabilities);
 void phylink_generic_validate(struct phylink_config *config,
-- 
2.35.1.1320.gc452695387.dirty

