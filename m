Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3674CE3E1
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 09:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiCEI7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 03:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiCEI7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 03:59:35 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA50D3BF;
        Sat,  5 Mar 2022 00:58:45 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id x15so15868819wru.13;
        Sat, 05 Mar 2022 00:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=SOx6GBoR3hk6Asho1tsO/KOxCoXLmE0mlhzsGo1SFqI=;
        b=phV5baG+I5sVlpNXWTolY5DZxNEIRbJoJZWWzGQh0EWngAjR/UpTVXyMpPEzfLroZC
         aERHd8cAI87ktK93Mz+9pV2SP4XW5TXjsFqbiMdMi0Vfv7NVlOq9SoiFHTGN+NbAKAC1
         EKsQZkbpAUixyB2Hm7z/JyWrBaqLgDtU1vfKsrtpNB8PqhUYTztJRY/OIOrGSbYiU/TB
         X+16aXF7rgaT3hEzr/Zi9M31u7v6Ob6HeAm6Y4aYos2OB3uNvvhi10awyYYjlTdQBnMK
         puqeWC5NjnVTPrbSRNqFov6W8Us3+/eU5B7xs1grPgN4g3cfoBfRO88hzYHUdD+COr45
         S4CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SOx6GBoR3hk6Asho1tsO/KOxCoXLmE0mlhzsGo1SFqI=;
        b=OfS+QnefLd2bS1lG5K+rtzw3mJc+WiJLh3om6j7rE1Bk2lCl2hwiVGgOv7AD9cFB0+
         4adcNx2dk00J7noVlwztPZys7uOTvMI6gejAcMpggoChPHrOtM1rNii+yXEIOtantWpq
         wk+1OgRvptOMA/krBVMP3HLRreIcg/d8IJQ4lyVuD4PBNcU7Fhp+1VzGmTLuNKoZcgFX
         nGUXdeVpjbrEyTPr7vrVaBDpnnpbDalffq1KqVD19LTB8VVrNoYDkYtKhgc5SjTaQOBq
         v8jJE5mXDiiq2RRTcUiNEpJDwl45UQ64PuKW92bD99lk8J/N7jZLEGTRsGX9sTB/0UKf
         sfgA==
X-Gm-Message-State: AOAM530wKqMj4O2B6TLNFqypuQRvLVVksPQjXWAcPq5upFtUf9bwabB1
        QmHLrKCdaBZii9cgn1UPKJL48QrxFXMiyA==
X-Google-Smtp-Source: ABdhPJz6afELVMrZQicO3jAt7+0KkM0rU23ldDJCoFz8kSn/AZcgpYYtS5Ib7fkbS7weYppRA3mv3w==
X-Received: by 2002:adf:8bd4:0:b0:1ed:c1f8:3473 with SMTP id w20-20020adf8bd4000000b001edc1f83473mr1879894wra.435.1646470724200;
        Sat, 05 Mar 2022 00:58:44 -0800 (PST)
Received: from localhost.localdomain ([64.64.123.48])
        by smtp.gmail.com with ESMTPSA id p12-20020a5d48cc000000b001e6114938a8sm6320131wrs.56.2022.03.05.00.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 00:58:43 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     isdn@linux-pingi.de, davem@davemloft.net, zou_wei@huawei.com,
        zheyuma97@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2] isdn: hfcpci: check the return value of dma_set_mask() in setup_hw()
Date:   Sat,  5 Mar 2022 00:58:16 -0800
Message-Id: <20220305085816.4659-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function dma_set_mask() in setup_hw() can fail, so its return value
should be checked.

Fixes: 1700fe1a10dc ("Add mISDN HFC PCI driver")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
v2:
* Correct the fixes tag.
  Thank Jakub for good advice.

---
 drivers/isdn/hardware/mISDN/hfcpci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index bd087cca1c1d..af17459c1a5c 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2005,7 +2005,11 @@ setup_hw(struct hfc_pci *hc)
 	}
 	/* Allocate memory for FIFOS */
 	/* the memory needs to be on a 32k boundary within the first 4G */
-	dma_set_mask(&hc->pdev->dev, 0xFFFF8000);
+	if (dma_set_mask(&hc->pdev->dev, 0xFFFF8000)) {
+		printk(KERN_WARNING
+		       "HFC-PCI: No usable DMA configuration!\n");
+		return -EIO;
+	}
 	buffer = dma_alloc_coherent(&hc->pdev->dev, 0x8000, &hc->hw.dmahandle,
 				    GFP_KERNEL);
 	/* We silently assume the address is okay if nonzero */
-- 
2.17.1

