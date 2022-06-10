Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C8E546861
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 16:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345844AbiFJObg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 10:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348475AbiFJOa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 10:30:57 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855D613F1D;
        Fri, 10 Jun 2022 07:30:56 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id c14so24892180pgu.13;
        Fri, 10 Jun 2022 07:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wPNc3YvhAKuZLbvOFj+YsMRBSINjKQKB6Tw7aOecxnY=;
        b=eBE6qF4nlQl7Zl2Y4JN5Z1kvFZl/AvZg1ykYz2OKXqqlf6SNkATUGveE5RrTyXmiSp
         RRld7jpaOGIFNJpMPHA158hfAMfiStGQYI064o9FNhVJmdU+wRZJ42aIxmNZW/epc5pe
         fYGe3RBFCo0LxqlGUQKgds2G0BlrOkrLByI0ZFY0wZ/43XyaxOq3nQyibWRrVZnwc8pL
         jr9470C59XLGlpAQTlAtnH9aq8R3AgPgy0avtBIKcIkRQABAw6m9oaFg248RhNohZ04J
         hpgD4Y+i+2t4rbRcUHpDX6vOPpuVd5+emZXbqmxSd1utJtEQ1CYUEFVP46XPd3jueNQl
         INig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=wPNc3YvhAKuZLbvOFj+YsMRBSINjKQKB6Tw7aOecxnY=;
        b=qqJerzY2777VP4gG+vVoVAcDXwuD/aeTvT4dy6udLi/bo3QJJJge2tAQoDG9HvhRrg
         OhRTZmPtRKn58gq4d2vuFIpU9wAS7vqyGGNP4fAOxFVDYqcryBSShq5mYPmQhcUyPU/L
         Glp97FpvL8FI7j15LpVTgaNDBEioLNRjNnDB6GmSm3Mlk4FYCPl2MXtnmIvoe9+wZ1l5
         XZj4nL3t8JmHJwTNlNPSaFIYp068Mk95NwrbZvyoahs6Hz1ZJbMiU98oy722ChHxZjRw
         WE4fa2mJb67Zq1CEfxamjCBaOpXpR6uPhzlUsottMZck9aNb0JPYoE/MVje2eB4YviyY
         Wblg==
X-Gm-Message-State: AOAM530b1irAxtJ+i7DVIvOif7ObfrgWUkLcAS/VA+XHAcqjoCsfxrdc
        DUm4ofX5Tbzj6Od/sXaYBrE=
X-Google-Smtp-Source: ABdhPJzCB3uljDqce/mdsq39xtZtFj4DHSmy8Fr2Uz/g4kc45x2vaMBQUmnrDT8/griTkJPSHdLmAg==
X-Received: by 2002:a05:6a00:1705:b0:51c:26ae:569c with SMTP id h5-20020a056a00170500b0051c26ae569cmr25188270pfc.28.1654871456011;
        Fri, 10 Jun 2022 07:30:56 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902ea0600b0016232dbd01fsm18851339plg.292.2022.06.10.07.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 07:30:55 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v6 7/7] can: skb: drop tx skb if in listen only mode
Date:   Fri, 10 Jun 2022 23:30:09 +0900
Message-Id: <20220610143009.323579-8-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frames can be directly injected to a can driver via the packet
socket. By doing so, it is possible to reach the
net_device_ops::ndo_start_xmit function even if the driver is
configured in listen only mode.

Add a check in can_dropped_invalid_skb() to discard the skb if
CAN_CTRLMODE_LISTENONLY is set.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev/skb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index dc9da76c0470..8bb62dd864c8 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/can/dev.h>
+#include <linux/can/netlink.h>
 #include <linux/module.h>
 
 #define MOD_DESC "CAN device driver interface"
@@ -293,6 +294,7 @@ static bool can_skb_headroom_valid(struct net_device *dev, struct sk_buff *skb)
 bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
 {
 	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
+	struct can_priv *priv = netdev_priv(dev);
 
 	if (skb->protocol == htons(ETH_P_CAN)) {
 		if (unlikely(skb->len != CAN_MTU ||
@@ -306,8 +308,13 @@ bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
 		goto inval_skb;
 	}
 
-	if (!can_skb_headroom_valid(dev, skb))
+	if (!can_skb_headroom_valid(dev, skb)) {
+		goto inval_skb;
+	} else if (priv->ctrlmode & CAN_CTRLMODE_LISTENONLY) {
+		netdev_info_once(dev,
+				 "interface in listen only mode, dropping skb\n");
 		goto inval_skb;
+	}
 
 	return false;
 
-- 
2.35.1

