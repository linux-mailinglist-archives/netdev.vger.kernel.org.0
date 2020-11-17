Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75ED2B7024
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgKQUeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgKQUeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:34:19 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF530C0613CF
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 12:34:18 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id d12so24692575wrr.13
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 12:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=1x1A5YcgE3vN+WCnlxjTX+2mKo29bnhZoWw/xtIYX/s=;
        b=RIfi44lHlhqwc9jeIHiEF9w1J+7tX1FucH0/ihnpd7YWH1lVyWJUQVChDaX+/nr1pQ
         5DOUbXR5Q5MS6ssJO24KuR78uVG6CIg1otChfyHw/MwEWj+szUbZ5925R9nNJMzphcsN
         KgKAxWcsW5p5leJr1xqAmqQSF1BUNgjboMkRszeTJCeTVUuTwTAUzO6QTOfTVsNhrSIc
         txYEAZoRJTtfvlhGPgkphl53qLXur4WQqlce3la82YfJbScco0u/3DHsN0oZEJYWKQSp
         9dGT+R+0Ed86D+GNGXMhIp0ww3p6tEb4OWY2wd1lmWQxJgnyby3ZpK7+iZMhle7wMADW
         /wfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=1x1A5YcgE3vN+WCnlxjTX+2mKo29bnhZoWw/xtIYX/s=;
        b=Wh/SPIaui/W7rcWK3Vwtaak37Y2gXZqth+quXErj0RelH8riW/yTtGQiynduSIfO6j
         2xlh1/HuRKgl9a5DS1Lf1GY4rOMlt3KD8OeneM3jgkuB/uwisuG62cP6xGt79RgzGxoJ
         lwcZEwW1/D0+xLLMbqmoapn8PM/BSt9rmXh+7vPYBT3qk6dYQvj8GY8OnTQWapULc5kt
         +cOpmwRnAeMcMnD3r49LgoX0MhQCWwIxhjqJOuP6a7NLOmLpxMsoVArYHwGkQh/Lr5NZ
         bkUkIwYHBWs6rPo/IkKf++bmXZNKPVymBFVqQKevE8kSZi9ha++Un6zGtIOhHzh8ROXn
         onHw==
X-Gm-Message-State: AOAM532yMinzej7UQA/gyx7dhDR14RZPiu7xWkujCgGyftr1/VE9NIEc
        jbs7TxwJH+MRBXg51COn6A++Of81+oWZxg==
X-Google-Smtp-Source: ABdhPJxewW2aku01PQfHJ4edY/5SKlWujDyV9+4x38xPPBpkOfgqcPX+6QrIWA5NnM7LChI/YOwvqQ==
X-Received: by 2002:adf:f9c6:: with SMTP id w6mr1277707wrr.273.1605645257381;
        Tue, 17 Nov 2020 12:34:17 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:44e4:5b02:13:99de? (p200300ea8f23280044e45b02001399de.dip0.t-ipconnect.de. [2003:ea:8f23:2800:44e4:5b02:13:99de])
        by smtp.googlemail.com with ESMTPSA id u81sm6107074wmb.27.2020.11.17.12.34.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 12:34:16 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: remove not needed check in rtl8169_start_xmit
Message-ID: <6965d665-6c50-90c5-70e6-0bb335d4ea47@gmail.com>
Date:   Tue, 17 Nov 2020 21:34:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rtl_tx() the released descriptors are zero'ed by
rtl8169_unmap_tx_skb(). And in the beginning of rtl8169_start_xmit()
we check that enough descriptors are free, therefore there's no way
the DescOwn bit can be set here.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e05df043c..5766d191f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4180,17 +4180,12 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	bool stop_queue, door_bell;
 	u32 opts[2];
 
-	txd_first = tp->TxDescArray + entry;
-
 	if (unlikely(!rtl_tx_slots_avail(tp))) {
 		if (net_ratelimit())
 			netdev_err(dev, "BUG! Tx Ring full when queue awake!\n");
 		goto err_stop_0;
 	}
 
-	if (unlikely(le32_to_cpu(txd_first->opts1) & DescOwn))
-		goto err_stop_0;
-
 	opts[1] = rtl8169_tx_vlan_tag(skb);
 	opts[0] = 0;
 
@@ -4203,6 +4198,8 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 				    entry, false)))
 		goto err_dma_0;
 
+	txd_first = tp->TxDescArray + entry;
+
 	if (frags) {
 		if (rtl8169_xmit_frags(tp, skb, opts, entry))
 			goto err_dma_1;
-- 
2.29.2

