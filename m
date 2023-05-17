Return-Path: <netdev+bounces-3322-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA92E7066D5
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:35:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B49E81C20B6D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1A4F2C74E;
	Wed, 17 May 2023 11:34:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0BB211C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:34:33 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937735253
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:34:24 -0700 (PDT)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A44823F235
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1684323262;
	bh=OF0SbgroQXegOKfgupip9FcKY0xyGooQ7mZBIpRXr2I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=btiiQf3VeTcvM7Oxna8mTH9DPK362+SQveBrNGqvuk/UPPPWgBWxfjYuLqcZbNGBs
	 wyaErld5EydO6S1nSaFWHqSvgwNtEQ/HkWoTPomYGsATBLM2EuYBaYt4SYUvImxedd
	 SmCx9MaJtKrHviWLxox3qzJzCuDJn/aNvSr+NGx6mdzR1ZDnt4YrNxFviR5Uoxs1dO
	 gcrR9ZqpOa2ODRRgu6UvWeC/nythot+vUw/nGm4EW8J/9FzSLYErdjFeoqOFPscx2D
	 Rj0ecqJMEGwo+ZsFPWJhLjcV8n2MCRDfIDqIcV243ZoRIDWjAao++H+B8+tvW4RE9E
	 25fVJrVMIDIIQ==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-94a341ee4fcso93228866b.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:34:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684323262; x=1686915262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OF0SbgroQXegOKfgupip9FcKY0xyGooQ7mZBIpRXr2I=;
        b=EgDo419AcE1I8J1aedhCITLaIpulzDCQTioPHg21s3v8G3oN9FEDpYhPzouycLBKfX
         dHYUw1VlAeWdGxCSV5MnFfI3hdeGZryI23lzpgwWvNEoRuPbPKaqhEkP+dyd1TwZXpKa
         N6aeCGQqq78OYfcZrq6ujlVKuQkpkaYdXRr3N/szjzvcyRRI+UzBgDpTUJI09GW6DVwS
         s8G1/goLbOsd8zSyJA0FuRC2eQfuX9EbRrBKteVcWOTtcPWF8lCssJfstLRuFqyen8hl
         MFaA43UbnTImE7+3y9MUAtKkBFeMVGrM0hO6H22DuhySViIe95tbhz05k0NzqJAbXgEA
         07xg==
X-Gm-Message-State: AC+VfDwKH04vbmzwZe4ZrkkPZyV2dBJSLgvLFgDBMhAaCy6dqJRYmJC+
	m1SVvdyFLqQ/I5iUVh6zsjEm5mBrBXHF3SqihxNaJd/w3ylOF3PM7ffUeb31MohF4uzXh7sUlOy
	UNPcm13nNhQwNMBtkitR4o7Pctq0X2zOKCw==
X-Received: by 2002:a17:906:fe0c:b0:961:78c2:1d27 with SMTP id wy12-20020a170906fe0c00b0096178c21d27mr37193284ejb.19.1684323262508;
        Wed, 17 May 2023 04:34:22 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5oaroDw85VzG/pU4SUbjJEcgfdT/j5LQHlcj2YN8ZfOrg6vuuELp+7nKe+6/jTWxHXiSs1Jw==
X-Received: by 2002:a17:906:fe0c:b0:961:78c2:1d27 with SMTP id wy12-20020a170906fe0c00b0096178c21d27mr37193272ejb.19.1684323262253;
        Wed, 17 May 2023 04:34:22 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-074-206-207.088.074.pools.vodafone-ip.de. [88.74.206.207])
        by smtp.gmail.com with ESMTPSA id p1-20020a170906838100b009662b4230cesm12404387ejx.148.2023.05.17.04.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:34:21 -0700 (PDT)
From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <keescook@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Luca Boccassi <bluca@debian.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stanislav Fomichev <sdf@google.com>,
	bpf@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [PATCH net-next v5 2/3] net: core: add getsockopt SO_PEERPIDFD
Date: Wed, 17 May 2023 13:33:50 +0200
Message-Id: <20230517113351.308771-3-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517113351.308771-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230517113351.308771-1-aleksandr.mikhalitsyn@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add SO_PEERPIDFD which allows to get pidfd of peer socket holder pidfd.
This thing is direct analog of SO_PEERCRED which allows to get plain PID.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Cc: Luca Boccassi <bluca@debian.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Tested-by: Luca Boccassi <bluca@debian.org>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
v5:
	- started using (struct proto)->bpf_bypass_getsockopt hook
v4:
	- return -ESRCH if sk->sk_peer_pid is NULL from getsockopt() syscall
	- return errors from pidfd_prepare() as it is from getsockopt() syscall
v3:
	- fixed possible fd leak (thanks to Christian Brauner)
v2:
	According to review comments from Kuniyuki Iwashima and Christian Brauner:
	- use pidfd_create(..) retval as a result
	- whitespace change
---
 arch/alpha/include/uapi/asm/socket.h    |  1 +
 arch/mips/include/uapi/asm/socket.h     |  1 +
 arch/parisc/include/uapi/asm/socket.h   |  1 +
 arch/sparc/include/uapi/asm/socket.h    |  1 +
 include/uapi/asm-generic/socket.h       |  1 +
 net/core/sock.c                         | 33 +++++++++++++++++++++++++
 net/unix/af_unix.c                      | 16 ++++++++++++
 tools/include/uapi/asm-generic/socket.h |  1 +
 8 files changed, 55 insertions(+)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index ff310613ae64..e94f621903fe 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -138,6 +138,7 @@
 #define SO_RCVMARK		75
 
 #define SO_PASSPIDFD		76
+#define SO_PEERPIDFD		77
 
 #if !defined(__KERNEL__)
 
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index 762dcb80e4ec..60ebaed28a4c 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -149,6 +149,7 @@
 #define SO_RCVMARK		75
 
 #define SO_PASSPIDFD		76
+#define SO_PEERPIDFD		77
 
 #if !defined(__KERNEL__)
 
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index df16a3e16d64..be264c2b1a11 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -130,6 +130,7 @@
 #define SO_RCVMARK		0x4049
 
 #define SO_PASSPIDFD		0x404A
+#define SO_PEERPIDFD		0x404B
 
 #if !defined(__KERNEL__)
 
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 6e2847804fea..682da3714686 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -131,6 +131,7 @@
 #define SO_RCVMARK               0x0054
 
 #define SO_PASSPIDFD             0x0055
+#define SO_PEERPIDFD             0x0056
 
 #if !defined(__KERNEL__)
 
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index b76169fdb80b..8ce8a39a1e5f 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -133,6 +133,7 @@
 #define SO_RCVMARK		75
 
 #define SO_PASSPIDFD		76
+#define SO_PEERPIDFD		77
 
 #if !defined(__KERNEL__)
 
diff --git a/net/core/sock.c b/net/core/sock.c
index bb1e3f7dba79..3d3f30436dbf 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1758,6 +1758,39 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 		goto lenout;
 	}
 
+	case SO_PEERPIDFD:
+	{
+		struct pid *peer_pid;
+		struct file *pidfd_file = NULL;
+		int pidfd;
+
+		if (len > sizeof(pidfd))
+			len = sizeof(pidfd);
+
+		spin_lock(&sk->sk_peer_lock);
+		peer_pid = get_pid(sk->sk_peer_pid);
+		spin_unlock(&sk->sk_peer_lock);
+
+		if (!peer_pid)
+			return -ESRCH;
+
+		pidfd = pidfd_prepare(peer_pid, 0, &pidfd_file);
+		put_pid(peer_pid);
+		if (pidfd < 0)
+			return pidfd;
+
+		if (copy_to_sockptr(optval, &pidfd, len) ||
+		    copy_to_sockptr(optlen, &len, sizeof(int))) {
+			put_unused_fd(pidfd);
+			fput(pidfd_file);
+
+			return -EFAULT;
+		}
+
+		fd_install(pidfd, pidfd_file);
+		return 0;
+	}
+
 	case SO_PEERGROUPS:
 	{
 		const struct cred *cred;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index aac40106d036..ea24843fb017 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -921,11 +921,26 @@ static void unix_unhash(struct sock *sk)
 	 */
 }
 
+static bool unix_bpf_bypass_getsockopt(int level, int optname)
+{
+	if (level == SOL_SOCKET) {
+		switch (optname) {
+		case SO_PEERPIDFD:
+			return true;
+		default:
+			return false;
+		}
+	}
+
+	return false;
+}
+
 struct proto unix_dgram_proto = {
 	.name			= "UNIX",
 	.owner			= THIS_MODULE,
 	.obj_size		= sizeof(struct unix_sock),
 	.close			= unix_close,
+	.bpf_bypass_getsockopt	= unix_bpf_bypass_getsockopt,
 #ifdef CONFIG_BPF_SYSCALL
 	.psock_update_sk_prot	= unix_dgram_bpf_update_proto,
 #endif
@@ -937,6 +952,7 @@ struct proto unix_stream_proto = {
 	.obj_size		= sizeof(struct unix_sock),
 	.close			= unix_close,
 	.unhash			= unix_unhash,
+	.bpf_bypass_getsockopt	= unix_bpf_bypass_getsockopt,
 #ifdef CONFIG_BPF_SYSCALL
 	.psock_update_sk_prot	= unix_stream_bpf_update_proto,
 #endif
diff --git a/tools/include/uapi/asm-generic/socket.h b/tools/include/uapi/asm-generic/socket.h
index fbbc4bf53ee3..54d9c8bf7c55 100644
--- a/tools/include/uapi/asm-generic/socket.h
+++ b/tools/include/uapi/asm-generic/socket.h
@@ -122,6 +122,7 @@
 #define SO_RCVMARK		75
 
 #define SO_PASSPIDFD		76
+#define SO_PEERPIDFD		77
 
 #if !defined(__KERNEL__)
 
-- 
2.34.1


