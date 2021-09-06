Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CDE4016E9
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 09:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240069AbhIFHWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 03:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240077AbhIFHWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 03:22:19 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813FBC061575;
        Mon,  6 Sep 2021 00:21:14 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id i13so3718539pjv.5;
        Mon, 06 Sep 2021 00:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZIcr/6ZRbqQH3X7ecU0Oevl/GBI2TnFrWp3BjerTV2Y=;
        b=AsMDmlxdiu9IuKWP2c08amvI+a9DnAABdiJxgrfxdTs3xg454ApRz5tVIgXiajwRzT
         2cUeMxseKavGtZeHfTe+Hqy1LNcpigQc4s9InO0Z3IK99Vc2NlYvWoavee6b+cyHRuqj
         5aZbJZKx8Bq8RqRP6rlHunDAwDcFKzimwrGoXXBkBJOa3TeiuqdKVpUr2L4LSSEx3b4B
         q25Gvfs4yoyLVIwwfiSpFJ6z83mxqmaW4NL0WPX7j1/gnz8m3bFKct8ZuSzW8UIQHmim
         Y+xWedbuyR6Xjqe/+YzDFrU719MElgFiObJRV0uxku3y8K7zFQwppY4xqQxnqECs7DWP
         /buw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZIcr/6ZRbqQH3X7ecU0Oevl/GBI2TnFrWp3BjerTV2Y=;
        b=LPrGfbKiwZy0quFRITWF/SEggzNYtGwTfjGr7DfrY3JtpRDJs29ggnjjhmyAJO9tFg
         LuacBOXBiRgQO/QLMDkJM+isE1EtdxA1v+1QBVYQ5+ksnx5+uDWH7ird7Qcpk8cZOiB7
         OatUtK9vTysbf/8w16t7dOzeL2RAVidsSJ2aY+CBcvfI298FXmGVWtZICXtR8EHicptq
         w42MeM4VesJFpFoWHOvU/t5BmTdvlWmoZFU4hTuAAR4sQZ5qY0XWM+Tbs9kmsHiypqUH
         xmqr6HmDSiSbK22hwYiITOmjN3fuutLNWLCYiO6TK30yxuiu6c+4p1aJ7Q09MqH02cJd
         I9kA==
X-Gm-Message-State: AOAM532bhRPt46KVFoP3EwvbG5zj/VuBNkcxcpUlWnPgEbA4YdLuAnnN
        XXvLq5W4eSJKrYYoB4AL+VI=
X-Google-Smtp-Source: ABdhPJxaJzOu+ptHoWdAA1Zn4x5+cq67cLhzW32kK8JTeRlGIurgTODd4I4W91q9Oabq+DvRwmKxMA==
X-Received: by 2002:a17:90b:4d09:: with SMTP id mw9mr11117532pjb.71.1630912873988;
        Mon, 06 Sep 2021 00:21:13 -0700 (PDT)
Received: from localhost.localdomain ([111.207.172.18])
        by smtp.gmail.com with ESMTPSA id w11sm7890885pgf.5.2021.09.06.00.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 00:21:13 -0700 (PDT)
From:   zhaoxiao <long870912@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhaoxiao <long870912@gmail.com>
Subject: [PATCH] stmmac: dwmac-loongson:Fix missing return value
Date:   Mon,  6 Sep 2021 15:21:07 +0800
Message-Id: <20210906072107.10906-1-long870912@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the return value when phy_mode < 0.

Signed-off-by: zhaoxiao <long870912@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index 4c9a37dd0d3f..ecf759ee1c9f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -109,8 +109,10 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 		plat->bus_id = pci_dev_id(pdev);
 
 	phy_mode = device_get_phy_mode(&pdev->dev);
-	if (phy_mode < 0)
+	if (phy_mode < 0) {
 		dev_err(&pdev->dev, "phy_mode not found\n");
+		return phy_mode;
+	}
 
 	plat->phy_interface = phy_mode;
 	plat->interface = PHY_INTERFACE_MODE_GMII;
-- 
2.20.1

