Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5FB4FE71F
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358268AbiDLRfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358184AbiDLRfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:35:37 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BE460A93
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:33:17 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id bv19so15728053ejb.6
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BOCNcCHoaIr0UXliwrJtAEwwXS/NvvZL8YTtuwi1Q8I=;
        b=iHELwmNmfRPmhT2mcePy8V126zUYxP288c4x/DaVpxBd+Ia45EgELwIgJJlFrCUkPv
         1OCBHmkPchCgI7QYJV9s4SsJvqY0RQtXUvJL367LXF9NXdI5/b42hFMpW/iU0jxz+eNV
         zBx14NzL6aPnYAu9YiOxitFQVwJ3xl6wtM/jU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BOCNcCHoaIr0UXliwrJtAEwwXS/NvvZL8YTtuwi1Q8I=;
        b=elBENa4tifR2vHI3O6DRCV9Xb9gtHr+vAyd/tQ4ZB7jZURUKmuPk23zy4fJn5WBAKI
         ylzvkUV9ShDay8SLysssCRYxIpROLu5WRmGcia8xiv6YadRUtljIa2CSi9oRG7HlpIex
         1hX+b9h8JRj3zKhVCmDdOX+cjaMC1aosT3cofU4TRye5eAqIMH7YbmqDjNLQJnePvCYj
         576DBpWvdpYkEr+NfvsCF0nyQ1hXBD3Rt6O+MIvhMf+KO2JSBE2URLWXjGvXp4MRYniE
         B9sSRPOUK/t/RbSWktWqhjlYb2igEPwOILFwYtMFOqHognTLU2ZvuebE2hb35qNevhv3
         YmXw==
X-Gm-Message-State: AOAM531k5xsqRjVM1wQmcypPxtOF1nvUVOJSTagZXQgOFuUNUkrxlXqG
        Eo8ixKIU3QT7UgPq3mWNhRglXVpoD84V/1eR
X-Google-Smtp-Source: ABdhPJwCtPsuDTZv3XuWBYconHvJf5mN0jA4xePfXqMg/VNm92xTiBzJMxj6pVzB9PE/o9gmCPJYsw==
X-Received: by 2002:a17:907:2bf4:b0:6e8:93d4:46e9 with SMTP id gv52-20020a1709072bf400b006e893d446e9mr10052342ejc.69.1649784795512;
        Tue, 12 Apr 2022 10:33:15 -0700 (PDT)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id o3-20020aa7dd43000000b00419db53ae65sm56142edw.7.2022.04.12.10.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 10:33:15 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH stable 5.16+ 1/3] net: dsa: realtek: allow subdrivers to externally lock regmap
Date:   Tue, 12 Apr 2022 19:32:50 +0200
Message-Id: <20220412173253.2247196-2-alvin@pqrs.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412173253.2247196-1-alvin@pqrs.dk>
References: <20220412173253.2247196-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

[ Upstream commit 907e772f6f6debb610ea28298ab57b31019a4edb ]

Currently there is no way for Realtek DSA subdrivers to serialize
consecutive regmap accesses. In preparation for a bugfix relating to
indirect PHY register access - which involves a series of regmap
reads and writes - add a facility for subdrivers to serialize their
regmap access.

Specifically, a mutex is added to the driver private data structure and
the standard regmap is initialized with custom lock/unlock ops which use
this mutex. Then, a "nolock" variant of the regmap is added, which is
functionally equivalent to the existing regmap except that regmap
locking is disabled. Functions that wish to serialize a sequence of
regmap accesses may then lock the newly introduced driver-owned mutex
before using the nolock regmap.

Doing things this way means that subdriver code that doesn't care about
serialized register access - i.e. the vast majority of code - needn't
worry about synchronizing register access with an external lock: it can
just continue to use the original regmap.

Another advantage of this design is that, while regmaps with locking
disabled do not expose a debugfs interface for obvious reasons, there
still exists the original regmap which does expose this interface. This
interface remains safe to use even combined with driver codepaths that
use the nolock regmap, because said codepaths will use the same mutex
to synchronize access.

With respect to disadvantages, it can be argued that having
near-duplicate regmaps is confusing. However, the naming is rather
explicit, and examples will abound.

Finally, while we are at it, rename realtek_smi_mdio_regmap_config to
realtek_smi_regmap_config. This makes it consistent with the naming
realtek_mdio_regmap_config in realtek-mdio.c.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[alsi: backport to 5.16: s/priv/smi/g and remove realtek-mdio changes]
Cc: stable@vger.kernel.org # v5.16+
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek/realtek-smi-core.c | 48 ++++++++++++++++++++--
 drivers/net/dsa/realtek/realtek-smi-core.h |  2 +
 2 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek-smi-core.c b/drivers/net/dsa/realtek/realtek-smi-core.c
index c66ebd0ee217..129ddee41928 100644
--- a/drivers/net/dsa/realtek/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek/realtek-smi-core.c
@@ -315,7 +315,21 @@ static int realtek_smi_read(void *ctx, u32 reg, u32 *val)
 	return realtek_smi_read_reg(smi, reg, val);
 }
 
-static const struct regmap_config realtek_smi_mdio_regmap_config = {
+static void realtek_smi_lock(void *ctx)
+{
+	struct realtek_smi *smi = ctx;
+
+	mutex_lock(&smi->map_lock);
+}
+
+static void realtek_smi_unlock(void *ctx)
+{
+	struct realtek_smi *smi = ctx;
+
+	mutex_unlock(&smi->map_lock);
+}
+
+static const struct regmap_config realtek_smi_regmap_config = {
 	.reg_bits = 10, /* A4..A0 R4..R0 */
 	.val_bits = 16,
 	.reg_stride = 1,
@@ -325,6 +339,21 @@ static const struct regmap_config realtek_smi_mdio_regmap_config = {
 	.reg_read = realtek_smi_read,
 	.reg_write = realtek_smi_write,
 	.cache_type = REGCACHE_NONE,
+	.lock = realtek_smi_lock,
+	.unlock = realtek_smi_unlock,
+};
+
+static const struct regmap_config realtek_smi_nolock_regmap_config = {
+	.reg_bits = 10, /* A4..A0 R4..R0 */
+	.val_bits = 16,
+	.reg_stride = 1,
+	/* PHY regs are at 0x8000 */
+	.max_register = 0xffff,
+	.reg_format_endian = REGMAP_ENDIAN_BIG,
+	.reg_read = realtek_smi_read,
+	.reg_write = realtek_smi_write,
+	.cache_type = REGCACHE_NONE,
+	.disable_locking = true,
 };
 
 static int realtek_smi_mdio_read(struct mii_bus *bus, int addr, int regnum)
@@ -388,6 +417,7 @@ static int realtek_smi_probe(struct platform_device *pdev)
 	const struct realtek_smi_variant *var;
 	struct device *dev = &pdev->dev;
 	struct realtek_smi *smi;
+	struct regmap_config rc;
 	struct device_node *np;
 	int ret;
 
@@ -398,14 +428,26 @@ static int realtek_smi_probe(struct platform_device *pdev)
 	if (!smi)
 		return -ENOMEM;
 	smi->chip_data = (void *)smi + sizeof(*smi);
-	smi->map = devm_regmap_init(dev, NULL, smi,
-				    &realtek_smi_mdio_regmap_config);
+
+	mutex_init(&smi->map_lock);
+
+	rc = realtek_smi_regmap_config;
+	rc.lock_arg = smi;
+	smi->map = devm_regmap_init(dev, NULL, smi, &rc);
 	if (IS_ERR(smi->map)) {
 		ret = PTR_ERR(smi->map);
 		dev_err(dev, "regmap init failed: %d\n", ret);
 		return ret;
 	}
 
+	rc = realtek_smi_nolock_regmap_config;
+	smi->map_nolock = devm_regmap_init(dev, NULL, smi, &rc);
+	if (IS_ERR(smi->map_nolock)) {
+		ret = PTR_ERR(smi->map_nolock);
+		dev_err(dev, "regmap init failed: %d\n", ret);
+		return ret;
+	}
+
 	/* Link forward and backward */
 	smi->dev = dev;
 	smi->clk_delay = var->clk_delay;
diff --git a/drivers/net/dsa/realtek/realtek-smi-core.h b/drivers/net/dsa/realtek/realtek-smi-core.h
index faed387d8db3..5fcad51e1984 100644
--- a/drivers/net/dsa/realtek/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek/realtek-smi-core.h
@@ -49,6 +49,8 @@ struct realtek_smi {
 	struct gpio_desc	*mdc;
 	struct gpio_desc	*mdio;
 	struct regmap		*map;
+	struct regmap		*map_nolock;
+	struct mutex		map_lock;
 	struct mii_bus		*slave_mii_bus;
 
 	unsigned int		clk_delay;
-- 
2.35.1

