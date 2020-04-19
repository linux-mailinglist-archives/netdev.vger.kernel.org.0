Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156DB1AFE5C
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 23:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgDSVRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 17:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726048AbgDSVRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 17:17:05 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B770C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 14:17:03 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id k1so9740216wrx.4
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 14:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=HOOwhqwq9uM3o9LmzvAQ/U4QS2t4AQX4tJJEhFdfB64=;
        b=O2O5UeNMipGgQ+SEApAxLBlzg/Q0L6OZnxc2opbbZISVIB07h/Ty9Wz86/OoDmp46N
         aATKW5Bs2FzT4S6emvUhRzYVu03y1eJSlLpxneIiLw5lHmPS+CH0t04hBmYUZGbHUGQg
         0gRltJl2zekCby+H6Kf5Tcd4RYoHGj9J3WCrq9U+Nlh2yU582ve43YAE7rjQ4+YwCiu+
         NoI6INbLAT0flGlCgWtYjvlWkJZNxPFRpNiXbtxf0xMhjHNatqHjXbPq0SKxkzcbqxVl
         aPeyIh2lBkIgEFXbDeIGoEYCWucspkL0PFDHRvbLiKbk9rySTp8k3BwIPfWvRhQ/PuqW
         TIQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=HOOwhqwq9uM3o9LmzvAQ/U4QS2t4AQX4tJJEhFdfB64=;
        b=Xc+EIHBSmOHC5Je5NTLPwjJ4h/JRmp2MbbaQ/n8K1pDi9hb+bE+OmwKVBRzjjNk3N1
         EDzxctxm7FdXVqVnmgLcwJDDuSSYsx1WTAVpldIXbhdSbZljF3HOjaMQOW1Su167Mw6H
         qVDyMdrXQxFvR910L0SG03odSeI5KxDSsYOkRvZZjuRyJBYbvrOYW1qHum+DjKwXh5w8
         xJA7o5F0iXZ8qTj7sDuGqwF7dRHGNy6fFgr0VPIlz9IoVlT0RD9iXOV9NYLRw8m1+/fp
         4M2OaANqcUpI8TRf+A5EqBWR8uJvIonvxT6q7F2wN8C8jUpIZ3b+Ch3pZ0YtdLvbGSfr
         dNfQ==
X-Gm-Message-State: AGi0PuZ3JKbjyEGI+p4IQngTuqYPrFSK8/S7GYvY3KwxPoFsJn7V+mLG
        p1WhiT1eIA9AAsCoTxiTmrt4S+Jh
X-Google-Smtp-Source: APiQypJCfsVwDI7NZQshsx/L6X2WCFg5mL3W/TldCApNQPP2PFwVmIPCUVciOIZHZDGZ2k8QMxNUlw==
X-Received: by 2002:adf:ff84:: with SMTP id j4mr14894997wrr.305.1587331021819;
        Sun, 19 Apr 2020 14:17:01 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:39dc:7003:657c:dd6e? (p200300EA8F29600039DC7003657CDD6E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:39dc:7003:657c:dd6e])
        by smtp.googlemail.com with ESMTPSA id 185sm4527882wmc.32.2020.04.19.14.17.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 14:17:01 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: inline rtl8169_mark_as_last_descriptor
Message-ID: <0e92eda1-79c2-761f-b58e-8a50eb94080c@gmail.com>
Date:   Sun, 19 Apr 2020 23:07:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtl8169_mark_as_last_descriptor() has just one user, so inline it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8e9944692..e9be6d0e2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3937,11 +3937,6 @@ static void rtl8169_rx_clear(struct rtl8169_private *tp)
 	}
 }
 
-static inline void rtl8169_mark_as_last_descriptor(struct RxDesc *desc)
-{
-	desc->opts1 |= cpu_to_le32(RingEnd);
-}
-
 static int rtl8169_rx_fill(struct rtl8169_private *tp)
 {
 	unsigned int i;
@@ -3957,7 +3952,8 @@ static int rtl8169_rx_fill(struct rtl8169_private *tp)
 		tp->Rx_databuff[i] = data;
 	}
 
-	rtl8169_mark_as_last_descriptor(tp->RxDescArray + NUM_RX_DESC - 1);
+	/* mark as last descriptor in the ring */
+	tp->RxDescArray[NUM_RX_DESC - 1].opts1 |= cpu_to_le32(RingEnd);
 
 	return 0;
 }
-- 
2.26.1

