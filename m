Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB376442A0
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbiLFL5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbiLFL5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:57:44 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15C1958F
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 03:57:40 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id gh17so5589258ejb.6
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 03:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jg8CR20tG79djQpdFo8U0Y6E9PQi/JvNHqoQZx2uO1Q=;
        b=zELG2lnh50u90Jp2YLLVqH4yZCkDv7zMa535EWcQPw1JEmENJog2b3Vqaw170TwLzo
         Mz0Z8SmeWTO+dx1Wuqlpp0fYpWLBXeqtfqlcCQZ70JmisGnxHt9gDi7T3KbSDRq/ytP9
         hOJ1oP74mxN+w1SRByUuzSSnFrUwbbjXn5/yUDUm5d+yU+2mw2E8sTLFVTMtLfuaVQCE
         w9JaR1YlrXSrq2LmYnEkm41ANlQdDqwshQbgkP3nVdbMCwXWNo8ur1m++gxNIw1Je89n
         Fj1r+UbVNA+7252hQFEO7reV7YGsMfRiDo7pj5nAZKquSRfB/BQZxVhRqEzcqJfFlJaT
         GPzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jg8CR20tG79djQpdFo8U0Y6E9PQi/JvNHqoQZx2uO1Q=;
        b=FbWhxIrs6/X1trxyGW3B9c7GbTscJTNueRJ4EHB9OcJAxQVB4/VXEpMtMOD7TZ8gh2
         qAHhC/+yq9ozZXmiensL9Ruv9I2uRmxfBUQ8g3pLzSpw8P2dX8tsnupQPrHf3iqq2QOY
         iS/AUDI4K3XId6suJkLIBnc0IB5+5gLLGgHCOmEmWl4MZhIMvSBMM4f2c6/0NaoBaNNX
         BM2o3Qt/a036gOQWVqXvZbv/jQacQhwJ7hknkP0C4D06L2upnWiwojXMU3tJx1hf3t2Z
         NiiovY8TIlo2H94Yd+kuqckFYAxgHrc15uurCwp2b4UbQbzkW0jrWRcJYE3x6LIagQub
         lfKA==
X-Gm-Message-State: ANoB5pk7LeJQm02npJMUqfcVtp9HvxGOkifALMAODUgL5F5yL4Wna4if
        hjK2vcgUWREDJSnyipEIBvXLaw==
X-Google-Smtp-Source: AA0mqf6XeLvgIxwGH4a6RLaphDtEo1NWHsQelYYFWjvNWuKUdCDgRQQAeNLelwlOJQCFkYYAsDhtig==
X-Received: by 2002:a17:906:444b:b0:7ad:dd43:5d53 with SMTP id i11-20020a170906444b00b007addd435d53mr54435818ejp.376.1670327859238;
        Tue, 06 Dec 2022 03:57:39 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id ky20-20020a170907779400b007c0ac4e6b6esm6472076ejc.143.2022.12.06.03.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 03:57:38 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v2 04/11] can: m_can: Count TXE FIFO getidx in the driver
Date:   Tue,  6 Dec 2022 12:57:21 +0100
Message-Id: <20221206115728.1056014-5-msp@baylibre.com>
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

The getindex simply increases by one for every iteration. There is no
need to get the current getidx every time from a register. Instead we
can just count and wrap if necessary.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 45c718413abf..a133f15fb90a 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1020,15 +1020,13 @@ static int m_can_echo_tx_event(struct net_device *dev)
 
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
@@ -1042,6 +1040,7 @@ static int m_can_echo_tx_event(struct net_device *dev)
 		/* ack txe element */
 		m_can_write(cdev, M_CAN_TXEFA, FIELD_PREP(TXEFA_EFAI_MASK,
 							  fgi));
+		fgi = (++fgi >= cdev->mcfg[MRAM_TXE].num ? 0 : fgi);
 
 		/* update stats */
 		m_can_tx_update_stats(cdev, msg_mark, timestamp);
-- 
2.38.1

