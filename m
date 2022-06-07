Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2FC542020
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381080AbiFHAR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588659AbiFGXyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:54:55 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFBD1B1857
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 16:36:35 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso16823242pjg.0
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 16:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oo4VNLQ32ZUWs+xj1GEnWGce/STbLBZ5K8YuYmraaxI=;
        b=i5u5pxeq5/uEJKzNM9ULNsWvaQie6meicLDBzjB/uCZqE8XYgLbR6NMuDenSRqu7D9
         jmvR00Xzq6rbS4PrqdP2HaapU4V9LEe3k5M590JhfwUJpCvHQQugYcSt77Uv7ZZvrHCD
         eeBpRAHkkO7Wx0ZwU3zr/dLDe8L7s1EE+g3K+5aDMasFVJjp/5Z8w/WP5xC5/sC780q9
         Ian/q1ecDRpURG1CG0SHBaSieRMr4QpD3QoVodRwbBR4238feAwD5p6jyhmZ5s37lXu/
         /FugmmlT5/qZVWUSqafmW0X9G4O3tGPxv4V3eUxLk/qeSHeEoWbSxAYKJr8ccwaMCygo
         x6mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oo4VNLQ32ZUWs+xj1GEnWGce/STbLBZ5K8YuYmraaxI=;
        b=niWj+mDy4SUSV20RS6NJrZKC2xe+j8gMEWZmpPFGmbPY9YxE3l4AB32QCvgoUAvRmW
         YpmH8fP8hlNTJPsYz6lF5U3fy8krBEFqUmT5gC4k5V5u3gVuOVGR1GcpysrNT8frxz9J
         BUpKvs4Vkx/n+C2b8shQTaky8Dh9B5bIRbWH4ChM9e9ZeW8jOsROqSXbq/zcM1PB/Tz3
         ZTCro4RVj2oM1wap9Cjd/Q6NnH4Np6AlUnIAKLs6iu2zeo9e1zs2zfP5N8g/Tj1Q8L/w
         UH9xgRRZ//BI6qZljbNqSPGSy1PqI5sPXj545F01iqLxC9orqD52DgiSDDOgfu4ahxo1
         4nTw==
X-Gm-Message-State: AOAM53017bI75/pr88M1Ppq2dOBikxHd9d7FNRNkddZKBymWi33bqyWG
        06KTPdJPoDHrfMf5LZviBEg=
X-Google-Smtp-Source: ABdhPJwajoF6n4Lpippxk93vNe9Qjb9r7px0vMvnW+ghZHpwCjglPap0EVJ4tx3kt1/h3g0gdlLiBg==
X-Received: by 2002:a17:903:2445:b0:164:16dd:a94a with SMTP id l5-20020a170903244500b0016416dda94amr31932688pls.46.1654644994885;
        Tue, 07 Jun 2022 16:36:34 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id u79-20020a627952000000b0051ba7515e0dsm13550947pfc.54.2022.06.07.16.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 16:36:34 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 8/9] drop_monitor: adopt u64_stats_t
Date:   Tue,  7 Jun 2022 16:36:13 -0700
Message-Id: <20220607233614.1133902-9-eric.dumazet@gmail.com>
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
 net/core/drop_monitor.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 4ad1decce72418818aa4c2415b202e4311061a8c..98952ffcee452fe8437b0d020ce834496cd26570 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -55,7 +55,7 @@ static bool monitor_hw;
 static DEFINE_MUTEX(net_dm_mutex);
 
 struct net_dm_stats {
-	u64 dropped;
+	u64_stats_t dropped;
 	struct u64_stats_sync syncp;
 };
 
@@ -530,7 +530,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 unlock_free:
 	spin_unlock_irqrestore(&data->drop_queue.lock, flags);
 	u64_stats_update_begin(&data->stats.syncp);
-	data->stats.dropped++;
+	u64_stats_inc(&data->stats.dropped);
 	u64_stats_update_end(&data->stats.syncp);
 	consume_skb(nskb);
 }
@@ -985,7 +985,7 @@ net_dm_hw_trap_packet_probe(void *ignore, const struct devlink *devlink,
 unlock_free:
 	spin_unlock_irqrestore(&hw_data->drop_queue.lock, flags);
 	u64_stats_update_begin(&hw_data->stats.syncp);
-	hw_data->stats.dropped++;
+	u64_stats_inc(&hw_data->stats.dropped);
 	u64_stats_update_end(&hw_data->stats.syncp);
 	net_dm_hw_metadata_free(n_hw_metadata);
 free:
@@ -1432,10 +1432,10 @@ static void net_dm_stats_read(struct net_dm_stats *stats)
 
 		do {
 			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
-			dropped = cpu_stats->dropped;
+			dropped = u64_stats_read(&cpu_stats->dropped);
 		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
 
-		stats->dropped += dropped;
+		u64_stats_add(&stats->dropped, dropped);
 	}
 }
 
@@ -1451,7 +1451,7 @@ static int net_dm_stats_put(struct sk_buff *msg)
 		return -EMSGSIZE;
 
 	if (nla_put_u64_64bit(msg, NET_DM_ATTR_STATS_DROPPED,
-			      stats.dropped, NET_DM_ATTR_PAD))
+			      u64_stats_read(&stats.dropped), NET_DM_ATTR_PAD))
 		goto nla_put_failure;
 
 	nla_nest_end(msg, attr);
@@ -1476,10 +1476,10 @@ static void net_dm_hw_stats_read(struct net_dm_stats *stats)
 
 		do {
 			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
-			dropped = cpu_stats->dropped;
+			dropped = u64_stats_read(&cpu_stats->dropped);
 		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
 
-		stats->dropped += dropped;
+		u64_stats_add(&stats->dropped, dropped);
 	}
 }
 
@@ -1495,7 +1495,7 @@ static int net_dm_hw_stats_put(struct sk_buff *msg)
 		return -EMSGSIZE;
 
 	if (nla_put_u64_64bit(msg, NET_DM_ATTR_STATS_DROPPED,
-			      stats.dropped, NET_DM_ATTR_PAD))
+			      u64_stats_read(&stats.dropped), NET_DM_ATTR_PAD))
 		goto nla_put_failure;
 
 	nla_nest_end(msg, attr);
-- 
2.36.1.255.ge46751e96f-goog

