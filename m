Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30F855058F
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 16:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbiFROsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 10:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbiFROs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 10:48:29 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8233617A97;
        Sat, 18 Jun 2022 07:48:28 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id hj18so12979536ejb.0;
        Sat, 18 Jun 2022 07:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TAka2U091hq1pTYLfbpSkbHxbEYvHoamK2SIJoLud0w=;
        b=OQOlMC+R31QKJmoU9wJB5Kv0I9fftYkXsmLoHLx0SiHNiFUeur0jFaDF1tKUqtmQ90
         Ovoq3IcTav4PWmsvpCm0ue5oTuMT4WVoTiZlr3UZuqzqmITVLmfXBrRdmKl0mlsP4OwA
         y1TuGGFqfxBUgh3VGNicAb+mXY2UF2xSiMz7dzDSY0HgKM50LyXeOjGDsjdCT373lCqf
         XpVV458qFjUzCzFl2eMNnL6q7xhZ+BG9718qg4rFMgM1R+2fNgExDDFCur8aVG3a48M1
         neDiPizURSwJoGdryAmyb8JoBxtEzNQMgChfIUgUhtKqfnNZyEfjEsa0Dr5lWO/iicrW
         Delw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TAka2U091hq1pTYLfbpSkbHxbEYvHoamK2SIJoLud0w=;
        b=J//BvxETzbUTGFojMPHYrZwcDeMIGOuV2fqjUFZGFMZX7MJ3kBZnGouOcti+MidjiZ
         QzfTrZsBq9EEi6QkSXV+FvvmaR0XVKCk8qzgwsHijvM6Tg6DZ3KT01ywRkYWirTY7s2i
         V4vFVne2qfMoF8XoEItG8mkg4f3xY34EChVXoohH+Cp/wUF7N11gzjTlKOBrHo3bYn6B
         jy1JZeLi6U3puFfMvHrrrssuQCyYMcr4R+L4PPJEoA0teTOTF0z2+MUEAHBGQ85yXu75
         7ao4d4Q/LK2yF5hCilrNi3/DTFeDeXZsdf/ZECM4MpjULLgzjfMhTSScan1BCRh1a9sO
         +ynA==
X-Gm-Message-State: AJIora97CqXDt5caja6HWB/Tu6ddI0w5w/nLMzmYJpOYW79bKS0jNUoT
        /nWK0UlJE+BktmrjhGTMeKzR8QFkMMQ=
X-Google-Smtp-Source: AGRyM1sf0gIEM9qnmpruEfunYcY2rJWY18yBnCyQJQEU9Q+xSQymS9j87O1VpY7q8V9XBCX0VlE3pA==
X-Received: by 2002:a17:906:99c5:b0:6ff:4c8f:6376 with SMTP id s5-20020a17090699c500b006ff4c8f6376mr13831933ejn.328.1655563706838;
        Sat, 18 Jun 2022 07:48:26 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id h20-20020a1709070b1400b006fe7d269db8sm3450296ejl.104.2022.06.18.07.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 07:48:26 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christian Marangi <ansuelsmth@gmail.com>
Subject: [PATCH 3/3] net: dsa: qca8k: reset cpu port on MTU change
Date:   Sat, 18 Jun 2022 08:23:00 +0200
Message-Id: <20220618062300.28541-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220618062300.28541-1-ansuelsmth@gmail.com>
References: <20220618062300.28541-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was discovered that the Documentation lacks of a fundamental detail
on how to correctly change the MAX_FRAME_SIZE of the switch.

In fact if the MAX_FRAME_SIZE is changed while the cpu port is on, the
switch panics and cease to send any packet. This cause the mgmt ethernet
system to not receive any packet (the slow fallback still works) and
makes the device not reachable. To recover from this a switch reset is
required.

To correctly handle this, turn off the cpu ports before changing the
MAX_FRAME_SIZE and turn on again after the value is applied.

Fixes: f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index eaaf80f96fa9..0b92b9d5954a 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2334,6 +2334,7 @@ static int
 qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct qca8k_priv *priv = ds->priv;
+	int ret;
 
 	/* We have only have a general MTU setting.
 	 * DSA always set the CPU port's MTU to the largest MTU of the slave
@@ -2344,10 +2345,29 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	if (!dsa_is_cpu_port(ds, port))
 		return 0;
 
+	/* To change the MAX_FRAME_SIZE the cpu ports must be off or
+	 * the switch panics.
+	 * Turn off both cpu ports before applying the new value to prevent
+	 * this.
+	 */
+	if (priv->port_enabled_map & BIT(0))
+		qca8k_port_set_status(priv, 0, 0);
+
+	if (priv->port_enabled_map & BIT(6))
+		qca8k_port_set_status(priv, 6, 0);
+
 	/* Include L2 header / FCS length */
-	return regmap_update_bits(priv->regmap, QCA8K_MAX_FRAME_SIZE_REG,
-				  QCA8K_MAX_FRAME_SIZE_MASK,
-				  new_mtu + ETH_HLEN + ETH_FCS_LEN);
+	ret = regmap_update_bits(priv->regmap, QCA8K_MAX_FRAME_SIZE_REG,
+				 QCA8K_MAX_FRAME_SIZE_MASK,
+				 new_mtu + ETH_HLEN + ETH_FCS_LEN);
+
+	if (priv->port_enabled_map & BIT(0))
+		qca8k_port_set_status(priv, 0, 1);
+
+	if (priv->port_enabled_map & BIT(6))
+		qca8k_port_set_status(priv, 6, 1);
+
+	return ret;
 }
 
 static int
-- 
2.36.1

