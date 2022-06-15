Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAA154D4CF
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 00:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350576AbiFOWvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 18:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350570AbiFOWvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 18:51:38 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A805641C
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 15:51:35 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z7so18188729edm.13
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 15:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AareH3Xp+hp4A5FOtY4uNivgTY9OEK29GzGPxmxFOws=;
        b=kJzpPcYmcX7GoYd5tKK+ollj2PRhF8lAkiyS3JW/xsbBypPJ1S6pWA7AwYOH4o1NNk
         TxuMrtWli9kiluVbcbl0Si+CK0BVPyD7C/b4zxvVTjOe1bm7iLzSbYQ+c/ZealIYX91u
         2BfBxNLumPg8ZjKobTSfjtIDMh1WL/1QFD7hM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AareH3Xp+hp4A5FOtY4uNivgTY9OEK29GzGPxmxFOws=;
        b=O7QUz6nNQjTrPFE8yQqdSby+gj+qU6Ev6LjVcqHIoYBLNNUshtA5ieFcrD7PkAdW3J
         /OmCOSMiC948RT2r52ejK0bpe6cRn3jpdqv6tDLGp9OaCr9m0tDae7VjExw8Tce2hQl6
         nyuruOxPrTYDwkzSJP2qZh3FXueiHEtrdxPZ073eeLdGebW5BWSuD/jDBjSQ0QHKpvZE
         t8D+zoWnh/0Vxu9PqaA80LDcx9QHQi++YrhNeztKC9+VUg/xNf++UhNxrqmgOtEeuoy0
         Ky+mKADAv6f0lXjlz3WTc3Osp2/qc+1foioDJAUQ0r16DoYnvTYNyd8aHH+NBxry0lSh
         Xy6w==
X-Gm-Message-State: AJIora8qLR5eea1xnjpnFAmHwaKvM7hRNL8AwodnGyy+q7/vZ4dsgolF
        Rmg7+i4EV2k54Xo28W5uZnt4cw==
X-Google-Smtp-Source: AGRyM1s8HNefBTr6EzDUrhiYqbINKuXkV+4Hc+kGEYoKgOE1r08kg/gFh3kyeRMAURVZ7aQz2TD0vA==
X-Received: by 2002:a05:6402:329b:b0:431:3143:5ced with SMTP id f27-20020a056402329b00b0043131435cedmr2648926eda.257.1655333493599;
        Wed, 15 Jun 2022 15:51:33 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id h23-20020aa7c617000000b0042e21f8c412sm371506edq.42.2022.06.15.15.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 15:51:33 -0700 (PDT)
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
Subject: [PATCH net-next v3 4/5] net: dsa: realtek: rtl8365mb: remove learn_limit_max private data member
Date:   Thu, 16 Jun 2022 00:51:14 +0200
Message-Id: <20220615225116.432283-5-alvin@pqrs.dk>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220615225116.432283-1-alvin@pqrs.dk>
References: <20220615225116.432283-1-alvin@pqrs.dk>
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

