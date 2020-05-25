Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7A61E13B8
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 19:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389089AbgEYRw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 13:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389063AbgEYRw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 13:52:57 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3888BC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 10:52:57 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id r15so466702wmh.5
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 10:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1dlDdoVuRpCznObQ86hCt3JA7rypuAfLbNjCOYmVt4Q=;
        b=rQ8jVsTUsvLlKYXCyA0lsnWFcLQMnpN5MNGRBhDGEtwcef0ckirCLuXcZt34GWH0PT
         BBf9qRHiIcp0zcaTjroAmH0ESsh5p0OBAAnj4+MqzY5IvEfjm16Gkk/gWHOlxW89kA50
         /LWzjHRoAvNgcyLT4LBR76C/rXgZ+Ngg82BTQHOt84yeF46KoEUeYum3KPIoSM4O6ZR1
         au2ImICyygYS+VwVdqmCVITweNmSjSHpU3LzTW6Z7/nudXpzqPk/H97hdVYfrB8oTxcp
         fbqLhdoW3Y/OUGg4TESpmRtKnDEqCJJhr4VjVbjNpB9VYnvalbkP1v0XuO+KniYqZGVl
         94fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1dlDdoVuRpCznObQ86hCt3JA7rypuAfLbNjCOYmVt4Q=;
        b=hGgtKXLluGCCPvwtxqIFqSZ5XriedLCcM0TZQWT9X7pTSUzP81dYLYvDpTdFqSvAP4
         6ln2JX6M5sgx5M77DegXQfuqkA0JbWGr3czIQFBd5JgICgtjKuOtTRlIZQpn7CWTwh/j
         lkO+pBGBOPxwv3z4M47dC4JPgASLiJy28Md/c2FojDaFiZfFxLmBjyAKYR4Kxqc0JF1M
         pKSwpTbDWaIyC0tJ3VtqS8whxIT01mlIDShDFWM8/DhAG7okb/IZ3dXvNdlgZynNVMpY
         Dplx9M0Vd/ZFvSMhDocmYaQTfuRsS3u/hwQ/3GrdXBCt1zBWEm7bHaJjheszu3UbrwP6
         dSqg==
X-Gm-Message-State: AOAM5324A7uldx8xR5Vgf9xRIf49j0tttTsTPak2uCt93htkmHqaI5L3
        fsVlo8VR1lVLdoWijpiuFLSoE2iW
X-Google-Smtp-Source: ABdhPJwFZbpiP98Flsl1TV6BN9APdZX9qkB9LmE4+IODmcZzjXBBkaYO2UDkKDICWQlsKFZ+e6FP0A==
X-Received: by 2002:a05:600c:1403:: with SMTP id g3mr27756742wmi.51.1590429175471;
        Mon, 25 May 2020 10:52:55 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:fd94:3db4:1774:4731? (p200300ea8f285200fd943db417744731.dip0.t-ipconnect.de. [2003:ea:8f28:5200:fd94:3db4:1774:4731])
        by smtp.googlemail.com with ESMTPSA id u7sm13397164wrm.23.2020.05.25.10.52.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 10:52:55 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 4/4] r8169: sync RTL8168f/RTL8411 hw config with
 vendor driver
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e9898548-158a-12d5-4c1a-efe8cfbe3416@gmail.com>
Message-ID: <6ce5e2a4-8fd0-c2b4-fd98-0d3ef158fe2f@gmail.com>
Date:   Mon, 25 May 2020 19:52:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <e9898548-158a-12d5-4c1a-efe8cfbe3416@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync hw config for RTL8168f/RTL8411 with r8168 vendor driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index dfb07df47..17c564457 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2953,11 +2953,11 @@ static void rtl_hw_start_8168f(struct rtl8169_private *tp)
 	rtl_set_def_aspm_entry_latency(tp);
 
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
-	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
+	rtl_eri_write(tp, 0xb8, ERIAR_MASK_1111, 0x0000);
 	rtl_set_fifo_size(tp, 0x10, 0x10, 0x02, 0x06);
 	rtl_reset_packet_filter(tp);
 	rtl_eri_set_bits(tp, 0x1b0, BIT(4));
-	rtl_eri_set_bits(tp, 0x1d0, BIT(4));
+	rtl_eri_set_bits(tp, 0x1d0, BIT(4) | BIT(1));
 	rtl_eri_write(tp, 0xcc, ERIAR_MASK_1111, 0x00000050);
 	rtl_eri_write(tp, 0xd0, ERIAR_MASK_1111, 0x00000060);
 
@@ -2986,7 +2986,7 @@ static void rtl_hw_start_8168f_1(struct rtl8169_private *tp)
 
 	rtl_ephy_init(tp, e_info_8168f_1);
 
-	rtl_w0w1_eri(tp, 0x0d4, 0x0c00, 0xff00);
+	rtl_eri_set_bits(tp, 0x0d4, 0x1f00);
 }
 
 static void rtl_hw_start_8411(struct rtl8169_private *tp)
-- 
2.26.2


