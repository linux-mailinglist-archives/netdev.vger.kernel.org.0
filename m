Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D256EF9C3C
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 22:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfKLVZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 16:25:53 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40649 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbfKLVZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 16:25:53 -0500
Received: by mail-wr1-f66.google.com with SMTP id i10so20171025wrs.7
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 13:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VkXDjfg/XJv9mTTfH4nBJNoJJotjJqktXs3P71Itf/k=;
        b=A260tcGUxdYYtlQ0f+Q5OlvOfRRDRxpV8TlD+maHmCHwzcEy0WzclR/oGzi1w8wqA/
         qWQXcY9EhK8KIvJADN767Ba176k3845d35YCj/1TRKr2KRAxcgfxE1cqoKQj5nk4R33N
         PwUZJfdZs6lCnuRSHiUBJ30cGSAhxlMUhzqS7KYg/NuRlHiwPDygsrDAgFCab8nVGgxC
         Mmv7AtP3YBnBj3McMOMgvYZrp8aEDM6H03VTr1wgdeONLKPeUTocvAZi/g94GDCKPGqM
         Pj3IoNCicoomuWG/maLV7m2NlenSCbCGagUlIbxOae/j5DIylDjjdkE6KcVP+Z3R72nL
         wN+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VkXDjfg/XJv9mTTfH4nBJNoJJotjJqktXs3P71Itf/k=;
        b=M6gL38OfAkyBZLmhTco1G52QQWsxVHjPzVSAUt9VZqZFlux33EoeXnB+KKWOGK0YmD
         EhflAw6QvU+ZaNOGyOwihvjVl5CMC1VKAwt+7SMaoI12o+jPECaP3AQN7HkyLkDlc9RY
         jYyZpxGMFHNvhAseVZxxJMrdZXhTE55jgH/DOrUz2EryJuI0cIBcDCMkkFnbZZP33t4Y
         EZx/tHDZjx3WaJvn01CrCH8pH1A9FSbmTNr04EdS+3jO0A62Yc8eYT+LDm4CnyJ5arso
         6QosTxKvqQMyuQgu3kFcXwMJAjpH5ADzFS6icjpp5vTWAcnKmifRWKCdQkRwb1k5kcYZ
         0aaQ==
X-Gm-Message-State: APjAAAVyEBqA+Y5+gJkPR65vpFKObidmRg2U6NFYqus1uuePdkN11Q0+
        /ZenvrkI1Q94VjGZ1rkJhACusuuF
X-Google-Smtp-Source: APXvYqy4cOFDKpMeJUtB2NkomPip1NTFzvtWmOLGMaDk3QZhdezFobhdtexaUtJ8ktd4inEG99lruA==
X-Received: by 2002:a5d:4c4e:: with SMTP id n14mr30375551wrt.260.1573593951425;
        Tue, 12 Nov 2019 13:25:51 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:7:bfb7:2ee9:e19? (p200300EA8F2D7D000007BFB72EE90E19.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:7:bfb7:2ee9:e19])
        by smtp.googlemail.com with ESMTPSA id j66sm3503258wma.19.2019.11.12.13.25.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 13:25:51 -0800 (PST)
Subject: [PATCH net-next 3/3] r8169: consider new hard dependency on
 REALTEK_PHY
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <461096ec-9185-a919-ae56-0208e73342fe@gmail.com>
Message-ID: <d74af231-be05-7f3f-2c00-55ae2cd91fc4@gmail.com>
Date:   Tue, 12 Nov 2019 22:25:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <461096ec-9185-a919-ae56-0208e73342fe@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now r8169 has a hard dependency on the Realtek PHY driver. Reflect this
in Kconfig and remove the soft dependency. REALTEK_PHY depends on
PHYLIB, therefore r8169 doesn't need an explicit dependency on PHYLIB.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/Kconfig      | 3 +--
 drivers/net/ethernet/realtek/r8169_main.c | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/Kconfig b/drivers/net/ethernet/realtek/Kconfig
index 5e0b9d2f1..9551ad5c1 100644
--- a/drivers/net/ethernet/realtek/Kconfig
+++ b/drivers/net/ethernet/realtek/Kconfig
@@ -98,10 +98,9 @@ config 8139_OLD_RX_RESET
 config R8169
 	tristate "Realtek 8169/8168/8101/8125 ethernet support"
 	depends on PCI
+	depends on REALTEK_PHY
 	select FW_LOADER
 	select CRC32
-	select PHYLIB
-	select REALTEK_PHY
 	---help---
 	  Say Y here if you have a Realtek Ethernet adapter belonging to
 	  the following families:
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 785987aae..73186e9b0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -697,7 +697,6 @@ MODULE_AUTHOR("Realtek and the Linux r8169 crew <netdev@vger.kernel.org>");
 MODULE_DESCRIPTION("RealTek RTL-8169 Gigabit Ethernet driver");
 module_param_named(debug, debug.msg_enable, int, 0);
 MODULE_PARM_DESC(debug, "Debug verbosity level (0=none, ..., 16=all)");
-MODULE_SOFTDEP("pre: realtek");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(FIRMWARE_8168D_1);
 MODULE_FIRMWARE(FIRMWARE_8168D_2);
-- 
2.24.0


