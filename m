Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AF16A1D19
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 14:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjBXNtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 08:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjBXNtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 08:49:03 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BA217144;
        Fri, 24 Feb 2023 05:49:02 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id s22so17868830lfi.9;
        Fri, 24 Feb 2023 05:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AZ7jweNDhv008P7BIGu/FPSGXOhE2NT82NyplwI7uuc=;
        b=YRsJJnFWlhBaEXBTYsJd3PDs2dzzwY5B6Dmhu4XdX601mMeC3C4zToqkc9yFjUe6Di
         WR8g3pORJ85vE1sjJT7pEZqpr9T+kW+okfNSFnBh70y41GtENoLjf0uxNjDsnEIrMMPO
         MkMNuId037ESU3qyfcWkkJYlZlJahnIbAcvPf40wxbQVQV5bEG/dFtDyjyGgPJrl6B/C
         aQyCp2o1KAyI/mutNEMhqVmmusv+wkrPNAe8CaVLR7fknEVkrHoMoryM45kBnE0hiO8O
         Q9KALeGm0ekko4jp3oRJwtUaXV3Yg30NzU5Cw83lcCk5h80EryximKSJn4oPHYt8yaPh
         bkxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AZ7jweNDhv008P7BIGu/FPSGXOhE2NT82NyplwI7uuc=;
        b=BM97STfaF1/TGSn6+lMigFtpwYKip6YkSzMlzXgt+wobNtZ5Ng4iAuk225szOir+uI
         LQkvm3vaBXezDIXR0RJSCMhBlsAX0bq4DKlMOR5H0nqGJreUnoQtPyYvih5CxSJT6oYy
         6YmxcP5gMANeUYS44/AAc7kA6nTIRcFoRYJfidP92zLE7G82H4FQQBQbpwlnkt7rdRe+
         8Wc31ybLmkjPfSqAw+JFKUcnxWvwUKTlEpDJTgWSy64N7AuPnkyFSVUl/tgr6dmTlMoT
         0mOiHLse9X6CrDXJMwAM83zt46ylaHyPSaEqWB3DcHkEXB0M6MBNRedwMFrxgt6QT8Xa
         o65w==
X-Gm-Message-State: AO0yUKUjJd4E8yIYQNj0aqpxaKAllSwVlpwCPL0m79Qs/1dQdSAkAF35
        7KtF8/yocAXbeQp2uvj93Uo=
X-Google-Smtp-Source: AK7set/gz1Tdhd4R6zPgD14Fh2WPnT0raS0/qH0xWprMLeHlkO3QVxxsbyonhGuoYbzrrmmtIFIp8g==
X-Received: by 2002:a05:6512:66:b0:4a4:7be4:9baf with SMTP id i6-20020a056512006600b004a47be49bafmr5239540lfo.59.1677246540444;
        Fri, 24 Feb 2023 05:49:00 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id 1-20020ac25681000000b004d594481d0asm1582928lfr.34.2023.02.24.05.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 05:48:59 -0800 (PST)
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
Subject: [PATCH RFC Vb] bgmac: fix *initial* chip reset to support BCM5358
Date:   Fri, 24 Feb 2023 14:48:51 +0100
Message-Id: <20230224134851.18028-1-zajec5@gmail.com>
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
RFC: This is alternative solutionto the
[PATCH RFC] bgmac: fix *initial* chip reset to support BCM5358
https://lore.kernel.org/lkml/20230207225327.27534-1-zajec5@gmail.com/T/

Any comments on the prefered solution? Parameter vs. flag?
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

