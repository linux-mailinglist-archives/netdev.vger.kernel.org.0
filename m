Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860CB4B6B13
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237335AbiBOLdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:33:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiBOLdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:33:03 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384C91EC62;
        Tue, 15 Feb 2022 03:32:28 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id r64-20020a17090a43c600b001b8854e682eso1900426pjg.0;
        Tue, 15 Feb 2022 03:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/4py2Bmts28btn/12GBhxHsz4doLzDFjoc4aV2hjupA=;
        b=Qcm/CLFVet0tiWOoTgyE0pXkLUvRc4lN7XR+bDFYpOSTWknOw0Q5W1ZKe71CQfcosl
         t8nlMTzn2qqMiUsel1hiZN9hZXmn1vm2w5zfzNEGyHKKUq96LoJb2jUlcVB/Fadiwg9X
         eX53BZ8yHKZF2uMeRc70S85Ixbubjgbg2dEqQ8hMDWWI9nHXL15ay+hihtCxa78BEvaX
         3qnv4xqziEQnoe9gSMYNj3scHMQCao2pXAhWocX7Z9zrY5N302Uy5TsSYhwssUzLXmUJ
         TEx29IyeUypBtwIL/kgOxeachZOcP/jZOWnj/Zz3aaffUSbNtBUGWN5mtv2PsS6fP7PL
         wMtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/4py2Bmts28btn/12GBhxHsz4doLzDFjoc4aV2hjupA=;
        b=kIGvi+gXbaiuc+vDn4Vpb+Z7VdFeSLJyxilhvGqYGpJtVeY8SqLG4RM9sC6fHNT3jg
         RYVnIEYyVAs8l8abvRE8r5I6EYs0SPXHcCAGpSVOKhh2qJmid6qprALUgH2BKBPhC56T
         RW9O8Ptqso5jfggIxWy8kfnwZ2WTHkX7ruoqZSB1ROi9taC9VzdoaI9ZuXOh17iXnyUW
         0AT4LwPYyfFfr3IZwwoPUFvHqzYYUiYPGZ1axPbhP4qu5JbpUre7TlaRIxRAQf/RbJaY
         5r9rIg1OpXMbVDmzxSOL9XvPQ3g6mE6EMdMHgkh8Bsttk/XufcubSdhctkmBxXpmNKxO
         l1WQ==
X-Gm-Message-State: AOAM530GReiOBIv1bRCyQ1w0OrskMmw9GGqis3/jJnVUZFUtgFCzn230
        o8JSI0b+BI234wdnsb3VaOI=
X-Google-Smtp-Source: ABdhPJyJYwHg3dZNxWZyk8m5YfvHB4DMBsjIOTCPkBqbh7zrzbsdvwnUjzS0vmzeBFsv/2u6MzBAwQ==
X-Received: by 2002:a17:903:2344:: with SMTP id c4mr3782667plh.55.1644924747817;
        Tue, 15 Feb 2022 03:32:27 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:32:27 -0800 (PST)
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
Subject: [PATCH net-next 15/19] net: dev: add skb drop reasons to __dev_xmit_skb()
Date:   Tue, 15 Feb 2022 19:28:08 +0800
Message-Id: <20220215112812.2093852-16-imagedong@tencent.com>
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
index dc3794b60b1c..0f7e5177dbaf 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -400,6 +400,10 @@ enum skb_drop_reason {
 					 * failed (maybe an eBPF program
 					 * is tricking?)
 					 */
+	SKB_DROP_REASON_QDISC_DROP,	/* dropped by qdisc when packet
+					 * outputting (failed to enqueue to
+					 * current qdisc)
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index a79b64eace9e..356bea7567b5 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -44,6 +44,7 @@
 	EM(SKB_DROP_REASON_NEIGH_FAILED, NEIGH_FAILED)		\
 	EM(SKB_DROP_REASON_NEIGH_QUEUEFULL, NEIGH_QUEUEFULL)	\
 	EM(SKB_DROP_REASON_QDISC_EGRESS, QDISC_EGRESS)		\
+	EM(SKB_DROP_REASON_QDISC_DROP, QDISC_DROP)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index 2a7b7c1b855a..55e890964fe2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3710,7 +3710,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 
 no_lock_out:
 		if (unlikely(to_free))
-			kfree_skb_list(to_free);
+			kfree_skb_list_reason(to_free,
+					      SKB_DROP_REASON_QDISC_DROP);
 		return rc;
 	}
 
@@ -3765,7 +3766,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	}
 	spin_unlock(root_lock);
 	if (unlikely(to_free))
-		kfree_skb_list(to_free);
+		kfree_skb_list_reason(to_free, SKB_DROP_REASON_QDISC_DROP);
 	if (unlikely(contended))
 		spin_unlock(&q->busylock);
 	return rc;
-- 
2.34.1

