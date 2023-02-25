Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA986A2BF1
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 22:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjBYVrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 16:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjBYVrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 16:47:47 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B3815559
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 13:47:46 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso2775wmo.0
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 13:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ArGXE4ImnTj0mcvzPwtJoM4Jm+yvRjjF/GU16UDwiWc=;
        b=ISvD8mtQezdmktQmaYt6Q3NEzuiNIaybsi8d9I0HjVXxKv28bOTt7XhZcwLCphsuXv
         rnlIpbDyBrQVtie0/6dMiujlhhaZAGJElsapNokNrAYrvOaJj6PM9FGrElsquu41fefn
         d+Li1SN3zwrOR8g6WYGFBhAwNOZJH4JUxWZUW3u9BI5pRvFgba1gCUw91lMklNJoAJkf
         j2Log6HuL7csKPzGHSZXgDMguAXaH2liVSaywtNJ53zGbSFDZDXctL/Yu8aUlcRNssSG
         WoVbJrQXUVIo68ggnDyROAiiuLEJbdkZdLGfLb3q/jIS7ByGXXQxorxIZpV712iL+sUX
         tkiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ArGXE4ImnTj0mcvzPwtJoM4Jm+yvRjjF/GU16UDwiWc=;
        b=Mxp618XQx0xLqfAAQ89PgALNrNkvT8mnWPzEqt3I99MwPPFQW82zZAZjUEFQAfil2f
         I/HubAAaV1WGrRoVokl0D7ZWnqhhQQHm9ZXqli1PY42AqPZcLLew3ipk03k+R4CAFF0T
         a2H/v9STUr0bRlvGs1hkKy4taZwLRwoxMP+HyjAKhmoMsTXK/b+l+y9z/4g+oFrvVf/p
         Uw+A1jn8sIB3Ab515bTcludkkb4jFOJ3O6EZZqfLtSK7a6gWsnAvhdthvTZgpRotfgIl
         gD5qP0K0sN5h8+/GxoQ46wA+KowOvjFU5nAq4jEr37GL7TsUsxiSjn0Yyq5MksLgRfVK
         N6Aw==
X-Gm-Message-State: AO0yUKVjR+BYdTo2rCTfCogwPBiA1PjMnZsSjAa8FHVsa4YmpK8eCMPk
        IIpJck0pBvUXobWKWzgwX1I=
X-Google-Smtp-Source: AK7set9G5dZWmXHAna/e4OZgYDPxkAxmIncMPbXywLTupIcpYtRNBiXW0KmDfwKx4LWoQ5GQfFAl/Q==
X-Received: by 2002:a05:600c:755:b0:3eb:3b7e:7b97 with SMTP id j21-20020a05600c075500b003eb3b7e7b97mr188752wmn.30.1677361664917;
        Sat, 25 Feb 2023 13:47:44 -0800 (PST)
Received: from ?IPV6:2a01:c22:7715:8b00:51a3:9e62:de37:8c49? (dynamic-2a01-0c22-7715-8b00-51a3-9e62-de37-8c49.c22.pool.telefonica.de. [2a01:c22:7715:8b00:51a3:9e62:de37:8c49])
        by smtp.googlemail.com with ESMTPSA id g9-20020a056000118900b002c794495f6fsm2659791wrx.117.2023.02.25.13.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 13:47:44 -0800 (PST)
Message-ID: <bcd18f60-3b39-599e-8392-998bdcbde1f2@gmail.com>
Date:   Sat, 25 Feb 2023 22:45:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH RFC 3/6] r8169: enable cfg9346 config register access in
 atomic context
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

For disabling ASPM during NAPI poll we'll have to unlock access
to the config registers in atomic context. Other code parts
running with config register access unlocked are partially
longer and can sleep. Add a usage counter to enable parallel
execution of code parts requiring unlocked config registers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e6f3f1947..61cbf498f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -616,6 +616,9 @@ struct rtl8169_private {
 	spinlock_t config25_lock;
 	spinlock_t mac_ocp_lock;
 
+	spinlock_t cfg9346_usage_lock;
+	int cfg9346_usage_count;
+
 	unsigned supports_gmii:1;
 	unsigned aspm_manageable:1;
 	dma_addr_t counters_phys_addr;
@@ -664,12 +667,22 @@ static inline struct device *tp_to_dev(struct rtl8169_private *tp)
 
 static void rtl_lock_config_regs(struct rtl8169_private *tp)
 {
-	RTL_W8(tp, Cfg9346, Cfg9346_Lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&tp->cfg9346_usage_lock, flags);
+	if (!--tp->cfg9346_usage_count)
+		RTL_W8(tp, Cfg9346, Cfg9346_Lock);
+	spin_unlock_irqrestore(&tp->cfg9346_usage_lock, flags);
 }
 
 static void rtl_unlock_config_regs(struct rtl8169_private *tp)
 {
-	RTL_W8(tp, Cfg9346, Cfg9346_Unlock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&tp->cfg9346_usage_lock, flags);
+	if (!tp->cfg9346_usage_count++)
+		RTL_W8(tp, Cfg9346, Cfg9346_Unlock);
+	spin_unlock_irqrestore(&tp->cfg9346_usage_lock, flags);
 }
 
 static void rtl_pci_commit(struct rtl8169_private *tp)
@@ -5229,6 +5242,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp->eee_adv = -1;
 	tp->ocp_base = OCP_STD_PHY_BASE;
 
+	spin_lock_init(&tp->cfg9346_usage_lock);
 	spin_lock_init(&tp->config25_lock);
 	spin_lock_init(&tp->mac_ocp_lock);
 
-- 
2.39.2


