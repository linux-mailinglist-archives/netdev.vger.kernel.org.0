Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECF7F18ACF3
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 07:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgCSGnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 02:43:53 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37171 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbgCSGnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 02:43:53 -0400
Received: by mail-pl1-f195.google.com with SMTP id f16so641972plj.4
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 23:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4+ce41gqzm22CFinhLSiCMx2DKeV8K25scp1EFRhKKw=;
        b=EAH0hp/YzZ0Vx4g3oknSGTUeMwX95d+ZF2zis5RDrJWofKUdR7jCmr9F3UI41cFa8y
         hc1EYB0izrbe8GkM+C2rYNh5gTUutq8UUfe4ZukDPfKRBCKchRvx7wbcjJL3RfDYx1t9
         +ChaHcSXgT0Ndz7bEhiR6HYOe/ZHxNi/MT/uJKdO3FETYnijJArGITiW+ncDlo5TsRoo
         Iwl7nUxxKl89ONoO+Mj/N74P/pZiRlTusFfWkXgurYTasrNhRBvVZUtlJULO55e6pWAc
         X6SFTRFqON2doCR5bBwtb4M+Q1xkGJXnq/JL/yQXBdTn2P9Oz5/IU1EfsvCGsm2tTVmS
         XeQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4+ce41gqzm22CFinhLSiCMx2DKeV8K25scp1EFRhKKw=;
        b=iyIYjIjbIq050GBpT4ErxbGpGEU6+Ncc8aQ4BMtfU79swXUN5j637XjfuoZimZjpQd
         Nn8ZO7Thrl4sbmdexdFJqbQaBzeKcmdtpxlkTa4ly/Rllj5kmxQfjTCpq+hHsSorrKAQ
         x41Ads6wG9npURlfdo4qq1EnAceWc7nscs+W6OXgYrGDK8kRVGHR7enAf9y9TrXZHpiW
         /FAg6Eh7JQySETKLCxC6VOQsDpt/UcXb3MtqmstmzXyEbN26DRI6pW+yd+NF5933lOPv
         J5HETDIOC6BkwvlnHUW8zq9UHwaZUUCMPMrAdLaS+S0HzVDwahllRu3wxuwuMGk9QXF4
         bCcw==
X-Gm-Message-State: ANhLgQ0ep+zEZ8CpFOCUQB/fhoNetT/IGWVVKEvg26+gN6ELXQkYYnDU
        S+d3jbZF3uanfP/+hoNwP3Byrg==
X-Google-Smtp-Source: ADFU+vvMiNTNJKvodZ7OC0QL8loodVxCZgzt0kLxePaXUFH5k5QafWPyqtXsLXgxDGFI7lDonBoHEw==
X-Received: by 2002:a17:90a:bc01:: with SMTP id w1mr2182430pjr.154.1584600230434;
        Wed, 18 Mar 2020 23:43:50 -0700 (PDT)
Received: from localhost.localdomain (59-127-47-130.HINET-IP.hinet.net. [59.127.47.130])
        by smtp.gmail.com with ESMTPSA id x8sm1098973pfp.135.2020.03.18.23.43.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Mar 2020 23:43:49 -0700 (PDT)
From:   Chris Chiu <chiu@endlessm.com>
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH] rtl8xxxu: Fix sparse warning: cast from restricted __le16
Date:   Thu, 19 Mar 2020 14:43:41 +0800
Message-Id: <20200319064341.49500-1-chiu@endlessm.com>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the warning reported by sparse as:
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4819:17: sparse: sparse: cast from restricted __le16
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4892:17: sparse: sparse: cast from restricted __le16

Signed-off-by: Chris Chiu <chiu@endlessm.com>
Reported-by: kbuild test robot <lkp@intel.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 54a1a4ea107b..daa6ce14c68b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4816,8 +4816,8 @@ rtl8xxxu_fill_txdesc_v1(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 		rate = tx_rate->hw_value;
 
 	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_TX)
-		dev_info(dev, "%s: TX rate: %d, pkt size %d\n",
-			 __func__, rate, cpu_to_le16(tx_desc->pkt_size));
+		dev_info(dev, "%s: TX rate: %d, pkt size %u\n",
+			 __func__, rate, le16_to_cpu(tx_desc->pkt_size));
 
 	seq_number = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
 
@@ -4889,8 +4889,8 @@ rtl8xxxu_fill_txdesc_v2(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 		rate = tx_rate->hw_value;
 
 	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_TX)
-		dev_info(dev, "%s: TX rate: %d, pkt size %d\n",
-			 __func__, rate, cpu_to_le16(tx_desc40->pkt_size));
+		dev_info(dev, "%s: TX rate: %d, pkt size %u\n",
+			 __func__, rate, le16_to_cpu(tx_desc40->pkt_size));
 
 	seq_number = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
 
-- 
2.20.1

