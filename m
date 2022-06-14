Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB2A54B62F
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 18:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344182AbiFNQao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 12:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344163AbiFNQal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:30:41 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C82844752
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:30:30 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o33-20020a17090a0a2400b001ea806e48c6so9552624pjo.1
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PX4xpZVSDZWWYzf0Mgpk64vZeG3iQ4tbiusifSgBIMg=;
        b=PDl5/BL6L01bwaLnV4AllRkkdPjStJ9OqT1xjjinfwKPIP6eneHg9rhG3s2ZOCV87f
         5mst/Y1F0zJQaNwDWs7plYwV5KDlUOv88cm4k7hT5xLDIT1B8qg+GctTSBIgO8zfp/DF
         xErqCudJeCdu5waZnUDLpHlMZ0+LVk2K84ehK784NHXeMqreU1lSssXX9QbdSrsLbd3Q
         aiDa9IeXgZSkv3w+yGLbgzfU1CT5rLoP5WThx1XUdLqQ+d+uUPUfdecj4AkpBuf8/6+/
         7HuMH1FJuosVKV7Ns+HCMw7kDxXR9LSDlnyly/0KXLLzzCRlwlNWTx+eu+YUXKpjgnYx
         kNxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PX4xpZVSDZWWYzf0Mgpk64vZeG3iQ4tbiusifSgBIMg=;
        b=EehHdp4iVo9gA2jn0B3xNCrMORuRb4Z9PVOX1JV9t8Pl+Q7/6zCZ896cPUmJesOMPr
         g85sSCDrSV7QE3sc1Dye1o1iBwS8njQe1puKTdjjA7PfE4hwJk7297DgTOSXj0OtuCFM
         r+rQOnAL92wjBo5lg1u/tweuQLNAcZLDx2ylJrIS4KT0xAH64D+iWdA3diQA39YiQvEg
         fWJYg1pIsq2KIhv4S3zTRSYlf6yoHT2E5WeZZn4Joir8sgr0fvk8N/eDLVOQoIJ58MJ/
         P37TU2oiZ5GF019fOrjmMUJNimdokLvBLV5vHck5m4V5e6RdZkraJFlLh164DpCDLkGh
         pytw==
X-Gm-Message-State: AJIora/5QKoUoVfzkdL7flH2478rhf9o9caCBlYbp77xrM3VJpwC4w7j
        MAp5rips1eO3nbffdmjSHp0=
X-Google-Smtp-Source: AGRyM1vM/U2ZJUy1ykQ8+9V/gGlXNQkxxey+W3AFHnowrqTyYEzQ/+5yL2Pm0x3uPHjni7Xld67OKA==
X-Received: by 2002:a17:90a:738d:b0:1ea:c598:20b3 with SMTP id j13-20020a17090a738d00b001eac59820b3mr4391979pjg.88.1655224229493;
        Tue, 14 Jun 2022 09:30:29 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2dbb:8c54:2434:5ada])
        by smtp.gmail.com with ESMTPSA id p1-20020a170903248100b0016796cdd802sm7506484plw.19.2022.06.14.09.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 09:30:29 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/2] tcp: fix over estimation in sk_forced_mem_schedule()
Date:   Tue, 14 Jun 2022 09:30:23 -0700
Message-Id: <20220614163024.1061106-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220614163024.1061106-1-eric.dumazet@gmail.com>
References: <20220614163024.1061106-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

sk_forced_mem_schedule() has a bug similar to ones fixed
in commit 7c80b038d23e ("net: fix sk_wmem_schedule() and
sk_rmem_schedule() errors")

While this bug has little chance to trigger in old kernels,
we need to fix it before the following patch.

Fixes: d83769a580f1 ("tcp: fix possible deadlock in tcp_send_fin()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_output.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 8ab98e1aca6797a51eaaf8886680d2001a616948..18c913a2347a984ae8cf2793bb8991e59e5e94ab 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3362,11 +3362,12 @@ void tcp_xmit_retransmit_queue(struct sock *sk)
  */
 void sk_forced_mem_schedule(struct sock *sk, int size)
 {
-	int amt;
+	int delta, amt;
 
-	if (size <= sk->sk_forward_alloc)
+	delta = size - sk->sk_forward_alloc;
+	if (delta <= 0)
 		return;
-	amt = sk_mem_pages(size);
+	amt = sk_mem_pages(delta);
 	sk->sk_forward_alloc += amt << PAGE_SHIFT;
 	sk_memory_allocated_add(sk, amt);
 
-- 
2.36.1.476.g0c4daa206d-goog

