Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9194B6B22
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbiBOLdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:33:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237336AbiBOLcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:32:39 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E641D30D;
        Tue, 15 Feb 2022 03:32:21 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso2529927pjg.0;
        Tue, 15 Feb 2022 03:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SkNAR3lDZcmBWeuKDCFBfpoA/7HZcdiBmnBFE2F5L64=;
        b=GZ9OUDvX25uu7M0gOzefMn7E7Z5QNqI0GPYYyIBj6wyCj/M5gWNcjRJ8dsZ9SDWoKu
         1zdk0aBMj6TcJ8HAjBiuAfz+x7T0t75nG6zpFo+rL6gaHDBX3BYmamGZgg9PqLR4PbTt
         Akp3DHdHM4oZ9Shhhrmepni2w5wRRRyshklHGe5EB+NryIF3b5+3RU35pQ1L+CYPeC+J
         E/2YlVsTjnwd3/srfbOZO5mVoDWlUDvVlWXar0iumwtQgGM+9iP9xe1oOKoBG9uq8gWh
         aMLWJEVrWQQUvZYdkLdgmOEBa/RUa87sRXwvZ/uhHd8NQ1b00OE9UM2j+uRfByW7z1In
         QX9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SkNAR3lDZcmBWeuKDCFBfpoA/7HZcdiBmnBFE2F5L64=;
        b=7z7f6kkJXm6Cwwe+iemP/03iAzVSXrXwSRmFrLFVqeN29xYcdHPZetXcsSDPSOLTtK
         MJyVW4eXn3sYrEiWm6d1sYsfCkDouE8wzhbBZEEsX0W6rAhCzU265jKJMnLshZ7Sk0CG
         UAG/k4bZW86B6T1J0hG9pRaeOoHsAPUBx000sTWVKaTA681eEYJgYCr6I7/rCy9TDtdr
         r8YZ+rQE5AH8Gee7l47Dp6Bw82fUvuUx875go3+N2iCSXYp1jahva/dH6Wy4+HeQcdi0
         q4CFOUAiBFkl/aSZYSu+nf4Vr984ahT/fW9xc7KmF2bEhhGLsFS499nmzlgvHOJARfdl
         +JpQ==
X-Gm-Message-State: AOAM532AQI53kMufhlx1+vikl1cls2wrdBEgWclnG9WRZ4yS4Rjjml0C
        w96fH7La1Y9jo9FbDAe3EBI=
X-Google-Smtp-Source: ABdhPJxHzUprbOT7DlhkjIqJGcqlcvTgQN/MMioMl3+q0IHTTgmTJC8SRbCvecqVcelRXWf9gqGcKA==
X-Received: by 2002:a17:90a:2949:b0:1b3:1bcd:e7f3 with SMTP id x9-20020a17090a294900b001b31bcde7f3mr3793574pjf.125.1644924740969;
        Tue, 15 Feb 2022 03:32:20 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:32:20 -0800 (PST)
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
Subject: [PATCH net-next 14/19] net: skb: introduce the function kfree_skb_list_reason()
Date:   Tue, 15 Feb 2022 19:28:07 +0800
Message-Id: <20220215112812.2093852-15-imagedong@tencent.com>
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
index 9e19806d9818..dc3794b60b1c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1196,10 +1196,16 @@ static inline void kfree_skb(struct sk_buff *skb)
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
index 9d0388bed0c1..f0c6207f5de7 100644
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
2.34.1

