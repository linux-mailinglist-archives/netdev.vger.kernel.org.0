Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB126A3E19
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 10:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjB0JRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 04:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjB0JRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 04:17:30 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660A4222C8
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 01:12:15 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id r27so7557411lfe.10
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 01:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MzeApAzG7O24Yh99pQWv7+dMMegpIs/OnvJLB7fcL04=;
        b=oUcVdWCxHqxWlm6gLkVSi56aeafu4S0MLAFSPo2NfXh/2CR+S8kUgCyDKNtBb7resD
         CwLV3o/dkwdcCnoqxS7daOqK6umL1tTl7nnNjcnHltu5yCKkYHZQXhAlNW8phhw8BH9l
         l8vnuL2lWkdjNweI+RYCGbFJYgV3sEcA4Ac8bvZZ83UaeK7oAxTIwAR057jNvr6oBoIk
         x/wWSwVjQDVRd/8nSF/GQY3eOaAVutyR2nqLVNZSdFO0b9iNjmt7gYA3MxfmSo6PwtTZ
         uOptP6XFExsF9eqMMbX6uJgMLNxhqV/MKpRSXY/ZyYaRGrTuW61usqQixLZqLP7VylcK
         5qIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MzeApAzG7O24Yh99pQWv7+dMMegpIs/OnvJLB7fcL04=;
        b=VdDkkfCDMCvL88l5HrWfGg7cLcejRlu4I0zLWk7WBUiTVb6DCCmHZE2AB1VYA/I5f/
         6wLWQEwXbLpyM58Km02eryuerwsVcFtGE0dT5/m60It31bb37OOdP2luvFW8KtskwkE6
         B3WEia52tvwEIOUujbtpgETMBr4R0IUs1em2vLaeLkFj4+Gx5bsmYFcNQkQm8VEHBN2H
         +NswpYnxJanh7dcInHtqWVk1WTN2+/pknFaCPxsfFs9U2xtZic+LsbZkzWcJt9cv2eBc
         eh33zEdHF+iYbSIzmScbWuTDUB1Te6PMU0z606gdWVY/zJTEbzEBkRxDW31a6Lml6nK5
         SKjA==
X-Gm-Message-State: AO0yUKW9OPvs51H/A1adVD9XFdU/cvey7NS57S7qLzswbdExX9k0n53U
        kKJH8+xOTme5x0/42siziog=
X-Google-Smtp-Source: AK7set/OnmoV8IxRZCSajIRukCOUEEGhArX6CmI418JS3Xv1vPT3/4mnyVi/lhp4/X8eUoziQIq+uA==
X-Received: by 2002:ac2:4842:0:b0:4df:5cc0:8ad1 with SMTP id 2-20020ac24842000000b004df5cc08ad1mr1349518lfy.28.1677489133511;
        Mon, 27 Feb 2023 01:12:13 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id a28-20020a2eb55c000000b0029352fc39fbsm643378ljn.63.2023.02.27.01.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 01:12:12 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Mason <jon.mason@broadcom.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Jon Mason <jdmason@kudzu.us>
Subject: [PATCH net] bgmac: fix *initial* chip reset to support BCM5358
Date:   Mon, 27 Feb 2023 10:11:56 +0100
Message-Id: <20230227091156.19509-1-zajec5@gmail.com>
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

From: Rafał Miłecki <rafal@milecki.pl>

While bringing hardware up we should perform a full reset including the
switch bit (BGMAC_BCMA_IOCTL_SW_RESET aka SICF_SWRST). It's what
specification says and what reference driver does.

This seems to be critical for the BCM5358. Without this hardware doesn't
get initialized properly and doesn't seem to transmit or receive any
packets.

Originally bgmac was calling bgmac_chip_reset() before setting
"has_robosw" property which resulted in expected behaviour. That has
changed as a side effect of adding platform device support which
regressed BCM5358 support.

Fixes: f6a95a24957a ("net: ethernet: bgmac: Add platform device support")
Cc: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/ethernet/broadcom/bgmac.c | 8 ++++++--
 drivers/net/ethernet/broadcom/bgmac.h | 2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 3038386a5afd..1761df8fb7f9 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -890,13 +890,13 @@ static void bgmac_chip_reset_idm_config(struct bgmac *bgmac)
 
 		if (iost & BGMAC_BCMA_IOST_ATTACHED) {
 			flags = BGMAC_BCMA_IOCTL_SW_CLKEN;
-			if (!bgmac->has_robosw)
+			if (bgmac->in_init || !bgmac->has_robosw)
 				flags |= BGMAC_BCMA_IOCTL_SW_RESET;
 		}
 		bgmac_clk_enable(bgmac, flags);
 	}
 
-	if (iost & BGMAC_BCMA_IOST_ATTACHED && !bgmac->has_robosw)
+	if (iost & BGMAC_BCMA_IOST_ATTACHED && (bgmac->in_init || !bgmac->has_robosw))
 		bgmac_idm_write(bgmac, BCMA_IOCTL,
 				bgmac_idm_read(bgmac, BCMA_IOCTL) &
 				~BGMAC_BCMA_IOCTL_SW_RESET);
@@ -1490,6 +1490,8 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 	struct net_device *net_dev = bgmac->net_dev;
 	int err;
 
+	bgmac->in_init = true;
+
 	bgmac_chip_intrs_off(bgmac);
 
 	net_dev->irq = bgmac->irq;
@@ -1542,6 +1544,8 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 	/* Omit FCS from max MTU size */
 	net_dev->max_mtu = BGMAC_RX_MAX_FRAME_SIZE - ETH_FCS_LEN;
 
+	bgmac->in_init = false;
+
 	err = register_netdev(bgmac->net_dev);
 	if (err) {
 		dev_err(bgmac->dev, "Cannot register net device\n");
diff --git a/drivers/net/ethernet/broadcom/bgmac.h b/drivers/net/ethernet/broadcom/bgmac.h
index e05ac92c0650..d73ef262991d 100644
--- a/drivers/net/ethernet/broadcom/bgmac.h
+++ b/drivers/net/ethernet/broadcom/bgmac.h
@@ -472,6 +472,8 @@ struct bgmac {
 	int irq;
 	u32 int_mask;
 
+	bool in_init;
+
 	/* Current MAC state */
 	int mac_speed;
 	int mac_duplex;
-- 
2.34.1

