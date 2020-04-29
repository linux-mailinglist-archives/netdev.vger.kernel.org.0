Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69DB1BE860
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgD2UR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbgD2URV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:17:21 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93764C035493;
        Wed, 29 Apr 2020 13:17:20 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id g13so4094287wrb.8;
        Wed, 29 Apr 2020 13:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3h1YUm9/diU16ZWjl6NvChhRtfF7E8PRZGhUvORG+lo=;
        b=rto3GJWZQoNgPlHueUkKcCqK3IdDgA7X1HGKQOWYfa+vuMVPy1RKmcr4eaUq+riF3a
         xlFniqSrHXGZF9y/33tP5hVCuVhcRS/vywrYUzdIzykRlTQdvDorM1o4YQ+61X9Y9Jpp
         bakGkz05rty4xhNrYmS3PG+e6LfFh1d/3G/9FWce2aBswflbZ27TJ2Sx6LQNV0InR5MA
         bAjqGdBDhpuyYosz+y02fxiGxrtOZO6GEnJXjUNl3holtvU1Eqs3i0wMTyKmKmjQfEGU
         ij+AV4RQcrTVzzsyS0fQwp3D+Hky94Wq6BSgmaTX3oG7YGcNzQhAjxFix9dgPkyaXE2V
         tE9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3h1YUm9/diU16ZWjl6NvChhRtfF7E8PRZGhUvORG+lo=;
        b=A4HkJK5nWRN0AjisEpXk+OQ53lSY0AyV3KTJFn5XDFYOmewOqlgMfYAU6Qv18I9nJh
         NW8e9YgCmclpwAsxpUN3riVd2LeVdBURRmZUIQYtfjwIyosqmJpfFSVRbV/Z6LVSWBw6
         N/eiKHaZFaKMmHmDifmT+U4+YmWbj/3Vvd+/v/i2p5Hy9nwbwnQABbkJzUOH/SFmekMe
         gtziVSrBOVkh1pW9Iouf/UJ0WsyMPJ2NIw3R5J0fDWq5G+I6qGUXw0ZW63cPJP9Nw3Xr
         MPm3XsWdzXossM5/Va14T8ROdhgwbIZ8ZrdTyJOwb5eJQpZA/6FUJTIN2R8hJqOv+V4/
         e6Sg==
X-Gm-Message-State: AGi0PuY8kR/yCgFROBpLtsTIq5N4FEg31lCqowx7BWfmeHyJJFaOtD+0
        JU612uTooMkKjsjRMDKtZY3JvA4J5Lc=
X-Google-Smtp-Source: APiQypI/ni8XFwYIHa0cewHD1MVfQDj2saKDUC5JGqEgPQrYhLr4ehS8ZLS8+x8E0cnvoqOaFTt7Fw==
X-Received: by 2002:a5d:42c7:: with SMTP id t7mr40611834wrr.336.1588191439216;
        Wed, 29 Apr 2020 13:17:19 -0700 (PDT)
Received: from localhost.localdomain (p200300F137142E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3714:2e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q143sm9923623wme.31.2020.04.29.13.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 13:17:18 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v2 06/11] net: stmmac: dwmac-meson8b: Fetch the "timing-adjustment" clock
Date:   Wed, 29 Apr 2020 22:16:39 +0200
Message-Id: <20200429201644.1144546-7-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PRG_ETHERNET registers have a built-in timing adjustment circuit
which can provide the RX delay in RGMII mode. This is driven by an
external (to this IP, but internal to the SoC) clock input. Fetch this
clock as optional (even though it's there on all supported SoCs) since
we just learned about it and existing .dtbs don't specify it.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 70075628c58e..41f3ef6bea66 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -85,6 +85,7 @@ struct meson8b_dwmac {
 	phy_interface_t			phy_mode;
 	struct clk			*rgmii_tx_clk;
 	u32				tx_delay_ns;
+	struct clk			*timing_adj_clk;
 };
 
 struct meson8b_dwmac_clk_configs {
@@ -380,6 +381,13 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 				 &dwmac->tx_delay_ns))
 		dwmac->tx_delay_ns = 2;
 
+	dwmac->timing_adj_clk = devm_clk_get_optional(dwmac->dev,
+						      "timing-adjustment");
+	if (IS_ERR(dwmac->timing_adj_clk)) {
+		ret = PTR_ERR(dwmac->timing_adj_clk);
+		goto err_remove_config_dt;
+	}
+
 	ret = meson8b_init_rgmii_tx_clk(dwmac);
 	if (ret)
 		goto err_remove_config_dt;
-- 
2.26.2

