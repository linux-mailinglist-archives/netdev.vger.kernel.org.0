Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C754CC44F
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbiCCRtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbiCCRt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:49:29 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870C75643C;
        Thu,  3 Mar 2022 09:48:43 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id z11so5217053pla.7;
        Thu, 03 Mar 2022 09:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PWlHozXjBpcdg0186JVwtvZRV5XBQhKzqyfGbgLa+ro=;
        b=RSNd65ABZfgCCUj4gIPsIjZxcfZhjb9yg1d+zUzHV09fMdn0okF8PFv+JIkzox3P+W
         csI+wFGuHlyr5yYzYcRS6UDAino+dwfTC0U74PTMI7K8AwiH9cH3unzO9lTHG//4DieA
         ka9mBpkL1Xy2pyLIVWD8YpQXGukl4jxSN1LhO7UpodsqpYUTTJ7NYFf7PR+Cwt8MeAtg
         HTdeN5F0mrwr+3r9X6/uArvZauAxDN50U1mJmRK8CP8hDnNYQykzo4ocJLsGzXS2DAJg
         HIHcqdyn3GuhRVD5LhQfYVuQjtZBVrQqTJ5O0Kph94UjVKTe+szuIq/egnbhA+VN5lV5
         lf7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PWlHozXjBpcdg0186JVwtvZRV5XBQhKzqyfGbgLa+ro=;
        b=KNzLzBgs1gkvP8LN8szr5R71wrqlXshMsrDkhvPh6dqzpG+62mxTZuylLfX3b+mnjW
         fSNAPFv9lgDisegrmgRcQWfZyyHfJkBFYUvAJXQhvRajjYHIjZcNxllEeSejgU8tIavO
         d0ZJcGW9VTY+oN+t8zRS4CRoSa6XjTHTk99jcwqwsvZHpnsUGQcSIKHrxmEsQBaENvbT
         NDBw6DzADY6gNrjjYu6CNxsN7fje2x64kvIEhDzXdJrCO/3B9zNQOHauwupCHBS+kve6
         NbD78VlMOFVBTTxDyJdB+TGo9uIkRhCS1Thzo+X3yvE6a4sd6Ld9o/ISbygRKV020B78
         subw==
X-Gm-Message-State: AOAM531PIdR3N78J4t5kG6ZJbadL9u+P+SQRchpduYS9P5rNORtN8JE6
        9YLufUgHdGKYn5FXgLlY8Qw=
X-Google-Smtp-Source: ABdhPJwlyKDmkv2A2G/wEiPnMyYQww/ts0ITpwATX8699WJbhzAbVAwiOdqVU4+pIr+Snuw5mSFvGA==
X-Received: by 2002:a17:902:7606:b0:151:6e0f:8986 with SMTP id k6-20020a170902760600b001516e0f8986mr20427236pll.20.1646329723071;
        Thu, 03 Mar 2022 09:48:43 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f0f0f852a4sm3209395pfx.77.2022.03.03.09.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 09:48:42 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, imagedong@tencent.com,
        edumazet@google.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com, atenart@kernel.org,
        bigeasy@linutronix.de, memxor@gmail.com, arnd@arndb.de,
        pabeni@redhat.com, willemb@google.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH net-next 3/7] net: dev: add skb drop reasons to __dev_xmit_skb()
Date:   Fri,  4 Mar 2022 01:47:03 +0800
Message-Id: <20220303174707.40431-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220303174707.40431-1-imagedong@tencent.com>
References: <20220303174707.40431-1-imagedong@tencent.com>
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

Add reasons for skb drops to __dev_xmit_skb() by replacing
kfree_skb_list() with kfree_skb_list_reason(). The drop reason of
SKB_DROP_REASON_QDISC_DROP is introduced for qdisc enqueue fails.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 4 ++++
 include/trace/events/skb.h | 1 +
 net/core/dev.c             | 5 +++--
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e344603aecc4..62f9d15ec6ec 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -398,6 +398,10 @@ enum skb_drop_reason {
 					 * failed (mapbe an eBPF program
 					 * is tricking?)
 					 */
+	SKB_DROP_REASON_QDISC_DROP,	/* dropped by qdisc when packet
+					 * outputting (failed to enqueue to
+					 * current qdisc)
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 3cadf13448c6..80fe15d175e3 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -46,6 +46,7 @@
 	EM(SKB_DROP_REASON_NEIGH_QUEUEFULL, NEIGH_QUEUEFULL)	\
 	EM(SKB_DROP_REASON_NEIGH_DEAD, NEIGH_DEAD)		\
 	EM(SKB_DROP_REASON_QDISC_EGRESS, QDISC_EGRESS)		\
+	EM(SKB_DROP_REASON_QDISC_DROP, QDISC_DROP)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index 828946d74a19..3280ba2502cd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3730,7 +3730,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 
 no_lock_out:
 		if (unlikely(to_free))
-			kfree_skb_list(to_free);
+			kfree_skb_list_reason(to_free,
+					      SKB_DROP_REASON_QDISC_DROP);
 		return rc;
 	}
 
@@ -3785,7 +3786,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	}
 	spin_unlock(root_lock);
 	if (unlikely(to_free))
-		kfree_skb_list(to_free);
+		kfree_skb_list_reason(to_free, SKB_DROP_REASON_QDISC_DROP);
 	if (unlikely(contended))
 		spin_unlock(&q->busylock);
 	return rc;
-- 
2.35.1

