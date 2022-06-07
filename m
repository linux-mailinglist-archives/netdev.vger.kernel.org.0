Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369E6542050
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385374AbiFHAVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588661AbiFGXyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:54:55 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F231B187D
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 16:36:37 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id gc3-20020a17090b310300b001e33092c737so16782769pjb.3
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 16:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c7ZxjBhd9r0DJDMboQQNSRkeIfCRgvQImpqF0uM/P4U=;
        b=XczANK+jExAUcWXhV20j1B1Porpas6jvvAehD0meFWO0o4wx49aepcY2+A+wp7ZqgF
         jllCMd0AMZLAEIcWeQzD1AsLcmYKfGy8GICIO2sYbSAfQ6Y+mZEWG++vhzlVH1nqZ9lL
         f3lZo4eetiMNEQMtJBMXCWj3wZwU475Z2zSFkViCRhNYi37XwNqHnRXOCwGvKAZ4svsS
         //6jlMLX13atECKRsygGz1XWtftmcmRlH58weXYcgsQzUpY5ap8ZAwC2t70OdUsTBzxV
         FqpjB2md1+iKwudngbwOu/X+48g0aJyJe6tEYv7DfyTlwPbm8VauTBHJR3ijo9J1O1dp
         NyrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c7ZxjBhd9r0DJDMboQQNSRkeIfCRgvQImpqF0uM/P4U=;
        b=RJnQg71Ar+eOdavcy+bcx9j+t342Drq0EqE3VS6i36Q9jITGBcI96l6iTPC+tzbtWo
         DUQY+jEu19rYO+UqnZpX+8PCpKcmXo0QVb9sK6tUGUz+fLn9tVYC4khLhrihxa9VCwTQ
         HEUt7PweVtwiZ6nKC2YvQ9w3XH4V66W97s3LtBmUVkrIukD3l8J4Q+vjJnc/HUgQ36Sj
         vyeKMDHBRmiyGJpb2oGyWZhNkR2CJIUCldz2B2Sb6oMQIsPthZvGhxcmGX+r82/qUF28
         ZzgJDM9qOVWHqED3Q9G5d+JF2MiofflYKdNL/cDMhW1JHMuKIQKxcG3kn0qg68u6HfxO
         PRdQ==
X-Gm-Message-State: AOAM530pop/WLYiAW6LB+sLx0ZhD/qnjSr+k0YPFiVql4nDKqqJEhcK3
        5FuELebj0dJW4Cp0LZ1aaLSvO/W0S+g=
X-Google-Smtp-Source: ABdhPJyquZZ1hAxNQMVjvg7ca8gFr3xmu8IXa4UayiAHS878IS3POM36h21eqT3hWkXxWCYxHXTCIA==
X-Received: by 2002:a17:902:dacd:b0:164:17ef:54c6 with SMTP id q13-20020a170902dacd00b0016417ef54c6mr31983701plx.11.1654644997428;
        Tue, 07 Jun 2022 16:36:37 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id u79-20020a627952000000b0051ba7515e0dsm13550947pfc.54.2022.06.07.16.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 16:36:37 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 9/9] team: adopt u64_stats_t
Date:   Tue,  7 Jun 2022 16:36:14 -0700
Message-Id: <20220607233614.1133902-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220607233614.1133902-1-eric.dumazet@gmail.com>
References: <20220607233614.1133902-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

As explained in commit 316580b69d0a ("u64_stats: provide u64_stats_t type")
we should use u64_stats_t and related accessors to avoid load/store tearing.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/team/team.c | 26 +++++++++++++-------------
 include/linux/if_team.h | 10 +++++-----
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index b07dde6f0abf273195ff0f60217bd7158535b153..aac133a1e27a5f64fe8f83a456aa0598fad6824c 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -749,10 +749,10 @@ static rx_handler_result_t team_handle_frame(struct sk_buff **pskb)
 
 		pcpu_stats = this_cpu_ptr(team->pcpu_stats);
 		u64_stats_update_begin(&pcpu_stats->syncp);
-		pcpu_stats->rx_packets++;
-		pcpu_stats->rx_bytes += skb->len;
+		u64_stats_inc(&pcpu_stats->rx_packets);
+		u64_stats_add(&pcpu_stats->rx_bytes, skb->len);
 		if (skb->pkt_type == PACKET_MULTICAST)
-			pcpu_stats->rx_multicast++;
+			u64_stats_inc(&pcpu_stats->rx_multicast);
 		u64_stats_update_end(&pcpu_stats->syncp);
 
 		skb->dev = team->dev;
@@ -1720,8 +1720,8 @@ static netdev_tx_t team_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		pcpu_stats = this_cpu_ptr(team->pcpu_stats);
 		u64_stats_update_begin(&pcpu_stats->syncp);
-		pcpu_stats->tx_packets++;
-		pcpu_stats->tx_bytes += len;
+		u64_stats_inc(&pcpu_stats->tx_packets);
+		u64_stats_add(&pcpu_stats->tx_bytes, len);
 		u64_stats_update_end(&pcpu_stats->syncp);
 	} else {
 		this_cpu_inc(team->pcpu_stats->tx_dropped);
@@ -1854,11 +1854,11 @@ team_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		p = per_cpu_ptr(team->pcpu_stats, i);
 		do {
 			start = u64_stats_fetch_begin_irq(&p->syncp);
-			rx_packets	= p->rx_packets;
-			rx_bytes	= p->rx_bytes;
-			rx_multicast	= p->rx_multicast;
-			tx_packets	= p->tx_packets;
-			tx_bytes	= p->tx_bytes;
+			rx_packets	= u64_stats_read(&p->rx_packets);
+			rx_bytes	= u64_stats_read(&p->rx_bytes);
+			rx_multicast	= u64_stats_read(&p->rx_multicast);
+			tx_packets	= u64_stats_read(&p->tx_packets);
+			tx_bytes	= u64_stats_read(&p->tx_bytes);
 		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
 
 		stats->rx_packets	+= rx_packets;
@@ -1870,9 +1870,9 @@ team_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		 * rx_dropped, tx_dropped & rx_nohandler are u32,
 		 * updated without syncp protection.
 		 */
-		rx_dropped	+= p->rx_dropped;
-		tx_dropped	+= p->tx_dropped;
-		rx_nohandler	+= p->rx_nohandler;
+		rx_dropped	+= READ_ONCE(p->rx_dropped);
+		tx_dropped	+= READ_ONCE(p->tx_dropped);
+		rx_nohandler	+= READ_ONCE(p->rx_nohandler);
 	}
 	stats->rx_dropped	= rx_dropped;
 	stats->tx_dropped	= tx_dropped;
diff --git a/include/linux/if_team.h b/include/linux/if_team.h
index add607943c9564365e8d72d7522291d7a3d899d2..fc985e5c739d434148e8ff19d30ebc3ee8abf1d8 100644
--- a/include/linux/if_team.h
+++ b/include/linux/if_team.h
@@ -12,11 +12,11 @@
 #include <uapi/linux/if_team.h>
 
 struct team_pcpu_stats {
-	u64			rx_packets;
-	u64			rx_bytes;
-	u64			rx_multicast;
-	u64			tx_packets;
-	u64			tx_bytes;
+	u64_stats_t		rx_packets;
+	u64_stats_t		rx_bytes;
+	u64_stats_t		rx_multicast;
+	u64_stats_t		tx_packets;
+	u64_stats_t		tx_bytes;
 	struct u64_stats_sync	syncp;
 	u32			rx_dropped;
 	u32			tx_dropped;
-- 
2.36.1.255.ge46751e96f-goog

