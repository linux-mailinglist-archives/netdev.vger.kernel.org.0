Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EE84CC44D
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbiCCRt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235436AbiCCRt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:49:26 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCF55F4D5;
        Thu,  3 Mar 2022 09:48:37 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id g1so5328620pfv.1;
        Thu, 03 Mar 2022 09:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D1g8qA5j8HhiVDyi8ohQbfHFEifnjz8mXbMbMyXSicQ=;
        b=Ce1JdhIuvGhIrcqjHwGoNPahbnjRpKTM43NNwCZdOc/n8WGjrO57m2InBBjPAOSKKJ
         w3/dyVzo/Kw3frLbWokOlji6QtgkjJS8yr98MZN61UXvcP/nYowJWuj1vmd1JPZ1gW70
         sK6AL9xub8zx9sy4hEai+bjYJ/QvNu/AJB/2DbHn92sUCpjIGdoGXhFdcsXXDBcRvWXa
         moiTiM+1VLohnTygSpwKa01DZ+ycUAHwfHxosd0oQ7aMYv7AJIVd0npY252wvnMXsEI9
         YAuRCPhsIPSyOS41CswhD3aolNOjdn200t5YL8ySLxogLmsVVzpCJbv/97TJQ7emuxFi
         dhhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D1g8qA5j8HhiVDyi8ohQbfHFEifnjz8mXbMbMyXSicQ=;
        b=m1Dm3+lobGE7zTVORxtdRjuqvGWtmtviHJ1mF0uApu0utN8XJZ4oy6KmYzNUDlGdJQ
         /SA2xddO8Vve/5VsAhrghLi9GITTDFrgpHkxelolWYHgPSj4Rm9Bz1r02MKsNM7UQH21
         tS4Zki5hSnOpQFPvJOY05TzKm4SK6clvbl1dU+qnrEKzdk3hty0R8sOrVHXNESIyDoo6
         yn6wGcDDDa721RP1odqJzVDEzDRA3/S2H640HLX1PF+VKKBZcJiG7dW2zgjhCAWcOa7s
         Ema4WUWFl8+/5GWKX4ELtPe1aHHgfEzXwXV3ULbEtdLpLP6FNXjtO9nj4GLsxYiMqYj3
         waAg==
X-Gm-Message-State: AOAM532325thWfk77VCszzSghIwtH7rmteS8HwYtnBomtnKYnj3plhdO
        mkLJybXur4zdd/pbg+h0NzI=
X-Google-Smtp-Source: ABdhPJyH+4en9Ep5dOvKPJxVosUVrhXXIelwbmW+FzG5d5mSh0UuFCCqVPtaVistFfeaclEbvETULg==
X-Received: by 2002:a63:894a:0:b0:37c:4f5f:b144 with SMTP id v71-20020a63894a000000b0037c4f5fb144mr4589641pgd.42.1646329716655;
        Thu, 03 Mar 2022 09:48:36 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f0f0f852a4sm3209395pfx.77.2022.03.03.09.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 09:48:36 -0800 (PST)
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
Subject: [PATCH net-next 2/7] net: skb: introduce the function kfree_skb_list_reason()
Date:   Fri,  4 Mar 2022 01:47:02 +0800
Message-Id: <20220303174707.40431-3-imagedong@tencent.com>
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

To report reasons of skb drops, introduce the function
kfree_skb_list_reason() and make kfree_skb_list() an inline call to
it. This function will be used in the next commit in
__dev_xmit_skb().

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h | 8 +++++++-
 net/core/skbuff.c      | 7 ++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ebd18850b63e..e344603aecc4 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1194,10 +1194,16 @@ static inline void kfree_skb(struct sk_buff *skb)
 }
 
 void skb_release_head_state(struct sk_buff *skb);
-void kfree_skb_list(struct sk_buff *segs);
+void kfree_skb_list_reason(struct sk_buff *segs,
+			   enum skb_drop_reason reason);
 void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
 void skb_tx_error(struct sk_buff *skb);
 
+static inline void kfree_skb_list(struct sk_buff *segs)
+{
+	kfree_skb_list_reason(segs, SKB_DROP_REASON_NOT_SPECIFIED);
+}
+
 #ifdef CONFIG_TRACEPOINTS
 void consume_skb(struct sk_buff *skb);
 #else
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b32c5d782fe1..46d7dea78011 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -777,16 +777,17 @@ void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 }
 EXPORT_SYMBOL(kfree_skb_reason);
 
-void kfree_skb_list(struct sk_buff *segs)
+void kfree_skb_list_reason(struct sk_buff *segs,
+			   enum skb_drop_reason reason)
 {
 	while (segs) {
 		struct sk_buff *next = segs->next;
 
-		kfree_skb(segs);
+		kfree_skb_reason(segs, reason);
 		segs = next;
 	}
 }
-EXPORT_SYMBOL(kfree_skb_list);
+EXPORT_SYMBOL(kfree_skb_list_reason);
 
 /* Dump skb information and contents.
  *
-- 
2.35.1

