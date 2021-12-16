Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD8A476B95
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 09:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhLPINR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 03:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbhLPINO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 03:13:14 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8174BC061757
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 00:13:14 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v16so6657528pjn.1
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 00:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jORfXqfkT+AmZwZbRfSXnEcMFi32raPXjjq42kYwqXI=;
        b=NyROb5UHfKELvGtaH6JLzZaZrCWR3OMKtVGLIxq1lNesb0I41GMDyDf2xYUtRSXr2R
         8yiOvH7A98JR/I4q1RHTK6tZUn9g84Xik+VxwxNi0+Jc2lz/gw0sgYfpaEZnVDwjvMkN
         iNemcrUv461reOylEuEZE/9u+8Svs9axsMQfm7mOayD1DUClXtF1zAtHWnSyK6Y6TJZl
         S7z07C6mEh9GqE6HNXbkqpxA0u5AZLNPihKqJNN09JBg8QUlZ7FFHntvwWx2kAlxOE9B
         XYkFIPve9HjA+6dbUlQzMnK3anVFI056k31Zgh6wsOUYjF7T3VRduqIqpqN/ptcCetha
         3qpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jORfXqfkT+AmZwZbRfSXnEcMFi32raPXjjq42kYwqXI=;
        b=KyiQI06iKP/c7rsYl+rSTBZgYUSfbGkgs45lv4ozTKZN002q+ZQTi9p0E8jrDd3Xy4
         B4SpY8BhBtVOnw3P17GVGISn5FgXQo19KitG1gBwAqhemkGO9WuNzfiCX8zO2VhEhexp
         uXMFYmlYbRYf4yBf4r8TrvWx99oK1wxM8IB/ZdBx5vrbGPL7klQSomG1XCTDvjSrv5H+
         eHDuZmvI10FjAz5twQjn0r5q+uOWCFnMkYxvXtboA5An9Jk71gyzDOXbsilbpH9x179M
         7UjSQ/7qae2ffRMiurUcDjr+M0Q8HQ+OIemeJdRy5/fBUZ8tVo0s7oH396Cu+LTnQz1C
         cI/Q==
X-Gm-Message-State: AOAM530WfKaMPHBXJlZjzAFsEP6I0d3K5U1ExOzGEa7ZEfFwiNKOp0Ek
        OTZ3HtGyQRhIZ3/1QDOwdXXw
X-Google-Smtp-Source: ABdhPJxSBZxpt9vbJSz9OgvxQmS/MXnfDD2CMsEYXXlEenw0R6KqhonP8LmYH/RF56yror/Md0arcw==
X-Received: by 2002:a17:902:d885:b0:148:a2e8:2c55 with SMTP id b5-20020a170902d88500b00148a2e82c55mr8633167plz.164.1639642394010;
        Thu, 16 Dec 2021 00:13:14 -0800 (PST)
Received: from localhost.localdomain ([117.193.208.121])
        by smtp.gmail.com with ESMTPSA id u38sm326835pfg.4.2021.12.16.00.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 00:13:13 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     mhi@lists.linux.dev, hemantk@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, thomas.perrot@bootlin.com,
        aleksander@aleksander.es, slark_xiao@163.com,
        christophe.jaillet@wanadoo.fr, keescook@chromium.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 05/10] bus: mhi: pci_generic: Simplify code and axe the use of a deprecated API
Date:   Thu, 16 Dec 2021 13:42:22 +0530
Message-Id: <20211216081227.237749-6-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211216081227.237749-1-manivannan.sadhasivam@linaro.org>
References: <20211216081227.237749-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

The wrappers in include/linux/pci-dma-compat.h should go away.

Replace 'pci_set_dma_mask/pci_set_consistent_dma_mask' by an equivalent
and less verbose 'dma_set_mask_and_coherent()' call.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/bb3dc436fe142309a2334549db782c5ebb80a2be.1625718497.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/pci_generic.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 4f72bbcc53c9..9ef41354237c 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -532,18 +532,12 @@ static int mhi_pci_claim(struct mhi_controller *mhi_cntrl,
 	mhi_cntrl->regs = pcim_iomap_table(pdev)[bar_num];
 	mhi_cntrl->reg_len = pci_resource_len(pdev, bar_num);
 
-	err = pci_set_dma_mask(pdev, dma_mask);
+	err = dma_set_mask_and_coherent(&pdev->dev, dma_mask);
 	if (err) {
 		dev_err(&pdev->dev, "Cannot set proper DMA mask\n");
 		return err;
 	}
 
-	err = pci_set_consistent_dma_mask(pdev, dma_mask);
-	if (err) {
-		dev_err(&pdev->dev, "set consistent dma mask failed\n");
-		return err;
-	}
-
 	pci_set_master(pdev);
 
 	return 0;
-- 
2.25.1

