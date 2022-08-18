Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD6A5988A2
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344636AbiHRQUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344630AbiHRQUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:20:02 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10088.outbound.protection.outlook.com [40.107.1.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45935C3F69;
        Thu, 18 Aug 2022 09:17:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NE9kLZKmfjJIzgr14wPbJKywyblA4fDXvaCcFuBmNbk28/Wji/ljC6VLqJORTH84aql7QzSa5MtaKBW1va/pzlFM7UHGobN7T+bs8bVz7oMBGkNiXkJA9UMuBj294FURJlyV1TppBk2aZ1QBNKV5b2cSn41YyD9T1s7J6cSII7jUBaSvydkY32OHeCwXpZ6Mqkr83svuQQjipsdwqYcvlHgeyH9VX2xFBsSX4LwyiOT942Y5sRyZlhirTYGlWIocujDaImbYbwt8e7Ysj5fqkWn4q8ScyItM2Db38u9nYQGgV41/q9n/GtcL9qEZLacTERtG2mT/mWCKZEtA4DElnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TW+mOa9KQRFDSI0Zt1Tw4dlfvjcTJC4gg2BjqexxeaM=;
 b=DNTjZ9NUgyFchzD+cYH7sJoZd6FEtuPMbJB3H8EBMPtUMPbPq7k04ye7p1reLDF2qGC9anLk+gjyudGVn5WM53b6I1cq3UNV+RKQ1BMOf/iXcZzhYq1Uh2MKDENxIwWSvQTNF/UOGMn1hok/eK8qnwXrYsEFXYQvper6P5QWi0MKlc14+RIKt24sTQ+ycn4Te7mw/JVdYdsmvyw1kWYobIBV8MzoqQpRMrKsR5s+K2MzZdptuy5HuCxeepPO4xn40SdlkUQ4PUgdjnpdvxOSivbJlWd84bfKFg/vTiaW8a+0aKsuUSErQa9p31byYhuQF8XmfYqD9Jsm0xqQAsdOFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TW+mOa9KQRFDSI0Zt1Tw4dlfvjcTJC4gg2BjqexxeaM=;
 b=I4sPSMrEjPVFp8Rcwme2lcCU1GFT8hn/jdaaYWIrf0lRryxJJWLL2a/AemPNPsLLHsr5a5pa/6rtBg6uV0GDtoiN++UaDXsdPlCHRrCV3LyhFv0wIdXFyHmaOgUWStDG9ipxo5XKxkk00ci2F/M71pu5J3Gf5519ohXD/nOEXRPGzoqcwi+TBlq+X/jBBdMjMc1RjwA5cVi0+dFXPdMcp8BlgMZDDslMMuoIheBPI3wR4LqWUScEtkk0XEPzl3UIyjUYlMRiQ4YMYKwDOwqGhMeFOoQX6Cb/bRns/x5XV8wprEYXBdXustW+Louf1OwIU/9ywuEmdJzv75gHIHQ3lQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5621.eurprd03.prod.outlook.com (2603:10a6:20b:f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 16:17:38 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:38 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RESEND PATCH net-next v4 21/25] net: fman: Change return type of disable to void
Date:   Thu, 18 Aug 2022 12:16:45 -0400
Message-Id: <20220818161649.2058728-22-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07b86fc7-b423-4dae-6e63-08da81352b30
X-MS-TrafficTypeDiagnostic: AM6PR03MB5621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D0M0nEQFUnY9rXBYI0tPuDQ5EW6HBf+BfUekiYaTqKY9BwTMSwwCIaUi6Vs2Yl9+0EpQlkbJVzts8y6+HwF7MtZOlnmQ/XM8AQdZ4Qjfwoth15r0gxSE4wnpE1OGbM5oXvdedAaDjxRhedMv+cKCKeN6a/rdqnyLF48BLRpQgn3+PKl7iRsjneh8ctOYwr9FqBZ/EHolHMeUqOMXSOCPdzUWK70HKoEEDDn/FeBhhxXdCXRPNbCqvOlPpxCbs3NBlMv9sUiuzcFpSlE6w1jYVRLm/HAIvf1Ipuz15MjqyEiTQSQzvo+v8exRE2DKdNL+0nrnDdf/xfpbnd5VveuJwHnJKW/USaxFoiUcaCswbuMCGB3CzvrRVDF4i3BXTugAEd1UuELcAS1wga108TVK+hq6o+jvoWOdyukw2zeV4QJQmGpFxWriSeyA3uXWG8FmDF0QHEKpEhtTe6d5YR6+wCYQWsVt9KjgNqC9nfJiHlPfgILWzmoM1OxAK2In62sovjOz7bCnDE6g3ogWy24alaroga8yB5n2ZOePGlnW4Sa1azEDUWd/MVw2kKBoJm/5Dafy3QZchtpeignG8qDehMHPxsOExSX4LFgtSTxrcU6HOqoBGdBfylh/EZYUsj0NHGaSdtTauLsiWQHT+GM8KFY0SE2de9a/0tOskvOYARg4CXuqGJfQ2yIgsREVj8btqw3gIHMrTRaJBCM4ulsdQ7BYxOsi+ielGLH7refWszv7Rb0BmXL+5IfnmC4ZmPEp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(396003)(376002)(39850400004)(41300700001)(316002)(478600001)(54906003)(38350700002)(5660300002)(38100700002)(6486002)(66946007)(7416002)(110136005)(66556008)(66476007)(8936002)(44832011)(8676002)(4326008)(2906002)(36756003)(6506007)(186003)(86362001)(107886003)(26005)(1076003)(6666004)(2616005)(52116002)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dhXDA2+xhwe/XRSkZAX48WRO136uZdeOlEMvTD2rHagvXE7CUYUyVus63yfD?=
 =?us-ascii?Q?rrfwdDyUZ+9K2YgfBDu56F3uO8XYUA+dAVGMrvDe/XU0jnI1ZjYSNKme939/?=
 =?us-ascii?Q?Q9fQMozLl8fghqgA2KerK3lNnZpCebr+FngwaHuInY+wcTgcem1Y8/qRDA+O?=
 =?us-ascii?Q?Em4DgbiiBCz4aqiWppK0QNlluXrUqiY7yqckdYGZ0v3G29rgTrrW81t6Fmun?=
 =?us-ascii?Q?5iSJE/6T8T47cIvKs+cbaHCah4VdIsROg+roaBSlab5MwJ3lVJ4Yb83gXobu?=
 =?us-ascii?Q?lg9mSkF+NrHvss+VeOE/NIh2aoNiQsqUmInwGRgOWt1Xxnkd5XnUSZcK1ik/?=
 =?us-ascii?Q?4X+6Cg3RB9GnPJ+5tOuZhN3f1Fw8aPS3bG6WmlsKjNKH7RqMeIIiP7V8Fhtr?=
 =?us-ascii?Q?b95N+pK/POt/lyKSnBedoaK17ML+ZRaHrZz4o9jNdrbgyqeMY0ATfTkjEnZA?=
 =?us-ascii?Q?BFFX6BfBr4meV/XA+aI7p53DjBcbP2qwrJnpimW7cU3SQNiXYj79OLP08dOG?=
 =?us-ascii?Q?Z0gUeWryJfv8Sjs2b/4SPqmotYoEhftRFbKe2Yb4M5xCpZKr5DtdhvMBvE+W?=
 =?us-ascii?Q?euQ4BEioNZe3fitCIwy53WXtYJKcV0Y2xAYCLxqtSp/lPdAzeKMcxdKAaBMq?=
 =?us-ascii?Q?Qb8GTIfd4BB0UEOjjTDddLwAYDpLoaiZ3tq0k1ZlOFfiBw0F8wVBP/DwTsQJ?=
 =?us-ascii?Q?22ncEPn25IYGZaG+EK+8Y754ZMc8OjPU9uD1xYafx0kftNP3qisxXKEikWW/?=
 =?us-ascii?Q?XREv75t+N0Z6SfX3z9vhzB9WZNIf5cUac2cZhJeNEW5UPfzu4954fRdZkUyZ?=
 =?us-ascii?Q?sIq2QVdHb3gkogJrwqRjH71lcVJ958B2DTjTGrY9Xdn30DUUE0KgUWJmUzxd?=
 =?us-ascii?Q?kJY4eYOnG35NndsWirsgcWAOFbD06malmw//uc60MB3xFKPeWVmeIl3Fjsnc?=
 =?us-ascii?Q?VNn5eN5CO08LSTT67+HCoU0pBL7tjgYKIXYtX5TWyCoQ+XcVe6OEIBfPpyJZ?=
 =?us-ascii?Q?Vb/lcUjkR+Yl/lKgERsydY+dElK8PJZTp3ttO6OlyK3apidcJPwlpdndKH+S?=
 =?us-ascii?Q?QmD2p23CsRuPIXnQY2ufqjuOQdHPfBpHgK5AOvk3KvTGCOD/RMKip/oJXZk7?=
 =?us-ascii?Q?bCPUbLV8RYBelgZjrMyA45Lwdl7kasuzTzIPrTjUldiw1HZqME0JtM6ReT8Z?=
 =?us-ascii?Q?WWV/2YKqVtO7Jj5E4QSXMvXn485dmmHYw7VsyXiBXdio5FFIi5s88tHwDBHe?=
 =?us-ascii?Q?RQdDoRV5m7Ho5GQYoBv1oLaVR8Zw/j9MBURDAAn8oUx+n6FQ48QOzRjQwByv?=
 =?us-ascii?Q?0mz+wyly2NRXkTCXaeSjSe4a6QfNV/W/5/Nl53xtHlY5g/cu+O5EyP4uyzjI?=
 =?us-ascii?Q?SkzJe9xsa05f3P7rhfxarPK8sFEAo3Vkxkm8Hz3PbfxA7MEhCaAJJqn207gr?=
 =?us-ascii?Q?7WVqCz7GaDb09yVzraxnHuzwlMNr/W3n1wVf2O0LY4p/bP4BSmAjyfSZ9jyg?=
 =?us-ascii?Q?Jn2AlF9TPHxhjIjMSJ08q9wsrz53cXz68d5bfIkWQs5tdMZo1bwL22c93B03?=
 =?us-ascii?Q?az4WVkzNOIrlAyX92dXF+b/lBOgepnwkiFyRTfIFzqVizlXMOD8Cdmv2ifTz?=
 =?us-ascii?Q?Lg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07b86fc7-b423-4dae-6e63-08da81352b30
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:38.5909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LTuY7IT41Pm99P0TnLN5Hue6Q7DpfjXtptc+EVcPXtsyUyaDuL47mg8j+44AuVJIK/j5jZsj9F5je1bTBeHS7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When disabling, there is nothing we can do about errors. In fact, the
only error which can occur is misuse of the API. Just warn in the mac
driver instead.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c   | 5 +----
 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 7 ++-----
 drivers/net/ethernet/freescale/fman/fman_memac.c | 8 +++-----
 drivers/net/ethernet/freescale/fman/fman_tgec.c  | 7 ++-----
 drivers/net/ethernet/freescale/fman/mac.h        | 2 +-
 5 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index d443d53c4504..0ea29f83d0e4 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -290,10 +290,7 @@ static int dpaa_stop(struct net_device *net_dev)
 
 	if (mac_dev->phy_dev)
 		phy_stop(mac_dev->phy_dev);
-	err = mac_dev->disable(mac_dev->fman_mac);
-	if (err < 0)
-		netif_err(priv, ifdown, net_dev, "mac_dev->disable() = %d\n",
-			  err);
+	mac_dev->disable(mac_dev->fman_mac);
 
 	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++) {
 		error = fman_port_disable(mac_dev->port[i]);
diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 7acd57424034..f2dd07b714ea 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -871,13 +871,12 @@ static int dtsec_enable(struct fman_mac *dtsec)
 	return 0;
 }
 
-static int dtsec_disable(struct fman_mac *dtsec)
+static void dtsec_disable(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
 
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
+	WARN_ON_ONCE(!is_init_done(dtsec->dtsec_drv_param));
 
 	/* Graceful stop - Assert the graceful Rx/Tx stop bit */
 	graceful_stop(dtsec);
@@ -885,8 +884,6 @@ static int dtsec_disable(struct fman_mac *dtsec)
 	tmp = ioread32be(&regs->maccfg1);
 	tmp &= ~(MACCFG1_RX_EN | MACCFG1_TX_EN);
 	iowrite32be(tmp, &regs->maccfg1);
-
-	return 0;
 }
 
 static int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 19619af99f9c..8ad93a4c0c21 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -701,19 +701,17 @@ static int memac_enable(struct fman_mac *memac)
 	return 0;
 }
 
-static int memac_disable(struct fman_mac *memac)
+static void memac_disable(struct fman_mac *memac)
+
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
 
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
+	WARN_ON_ONCE(!is_init_done(memac->memac_drv_param));
 
 	tmp = ioread32be(&regs->command_config);
 	tmp &= ~(CMD_CFG_RX_EN | CMD_CFG_TX_EN);
 	iowrite32be(tmp, &regs->command_config);
-
-	return 0;
 }
 
 static int memac_set_promiscuous(struct fman_mac *memac, bool new_val)
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 010c0e0b57d7..f4cdf0cf7c32 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -408,19 +408,16 @@ static int tgec_enable(struct fman_mac *tgec)
 	return 0;
 }
 
-static int tgec_disable(struct fman_mac *tgec)
+static void tgec_disable(struct fman_mac *tgec)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
 
-	if (!is_init_done(tgec->cfg))
-		return -EINVAL;
+	WARN_ON_ONCE(!is_init_done(tgec->cfg));
 
 	tmp = ioread32be(&regs->command_config);
 	tmp &= ~(CMD_CFG_RX_EN | CMD_CFG_TX_EN);
 	iowrite32be(tmp, &regs->command_config);
-
-	return 0;
 }
 
 static int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val)
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index c5fb4d46210f..a55efcb7998c 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -38,7 +38,7 @@ struct mac_device {
 	bool allmulti;
 
 	int (*enable)(struct fman_mac *mac_dev);
-	int (*disable)(struct fman_mac *mac_dev);
+	void (*disable)(struct fman_mac *mac_dev);
 	void (*adjust_link)(struct mac_device *mac_dev);
 	int (*set_promisc)(struct fman_mac *mac_dev, bool enable);
 	int (*change_addr)(struct fman_mac *mac_dev, const enet_addr_t *enet_addr);
-- 
2.35.1.1320.gc452695387.dirty

