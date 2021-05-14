Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576F638124D
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbhENVCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhENVBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:45 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8893FC061756;
        Fri, 14 May 2021 14:00:29 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id l7so80446edb.1;
        Fri, 14 May 2021 14:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2uJO2aO8VGq4uIw0TCHk6HQMIpt50sRO38SxfxJU7NU=;
        b=NzSd8+Ts2MFXhw5Dq+TR+o0yi/Vo4bXQCMnFv9BwLc6WJcZE4w81PXGU8bw96JQ15c
         Ltu3rtpEBZHkLVa7vjQp25n9BWlUrGN4AXvY50WRLSQE1EQYoLFfBa5LNo9sefmW4iBe
         vlzBIHe/xAXTQMR56gCQu7ITDS/uTZq3NpSzzqVB6LljJyOLAc6XWWPPUCra4TqDVBNs
         vSg33qmQ3Z0OQXpDkeI34Ua5KvIwTv99pg6YCfRdbBdNw+X2iPPuAOnfUrZgVRc4Pm/T
         vIC61dnLgHyzikC3ZNFY4GBRZSFqx0v73uqi5inkwd0qYsGBhRRiYe5GG1qbdcsBvEwj
         D2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2uJO2aO8VGq4uIw0TCHk6HQMIpt50sRO38SxfxJU7NU=;
        b=Co3jEdoK8Mo3gT4z6siqjjkHf9V8W7RZqkgIMNJzSHXVHXnWcvrHLk0VvLj5NdWp5e
         3vwC9cQb4s/g5J+nCD7KymHaKogDMSqTfiSdvAE/Ef60nCuIywEEcXmlACnEVVN1+GeD
         Y5et3tW/Lqy92EVBJuosjOYBw55apS8M5R3RjpBtslV91TNLmQ0YN2Bxz21FnqW1hEPf
         S5WtxCywvf/t91dgi7ecsm2n9K07sCjpboYwuuJXkOauxwUisNHdsiQlJB5hZ4qBIZ9W
         x7FBNa07akMM7T3vqiDQE2neMBa/5pEy/fDoHqXB2CfhauHy1l1HyCNVXXOX92Bgev/o
         Xofw==
X-Gm-Message-State: AOAM531jkbia0yzfJakwdI64EZMrdCX4sZ7BXfhXTntMwD7CX+7fpxPs
        XK6+qmtAnqonboH9iwozaNs=
X-Google-Smtp-Source: ABdhPJytdzy51WCrRT0DMnj+YaNrqAp1FOlPdfjRtJcmMK4EUm5RU1E+Vwg021B2vzXg/Yn5htlZQw==
X-Received: by 2002:a05:6402:b2c:: with SMTP id bo12mr58592673edb.196.1621026028204;
        Fri, 14 May 2021 14:00:28 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:27 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 12/25] net: dsa: qca8k: limit port5 delay to qca8337
Date:   Fri, 14 May 2021 23:00:02 +0200
Message-Id: <20210514210015.18142-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Limit port5 rx delay to qca8337. This is taken from the legacy QSDK code
that limits the rx delay on port5 to only this particular switch version,
on other switch only the tx and rx delay for port0 are needed.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca8k.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 65f27d136aef..b598930190e1 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1003,8 +1003,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			    QCA8K_PORT_PAD_RGMII_EN |
 			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
 			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
-		qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
-			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
+		/* QCA8337 requires to set rgmii rx delay */
+		if (priv->switch_id == QCA8K_ID_QCA8337)
+			qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
+				    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_1000BASEX:
-- 
2.30.2

