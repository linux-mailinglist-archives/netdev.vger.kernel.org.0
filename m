Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12904C3EE2
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 08:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238070AbiBYHTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 02:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238068AbiBYHTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 02:19:41 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AEE25457D;
        Thu, 24 Feb 2022 23:19:10 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id 75so3898398pgb.4;
        Thu, 24 Feb 2022 23:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nktOubmjpRUAnpGyo8e1v9i8C9voQ6lx6Hy1CUhibQM=;
        b=XqzfhUio3BD/M87+BTN5z6BBpxqs/29Ka36m5i71Wafu4UtDjrFAg27shdq2/4Roky
         XGAL828bF/x+S+W8xyGynPDw29t9Mp2JUfTxle3sMvAzL1Bfokv7fSGKYR5J6aAlxnZ6
         GiK12kAqyjSsPoiL/8Jsg2d1mUXm4whMg1ecpPGbKiLcSrxYxXIIA2HC15QypoeqC3p3
         9dv8acwybhfYe8rb7AP+47DtMyETEy0hTLy2o4Ozqu0fJMN8v/GfHjnl/ioXT+fCNo80
         32G0AOzIoKzwAkAWxXxe1ouih9MJMthxuqckqikFa0tnO1dNkLqJeAfiIUWFHw8n0Jkj
         +2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nktOubmjpRUAnpGyo8e1v9i8C9voQ6lx6Hy1CUhibQM=;
        b=o/oDwluSMyVieshOJMg7rwUN82aF0wrgZYMWdGTKHim5vwj188ZvxiMBd/hkT4a9hh
         4DUV+I2nQJmv9I87lbVmpO+NfXCs9CGlncYBH9/b5f0rTSPLaWy/V2NvYwU1xYQl3S8Y
         E7Y8LbeC0+1SFBS47TT+xxloN5do9jNvWl1cRDU+M6IZVmWL0wvn/wIe9uDxoE6EZggi
         hApBMSDkWXoua1JJqvWikI2gy60h32eCjrifG26wqOOG2ri22ADoD3I9t5aMdyz1tf4Y
         787tzLn9IColKX9P8sSmSXdt1tTG5fkQ+89U47a9Zey1VuE9ZQq/kmCmb6hU7d66MULr
         7sdw==
X-Gm-Message-State: AOAM531eEbI7GrQtA/dkK29QUMxVhAWo8P1+3WmWEC/VrKPDt8RFIPZo
        YU52Lbc6XJvMzq2Tsa2Wi5oTll0L/fc=
X-Google-Smtp-Source: ABdhPJza9RWWU8Tgg5OVHlMptAp+4kFgm1qbvvPlycDRXIhgDIpMq7ZN8hmxXjDOPgPbLnhVVy5Fkw==
X-Received: by 2002:a63:a80c:0:b0:374:2526:2d68 with SMTP id o12-20020a63a80c000000b0037425262d68mr5114619pgf.572.1645773549923;
        Thu, 24 Feb 2022 23:19:09 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.gmail.com with ESMTPSA id k20-20020a056a00135400b004ecc81067b8sm1970825pfu.144.2022.02.24.23.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 23:19:09 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, cong.wang@bytedance.com,
        paulb@nvidia.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        flyingpeng@tencent.com, mengensun@tencent.com,
        daniel@iogearbox.net, yajun.deng@linux.dev, roopa@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/3] net: neigh: use kfree_skb_reason() for __neigh_event_send()
Date:   Fri, 25 Feb 2022 15:17:38 +0800
Message-Id: <20220225071739.1956657-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220225071739.1956657-1-imagedong@tencent.com>
References: <20220225071739.1956657-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() used in __neigh_event_send() with
kfree_skb_reason(). Following drop reasons are added:

SKB_DROP_REASON_NEIGH_FAILED
SKB_DROP_REASON_NEIGH_QUEUEFULL
SKB_DROP_REASON_NEIGH_DEAD

The first two reasons above should be the hot path that skb drops
in neighbour subsystem.

Reviewed-by: Mengen Sun <mengensun@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- introduce the new drop reason 'SKB_DROP_REASON_NEIGH_DEAD'
- simplify the document for the new drop reasons
---
 include/linux/skbuff.h     | 5 +++++
 include/trace/events/skb.h | 3 +++
 net/core/neighbour.c       | 6 +++---
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c99b944dc712..5559ddeda728 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -389,6 +389,11 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_NEIGH_CREATEFAIL,	/* failed to create neigh
 						 * entry
 						 */
+	SKB_DROP_REASON_NEIGH_FAILED,	/* neigh entry in failed state */
+	SKB_DROP_REASON_NEIGH_QUEUEFULL,	/* arp_queue for neigh
+						 * entry is full
+						 */
+	SKB_DROP_REASON_NEIGH_DEAD,	/* neigh entry is dead */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 38a6e4e3ff9a..d647f519f900 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -42,6 +42,9 @@
 	   BPF_CGROUP_EGRESS)					\
 	EM(SKB_DROP_REASON_IPV6DSIABLED, IPV6DSIABLED)		\
 	EM(SKB_DROP_REASON_NEIGH_CREATEFAIL, NEIGH_CREATEFAIL)	\
+	EM(SKB_DROP_REASON_NEIGH_FAILED, NEIGH_FAILED)		\
+	EM(SKB_DROP_REASON_NEIGH_QUEUEFULL, NEIGH_QUEUEFULL)	\
+	EM(SKB_DROP_REASON_NEIGH_DEAD, NEIGH_DEAD)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index ec0bf737b076..f64ebd050f6c 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1171,7 +1171,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb,
 			neigh->updated = jiffies;
 			write_unlock_bh(&neigh->lock);
 
-			kfree_skb(skb);
+			kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_FAILED);
 			return 1;
 		}
 	} else if (neigh->nud_state & NUD_STALE) {
@@ -1193,7 +1193,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb,
 				if (!buff)
 					break;
 				neigh->arp_queue_len_bytes -= buff->truesize;
-				kfree_skb(buff);
+				kfree_skb_reason(buff, SKB_DROP_REASON_NEIGH_QUEUEFULL);
 				NEIGH_CACHE_STAT_INC(neigh->tbl, unres_discards);
 			}
 			skb_dst_force(skb);
@@ -1215,7 +1215,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb,
 	if (neigh->nud_state & NUD_STALE)
 		goto out_unlock_bh;
 	write_unlock_bh(&neigh->lock);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_DEAD);
 	trace_neigh_event_send_dead(neigh, 1);
 	return 1;
 }
-- 
2.35.1

