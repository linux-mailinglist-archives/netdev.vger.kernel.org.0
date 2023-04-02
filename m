Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37536D36A6
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 11:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjDBJse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 05:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjDBJsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 05:48:33 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A0359E8
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 02:48:32 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id t4so21206379wra.7
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 02:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680428910;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LwgbIeTanWWopm2Woc6G9OjxlDTFUJdRd+39o8DvPaQ=;
        b=UeaaSaYdZ3IGhpR5TWe2uV5Rs8gK6W5fAWC5SOjltkwjeoz9RSLxhsma1z5v29GUXa
         SJj80LQvDtLpem/ag248Hsoyu7YW8FZGKzLHPMjgNXGPV/xRwjJybygYfAAB+5pUiSdZ
         bNyfspOUhVl/qRtNfEBdi69qsjEodRHoD9rHQ1X9U4PLJRTPzJV44mNBBCuy7DKsA6Jt
         bSJKKdEC36BFazRMYk5Xd9QOxvj3cFD8VM+qUTGyCmHIruqtyGA1j+vxkjN+FRFsUZYm
         3KHx79pY8VhrPAbtPw4/3VYh9viyohMDmdrsTZliakK+fSgcFsxFZnkg3BVUF7KnlDN2
         485A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680428910;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LwgbIeTanWWopm2Woc6G9OjxlDTFUJdRd+39o8DvPaQ=;
        b=LPb2Kbh50Zu4WRQxJKZJZ8JWiw0U5D/7JBWW3qgzpCsYFO4+w+//kCnx5ucjP6amxF
         3rCZgjskzxU/J+Is/cYmaRps7r7SX4vFYm/98qZJjMd06AzfC7YGvhvP3YZTAgWgTrz0
         oU5FoA2Ap5f6jIW8rN/H0BihH1g2J0DqErWfbLAPCUgXwCgHwvjJ9LJunETxLZXH/P+Z
         AUsBMCukVgWxtE1PJ/+k+4/W7UCqAxAXpQGVkCL7PYeaqP5kYsA7rqOTNp0Cz+et5bH6
         BwMxAHan+yN3dxpL3K9H5kxo/AzUOlZMORamR+H/M1aX6l1M1dt5pO8XyXNNcyyOZZ8U
         awSQ==
X-Gm-Message-State: AAQBX9eeha+T5W/+i1TqDV0jgKfub0uSQE05AZpCMUh/Ej+HXIyPCyEm
        nW3y8KuCRXckAzWJoX8NvbU=
X-Google-Smtp-Source: AKy350aKHy9TnCxEaNjPSqZVBT7xU3MfmYWc0KvuWxmVFVNNpxvo/+zQ9KKdibW9+Y6Qvu/kw00yFw==
X-Received: by 2002:a5d:6b4b:0:b0:2dc:2431:67d0 with SMTP id x11-20020a5d6b4b000000b002dc243167d0mr24385422wrw.19.1680428910525;
        Sun, 02 Apr 2023 02:48:30 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id k16-20020a056000005000b002e116cbe24esm6903026wrx.32.2023.04.02.02.48.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 02:48:30 -0700 (PDT)
Message-ID: <a8c2ca24-65a8-fbc4-f74d-aa90a9505787@gmail.com>
Date:   Sun, 2 Apr 2023 11:45:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: [PATCH net-next 3/7] net: phy: smsc: clear edpd_enable if interrupt
 mode is used
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

Clear edpd_enable if interrupt mode is used, this avoids
having to check for PHY_POLL multiple times.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 1b588366e..f5ecd8bea 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -114,9 +114,12 @@ int smsc_phy_config_init(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
 
-	if (!priv || !priv->edpd_enable || phydev->irq != PHY_POLL)
+	if (!priv)
 		return 0;
 
+	if (phydev->irq != PHY_POLL)
+		priv->edpd_enable = false;
+
 	return smsc_phy_config_edpd(phydev);
 }
 EXPORT_SYMBOL_GPL(smsc_phy_config_init);
@@ -208,8 +211,7 @@ int lan87xx_read_status(struct phy_device *phydev)
 	if (err)
 		return err;
 
-	if (!phydev->link && priv && priv->edpd_enable &&
-	    phydev->irq == PHY_POLL) {
+	if (!phydev->link && priv && priv->edpd_enable) {
 		/* Disable EDPD to wake up PHY */
 		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
 		if (rc < 0)
-- 
2.40.0


