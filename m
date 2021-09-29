Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D1B41CDC7
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 23:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346169AbhI2VIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 17:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345622AbhI2VIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 17:08:40 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD716C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:06:58 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id e15so16197817lfr.10
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A16Q8X6j77E5oCaHJ/vqDItQyNAq42o/Cp5ylsoL1I4=;
        b=DeGSG/1vfgJbP0xompUzNaZBarbudv2K8owGvX3esH6MrLY4O2EZd9wCqlJrLD/lR7
         KxgjmuLOtExkySp4Hq3anjlzkJcoXzzz1+0iS78kFG1CaLA87DgD3ZVTSzTC3zFSsImS
         JZjvNQ50ZaBxE14bN8vryLwJp0BDJL8VyYpmjm/H89DfcTy+/VJFTQDYyxCmof4lHtcr
         GQNoNykQKSape0ANuRxWtWv8Z5aa/p34N2HivCmMKC09cZbSTw4+lsZBHNWHnyvdoriM
         SxqRgPvVr0/55ih8dlpbzYFsiL5n5sqn66DlQvYsU08kzjlo0WHRy0/PDJVfXgwK6zEN
         sBoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A16Q8X6j77E5oCaHJ/vqDItQyNAq42o/Cp5ylsoL1I4=;
        b=nPgZz7XPTrB3PQqBAkXeqZEYkKiZW2y7Yoju873Zto1L3pTr4HhpgON909JmBNV1IF
         vZKh/YM0qfIYGXPRLdizbJz+UKeMtQn/9xj/5EUgO6YHQ4AUQz6oJcDpLbWTMh7+5nPf
         e49Vrrotp2fGMf6rVGaYBJ2pTbDU2zYrynV0oTFOQn4w/TFZgQ+PqtMiRcTsXbcgGFF3
         DfFbozTFjnHijDF4RQaDrumVVGnlUJuUfEACHL27OnASfgaUg04cwGowyBrlm/xWY0gq
         O3n2Jy59RqM7aeNXXIwxucnXDS2nMt/E9TTxdO2BsiSBOgVLFfGSeNHfJKBoCR56u5sK
         9s7g==
X-Gm-Message-State: AOAM532O6t53L9U5cn5OGHK6TFpFj4qFi0aPTbJgOlTJPLz/H4Q+43j4
        AaGUMb8JSXJUTEcPTDPDoZg5aQ==
X-Google-Smtp-Source: ABdhPJxg1EPQ8G4NpBKTNLQ9bcHz6Qu4HUGYoS3eYpRhIFTlyI1dHhcNa5yAja3fUEkReBEpLdpj/A==
X-Received: by 2002:a2e:b890:: with SMTP id r16mr2140243ljp.157.1632949617083;
        Wed, 29 Sep 2021 14:06:57 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id s9sm112613lfp.291.2021.09.29.14.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 14:06:56 -0700 (PDT)
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
Subject: [PATCH net-next 2/4 v4] net: dsa: rtl8366rb: Support flood control
Date:   Wed, 29 Sep 2021 23:03:47 +0200
Message-Id: <20210929210349.130099-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929210349.130099-1-linus.walleij@linaro.org>
References: <20210929210349.130099-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have implemented bridge flag handling we can easily
support flood control as well so let's do it.

Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v3->v4:
- No changes, rebased on the other patches.
ChangeLog v2->v3:
- Move the UNMC under the multicast setting as it is related to
  multicast to unknown address.
- Add some more registers from the API, unfortunately we don't
  know how to make use of them.
- Use tabs for indentation in copypaste bug.
- Since we don't know how to make the elaborate storm control
  work just mention flood control in the message.
ChangeLog v1->v2:
- New patch
---
 drivers/net/dsa/rtl8366rb.c | 55 +++++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index b3056064b937..52e750ea790e 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -164,6 +164,26 @@
  */
 #define RTL8366RB_VLAN_INGRESS_CTRL2_REG	0x037f
 
+/* Storm registers are for flood control
+ *
+ * 02e2 and 02e3 are defined in the header for the RTL8366RB API
+ * but there are no usage examples. The implementation only activates
+ * the filter per port in the CTRL registers.
+ */
+#define RTL8366RB_STORM_FILTERING_1_REG		0x02e2
+#define RTL8366RB_STORM_FILTERING_PERIOD_BIT	BIT(0)
+#define RTL8366RB_STORM_FILTERING_PERIOD_MSK	GENMASK(1, 0)
+#define RTL8366RB_STORM_FILTERING_COUNT_BIT	BIT(1)
+#define RTL8366RB_STORM_FILTERING_COUNT_MSK	GENMASK(3, 2)
+#define RTL8366RB_STORM_FILTERING_BC_BIT	BIT(5)
+#define RTL8366RB_STORM_FILTERING_2_REG		0x02e3
+#define RTL8366RB_STORM_FILTERING_MC_BIT	BIT(0)
+#define RTL8366RB_STORM_FILTERING_UNDA_BIT	BIT(5)
+#define RTL8366RB_STORM_BC_CTRL			0x03e0
+#define RTL8366RB_STORM_MC_CTRL			0x03e1
+#define RTL8366RB_STORM_UNDA_CTRL		0x03e2
+#define RTL8366RB_STORM_UNMC_CTRL		0x03e3
+
 /* LED control registers */
 #define RTL8366RB_LED_BLINKRATE_REG		0x0430
 #define RTL8366RB_LED_BLINKRATE_MASK		0x0007
@@ -1282,8 +1302,8 @@ rtl8366rb_port_pre_bridge_flags(struct dsa_switch *ds, int port,
 				struct switchdev_brport_flags flags,
 				struct netlink_ext_ack *extack)
 {
-	/* We support enabling/disabling learning */
-	if (flags.mask & ~(BR_LEARNING))
+	if (flags.mask & ~(BR_LEARNING | BR_BCAST_FLOOD |
+			   BR_MCAST_FLOOD | BR_FLOOD))
 		return -EINVAL;
 
 	return 0;
@@ -1305,6 +1325,37 @@ rtl8366rb_port_bridge_flags(struct dsa_switch *ds, int port,
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
+		/* UNMC = Unknown multicast address */
+		ret = regmap_update_bits(smi->map, RTL8366RB_STORM_UNMC_CTRL,
+					 BIT(port),
+					 (flags.val & BR_FLOOD) ? BIT(port) : 0);
+		if (ret)
+			return ret;
+	}
+
+	if (flags.mask & BR_FLOOD) {
+		/* UNDA = Unknown destination address */
+		ret = regmap_update_bits(smi->map, RTL8366RB_STORM_UNDA_CTRL,
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

