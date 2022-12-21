Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D17AC653340
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbiLUP0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbiLUPZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:25:54 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFD712A85
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:52 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id d20so22556841edn.0
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zaFd0UHzSeYEPzZz7K9tbNkv+WSIQz5WkJ+qjHeZoG0=;
        b=76sOPqH/fmMgKEbazcH+Us5Ma/WrgGw2WhMh2Oh4SnBnYPN7eFgp0t3UON5GvUybhR
         P8qW/TgFWtg6lGMwfIN4AGRTwdt7DUNP1rW570xjnTKeP4tkREOpsVbF/QqgR/GZ6Rfm
         KVraxRJbkv2q54RucMzujZVWEHoaSAxvoK87TIkyA+c6d4QnWsLZrqBxTLrSaVFyArbH
         6wXtYD6quzZG/Uw64VkfNJ4eU+3ynyLczd/DWzEzwTtuHsxzCZbYfauaA9oJLkRs9kMd
         ixsRxmwhvBMcLJYlOZviydhMCc/gwfbUpKWzNpKvyJ2JP02yEgSyBtzLVrikc6Kau+qV
         GvlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zaFd0UHzSeYEPzZz7K9tbNkv+WSIQz5WkJ+qjHeZoG0=;
        b=36Jy2QGpyY65iYfKlKhPQ/bhMMi2/fspJnkHWrxQ9naFQtgOLKcGkAJWsAXuYsG5OP
         03Ukh7d9FvWtTygd1m57RgRlA0stdb1HP474EBCDNvOtrgtnY5k6TAw4ilCnMIlzmyvN
         DA11jzT1YJBv481VyLzr+OzpeztsKS7Ea0H8UidzgQLlpxh3k93GLXbMQgQaFpA/XgZS
         +32FzIsujs343JbnIeLIQpqf8fT14744/6Sk3TIu1mhositoaF6xG65poP0JDWcY3AU0
         TywLqN9spTTy3xAjmJ5HC8yDkBVD2tIVrsKOuV2SALY735jKqEEZLYAro5I7j4CrVaKO
         gk5g==
X-Gm-Message-State: AFqh2kqplnaRW9YfVMVX+gn3MrVS3p5Io+gI3HCd0/ROA6gnj/a3zaf4
        UenqvPb/7vS/stIUZSU+TRl6gw==
X-Google-Smtp-Source: AMrXdXuSMvF3Uvh+kus4bVxXcEjE4VTHk+b9AcM5GoXVPdrG8EVcgcAP5nhsRh8Yj9OXxN3TsDjZvw==
X-Received: by 2002:a05:6402:241d:b0:46b:19ab:68d8 with SMTP id t29-20020a056402241d00b0046b19ab68d8mr1957308eda.40.1671636351804;
        Wed, 21 Dec 2022 07:25:51 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id n19-20020aa7c793000000b0045cf4f72b04sm7105428eds.94.2022.12.21.07.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 07:25:51 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 12/18] can: m_can: Add tx coalescing ethtool support
Date:   Wed, 21 Dec 2022 16:25:31 +0100
Message-Id: <20221221152537.751564-13-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221152537.751564-1-msp@baylibre.com>
References: <20221221152537.751564-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add get/set functions for ethtool coalescing. tx-frames-irq and
tx-usecs-irq can only be set/unset together. tx-frames-irq needs to be
less than TXE and TXB.

As rx and tx share the same timer, rx-usecs-irq and tx-usecs-irq can be
enabled/disabled individually but they need to have the same value if
enabled.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 38 ++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 4d6fc8ade4d6..fc5a269f4930 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1918,6 +1918,8 @@ static int m_can_get_coalesce(struct net_device *dev,
 
 	ec->rx_max_coalesced_frames_irq = cdev->rx_max_coalesced_frames_irq;
 	ec->rx_coalesce_usecs_irq = cdev->rx_coalesce_usecs_irq;
+	ec->tx_max_coalesced_frames_irq = cdev->tx_max_coalesced_frames_irq;
+	ec->tx_coalesce_usecs_irq = cdev->tx_coalesce_usecs_irq;
 
 	return 0;
 }
@@ -1944,16 +1946,50 @@ static int m_can_set_coalesce(struct net_device *dev,
 		netdev_err(dev, "rx-frames-irq and rx-usecs-irq can only be set together\n");
 		return -EINVAL;
 	}
+	if (ec->tx_max_coalesced_frames_irq > cdev->mcfg[MRAM_TXE].num) {
+		netdev_err(dev, "tx-frames-irq (%u) greater than the TX event FIFO (%u)\n",
+			   ec->tx_max_coalesced_frames_irq,
+			   cdev->mcfg[MRAM_TXE].num);
+		return -EINVAL;
+	}
+	if (ec->tx_max_coalesced_frames_irq > cdev->mcfg[MRAM_TXB].num) {
+		netdev_err(dev, "tx-frames-irq (%u) greater than the TX FIFO (%u)\n",
+			   ec->tx_max_coalesced_frames_irq,
+			   cdev->mcfg[MRAM_TXB].num);
+		return -EINVAL;
+	}
+	if ((ec->tx_max_coalesced_frames_irq == 0) != (ec->tx_coalesce_usecs_irq == 0)) {
+		netdev_err(dev, "tx-frames-irq and tx-usecs-irq can only be set together\n");
+		return -EINVAL;
+	}
+	if (ec->rx_coalesce_usecs_irq != 0 && ec->tx_coalesce_usecs_irq != 0 &&
+	    ec->rx_coalesce_usecs_irq != ec->tx_coalesce_usecs_irq) {
+		netdev_err(dev, "rx-usecs-irq (%u) needs to be equal to tx-usecs-irq (%u) if both are enabled\n",
+			   ec->rx_coalesce_usecs_irq,
+			   ec->tx_coalesce_usecs_irq);
+		return -EINVAL;
+	}
 
 	cdev->rx_max_coalesced_frames_irq = ec->rx_max_coalesced_frames_irq;
 	cdev->rx_coalesce_usecs_irq = ec->rx_coalesce_usecs_irq;
+	cdev->tx_max_coalesced_frames_irq = ec->tx_max_coalesced_frames_irq;
+	cdev->tx_coalesce_usecs_irq = ec->tx_coalesce_usecs_irq;
+
+	if (cdev->rx_coalesce_usecs_irq)
+		cdev->irq_timer_wait =
+			ns_to_ktime(cdev->rx_coalesce_usecs_irq * NSEC_PER_USEC);
+	else
+		cdev->irq_timer_wait =
+			ns_to_ktime(cdev->tx_coalesce_usecs_irq * NSEC_PER_USEC);
 
 	return 0;
 }
 
 static const struct ethtool_ops m_can_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS_IRQ |
-		ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ,
+		ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ |
+		ETHTOOL_COALESCE_TX_USECS_IRQ |
+		ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ,
 	.get_ts_info = ethtool_op_get_ts_info,
 	.get_coalesce = m_can_get_coalesce,
 	.set_coalesce = m_can_set_coalesce,
-- 
2.38.1

