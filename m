Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF83C39CA44
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 19:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhFERno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 13:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbhFERnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 13:43:43 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDEBC061766;
        Sat,  5 Jun 2021 10:41:42 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id t16-20020a05600c1990b02901a0d45ff03aso6244604wmq.2;
        Sat, 05 Jun 2021 10:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=58S1Og3Gq6yFDBmvvvA786Kv3ZHM/KHp6+Nqv3S6XUY=;
        b=b5eJWGhJcXo5IFD5VMPLXDFJk6XICjvJsKi6fJPjDU0yt3+d23qtGnZtUb3UMREcHq
         zeLRKuHA2/4mX/1VJO+TIEfVadGQ2fEsXaEilGumOx/UGUyosGYn9evcumxaBDoJo4Su
         kcJCrW65I1EePaKe5uNGbDnKLCF9qyG2c3JJVUkfdGDwpZYwl1zUI0zI2YyhZFEJS8Py
         mP6GbeLyApeKPNr4W4DkjTshBVfP4fPMCWV4dzbMh1ib5NDd8Ol4yE8vmVgpO+aIs6m+
         mBOaaSP2QV0vsolS0IBJb3TSyEu6EPYgf18kMUU7y8XK622+Y/r9gwF300uyuz4ihbAv
         pYiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=58S1Og3Gq6yFDBmvvvA786Kv3ZHM/KHp6+Nqv3S6XUY=;
        b=qr4T2fClW0ln/oD+zLhrcRnA1pnPakenSoR9alUN8/U7eSf2QAg8w+hymGnO8b57bK
         Ln4jkF+zCzqNUPVIP6hjuGjwk1ZIBB1lEFVxbiMnyfn9hF3FWzjWDR8H75RGNbL2UZNS
         U0dK+xdC2oEupueY1PQQxLn5BaUUeqZWo2HoRlS3heVUBo5DwsJADzNPH9hmRvusMFFJ
         6HoHFFjFCOtqgpR8TslAYUz8r0+gZYyRfpOIEmMlOlVyWFFwj+rIA1sNT4Vu6bIves+r
         5NTWpTGU976kPSkHdgOU2/MIlp9gKeGqIxnUJhKLUKJBJC1wUjHSAf49xRL0kLXeB1ma
         twng==
X-Gm-Message-State: AOAM533js6FZV6fR39VvTKZQoRKlOXNvkmKRLfQ+e3CRfKc87JqEy8MH
        rghlxri1bbKR3avzBMX64kM=
X-Google-Smtp-Source: ABdhPJyiFCxRpIhc+P1d+WdBeVTCiCFPFUkUwjDbqSiPHq+lzi4KTMpPe8xwEp7BhyJd6VmUYckIpQ==
X-Received: by 2002:a05:600c:4ba1:: with SMTP id e33mr3183717wmp.39.1622914900861;
        Sat, 05 Jun 2021 10:41:40 -0700 (PDT)
Received: from cluster5 ([80.76.206.81])
        by smtp.gmail.com with ESMTPSA id c206sm12182512wmf.12.2021.06.05.10.41.40
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sat, 05 Jun 2021 10:41:40 -0700 (PDT)
From:   Matthew Hagan <mnhagan88@gmail.com>
Cc:     Matthew Hagan <mnhagan88@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        Fugang Duan <fugang.duan@nxp.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] net: stmmac: explicitly deassert GMAC_AHB_RESET
Date:   Sat,  5 Jun 2021 18:35:37 +0100
Message-Id: <20210605173546.4102455-1-mnhagan88@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are currently assuming that GMAC_AHB_RESET will already be deasserted
by the bootloader. However if this has not been done, probing of the GMAC
will fail. To remedy this we must ensure GMAC_AHB_RESET has been deasserted
prior to probing.

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 7 +++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 7 +++++++
 include/linux/stmmac.h                                | 1 +
 3 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6d41dd6f9f7a..1e28058b65a8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6840,6 +6840,13 @@ int stmmac_dvr_probe(struct device *device,
 			reset_control_reset(priv->plat->stmmac_rst);
 	}
 
+	if (priv->plat->stmmac_ahb_rst) {
+		ret = reset_control_deassert(priv->plat->stmmac_ahb_rst);
+		if (ret == -ENOTSUPP)
+			dev_err(priv->device,
+				"unable to bring out of ahb reset\n");
+	}
+
 	/* Init MAC and get the capabilities */
 	ret = stmmac_hw_init(priv);
 	if (ret)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 97a1fedcc9ac..d8ae58bdbbe3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -600,6 +600,13 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 		goto error_hw_init;
 	}
 
+	plat->stmmac_ahb_rst = devm_reset_control_get_optional_shared(
+							&pdev->dev, "ahb");
+	if (IS_ERR(plat->stmmac_ahb_rst)) {
+		ret = plat->stmmac_ahb_rst;
+		goto error_hw_init;
+	}
+
 	return plat;
 
 error_hw_init:
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index e55a4807e3ea..9b6a64f3e3dc 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -239,6 +239,7 @@ struct plat_stmmacenet_data {
 	unsigned int mult_fact_100ns;
 	s32 ptp_max_adj;
 	struct reset_control *stmmac_rst;
+	struct reset_control *stmmac_ahb_rst;
 	struct stmmac_axi *axi;
 	int has_gmac4;
 	bool has_sun8i;
-- 
2.26.3

