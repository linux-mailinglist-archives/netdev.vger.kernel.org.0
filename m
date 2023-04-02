Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FE06D38BB
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 17:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbjDBPSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 11:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjDBPSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 11:18:20 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CE6CDFA
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 08:18:19 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id ew6so107852425edb.7
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 08:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680448697;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=upQXBEYXOyx70bYLdqvKtCylGja9s+Qe8Od27p9n1/c=;
        b=baelzLlXhOVPyW+bDQ8HK8fE9sKT8rnnFt5holvBi/Mn/ztQnoL7Uju2eZru2z2/Dk
         sGpCyiac2ufWrZpNyIipsC5JsYxecuprHhZnfORsuuxpxgVCYFw5d/G2VQutM4q6K5wY
         FOHOTBJ9K6FZVpxzrMdT0dq53vT4qRVi3K4ly0hot+zG6UHCCS7SGy1HjVqZwtRX+l2t
         EwcpXryTLw3Td4FH2EJwnACr4sFXVR+tIEzavX6OYPBkh1ou3W35gaFL6HKidWjoe/gv
         oTswuZD7N1qmeQ7T3SyfsXMmXyOnfB2jCjDBnwehrvDFN7iiHLtQX4XdZitwmB+C0Dr5
         QEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680448697;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=upQXBEYXOyx70bYLdqvKtCylGja9s+Qe8Od27p9n1/c=;
        b=lZGnUTKDLoLbrAp5hm6+RikjbhNDYt1ioAVxKSB+Im9ICWL5NVRFp+OayDN4yxAypd
         fv9giERTE+0p3uRpwcLGnPpYgpj3rtlbjrI/KF/QNSD7qzzPb9RtBdgHzEaLupcI51pM
         jEBvx/WOaknc84DJbZyF+To8FfW0F9a/Ktz57/KVZjlkjdHg/PSOK9rgq4pxS3x46Vib
         3XTuhSCBTxzriFr20AaRtLnWRNoTbCR2Gi7xT8H2dzC8PCyKKWUqjfjE5HZ1iYdy/aU6
         D+dsxisPrYmLT07LUrt3101Je05UhzcrOrKkGNfjat9E6csH60vPyb8CQjVH1loWEcuR
         5CNQ==
X-Gm-Message-State: AAQBX9fhL0OB1tOjYC9hC8fIP3ZI6J5BBTtW13w0daT3PMGMj2sl++jM
        nAR9wOv96i6ZX43xbKhUX8s=
X-Google-Smtp-Source: AKy350Y/rY2j0t9FEruaIg7CM2MXRAaxcK6/P5ci1c19IIKMWTQ6olcUHQBvKLvJEKDSL3mzBb9vfQ==
X-Received: by 2002:a17:907:b60e:b0:93e:9fb9:183b with SMTP id vl14-20020a170907b60e00b0093e9fb9183bmr34505980ejc.73.1680448697420;
        Sun, 02 Apr 2023 08:18:17 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id y7-20020a1709064b0700b00946be16f725sm3314857eju.153.2023.04.02.08.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 08:18:16 -0700 (PDT)
Message-ID: <27ad971b-929e-d292-a16e-c0c3371ca17b@gmail.com>
Date:   Sun, 2 Apr 2023 17:12:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: [PATCH net-next v2 2/7] net: phy: smsc: add helper
 smsc_phy_config_edpd
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Healy <cphealy@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
In-Reply-To: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
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


