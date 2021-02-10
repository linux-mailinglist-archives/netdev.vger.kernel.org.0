Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F48316630
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhBJMMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbhBJMKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:10:05 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7E9C0611BC
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 04:04:39 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id f16so1607174wmq.5
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 04:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7YlFkcwEzuK8xj1bqWFb4J+pbM9jNy7GJX0y3deB8As=;
        b=syPwiZlFCfO6MHc40aH33LzcMM6KfDmzRv+D2pLSH5QhqhfJeAI8pcSdpGXIuefrhT
         QANrLqzWqVKdKDRMI9LkGu7/nHBiH+rC1ieNTWfFHSmkspO5VBaxfKVXb2X2Squ8dPwc
         gqbcZAWKlW0ioCr6UjiF2eRNBO1Q7kMUruhv0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7YlFkcwEzuK8xj1bqWFb4J+pbM9jNy7GJX0y3deB8As=;
        b=LoKyqW0VGHBO0mrcrsZfCURj94HLS1nVpfkSgstUC3hXNnH1RJ2GTye7BU43cPTEjm
         oaLe/0mXVSrZe+nqPB5ihYBlk0kbisubxiAqAvpvAnpRBmomR2poTnoiaHW0r7w2Ei5a
         CKgCQaZu3xlBMpaYYYmAaN/rgqSk1WzWN5riolDIVNMJocdp9MrpybXgOgZssYs1cT3P
         Xamz/j1B56KI0516osaBz+NojjCZgp/PkBlkWDrtaA6ADtQ6cFA1f/93gML/1L7XfZFc
         cMdOWUvwpJrSKpvIXZnqYBFPDDIheJOLpNqV/xhPZltasJgmKHi+81dBPfOAMdDeHVQR
         apEw==
X-Gm-Message-State: AOAM530Kgu3bgTEv5Nw5YSZZLiQAEBe9PyvrP1lCgaQ+kMwTspgQnpw0
        ZeMVtuG9YSyJ++Y7qEhCgHH1ZA==
X-Google-Smtp-Source: ABdhPJzWH8Tw+178GsaKwHlgz0XiwPg9erze0gT5N1I/sfwQGjRhxr9XRlOCiSD9NdzdTDxtpCscUA==
X-Received: by 2002:a1c:f70c:: with SMTP id v12mr2614677wmh.77.1612958678358;
        Wed, 10 Feb 2021 04:04:38 -0800 (PST)
Received: from antares.lan (c.3.c.9.d.d.c.e.0.a.6.8.a.9.e.c.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:ce9a:86a0:ecdd:9c3c])
        by smtp.gmail.com with ESMTPSA id j7sm2837854wrp.72.2021.02.10.04.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 04:04:38 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-api@vger.kernel.org, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf 1/4] net: add SO_NETNS_COOKIE socket option
Date:   Wed, 10 Feb 2021 12:04:22 +0000
Message-Id: <20210210120425.53438-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210210120425.53438-1-lmb@cloudflare.com>
References: <20210210120425.53438-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to distinguish which network namespace a socket belongs to.
BPF has the useful bpf_get_netns_cookie helper for this, but accessing
it from user space isn't possible. Add a read-only socket option that
returns the netns cookie, similar to SO_COOKIE. If network namespaces
are disabled, SO_NETNS_COOKIE returns the cookie of init_net.

The BPF helpers change slightly: instead of returning 0 when network
namespaces are disabled we return the init_net cookie as for the
socket option.

Cc: linux-api@vger.kernel.org
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 arch/alpha/include/uapi/asm/socket.h  |  2 ++
 arch/mips/include/uapi/asm/socket.h   |  2 ++
 arch/parisc/include/uapi/asm/socket.h |  2 ++
 arch/sparc/include/uapi/asm/socket.h  |  2 ++
 include/linux/sock_diag.h             | 20 ++++++++++++++++++++
 include/uapi/asm-generic/socket.h     |  2 ++
 net/core/filter.c                     |  9 ++++-----
 net/core/sock.c                       |  7 +++++++
 8 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index 57420356ce4c..6b3daba60987 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -127,6 +127,8 @@
 #define SO_PREFER_BUSY_POLL	69
 #define SO_BUSY_POLL_BUDGET	70
 
+#define SO_NETNS_COOKIE		71
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index 2d949969313b..cdf404a831b2 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -138,6 +138,8 @@
 #define SO_PREFER_BUSY_POLL	69
 #define SO_BUSY_POLL_BUDGET	70
 
+#define SO_NETNS_COOKIE		71
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index f60904329bbc..5b5351cdcb33 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -119,6 +119,8 @@
 #define SO_PREFER_BUSY_POLL	0x4043
 #define SO_BUSY_POLL_BUDGET	0x4044
 
+#define SO_NETNS_COOKIE		0x4045
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 848a22fbac20..ff79db753dce 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -120,6 +120,8 @@
 #define SO_PREFER_BUSY_POLL	 0x0048
 #define SO_BUSY_POLL_BUDGET	 0x0049
 
+#define SO_NETNS_COOKIE		 0x004a
+
 #if !defined(__KERNEL__)
 
 
diff --git a/include/linux/sock_diag.h b/include/linux/sock_diag.h
index 0b9ecd8cf979..6e88436097b1 100644
--- a/include/linux/sock_diag.h
+++ b/include/linux/sock_diag.h
@@ -38,6 +38,26 @@ static inline u64 sock_gen_cookie(struct sock *sk)
 	return cookie;
 }
 
+static inline u64 __sock_gen_netns_cookie(struct sock *sk)
+{
+#ifdef CONFIG_NET_NS
+	return __net_gen_cookie(sk->sk_net.net);
+#else
+	return __net_gen_cookie(&init_net);
+#endif
+}
+
+static inline u64 sock_gen_netns_cookie(struct sock *sk)
+{
+	u64 cookie;
+
+	preempt_disable();
+	cookie = __sock_gen_netns_cookie(sk);
+	preempt_enable();
+
+	return cookie;
+}
+
 int sock_diag_check_cookie(struct sock *sk, const __u32 *cookie);
 void sock_diag_save_cookie(struct sock *sk, __u32 *cookie);
 
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 4dcd13d097a9..d588c244ec2f 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -122,6 +122,8 @@
 #define SO_PREFER_BUSY_POLL	69
 #define SO_BUSY_POLL_BUDGET	70
 
+#define SO_NETNS_COOKIE		71
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/core/filter.c b/net/core/filter.c
index e15d4741719a..51f47b6913f1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4645,11 +4645,10 @@ static const struct bpf_func_proto bpf_get_socket_cookie_sock_ops_proto = {
 
 static u64 __bpf_get_netns_cookie(struct sock *sk)
 {
-#ifdef CONFIG_NET_NS
-	return __net_gen_cookie(sk ? sk->sk_net.net : &init_net);
-#else
-	return 0;
-#endif
+	if (sk)
+		return __sock_gen_netns_cookie(sk);
+
+	return __net_gen_cookie(&init_net);
 }
 
 BPF_CALL_1(bpf_get_netns_cookie_sock, struct sock *, ctx)
diff --git a/net/core/sock.c b/net/core/sock.c
index bbcd4b97eddd..2db201c210ca 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1606,6 +1606,13 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		v.val = sk->sk_bound_dev_if;
 		break;
 
+	case SO_NETNS_COOKIE:
+		lv = sizeof(u64);
+		if (len < lv)
+			return -EINVAL;
+		v.val64 = sock_gen_netns_cookie(sk);
+		break;
+
 	default:
 		/* We implement the SO_SNDLOWAT etc to not be settable
 		 * (1003.1g 7).
-- 
2.27.0

