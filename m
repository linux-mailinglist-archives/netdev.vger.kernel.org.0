Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9EA4CC446
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbiCCRtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235232AbiCCRtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:49:17 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DBB5523C;
        Thu,  3 Mar 2022 09:48:31 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id bd1so5196155plb.13;
        Thu, 03 Mar 2022 09:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fVdTMm1MoKAuDl3iNhPobLEeG1YoGE3fthuxjoz4iSA=;
        b=jkbOP7jlYnjdcFidIOClWrppzpnklc9u0W3moffTBKxusrl5uAr7xlPupLd5473VF5
         +Sj0+YizxQCNa+R9yA/dvV/4K1ABDpXdpqLvTMUQ3ijU4LLSEHSA+sY9tbLSaS9GEx3Q
         J07mkxts/EgTdH1t5xbN0aF0m6urTX+fJCrB6Ifzn32swLc+5znS+54XLXYlUbkUdRWD
         pYyLXRm+t/hy50AqSWJOiNEPAKhpJJaTVuvN7ca7Iba+0uJlx1z/HwHxosd5iYy6xZdX
         3VCNNH/B2UMO6nUhhOKPQbdUvaHe3sfGlN5fO4UabuzoqRBBtdaz0/4Fui24Ei0vwlOL
         nqwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fVdTMm1MoKAuDl3iNhPobLEeG1YoGE3fthuxjoz4iSA=;
        b=Mg5Nn8HaiVEDB2wW2COc64dw5NldA8oQIxEPSkF9fCsRZ2GcZvVPo0RYe1/0jdxR5W
         f90SR8SD4rjsD6KVpbRd+64fIrtPjfMfIr2CGH5vNBWNvolMQyG04+ihcBeVOcNQ3l1j
         rfnccuOEhZjPXxOvDeIDdsBXT7IawvKJcGwrwTT+WcVCNKYv1fFGj3pqU5kAG2/YataH
         V4yS4YwWvkYtoz+ZwEB53BP2Bi1bmFUfLPMmIrkwwZaAv/5euG00ASGSzUp20iy6BYIJ
         1hvG+UTJHKyZ4yPwQgtihb753ac4tjNB/BDhd/m42xKR9oq80qj4DWivPdBKqbQ06AcJ
         72cQ==
X-Gm-Message-State: AOAM530Ym3xDkIH0NLZyF8iJabaQgb1kthXey4tGEVvDxNW4Vfbd79TL
        fMH+p4HMrabPR60grnxz9AI=
X-Google-Smtp-Source: ABdhPJxFwGvu2yyZFcAIvZ3WCf6FLkeewdn6Pk6SDmXp1q8qvo3oUeW+6qKa0qTbMdowgohmv6PMxA==
X-Received: by 2002:a17:902:b18d:b0:151:7456:4f77 with SMTP id s13-20020a170902b18d00b0015174564f77mr18266833plr.41.1646329710532;
        Thu, 03 Mar 2022 09:48:30 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f0f0f852a4sm3209395pfx.77.2022.03.03.09.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 09:48:30 -0800 (PST)
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
Subject: [PATCH net-next 1/7] net: dev: use kfree_skb_reason() for sch_handle_egress()
Date:   Fri,  4 Mar 2022 01:47:01 +0800
Message-Id: <20220303174707.40431-2-imagedong@tencent.com>
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

Replace kfree_skb() used in sch_handle_egress() with kfree_skb_reason().
The drop reason SKB_DROP_REASON_QDISC_EGRESS is introduced. Considering
the code path of qdisc egerss, we make it distinct with the drop reason
of SKB_DROP_REASON_QDISC_DROP in the next commit.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 4 ++++
 include/trace/events/skb.h | 1 +
 net/core/dev.c             | 2 +-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index d67941f78b92..ebd18850b63e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -394,6 +394,10 @@ enum skb_drop_reason {
 						 * entry is full
 						 */
 	SKB_DROP_REASON_NEIGH_DEAD,	/* neigh entry is dead */
+	SKB_DROP_REASON_QDISC_EGRESS,	/* qdisc of type egress check
+					 * failed (mapbe an eBPF program
+					 * is tricking?)
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 1977f301260d..3cadf13448c6 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -45,6 +45,7 @@
 	EM(SKB_DROP_REASON_NEIGH_FAILED, NEIGH_FAILED)		\
 	EM(SKB_DROP_REASON_NEIGH_QUEUEFULL, NEIGH_QUEUEFULL)	\
 	EM(SKB_DROP_REASON_NEIGH_DEAD, NEIGH_DEAD)		\
+	EM(SKB_DROP_REASON_QDISC_EGRESS, QDISC_EGRESS)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index 2d6771075720..828946d74a19 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3860,7 +3860,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	case TC_ACT_SHOT:
 		mini_qdisc_qstats_cpu_drop(miniq);
 		*ret = NET_XMIT_DROP;
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_QDISC_EGRESS);
 		return NULL;
 	case TC_ACT_STOLEN:
 	case TC_ACT_QUEUED:
-- 
2.35.1

