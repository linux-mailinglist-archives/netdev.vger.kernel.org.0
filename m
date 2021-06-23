Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B0F3B20D8
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 21:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhFWTQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 15:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWTQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 15:16:50 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7ADC061574;
        Wed, 23 Jun 2021 12:14:32 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id j4so5892071lfc.8;
        Wed, 23 Jun 2021 12:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vCA9UxJ+EMCBunFdIzfCgcc8cOVFYGFyGgIL+e4eYGc=;
        b=UzNhGzf3APIIvFvjJsrVV26jL1WdkAkoAwzH5J+sxCyYYAY8XvjzLBKarHlYSgEW+H
         ROakHkkCfn70i7JTu+yHbCUbnkuPf7TkqgAOUJt1d0Ms8qGccgWOFHX7YAWXLuxF4qZl
         U/XbtVMPj5nLRPkZKpRykEAA6jKBoO5kEXNfZAlVD+EWR1Led/Uz5YOVeudBbQyx3X57
         OurvlnmzdOoSny+LJAPPAbww4QTxM0W6d/VHRAR8uiuhK1xGiMG1A94AOKVZJSkD5qPj
         0bbbGsEAChYON9jaMET8xnLxvZDByABYXkAbL4e6Wq3VBH9HdfNQcUsTU0Os2aMchm45
         AXkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vCA9UxJ+EMCBunFdIzfCgcc8cOVFYGFyGgIL+e4eYGc=;
        b=CKSGAoC5Pne2c1+Z7TYaz2ETAhWVDJzuHBvF4qt4K+V9wdQTXtJdAZNy8eU2ShOdOx
         52AaOzbAgTTHr7rhAE6ovMExacva4RNDa+CnIwq857JzmCJit84zc/J21XY/LY+YQhas
         9TTH2LKM98ZJZgVQonzP03h6ndothNXtMECA+AVrNulr+l2sLqnDt5JXRyuXWnItCQED
         lvxLOnXL7VqdzP0beeafWfYkua6kF/1LxMV7hSka+gAdqLIAbIz1a/HSDRyfd6LdjmIC
         vMMbdUTpNjBZgse9xUrfVnmm5WIV9wRnt3z6J6Wr2ePZUq2F+0VRrd4YoH5R082o1/h1
         wJlQ==
X-Gm-Message-State: AOAM533CPsEMfRKrC1YdLR44TZoS0oapic6eHuZYGopxEs94RkIe4VH+
        2IVBAc6T9w7B37lmgvADWB7gXeuHhw4UmA==
X-Google-Smtp-Source: ABdhPJwEryE5nA4/ztCF+DQUY46j/ZZB0JCfX0QWNYwk/Gjoy0mw/XvPRg1ombAoJ9/Rq/4JX1XHwg==
X-Received: by 2002:a05:6512:b26:: with SMTP id w38mr859979lfu.227.1624475670940;
        Wed, 23 Jun 2021 12:14:30 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id w4sm79724lfr.282.2021.06.23.12.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 12:14:30 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net, chunkeey@gmail.com
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH] net: ath10: add missing ret initialization
Date:   Wed, 23 Jun 2021 22:14:26 +0300
Message-Id: <20210623191426.13648-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of not supported chip the code jump
to the error handling path, but _ret_ will be set to 0.
Returning 0 from probe means, that ->probe() succeeded, but
it's not true when chip is not supported.

Fixes: f8914a14623a ("ath10k: restore QCA9880-AR1A (v1) detection")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index e7fde635e0ee..36ea8debd1c7 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3697,11 +3697,15 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	}
 
 	bus_params.chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
-	if (bus_params.chip_id == 0xffffffff)
+	if (bus_params.chip_id == 0xffffffff) {
+		ret = -ENODEV;
 		goto err_unsupported;
+	}
 
-	if (!ath10k_pci_chip_is_supported(pdev->device, bus_params.chip_id))
+	if (!ath10k_pci_chip_is_supported(pdev->device, bus_params.chip_id)) {
+		ret = -ENODEV;
 		goto err_free_irq;
+	}
 
 	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
-- 
2.32.0

