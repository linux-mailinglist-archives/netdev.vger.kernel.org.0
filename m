Return-Path: <netdev+bounces-1838-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F2186FF44B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C95A1C20F54
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF5D1E527;
	Thu, 11 May 2023 14:27:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D8919E77;
	Thu, 11 May 2023 14:27:15 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089C0E72;
	Thu, 11 May 2023 07:26:49 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-965ac4dd11bso1723548966b.2;
        Thu, 11 May 2023 07:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1683815207; x=1686407207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yh+kmOB/3T2Ct+e48ke7ddrVyWc5FzCqMfagVQ+ockI=;
        b=mR9aqKYicwMhgogcBnAWcdWjqogQ/c966GYPXq2hztmeo7By9ge9YtvNNVBIBOjCAU
         92/2QZ+ONIbYxFkUA79jMjYwJrHgIchmcwyQ+IH1HZAJX3m6JJEq2KyQNvqZaSlzq6Fx
         Gt0qJ+2K3/5BEPKoqxysmvLFVMv/tPjGoFE5oJ3L+JGRRJipYB7b5kWJsnJTvP/8r4sI
         AL0DxwnAsD/2HvZkicFCgrxdib1N1YI95aYIY0aanJcnsHrRjdcPxWaqpHoSeHoXgulh
         nXgY15ThHUUs5d05k9LT1s98tveFZZvlLfRZeCSOL0NkJtmPG++KIatLJDx0KS0+86Nl
         i9xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683815207; x=1686407207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yh+kmOB/3T2Ct+e48ke7ddrVyWc5FzCqMfagVQ+ockI=;
        b=RG3ajnOHsuLldcTD3zgTh7gF02yKXeGWEuUiyFvRvAsZghEj64WaB3f94pKsoLTgMb
         vKh5qZGIbP38111GLW4PynxIFH7V1DUZ/uGa0OMX7mmKPLXX368dSl68nFcq7lE9xAYf
         6rjMW4uLw+/Lhsdvcds5BU8NdmUYRH7+HsYoQjYdERKzB66Q024jjb4+hziKobMIKODA
         x5qiQ5LCe6hOz5doYwArNduSgrs5TAIvHYu+GprRYJU5Ix22OrsmI7Mxrx6SkYD+qtq1
         5FFVur+ovBfYAPXUtOO8nKyUA3yKaq3KP59mE6fGMmqP6qCUC5eWwNJU7O5dHm7pw7/9
         9yxQ==
X-Gm-Message-State: AC+VfDwnK8XV0Ydw2PYF8QuhBCV64rsnedseLT7G6hIEh4Ln+ryrTOOY
	W2Q2ULew9SALUjrE9Sphd8e4tnmtbAmaTg==
X-Google-Smtp-Source: ACHHUZ55K3LlAfJsD/0MVktqrGV0ADiuIvt5DFR+742oY+v7paoIFV0bf/KxU1DRLqe4/9ezFAEbVA==
X-Received: by 2002:a17:907:1c88:b0:961:be96:b0e0 with SMTP id nb8-20020a1709071c8800b00961be96b0e0mr20141790ejc.73.1683815207515;
        Thu, 11 May 2023 07:26:47 -0700 (PDT)
Received: from debianHome.localdomain (dynamic-077-008-180-228.77.8.pool.telefonica.de. [77.8.180.228])
        by smtp.gmail.com with ESMTPSA id hf15-20020a1709072c4f00b0094f58a85bc5sm4056647ejc.180.2023.05.11.07.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 07:26:45 -0700 (PDT)
From: =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
To: selinux@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	David Ahern <dsahern@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Alexei Starovoitov <ast@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jason Xing <kernelxing@tencent.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-wpan@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH v4 9/9] net: use new capable_any functionality
Date: Thu, 11 May 2023 16:25:32 +0200
Message-Id: <20230511142535.732324-9-cgzones@googlemail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511142535.732324-1-cgzones@googlemail.com>
References: <20230511142535.732324-1-cgzones@googlemail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use the new added capable_any function in appropriate cases, where a
task is required to have any of two capabilities.

Add sock_ns_capable_any() wrapper similar to existing sock_ns_capable()
one.

Reorder CAP_SYS_ADMIN last.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
v4:
  - introduce sockopt_ns_capable_any()
v3:
  - rename to capable_any()
  - make use of ns_capable_any
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
 include/net/sock.h       |  1 +
 net/caif/caif_socket.c   |  2 +-
 net/core/sock.c          | 18 ++++++++++--------
 net/ieee802154/socket.c  |  6 ++----
 net/ipv4/ip_sockglue.c   |  4 ++--
 net/ipv6/ipv6_sockglue.c |  3 +--
 net/unix/scm.c           |  2 +-
 7 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 8b7ed7167243..a17178e31e91 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1762,6 +1762,7 @@ static inline void unlock_sock_fast(struct sock *sk, bool slow)
 void sockopt_lock_sock(struct sock *sk);
 void sockopt_release_sock(struct sock *sk);
 bool sockopt_ns_capable(struct user_namespace *ns, int cap);
+bool sockopt_ns_capable_any(struct user_namespace *ns, int cap1, int cap2);
 bool sockopt_capable(int cap);
 
 /* Used by processes to "lock" a socket state, so that
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 4eebcc66c19a..6dcc08f9da3b 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -1027,7 +1027,7 @@ static int caif_create(struct net *net, struct socket *sock, int protocol,
 		.usersize = sizeof_field(struct caifsock, conn_req.param)
 	};
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_NET_ADMIN))
+	if (!capable_any(CAP_NET_ADMIN, CAP_SYS_ADMIN))
 		return -EPERM;
 	/*
 	 * The sock->type specifies the socket type to use.
diff --git a/net/core/sock.c b/net/core/sock.c
index 5440e67bcfe3..6a236d649bec 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1073,6 +1073,12 @@ bool sockopt_ns_capable(struct user_namespace *ns, int cap)
 }
 EXPORT_SYMBOL(sockopt_ns_capable);
 
+bool sockopt_ns_capable_any(struct user_namespace *ns, int cap1, int cap2)
+{
+	return has_current_bpf_ctx() || ns_capable_any(ns, cap1, cap2);
+}
+EXPORT_SYMBOL(sockopt_ns_capable_any);
+
 bool sockopt_capable(int cap)
 {
 	return has_current_bpf_ctx() || capable(cap);
@@ -1207,8 +1213,7 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 
 	case SO_PRIORITY:
 		if ((val >= 0 && val <= 6) ||
-		    sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) ||
-		    sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+		    sockopt_ns_capable_any(sock_net(sk)->user_ns, CAP_NET_RAW, CAP_NET_ADMIN))
 			sk->sk_priority = val;
 		else
 			ret = -EPERM;
@@ -1353,8 +1358,7 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 			clear_bit(SOCK_PASSSEC, &sock->flags);
 		break;
 	case SO_MARK:
-		if (!sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
-		    !sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
+		if (!sockopt_ns_capable_any(sock_net(sk)->user_ns, CAP_NET_RAW, CAP_NET_ADMIN)) {
 			ret = -EPERM;
 			break;
 		}
@@ -1362,8 +1366,7 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 		__sock_set_mark(sk, val);
 		break;
 	case SO_RCVMARK:
-		if (!sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
-		    !sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
+		if (!sockopt_ns_capable_any(sock_net(sk)->user_ns, CAP_NET_RAW, CAP_NET_ADMIN)) {
 			ret = -EPERM;
 			break;
 		}
@@ -2747,8 +2750,7 @@ int __sock_cmsg_send(struct sock *sk, struct cmsghdr *cmsg,
 
 	switch (cmsg->cmsg_type) {
 	case SO_MARK:
-		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
-		    !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable_any(sock_net(sk)->user_ns, CAP_NET_RAW, CAP_NET_ADMIN))
 			return -EPERM;
 		if (cmsg->cmsg_len != CMSG_LEN(sizeof(u32)))
 			return -EINVAL;
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 1fa2fe041ec0..f9bc6cae4af9 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -904,8 +904,7 @@ static int dgram_setsockopt(struct sock *sk, int level, int optname,
 		ro->want_lqi = !!val;
 		break;
 	case WPAN_SECURITY:
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN) &&
-		    !ns_capable(net->user_ns, CAP_NET_RAW)) {
+		if (!ns_capable_any(net->user_ns, CAP_NET_ADMIN, CAP_NET_RAW)) {
 			err = -EPERM;
 			break;
 		}
@@ -928,8 +927,7 @@ static int dgram_setsockopt(struct sock *sk, int level, int optname,
 		}
 		break;
 	case WPAN_SECURITY_LEVEL:
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN) &&
-		    !ns_capable(net->user_ns, CAP_NET_RAW)) {
+		if (!ns_capable_any(net->user_ns, CAP_NET_ADMIN, CAP_NET_RAW)) {
 			err = -EPERM;
 			break;
 		}
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index b511ff0adc0a..4dd752743b84 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1341,8 +1341,8 @@ int do_ip_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case IP_TRANSPARENT:
-		if (!!val && !sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
-		    !sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
+		if (!!val && !sockopt_ns_capable_any(sock_net(sk)->user_ns, CAP_NET_RAW,
+						     CAP_NET_ADMIN)) {
 			err = -EPERM;
 			break;
 		}
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index ae818ff46224..38aad44547e4 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -625,8 +625,7 @@ int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case IPV6_TRANSPARENT:
-		if (valbool && !sockopt_ns_capable(net->user_ns, CAP_NET_RAW) &&
-		    !sockopt_ns_capable(net->user_ns, CAP_NET_ADMIN)) {
+		if (valbool && !sockopt_ns_capable_any(net->user_ns, CAP_NET_RAW, CAP_NET_ADMIN)) {
 			retv = -EPERM;
 			break;
 		}
diff --git a/net/unix/scm.c b/net/unix/scm.c
index f9152881d77f..4d18187a5349 100644
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
2.40.1


