Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB383A02E3
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbhFHTLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 15:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236094AbhFHTHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 15:07:23 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B25C06115D;
        Tue,  8 Jun 2021 12:00:22 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id a11so20850653wrt.13;
        Tue, 08 Jun 2021 12:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uip1vDK/GvnRP2tuA2PdZT2AGkszBhFjdDLQc1lrazM=;
        b=mf8PYe9ZlWYQkGj9Esq0zaqBLrYGXrlL7OK0dZhv9N/FndZxs7wgU3igPT77cNrUr3
         1hHAuupqcQPOZ65bCjec8GNwcvCBAoH70+lZMEh18nILeAOcurnAWEv/lOiGuoFQsd+f
         FV9EZ+OXdtwO2d9yWpYuoRQ8a2/qpuhzECfHklaKQFq1/xOv9NrLoLLgIfzZCvOyKdGP
         hxoEO2izfy4IUo3j0uak2ZgwxhWlyRYBronc1MGF/AL8C4AiO2F5blQbYP9ys5taO3By
         KJjPTF4Sk7Uc8vajajyh6Zt++0rLF/Ol7nY2dZqrKHEGbIkE8NITB/TWbcGwyDmIcEBd
         y1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uip1vDK/GvnRP2tuA2PdZT2AGkszBhFjdDLQc1lrazM=;
        b=G7HMCIB7fZQdoU7pO3yjJLfaGxPP5t0hHHqmYUE2rZS/pA2WluSYru82+XtH6DMu2S
         oRCkhO4XX1ICuQrElgZA+zlm6TGlBAHkkp0ZEPi7KjPpY24I5VeGQVI/k37qpQjsT+64
         XGwN+7xYVAoZMIrE1dLXIhJJ6cawu+wASbUHgWn4w8C6aUvGnwK4GuxdyhND3/LIr+Dg
         fQ/AVmE/+KAg3oQQwU4cvUD3JeEEdqjlKWerx6npIeGZhELvbxjlJUau95oqLxDVYpC6
         GtgNMY44bOvhsZR1qyiy2pvGjZkcR+64qn0XN7eEfwxuscij8J/yUaSYZ1ueZtOLgAcJ
         8LMA==
X-Gm-Message-State: AOAM531MqoqOQCoH/S+ROAFQHeGtBsIcwnzHJKNc3q399Da1lgry4KbH
        aDCYgcZmfPXc/c6R09PwjD42mVyEZvw=
X-Google-Smtp-Source: ABdhPJzgTgRj6uydfUPubkT+rZSonmvkQaAl/Ei9uKDeCamwzpyS7SlLHNhdsmHohhD0B9aWfnJ+qw==
X-Received: by 2002:adf:ff88:: with SMTP id j8mr24110899wrr.10.1623178821049;
        Tue, 08 Jun 2021 12:00:21 -0700 (PDT)
Received: from cluster5 ([80.76.206.81])
        by smtp.gmail.com with ESMTPSA id w13sm22560462wrc.31.2021.06.08.12.00.20
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Tue, 08 Jun 2021 12:00:20 -0700 (PDT)
From:   Matthew Hagan <mnhagan88@gmail.com>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Matthew Hagan <mnhagan88@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] net: stmmac: explicitly deassert GMAC_AHB_RESET
Date:   Tue,  8 Jun 2021 19:59:06 +0100
Message-Id: <20210608185913.3909878-1-mnhagan88@gmail.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210606103019.2807397-1-mnhagan88@gmail.com>
References: <20210606103019.2807397-1-mnhagan88@gmail.com>
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

v2 changes:
 - remove NULL condition check for stmmac_ahb_rst in stmmac_main.c
 - unwrap dev_err() message in stmmac_main.c
 - add PTR_ERR() around plat->stmmac_ahb_rst in stmmac_platform.c

v3 changes:
 - add error pointer to dev_err() output
 - add reset_control_assert(stmmac_ahb_rst) in stmmac_dvr_remove
 - revert PTR_ERR() around plat->stmmac_ahb_rst since this is performed
   on the returned value of ret by the calling function

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 6 ++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 7 +++++++
 include/linux/stmmac.h                                | 1 +
 3 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6d41dd6f9f7a..78dafde70671 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6840,6 +6840,11 @@ int stmmac_dvr_probe(struct device *device,
 			reset_control_reset(priv->plat->stmmac_rst);
 	}
 
+	ret = reset_control_deassert(priv->plat->stmmac_ahb_rst);
+	if (ret == -ENOTSUPP)
+		dev_err(priv->device, "unable to bring out of ahb reset: %pe\n",
+			ERR_PTR(ret));
+
 	/* Init MAC and get the capabilities */
 	ret = stmmac_hw_init(priv);
 	if (ret)
@@ -7072,6 +7077,7 @@ int stmmac_dvr_remove(struct device *dev)
 	phylink_destroy(priv->phylink);
 	if (priv->plat->stmmac_rst)
 		reset_control_assert(priv->plat->stmmac_rst);
+	reset_control_assert(priv->plat->stmmac_ahb_rst);
 	pm_runtime_put(dev);
 	pm_runtime_disable(dev);
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
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

