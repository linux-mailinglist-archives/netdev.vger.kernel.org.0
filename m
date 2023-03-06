Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5BE6AD041
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjCFV2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCFV2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:28:40 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E372B72B36
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:28:27 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id p26so6543820wmc.4
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 13:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678138106;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=syuaSwBNSDtPzsrmU5QAcX/q0F5xd0RoyEs1wJVN19I=;
        b=l3ljv8LVJIsbcjybxj4jhOtUQW0rCrM41r7irMGigWOOWipeWEpzS8mfCWGRrpueNB
         oiZFJJpGhowLmcnTqjJ8ekbHiEsANAl3OY6+cBo/RROwPdOsV6sNpgJJzdhdzUS1rUkX
         DCb4krEug3KRYbRQpAY/isXNEeeERjGztB8N2g6Z/009/vTWfDApwsNyUXYwrqWGSBxW
         U2AL4idiH75ly9WjqCTEHdzB4VK+G9pIBFq1e8ep6OUnXLvltv0537U0fnUzgUmdqoB2
         kSBj3PuQ1ghgcAq4JlIp5lzYz0NTxrbi9K3WDcZrixC8Ek4sTFAQm1/GPNMK+S46Bevw
         5GbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678138106;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=syuaSwBNSDtPzsrmU5QAcX/q0F5xd0RoyEs1wJVN19I=;
        b=hl9i6ww1yNjnM/VgT+2AEwTRJRVzhKKR312tzktW9xW43+tMO4reLyPah61dnVHFSt
         DfOKnnybrhRINpJKMCFF5AOHeyUb3aH/jXmJz/8z48dQredYnxkXneNqX7VW/wyBtwrD
         ORQp1+KmZNjGL+4vv/l4zk13B1VTcp2S2vZ76YZhtxm95KGMCrOF1MLmBYBt87BR2Ci3
         NxTqz0XNZh40Q6Pt7NQehcMX3fYBTRYh84bMkIS+dZvwRyEj7X/2ubsX2OTJUqh2Ffoh
         MaozrV0hHo3j+U6RWGFyrhvN2SvVzusab9PI0RhRnrI7lMBLoiYAifImNqBZfElj0r6J
         iM6A==
X-Gm-Message-State: AO0yUKWAZinul903eYe+O8WxqWmuwevrTQ1qfDb/a1tt5fY2RRQMsSbC
        R+eOnyH6hUAvuK9qfJnVFvE=
X-Google-Smtp-Source: AK7set/elRBVLhjzkqYuKd4zUUDmluA3xzjacCLiogAoT09TimIRbA4aUiweHdeqxZz+4cqPpVbbiA==
X-Received: by 2002:a05:600c:3587:b0:3ea:e7f6:f8fa with SMTP id p7-20020a05600c358700b003eae7f6f8famr10786364wmq.10.1678138105984;
        Mon, 06 Mar 2023 13:28:25 -0800 (PST)
Received: from ?IPV6:2a01:c22:7bf4:7d00:9590:4142:18ea:aa32? (dynamic-2a01-0c22-7bf4-7d00-9590-4142-18ea-aa32.c22.pool.telefonica.de. [2a01:c22:7bf4:7d00:9590:4142:18ea:aa32])
        by smtp.googlemail.com with ESMTPSA id h22-20020a05600c351600b003daf6e3bc2fsm22119584wmq.1.2023.03.06.13.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 13:28:25 -0800 (PST)
Message-ID: <b1d8f3d6-78d0-0a24-89d7-a435857a541e@gmail.com>
Date:   Mon, 6 Mar 2023 22:23:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH net-next 1/6] r8169: use spinlock to protect mac ocp register
 access
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

For disabling ASPM during NAPI poll we'll have to access mac ocp
registers in atomic context. This could result in races because
a mac ocp read consists of a write to register OCPDR, followed
by a read from the same register. Therefore add a spinlock to
protect access to mac ocp registers.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 37 ++++++++++++++++++++---
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 45147a101..259eac5b0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -613,6 +613,8 @@ struct rtl8169_private {
 		struct work_struct work;
 	} wk;
 
+	spinlock_t mac_ocp_lock;
+
 	unsigned supports_gmii:1;
 	unsigned aspm_manageable:1;
 	dma_addr_t counters_phys_addr;
@@ -847,7 +849,7 @@ static int r8168_phy_ocp_read(struct rtl8169_private *tp, u32 reg)
 		(RTL_R32(tp, GPHY_OCP) & 0xffff) : -ETIMEDOUT;
 }
 
-static void r8168_mac_ocp_write(struct rtl8169_private *tp, u32 reg, u32 data)
+static void __r8168_mac_ocp_write(struct rtl8169_private *tp, u32 reg, u32 data)
 {
 	if (rtl_ocp_reg_failure(reg))
 		return;
@@ -855,7 +857,16 @@ static void r8168_mac_ocp_write(struct rtl8169_private *tp, u32 reg, u32 data)
 	RTL_W32(tp, OCPDR, OCPAR_FLAG | (reg << 15) | data);
 }
 
-static u16 r8168_mac_ocp_read(struct rtl8169_private *tp, u32 reg)
+static void r8168_mac_ocp_write(struct rtl8169_private *tp, u32 reg, u32 data)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&tp->mac_ocp_lock, flags);
+	__r8168_mac_ocp_write(tp, reg, data);
+	spin_unlock_irqrestore(&tp->mac_ocp_lock, flags);
+}
+
+static u16 __r8168_mac_ocp_read(struct rtl8169_private *tp, u32 reg)
 {
 	if (rtl_ocp_reg_failure(reg))
 		return 0;
@@ -865,12 +876,28 @@ static u16 r8168_mac_ocp_read(struct rtl8169_private *tp, u32 reg)
 	return RTL_R32(tp, OCPDR);
 }
 
+static u16 r8168_mac_ocp_read(struct rtl8169_private *tp, u32 reg)
+{
+	unsigned long flags;
+	u16 val;
+
+	spin_lock_irqsave(&tp->mac_ocp_lock, flags);
+	val = __r8168_mac_ocp_read(tp, reg);
+	spin_unlock_irqrestore(&tp->mac_ocp_lock, flags);
+
+	return val;
+}
+
 static void r8168_mac_ocp_modify(struct rtl8169_private *tp, u32 reg, u16 mask,
 				 u16 set)
 {
-	u16 data = r8168_mac_ocp_read(tp, reg);
+	unsigned long flags;
+	u16 data;
 
-	r8168_mac_ocp_write(tp, reg, (data & ~mask) | set);
+	spin_lock_irqsave(&tp->mac_ocp_lock, flags);
+	data = __r8168_mac_ocp_read(tp, reg);
+	__r8168_mac_ocp_write(tp, reg, (data & ~mask) | set);
+	spin_unlock_irqrestore(&tp->mac_ocp_lock, flags);
 }
 
 /* Work around a hw issue with RTL8168g PHY, the quirk disables
@@ -5176,6 +5203,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp->eee_adv = -1;
 	tp->ocp_base = OCP_STD_PHY_BASE;
 
+	spin_lock_init(&tp->mac_ocp_lock);
+
 	dev->tstats = devm_netdev_alloc_pcpu_stats(&pdev->dev,
 						   struct pcpu_sw_netstats);
 	if (!dev->tstats)
-- 
2.39.2



