Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D746AD139
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 23:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjCFWLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 17:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjCFWLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 17:11:12 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2743B679
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 14:11:10 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso9236969wmq.1
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 14:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678140668;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4mfii0fRoeo9bvZmh0Rbze+u2GmXvVbER4exI0vvBXU=;
        b=SuiPHg+/mYEfEVkieOoo0h/nkLV2iDkNbamEZhByy6k7aZGj2BrHzCtLruZm6jyX0L
         H5z3Qc+5V+2jR1UqEJfaDBJn8cQmJ/7buOvdqeDvPFe75cSUe/aOjqVIEutz257V6+Ex
         1hoBqZiSaEaD+BwX8vi7Bky/1EK8nEZ1+M8NTOqZ0L93FOccmRM9N6J7VvbBz8USSerp
         1lzwod2WjBJsHRWAoUJb8eXwsgc1XYyVoHBsYKRL1nZsvrKCOVCGGqnIfzTy3Cjv/fOe
         WzfKkqVD/oYjqRXnTNPtfLpVEa6widMlWELif66oBOiGTbFLxSvOoBxzZT2bJZ5BXZ0X
         oHmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678140668;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4mfii0fRoeo9bvZmh0Rbze+u2GmXvVbER4exI0vvBXU=;
        b=w/rkJpICU7V1hGq3C8XpsGnXacwzLbd3EUCTiaPT/uEBGW7TBwW+aGYeV1rxjPOg4U
         EbZ22z9pPERc+LHsTU9j/XzW6XoTN5Q0CmVivKCA206qMNOKQxrA3U8QhhlsvWHQCDK8
         if1tY1N+p7sxCKLlLpPYMHgsCaf4q+4UtWAJDN5Jw6TKBYVAg98HnOYEguxo3Tm/lFeU
         R8zkxC+1G6uI9xXefoC4eTNHSrY8jM16dXOnbcPKvzTsXhPaqJaIGHw3GfuMB62avnsc
         kLjHLspWP5ogd640CFA07HXy38h8eNQnhijw53niBzWM9J3OdL3S5q3ojZp18fFf/6lJ
         6hPA==
X-Gm-Message-State: AO0yUKUylhhfQ9jL7j1VlH05buO3UsCaHj5WY5o7oA87i7eIxODgKpEr
        qULtQpbGJhyud97DdoGkV9s=
X-Google-Smtp-Source: AK7set9GV0vfA6H+XXx9arOgZvEOc1jg59cEDjdSdAEz+4gzzKXVjKLdvVXUp0GKhGEMsvHxmtBDcg==
X-Received: by 2002:a05:600c:19cf:b0:3e7:772d:22de with SMTP id u15-20020a05600c19cf00b003e7772d22demr10562543wmq.30.1678140668571;
        Mon, 06 Mar 2023 14:11:08 -0800 (PST)
Received: from ?IPV6:2a01:c22:7bf4:7d00:9590:4142:18ea:aa32? (dynamic-2a01-0c22-7bf4-7d00-9590-4142-18ea-aa32.c22.pool.telefonica.de. [2a01:c22:7bf4:7d00:9590:4142:18ea:aa32])
        by smtp.googlemail.com with ESMTPSA id b8-20020a05600c4e0800b003e208cec49bsm354wmq.3.2023.03.06.14.11.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 14:11:08 -0800 (PST)
Message-ID: <3da785c7-3ef8-b5d3-89a0-340f550be3c2@gmail.com>
Date:   Mon, 6 Mar 2023 23:10:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: smsc: simplify lan95xx_config_aneg_ext
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

lan95xx_config_aneg_ext() can be simplified by using phy_set_bits().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index be96c474c..0e9fcbe33 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -167,18 +167,15 @@ static int lan87xx_config_aneg(struct phy_device *phydev)
 
 static int lan95xx_config_aneg_ext(struct phy_device *phydev)
 {
-	int rc;
-
-	if (phydev->phy_id != 0x0007c0f0) /* not (LAN9500A or LAN9505A) */
-		return lan87xx_config_aneg(phydev);
+	if (phydev->phy_id == 0x0007c0f0) { /* LAN9500A or LAN9505A */
+		/* Extend Manual AutoMDIX timer */
+		int rc = phy_set_bits(phydev, PHY_EDPD_CONFIG,
+				      PHY_EDPD_CONFIG_EXT_CROSSOVER_);
 
-	/* Extend Manual AutoMDIX timer */
-	rc = phy_read(phydev, PHY_EDPD_CONFIG);
-	if (rc < 0)
-		return rc;
+		if (rc < 0)
+			return rc;
+	}
 
-	rc |= PHY_EDPD_CONFIG_EXT_CROSSOVER_;
-	phy_write(phydev, PHY_EDPD_CONFIG, rc);
 	return lan87xx_config_aneg(phydev);
 }
 
-- 
2.39.2

