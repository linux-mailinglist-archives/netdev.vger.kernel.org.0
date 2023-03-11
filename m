Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6D76B5FCC
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 19:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjCKSez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 13:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCKSey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 13:34:54 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB8712873
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 10:34:53 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id c18so5427469wmr.3
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 10:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678559691;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eqEJqbCuZuRl7814GB5IwcmDcGHUjuyv288ufowS3vI=;
        b=Be6gWtivglmWVdMHx0ZfYXT+L2ESVL9VWpHMDGCneRAF6s1kRiJ3ovxheL3rtbVXaD
         MPPLlbkgJvM1ZUOvvTyE+W90OWrxQ8p3RbbGGKjl2FxxoNJWybzjWoxq7JnqbeOd35av
         pqPmNjtjRNb9eqJXn4iVgf7O5pueLUoZt/xJvpP18Ug3P5MCqjy3Py8HMw7sWv1qSnna
         Twdd0gRpF0Q7MPBndUhcoIYIJt0lf4OZ32QsezfCjhMNx1MyF0qvmD3CTcOTcowqpkdu
         22R0qOCn8Lga0qM59KA/O6bquntPoOoaI/sphoUgyoPkduM+IEa53hv2sLcQStorrpH6
         OPzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678559691;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eqEJqbCuZuRl7814GB5IwcmDcGHUjuyv288ufowS3vI=;
        b=t77/Pdq/KV1crnBzjhK3L21njPenR6kdn3/2tNAqnPmOoUPFdwFVWDM8zgxgWV71Dt
         WVMCYZubPW00QbmrP+l3wqWAo60kSTAlL4wJ2VpPPnO115/bmD6Jo5EjnpMdB402t2fL
         EDq2nvU35/3VhNPYcED5yFl8NuiKIvhCWr4ZPGmsjHs8jusrmIGjQ8xTtMQEYFc7TT65
         j0D6siufQb6n/7z9d1GkIslASIPmLhJTkXKdc1YOvSssqIreYo2FWtcQo7RCo49tdIK5
         b/S3CW0Sa3VjrMdnx2rBto+eR3mgowvaF7A7CdiWUh7dlVOkff9J5yQrJN+LXLkyh1/e
         R8fA==
X-Gm-Message-State: AO0yUKX4JYFUpK6E4MrrmTbI2ZzJ2mo1OxhcAh6gZqBnoSXQYTyKRtxT
        YhWyjss9neCBw5Q59zHciEY=
X-Google-Smtp-Source: AK7set+MEIOXOw/oM0BfCw3ao3hPoVbspSqgLF9DshMQlgAaz1t3odL3XXrBC/kchTz4Pe3aVSTruA==
X-Received: by 2002:a05:600c:1ca6:b0:3eb:2db4:c626 with SMTP id k38-20020a05600c1ca600b003eb2db4c626mr6802591wms.38.1678559691388;
        Sat, 11 Mar 2023 10:34:51 -0800 (PST)
Received: from ?IPV6:2a01:c22:7697:7600:9da4:a8d7:23a9:980? (dynamic-2a01-0c22-7697-7600-9da4-a8d7-23a9-0980.c22.pool.telefonica.de. [2a01:c22:7697:7600:9da4:a8d7:23a9:980])
        by smtp.googlemail.com with ESMTPSA id h19-20020a05600c315300b003e7c89b3514sm3806892wmo.23.2023.03.11.10.34.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 10:34:50 -0800 (PST)
Message-ID: <026aa4f2-36f5-1c10-ab9f-cdb17dda6ac4@gmail.com>
Date:   Sat, 11 Mar 2023 19:34:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Patrick Trantham <patrick.trantham@fuel7.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] net: phy: smsc: bail out in lan87xx_read_status if
 genphy_read_status fails
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

If genphy_read_status fails then further access to the PHY may result
in unpredictable behavior. To prevent this bail out immediately if
genphy_read_status fails.

Fixes: 4223dbffed9f ("net: phy: smsc: Re-enable EDPD mode for LAN87xx")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 9cfaccce1..721871184 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -189,8 +189,11 @@ static int lan95xx_config_aneg_ext(struct phy_device *phydev)
 static int lan87xx_read_status(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
+	int err;
 
-	int err = genphy_read_status(phydev);
+	err = genphy_read_status(phydev);
+	if (err)
+		return err;
 
 	if (!phydev->link && priv->energy_enable && phydev->irq == PHY_POLL) {
 		/* Disable EDPD to wake up PHY */
-- 
2.39.2

