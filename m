Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A7563E380
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiK3WaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiK3WaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:30:21 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390EF92A06
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:30:21 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id w15so16217197wrl.9
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BDZzkQyiysskVYuTmzk+3p8oEPfSeUMrQN2y4xwT6XA=;
        b=cFrSjsl8EK1KAIsc+wU2QsmBJVDEeLl2vCCqIzZhGKe+EZ69aHwTwSMcS7CQ5FT8YQ
         N3gYRqQMi8asM2ntcuO8HrUToowvq56lvPhtOEc1niogreQMTpkAg/JwB7WgkR7/brW/
         UwkNAYylStTKndl6p9+RY3Xsujsu2HKcAt5zQ6N8taPCAtQ56sZ9LmX1DroutB+mD4kX
         cZHtEs5Pglx90ARr2hQuWRepLXuQ64TRqRx1Zt2IQ9qzrBqFR6Td3FtSXKiarIdZsElG
         9JneyjXSQvRuZBx4VzwqGkG7A2ByLqVQklkSEr73jq7VJxUkP8iHzJc0HLjAQOGS5VLq
         4bwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BDZzkQyiysskVYuTmzk+3p8oEPfSeUMrQN2y4xwT6XA=;
        b=ecV6lHC2gMcnSar0HUtHolUfSiKTO9yoeC2bRxQB2VwhpVuDG469a42fznoXol2vxw
         5x5iNGRSL0+TIpPdNP3Q9EPkAdtI2D9x0F/tcm7ByTJ7Yv0R+OYSk9KbHwXpU41Iod5e
         b/OHvkIXZwfh7PG59Q7gEGIO090j/AO+y0gwGCAmA50t0+gauVP55kjSxaCpvChspUgi
         SdLDObeOw2hNAuqw6hpU3dePEGezi3uJT7tOLfL5rwnX+kjhwXtkefjMLnuhXevIbGvO
         a+Hcmn1Gl3vij8W9inrjFXUZf5DEhVMJyozh9prUROmDshmdV6H2yxyDH54GKUdI0Xju
         hH7A==
X-Gm-Message-State: ANoB5pkjZJyUN0omYaqYB/awoU1tOcCElFjEgP9ZJMbie8ky3+61Bsvd
        +GIRUBUd25Xrmz6lf9EmkdooqqiGWpQ=
X-Google-Smtp-Source: AA0mqf4IxPhbse1MY214EEX+p8gciIeUWMLok7GkftpmhKtcc9Ro9XYh0vy37NksT8fG+G+xAiPZfw==
X-Received: by 2002:a05:6000:1811:b0:242:310a:300b with SMTP id m17-20020a056000181100b00242310a300bmr2198520wrh.698.1669847419666;
        Wed, 30 Nov 2022 14:30:19 -0800 (PST)
Received: from ?IPV6:2a01:c22:77d6:e700:1465:fbc6:a2a6:9b65? (dynamic-2a01-0c22-77d6-e700-1465-fbc6-a2a6-9b65.c22.pool.telefonica.de. [2a01:c22:77d6:e700:1465:fbc6:a2a6:9b65])
        by smtp.googlemail.com with ESMTPSA id hg6-20020a05600c538600b003a6125562e1sm3177413wmb.46.2022.11.30.14.30.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 14:30:19 -0800 (PST)
Message-ID: <d3d7ee26-429d-ab01-c364-553b5bc602f1@gmail.com>
Date:   Wed, 30 Nov 2022 23:30:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: [PATCH net-next 2/2] r8169: enable GRO software interrupt coalescing
 per default
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e4d1cc88-2064-caa0-c786-41f8720869a4@gmail.com>
In-Reply-To: <e4d1cc88-2064-caa0-c786-41f8720869a4@gmail.com>
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

There are reports about r8169 not reaching full line speed on certain
systems (e.g. SBC's) with a 2.5Gbps link.
There was a time when hardware interrupt coalescing was enabled per
default, but this was changed due to ASPM-related issues on few systems.
So let's use software interrupt coalescing instead and enable it
using new function netdev_sw_irq_coalesce_default_on().

Even with these conservative settings interrupt load on my 1Gbps test
system reduced significantly.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 5bc1181f8..f4e160888 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5282,6 +5282,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->hw_features |= NETIF_F_RXALL;
 	dev->hw_features |= NETIF_F_RXFCS;
 
+	netdev_sw_irq_coalesce_default_on(dev);
+
 	/* configure chip for default features */
 	rtl8169_set_features(dev, dev->features);
 
-- 
2.38.1

