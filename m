Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5574E4BCFAF
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 17:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244275AbiBTP71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 10:59:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243520AbiBTP7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 10:59:23 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C2E4476D;
        Sun, 20 Feb 2022 07:59:02 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 12so8631261pgd.0;
        Sun, 20 Feb 2022 07:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=44LYBQpyrjIKyg3Y9on2cX6HSqaMbgnWx5oGl5OsXPY=;
        b=XEODjzbh6LmU2vDPqqhz1yXoiLwka8QJblDkRG0ZXapsTjpPNgUu3/PDQMaPfAAsly
         SYusaQSBQDjpLemEbYwG//xfO2DCi+osj64jheB/NC7JeFh3kn3ObUr1mJuJ7Hl4q9/P
         MoNQ4BlKTI1VRBuyhgFdb0uawAwiH06xiv0aA00q/tic0hSuiUltEkxxQiUbSZWeBCVq
         Zsm9C9QdgYZHiX7P6+TctVvwBf9hvpqDbAjZb8wI3NTQBjEL7aKPyK0sKCTOWPK4FVn7
         aLxv7kgfi3wYMOKj2k7lDF587ELxh1iTobvErixEqhvu8DgjJovpv7SQ9rkvf2/ljY6S
         uYpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=44LYBQpyrjIKyg3Y9on2cX6HSqaMbgnWx5oGl5OsXPY=;
        b=RE9pD3nqOebqktNUagepsZMFMU2YWdNAN8Z9Jz5dYeuvzwygiYPsElw3fHjYKFVtMg
         H0NTyp8VUSO+64qkrhRkIW19QO05RJI7UhoNu+42w41OgWpxeZ9Wh2kc15AaLvi0Y3pY
         Zy9QHngXKSpA+zVlJMWntf/COHnh/+8BvimOaDhVrK0HOxFrUT5DGY8Yr+TaO3bMyXsS
         nJz163Ef57kMulSltPBnGu4iXG0pPxmNY3hXsDuqosq7+Tpmp2mrwVrIgTiUGbXmMk6h
         F5LOFMH0N7OJdyeEbm9UbrNQMXYEcBtnpmdMZhwfjGaETXD3ZWzwSp1gYhH4/sRt70FH
         GLBQ==
X-Gm-Message-State: AOAM531FixWKpDolWYHziWGyeWPZaVwv1dTgW4B8Zn77S8C3XnsJ0GiS
        6YnbTgRbqq1MwQvR6nN99tfyAUynzE4=
X-Google-Smtp-Source: ABdhPJzn9S0cEXinVzxQHrgEyWcCZaNhLMOJNxIeZgoh99J3QV3vnukOy/kS4zl8voBMFhggoqRhlQ==
X-Received: by 2002:a05:6a00:1995:b0:4e1:a7dd:96d6 with SMTP id d21-20020a056a00199500b004e1a7dd96d6mr16218258pfl.16.1645372741775;
        Sun, 20 Feb 2022 07:59:01 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id o14sm5001927pfw.121.2022.02.20.07.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 07:59:01 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, cong.wang@bytedance.com,
        paulb@nvidia.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        flyingpeng@tencent.com, mengensun@tencent.com,
        daniel@iogearbox.net, yajun.deng@linux.dev, roopa@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] net: neigh: use kfree_skb_reason() for __neigh_event_send()
Date:   Sun, 20 Feb 2022 23:57:04 +0800
Message-Id: <20220220155705.194266-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220155705.194266-1-imagedong@tencent.com>
References: <20220220155705.194266-1-imagedong@tencent.com>
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

The two reasons above should be the hot path that skb drops in
neighbour subsystem.

Reviewed-by: Mengen Sun <mengensun@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 9 +++++++++
 include/trace/events/skb.h | 2 ++
 net/core/neighbour.c       | 4 ++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c310a4a8fc86..206b66f5ce6b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -393,6 +393,15 @@ enum skb_drop_reason {
 					 * see the doc for disable_ipv6
 					 * in ip-sysctl.rst for detail
 					 */
+	SKB_DROP_REASON_NEIGH_FAILED,	/* dropped as the state of
+					 * neighbour is NUD_FAILED
+					 */
+	SKB_DROP_REASON_NEIGH_QUEUEFULL,	/* the skbs that waiting
+						 * for sending on the queue
+						 * of neigh->arp_queue is
+						 * full, and the skbs on the
+						 * tail will be dropped
+						 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 47dedef7b6b8..dd06366ded4a 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -41,6 +41,8 @@
 	EM(SKB_DROP_REASON_BPF_CGROUP_EGRESS,			\
 	   BPF_CGROUP_EGRESS)					\
 	EM(SKB_DROP_REASON_IPV6DSIABLED, IPV6DSIABLED)		\
+	EM(SKB_DROP_REASON_NEIGH_FAILED, NEIGH_FAILED)		\
+	EM(SKB_DROP_REASON_NEIGH_QUEUEFULL, NEIGH_QUEUEFULL)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index ec0bf737b076..c353834e8fa9 100644
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
-- 
2.35.1

