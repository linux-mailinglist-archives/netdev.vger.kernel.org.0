Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5BD5806F0
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 23:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbiGYVty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 17:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbiGYVtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 17:49:52 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8610121E06;
        Mon, 25 Jul 2022 14:49:51 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t3-20020a17090a3b4300b001f21eb7e8b0so14967343pjf.1;
        Mon, 25 Jul 2022 14:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qW/It6c6ryu2QgDKcjreDIFG3bmqLDIYxkxCKtddTZ8=;
        b=IR89cid8sYRgrxM0IUL6ziY1VPFDiYbxG29HODh8EtkOQnESNrAFWKtj31UdqluNee
         CoSiMp5O8ddCzu555tQacoGijPS0zrMMSzBetQex0GjdqSa33fEYD6AYG6XGF6oBYF/Q
         1I2bk27WZKKiD9ae7pRhXmuLaMHRLzte2mTxLBd7h0Rl/JmDj51a1ZHf9SalwE9Dk/Lj
         BmanDP8qwn+/uNzxZaFEoaHRWPvmbU1bKjUXGa5dErxkm7wtHb7/fxyZJR07VD9lnSxQ
         HuGkWoj63XbHl/PXLfQjq83FFkZKpGIFryEx00gbaRCWb1ca/LJmzeJr8wa5YAX3/NAW
         WQhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qW/It6c6ryu2QgDKcjreDIFG3bmqLDIYxkxCKtddTZ8=;
        b=B+SNdies4ejAy/WqnrUXF0JkOP7O7elkOeVOImfBthMfmg/yD6HfiWB08Lqs1TSL8E
         2IRWQNum2bPL6RaVJeToTBzmundQzP+a8Wv4euTqyfGB8A+qpgTJjcDzZ53q68DNMgOC
         bXrZC9a/ZzBlG3qfIibl2qyc9dzfQE40SqPWZD1rPuw4KonqsVrFRGljSPizp8nyUSmP
         LkRLYS2fymSTQ/LgjAjWF1iQbxHN2TEou0+I2xW2Fh/bvUKJZvpdEmez8Fp8tgV0hsU6
         JoxsISQ+tH1LjCcgJaDTXYOvu0Xq1HCepsI0agY2ymO0lgJBiXewVn9Gs95QGj6XzgJp
         s87Q==
X-Gm-Message-State: AJIora/YL/bHs6zZwp5MO54PtI04ntH2IaSWqcpZ29SAzw52BxT4sxR8
        TYyMgwld3hGCz/f8pwvVN2aHw7MYqHM=
X-Google-Smtp-Source: AGRyM1tPdGiI/8b1MXr447JbwppiCJg/L1w/v/ndO4Set2t+VYKeDQANpv4sS/uJNqptwVmkaFG0YQ==
X-Received: by 2002:a17:90b:b12:b0:1f2:3345:44ec with SMTP id bf18-20020a17090b0b1200b001f2334544ecmr16778411pjb.29.1658785790658;
        Mon, 25 Jul 2022 14:49:50 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c5-20020a637245000000b004161b3c3388sm9086551pgn.26.2022.07.25.14.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 14:49:50 -0700 (PDT)
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
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC net-next 1/2] net: dsa: bcm_sf2: Introduce helper for port override offset
Date:   Mon, 25 Jul 2022 14:49:41 -0700
Message-Id: <20220725214942.97207-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220725214942.97207-1-f.fainelli@gmail.com>
References: <20220725214942.97207-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depending upon the generation of switches, we have different offsets for
configuring a given port's status override where link parameters are
applied. Introduce a helper function that we re-use throughout the code
in order to let phylink callbacks configure the IMP/CPU port(s) in
subsequent changes.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index be0edfa093d0..10de0cffa047 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -94,6 +94,24 @@ static u16 bcm_sf2_reg_led_base(struct bcm_sf2_priv *priv, int port)
 	return REG_SWITCH_STATUS;
 }
 
+static u32 bcm_sf2_port_override_offset(struct bcm_sf2_priv *priv, int port)
+{
+	switch (priv->type) {
+	case BCM4908_DEVICE_ID:
+	case BCM7445_DEVICE_ID:
+		return port == 8 ? CORE_STS_OVERRIDE_IMP :
+				   CORE_STS_OVERRIDE_GMIIP_PORT(port);
+	case BCM7278_DEVICE_ID:
+		return port == 8 ? CORE_STS_OVERRIDE_IMP2 :
+				   CORE_STS_OVERRIDE_GMIIP2_PORT(port);
+	default:
+		WARN_ONCE(1, "Unsupported device: %d\n", priv->type);
+	}
+
+	/* RO fallback register */
+	return REG_SWITCH_STATUS;
+}
+
 /* Return the number of active ports, not counting the IMP (CPU) port */
 static unsigned int bcm_sf2_num_active_ports(struct dsa_switch *ds)
 {
@@ -167,11 +185,7 @@ static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
 	b53_brcm_hdr_setup(ds, port);
 
 	if (port == 8) {
-		if (priv->type == BCM4908_DEVICE_ID ||
-		    priv->type == BCM7445_DEVICE_ID)
-			offset = CORE_STS_OVERRIDE_IMP;
-		else
-			offset = CORE_STS_OVERRIDE_IMP2;
+		offset = bcm_sf2_port_override_offset(priv, port);
 
 		/* Force link status for IMP port */
 		reg = core_readl(priv, offset);
@@ -813,12 +827,7 @@ static void bcm_sf2_sw_mac_link_down(struct dsa_switch *ds, int port,
 		return;
 
 	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
-		if (priv->type == BCM4908_DEVICE_ID ||
-		    priv->type == BCM7445_DEVICE_ID)
-			offset = CORE_STS_OVERRIDE_GMIIP_PORT(port);
-		else
-			offset = CORE_STS_OVERRIDE_GMIIP2_PORT(port);
-
+		offset = bcm_sf2_port_override_offset(priv, port);
 		reg = core_readl(priv, offset);
 		reg &= ~LINK_STS;
 		core_writel(priv, reg, offset);
@@ -843,11 +852,7 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 		u32 reg_rgmii_ctrl = 0;
 		u32 reg, offset;
 
-		if (priv->type == BCM4908_DEVICE_ID ||
-		    priv->type == BCM7445_DEVICE_ID)
-			offset = CORE_STS_OVERRIDE_GMIIP_PORT(port);
-		else
-			offset = CORE_STS_OVERRIDE_GMIIP2_PORT(port);
+		offset = bcm_sf2_port_override_offset(priv, port);
 
 		if (interface == PHY_INTERFACE_MODE_RGMII ||
 		    interface == PHY_INTERFACE_MODE_RGMII_TXID ||
-- 
2.25.1

