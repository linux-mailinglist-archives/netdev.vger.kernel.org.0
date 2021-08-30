Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3303FBE95
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 23:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238817AbhH3Vxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 17:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238788AbhH3Vxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 17:53:49 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DDEC061764
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 14:52:55 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id c8so21616720lfi.3
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 14:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eSR/6/R7THpAwy4A0msHNf8bOj6o29f7fnPgnd1UmSA=;
        b=Q5CoBlQGxUdAsvYfNoHkrmajhg5mM9w5XCJpwllThzBGYrNFRvYtGCUEbGf9jv2ht+
         QrkgMx1HHLuxPd7c0DOGSrHz8Z3eGBsBxHsGY4TzHQZ0wuc7faubhxO5AqTz70deVD5I
         V/1dBx5Gi14cZl99W9lLniM0Li76NKuErnTDdbJ3fN7MbalpVdzbNL3ePNgsDZCiV0cH
         VktoVeMZLQNeH98W2Im1njJWNPAQWYIKLcuJXIVU4sOeC7RHH+R5stXD6fUjVgQhkMCK
         44EOuCFpEVQvPyL7v6S+qwNXsf8NthF50OJkh3wd48lh3a3arCycWWkn3UeaxZ5Fg3f/
         TsJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eSR/6/R7THpAwy4A0msHNf8bOj6o29f7fnPgnd1UmSA=;
        b=HvGaPlLCYo0MOUtX7J+6fwpMZex32mwWyLP0njnE06OYWyC8ufXnFrvR6gpVojeONi
         3Gj3NpzuZjLhHGgtWKv43zcRzr3CFAO2XX9b3X+V2c7YxaJiaDl2uqDq9KKRzUVcN+M4
         JzaR7OQfk4ima9LRAhtAtoGRe3Mzmzg5xKm/cjUbYnoOcUZtixPBpnB6uPw/7GBbnpQT
         TAR62HfsGtgKHn/UmtEZ/QftRtNdfJ7QbIsBzCkHdd1uwFGfIgX5CtgiOKzep8YvCOME
         PnMABwWPzr1VJHhQpxSKhjykKt8gevRubwumORV0lcwhhM6QnHqWGphLYyV3ahRUQcjs
         SyPw==
X-Gm-Message-State: AOAM5313PRrZu6uuC4hm+BEGofneNim7H7MeimannoV0XO0Iv/2NTWi2
        nIDQeeBecZhsFCuK/In7HQkOqw==
X-Google-Smtp-Source: ABdhPJx7BixVA946QLOaPULbqWzMOG7q6NLae45EG1vngjwnOzjXiwA/t5JBhbBKaSOTEt8PvtWHFg==
X-Received: by 2002:a05:6512:318e:: with SMTP id i14mr6075790lfe.444.1630360373551;
        Mon, 30 Aug 2021 14:52:53 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id h4sm1514049lft.184.2021.08.30.14.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 14:52:53 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next 4/5 v2] net: dsa: rtl8366rb: Support flood control
Date:   Mon, 30 Aug 2021 23:48:58 +0200
Message-Id: <20210830214859.403100-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210830214859.403100-1-linus.walleij@linaro.org>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have implemented bridge flag handling we can easily
support flood (storm) control as well so let's do it.

Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- New patch
---
 drivers/net/dsa/rtl8366rb.c | 38 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index 2cadd3e57e8b..4cb0e336ce6b 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -149,6 +149,11 @@
 
 #define RTL8366RB_VLAN_INGRESS_CTRL2_REG	0x037f
 
+#define RTL8366RB_STORM_BC_CTRL			0x03e0
+#define RTL8366RB_STORM_MC_CTRL			0x03e1
+#define RTL8366RB_STORM_UNDA_CTRL		0x03e2
+#define RTL8366RB_STORM_UNMC_CTRL		0x03e3
+
 /* LED control registers */
 #define RTL8366RB_LED_BLINKRATE_REG		0x0430
 #define RTL8366RB_LED_BLINKRATE_MASK		0x0007
@@ -1158,7 +1163,8 @@ rtl8366rb_port_pre_bridge_flags(struct dsa_switch *ds, int port,
 				struct netlink_ext_ack *extack)
 {
 	/* We support enabling/disabling learning */
-	if (flags.mask & ~(BR_LEARNING))
+	if (flags.mask & ~(BR_LEARNING | BR_BCAST_FLOOD |
+                           BR_MCAST_FLOOD | BR_FLOOD))
 		return -EINVAL;
 
 	return 0;
@@ -1180,6 +1186,36 @@ rtl8366rb_port_bridge_flags(struct dsa_switch *ds, int port,
 			return ret;
 	}
 
+	if (flags.mask & BR_BCAST_FLOOD) {
+		ret = regmap_update_bits(smi->map, RTL8366RB_STORM_BC_CTRL,
+					 BIT(port),
+					 (flags.val & BR_BCAST_FLOOD) ? BIT(port) : 0);
+		if (ret)
+			return ret;
+	}
+
+	if (flags.mask & BR_MCAST_FLOOD) {
+		ret = regmap_update_bits(smi->map, RTL8366RB_STORM_MC_CTRL,
+					 BIT(port),
+					 (flags.val & BR_MCAST_FLOOD) ? BIT(port) : 0);
+		if (ret)
+			return ret;
+	}
+
+	/* Enable/disable both types of unicast floods */
+	if (flags.mask & BR_FLOOD) {
+		ret = regmap_update_bits(smi->map, RTL8366RB_STORM_UNDA_CTRL,
+					 BIT(port),
+					 (flags.val & BR_FLOOD) ? BIT(port) : 0);
+		if (ret)
+			return ret;
+		ret = regmap_update_bits(smi->map, RTL8366RB_STORM_UNMC_CTRL,
+					 BIT(port),
+					 (flags.val & BR_FLOOD) ? BIT(port) : 0);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
-- 
2.31.1

