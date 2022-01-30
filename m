Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DFD4A3ABA
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 23:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356651AbiA3WhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 17:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbiA3WhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 17:37:18 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFBFC061714;
        Sun, 30 Jan 2022 14:37:17 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id l12-20020a7bc34c000000b003467c58cbdfso12416367wmj.2;
        Sun, 30 Jan 2022 14:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LiwpBu4M08AZnkMwgpYj1EoWqXR0OVGxhENJRrnFA6A=;
        b=FoEuO3+a0JfsU4DDr4PRQHApw0lvIXm+BoXe2F9lzcHY/eHsSYCYu+SRhOiTLeD6Sm
         T5azkNJuUMmP4yPuUIRHINMDKjAuUHdMXz468ydpTeOEfjVLjeykwBtK5oo73aUNrfIV
         xqZ2Ysqpy34MlhLH97C35dlNwky+y96Un9uMekx59oDPOTVjo3euL4vEnWAGLjZd3YHa
         vf5ZkQ0Q2mfZ/DVZ4zcBbvddWWkEpmC8/129arGxufifDSNfp754OwYcKBRdLMnmHtLq
         XosU4Rg5Fht+HhkxUnqMWsTZ7no8y0KVKHyjilmYpu7Mnl+Ig1mTpjoomf9jFnHgKxrj
         729w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LiwpBu4M08AZnkMwgpYj1EoWqXR0OVGxhENJRrnFA6A=;
        b=2f3EzMRzkD12HmlWEz4d8X9G1tcE4ZKmsf6tpqxgE0+MDdkDyTuD6p722E+W2mZ22R
         8jDelzAQGvNA10usMDnuGjF4ElFsxnk4N7YaGYTWgoZuC0dKsOv83LBc81dXj+Q69X6W
         2Of+stZCHC2SJmeWVSqjUAUEUYnxuFK7lUQ4Kzrg5g77OgR3+3o3iTlxvg7UnreLtKsU
         9kY0MwM0aPFYS1b10PyaMNGTjNEDwJ7cf3gN40wPg30KN/NBEA8qb8TRybZmaS50h4+3
         QXKk4RCymOBXTEVbnrDTruG1qz0qM7XkaYkt45JM0z3eXXDAvAgM/mD4FmverMa7HXu7
         OYLQ==
X-Gm-Message-State: AOAM533StdTLHzn5IdcEaXBrg8a+s/vw1/jWzZ6UBcaJpDmnV50Z/jAV
        4QX7w5TQXmvKodZBfUbZ1aI=
X-Google-Smtp-Source: ABdhPJwc51UUcKSTBqdxRNwwWogSb6LyzW3Y+WwT70s6utiqC4KvLngvlItXv9qrp8UziP34m+Ep1Q==
X-Received: by 2002:a05:600c:3d0c:: with SMTP id bh12mr25432131wmb.179.1643582235624;
        Sun, 30 Jan 2022 14:37:15 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id e9sm3576034wrg.60.2022.01.30.14.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 14:37:15 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: remove redundant initialization of variable ul_encalgo
Date:   Sun, 30 Jan 2022 22:37:14 +0000
Message-Id: <20220130223714.6999-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable ul_encalgo is initialized with a value that is never read,
it is being re-assigned a new value in every case in the following
switch statement. The initialization is redundant and can be removed.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/cam.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/cam.c b/drivers/net/wireless/realtek/rtlwifi/cam.c
index 7a0355dc6bab..32970ea4b4e7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/cam.c
+++ b/drivers/net/wireless/realtek/rtlwifi/cam.c
@@ -208,7 +208,7 @@ void rtl_cam_empty_entry(struct ieee80211_hw *hw, u8 uc_index)
 
 	u32 ul_command;
 	u32 ul_content;
-	u32 ul_encalgo = rtlpriv->cfg->maps[SEC_CAM_AES];
+	u32 ul_encalgo;
 	u8 entry_i;
 
 	switch (rtlpriv->sec.pairwise_enc_algorithm) {
-- 
2.34.1

