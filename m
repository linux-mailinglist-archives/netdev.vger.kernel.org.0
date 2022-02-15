Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB3A4B6B0E
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbiBOLdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:33:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237384AbiBOLdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:33:23 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FD913EA5;
        Tue, 15 Feb 2022 03:32:55 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id c3so12877117pls.5;
        Tue, 15 Feb 2022 03:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uvNG3b2ZVAODPVHZbR7OYDshW9r7jcq3KS61WPMxW90=;
        b=T2fE7+oGkLWvKCMISDbt4bvOr7QIHlkrZlnQet4SeOSLZPVjKT3pWkYg3UDXs1SPRg
         YBE2wQq4UchSyDXvJgvOnHflX78v6Df2RIBEmfMQl/SODnKmxT1RsFcaWtIyDMHXJl/T
         VBoYbiekjo6P37OZ9EpcbW2FSIcPd+CFbXw4wXE8ZywQqPcqVX6kcCVmOFaAsbpyhUpX
         aXnFFKwRumazi6MgnxI+uVHj4JeOjhOTqcBN5yd1J6trqxfJQm30wfRGEvD47gD7WB8R
         +UXS8UAKw9SxMkktLVN+rNVSFsgMWTohWIh3lay0JL3VITklQIMH8Kq63XDAdAk3QzeO
         1TdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uvNG3b2ZVAODPVHZbR7OYDshW9r7jcq3KS61WPMxW90=;
        b=HtY8QPP6c8fUzScDxfb0bUO5pJH40mgmPkbJNyOoIvYrLz485V7yW7xh9wq4CEwgyo
         fXv+sD1qO88yrJbkDURHuUp72Ycz0O9VbC3Fz2auQ1gu2Kzp9d0vfEsryz375HdCaXaB
         b2PTe3QbMnUnoIlrKbBcgKOE7ljKZM5h7sEDjEXgr5sagzlWyAazvqBRbZlFXCgAzoVX
         lFDZo8NnG9Ne7gbgxgixuyA/40urlgpkqBB8NToCFEl5ZqH+P869NYC+RwUexjUpzF8i
         8mKi5nKdnAP5hh4hfFjr9wN7kCJShdAXtg1nXFPNLwDkUAZEp6mRsKRgWwuUYczC1zYK
         NqQQ==
X-Gm-Message-State: AOAM531OV2+eSExSInNNEpF2O+rk7dbEuzTTajKaJZ9CtJil3V9Iz1wI
        NCnDxrbIlap8vk3xvzNu5rc=
X-Google-Smtp-Source: ABdhPJw2H1l6j9qqcE3Sp6JhI0pOdJnG6iQ17yFicjP59I0hrTkpTTpS6iQab8ePR5xq32PTvq0Duw==
X-Received: by 2002:a17:902:8d96:: with SMTP id v22mr3646721plo.77.1644924775195;
        Tue, 15 Feb 2022 03:32:55 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:32:54 -0800 (PST)
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
Subject: [PATCH net-next 19/19] net: dev: use kfree_skb_reason() for __netif_receive_skb_core()
Date:   Tue, 15 Feb 2022 19:28:12 +0800
Message-Id: <20220215112812.2093852-20-imagedong@tencent.com>
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

Add reason for skb drops to __netif_receive_skb_core() when packet_type
not found to handle the skb. For this purpose, the drop reason
SKB_DROP_REASON_PTYPE_ABSENT is introduced. Take ether packets for
example, this case mainly happens when L3 protocol is not supported.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 5 +++++
 include/trace/events/skb.h | 1 +
 net/core/dev.c             | 8 +++++---
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e36e27943104..b467a5adfeaf 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -415,6 +415,11 @@ enum skb_drop_reason {
 					 * failed (maybe an eBPF program
 					 * is tricking?)
 					 */
+	SKB_DROP_REASON_PTYPE_ABSENT,	/* no packet_type found to handle
+					 * the skb. For an etner packet,
+					 * this means that L3 protocol is
+					 * not supported
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 96a550570dfe..f649c0a18d29 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -48,6 +48,7 @@
 	EM(SKB_DROP_REASON_CPU_BACKLOG, CPU_BACKLOG)		\
 	EM(SKB_DROP_REASON_XDP, XDP)				\
 	EM(SKB_DROP_REASON_QDISC_INGRESS, QDISC_INGRESS)	\
+	EM(SKB_DROP_REASON_PTYPE_ABSENT, PTYPE_ABSENT)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index c67e3491c004..90488d05f83b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5323,11 +5323,13 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 		*ppt_prev = pt_prev;
 	} else {
 drop:
-		if (!deliver_exact)
+		if (!deliver_exact) {
 			atomic_long_inc(&skb->dev->rx_dropped);
-		else
+			kfree_skb_reason(skb, SKB_DROP_REASON_PTYPE_ABSENT);
+		} else {
 			atomic_long_inc(&skb->dev->rx_nohandler);
-		kfree_skb(skb);
+			kfree_skb(skb);
+		}
 		/* Jamal, now you will not able to escape explaining
 		 * me how you were going to use this. :-)
 		 */
-- 
2.34.1

