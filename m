Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B3629F3BE
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 19:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgJ2SD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 14:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgJ2SD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 14:03:26 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D02AC0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 11:03:26 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id m13so3778282wrj.7
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 11:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=2POKjdBXfG64SY+YaHA+CifYR71LEp3MixfJHoDyDD8=;
        b=SVHcazhF63sKB9wJqF08tKcjmMfvCOcu0s61RArNEUx+rEXcQWBYTWTimCIP7np5zp
         HjK5e24oEEZ1/HNh6TqI5gCIbWILNd/LxxrkS5v286y4DtR/9B/SuZJXYa2jLrXjZPm2
         8qKcLlhnGi54o11ai5z9+8qDWY7GYfvwiWXA9dyJNTeo/cIPxWjlfm6Rymk9aXLH1xp6
         v0yWuLS+jcIeq5L/3hfXBx8MzsvCS/+pNxqRaCRvbVxCHwERBW0p4OKqSQg0mhxgDq6u
         RxuPcF1iH3mpR0rzJ7/lMFpX1Nuc4d/mdFWD7KM6fVBP/Zox2F/To1caOFXrzeRIXh1y
         EDHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=2POKjdBXfG64SY+YaHA+CifYR71LEp3MixfJHoDyDD8=;
        b=e8BF5yojatPRlkbj+JswyAZId6MUdNed8uzfX1RBf2Nr0PwYzykfCukphE7ScLF9La
         0tLUdEc8A6vJcGwSF/teNHWnU2We6irve6x7H36OLm8Sz6EXBSXkoDuAQcMPkwxFC/RU
         aTRA8ykKSwphPbhkELo3o5ipxFJEUVZPj9Fi7z8X76hVsvhzziCzlVHtpi7SdsA0LGGv
         p0AoO7vkbLu08c8sU9WrhAeu8gMdWNlk6Td2EUaxaxK//Ou97WXnyKz6LhqHdvinnXMz
         6s2YBsxBOAz51her8bNalJcfPu7YbO9pIk4Alp6K23y0Ju7P6jsymcvdwMXHx0/D4TSO
         Hq+Q==
X-Gm-Message-State: AOAM531jVj0a1LSxu/BDaGFfnXiXqF1aSq893p9w30D0c3v5HWqf7821
        t5pJWnVRjVJJCkxQx3JcmhMTEflyIjo=
X-Google-Smtp-Source: ABdhPJx7qofLCbkG1HKwLH862cbXrM2r46Qu+xbDPeoV8nfJriSUPm2hvAC2AJxNfNXudTZtx0yA2A==
X-Received: by 2002:a5d:468f:: with SMTP id u15mr7284821wrq.154.1603994604673;
        Thu, 29 Oct 2020 11:03:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:a990:f24b:87e1:a560? (p200300ea8f232800a990f24b87e1a560.dip0.t-ipconnect.de. [2003:ea:8f23:2800:a990:f24b:87e1:a560])
        by smtp.googlemail.com with ESMTPSA id b5sm6353235wrs.97.2020.10.29.11.03.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 11:03:24 -0700 (PDT)
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: remove unneeded memory barrier in rtl_tx
Message-ID: <2264563a-fa9e-11b0-2c42-31bc6b8e2790@gmail.com>
Date:   Thu, 29 Oct 2020 18:56:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tp->dirty_tx isn't changed outside rtl_tx(). Therefore I see no need
to guarantee a specific order of reading tp->dirty_tx and tp->cur_tx.
Having said that we can remove the memory barrier.
In addition use READ_ONCE() when reading tp->cur_tx because it can
change in parallel to rtl_tx().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b6c11aaa5..75df476c6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4364,9 +4364,8 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 	unsigned int dirty_tx, tx_left, bytes_compl = 0, pkts_compl = 0;
 
 	dirty_tx = tp->dirty_tx;
-	smp_rmb();
 
-	for (tx_left = tp->cur_tx - dirty_tx; tx_left > 0; tx_left--) {
+	for (tx_left = READ_ONCE(tp->cur_tx) - dirty_tx; tx_left; tx_left--) {
 		unsigned int entry = dirty_tx % NUM_TX_DESC;
 		struct sk_buff *skb = tp->tx_skb[entry].skb;
 		u32 status;
-- 
2.29.1

