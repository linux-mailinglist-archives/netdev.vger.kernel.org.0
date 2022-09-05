Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902A15ACC19
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237500AbiIEHJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237243AbiIEHHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:07:21 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CD93F30C;
        Mon,  5 Sep 2022 00:06:57 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b16so10098634edd.4;
        Mon, 05 Sep 2022 00:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=TovwxS/IQLmo+Xng6jJuhfPGUn+AGzgUVGlc7q8PIhw=;
        b=FC04oRxxg7A/FBOvJl0eh1L8qRBNmW2miLprJU3NgqFWQyzMkGWfPQf/hDXIxOxvVk
         QsUVJ7O1cUfPUxzRe3nCk1lCxDZeIlK3ddUrReWNVwJFOYhAVTpscU7K7CABe2vDycxG
         Hv8NcaAmVRIzQ0WN/HGKHezuBXGrlcEFSz2Ut5y9JQpi3OX7rv2bEnTGdH7pZ6VAKOzS
         ATD21Cai526NqsoFY1IxUdRwlW//9Pm1QON9acQqQsTba6TSye+QHq8ch6S/BLfQhvCw
         B5rJdNtt1fwNFi30W0PlhThXKtKB5GkklJ86GfpRpdzJm2rogjZnzjL1G2lGjp145uu0
         7Mpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=TovwxS/IQLmo+Xng6jJuhfPGUn+AGzgUVGlc7q8PIhw=;
        b=EhJwl6g1nG1VvN6k08S1+yfDaeBWnUB68i2Mxcwk6w7RQFd1ZRo2UnNuSj0q0ZhLwn
         AysJd50xGTFd2UCHL58YYXSA13hyYr9s42ENt4Mzta0dxELlPuUOeqpWEJF4awZoeKt+
         +35fHBxF10B3t5PaGKJ+PjRrgKMS6tFiALy8lfiZtNmXvy1/GPbAUx4RZ2wVYa0yUyjw
         joLXP6+QMUonG8HeqEPjfPpiWLGl2NfPkNuLQkUiinHZhMTrNajaf1osYw5uVMheyS0p
         i7Ss2xtFlzRxbS757pVcG9BAntHIszBz8NOMUCZUSypQVdUHTkJkmmfMNRqLZIi0IHzC
         o7uA==
X-Gm-Message-State: ACgBeo1urUauFOKKGeicinphwswsNpZpSUpExd9tsA0llFXpjfFoo7uV
        mpTK/ppkO1DRAKWEWTT9kVs=
X-Google-Smtp-Source: AA6agR7COv6ceRdcHvs/XAlzrnv2vDerv3vPYXik0bPhzYI2V5KQ7Ls5JlVzdwWLcbBRB3Crnlji/w==
X-Received: by 2002:a05:6402:3591:b0:448:a15e:3ca0 with SMTP id y17-20020a056402359100b00448a15e3ca0mr27555651edc.195.1662361616465;
        Mon, 05 Sep 2022 00:06:56 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:40ec:9f50:387:3cfb])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5882775edd.48.2022.09.05.00.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:06:55 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 23/26] tcp: authopt: Initial implementation of TCP_REPAIR_AUTHOPT
Date:   Mon,  5 Sep 2022 10:05:59 +0300
Message-Id: <ace7764cc7fca32864d09d4ee6042dc8b90cb773.1662361354.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662361354.git.cdleonard@gmail.com>
References: <cover.1662361354.git.cdleonard@gmail.com>
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

In order to support TCP_REPAIR for connections using RFC5925
Authentication Option add a sockopt to get/set ISN and SNE values.

The TCP_REPAIR_AUTHOxpTP sockopt is only allowed when the socket is
already in "repair" mode, this behavior is shared with other sockopts
relevant to TCP_REPAIR.

The setsockopt further requires the TCP_ESTABLISHED state, this is
because it relies on snd_nxt which is only initialized after connect().

For SNE restoration we provide a full 64-bit sequence number on "get" and
handle any recent 64-bit sequence number on "set", where recent means
"within ~2GB to the current window".

Linux tracks snd_sne and rcv_sne as the extension of snd_nxt and
rcv_nxt but this is an implementation detail and snd_nxt doesn't even
seem to be one of the values that can be read by userspace. Handling SNE
with 64-bit values means userspace doesn't need to worry about matching
snd_nxt.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h |  2 ++
 include/uapi/linux/tcp.h  | 19 +++++++++++
 net/ipv4/tcp.c            | 23 ++++++++++++++
 net/ipv4/tcp_authopt.c    | 66 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 759b6d71fe86..5a8cea32a5f3 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -236,10 +236,12 @@ static inline void tcp_authopt_update_snd_sne(struct tcp_sock *tp, u32 seq)
 						 lockdep_sock_is_held((struct sock *)tp));
 		if (info)
 			__tcp_authopt_update_snd_sne(tp, info, seq);
 	}
 }
+int tcp_get_authopt_repair_val(struct sock *sk, struct tcp_authopt_repair *opt);
+int tcp_set_authopt_repair(struct sock *sk, sockptr_t optval, unsigned int optlen);
 #else
 static inline void tcp_authopt_clear(struct sock *sk)
 {
 }
 static inline int tcp_authopt_openreq(struct sock *newsk,
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index ff8b53f4209d..d6911d9c2b4e 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -128,10 +128,11 @@ enum {
 #define TCP_CM_INQ		TCP_INQ
 
 #define TCP_TX_DELAY		37	/* delay outgoing packets by XX usec */
 #define TCP_AUTHOPT		38	/* TCP Authentication Option (RFC5925) */
 #define TCP_AUTHOPT_KEY		39	/* TCP Authentication Option Key (RFC5925) */
+#define TCP_REPAIR_AUTHOPT	40
 
 
 #define TCP_REPAIR_ON		1
 #define TCP_REPAIR_OFF		0
 #define TCP_REPAIR_OFF_NO_WP	-1	/* Turn off without window probes */
@@ -509,10 +510,28 @@ struct tcp_authopt_key {
 	__u64	recv_lifetime_begin;
 	/** @recv_lifetime_end: End of recv lifetime */
 	__u64	recv_lifetime_end;
 };
 
+/**
+ * struct tcp_authopt_repair - TCP_REPAIR information related to Authentication Option
+ * @src_isn: Local Initial Sequence Number
+ * @dst_isn: Remote Initial Sequence Number
+ * @snd_sne: Sequence Number Extension for Send (upper 32 bits of snd_seq)
+ * @rcv_sne: Sequence Number Extension for Recv (upper 32 bits of rcv_seq)
+ * @snd_seq: Recent Send Sequence Number (lower 32 bits of snd_sne)
+ * @rcv_seq: Recent Recv Sequence Number (lower 32 bits of rcv_sne)
+ */
+struct tcp_authopt_repair {
+	__u32	src_isn;
+	__u32	dst_isn;
+	__u32	snd_sne;
+	__u32	rcv_sne;
+	__u32	snd_seq;
+	__u32	rcv_seq;
+};
+
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
 struct tcp_zerocopy_receive {
 	__u64 address;		/* in: address of mapping */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index dd31e78bd22d..1e0dcfae23f5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3712,10 +3712,13 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		err = tcp_set_authopt(sk, optval, optlen);
 		break;
 	case TCP_AUTHOPT_KEY:
 		err = tcp_set_authopt_key(sk, optval, optlen);
 		break;
+	case TCP_REPAIR_AUTHOPT:
+		err = tcp_set_authopt_repair(sk, optval, optlen);
+		break;
 #endif
 	case TCP_USER_TIMEOUT:
 		/* Cap the max time in ms TCP will retry or probe the window
 		 * before giving up and aborting (ETIMEDOUT) a connection.
 		 */
@@ -4384,10 +4387,30 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 			return -EFAULT;
 		if (copy_to_user(optval, &info, len))
 			return -EFAULT;
 		return 0;
 	}
+	case TCP_REPAIR_AUTHOPT: {
+		struct tcp_authopt_repair val;
+		int err;
+
+		if (get_user(len, optlen))
+			return -EFAULT;
+
+		lock_sock(sk);
+		err = tcp_get_authopt_repair_val(sk, &val);
+		release_sock(sk);
+
+		if (err)
+			return err;
+		len = min_t(unsigned int, len, sizeof(val));
+		if (put_user(len, optlen))
+			return -EFAULT;
+		if (copy_to_user(optval, &val, len))
+			return -EFAULT;
+		return 0;
+	}
 #endif
 
 	default:
 		return -ENOPROTOOPT;
 	}
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index b4158b430b79..1c571a977224 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -1839,10 +1839,76 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb,
 	save_inbound_key_info(info, opt);
 	return 1;
 }
 EXPORT_SYMBOL(__tcp_authopt_inbound_check);
 
+int tcp_get_authopt_repair_val(struct sock *sk, struct tcp_authopt_repair *opt)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_authopt_info *info;
+	int err;
+
+	memset(opt, 0, sizeof(*opt));
+	sock_owned_by_me(sk);
+	err = check_sysctl_tcp_authopt();
+	if (err)
+		return err;
+	if (!tp->repair)
+		return -EPERM;
+
+	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
+	if (!info)
+		return -ENOENT;
+
+	opt->dst_isn = info->dst_isn;
+	opt->src_isn = info->src_isn;
+	opt->rcv_sne = info->rcv_sne;
+	opt->snd_sne = info->snd_sne;
+	opt->rcv_seq = tp->rcv_nxt;
+	opt->snd_seq = tp->snd_nxt;
+
+	return 0;
+}
+
+int tcp_set_authopt_repair(struct sock *sk, sockptr_t optval, unsigned int optlen)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_authopt_info *info;
+	struct tcp_authopt_repair val;
+	int err;
+
+	sock_owned_by_me(sk);
+	err = check_sysctl_tcp_authopt();
+	if (err)
+		return err;
+
+	if (optlen != sizeof(val))
+		return -EFAULT;
+	if (copy_from_sockptr(&val, optval, sizeof(val)))
+		return -EFAULT;
+
+	/* tcp_authopt repair relies on fields that are only initialized after
+	 * tcp_connect. Doing this setsockopt before connect() can't be correct
+	 * so return an error.
+	 */
+	if (sk->sk_state != TCP_ESTABLISHED)
+		return -EPERM;
+
+	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
+	if (!info)
+		return -ENOENT;
+	if (!tp->repair)
+		return -EPERM;
+
+	info->dst_isn = val.dst_isn;
+	info->src_isn = val.src_isn;
+	info->rcv_sne = compute_sne(val.rcv_sne, val.rcv_seq, tp->rcv_nxt);
+	info->snd_sne = compute_sne(val.snd_sne, val.snd_seq, tp->snd_nxt);
+
+	return 0;
+}
+
 #ifdef CONFIG_PROC_FS
 struct tcp_authopt_iter_state {
 	struct seq_net_private p;
 };
 
-- 
2.25.1

