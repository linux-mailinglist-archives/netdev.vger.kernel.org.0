Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B805E5BC092
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 01:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiIRX2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 19:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiIRX06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 19:26:58 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5D118357;
        Sun, 18 Sep 2022 16:26:45 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id h28so19531875qka.0;
        Sun, 18 Sep 2022 16:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=8pbxZjF/RhWmoIGCjzSwGdndkU6NZbU29iK5d8jcQ3o=;
        b=mghTESWIyiSWn6i6Ar8D4bD1U9cN+HCjkBocsOr0Lry5x0Ht72wndUAf7Lqgz0bAD8
         dbbzrbzKI1x5qc1IiiGLYmruRzkaFip9MfeOvFi6YL33UdCMyclk8hq813zSiPqh/Rfm
         FSKSMpkdqJfgKjNqEu3a2kYPF9ZT08ivntyxK8VrZKe5a+rxx68LWNL91err894JA0OH
         0zczpUjNPCdOfZwSElmgeA5ZUvFVPvuPGYgQw5GLjRlE9HqdaSSaNC/VqBD4CIkJzp2v
         IGskkvP84OGDCnf9AVcDjjR3bNbeAhM7UUSZwe09dak3Z0ZCDbiblE+VLZgFTIqHz791
         i1JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=8pbxZjF/RhWmoIGCjzSwGdndkU6NZbU29iK5d8jcQ3o=;
        b=Js46C5EKy54iKa5qVwAtLhvityu3O7hDWE8SG91FttpU+0MI86ofrDKzHUJigPwKt3
         X21KQ6p0KeQ6TYUyTT1acUCsvVLiDIkVJKCflmtAhssMLuuWSa0xxF/ziAWoEq6D1fAI
         A5NfA90lmqqA8VeY/JVbVmb8MCMEI9GqGLJC7yeHsbR0gYnB8d8oB9RyXxBJYKWwNOCS
         mKXJzXX6EU9JJ3lkxl12Qx1AS4BjC/ui3hn0YeuA7BwrTfYs1msetbjTLmDU0Av0eACX
         guj8UpcKvzMhH2QLOXSOSV88sN49X+1PQipE7wjWxxYuWlWoNeiubYna6jsFYu2UwQbJ
         BzwA==
X-Gm-Message-State: ACrzQf3VLSf8W3FrJilOFuc7WBhtr7IXBIvvl9NywP4nRuYe1cdT+0cU
        A2Rv51ijJ6JUyw6zKluwuvk=
X-Google-Smtp-Source: AMsMyM60vCWI9BHgGaq453Q0PU1I+UnThgkTfphJ5UEpyg0uXrcwYJcbMU1KCdKA6dyWnu7Mz2lDeQ==
X-Received: by 2002:a05:620a:1283:b0:6ce:f08b:ead0 with SMTP id w3-20020a05620a128300b006cef08bead0mr4391568qki.669.1663543604316;
        Sun, 18 Sep 2022 16:26:44 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id c4-20020a05620a268400b006b633dc839esm11763677qkp.66.2022.09.18.16.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 16:26:43 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list),
        Zheyu Ma <zheyuma97@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next 12/13] sunhme: Use vdbg for spam-y prints
Date:   Sun, 18 Sep 2022 19:26:25 -0400
Message-Id: <20220918232626.1601885-13-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220918232626.1601885-1-seanga2@gmail.com>
References: <20220918232626.1601885-1-seanga2@gmail.com>
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

 drivers/net/ethernet/sun/sunhme.c | 29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 9965c9c872a6..8e4927589524 100644
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
@@ -1834,7 +1813,7 @@ static void happy_meal_tx(struct happy_meal *hp)
 		u32 flags, dma_addr, dma_len;
 		int frag;
 
-		TXD("TX[%d]\n", elem);
+		netdev_vdbg(hp->dev, "TX[%d]\n", elem);
 		this = &txbase[elem];
 		flags = hme_read_desc32(hp, &this->tx_flags);
 		if (flags & TXFLAG_OWN)
@@ -1901,7 +1880,7 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 
 		/* Check for errors. */
 		if ((len < ETH_ZLEN) || (flags & RXFLAG_OVERFLOW)) {
-			RXD("RX[%d ERR(%08x)]", elem, flags);
+			netdev_vdbg(dev, "RX[%d ERR(%08x)]", elem, flags);
 			dev->stats.rx_errors++;
 			if (len < ETH_ZLEN)
 				dev->stats.rx_length_errors++;
@@ -1973,7 +1952,7 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 		skb->csum = csum_unfold(~(__force __sum16)htons(csum));
 		skb->ip_summed = CHECKSUM_COMPLETE;
 
-		RXD("RX[%d len=%d csum=%4x]", elem, len, csum);
+		netdev_vdbg(dev, "RX[%d len=%d csum=%4x]", elem, len, csum);
 		skb->protocol = eth_type_trans(skb, dev);
 		netif_rx(skb);
 
@@ -2179,7 +2158,7 @@ static netdev_tx_t happy_meal_start_xmit(struct sk_buff *skb,
 	}
 
 	entry = hp->tx_new;
-	SXD("SX<l[%d]e[%d]>\n", skb->len, entry);
+	netdev_vdbg(dev, "SX<l[%d]e[%d]>\n", skb->len, entry);
 	hp->tx_skbs[entry] = skb;
 
 	if (skb_shinfo(skb)->nr_frags == 0) {
-- 
2.37.1

