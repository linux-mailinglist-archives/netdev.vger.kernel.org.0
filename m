Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B3F128929
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 14:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfLUNPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 08:15:55 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45466 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfLUNPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 08:15:54 -0500
Received: by mail-wr1-f66.google.com with SMTP id j42so11984002wrj.12
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 05:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=dY0UWbS5mIaCYPRBsmGmLWYRkCiCFQ1HsNkWnV0cAR4=;
        b=AyeSZ2z6F9mgjWbYAuEDx7WNEi6wUEGMYfCU0Y4I9uw4XfudtTKS9EDK/u3LWQBu7x
         VzfUu9yeIOmGfvmxwDnUEaRSSGkOeTzqe6hsMHsIXdVqqhkt7s6Sji7Hv3TD5iUPQk9H
         bjRwx4tpCwL/cMzRnQuMkbHUappuPXieab7fIClOmX4uxxXpwV+yLfgORSnG0G1gOI1c
         XIXQrqMNTvjlRZDw79wz9SbgQ394Eta4hLiHF87jtMtpml8BfVn7ygy0jUwnQNH1nW03
         XHI15V+gWDWPAYoK7ugD9HGtWRKLRHjJbp2XhGRdYJ0LH28BwAEeaVmP8+9IMay9owk6
         xLHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=dY0UWbS5mIaCYPRBsmGmLWYRkCiCFQ1HsNkWnV0cAR4=;
        b=j7TX99Cag1Kp+BXznyB2oLcNZHcFZGGMLehedJRa00gMHdL2CxKIPkOscH4Juglzlr
         xI1oVCfFqE7UVHB4DyS33bzpGrodiyWqna+9LWaAcQHtnXIKaiCEozElKeC2Gfr2tKaE
         SfeEu/XXMI8Dl6F3H45xkfR2eZIsx2dF897f+wPee6B2Eenrg1vVXbTedfK7n/TSv5fO
         ahmkyX4CmRFrnc/90/D3GJv6Sj5/YHAcSGvM7cXGvvJ89sp0+E/ztqJBWcUIiyIlPpUg
         joLIvsMv6SQHYyXVA8OLLLDyknqGW7uE0cb/bFsmR3Dg+fGiiQpBt8d+omO3d6joSi1v
         5Eow==
X-Gm-Message-State: APjAAAVfJL+mqDx7nnp1xMP6PHD2Ve2k5RPaDQXYTERTdjw8EwEU3rYP
        oRM0mY9jFHgFjkiT3VjDG6cn/ncY
X-Google-Smtp-Source: APXvYqwpIdlwicTKILBHtBeitOq7KDsYNnPzyU5j5dwG4u+K3DAPqYFXE7smJsYDcMUpw/tkqPiFTg==
X-Received: by 2002:adf:ee88:: with SMTP id b8mr21914329wro.249.1576934153048;
        Sat, 21 Dec 2019 05:15:53 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:1d9b:6ccb:460c:7d9e? (p200300EA8F4A63001D9B6CCB460C7D9E.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:1d9b:6ccb:460c:7d9e])
        by smtp.googlemail.com with ESMTPSA id x132sm16923826wmg.0.2019.12.21.05.15.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Dec 2019 05:15:52 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: remove MAC workaround in
 rtl8168e_2_hw_phy_config
Message-ID: <7fada62e-0f26-bc72-4872-817d924baa9f@gmail.com>
Date:   Sat, 21 Dec 2019 14:11:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to recent changes we don't need the call to rtl_rar_exgmac_set()
and longer at this place. It's called from rtl_rar_set() which is
called in rtl_init_mac_address() and rtl8169_resume().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c845a5850..38a09b5ee 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2961,9 +2961,6 @@ static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0005);
 	rtl_w0w1_phy(tp, 0x01, 0x0100, 0x0000);
 	rtl_writephy(tp, 0x1f, 0x0000);
-
-	/* Broken BIOS workaround: feed GigaMAC registers with MAC address. */
-	rtl_rar_exgmac_set(tp, tp->dev->dev_addr);
 }
 
 static void rtl8168f_hw_phy_config(struct rtl8169_private *tp)
-- 
2.24.1

