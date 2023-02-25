Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C576A2BF2
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 22:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBYVrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 16:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBYVrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 16:47:47 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6038215565
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 13:47:45 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id ay29-20020a05600c1e1d00b003e9f4c2b623so4661868wmb.3
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 13:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fs6Ye0Y7lLqTDKrmf5OausJVY8USxG33uLTz6DKiW+k=;
        b=AtF91Oqt6BZsg+tt7Ui2tNWj+53d2zp2USOiOVogh+pDGQ3arKK2vuNHsIOR4DGzPN
         YigIm72I37fAnGJzq4zN0WDUcIBekzOEJ/Mz3zm2UvxnY3Eln8tqSCwFeSMW/A90pH17
         2r5y/5FKVv1yJ6fVthtWN9RyrOZS5XnXMzaa9YVeIV2gV0C9fj3xu2iswFBZGCoa65Gb
         wOaTq9EpzcsEDTidP5ugsV8T7wl7XuYEMMtFUMzKD2IqX2nJfKf+Mm2joh62gKOqVusM
         Dp4dfv7lRnLzOouZYWbPwpO+nsg9BBLq1/GfRLrO9d0tpi3/sK1s/7TinLeBKhvExsaA
         4hYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fs6Ye0Y7lLqTDKrmf5OausJVY8USxG33uLTz6DKiW+k=;
        b=fzQ/FB3+E+AearAbbUgWGOgRii3JuD0jZ3ygKnPFK4ep7Dhis+jpeXoWbJNObVFiF9
         OB52zu6MjdOFAoN/d3N33famLV3I9dUPnTQUqQngiCNX0qglLL0fT52HF89MhlShmDQS
         1TMuJc6M6xtl9PBnVqqkfj3rbed0aAWNd8iZliDJ6U8vgbse1F6MVYv+yz5LS/Uug9ph
         5VUkG1V1LuISSVsjeC1JQ/KcWERkmHh+To65sKlyM9uMo6cpVXmIYidcEJVzY8CiEy9s
         JFjGTd8mvfTyTPZMB4wwkJjdaJV34A8tF25sugxBn+MMJf+EjwQr2jX9KTFr5/LGmiFl
         zScA==
X-Gm-Message-State: AO0yUKUxWsJCqwvVv+WCjHI1DY+1I0HH/QfUj3S725diXkckjkELikrq
        JgUDOfIECKcVXP15lAw158o=
X-Google-Smtp-Source: AK7set/iLkzJz5rf8s5/qgB3UmS8WMDqJ4q0lH6BJK0N/mAepm0A4AvVCO8o4j0zXoJpCRFOd+1NvA==
X-Received: by 2002:a05:600c:4b28:b0:3e2:9b4:4303 with SMTP id i40-20020a05600c4b2800b003e209b44303mr15951313wmp.19.1677361663688;
        Sat, 25 Feb 2023 13:47:43 -0800 (PST)
Received: from ?IPV6:2a01:c22:7715:8b00:51a3:9e62:de37:8c49? (dynamic-2a01-0c22-7715-8b00-51a3-9e62-de37-8c49.c22.pool.telefonica.de. [2a01:c22:7715:8b00:51a3:9e62:de37:8c49])
        by smtp.googlemail.com with ESMTPSA id m21-20020a7bcb95000000b003e21f959453sm3830016wmi.32.2023.02.25.13.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 13:47:43 -0800 (PST)
Message-ID: <4efb7dcc-0e7c-8873-9a8c-fc681ef30b33@gmail.com>
Date:   Sat, 25 Feb 2023 22:44:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH RFC 2/6] r8169: use spinlock to protect access to registers
 Config2 and Config5
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <af076f1f-a034-82e5-8f76-f3ec32a14eaa@gmail.com>
In-Reply-To: <af076f1f-a034-82e5-8f76-f3ec32a14eaa@gmail.com>
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

For disabling ASPM during NAPI poll we'll have to access both registers
in atomic context. Use a spinlock to protect access.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 47 ++++++++++++++++++-----
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 259eac5b0..e6f3f1947 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -613,6 +613,7 @@ struct rtl8169_private {
 		struct work_struct work;
 	} wk;
 
+	spinlock_t config25_lock;
 	spinlock_t mac_ocp_lock;
 
 	unsigned supports_gmii:1;
@@ -677,6 +678,28 @@ static void rtl_pci_commit(struct rtl8169_private *tp)
 	RTL_R8(tp, ChipCmd);
 }
 
+static void rtl_mod_config2(struct rtl8169_private *tp, u8 clear, u8 set)
+{
+	unsigned long flags;
+	u8 val;
+
+	spin_lock_irqsave(&tp->config25_lock, flags);
+	val = RTL_R8(tp, Config2);
+	RTL_W8(tp, Config2, (val & ~clear) | set);
+	spin_unlock_irqrestore(&tp->config25_lock, flags);
+}
+
+static void rtl_mod_config5(struct rtl8169_private *tp, u8 clear, u8 set)
+{
+	unsigned long flags;
+	u8 val;
+
+	spin_lock_irqsave(&tp->config25_lock, flags);
+	val = RTL_R8(tp, Config5);
+	RTL_W8(tp, Config5, (val & ~clear) | set);
+	spin_unlock_irqrestore(&tp->config25_lock, flags);
+}
+
 static bool rtl_is_8125(struct rtl8169_private *tp)
 {
 	return tp->mac_version >= RTL_GIGA_MAC_VER_61;
@@ -1363,6 +1386,7 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 		{ WAKE_MAGIC, Config3, MagicPacket }
 	};
 	unsigned int i, tmp = ARRAY_SIZE(cfg);
+	unsigned long flags;
 	u8 options;
 
 	rtl_unlock_config_regs(tp);
@@ -1381,12 +1405,14 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 			r8168_mac_ocp_modify(tp, 0xc0b6, BIT(0), 0);
 	}
 
+	spin_lock_irqsave(&tp->config25_lock, flags);
 	for (i = 0; i < tmp; i++) {
 		options = RTL_R8(tp, cfg[i].reg) & ~cfg[i].mask;
 		if (wolopts & cfg[i].opt)
 			options |= cfg[i].mask;
 		RTL_W8(tp, cfg[i].reg, options);
 	}
+	spin_unlock_irqrestore(&tp->config25_lock, flags);
 
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
@@ -1398,10 +1424,10 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 	case RTL_GIGA_MAC_VER_34:
 	case RTL_GIGA_MAC_VER_37:
 	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_63:
-		options = RTL_R8(tp, Config2) & ~PME_SIGNAL;
 		if (wolopts)
-			options |= PME_SIGNAL;
-		RTL_W8(tp, Config2, options);
+			rtl_mod_config2(tp, 0, PME_SIGNAL);
+		else
+			rtl_mod_config2(tp, PME_SIGNAL, 0);
 		break;
 	default:
 		break;
@@ -2704,8 +2730,8 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 {
 	/* Don't enable ASPM in the chip if OS can't control ASPM */
 	if (enable && tp->aspm_manageable) {
-		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
-		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
+		rtl_mod_config5(tp, 0, ASPM_en);
+		rtl_mod_config2(tp, 0, ClkReqEn);
 
 		switch (tp->mac_version) {
 		case RTL_GIGA_MAC_VER_46 ... RTL_GIGA_MAC_VER_48:
@@ -2728,8 +2754,8 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 			break;
 		}
 
-		RTL_W8(tp, Config2, RTL_R8(tp, Config2) & ~ClkReqEn);
-		RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
+		rtl_mod_config2(tp, ClkReqEn, 0);
+		rtl_mod_config5(tp, ASPM_en, 0);
 	}
 
 	udelay(10);
@@ -2890,7 +2916,7 @@ static void rtl_hw_start_8168e_1(struct rtl8169_private *tp)
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | TXPLA_RST);
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~TXPLA_RST);
 
-	RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~Spi_en);
+	rtl_mod_config5(tp, Spi_en, 0);
 }
 
 static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
@@ -2923,7 +2949,7 @@ static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
 
 	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) | PFM_EN);
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | PWM_EN);
-	RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~Spi_en);
+	rtl_mod_config5(tp, Spi_en, 0);
 
 	rtl_hw_aspm_clkreq_enable(tp, true);
 }
@@ -2946,7 +2972,7 @@ static void rtl_hw_start_8168f(struct rtl8169_private *tp)
 	RTL_W8(tp, MCU, RTL_R8(tp, MCU) & ~NOW_IS_OOB);
 	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) | PFM_EN);
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | PWM_EN);
-	RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~Spi_en);
+	rtl_mod_config5(tp, Spi_en, 0);
 
 	rtl8168_config_eee_mac(tp);
 }
@@ -5203,6 +5229,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp->eee_adv = -1;
 	tp->ocp_base = OCP_STD_PHY_BASE;
 
+	spin_lock_init(&tp->config25_lock);
 	spin_lock_init(&tp->mac_ocp_lock);
 
 	dev->tstats = devm_netdev_alloc_pcpu_stats(&pdev->dev,
-- 
2.39.2


