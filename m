Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276CB6D36AB
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 11:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjDBJsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 05:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjDBJsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 05:48:45 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D14A1D2C6
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 02:48:36 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso16375577wmo.0
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 02:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680428914;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h74B+sspgxWF+7aFXKfhg3s39gu1HTzZBhHhas95eg0=;
        b=RJbxMQr1kpLtO+MyUBP7WhR6bj67reJZZg+Ym4Q6b91V6CNXZjPWPVB+OuaHKiqoQM
         RSqO6808kyOJ+lQQ+AH7AV4wqE9s+U6WYNg13YjX67jDTAl8B8HXSUZcdAS7/YpKUgmf
         M1abDow9NjG1gIOVQDNQKNbeT+IUO/74NCB6lahka5RIyUB6S1tFFACE9A5/caW2zcPg
         0FWtPtKXPUo5AeBgHuazkYhmyJsGnXSzjc/a+QngZqotCi8MfITpxNI1wl8+M9fB5ZVE
         vtL9B8mYZBx9KG7CUjfQgIJpRj8iLdr8XnBc+UNSFCMIGeOTNUtiEkheZ11L1Gpq4+BW
         5rGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680428914;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h74B+sspgxWF+7aFXKfhg3s39gu1HTzZBhHhas95eg0=;
        b=zJOVK0QbZx9U/ffqYe6yB+NvUA5R+dJ6pBvZsUHL3B/I2dYiaau26XJwjy0aTLmbnz
         gHqknDP8xSB1YKinu29WiOc1DCFMjXT4EgSLphsWC+tWiHGHi4ICSXk7GK9XOUFHiHT1
         cJP9pU/tKn+zUJH3AT9uSRIfrdB43JtArwPRxdQB+6RTN9KraqFC75fzlfjiS1wkn2Ig
         DiMiJmHvrJEOtvlI+43Zg6IDSXw07bYmiY7kgso8imrxotgEItc+ulbd9mFYGoDGTlAI
         /8HNuWnE+bSnuc/4pXqSoSzEXeZSEDvLhAcFgVQckhlKgb5czawx24Fw8DOxYzpshNJb
         oc4A==
X-Gm-Message-State: AO0yUKU32JnbGqg8mvHiOdkj7BdGMMkVVAwrJfgUauB/MAYkF4H89jjf
        EHM7qEE3orDfiBzc0S0KQTA=
X-Google-Smtp-Source: AK7set9JKeHqrfKGDPSlyxWTJeNb2C8RLV62283dni2kCcbBO7m2DSmxeAXtdLPAPAP9EnTYhi+tFw==
X-Received: by 2002:a05:600c:25a:b0:3ed:358e:c1c2 with SMTP id 26-20020a05600c025a00b003ed358ec1c2mr24288815wmj.18.1680428914544;
        Sun, 02 Apr 2023 02:48:34 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id z7-20020a05600c220700b003f04646838esm7382057wml.39.2023.04.02.02.48.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 02:48:34 -0700 (PDT)
Message-ID: <66446a75-8087-10f4-fc37-b97e13b88c27@gmail.com>
Date:   Sun, 2 Apr 2023 11:47:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: [PATCH net-next 6/7] net: phy: smsc: add edpd tunable support
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

This adds support for the EDPD PHY tunable.
Per default EDPD is disabled in interrupt mode, the tunable can be used
to override this, e.g. if the link partner doesn't use EDPD.
The interval to check for energy can be chosen between 1000ms and
2000ms. Note that this value consists of the 1000ms phylib interval
for state machine runs plus the time to wait for energy being detected.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c  | 82 +++++++++++++++++++++++++++++++++++++++++
 include/linux/smscphy.h |  4 ++
 2 files changed, 86 insertions(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 0cd433f01..cca5bf46f 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -34,6 +34,8 @@
 #define SPECIAL_CTRL_STS_AMDIX_STATE_	0x2000
 
 #define EDPD_MAX_WAIT_DFLT		640
+/* interval between phylib state machine runs in ms */
+#define PHY_STATE_MACH_MS		1000
 
 struct smsc_hw_stat {
 	const char *string;
@@ -295,6 +297,86 @@ static void smsc_get_stats(struct phy_device *phydev,
 		data[i] = smsc_get_stat(phydev, i);
 }
 
+static int smsc_phy_get_edpd(struct phy_device *phydev, u16 *edpd)
+{
+	struct smsc_phy_priv *priv = phydev->priv;
+
+	if (!priv)
+		return -EOPNOTSUPP;
+
+	if (!priv->edpd_enable)
+		*edpd = ETHTOOL_PHY_EDPD_DISABLE;
+	else if (!priv->edpd_max_wait_ms)
+		*edpd = ETHTOOL_PHY_EDPD_NO_TX;
+	else
+		*edpd = PHY_STATE_MACH_MS + priv->edpd_max_wait_ms;
+
+	return 0;
+}
+
+static int smsc_phy_set_edpd(struct phy_device *phydev, u16 edpd)
+{
+	struct smsc_phy_priv *priv = phydev->priv;
+	int ret;
+
+	if (!priv)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&phydev->lock);
+
+	switch (edpd) {
+	case ETHTOOL_PHY_EDPD_DISABLE:
+		priv->edpd_enable = false;
+		break;
+	case ETHTOOL_PHY_EDPD_NO_TX:
+		priv->edpd_enable = true;
+		priv->edpd_max_wait_ms = 0;
+		break;
+	case ETHTOOL_PHY_EDPD_DFLT_TX_MSECS:
+		edpd = PHY_STATE_MACH_MS + EDPD_MAX_WAIT_DFLT;
+		fallthrough;
+	default:
+		if (phydev->irq != PHY_POLL)
+			return -EOPNOTSUPP;
+		if (edpd < PHY_STATE_MACH_MS || edpd > PHY_STATE_MACH_MS + 1000)
+			return -EINVAL;
+		priv->edpd_enable = true;
+		priv->edpd_max_wait_ms = edpd - PHY_STATE_MACH_MS;
+	}
+
+	priv->edpd_mode_set_by_user = true;
+
+	ret = smsc_phy_config_edpd(phydev);
+
+	mutex_unlock(&phydev->lock);
+
+	return ret;
+}
+
+int smsc_phy_get_tunable(struct phy_device *phydev,
+			 struct ethtool_tunable *tuna, void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_EDPD:
+		return smsc_phy_get_edpd(phydev, data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL_GPL(smsc_phy_get_tunable);
+
+int smsc_phy_set_tunable(struct phy_device *phydev,
+			 struct ethtool_tunable *tuna, const void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_EDPD:
+		return smsc_phy_set_edpd(phydev, *(u16 *)data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL_GPL(smsc_phy_set_tunable);
+
 int smsc_phy_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
diff --git a/include/linux/smscphy.h b/include/linux/smscphy.h
index 80f37c1db..e1c886277 100644
--- a/include/linux/smscphy.h
+++ b/include/linux/smscphy.h
@@ -32,6 +32,10 @@ int smsc_phy_config_intr(struct phy_device *phydev);
 irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev);
 int smsc_phy_config_init(struct phy_device *phydev);
 int lan87xx_read_status(struct phy_device *phydev);
+int smsc_phy_get_tunable(struct phy_device *phydev,
+			 struct ethtool_tunable *tuna, void *data);
+int smsc_phy_set_tunable(struct phy_device *phydev,
+			 struct ethtool_tunable *tuna, const void *data);
 int smsc_phy_probe(struct phy_device *phydev);
 
 #endif /* __LINUX_SMSCPHY_H__ */
-- 
2.40.0


