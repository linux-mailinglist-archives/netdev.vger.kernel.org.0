Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD7C524CEB
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353814AbiELMeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353812AbiELMeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:34:02 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C856472D;
        Thu, 12 May 2022 05:34:01 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id iq10so5068605pjb.0;
        Thu, 12 May 2022 05:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0V/g4vf7d52LTUG/UsmwgEG5VgHlj0HZXVekJyZLmLw=;
        b=G/JVuwSEPN76TvxMfqy//u63ILusYW4sCTGj5y3HNBk98lCEIJqMpXEOmk6rQJ30nj
         YfElfvpOg/oJXQb6Fd8PqMKj9iJ5o+kXrk/NgCi1ZFybwDX37pJMyXV5MiT7bHxnlT25
         IJmgExMmwGxkEnetQCrSuuQVCLGtJIhNQHKxTSIrUr3C68BjSneW5MI+xmddALoBocqL
         tIEeg7BrUGPxr4J3Q9TuPGO1l6t5zjg/l5XF89L6kf8/497QHu2PbVk6YftG7hBjgpp6
         /LcDgWuukBWtHf6lB1JWmX1hhPEr4hMF3PeNjuGBASicbojf2GJ6j3ukd8cUQ1nLMu5m
         A4IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0V/g4vf7d52LTUG/UsmwgEG5VgHlj0HZXVekJyZLmLw=;
        b=cXYJZK7jDEXmKDIKsAEYoUWg7XOTUSo6IOGGvcYiDXtXcKBiJ+8T8ZZmwbAX4T3HcA
         0tOD27o0fv6f9rYp+2bXTc2x6P+NaRLA1gnXg/hGxWgJi07pxvtcQtUo32SPwrM6YTN/
         gG4XLzBIUvK6WIy6u/fWz92WKE7OK0ZF3uTt7mLXXo7Gtkna3WjGUtLGwyHU5Ooay+yB
         KnTqEX9bUyceqdxHX9jN7yHcQ41z0j5Yj8+B9cup77fY1yVvwXjs7K/J2btxG/8uSEBM
         SdINJBYwMu6kj8/FoSANpc3wRmI40UydrvIlzE5+uHySYWLfEnpyswB7zEI6SUOScORa
         31Pg==
X-Gm-Message-State: AOAM530kEP4VUhiTTQkKVGNOq68OLzFUJcBhKfXuzyZLnz7d0RzOX5ez
        GW5H+np4HclIgxOXO2GF9VQ=
X-Google-Smtp-Source: ABdhPJwKDLSY6KwMpO0cPuAPisRwuDA6Z/r2td7rBvg2PXRrUAZP6WQ2SwOzd9BWZu2NhCBfVvERwQ==
X-Received: by 2002:a17:90b:1c04:b0:1dc:4dfd:5a43 with SMTP id oc4-20020a17090b1c0400b001dc4dfd5a43mr10899801pjb.160.1652358841119;
        Thu, 12 May 2022 05:34:01 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id y24-20020a63de58000000b003c14af50643sm1738130pgi.91.2022.05.12.05.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 05:34:00 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        imagedong@tencent.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, asml.silence@gmail.com, willemb@google.com,
        vasily.averin@linux.dev, ilias.apalodimas@linaro.org,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/4] net: skb: check the boundrary of drop reason in kfree_skb_reason()
Date:   Thu, 12 May 2022 20:33:11 +0800
Message-Id: <20220512123313.218063-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512123313.218063-1-imagedong@tencent.com>
References: <20220512123313.218063-1-imagedong@tencent.com>
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

Sometimes, we may forget to reset skb drop reason to NOT_SPECIFIED after
we make it the return value of the functions with return type of enum
skb_drop_reason, such as tcp_inbound_md5_hash. Therefore, its value can
be SKB_NOT_DROPPED_YET(0), which is invalid for kfree_skb_reason().

So we check the range of drop reason in kfree_skb_reason() and reset it
to NOT_SPECIFIED and print a warning with DEBUG_NET_WARN_ON_ONCE() if it
is invalid.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/core/skbuff.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 15f7b6f99a8f..e49e43d4c34d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -771,6 +771,11 @@ void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 	if (!skb_unref(skb))
 		return;
 
+	if (unlikely(reason <= 0 || reason >= SKB_DROP_REASON_MAX)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
+		reason = SKB_DROP_REASON_NOT_SPECIFIED;
+	}
+
 	trace_kfree_skb(skb, __builtin_return_address(0), reason);
 	__kfree_skb(skb);
 }
-- 
2.36.1

