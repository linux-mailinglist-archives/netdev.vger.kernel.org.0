Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A6C55F156
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiF1WRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiF1WPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:15:08 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00064.outbound.protection.outlook.com [40.107.0.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9464037AA6;
        Tue, 28 Jun 2022 15:15:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLzbiNGC2jCUn2WrXsCLiQuInP8dizCSpL2LIXyM6oWSAZ2OsrcalFrf/rtHQWFF7MYbdlPxYVn8rYTGROJVbGSJo6ziUjqUaq61/YK5i5GotB3QFB3jNWrxQr0CnGwHCD85e/CqCSGCk/vsSs1qObCWZ/ESVTAxQnuZM5JCyNQOymQCQF7NZ8jBO9FbqllRiroSHl1sNjUPpWkOiT8jfNsoJXdBQPyvnhIN4LKrWzSPB/v2SrNWi+3rbWaXed3Wv0+G7CWB7ZIKR4LvsM/KfcldP0p59drYzONBIUg3tFAjgCuLbTlOvzgGiONzgI66fyUqdFRZGxusLXzP48bsUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z92nDiFPrY/SLAPUikzBA56YSrw9Hgp2mCAPGnpbtek=;
 b=UrgHo38pq7V1ihU+dJt7MQ5gnivc0hXaizyvc7DW6F9h9Lhc2IOLIbp5z7MPBWnauveVGrGehF8v80uftLftnJ9djp2BThkAy6/eVH+6nb1FM8ek+mkaZhLr5PorMiz/KLL1sDU/nBRzOOhx1icD7fpg5yMh6SLApoS3A75EW+kVsFu09vS63yusveJjGEQKCVZS17CU8CcdBfA5eTRZ1SsPe8/EmRLouCtTTSOo+BM6sP2xYl903sfJPEOiDn/nQJY1WxLMuPtsxtHHdwYfC+KRyb96RJXrdqEOQ5MomxYOjy80WoRuaTjt34wcijeO51SlM6oy+6vmNnCovGW3jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z92nDiFPrY/SLAPUikzBA56YSrw9Hgp2mCAPGnpbtek=;
 b=JxEnwYgaBY8jXODsHY5cXg6V4puHe1SSwOvGvLJWL0MpeVIYMtRVAVgN10pdRtOGVDh54lpgmrRrijvwbrN/wm8ABL2+5squWRUeVwO5O1VwkXOhEkBNruHn6qG+fwQ8iaXDRuPWQLgCEN3Jr+Ck8L/flRZYYieteGGRp61yQJPAW420d88+64MbmugL0g6yFeYiafMBeJ0oc/khuYG1h700bGAp35Azm55QtnqqptE+G27mCTe7rp2+CsMKkkCZBYP1OcPBGtdiamHuovVJj4UwlBjrOTfDYmrwrUYIgA3PO7EkRz5GGZuUZnNPw7fNXWsvq3JXP/Z5t+hPO4r3Mw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB6PR03MB3013.eurprd03.prod.outlook.com (2603:10a6:6:3c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:52 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:52 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 21/35] net: fman: Use mac_dev for some params
Date:   Tue, 28 Jun 2022 18:13:50 -0400
Message-Id: <20220628221404.1444200-22-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 396f13b0-c9cf-4c00-eec8-08da59539f80
X-MS-TrafficTypeDiagnostic: DB6PR03MB3013:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qFnZRlsLubuh2uZ5MRCnWBuGxEgKtgTmEDIzraQxJJM8cW0ryR61XpP+ppsbecblatO270zNaMi//4oxspsvfQKMaTGtVB5lRSV35BwE5+h7/yVwICm91ottbsyacDGvnl4ewXS2BF4HefZMlY5SF7Xba0y3XfABxqld4TzY0aDh4aJwfaFIjF/rRMXToyYcILbipEFCWaN34oCb/l7yd+2/XLMsPjPLofq2dtiCtZR8x0NsQ++3arYQN7XcrNwie2WAJwf1UcpRgG+xh1lMPJPuwKCH15ak+6sdW5gJ8BHyzIK3OvXfUmKOUJimHANaQSccacMVVmnyQEgUO72943Vl1PDlTJX5cliUgvDkEcpPrBqgIlML/QNqfCUyK3q1AlQ42Vt/Dc3g+mgkMvXidbWvn5Nc+3qWdB8c064Z4xcIKEKKMsNWBooHl5CfPdvxBf6kI++qrv8IqmGvmHu5WHjwB7g6hxiEtr57JfzdyZkEgnLXWx2P4ieuG6yFXVJR5/Yo+ZfRyBXHLZgeDE1GkyNsKTwnOd+j0WP7Wvq/6l3c5884N8PZHthPB2tPDsURGQXNfEoqB3bVj5OjM9Dc+5rx3xJkJX6xcMSYUjOx1vhMWZmowOfnZgxmnUjPiUbrQVENO+7FE4DjavTGkV9du2OdclyT2Z8k3ebLOhOkE1GM48MlHNoBR1RbdbwXPR9aqrlRWNSy5JGmcsANilE7061NQO6hiev3K5UXLcIy/QP2pO32Woj+191zVJDE3rZOWIZI+UAGuoRugu1gD2N2cF1Ni0MC+eIUfJKBm8bFKC4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39850400004)(376002)(366004)(136003)(346002)(2616005)(41300700001)(26005)(107886003)(1076003)(66946007)(8676002)(6506007)(6512007)(52116002)(186003)(38350700002)(83380400001)(44832011)(6486002)(8936002)(66476007)(38100700002)(2906002)(66556008)(86362001)(5660300002)(54906003)(36756003)(110136005)(4326008)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nXOWftF6KPe95MbcV6yCc5tNVUzcPmcXZNJDfDkFNSyhr5P76qsg74CgiPHP?=
 =?us-ascii?Q?AlJwFD+D3EwNbH2HE+ZkXN0PxaA6XyhUTKXwTxaxsxCFkCb0PXsdfAJbXqZA?=
 =?us-ascii?Q?QJ+1wDxMokaSlrSQUwWBPLIoO+7v587cVmkPICgHu/keXYYpM0F44HzMZkUq?=
 =?us-ascii?Q?zm17e+SECCUqPoGY4DgaLxJR+pJN52+1j2quiH+GWv89c5noaphb68xhJv0Y?=
 =?us-ascii?Q?H08po8CWy8+UTkPADrh5sEVkCNzICnMjh87gnsxKh7FKQ7LDGP+nAES4kKM3?=
 =?us-ascii?Q?BbqgdBEVpjndS+xmSHbnsBoQN+bQQ3ghXv94q3CgVxKU6JAlrZRH9wTrnmnC?=
 =?us-ascii?Q?FOTROQYCeLoKbKHgG7OwrVSGEqNntXrKOc535epkbpfXeImdTlhLFjZ7Q5v0?=
 =?us-ascii?Q?jAkVIcy9BzRkderENQ9/t3waZ3C0+fniLbehOZi7BU6MsebzqwUzTky++cGZ?=
 =?us-ascii?Q?4IW7/sPVLQbMWp3GZUBkUfDJJLXMmdUVTf6Pr84oUkA7QMP4AZCSzC6TBqp2?=
 =?us-ascii?Q?2egDfRwrUrSoRmmr4jqyPyfHjtQ5+7WLVCvezUkCZY4Lwk26bja7bBP/vJiV?=
 =?us-ascii?Q?FEAYxr+0nkz0bEB3058ZoipElNI94mRs8vszFMPqFfPua30xlXFz3ntU101l?=
 =?us-ascii?Q?C17UhzXwGto7f38gXZRbTBLoabQOskYEmVw+CaRub6lCDnDQDTBg0/W8piUJ?=
 =?us-ascii?Q?IA+dnJPskFHumfZNFyR+TRLIf+WzLIMd0Ro9HJZgS8aoi2aNSQ9r1kifpuZ5?=
 =?us-ascii?Q?oJi9pjszhxHMKHKdK6xdO6mfafGFHelV9O6Ki/krwyLp5j0rH9F6jn3bZ24m?=
 =?us-ascii?Q?fiZcss/UxqOa6HiSP6fUHC8vdzFYRudvvZ+4FMdjcrC9Nh7OGHd7rSNCZQc5?=
 =?us-ascii?Q?NgUYzgEMY+AhHUPTaWX2dvWmq5DKpctN+uTpn1cYgSN2hCihQhsCiSNKZnhF?=
 =?us-ascii?Q?yN3NOZyQoPHm1jsV20Q0RYvQev0HZmvOcAXg9dy0+zKF22JTV7wo1L4ZeOfV?=
 =?us-ascii?Q?Ny8sxnQTAnmsQFuhITtUyuSplD6gNBcMrmPu4u8kUBiT8J2dvPmCkf/UDk63?=
 =?us-ascii?Q?bg/O4AzrwScn6YUldf7TnTVIHoZC+fEKuP0Y/s15q5kyNnrt7Twlnux4naVY?=
 =?us-ascii?Q?aJByiq6Gd+8S//DYZrQCbU2aG18QT9d7JM1DoSx4Q7iIAbpF9yfEnPeL5ipp?=
 =?us-ascii?Q?Q3zjQjsqC2FX4+ypH2aeWv1MFSaSid/6pF+KKitM72VQ2h1pQ8h6Zq5nPcYz?=
 =?us-ascii?Q?k40G0khdj+EoYOz0G7cu8CXO54t4ktAX6eMUtuE2go+gQLtWWsCRJUX8Qyk0?=
 =?us-ascii?Q?URxicIwRB3MbciPqTCdpBPeGkolDFTnlwFF8NQWVLac1pClt5t5a9tJj9Gu5?=
 =?us-ascii?Q?8DQkeSb5tPiu5+ylWrNskMqeIMOqpwVCkLEr2frI4LvxFabY7LchCIg2dO9g?=
 =?us-ascii?Q?EhPILn1EuGQWk3ESYELPxFCtteENwzw4wZr2CZqVozFhDUVCGxPHg/L8ztwn?=
 =?us-ascii?Q?L/VU8M8ufxWzM8DXuR4ev8ZbKBhF0asJ9YlLGoKlE0PFF59edeck3Lq+VsNh?=
 =?us-ascii?Q?hqgZkTC1qvhisyOnennN8VEGtDBVZpN0KDDKsF62lV2GAUWFhyPn1X8hG4HF?=
 =?us-ascii?Q?Rg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 396f13b0-c9cf-4c00-eec8-08da59539f80
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:52.1249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qiQAQ7+q81LDJzign3ertkE/BxLE14GpceuI51mYLuinOldNT8AEiXVTKTx4QY2BpniYa4v5VfF3w0zviio70g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB3013
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some params are already present in mac_dev. Use them directly instead of
passing them through params.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_dtsec.c    | 16 +++++++---------
 drivers/net/ethernet/freescale/fman/fman_mac.h  |  7 -------
 .../net/ethernet/freescale/fman/fman_memac.c    | 17 ++++++++---------
 drivers/net/ethernet/freescale/fman/fman_tgec.c | 12 +++++-------
 drivers/net/ethernet/freescale/fman/mac.c       | 10 ++--------
 5 files changed, 22 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 9fabb2dfc972..09ad1117005a 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1413,13 +1413,11 @@ static int dtsec_free(struct fman_mac *dtsec)
 	return 0;
 }
 
-static struct fman_mac *dtsec_config(struct fman_mac_params *params)
+static struct fman_mac *dtsec_config(struct mac_device *mac_dev,
+				     struct fman_mac_params *params)
 {
 	struct fman_mac *dtsec;
 	struct dtsec_cfg *dtsec_drv_param;
-	void __iomem *base_addr;
-
-	base_addr = params->base_addr;
 
 	/* allocate memory for the UCC GETH data structure. */
 	dtsec = kzalloc(sizeof(*dtsec), GFP_KERNEL);
@@ -1436,10 +1434,10 @@ static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 
 	set_dflts(dtsec_drv_param);
 
-	dtsec->regs = base_addr;
-	dtsec->addr = ENET_ADDR_TO_UINT64(params->addr);
+	dtsec->regs = mac_dev->vaddr;
+	dtsec->addr = ENET_ADDR_TO_UINT64(mac_dev->addr);
 	dtsec->max_speed = params->max_speed;
-	dtsec->phy_if = params->phy_if;
+	dtsec->phy_if = mac_dev->phy_if;
 	dtsec->mac_id = params->mac_id;
 	dtsec->exceptions = (DTSEC_IMASK_BREN	|
 			     DTSEC_IMASK_RXCEN	|
@@ -1456,7 +1454,7 @@ static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 			     DTSEC_IMASK_RDPEEN);
 	dtsec->exception_cb = params->exception_cb;
 	dtsec->event_cb = params->event_cb;
-	dtsec->dev_id = params->dev_id;
+	dtsec->dev_id = mac_dev;
 	dtsec->ptp_tsu_enabled = dtsec->dtsec_drv_param->ptp_tsu_en;
 	dtsec->en_tsu_err_exception = dtsec->dtsec_drv_param->ptp_exception_en;
 
@@ -1495,7 +1493,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= dtsec_enable;
 	mac_dev->disable		= dtsec_disable;
 
-	mac_dev->fman_mac = dtsec_config(params);
+	mac_dev->fman_mac = dtsec_config(mac_dev, params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index 7774af6463e5..730aae7fed13 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -163,25 +163,18 @@ typedef void (fman_mac_exception_cb)(void *dev_id,
 
 /* FMan MAC config input */
 struct fman_mac_params {
-	/* Base of memory mapped FM MAC registers */
-	void __iomem *base_addr;
-	/* MAC address of device; First octet is sent first */
-	enet_addr_t addr;
 	/* MAC ID; numbering of dTSEC and 1G-mEMAC:
 	 * 0 - FM_MAX_NUM_OF_1G_MACS;
 	 * numbering of 10G-MAC (TGEC) and 10G-mEMAC:
 	 * 0 - FM_MAX_NUM_OF_10G_MACS
 	 */
 	u8 mac_id;
-	/* PHY interface */
-	phy_interface_t	 phy_if;
 	/* Note that the speed should indicate the maximum rate that
 	 * this MAC should support rather than the actual speed;
 	 */
 	u16 max_speed;
 	/* A handle to the FM object this port related to */
 	void *fm;
-	void *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *event_cb;    /* MDIO Events Callback Routine */
 	fman_mac_exception_cb *exception_cb;/* Exception Callback Routine */
 	/* SGMII/QSGII interface with 1000BaseX auto-negotiation between MAC
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 7121be0f958b..2f3050df5ab9 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1109,13 +1109,12 @@ static int memac_free(struct fman_mac *memac)
 	return 0;
 }
 
-static struct fman_mac *memac_config(struct fman_mac_params *params)
+static struct fman_mac *memac_config(struct mac_device *mac_dev,
+				     struct fman_mac_params *params)
 {
 	struct fman_mac *memac;
 	struct memac_cfg *memac_drv_param;
-	void __iomem *base_addr;
 
-	base_addr = params->base_addr;
 	/* allocate memory for the m_emac data structure */
 	memac = kzalloc(sizeof(*memac), GFP_KERNEL);
 	if (!memac)
@@ -1133,17 +1132,17 @@ static struct fman_mac *memac_config(struct fman_mac_params *params)
 
 	set_dflts(memac_drv_param);
 
-	memac->addr = ENET_ADDR_TO_UINT64(params->addr);
+	memac->addr = ENET_ADDR_TO_UINT64(mac_dev->addr);
 
-	memac->regs = base_addr;
+	memac->regs = mac_dev->vaddr;
 	memac->max_speed = params->max_speed;
-	memac->phy_if = params->phy_if;
+	memac->phy_if = mac_dev->phy_if;
 	memac->mac_id = params->mac_id;
 	memac->exceptions = (MEMAC_IMASK_TSECC_ER | MEMAC_IMASK_TECC_ER |
 			     MEMAC_IMASK_RECC_ER | MEMAC_IMASK_MGI);
 	memac->exception_cb = params->exception_cb;
 	memac->event_cb = params->event_cb;
-	memac->dev_id = params->dev_id;
+	memac->dev_id = mac_dev;
 	memac->fm = params->fm;
 	memac->basex_if = params->basex_if;
 
@@ -1177,9 +1176,9 @@ int memac_initialization(struct mac_device *mac_dev,
 	mac_dev->disable		= memac_disable;
 
 	if (params->max_speed == SPEED_10000)
-		params->phy_if = PHY_INTERFACE_MODE_XGMII;
+		mac_dev->phy_if = PHY_INTERFACE_MODE_XGMII;
 
-	mac_dev->fman_mac = memac_config(params);
+	mac_dev->fman_mac = memac_config(mac_dev, params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index f34f89e46a6f..2642a4c27292 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -728,13 +728,11 @@ static int tgec_free(struct fman_mac *tgec)
 	return 0;
 }
 
-static struct fman_mac *tgec_config(struct fman_mac_params *params)
+static struct fman_mac *tgec_config(struct mac_device *mac_dev, struct fman_mac_params *params)
 {
 	struct fman_mac *tgec;
 	struct tgec_cfg *cfg;
-	void __iomem *base_addr;
 
-	base_addr = params->base_addr;
 	/* allocate memory for the UCC GETH data structure. */
 	tgec = kzalloc(sizeof(*tgec), GFP_KERNEL);
 	if (!tgec)
@@ -752,8 +750,8 @@ static struct fman_mac *tgec_config(struct fman_mac_params *params)
 
 	set_dflts(cfg);
 
-	tgec->regs = base_addr;
-	tgec->addr = ENET_ADDR_TO_UINT64(params->addr);
+	tgec->regs = mac_dev->vaddr;
+	tgec->addr = ENET_ADDR_TO_UINT64(mac_dev->addr);
 	tgec->max_speed = params->max_speed;
 	tgec->mac_id = params->mac_id;
 	tgec->exceptions = (TGEC_IMASK_MDIO_SCAN_EVENT	|
@@ -773,7 +771,7 @@ static struct fman_mac *tgec_config(struct fman_mac_params *params)
 			    TGEC_IMASK_RX_ALIGN_ER);
 	tgec->exception_cb = params->exception_cb;
 	tgec->event_cb = params->event_cb;
-	tgec->dev_id = params->dev_id;
+	tgec->dev_id = mac_dev;
 	tgec->fm = params->fm;
 
 	/* Save FMan revision */
@@ -803,7 +801,7 @@ int tgec_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= tgec_enable;
 	mac_dev->disable		= tgec_disable;
 
-	mac_dev->fman_mac = tgec_config(params);
+	mac_dev->fman_mac = tgec_config(mac_dev, params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index fb04c1f9cd3e..0f9e3e9e60c6 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -34,7 +34,6 @@ struct mac_priv_s {
 	struct list_head		mc_addr_list;
 	struct platform_device		*eth_dev;
 	u16				speed;
-	u16				max_speed;
 };
 
 struct mac_address {
@@ -439,7 +438,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	mac_dev->phy_if = phy_if;
 
 	priv->speed		= phy2speed[mac_dev->phy_if];
-	priv->max_speed		= priv->speed;
+	params.max_speed	= priv->speed;
 	mac_dev->if_support	= DTSEC_SUPPORTED;
 	/* We don't support half-duplex in SGMII mode */
 	if (mac_dev->phy_if == PHY_INTERFACE_MODE_SGMII)
@@ -447,7 +446,7 @@ static int mac_probe(struct platform_device *_of_dev)
 					SUPPORTED_100baseT_Half);
 
 	/* Gigabit support (no half-duplex) */
-	if (priv->max_speed == 1000)
+	if (params.max_speed == 1000)
 		mac_dev->if_support |= SUPPORTED_1000baseT_Full;
 
 	/* The 10G interface only supports one mode */
@@ -457,16 +456,11 @@ static int mac_probe(struct platform_device *_of_dev)
 	/* Get the rest of the PHY information */
 	mac_dev->phy_node = of_parse_phandle(mac_node, "phy-handle", 0);
 
-	params.base_addr = mac_dev->vaddr;
-	memcpy(&params.addr, mac_dev->addr, sizeof(mac_dev->addr));
-	params.max_speed	= priv->max_speed;
-	params.phy_if		= mac_dev->phy_if;
 	params.basex_if		= false;
 	params.mac_id		= priv->cell_index;
 	params.fm		= (void *)priv->fman;
 	params.exception_cb	= mac_exception;
 	params.event_cb		= mac_exception;
-	params.dev_id		= mac_dev;
 
 	err = init(mac_dev, mac_node, &params);
 	if (err < 0) {
-- 
2.35.1.1320.gc452695387.dirty

