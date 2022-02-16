Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387D84B7F02
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245105AbiBPDzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:55:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245094AbiBPDzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:55:15 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E93F5402;
        Tue, 15 Feb 2022 19:55:04 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id i10so1027997plr.2;
        Tue, 15 Feb 2022 19:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lgdlyhNIvtAukMCB9p+w3nagDPuFMbvyfD2Rz3/nNMQ=;
        b=c/b/Tg49janS6+LjvyXrPHSdiQ2Y+PV43YxUzO7BnsDE9FYiv13Akw0iz51yqyK/d5
         kk9wD+fQ6bViJRrPTgwUv17xKORkk5LwogsQQA+YnkiT6TEJ1phBXHuRRcujcMxxW1lW
         6QE4a9qRRTBgyY56IOUlPGirZC8LbnfxaaqPvs64bENW+YBlxxtIQjZnyFPamA2xnINh
         K1qY/43+68Qz0yHDD9w24FonBCTBztm3oD4ENDaac7E0W/vvqWbZUt/dxKvWMTm2g5gO
         FGN1mWxtbR1CkmJRebrNcad2y3m7EY5bG0liaMd7uzUCOBd+Sd+yR8IWb/qwpZvKjWeF
         4Ylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lgdlyhNIvtAukMCB9p+w3nagDPuFMbvyfD2Rz3/nNMQ=;
        b=u0ssqlaBuIOSH6wT+3a5p0WYy1hpEzgju0LoL10kclUJkGllQ3e90i28EcJbuFmYkO
         xkQllxbSxUD4ozwMCP514yNVFttuqfLCgud6TQtrqf3gxqhvXoh/FdtiH+QdwPhz4RxS
         U/COaZ+hK7mil8MpisNSseLB6QlIJJKSh9G6fE5AxyzITl+pqW3obICsq72I8aQeQnsC
         hzNKx9FM6X0IiZWdEzNWfEsYtCLQ9frrQ7MtMNmQPg+XRu5C/+D95x9QkWKI3HNn9J7/
         Nruxq+6s6aUb8SjlAZNC6uen5pvvV1QMLs1GrszRrfyBjlWSnz0cozD4D2z2/UU9rD8I
         dBJA==
X-Gm-Message-State: AOAM532byjw4DOb3aYB6pVutOB4QG+jNBnYoPsDzpwEZy2Cg81BLl6xD
        QBmecpSfZK40ALI+QNDgnZw=
X-Google-Smtp-Source: ABdhPJwn2tin0nBtol+lptHDksIAW/XkMFGoH0u3MT3KMivqPD6KKyrQChIKyshzgxcDHQTNsGCetw==
X-Received: by 2002:a17:90b:104:b0:1b8:d212:9b8e with SMTP id p4-20020a17090b010400b001b8d2129b8emr8051706pjz.11.1644983703793;
        Tue, 15 Feb 2022 19:55:03 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.gmail.com with ESMTPSA id nn16sm19099668pjb.2.2022.02.15.19.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 19:55:03 -0800 (PST)
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
Subject: [PATCH net-next 1/9] net: tcp: introduce tcp_drop_reason()
Date:   Wed, 16 Feb 2022 11:54:18 +0800
Message-Id: <20220216035426.2233808-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220216035426.2233808-1-imagedong@tencent.com>
References: <20220216035426.2233808-1-imagedong@tencent.com>
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

For TCP protocol, tcp_drop() is used to free the skb when it needs
to be dropped. To make use of kfree_skb_reason() and pass the drop
reason to it, introduce the function tcp_drop_reason(). Meanwhile,
make tcp_drop() an inline call to tcp_drop_reason().

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv4/tcp_input.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index af94a6d22a9d..0a2740add404 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4684,10 +4684,16 @@ static bool tcp_ooo_try_coalesce(struct sock *sk,
 	return res;
 }
 
-static void tcp_drop(struct sock *sk, struct sk_buff *skb)
+static void tcp_drop_reason(struct sock *sk, struct sk_buff *skb,
+			    enum skb_drop_reason reason)
 {
 	sk_drops_add(sk, skb);
-	__kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
+}
+
+static inline void tcp_drop(struct sock *sk, struct sk_buff *skb)
+{
+	tcp_drop_reason(sk, skb, SKB_DROP_REASON_NOT_SPECIFIED);
 }
 
 /* This one checks to see if we can put data from the
-- 
2.34.1

