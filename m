Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81CB67BB1D
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbjAYTvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235675AbjAYTvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:51:33 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF6B59E4F
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:13 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ss4so50473918ejb.11
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DaeIa0Og32Nc18yUwKazkfXKROUGY5JQszAI0CKb6Vs=;
        b=lS9gGYHuiuM/w80eo3DAsw58dwrFA1eksEYp23X8XUfPEeV/wEuepNa0Ug7REjGdIX
         6ghKhgpFh4fC3Gebtv4AvJf/eKCY0CGjBtV4WGKq5Kr5/zCs4CkjhV02ptrdUqYu2+5W
         4gS3Yz/H+bykdw2oJyyrUUS2gThandS/vGkFUu2A+gwPdzC7zqokFHbyimnRT+8PJEt6
         KjkeFwCHoCZkKktBfk4Uje2HNH+M9Tz9gfULOSMQeOZVf+NFSzOkCQTI7/yggl+v0tyA
         L3JNNDcOZkyCoGWI3ULBIPxowk8M0tb6VYeLbgdFcVCxfSgQer2tE+MFLs1zZLHwYojk
         LBzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DaeIa0Og32Nc18yUwKazkfXKROUGY5JQszAI0CKb6Vs=;
        b=3nhS+VoUD8GEqr9jTAGw8dSLeg8DfwodugAE9u4Bz9nqEbpWWx3+nsxlJ2BKJz7OME
         W23ccRs0U/o6aPUFGYX5owQPWif0MJaqVk0ZD0PxsDzJSc+8XrbtNxIyOq8Xa7dq1QDD
         QaWa7JFLlr0g+x41LD7hcPSQsyJDV1B8zrZ8R096gkj+MoSSSRoDHfpJKKHWcFGH1BRB
         OLuQsiiudR6boJoCbsaGr0fNu5r6ewKHbtTcYf7wB/S2djLxzj0g0gzofiLxl5N8vTWb
         YSm5t+SvnKlJKy3cmLkcGouNGfGwN9nScawr4UnM0KV3g7nQHgKaL/SqebDByxZ8bRC0
         uD6g==
X-Gm-Message-State: AFqh2kr/NDts/D4b4UnO18yrQCBRhdqRn3sABTP6jM/UxJ6fIvSXLqcI
        VXHQyH8ykRuz4KprpRyU8D4ScQ==
X-Google-Smtp-Source: AMrXdXtGwuyABY/MRyoClnX73tx3lkrqblswfHV3HaUebSkG/Zv7GCnSLBRO2+uBiubSlEYC28mQUA==
X-Received: by 2002:a17:906:b081:b0:877:7789:765a with SMTP id x1-20020a170906b08100b008777789765amr27140345ejy.16.1674676273265;
        Wed, 25 Jan 2023 11:51:13 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a247:815f:ef74:e427:628a:752c])
        by smtp.gmail.com with ESMTPSA id s15-20020a170906454f00b00872c0bccab2sm2778830ejq.35.2023.01.25.11.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 11:51:12 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v2 10/18] can: m_can: Implement transmit coalescing
Date:   Wed, 25 Jan 2023 20:50:51 +0100
Message-Id: <20230125195059.630377-11-msp@baylibre.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230125195059.630377-1-msp@baylibre.com>
References: <20230125195059.630377-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the coalescing implementation for transmits.

In normal mode the chip raises an interrupt for every finished transmit.
This implementation switches to coalescing mode as soon as an interrupt
handled a transmit. For coalescing the watermark level interrupt is used
to interrupt exactly after x frames were sent. It switches back into
normal mode once there was an interrupt with no finished transmit and
the timer being inactive.

The timer is shared with receive coalescing. The time for receive and
transmit coalescing timers have to be the same for that to work. The
benefit is to have only a single running timer.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 33 ++++++++++++++++++++-------------
 drivers/net/can/m_can/m_can.h |  3 +++
 2 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index a9d028ebc1f4..31a5e551ebd9 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -255,6 +255,7 @@ enum m_can_reg {
 #define TXESC_TBDS_64B		0x7
 
 /* Tx Event FIFO Configuration (TXEFC) */
+#define TXEFC_EFWM_MASK		GENMASK(29, 24)
 #define TXEFC_EFS_MASK		GENMASK(21, 16)
 
 /* Tx Event FIFO Status (TXEFS) */
@@ -1080,7 +1081,7 @@ static void m_can_interrupt_enable(struct m_can_classdev *cdev, u32 interrupts)
 
 static void m_can_coalescing_disable(struct m_can_classdev *cdev)
 {
-	u32 new_interrupts = cdev->active_interrupts | IR_RF0N;
+	u32 new_interrupts = cdev->active_interrupts | IR_RF0N | IR_TEFN;
 
 	hrtimer_cancel(&cdev->irq_timer);
 	m_can_interrupt_enable(cdev, new_interrupts);
@@ -1089,21 +1090,26 @@ static void m_can_coalescing_disable(struct m_can_classdev *cdev)
 static void m_can_coalescing_update(struct m_can_classdev *cdev, u32 ir)
 {
 	u32 new_interrupts = cdev->active_interrupts;
-	bool enable_timer = false;
+	bool enable_rx_timer = false;
+	bool enable_tx_timer = false;
 
 	if (cdev->rx_coalesce_usecs_irq > 0 && (ir & (IR_RF0N | IR_RF0W))) {
-		enable_timer = true;
+		enable_rx_timer = true;
 		new_interrupts &= ~IR_RF0N;
-	} else if (!hrtimer_active(&cdev->irq_timer)) {
-		new_interrupts |= IR_RF0N;
 	}
+	if (cdev->tx_coalesce_usecs_irq > 0 && (ir & (IR_TEFN | IR_TEFW))) {
+		enable_tx_timer = true;
+		new_interrupts &= ~IR_TEFN;
+	}
+	if (!enable_rx_timer && !hrtimer_active(&cdev->irq_timer))
+		new_interrupts |= IR_RF0N;
+	if (!enable_tx_timer && !hrtimer_active(&cdev->irq_timer))
+		new_interrupts |= IR_TEFN;
 
 	m_can_interrupt_enable(cdev, new_interrupts);
-	if (enable_timer) {
-		hrtimer_start(&cdev->irq_timer,
-			      ns_to_ktime(cdev->rx_coalesce_usecs_irq * NSEC_PER_USEC),
+	if (enable_rx_timer | enable_tx_timer)
+		hrtimer_start(&cdev->irq_timer, cdev->irq_timer_wait,
 			      HRTIMER_MODE_REL);
-	}
 }
 
 static irqreturn_t m_can_isr(int irq, void *dev_id)
@@ -1158,7 +1164,7 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 			netif_wake_queue(dev);
 		}
 	} else  {
-		if (ir & IR_TEFN) {
+		if (ir & (IR_TEFN | IR_TEFW)) {
 			/* New TX FIFO Element arrived */
 			if (m_can_echo_tx_event(dev) != 0)
 				goto out_fail;
@@ -1326,9 +1332,8 @@ static int m_can_chip_config(struct net_device *dev)
 	}
 
 	/* Disable unused interrupts */
-	interrupts &= ~(IR_ARA | IR_ELO | IR_DRX | IR_TEFF | IR_TEFW | IR_TFE |
-			IR_TCF | IR_HPM | IR_RF1F | IR_RF1W | IR_RF1N |
-			IR_RF0F);
+	interrupts &= ~(IR_ARA | IR_ELO | IR_DRX | IR_TEFF | IR_TFE | IR_TCF |
+			IR_HPM | IR_RF1F | IR_RF1W | IR_RF1N | IR_RF0F);
 
 	m_can_config_endisable(cdev, true);
 
@@ -1365,6 +1370,8 @@ static int m_can_chip_config(struct net_device *dev)
 	} else {
 		/* Full TX Event FIFO is used */
 		m_can_write(cdev, M_CAN_TXEFC,
+			    FIELD_PREP(TXEFC_EFWM_MASK,
+				       cdev->tx_max_coalesced_frames_irq) |
 			    FIELD_PREP(TXEFC_EFS_MASK,
 				       cdev->mcfg[MRAM_TXE].num) |
 			    cdev->mcfg[MRAM_TXE].off);
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 35aa3c70b0a3..0721faae7886 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -85,6 +85,7 @@ struct m_can_classdev {
 	struct phy *transceiver;
 
 	struct hrtimer irq_timer;
+	ktime_t irq_timer_wait;
 
 	struct m_can_ops *ops;
 
@@ -98,6 +99,8 @@ struct m_can_classdev {
 	u32 active_interrupts;
 	u32 rx_max_coalesced_frames_irq;
 	u32 rx_coalesce_usecs_irq;
+	u32 tx_max_coalesced_frames_irq;
+	u32 tx_coalesce_usecs_irq;
 
 	struct mram_cfg mcfg[MRAM_CFG_NUM];
 };
-- 
2.39.0

