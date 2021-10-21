Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768874359C9
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 06:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhJUEXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 00:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhJUEXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 00:23:39 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B5CC06161C;
        Wed, 20 Oct 2021 21:21:24 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 75so24451363pga.3;
        Wed, 20 Oct 2021 21:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ixyQzkQdtxqQ6hHIEMwuveqXMEXtj9NSrqCEivXnv/M=;
        b=kVMAcYR6AnNnH/EjHl0xcj438bVkUnh2oY2fVADdxZibvLXDAU8OyVbZr17fIyMYX7
         bk8LVrhzxvAFJ7x5uk3aJsTZuj26WTYaSRBpsyB/8rhkpvSZwYKAlIbNt4cEbg7Z88Vt
         tePKB1zP4/o7pAYFMfix3YhBhYevlXwtQDNW1A284UHJivZ9SpGdJTTEe24EVFcGpNQL
         nFmWzQLkwkCK9Pu1o0ivRq9SG+6vnBJD8WurUvPYkpQKGvJ+VFrsfBIROG6j2oqKRD9e
         DsQ4rgJo5ASD0YkWTzpel/Xscfwooo5FUe54zELZ1ZHDmgY/qJ8hu/R+LnixDMerxx6p
         Dl4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ixyQzkQdtxqQ6hHIEMwuveqXMEXtj9NSrqCEivXnv/M=;
        b=QS+f4EGSpqaTKueCBk7vjlGKDEA7ovdcFloYab7Tjzzd2Siw1IdtOQmgI3YPAOmjBx
         ZdqIwQggaicVIOadTTSWXzALyHUwuu8zBU70/6KNMMoyLA0tPeM4GCWCtWtTM2i+5VFF
         6FZbqW6QnUZR1N74b8qrhn4IQY9uyvm8p8xELUNjTmhWkhcufAZpy5D2sLMzjy2WY0l3
         Xz3DCGkbYYFPKlTET0jlMaMSYJjO4u8VPZLVSx54SxZIROLIy0abQTdwTvCtH48mOaQD
         OUD2DBPS+KSLOoXsj1wbCM/smT3AOfbFSvwIWhLGfN8THkKU5t3aVgvlOTfHPpkeZ6xC
         pSSg==
X-Gm-Message-State: AOAM530sKXvvlTe4uzJ+bBG1do6bqoJ/Op04nKdX9gWUc/swPHWJ4bGP
        VilO3NgCzIrmyGvELsctPTI=
X-Google-Smtp-Source: ABdhPJwninnSG0sCMFKy/mHB052ptxksM/hUwORSt5r6li6VVGMHfcdU+QyOfvBv45vLgwq5UPAA2w==
X-Received: by 2002:a63:2b81:: with SMTP id r123mr2546500pgr.91.1634790083836;
        Wed, 20 Oct 2021 21:21:23 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id x30sm4258833pfj.219.2021.10.20.21.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 21:21:23 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH V2] rtw89: fix error function parameter
Date:   Thu, 21 Oct 2021 04:20:35 +0000
Message-Id: <20211021042035.1042463-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <3e121f8f6dd4411eace22a7030824ce4@realtek.com>
References: <3e121f8f6dd4411eace22a7030824ce4@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

This patch fixes the following Coccinelle warning:
drivers/net/wireless/realtek/rtw89/rtw8852a.c:753:
WARNING  possible condition with no effect (if == else)

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 drivers/net/wireless/realtek/rtw89/rtw8852a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852a.c b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
index b1b87f0aadbb..5c6ffca3a324 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
@@ -757,7 +757,7 @@ static void rtw8852a_ctrl_ch(struct rtw89_dev *rtwdev, u8 central_ch,
 		else
 			rtw89_phy_write32_idx(rtwdev, R_P1_MODE,
 					      B_P1_MODE_SEL,
-					      1, phy_idx);
+					      0, phy_idx);
 		/* SCO compensate FC setting */
 		sco_comp = rtw8852a_sco_mapping(central_ch);
 		rtw89_phy_write32_idx(rtwdev, R_FC0_BW, B_FC0_BW_INV,
-- 
2.25.1

