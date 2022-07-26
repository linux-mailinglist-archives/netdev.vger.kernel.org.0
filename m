Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD78580B74
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbiGZGVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237898AbiGZGTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:19:06 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457FE2AC73;
        Mon, 25 Jul 2022 23:16:36 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id u12so11481766edd.5;
        Mon, 25 Jul 2022 23:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FbU6AOsxSaCrQyo6crmktmrXF66ZdlejKzTQU66I6PU=;
        b=Ijj4e3S60/m8RzF7AIVGNFuKHtWedhChLjG8AEOvwpXq6KRNJrTnYBX47QiwHnkt0t
         LUe5tWFUlTnSp7hgWQ9BW5dCxVSFk3V7Us+yS12+DvgVsPLAd3wYUOPeAxVk4kODPqiT
         YWsKXxRD/AI7O2PPenqjq9v+rl7XLeXHXvAx3sff3A7gGWyHhcXstS2bF297s3ITBFRr
         HlElkiL5o3IV7uFNUxEViKOvUMztEtBR3ww+v7unM9jXVpiHvYH+EZxL3yaLsdGQrrGQ
         WvtBdzkvzl1Q6FaRFX/Bl++abhyQXbz2Qfb8fK9sFrmBwFM9k2WLbiScJvmIXXweUO69
         2I8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FbU6AOsxSaCrQyo6crmktmrXF66ZdlejKzTQU66I6PU=;
        b=qdfR+OGNxGc4d5EkN6n0P1nNErXE7ZK79IHe4dbsFTmfzV72kaV3iq+Xwuwhli8Qh5
         05o68Rtp3nOD5OZsgKETvEaSBgSVDX13ytzzx0xoylqgeuzIvCOx+oyqp3ksxNBF4Owj
         f7ZR1EW5SIipsG3Qh6do/QpC/crNghsR093Aj1x3QSPrwCTBNZaKRphuqrJryqIpXojg
         KW+zy0zl49AyMNwwWSG2CZ72KOj3RIwqEOAD+W1AABsDRnB1uRpHaHkIAwm7Z2N8EGRH
         YQIklNAkwVtt5e+TJaTNY6UevL6rgJS67xGdudqJv9Tj5Q+rsdE8ZrtapP2OPaEzzbrg
         aqdA==
X-Gm-Message-State: AJIora/S2tAP0UuuaLwoAhsPCjJBTYQgyC9SLNyauqcg6H/qH8h4SM6F
        NTgMeuIEql+2w/7X5MFg+yk=
X-Google-Smtp-Source: AGRyM1vzDyQBrcRgCgVFkfLcKrBko8ADwqC5PufOKsc9XkQSO19F1BRvynX4dgU8VpNWUmAsipjVrA==
X-Received: by 2002:a05:6402:48:b0:43a:caa8:756b with SMTP id f8-20020a056402004800b0043acaa8756bmr16410448edu.112.1658816187241;
        Mon, 25 Jul 2022 23:16:27 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:16:26 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 26/26] tcp: authopt: Initial implementation of TCP_REPAIR_AUTHOPT
Date:   Tue, 26 Jul 2022 09:15:28 +0300
Message-Id: <660b000d4334668f0cd3f4c9e86e5b93134ea380.1658815925.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1658815925.git.cdleonard@gmail.com>
References: <cover.1658815925.git.cdleonard@gmail.com>
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

In order to support TCP_REPAIR for connections use RFC5925
Authentication Option add a sockopt to get/set ISN and SNE values.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h |  2 ++
 include/uapi/linux/tcp.h  | 15 +++++++++++
 net/ipv4/tcp.c            | 23 +++++++++++++++++
 net/ipv4/tcp_authopt.c    | 53 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 93 insertions(+)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 4f83d8e54fef..fda6dc4b5d57 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -231,10 +231,12 @@ static inline void tcp_authopt_update_snd_sne(struct tcp_sock *tp, u32 seq)
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
index 5ca8aa9d5e43..469a783ce32b 100644
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
@@ -490,10 +491,24 @@ struct tcp_authopt_key {
 	 * address match is performed.
 	 */
 	int	prefixlen;
 };
 
+/**
+ * struct tcp_authopt_repair - TCP_REPAIR information related to Authentication Option
+ * @src_isn: Local Initial Sequence Number
+ * @dst_isn: Remote Initial Sequence Number
+ * @snd_sne: Sequence Number Extension for Send (upper 32 bits of snd_nxt)
+ * @rcv_sne: Sequence Number Extension for Recv (upper 32 bits of rcv_nxt)
+ */
+struct tcp_authopt_repair {
+	__u32	src_isn;
+	__u32	dst_isn;
+	__u32	snd_sne;
+	__u32	rcv_sne;
+};
+
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
 struct tcp_zerocopy_receive {
 	__u64 address;		/* in: address of mapping */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 2460bff936c6..3e135c4ca23d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3675,10 +3675,13 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
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
@@ -4347,10 +4350,30 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
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
index c71f5ed5ca1d..c3b001905296 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -682,10 +682,63 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 	opt->recv_rnextkeyid = info->recv_rnextkeyid;
 
 	return 0;
 }
 
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
+
+	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
+	if (!info)
+		return -ENOENT;
+
+	opt->dst_isn = info->dst_isn;
+	opt->src_isn = info->src_isn;
+	opt->rcv_sne = info->rcv_sne;
+	opt->snd_sne = info->snd_sne;
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
+	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
+	if (!info)
+		return -ENOENT;
+
+	info->dst_isn = val.dst_isn;
+	info->src_isn = val.src_isn;
+	info->rcv_sne = val.rcv_sne;
+	info->snd_sne = val.snd_sne;
+
+	return 0;
+}
+
 #define TCP_AUTHOPT_KEY_KNOWN_FLAGS ( \
 	TCP_AUTHOPT_KEY_DEL | \
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS | \
 	TCP_AUTHOPT_KEY_ADDR_BIND | \
 	TCP_AUTHOPT_KEY_IFINDEX | \
-- 
2.25.1

