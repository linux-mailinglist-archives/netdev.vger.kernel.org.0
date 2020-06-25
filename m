Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9A320A4C6
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 20:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403908AbgFYSV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 14:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405903AbgFYSVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 14:21:55 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30B6C08C5C1;
        Thu, 25 Jun 2020 11:21:54 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h15so6860080wrq.8;
        Thu, 25 Jun 2020 11:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1jwFq5S23vPzbNJSmrZrgIsKoZN4GTlh6PdOkISx7aY=;
        b=NyEtXQudR4pLxM9yltdxoOlvEPVNBsKan1eHHSiMxVaFZHIkU2d10gR6YakV88025l
         97ELYaLl7xj5OM8POW24GS6S7Q71A7qq/LydfsYJBPoljFJVjDGiu79rsfgl44maHeTv
         CYByd+paQbGFcLSZvt02AdCUMdpogSIKd0UECEDt2uL6WPEYIr8wyZWRyQE0oeYU5XLu
         D7IaQ7pzM53UrmKUedw8BY11vIw9CYn2xJ3zu8DSpD0K+BAoJzovG2YwumZesXjKMvHX
         nDQmvmZ1XzUuSQrPBpKk2+cXMxu2cr/Y6poqKQeNGsCeH78IV5CXvxVb6X+/dQuyZ3xZ
         lFwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1jwFq5S23vPzbNJSmrZrgIsKoZN4GTlh6PdOkISx7aY=;
        b=RF1Mnr2m+KsXQiEs7LmuSnTGEyAnn6NxRuqzB3tEILBp/i2hiBUOz5A5Qxd2hrDAZZ
         /DAeZRpxngeJ1IH1832uyv1B90tzpUVDITYyutpmyapdYxkvkGijF603X8bZXZFzGF5E
         zvk1fVFbSBRd50LdwyLt8Tj7e/hJyISWbwcBeKJ/W7ru0lj+XasZ+3WKZaCrJo9HxtLu
         9Wk9bcCcYWvjSLH/Z2lzx9OmE7VAJ6qD7W051TFB9SjeC/IgZnEmnNLmd6btSVi+m7fK
         TCvRX2v37O5eILJWNjWIaxTsj5G0WVwoSDCa6a5SsXzWgMixs/rqGa6Uv8a/u8CfEfYP
         8VhA==
X-Gm-Message-State: AOAM532ow0wMATXXFccQ/MNF7tJshhQfsyAZi9M0YUq2K8USc/mscEoK
        hQYnygtdXG2xGP0cKJuUZiRE/6wm
X-Google-Smtp-Source: ABdhPJxoWeHHa9uUOMDwo1O0nU3whkjZr5zI4DDFkqvZSjaKRhH1psS3keHtfjdJ2XPmlyFHlX+UxA==
X-Received: by 2002:a5d:6809:: with SMTP id w9mr40364931wru.182.1593109313476;
        Thu, 25 Jun 2020 11:21:53 -0700 (PDT)
Received: from localhost.localdomain (p200300f1370fee00428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:370f:ee00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id y6sm14312233wmy.0.2020.06.25.11.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 11:21:52 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jbrunet@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH] net: stmmac: dwmac-meson8b: use clk_parent_data for clock registration
Date:   Thu, 25 Jun 2020 20:21:42 +0200
Message-Id: <20200625182142.1673053-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify meson8b_init_rgmii_tx_clk() by using struct clk_parent_data to
initialize the clock parents. No functional changes intended.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   | 49 +++++++------------
 1 file changed, 17 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 544bc621146c..5afcf05bbf9c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -69,8 +69,6 @@
  */
 #define PRG_ETH0_ADJ_SKEW		GENMASK(24, 20)
 
-#define MUX_CLK_NUM_PARENTS		2
-
 struct meson8b_dwmac;
 
 struct meson8b_dwmac_data {
@@ -110,12 +108,12 @@ static void meson8b_dwmac_mask_bits(struct meson8b_dwmac *dwmac, u32 reg,
 
 static struct clk *meson8b_dwmac_register_clk(struct meson8b_dwmac *dwmac,
 					      const char *name_suffix,
-					      const char **parent_names,
+					      const struct clk_parent_data *parents,
 					      int num_parents,
 					      const struct clk_ops *ops,
 					      struct clk_hw *hw)
 {
-	struct clk_init_data init;
+	struct clk_init_data init = { };
 	char clk_name[32];
 
 	snprintf(clk_name, sizeof(clk_name), "%s#%s", dev_name(dwmac->dev),
@@ -124,7 +122,7 @@ static struct clk *meson8b_dwmac_register_clk(struct meson8b_dwmac *dwmac,
 	init.name = clk_name;
 	init.ops = ops;
 	init.flags = CLK_SET_RATE_PARENT;
-	init.parent_names = parent_names;
+	init.parent_data = parents;
 	init.num_parents = num_parents;
 
 	hw->init = &init;
@@ -134,11 +132,12 @@ static struct clk *meson8b_dwmac_register_clk(struct meson8b_dwmac *dwmac,
 
 static int meson8b_init_rgmii_tx_clk(struct meson8b_dwmac *dwmac)
 {
-	int i, ret;
 	struct clk *clk;
 	struct device *dev = dwmac->dev;
-	const char *parent_name, *mux_parent_names[MUX_CLK_NUM_PARENTS];
-	struct meson8b_dwmac_clk_configs *clk_configs;
+	static const struct clk_parent_data mux_parents[] = {
+		{ .fw_name = "clkin0", },
+		{ .fw_name = "clkin1", },
+	};
 	static const struct clk_div_table div_table[] = {
 		{ .div = 2, .val = 2, },
 		{ .div = 3, .val = 3, },
@@ -148,62 +147,48 @@ static int meson8b_init_rgmii_tx_clk(struct meson8b_dwmac *dwmac)
 		{ .div = 7, .val = 7, },
 		{ /* end of array */ }
 	};
+	struct meson8b_dwmac_clk_configs *clk_configs;
+	struct clk_parent_data parent_data = { };
 
 	clk_configs = devm_kzalloc(dev, sizeof(*clk_configs), GFP_KERNEL);
 	if (!clk_configs)
 		return -ENOMEM;
 
-	/* get the mux parents from DT */
-	for (i = 0; i < MUX_CLK_NUM_PARENTS; i++) {
-		char name[16];
-
-		snprintf(name, sizeof(name), "clkin%d", i);
-		clk = devm_clk_get(dev, name);
-		if (IS_ERR(clk)) {
-			ret = PTR_ERR(clk);
-			if (ret != -EPROBE_DEFER)
-				dev_err(dev, "Missing clock %s\n", name);
-			return ret;
-		}
-
-		mux_parent_names[i] = __clk_get_name(clk);
-	}
-
 	clk_configs->m250_mux.reg = dwmac->regs + PRG_ETH0;
 	clk_configs->m250_mux.shift = PRG_ETH0_CLK_M250_SEL_SHIFT;
 	clk_configs->m250_mux.mask = PRG_ETH0_CLK_M250_SEL_MASK;
-	clk = meson8b_dwmac_register_clk(dwmac, "m250_sel", mux_parent_names,
-					 MUX_CLK_NUM_PARENTS, &clk_mux_ops,
+	clk = meson8b_dwmac_register_clk(dwmac, "m250_sel", mux_parents,
+					 ARRAY_SIZE(mux_parents), &clk_mux_ops,
 					 &clk_configs->m250_mux.hw);
 	if (WARN_ON(IS_ERR(clk)))
 		return PTR_ERR(clk);
 
-	parent_name = __clk_get_name(clk);
+	parent_data.hw = &clk_configs->m250_mux.hw;
 	clk_configs->m250_div.reg = dwmac->regs + PRG_ETH0;
 	clk_configs->m250_div.shift = PRG_ETH0_CLK_M250_DIV_SHIFT;
 	clk_configs->m250_div.width = PRG_ETH0_CLK_M250_DIV_WIDTH;
 	clk_configs->m250_div.table = div_table;
 	clk_configs->m250_div.flags = CLK_DIVIDER_ALLOW_ZERO |
 				      CLK_DIVIDER_ROUND_CLOSEST;
-	clk = meson8b_dwmac_register_clk(dwmac, "m250_div", &parent_name, 1,
+	clk = meson8b_dwmac_register_clk(dwmac, "m250_div", &parent_data, 1,
 					 &clk_divider_ops,
 					 &clk_configs->m250_div.hw);
 	if (WARN_ON(IS_ERR(clk)))
 		return PTR_ERR(clk);
 
-	parent_name = __clk_get_name(clk);
+	parent_data.hw = &clk_configs->m250_div.hw;
 	clk_configs->fixed_div2.mult = 1;
 	clk_configs->fixed_div2.div = 2;
-	clk = meson8b_dwmac_register_clk(dwmac, "fixed_div2", &parent_name, 1,
+	clk = meson8b_dwmac_register_clk(dwmac, "fixed_div2", &parent_data, 1,
 					 &clk_fixed_factor_ops,
 					 &clk_configs->fixed_div2.hw);
 	if (WARN_ON(IS_ERR(clk)))
 		return PTR_ERR(clk);
 
-	parent_name = __clk_get_name(clk);
+	parent_data.hw = &clk_configs->fixed_div2.hw;
 	clk_configs->rgmii_tx_en.reg = dwmac->regs + PRG_ETH0;
 	clk_configs->rgmii_tx_en.bit_idx = PRG_ETH0_RGMII_TX_CLK_EN;
-	clk = meson8b_dwmac_register_clk(dwmac, "rgmii_tx_en", &parent_name, 1,
+	clk = meson8b_dwmac_register_clk(dwmac, "rgmii_tx_en", &parent_data, 1,
 					 &clk_gate_ops,
 					 &clk_configs->rgmii_tx_en.hw);
 	if (WARN_ON(IS_ERR(clk)))
-- 
2.27.0

