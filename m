Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B87325D95
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 07:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhBZGd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 01:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhBZGdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 01:33:17 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50EDC061574;
        Thu, 25 Feb 2021 22:32:36 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id e9so4780162plh.3;
        Thu, 25 Feb 2021 22:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NpdHCFtO3bIe52UEacMInES0+SrQ248CIIeiK4xDEUY=;
        b=d/TPMKkW0kBRd5/tm0Ztd3cdvVjKQvNroZzIVy1dAomZhSF8ugH3q17Io/56h9xWXW
         b38TNWMrrTD7BnuP+Ufa6LT0vihdf9qEOHAsx+jJze8JYdwvNISvQ6OvOEYG6NJr+rmX
         L4VsfAHhIh/f00HIpH2dlB8Di78mvRof7JZh4Xaq16FDCS8G+P4c2AOXQ8seCm7yZv9S
         LasWksJI/YFyejpNCeuX+isJPdAX3LJA3c5RtGaqPdgWjGr8fy+O3mKlW0XZxrCadM/6
         +ks2pj4Go0yd+aN2QYNZl9Hleq5bobCK4i/LznnCp8fYSbSCFxlAAKN8yIeQX7huT2/N
         gzIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NpdHCFtO3bIe52UEacMInES0+SrQ248CIIeiK4xDEUY=;
        b=rA6Bhg6svX/FfWP2zImG/k3W4vENE/jqf8SlMxW4F4QLUi2P0MEZ7a5VXXi4fqtpeP
         U8X2vD3XjjMPBsxHDK8chaLT4jr+YQmNNIqQS7mQKdCehiuApdGMYreDoLwdKzUOprSB
         8hWo5iJtcmrK/fKFDDomw5icJbv+kTqDbw5IjIEoqs6VwFUI4Y9zsPzNgMQ6MHvRQMK3
         PtzkLEVlbiWWB0CmxyibSWeutRLkD5+8HhAtHB4R1JmYqQANglNRRQnDPXc+BZ/FZuJy
         xqslZI0mcjguC+MTibkiGH9pz/NgBqmrHZ7HSWmCycLsIvq6/7KTV3fCvnQpihsON3rm
         w01g==
X-Gm-Message-State: AOAM530IT/B5/a8IVVWdDTVmpDV38e+hvWCiU5KKVJaCcKEhmV/S0lYz
        lxFMon0Vtbzco7mNTdee4Ho=
X-Google-Smtp-Source: ABdhPJwy4aE+bw9E/kOcYG6UVQypQ61Mae8c/cVEec5XMdphDpFdhMCVRI6SVHHNd1fNS5H71MTGCA==
X-Received: by 2002:a17:90a:7c0c:: with SMTP id v12mr1845484pjf.63.1614321156143;
        Thu, 25 Feb 2021 22:32:36 -0800 (PST)
Received: from container-ubuntu.lan ([171.211.28.221])
        by smtp.gmail.com with ESMTPSA id 134sm8491186pfc.113.2021.02.25.22.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 22:32:35 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Landen Chao <landen.chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: dsa: mt7530: don't build GPIO support if !GPIOLIB
Date:   Fri, 26 Feb 2021 14:32:26 +0800
Message-Id: <20210226063226.8474-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new GPIO support may be optional at runtime, but it requires
building against gpiolib:

ERROR: modpost: "gpiochip_get_data" [drivers/net/dsa/mt7530.ko]
undefined!
ERROR: modpost: "devm_gpiochip_add_data_with_key"
[drivers/net/dsa/mt7530.ko] undefined!

Add #ifdef to exclude GPIO support if GPIOLIB is not enabled.

Fixes: 429a0edeefd8 ("net: dsa: mt7530: MT7530 optional GPIO support")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index c17de2bcf2fe..f06f5fa2f898 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1624,6 +1624,7 @@ mtk_get_tag_protocol(struct dsa_switch *ds, int port,
 	}
 }
 
+#ifdef CONFIG_GPIOLIB
 static inline u32
 mt7530_gpio_to_bit(unsigned int offset)
 {
@@ -1726,6 +1727,7 @@ mt7530_setup_gpio(struct mt7530_priv *priv)
 
 	return devm_gpiochip_add_data(dev, gc, priv);
 }
+#endif /* CONFIG_GPIOLIB */
 
 static int
 mt7530_setup(struct dsa_switch *ds)
@@ -1868,11 +1870,13 @@ mt7530_setup(struct dsa_switch *ds)
 		}
 	}
 
+#ifdef CONFIG_GPIOLIB
 	if (of_property_read_bool(priv->dev->of_node, "gpio-controller")) {
 		ret = mt7530_setup_gpio(priv);
 		if (ret)
 			return ret;
 	}
+#endif /* CONFIG_GPIOLIB */
 
 	mt7530_setup_port5(ds, interface);
 
-- 
2.25.1

