Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF665E871D
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 03:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbiIXByi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 21:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbiIXByP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 21:54:15 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBC0109771;
        Fri, 23 Sep 2022 18:53:54 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id ml1so1064252qvb.1;
        Fri, 23 Sep 2022 18:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=AqcwPX5NrwQ5Phxc7B78FzyStvxIApMlNxgtoCkojQ4=;
        b=eMimTk6wJD/NSK7tI+TJy/WBpVBlogF0MThwgAYiJxErF8WGoYr7IIdsGj82s4xPK0
         DB6u7zfNnJYFuD51Dj7YAS5Kv+MpogxYAcFi+qHhZAS5rkyOLd9mnoZMmQD5ZPSA/Hqz
         L2icfXWhtxlTvhiYPtazBFw6a9b3Asug8E981pCD6284zmQaol8fwoDfpp2t0wbzGIQv
         do3M3vQWV5JNvdFI7HcfwFQvNJlgtubgHYD/zIa8Mjid3uefHbqB/5uLD6Tl8RsMcyou
         T7srWm/4cORBYpUS1l65ejxWsoI03MagpZFHt3LQzsPsFm3IJ44M14/5KsYOM8Ws4jer
         6erQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=AqcwPX5NrwQ5Phxc7B78FzyStvxIApMlNxgtoCkojQ4=;
        b=lc/KVZkzovsvNuS3kCQBjYJy6RL5qBIk1+s+blXupJXQZ28TgOq7n+2kP2hfTBsWr8
         VwrYlIXY8ilXLSxgxqQrz6ZKtt5j+tkwcsNcTe6nuGPbaNIfoXyTuJusvr7mbpseQ907
         wGyFGTEK/LN+YLqnSGDkzTtsrvkVupivebry3M7XdvXN7efBEYQ8fTD2BoEyJOJgDn23
         5FjaLjwIIntRT5zQsNkQD8ax+SThnFoNYFjWrK4f/Ycj8rmsN9/FQibqJw367Qk4on5n
         ECQHoDoLeVgM6LDEstYxfxn+R+TRf/M3QYK+xq2m7gchytv7NlWS236dTuVmaxwH2tk+
         YSMg==
X-Gm-Message-State: ACrzQf1MLaEGUGSaEnttLvouCN96qm2DoMyHDMGTGfQ3qE6qWABIoU4o
        7otIkFlcoYt1XqeBA9mvuLo=
X-Google-Smtp-Source: AMsMyM4Tg7+nu4VMjSeTeps5gCW3slq2mnLxrn7FFOTRQ+ls6Emux7a058MRnZkqdWnycdj/fcoiDA==
X-Received: by 2002:a05:6214:d4f:b0:4ab:20:87c5 with SMTP id 15-20020a0562140d4f00b004ab002087c5mr9387753qvr.55.1663984433391;
        Fri, 23 Sep 2022 18:53:53 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id w25-20020a05620a0e9900b006b5c061844fsm6908182qkm.49.2022.09.23.18.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 18:53:53 -0700 (PDT)
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
Subject: [PATCH net-next v2 08/13] sunhme: Clean up debug infrastructure
Date:   Fri, 23 Sep 2022 21:53:34 -0400
Message-Id: <20220924015339.1816744-9-seanga2@gmail.com>
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

Remove all the single-use debug conditionals, and just collect the debug
defines at the top of the file. HMD seems like it is used for general debug
info, so just redefine it as pr_debug. Additionally, instead of using the
default loglevel, use the debug loglevel for debugging.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

(no changes since v1)

 drivers/net/ethernet/sun/sunhme.c | 72 ++++++++++++++-----------------
 1 file changed, 32 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 77a2a192f2ce..cea99ddc4ce5 100644
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

