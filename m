Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE582452E5
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 23:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgHOV4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 17:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729038AbgHOVwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:52:14 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791A0C004588
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 11:24:08 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id c4so10204518otf.12
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 11:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tfz-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Npmo1qy1EtVMY1f22f/XoQlkfS4jbAFUtpYwb+UPN9s=;
        b=UGhjOy6sny6yVuAYdTV7QBCsVIFSkm8sA3y/SwYBtDKROYWCu7teCOiIZNIbFqbCYc
         ExIJMnNURR2y62RErP89vr5vRlyCI26hAxWcIRy+YJupCpNAWZwAPEF0bvbN7jlfrNBW
         Z6XL/zXinZFM3jz26fjeTSDd5bpJjvs/+j1Wxbfowb0CHENC0egNjqh/Gl2vPvf5J5ti
         NYw9sRYdgG4Sm5vsHkdc0KonY3R8qwZLxvgscFYM88L8Wg+IO7UcFJd/T7ItwLGOEzEH
         n+YiJzdL+FBqViqWHvhlG20hAgDcQPgR3M6n3cgCQkXAdj4ed4Zuo02mdBGxq+kcLpfX
         Jr+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Npmo1qy1EtVMY1f22f/XoQlkfS4jbAFUtpYwb+UPN9s=;
        b=c3UPTeGvE9keat+/Sray7EO0Qs7Qy0MsDwhT5tw3D49Du7IHNgqNXq/yRqpAPd3cQD
         OB+sz6h9GbBN00ksKG2uXlhTyNEBRfPpJbUiC6+ViLfg5XllCSem9nXQjVU2yJUUqeN8
         +fTWiuNyXGmE5kQEJOzwcgfIrTuejC9uLqARZxMOYqFThBG3MKUIjQv5yN7CycJI8xeG
         HDvkdF18BGxEU4a2ooIvYUxhTvzLustMt0csqrbrp9cYveAKw+p87zWQaDlGLg8VHuvB
         UN+1dNCMpDWVMEy1APYwIaoir/ocO7ZrsNAY1cxN3/Lhn92REUcRAyr+qIqqh3vMviPh
         6BRQ==
X-Gm-Message-State: AOAM532zTySnvrfKZ5Vx9UWPBzw8aGUMzIDLZr6Ih+AFXAiG6pFgzDSS
        /iJiCAAndia+OFIoKQFMBvXlIg==
X-Google-Smtp-Source: ABdhPJy7YkkteM56EdGdHCXuWzaeZe6zD/figZlqTYdO0AG60UZFeFBumOA4ui2QoHa8visqRWX4FA==
X-Received: by 2002:a05:6830:605:: with SMTP id w5mr5942549oti.3.1597515847051;
        Sat, 15 Aug 2020 11:24:07 -0700 (PDT)
Received: from foo.attlocal.net (108-232-117-128.lightspeed.sntcca.sbcglobal.net. [108.232.117.128])
        by smtp.gmail.com with ESMTPSA id z72sm2397820ooa.42.2020.08.15.11.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2020 11:24:06 -0700 (PDT)
From:   Pascal Bouchareine <kalou@tfz.net>
To:     linux-kernel@vger.kernel.org
Cc:     Pascal Bouchareine <kalou@tfz.net>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Alexey Dobriyan" <adobriyan@gmail.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/2] net: socket: implement SO_DESCRIPTION
Date:   Sat, 15 Aug 2020 11:23:44 -0700
Message-Id: <20200815182344.7469-3-kalou@tfz.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200815182344.7469-1-kalou@tfz.net>
References: <20200815182344.7469-1-kalou@tfz.net>
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
 include/net/sock.h                |  4 ++++
 include/uapi/asm-generic/socket.h |  2 ++
 net/core/sock.c                   | 23 +++++++++++++++++++++++
 net/socket.c                      |  5 +++++
 4 files changed, 34 insertions(+)

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
index 2e5b7870e5d3..2cb44a0e38b7 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -828,6 +828,24 @@ void sock_set_rcvbuf(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(sock_set_rcvbuf);
 
+int sock_set_description(struct sock *sk, char __user *user_desc)
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
 /*
  *	This is meant for all protocols to use and covers goings on
  *	at the socket level. Everything here is generic.
@@ -850,6 +868,9 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 	if (optname == SO_BINDTODEVICE)
 		return sock_setbindtodevice(sk, optval, optlen);
 
+	if (optname == SO_DESCRIPTION)
+		return sock_set_description(sk, optval);
+
 	if (optlen < sizeof(int))
 		return -EINVAL;
 
@@ -1792,6 +1813,8 @@ static void __sk_destruct(struct rcu_head *head)
 		RCU_INIT_POINTER(sk->sk_filter, NULL);
 	}
 
+	kfree(sk->sk_description);
+
 	sock_disable_timestamp(sk, SK_FLAGS_TIMESTAMP);
 
 #ifdef CONFIG_BPF_SYSCALL
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

