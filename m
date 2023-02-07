Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B88E68E3A5
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 23:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjBGWyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 17:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBGWyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 17:54:00 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F9322A03;
        Tue,  7 Feb 2023 14:53:59 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id dr8so46697591ejc.12;
        Tue, 07 Feb 2023 14:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fCqExVtxIQ8fx2PtH4CD+ssBUWyleyM+Y/yJC5Su3to=;
        b=ARzyMCa57hmvHj2qiZ4Y0X13C2pc3k0DK/F2SzSo1J3Kh73G8GiPLEp9M/eWhfoboU
         oJLFipPSnGer6Pi3m4oPdjzsgWPxlEDqn3pSJCphmLxWCZj6+egr4cvyWcoIc2FKctnN
         t2BWYV+kCIKA1yPkqdr2XUs39eIYx86OrZe+edReKl84nvQlqLabsVqKACLsvnP+uCrq
         rRstHEk37Y+ea138gvu0Gow3zAoNSjN1G2TwKHAbHWuhMoXgtUH1y3IVX6G6UbLFEb/R
         6V+VrhoB8W3sAGoMReTaH8+ufnYLkq4U2UNa53CPU/qlcUAu3tSk5Akz6B6GkxSmgLED
         cvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fCqExVtxIQ8fx2PtH4CD+ssBUWyleyM+Y/yJC5Su3to=;
        b=g+XICN+wIH6ALaIr8Zke59RzAHcEa3Xwib6X70+NObYnvxUt0VRJ/kGNykoxcMGPHv
         FY5rl7KK/5E3PhFxD/s+B+s+74XIMBot596bKztqmA8emX79i2Jl/oA/EsWVUdElQakr
         0R1rpWmPlnnMfGsF+gj0+mzacZ+PvLOV05CErPHo1Wi1rX0wE8tjmYMGmeVxi4VJ5apN
         KdBwHWPWH1DgEHRegfuUETU1Tl0SPSHqjp/13XIw4ZrNUjx5vJsbBpeDrbYrCpriMdRu
         yyGsVTQvJk2uSmXpB1r6DW5uw3DMTqAq2nsrCpudaao55/M/vUmj72S/WmAsJRFshibG
         MuHg==
X-Gm-Message-State: AO0yUKXjqVD+dNAFCIgmNRGsNeann+PaZATgipoq7KNeGAfDiLhhEZOM
        gZi0vLnLGQBLHOENgn+5CF0=
X-Google-Smtp-Source: AK7set858wdCN1RRt53CZdx+41ECs55QkbWbM6xU5QVfjUe3stU2UAoU/eH6rUPXzk3fuQ6uujlvNw==
X-Received: by 2002:a17:907:20cb:b0:87f:89f2:c012 with SMTP id qq11-20020a17090720cb00b0087f89f2c012mr5670236ejb.24.1675810437547;
        Tue, 07 Feb 2023 14:53:57 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id b21-20020a170906195500b008779b5c7db6sm7437785eje.107.2023.02.07.14.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 14:53:56 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH RFC] bgmac: fix *initial* chip reset to support BCM5358
Date:   Tue,  7 Feb 2023 23:53:27 +0100
Message-Id: <20230207225327.27534-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While bringing hardware up we should perform a full reset including the
switch bit (BGMAC_BCMA_IOCTL_SW_RESET aka SICF_SWRST). It's what
specification says and what reference driver does.

This seems to be critical for the BCM5358. Without this hardware doesn't
get initialized properly and doesn't seem to transmit or receive any
packets.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
RFC: What do you think about adding that "bool initial" parameter? Is
     that OK? As an alternative I could use something like
     u16 flags;
     BGMAC_FLAGS_INITIAL_RESET
---
 drivers/net/ethernet/broadcom/bgmac.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 3038386a5afd..4963fdbad31b 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -876,7 +876,7 @@ static void bgmac_miiconfig(struct bgmac *bgmac)
 	}
 }
 
-static void bgmac_chip_reset_idm_config(struct bgmac *bgmac)
+static void bgmac_chip_reset_idm_config(struct bgmac *bgmac, bool initial)
 {
 	u32 iost;
 
@@ -890,20 +890,20 @@ static void bgmac_chip_reset_idm_config(struct bgmac *bgmac)
 
 		if (iost & BGMAC_BCMA_IOST_ATTACHED) {
 			flags = BGMAC_BCMA_IOCTL_SW_CLKEN;
-			if (!bgmac->has_robosw)
+			if (initial || !bgmac->has_robosw)
 				flags |= BGMAC_BCMA_IOCTL_SW_RESET;
 		}
 		bgmac_clk_enable(bgmac, flags);
 	}
 
-	if (iost & BGMAC_BCMA_IOST_ATTACHED && !bgmac->has_robosw)
+	if (iost & BGMAC_BCMA_IOST_ATTACHED && (initial || !bgmac->has_robosw))
 		bgmac_idm_write(bgmac, BCMA_IOCTL,
 				bgmac_idm_read(bgmac, BCMA_IOCTL) &
 				~BGMAC_BCMA_IOCTL_SW_RESET);
 }
 
 /* http://bcm-v4.sipsolutions.net/mac-gbit/gmac/chipreset */
-static void bgmac_chip_reset(struct bgmac *bgmac)
+static void bgmac_chip_reset(struct bgmac *bgmac, bool initial)
 {
 	u32 cmdcfg_sr;
 	int i;
@@ -927,7 +927,7 @@ static void bgmac_chip_reset(struct bgmac *bgmac)
 	}
 
 	if (!(bgmac->feature_flags & BGMAC_FEAT_IDM_MASK))
-		bgmac_chip_reset_idm_config(bgmac);
+		bgmac_chip_reset_idm_config(bgmac, initial);
 
 	/* Request Misc PLL for corerev > 2 */
 	if (bgmac->feature_flags & BGMAC_FEAT_MISC_PLL_REQ) {
@@ -1177,7 +1177,7 @@ static int bgmac_open(struct net_device *net_dev)
 	struct bgmac *bgmac = netdev_priv(net_dev);
 	int err = 0;
 
-	bgmac_chip_reset(bgmac);
+	bgmac_chip_reset(bgmac, false);
 
 	err = bgmac_dma_init(bgmac);
 	if (err)
@@ -1214,7 +1214,7 @@ static int bgmac_stop(struct net_device *net_dev)
 	bgmac_chip_intrs_off(bgmac);
 	free_irq(bgmac->irq, net_dev);
 
-	bgmac_chip_reset(bgmac);
+	bgmac_chip_reset(bgmac, false);
 	bgmac_dma_cleanup(bgmac);
 
 	return 0;
@@ -1515,7 +1515,7 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 			bgmac_idm_write(bgmac, BCMA_OOB_SEL_OUT_A30, 0x86);
 	}
 
-	bgmac_chip_reset(bgmac);
+	bgmac_chip_reset(bgmac, true);
 
 	err = bgmac_dma_alloc(bgmac);
 	if (err) {
@@ -1587,7 +1587,7 @@ int bgmac_enet_suspend(struct bgmac *bgmac)
 	netif_tx_unlock(bgmac->net_dev);
 
 	bgmac_chip_intrs_off(bgmac);
-	bgmac_chip_reset(bgmac);
+	bgmac_chip_reset(bgmac, false);
 	bgmac_dma_cleanup(bgmac);
 
 	return 0;
-- 
2.34.1

