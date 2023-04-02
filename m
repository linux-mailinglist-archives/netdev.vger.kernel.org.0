Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD34B6D38BA
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 17:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjDBPSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 11:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjDBPST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 11:18:19 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CC5D50C
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 08:18:17 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b20so107944542edd.1
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 08:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680448696;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AxNLqwe7oCB4JXyBb+HCY+YQ9gAGvcZfdTIxvMULNNY=;
        b=PgiI2RTCnu6bJlFSqOVb1+tuMVn9Ms1zIz0AlR0jkUfvfJIJIuSUCRSMKoHU5EdGVS
         X3U1qvKFLNGnTNV85G2LW2mYXoJCM0s6ba1WzOj+uAvHWZFUoD6m61kAmBsF6BcWrk2s
         BJB1+UKP4/tNeryAjnjCSCNaP4Gc1Inj9giPQDOP6koC/fxSOjlJX/db55OdDtAZeojc
         AfRoyBDWm4/7uVzdA5WmUvwcAgU0SZ03zmX7R4Zy0CNIslIfUXz/Y6OdhTYFXCmyNiID
         xMrg8pzKya19ES3/PtmoErTX7Lq4rTY1fzsLCYtdPK7EZXc/ZFJRV0XXKdqMKYWAVaWJ
         9QkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680448696;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AxNLqwe7oCB4JXyBb+HCY+YQ9gAGvcZfdTIxvMULNNY=;
        b=QcpEGlpKmdadbaGrNEae33dXhji4hdyobyPzUcuXzKfqO2dz5p8+ZA++fI2M0oc57K
         irr9d+64d7d2H/domvEcHV5ZI3ZtiC554gNPaEYXeD9uMbgNhZMco9BLSyE1RlFfwjic
         SqkEG5kRJfnsCedAm04u2TPDxCMiSDCJQR+wvkkP4My3AnwnxDWF+CDiJ28xrYcY3LNg
         qr6rOywcrmJk0v4jCa+ai9Pa99R9eZ7q1pAUfU5dQa1hyDheGvDhpikbDFF/xIfANgye
         5BXFBpm7cOZuKCucttTGdYLndkBuRPyerBGtGPL+0yM2CJ2a4Libcm+8EcMe/B5N6OlN
         DYVg==
X-Gm-Message-State: AAQBX9dTbUvwQrFmO/rRzji8L+2uJGaTW/mxkcpSs0r9+bnEF6FczNug
        HAK1HgbJSPIKcLuNgItBAQeNImqc5YA=
X-Google-Smtp-Source: AKy350bwG6TBalLi4Qp2mDFqHdBwmOXdfwdH1yVDYIaA42Bq5OnN6P+D41fgL5b7MNBG6DEMbx9okA==
X-Received: by 2002:aa7:c490:0:b0:4fa:315a:cb55 with SMTP id m16-20020aa7c490000000b004fa315acb55mr34271690edq.21.1680448696097;
        Sun, 02 Apr 2023 08:18:16 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id r3-20020a50d683000000b00502719a3966sm2873282edi.18.2023.04.02.08.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 08:18:15 -0700 (PDT)
Message-ID: <3fcf639a-12b7-f5b2-29c8-a5c3e2e16ca3@gmail.com>
Date:   Sun, 2 Apr 2023 17:11:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: [PATCH net-next v2 1/7] net: phy: smsc: rename flag energy_enable
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

Rename the flag to edpd_enable, as we're not enabling energy but
edpd (energy detect power down) mode. In addition change the
type to a bit field member in preparation of adding further flags.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 730964b85..928cf6d8b 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -44,7 +44,7 @@ static struct smsc_hw_stat smsc_hw_stats[] = {
 };
 
 struct smsc_phy_priv {
-	bool energy_enable;
+	unsigned int edpd_enable:1;
 };
 
 static int smsc_phy_ack_interrupt(struct phy_device *phydev)
@@ -102,7 +102,7 @@ int smsc_phy_config_init(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
 
-	if (!priv || !priv->energy_enable || phydev->irq != PHY_POLL)
+	if (!priv || !priv->edpd_enable || phydev->irq != PHY_POLL)
 		return 0;
 
 	/* Enable energy detect power down mode */
@@ -198,7 +198,7 @@ int lan87xx_read_status(struct phy_device *phydev)
 	if (err)
 		return err;
 
-	if (!phydev->link && priv && priv->energy_enable &&
+	if (!phydev->link && priv && priv->edpd_enable &&
 	    phydev->irq == PHY_POLL) {
 		/* Disable EDPD to wake up PHY */
 		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
@@ -284,10 +284,10 @@ int smsc_phy_probe(struct phy_device *phydev)
 	if (!priv)
 		return -ENOMEM;
 
-	priv->energy_enable = true;
+	priv->edpd_enable = true;
 
 	if (device_property_present(dev, "smsc,disable-energy-detect"))
-		priv->energy_enable = false;
+		priv->edpd_enable = false;
 
 	phydev->priv = priv;
 
-- 
2.40.0


