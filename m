Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1CB6AD043
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjCFV2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCFV2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:28:44 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FE265115
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:28:28 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id f11so10254400wrv.8
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 13:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678138107;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=joa9HNCqYKgTx0nZc2iaq9jq6ADI6g6RY46WWp+EnV8=;
        b=eTmNNE3VmZ1yJSCu2xm6EgrqRdpejjTBZu44enKMRHM0QL5iRB4xQfpCPxVXx+r5Wk
         qBFZ1ScWr8W5ZOUR2BXXR/dYVkUBd2hAXDzewbwjV2Y3fA+7JCDvcoxjTeacYFQnOR4N
         eL28S/ml4JMQhRPYWP5wF0Hgg6EMk0wayV/AoCUrtxbhkuuSmt09LlfIQHV+wOOKKwGt
         wHWF8SsXA9Y5HansVcJkBZBkrTWqO4z52lN4Uc7uPIpVYlMQ0rwZ8GbdD2JpyXX7fwO/
         BF5cuYUwAKDJeBpJY1h04INSzh7Y1UTXd26FAg1T0ZjygDME8/t2U5mJ8/8Xrt13nOYr
         VavA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678138107;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=joa9HNCqYKgTx0nZc2iaq9jq6ADI6g6RY46WWp+EnV8=;
        b=gyuMn+F60gkPSvs4npfi6dJw7xCdHaPF9Q0v2a+x+9Qgmp8LOis5KY5dYHvmHtDw+U
         wD3w/GPW5HGd92njGOgrVbhvuJturrqTvCzxoWvtsUg+F/Wk9QwTq5Wf6ppHYd/doII+
         PcTYoa58fUbc0QnVmjOop4X3MoY//MvdfcEyR8qYc65v64Jl8LLxHRth4qkLH64gkQCk
         CG1Zxqqzl9GwbZR2/RPAQOAhDD6rQspUgEoJD/rB5pffkLg+6OdGZogazxF4Gfh/y0jC
         qRLOhUP2tAvJHDCZO5qf3l41jQRHZjbENLJYfGoIs1NRpMvaPKlbH94rJfivT9ZoICsI
         5uJA==
X-Gm-Message-State: AO0yUKWUCJwMpSkpOWja7QAgEPse9cYW2cohLthvrIWXHNsemoHQGUA0
        V0CKHZSTOMGHWeGeLwx3nGw=
X-Google-Smtp-Source: AK7set9q5N2+OhmjdHC+btkww6POMxBiyzOWXYY4kTKZ4xN0/PZwob7WASeSF2TGFuUfzLsmDBP5Bg==
X-Received: by 2002:a5d:63c9:0:b0:2c3:d707:7339 with SMTP id c9-20020a5d63c9000000b002c3d7077339mr10915320wrw.6.1678138107121;
        Mon, 06 Mar 2023 13:28:27 -0800 (PST)
Received: from ?IPV6:2a01:c22:7bf4:7d00:9590:4142:18ea:aa32? (dynamic-2a01-0c22-7bf4-7d00-9590-4142-18ea-aa32.c22.pool.telefonica.de. [2a01:c22:7bf4:7d00:9590:4142:18ea:aa32])
        by smtp.googlemail.com with ESMTPSA id u12-20020a05600c00cc00b003e1202744f2sm14650409wmm.31.2023.03.06.13.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 13:28:26 -0800 (PST)
Message-ID: <fcc17755-e294-9002-9360-5b9635c65613@gmail.com>
Date:   Mon, 6 Mar 2023 22:24:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH net-next 2/6] r8169: use spinlock to protect access to
 registers Config2 and Config5
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
References: <b434a0ce-9a76-e227-3267-ee26497ec446@gmail.com>
In-Reply-To: <b434a0ce-9a76-e227-3267-ee26497ec446@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
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



