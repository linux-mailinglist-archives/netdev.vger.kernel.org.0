Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8AE31E14E
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 22:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbhBQVZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 16:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbhBQVYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 16:24:49 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2A2C061756
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 13:24:08 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id n8so18857330wrm.10
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 13:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=y4YdLMuf0KTKOouoR3VajUoP0eQWSuLkckPIViIu7Pk=;
        b=Zl+UQxUSoC++gAKBFljIq7zUZZ0vb2qMRpLqebFJb15gwMYkdP6FKxuxax7oWmkTaz
         ahuWCT32751Dzx6+fKNrUQOvNcGgjIKF3t9F6T/skSe59UOIIjuLAIBvhUiltJCz1KoX
         notAO5vZGdiEJQC3IyJo1UC0Wcf19Qcfari9LaBolpN1ZBrx6zAn0ILqUh3thkHhahqi
         27WijGUMpqrMClf1tWF4BAAHYwTvc3pEcZLqgpbNVt9lYPh6/jY0F5x72xvifpMnoDiJ
         aGVff8/LsMum4iTkBiaQ9HefVbNXvIMW5Vd7Y77cyT3JmxRZXt5qBxdRrH45h4lV/3Xc
         Ir2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=y4YdLMuf0KTKOouoR3VajUoP0eQWSuLkckPIViIu7Pk=;
        b=Pzeoaslao6BFObQyV1b0za8lfTjp1hckmWqvX1rRwXV2pbjVX4BR4hbv91a/YmduPG
         ytWIdGC2wuoHra5hyHr/AJvVMF9mbx6HSq/4OUyOk2VRFXO6p48c+vb1cyUSdRh5XVOM
         fcRorVpS806ZV371O+VBBJZBxyzAUl7/P8CCRIJRkh+bRg7f7mvYWLEFM/1jySG18XJz
         Pn41hUtfjk9DfPpQhB+GhBVYKmvJfDPFo0or3odAJAMss6dipY8SRQhuql0nPEYmG79s
         hF6cpt+ucNQIf6DuT/aN9YWMIXYw8mCgSobFmDbgs3Grg0ev/KntAC43W8wAXP/jGNV7
         VPVw==
X-Gm-Message-State: AOAM531h4aU1ziYK7KsNUNYoL/HfRK3PmxFrXum/DAtPk/Wu+UdJXR5A
        A7vhHpcuy7F6qxFAzIv4mOGhV57Eg4+nVA==
X-Google-Smtp-Source: ABdhPJxdgzYNvTp0WvzcnmNHk1uBeVyi1zExetD2VkPdxrfPiL3rMgSS0t4SEZc9CpevM994N9Ng/Q==
X-Received: by 2002:a5d:5149:: with SMTP id u9mr1101712wrt.348.1613597047314;
        Wed, 17 Feb 2021 13:24:07 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:3459:b70a:ad7d:c95e? (p200300ea8f395b003459b70aad7dc95e.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:3459:b70a:ad7d:c95e])
        by smtp.googlemail.com with ESMTPSA id l2sm5667077wrm.6.2021.02.17.13.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 13:24:07 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: use macro pm_ptr
Message-ID: <c79d075a-e30d-7960-83cb-820a18abd782@gmail.com>
Date:   Wed, 17 Feb 2021 22:23:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use macro pm_ptr(), this helps to avoid some ifdeffery.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index cbc30df4e..0a20dae32 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5414,9 +5414,7 @@ static struct pci_driver rtl8169_pci_driver = {
 	.probe		= rtl_init_one,
 	.remove		= rtl_remove_one,
 	.shutdown	= rtl_shutdown,
-#ifdef CONFIG_PM
-	.driver.pm	= &rtl8169_pm_ops,
-#endif
+	.driver.pm	= pm_ptr(&rtl8169_pm_ops),
 };
 
 module_pci_driver(rtl8169_pci_driver);
-- 
2.30.1

