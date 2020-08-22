Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A8424E4D8
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 05:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgHVD3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 23:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgHVD3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 23:29:00 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71100C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 20:29:00 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id 93so3185997otx.2
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 20:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tfz-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Srj8tbi8H7OGKkWCBcz0qRrEm5Yx5d3t2AQ3ak3evYA=;
        b=2Lyb0jq0EUHVSngH1Jgs57MFEUXCjkTyCZYmA/Mq6Q5PzJG3k3zwIne2Bn1Fm3Wg8z
         QWB7Yjbam3SATZe09HufLiwfkWWwn+GOQLQ/nckR+fYiQEChFSaePUakWajxvxDvFLAW
         TNVCDXKEJrkNfeyFutBtcwtY/wbGHfmWGMXxQxpfal+ML9yd6kU3f5y7vH6ZW8QW9HZ5
         l7tscZ9+IlWgoDULVAK1d3GX56PVxKBPpxlu3yhmjEqp71Xm9FMf7tvTEQA+i8eqiZr9
         t5l+TACvzlxb8l39Ndm9X4V9qI+XIpgRLPVj0o2OY3FEAvYJzJ/cLV5v21h1XxFvqpYh
         C6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Srj8tbi8H7OGKkWCBcz0qRrEm5Yx5d3t2AQ3ak3evYA=;
        b=NNqKKlTJrBQppo8I6qWVyVOaFZ8Q/uKNnpGdn+JIwy/qURJKEWkkB4oy7EzQSbzap5
         vxNlWIGqwsmvqlVV6mIN1Ipv9mzPW5QFBSRMTfqC68JF1mwJQBlW53027TojuYT0pdz9
         nlMQR4YGPDRaLQFqqsgfmnDYl44m5XLYv29EuOltAozR11QEo34nj3dhdVE6HPzSPnkC
         SMIxfFbtr+yopV3UdJiRR9iPFG1IPsDalusYx2UBSGmENEkmOwJdc0BPFcaJTEEy2Gwi
         I3D0vX9cnPzTbeslRUoznwFO1LfrP/jSKvY2wyDiGPGsHKY6NZf6WTen4EwU946kzc7O
         Gl0w==
X-Gm-Message-State: AOAM531SsZRohN0i6M/daDq4AZxbXdZKfdDs2PtwdjgzewJAZmEOGjtO
        crW4bL9LKUoaAgv7QNyqMEGP7A==
X-Google-Smtp-Source: ABdhPJwCvl3/XYLcaof7B2pTpHrNxI1YrQ5c9MGqcVrOGRloh3fCOmo6o/J9AedLdYoRvMcyhKrSnw==
X-Received: by 2002:a05:6830:1e15:: with SMTP id s21mr4241022otr.204.1598066939731;
        Fri, 21 Aug 2020 20:28:59 -0700 (PDT)
Received: from foo.attlocal.net (108-232-117-128.lightspeed.sntcca.sbcglobal.net. [108.232.117.128])
        by smtp.gmail.com with ESMTPSA id o3sm829431oom.26.2020.08.21.20.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 20:28:59 -0700 (PDT)
From:   Pascal Bouchareine <kalou@tfz.net>
To:     linux-kernel@vger.kernel.org
Cc:     Pascal Bouchareine <kalou@tfz.net>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Alexey Dobriyan" <adobriyan@gmail.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>
Subject: [PATCH v2 2/2] net: socket: implement SO_DESCRIPTION
Date:   Fri, 21 Aug 2020 20:28:27 -0700
Message-Id: <20200822032827.6386-2-kalou@tfz.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200822032827.6386-1-kalou@tfz.net>
References: <20200815182344.7469-1-kalou@tfz.net>
 <20200822032827.6386-1-kalou@tfz.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This command attaches the zero terminated string in optval to the
socket for troubleshooting purposes. The free string is displayed in the
process fdinfo file for that fd (/proc/<pid>/fdinfo/<fd>).

One intended usage is to allow processes to self-document sockets
for netstat and friends to report

We ignore optlen and constrain the string to a static max size

Signed-off-by: Pascal Bouchareine <kalou@tfz.net>
---
 include/net/sock.h                |  4 +++
 include/uapi/asm-generic/socket.h |  2 ++
 net/core/sock.c                   | 53 +++++++++++++++++++++++++++++++
 net/socket.c                      |  5 +++
 4 files changed, 64 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 1183507df95b..6b4fd1383282 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -342,6 +342,7 @@ struct bpf_sk_storage;
   *	@sk_txtime_deadline_mode: set deadline mode for SO_TXTIME
   *	@sk_txtime_report_errors: set report errors mode for SO_TXTIME
   *	@sk_txtime_unused: unused txtime flags
+  *	@sk_description: user supplied with SO_DESCRIPTION
   */
 struct sock {
 	/*
@@ -519,6 +520,9 @@ struct sock {
 	struct bpf_sk_storage __rcu	*sk_bpf_storage;
 #endif
 	struct rcu_head		sk_rcu;
+
+#define	SK_MAX_DESC_SIZE	256
+	char			*sk_description;
 };
 
 enum sk_pacing {
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 77f7c1638eb1..fb51c4bb7a12 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -119,6 +119,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 68
 
+#define SO_DESCRIPTION		69
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/core/sock.c b/net/core/sock.c
index 2e5b7870e5d3..b8bad57338d8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -828,6 +828,49 @@ void sock_set_rcvbuf(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(sock_set_rcvbuf);
 
+static int sock_set_description(struct sock *sk, char __user *user_desc)
+{
+	char *old, *desc;
+
+	desc = strndup_user(user_desc, SK_MAX_DESC_SIZE, GFP_KERNEL_ACCOUNT);
+	if (IS_ERR(desc))
+		return PTR_ERR(desc);
+
+	lock_sock(sk);
+	old = sk->sk_description;
+	sk->sk_description = desc;
+	release_sock(sk);
+
+	kfree(old);
+
+	return 0;
+}
+
+static int sock_get_description(struct sock *sk, char __user *optval,
+				int __user *optlen, int len)
+{
+	char desc[SK_MAX_DESC_SIZE];
+
+	lock_sock(sk);
+	if (sk->sk_description) {
+		/* strndup_user: len(desc + nul) <= SK_MAX_DESC_SIZE */
+		len = min_t(unsigned int, len,
+			    strlen(sk->sk_description) + 1);
+		memcpy(desc, sk->sk_description, len);
+	} else {
+		len = 0;
+	}
+	release_sock(sk);
+
+	if (copy_to_user(optval, desc, len))
+		return -EFAULT;
+
+	if (put_user(len, optlen))
+		return -EFAULT;
+
+	return 0;
+}
+
 /*
  *	This is meant for all protocols to use and covers goings on
  *	at the socket level. Everything here is generic.
@@ -850,6 +893,9 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 	if (optname == SO_BINDTODEVICE)
 		return sock_setbindtodevice(sk, optval, optlen);
 
+	if (optname == SO_DESCRIPTION)
+		return sock_set_description(sk, optval);
+
 	if (optlen < sizeof(int))
 		return -EINVAL;
 
@@ -1614,6 +1660,9 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		v.val = sk->sk_bound_dev_if;
 		break;
 
+	case SO_DESCRIPTION:
+		return sock_get_description(sk, optval, optlen, len);
+
 	default:
 		/* We implement the SO_SNDLOWAT etc to not be settable
 		 * (1003.1g 7).
@@ -1792,6 +1841,8 @@ static void __sk_destruct(struct rcu_head *head)
 		RCU_INIT_POINTER(sk->sk_filter, NULL);
 	}
 
+	kfree(sk->sk_description);
+
 	sock_disable_timestamp(sk, SK_FLAGS_TIMESTAMP);
 
 #ifdef CONFIG_BPF_SYSCALL
@@ -1964,6 +2015,8 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 		if (sk_user_data_is_nocopy(newsk))
 			newsk->sk_user_data = NULL;
 
+		newsk->sk_description = NULL;
+
 		newsk->sk_err	   = 0;
 		newsk->sk_err_soft = 0;
 		newsk->sk_priority = 0;
diff --git a/net/socket.c b/net/socket.c
index 976426d03f09..4f2c1a7744b0 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -134,6 +134,11 @@ static void sock_show_fdinfo(struct seq_file *m, struct file *f)
 {
 	struct socket *sock = f->private_data;
 
+	lock_sock(sock->sk);
+	if (sock->sk->sk_description)
+		seq_printf(m, "desc:\t%s\n", sock->sk->sk_description);
+	release_sock(sock->sk);
+
 	if (sock->ops->show_fdinfo)
 		sock->ops->show_fdinfo(m, sock);
 }
-- 
2.25.1

