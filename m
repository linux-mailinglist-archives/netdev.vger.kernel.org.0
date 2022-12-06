Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA596442A4
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbiLFL5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbiLFL5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:57:39 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234696472
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 03:57:38 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id l11so19949781edb.4
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 03:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qNZbR/OCEKJKCF9Pyi6+mM/mCQOvMeAEcjhJky1x5bk=;
        b=NWXWNYnvN1jBg8fh4s6alBCUPRmNaziz7tTuEZ+3lKk9a1vsxZGan2QgpRPFxAXAP7
         YsQ4Du++m8bcwKtpsi9WofamV42a9mEu1S/Fnqb6LfL6+40eaW4+0S7fTIkyY2HmDUiK
         lzWzBTLkGOwR9Sj1OClt/3jtRXnN4xSNEVMwxNfzsLQ6eQg38h/H1KPOUXF23luITTol
         vtY3VwKBxefY0dbmYHZvWLUFM37oFrl4EWpXOBjH7NRt2d8CfnEuR5gn0tlVq3YmhCyf
         WLiJ40Idltmo/IBDV+1sqF/ZJnty5NCiWqICdl+orbB0sLqxFoL70R47xDySUoYzufGE
         RBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qNZbR/OCEKJKCF9Pyi6+mM/mCQOvMeAEcjhJky1x5bk=;
        b=gDC1EJZG1IPcnDHY6oCUJNaIW1kIetDH3ZjXg2Aok9e9i8aBtU0yG6k2px9bs+yYI8
         GpVTgM0amANmonoTS3Sq+3cwRpE/DB2GY5YAnJ3V9+X08SDrHtERfa6h6D2McIhHLzmi
         UsXjxq7KqUz3ZqXa8QU4Snrg9JA78qeSi5Ijwj1GS7EmWQeTIwvb5ooi+USuF6hkm+MU
         x26lWlgdT2VNJXC2mvMBsNP+Cg7k+MmHLH+3afhc3WeaXQVItG2nJC1g6yFfVf6wSexA
         D21WlOijaha6aLiP0ixYOADEdcuHFmJgLmEaAEdqnlFQjZhI95FIdCtsl1GANHnefFRz
         RlGQ==
X-Gm-Message-State: ANoB5plPJwAmx0c/hm2kfKfX6eSIMjNgbRu/iCt2isNvuKpU8P0XpEjY
        kxce0ld7+7O4dw3SQ2if+oPWNAnMq5osc0r/
X-Google-Smtp-Source: AA0mqf489vUcETfBpNEXYBWARn81KzeGgaVU6pd9QSVl665/cF68KK+1pB0YvEGuCclDi/LRhIw2og==
X-Received: by 2002:a05:6402:3785:b0:461:e598:e0bb with SMTP id et5-20020a056402378500b00461e598e0bbmr14889196edb.21.1670327856563;
        Tue, 06 Dec 2022 03:57:36 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id ky20-20020a170907779400b007c0ac4e6b6esm6472076ejc.143.2022.12.06.03.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 03:57:36 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v2 01/11] can: m_can: Eliminate double read of TXFQS in tx_handler
Date:   Tue,  6 Dec 2022 12:57:18 +0100
Message-Id: <20221206115728.1056014-2-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206115728.1056014-1-msp@baylibre.com>
References: <20221206115728.1056014-1-msp@baylibre.com>
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

The TXFQS register is read first to check if the fifo is full and then
immediately again to get the putidx. This is unnecessary and adds
significant overhead if read requests are done over a slow bus, for
example SPI with tcan4x5x.

Add a variable to store the value of the register. Split the
m_can_tx_fifo_full function into two to avoid the hidden m_can_read call
if not needed.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index e5575d2755e4..0cc0abde9b1d 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -368,9 +368,14 @@ m_can_txe_fifo_read(struct m_can_classdev *cdev, u32 fgi, u32 offset, u32 *val)
 	return cdev->ops->read_fifo(cdev, addr_offset, val, 1);
 }
 
+static inline bool _m_can_tx_fifo_full(u32 txfqs)
+{
+	return !!(txfqs & TXFQS_TFQF);
+}
+
 static inline bool m_can_tx_fifo_full(struct m_can_classdev *cdev)
 {
-	return !!(m_can_read(cdev, M_CAN_TXFQS) & TXFQS_TFQF);
+	return _m_can_tx_fifo_full(m_can_read(cdev, M_CAN_TXFQS));
 }
 
 static void m_can_config_endisable(struct m_can_classdev *cdev, bool enable)
@@ -1585,6 +1590,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 	struct sk_buff *skb = cdev->tx_skb;
 	struct id_and_dlc fifo_header;
 	u32 cccr, fdflags;
+	u32 txfqs;
 	int err;
 	int putidx;
 
@@ -1641,8 +1647,10 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 	} else {
 		/* Transmit routine for version >= v3.1.x */
 
+		txfqs = m_can_read(cdev, M_CAN_TXFQS);
+
 		/* Check if FIFO full */
-		if (m_can_tx_fifo_full(cdev)) {
+		if (_m_can_tx_fifo_full(txfqs)) {
 			/* This shouldn't happen */
 			netif_stop_queue(dev);
 			netdev_warn(dev,
@@ -1658,8 +1666,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		}
 
 		/* get put index for frame */
-		putidx = FIELD_GET(TXFQS_TFQPI_MASK,
-				   m_can_read(cdev, M_CAN_TXFQS));
+		putidx = FIELD_GET(TXFQS_TFQPI_MASK, txfqs);
 
 		/* Construct DLC Field, with CAN-FD configuration.
 		 * Use the put index of the fifo as the message marker,
-- 
2.38.1

