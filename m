Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F281353E84E
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239224AbiFFNqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 09:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239184AbiFFNqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 09:46:20 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C3D2B1956
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 06:46:19 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u12so29081569eja.8
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 06:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uHwQH74Q7N25Q2zdI6IdVXzOKcdi3juWfll5ugT6Tp8=;
        b=HYqm1kQIFYFjJDQgAJt9wjqHr/Y/X21kXW7swzLHk/yT4N57VjWHoyBsEzw0XckAYq
         qCqyJ3ooMy+n3Xw+Ldk31A1qJZmqEOBs7J7IKp2mOCuSjGchK+xPq//cpeKvmAhkmrH5
         m0dVaugF7kY3M/AI+WOLm5+8OL8xEeDqaWV8s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uHwQH74Q7N25Q2zdI6IdVXzOKcdi3juWfll5ugT6Tp8=;
        b=27gUbzTn8vzPzdAbPIuvLn6Nl5SAk824VecKHLAGS37RlUVePZX5iJ2x/nTBA01EuV
         AGo0pWkpCSmdy9pWA54hkKC7BYz+AuzH5DHRsG09VjEUOVeKeS9Qt1MFwe4D7zeSaSwV
         ay+AlTbegWy16+a3m9C/9CuC23FVzK9ClmRXh+B8EXW2kDUeWmYRTaTn27gsQnaDWR1c
         62qRRfOh2mqRq1vEDH4VrDc1Be49JQcpsx70zUoRerFEP3myoivArsBOhMzysQLoB751
         PjNxEMSeSyRQv6ClPvTq5mTLIHBaKzpVymrHdRMbFGyCvu9xlNlZN9+/2mB5G2ajYIOE
         AOdg==
X-Gm-Message-State: AOAM530LKdnWNVPU05d8hC+nrPzOOWF8eAQvfB0OtQpF0n7aF/R7NMKL
        GfXxGVrK9aUHB5w+fdEJIjkvbQ==
X-Google-Smtp-Source: ABdhPJxHAmaTQ7SoG4xOWZo1AxxrADEQ2354vOZDz2LunO92X2LOOVaWdpZupcrtKG2bjWHbFEFu3Q==
X-Received: by 2002:a17:907:2d2a:b0:710:76a1:4d89 with SMTP id gs42-20020a1709072d2a00b0071076a14d89mr11993861ejc.307.1654523178289;
        Mon, 06 Jun 2022 06:46:18 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id a26-20020a1709062b1a00b006f3ef214db4sm5496538ejg.26.2022.06.06.06.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 06:46:17 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     luizluca@gmail.com, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] net: dsa: realtek: rtl8365mb: remove learn_limit_max private data member
Date:   Mon,  6 Jun 2022 15:45:52 +0200
Message-Id: <20220606134553.2919693-5-alvin@pqrs.dk>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220606134553.2919693-1-alvin@pqrs.dk>
References: <20220606134553.2919693-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

The variable is just assigned the value of a macro, so it can be
removed.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 392047558656..a3a4454f77bf 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -563,7 +563,6 @@ struct rtl8365mb_port {
  * @irq: registered IRQ or zero
  * @chip_id: chip identifier
  * @chip_ver: chip silicon revision
- * @learn_limit_max: maximum number of L2 addresses the chip can learn
  * @cpu: CPU tagging and CPU port configuration for this chip
  * @mib_lock: prevent concurrent reads of MIB counters
  * @ports: per-port data
@@ -577,7 +576,6 @@ struct rtl8365mb {
 	int irq;
 	u32 chip_id;
 	u32 chip_ver;
-	u32 learn_limit_max;
 	struct rtl8365mb_cpu cpu;
 	struct mutex mib_lock;
 	struct rtl8365mb_port ports[RTL8365MB_MAX_NUM_PORTS];
@@ -1108,15 +1106,13 @@ static void rtl8365mb_port_stp_state_set(struct dsa_switch *ds, int port,
 static int rtl8365mb_port_set_learning(struct realtek_priv *priv, int port,
 				       bool enable)
 {
-	struct rtl8365mb *mb = priv->chip_data;
-
 	/* Enable/disable learning by limiting the number of L2 addresses the
 	 * port can learn. Realtek documentation states that a limit of zero
 	 * disables learning. When enabling learning, set it to the chip's
 	 * maximum.
 	 */
 	return regmap_write(priv->map, RTL8365MB_LUT_PORT_LEARN_LIMIT_REG(port),
-			    enable ? mb->learn_limit_max : 0);
+			    enable ? RTL8365MB_LEARN_LIMIT_MAX : 0);
 }
 
 static int rtl8365mb_port_set_isolation(struct realtek_priv *priv, int port,
@@ -2026,7 +2022,6 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->priv = priv;
 		mb->chip_id = chip_id;
 		mb->chip_ver = chip_ver;
-		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX;
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
 
-- 
2.36.0

