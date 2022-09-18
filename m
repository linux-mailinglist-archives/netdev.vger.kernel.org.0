Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5275BC0A0
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 01:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiIRX0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 19:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiIRX0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 19:26:41 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9321707C;
        Sun, 18 Sep 2022 16:26:39 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id s13so20746206qvq.10;
        Sun, 18 Sep 2022 16:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=8N8HEycdLAoSNsPU4lmWCROhFmQPZjZr+OJRW3/rKd0=;
        b=K9q7paqQVbU9FYFCjsqXw5JEKel5oFfCe/cAO14DeKrFeNFaGDIaxSrPbFa9ppUU14
         4u792xWpJlprz1y4TG2CloFYhNXcCg1LPgkzKADNAxBmS9fHT5NA4dkTOnf9XkJ/Xxjs
         eLHLo2OPDorUvao9s/r4laxP5FxNSoEWRODKPsOyBTQ7Ebn0Q5RIxq/trBu6WKO5Kt5q
         Mr9KhIA8FoKPYUQIyP9w5DrhjW3QijskZeDWxV6wUE+mX5YypNAKMCjIVg8msOTzJaT3
         4+jH0eYZ+ARCoFVijJKFuNp2YSSA1tEeQn7C5jEd28MpsawWaTGi4/1jqKw6KXeGQn0x
         JgxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=8N8HEycdLAoSNsPU4lmWCROhFmQPZjZr+OJRW3/rKd0=;
        b=kol6MmNIgHbH5f0FjxwAO1UfACYvbmiOkZEOCOMpr9NOf+hdjO5mOUB4xJYfDOf6tu
         g+MDfFj8+cAPyscAsZKnCz6Jd5SQjEpjUti+2/ARtPy/JUaCBeLqjNxWvBEUo/UqW5F5
         qgpcFJUPxmCi/Xr+6p0TsWxcWUfnmr+EHC7b1vmn/vZ/wGELR/uJTJXBFa1lpUEc1cDg
         Pyt22xgBZyFpedF9lS7XEhHIrxAX9WflEETnKL42LzIMlSI5R3gHNmu7hneq38gHvvBB
         lhr3N3KPUBJ0JIrQtlVj322pOx3QNxl/RL0C5UxArRH0Ym7CoFXR7QIPvNNuK3d12sQB
         H62g==
X-Gm-Message-State: ACrzQf0aNNxPhXACYLaH1f0DAiFj4wi5LD0h5TTwyDsRuPTgEtXDQySO
        ZgulnBHU71wSten29vk3S8Q=
X-Google-Smtp-Source: AMsMyM5sz+3JPn51EcZhPgX4aUtfLiBqg2O6Hjj2HytisO/DNPN4iS6e6bJkMU/xJVApqS50GsDvyg==
X-Received: by 2002:a05:6214:508b:b0:4ac:bb3f:dcc3 with SMTP id kk11-20020a056214508b00b004acbb3fdcc3mr12347403qvb.8.1663543599330;
        Sun, 18 Sep 2022 16:26:39 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id s14-20020ac85ece000000b00339b8a5639csm9350216qtx.95.2022.09.18.16.26.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 16:26:38 -0700 (PDT)
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
Subject: [PATCH net-next 08/13] sunhme: Clean up debug infrastructure
Date:   Sun, 18 Sep 2022 19:26:21 -0400
Message-Id: <20220918232626.1601885-9-seanga2@gmail.com>
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

Remove all the single-use debug conditionals, and just collect the debug
defines at the top of the file. HMD seems like it is used for general debug
info, so just redefine it as pr_debug. Additionally, instead of using the
default loglevel, use the debug loglevel for debugging.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 drivers/net/ethernet/sun/sunhme.c | 72 ++++++++++++++-----------------
 1 file changed, 32 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 16b81beb3ffb..ae206d552c27 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -80,13 +80,37 @@ static struct quattro *qfe_sbus_list;
 static struct quattro *qfe_pci_list;
 #endif
 
-#undef HMEDEBUG
-#undef SXDEBUG
-#undef RXDEBUG
-#undef TXDEBUG
-#undef TXLOGGING
+#define HMD pr_debug
 
-#ifdef TXLOGGING
+/* "Auto Switch Debug" aka phy debug */
+#if 0
+#define ASD pr_debug
+#else
+#define ASD(...)
+#endif
+
+/* Transmit debug */
+#if 0
+#define TXD pr_debug
+#else
+#define TXD(...)
+#endif
+
+/* Skid buffer debug */
+#if 0
+#define SXD pr_debug
+#else
+#define SXD(...)
+#endif
+
+/* Receive debug */
+#if 0
+#define RXD pr_debug
+#else
+#define RXD(...)
+#endif
+
+#if 0
 struct hme_tx_logent {
 	unsigned int tstamp;
 	int tx_new, tx_old;
@@ -129,22 +153,8 @@ static __inline__ void tx_dump_log(void)
 	}
 }
 #else
-#define tx_add_log(hp, a, s)		do { } while(0)
-#define tx_dump_log()			do { } while(0)
-#endif
-
-#ifdef HMEDEBUG
-#define HMD printk
-#else
-#define HMD(...)
-#endif
-
-/* #define AUTO_SWITCH_DEBUG */
-
-#ifdef AUTO_SWITCH_DEBUG
-#define ASD printk
-#else
-#define ASD(...)
+#define tx_add_log(hp, a, s)
+#define tx_dump_log()
 #endif
 
 #define DEFAULT_IPG0      16 /* For lance-mode only */
@@ -1842,12 +1852,6 @@ static void happy_meal_mif_interrupt(struct happy_meal *hp)
 	happy_meal_poll_stop(hp, tregs);
 }
 
-#ifdef TXDEBUG
-#define TXD printk
-#else
-#define TXD(...)
-#endif
-
 /* hp->happy_lock must be held */
 static void happy_meal_tx(struct happy_meal *hp)
 {
@@ -1906,12 +1910,6 @@ static void happy_meal_tx(struct happy_meal *hp)
 		netif_wake_queue(dev);
 }
 
-#ifdef RXDEBUG
-#define RXD printk
-#else
-#define RXD(...)
-#endif
-
 /* Originally I used to handle the allocation failure by just giving back just
  * that one ring buffer to the happy meal.  Problem is that usually when that
  * condition is triggered, the happy meal expects you to do something reasonable
@@ -2173,12 +2171,6 @@ static int happy_meal_close(struct net_device *dev)
 	return 0;
 }
 
-#ifdef SXDEBUG
-#define SXD printk
-#else
-#define SXD(...)
-#endif
-
 static void happy_meal_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct happy_meal *hp = netdev_priv(dev);
-- 
2.37.1

