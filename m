Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66FBB6D38C2
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 17:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjDBPSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 11:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbjDBPS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 11:18:28 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED9BE053
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 08:18:23 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id eh3so107849204edb.11
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 08:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680448702;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NOf2b+S5Wsg1yUC+DGGFW5l5LkigK5jBetrmYDqYsRM=;
        b=bNtypxNSEIr1y1gG8y6mgGsvkBz9HHEBzKvaNLt3+2PsQAAWROLdsyuFmvADt7Q1EI
         wKMvWd1ZLG1uIPi/4Vq7r9Qeqw7GQic/T0AqdiCHzq3o+CD7q4b+AAr93ZcwvzsRhpzm
         ezCszw/u0po0Ti3RxUfRzJfB3xvUmskTSGKPEbwwGtn0DyrCWpc3V70MDCia4mx4kww5
         RdY5QgPnD1k95P4m5o8e2ON+QqfWiVTd5CccN1JLy4awrb9GJro3MVGgvwFO40eOVE51
         x7hovMxam3F45E7szXXBPlE9YP1Ulfg6iK65AcD5S+bPhlUsBOG0djLs04nqdSHu3x1V
         yllQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680448702;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NOf2b+S5Wsg1yUC+DGGFW5l5LkigK5jBetrmYDqYsRM=;
        b=dBDS5OwgozLlfHDFfhfM5Pxe3xuoURiV0p8ZaEWJzQxl3vyq6o0/X/dni/mLqfLnyd
         GFsC+S/jJTBfz34F5F/m7kux2381vwOtjQ2x8Qn7YP9Og61kRHIYPT+GAePGgLVciWUu
         xpxkPuWEAJnpvFk42ndSs5ECdXJT5bzz4Baaxkj7r9K0rif/KGPCSe/7XzNVyB/b7xhE
         ht1boL3YpP8h5tG6/VVnR9HuaROcWMe73U5agdJaQmb4dedgKjzDDJ3DU5hCv7Rq9Xmn
         iJfpCO7vtb6uqZ07YZlzsi1sU3rwtlyrigqraoeCG8HDoclnsE899iHaqQ2S2J3uPRK0
         A0jA==
X-Gm-Message-State: AAQBX9dqcy0NqNPtaiHHglLW9OdoaJkf1AKElNmyBsty5qC6GT2ipOMn
        UurJGe8xFIir/7duRSqud/E=
X-Google-Smtp-Source: AKy350bkZwf6iqswzqpXMmSEia/rGJP1PvbA0fR+8KeG+QddbiCmajg1LYcnnv02jdpb/PT8S/FGbQ==
X-Received: by 2002:a17:907:320c:b0:947:5acb:920c with SMTP id xg12-20020a170907320c00b009475acb920cmr13903488ejb.34.1680448702344;
        Sun, 02 Apr 2023 08:18:22 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id l20-20020a17090612d400b00947740a4373sm3301782ejb.81.2023.04.02.08.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 08:18:22 -0700 (PDT)
Message-ID: <f47ac853-a413-1cf7-15d8-2e4400740510@gmail.com>
Date:   Sun, 2 Apr 2023 17:16:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: [PATCH net-next v2 6/7] net: phy: smsc: add support for edpd tunable
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

This adds support for the EDPD PHY tunable.
Per default EDPD is disabled in interrupt mode, the tunable can be used
to override this, e.g. if the link partner doesn't use EDPD.
The interval to check for energy can be chosen between 1000ms and
2000ms. Note that this value consists of the 1000ms phylib interval
for state machine runs plus the time to wait for energy being detected.

v2:
- consider that phylib core holds phydev->lock when calling the
  phy tunable hooks

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c  | 75 +++++++++++++++++++++++++++++++++++++++++
 include/linux/smscphy.h |  4 +++
 2 files changed, 79 insertions(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 659a3ab10..0eba69ad5 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -34,6 +34,8 @@
 #define SPECIAL_CTRL_STS_AMDIX_STATE_	0x2000
 
 #define EDPD_MAX_WAIT_DFLT_MS		640
+/* interval between phylib state machine runs in ms */
+#define PHY_STATE_MACH_MS		1000
 
 struct smsc_hw_stat {
 	const char *string;
@@ -295,6 +297,79 @@ static void smsc_get_stats(struct phy_device *phydev,
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
+
+	if (!priv)
+		return -EOPNOTSUPP;
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
+		edpd = PHY_STATE_MACH_MS + EDPD_MAX_WAIT_DFLT_MS;
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
+	return smsc_phy_config_edpd(phydev);
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


