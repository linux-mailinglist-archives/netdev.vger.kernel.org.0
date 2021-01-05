Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE982EA8EC
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 11:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbhAEKgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 05:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbhAEKgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 05:36:00 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5983BC061574;
        Tue,  5 Jan 2021 02:35:20 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id n4so27749116iow.12;
        Tue, 05 Jan 2021 02:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=60AIUV4Jg1QdrWGAn445MgDZhFfwHKWY+s8i6/NBKBU=;
        b=jCV95JyANFiRlp6NDcE4707Vv5U1woOyRCb/FSUewRJhD3KRIGIoiEWAPJPZ2cem9e
         EMPVmFUKWkCW2wpJLCH7PywnmGUTAAD76N+ReMlG8ED8/8k8YJMFNR4k67jKZRBO4Q7A
         +VnmQgU1pCOoXfdx7EpMUmWQI5LGZPRr9pEQyE/92focAl2F/04tRklXDSk2gKbJm+/Z
         IIm593JUGDQeKhAyrQEWbb8oMFsfguUWCnYnVn5zai0Z6LmTfqOHqagjSgbp9PuBIV1q
         CzUHIyOauxK0CibgiyBg7Hn1iuBg/6wMbxKwXQWdnEsYnu97H426WVV7MZP7yOedm30o
         fc2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=60AIUV4Jg1QdrWGAn445MgDZhFfwHKWY+s8i6/NBKBU=;
        b=Iqzu5AB/RjmIiZfNvTtfs4c2HF8BJ+H5zHEXm0A2jgZ20qewRzWE4ChWsUpldh3Y5H
         AvbN6dM5IAVtanC8B+1Zx79BKNY2wJDzxgaS7TsSM3YuCTYIMe9FyZgaiVES5JuOvNqy
         /IDGO3HVB+DMVrcRbId2n4WHb8gdwroYfTdqCeODTK1/07XtXEd7sywo6PddcYQjWIrs
         XGQpuEiZooL3HdInDWKsXJvjTfG9xmqPBgcERWwtzOr0Ttr32CE+Qg9+O8SCgec/xmSw
         biPcTduAgv+GKjlh3sQpg5wAltCBjOuommAMB7NqlUt5/JIK2FKu0eRDeAeXdNZY1IEY
         YsjA==
X-Gm-Message-State: AOAM531joaxtbM4mzsUxiEnm8XgIBD5CjPcK3ueyuvBf9KY/Md236o1j
        phJ/7oEQBow+bIt7iQg+EpqS0dV/UjRL1wKw
X-Google-Smtp-Source: ABdhPJzu3JB9gA9Gcz17wryDh6pSt/WfoquSP+LPAaxzNkC/Acsp01pkY2F8T7eC5yWfmeCS3iCyRQ==
X-Received: by 2002:a02:ccdc:: with SMTP id k28mr63881476jaq.137.1609842919849;
        Tue, 05 Jan 2021 02:35:19 -0800 (PST)
Received: from localhost.localdomain ([156.146.37.136])
        by smtp.gmail.com with ESMTPSA id r3sm42589955ilt.76.2021.01.05.02.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 02:35:19 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Larry.Finger@lwfinger.net,
        christophe.jaillet@wanadoo.fr, zhengbin13@huawei.com,
        baijiaju1990@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: rtlwifi: rtl8723ae: Fix word association in trx.c
Date:   Tue,  5 Jan 2021 16:05:25 +0530
Message-Id: <20210105103525.28159-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
index 340b3d68a54e..59e0a04b167d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
@@ -673,7 +673,7 @@ bool rtl8723e_is_tx_desc_closed(struct ieee80211_hw *hw,

 	/**
 	 *beacon packet will only use the first
-	 *descriptor defautly,and the own may not
+	 *descriptor de-faulty,and the own may not
 	 *be cleared by the hardware
 	 */
 	if (own)
--
2.26.2

