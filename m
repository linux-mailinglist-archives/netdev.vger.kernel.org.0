Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D5D2DB11C
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbgLOQQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729805AbgLOQPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 11:15:52 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573F7C06179C
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 08:15:11 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id t30so2394835wrb.0
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 08:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=LPel21NRTO61wzu8N9YotP/ii5zfQp92QW0Z5ATgIBA=;
        b=ss2+fecd07PxzKGB+93d5RWUyv4zAUezZiaHpYOl0Mwil3k4ZvCQd/7krn1CZaTMp0
         anjZUOh+SQEyREgf8GcCZul38nMJl3r7vp/W6LqTlp8Bv/Ms1sxmq1fnIDl8PiO5eB+6
         yQZMKYEif2YFoDZkhwG2Sav1j7lg0mU40ChI1Uc7v67YwLdUfwczEYEcb/3xuSnpcaBz
         CanUPBP8wjMby/szady5q9dHNejGRaGQUx80GwXZS+nS8gjonfP0TJxUZnTT0VmsgjgO
         fGCCOJOPbUBzG9lXc7Ual68rWvIke7g0YiYXxMKSEyMSUaUlTMBwTHmO/erGnzv85pX3
         OPfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=LPel21NRTO61wzu8N9YotP/ii5zfQp92QW0Z5ATgIBA=;
        b=kd6v5Jytwu6AFhSyD95WS2vgQjW10HoaSAYzAmQAPnTL42z51dtyVOFRbYnKtGCrqe
         4Otfl8CHTgAvVcCG7Fho30Uwb2CbMZDoztFz+DLh0j83d02SFrsc1urVbmlv+28mPBJs
         TLdzDC6Ks7k0yHdbpDPS8tk5lG2zC2nG+ceAk7tskeBCqWlDrBXVTgrG8KoDTqBFNf7U
         V6IS2Fx0IjotKcfq7azjsRTwXAAymkAWoTV/3umScccqzGfVhAUR1dAmeOdfQ3XZrs9i
         KiBCnWF2CoTyeaXE1Z9OM9FocD5iO/10kheE/nxu6wM+bh5RTGIj+4na32q4a0U+TgA8
         YqBA==
X-Gm-Message-State: AOAM532N+EKlfqkTzBWe1zJreaM0fskBOW/cAkFilE4uC0KXM41xqsV9
        fybo4roKUAuwGzja3HGJObg5zsYQoZ0=
X-Google-Smtp-Source: ABdhPJwwtoAvQV935gyPYbXbuWOol3iMtPr1cjXySBFBlwfVKLGKq0DphtpOYkc8RsFqw5JM8DC4TQ==
X-Received: by 2002:a5d:4fc4:: with SMTP id h4mr33866806wrw.129.1608048909803;
        Tue, 15 Dec 2020 08:15:09 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:d4d9:f1ee:1b1f:c865? (p200300ea8f065500d4d9f1ee1b1fc865.dip0.t-ipconnect.de. [2003:ea:8f06:5500:d4d9:f1ee:1b1f:c865])
        by smtp.googlemail.com with ESMTPSA id x7sm29366636wmi.11.2020.12.15.08.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 08:15:09 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: facilitate adding new chip versions
Message-ID: <d2d55677-3b6a-9918-e177-9968fc59b460@gmail.com>
Date:   Tue, 15 Dec 2020 17:15:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a constant RTL_GIGA_MAC_MAX and use it if all new chip versions
handle a feature in a specific way. As result we have to touch less
places when adding support for a new chip version.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.h      |  3 ++-
 drivers/net/ethernet/realtek/r8169_main.c | 14 +++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
index 7be86ef5a..4a924920e 100644
--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -66,7 +66,8 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_60,
 	RTL_GIGA_MAC_VER_61,
 	RTL_GIGA_MAC_VER_63,
-	RTL_GIGA_MAC_NONE
+	RTL_GIGA_MAC_MAX,
+	RTL_GIGA_MAC_NONE = RTL_GIGA_MAC_MAX
 };
 
 struct rtl8169_private;
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 46d8510b2..01087d3c0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -962,7 +962,7 @@ static void rtl_writephy(struct rtl8169_private *tp, int location, int val)
 	case RTL_GIGA_MAC_VER_31:
 		r8168dp_2_mdio_write(tp, location, val);
 		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_63:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_MAX:
 		r8168g_mdio_write(tp, location, val);
 		break;
 	default:
@@ -979,7 +979,7 @@ static int rtl_readphy(struct rtl8169_private *tp, int location)
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
 		return r8168dp_2_mdio_read(tp, location);
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_63:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_MAX:
 		return r8168g_mdio_read(tp, location);
 	default:
 		return r8169_mdio_read(tp, location);
@@ -1383,7 +1383,7 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 		break;
 	case RTL_GIGA_MAC_VER_34:
 	case RTL_GIGA_MAC_VER_37:
-	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_63:
+	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_MAX:
 		options = RTL_R8(tp, Config2) & ~PME_SIGNAL;
 		if (wolopts)
 			options |= PME_SIGNAL;
@@ -2182,7 +2182,7 @@ static void rtl_wol_suspend_quirk(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_32:
 	case RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_34:
-	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_63:
+	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_MAX:
 		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
 			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
 		break;
@@ -2216,7 +2216,7 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_46:
 	case RTL_GIGA_MAC_VER_47:
 	case RTL_GIGA_MAC_VER_48:
-	case RTL_GIGA_MAC_VER_50 ... RTL_GIGA_MAC_VER_63:
+	case RTL_GIGA_MAC_VER_50 ... RTL_GIGA_MAC_MAX:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) & ~0x80);
 		break;
 	case RTL_GIGA_MAC_VER_40:
@@ -2244,7 +2244,7 @@ static void rtl_pll_power_up(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_46:
 	case RTL_GIGA_MAC_VER_47:
 	case RTL_GIGA_MAC_VER_48:
-	case RTL_GIGA_MAC_VER_50 ... RTL_GIGA_MAC_VER_63:
+	case RTL_GIGA_MAC_VER_50 ... RTL_GIGA_MAC_MAX:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) | 0xc0);
 		break;
 	case RTL_GIGA_MAC_VER_40:
@@ -3950,7 +3950,7 @@ static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
 		RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) | StopReq);
 		rtl_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 666);
 		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_63:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_MAX:
 		rtl_enable_rxdvgate(tp);
 		fsleep(2000);
 		break;
-- 
2.29.2

