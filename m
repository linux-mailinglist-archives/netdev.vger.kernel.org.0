Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC8A5505E8
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 17:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbiFRPwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 11:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235296AbiFRPwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 11:52:17 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8245413D10;
        Sat, 18 Jun 2022 08:52:16 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id o16so9199053wra.4;
        Sat, 18 Jun 2022 08:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TAka2U091hq1pTYLfbpSkbHxbEYvHoamK2SIJoLud0w=;
        b=dpUtiHtnGLH0sRA+TkOb7TH5iShPD74gkMF4kZ5N9g4gW4bPawc1KU98fC2i4vKT2E
         0saMbZ5pEh/7QCGHYCW868w9Nnrrp5yNJJHdifUXLAqO18+AQANWcT/djpfc+yOkzym+
         r899LsQvd5P+stvcHjPiXrapVufqGesRbVLBElXX1p6Rw4+cdWd7NL1Jm/q+CK+14xcG
         mOLOLp2KZbYofTMnxW4cv4QXJDQiy4vWXjip7GSLzVnZi785B9O1HBKN4n6ZxKJwgEg8
         EF37uJyTaCFAkoWjMk4zLLmkzoBUkLJN0AaqXh3nG1CfWR4sDAxqQ9wsqHKZJiRk9nIw
         kGug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TAka2U091hq1pTYLfbpSkbHxbEYvHoamK2SIJoLud0w=;
        b=VCzn2xE3HoiYCKRRQadarKoPmxBimvp0b4Qy6R8QTDwdHsQtow686v7d7OT2rsEV+s
         mkZx/ROeJUe3113ZN59MSCAPpc8UX2Yx1QTYuxjw7mL3rVY26U1gm4kNZZhwmyA7zjd3
         OP8tnBPeuZpafp9OQvJFiKvzLRVvtaJDlo23oKJpzZvYj2gF8oEsM+m63G1TN826UK7E
         F3o8QEQJNKZUZV0pN8fJwssjcCBPMUKOeq7e9B0WB2yMaTzaEGCywbHb6bgTx9biQQmf
         7r9Sl69rdt5LwIoagLSmfvHt/DvNXHiJoNqgztXvcdem6MGX+YAIqvfXtB46C+sxdy+U
         edew==
X-Gm-Message-State: AJIora/vr9DGVsQXDRMNskmr2Fy125MR4gYEbB9Gun1pLYgbcTgdUZUk
        +MRNRBXP3gDWXWYeGDumvJc=
X-Google-Smtp-Source: AGRyM1va7j3EnoWku6+iPBrLG3zW8WN2GupDj5eVgKdIfXnz1Q+Aww42ksJ2o1+DqQk2eeFLFbh7cg==
X-Received: by 2002:a05:6000:1ac7:b0:219:e95e:706b with SMTP id i7-20020a0560001ac700b00219e95e706bmr14516251wry.198.1655567535033;
        Sat, 18 Jun 2022 08:52:15 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id a8-20020adfed08000000b0020d106c0386sm1952188wro.89.2022.06.18.08.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 08:52:14 -0700 (PDT)
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
Subject: [RESEND net-next PATCH 3/3] net: dsa: qca8k: reset cpu port on MTU change
Date:   Sat, 18 Jun 2022 09:26:50 +0200
Message-Id: <20220618072650.3502-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220618072650.3502-1-ansuelsmth@gmail.com>
References: <20220618072650.3502-1-ansuelsmth@gmail.com>
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

