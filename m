Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1339F62CB94
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238815AbiKPUyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbiKPUxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:53:45 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53B1E01
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:26 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id s12so28433442edd.5
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ajsZbX3+twaGsWlZnthQH+DJqMTcB864bD+ktj1XJi8=;
        b=cGyV6iSyzBue0i5l97tQs1F/+bVMjgHav1MAY5Sp3ebIBKAF7rtEZUC/JmhiwCz45R
         rRQmwP4+vYFx1HAHkCDFG483CrsfEqHCo+WCCTFlJMKBWpByz9CHRlXEaEQXB15nQPg4
         dVsPlUsn/h1qq8jjY1MBSrqbPNamW8aseozcmaPGAq5PLnSUxm1OYs1RIplM/W+npToS
         w+3jyD1we20/rAh/289ilWSbioDeGmbslRMCVMzHBoPyp6ZqDInmObMZhFFeJfhVg5b/
         iuEhPle4TOpHkI0KN4kdg09gqWy6Y6GZf3f7H+fUL6eCG+EP6tv6oKJnBQ1vawL2Zg8+
         FgpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ajsZbX3+twaGsWlZnthQH+DJqMTcB864bD+ktj1XJi8=;
        b=vOgEEvBkuo0wnu26ZEeJ1euut8ClLFIT7+QfsdFajW6/yDwTQjYsQNe0On5Udbwj7H
         57KGnaglUpnVQJ9NLudhSHjc/w22NiiTPOMygaDVskF1BQxwnPfqF8UyR13LsOy1a/Kz
         J6dZ8DExgdgBxwIr73BpLX+nZrrcc8fKOgYcF+uKWgQAnDdklhvkOsMJ00xAiDWH0w9H
         Q+LTwl01iet6gS0xlzzHli8TcFgTZDj9utNEy90JrhSeP4TPuv3MAHd66dC+e1sTYXYh
         dXmZUT65hLaegioXkdp/E5fHmoRP1ORnKhpnCZHXg/HV0S3Tam5BeMC77dSOGwwF3Lqj
         kQ3g==
X-Gm-Message-State: ANoB5plbd/Pk+7C6IenjDuxTbFmwlF3WFc1zYgVb6rV4CWbevh1XNisW
        wLIFBbs9c3lidVPGPwbMBowAgA==
X-Google-Smtp-Source: AA0mqf6Z3LMs4psPQJjOVF9nPXX0RertMMFOq9jkbzOnbJJVdAXVu48YNiJv8YDaS7aZAMMLs4tX4w==
X-Received: by 2002:aa7:d6cb:0:b0:467:e2dd:b593 with SMTP id x11-20020aa7d6cb000000b00467e2ddb593mr12985138edr.378.1668632005445;
        Wed, 16 Nov 2022 12:53:25 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4090:a244:804b:353b:565:addf:3aa7])
        by smtp.gmail.com with ESMTPSA id kv17-20020a17090778d100b007aece68483csm6782828ejc.193.2022.11.16.12.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:53:24 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 02/15] can: m_can: Wakeup net queue once tx was issued
Date:   Wed, 16 Nov 2022 21:52:55 +0100
Message-Id: <20221116205308.2996556-3-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116205308.2996556-1-msp@baylibre.com>
References: <20221116205308.2996556-1-msp@baylibre.com>
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

Currently the driver waits to wakeup the queue until the interrupt for
the transmit event is received and acknowledged. If we want to use the
hardware FIFO, this is too late.

Instead release the queue as soon as the transmit was transferred into
the hardware FIFO. We are then ready for the next transmit to be
transferred.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 2c01e3f7b23f..4adf03111782 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1097,10 +1097,9 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 			/* New TX FIFO Element arrived */
 			if (m_can_echo_tx_event(dev) != 0)
 				goto out_fail;
-
-			if (netif_queue_stopped(dev) &&
-			    !m_can_tx_fifo_full(cdev))
+			if (!cdev->tx_skb && netif_queue_stopped(dev))
 				netif_wake_queue(dev);
+
 		}
 	}
 
@@ -1705,6 +1704,8 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		if (m_can_tx_fifo_full(cdev) ||
 		    m_can_next_echo_skb_occupied(dev, putidx))
 			netif_stop_queue(dev);
+		else if (cdev->is_peripheral && !cdev->tx_skb && netif_queue_stopped(dev))
+			netif_wake_queue(dev);
 	}
 
 	return NETDEV_TX_OK;
-- 
2.38.1

