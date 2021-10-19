Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12985432C75
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhJSDzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhJSDza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 23:55:30 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41ADC06161C;
        Mon, 18 Oct 2021 20:53:18 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id r2so18114244pgl.10;
        Mon, 18 Oct 2021 20:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nLKHdxjenXc/vGWlsDwIHfarXTTE576FfBwh4suJRZ8=;
        b=ggYvlu/6JUj+j7zTeBcacchHSZY/gHE2bBfq7PcnUs9jrgdnfHlr58paOcz0XsiE0P
         bZRRGNEkH9RBoA+rAnEAHAmQsnhBQyRshAFhm5DlOBulb+dHqa/wXPBrxzv/CRs96W9k
         cAljblOrK5wtgL6rvwHJdw5D5LC7LRJcSQM+WRevMf9rrfVpUjHNLHwjSJdTcsfjhkkX
         qIs8wFfBVM88DCWCgriF43shAU+5AwAS66q/ldXWFB+PulwvmDptAHN+dtp+yykk50Oy
         jl3IMu84BdxXiheHr98KYMFbyNCHBWlUyRNtMReiv86YQfp/CKwBjKiU0OG66kxeDNlC
         rnmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nLKHdxjenXc/vGWlsDwIHfarXTTE576FfBwh4suJRZ8=;
        b=7dgpkYXXQ7VpdpRWY9cyV5F1KpUhhvhj7oR8WHuZ/qq6603+shqRpPljyTw4PLWXU4
         tiOXpnBmaMp/U5Dtwk4GoTPFY/4B5brFCqFDYuk16HzOocYhm2Lh1ulgl/5x9R2RirsY
         mATkVk7p5coM6TQN0BQPYo2xuW8g4Y38odYaF1KA0yntrFVOFoUHqSesRgD2IStUQsA3
         KJLpdMH2I6PNay7UgzPMabPONYOX5/7A3CvfxXO3GLjQOal5j7dRNgqecTlu/9VxWaiw
         9m/zvEb0Aam7E4e807hmwot+AeqJa8k32orl1/A7wcAG1voyIj0aED34U/rJALZqVw24
         wUrQ==
X-Gm-Message-State: AOAM533OGcEgb9KXl/UfJCL2EQo7Yar4DAzXRSDaa4f9wOzUCM4xCW5l
        pnUACrDw61py0qYIpYIuo+o=
X-Google-Smtp-Source: ABdhPJy7ZqqFzjB9xqwYofAac7Cr+3E5PxDcvrZNb7aopwMIbp12o7NYLuRc/JSQ/aviAGMSfFdunQ==
X-Received: by 2002:a63:3548:: with SMTP id c69mr26931312pga.111.1634615598325;
        Mon, 18 Oct 2021 20:53:18 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id x31sm14486186pfu.40.2021.10.18.20.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 20:53:17 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     kvalo@codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, pkshih@realtek.com,
        lv.ruyi@zte.com.cn, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] rtw89: fix error function parameter
Date:   Tue, 19 Oct 2021 03:53:11 +0000
Message-Id: <20211019035311.974706-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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
@@ -753,11 +753,11 @@ static void rtw8852a_ctrl_ch(struct rtw89_dev *rtwdev, u8 central_ch,
                if (is_2g)
                        rtw89_phy_write32_idx(rtwdev, R_P1_MODE,
                                              B_P1_MODE_SEL,
                                              1, phy_idx);
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

