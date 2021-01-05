Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0783A2EA866
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 11:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbhAEKSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 05:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbhAEKSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 05:18:13 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A4DC061574;
        Tue,  5 Jan 2021 02:17:33 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id q137so27669478iod.9;
        Tue, 05 Jan 2021 02:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jqm0U226hSGpLlFOe8Ys6U5Rvvh/SeKcAfJj4jwLTow=;
        b=Z8jqvumC0hWiumtreehL9gMTDCVeaz2dlPWnuUeqQ+1JDgO/sj5VE1GQdvtMfI2heh
         xf7l76YFbtBy4jlMWrIV+wUS/padurZhRT8Xo44XfLj93hS8ONUxuIP4KV9tmCU98E+W
         jy8hq/hm4j79WzqN7OjElv0kFTYVbyfHZU19vh7eLAVdzLaSS1qBxu44U+GwP2GXpBuR
         hiGn7TzK1QRV+J77Y9z7kY9pzG/LlJcb7yEaGBgw0q3z3ll61es/VhJRKJf7CsJRXtX+
         CeFOZTUaSUfexRs2N1Zel1auB7158go0Q4xXwywv7xP4y5tWQRcCJN5VvJv7gYlImEcj
         4/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jqm0U226hSGpLlFOe8Ys6U5Rvvh/SeKcAfJj4jwLTow=;
        b=QO0ikOtz6RKkI9yUAOsuh5c7pwIPJF11TjuHOn4MsrqJND06HM22s0N8YhVEN8snri
         xFBB4WAdRO5gRgMjPH5ItsB/68qOEipAyEKkTAmwSzMVt+gbsI/iGv+wwoknIXWGu/GG
         tTpKmAvFX+BQVg2qnFHQOGuRpWgNTs/7FK7YgqQBBhFquUcEn7qEIrTDczDKmJYVvwll
         +9txpNss0SJl5+iRhpZNJZFLDs/Akaj9mh4MRDBEojlxUVRcDimF8Y/eKpc6X+dQpZ4G
         YUPcisMpejtWp7EWcrOJ5P1Pj0Zk9ZeTN46pUFqrhwLqKPwhDbg1IpAH5EgrVN9GtN3k
         tZ3A==
X-Gm-Message-State: AOAM532SUB/hYJAuWZY/1/PHxAwdNIsc1gy62WsizPRZPkQ5pnxX8D0o
        IKg4n1zEIctz+uCDIExNVeQ=
X-Google-Smtp-Source: ABdhPJxlMtasgqsVA1n3EypXlgprWfbCXEFmuo5+7wMx0SfNR9VIMKD6oAzqAJgh2evStrLOgAg1JA==
X-Received: by 2002:a02:91c2:: with SMTP id s2mr66587368jag.48.1609841852935;
        Tue, 05 Jan 2021 02:17:32 -0800 (PST)
Received: from localhost.localdomain ([156.146.37.136])
        by smtp.gmail.com with ESMTPSA id p18sm43495280ile.27.2021.01.05.02.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 02:17:32 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Larry.Finger@lwfinger.net, zhengbin13@huawei.com,
        baijiaju1990@gmail.com, christophe.jaillet@wanadoo.fr,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: net: wireless: realtek: Fix the word association defautly de-faulty
Date:   Tue,  5 Jan 2021 15:47:38 +0530
Message-Id: <20210105101738.13072-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/defautly/de-faulty/p


Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
index c948dafa0c80..7d02d8abb4eb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
@@ -814,7 +814,7 @@ bool rtl88ee_is_tx_desc_closed(struct ieee80211_hw *hw, u8 hw_queue, u16 index)
 	u8 own = (u8)rtl88ee_get_desc(hw, entry, true, HW_DESC_OWN);

 	/*beacon packet will only use the first
-	 *descriptor defautly,and the own may not
+	 *descriptor de-faulty,and the own may not
 	 *be cleared by the hardware
 	 */
 	if (own)
--
2.26.2

