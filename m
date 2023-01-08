Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE979661892
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 20:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbjAHTiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 14:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbjAHTiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 14:38:01 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291492BCB
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 11:38:00 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id cf18so8934748ejb.5
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 11:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t4ovmwOwmBVkluxFmX9Q6ob97I/KcvEz3No73F7IfFA=;
        b=a0Qt6NCzYS2LVJnvI6HCSLrmHQOluNtTOGa7NG0q3+uF8CRIt0ocBb8twDszykcLyw
         /oTml5XZnERfaqNj8yB5fbBAxNrVmMBsi8TihUuIlXCDma1VYJrmOQe9hnEb05T0W7UE
         qKM15n/JW5lKaB7R2ZzNx3DAtNLei2lFLpIf8CjpTREYL3AqojuVPn4ZBO6xbBJ6qpO0
         Ek0sZjgunlMntfiGGqhzfaOqYMT5TgX28nxUcFMiggVm2456wwK/YDujWMVJz5L8grDO
         QCj1YVl25IDE1H9H4C3NaREee7KEvTmIhxG7M0c8FSuYhVsbamz252G6M9jrPN5q20vi
         Kj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t4ovmwOwmBVkluxFmX9Q6ob97I/KcvEz3No73F7IfFA=;
        b=DpVzvgb8lTudlSJOHH0ymaGCtV2Tl2fHc39LnMAyW8HPlIBDR1ZjfeQiVurPUXyL33
         EbHj8zWy/ZmYshrNhCQl6mn+79NlGxZq5FHpcYQlCNYlQw5kBz7yIep3ByifyoDdyUWS
         szhzMoto7ZMgC39O6RQOz8mRc2DNynqYosjAh7CFQjBelmAUKgjhHsZZ/mBm2kxBYJ/A
         d8bVrw+hAqO3G2BA80MxkE6VvFHP5rlCA2vyoXyB3AY2KOR5sVoSv3l/v3LaXSXjADOc
         9gt2Lqbn39EldnFARmKNEz1LyuBxGJ0D42ZqsIPC0GJNcUZqq6rvvRqVXELWQxHKrMsL
         Fj8A==
X-Gm-Message-State: AFqh2komCyFWFyZfD5SSRu6goqGRf1/rtp+efsNYR8NNBt7HvN5LdH6A
        cTwV/pt/0dsUVhAIu8CB4so0Ol7IIeo=
X-Google-Smtp-Source: AMrXdXu/vI9gC3kC8fKw26zKvjdM95wAOT62dhk7ESmfoE8gT4zObk1efKPvYdnYhSH/09LnKLHi3w==
X-Received: by 2002:a17:907:7844:b0:7c0:eba2:f9dd with SMTP id lb4-20020a170907784400b007c0eba2f9ddmr52142967ejc.53.1673206678551;
        Sun, 08 Jan 2023 11:37:58 -0800 (PST)
Received: from ?IPV6:2a01:c23:c473:c200:8b4:d99a:c124:498f? (dynamic-2a01-0c23-c473-c200-08b4-d99a-c124-498f.c23.pool.telefonica.de. [2a01:c23:c473:c200:8b4:d99a:c124:498f])
        by smtp.googlemail.com with ESMTPSA id fy5-20020a170906b7c500b0084d3bf4498csm1284209ejb.140.2023.01.08.11.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jan 2023 11:37:58 -0800 (PST)
Message-ID: <42e9674c-d5d0-a65a-f578-e5c74f244739@gmail.com>
Date:   Sun, 8 Jan 2023 20:37:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] Revert "r8169: disable detection of chip version 36"
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 42666b2c452ce87894786aae05e3fad3cfc6cb59.

This chip version seems to be very rare, but it exits in consumer
devices, see linked report.

https://stackoverflow.com/questions/75049473/cant-setup-a-wired-network-in-archlinux-fresh-install

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 24592d972523..dadd61bccfe7 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1996,10 +1996,7 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 
 		/* 8168F family. */
 		{ 0x7c8, 0x488,	RTL_GIGA_MAC_VER_38 },
-		/* It seems this chip version never made it to
-		 * the wild. Let's disable detection.
-		 * { 0x7cf, 0x481,	RTL_GIGA_MAC_VER_36 },
-		 */
+		{ 0x7cf, 0x481,	RTL_GIGA_MAC_VER_36 },
 		{ 0x7cf, 0x480,	RTL_GIGA_MAC_VER_35 },
 
 		/* 8168E family. */
-- 
2.39.0

