Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D794D6A2BEF
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 22:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBYVrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 16:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBYVrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 16:47:45 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071B015559
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 13:47:44 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id c18so1970549wmr.3
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 13:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NsaTFkT0zxCztwBusggP7k2Pfzh0LdcT5o8TgXJsooU=;
        b=YC7oUjd1DCJz3IBVYlEuFXzRfIuzRfFwl1o17LZqepMXNl08opvzA0C0LF4Ol1l2zp
         hJZzFF2hq8uCxFYdSf6adK6TRWBPF7S3Av3Y0w8HnL9NKosBJVFMJqWBqA/e4EGYqexr
         S4TMpOXae9TxAA8JQfad1Q4FuDTTjlfgIjSo+GL8J91gXufk8ORg/Xi6Kd2U2qX1jMp9
         XSrKNCA4umaR8pAv1tcRlVghDlUYoUPcDm4uSLkq7jNHSceippqKjBXYUtmrt8vkAWHw
         FNod8m0ZwAPa7W1eFwaTzJ3/DHRa2DQn5EFJNkyJkKOEPmJ9PRAWb49r0nYI2ffb5KQi
         YB5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NsaTFkT0zxCztwBusggP7k2Pfzh0LdcT5o8TgXJsooU=;
        b=opKuNwPud+kBcugeYB9tgcf2lYNukjOcJUi/yQ2/8HmVEZZ354ttDiGW/lGQU6WRHA
         piWxgOPDUee6ykYvnn0EK8Snyf8LubjgAPXKe28cZx4xjVi087S5DLCJ+YPNGjJ+5QnX
         bZlPdjIUt/kX4rmgESNNj8csC29WqyjmT//fz8l4XCXCq9cGkJZo01BkPiTcjX6KCFQS
         ye/AfSawqDT4OCeS7y/o9WLn1QigNjG8E7qzm5CyD46Po9SJg8IC8pf+LqnYKpqz1ID4
         1FqXhBxI/iXASKA+ehvw8JG1hoP1AOIEHlzpq6X6TlJMOYra/j0lOBTNMpentqogD+iJ
         xGOw==
X-Gm-Message-State: AO0yUKUw+aNna4JA9Zi5EgURL5cah3DD31CpIma+hMKOWjXWXbMIBkVM
        cgfK2BnOqbSMl4SGMKMzwn2pABE9FQI=
X-Google-Smtp-Source: AK7set/k5Z1hgWu/dRsdHgG5H43igKyumGX7qSEoJ5IY9AWhfRmaJHFDpkSXSJV7OZtJW3NLPQeSCg==
X-Received: by 2002:a05:600c:3088:b0:3d3:49db:9b25 with SMTP id g8-20020a05600c308800b003d349db9b25mr16367507wmn.26.1677361662349;
        Sat, 25 Feb 2023 13:47:42 -0800 (PST)
Received: from ?IPV6:2a01:c22:7715:8b00:51a3:9e62:de37:8c49? (dynamic-2a01-0c22-7715-8b00-51a3-9e62-de37-8c49.c22.pool.telefonica.de. [2a01:c22:7715:8b00:51a3:9e62:de37:8c49])
        by smtp.googlemail.com with ESMTPSA id c16-20020a05600c0ad000b003e214803343sm7314109wmr.46.2023.02.25.13.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 13:47:41 -0800 (PST)
Message-ID: <9508a76f-8f83-9579-a46f-742d486a6cac@gmail.com>
Date:   Sat, 25 Feb 2023 22:44:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH RFC 1/6] r8169: use spinlock to protect mac ocp register
 access
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

For disabling ASPM during NAPI poll we'll have to access mac ocp
registers in atomic context. This could result in races because
a mac ocp read consists of a write to register OCPDR, followed
by a read from the same register. Therefore add a spinlock to
protext access to mac ocp registers.

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


