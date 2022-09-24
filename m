Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E8E5E8724
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 03:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbiIXBzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 21:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233146AbiIXByy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 21:54:54 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537AA145977;
        Fri, 23 Sep 2022 18:53:59 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id c11so1120274qtw.8;
        Fri, 23 Sep 2022 18:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=3bs0N5FwO/r0I3aQCR6SfwM41fBZ9Ic0KQjMl09QWjk=;
        b=ZXHC5ypKv1ZGjdXJiWNL8dsr0d1r67+YgujjKk6DxMNlj1+9ggIx05H0bYS1dUJnjy
         +iONTkuPuP579bZtaM2znKhSdOiOEkWw+gjoFEHQHXPUc2KD//K4FGNDvAbdcxCWlBm1
         1RExhs3HZEnN+pRMmrAzrxPz7zTgLjb3lodZAs7cHTumjqDMzTAksFz6tr5pIWX7BDaa
         IJ0uEcXg10LlBEBraG1+f6cHgzVKdwk+JEB3tQEtO8Z1+HwxiGDEt8syre9skftm9gOt
         zK7Z7IjHukvG7vLoJmdTSBP7uP9d7DJsTaHfGjvZDv8sf27DIvUQoL6KmOzJvKPYwSon
         Tjnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=3bs0N5FwO/r0I3aQCR6SfwM41fBZ9Ic0KQjMl09QWjk=;
        b=TPEyLy0+U5A02V5HLNXv3Fxt9XggtDZS4m6yRxvkFK6jtV0uEdWqTH30Tz6NbIhedG
         r3crKqwfAWa5VhFKV75ynYUn8ttuIArvhTbXDXFLpnczX/jlvNYzX16Vi0gckVl+ViOB
         xPzVcBUHm3vu8xBREvAmanEIQ2y33RV6siFFCtHAsVkyMP3wQleoMYeDRetjcOYuGDKZ
         PI67RmV+PWBwWbW9UwR+B9ME50ynko6UqFF9gBs4as4IeiecEl8eIwBvoyf1+sABgPo8
         g7MgQoOKaMU+viFfF1wGOIYZA8vJs0NhCgujS+0JGkBXH3nzwmN6JAkozqMTb/O2xdtf
         w02A==
X-Gm-Message-State: ACrzQf0yT621eUIKbbImEMwea+gi/wiaV2+gWyKC4TuZVGr/TeTYe29b
        ilcAHruD+cOcEJIztvLBuJk=
X-Google-Smtp-Source: AMsMyM4NoqWWbAyhrpxWzm3iSHZn5UKo/dspK1DtGupdppRMRjesNg5E8ydEvbkdy1BnUPDOekYf+g==
X-Received: by 2002:a05:622a:1a1b:b0:35c:d51b:505b with SMTP id f27-20020a05622a1a1b00b0035cd51b505bmr10097224qtb.308.1663984438720;
        Fri, 23 Sep 2022 18:53:58 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id bb4-20020a05622a1b0400b0035cf2995ad8sm6183121qtb.51.2022.09.23.18.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 18:53:58 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Zheyu Ma <zheyuma97@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v2 12/13] sunhme: Use vdbg for spam-y prints
Date:   Fri, 23 Sep 2022 21:53:38 -0400
Message-Id: <20220924015339.1816744-13-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220924015339.1816744-1-seanga2@gmail.com>
References: <20220924015339.1816744-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SXD, TXD, and RXD macros are used only once (or twice). Just use the
vdbg print, which seems to have been devised for these sorts of very
verbose messages.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

(no changes since v1)

 drivers/net/ethernet/sun/sunhme.c | 29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 51a04353e08e..3afa73db500c 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -90,27 +90,6 @@ static struct quattro *qfe_pci_list;
 #define ASD(...)
 #endif
 
-/* Transmit debug */
-#if 1
-#define TXD hme_debug
-#else
-#define TXD(...)
-#endif
-
-/* Skid buffer debug */
-#if 1
-#define SXD hme_debug
-#else
-#define SXD(...)
-#endif
-
-/* Receive debug */
-#if 1
-#define RXD hme_debug
-#else
-#define RXD(...)
-#endif
-
 #if 0
 struct hme_tx_logent {
 	unsigned int tstamp;
@@ -1832,7 +1811,7 @@ static void happy_meal_tx(struct happy_meal *hp)
 		u32 flags, dma_addr, dma_len;
 		int frag;
 
-		TXD("TX[%d]\n", elem);
+		netdev_vdbg(hp->dev, "TX[%d]\n", elem);
 		this = &txbase[elem];
 		flags = hme_read_desc32(hp, &this->tx_flags);
 		if (flags & TXFLAG_OWN)
@@ -1899,7 +1878,7 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 
 		/* Check for errors. */
 		if ((len < ETH_ZLEN) || (flags & RXFLAG_OVERFLOW)) {
-			RXD("RX[%d ERR(%08x)]", elem, flags);
+			netdev_vdbg(dev, "RX[%d ERR(%08x)]", elem, flags);
 			dev->stats.rx_errors++;
 			if (len < ETH_ZLEN)
 				dev->stats.rx_length_errors++;
@@ -1971,7 +1950,7 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 		skb->csum = csum_unfold(~(__force __sum16)htons(csum));
 		skb->ip_summed = CHECKSUM_COMPLETE;
 
-		RXD("RX[%d len=%d csum=%4x]", elem, len, csum);
+		netdev_vdbg(dev, "RX[%d len=%d csum=%4x]", elem, len, csum);
 		skb->protocol = eth_type_trans(skb, dev);
 		netif_rx(skb);
 
@@ -2177,7 +2156,7 @@ static netdev_tx_t happy_meal_start_xmit(struct sk_buff *skb,
 	}
 
 	entry = hp->tx_new;
-	SXD("SX<l[%d]e[%d]>\n", skb->len, entry);
+	netdev_vdbg(dev, "SX<l[%d]e[%d]>\n", skb->len, entry);
 	hp->tx_skbs[entry] = skb;
 
 	if (skb_shinfo(skb)->nr_frags == 0) {
-- 
2.37.1

