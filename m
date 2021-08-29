Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB01A3FABAD
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 15:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbhH2NOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 09:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235550AbhH2NON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 09:14:13 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FA5C0612E7
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 06:13:21 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id g13so25234921lfj.12
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 06:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V1qCDwrnxZyyxD18n557PC/vv86td/OsZqjd5RQRW8E=;
        b=jdppaH2W155GXBSpK9HAC3zcOJOHlIf4pWlevT2rBJaK2K4RL+tfztI/UYo+hW4cPu
         0zCBlJzfpZvZj5m49gAwW6XfSPo+3ZkEpXYllog2PoKxHmBFWhLtG8Dn9SbQIwAHybEc
         veVLg9MOR1ETsT8FRVvJsnXX3ycN6piz2/RRZPfzd7VtITuX8/MCDHPs4EWcU8GKlDcV
         s0kPsKiT32JfX+QUOuxxOqCGgHG13Oe/BqgWg6sR611svTU2nBGGnU8oZFHMfpblERBX
         gM/UYdNj5mANmoAj5JXOMPo4p4426dnQEYXtW3pOafe0PvMn5iNnRorLXgzf56ZUBPJ0
         WJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V1qCDwrnxZyyxD18n557PC/vv86td/OsZqjd5RQRW8E=;
        b=fFd8zuN08beyRGhVtRg1NRf7jyM/+E4ReloxqtYCF5vrlmZIlx5BTF7xWZh7nzEpso
         NOaMKTgLdA2T636Ous1kdrI/AzKaNs2DVS7lrHz8o9ezSorlYkaatkNLSvF9dxcI5U+6
         oFSHx0DFMJ5WfGoG3uBtIP37lNJpogtRIchMj41S54efaqdlzC84OkH3Qq0M0Kzj48eD
         TyBhW1II5XvyOxekjwB8kS3s/0/HxYlpzPpybuflVW4/oI7C74JtSTvFhFzBV9xPnbYU
         ljjnz8/KwlcVlrWZD3LdBqA1WX+KAQVdgnyKEeEJP6me975x5R7e2lYRBLNnmHTLXFJz
         SoBg==
X-Gm-Message-State: AOAM532Pt2TnrQDQv48OQJ6orn6pgJWD/BEmvjg4jlmGFyQm8XD5ste0
        4x3C8QXjewSyqXo0dfCVG2AydA==
X-Google-Smtp-Source: ABdhPJyKjcg8TLay1deazFXUMwoYdOraqQvWUGRZSJPo25xL40sIUpHM/gyv+ASdRt7Jol3tqtKlQQ==
X-Received: by 2002:a05:6512:e99:: with SMTP id bi25mr13658144lfb.486.1630242799230;
        Sun, 29 Aug 2021 06:13:19 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id x13sm712503lfq.262.2021.08.29.06.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 06:13:18 -0700 (PDT)
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC v2 12/13] WIP: PCI: qcom: use pwrseq to power up bus devices
Date:   Sun, 29 Aug 2021 16:13:04 +0300
Message-Id: <20210829131305.534417-13-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210829131305.534417-1-dmitry.baryshkov@linaro.org>
References: <20210829131305.534417-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use bus-pwrseq device tree node to power up the devices on the bus. This
is to be rewritten with the proper code parsing the device tree and
powering up individual devices.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 8a7a300163e5..a60d41fbcd6f 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -23,6 +23,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/platform_device.h>
 #include <linux/phy/phy.h>
+#include <linux/pwrseq/consumer.h>
 #include <linux/regulator/consumer.h>
 #include <linux/reset.h>
 #include <linux/slab.h>
@@ -1467,6 +1468,7 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 	struct pcie_port *pp;
 	struct dw_pcie *pci;
 	struct qcom_pcie *pcie;
+	struct pwrseq *pwrseq;
 	int ret;
 
 	pcie = devm_kzalloc(dev, sizeof(*pcie), GFP_KERNEL);
@@ -1520,6 +1522,17 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 
 	pp->ops = &qcom_pcie_dw_ops;
 
+	pwrseq = devm_pwrseq_get_optional(dev, "bus");
+	if (IS_ERR(pwrseq)) {
+		ret = PTR_ERR(pwrseq);
+		goto err_pm_runtime_put;
+	}
+	if (pwrseq) {
+		ret = pwrseq_full_power_on(pwrseq);
+		if (ret)
+			goto err_pm_runtime_put;
+	}
+
 	ret = phy_init(pcie->phy);
 	if (ret) {
 		pm_runtime_disable(&pdev->dev);
-- 
2.33.0

