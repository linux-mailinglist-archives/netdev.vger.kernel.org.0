Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35B454CCBB
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 17:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352144AbiFOP1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 11:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352075AbiFOP1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 11:27:00 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81B141627;
        Wed, 15 Jun 2022 08:26:53 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 25so16659798edw.8;
        Wed, 15 Jun 2022 08:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aD3KXmUM+TaBN7hTJKm0rCjbZHzjs5kWkG6RSEVpXOI=;
        b=QvQ5VGcFr3+d2na6CeGcuynBeqUgn5YRGegdzwJhioXwEFEzc+XR9PMm5p2dqnqEc7
         cbChMICejcuvR/cTVgcIEKdNk3MnPwurGtd8G35rcBqgrGhW8hvxOPJVtjuYSDVwjWI9
         PDhMpk83kLOecZk+Y6JGAo6t7mY2cUKMtJ1h+6BghNLyPe3uEXtswic3XIqt3LDs2kNX
         U272LCFRIFsKKpo+dw8PGEfK6+xtAKfBYCe8cqylBeqT/X0qGRxZGATSIEk0MbkEXoMP
         Zw0yZTJpmLpyNbPTfivAW64sdto/rSYETIKc1y7VbUyMbRCFrAJAU60mV+gmH6vjNdNJ
         adrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aD3KXmUM+TaBN7hTJKm0rCjbZHzjs5kWkG6RSEVpXOI=;
        b=Nc0cN9qcFZyfG0njTNZTYgRlCwg4q3gNyYK8NL1vmsbDL1C7fVFsSjlr83LPw4OQsm
         JlyPoQWgHCgRH4zFpPZj5gDBRTn1EQarZlYSIsXeykDW/bX0ux66w8UC/FoHTo5MBxpI
         2tFqd4ry1kjNvzqL7Q/2bvRa77rAAP1zQ/79R1bn3GERqVn340bmaxDdK68JoBdLEZ4Y
         ZZJLqkKEfObfk8pWK7rMKl3tEW74oI0qb/55Uc6GGxeoV7+931I+oJOmHO0UMr+aY2i5
         k8wnoDLBEF0XDd4rNZYySkVmMRwFbaGrgQlJjq8d1pOcCTIQ65lH0/En+3M8CQpgua/u
         yhyQ==
X-Gm-Message-State: AJIora+Xm7zLb68OyEqFE+K/fYxTAni32urT4FIicIdR0FCsXGPDytrs
        eU3pbwvs7pPOtCREtwLaE02sWyC1gGXsyA==
X-Google-Smtp-Source: AGRyM1sEZmu+MTQbIwUzGr+8J42hYq6zjx150kpTt+7z4b6FMHkhpZ4n4pFUNtXVbDWR2eg/fg0Buw==
X-Received: by 2002:a05:6402:2708:b0:431:45d1:3aa0 with SMTP id y8-20020a056402270800b0043145d13aa0mr332419edd.408.1655306812318;
        Wed, 15 Jun 2022 08:26:52 -0700 (PDT)
Received: from debianHome.localdomain (dynamic-077-003-151-196.77.3.pool.telefonica.de. [77.3.151.196])
        by smtp.gmail.com with ESMTPSA id v14-20020aa7d9ce000000b0042bc97322desm9501224eds.43.2022.06.15.08.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 08:26:51 -0700 (PDT)
From:   =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
To:     selinux@vger.kernel.org
Cc:     Serge Hallyn <serge@hallyn.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wei Wang <weiwan@google.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Menglong Dong <imagedong@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Palethorpe <rpalethorpe@suse.com>,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wpan@vger.kernel.org
Subject: [PATCH v3 8/8] net: use new capable_any functionality
Date:   Wed, 15 Jun 2022 17:26:22 +0200
Message-Id: <20220615152623.311223-7-cgzones@googlemail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220615152623.311223-1-cgzones@googlemail.com>
References: <20220502160030.131168-8-cgzones@googlemail.com>
 <20220615152623.311223-1-cgzones@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Use the new added capable_any function in appropriate cases, where a
task is required to have any of two capabilities.

Reorder CAP_SYS_ADMIN last.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
v3:
  - rename to capable_any()
  - make use of ns_capable_any
---
 net/caif/caif_socket.c   |  2 +-
 net/core/sock.c          | 12 ++++--------
 net/ieee802154/socket.c  |  6 ++----
 net/ipv4/ip_sockglue.c   |  3 +--
 net/ipv6/ipv6_sockglue.c |  3 +--
 net/unix/scm.c           |  2 +-
 6 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 251e666ba9a2..2d3df7658e04 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -1036,7 +1036,7 @@ static int caif_create(struct net *net, struct socket *sock, int protocol,
 		.usersize = sizeof_field(struct caifsock, conn_req.param)
 	};
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_NET_ADMIN))
+	if (!capable_any(CAP_NET_ADMIN, CAP_SYS_ADMIN))
 		return -EPERM;
 	/*
 	 * The sock->type specifies the socket type to use.
diff --git a/net/core/sock.c b/net/core/sock.c
index 2ff40dd0a7a6..6b04301982d8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1163,8 +1163,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 
 	case SO_PRIORITY:
 		if ((val >= 0 && val <= 6) ||
-		    ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) ||
-		    ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+		    ns_capable_any(sock_net(sk)->user_ns, CAP_NET_RAW, CAP_NET_ADMIN))
 			sk->sk_priority = val;
 		else
 			ret = -EPERM;
@@ -1309,8 +1308,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			clear_bit(SOCK_PASSSEC, &sock->flags);
 		break;
 	case SO_MARK:
-		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
-		    !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
+		if (!ns_capable_any(sock_net(sk)->user_ns, CAP_NET_RAW, CAP_NET_ADMIN)) {
 			ret = -EPERM;
 			break;
 		}
@@ -1318,8 +1316,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		__sock_set_mark(sk, val);
 		break;
 	case SO_RCVMARK:
-		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
-		    !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
+		if (!ns_capable_any(sock_net(sk)->user_ns, CAP_NET_RAW, CAP_NET_ADMIN)) {
 			ret = -EPERM;
 			break;
 		}
@@ -2680,8 +2677,7 @@ int __sock_cmsg_send(struct sock *sk, struct msghdr *msg, struct cmsghdr *cmsg,
 
 	switch (cmsg->cmsg_type) {
 	case SO_MARK:
-		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
-		    !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable_any(sock_net(sk)->user_ns, CAP_NET_RAW, CAP_NET_ADMIN))
 			return -EPERM;
 		if (cmsg->cmsg_len != CMSG_LEN(sizeof(u32)))
 			return -EINVAL;
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 718fb77bb372..882483602c27 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -894,8 +894,7 @@ static int dgram_setsockopt(struct sock *sk, int level, int optname,
 		ro->want_lqi = !!val;
 		break;
 	case WPAN_SECURITY:
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN) &&
-		    !ns_capable(net->user_ns, CAP_NET_RAW)) {
+		if (!ns_capable_any(net->user_ns, CAP_NET_RAW, CAP_NET_ADMIN)) {
 			err = -EPERM;
 			break;
 		}
@@ -918,8 +917,7 @@ static int dgram_setsockopt(struct sock *sk, int level, int optname,
 		}
 		break;
 	case WPAN_SECURITY_LEVEL:
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN) &&
-		    !ns_capable(net->user_ns, CAP_NET_RAW)) {
+		if (!ns_capable_any(net->user_ns, CAP_NET_RAW, CAP_NET_ADMIN)) {
 			err = -EPERM;
 			break;
 		}
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 445a9ecaefa1..2da0a450edf6 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1339,8 +1339,7 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case IP_TRANSPARENT:
-		if (!!val && !ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
-		    !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
+		if (!!val && !ns_capable_any(sock_net(sk)->user_ns, CAP_NET_RAW, CAP_NET_ADMIN)) {
 			err = -EPERM;
 			break;
 		}
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 222f6bf220ba..25babd7ce844 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -634,8 +634,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case IPV6_TRANSPARENT:
-		if (valbool && !ns_capable(net->user_ns, CAP_NET_RAW) &&
-		    !ns_capable(net->user_ns, CAP_NET_ADMIN)) {
+		if (valbool && !ns_capable_any(net->user_ns, CAP_NET_RAW, CAP_NET_ADMIN)) {
 			retv = -EPERM;
 			break;
 		}
diff --git a/net/unix/scm.c b/net/unix/scm.c
index aa27a02478dc..6c47baf04d7d 100644
--- a/net/unix/scm.c
+++ b/net/unix/scm.c
@@ -99,7 +99,7 @@ static inline bool too_many_unix_fds(struct task_struct *p)
 	struct user_struct *user = current_user();
 
 	if (unlikely(user->unix_inflight > task_rlimit(p, RLIMIT_NOFILE)))
-		return !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN);
+		return !capable_any(CAP_SYS_RESOURCE, CAP_SYS_ADMIN);
 	return false;
 }
 
-- 
2.36.1

