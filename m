Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12CA4B6AFA
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiBOLc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:32:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237276AbiBOLcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:32:10 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F631D0C9;
        Tue, 15 Feb 2022 03:32:00 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id z16so12492106pfh.3;
        Tue, 15 Feb 2022 03:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X06QuFP/yl7TqcgHiQEothXnvH7lD4rIikeiUy/iGKA=;
        b=At1Pl+hpDThg3GfUVuCCz5vj5bbLsK85uqz6To7gZrkAlwMzt7oT3dEqVjzOXXGOwg
         wPZ8RurgieWHvvSBQDx+Rw1FkgBNuqUOUsX9YbI9C2nZMhZKVM341W1NAKx8C6/ZzlkA
         d89qt4j9+Eo0Zjp3tbWN514m1OFq+GX4q7NvSCjdALh2a8Mv2sL8krj41AzVioegv0yo
         3homwSbFh7MbWc9QZnFqZUKSQrUDeZ/NV45zEc9jsfex37Mybw/DjhUApq7+uZdh/zuc
         11JnpsrWoqd2ca5XWAgTX0Ee5ybnklG3TK6q+OnJePhe8ynU0GqObMqubAwkvyaxc5l8
         labw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X06QuFP/yl7TqcgHiQEothXnvH7lD4rIikeiUy/iGKA=;
        b=4zHWXL9DTFSS+uiOCejHzrFqwXD1cDN41F4+60fRQVvlserblo6cuTg6OkpX+APJQc
         kdZnly5l/BfpDEB941/51nFMtL/76ImulKk1sUZjfQhUTfm2Jzw5tArMTWijIvsg4ewN
         VWQsGDQRXany6d+3PNMHIg6mIw4v2V+jNVuSa9DP/VBnOU91dkmNMORFN7+cLdK8HIvc
         wYLK/yyttzQKB0dsr8ko+wsVLBITYfvc+mWP4pXMX79rZtR5BlXbgHXpBq0YM0w4gEmH
         bF/PFCqKqts0OkVKSOzLaJBmnl2Qwijim0cUujqDhfJyx8f3mezrwL5Vxl8vSdImDVRn
         SF+g==
X-Gm-Message-State: AOAM5337eqxh30Wd71DxyVQyPwPr4cyosRh1LsaZbmv825h9jBAjFNNS
        kfjoRkYDXH/6UM0J6J43/Wo=
X-Google-Smtp-Source: ABdhPJzCMqnT4ZZNKfLuu1n+m4J6Ch0EkyG5spcVLgiXXSpKKQ8Py2pk5vCbpLXk6SC+P0Ig5C+WYQ==
X-Received: by 2002:a05:6a00:174d:: with SMTP id j13mr3501886pfc.58.1644924720397;
        Tue, 15 Feb 2022 03:32:00 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:31:59 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@redhat.com, yoshfuji@linux-ipv6.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        memxor@gmail.com, atenart@kernel.org, bigeasy@linutronix.de,
        pabeni@redhat.com, linyunsheng@huawei.com, arnd@arndb.de,
        yajun.deng@linux.dev, roopa@nvidia.com, willemb@google.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: [PATCH net-next 11/19] net: neigh: use kfree_skb_reason() for __neigh_event_send()
Date:   Tue, 15 Feb 2022 19:28:04 +0800
Message-Id: <20220215112812.2093852-12-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215112812.2093852-1-imagedong@tencent.com>
References: <20220215112812.2093852-1-imagedong@tencent.com>
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

The two reasons above should be the hot path that skb drops in neighbour
layer.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 9 +++++++++
 include/trace/events/skb.h | 2 ++
 net/core/neighbour.c       | 4 ++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c7394b4790a0..136af29be256 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -387,6 +387,15 @@ enum skb_drop_reason {
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
2.34.1

