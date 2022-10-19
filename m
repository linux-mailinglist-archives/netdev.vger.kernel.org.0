Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C1A604089
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 12:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbiJSKDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 06:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiJSKDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 06:03:20 -0400
Received: from mail-oa1-x41.google.com (mail-oa1-x41.google.com [IPv6:2001:4860:4864:20::41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C4F127433;
        Wed, 19 Oct 2022 02:41:39 -0700 (PDT)
Received: by mail-oa1-x41.google.com with SMTP id 586e51a60fabf-1321a1e94b3so19976430fac.1;
        Wed, 19 Oct 2022 02:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lSYuiPbkFUQeSRCBwAGkhrUEWgqROb3Ooc8NIPZekZ4=;
        b=TyUNqg/50MJ9OJRoSjAXEV1x6JiHz6zn+lFYaZLqwmF/AcaVuWGSlsqieXsUL/P5p7
         LKXoZbEftpjDwpg/rFJnLSw25IGNH1z0U/brbIkOwVGFo2yXGO4JVH/KhzaZHvBQNzx5
         NHV+DmejBxAaf9Ec1FEYOUEss/kT7COJgHsCqYIJEUHoCBLtg9VnVBWgchPy0JXy6oHK
         RWwBSMfV5s86FVzEG3zT9DjtfyG7alI+JjdnOz5db2r5+99L1T4jX74ugtMKlsj31IiQ
         9fJXZ69rXz5JbO5X+vFkWbpABnH8hNZRPNtO9ZVmoNBPFrbaMX/bhf9Cjz7LwbzzrlOD
         4QSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lSYuiPbkFUQeSRCBwAGkhrUEWgqROb3Ooc8NIPZekZ4=;
        b=tm3YhPlX0uPGVVc06qBB6nbnXmM13eM2piug+7M74KhD9lpFoR0geFZL0WCoFald25
         VsYVdUXbsrN/PyHbjqyLJj3JKLIRYWFrZTDB7J+od9x0vIYeFLq7gv1yWoR5jv6+tvWF
         UiX/wRT9dGNyrokkn7ICC4DzLYAqk0l6EJIIzpKWvBg/bCHI508mIJSZS/MTPpIDlsDl
         lkglnYbXqR3xfr8ATxVsSlel4xt5h4FBtSHtT7dX8nYSQP65Mx35aAO0oCb9PVOcvUHP
         qdDlL+64TSvnr89qzgO8FtjBWa4rk+SxeSuGRJQ7+cyiL6mglnCUk+oy05vBvz8Z0lBS
         6ntQ==
X-Gm-Message-State: ACrzQf3HZFZHwMzqADzK3OP4sz0lcnOloN4E9/CWfCD3yRriwEMBmUaD
        ehsNvqP+7p7dbhXbOgvDmJ7Wkupnbo4=
X-Google-Smtp-Source: AMsMyM6sNhUUbHepQ4pUeAreQF+GrD26ZlU/AHpZrRgWL41afoXIlbaY12mmWBCiT7yWzzxx5a0LOw==
X-Received: by 2002:a17:90b:3850:b0:20d:54f2:a780 with SMTP id nl16-20020a17090b385000b0020d54f2a780mr44237090pjb.115.1666171826686;
        Wed, 19 Oct 2022 02:30:26 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id t13-20020a1709027fcd00b0016d8d277c02sm10296420plb.25.2022.10.19.02.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 02:30:25 -0700 (PDT)
From:   xu.xin.sc@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     edumazet@google.com, pabeni@redhat.com, dsahern@kernel.org,
        martin.lau@kernel.org, ast@kernel.org, kuniyu@amazon.com,
        asml.silence@gmail.com, xu xin <xu.xin16@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Zhang Yunkai <zhang.yunkai@zte.com.cn>
Subject: [PATCH linux-next] net: remove useless parameter of __sock_cmsg_send The
Date:   Wed, 19 Oct 2022 09:30:14 +0000
Message-Id: <20221019093014.389738-1-xu.xin16@zte.com.cn>
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

parameter 'msg' has never been used by __sock_cmsg_send, so we can remove it
safely.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
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

