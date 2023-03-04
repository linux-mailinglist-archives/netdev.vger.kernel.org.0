Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF726AA93E
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 11:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjCDKw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 05:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjCDKwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 05:52:55 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB52213B
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 02:52:53 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id h11so4494210wrm.5
        for <netdev@vger.kernel.org>; Sat, 04 Mar 2023 02:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bl32myXK96JlWfYadQkJtxfi/oh01QiP7PLh4DrTDHs=;
        b=n7lfVayG84538WxikmSWfDdxAjGKhrBi5Ydsa6ig/KZQ4OdFVe6vNfvb8ZrfyIME6z
         kShxT/8VN2cxAZCIJQLXEx1Ba4T4UzdMF7qRm0OIuIkKKDXwRupXDWqZ1SExL1I/u3Jk
         5rAhHwxL90cZ2oEqRyc5CKpeXl7UDyGVsNqIwpeaU9Wq6tO0X1EbJmXyUyYFenHXOCc5
         BCPY4zL/F4QIJVoSStsHBOrQMXpMCa0rf6x+Ro0nfgXlVoCSA7NtGFr5vdZbzwtT2KHK
         Cw+iaV1kcQHbNayP5ol8ynE27TzXGWE1oEfLdVqX5UGVmurENDsphvB5B+Lz9cV3ja1q
         6MeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Bl32myXK96JlWfYadQkJtxfi/oh01QiP7PLh4DrTDHs=;
        b=bj1ISH2rOuS2JS3lcHkNlOdJQZhEi+egItPsQj6k4x2LsbIo3mmUGtn+jJgJAs7wtY
         sUuLRGVA796J3SFzfBvrCjpkjvh7FgMXAGtb7ANx/uzbjRJzpt1+aOlib2TKwBCVeV/3
         J3YuxnpnLOIWs+JkLjzNExwJ/iMO02yase+FX0l0zrat20vnRuGmAQ7ni0FxhTtjKJCo
         UOiM29nbPfwDGyHDwku2sSCHS3N6UIZDOp1tYS8BOSM4XU/y3A4niTPLApIc7AbdXpwg
         XyKMWYU34g36mgMW5B1co5fcTaaQab6zjrcycHUft+vuW4z/l2ws0MwuA8h6C0aOwVOz
         MeYw==
X-Gm-Message-State: AO0yUKUqggKNhkh5QshWn2m8KbEtd62pvDlnFxCzNFF9YehzwrErhuwY
        m0RWV7uQbX2tpQYKqtHqVKM=
X-Google-Smtp-Source: AK7set8z6BH7wHV2JBb/aXR7891UPnhqlxFuNnLXNuBl/SY33D1dLGWQvGWZL/6X+FGHyIawFCmHBg==
X-Received: by 2002:adf:e6c9:0:b0:2cb:2775:6e6 with SMTP id y9-20020adfe6c9000000b002cb277506e6mr3063151wrm.45.1677927171898;
        Sat, 04 Mar 2023 02:52:51 -0800 (PST)
Received: from ?IPV6:2a01:c22:72de:8e00:407a:2df4:b258:9a04? (dynamic-2a01-0c22-72de-8e00-407a-2df4-b258-9a04.c22.pool.telefonica.de. [2a01:c22:72de:8e00:407a:2df4:b258:9a04])
        by smtp.googlemail.com with ESMTPSA id d18-20020a5d6452000000b002c71dd1109fsm4578335wrw.47.2023.03.04.02.52.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Mar 2023 02:52:51 -0800 (PST)
Message-ID: <5dca131f-e47b-22a9-3f9a-ec754fa532bc@gmail.com>
Date:   Sat, 4 Mar 2023 11:52:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marco Felsch <m.felsch@pengutronix.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] net: phy: smsc: fix link up detection in forced irq mode
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently link up can't be detected in forced mode if polling
isn't used. Only link up interrupt source we have is aneg
complete which isn't applicable in forced mode. Therefore we
have to use energy-on as link up indicator.

Fixes: 7365494550f6 ("net: phy: smsc: skip ENERGYON interrupt if disabled")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index ac7481ce2..00d9eff91 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -44,7 +44,6 @@ static struct smsc_hw_stat smsc_hw_stats[] = {
 };
 
 struct smsc_phy_priv {
-	u16 intmask;
 	bool energy_enable;
 };
 
@@ -57,7 +56,6 @@ static int smsc_phy_ack_interrupt(struct phy_device *phydev)
 
 static int smsc_phy_config_intr(struct phy_device *phydev)
 {
-	struct smsc_phy_priv *priv = phydev->priv;
 	int rc;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
@@ -65,14 +63,9 @@ static int smsc_phy_config_intr(struct phy_device *phydev)
 		if (rc)
 			return rc;
 
-		priv->intmask = MII_LAN83C185_ISF_INT4 | MII_LAN83C185_ISF_INT6;
-		if (priv->energy_enable)
-			priv->intmask |= MII_LAN83C185_ISF_INT7;
-
-		rc = phy_write(phydev, MII_LAN83C185_IM, priv->intmask);
+		rc = phy_write(phydev, MII_LAN83C185_IM,
+			       MII_LAN83C185_ISF_INT_PHYLIB_EVENTS);
 	} else {
-		priv->intmask = 0;
-
 		rc = phy_write(phydev, MII_LAN83C185_IM, 0);
 		if (rc)
 			return rc;
@@ -85,7 +78,6 @@ static int smsc_phy_config_intr(struct phy_device *phydev)
 
 static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 {
-	struct smsc_phy_priv *priv = phydev->priv;
 	int irq_status;
 
 	irq_status = phy_read(phydev, MII_LAN83C185_ISF);
@@ -96,7 +88,7 @@ static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 
-	if (!(irq_status & priv->intmask))
+	if (!(irq_status & MII_LAN83C185_ISF_INT_PHYLIB_EVENTS))
 		return IRQ_NONE;
 
 	phy_trigger_machine(phydev);
-- 
2.39.2

