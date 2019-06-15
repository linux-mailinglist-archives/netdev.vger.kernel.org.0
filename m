Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B414E46F72
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 12:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfFOKKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 06:10:02 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52077 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfFOKJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 06:09:48 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so4708884wma.1;
        Sat, 15 Jun 2019 03:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=21LzFx2Yc8y77IkHIvE2bMFa0+wAZqeT/XG4CmiYg9c=;
        b=Uci2wXZnDus0zk0ldy2dfk3d4aJr68Zw4QGrTtJh9KC/t6mdLM97KeoGnbhX0BDZp4
         mCtBky+GT+CCrAmPb6CQ3WtCzlRp7Bd9iwapxtrEqSZIR/E68kybbnIb+GcsDcnyzeeH
         zpwELa0AKEjwI8ChQ4ZuUIuhaHIGEs5H2TLn0aZu8bEJOjsIsyDtjaeXwJEqUfXieS7k
         At7tBj6NYhOwKcQm25Ft+x1l2BQgK16tOjck+Qnx/jf0ZDLLLhAtv6SgS5ylI0uDLeyA
         PHFr6f7aBVSaDPS6JmhjADnFyp7rJIq5as2BAIo+i/+7/I/A+y/gz9ebD91fo6lIx5x5
         XANQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=21LzFx2Yc8y77IkHIvE2bMFa0+wAZqeT/XG4CmiYg9c=;
        b=TUxvlN3kNTBdjErFm6V0fKQ7+l3ISPHuOJbDKpqHKyk6pk3czpHsFdTbT2bpS33bBn
         TXBdVN4BW5U0UoC+eyxH165+u8ICgeA5Vuem/56qer0r2TsO6mjomBQ8LRE8bD7oHghj
         f8Sn4SGaVh6tRG7DdeYrtRTiKymvUgJ4Uqwxe0l6S7ATgY7NumKrI40uUI05zMHzTFwg
         zFk0Optb/MQjGxSJnHOpTuR70c40auLhnXcLdVqcaAwXlBlQ57LOgRncKaJoxqMm8ASq
         pE7uGdz0OryBWnzm+ojegV1N/4c1K8fHuSuoW8auz8KKsCiGN6HMRNt9qlW3q3zrDXXS
         uAug==
X-Gm-Message-State: APjAAAWcKUA4oYb/vWzEpZ/ogrMu4KE9TyQ8ZUsufWMiCnWIZDhPoWsr
        EzLvW1kZG8e+R7vZLd0JQABtcIAaKBY=
X-Google-Smtp-Source: APXvYqzPm8dHyxHlzfDDjd2ma6Gj+6tSgX08AW5n9xYFU30GEctIRwfe1P7qrO8HGdN8b/koJ5+c5g==
X-Received: by 2002:a1c:cb43:: with SMTP id b64mr10850812wmg.135.1560593386042;
        Sat, 15 Jun 2019 03:09:46 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133C20E00A9A405DFDBBC0790.dip0.t-ipconnect.de. [2003:f1:33c2:e00:a9a4:5df:dbbc:790])
        by smtp.googlemail.com with ESMTPSA id f2sm9270513wrq.48.2019.06.15.03.09.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 03:09:45 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net
Cc:     linus.walleij@linaro.org, andrew@lunn.ch,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net-next v1 4/5] net: stmmac: drop the reset delays from struct stmmac_mdio_bus_data
Date:   Sat, 15 Jun 2019 12:09:31 +0200
Message-Id: <20190615100932.27101-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190615100932.27101-1-martin.blumenstingl@googlemail.com>
References: <20190615100932.27101-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only OF platforms use the reset delays and these delays are only read in
stmmac_mdio_reset(). Move them from struct stmmac_mdio_bus_data to a
stack variable inside stmmac_mdio_reset() because that's the only usage
of these delays.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 15 ++++++++-------
 include/linux/stmmac.h                            |  3 ---
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 459ef8afe4fb..c9454cf4f189 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -252,6 +252,7 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 #ifdef CONFIG_OF
 	if (priv->device->of_node) {
 		struct gpio_desc *reset_gpio;
+		u32 delays[3];
 
 		reset_gpio = devm_gpiod_get_optional(priv->device,
 						     "snps,reset",
@@ -261,18 +262,18 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 
 		device_property_read_u32_array(priv->device,
 					       "snps,reset-delays-us",
-					       data->delays, 3);
+					       delays, ARRAY_SIZE(delays));
 
-		if (data->delays[0])
-			msleep(DIV_ROUND_UP(data->delays[0], 1000));
+		if (delays[0])
+			msleep(DIV_ROUND_UP(delays[0], 1000));
 
 		gpiod_set_value_cansleep(reset_gpio, 1);
-		if (data->delays[1])
-			msleep(DIV_ROUND_UP(data->delays[1], 1000));
+		if (delays[1])
+			msleep(DIV_ROUND_UP(delays[1], 1000));
 
 		gpiod_set_value_cansleep(reset_gpio, 0);
-		if (data->delays[2])
-			msleep(DIV_ROUND_UP(data->delays[2], 1000));
+		if (delays[2])
+			msleep(DIV_ROUND_UP(delays[2], 1000));
 	}
 #endif
 
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index fe865df82e48..96d97c908595 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -96,9 +96,6 @@ struct stmmac_mdio_bus_data {
 	unsigned int phy_mask;
 	int *irqs;
 	int probed_phy_irq;
-#ifdef CONFIG_OF
-	u32 delays[3];
-#endif
 };
 
 struct stmmac_dma_cfg {
-- 
2.22.0

