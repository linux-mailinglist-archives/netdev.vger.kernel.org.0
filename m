Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56393576984
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbiGOWE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbiGOWDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:03:43 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2079.outbound.protection.outlook.com [40.107.20.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60E28E4C0;
        Fri, 15 Jul 2022 15:01:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTqpAX31rGdkgn8yt1iedgSNTbF0tPX/dotEMTKTEIvWiz/7Pn/834Ur1gXspV+wKgdaH43S9+HVy7oqj29GdNtudCjFQCYgwLXSKJ0jufbrSW7xPb9tGZP14COdvvct4Wp+BkB0wZovYlZ1nzw3myp5CHzQwRCUuoj2HkbtBVjXN32Urgit0Pm5yll+1Tm/pmLNSk3MhSabWRuRn5VXVmWA2r0as0W8iXhPYfbF3ZmC4KFeM9nsGt68YiYaHhVo/JekiXZMU8TFRUl6i8pF5vlfrHlmLEsEoNlI1TtrJV72xfhbum6SZro726axaI83n9BmboavMMguAtb8oh0yVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r8/eM0tio6WPHOydqQD2/9WPF01qGFSIswsP2saXMAg=;
 b=TNF7mXNX0ZaoyydizbpNcw0MuGw305B+lF4urEqI8uvpRxjMJRpOe4eBLzY39JfiRhVFV2ywyEUKswkcSHLN2E90WmSDhMhZUKKjxtPvK0/2sI99hscFH2qbjjvI5jFH3v4hq1NHatgPzTlmUqS+VOgHrbP02MYV65jnKkdojP5iqtmIHD8sBzTkA4FN6hJeNRu4v65Q1flCUccAE0cIPK5HmKUu7653MTZYxCyVSyDgI2L2bRrU8Wzc0iRu25GB7ICg5yR3ZP+e7hIFpZd1GE3tEuXPAsyqcNtPoqZrGQ+bgDFp32+9I/sKqiiCbrwGZPbJREYjaMe+uHgX+FYosQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8/eM0tio6WPHOydqQD2/9WPF01qGFSIswsP2saXMAg=;
 b=1ofx51Cc81mpN7FW5o8N827ROyeVggGQXVl2AC6NTEgdvDpljcuyV5lu/wKshARwUG975oVp4a6+CemuYZdDsKJ7F6EOCjjWEPNlhJ9nE2OH/8gJLOilA9QGGB4dbLQCS+UTOup0AakH1SPINmdGY33VAfTATT4uRYl7qD4Jjg8huS7to6cEP2LSgejJWHVeiW9x+wlJfFBsonmiYp1GaSBfgEHeFnrhgqEad9bNyEF0lM+Kkx208hYdbImAiRsP7mPjpcBBNBCW5f8UqiOWsMqPIdG0LxI+x6lYeFRj3DCDQSJW5iCO8VmnIdqbpJ0CZ/o6TrPl+ENTRYO2DaUomg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by HE1PR03MB2857.eurprd03.prod.outlook.com (2603:10a6:7:5f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Fri, 15 Jul
 2022 22:01:30 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:29 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 34/47] net: fman: Change return type of disable to void
Date:   Fri, 15 Jul 2022 17:59:41 -0400
Message-Id: <20220715215954.1449214-35-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91f20521-056f-41c1-ade2-08da66ad9235
X-MS-TrafficTypeDiagnostic: HE1PR03MB2857:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GOglLQiJQGw+KT//zFjtN6Zmhr+ysE5Pq9kAzp5L74nQidZhJyqBG72OxNE6huuPm+tECfMnNkiGqllMrKmMCIUKHVDAJCt6HanLs2CC+mJpNepQ42PtbEcCpcto0fNEgidiiKMm7j3ulj/I+/i4N5Nh4GbGjjgwOwvPpka+qBJoHfEtVP/odqfDF6DhRgT99AOEeKPHv1g/DZorZxTbvsTFo65Qgilz12Q4uh8Dy9v2MiuhzDIq4Oygow5DRMbk+WL3r2xtWsfjylVHWCqTsM4kxcm+QO5zjfFLQUwGT8OYEWRwP/vJRbEKW/f7wzLDGh+dyfdot6Z24htSX3ymQQlWJsgEdVrVhIsObf2+iStRh05Q0z7FRk2ZGtVKg6k+BGWJl2hdrSTgHxi8iJ3A2jxoH2VuiPFJ5qLdQu+xl9X20QUfTuTamD0wM6JRhsbEaOASbZ6LnfFcofFA5ooTAAaqGNwNT64fVcWB0YX0BnbAaUnDlTpgCWmAaPsMn3rpZXKX1ZF72m162i7vJPK5e1kezn3eI0pPq1kvihyj40Qy+/0uQ/xYSA5E7CaC739PXaSJJDTeHqiMvKhyOkAbPpM6pwzoTzQL+H9pIn0gSIro3fliaQo4uYSy0/HsjQX+jxcPn4VJYGWtfLR8yzqh3cgDzUXUREN+GElyYUFKDGRFqGMAiucIvAlk2LlVfjrRik3a0fOT92tXeiWUzGeR/auX9M39D0SAoPVSMBE1BnFLGJyUvSjdXfyi99r1BcOGGdmKeDHIT/XjpbOFj4jTHzGbKjsk3blIncWmYE2RIr8y8U/dUXdh0ZHC9LK5y8jz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39850400004)(396003)(366004)(346002)(136003)(316002)(54906003)(38100700002)(2616005)(186003)(36756003)(2906002)(6506007)(38350700002)(26005)(1076003)(107886003)(86362001)(110136005)(5660300002)(6666004)(6512007)(66476007)(4326008)(8676002)(44832011)(66556008)(52116002)(83380400001)(8936002)(66946007)(478600001)(6486002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?roAsmrGulKBtbI/awM1l7T1jGd3hud/I5ZMw3tg4AoKnNwM93pZO7midG9Sq?=
 =?us-ascii?Q?Q2FVW0CQeMs5fMelEdLtt0kAFxpUC2pwCa2A0AJXfiXFo3qXSLyTrTpDwlF0?=
 =?us-ascii?Q?/zMI40gOWnXEDM/hLVEPr5zTzs5YF9PNv2SFYragjP1BtuP5K0j25iL3HGuf?=
 =?us-ascii?Q?2D8b8Y2Mc8j1l6v7KruP3kFph5GPy7Xkb/aHyt+SOoSIKWz7r3nSQbXJH1h6?=
 =?us-ascii?Q?kMKFwidebiAfOaYAsiFMl818qoC/fwIFbkVIdcs3LvQq9mQWuCrWjfi//6yH?=
 =?us-ascii?Q?QgTUqPF+OA9B52d3TalLDLq1c9Wg/uZUFrlpAPRxV/kbwXqmgtkOobrwxyp9?=
 =?us-ascii?Q?DcKGRfz5cNSCF8Z+nEWMm5Oxv66JQaVKqiTjc7OeHfyo4V1JBpmNaIcrXkhK?=
 =?us-ascii?Q?AYlbcWjAFbA/B/jgkeXzKw+aIxwaWyoeaJ72pxS4+3SOUbIjA1Hi3kAZ2ycE?=
 =?us-ascii?Q?CV5RUiVGXclj9GoxMgHuBhdDgKi3fSRl2VqBOv2JxsO6NruuGSnz33Qqcclu?=
 =?us-ascii?Q?+kVoc3DY7IrUpVKJaXoQ37sFs0dxO6IHP7YZkuF/nUXxEV2nK7F5FRleoC14?=
 =?us-ascii?Q?pb1IID9rHi9kwpWC4qvQsYC7MsG5K5Fbmm4P/xP5lag0m0m77KtxpAwPy44y?=
 =?us-ascii?Q?NJWT//lj4JtvirHZTJq1Q55CgyUrHcCP2qzK+1I/CNqrWW2hHznohdgW5A50?=
 =?us-ascii?Q?7YrdIB7nzm1U4iJmX/5G3pZaXQw0Bii44KOS3LelyzKbg1RJVo5r0TBuypzM?=
 =?us-ascii?Q?WLjvsSOV/irAg4uwMEOQOAd+dI2BFPOGseh77qYTyQJBUZZlxV0Zlca6ki/W?=
 =?us-ascii?Q?5od0Vaa3Cg+nA2521Aevr9dFSwEV+gfx58TDJcm8mBTCfGtPI8sJMhWWZeO5?=
 =?us-ascii?Q?Fn50Zr9g3ELpkpg6ctThriJN2DRmbG+CJ+V86jtfu8iATxAotfgeMo8MwsGm?=
 =?us-ascii?Q?tSYlByYZOnwhP4SdGTgSVGtrcXkCug5cdBh0BHEOAv1wHnkl6dJ55l9m0uMC?=
 =?us-ascii?Q?6RnwRKq88TG5wHH45RFHGZVJr/L8JmNCaB21LU8a4J1eGVTomas+j6D9uZ4h?=
 =?us-ascii?Q?XGBI/S7mXXBudR4wkEhAj5ICU8t0PVYB254l2X6ZEp1cvmBXeIz4h5k+VUsA?=
 =?us-ascii?Q?GE+3SvM7imG4b7iOHi6OZ8RynXccAYOAT1NZLbNknPxt9iPdIkB5xDp5/aE1?=
 =?us-ascii?Q?JzDOSa24twQiLWWhqjSFs4vtgPNzMjxFkrzl6o3AqeEoS03SkFD6soaK4yVQ?=
 =?us-ascii?Q?JqkVHGKosTul/FPVq8j7y+r0d5eQVyk/djaJAXjmqFW49OTHbRWHkOU650wJ?=
 =?us-ascii?Q?fshpqBJa6ZCTGFGwTMzFziWVGJMku3FuGX1CueuRVjRYaBEkqJFPg1xoj7so?=
 =?us-ascii?Q?uPzGZo4L9qjh32BOGtJvwH+0feKhZeKbVoPGFKELTJM34JZUO6XzMMAtYvce?=
 =?us-ascii?Q?MikgAX35bGQYrZk9MfJlbP327PJtWunnNpkM6ph2U/7T9vlo7im+uet3uhM1?=
 =?us-ascii?Q?V9PwQFAhdU2DqOZZ0v2z5sufO0/VGFgSFvZxkYvUInkiRSQT64wPVnaqXd8k?=
 =?us-ascii?Q?s0N0b+L/iLumJsd+vEsAWKDc//wbxIshfyyEe6rLbwBhC6A9tHXTMhz6JCJu?=
 =?us-ascii?Q?wQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91f20521-056f-41c1-ade2-08da66ad9235
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:29.5650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FionsTiKGwG8h72SlEriPZfvdBalz5otNHsr0InaQ2e8ae0cBDWBbhf5lXbmyPr3sXL0wYeKkDDlQpE5iqlBdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR03MB2857
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When disabling, there is nothing we can do about errors. In fact, the
only error which can occur is misuse of the API. Just warn in the mac
driver instead.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c   | 5 +----
 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 7 ++-----
 drivers/net/ethernet/freescale/fman/fman_memac.c | 8 +++-----
 drivers/net/ethernet/freescale/fman/fman_tgec.c  | 7 ++-----
 drivers/net/ethernet/freescale/fman/mac.h        | 2 +-
 5 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 02b588c46fcf..d378247a6d0c 100644
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

