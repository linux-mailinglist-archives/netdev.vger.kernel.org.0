Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D27B15FEB2
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 14:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgBONyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 08:54:38 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54934 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgBONyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 08:54:37 -0500
Received: by mail-wm1-f68.google.com with SMTP id g1so12873294wmh.4
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 05:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jPF0gQO0/1xvcEzPEx+ewyIE6Cq6I5ZS/Hk1tO3fBlY=;
        b=sE/rhDhUCU2einFYW6hqL9XVUubp8wyaHo1aHuBe2IFHyqDCzb0SveVclY2JJA38fx
         io3qWhwvFjKkFw3ldGsC1qXiV+3bOD3SCL4eKEMcljnIvLaeAq8R75WtbEj35XrSINT8
         2g8X/okfgHNtCkYMxDgTzHGlK5Z9eXnCi0QrHKpKWh16LiKozjNrgEqryUTbGAJUgdMK
         nqNyoFcQ3oPgybhSMiHavgLTcFSwWb3VLXKNoOWMfkdQFDf/0TwbFy+anrhWfywtKEMA
         cuNfpw4GirJxKYkAcFjR+02HutIFzHJgj8NQEDhJ/CHta8u4q9gWrklXAv+1OwkI955L
         BfyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jPF0gQO0/1xvcEzPEx+ewyIE6Cq6I5ZS/Hk1tO3fBlY=;
        b=s0qXXKh91hgGm4WT6pQyN8zLGQu/Rz9uo3LuavG2cI+tG4ktjlDDd72oasy/9qsYs6
         fMWaoqu4i549ewMP/vNotNcWRWPPRh1zwy+Z9fW1RyGvVCLNAcA1TCi1YCtoHIQ/iO9m
         IPqPFjEAocrBXA4oB+UKlKlOjVMSyjPfe7LEQupZWWrBnL/fKdgdz29KYusgLzvucIv0
         T29k2nhoUBlRjFOHhnMokCHtNJvZfRuBx/YRPw/KsvNK7lLz676dGp17s2BwaGhdLPbj
         tlPUmeM58KJ+76IuoPw8CE0aEBXmsUsh2k/xfh4auLQpUdJl621NJ1VMYNbXYTSwp3ld
         MXGA==
X-Gm-Message-State: APjAAAX1/n8Ghifu1niympzKe7BSBR+q/yLdnO3OKhNtzswz6v230APi
        34Lm0tEJ2YOUwsAF9ojeyTS/hSki
X-Google-Smtp-Source: APXvYqxp239OWGUGL4yL2TyBzJRteaYoQU0YWiZyeLsnAwYDmgoZECeZXYb/Uvc+ap5qohA3v0qiGA==
X-Received: by 2002:a1c:4d03:: with SMTP id o3mr10694398wmh.164.1581774876067;
        Sat, 15 Feb 2020 05:54:36 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:1ddf:2e8f:533:981f? (p200300EA8F2960001DDF2E8F0533981F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1ddf:2e8f:533:981f])
        by smtp.googlemail.com with ESMTPSA id k10sm11695899wrd.68.2020.02.15.05.54.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 05:54:35 -0800 (PST)
Subject: [PATCH net-next 2/7] r8169: remove setting PCI_CACHE_LINE_SIZE in
 rtl_hw_start_8169
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bd37db86-a725-57b3-4618-527597752798@gmail.com>
Message-ID: <662c0cfe-1cf3-8a42-62b6-75803b78b4a6@gmail.com>
Date:   Sat, 15 Feb 2020 14:48:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <bd37db86-a725-57b3-4618-527597752798@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is done for all RTL8169 chip versions in rtl8169_init_phy already.
Therefore we can remove it here.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b6614f15a..a9a55589e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3834,9 +3834,6 @@ static void rtl_hw_start_8168(struct rtl8169_private *tp)
 
 static void rtl_hw_start_8169(struct rtl8169_private *tp)
 {
-	if (tp->mac_version == RTL_GIGA_MAC_VER_05)
-		pci_write_config_byte(tp->pci_dev, PCI_CACHE_LINE_SIZE, 0x08);
-
 	RTL_W8(tp, EarlyTxThres, NoEarlyTx);
 
 	tp->cp_cmd |= PCIMulRW;
-- 
2.25.0


