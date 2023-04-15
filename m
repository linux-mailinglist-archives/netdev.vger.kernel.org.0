Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537CC6E2F77
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 09:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjDOHYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 03:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDOHYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 03:24:21 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCF859EA
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 00:24:19 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id dm2so51287371ejc.8
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 00:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681543458; x=1684135458;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tRUb1jq6dyRB1byqY/bTgCFESHTySsZnF7VVr6Rsffk=;
        b=AwrsagBmpdIfSywXpBoc17BZ4+5wH97ixx9QnT/VGUsQJbYu5S5Mnjvw5MrL8rih0F
         RkKJZM6UoCxwkbyfKAJTWvmhYMqpGGVqAV3JeWbLYx/0vs36SIoSZ/uAIBbauR3GDtXd
         FqZyQp58sgjIli0J9AzVl/0WgNH4MbQjL9bAWj24wHKGc5AIIGydg1WcDaiObk1j2HWY
         Zzgt2xbwvVv4IvdH0zYgaQdb2y/1qFM/5Hrutp8w8H6urDCojdbOVraDDpV8EsW22T7Q
         BvADI0fae/306hM88FoAyRbpJk1tyrofGliO7MYSimnlt45xS+ETiAF3eEp2TXArGRLG
         n7sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681543458; x=1684135458;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRUb1jq6dyRB1byqY/bTgCFESHTySsZnF7VVr6Rsffk=;
        b=khgaDXVEih744+/C5unDAZNQA0SE4u7bFZaDBbjqHooer1RbO/VR0IUp1qcuDELwYg
         Tmd4TLS1butyf8K9kDBO8MvFtgWiyoaQfmrlAmsbkIUlmNt6fydAd/aefdBwglCq5h9D
         bqglRp6/GmHORy8UJmHgRKulzFpdqt8Jkb6SeEVh1FIvE9LEnuj2vvx53DsqTmH/3Efy
         nNUt5NAvbtoIVlVtFDkvnovxh/04fX2VVZMUZEXR49SWSAVyYuHxt4/q/0Jtp6ngRexc
         wAqrurzAfeYm62ft1XMvk/YZ7ELzm3skcRh0pGdeR9NAyzyLKFHamOObStLuuSwZfH2g
         YYqg==
X-Gm-Message-State: AAQBX9fNG3l789+UOp5YqropbUBtq4Udw8VeGXocADiqjvmaB54iLW40
        P0fPpj8MrvEhbLU+sgsb90s=
X-Google-Smtp-Source: AKy350ZugidO6GPKzviXfcR3ew30QCdfFDwgI2/Oir0PMym9+G6iB78+q28uCOTs1IvW7vH5TlBI7Q==
X-Received: by 2002:a17:906:af9a:b0:94e:e6b9:fef2 with SMTP id mj26-20020a170906af9a00b0094ee6b9fef2mr1460279ejb.67.1681543458265;
        Sat, 15 Apr 2023 00:24:18 -0700 (PDT)
Received: from ?IPV6:2a01:c22:76c9:5300:c449:604e:39a7:3bce? (dynamic-2a01-0c22-76c9-5300-c449-604e-39a7-3bce.c22.pool.telefonica.de. [2a01:c22:76c9:5300:c449:604e:39a7:3bce])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7cb87000000b0050687ca0c92sm1161685edt.84.2023.04.15.00.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Apr 2023 00:24:18 -0700 (PDT)
Message-ID: <c406b18b-906f-29a2-d724-581d727fa79b@gmail.com>
Date:   Sat, 15 Apr 2023 09:23:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: [PATCH net-next v2 3/3] r8169: use new macro
 netif_subqueue_completed_wake in the tx cleanup path
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f07fd01b-b431-6d8d-bd14-d447dffd8e64@gmail.com>
In-Reply-To: <f07fd01b-b431-6d8d-bd14-d447dffd8e64@gmail.com>
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


