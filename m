Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C2E4CCD7B
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 07:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238263AbiCDGCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 01:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbiCDGCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 01:02:47 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391D418644E;
        Thu,  3 Mar 2022 22:02:00 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id y11so6785729pfa.6;
        Thu, 03 Mar 2022 22:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M1KGGJ++5jvrBcGkFVx4NiuAGaDCJ+LibUibMFb2wJo=;
        b=eGL+lMsza+NRI7f1au4IUVjPjVgjopU7gUu3TDgoNEPCYpCFiUliOlTBqgPgRJ3XJW
         mdVvtktc4gIoB12ZWU6m0PLLuZt8P/QoxAowaCMHs3B8IM3jxJnEsKNO2iyA+ToA5Lb0
         WfypiescCI9F83DvithbGm638ZLN9JAI5PZztfs68fLbbwlnFKfSQtDP5/lf8ktWU6zO
         GFrudvjp30eeucmgSXGADFxguxKt/JykSFEdT+D78up4Szpe/3zF2EKpckvWWJruVdBl
         Ap5EpgNNNc1LQcQBQ+g+0SzS/BsvKGAE6tXxNGsL8agqKEhq/IVsii8H7rawW2p6jPeW
         788Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M1KGGJ++5jvrBcGkFVx4NiuAGaDCJ+LibUibMFb2wJo=;
        b=bEwkrgPp+wRqMfueH29DS+nHZslJLR+X66GkmddrgZFCQnk//KiGJIFolCCHOqb930
         8WMUGlQMD/JLqlAyzlnnPLkQaIsmdTW+6vUqf/5927inBKK9I0t3AOHNHRmqoKygnkyK
         zgTgDMKGviHu0sPnAErcH57BjdwNDFe2K9pSIdHRIuywffiC/VpRs7dqZ05BR1yx/yf1
         NfmcxY4glveJorbNdAFHKP6lra0Ootjb4i/olJAHSQMgQUpOyKSQ2UHF9IuNH6xBzkSu
         6JlQDR4GeQg35EUW+RCNFQOhRaYx3m/uRbzl6Kkqrd0sZhVMesxO8NRLsXbOO344rSO9
         FdoQ==
X-Gm-Message-State: AOAM530+7uPmy7pZ3HU98ypB8FBzgaB8eZL0/GPsNBRZtvMeEz8dqv0+
        VLhcexDFCihe3Xtvcid/NGM=
X-Google-Smtp-Source: ABdhPJxDUYrkMB4n7fkWhNNcvZb9Nko0XU74IJcdXzXHcXNn77Ko6MKFcATl2GCXVUQK9EGDUxW8Ng==
X-Received: by 2002:a05:6a00:987:b0:4f3:e5d3:448d with SMTP id u7-20020a056a00098700b004f3e5d3448dmr32437882pfg.14.1646373719728;
        Thu, 03 Mar 2022 22:01:59 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id y5-20020a056a00190500b004f104b5350fsm4569073pfi.93.2022.03.03.22.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 22:01:59 -0800 (PST)
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
Subject: [PATCH net-next v2 3/7] net: dev: add skb drop reasons to __dev_xmit_skb()
Date:   Fri,  4 Mar 2022 14:00:42 +0800
Message-Id: <20220304060046.115414-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304060046.115414-1-imagedong@tencent.com>
References: <20220304060046.115414-1-imagedong@tencent.com>
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
index 9d219e266dc7..a3d65e749ea3 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -395,6 +395,10 @@ enum skb_drop_reason {
 						 */
 	SKB_DROP_REASON_NEIGH_DEAD,	/* neigh entry is dead */
 	SKB_DROP_REASON_TC_EGRESS,	/* dropped in TC egress HOOK */
+	SKB_DROP_REASON_QDISC_DROP,	/* dropped by qdisc when packet
+					 * outputting (failed to enqueue to
+					 * current qdisc)
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 53755e8191a1..dbf3e2e3c1b4 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -46,6 +46,7 @@
 	EM(SKB_DROP_REASON_NEIGH_QUEUEFULL, NEIGH_QUEUEFULL)	\
 	EM(SKB_DROP_REASON_NEIGH_DEAD, NEIGH_DEAD)		\
 	EM(SKB_DROP_REASON_TC_EGRESS, TC_EGRESS)		\
+	EM(SKB_DROP_REASON_QDISC_DROP, QDISC_DROP)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index 353322e72a61..2ba331b5b775 100644
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

