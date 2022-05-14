Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E25B5271D7
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 16:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbiENORm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 10:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbiENORk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 10:17:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE0A1116D;
        Sat, 14 May 2022 07:17:36 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id iq10so10495865pjb.0;
        Sat, 14 May 2022 07:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N2k+Isl+sOcDD7NLNzf36x6iwDEAfomPn6Ceuobwoj8=;
        b=eKAd7Qjm1zOu0ZTJtm7WbmExZ4SlGb3O73IYgy91c2I0JSERoCr4RA+7RM23I4GXrb
         CQbcsDZXqzgMb5C6S2Cbe5alK6o+5IJKhIOEex1WB0vSCo5wMcKuWOj3+iWE4BvoL/9T
         t6lpStmBmOV3WswTsT3a2P7mgOisrouVd2TH1uJ3s6pZmxch2OQZVD/nw6WlUiV9DlJJ
         ruUY40ZaXh6BdF/W+DxBwgZiNNslyVqlFkbGYQpuh9D4v01QNd7FLBnOR8aMQV6cQGgm
         MmJ2g+Y7tmVuGuZN4zhvuMIoEqwnIa7PUggIGs3u2oZ5GICpX91VV3wGMan6SMtwPZyQ
         vO2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=N2k+Isl+sOcDD7NLNzf36x6iwDEAfomPn6Ceuobwoj8=;
        b=cNRbUI81/SHnsJ0yS3HXT5STnJoSL1HAMM+3EdBDhvzwCuBCnb47GY0itKzWBbDKMl
         oEZ5fyPIwuBAuzO5N9xMrUOolyIJWAMnRfCGZYLy/2aqUxtVuvB9wbQAsihaVMIf+QQH
         S+D+e3porJXZ/MWiFS6mH6kujTcfGewQkSRqiHv0tvbu9UprSKoNyYE9TB7G847+x8k3
         ywAZGmN2ZGOzywqNfqZ/wVhWug0q4OX3crcYUgavDWoWj0PZ0lGyESjQSEYLMeVjXTYL
         O186Zb0xMoId98DYP7OTyahvnnORMS/Yi6Ij1CGEiXimnT3TptKzSHyFQ2omY4adm237
         6QDQ==
X-Gm-Message-State: AOAM530aZ4hDKKTpNokL6g1BDVc41VauW+JDSsXtcSW3EM+Xjr/Kd8DJ
        +2fjUaMrcjn9KnSW7Q1rPdJLfXy1eoImdNVP
X-Google-Smtp-Source: ABdhPJwPzbHSNsj9dbC0cqBf7Ij3t+TWaBK7sYYngDWyEGhuHSTFFkys/A/7gn8Wj/3l4JEtQWQ/Eg==
X-Received: by 2002:a17:90b:8c6:b0:1da:248b:2f95 with SMTP id ds6-20020a17090b08c600b001da248b2f95mr10093342pjb.125.1652537856310;
        Sat, 14 May 2022 07:17:36 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id x8-20020a17090a530800b001cd4989feccsm5298541pjh.24.2022.05.14.07.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 07:17:36 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and can_skb_headroom_valid to skb.c
Date:   Sat, 14 May 2022 23:16:49 +0900
Message-Id: <20220514141650.1109542-4-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions can_dropped_invalid_skb() and can_skb_headroom_valid()
grew a lot over the years to a point which it does not make much sense
to have them defined as static inline in header files. Move those two
functions to the .c counterpart of skb.h.

can_skb_headroom_valid() only caller being can_dropped_invalid_skb(),
the declaration is removed from the header. Only
can_dropped_invalid_skb() gets its symbol exported.

While doing so, do a small cleanup: add brackets around the else block
in can_dropped_invalid_skb().

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev/skb.c | 58 ++++++++++++++++++++++++++++++++++++++
 include/linux/can/skb.h   | 59 +--------------------------------------
 2 files changed, 59 insertions(+), 58 deletions(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 61660248c69e..8b1991130de5 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -252,3 +252,61 @@ struct sk_buff *alloc_can_err_skb(struct net_device *dev, struct can_frame **cf)
 	return skb;
 }
 EXPORT_SYMBOL_GPL(alloc_can_err_skb);
+
+/* Check for outgoing skbs that have not been created by the CAN subsystem */
+static bool can_skb_headroom_valid(struct net_device *dev, struct sk_buff *skb)
+{
+	/* af_packet creates a headroom of HH_DATA_MOD bytes which is fine */
+	if (WARN_ON_ONCE(skb_headroom(skb) < sizeof(struct can_skb_priv)))
+		return false;
+
+	/* af_packet does not apply CAN skb specific settings */
+	if (skb->ip_summed == CHECKSUM_NONE) {
+		/* init headroom */
+		can_skb_prv(skb)->ifindex = dev->ifindex;
+		can_skb_prv(skb)->skbcnt = 0;
+
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+		/* perform proper loopback on capable devices */
+		if (dev->flags & IFF_ECHO)
+			skb->pkt_type = PACKET_LOOPBACK;
+		else
+			skb->pkt_type = PACKET_HOST;
+
+		skb_reset_mac_header(skb);
+		skb_reset_network_header(skb);
+		skb_reset_transport_header(skb);
+	}
+
+	return true;
+}
+
+/* Drop a given socketbuffer if it does not contain a valid CAN frame. */
+bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
+{
+	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
+
+	if (skb->protocol == htons(ETH_P_CAN)) {
+		if (unlikely(skb->len != CAN_MTU ||
+			     cfd->len > CAN_MAX_DLEN))
+			goto inval_skb;
+	} else if (skb->protocol == htons(ETH_P_CANFD)) {
+		if (unlikely(skb->len != CANFD_MTU ||
+			     cfd->len > CANFD_MAX_DLEN))
+			goto inval_skb;
+	} else {
+		goto inval_skb;
+	}
+
+	if (!can_skb_headroom_valid(dev, skb))
+		goto inval_skb;
+
+	return false;
+
+inval_skb:
+	kfree_skb(skb);
+	dev->stats.tx_dropped++;
+	return true;
+}
+EXPORT_SYMBOL_GPL(can_dropped_invalid_skb);
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index fdb22b00674a..182749e858b3 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -31,6 +31,7 @@ struct sk_buff *alloc_canfd_skb(struct net_device *dev,
 				struct canfd_frame **cfd);
 struct sk_buff *alloc_can_err_skb(struct net_device *dev,
 				  struct can_frame **cf);
+bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb);
 
 /*
  * The struct can_skb_priv is used to transport additional information along
@@ -96,64 +97,6 @@ static inline struct sk_buff *can_create_echo_skb(struct sk_buff *skb)
 	return nskb;
 }
 
-/* Check for outgoing skbs that have not been created by the CAN subsystem */
-static inline bool can_skb_headroom_valid(struct net_device *dev,
-					  struct sk_buff *skb)
-{
-	/* af_packet creates a headroom of HH_DATA_MOD bytes which is fine */
-	if (WARN_ON_ONCE(skb_headroom(skb) < sizeof(struct can_skb_priv)))
-		return false;
-
-	/* af_packet does not apply CAN skb specific settings */
-	if (skb->ip_summed == CHECKSUM_NONE) {
-		/* init headroom */
-		can_skb_prv(skb)->ifindex = dev->ifindex;
-		can_skb_prv(skb)->skbcnt = 0;
-
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-
-		/* perform proper loopback on capable devices */
-		if (dev->flags & IFF_ECHO)
-			skb->pkt_type = PACKET_LOOPBACK;
-		else
-			skb->pkt_type = PACKET_HOST;
-
-		skb_reset_mac_header(skb);
-		skb_reset_network_header(skb);
-		skb_reset_transport_header(skb);
-	}
-
-	return true;
-}
-
-/* Drop a given socketbuffer if it does not contain a valid CAN frame. */
-static inline bool can_dropped_invalid_skb(struct net_device *dev,
-					  struct sk_buff *skb)
-{
-	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
-
-	if (skb->protocol == htons(ETH_P_CAN)) {
-		if (unlikely(skb->len != CAN_MTU ||
-			     cfd->len > CAN_MAX_DLEN))
-			goto inval_skb;
-	} else if (skb->protocol == htons(ETH_P_CANFD)) {
-		if (unlikely(skb->len != CANFD_MTU ||
-			     cfd->len > CANFD_MAX_DLEN))
-			goto inval_skb;
-	} else
-		goto inval_skb;
-
-	if (!can_skb_headroom_valid(dev, skb))
-		goto inval_skb;
-
-	return false;
-
-inval_skb:
-	kfree_skb(skb);
-	dev->stats.tx_dropped++;
-	return true;
-}
-
 static inline bool can_is_canfd_skb(const struct sk_buff *skb)
 {
 	/* the CAN specific type of skb is identified by its data length */
-- 
2.35.1

