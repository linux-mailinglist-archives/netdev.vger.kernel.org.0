Return-Path: <netdev+bounces-3119-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C9B470588C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 22:17:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48FA91C20C5E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 259DB24EA3;
	Tue, 16 May 2023 20:16:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193B324E91
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 20:16:19 +0000 (UTC)
Received: from mail-wr1-x461.google.com (mail-wr1-x461.google.com [IPv6:2a00:1450:4864:20::461])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C041A421A
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 13:15:51 -0700 (PDT)
Received: by mail-wr1-x461.google.com with SMTP id ffacd0b85a97d-307c040797bso5098558f8f.3
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 13:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1684268146; x=1686860146;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CAI4UrPhLCkj1nbX20wKvZAfgpXNoo2nXGSG8wVpkNo=;
        b=LhM2gAf6rwAKpwCA6Lhl6FFPm+lACFFEAWvW266q+Nllwz/CmeAf8LswhEP0UJBRgI
         XSw3DopOLjvA3zV9dm8GPZGzEITehtHVOFUvg31QE3uD6mVhjF+TvcitHGc8DRUM89G9
         P8MCRM2w5VHk1HcAhiapxDdmPajvX678MzBO6v9YxSBIZSiEHXOI5riMZjoOvq1BWQi+
         PuCdyAcLuYf7GnbXYec1noWurAugOfnaZHXmZ/kz0nKfB40WiB3DqeiqkWyfXlNbf5HW
         FmFZra4Ln0ePTZYEijSJXYym/ada+lMjPBxWFs9QkViXn/NfKG0nX00gMLzvfAMtVtmK
         3JZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684268146; x=1686860146;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CAI4UrPhLCkj1nbX20wKvZAfgpXNoo2nXGSG8wVpkNo=;
        b=biKvV/qG7vs3rsE/ev9b07tWfjbcVs9v9eybGoLZODWCte7UqQWzRVMgCmAAvX/l5/
         3LaTyb8m9+WxsAPkZ7OentMPqy2RFl+2q3FcDMCPwCPID79I0HqO8Bagvfy4pRYLyZTn
         7Yjm4cAX78yI9mTogwFB7XXgX3jIvwyRiFULGWWvYQKmHRW29XthFhnnJxo1F+jUO7fN
         dvj3hmt+sG9gDXDgWdoppEjhZ85QJFyvqlin8oIXpfhvttg8lfs8V9aGjrpXaWcGA6Mv
         Cq4kDnbBkooGkAczkG5xHTj+OmCRGLcpIhVFeRO0jUCJSRp2ZqeWdxolZqYRyc2XJSxS
         OGRg==
X-Gm-Message-State: AC+VfDzmTRGUFWgLXYTBgjraYyWjzR5t9k4oTHuRyUkC+tBB+2x+kg6f
	Jc5WyC7s4Zfa8LrTwVaCaVS3yC1JrAq3oVCAdWRftfBTkXgEfA==
X-Google-Smtp-Source: ACHHUZ4RXwGpU+fatMH5iBpsVkHr60ggUfz+GWlRBOPq2oC9pF4IIXPBS/Y6rp/X41sWozbas4p6JRQSmsEm
X-Received: by 2002:a5d:5747:0:b0:309:3a83:cf3a with SMTP id q7-20020a5d5747000000b003093a83cf3amr1622776wrw.0.1684268145628;
        Tue, 16 May 2023 13:15:45 -0700 (PDT)
Received: from smtpservice.6wind.com ([185.13.181.2])
        by smtp-relay.gmail.com with ESMTP id l20-20020a5d5274000000b003090455296bsm35470wrc.1.2023.05.16.13.15.45;
        Tue, 16 May 2023 13:15:45 -0700 (PDT)
X-Relaying-Domain: 6wind.com
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
	by smtpservice.6wind.com (Postfix) with ESMTPS id 5C706600F0;
	Tue, 16 May 2023 22:15:45 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
	(envelope-from <nicolas.dichtel@6wind.com>)
	id 1pz15F-0005KH-81; Tue, 16 May 2023 22:15:45 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <klassert@kernel.org>,
	netdev@vger.kernel.org,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	stable@vger.kernel.org
Subject: [PATCH RESEND net] ipv{4,6}/raw: fix output xfrm lookup wrt protocol
Date: Tue, 16 May 2023 22:15:42 +0200
Message-Id: <20230516201542.9086-1-nicolas.dichtel@6wind.com>
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
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
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
CC: stable@vger.kernel.org
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---

The first version has been marked 'Awaiting Upstream'. Steffen confirmed
that the 'net' tree should be the target, thus I resend this patch.
I also CC stable@vger.kernel.org.

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


