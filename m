Return-Path: <netdev+bounces-4233-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75AB870BCF5
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:08:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E47241C20A24
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A20D30E;
	Mon, 22 May 2023 12:08:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02A9D30B
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:08:39 +0000 (UTC)
Received: from mail-ej1-x663.google.com (mail-ej1-x663.google.com [IPv6:2a00:1450:4864:20::663])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A92B3
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 05:08:25 -0700 (PDT)
Received: by mail-ej1-x663.google.com with SMTP id a640c23a62f3a-96f818c48fbso555331666b.0
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 05:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1684757303; x=1687349303;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gZQANtnYzYVh9bLE6o/zHcuLfWgH/zMHwwYGn/d3H40=;
        b=g5f3E9N8Xyga3zVJEohWNmVS3D89svqtP359KOi7he7s3NyCMgeZg2uic69TNJuzvS
         nbeOXM5VffRNvtQIg2YFOGBLxQgch7Pbr3UvFWMOV2SQKPDPbC/K8T08MeU7WQ83HUQU
         /5ZtGgTARgtSRcYCXbZA1CSAtsrvgQM6RRI+Jp/2177qyoOodS6KlSWigNlYiPyVLbUF
         EGdGNSLnbv+M33nPWqHL1UOVPBERbwBHhF6Qnh1c9Mi0xYUgAeDrN4SgU5uckS2sQrP/
         /32iykU8bbOFy/e7sjdgvs5Zdbjvl7/0aZXMFjfJ85eQPim6GbMjY2RARAaNJ3xhnLDd
         GKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757303; x=1687349303;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gZQANtnYzYVh9bLE6o/zHcuLfWgH/zMHwwYGn/d3H40=;
        b=iSEx3543nhjg48RS+2njrojia8K4aqyVO9xD7CnVFxP2KSku7xvT6Q+Z/2DQuL13rI
         6cJEOTXgHG+ekj2KmT66XsPOhR9zdoITE1dYhsvJy32RV66jh2fhOYqI6JG/XNqzlYLw
         ezR+wRdAuDPOxieFcrX3/iR08IMpyHHOJpbvrBiQ+lHMTGrpbLFMKXCDtOCI2hvwxnuL
         DnTMBTqDnpReiaTrT+eu31d6DmjM+e9yhoQC9rpSFNYkinu8nLVFZD374rIEB1BW5A/P
         Sg2LW6F+aAZBlS/JQAsuJUnjfr4fic3W74Phkqcm+qAfktyVsf18CGz+7hDfXriXkfHP
         72LQ==
X-Gm-Message-State: AC+VfDzKkGOtJCN7c3aPFNg8ZW8NR0/zKyyMnqQbxvuRHF5JGUvRaDBa
	WulrG3SNbQRWNgFXUBYv1bcO/LTmkYn6TQFOEstwVXNZs4KzCg==
X-Google-Smtp-Source: ACHHUZ4CQO8et14Y4Zk3ZBuYVEojUVYHEfqtzRRn5Vfzpoizo05yYezy/8U9DJcwvi4dsELQIETkkz+DEkxJ
X-Received: by 2002:a17:907:1607:b0:966:5912:c4b with SMTP id hb7-20020a170907160700b0096659120c4bmr10032375ejc.76.1684757303545;
        Mon, 22 May 2023 05:08:23 -0700 (PDT)
Received: from smtpservice.6wind.com ([185.13.181.2])
        by smtp-relay.gmail.com with ESMTP id gh14-20020a170906e08e00b0096647f95cc2sm758300ejb.291.2023.05.22.05.08.23;
        Mon, 22 May 2023 05:08:23 -0700 (PDT)
X-Relaying-Domain: 6wind.com
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
	by smtpservice.6wind.com (Postfix) with ESMTPS id 42CA760115;
	Mon, 22 May 2023 14:08:23 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.94.2)
	(envelope-from <nicolas.dichtel@6wind.com>)
	id 1q14Ks-005XEv-V8; Mon, 22 May 2023 14:08:22 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>
Cc: Steffen Klassert <klassert@kernel.org>,
	netdev@vger.kernel.org,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	stable@vger.kernel.org
Subject: [PATCH net v2] ipv{4,6}/raw: fix output xfrm lookup wrt protocol
Date: Mon, 22 May 2023 14:08:20 +0200
Message-Id: <20230522120820.1319391-1-nicolas.dichtel@6wind.com>
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
CC: stable@vger.kernel.org
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---

v1 -> v2:
 - accept only int in cmsg for IP_PROTOCOL

 include/net/ip.h        |  2 ++
 include/uapi/linux/in.h |  1 +
 net/ipv4/ip_sockglue.c  | 12 +++++++++++-
 net/ipv4/raw.c          |  5 ++++-
 net/ipv6/raw.c          |  3 ++-
 5 files changed, 20 insertions(+), 3 deletions(-)

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
index b511ff0adc0a..8e97d8d4cc9d 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -317,7 +317,14 @@ int ip_cmsg_send(struct sock *sk, struct msghdr *msg, struct ipcm_cookie *ipc,
 			ipc->tos = val;
 			ipc->priority = rt_tos2priority(ipc->tos);
 			break;
-
+		case IP_PROTOCOL:
+			if (cmsg->cmsg_len != CMSG_LEN(sizeof(int)))
+				return -EINVAL;
+			val = *(int *)CMSG_DATA(cmsg);
+			if (val < 1 || val > 255)
+				return -EINVAL;
+			ipc->protocol = val;
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -1761,6 +1768,9 @@ int do_ip_getsockopt(struct sock *sk, int level, int optname,
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


