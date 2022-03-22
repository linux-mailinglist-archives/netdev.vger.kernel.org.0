Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152D64E36E9
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 03:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbiCVCzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 22:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235690AbiCVCzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 22:55:05 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4F110611D;
        Mon, 21 Mar 2022 19:53:37 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id w8so14310524pll.10;
        Mon, 21 Mar 2022 19:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=//KZ6YHhys1mLVWKPMFh1+e7V9mc1xx+r9/4L0Awq3M=;
        b=fzpui0GWlWpFez6IvjCF3jDiT5Csb42+vRNyh+c9wt2w6MeqkxJIsWULy26OsGeey1
         e4sUesGIttABi7JuOMRBee8tuxyP/I99izWUqACKkGpIFsj6vYCZCGmQ9nMQ2joVEzpw
         dIS4GXMMJFOKWssnvTpHY37471yoqQBfVmjJvBkCi7XAAQ4t/lQ8BdV5KtzUH8SShk4W
         catNl1AKSGWo1Vykmr78V9ZdcBXQO48oBLV2Hu746/uA3g3Sy51Fqmz2gkb6d0K76Df5
         VPpbWMG8r54HQTyqf1B3RIR9hAi4v8pKfNNAR641bRKFHwi5cZm3yZdfpi58mdppgeqS
         DR6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=//KZ6YHhys1mLVWKPMFh1+e7V9mc1xx+r9/4L0Awq3M=;
        b=UnXcxa204+IN6hEfdQ7n1cPLriIq4iett6RkD3SYlLEQOFIuAKw0ml8OH0Q/oZpk7F
         n5ULf8zEOwWhA9w1FSasDgeON/VxaoY1ldrnRjaQy2tnXXvAvmFhS3Ug8AWVXW/myMeo
         5pkRP9NbZORjFBnyhqsiSVARCwR7r+qqF69k0eX6Q8eH4IxHAKugAuGzOKtI9Yx8GjtD
         mE6QzprlXk77bJkuyzErjhNPnmE6FpaM17M83h+FPvIZyUKxIEsETdXC5mjQNhpqKWAW
         +AyZ0Lpvs3l4r74TFj3mHUVmzORLxZCbiHw0uk6To2C098lR/v77rZHEdrBGmA9jdve0
         Z21g==
X-Gm-Message-State: AOAM533YYVO0qQeoBU0ybAc8w1EIsajS4fpeqzsWFKd+jcgHbDIVJjsS
        xplm9ShR8Ht38KgPBYiFB+8=
X-Google-Smtp-Source: ABdhPJxwa2ncEptSwDnqe0x+wmZou7J/3aYSOxEFQ+w+YeHhZHXVYMMbBO31AGFBczZIW7rDm5TyIQ==
X-Received: by 2002:a17:903:230a:b0:154:6770:ea6d with SMTP id d10-20020a170903230a00b001546770ea6dmr6046887plh.139.1647917616995;
        Mon, 21 Mar 2022 19:53:36 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id g24-20020a17090a579800b001c60f919656sm764687pji.18.2022.03.21.19.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 19:53:36 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, xeb@mail.ru,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, benbjiang@tencent.com
Subject: [PATCH net-next v4 2/4] net: skb: rename SKB_DROP_REASON_PTYPE_ABSENT
Date:   Tue, 22 Mar 2022 10:52:18 +0800
Message-Id: <20220322025220.190568-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220322025220.190568-1-imagedong@tencent.com>
References: <20220322025220.190568-1-imagedong@tencent.com>
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

As David Ahern suggested, the reasons for skb drops should be more
general and not be code based.

Therefore, rename SKB_DROP_REASON_PTYPE_ABSENT to
SKB_DROP_REASON_UNHANDLED_PROTO, which is used for the cases of no
L3 protocol handler, no L4 protocol handler, version extensions, etc.

From previous discussion, now we have the aim to make these reasons
more abstract and users based, avoiding code based.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 8 +++-----
 include/trace/events/skb.h | 2 +-
 net/core/dev.c             | 8 +++-----
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 26538ceb4b01..10ba07892c46 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -408,11 +408,9 @@ enum skb_drop_reason {
 					 */
 	SKB_DROP_REASON_XDP,		/* dropped by XDP in input path */
 	SKB_DROP_REASON_TC_INGRESS,	/* dropped in TC ingress HOOK */
-	SKB_DROP_REASON_PTYPE_ABSENT,	/* not packet_type found to handle
-					 * the skb. For an etner packet,
-					 * this means that L3 protocol is
-					 * not supported
-					 */
+	SKB_DROP_REASON_UNHANDLED_PROTO,	/* protocol not implemented
+						 * or not supported
+						 */
 	SKB_DROP_REASON_SKB_CSUM,	/* sk_buff checksum computation
 					 * error
 					 */
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index e1670e1e4934..85abd7cbd221 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -50,7 +50,7 @@
 	EM(SKB_DROP_REASON_CPU_BACKLOG, CPU_BACKLOG)		\
 	EM(SKB_DROP_REASON_XDP, XDP)				\
 	EM(SKB_DROP_REASON_TC_INGRESS, TC_INGRESS)		\
-	EM(SKB_DROP_REASON_PTYPE_ABSENT, PTYPE_ABSENT)		\
+	EM(SKB_DROP_REASON_UNHANDLED_PROTO, UNHANDLED_PROTO)	\
 	EM(SKB_DROP_REASON_SKB_CSUM, SKB_CSUM)			\
 	EM(SKB_DROP_REASON_SKB_GSO_SEG, SKB_GSO_SEG)		\
 	EM(SKB_DROP_REASON_SKB_UCOPY_FAULT, SKB_UCOPY_FAULT)	\
diff --git a/net/core/dev.c b/net/core/dev.c
index 75bab5b0dbae..d73b35e6aae4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5359,13 +5359,11 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 		*ppt_prev = pt_prev;
 	} else {
 drop:
-		if (!deliver_exact) {
+		if (!deliver_exact)
 			dev_core_stats_rx_dropped_inc(skb->dev);
-			kfree_skb_reason(skb, SKB_DROP_REASON_PTYPE_ABSENT);
-		} else {
+		else
 			dev_core_stats_rx_nohandler_inc(skb->dev);
-			kfree_skb(skb);
-		}
+		kfree_skb_reason(skb, SKB_DROP_REASON_UNHANDLED_PROTO);
 		/* Jamal, now you will not able to escape explaining
 		 * me how you were going to use this. :-)
 		 */
-- 
2.35.1

