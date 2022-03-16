Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72A04DBA1F
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 22:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355860AbiCPVcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 17:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344158AbiCPVcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 17:32:21 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24F42611D
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 14:31:05 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b24so4311219edu.10
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 14:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:to:cc:content-language
         :subject:content-transfer-encoding;
        bh=vhO3N6XTzM31dOYGUeEFhrFXLVqO21MmykPlJ88Vok8=;
        b=DXGOYVS25Kx9tskgmnZUws+P6u/vUgODkKeB9IXdiCdLPH0U7W++tv6tzYpgJzKNtn
         GfTQD4EGtF79t191oMMcULYZf8biBwHLOZnmPrUUJ1v1jvZCYlP84BTfbNypU8YQLogJ
         mjDUh09rc09ReTauoZ6D1PhAQgVB/CnXRdhnMhmSTMHrxVchwwE3EF65XMER4dz7I7cT
         of/vcFjYiiDOHtTar7GAPlfds1MtJRs0xvD3ZRnZdJ+cHl7SGTqNVY+S8wGOPtUK09OG
         6TcQyV7ZtJVbkbV7SkQo5bk8rgKcrPitq+JQHcKYhYlntSUOXUh+nptXPgctj3j1soZ+
         uYng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from:to
         :cc:content-language:subject:content-transfer-encoding;
        bh=vhO3N6XTzM31dOYGUeEFhrFXLVqO21MmykPlJ88Vok8=;
        b=71UWCCToDvzBLSrP6Sbyt3RYDm6Ez3v0H2PpR0UcNgt2B2vMGzUl2hgVE4VbofI398
         4kVXmlb9WbpRRQTi0jUzzoWF1qY8M/QcYK/gVZWd8ppfcSB1anrStI449mUvPSjbpvqy
         jJh4jipPlfrna5YB9ZZR1LX7mPzC7JofD4FSubMcUiJHkXsWrCzWp4tVslMzLyoprcrt
         0GxjDOv032/FXsciqPSmf5Ml5wOvYVpbUo8Ekkzv+JH9mrAvO3zKfmQSB517BF0+9xTG
         icCBu9o46qH7FtHGiPhwzoYCd6nnDzQmh32252N22f1yquKYgiU0BQkOpcQUhDW55Oan
         lrKQ==
X-Gm-Message-State: AOAM531W6ygzmdBgJebQaUPWsEfE/15cVqSo65aLSkR1ZiZe9AYMptsq
        8dO7UgfO5xxU/xp3cq7GjL8=
X-Google-Smtp-Source: ABdhPJxMPTJtFiJGq8cSGt3FA+FI4LbPFDMdm6Oruu46JWfHYWLrmPuh/G1UmJy+cCQLVnSV4ZEA3A==
X-Received: by 2002:a05:6402:100e:b0:416:596a:2581 with SMTP id c14-20020a056402100e00b00416596a2581mr1369419edu.181.1647466264366;
        Wed, 16 Mar 2022 14:31:04 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b866:cc00:e490:2de6:a89f:9b66? (dynamic-2a01-0c23-b866-cc00-e490-2de6-a89f-9b66.c23.pool.telefonica.de. [2a01:c23:b866:cc00:e490:2de6:a89f:9b66])
        by smtp.googlemail.com with ESMTPSA id ca21-20020aa7cd75000000b004188bc5712fsm1515645edb.73.2022.03.16.14.31.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 14:31:03 -0700 (PDT)
Message-ID: <1de3b176-c09c-1654-6f00-9785f7a4f954@gmail.com>
Date:   Wed, 16 Mar 2022 22:31:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Yanko Kaneti <yaneti@declera.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Subject: [PATCH net-next] r8169: improve driver unload and system shutdown
 behavior on DASH-enabled systems
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a number of systems supporting DASH remote management.
Driver unload and system shutdown can result in the PHY suspending,
thus making DASH unusable. Improve this by handling DASH being enabled
very similar to WoL being enabled.

Tested-by: Yanko Kaneti <yaneti@declera.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 67014eb76..33f5c5698 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1397,8 +1397,11 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 	rtl_lock_config_regs(tp);
 
 	device_set_wakeup_enable(tp_to_dev(tp), wolopts);
-	rtl_set_d3_pll_down(tp, !wolopts);
-	tp->dev->wol_enabled = wolopts ? 1 : 0;
+
+	if (tp->dash_type == RTL_DASH_NONE) {
+		rtl_set_d3_pll_down(tp, !wolopts);
+		tp->dev->wol_enabled = wolopts ? 1 : 0;
+	}
 }
 
 static int rtl8169_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
@@ -4938,6 +4941,9 @@ static int rtl8169_runtime_idle(struct device *device)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(device);
 
+	if (tp->dash_type != RTL_DASH_NONE)
+		return -EBUSY;
+
 	if (!netif_running(tp->dev) || !netif_carrier_ok(tp->dev))
 		pm_schedule_suspend(device, 10000);
 
@@ -4978,7 +4984,8 @@ static void rtl_shutdown(struct pci_dev *pdev)
 	/* Restore original MAC address */
 	rtl_rar_set(tp, tp->dev->perm_addr);
 
-	if (system_state == SYSTEM_POWER_OFF) {
+	if (system_state == SYSTEM_POWER_OFF &&
+	    tp->dash_type == RTL_DASH_NONE) {
 		if (tp->saved_wolopts)
 			rtl_wol_shutdown_quirk(tp);
 
@@ -5449,7 +5456,12 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* configure chip for default features */
 	rtl8169_set_features(dev, dev->features);
 
-	rtl_set_d3_pll_down(tp, true);
+	if (tp->dash_type == RTL_DASH_NONE) {
+		rtl_set_d3_pll_down(tp, true);
+	} else {
+		rtl_set_d3_pll_down(tp, false);
+		dev->wol_enabled = 1;
+	}
 
 	jumbo_max = rtl_jumbo_max(tp);
 	if (jumbo_max)
-- 
2.35.1

