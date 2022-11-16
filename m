Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A0062CB9B
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbiKPUyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237236AbiKPUxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:53:52 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD07626A
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:31 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id gv23so14439967ejb.3
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1NW4yffam7J6Z66UeY98X/Lxzuu+uqNj1++GX3J7z0=;
        b=Fn+pjOi7VxZlwBiOMmabPiR+6IHaFVnPkFKbMENKhdrwfdApvpUQBK2DrzSm8UZ3l+
         LBgLnkruBLVK5H9Tz3LtB/DxxziqVAKGYdy+2KAVIJ3tPxXMTLxirF7JOIUcPu3bk1s5
         Ah2GESoKw9t04qJclb9ZKouemoIya66kpstWZwAR76Ni2A6BXsyOjIau71qtKm2twGCH
         OZewz/IsWr1KR9xbm3owiIWYvu9j4qJ6AWvx6bzdTD0OK/RnbkqCeFRwpg88Birnm2FI
         IBOaNk32rlVnzjgJDp+VA4edjSpYwHv/Iw52HlvRGfnLV14A4FTa8v7sbR1UtkAAbsVg
         JDqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1NW4yffam7J6Z66UeY98X/Lxzuu+uqNj1++GX3J7z0=;
        b=3BRgeIUl+EvNmumOlpWvVcfQsCUU1Ty+lckquBPgeZN+7kTY/g3NI4UJUn0hsZO/yO
         fNnHntDWtALNOQqHZyq4e47nX3Pl7flCSzPFrf6gEwXWitSBQtQ8lsT1HHLph859bJlH
         0zuvGVBpixOAJmRpjB96auYEeggqRvQrmn1tWWCaIX/0Px2T6Om7yOXBhKwIq+1UeeMy
         56jPcAf7ZYIZcA/Kst6x7Xjs5QCwsZo7RjY6zugKSSraJcXng8buhgebV+/fQpXdWJIN
         fj+vSXIx2NhFR1qc6F0rq8r7r1DUgqeRky1357cxDAiG0XoSR+NItKHIsaKbDbLTBkrx
         Er0Q==
X-Gm-Message-State: ANoB5pmED6myCBu6Ue8rBrctrfLS135Fbs3B4TF/VePypZtFV4z1UYM9
        LJthmeG5ApE5ltU9vRCoweV06w==
X-Google-Smtp-Source: AA0mqf5INbSS61YudtGvV7KRJAO/74+RHCAHzS3vYu3sIf8dRl8BpsQJ4HaUspFyOyKl/Ph09ENVdw==
X-Received: by 2002:a17:906:489a:b0:7b2:73d0:4b9c with SMTP id v26-20020a170906489a00b007b273d04b9cmr6681647ejq.746.1668632010464;
        Wed, 16 Nov 2022 12:53:30 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4090:a244:804b:353b:565:addf:3aa7])
        by smtp.gmail.com with ESMTPSA id kv17-20020a17090778d100b007aece68483csm6782828ejc.193.2022.11.16.12.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:53:30 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 08/15] can: m_can: Count TXE FIFO getidx in the driver
Date:   Wed, 16 Nov 2022 21:53:01 +0100
Message-Id: <20221116205308.2996556-9-msp@baylibre.com>
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

The getindex simply increases by one for every iteration. There is no
need to get the current getidx every time from a register. Instead we
can just count and wrap if necessary.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 1d15beaea920..27095a7254dd 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1021,15 +1021,13 @@ static int m_can_echo_tx_event(struct net_device *dev)
 
 	/* Get Tx Event fifo element count */
 	txe_count = FIELD_GET(TXEFS_EFFL_MASK, m_can_txefs);
+	fgi = FIELD_GET(TXEFS_EFGI_MASK, m_can_txefs);
 
 	/* Get and process all sent elements */
 	for (i = 0; i < txe_count; i++) {
 		u32 txe, timestamp = 0;
 		int err;
 
-		/* retrieve get index */
-		fgi = FIELD_GET(TXEFS_EFGI_MASK, m_can_read(cdev, M_CAN_TXEFS));
-
 		/* get message marker, timestamp */
 		err = m_can_txe_fifo_read(cdev, fgi, 4, &txe);
 		if (err) {
@@ -1043,6 +1041,7 @@ static int m_can_echo_tx_event(struct net_device *dev)
 		/* ack txe element */
 		m_can_write(cdev, M_CAN_TXEFA, FIELD_PREP(TXEFA_EFAI_MASK,
 							  fgi));
+		fgi = (++fgi >= cdev->mcfg[MRAM_TXE].num ? 0 : fgi);
 		--cdev->tx_fifo_in_flight;
 
 		/* update stats */
-- 
2.38.1

