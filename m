Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8826E4423
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjDQJkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjDQJjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:39:47 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F03235A4
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:39:00 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u3so10439225ejj.12
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681724334; x=1684316334;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tRUb1jq6dyRB1byqY/bTgCFESHTySsZnF7VVr6Rsffk=;
        b=arecx17cX1mMOuW4wOrHUcWd5k6pvudYg+wa4n4o/rtQGsloHelKlX+fCwN2W98DlY
         nhNPMAVbuDR/alIBmYTeW3Z1zJXyLBvI88kb7OyVjH35IOwBmMUYS/19vC6NoFM/6bJp
         /NHGvnxCE0Yxi7ZHPTOSYwLwtQJsp432R5tCamjmTTu02yz+5qzYfrUyiuiaEz02/bmD
         Bh3HGuWCay9dF+I0Yb6+cUpp5yaF5taTsgxnXyofwaUJylyy9PD5wKnFdqLCiIVQglMP
         /+ilS8HBIaiREeMu+3P8qjUM2WrUr9BTeDA1KaVHZW+We2ecGx9JuggzqLPtFI1h62G+
         T7nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681724334; x=1684316334;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRUb1jq6dyRB1byqY/bTgCFESHTySsZnF7VVr6Rsffk=;
        b=cJsdTciee29kZJG/ZOV80sUqXI3PlysUzTIFmhFnC2Waw9sdI7zVMnS4mM0jWeWeWB
         VNaitXZmd/fYCj8o40zZhbtNFAizRyIlJIT6F3SBIUrV0UoVMUY2mhCQNffssxKI2Ec7
         s4srTAy6g/XOUu78jxQGj2+mL7euyY16c4KBAZcNUKl7iP23TVEyNm9jqtP4+s/6B3dX
         OF92pMq+o9ohKSRiPTRiKFRMqyqmIIutTszxd8zn+CunTI+PXQFppm1C08fG3K6p9Kgx
         sn7YKXbLo/jm0vafi+GZqD/V1b2yV6HuA0mGOtznqEA0kcBySnMsLwb9Bog+w4Nbym4x
         bO9g==
X-Gm-Message-State: AAQBX9d4wDO8IoYtcmb1KJmOg1Mf6VYImElxVx5sXA+FtUqLtexpwx03
        mhKhSsSo9YiVY2xhGqgsTJ8=
X-Google-Smtp-Source: AKy350Yx2sUMUEOGDehcXSjRShH6arkO46HnfzAKg2R9phj312niRh/ge7t36YWMqYPgxDPbC9Rd7A==
X-Received: by 2002:a17:906:6bd9:b0:94e:43ce:95f6 with SMTP id t25-20020a1709066bd900b0094e43ce95f6mr7263966ejs.47.1681724333999;
        Mon, 17 Apr 2023 02:38:53 -0700 (PDT)
Received: from ?IPV6:2a01:c22:770d:1c00:59f1:1548:39fc:ccd5? (dynamic-2a01-0c22-770d-1c00-59f1-1548-39fc-ccd5.c22.pool.telefonica.de. [2a01:c22:770d:1c00:59f1:1548:39fc:ccd5])
        by smtp.googlemail.com with ESMTPSA id a12-20020a170906368c00b0094e8de89111sm6277995ejc.201.2023.04.17.02.38.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 02:38:53 -0700 (PDT)
Message-ID: <d1dc186b-ea95-35fa-6fcf-d885e7626656@gmail.com>
Date:   Mon, 17 Apr 2023 11:38:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: [PATCH net-next v3 3/3] r8169: use new macro
 netif_subqueue_completed_wake in the tx cleanup path
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7147a001-3d9c-a48d-d398-a94c666aa65b@gmail.com>
In-Reply-To: <7147a001-3d9c-a48d-d398-a94c666aa65b@gmail.com>
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

Use new net core macro netif_subqueue_completed_wake to simplify
the code of the tx cleanup path.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index fff44d46b..a7e376e7e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4371,20 +4371,12 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
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

