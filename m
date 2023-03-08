Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2343A6B12AD
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 21:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjCHULT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 15:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjCHULS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 15:11:18 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352A8CF980
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 12:11:17 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id da10so70573889edb.3
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 12:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678306275;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VV0bBYD4IfGM03b6Vw1KULaYzQgZshy8Em84TaP9Gaw=;
        b=l8DrYWm1xpAGvZ1T+GZVHwI3x4ZWJ81dakJHhL+OY6MscA42Z8p6ip/zqXDyemdLgc
         +PGe4xWDs9gTsvaoLeT8yLIa8LoLDj70YxujJBshcts66/BgVwpXZNaCWUZGYyBfZWK6
         Z58/ALlNW2dJ1Xm5XpNSInSEWQr3sU3V1t0PiLULt6reMvgKSBFgf5xkEiOnnvu/FX5m
         LVPxFDUSye7N+UIS3a8Wx1vcpZd5H1oysf+h67HSz9tMfauDxSF3d5Rs1aZTSnTg/rQS
         prc9etANmzMepyHYROPzekFeDnEz7my6/oyf6XMcfH+f/Z7u1Bh5TRaEJvF9AL1iZ4YV
         NhDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678306275;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VV0bBYD4IfGM03b6Vw1KULaYzQgZshy8Em84TaP9Gaw=;
        b=Z2TfibtNAuoFBUK0PROP9G9SSR+iBcHVcnJUszWOOnldkolS1mPNEPB873W39N7ZA+
         o8VESJ10/rUKthCrE5O1VhdabuuJIV+pW399pSJxjaZoXJ0a0bkbAOMThASV6ZrOuH4o
         UekNX2VKtmIetWOHaGahD0PS3Azb1hRQJnKylf3G0U4j7d9tTKUVxPeXDHgjELZvu3YJ
         VjDTIjnNEVERsEvxU3CtkD39J1bgJyakdq71GQdaCynE0x6UQnZD8/ifglvZ+OXlvq99
         zhhkgSjeVUgAQc097YZ0z5MndSlV1jYlndUPiYAvpeKX4g0Iexk7NWCICdYi2+Mkbkv0
         eGww==
X-Gm-Message-State: AO0yUKUOlAb2YJAK4f64/weFZhckHA0ZIr0wzj5Fj8rod7xYdFpdie9w
        4rf3xOCm/5xoDJwnaxosYL9Pfy/OLE0=
X-Google-Smtp-Source: AK7set/Ct9+FeFqNyhs905FCW67sXzK4XcwfCux8VuyiGXryRiwRWxz67oLu26RS3GQNYYMfpTYTQg==
X-Received: by 2002:a17:906:aadb:b0:905:a46b:a725 with SMTP id kt27-20020a170906aadb00b00905a46ba725mr21795790ejb.16.1678306274517;
        Wed, 08 Mar 2023 12:11:14 -0800 (PST)
Received: from ?IPV6:2a01:c22:6ed9:d400:9df:5c71:99fe:44f3? (dynamic-2a01-0c22-6ed9-d400-09df-5c71-99fe-44f3.c22.pool.telefonica.de. [2a01:c22:6ed9:d400:9df:5c71:99fe:44f3])
        by smtp.googlemail.com with ESMTPSA id i6-20020a17090671c600b008b26f3d45fbsm7984413ejk.143.2023.03.08.12.11.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 12:11:13 -0800 (PST)
Message-ID: <6c4ca9e8-8b68-f730-7d88-ebb7165f6b1d@gmail.com>
Date:   Wed, 8 Mar 2023 21:11:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: smsc: use phy_clear/set_bits in
 lan87xx_read_status
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

Simplify the code by using phy_clear/sert_bits().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index af89f3ef1..5965a8afa 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -204,17 +204,16 @@ static int lan95xx_config_aneg_ext(struct phy_device *phydev)
 static int lan87xx_read_status(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
+	int rc;
 
-	int err = genphy_read_status(phydev);
+	rc = genphy_read_status(phydev);
+	if (rc)
+		return rc;
 
 	if (!phydev->link && priv->energy_enable && phydev->irq == PHY_POLL) {
 		/* Disable EDPD to wake up PHY */
-		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
-		if (rc < 0)
-			return rc;
-
-		rc = phy_write(phydev, MII_LAN83C185_CTRL_STATUS,
-			       rc & ~MII_LAN83C185_EDPWRDOWN);
+		rc = phy_clear_bits(phydev, MII_LAN83C185_CTRL_STATUS,
+				    MII_LAN83C185_EDPWRDOWN);
 		if (rc < 0)
 			return rc;
 
@@ -222,24 +221,20 @@ static int lan87xx_read_status(struct phy_device *phydev)
 		 * an actual error.
 		 */
 		read_poll_timeout(phy_read, rc,
-				  rc & MII_LAN83C185_ENERGYON || rc < 0,
+				  rc < 0 || rc & MII_LAN83C185_ENERGYON,
 				  10000, 640000, true, phydev,
 				  MII_LAN83C185_CTRL_STATUS);
 		if (rc < 0)
 			return rc;
 
 		/* Re-enable EDPD */
-		rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
-		if (rc < 0)
-			return rc;
-
-		rc = phy_write(phydev, MII_LAN83C185_CTRL_STATUS,
-			       rc | MII_LAN83C185_EDPWRDOWN);
+		rc = phy_set_bits(phydev, MII_LAN83C185_CTRL_STATUS,
+				  MII_LAN83C185_EDPWRDOWN);
 		if (rc < 0)
 			return rc;
 	}
 
-	return err;
+	return 0;
 }
 
 static int smsc_get_sset_count(struct phy_device *phydev)
-- 
2.39.2

