Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77145524265
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 04:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238500AbiELCRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 22:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237173AbiELCRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 22:17:40 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F54139167;
        Wed, 11 May 2022 19:17:39 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id j6so3498250pfe.13;
        Wed, 11 May 2022 19:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aIdzbXsqXbRstF0IbI4DJcTY/zYonS1/qdwLxMPj1DA=;
        b=dWz5AOMf8jEq4rDDm76qKHm8I94zglKEsjUC8/TolEma2LoFmXbG+yS+Il8R9RWhp2
         xOo1zO4MDmTPVDrqDbr8tZSX1mX/5BiQMxuxaJpWaOVO+gbkAhOAn4K3tLytUG2H3Lm8
         GE9+Pbj3KoO3VYU2ABMKnN0/Y6gLTl+DkO1pCPPaWFHLlb6UYTSnJ6ga9uTvsAolrBnT
         t8JEcPON36m2ZLLBmAl4Bxv5A8aypr9hGcuZP/3n2zN8yfXvjxJBjNjsAjz695pQVDl2
         Q3Cs6ED2RATb0eb0iroNclx0jjwUu0BrjJQOF3vvR3ZHfHA0UyTizlprekrRWKVOcXhd
         lsXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aIdzbXsqXbRstF0IbI4DJcTY/zYonS1/qdwLxMPj1DA=;
        b=CCHcaiI4n6LPa4I2mHNEHcTjYTTwvGWNHV35WLtvbbtAfPMIoW6lF8Mbcmc6DJYhYG
         N2vHp9HOXsgOFS4iANMCRbJNQrGLQJje2W5wP+WcP5aXma8Okhk3u8F+mKZsqW5wE6ql
         twBYJ/o2/v7Tz5XyNrR5iIWtpTdyqRB90vM2Yg857FxvZVA1dIYTYap39Uk4vua0683x
         tfsSnjwEhnlz+qOyYhIIkd5xLx0a9g1vCZcvsSM3MQ2H5uef51Wea16JcST0AynTVBnA
         cYxMlhfdXkt8dmDW+eMobUi92NHSj8vgqhvypsqwVeIg7g1AepaoQ5A16vxntkWc3sRU
         Fl3w==
X-Gm-Message-State: AOAM530jub84ZnbIojZProuF7GGM1zO0nblxOU7dxsqUfRpw2P/tCZJ8
        IEnU1tFxRCg0Neto+jxY72/XuBYxP08=
X-Google-Smtp-Source: ABdhPJx+9s+FvmtYdx6PsFlI9t7Z8KMVZpBC5BGgvp57qktfK7DPm8KHpMbl+GtkdVOG8fRK+HFKUg==
X-Received: by 2002:a63:d07:0:b0:3c2:7317:24c8 with SMTP id c7-20020a630d07000000b003c2731724c8mr23277208pgl.109.1652321858410;
        Wed, 11 May 2022 19:17:38 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q24-20020a62ae18000000b0050dc7628148sm2417685pff.34.2022.05.11.19.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 19:17:37 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: bcm_sf2: Fix Wake-on-LAN with mac_link_down()
Date:   Wed, 11 May 2022 19:17:31 -0700
Message-Id: <20220512021731.2494261-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 2d1f90f9ba83 ("net: dsa/bcm_sf2: fix incorrect usage of
state->link") the interface suspend path would call our mac_link_down()
call back which would forcibly set the link down, thus preventing
Wake-on-LAN packets from reaching our management port.

Fix this by looking at whether the port is enabled for Wake-on-LAN and
not clearing the link status in that case to let packets go through.

Fixes: 2d1f90f9ba83 ("net: dsa/bcm_sf2: fix incorrect usage of state->link")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index cf82b1fa9725..87e81c636339 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -809,6 +809,9 @@ static void bcm_sf2_sw_mac_link_down(struct dsa_switch *ds, int port,
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	u32 reg, offset;
 
+	if (priv->wol_ports_mask & BIT(port))
+		return;
+
 	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
 		if (priv->type == BCM4908_DEVICE_ID ||
 		    priv->type == BCM7445_DEVICE_ID)
-- 
2.25.1

