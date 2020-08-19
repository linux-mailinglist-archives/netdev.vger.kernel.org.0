Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C47249B53
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 13:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgHSLEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 07:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727849AbgHSLDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 07:03:24 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACED9C061342
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 04:03:23 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id bo3so25736351ejb.11
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 04:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zNNdoeIqcYy1SeLv/FD25zwE2tmvCpD0ZxB/PMHmXRc=;
        b=uBrhMq8iBjX41J6srQWfur+Hp/HN0yHYir/WXyh/HinnXPbCHTSPNjZVU1gJKZTgwR
         XP1ezyKCosZmoxWjUA5UySwhN2l3fMpNA3ZfGPMHTaji/+x8BCfhcDbDnvvysf87JTVr
         lTThez705hTy9Lk2E3kx2x+BTRSOZZVULSVMo3Vz9bY1gEnSZKqZElg4RliTIppWI/+p
         5Mb9VF2Tz38jfQzF4tR67J/EfgwIUkDLtpD9ODWPDUPQ0lfYIB0IMfx2LgTHPYtvmJ6C
         9WHJnkv11ibrXAGiCJZuggSxrKst/HpOpAgu/8wGN7liC//2vgJqe1q1otWOA8JlwyGJ
         H/NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zNNdoeIqcYy1SeLv/FD25zwE2tmvCpD0ZxB/PMHmXRc=;
        b=NoScefbKQrZt/+sV5rHhHhwjdr2+emRL+KffVe8vhYQbK0nyKK8gJ7X853aiiNBVsB
         g9TkACuL1RWyygRwl80KXt+9v2AdP0GRJJy0P7cR9l3oioRvEsQyZSChbCsHHjPcSrnS
         eT41bZfk9Iz8qY3t5eUbwLExBPsgTHifCwEsZRP8kXYRJHdrNqn+37A51sKcnRMqPbI1
         DfVEIrdMebVFA3CVFhmGG+pzlhS39aBBQyVhqB8EK3j2KPc4IQwZACM684Rvgr+SDNVX
         3E3lownUxKe1ds4zjxY+v6WPs8fdc9UeOZSE9ebU4Z9mvRkqArh+ri+iB1+olvC+csSB
         8EUg==
X-Gm-Message-State: AOAM531gfvlY3qJZidRMVSf97p9tB/OsKQ3+jCkxY/n4HnV3Q3xKu4bj
        D01HwVeqJIMCenir5VDN/+Y9o5wh9C1FOA==
X-Google-Smtp-Source: ABdhPJwgeJk8Ce97+lFYWzvIYLU4tZixU6Owj00brvXX/veuxe7SRjj7L63q41YaSlCm6Drc5p60zQ==
X-Received: by 2002:a17:906:c310:: with SMTP id s16mr24821511ejz.466.1597835002061;
        Wed, 19 Aug 2020 04:03:22 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:8106:4619:9f30:5ac7? (p200300ea8f235700810646199f305ac7.dip0.t-ipconnect.de. [2003:ea:8f23:5700:8106:4619:9f30:5ac7])
        by smtp.googlemail.com with ESMTPSA id z10sm18356285eje.122.2020.08.19.04.03.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2020 04:03:21 -0700 (PDT)
Subject: [PATCH net-next 2/2] r8169: remove member irq_enabled from struct
 rtl8169_private
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <18f0fcd2-919e-3580-979d-d0270c81a9ad@gmail.com>
Message-ID: <1d58c134-d42f-f7a0-6929-4880ae7ae888@gmail.com>
Date:   Wed, 19 Aug 2020 13:03:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <18f0fcd2-919e-3580-979d-d0270c81a9ad@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After making use of the gro_flush_timeout attribute I once got a
tx timeout due to an interrupt that wasn't handled. Seems using
irq_enabled can be racy, and it's not needed any longer anyway,
so remove it. I've never seen a report about such a race before,
therefore treat the change as an improvement.

There's just one small drawback: If a legacy PCI interrupt is used,
and if this interrupt is shared with a device with high interrupt
rate, then we may handle interrupts even if NAPI disabled them,
and we may see a certain performance decrease under high network load.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index dbc324c53..c427865d5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -617,7 +617,6 @@ struct rtl8169_private {
 		struct work_struct work;
 	} wk;
 
-	unsigned irq_enabled:1;
 	unsigned supports_gmii:1;
 	unsigned aspm_manageable:1;
 	dma_addr_t counters_phys_addr;
@@ -1280,12 +1279,10 @@ static void rtl_irq_disable(struct rtl8169_private *tp)
 		RTL_W32(tp, IntrMask_8125, 0);
 	else
 		RTL_W16(tp, IntrMask, 0);
-	tp->irq_enabled = 0;
 }
 
 static void rtl_irq_enable(struct rtl8169_private *tp)
 {
-	tp->irq_enabled = 1;
 	if (rtl_is_8125(tp))
 		RTL_W32(tp, IntrMask_8125, tp->irq_mask);
 	else
@@ -4541,8 +4538,7 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 	struct rtl8169_private *tp = dev_instance;
 	u32 status = rtl_get_events(tp);
 
-	if (!tp->irq_enabled || (status & 0xffff) == 0xffff ||
-	    !(status & tp->irq_mask))
+	if ((status & 0xffff) == 0xffff || !(status & tp->irq_mask))
 		return IRQ_NONE;
 
 	if (unlikely(status & SYSErr)) {
-- 
2.28.0


