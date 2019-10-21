Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60CD0DF5EB
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 21:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbfJUTYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 15:24:31 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51069 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728056AbfJUTYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 15:24:31 -0400
Received: by mail-wm1-f65.google.com with SMTP id q13so4559268wmj.0
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 12:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oXLFOP11VVndo7+JO4IkQH1+pIBMLItzjfjbB5VWgPo=;
        b=Q31cq7hxPq8rBszWxKeFS9911YWXCf/JfiyqlOSpkEJE0gl31bdjFRWt4b7NtnUO1o
         Ql9oezQ3qkCV3QZG/RYHwdORG609iRxwb7AOsvELi59lkrc/T+D1zjFO0RctK7XnuELl
         CxzQQx8nps93Ft6mgdHJg1EpvouNKcIdKDWnfWuWONqAojSo8Pk1nwtwKTnrutRJWwQp
         oXlyUd+oBaGLdT/ncwFUPzgy9i1n10/f5qZ1eo7VM4veACJqO8wLhDvj7JOsrCB1jg4p
         YIbINMLhFvmcO+MSJKy2lZk8yjqE+8GqolsgBl9Y49d09ATJiUphYBJIMeMglI4FqKDE
         zrnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oXLFOP11VVndo7+JO4IkQH1+pIBMLItzjfjbB5VWgPo=;
        b=njdcS+hRKe9IlQtJ0ge/5lMyRvM5aSUeRJ5lA77/dY0b8TdcXdHx3a/pI0grhqDAAz
         66hwSPmK+4KUwdGJ7uTKFWtR6QdgG2FWytM+83lhHd9AtCYBZzoMvLYNO6SLj1AE0olQ
         s/5tGEHzkLBDLFKUZO9UW7UWtGgDkNxExOOVqgHeI4SYp8gdRxstsZd0c5l1zzVj15Ee
         l4uUu2i5qC7sS4PJVVkBjFiskU769GQSgWTzWst5lNcU5QO6s84KfL8DzWQ5D9ytNguQ
         LkocV+8+ayKh9+CBKGIxltsXLrZ36O14IMPzsPRJRzbED1AP9e+OnBIZFlGvhtm72g0s
         vmBw==
X-Gm-Message-State: APjAAAUBzaA/P8ch8rMbl+OjCfpnqvYDjVDb/9QFF6T7vGQ5wxNZ89WN
        Y0p3SE/1h8NGCVM7RUkKUc4SEYjJ
X-Google-Smtp-Source: APXvYqxLBozw5YJDFPdvs2pRXJGGEXD1eOturJErSU9AH3ET2Ofyla9gJoctaVU/vND5dbdbk9CipQ==
X-Received: by 2002:a05:600c:410:: with SMTP id q16mr1196415wmb.169.1571685869354;
        Mon, 21 Oct 2019 12:24:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:1cea:5bb:1373:bc70? (p200300EA8F2664001CEA05BB1373BC70.dip0.t-ipconnect.de. [2003:ea:8f26:6400:1cea:5bb:1373:bc70])
        by smtp.googlemail.com with ESMTPSA id q124sm28995889wma.5.2019.10.21.12.24.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 12:24:28 -0700 (PDT)
Subject: [PATCH net-next 2/4] r8169: simplify setting
 PCI_EXP_DEVCTL_NOSNOOP_EN
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c4f2e4fc-9cbe-2ba1-b0b2-1e734032b550@gmail.com>
Message-ID: <94a80b7f-91d1-d826-14da-4308d02723bf@gmail.com>
Date:   Mon, 21 Oct 2019 21:22:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c4f2e4fc-9cbe-2ba1-b0b2-1e734032b550@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

r8168b_0_hw_jumbo_enable() and r8168b_0_hw_jumbo_disable() both do the
same and just set PCI_EXP_DEVCTL_NOSNOOP_EN. We can simplify the code
by moving this setting for RTL8168B to rtl_hw_start_8168().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 34 +++++++----------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 41680bd08..990b941f5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4058,29 +4058,13 @@ static void r8168e_hw_jumbo_disable(struct rtl8169_private *tp)
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) & ~0x01);
 }
 
-static void r8168b_0_hw_jumbo_enable(struct rtl8169_private *tp)
-{
-	pcie_capability_set_word(tp->pci_dev, PCI_EXP_DEVCTL,
-				 PCI_EXP_DEVCTL_NOSNOOP_EN);
-}
-
-static void r8168b_0_hw_jumbo_disable(struct rtl8169_private *tp)
-{
-	pcie_capability_set_word(tp->pci_dev, PCI_EXP_DEVCTL,
-				 PCI_EXP_DEVCTL_NOSNOOP_EN);
-}
-
 static void r8168b_1_hw_jumbo_enable(struct rtl8169_private *tp)
 {
-	r8168b_0_hw_jumbo_enable(tp);
-
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) | (1 << 0));
 }
 
 static void r8168b_1_hw_jumbo_disable(struct rtl8169_private *tp)
 {
-	r8168b_0_hw_jumbo_disable(tp);
-
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) & ~(1 << 0));
 }
 
@@ -4088,9 +4072,6 @@ static void rtl_hw_jumbo_enable(struct rtl8169_private *tp)
 {
 	rtl_unlock_config_regs(tp);
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_11:
-		r8168b_0_hw_jumbo_enable(tp);
-		break;
 	case RTL_GIGA_MAC_VER_12:
 	case RTL_GIGA_MAC_VER_17:
 		r8168b_1_hw_jumbo_enable(tp);
@@ -4114,9 +4095,6 @@ static void rtl_hw_jumbo_disable(struct rtl8169_private *tp)
 {
 	rtl_unlock_config_regs(tp);
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_11:
-		r8168b_0_hw_jumbo_disable(tp);
-		break;
 	case RTL_GIGA_MAC_VER_12:
 	case RTL_GIGA_MAC_VER_17:
 		r8168b_1_hw_jumbo_disable(tp);
@@ -5381,10 +5359,18 @@ static void rtl_hw_start_8125(struct rtl8169_private *tp)
 
 static void rtl_hw_start_8168(struct rtl8169_private *tp)
 {
-	if (tp->mac_version == RTL_GIGA_MAC_VER_13 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_16)
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_11:
+	case RTL_GIGA_MAC_VER_12:
+	case RTL_GIGA_MAC_VER_13:
+	case RTL_GIGA_MAC_VER_16:
+	case RTL_GIGA_MAC_VER_17:
 		pcie_capability_set_word(tp->pci_dev, PCI_EXP_DEVCTL,
 					 PCI_EXP_DEVCTL_NOSNOOP_EN);
+		break;
+	default:
+		break;
+	}
 
 	if (rtl_is_8168evl_up(tp))
 		RTL_W8(tp, MaxTxPacketSize, EarlySize);
-- 
2.23.0


