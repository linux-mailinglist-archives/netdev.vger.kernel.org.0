Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4285545AC4
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345966AbiFJDov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345994AbiFJDot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:44:49 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E98C37E89D;
        Thu,  9 Jun 2022 20:44:48 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gc3-20020a17090b310300b001e33092c737so1054337pjb.3;
        Thu, 09 Jun 2022 20:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=toFzfxDcNAOLYWQB4b127Zf224IUbbcInL430hwlC3I=;
        b=RsbGiywD3tPrXtSrQg5Hd/IL4UIMGAcVuBdvWefpFY+Z/ty5scsJcntj9NeJMK54Iz
         q9YEnNb+IP0biiFYWC7YgJf6N7SoTFgEJ/O3RZHaPUrFrdZjFj9O2sHGFAaIU8+n9fZs
         yvCxGPEEtyNOdoYZNa8h3WHNarjHJDpyibnVFlBLB2qT+DbQGUfp0p3HYfuj+cltPJxU
         fuMMIh5DMxxbmovrEGcl8/mOiqICru63kbzVzScobkVgkKkbGalplWyOopdchu7ZCD+Q
         gD2RTXZaEOUzQMQ56WcEP4CwO12tgETuu4F2Nt8eL9rbK9S+usDb4umWiHQkm88PDVzs
         dmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=toFzfxDcNAOLYWQB4b127Zf224IUbbcInL430hwlC3I=;
        b=rp3bv+wNryKRjwC760jibeMu41Lpta3rXnlXlqC9B7R5D4VS8h9f7T6QeXNhOtw5mv
         DL3Ubbzqd8jUa095akOX3B5gn7xsv/d1TyiCNShmAdmkEmJExCdX12us30GbHRO8M2F0
         WslZ2XvJKNQjei1vyg3ACUPYY89H8NG2k8jRYBegD8syPcEDG9f7liSbxfs3zziI8HiN
         +/38xYdibWKYMX2+fdNob5N7kkuTAKwqjWZSKkBfm2gXVMYSJ7FQE933YQBjn783hDNQ
         mimYnv20OWgBY6aUhELusGwiPb+0P/xk6zaEOScq4AOWKFiY1VE30oLznG0AGDcJw/5V
         PWXA==
X-Gm-Message-State: AOAM531fEIIt4Lp2I3cM2x4rUnN3HLrxPmS/e5BvugG+4Y/yxQPsBdiU
        anYlvRsrQ5ckDhusQN+FYR8=
X-Google-Smtp-Source: ABdhPJyrm4+4Obv+9ot/mxThaQHEkd2WuBpIhzoAFa7xPbqIpgXY5dxOeHnU6HSasiRYlTWiufVXhw==
X-Received: by 2002:a17:902:e88e:b0:163:ee82:ffb with SMTP id w14-20020a170902e88e00b00163ee820ffbmr43796014plg.142.1654832687952;
        Thu, 09 Jun 2022 20:44:47 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id u30-20020a63b55e000000b003fc136f9a7dsm5908368pgo.38.2022.06.09.20.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 20:44:47 -0700 (PDT)
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
Subject: [PATCH net-next v3 1/9] net: skb: introduce __skb_queue_purge_reason()
Date:   Fri, 10 Jun 2022 11:41:56 +0800
Message-Id: <20220610034204.67901-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220610034204.67901-1-imagedong@tencent.com>
References: <20220610034204.67901-1-imagedong@tencent.com>
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
index 82edf0359ab3..8d5445c3d3e7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3020,18 +3020,24 @@ static inline int skb_orphan_frags_rx(struct sk_buff *skb, gfp_t gfp_mask)
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

