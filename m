Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D651C42B9
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgEDR2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730014AbgEDR2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:28:33 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86396C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:28:33 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x17so59822wrt.5
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 10:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qZ6LlpUY0DgjzXmBPD6mCjKzp415SYPr0WTEL9OCffw=;
        b=N91B708jSJZfjPAhOPJE54KjFIBI4xEadYRg5A+8jc4h5isQkej3k5A4dTRplTjXL0
         tHUtnrrQouetSPeZnLwhG5xf+E4GhI56/gbip5btK6xx5wNecXRmruo1s6y7Aig+sABF
         XvSnZJeQTAPJn/uYARfiySCXRpDCTeQf4dJAxpqvM7QA+/9C8/o/TgHtKslF5SIfavHP
         XfC1ePmyvqQMlk0ZwTbnu4V+FThdyxQWycnV0vYAInL+3P/4vsokd1FUIWBr3f9KGl9c
         cDt9GQGoidt/oyLyhvp/zvzbl24NGZLfgDMgR4OjFtlJhL6dd4OEZOcCdTKRXND/kJY5
         cO5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qZ6LlpUY0DgjzXmBPD6mCjKzp415SYPr0WTEL9OCffw=;
        b=rA5/EsbUQeKC2O9JeT3wQgz9nyUk6IApxPfpnfvEkvpV2mKngkBMP7qUXnm63V8Anx
         x4vZPqIxE5kEKZc56aBsxYgUPp0o5vRT2SAFCz5WB4BNpCqV/57Fux92dkUTnqQiOMEH
         nsipaE2e3zBWFGas+WHaBv7u33j7+eAisz1z66cbtr1ynCXRoetfmyuU/rjCu4+SJaMy
         xUJs3xKksUjd/kcANd+fHpMY4YIvieva3s3qsmBPmmu3KXZRsofSBeSlamdP2AyKIgAQ
         lR6ycrwRb4tD2I9znZMMzn7TaXPKPEnd8wJCM1sg5DQNH4WNA98MjrsOspKCfv9Jnyvo
         vTRg==
X-Gm-Message-State: AGi0Puaikdqqnblqp6WvbAWwABqCjNMmHRAo3z4hJXOTViMiqi0xJFNx
        XiSOkyn2iLRvreFNyFOCL5cxQuxo
X-Google-Smtp-Source: APiQypKIRU4qcH8PF+MlZtTqbeOG3WDBY8Dd40NXvAiMZDTWh0xTor2wg7Qyh33r1cdTyPkhZY2njw==
X-Received: by 2002:adf:9482:: with SMTP id 2mr364858wrr.328.1588613311999;
        Mon, 04 May 2020 10:28:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:c500:c07a:3448:98ce:439e? (p200300EA8F43C500C07A344898CE439E.dip0.t-ipconnect.de. [2003:ea:8f43:c500:c07a:3448:98ce:439e])
        by smtp.googlemail.com with ESMTPSA id u7sm118305wmg.41.2020.05.04.10.28.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 10:28:31 -0700 (PDT)
Subject: [PATCH net-next 2/2] r8169: use new helper eth_hw_addr_crc
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <329df165-a6a3-3c3b-cbb3-ea77ce2ea672@gmail.com>
Message-ID: <1589b27a-7bf6-6f51-441f-442c0af7ca86@gmail.com>
Date:   Mon, 4 May 2020 19:28:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <329df165-a6a3-3c3b-cbb3-ea77ce2ea672@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new helper eth_hw_addr_crc to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8b665f2ec..2f6512ed0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -19,7 +19,6 @@
 #include <linux/ethtool.h>
 #include <linux/phy.h>
 #include <linux/if_vlan.h>
-#include <linux/crc32.h>
 #include <linux/in.h>
 #include <linux/io.h>
 #include <linux/ip.h>
@@ -2610,7 +2609,7 @@ static void rtl_set_rx_mode(struct net_device *dev)
 
 		mc_filter[1] = mc_filter[0] = 0;
 		netdev_for_each_mc_addr(ha, dev) {
-			u32 bit_nr = ether_crc(ETH_ALEN, ha->addr) >> 26;
+			u32 bit_nr = eth_hw_addr_crc(ha) >> 26;
 			mc_filter[bit_nr >> 5] |= BIT(bit_nr & 31);
 		}
 
-- 
2.26.2


