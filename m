Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2B36442B2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbiLFL6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235166AbiLFL5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:57:46 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DCE65B4
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 03:57:43 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id n20so5724963ejh.0
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 03:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=83PP3edth58TA8zB8E6Zh9GJd+Ky/ClAFIA3P8EFVEY=;
        b=ZmTzsvSEnQugnHmiOGpzBOFBYadRAHO8P94h8wRpc1ocO2mItjUJ8G2A2g1bg+aTxK
         qq/xGf0lhP9cuieUkkAAwVo1YGNexSDz4Y7524SetLJMGRPR1vqCD9LToU/YragnTqwa
         +GH5ZUrt2jJne1PAd0Fkh4L2kx0h4QnHM2ZrZm2OLzt++l2OaOCJuUW8L11kUwA4ZG9e
         fZoJl+oM0J7F+8P6/EMwvwIv6X5Dwo1HiRybxLpPB9V/LdijGr7UwhjZLgsY+VKngPWH
         WKWI72MG8U6NadKKD2SMTaZDziV4kUvYNJKZFIRxopvc4W9XvQDQB6YfamHcH+QVPuIj
         B3Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=83PP3edth58TA8zB8E6Zh9GJd+Ky/ClAFIA3P8EFVEY=;
        b=6Cit5bZy0p0T+rBR22OZFh+xaBfjtpYTrcXolecWjNy9GJZJBdlL9aK9uAfJ1it9V7
         +a83xQyTG0o9GkZXg3+HUVbLN2cm59WfBqqsZYIazPxFb6HTzpK+q/K4YXLkHbtOwwm9
         asFFgXv0ShNeJR4ej5R4hps2t2YSE1YnGSNwE+ZdNxBc+PVSYNpvfUCPtQXiLB0JjORW
         qvseByaqJgk50u2XrGLtDXwKzdwg1F+wWUXxPPIv5kT61DO28vvARbKa+TGGaYf1dROs
         MbYPW0NHkOxTRbM7LltRL8TtRlD9mb9sXn2+JQQkD8xvyNEQ1TM4aBt2LtHOhO2c3pSx
         //SQ==
X-Gm-Message-State: ANoB5pkzfKkUKjQVtFmazwPnuz4aly6TQExTiXUsS9D5RhWrDU5SlYl5
        LcqfAlbLFMOxn+AsLmZ1/VhR6w==
X-Google-Smtp-Source: AA0mqf56KMKwHGEPqLdvA1xeKZO3WSzbx+Hrig6h2oxmyp3nkUwQmFWl3nop/IYAJYnzUEu2T7QIew==
X-Received: by 2002:a17:906:2851:b0:78d:88c7:c1bf with SMTP id s17-20020a170906285100b0078d88c7c1bfmr57231518ejc.299.1670327861708;
        Tue, 06 Dec 2022 03:57:41 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id ky20-20020a170907779400b007c0ac4e6b6esm6472076ejc.143.2022.12.06.03.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 03:57:41 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v2 07/11] can: m_can: Batch acknowledge rx fifo
Date:   Tue,  6 Dec 2022 12:57:24 +0100
Message-Id: <20221206115728.1056014-8-msp@baylibre.com>
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

Instead of acknowledging every item of the fifo, only acknowledge the
last item read. This behavior is documented in the datasheet. The new
getindex will be the acknowledged item + 1.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 5572a6b3b94c..56f07f2023dd 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -529,9 +529,6 @@ static int m_can_read_fifo(struct net_device *dev, u32 fgi)
 	}
 	stats->rx_packets++;
 
-	/* acknowledge rx fifo 0 */
-	m_can_write(cdev, M_CAN_RXF0A, fgi);
-
 	timestamp = FIELD_GET(RX_BUF_RXTS_MASK, fifo_header.dlc) << 16;
 
 	m_can_receive_skb(cdev, skb, timestamp);
@@ -552,8 +549,9 @@ static int m_can_do_rx_poll(struct net_device *dev, int quota)
 	u32 rxfs;
 	u32 rx_count;
 	u32 fgi;
+	int ack_fgi = -1;
 	int i;
-	int err;
+	int err = 0;
 
 	rxfs = m_can_read(cdev, M_CAN_RXF0S);
 	if (!(rxfs & RXFS_FFL_MASK)) {
@@ -567,13 +565,20 @@ static int m_can_do_rx_poll(struct net_device *dev, int quota)
 	for (i = 0; i < rx_count && quota > 0; ++i) {
 		err = m_can_read_fifo(dev, fgi);
 		if (err)
-			return err;
+			break;
 
 		quota--;
 		pkts++;
+		ack_fgi = fgi;
 		fgi = (++fgi >= cdev->mcfg[MRAM_RXF0].num ? 0 : fgi);
 	}
 
+	if (ack_fgi != -1)
+		m_can_write(cdev, M_CAN_RXF0A, ack_fgi);
+
+	if (err)
+		return err;
+
 	return pkts;
 }
 
-- 
2.38.1

