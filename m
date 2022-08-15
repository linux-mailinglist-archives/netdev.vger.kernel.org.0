Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57B2593430
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 19:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbiHORum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 13:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiHORuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 13:50:18 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDAE39B;
        Mon, 15 Aug 2022 10:50:17 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id c20so6001645qtw.8;
        Mon, 15 Aug 2022 10:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=qW/It6c6ryu2QgDKcjreDIFG3bmqLDIYxkxCKtddTZ8=;
        b=DtuP9JRLXskLjOdrd/JY58SNHaK+A30zL0GcB/RDjN7X7iT2hbIZzg/6M+O2Jr+Y6T
         trc2XEsJaW+CfBHO3bgLaTxFwFiqjFvGBCRviQyzxA86jZxl0oo4Mg+No+1UqMSW711h
         vuQzK07AVPq2zTYYbVFJ9LB4Deq5D590hYsN2zy81w8zRepy1vkmSinTRUOKQFhg4Z4J
         GIG3Fy0X3yzBy/mY24mO/nFLl20tzJZITyH/nFezVbS08NA6I32OqLFZfD5Bw3GgBtHD
         aDR7zFOA5gwi6YDSDGeQ7WILZ9r7EwyR+9EJnfKVm/yCERDOBHf35HfRcv7c+JymSEbI
         /o7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=qW/It6c6ryu2QgDKcjreDIFG3bmqLDIYxkxCKtddTZ8=;
        b=5rEcJrOXIOkLmTqSeEH4vejbGj4pO+WfVm5IDHuOOXbVubpmtqoPwuIsh0/xZbqyJd
         sYWkKn9eXNN2vUWFOY3iEcL/zTSseP7Xk1Bp0v9+bQeysXY0YW8BlQY6hF7x6EckZgN8
         w15Afpb1aYQ4ZXr1sI8qU+qsXL0jmfZeOum1CR6tnzOw6uW6jcOavR+yb+2ngUcRIJcP
         lP9YXaQ5ITWaVwyUS6VmcF/RC0Vw1dw1LlOgdNSTMFCk7L9DaoIW4OkhCra2IdOI7Jh/
         6eUPeeMxmDMBbacZRRKqW90j7xD3FvwIDGwDRfiaxbx72NVavhXWQHaAIqxpqsdddk9y
         5oow==
X-Gm-Message-State: ACgBeo0CoMoGlgUpTZicOV0NgmyLQF6YzifpGuqVRdmcCZYzaeI3K7T5
        bxhb36V1TDqQY/XRttdEoDsgb7dUBl8=
X-Google-Smtp-Source: AA6agR7WSyiGvFQRYH1R5KTEJvXZnNckQCCvEHGBTJ8QNdDc7nDqFa7hmPW83RxyDtJyGDM4b4Sqbw==
X-Received: by 2002:a05:622a:449:b0:343:6353:8f94 with SMTP id o9-20020a05622a044900b0034363538f94mr15475892qtx.154.1660585816006;
        Mon, 15 Aug 2022 10:50:16 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ez12-20020a05622a4c8c00b00339163a06fcsm8741524qtb.6.2022.08.15.10.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 10:50:15 -0700 (PDT)
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
Subject: [PATCH net-next 1/2] net: dsa: bcm_sf2: Introduce helper for port override offset
Date:   Mon, 15 Aug 2022 10:50:08 -0700
Message-Id: <20220815175009.2681932-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220815175009.2681932-1-f.fainelli@gmail.com>
References: <20220815175009.2681932-1-f.fainelli@gmail.com>
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

