Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714D845164F
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 22:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349054AbhKOVTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 16:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347667AbhKOU7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 15:59:12 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC6EC061714
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:52:56 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 67-20020a1c1946000000b0030d4c90fa87so750748wmz.2
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=guizuCKGXp/lFzFX+o51T7PSXYOfVnCvlTGA6huwYWg=;
        b=U3zGOylSfuFxzpx9MYqwFB0aBb9iEbFF7Qe6s/1K3qMAtevNqySUUbuG5EtqaD+X+k
         SyJ1XIUOF5bzf77WldYvAH3MhhulZWkc94X/Cym6h/sCFHBuexj6YrHo1wr3lQwcH9Wy
         Jd1JhaR/xULHBdB+bz166F7L57q228U5Qyzi4WBT2lmHz/hXl+wSbe65f+tlY93NrP/i
         jrJ4ba373UTKbrg4msBaCWxZuqyKrdlnmnA2C5xfPs7pQCBCBOKmCKiSZ9G5s8LYgKe2
         WZn18580U1zdANZBFSYabEIAEeHk/UzMWFuxK5IzTRuQ4RUMUG7zuN4EyIqiw3x9d0cP
         wQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=guizuCKGXp/lFzFX+o51T7PSXYOfVnCvlTGA6huwYWg=;
        b=7XacJZd81cqwn353usE3AR8Whv+avSfkiNnRG+jNUADC/gBQ373w79n1wfk7FwV7WG
         xrPHZ6hGyp5IUuLJfhXL7UMA4XPlAda5suIZULaZ2PPLp7kxb8O2zhG58paDHk0KYNYe
         xrixyWm2ypKKars6Q/VPU+VEhOF0GgUI02pDXS1DTW0mxkIcWZx4303e/eY+DwFQD916
         6PdEb/Bjbg5sBjSa0hSrnTpBYn2t17FCdoHyJAjX/HUlV9o0ozCu22fgf8dWZ7+iRLME
         G0GBcOuwsOczXsS8hyaLjpAmQ/S6ueMP8vvyMiM3U4nRsR7XKbwAyr3qy4HOrhjWW9+D
         lAvQ==
X-Gm-Message-State: AOAM533TLNgCzNI6mt4OTXdstYA85UAzYSFwD6/bz78lXJ6ZOjAI5uo1
        73Yy9z1ZLC/jC6dgBL9hGa8nTqeFlWk=
X-Google-Smtp-Source: ABdhPJxGImjCCCGlrBIGh//3kv5bYg3tcPMoLqBZXmIoQhGyjpj8Iv4TXdXP3u2zsddTCF0BtJcEjw==
X-Received: by 2002:a1c:23cb:: with SMTP id j194mr63900721wmj.13.1637009574641;
        Mon, 15 Nov 2021 12:52:54 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:a554:6e71:73b4:f32d? (p200300ea8f1a0f00a5546e7173b4f32d.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:a554:6e71:73b4:f32d])
        by smtp.googlemail.com with ESMTPSA id h15sm425438wmq.32.2021.11.15.12.52.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 12:52:54 -0800 (PST)
Message-ID: <f6b8735b-5d16-9f5d-07f6-f2890316d50f@gmail.com>
Date:   Mon, 15 Nov 2021 21:51:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: [PATCH net-next 2/3] r8169: disable detection of chip version 45
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7708d13a-4a2b-090d-fadf-ecdd0fff5d2e@gmail.com>
In-Reply-To: <7708d13a-4a2b-090d-fadf-ecdd0fff5d2e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems this chip version never made it to the wild. Therefore
disable detection and if nobody complains remove support completely
later.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3033f1222..c4dda39e4 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1986,7 +1986,10 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 
 		/* 8168H family. */
 		{ 0x7cf, 0x541,	RTL_GIGA_MAC_VER_46 },
-		{ 0x7cf, 0x540,	RTL_GIGA_MAC_VER_45 },
+		/* It seems this chip version never made it to
+		 * the wild. Let's disable detection.
+		 * { 0x7cf, 0x540,	RTL_GIGA_MAC_VER_45 },
+		 */
 
 		/* 8168G family. */
 		{ 0x7cf, 0x5c8,	RTL_GIGA_MAC_VER_44 },
-- 
2.33.1


