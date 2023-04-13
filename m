Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9006E150D
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 21:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjDMTRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 15:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjDMTR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 15:17:28 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8D89029
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:17:10 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id s12so6775913wrb.1
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681413429; x=1684005429;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=metY6p2SbdJqId2s/ZvyI/bQ/cGWvZRnBDqDhbQZMIE=;
        b=kmi+zNxL0MSlh+eOey+H51dNusOGo3cbvr5nXSZJ54pQvypaimh3GSesNFC4fyvWc2
         Hg0Pl8LT/1OYOTS3MJ2PjKMbmuaaFog4Kz1VdAGTwATHXVub5+aPuMZD+CbDkmP49OL0
         PD3GHmTY8dNya6gYGbLGXiKsCQxOD6Z19R6ZwBHfJjEP75pA9PKfxdoGxUgu351IdhiC
         6U+lRiRaq9XCzG80Mo1CtyF7ayE9vMBxEMZJqB1l81u+e6G3Kc3tlQmJ7b1xdpURTU65
         bk/4E30bArP/mjBdYeK2HK4wC5gukOzXRiU173YqOEjMwsOBN5N81fk6SCXdIZ20wGW1
         Vrug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681413429; x=1684005429;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=metY6p2SbdJqId2s/ZvyI/bQ/cGWvZRnBDqDhbQZMIE=;
        b=D0+LQ1Qeh7apUr68nuwsbUO3kgFDXLlOBdcKNA43Rg8qaJnZ04YGsYj+Uvh7GiXQXD
         wdgaDUvc7NGJdBRjT1DmVTJCjd3m+ashItZw9lir2LXlTp+2pwp7FzkDyJzN620EYHQT
         0Ar1VHBjyZ3wtYEvJ+didWwnOvnuumm6FoT1PgzEu2b3POWxdVZiYFN1TJQ7kWTlQNcO
         elw7Dhoar2eNIh57EwaCd8Rr1PKI/bbYSQEpAHIboUScOKNECJJxgdOfk8tv7Ilu9RlL
         UDXTUmwtUaQGiG0jm6r9bSDOvVa8i9LMVCiBEnbzULZyCYRd0WZRTUiuiZPHPUmuvoKG
         lG0A==
X-Gm-Message-State: AAQBX9dWSOpQyP2C/cyiQB3lpiYcCSOpT/kf8Z/9H3vLpJA1Utjq1TSl
        bPgWZE36RZnNlNwXNB8rdTQ=
X-Google-Smtp-Source: AKy350b1Ysik5kbmA/JKfQ8tcr35fiHpSR7W1kIqMs/So95B7qWURD9DKb1ESAFs5IFmjHVrdWyBqQ==
X-Received: by 2002:adf:e74c:0:b0:2e6:348:5fef with SMTP id c12-20020adfe74c000000b002e603485fefmr2055376wrn.55.1681413428692;
        Thu, 13 Apr 2023 12:17:08 -0700 (PDT)
Received: from ?IPV6:2a01:c22:738e:4400:f580:be04:1a64:fc5e? (dynamic-2a01-0c22-738e-4400-f580-be04-1a64-fc5e.c22.pool.telefonica.de. [2a01:c22:738e:4400:f580:be04:1a64:fc5e])
        by smtp.googlemail.com with ESMTPSA id r12-20020adff10c000000b002cfe685bfd6sm1870221wro.108.2023.04.13.12.17.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 12:17:08 -0700 (PDT)
Message-ID: <3ef7166d-ce47-e24c-1df4-bb76a39c96c3@gmail.com>
Date:   Thu, 13 Apr 2023 21:16:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: [PATCH net-next 3/3] r8169: use new macro
 netif_subqueue_completed_wake in the tx cleanup path
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <32e7eaf4-7e1c-04ce-eee5-a190349b31f9@gmail.com>
In-Reply-To: <32e7eaf4-7e1c-04ce-eee5-a190349b31f9@gmail.com>
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

Use new net core macro netif_subqueue_completed_wake to simplify
the code of the tx cleanup path.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3f0b78fd9..5cfdb60ab 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4372,20 +4372,12 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 	}
 
 	if (tp->dirty_tx != dirty_tx) {
-		netdev_completed_queue(dev, pkts_compl, bytes_compl);
 		dev_sw_netstats_tx_add(dev, pkts_compl, bytes_compl);
+		WRITE_ONCE(tp->dirty_tx, dirty_tx);
 
-		/* Sync with rtl8169_start_xmit:
-		 * - publish dirty_tx ring index (write barrier)
-		 * - refresh cur_tx ring index and queue status (read barrier)
-		 * May the current thread miss the stopped queue condition,
-		 * a racing xmit thread can only have a right view of the
-		 * ring status.
-		 */
-		smp_store_mb(tp->dirty_tx, dirty_tx);
-		if (netif_queue_stopped(dev) &&
-		    rtl_tx_slots_avail(tp) >= R8169_TX_START_THRS)
-			netif_wake_queue(dev);
+		netif_subqueue_completed_wake(dev, 0, pkts_compl, bytes_compl,
+					      rtl_tx_slots_avail(tp),
+					      R8169_TX_START_THRS);
 		/*
 		 * 8168 hack: TxPoll requests are lost when the Tx packets are
 		 * too close. Let's kick an extra TxPoll request when a burst
-- 
2.40.0


