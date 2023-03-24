Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A9E6C83BB
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbjCXRwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbjCXRwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:52:01 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6101ABFF;
        Fri, 24 Mar 2023 10:51:42 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id w25so2195796qtc.5;
        Fri, 24 Mar 2023 10:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679680301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QLbggjUBWDhCFAFfhTFn/HC3bA9ftKuc9kzs8SaypEw=;
        b=Km3u7U/hWu1WfQRVv0wtAQowQt7VdHwtGoQunxxrZFiarxq356cArSlobk6vhFnpYO
         B6BhpOUxqEgcnQwASKGXfhhloYvfQM16aNYaCQBM2jf7AEWaUGS4dzlF+L1JrSZYOHRm
         Er8M7l8P2Icj9U0Z5pO9gMbDn0fxnwWGl8vfq+Ck2B74llmXEq+QUkkMGeqIj40ENyHm
         Lh0cTQkqOrtFWxVSuPdaQLPHw09sCv71Z+78Oss1qbUXkART1z1utc0CrvZQp6k5J7hY
         CZ91kRJHNibQxOQm4ocWeE4tOUvOtxVBOokW/eZ/0kyK0vKqhY6G6YooJkzecaEG8E2g
         RslA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679680301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QLbggjUBWDhCFAFfhTFn/HC3bA9ftKuc9kzs8SaypEw=;
        b=lKHdNfX+GETCPeQxZSA9tILIx2DFNT2OBy62oKg7RJRayLUa4HiGv/5utNMHXGVfvf
         PUfHPGbHN5AQY6AfJ6Wu3QBLIyk6Kby1W7HAJt6mfZon41icwX1XnrxAvcpwPzI/j820
         8vMo+4fE8GqEDwkRkd+WrgAS2XgAExCb5i+SkA2Fq0f2B0obVsoj6OwOk0flxh1SSUYR
         VdU60IMnKbVkpwulxxuPfg5ahxacvu4CBRLiKAqbyZ6F/Z4GE+YTUX6OoTcq0hzBcjAn
         IAVgPDbkFtR+BxM8Wqhf1F163lVldlewBWBSYMXWUSVPvhqPH0vCtfWNZaYNuht9xsFC
         +ZCA==
X-Gm-Message-State: AO0yUKXljfrXMutFwOo/rXeeMXB2AH8wQrlavHXbzou8/4DY41vDF7to
        JWz7lg4l7UK5kjL1G7gaQZU=
X-Google-Smtp-Source: AK7set+46/9A5AmXsNxTBiyOANyCPNhdwWXAZCRZgfC8v/PcsDn4TwwuwEH5uK1W6w7qVveRiT/JQA==
X-Received: by 2002:a05:622a:206:b0:3da:cef1:79b5 with SMTP id b6-20020a05622a020600b003dacef179b5mr5070647qtx.26.1679680300788;
        Fri, 24 Mar 2023 10:51:40 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id o5-20020a375a05000000b007464fcca543sm14421460qkb.50.2023.03.24.10.51.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 10:51:40 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v4 02/10] net: sunhme: Just restart autonegotiation if we can't bring the link up
Date:   Fri, 24 Mar 2023 13:51:28 -0400
Message-Id: <20230324175136.321588-3-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230324175136.321588-1-seanga2@gmail.com>
References: <20230324175136.321588-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we've tried regular autonegotiation and forcing the link mode, just
restart autonegotiation instead of reinitializing the whole NIC.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---

(no changes since v2)

Changes in v2:
- Move happy_meal_begin_auto_negotiation earlier and remove forward declaration

 drivers/net/ethernet/sun/sunhme.c | 245 +++++++++++++++---------------
 1 file changed, 119 insertions(+), 126 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 7cf8210ebbec..e52f2d9305bc 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -589,8 +589,6 @@ static int set_happy_link_modes(struct happy_meal *hp, void __iomem *tregs)
 	return 1;
 }
 
-static int happy_meal_init(struct happy_meal *hp);
-
 static int is_lucent_phy(struct happy_meal *hp)
 {
 	void __iomem *tregs = hp->tcvregs;
@@ -606,6 +604,124 @@ static int is_lucent_phy(struct happy_meal *hp)
 	return ret;
 }
 
+/* hp->happy_lock must be held */
+static void
+happy_meal_begin_auto_negotiation(struct happy_meal *hp,
+				  void __iomem *tregs,
+				  const struct ethtool_link_ksettings *ep)
+{
+	int timeout;
+
+	/* Read all of the registers we are interested in now. */
+	hp->sw_bmsr      = happy_meal_tcvr_read(hp, tregs, MII_BMSR);
+	hp->sw_bmcr      = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
+	hp->sw_physid1   = happy_meal_tcvr_read(hp, tregs, MII_PHYSID1);
+	hp->sw_physid2   = happy_meal_tcvr_read(hp, tregs, MII_PHYSID2);
+
+	/* XXX Check BMSR_ANEGCAPABLE, should not be necessary though. */
+
+	hp->sw_advertise = happy_meal_tcvr_read(hp, tregs, MII_ADVERTISE);
+	if (!ep || ep->base.autoneg == AUTONEG_ENABLE) {
+		/* Advertise everything we can support. */
+		if (hp->sw_bmsr & BMSR_10HALF)
+			hp->sw_advertise |= (ADVERTISE_10HALF);
+		else
+			hp->sw_advertise &= ~(ADVERTISE_10HALF);
+
+		if (hp->sw_bmsr & BMSR_10FULL)
+			hp->sw_advertise |= (ADVERTISE_10FULL);
+		else
+			hp->sw_advertise &= ~(ADVERTISE_10FULL);
+		if (hp->sw_bmsr & BMSR_100HALF)
+			hp->sw_advertise |= (ADVERTISE_100HALF);
+		else
+			hp->sw_advertise &= ~(ADVERTISE_100HALF);
+		if (hp->sw_bmsr & BMSR_100FULL)
+			hp->sw_advertise |= (ADVERTISE_100FULL);
+		else
+			hp->sw_advertise &= ~(ADVERTISE_100FULL);
+		happy_meal_tcvr_write(hp, tregs, MII_ADVERTISE, hp->sw_advertise);
+
+		/* XXX Currently no Happy Meal cards I know off support 100BaseT4,
+		 * XXX and this is because the DP83840 does not support it, changes
+		 * XXX would need to be made to the tx/rx logic in the driver as well
+		 * XXX so I completely skip checking for it in the BMSR for now.
+		 */
+
+		ASD("Advertising [ %s%s%s%s]\n",
+		    hp->sw_advertise & ADVERTISE_10HALF ? "10H " : "",
+		    hp->sw_advertise & ADVERTISE_10FULL ? "10F " : "",
+		    hp->sw_advertise & ADVERTISE_100HALF ? "100H " : "",
+		    hp->sw_advertise & ADVERTISE_100FULL ? "100F " : "");
+
+		/* Enable Auto-Negotiation, this is usually on already... */
+		hp->sw_bmcr |= BMCR_ANENABLE;
+		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
+
+		/* Restart it to make sure it is going. */
+		hp->sw_bmcr |= BMCR_ANRESTART;
+		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
+
+		/* BMCR_ANRESTART self clears when the process has begun. */
+
+		timeout = 64;  /* More than enough. */
+		while (--timeout) {
+			hp->sw_bmcr = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
+			if (!(hp->sw_bmcr & BMCR_ANRESTART))
+				break; /* got it. */
+			udelay(10);
+		}
+		if (!timeout) {
+			netdev_err(hp->dev,
+				   "Happy Meal would not start auto negotiation BMCR=0x%04x\n",
+				   hp->sw_bmcr);
+			netdev_notice(hp->dev,
+				      "Performing force link detection.\n");
+			goto force_link;
+		} else {
+			hp->timer_state = arbwait;
+		}
+	} else {
+force_link:
+		/* Force the link up, trying first a particular mode.
+		 * Either we are here at the request of ethtool or
+		 * because the Happy Meal would not start to autoneg.
+		 */
+
+		/* Disable auto-negotiation in BMCR, enable the duplex and
+		 * speed setting, init the timer state machine, and fire it off.
+		 */
+		if (!ep || ep->base.autoneg == AUTONEG_ENABLE) {
+			hp->sw_bmcr = BMCR_SPEED100;
+		} else {
+			if (ep->base.speed == SPEED_100)
+				hp->sw_bmcr = BMCR_SPEED100;
+			else
+				hp->sw_bmcr = 0;
+			if (ep->base.duplex == DUPLEX_FULL)
+				hp->sw_bmcr |= BMCR_FULLDPLX;
+		}
+		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
+
+		if (!is_lucent_phy(hp)) {
+			/* OK, seems we need do disable the transceiver for the first
+			 * tick to make sure we get an accurate link state at the
+			 * second tick.
+			 */
+			hp->sw_csconfig = happy_meal_tcvr_read(hp, tregs,
+							       DP83840_CSCONFIG);
+			hp->sw_csconfig &= ~(CSCONFIG_TCVDISAB);
+			happy_meal_tcvr_write(hp, tregs, DP83840_CSCONFIG,
+					      hp->sw_csconfig);
+		}
+		hp->timer_state = ltrywait;
+	}
+
+	hp->timer_ticks = 0;
+	hp->happy_timer.expires = jiffies + (12 * HZ)/10;  /* 1.2 sec. */
+	add_timer(&hp->happy_timer);
+}
+
 static void happy_meal_timer(struct timer_list *t)
 {
 	struct happy_meal *hp = from_timer(hp, t, happy_timer);
@@ -743,12 +859,7 @@ static void happy_meal_timer(struct timer_list *t)
 					netdev_notice(hp->dev,
 						      "Link down, cable problem?\n");
 
-					ret = happy_meal_init(hp);
-					if (ret) {
-						/* ho hum... */
-						netdev_err(hp->dev,
-							   "Error, cannot re-init the Happy Meal.\n");
-					}
+					happy_meal_begin_auto_negotiation(hp, tregs, NULL);
 					goto out;
 				}
 				if (!is_lucent_phy(hp)) {
@@ -1201,124 +1312,6 @@ static void happy_meal_init_rings(struct happy_meal *hp)
 	HMD("done\n");
 }
 
-/* hp->happy_lock must be held */
-static void
-happy_meal_begin_auto_negotiation(struct happy_meal *hp,
-				  void __iomem *tregs,
-				  const struct ethtool_link_ksettings *ep)
-{
-	int timeout;
-
-	/* Read all of the registers we are interested in now. */
-	hp->sw_bmsr      = happy_meal_tcvr_read(hp, tregs, MII_BMSR);
-	hp->sw_bmcr      = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
-	hp->sw_physid1   = happy_meal_tcvr_read(hp, tregs, MII_PHYSID1);
-	hp->sw_physid2   = happy_meal_tcvr_read(hp, tregs, MII_PHYSID2);
-
-	/* XXX Check BMSR_ANEGCAPABLE, should not be necessary though. */
-
-	hp->sw_advertise = happy_meal_tcvr_read(hp, tregs, MII_ADVERTISE);
-	if (!ep || ep->base.autoneg == AUTONEG_ENABLE) {
-		/* Advertise everything we can support. */
-		if (hp->sw_bmsr & BMSR_10HALF)
-			hp->sw_advertise |= (ADVERTISE_10HALF);
-		else
-			hp->sw_advertise &= ~(ADVERTISE_10HALF);
-
-		if (hp->sw_bmsr & BMSR_10FULL)
-			hp->sw_advertise |= (ADVERTISE_10FULL);
-		else
-			hp->sw_advertise &= ~(ADVERTISE_10FULL);
-		if (hp->sw_bmsr & BMSR_100HALF)
-			hp->sw_advertise |= (ADVERTISE_100HALF);
-		else
-			hp->sw_advertise &= ~(ADVERTISE_100HALF);
-		if (hp->sw_bmsr & BMSR_100FULL)
-			hp->sw_advertise |= (ADVERTISE_100FULL);
-		else
-			hp->sw_advertise &= ~(ADVERTISE_100FULL);
-		happy_meal_tcvr_write(hp, tregs, MII_ADVERTISE, hp->sw_advertise);
-
-		/* XXX Currently no Happy Meal cards I know off support 100BaseT4,
-		 * XXX and this is because the DP83840 does not support it, changes
-		 * XXX would need to be made to the tx/rx logic in the driver as well
-		 * XXX so I completely skip checking for it in the BMSR for now.
-		 */
-
-		ASD("Advertising [ %s%s%s%s]\n",
-		    hp->sw_advertise & ADVERTISE_10HALF ? "10H " : "",
-		    hp->sw_advertise & ADVERTISE_10FULL ? "10F " : "",
-		    hp->sw_advertise & ADVERTISE_100HALF ? "100H " : "",
-		    hp->sw_advertise & ADVERTISE_100FULL ? "100F " : "");
-
-		/* Enable Auto-Negotiation, this is usually on already... */
-		hp->sw_bmcr |= BMCR_ANENABLE;
-		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
-
-		/* Restart it to make sure it is going. */
-		hp->sw_bmcr |= BMCR_ANRESTART;
-		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
-
-		/* BMCR_ANRESTART self clears when the process has begun. */
-
-		timeout = 64;  /* More than enough. */
-		while (--timeout) {
-			hp->sw_bmcr = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
-			if (!(hp->sw_bmcr & BMCR_ANRESTART))
-				break; /* got it. */
-			udelay(10);
-		}
-		if (!timeout) {
-			netdev_err(hp->dev,
-				   "Happy Meal would not start auto negotiation BMCR=0x%04x\n",
-				   hp->sw_bmcr);
-			netdev_notice(hp->dev,
-				      "Performing force link detection.\n");
-			goto force_link;
-		} else {
-			hp->timer_state = arbwait;
-		}
-	} else {
-force_link:
-		/* Force the link up, trying first a particular mode.
-		 * Either we are here at the request of ethtool or
-		 * because the Happy Meal would not start to autoneg.
-		 */
-
-		/* Disable auto-negotiation in BMCR, enable the duplex and
-		 * speed setting, init the timer state machine, and fire it off.
-		 */
-		if (!ep || ep->base.autoneg == AUTONEG_ENABLE) {
-			hp->sw_bmcr = BMCR_SPEED100;
-		} else {
-			if (ep->base.speed == SPEED_100)
-				hp->sw_bmcr = BMCR_SPEED100;
-			else
-				hp->sw_bmcr = 0;
-			if (ep->base.duplex == DUPLEX_FULL)
-				hp->sw_bmcr |= BMCR_FULLDPLX;
-		}
-		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
-
-		if (!is_lucent_phy(hp)) {
-			/* OK, seems we need do disable the transceiver for the first
-			 * tick to make sure we get an accurate link state at the
-			 * second tick.
-			 */
-			hp->sw_csconfig = happy_meal_tcvr_read(hp, tregs,
-							       DP83840_CSCONFIG);
-			hp->sw_csconfig &= ~(CSCONFIG_TCVDISAB);
-			happy_meal_tcvr_write(hp, tregs, DP83840_CSCONFIG,
-					      hp->sw_csconfig);
-		}
-		hp->timer_state = ltrywait;
-	}
-
-	hp->timer_ticks = 0;
-	hp->happy_timer.expires = jiffies + (12 * HZ)/10;  /* 1.2 sec. */
-	add_timer(&hp->happy_timer);
-}
-
 /* hp->happy_lock must be held */
 static int happy_meal_init(struct happy_meal *hp)
 {
-- 
2.37.1

