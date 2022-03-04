Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1A54CCD7F
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 07:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238254AbiCDGDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 01:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238293AbiCDGCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 01:02:54 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA9D187BB5;
        Thu,  3 Mar 2022 22:02:06 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id t14so6668982pgr.3;
        Thu, 03 Mar 2022 22:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pNFrY2MhzoakFNW6ci8QTeSX3zRLAuHfLCZuqh4I71Y=;
        b=jAlc4UdrydDIJ23f6GwmZhCfGK6niQ/+YpwSezFPqnTOJFGSLxHlgKFpyV//3VNK4/
         Xhh/7ciTu/9l4h2AvwzUpKwaRtkBqHTJyvtM8kyXe6E94F4jjeJMf2RAOblwkdF6mMPz
         p2rZ+Km1e3L0z5aOQaL+9M80Yq8Z3GgiqTX6YJHQOvlI9yTtGEfoFZAjmsWjpmbT0zp5
         Oe+pyMnFQNAZwB1urqENLAcHnx9zRk4N5qJsQo6u+guiRUb61zwCn2ztSSnSviXY9MHR
         aeTVTH3sUXufgVoponxiCE4/STG8366xtXcTs6UimhUf9o7L/L83CJ64s19z40kib2Tg
         r7iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pNFrY2MhzoakFNW6ci8QTeSX3zRLAuHfLCZuqh4I71Y=;
        b=BydA6o4eQ+DB0bGKeiVzWwJaKpYzQdyHZzwM4JcTSqBQvOMJaUj9LZWmQ9OjvDEG5P
         MSFn/oKwzo+6SPR8ToJXSA1j330AwK6rmoITF5Pl1WZMSJWRY6CY8TYkdhleQLX6IbkK
         ypVMkCG8U92cTWHW7albfTigRtF2EXN8kYM0uOZLiE4Ygn4pMhdlmGNMJUG/Cx7A7hM7
         SLImZOsSqH1Yx1eNkr14FqKpbVvRsuKV17ou5TLfRXlmEiIuI/I56Jc+grNgTisEubUl
         AJBOwLqRajo8DVkZWu2FXExs6xUYw4dlN3gE2VjlLJNSULoQl/Jotu5WsmKgiK+qtO6O
         coQg==
X-Gm-Message-State: AOAM533NVqHDFXO6DF19Qsemqo0BroPsLQmP+O40GbVZG2FZ/z2kxw9d
        H8mZ8SERSKNXQMmZ2i5MYjY=
X-Google-Smtp-Source: ABdhPJze2Haz8Mif3fbJheI8tbVi5baPyGwsK2vbIP09IJMY7YTDREKH/KMasC9N+huECprL2fbLyw==
X-Received: by 2002:a63:82c1:0:b0:37c:99c3:e3ef with SMTP id w184-20020a6382c1000000b0037c99c3e3efmr1052751pgd.27.1646373726392;
        Thu, 03 Mar 2022 22:02:06 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id y5-20020a056a00190500b004f104b5350fsm4569073pfi.93.2022.03.03.22.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 22:02:05 -0800 (PST)
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
Subject: [PATCH net-next v2 4/7] net: dev: use kfree_skb_reason() for enqueue_to_backlog()
Date:   Fri,  4 Mar 2022 14:00:43 +0800
Message-Id: <20220304060046.115414-5-imagedong@tencent.com>
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

Replace kfree_skb() used in enqueue_to_backlog() with
kfree_skb_reason(). The skb rop reason SKB_DROP_REASON_CPU_BACKLOG is
introduced for the case of failing to enqueue the skb to the per CPU
backlog queue. The further reason can be backlog queue full or RPS
flow limition, and I think we needn't to make further distinctions.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 6 ++++++
 include/trace/events/skb.h | 1 +
 net/core/dev.c             | 5 ++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a3d65e749ea3..cf168f353338 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -399,6 +399,12 @@ enum skb_drop_reason {
 					 * outputting (failed to enqueue to
 					 * current qdisc)
 					 */
+	SKB_DROP_REASON_CPU_BACKLOG,	/* failed to enqueue the skb to
+					 * the per CPU backlog queue. This
+					 * can be caused by backlog queue
+					 * full (see netdev_max_backlog in
+					 * net.rst) or RPS flow limit
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index dbf3e2e3c1b4..3bb90ca893ae 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -47,6 +47,7 @@
 	EM(SKB_DROP_REASON_NEIGH_DEAD, NEIGH_DEAD)		\
 	EM(SKB_DROP_REASON_TC_EGRESS, TC_EGRESS)		\
 	EM(SKB_DROP_REASON_QDISC_DROP, QDISC_DROP)		\
+	EM(SKB_DROP_REASON_CPU_BACKLOG, CPU_BACKLOG)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index 2ba331b5b775..0d097d0e710f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4541,10 +4541,12 @@ static bool skb_flow_limit(struct sk_buff *skb, unsigned int qlen)
 static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 			      unsigned int *qtail)
 {
+	enum skb_drop_reason reason;
 	struct softnet_data *sd;
 	unsigned long flags;
 	unsigned int qlen;
 
+	reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	sd = &per_cpu(softnet_data, cpu);
 
 	rps_lock_irqsave(sd, &flags);
@@ -4567,13 +4569,14 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 			napi_schedule_rps(sd);
 		goto enqueue;
 	}
+	reason = SKB_DROP_REASON_CPU_BACKLOG;
 
 drop:
 	sd->dropped++;
 	rps_unlock_irq_restore(sd, &flags);
 
 	atomic_long_inc(&skb->dev->rx_dropped);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return NET_RX_DROP;
 }
 
-- 
2.35.1

