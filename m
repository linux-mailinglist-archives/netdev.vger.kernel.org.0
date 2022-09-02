Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2175ABA86
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 00:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiIBWAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 18:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiIBV6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:58:32 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150043.outbound.protection.outlook.com [40.107.15.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F854F8FC6;
        Fri,  2 Sep 2022 14:58:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVAx4+wSDQZbuBvXgYqLeIRHSVbqUcGcrmi8HFO6SpSY8EVhUt5uqbEIsXL96uV29wVJUwep5LblxC5ztSlYxON39WqCjzP6anQs7K4/AuEKbu2e6QL2s9Q2mix1PkfVAueQPTTS65i0nCD/QuLcWvn1PaPabtuUea2oZsO8AAZyyJ567QBmFtUDnme865ZNrONIszEHUfv4ixaQp7u5G+1+iqDhPizfXVGXWQcukWHCAMDOTFBRtQ0QXIP0YqPyTlTSGEBmqUmljWk4xer/M22T7mUaxViyrac8tPx4A5KJFIeZYlLUPrSsBI5SOU/N43S7FpRgAwaI9No2HbvW4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPJ9aEZ0tCyCtwuMuwv2HSxodcvXZItyWRtXwYebUDY=;
 b=iqJPvLUEShMwZogzAUtbv0i3v7+rCKLfeMYcCbU0Sh+8opTpFr0Xv4sB/MK7e45N1Q/4k7r3jqbMEkTEno3nRC02UE+wrfN8hmyIjolg0NwFf3oPCILBAq7OfU/jAvxULKHqXzeecaHRMLkkPtvlTpgtNxP/OPlEPefnU8/+6aCjtGisGkk1Uusz1cOnA81fNRHFVAZ6CRmeHvBeEtEwUaBpzLsdOUFKSl56OlrjPMu6LOCPrVqC0Cr78U2CUmQk1gZFJbbtgZDvcxMSFK4sAmxy1/BTcX4wcSELdqxMVZrpE13TRBOnMhxGnafIcmOHrFFiwHW22+2OylOy9uhgbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPJ9aEZ0tCyCtwuMuwv2HSxodcvXZItyWRtXwYebUDY=;
 b=zu2vU3euAbW6SSmOT//0dX96aZX5AusK0AKHgyEP04LrzdHLwLZnTGwR0iVdjEn6DSBQT9/QpEMzb6Ye6ttogDKMnHHrT9A2YhwHHPzdApKEH0A23XJFO+gNxRS8WiC8sQEmOkU+mf0brWbyQrcPsxjNYaE/ObeSQ5+7dY27yXF2JcdVCu3l9wW+Q8J+Gs3mYEBrcnk7uPUPITwaYwN1aVn7QxEIeSTBE6kj19TvpVt7kjZ9UsqlYr8x3Ve4KgSACsUgW9Rl/gddgIM4GfMRXREfk60TXhc7Pin8v39aaOsR5VwRVIRMSKJdnmbKq3FyBK6eku/i+T3/Y3oX9LDaSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4085.eurprd03.prod.outlook.com (2603:10a6:20b:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 21:58:09 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:58:09 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 10/14] net: fman: Change return type of disable to void
Date:   Fri,  2 Sep 2022 17:57:32 -0400
Message-Id: <20220902215737.981341-11-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220902215737.981341-1-sean.anderson@seco.com>
References: <20220902215737.981341-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0315.namprd03.prod.outlook.com
 (2603:10b6:610:118::15) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a159ce17-7811-4988-4b1f-08da8d2e38e5
X-MS-TrafficTypeDiagnostic: AM6PR03MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2mveDSjxZP+mYTBWNqj4XARFkNbVGqAmmEChCN7X4zlqS9Ck8/j96oD5X6zHBcyMPX4AJu7o48RaL2fSgfpU5ARYnJQtbAM+VZrEACJQcTHHl64pgP1uGTYW6s2HPNux09c7QAfQT6BPwJGz/x0Sr1BkiIm1NLJqiARgU3ZdiccEaN/H0fXK4tjOSEr/mshc7ZET2IskfZ1y33XKZiaN17EajJmzBC92nqP9JLr/mmjDciWlT66VSK5JSYDGOm/6x3EG2qx8YHi2mFAF1YEv3v2UOjLIbM1wklK9eXHniRStskU89WXai4NhwQuMVb91fuT0MKq6SXx8c8TAvWg2jdKs176UBvZNrgrqVmG0RAuUas5cFr0I1AoJ1VmxwThBUPYckjzx22Birfx33lEGrpbVaEnWtV2c5HsKngSgDrg82+0uqGmgQAbWADsSeiiNP9Kj7iCcRMHxe4Kxcr52SgxPBNhPXGGlamrcUoDCIRZtx5ubo9eCa8JWPXoJKA3qDkYPWovdwVN5VAHxvN2giII3SMfTy7GQYDBGyfhPNFdbRFv5e6weEMQ9dXSBJLlrQp50DbA9fcHGI0AzOnMF6j7b0HHiWACNX1dAqqez0InxDNDqWvU265W7ZpWvOzOxK5n6h6JZu7CjgBvwFWpEccTQlIEfFh95iyR1K7MaQYUJ1AWNbjjEc3A2AwvWaknI0rIef7C+S+jbEVSPq1QGdk/bZ3E9nRScw6/7FEDMS5OF1fLBH6RrVcb+osQxNgYf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(376002)(396003)(366004)(6506007)(6512007)(26005)(2616005)(186003)(1076003)(7416002)(44832011)(52116002)(8936002)(5660300002)(86362001)(6486002)(41300700001)(6666004)(107886003)(478600001)(83380400001)(36756003)(2906002)(4326008)(8676002)(110136005)(316002)(38350700002)(38100700002)(66476007)(54906003)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zfCmFpCxulvDi/XP05hOxoGiaHsBhMK+cv57gmeboEnPvif8AY3psS4mw/G3?=
 =?us-ascii?Q?WnvokJxGnjGyUxrnWmNGvS5b+fEG3n9DA7Os2PlhGGV2qeIhmSJ6IgWS1Urn?=
 =?us-ascii?Q?pM0s3WcpqMiRfGtnpgEOB35fb+/2RdvwAEya9K+35MvYvEJ+TmQWilEQnmtq?=
 =?us-ascii?Q?4p8zXqrmtMZBmrTgC7TUOTHj+ECKyMtlgDg1FvXnfoym2O4pXALNYGnWsJbl?=
 =?us-ascii?Q?gzoMpFKZVAkmqe0z+gP4DzdoxYBh9f/LNq/QdARBJgwwJRBMqP5OJ9aFWVWX?=
 =?us-ascii?Q?Oi5b7inv/rSDjmVEz4abRTBMCVod0UqRfNgi2t337psYbN9NToyMsHV/iufb?=
 =?us-ascii?Q?yuBvuMLHy9muDo22y8MvGj6wTLbV2PpWoiqrfv9rg3DzMjmvqh4L2zfClsuO?=
 =?us-ascii?Q?NaV3F7AwXSTVEReDsZh85K/P6wHHoY47EnPJrfryhFGstT9U8bKSpqV50B2X?=
 =?us-ascii?Q?6k46KRLZFW3Ru6JvY9fAYlY6Fuh5cMtT4UMmt0hdMANR38OSlM7R34DIPxrV?=
 =?us-ascii?Q?mMfFI5yZNUIXhmFJFXgjOurYRkZdsqh6Wp2N8ullBr6JlTd3i3vwJHu/imSR?=
 =?us-ascii?Q?7msOCdptDkQc9LB6ma02omifjyDkrIkKoNeU+ZhpVmmGHWSSCU+bW4mQwBqo?=
 =?us-ascii?Q?gtvtSq6IVnmWtMXYB7trMOMl3dUA0SEe5p9hyxc/1ZvJxSZbXwZLOMy7/i+w?=
 =?us-ascii?Q?3mstpLLtwZF8o8Tur9WY35y3foqpsbCaODfX49QnbLcnwNi8N/XLgs0IJHz6?=
 =?us-ascii?Q?jJnaFyleT4F6dhESrGiPCBGd3qE8AWn+cxcTEYMes6ZfLTSJq5a67QViyaGB?=
 =?us-ascii?Q?+Z23sTkUMzqhTwSFE2jTZOI+Wl1nms8hj5mSwryGfBHS1/zu6CTUCH1C0I6Y?=
 =?us-ascii?Q?0FalHtVQKsYldgiyh//G8gTKgqjx5PqLy9g6d/DbZURDYFsy9emh7OooVSIh?=
 =?us-ascii?Q?RJjk+B1NqrTCBiyIDnMbExl6LcrTDThbSTSlMwtIRsGAyPjiHxalGZS/JrQe?=
 =?us-ascii?Q?9so54sVPeMwuD7ZFDLkCYPDdU+uJgp/TU84BE9+N3iF80SWdAgj6X2ynbRPx?=
 =?us-ascii?Q?brjICHcH1lQpBmMNc0dxz8HlixSyU6oh+zY3PedL/V913yEBjrmbKDvTjToY?=
 =?us-ascii?Q?RQJ6zhGh+zJiCMJ6s1inNs4tsyQsNYXEesbvgnnrYx2TJ0A/qfqcJizp01aQ?=
 =?us-ascii?Q?LmqMYrxjCTnnrKWCxbJrR+Z8XAhVsY22hMoZlOskBsiObX+2nNMWotZ+L0Dq?=
 =?us-ascii?Q?xUQLcoOcJ1ceisQQ0923taEjq70JgkHI7X5x4HhPxQQmbYyEfv7IyiqwljZL?=
 =?us-ascii?Q?E2Vt5AhXhSyMgQZ7QNm0VdGhl4huXZVuORUWyBv1lHOiWEpIfpci6M+bMwsO?=
 =?us-ascii?Q?pQpre8cEasZng0RZQ1utYnCMcXSPcsNf/M1+W8EZzwfuN1d73DturUZnPMHV?=
 =?us-ascii?Q?Q1ClUoOMPD/JRWXSHM0iKbjTLAlfvu7bLhxzfca2KroA4q/6Bfb+3hn55HDK?=
 =?us-ascii?Q?v+WE7gBu/mvRCK0IOnvPCjK+5GozMuxRRpRAn0ykUJ8/T/zzIUcmRxrugFUH?=
 =?us-ascii?Q?Ctg+CGfAURtjhjZtijWGwW42JOQDMFFIx8vJS2ex/FPAsQ02vc0OTipJ+/7B?=
 =?us-ascii?Q?jQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a159ce17-7811-4988-4b1f-08da8d2e38e5
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:58:09.0628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DEdJNS67+QwAJdMD2FnoLGKpzXC8F9bRGPnDJU35kyn4LFc4/f1MY2YiTyL9XMzjQ7kAoQcEl4HDpSN6lcFDCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 0e0d9415b93e..fc79abd1f204 100644
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
index 0a66ae58c026..1b60239d5fc7 100644
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

