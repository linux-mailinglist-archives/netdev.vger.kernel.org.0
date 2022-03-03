Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58604CC453
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbiCCRtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:49:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235479AbiCCRtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:49:43 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7B6692B3;
        Thu,  3 Mar 2022 09:48:55 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id ge19-20020a17090b0e1300b001bcca16e2e7so8312953pjb.3;
        Thu, 03 Mar 2022 09:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YLrSI94Uiwy3g6pV3msifjgFEANBJZPbxRHw7SSLhdA=;
        b=hQlBrnsB4zTkyzKjNDTGpsGuorfYjPy4uEgWUm4YjxbMyGa9bMPPI+J/hMqtw+Rgc0
         s3EOI9NVgzy3OIw3qwMAXFO6vc9YU1jpS25u05VmL/xPQ4WaHF6pWzkTvzK+mzU5v8cn
         EcNOrm5XNM7Yo2LpUvGrtawiw6/EPvNkGNYRj9UUzupS/6tebwPT7AqIAwA/Ty3Kuggw
         pf3JzResSzZUrdgPEUj53rnCaD/Ml63/Hh+oDam3No/Jt40HOrA2ycWFchlGZqp6Qx9n
         cn+JCfQQEUoOfnZ8PNMcQncdnulysWU5S5lIgCNXnlL8p0HgpFS32gN3+pEnDIRXV7Pr
         /hLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YLrSI94Uiwy3g6pV3msifjgFEANBJZPbxRHw7SSLhdA=;
        b=4ouTQKhgVxfEjKt5bTxd1rmhS734N+0vqkvJ8MnNVw03UhHkIXVYkiRciAsoK239BM
         S4/48uXjL2xRGjCdHwjR/GJpzE111S01tqYda1ScaZF4zbFkyz9FIueZFgt7VU8oalKD
         ieeTXe0cCdLpTjQspjVhLVAHUGdz6k6MfudrlpII7Fbz716GIVeZaZqxCjmausyPTGT6
         waF6ZbGU4P1B2I4yfMIoe7MQ2aEsan9RuQX6hB2KgSsx1wZ0SQnQbW6JR2KxXp2aKD45
         8x28BLic+OX2GsW23UES2L1Nndjy0mpflaH38L4gzP130j5fWveGjyGklGquU/1RbJ74
         3o/A==
X-Gm-Message-State: AOAM531ESp0JfeJW50sk1I3NhJxrnRZ5n5Iv0oiPJi35abzRS+JMznWM
        q2+D5KwnpQCaLumFytB2Xnw=
X-Google-Smtp-Source: ABdhPJwsG12VObYnwUeH0gp7hc4IbKOA/gSOfwxebw1OiTTj6/7iK2UweTExsKBSouovle2zNYKk4w==
X-Received: by 2002:a17:902:b709:b0:151:49e7:d4e1 with SMTP id d9-20020a170902b70900b0015149e7d4e1mr28460027pls.144.1646329735295;
        Thu, 03 Mar 2022 09:48:55 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f0f0f852a4sm3209395pfx.77.2022.03.03.09.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 09:48:54 -0800 (PST)
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
Subject: [PATCH net-next 5/7] net: dev: use kfree_skb_reason() for do_xdp_generic()
Date:   Fri,  4 Mar 2022 01:47:05 +0800
Message-Id: <20220303174707.40431-6-imagedong@tencent.com>
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

Replace kfree_skb() used in do_xdp_generic() with kfree_skb_reason().
The drop reason SKB_DROP_REASON_XDP is introduced for this case.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 1 +
 include/trace/events/skb.h | 1 +
 net/core/dev.c             | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index d2cf87ff84c2..23bbfcd6668b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -408,6 +408,7 @@ enum skb_drop_reason {
 					 * full (see netdev_max_backlog in
 					 * net.rst) or RPS flow limit
 					 */
+	SKB_DROP_REASON_XDP,		/* dropped by XDP in input path */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 29c360b5e114..c117430375c0 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -48,6 +48,7 @@
 	EM(SKB_DROP_REASON_QDISC_EGRESS, QDISC_EGRESS)		\
 	EM(SKB_DROP_REASON_QDISC_DROP, QDISC_DROP)		\
 	EM(SKB_DROP_REASON_CPU_BACKLOG, CPU_BACKLOG)		\
+	EM(SKB_DROP_REASON_XDP, XDP)				\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index 373fa7a33ffa..ae85e024c7b7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4797,7 +4797,7 @@ int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 	}
 	return XDP_PASS;
 out_redir:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_REASON_XDP);
 	return XDP_DROP;
 }
 EXPORT_SYMBOL_GPL(do_xdp_generic);
-- 
2.35.1

