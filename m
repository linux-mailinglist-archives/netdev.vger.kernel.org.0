Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C64529BE7
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242542AbiEQIL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242895AbiEQIL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:11:57 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D603CA57;
        Tue, 17 May 2022 01:11:56 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w200so337252pfc.10;
        Tue, 17 May 2022 01:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PFUmdFHadjVSWKgDGHvFdEqXwH0fA/y0X+v/6NyB02o=;
        b=SC/hukbpWW+a5yMv8Ch5Ltq/54B7Mk7Iu1ukbh1d7rHYnYYhrB6da5wxfRnd2pPA4g
         z4tFRZp99sljMCjD3eEIwdnFo34IriXuZ7hDrmIePOlhabDDw2e6QacyA5IMdiq7LlLO
         LFFhsaQh3mSZ3Vq+IIP17m9m+M8JOPaBFx0GdXC3lgzoSbjzgQuXT/OI8hSy6XRz8Pmp
         nqu29qV61LkwpbeUHCs2ygbuRPuLfz2n/0o5lefGEW8Yl6c4vRYsyYKgbAwL1xzdlrKT
         CwP6DIjokwTmmhsZpLx2Vv0f2miFFutRTVtWI46daf2MA+bzBI2ITdJP0vLopRos2yBX
         I92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PFUmdFHadjVSWKgDGHvFdEqXwH0fA/y0X+v/6NyB02o=;
        b=3G/+GhEoB/5csZ+VHJF7GuaCocNPctJnN3mn3FxgSr6le/Qp3hx6Gy8sEYoUvj7R7x
         92tOkzG892cwo4bb9pMrXMp2aCmXlZn3TAjvtOljQD1Q8vGi8TVq+lTc3Sql5ixdkbYk
         e9TBxDTC9WSBpcMV2EkGKmgHA7WDe5GTXOZ80IA9OXEeR5FgNVzGz0uQUQ4TL1UY22Uh
         sbabHBw/jXzUnUazlMrR6wj5Uku4GSnLFZMrj0BrIKkQklm1glcz17w1+RNvayIdVmyy
         uh0dV1peF5mSphpBGxWW6JmXMSO+WL2KAEBaxA88v8Ww8cACE9aDCyHL2C+BX3rpibGF
         HSKg==
X-Gm-Message-State: AOAM530M8kK8JyeFwKnqrgb0ApZ3cEzCOBquEfVxkalGCOAszLXtIMuT
        yQPBAOyoupYg9wTD/5EPj68=
X-Google-Smtp-Source: ABdhPJyjWuQLM53tDQ80cZZXhrYJPrAkc/zBQyq0h4cTnU147xlc7UBjKuawyMF2GNTSOBSc1HbyVA==
X-Received: by 2002:a63:2b0b:0:b0:39d:890a:ab68 with SMTP id r11-20020a632b0b000000b0039d890aab68mr18266378pgr.247.1652775116105;
        Tue, 17 May 2022 01:11:56 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id c14-20020a170902c2ce00b0015e8d4eb2easm8336306pla.308.2022.05.17.01.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 01:11:55 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH net-next v2 2/9] net: skb: introduce __skb_queue_purge_reason()
Date:   Tue, 17 May 2022 16:10:01 +0800
Message-Id: <20220517081008.294325-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220517081008.294325-1-imagedong@tencent.com>
References: <20220517081008.294325-1-imagedong@tencent.com>
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

Introduce __skb_queue_purge_reason() to empty a skb list with drop
reason and make __skb_queue_purge() an inline call to it.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dfc568844df2..e9659a63961a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3323,18 +3323,24 @@ static inline int skb_orphan_frags_rx(struct sk_buff *skb, gfp_t gfp_mask)
 }
 
 /**
- *	__skb_queue_purge - empty a list
+ *	__skb_queue_purge_reason - empty a list with specific drop reason
  *	@list: list to empty
+ *	@reason: drop reason
  *
  *	Delete all buffers on an &sk_buff list. Each buffer is removed from
  *	the list and one reference dropped. This function does not take the
  *	list lock and the caller must hold the relevant locks to use it.
  */
-static inline void __skb_queue_purge(struct sk_buff_head *list)
+static inline void __skb_queue_purge_reason(struct sk_buff_head *list,
+					    enum skb_drop_reason reason)
 {
 	struct sk_buff *skb;
 	while ((skb = __skb_dequeue(list)) != NULL)
-		kfree_skb(skb);
+		kfree_skb_reason(skb, reason);
+}
+static inline void __skb_queue_purge(struct sk_buff_head *list)
+{
+	__skb_queue_purge_reason(list, SKB_DROP_REASON_NOT_SPECIFIED);
 }
 void skb_queue_purge(struct sk_buff_head *list);
 
-- 
2.36.1

