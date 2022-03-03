Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2AD4CB82C
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 08:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiCCHzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 02:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiCCHzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 02:55:09 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA3916F960
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 23:54:23 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id kt27so8899235ejb.0
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 23:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=M4XRf2sIBG0/gEW/qp5zl/3bv8xHye0TNCiBP0f7nIc=;
        b=UOdXsYKoHU8Sb4BfBpPn6+kmp5JZbNOgwuuX8KgkW6JEq/jxNwJE3F+raFOL339fDr
         9mhF4u9I3N1QEBYFA69+FF8fgaXVq71GMrA2mNJXuiidC4HHotqNBa5xeUj2LKJs0fSY
         mdgmbuKCyuZ1jfIaymv9hprAYLOOe7B1rYCey1q44pITBLzY5n7Lc/D5k1ZxWqvQNEXS
         8mlcQ9tCHJcgN2UKhXe0/J3maT8dU3yDPXwlvBIXgj1sHwxqduHSjDMOk8L1jS7zq1Gn
         rLeMo+6aYzk0nUIpKFSWE0wt6rz1QylJm6UkHMdkmqtFxgXxt74LsmjikPomvNBHkzyb
         7o5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=M4XRf2sIBG0/gEW/qp5zl/3bv8xHye0TNCiBP0f7nIc=;
        b=It9ZSPkqVEKQBEKEnPaP0taNuqnb/EB/0qtC5uMykf951eLCoOxWx3xIJlQwMg8wWK
         hgQ7q4C8ncv1Qoyqv3/R2E4h4oJ0RzQibp8O8PMfHlC8+f+nzj0c3Z1gvGvucvasET4p
         A6kYLJSbzs5CFtgC9fgoD9O6Erah5tsAyrbvNpVkJFHabj/UL9VCHelG5TInRDkRkhXW
         0Kh45i7BZP04SakTUSDIRTapd809JnQ4Clh/jcLfxhn3TgzhWU43Asa0V6SN8FxENsRR
         1Jl39gWlJbsI0JMA9JL2CLNaaVjWYtg5Q3oMqy95XnpspbYANe77okxIhE70KrpcSiUT
         CwAg==
X-Gm-Message-State: AOAM532IvMabAhuyPpLPwMIR9uhoxRtx1tnjkv4qW/qBc3fIWzPf1/tH
        apO3xNJ/2TTL3/yodalQJfE=
X-Google-Smtp-Source: ABdhPJwh3lwBn4C1AqDcAdk1HxU1PbxBM+iT5YZF5nv1VJ5aqKL5crIXy447dJvtp1MEyoThyqsaqw==
X-Received: by 2002:a17:907:1c13:b0:6da:62bb:f1ff with SMTP id nc19-20020a1709071c1300b006da62bbf1ffmr5237397ejc.276.1646294061921;
        Wed, 02 Mar 2022 23:54:21 -0800 (PST)
Received: from ?IPV6:2a01:c22:77fb:7800:e497:e843:ca71:bb7d? (dynamic-2a01-0c22-77fb-7800-e497-e843-ca71-bb7d.c22.pool.telefonica.de. [2a01:c22:77fb:7800:e497:e843:ca71:bb7d])
        by smtp.googlemail.com with ESMTPSA id y18-20020a170906471200b006da8a883b5fsm423367ejq.54.2022.03.02.23.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 23:54:21 -0800 (PST)
Message-ID: <04cac530-ea1b-850e-6cfa-144a55c4d75d@gmail.com>
Date:   Thu, 3 Mar 2022 08:54:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>, netdev@vger.kernel.org,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] net: phy: meson-gxl: fix interrupt handling in forced
 mode
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This PHY doesn't support a link-up interrupt source. If aneg is enabled
we use the "aneg complete" interrupt for this purpose, but if aneg is
disabled link-up isn't signaled currently.
According to a vendor driver there's an additional "energy detect"
interrupt source that can be used to signal link-up if aneg is disabled.
We can safely ignore this interrupt source if aneg is enabled.

This patch was tested on a TX3 Mini TV box with S905W (even though
boot message says it's a S905D).

This issue has been existing longer, but due to changes in phylib and
the driver the patch applies only from the commit marked as fixed.

Fixes: 84c8f773d2dc ("net: phy: meson-gxl: remove the use of .ack_callback()")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/meson-gxl.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index 7e7904fee..c49062ad7 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -30,8 +30,12 @@
 #define  INTSRC_LINK_DOWN	BIT(4)
 #define  INTSRC_REMOTE_FAULT	BIT(5)
 #define  INTSRC_ANEG_COMPLETE	BIT(6)
+#define  INTSRC_ENERGY_DETECT	BIT(7)
 #define INTSRC_MASK	30
 
+#define INT_SOURCES (INTSRC_LINK_DOWN | INTSRC_ANEG_COMPLETE | \
+		     INTSRC_ENERGY_DETECT)
+
 #define BANK_ANALOG_DSP		0
 #define BANK_WOL		1
 #define BANK_BIST		3
@@ -200,7 +204,6 @@ static int meson_gxl_ack_interrupt(struct phy_device *phydev)
 
 static int meson_gxl_config_intr(struct phy_device *phydev)
 {
-	u16 val;
 	int ret;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
@@ -209,16 +212,9 @@ static int meson_gxl_config_intr(struct phy_device *phydev)
 		if (ret)
 			return ret;
 
-		val = INTSRC_ANEG_PR
-			| INTSRC_PARALLEL_FAULT
-			| INTSRC_ANEG_LP_ACK
-			| INTSRC_LINK_DOWN
-			| INTSRC_REMOTE_FAULT
-			| INTSRC_ANEG_COMPLETE;
-		ret = phy_write(phydev, INTSRC_MASK, val);
+		ret = phy_write(phydev, INTSRC_MASK, INT_SOURCES);
 	} else {
-		val = 0;
-		ret = phy_write(phydev, INTSRC_MASK, val);
+		ret = phy_write(phydev, INTSRC_MASK, 0);
 
 		/* Ack any pending IRQ */
 		ret = meson_gxl_ack_interrupt(phydev);
@@ -237,9 +233,16 @@ static irqreturn_t meson_gxl_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 
+	irq_status &= INT_SOURCES;
+
 	if (irq_status == 0)
 		return IRQ_NONE;
 
+	/* Aneg-complete interrupt is used for link-up detection */
+	if (phydev->autoneg == AUTONEG_ENABLE &&
+	    irq_status == INTSRC_ENERGY_DETECT)
+		return IRQ_HANDLED;
+
 	phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
-- 
2.35.1

