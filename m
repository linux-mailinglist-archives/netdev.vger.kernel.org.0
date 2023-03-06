Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A07A6AD046
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjCFV2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjCFV2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:28:47 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C3D30B32
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:28:30 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id k37so6595655wms.0
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 13:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678138108;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b9AKknuKKfnLxpDQvjO1K47KXCz0le2zEbS5FuxPY2A=;
        b=C5OzqlUgqv2DYspkOOUUgJXftI5Ro63jg7RnsuYxFQStKIjlOo4ALUanm/tW+kgvKE
         2av1ewkhJt8GtoZlpkmAuQZbFtGK+0nj5gqde/v53id89de42zvsd1smvewd0FkYGKB/
         S9XJrSOuE2G2V2ji3INNxsOnnmr0cGZK65yOjahZ6NW2CZ1cmoiq9eS9WzBG498gWvwF
         JnvOXwTOEbiHmEEK2Ze1CWTkY6adhh90H1qdDR6F64P9foJlVf8YxQiinljHrpCnJOoX
         HjNWl/qWoGFYh+8SqPMABAwCNigAXO7+7irrGx3LxlqOiDJPqeVkuzfBmIhAuod0QzMT
         HzGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678138108;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b9AKknuKKfnLxpDQvjO1K47KXCz0le2zEbS5FuxPY2A=;
        b=v0a11tRmb8Qn06xxem+C/VTVUQZS7VydcvR+d4GYlhMZlXIlxuelBXvFB0Zv7zS6Aq
         TURuT+OP7AyplVt0Blpp5T23pizOn3vp/K14g2I76m4ez7cWpWPz0pEi52Opqnn2aO89
         Ps+MlNeYgCumR7qkguR/z+jkSu/bt6RLneTxa0wEYhPV9NjbfMUEUbi67GJ/vxF2IibS
         iDJ6KhfE6zOknUH0uGLSGSB2WQcZBJZKW6WBBxOPPLay4WPVKQJ4x1q6hARA9P/30uhg
         +wdDquHl2NpF5yUSomXUbL0qOhUniV71iozO8KsGkpwLf4lgFKP7jmJHAV1+Fr3nGUb3
         oFrw==
X-Gm-Message-State: AO0yUKVwztCxip3M1xSslpvQORuKytY2w4Lc+z4QdbE54LSU5odVHICM
        RoMBnYCA4iSsxHNvIaxElUM=
X-Google-Smtp-Source: AK7set/Mwv2vU/gaIWvQz8HF0nvEnK6JTdSR0PYD8L4lC1HtIhTv551LS52+TyMIe3+6YWI0zugmRw==
X-Received: by 2002:a05:600c:4fd6:b0:3df:d8c5:ec18 with SMTP id o22-20020a05600c4fd600b003dfd8c5ec18mr10323478wmq.13.1678138108256;
        Mon, 06 Mar 2023 13:28:28 -0800 (PST)
Received: from ?IPV6:2a01:c22:7bf4:7d00:9590:4142:18ea:aa32? (dynamic-2a01-0c22-7bf4-7d00-9590-4142-18ea-aa32.c22.pool.telefonica.de. [2a01:c22:7bf4:7d00:9590:4142:18ea:aa32])
        by smtp.googlemail.com with ESMTPSA id o2-20020a05600c510200b003e208cec49bsm24206909wms.3.2023.03.06.13.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 13:28:27 -0800 (PST)
Message-ID: <15b30923-0b59-db1e-e64f-3b05b8fcbd01@gmail.com>
Date:   Mon, 6 Mar 2023 22:24:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH net-next 3/6] r8169: enable cfg9346 config register access in
 atomic context
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

For disabling ASPM during NAPI poll we'll have to unlock access
to the config registers in atomic context. Other code parts
running with config register access unlocked are partially
longer and can sleep. Add a usage counter to enable parallel
execution of code parts requiring unlocked config registers.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
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



