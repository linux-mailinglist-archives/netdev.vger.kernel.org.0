Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D67546996
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345858AbiFJPj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345256AbiFJPjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:39:22 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE1E294230
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:39:20 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id x62so35796139ede.10
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AareH3Xp+hp4A5FOtY4uNivgTY9OEK29GzGPxmxFOws=;
        b=cerH8wlG313nA0z0Y7JIP0fnogppEEaTDR4YmPZvIIxv2wRJq3Kq8l+xWfW7dFVRN/
         jyeFFxTIn5hReE15OTzXVG8bqJG0kAI3ueQkwX8823WsOL3xlFtg5cCOeczLROZmimhL
         1LZBzKju0bGg2IsnaN6U4rS8A8QuS9MTKReaE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AareH3Xp+hp4A5FOtY4uNivgTY9OEK29GzGPxmxFOws=;
        b=qwYaN/cLcW5nhw16K1wD2V3iluuOeMK5qLNFn0apYXj8oN6No6IJFRDfw4PlPNUPN9
         Be8Evm0f3XxK8mAIEDNaYtpqhEp5ByzBvG33bRVKUBbU5y4kJxj2d0qg5YUw/kzGigTR
         9cGBWaOf/70PK6zEnGLGuIwvjqCy6UnACJUW2rmk3r5YVJQppQLdvpWVo80sjdjh/bRo
         S8oRgtjpRM9MQYvuMkgf7cQcM8MyLd8ImKks4Mxre3d9blm/sodUXi2o7xhFY92I7wGY
         +A/N51/T1ZTRg0B812J0I2Q+bnQe98gE1R20gyXJmhwZ94fqTO6I+5HoPs7dTiu+24Xj
         e6dg==
X-Gm-Message-State: AOAM533LKVCIEq+hrugiz9g0QORVT8znd7gKVAudB7Zz3vxREeiBbdby
        Ql/rXwf19m8aV6eccRLWjJ2h3g==
X-Google-Smtp-Source: ABdhPJy4raIs0VwqrQPiBQc3E+6FgvT/KawaF9u4p4aP/jcqe9nJxFcsMMLVxxPhpWnrV5KLM9ze4g==
X-Received: by 2002:aa7:c752:0:b0:42d:ee9d:5ace with SMTP id c18-20020aa7c752000000b0042dee9d5acemr52401926eds.318.1654875558812;
        Fri, 10 Jun 2022 08:39:18 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id h24-20020a170906829800b0070f7d1c5a18sm9783857ejx.55.2022.06.10.08.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 08:39:17 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     hauke@hauke-m.de, Linus Walleij <linus.walleij@linaro.org>,
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
Subject: [PATCH net-next v2 4/5] net: dsa: realtek: rtl8365mb: remove learn_limit_max private data member
Date:   Fri, 10 Jun 2022 17:38:28 +0200
Message-Id: <20220610153829.446516-5-alvin@pqrs.dk>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220610153829.446516-1-alvin@pqrs.dk>
References: <20220610153829.446516-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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
index 3599fa5d9f14..676b88798976 100644
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
@@ -1088,15 +1086,13 @@ static void rtl8365mb_port_stp_state_set(struct dsa_switch *ds, int port,
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
@@ -2003,7 +1999,6 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->priv = priv;
 		mb->chip_id = chip_id;
 		mb->chip_ver = chip_ver;
-		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX;
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
 
-- 
2.36.1

