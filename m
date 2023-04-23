Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D32C6EC15C
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 19:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjDWRZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 13:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjDWRZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 13:25:47 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF46E6C
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 10:25:46 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f19c473b9eso21297895e9.0
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 10:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google; t=1682270745; x=1684862745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MbxDPqhzMCS7xX3Keeglii9B+3fU/m4LAIoQKCOvlGw=;
        b=kFx5aT3ZHShtKXQkjX5bjO1mltO6ghMp7YmjXd5ZNvN76bvrP2gL4pOSBoqLeReB8G
         zeWLvoIy3pGRjaBg8ippvtE2ncmlfWQ4TADwU81Z+/hoRM/Bogq1AjHFchGRzH+I/e4P
         WZ8/UXVNRta+9EMAFm/75ZgVx4u7w4Zq4Gm40=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682270745; x=1684862745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MbxDPqhzMCS7xX3Keeglii9B+3fU/m4LAIoQKCOvlGw=;
        b=aX9OQ6guuWaDNQtYCjtLTF6r6IR70zIgyszC1HLp2iKHXNSnhW+LIGqn1p97HofAoa
         1pMKawHvoXGDOFWCbRPpHdFLZOfGgMP0JGCb9BZX3hpu0dnd6gJvD+Q4mXadhoyXUct9
         L7rSrdt3JUwTgzeFCn9ehDQ8l/Wb4xcgCuAe8n/T+GtXfd2tZjUJEqCABfHGd+stwAhG
         mBV6Lqr3caAZAum/sWvAl6eMLmptK1DBgjNNvPccgBKRNz+PCSU5uWEh+0cBJii7hvK/
         tA5C7+L/3UP4HRznBf+yCFcnYADVfan7AiR+CHXsgX0JirJMrXYrMAYz2+OLbd6e+BtI
         EIYQ==
X-Gm-Message-State: AAQBX9cwOP1I3TgxPNripWoVnaHk3+K1UBFekCc9rIbb7Li/jBIXIYLw
        DT7N8yeyBgGYbrlfxUb4CTc8Vw==
X-Google-Smtp-Source: AKy350ZHuZgYLS/Hh8NQ9a899+cfyiN9BaStXdrvXMXXQ5mfLaLgd3HI+XE8ZsuF4x4OP0KwGf8x8A==
X-Received: by 2002:a1c:e904:0:b0:3ed:3268:5f35 with SMTP id q4-20020a1ce904000000b003ed32685f35mr6156037wmc.18.1682270745255;
        Sun, 23 Apr 2023 10:25:45 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.. ([37.159.119.249])
        by smtp.gmail.com with ESMTPSA id j32-20020a05600c1c2000b003f173987ec2sm13511653wms.22.2023.04.23.10.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 10:25:44 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 4/4] can: bxcan: add support for single peripheral configuration
Date:   Sun, 23 Apr 2023 19:25:28 +0200
Message-Id: <20230423172528.1398158-5-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20230423172528.1398158-1-dario.binacchi@amarulasolutions.com>
References: <20230423172528.1398158-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for bxCAN controller in single peripheral configuration:
- primary bxCAN
- dedicated Memory Access Controller unit
- 512-byte SRAM memory
- 14 fiter banks

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

 drivers/net/can/bxcan.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/bxcan.c b/drivers/net/can/bxcan.c
index e26ccd41e3cb..9bcbbb85da6e 100644
--- a/drivers/net/can/bxcan.c
+++ b/drivers/net/can/bxcan.c
@@ -155,6 +155,7 @@ struct bxcan_regs {
 	u32 reserved0[88];		/* 0x20 */
 	struct bxcan_mb tx_mb[BXCAN_TX_MB_NUM];	/* 0x180 - tx mailbox */
 	struct bxcan_mb rx_mb[BXCAN_RX_MB_NUM];	/* 0x1b0 - rx mailbox */
+	u32 reserved1[12];		/* 0x1d0 */
 };
 
 struct bxcan_priv {
@@ -922,6 +923,12 @@ static int bxcan_get_berr_counter(const struct net_device *ndev,
 	return 0;
 }
 
+static const struct regmap_config bxcan_gcan_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+};
+
 static int bxcan_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -942,11 +949,18 @@ static int bxcan_probe(struct platform_device *pdev)
 
 	gcan = syscon_regmap_lookup_by_phandle(np, "st,gcan");
 	if (IS_ERR(gcan)) {
-		dev_err(dev, "failed to get shared memory base address\n");
-		return PTR_ERR(gcan);
+		primary = true;
+		gcan = devm_regmap_init_mmio(dev,
+					     regs + sizeof(struct bxcan_regs),
+					     &bxcan_gcan_regmap_config);
+		if (IS_ERR(gcan)) {
+			dev_err(dev, "failed to get filter base address\n");
+			return PTR_ERR(gcan);
+		}
+	} else {
+		primary = of_property_read_bool(np, "st,can-primary");
 	}
 
-	primary = of_property_read_bool(np, "st,can-primary");
 	clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(dev, "failed to get clock\n");
-- 
2.32.0

