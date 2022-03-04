Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80DB4CCD79
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 07:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238241AbiCDGCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 01:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238246AbiCDGCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 01:02:34 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC4C18644E;
        Thu,  3 Mar 2022 22:01:47 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id c1so6638470pgk.11;
        Thu, 03 Mar 2022 22:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L9IOl6pjPg22QK2MP5IDPTP2U5QiFnZFZ9yjUF6EnBk=;
        b=WLZRGNecUiHs3lVzcetuym+N87W3/xfs34bO97KIUwpQVSf+vD71DIzI0QpGxHsGSc
         ZVR6+nCFWbbrXOi+cHcqKczkXD/6omNp6EpYx0NLfuox5L3Z9PVfyJypIJJ7IJSLalkK
         2RErbyDPeAXW3TbmNak9JXgQL16xVrR5Oew0j2urZiUPhe3JbXHjc4b9mndc3jp38la7
         KqSSSsdwQ0tlAlqNXXSOSHT8xxzwnh6gXkMseQ05LBZ4+cd0ULt/I8+B9QcJdvmR92mZ
         HVcRcWTDxEbNWYeRiza0bW9wNrFxvIIex2pW2PKv5x/F7o41KTfA8uReCgFUIEETPoMw
         4X3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L9IOl6pjPg22QK2MP5IDPTP2U5QiFnZFZ9yjUF6EnBk=;
        b=J0sUcC+C/ouizHgrLLxpvL1dny1Fot97fMHysJ7Q3vEoxQFLGA5aSO/A89eXwyio/M
         TstcEuyYlBpcWxhbqupyUINg+hibnKtfNkskXXTfO8Dx+sOWYEBB/T6W7SQ3PBkVO2+i
         wrU+uRjZxaSJLrNa955gUQ2Y/hgMr7flXGe3LvnvmLeQ0BUqaqjNoSeFJ3gunxVwyBAo
         5Gz+WC2FgeJIdwqfc1Y/huKg+cqR7iFRtCdUqNBxzFvo/v7Iz2aEn7gL3O5BDWjHtalu
         1+RFhZat99F3QhQKtxYjYb7B65ROC/4zwHsc6U4Q34+cQlbhZoN50g0Soe/UuYpfAzc+
         Gzjg==
X-Gm-Message-State: AOAM530I+8y2rXa4EZjsschhOIBQfG0nP1xSzP+nYYd2qkvYzKCY+W7V
        h4/UTZOGHtkf+49mjNfo79NpTSfiLgI=
X-Google-Smtp-Source: ABdhPJxYqFNPC/jDWUbDysKVzCiVab2X9l5McdowJYkNBxDit8vdq6NEL9TTOOoV78Vp0Z14SkPVyg==
X-Received: by 2002:a63:8a4c:0:b0:37e:31f8:15f2 with SMTP id y73-20020a638a4c000000b0037e31f815f2mr90695pgd.225.1646373707078;
        Thu, 03 Mar 2022 22:01:47 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id y5-20020a056a00190500b004f104b5350fsm4569073pfi.93.2022.03.03.22.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 22:01:46 -0800 (PST)
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
Subject: [PATCH net-next v2 1/7] net: dev: use kfree_skb_reason() for sch_handle_egress()
Date:   Fri,  4 Mar 2022 14:00:40 +0800
Message-Id: <20220304060046.115414-2-imagedong@tencent.com>
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

Replace kfree_skb() used in sch_handle_egress() with kfree_skb_reason().
The drop reason SKB_DROP_REASON_TC_EGRESS is introduced. Considering
the code path of tc egerss, we make it distinct with the drop reason
of SKB_DROP_REASON_QDISC_DROP in the next commit.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- rename SKB_DROP_REASON_QDISC_EGRESS to SKB_DROP_REASON_TC_EGRESS
---
 include/linux/skbuff.h     | 1 +
 include/trace/events/skb.h | 1 +
 net/core/dev.c             | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index d67941f78b92..4328dfc3281c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -394,6 +394,7 @@ enum skb_drop_reason {
 						 * entry is full
 						 */
 	SKB_DROP_REASON_NEIGH_DEAD,	/* neigh entry is dead */
+	SKB_DROP_REASON_TC_EGRESS,	/* dropped in TC egress HOOK */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 1977f301260d..53755e8191a1 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -45,6 +45,7 @@
 	EM(SKB_DROP_REASON_NEIGH_FAILED, NEIGH_FAILED)		\
 	EM(SKB_DROP_REASON_NEIGH_QUEUEFULL, NEIGH_QUEUEFULL)	\
 	EM(SKB_DROP_REASON_NEIGH_DEAD, NEIGH_DEAD)		\
+	EM(SKB_DROP_REASON_TC_EGRESS, TC_EGRESS)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index 2d6771075720..353322e72a61 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3860,7 +3860,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	case TC_ACT_SHOT:
 		mini_qdisc_qstats_cpu_drop(miniq);
 		*ret = NET_XMIT_DROP;
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_TC_EGRESS);
 		return NULL;
 	case TC_ACT_STOLEN:
 	case TC_ACT_QUEUED:
-- 
2.35.1

