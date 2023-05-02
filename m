Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642A56F47B9
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbjEBPwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234634AbjEBPwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:52:21 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDFA191;
        Tue,  2 May 2023 08:52:15 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-51fdc1a1270so2662319a12.1;
        Tue, 02 May 2023 08:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683042735; x=1685634735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/KzRg9aHA0s5k4RK9UiOKN5luPpSfH6F5b1d4OqlWWg=;
        b=cK6emukSMpbqVj4pr3dgnqqMTnOFPF8nHydBtvaJsJ6F0OS75QeYVPZrYVDNqNMXje
         kz5cdzZ1vQobUTOylEmsl0V0bMx/bsiikJ01LjwUj6pQ7UUKcVDqoptgcHvKnhczBfb9
         DXtZY/2st+mRaWV4OpH9caq2Rm6h15H6eAL2bRPkq21XcahWO6Nzqd5vu56kMPtaHGqu
         /WjPXu1qZ1VLYXJzuwptnMV3e0yrsxl6zWEqeZHF0k5Gnb5j4oZGyXD7sHBpV/axu8Ck
         yTKEwZxYTC1d4DCoa2yUC9/rJan6Demlz7ns+jsthQlp+2PvuqJ/rl8T8DycnIzZz6W7
         UL0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683042735; x=1685634735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/KzRg9aHA0s5k4RK9UiOKN5luPpSfH6F5b1d4OqlWWg=;
        b=B0NpU13yJv6v91AEHz2lfChd1ojxDfIKdo72jQG1U7IYqTzqCjP0Mruempma3EWfRf
         7t5QPHpxQw+uzdBzEEJNcbWvPnD+ipPSW4+1iNzvB7zzdkMh2h/uPp9vDhegH6K2P7he
         wLmz+n0ok5jT4Sly2hb1/k2moWxoA/iIdF+WAnh/Fh/1R/gvei30ziRLjg+FMT4lG2Jp
         SkJYWFFxg4MRcrYOydfikmV750d4LHm3Tbqi5mExzQ++3GFBLsyECrzKTIbMafphObn7
         HcrIU1QFCSlZ/Ui9qigPFDHungtkIIiHqvj/oes9nn1UQZI65o4+oVnmKO6CbfUov29E
         n9Nw==
X-Gm-Message-State: AC+VfDwl3b3Id1lQ94XNOnvTgTPz3/BPmc5R4vo0MkQSI3vBq+fQR+DV
        ruVkaj6YBenUJGhyZnE9f+M=
X-Google-Smtp-Source: ACHHUZ7G86pI1WA6/ZT+rGPHRKDQueuIvaMxLe2nyZBQDuciqIXqi19XYZOPT9iZAXdb3QHL1H2NHQ==
X-Received: by 2002:a17:902:d4c1:b0:1ab:14da:981 with SMTP id o1-20020a170902d4c100b001ab14da0981mr1045162plg.35.1683042734905;
        Tue, 02 May 2023 08:52:14 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:62ab:a7fd:a4e3:bd70])
        by smtp.gmail.com with ESMTPSA id o3-20020a170902778300b001a1a07d04e6sm19917212pll.77.2023.05.02.08.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 08:52:14 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v7 07/13] bpf: sockmap, wake up polling after data copy
Date:   Tue,  2 May 2023 08:51:53 -0700
Message-Id: <20230502155159.305437-8-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230502155159.305437-1-john.fastabend@gmail.com>
References: <20230502155159.305437-1-john.fastabend@gmail.com>
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

When TCP stack has data ready to read sk_data_ready() is called. Sockmap
overwrites this with its own handler to call into BPF verdict program.
But, the original TCP socket had sock_def_readable that would additionally
wake up any user space waiters with sk_wake_async().

Sockmap saved the callback when the socket was created so call the saved
data ready callback and then we can wake up any epoll() logic waiting
on the read.

Note we call on 'copied >= 0' to account for returning 0 when a FIN is
received because we need to wake up user for this as well so they
can do the recvmsg() -> 0 and detect the shutdown.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index bc5ca973400c..3c0663f5cc3e 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1198,12 +1198,21 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 static void sk_psock_verdict_data_ready(struct sock *sk)
 {
 	struct socket *sock = sk->sk_socket;
+	int copied;
 
 	trace_sk_data_ready(sk);
 
 	if (unlikely(!sock || !sock->ops || !sock->ops->read_skb))
 		return;
-	sock->ops->read_skb(sk, sk_psock_verdict_recv);
+	copied = sock->ops->read_skb(sk, sk_psock_verdict_recv);
+	if (copied >= 0) {
+		struct sk_psock *psock;
+
+		rcu_read_lock();
+		psock = sk_psock(sk);
+		psock->saved_data_ready(sk);
+		rcu_read_unlock();
+	}
 }
 
 void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock)
-- 
2.33.0

