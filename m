Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A355443D9
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 08:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239001AbiFIGei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 02:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238970AbiFIGe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 02:34:27 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E955C369D3
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 23:34:25 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id e66so20959798pgc.8
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 23:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l94o/1eJJb3mEn0w56d5zkZI41cFtm3Fy1loLlVyw3k=;
        b=fDJiMy6WyYd1usVQpjedtmNc/cAmLBkC85c0aOZLKpK6Z3y3oBvESQ462UUB4iwSMx
         ucD7TV9oIcPb93CbeYIazzTWPfcYRN8G4hGYpT3uEReY2JJibCvhz2LeN8dAobzkh1Kd
         cbUmYrjXQFkAFP9d4q1TOTvQpLJ24ebOuCg+F/3qI7WIbGmdHMN1bMMHlcxheJv1nxu8
         GdD4/xSqfPPq9MiJFcCwGJklA/fr2T2tLqMC7t6UOOjyXfwpt1evxtC6a3AkT6kh9mid
         CVWNB3xM67i6h2RX9JWMIRk9iTCfnp/0L7/hfIXmgC2FMLYC+jwfb6zfgODQk50UKosC
         UM6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l94o/1eJJb3mEn0w56d5zkZI41cFtm3Fy1loLlVyw3k=;
        b=UH1d+DQsuByF8aedumYk+G4C7aS+R95zoxhpF4vnYdW6evhT50V9ZmHORxCppuSZSC
         lYlw7EGG3EEQ+C9cDutXFVQBpA2SIT0OATaIC74s6+iRHp1JqZon/Fsi6bdcJxcrN7Om
         9xsTfbWmG+PdKiCLxHGlYmw5HJuHY0F33zIzqI4DJQiREUgSEQeMMzipM8OEQddLfGBm
         lzNgNAvGwwAA5NWDc7artL7rt/2MY5nZ6vBsukSovbAXaSHg5MM6OXGKrC1PZ5aCnmlR
         JwaH9N2PZahSO1QscDCIo/xy0mnfTYfUtEMQcDNqovktoYM0cp/6j+WMMA4CxmOmaU2W
         Vokg==
X-Gm-Message-State: AOAM531EyGhPi8JKBlKbhF/ssjsrZnAKCg67L19EYrRgEepBp9J6ftkd
        CDPDhCjVV3WCq/DlXPfPOVmrU2hR14U=
X-Google-Smtp-Source: ABdhPJw3Cp83RP4AOWRMrrD4CfvWfqwy59DpORe4O1n+c2PKK7dLIcYh24NN41x3N1iVPqIJ/sNPXg==
X-Received: by 2002:a65:6459:0:b0:3fc:700a:ce88 with SMTP id s25-20020a656459000000b003fc700ace88mr33882596pgv.143.1654756465338;
        Wed, 08 Jun 2022 23:34:25 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id 199-20020a6215d0000000b0051b9c0af43dsm16340050pfv.155.2022.06.08.23.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 23:34:25 -0700 (PDT)
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
Subject: [PATCH net-next 5/7] net: fix sk_wmem_schedule() and sk_rmem_schedule() errors
Date:   Wed,  8 Jun 2022 23:34:10 -0700
Message-Id: <20220609063412.2205738-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220609063412.2205738-1-eric.dumazet@gmail.com>
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
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

If sk->sk_forward_alloc is 150000, and we need to schedule 150001 bytes,
we want to allocate 1 byte more (rounded up to one page),
instead of 150001 :/

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 59040fee74e7de8d63fbf719f46e172906c134bb..cf288f7e9019106dfb466be707d34dacf33b339c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1575,19 +1575,23 @@ static inline bool sk_has_account(struct sock *sk)
 
 static inline bool sk_wmem_schedule(struct sock *sk, int size)
 {
+	int delta;
+
 	if (!sk_has_account(sk))
 		return true;
-	return size <= sk->sk_forward_alloc ||
-		__sk_mem_schedule(sk, size, SK_MEM_SEND);
+	delta = size - sk->sk_forward_alloc;
+	return delta <= 0 || __sk_mem_schedule(sk, delta, SK_MEM_SEND);
 }
 
 static inline bool
 sk_rmem_schedule(struct sock *sk, struct sk_buff *skb, int size)
 {
+	int delta;
+
 	if (!sk_has_account(sk))
 		return true;
-	return size <= sk->sk_forward_alloc ||
-		__sk_mem_schedule(sk, size, SK_MEM_RECV) ||
+	delta = size - sk->sk_forward_alloc;
+	return delta <= 0 || __sk_mem_schedule(sk, delta, SK_MEM_RECV) ||
 		skb_pfmemalloc(skb);
 }
 
-- 
2.36.1.255.ge46751e96f-goog

