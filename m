Return-Path: <netdev+bounces-1830-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BA3E6FF3E4
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:20:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 276FC2815CA
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554EE1B8FA;
	Thu, 11 May 2023 14:20:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424F21F956
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:20:09 +0000 (UTC)
Received: from mail-lf1-x162.google.com (mail-lf1-x162.google.com [IPv6:2a00:1450:4864:20::162])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDED2109
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:20:06 -0700 (PDT)
Received: by mail-lf1-x162.google.com with SMTP id 2adb3069b0e04-4efd6e26585so9871285e87.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1683814805; x=1686406805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XIe9TrrR/9flXN4+DYaiqlVpMC6V5HleA0mYiZIyGMg=;
        b=WZsauXGWOOvUyMUiRXrlPpLJa06tbY08fl64d2oc0rE/Bus5329oYDKWhBzyOKKbpf
         O9gGokFY+LDYK1kZvc5sBOaAKZDxzHxFgcasBlCg5/Ih7BGqcbZx09ISzPaZTq4Oepef
         HqI510dMAh+iTmU2DN4LQ/epi+8W/ATjw+b0gpghxNNGtFVIyr5JfGVg4EXcm2JvTQ+9
         h61NosXI85YApQutyPvDbAKjPxRhMDhzOGQlqHs8KYBsvnHXv8jS4Qcmwv0dBxDfNn4f
         15JtRLV92DdRUH6ZLzUDNB225L0QPlACS43jiNYnbiHIKIIzFXF6M2/8xMvQ+BzDnL/l
         YFxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683814805; x=1686406805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XIe9TrrR/9flXN4+DYaiqlVpMC6V5HleA0mYiZIyGMg=;
        b=bskN5ooZfrcXjNNW5DMQwUo71wI5ACaeHpv+bDJ0K/eUeIEkZv+2fja8PxwwigcmLq
         4dxhSQXC+l7YNzCHpUhrWqjMg7YxUGrb6CPjIEtxeX87fSLrcU0ccutm1Uq5goHwXhnR
         WxJC2a/HMByAtGDtWrMevPZFLox+EH36Ie2wBYR3FJLNjBCItBgf65UqwAsdnEsrThke
         NrtJLW47mP099Am1k15jwGN9RmOhSdqJNJpxVxKg/yaWsZJFLpFaZ5pJn/dzQ50UsR4x
         PjlA33flSR7xlI6prO9YkR+1wZgt7WL9fqD+6trUn25oxiLjZLgnh5mV4lWlPAA8Eza+
         8J/w==
X-Gm-Message-State: AC+VfDwoKBFIMR0/P2SUdmFX0hRQXxbe+ARnA7fk4ZWe+FwotBBTGnd3
	q9+B8FxGxiTCmq1mmCklwtAdwrJp48npRpIpNhT/Gy5MPwiCbg==
X-Google-Smtp-Source: ACHHUZ58EmCXVXkgyW/ciNtXFAuk02usKHOfiIoRah5cYcdhbVyTscMJKEeIakcKf9RCSq/NTxqRc+aj916t
X-Received: by 2002:ac2:51cb:0:b0:4ee:c134:8220 with SMTP id u11-20020ac251cb000000b004eec1348220mr3481236lfm.30.1683814804756;
        Thu, 11 May 2023 07:20:04 -0700 (PDT)
Received: from smtpservice.6wind.com ([185.13.181.2])
        by smtp-relay.gmail.com with ESMTP id a6-20020a2e8606000000b002a8aec38303sm1408674lji.1.2023.05.11.07.20.04;
        Thu, 11 May 2023 07:20:04 -0700 (PDT)
X-Relaying-Domain: 6wind.com
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
	by smtpservice.6wind.com (Postfix) with ESMTPS id 5A1AD60108;
	Thu, 11 May 2023 16:20:04 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
	(envelope-from <nicolas.dichtel@6wind.com>)
	id 1px79I-0005yh-87; Thu, 11 May 2023 16:20:04 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <klassert@kernel.org>,
	netdev@vger.kernel.org,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net] ipv{4,6}/raw: fix output xfrm lookup wrt protocol
Date: Thu, 11 May 2023 16:19:46 +0200
Message-Id: <20230511141946.22970-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

With a raw socket bound to IPPROTO_RAW (ie with hdrincl enabled), the
protocol field of the flow structure, build by raw_sendmsg() /
rawv6_sendmsg()),  is set to IPPROTO_RAW. This breaks the ipsec policy
lookup when some policies are defined with a protocol in the selector.

For ipv6, the sin6_port field from 'struct sockaddr_in6' could be used to
specify the protocol. Just accept all values for IPPROTO_RAW socket.

For ipv4, the sin_port field of 'struct sockaddr_in' could not be used
without breaking backward compatibility (the value of this field was never
checked). Let's add a new kind of control message, so that the userland
could specify which protocol is used.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/net/ip.h        |  2 ++
 include/uapi/linux/in.h |  1 +
 net/ipv4/ip_sockglue.c  | 15 ++++++++++++++-
 net/ipv4/raw.c          |  5 ++++-
 net/ipv6/raw.c          |  3 ++-
 5 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index c3fffaa92d6e..acec504c469a 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -76,6 +76,7 @@ struct ipcm_cookie {
 	__be32			addr;
 	int			oif;
 	struct ip_options_rcu	*opt;
+	__u8			protocol;
 	__u8			ttl;
 	__s16			tos;
 	char			priority;
@@ -96,6 +97,7 @@ static inline void ipcm_init_sk(struct ipcm_cookie *ipcm,
 	ipcm->sockc.tsflags = inet->sk.sk_tsflags;
 	ipcm->oif = READ_ONCE(inet->sk.sk_bound_dev_if);
 	ipcm->addr = inet->inet_saddr;
+	ipcm->protocol = inet->inet_num;
 }
 
 #define IPCB(skb) ((struct inet_skb_parm*)((skb)->cb))
diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index 4b7f2df66b99..e682ab628dfa 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -163,6 +163,7 @@ struct in_addr {
 #define IP_MULTICAST_ALL		49
 #define IP_UNICAST_IF			50
 #define IP_LOCAL_PORT_RANGE		51
+#define IP_PROTOCOL			52
 
 #define MCAST_EXCLUDE	0
 #define MCAST_INCLUDE	1
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index b511ff0adc0a..ec0fbe874426 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -317,7 +317,17 @@ int ip_cmsg_send(struct sock *sk, struct msghdr *msg, struct ipcm_cookie *ipc,
 			ipc->tos = val;
 			ipc->priority = rt_tos2priority(ipc->tos);
 			break;
-
+		case IP_PROTOCOL:
+			if (cmsg->cmsg_len == CMSG_LEN(sizeof(int)))
+				val = *(int *)CMSG_DATA(cmsg);
+			else if (cmsg->cmsg_len == CMSG_LEN(sizeof(u8)))
+				val = *(u8 *)CMSG_DATA(cmsg);
+			else
+				return -EINVAL;
+			if (val < 1 || val > 255)
+				return -EINVAL;
+			ipc->protocol = val;
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -1761,6 +1771,9 @@ int do_ip_getsockopt(struct sock *sk, int level, int optname,
 	case IP_LOCAL_PORT_RANGE:
 		val = inet->local_port_range.hi << 16 | inet->local_port_range.lo;
 		break;
+	case IP_PROTOCOL:
+		val = inet_sk(sk)->inet_num;
+		break;
 	default:
 		sockopt_release_sock(sk);
 		return -ENOPROTOOPT;
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index ff712bf2a98d..eadf1c9ef7e4 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -532,6 +532,9 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	}
 
 	ipcm_init_sk(&ipc, inet);
+	/* Keep backward compat */
+	if (hdrincl)
+		ipc.protocol = IPPROTO_RAW;
 
 	if (msg->msg_controllen) {
 		err = ip_cmsg_send(sk, msg, &ipc, false);
@@ -599,7 +602,7 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	flowi4_init_output(&fl4, ipc.oif, ipc.sockc.mark, tos,
 			   RT_SCOPE_UNIVERSE,
-			   hdrincl ? IPPROTO_RAW : sk->sk_protocol,
+			   hdrincl ? ipc.protocol : sk->sk_protocol,
 			   inet_sk_flowi_flags(sk) |
 			    (hdrincl ? FLOWI_FLAG_KNOWN_NH : 0),
 			   daddr, saddr, 0, 0, sk->sk_uid);
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 7d0adb612bdd..44ee7a2e72ac 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -793,7 +793,8 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 		if (!proto)
 			proto = inet->inet_num;
-		else if (proto != inet->inet_num)
+		else if (proto != inet->inet_num &&
+			 inet->inet_num != IPPROTO_RAW)
 			return -EINVAL;
 
 		if (proto > 255)
-- 
2.39.2


