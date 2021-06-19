Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D083AD8AD
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 10:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbhFSInp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 04:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbhFSIno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 04:43:44 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCEAC061574;
        Sat, 19 Jun 2021 01:41:32 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id e33so9869310pgm.3;
        Sat, 19 Jun 2021 01:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/1Rwnm8wm01ORDHn/DlKmW7MPMS9lQBNMJF6mJ4+ZYk=;
        b=g2uvNK3YyO/jeMXHiponTM5coP5SWIglZNmGPAwBQnlTW1+BiRxy9u3hJ17k9yvfrW
         coCplppcF2EksIMS8UxfijUVj0EIOb1fl3QsvxGXb0ZTTcyWOUGlHvBP06TLaE3nIF1c
         iw9EKFL7nc4hKYZT9vV80QJXnYi+hXvEd7cyZVQ7ZVk1/sGMNd6sD3HGqqmjh0zoPc0D
         JRoh04DPSAJ8TQ8PqhlIlp1rcE99XjnGcejydeh7ZSHQ5fxwx0+wy1q5L82dMZALGk04
         GcGNhr5tL+mbC2AX9ewXJ5SzUMatWGeMx8pWMARL/Q1nAdIG27duGgbQPnh/jCn4KUKw
         OQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/1Rwnm8wm01ORDHn/DlKmW7MPMS9lQBNMJF6mJ4+ZYk=;
        b=HRTebYRlK7wQVyMBUTLe7Lab6qZerPyOWZyWetoLQSFTFY8RiCFX5ajfYfZNiAq7Cm
         6gqg1+EuxP2V1ZL/8xoYuzpOR2kjrgYxkA5l29HvkkIDM+063JMwk5GeIglLOISq27ln
         BZgMihm29YHuEK8eRspVyav5f+wlzbxH3xI5wPlXFbi+Ems6+YNg4AwVnRo9CYEnF7Q+
         ZCxS5VoK3Oub4xTsqYP63MlUWx4mUWTif8m98q9XhOmlWon73JsOlajy00QSl5jVbKnn
         zfo7CqYJZrvLZbQrKVGfTJQeKIeG3fjeLb2oZgEW+L+Szx6fSjxOjgO4y82Z7ImdZgzD
         /LXQ==
X-Gm-Message-State: AOAM530XLJi0Tn+94RfzzqJfw6+YkWTpsjBLYdvHbKLwHqnhVHOPhahS
        Qjkkr3VR1PfwlZR7543nnQwqm8TVDo29og==
X-Google-Smtp-Source: ABdhPJz7MgDW6VmIOO3XCs5EnP9Ruu1Y/ySxDJ6PBcJRXvEzRYKGy7+/QEDCUb50HEa3Nw6YyCPsGg==
X-Received: by 2002:a62:53c1:0:b029:2ef:25e8:d9e5 with SMTP id h184-20020a6253c10000b02902ef25e8d9e5mr9261979pfb.74.1624092092385;
        Sat, 19 Jun 2021 01:41:32 -0700 (PDT)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id s13sm11388885pgi.36.2021.06.19.01.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jun 2021 01:41:31 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     jmaloy@redhat.com
Cc:     ying.xue@windriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, lxin@redhat.com,
        hoang.h.le@dektech.com.au, Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH v5 net-next 2/2] net: tipc: replace align() with ALIGN in msg.c
Date:   Sat, 19 Jun 2021 16:41:06 +0800
Message-Id: <20210619084106.3657-3-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210619084106.3657-1-dong.menglong@zte.com.cn>
References: <20210619084106.3657-1-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

The function align() which is defined in msg.c is redundant, replace it
with ALIGN() and introduce a BUF_ALIGN().

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/msg.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 7053c22e393e..5c9fd4791c4b 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -41,6 +41,7 @@
 #include "name_table.h"
 #include "crypto.h"
 
+#define BUF_ALIGN(x) ALIGN(x, 4)
 #define MAX_FORWARD_SIZE 1024
 #ifdef CONFIG_TIPC_CRYPTO
 #define BUF_HEADROOM ALIGN(((LL_MAX_HEADER + 48) + EHDR_MAX_SIZE), 16)
@@ -53,11 +54,6 @@
 const int one_page_mtu = PAGE_SIZE - SKB_DATA_ALIGN(BUF_OVERHEAD) -
 			 SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
-static unsigned int align(unsigned int i)
-{
-	return (i + 3) & ~3u;
-}
-
 /**
  * tipc_buf_acquire - creates a TIPC message buffer
  * @size: message size (including TIPC header)
@@ -489,7 +485,7 @@ static bool tipc_msg_bundle(struct sk_buff *bskb, struct tipc_msg *msg,
 
 	msz = msg_size(msg);
 	bsz = msg_size(bmsg);
-	offset = align(bsz);
+	offset = BUF_ALIGN(bsz);
 	pad = offset - bsz;
 
 	if (unlikely(skb_tailroom(bskb) < (pad + msz)))
@@ -546,7 +542,7 @@ bool tipc_msg_try_bundle(struct sk_buff *tskb, struct sk_buff **skb, u32 mss,
 
 	/* Make a new bundle of the two messages if possible */
 	tsz = msg_size(buf_msg(tskb));
-	if (unlikely(mss < align(INT_H_SIZE + tsz) + msg_size(msg)))
+	if (unlikely(mss < BUF_ALIGN(INT_H_SIZE + tsz) + msg_size(msg)))
 		return true;
 	if (unlikely(pskb_expand_head(tskb, INT_H_SIZE, mss - tsz - INT_H_SIZE,
 				      GFP_ATOMIC)))
@@ -605,7 +601,7 @@ bool tipc_msg_extract(struct sk_buff *skb, struct sk_buff **iskb, int *pos)
 	if (unlikely(!tipc_msg_validate(iskb)))
 		goto none;
 
-	*pos += align(imsz);
+	*pos += BUF_ALIGN(imsz);
 	return true;
 none:
 	kfree_skb(skb);
-- 
2.32.0

