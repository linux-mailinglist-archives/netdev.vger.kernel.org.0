Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296E53C99D3
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 09:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237190AbhGOHrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 03:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbhGOHry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 03:47:54 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0ABEC06175F;
        Thu, 15 Jul 2021 00:45:00 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id l11so3221093pji.5;
        Thu, 15 Jul 2021 00:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3H3QucrgEfBfWLW7Yv3LB8AXp4eWdNO8XfGBK/bcpzE=;
        b=CMNeH5VmJGRqAXS/AvAllS3PqwdjoJbxCRmngkrH41hiVpIManVkJBv7RzRIotc59k
         UTiQk01o1Ic4WFKMZorhktNbKXCe/RgI5C7WDFV300wVa7yxbcedja4CPygOHIheCvM6
         hVCPn2fo2hZCwLcbnVc871DLrvZy6yjyRE+TbgRbB8FlM0ObnDMKpr950yYASMuFv5+/
         j0Lep5ydcdJ+C3PMJFs7z93zxrhFjBV1iGWmRWWwGxDfOnAQM0/qL21LfMqkIcwQicbr
         Djwwz/9T8zAIJmkm4McKSDWH+sbPRxopa2mHXF0k1VsOqglInOPmVHFhW7Fto1pkFCcE
         hlVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3H3QucrgEfBfWLW7Yv3LB8AXp4eWdNO8XfGBK/bcpzE=;
        b=CxfMOZoV9b1THVqqM5pfPPDeG1MwGFvFYThgoKWKznyLDC4+TO+JbG4cpNYFdrPBKw
         WFsLjV9KtfgaCUjS4/2pMFzo9b15okjKTZrSnBZchSyKfnd2E7fABCIRLl9KF0YcfSIj
         zugYJIRTB9zdEWVClaeWPVbF9yYaWQC9l2sYlG7x9TtBvXovGjK35bkk5p/VaU4d2mV/
         IZLYNuLc1GZtq69EAiqs5WmOYPqCy/pZkxDGQtl9/hpq+FViCRDDUH2pM/pfyVnqoI8g
         BrF+YKFpg6VyMAlq/6Qvj2b528up2JODaXWwE7nMO/9Ed26N9TmaFJJ5IPke4WLZwxug
         xZOw==
X-Gm-Message-State: AOAM531I3kurpZkECdgODR7O9//B8ynF89XO8oYOCjCW9DRPcQtXl+Up
        em0lv+OMU73tlUarVi4m3Yg0Sq25oNU=
X-Google-Smtp-Source: ABdhPJxawBhQnz9L11JWFp/HWmMhtlszU/lv3a9P8s3WIDjJRh1wyfft9iOylxGvQ4wocpArZJC9KA==
X-Received: by 2002:a17:90b:1244:: with SMTP id gx4mr3067652pjb.192.1626335100159;
        Thu, 15 Jul 2021 00:45:00 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id t26sm5702039pgu.35.2021.07.15.00.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 00:44:59 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: zhang.yunkai@zte.com.cn
To:     davem@davemloft.net
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Zhang Yunkai <zhang.yunkai@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] net:stmmac: Fix the unsigned expression compared with zero
Date:   Thu, 15 Jul 2021 00:45:39 -0700
Message-Id: <20210715074539.226600-1-zhang.yunkai@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Yunkai <zhang.yunkai@zte.com.cn>

WARNING:  Unsigned expression "queue" compared with zero.
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7b8404a21544..a4cf2c640531 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1699,7 +1699,7 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 	return 0;
 
 err_init_rx_buffers:
-	while (queue >= 0) {
+	do {
 		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
 
 		if (rx_q->xsk_pool)
@@ -1710,11 +1710,7 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 		rx_q->buf_alloc_num = 0;
 		rx_q->xsk_pool = NULL;
 
-		if (queue == 0)
-			break;
-
-		queue--;
-	}
+	} while (queue--);
 
 	return ret;
 }
-- 
2.25.1

