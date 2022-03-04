Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E61F4CCD81
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 07:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238302AbiCDGD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 01:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238292AbiCDGDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 01:03:06 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE29187E2F;
        Thu,  3 Mar 2022 22:02:19 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id e15so5205243pfv.11;
        Thu, 03 Mar 2022 22:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BZGaInOiLUr+kDcdbjgKggubDUn9ZQLD7jeoPnkVS2s=;
        b=X2D2HuQnHwkQXfRLFYyVBS+xgxKSezpHpx9+UUiBNEKHvHglkYxe1hTdVlfMlDRkjA
         AmUEsAkUQKWEtINhcqPvAdsNrtCXm0rcba/81UiBgDORly6jQvX+7/gG2B/fgJ01daD4
         KehFzJ9VkizihcP6avYCS/WtidoLD56xL1TMK2HP80pfEjFFLl2l+eROYC7jCxq/pCje
         iIkBwcVRR72rT9LkY2nQ3nhB10bKeKFWRG58DMcGO7PNXrbmUOZ0/R0jOjKxYIavAgrC
         GSAZu/sinpmEOd1O7b8xXYd7zllr3kTxrIEbsvLN/+fzosAaWR6HWsyoJQHofnpWkgpO
         QILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BZGaInOiLUr+kDcdbjgKggubDUn9ZQLD7jeoPnkVS2s=;
        b=SSNkeQ7h+yvnmE4h+nhlWSRtzCBXVbsRMvbxWd7BH3E8WO5/V8tTrG0GK9bcukdfqT
         iT1FEZyoojOfSgFkRq/oOjEZS/GcW0+rITQ7WJeNUbGwCQq4zZCqrdQ7yqY4rv5F7uG4
         2OKmaEPKqDzaFtuBaXHDYgF/n8gmIL20odt0GZu8UyCTUL95S9r1O8EDmqpK1EDb0Xyh
         RDa49zxe/W0jHvI6imxcf2a1h3heJ2Gr80odVMR1YwH2UCwBAYLoGH0Ds0FRT1XCPRJg
         wJzaZeqW0J8SeCN5FcX/17lj59niFvHI5T9he4rb7pQ/H7/q/6/Gs/cmqrZfds+eV3Un
         mA3A==
X-Gm-Message-State: AOAM531LRj9AMX90e9UqQK/bWPYHUMTEP3koNnAHBcCEG8BMUxZ18bZ2
        wOcXKrL59AlQETw6pdqkWao=
X-Google-Smtp-Source: ABdhPJzD0P/BUERhKEQF5HyY9TzVl0iLBvCrwTO3xzYQUfje/ZoAOrI29HqAe4bRg3hgUIoSpwtjag==
X-Received: by 2002:a65:5189:0:b0:378:f265:982e with SMTP id h9-20020a655189000000b00378f265982emr13066548pgq.582.1646373739173;
        Thu, 03 Mar 2022 22:02:19 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id y5-20020a056a00190500b004f104b5350fsm4569073pfi.93.2022.03.03.22.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 22:02:18 -0800 (PST)
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
Subject: [PATCH net-next v2 6/7] net: dev: use kfree_skb_reason() for sch_handle_ingress()
Date:   Fri,  4 Mar 2022 14:00:45 +0800
Message-Id: <20220304060046.115414-7-imagedong@tencent.com>
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

Replace kfree_skb() used in sch_handle_ingress() with
kfree_skb_reason(). Following drop reasons are introduced:

SKB_DROP_REASON_TC_INGRESS

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- rename SKB_DROP_REASON_QDISC_INGRESS to SKB_DROP_REASON_TC_INGRESS
---
 include/linux/skbuff.h     | 1 +
 include/trace/events/skb.h | 1 +
 net/core/dev.c             | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e13ef6ca5470..d0a10fa477be 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -406,6 +406,7 @@ enum skb_drop_reason {
 					 * net.rst) or RPS flow limit
 					 */
 	SKB_DROP_REASON_XDP,		/* dropped by XDP in input path */
+	SKB_DROP_REASON_TC_INGRESS,	/* dropped in TC ingress HOOK */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 8c4c343c830f..514dd2de8776 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -49,6 +49,7 @@
 	EM(SKB_DROP_REASON_QDISC_DROP, QDISC_DROP)		\
 	EM(SKB_DROP_REASON_CPU_BACKLOG, CPU_BACKLOG)		\
 	EM(SKB_DROP_REASON_XDP, XDP)				\
+	EM(SKB_DROP_REASON_TC_INGRESS, TC_INGRESS)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index 5ad74a46452b..7eb293684871 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5012,7 +5012,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 		break;
 	case TC_ACT_SHOT:
 		mini_qdisc_qstats_cpu_drop(miniq);
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_TC_INGRESS);
 		return NULL;
 	case TC_ACT_STOLEN:
 	case TC_ACT_QUEUED:
-- 
2.35.1

