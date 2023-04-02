Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0266D36A5
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 11:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjDBJsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 05:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjDBJsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 05:48:31 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4675B85
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 02:48:30 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso18014210wmb.0
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 02:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680428909;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=upQXBEYXOyx70bYLdqvKtCylGja9s+Qe8Od27p9n1/c=;
        b=l+A6zY/43MGMMyb9o/A5gUfOzkbkHeEzkZ8M9cu5LIv6DxWF/bgWEaOnaNqnmAWB56
         aAnFp20cqew4wd/BXtWu0WuY4XMQpZRTrycX+bhDxtXafTOKTXNITlHfNjtInz1871v9
         n7qBCxEFYAkTf3oBvPi2/XGItnmfY4GbVZP3ERSfL62c0D2zz8lcnT/FcKBqxa1sNE8i
         sWzxVB0MKjwGIn4Lm/6xglGCi3YBJD9bsXscOyYRAQbobK9Rphlo38mey/SNVcnjtNCL
         mFkZCM09g1ncltTZ8s2lgpNPeWMLG++qFtCNSydzcInD3hiAjzHFC2Ct0I01ZgS+8yHl
         mTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680428909;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=upQXBEYXOyx70bYLdqvKtCylGja9s+Qe8Od27p9n1/c=;
        b=Ixx4OD8K0PxrujG1KlxAS2H4pGigXC0EHOj8TfHscCnnOMyO00neM8HzsFoa9fA6mM
         mqeecNGbXTCX4oVkjMfSgyFVxUeFOkWccH3k3XYBmYpn7FvMPJnR7Nr18t46s4wV8yla
         +NwtsnSJgZn/ofnSq+55iSFaItPRCt/g6H2m79alVFoicG3Zth9VwlmJb9rWsPajR8vu
         MR/TTwzutcIfcKMLHyLp56DjxKGb3qKfJSKGeVpZjU06Iqwr2eJN9LyAvjClUuT8pmrk
         Dl7Zd/eXU9Xt8ztOvm3xSVn4PE6XxAf3DZ+47B4lDcEZjgmZcGDuFeitn1ERU/YvXESx
         vn2g==
X-Gm-Message-State: AO0yUKVlgxNwCUFOpd+OqZS0I4WGYeMH0o+FjnmO+krwL0cJvpy31KiL
        N6kFyWAzpmmuR5b+C1KWtcM=
X-Google-Smtp-Source: AK7set8qBUMVe4dZVitqlV32lDCEA8h7uLASbKwoQCenQ8DFRRu8Yv0DKbp5vAInewXGXTaBtWFxMg==
X-Received: by 2002:a7b:c7ce:0:b0:3ed:a07b:c59d with SMTP id z14-20020a7bc7ce000000b003eda07bc59dmr25125849wmk.21.1680428909312;
        Sun, 02 Apr 2023 02:48:29 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id q9-20020a1cf309000000b003f04f0c5a6fsm1821763wmq.26.2023.04.02.02.48.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 02:48:28 -0700 (PDT)
Message-ID: <eaf837a8-20f2-6ed9-6819-e149097568e8@gmail.com>
Date:   Sun, 2 Apr 2023 11:45:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: [PATCH net-next 2/7] net: phy: smsc: add helper smsc_phy_config_edpd
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
In-Reply-To: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper smsc_phy_config_edpd() and explicitly clear bit
MII_LAN83C185_EDPWRDOWN is edpd_enable isn't set.
Boot loader may have left whatever value.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 928cf6d8b..1b588366e 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -77,6 +77,18 @@ int smsc_phy_config_intr(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(smsc_phy_config_intr);
 
+static int smsc_phy_config_edpd(struct phy_device *phydev)
+{
+	struct smsc_phy_priv *priv = phydev->priv;
+
+	if (priv->edpd_enable)
+		return phy_set_bits(phydev, MII_LAN83C185_CTRL_STATUS,
+				    MII_LAN83C185_EDPWRDOWN);
+	else
+		return phy_clear_bits(phydev, MII_LAN83C185_CTRL_STATUS,
+				      MII_LAN83C185_EDPWRDOWN);
+}
+
 irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 {
 	int irq_status;
@@ -105,9 +117,7 @@ int smsc_phy_config_init(struct phy_device *phydev)
 	if (!priv || !priv->edpd_enable || phydev->irq != PHY_POLL)
 		return 0;
 
-	/* Enable energy detect power down mode */
-	return phy_set_bits(phydev, MII_LAN83C185_CTRL_STATUS,
-			    MII_LAN83C185_EDPWRDOWN);
+	return smsc_phy_config_edpd(phydev);
 }
 EXPORT_SYMBOL_GPL(smsc_phy_config_init);
 
-- 
2.40.0


