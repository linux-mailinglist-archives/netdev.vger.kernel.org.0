Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973AB39CE94
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 12:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhFFKcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 06:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhFFKcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 06:32:52 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F782C061766;
        Sun,  6 Jun 2021 03:30:50 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n17-20020a7bc5d10000b0290169edfadac9so10648105wmk.1;
        Sun, 06 Jun 2021 03:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ikXJBehZXFSB5UrJ89OaYAcJZ+kIUikwdL83ZPiK/5Y=;
        b=FexVLV1F67sJ8VtLdcDCHjf+oX3RM8/jbrZGl69yu70d1Po34D5B/Jrfh1Wc0B2bFk
         M/bjGeAgCvUCDukHX0G0Ip8Z+gWnW+VBd2brgbMSDZ+wyNLrbujmvHYprvmVbquWavfS
         K0HvIgpQay8mLct9xagtW/7c63fHjfbBmjsJYR9s3p+lPqPlC/bN7ZgEhqWjF+Bj+8F/
         TDom7Z+CS+qYtBchGiyn7gv/1Y3IHovBEmbSESqVqxiVehsOPrPamoIR9/ulqjfGIwL1
         Irl8Rh97DtGYaT7wwXLkONEx4EVAo7Jz+WacxiH5ptE2GOUMt/BmZFtMu/ayRnViDXa2
         7cZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ikXJBehZXFSB5UrJ89OaYAcJZ+kIUikwdL83ZPiK/5Y=;
        b=J+0Vx5/IGH5ZZx30CuxVlDT4o8RAvxPIdE/kZ5UQddkzJ2vFAnnJ1cQ6DauUCTnJ4K
         PbgKEeIpD8UDYa41gzxe5W8i2rBd2ylVEnWHXcnFwPzFFZwL027/wS8bZDR18Sqemf1C
         4f0+D/5jme8CrpqjmvwL3eLZw6FRLgBd4A8jTG04ztrRARCHf8cWLU9uUfVpgUOfSWQ1
         GzewXBgLkvruBxBIhoNeZgmWtK5ltHjFZR3cihzI6+FXuOMbFoaDhUrxW1XXzDI58wEo
         Rdg48JfSFEOvJemXfo4tY9IepyVQn7evk9Eyf5fc3HuKaqCVNiKWM/LE14x9dKsLSKAB
         bMOw==
X-Gm-Message-State: AOAM531FnG901QvT6oJLIXlsZuKa7DZNJk3cDllJEPKlCZ8vrX95fJrS
        4XJCeb1DJdV0sP0PJfnEGLeXjusVYmY=
X-Google-Smtp-Source: ABdhPJwWAiiWqtqihbUCZBiBb+hiCCGLYOEmHqUxvoIWanfLpsTPgU+VvFX0yTMsszDmE/6ByuoYAA==
X-Received: by 2002:a1c:ed03:: with SMTP id l3mr12198750wmh.130.1622975444995;
        Sun, 06 Jun 2021 03:30:44 -0700 (PDT)
Received: from cluster5 ([80.76.206.81])
        by smtp.gmail.com with ESMTPSA id s62sm13926536wms.13.2021.06.06.03.30.44
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sun, 06 Jun 2021 03:30:44 -0700 (PDT)
From:   Matthew Hagan <mnhagan88@gmail.com>
Cc:     bjorn.andersson@linaro.org, Matthew Hagan <mnhagan88@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: stmmac: explicitly deassert GMAC_AHB_RESET
Date:   Sun,  6 Jun 2021 11:30:13 +0100
Message-Id: <20210606103019.2807397-1-mnhagan88@gmail.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <3436f8f0-77dc-d4ff-4489-e9294c434a08@gmail.com>
References: <3436f8f0-77dc-d4ff-4489-e9294c434a08@gmail.com>
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

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 4 ++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 7 +++++++
 include/linux/stmmac.h                                | 1 +
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6d41dd6f9f7a..0d4cb423cbbd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6840,6 +6840,10 @@ int stmmac_dvr_probe(struct device *device,
 			reset_control_reset(priv->plat->stmmac_rst);
 	}
 
+	ret = reset_control_deassert(priv->plat->stmmac_ahb_rst);
+	if (ret == -ENOTSUPP)
+		dev_err(priv->device, "unable to bring out of ahb reset\n");
+
 	/* Init MAC and get the capabilities */
 	ret = stmmac_hw_init(priv);
 	if (ret)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 97a1fedcc9ac..a178181f6a24 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -600,6 +600,13 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 		goto error_hw_init;
 	}
 
+	plat->stmmac_ahb_rst = devm_reset_control_get_optional_shared(
+							&pdev->dev, "ahb");
+	if (IS_ERR(plat->stmmac_ahb_rst)) {
+		ret = PTR_ERR(plat->stmmac_ahb_rst);
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

