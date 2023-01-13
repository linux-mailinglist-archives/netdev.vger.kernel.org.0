Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14303668E3F
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239769AbjAMGtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjAMGso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:48:44 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DE27A901
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 22:33:40 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id fy8so49914180ejc.13
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 22:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lQhZ+TwxDKyi6IiDkLAC/UJvUKEPKZCm3T6E/ZGXWVE=;
        b=Rf+VrAQ5aQjHcG9a5/u6RtyCnuYbhBgbK4J9Ngoul6wcfYiZjyysB5BBHxMxgzgwzg
         2eWPZRv5A5h1bk/KTuZFQjcd07QYBIApzDrAKGIS3idzLkmMbB8g1zu4yEwCMHFdOazT
         SLbBIXLhi1GpdvNC1BqjxRFfGO1bpU0OEaEzm1029xNGAPQE8sk5vAa5IDhOEowX1Fjq
         FiiK8GNmeXEauXdyfzDDz9CIEVVMQ8H+nv4BbBocLP6sUb5JzU1LEjfAtXJDmLm+11UO
         Sqf+hIXNqP5lhD/nGeADPdlAhYLMMZhHwXSWdRuoC49+79VMBFIvSUtLpuErQkEwsnV5
         5wmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lQhZ+TwxDKyi6IiDkLAC/UJvUKEPKZCm3T6E/ZGXWVE=;
        b=aRJ8daVHlE54SMqsV8rXHkWgkPUksWoK1OKG2TE3g31+/L6Nw3ngmHvRxEzQioxQVM
         x6fN5RcmkfBuw7m9jO1+/YAVI99HMLw/5QJD6fsL0lUeVngXcupeBrcwDP3BY1KfZHu0
         z7PtdbljWmykg5A7HUlBV6YG/F+Swbc5girFWJKq+NTgE3zOlnxVRVBGAH+eCl++N6ku
         5azXL2bBgjiC2E1WAFsntNhaCCiXTbTBKJt4yZSHk7AIHdOz8xpMmi1pGihNO2ZgTwMs
         G3MaxYT2L0Y36oKP1Gljx0i/wDLS0vESbpGpsWE0q6wIChPnCoPg0lX3DCHtyChDSjnv
         1/Hw==
X-Gm-Message-State: AFqh2krA82buW01dWBMTPWkLVrCqvA03bGMLY3ZLq6shxSIgvgQZ+HWp
        tZypI9LHjUSkxL96ZYziM2Q=
X-Google-Smtp-Source: AMrXdXv63mwpU+BFYeHcO+Y45rVb+13hYh/o6lI2aONgoPLUW/+05ot9Ib34DMA0dYavEgxm8zYn1g==
X-Received: by 2002:a17:907:a481:b0:7c0:c1cc:c68 with SMTP id vp1-20020a170907a48100b007c0c1cc0c68mr67389988ejc.6.1673591546814;
        Thu, 12 Jan 2023 22:32:26 -0800 (PST)
Received: from ?IPV6:2a01:c23:b9df:eb00:305a:2f95:59b3:1211? (dynamic-2a01-0c23-b9df-eb00-305a-2f95-59b3-1211.c23.pool.telefonica.de. [2a01:c23:b9df:eb00:305a:2f95:59b3:1211])
        by smtp.googlemail.com with ESMTPSA id 15-20020a170906310f00b00738795e7d9bsm8092104ejx.2.2023.01.12.22.32.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 22:32:26 -0800 (PST)
Message-ID: <85f2b5e5-ea85-3a84-1a5e-c4f84897ac04@gmail.com>
Date:   Fri, 13 Jan 2023 07:32:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Language: en-US
Subject: [PATCH net-next] r8169: reset bus if NIC isn't accessible after tx
 timeout
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

ASPM issues may result in the NIC not being accessible any longer.
In this case disabling ASPM may not work. Therefore detect this case
by checking whether register reads return ~0, and try to make the
NIC accessible again by resetting the secondary bus.

Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 49c124d8e..b79ccde70 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4535,6 +4535,10 @@ static void rtl_task(struct work_struct *work)
 		goto out_unlock;
 
 	if (test_and_clear_bit(RTL_FLAG_TASK_TX_TIMEOUT, tp->wk.flags)) {
+		/* if NIC isn't accessible, reset secondary bus to revive it */
+		if (RTL_R32(tp, TxConfig) == ~0)
+			pci_reset_bus(tp->pci_dev);
+
 		/* ASPM compatibility issues are a typical reason for tx timeouts */
 		ret = pci_disable_link_state(tp->pci_dev, PCIE_LINK_STATE_L1 |
 							  PCIE_LINK_STATE_L0S);
-- 
2.39.0

