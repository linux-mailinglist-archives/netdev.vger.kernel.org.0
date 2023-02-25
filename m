Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5976A2BF3
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 22:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjBYVsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 16:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjBYVru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 16:47:50 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFDA17CCA
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 13:47:48 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id p8so2547709wrt.12
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 13:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BfPBypnUp662Wa/T+fbE80zBYw474TJLsUpPffFo5wU=;
        b=HXtOCe2dxv5q825BHDyLTWxtwzQ/PlYbkORbGsQAz03mjoH7Npm6QNGERIm15tjpv+
         oBzVT9H+M1gFlTnepCpwfJeVeLUw2zQeY1R8EIcrzjGBehXgMAUrMbIpmsJIq37/eR64
         ntpmKy1sEggupGkQoCb9x/MklMCPatmaoYMuCPAk6H+9RjDRdm84DkokDekXnI9QAj8y
         IufECu5yICLbaz744m11admOQOo/c7qEFCUgSVereX5lP9cZq4I6VL/jUE7i36qomXGr
         XL3jPe7Zw+AP7RehC41GcYgvGXhPQm646CEyUPQLb3i5RnKoqZMKQLlMfaejzbJ8GCvx
         BvXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BfPBypnUp662Wa/T+fbE80zBYw474TJLsUpPffFo5wU=;
        b=W8fZh8Gm6cAjdcf2dmWazKzVhF4RvaRvLOkLXHYyQMDKVck6DPiMXMP01dK+LJOOgd
         GVwa4aOIJQ4lNJJlJRonIMc+vC8bLkTO8O08eVA5G6heT/efSWKJdxTOfouMzxZ6T1WQ
         yNouDgLCJFCjprApVHqct5u2kTwUBD9xy0Nn21dgSMW8Krp+KhQ5bV8aTihBis9u3vvz
         2+i3gmpJI5+HYIav+pIMpyVh8f94cQs5+dMB1eGZqwcycFjPoBX3e1FkdqzAtSq+KvcT
         BswshWVMFVgJ6tU/XCHPLQTo7kAXawKxbcggz07dwXesI8bZfIg2FWdnq6xZL6nQwpQu
         cBBg==
X-Gm-Message-State: AO0yUKUmQ5ACKanU+nabxOj05TeCPJCWmYC8OS9OilEfYDIJB29NWwBN
        hz4J8GrCkAeaBjLvrFD+AYQWjE7TF1s=
X-Google-Smtp-Source: AK7set9MUl662BbXbkCz350Kl7SepTkmNI6urVSFGtGTKXKMNmmjZxeljJ1dhQSWQZruyr7PhxwzVA==
X-Received: by 2002:adf:f292:0:b0:2c7:1b4b:d729 with SMTP id k18-20020adff292000000b002c71b4bd729mr5949184wro.65.1677361667306;
        Sat, 25 Feb 2023 13:47:47 -0800 (PST)
Received: from ?IPV6:2a01:c22:7715:8b00:51a3:9e62:de37:8c49? (dynamic-2a01-0c22-7715-8b00-51a3-9e62-de37-8c49.c22.pool.telefonica.de. [2a01:c22:7715:8b00:51a3:9e62:de37:8c49])
        by smtp.googlemail.com with ESMTPSA id p13-20020a1c544d000000b003e208cec49bsm13324856wmi.3.2023.02.25.13.47.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 13:47:46 -0800 (PST)
Message-ID: <fce675d9-7352-2fb4-65ba-05bb9a4a5473@gmail.com>
Date:   Sat, 25 Feb 2023 22:46:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH RFC 5/6] r8169: disable ASPM during NAPI poll
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

Several chip versions have problems with ASPM, what may result in
rx_missed errors or tx timeouts. The root cause isn't known but
experience shows that disabling ASPM during NAPI poll can avoid
these problems.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 96af31aea..2897b9bf2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4577,6 +4577,10 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 	}
 
 	if (napi_schedule_prep(&tp->napi)) {
+		rtl_unlock_config_regs(tp);
+		rtl_hw_aspm_clkreq_enable(tp, false);
+		rtl_lock_config_regs(tp);
+
 		rtl_irq_disable(tp);
 		__napi_schedule(&tp->napi);
 	}
@@ -4636,9 +4640,14 @@ static int rtl8169_poll(struct napi_struct *napi, int budget)
 
 	work_done = rtl_rx(dev, tp, budget);
 
-	if (work_done < budget && napi_complete_done(napi, work_done))
+	if (work_done < budget && napi_complete_done(napi, work_done)) {
 		rtl_irq_enable(tp);
 
+		rtl_unlock_config_regs(tp);
+		rtl_hw_aspm_clkreq_enable(tp, true);
+		rtl_lock_config_regs(tp);
+	}
+
 	return work_done;
 }
 
-- 
2.39.2


