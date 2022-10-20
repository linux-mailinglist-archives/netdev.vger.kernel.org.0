Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B346057B9
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 08:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiJTG4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 02:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiJTG4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 02:56:19 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E941162F1;
        Wed, 19 Oct 2022 23:56:18 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id h185so18393166pgc.10;
        Wed, 19 Oct 2022 23:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1pwnbAK9KKNITLHun9Ms0l02kwgq26mhZcJVsIfPh/U=;
        b=WGlJMa4/j+mKh6MeeDQKT6eGvFSecJ8hTc1C0OxySPaTxTAG2nSImpnU5nl/JEslN/
         gUyxiBOJN3it75fNSSrk220kO8GhpjNCUWOpp5PyiBkeUnWdZeYdr26r5I2sRSna34Zv
         9tKk9Iy3O+5BK7Y2tFx9m4bv/V50PftcB7TtOR6g7V//9FC4fuxD/48DO1l8gCVHLdcL
         YkrrudZgPDYC0Cc6oYG29Fi3KZ3Ka657bjRI9iKYOBuY8WoFq8hi49hP+D5RAGF0TKB6
         EW9mrvHbz37rFTthh4aKS3fV4TzLntv9j1nXWQpliixSsZGORy+EeOzILkXPge+htKwD
         6LBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1pwnbAK9KKNITLHun9Ms0l02kwgq26mhZcJVsIfPh/U=;
        b=Tj7iIgXHXVdOfuOg+4Unw00Y+K47/i9O0kh4D2ouTJOnyKP+kWXXuchO7le348vfGb
         sG/O/MQLAdsq2OX21PR8bYRgPJCM2TaOjgZsJ0VB7SUKN39W+Y7VsYkvO3GIx8b3p+BA
         zV74GhdNebpQ5cO9Lv42kMB0YFecdcgg2J1BsiEDNQ2Qa5jbv2hf8NN21Y5jgYYjA1Fb
         WNFDf9nhfJTRQxlHLpfMkYOQtw4rR9xTRoOMhIR5OTtG5MlAQQM+d+n4214tuSS31AKb
         ilMSCgr6A3EZC6YjXMrYVNXl7tl+8pjitsMnrcPRyz3/B/DyngEK/S13xKHIVyKw8gRY
         XIsA==
X-Gm-Message-State: ACrzQf0HBs++7AJpb9auk37nBbjFsNgRiRGPgkGlz/FlRyn1FQWPXKuS
        VBlsuhA86u6rcvZEtP6FO2A=
X-Google-Smtp-Source: AMsMyM6Yrdv3mY5mW4r4IWOp5pN+YW4h0qoyaVefW6f+cosZFCTExrzS7N5qjQBJvUQp+AHMOFMa8A==
X-Received: by 2002:aa7:9212:0:b0:562:b5f6:f7d7 with SMTP id 18-20020aa79212000000b00562b5f6f7d7mr12898288pfo.70.1666248977615;
        Wed, 19 Oct 2022 23:56:17 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id a9-20020a1709027e4900b0017f8094a52asm11972756pln.29.2022.10.19.23.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 23:56:16 -0700 (PDT)
From:   xu.xin.sc@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     edumazet@google.com, pabeni@redhat.com, dsahern@kernel.org,
        xu xin <xu.xin16@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Zhang Yunkai <zhang.yunkai@zte.com.cn>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCHv2 linux-next] net: remove useless parameter of __sock_cmsg_send
Date:   Thu, 20 Oct 2022 06:54:41 +0000
Message-Id: <20221020065440.397406-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xu xin <xu.xin16@zte.com.cn>

The parameter 'msg' has never been used by __sock_cmsg_send, so we can remove it
safely.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Acked-by: Kuniyuki Iwashima <kuniyu@amazon.com>

---
v1->v2:
fix the title and commit log.

---
 include/net/sock.h     | 2 +-
 net/core/sock.c        | 4 ++--
 net/ipv4/ip_sockglue.c | 2 +-
 net/ipv6/datagram.c    | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 9e464f6409a7..b1dacc4d68c9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1901,7 +1901,7 @@ static inline void sockcm_init(struct sockcm_cookie *sockc,
 	*sockc = (struct sockcm_cookie) { .tsflags = sk->sk_tsflags };
 }
 
-int __sock_cmsg_send(struct sock *sk, struct msghdr *msg, struct cmsghdr *cmsg,
+int __sock_cmsg_send(struct sock *sk, struct cmsghdr *cmsg,
 		     struct sockcm_cookie *sockc);
 int sock_cmsg_send(struct sock *sk, struct msghdr *msg,
 		   struct sockcm_cookie *sockc);
diff --git a/net/core/sock.c b/net/core/sock.c
index a3ba0358c77c..944a9ea75f65 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2730,7 +2730,7 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 }
 EXPORT_SYMBOL(sock_alloc_send_pskb);
 
-int __sock_cmsg_send(struct sock *sk, struct msghdr *msg, struct cmsghdr *cmsg,
+int __sock_cmsg_send(struct sock *sk, struct cmsghdr *cmsg,
 		     struct sockcm_cookie *sockc)
 {
 	u32 tsflags;
@@ -2784,7 +2784,7 @@ int sock_cmsg_send(struct sock *sk, struct msghdr *msg,
 			return -EINVAL;
 		if (cmsg->cmsg_level != SOL_SOCKET)
 			continue;
-		ret = __sock_cmsg_send(sk, msg, cmsg, sockc);
+		ret = __sock_cmsg_send(sk, cmsg, sockc);
 		if (ret)
 			return ret;
 	}
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 6e19cad154f5..5f16807d3235 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -267,7 +267,7 @@ int ip_cmsg_send(struct sock *sk, struct msghdr *msg, struct ipcm_cookie *ipc,
 		}
 #endif
 		if (cmsg->cmsg_level == SOL_SOCKET) {
-			err = __sock_cmsg_send(sk, msg, cmsg, &ipc->sockc);
+			err = __sock_cmsg_send(sk, cmsg, &ipc->sockc);
 			if (err)
 				return err;
 			continue;
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 5ecb56522f9d..df7e032ce87d 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -771,7 +771,7 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 		}
 
 		if (cmsg->cmsg_level == SOL_SOCKET) {
-			err = __sock_cmsg_send(sk, msg, cmsg, &ipc6->sockc);
+			err = __sock_cmsg_send(sk, cmsg, &ipc6->sockc);
 			if (err)
 				return err;
 			continue;
-- 
2.25.1

