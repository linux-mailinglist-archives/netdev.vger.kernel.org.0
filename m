Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCD51CB9D7
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgEHVdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgEHVdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 17:33:05 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E770C05BD09
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 14:33:05 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y3so3597294wrt.1
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 14:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=83rsyD8e8CTJY9Kn3RzBWp5R9SEw+FYfUFuMgUNzd5w=;
        b=uIJrSGXkgYY+NSkwjPpbgn1XpTZLkixNrH5n79qLBDSYFvgrsr2Hl/HGQVwtwKM7Cb
         /kI+UCTdW5T3hwkOX4MZi49pE5DBJvgAdV0coRepo6CqKEQHhGcZTeOert8QBQg9VJqU
         Ha+EMIyUcgTUrQGG8mzElk+/JuCW1Vox+aD1tojRbnZEQ5h+bqrM+Wu3vIUFGhO1Xjy3
         RrQh9kSdm4mFw76oMj2BAdw7WhncskEBJAeR9rejWNZzhnwIMHUCky5WlPISeZsFvNlj
         D5HlH/49TL3tqU7fSJpj8ljqaKM6uvwgIqzE8khQPU7laJMFvR15Zy5erKb/94p50+2m
         XHLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=83rsyD8e8CTJY9Kn3RzBWp5R9SEw+FYfUFuMgUNzd5w=;
        b=cpBusLcxmGMHxLjVRM00Z3xeVV74D8ssQ86F6xED8sxMQN5aQjSMda2maMBE5Y8RU+
         rT5z9QRMicQ8uItwg1wy+P2hI13kxxlLUC6Ky1b8kTAnWrkCbX1a8bq9KuHvtApLjGup
         MytHJ0rKo0nSoDMHfM8TJC6n6Y1ua74zaAgbsqfkRbTslCNnhm3xckLFz54lycszX9Lp
         ZTsgjJjpzQomp5goEotxf0SAycYXXynPIDTHH7svlK+DZAtxVA5ox+7fZqnb9+rsEIwO
         +Eb2EafBs8t/FlwrqkAp53NGZ6j2yQ2o67ZS7nkk0e41klBkhrIZHGa1uMgdiNUAsFJc
         kcLQ==
X-Gm-Message-State: AGi0PubExpjyNhPxL8Qt9Hs2Go3Q/9yO0Ym5ZRr5geejlH/n3R96zzoH
        eHBeePexqTxaEMa42W0TT+Uz16ce
X-Google-Smtp-Source: APiQypIfvP+OQ4iKBBNdn8UsU0YQn4zJ0f9FQJEUEUzTAQfL9OjaoK1O4WpAIuXs9uAjZKa7pHUJZQ==
X-Received: by 2002:adf:e7cb:: with SMTP id e11mr4797228wrn.145.1588973581798;
        Fri, 08 May 2020 14:33:01 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:b9ec:f867:184c:fa95? (p200300EA8F285200B9ECF867184CFA95.dip0.t-ipconnect.de. [2003:ea:8f28:5200:b9ec:f867:184c:fa95])
        by smtp.googlemail.com with ESMTPSA id 77sm5167831wrc.6.2020.05.08.14.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 14:33:01 -0700 (PDT)
Subject: [PATCH net-next 1/4] r8169: add helper
 r8168g_wait_ll_share_fifo_ready
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ae5fb819-26e4-d796-2783-2ed5212d0146@gmail.com>
Message-ID: <933ef712-66e8-c7b4-8abb-55a537681217@gmail.com>
Date:   Fri, 8 May 2020 23:30:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <ae5fb819-26e4-d796-2783-2ed5212d0146@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a helper for this waiting function, name of the helper is
borrowed from the vendor driver. In addition don't return in the two
hw_init functions if the first wait runs into a timeout, there's no
benefit in doing so.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8c41f6848..1c96fc219 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5057,6 +5057,11 @@ DECLARE_RTL_COND(rtl_link_list_ready_cond)
 	return RTL_R8(tp, MCU) & LINK_LIST_RDY;
 }
 
+static void r8168g_wait_ll_share_fifo_ready(struct rtl8169_private *tp)
+{
+	rtl_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42);
+}
+
 DECLARE_RTL_COND(rtl_rxtx_empty_cond)
 {
 	return (RTL_R8(tp, MCU) & RXTX_EMPTY) == RXTX_EMPTY;
@@ -5141,13 +5146,10 @@ static void rtl_hw_init_8168g(struct rtl8169_private *tp)
 	RTL_W8(tp, MCU, RTL_R8(tp, MCU) & ~NOW_IS_OOB);
 
 	r8168_mac_ocp_modify(tp, 0xe8de, BIT(14), 0);
-
-	if (!rtl_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42))
-		return;
+	r8168g_wait_ll_share_fifo_ready(tp);
 
 	r8168_mac_ocp_modify(tp, 0xe8de, 0, BIT(15));
-
-	rtl_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42);
+	r8168g_wait_ll_share_fifo_ready(tp);
 }
 
 static void rtl_hw_init_8125(struct rtl8169_private *tp)
@@ -5162,15 +5164,12 @@ static void rtl_hw_init_8125(struct rtl8169_private *tp)
 	RTL_W8(tp, MCU, RTL_R8(tp, MCU) & ~NOW_IS_OOB);
 
 	r8168_mac_ocp_modify(tp, 0xe8de, BIT(14), 0);
-
-	if (!rtl_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42))
-		return;
+	r8168g_wait_ll_share_fifo_ready(tp);
 
 	r8168_mac_ocp_write(tp, 0xc0aa, 0x07d0);
 	r8168_mac_ocp_write(tp, 0xc0a6, 0x0150);
 	r8168_mac_ocp_write(tp, 0xc01e, 0x5555);
-
-	rtl_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42);
+	r8168g_wait_ll_share_fifo_ready(tp);
 }
 
 static void rtl_hw_initialize(struct rtl8169_private *tp)
-- 
2.26.2


