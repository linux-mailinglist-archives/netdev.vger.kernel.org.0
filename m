Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F09DC69FD3
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 02:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733047AbfGPA1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 20:27:04 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36476 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731009AbfGPA1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 20:27:03 -0400
Received: by mail-pg1-f194.google.com with SMTP id l21so8507105pgm.3;
        Mon, 15 Jul 2019 17:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+/EwL7Q5l4U6k3tjN3kXQVZrpS1BmiE9Ulp1kUWWVbY=;
        b=V3gvjWUwOg9SJgtHTlKTfTEfp3hTtaAQ4t0ClckL6i3qOHuNmY/qaL7qAw5CeLykG1
         Nr0Q5g08kV/ADS7tAdUXNDr++P/sm7iDqe0dd4ZTdi8KxTGL6MVexQKqCCwkvRqKOzQ5
         072OtbUcl4uAnlCZXkfZrdK+EGUFuuj4k18Z461UTuJuMPYzIfWqPKjrm67B9MS7wQlu
         ZbBHQN0hAaagC55wLOONHHJhW4uF2b8Bq8tTCUGjkg6oJwauKaBiRFvNxBoS/yxhlAW8
         wX2x+BAf6z8IJPBJjWQZf2oGfnf2zM974u1kuLyK6dDpxXuPx0LxIpX3/eEeAyvq60mk
         AQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+/EwL7Q5l4U6k3tjN3kXQVZrpS1BmiE9Ulp1kUWWVbY=;
        b=ppp/1GymqKo6jyrttUVehtCfn4EoXpksVzv7clQqVJnOt6kW4jtNviwCjdfli1j078
         YS6xU1RrcdN5k0PSQldOS0kWkNeWaP2jcDhEGwLe/KuB6IJtCgFeL1WzoJzKJ1I0TOkT
         IJsJKQBn+R7NvYDkLAHvoX345ybKi/+EVDJp3rKW52azDrC79i9sgyo7SxJRY8C+zrvx
         OuWotqJ16FdmJ/zIohe9Mg0gJEE6iy3m0I/ZVWZViD0bBkEkMBWKMLWXAp1qtkqHe/EY
         sTj5dembaP1D31Z7YMbuezHSXGYJA+SrpTxMYMjJY+RBnQfS4LiGi/8aJd1LTHuBoOkG
         41Wg==
X-Gm-Message-State: APjAAAUbx0xY4POm2zCqL0KkTUvbvuDVh6h02tP+6/80hf3PJAfPmrsz
        QTNsKt/uzl7DHxW/vzysBQu4xbra
X-Google-Smtp-Source: APXvYqxOTUULmZglveq3jY9uKF++8mkrfvrgC3avQPcb1eF9LcT0kbSvS1v+qXAK83e1ZecRmREfWg==
X-Received: by 2002:a63:6904:: with SMTP id e4mr2507358pgc.321.1563236822388;
        Mon, 15 Jul 2019 17:27:02 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id q24sm16775444pjp.14.2019.07.15.17.27.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 17:27:02 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: [bpf-next RFC 3/6] bpf: add bpf_tcp_gen_syncookie helper
Date:   Mon, 15 Jul 2019 17:26:47 -0700
Message-Id: <20190716002650.154729-4-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
References: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov@google.com>

This helper function allows BPF programs to try to generate SYN
cookies, given a reference to a listener socket. The function works
from XDP and with an skb context since bpf_skc_lookup_tcp can lookup a
socket in both cases.

Signed-off-by: Petar Penkov <ppenkov@google.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
---
 include/uapi/linux/bpf.h | 30 ++++++++++++++++++-
 net/core/filter.c        | 62 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6f68438aa4ed..abf4a85c76d1 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2713,6 +2713,33 @@ union bpf_attr {
  *		**-EPERM** if no permission to send the *sig*.
  *
  *		**-EAGAIN** if bpf program can try again.
+ *
+ * s64 bpf_tcp_gen_syncookie(struct bpf_sock *sk, void *iph, u32 iph_len, struct tcphdr *th, u32 th_len)
+ *	Description
+ *		Try to issue a SYN cookie for the packet with corresponding
+ *		IP/TCP headers, *iph* and *th*, on the listening socket in *sk*.
+ *
+ *		*iph* points to the start of the IPv4 or IPv6 header, while
+ *		*iph_len* contains **sizeof**\ (**struct iphdr**) or
+ *		**sizeof**\ (**struct ip6hdr**).
+ *
+ *		*th* points to the start of the TCP header, while *th_len*
+ *		contains **sizeof**\ (**struct tcphdr**).
+ *
+ *	Return
+ *		On success, lower 32 bits hold the generated SYN cookie in
+ *		network order and the higher 32 bits hold the MSS value for that
+ *		cookie.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** SYN cookie cannot be issued due to error
+ *
+ *		**-ENOENT** SYN cookie should not be issued (no SYN flood)
+ *
+ *		**-ENOTSUPP** kernel configuration does not enable SYN cookies
+ *
+ *		**-EPROTONOSUPPORT** *sk* family is not AF_INET/AF_INET6
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2824,7 +2851,8 @@ union bpf_attr {
 	FN(strtoul),			\
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
-	FN(send_signal),
+	FN(send_signal),		\
+	FN(tcp_gen_syncookie),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/net/core/filter.c b/net/core/filter.c
index 47f6386fb17a..109fd1e286f4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5850,6 +5850,64 @@ static const struct bpf_func_proto bpf_tcp_check_syncookie_proto = {
 	.arg5_type	= ARG_CONST_SIZE,
 };
 
+BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
+	   struct tcphdr *, th, u32, th_len)
+{
+#ifdef CONFIG_SYN_COOKIES
+	u32 cookie;
+	u16 mss;
+
+	if (unlikely(th_len < sizeof(*th)))
+		return -EINVAL;
+
+	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
+		return -EINVAL;
+
+	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
+		return -EINVAL;
+
+	if (!th->syn || th->ack || th->fin || th->rst)
+		return -EINVAL;
+
+	switch (sk->sk_family) {
+	case AF_INET:
+		if (unlikely(iph_len < sizeof(struct iphdr)))
+			return -EINVAL;
+		mss = tcp_v4_get_syncookie(sk, iph, th, &cookie);
+		break;
+
+#if IS_BUILTIN(CONFIG_IPV6)
+	case AF_INET6:
+		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
+			return -EINVAL;
+		mss = tcp_v6_get_syncookie(sk, iph, th, &cookie);
+		break;
+#endif /* CONFIG_IPV6 */
+
+	default:
+		return -EPROTONOSUPPORT;
+	}
+	if (mss <= 0)
+		return -ENOENT;
+
+	return htonl(cookie) | ((u64)mss << 32);
+#else
+	return -ENOTSUPP;
+#endif /* CONFIG_SYN_COOKIES */
+}
+
+static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
+	.func		= bpf_tcp_gen_syncookie,
+	.gpl_only	= true, /* __cookie_v*_init_sequence() is GPL */
+	.pkt_access	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_SOCK_COMMON,
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_CONST_SIZE,
+	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg5_type	= ARG_CONST_SIZE,
+};
+
 #endif /* CONFIG_INET */
 
 bool bpf_helper_changes_pkt_data(void *func)
@@ -6135,6 +6193,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_tcp_check_syncookie_proto;
 	case BPF_FUNC_skb_ecn_set_ce:
 		return &bpf_skb_ecn_set_ce_proto;
+	case BPF_FUNC_tcp_gen_syncookie:
+		return &bpf_tcp_gen_syncookie_proto;
 #endif
 	default:
 		return bpf_base_func_proto(func_id);
@@ -6174,6 +6234,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_skc_lookup_tcp_proto;
 	case BPF_FUNC_tcp_check_syncookie:
 		return &bpf_tcp_check_syncookie_proto;
+	case BPF_FUNC_tcp_gen_syncookie:
+		return &bpf_tcp_gen_syncookie_proto;
 #endif
 	default:
 		return bpf_base_func_proto(func_id);
-- 
2.22.0.510.g264f2c817a-goog

