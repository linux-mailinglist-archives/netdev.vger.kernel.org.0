Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AC14C53AC
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 05:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiBZEUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 23:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiBZEUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 23:20:15 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD2421F9FC;
        Fri, 25 Feb 2022 20:19:41 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id c1so6382806pgk.11;
        Fri, 25 Feb 2022 20:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HRHNQDNF5OpWMtsci03yux/pgrST514TVdTkLdLRMoQ=;
        b=IdJvqiYFQvHbZg6AFtKmWqdo3u/57hrG/PQXtNhUXnWufUk840BoaISCqpRtaOjiue
         dPvqOvgfNyhDeAfblgQZB5NoHz3klBzLIx+lU9mVV7FxApx6cn3a1tDcDwxVuYKEu3u4
         liCk5oW+DCGsdO1gFBfRTO7ANQFdMzrRWKs3l+qD6RC8jLA//lI0XlmbTCIF1OdRHYu0
         wcjHFyRRSkhAAxptH9DKIqgxBtYrHbGEaZNVCv81nvDXrhrNitizlDvNmkYflqoAllR9
         D5xqx1O1wLK7NHECKYFeHBNS8eCLwgJkhEnukmAyYsORDdPy8du3CfSThTrz+8Mxg6jz
         AuBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HRHNQDNF5OpWMtsci03yux/pgrST514TVdTkLdLRMoQ=;
        b=VoZ2s2146KRe/+LyCY236P0PPykesD8hARaxYlZ6DvXBJcjI743ft9a0zqfwFya5ge
         vZNvner7Yc7G0LclDqwBjopnSmy1ZNKjVfpKq4APcsF9Hogrk2LR48zIJIIcx5buqLxC
         IW5wMV4D6MGACZJlSzLnNNVF2how9zsmHDu3dyMwwRNBJjH4gHJkPBsih7PKD6YQT6RF
         qiC4mGmC32w55xhv2FYLbzIBgZxowSVT825zVLybyj38cm+DaITa+s9Rye3m2tSL5++h
         wOfFLLSGkmemaCn98rDNHs2TtC36Als/qAEGKqByQfFRnnd5jIzFek5xg3aYs0nR5ilY
         yESg==
X-Gm-Message-State: AOAM531THdxHhq8PPp3G9Y3kc9Hrah3Hezt3B+SMLnNknOsjKn6qLPUf
        GCZHj8jwyBQ33cTeC83l9o4=
X-Google-Smtp-Source: ABdhPJx1+DDr7dos9lCkZeSKsCfgObqLdHUTo6gpbntNEjZ9wM/klId+MY5eNmExEJA/5yU/iFLyRA==
X-Received: by 2002:a05:6a00:ac1:b0:4f1:29e4:b3a1 with SMTP id c1-20020a056a000ac100b004f129e4b3a1mr11081837pfl.63.1645849180922;
        Fri, 25 Feb 2022 20:19:40 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id k22-20020aa788d6000000b004f1335c8889sm4896193pff.7.2022.02.25.20.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 20:19:40 -0800 (PST)
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
Subject: [PATCH net-next v3 2/3] net: neigh: use kfree_skb_reason() for __neigh_event_send()
Date:   Sat, 26 Feb 2022 12:18:30 +0800
Message-Id: <20220226041831.2058437-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220226041831.2058437-1-imagedong@tencent.com>
References: <20220226041831.2058437-1-imagedong@tencent.com>
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
Reviewed-by: David Ahern <dsahern@kernel.org>
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
index bd6ed54f2460..9c4f6fc4e118 100644
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
index 97f8097651da..1977f301260d 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -42,6 +42,9 @@
 	   BPF_CGROUP_EGRESS)					\
 	EM(SKB_DROP_REASON_IPV6DISABLED, IPV6DISABLED)		\
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

