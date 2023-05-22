Return-Path: <netdev+bounces-4306-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF83370BFA8
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:25:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E29D4280FA4
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:25:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B8B13AFB;
	Mon, 22 May 2023 13:25:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5164313AE2
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:25:02 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F71C109
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 06:24:58 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 11E553F4B8
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1684761896;
	bh=KOvUpcYIwOTb1H7aXEj0fzqsyKzkQwsjr6beMckrdbc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=ICib93FtISiic5tx18LJHoAkqW2KBKqRLoLtOGyGKRLdJxQiXvan3g2O7zkxDJmHt
	 pJ/JPdv+tgN3Ij+noaHr1vo06EHOXw8yxdlYQm/9xzsalGrNhxXMw21F4/1+nWBwxS
	 BOzEXp3ZfEICq639DKk4BkIarMgAt3m7rvdbEUWCDIQ3s2rEWcRC6Tyx0JH8V/0URG
	 Wdt814iXDfFvewwJXveFC3FdaNCotCM3sJoWXB/2isCBZx24+v7UXnnZmJpUv+KW8Q
	 KDVX0qfxcgCDzEdVlo1J6UJVv6JZAsnirofVClad/Iu4yKnTacdwP5bHcn54/dp06h
	 GZH/uMTEo+yfw==
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5128dcbdfc1so1870950a12.1
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 06:24:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684761893; x=1687353893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KOvUpcYIwOTb1H7aXEj0fzqsyKzkQwsjr6beMckrdbc=;
        b=ZAPAfPnmGAsLlwyVkDGyEp4M1L8XiVcE8ET/yZTpVXPjRIw9rCpakE5j+qKZgyXBIQ
         YEDGVhKq+yRqnlisXkpE3dYJECsimDiyvyalHIbvn3R1gRPRQ1C5cgJqdFIgqXqwYSdT
         aT+ovSscKmBdWZ6roR+PtkXsW8U8XLkJIJjBpOlWwI2hrZkcrPipR24uJxwMzheQfjKG
         QNWR1WQjtSwnSSVX2nNo3SNSAu/kRVezZUFhPBKbKojtEu7Wwo0v/y7jWuteyeIajBQU
         8qZUIJ7KuhgforPQytVLo6aYp/S27V2x8fRGIRk3dFU03HEkAmyxHcUatEsc/Ux2be/2
         n+2w==
X-Gm-Message-State: AC+VfDzNQjJ9SPOz/N69JMU5O22Klq97CqKHT0p+BIUaU3MkRZzNmO+y
	NJwCb2JbWjqEozP5SlIUPlPk9Uhvi6v3OmAT02Y+FCq0R+sXSJSeN+DNKKSDTEemoqUa4FzFgrL
	kdBLw17VMCdEPveCnMUfAhhYvlls8XKyE1Q==
X-Received: by 2002:a17:907:d402:b0:96f:4225:cf46 with SMTP id vi2-20020a170907d40200b0096f4225cf46mr8656524ejc.76.1684761892776;
        Mon, 22 May 2023 06:24:52 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4vrb4/DpGOWWcOEmeIgOy/i+L1gEMNOM6tGZsXVhCMYh9UsqzgFYQa3UTLjoVjc44/k3LO0g==
X-Received: by 2002:a17:907:d402:b0:96f:4225:cf46 with SMTP id vi2-20020a170907d40200b0096f4225cf46mr8656491ejc.76.1684761892397;
        Mon, 22 May 2023 06:24:52 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-074-206-207.088.074.pools.vodafone-ip.de. [88.74.206.207])
        by smtp.gmail.com with ESMTPSA id p16-20020a1709060dd000b0094f698073e0sm3044509eji.123.2023.05.22.06.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 06:24:52 -0700 (PDT)
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
	linux-arch@vger.kernel.org
Subject: [PATCH net-next v6 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Date: Mon, 22 May 2023 15:24:37 +0200
Message-Id: <20230522132439.634031-2-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230522132439.634031-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230522132439.634031-1-aleksandr.mikhalitsyn@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENTIALS,
but it contains pidfd instead of plain pid, which allows programmers not
to care about PID reuse problem.

We mask SO_PASSPIDFD feature if CONFIG_UNIX is not builtin because
it depends on a pidfd_prepare() API which is not exported to the kernel
modules.

Idea comes from UAPI kernel group:
https://uapi-group.org/kernel-features/

Big thanks to Christian Brauner and Lennart Poettering for productive
discussions about this.

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
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Tested-by: Luca Boccassi <bluca@debian.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
v6:
	- disable feature when CONFIG_UNIX=n/m (pidfd_prepare API is not exported to modules)
v5:
	- no changes
v4:
	- fixed silent fd_install if writting of CMSG to the userspace fails (pointed by Christian)
v2:
	According to review comments from Kuniyuki Iwashima and Christian Brauner:
	- use pidfd_create(..) retval as a result
	- whitespace change
---
 arch/alpha/include/uapi/asm/socket.h    |  2 ++
 arch/mips/include/uapi/asm/socket.h     |  2 ++
 arch/parisc/include/uapi/asm/socket.h   |  2 ++
 arch/sparc/include/uapi/asm/socket.h    |  2 ++
 include/linux/net.h                     |  1 +
 include/linux/socket.h                  |  1 +
 include/net/scm.h                       | 43 +++++++++++++++++++++++--
 include/uapi/asm-generic/socket.h       |  2 ++
 net/core/sock.c                         | 15 +++++++++
 net/mptcp/sockopt.c                     |  3 ++
 net/unix/af_unix.c                      | 18 ++++++++---
 tools/include/uapi/asm-generic/socket.h |  2 ++
 12 files changed, 86 insertions(+), 7 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index 739891b94136..ff310613ae64 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -137,6 +137,8 @@
 
 #define SO_RCVMARK		75
 
+#define SO_PASSPIDFD		76
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index 18f3d95ecfec..762dcb80e4ec 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -148,6 +148,8 @@
 
 #define SO_RCVMARK		75
 
+#define SO_PASSPIDFD		76
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index f486d3dfb6bb..df16a3e16d64 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -129,6 +129,8 @@
 
 #define SO_RCVMARK		0x4049
 
+#define SO_PASSPIDFD		0x404A
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 2fda57a3ea86..6e2847804fea 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -130,6 +130,8 @@
 
 #define SO_RCVMARK               0x0054
 
+#define SO_PASSPIDFD             0x0055
+
 #if !defined(__KERNEL__)
 
 
diff --git a/include/linux/net.h b/include/linux/net.h
index b73ad8e3c212..c234dfbe7a30 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -43,6 +43,7 @@ struct net;
 #define SOCK_PASSSEC		4
 #define SOCK_SUPPORT_ZC		5
 #define SOCK_CUSTOM_SOCKOPT	6
+#define SOCK_PASSPIDFD		7
 
 #ifndef ARCH_HAS_SOCKET_TYPES
 /**
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 13c3a237b9c9..6bf90f251910 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -177,6 +177,7 @@ static inline size_t msg_data_left(struct msghdr *msg)
 #define	SCM_RIGHTS	0x01		/* rw: access rights (array of int) */
 #define SCM_CREDENTIALS 0x02		/* rw: struct ucred		*/
 #define SCM_SECURITY	0x03		/* rw: security label		*/
+#define SCM_PIDFD	0x04		/* ro: pidfd (int)		*/
 
 struct ucred {
 	__u32	pid;
diff --git a/include/net/scm.h b/include/net/scm.h
index 585adc1346bd..13b188422370 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -120,12 +120,46 @@ static inline bool scm_has_secdata(struct socket *sock)
 }
 #endif /* CONFIG_SECURITY_NETWORK */
 
+#if IS_BUILTIN(CONFIG_UNIX)
+static __inline__ void scm_pidfd_recv(struct msghdr *msg, struct scm_cookie *scm)
+{
+	struct file *pidfd_file = NULL;
+	int pidfd;
+
+	/*
+	 * put_cmsg() doesn't return an error if CMSG is truncated,
+	 * that's why we need to opencode these checks here.
+	 */
+	if ((msg->msg_controllen <= sizeof(struct cmsghdr)) ||
+	    (msg->msg_controllen - sizeof(struct cmsghdr)) < sizeof(int)) {
+		msg->msg_flags |= MSG_CTRUNC;
+		return;
+	}
+
+	WARN_ON_ONCE(!scm->pid);
+	pidfd = pidfd_prepare(scm->pid, 0, &pidfd_file);
+
+	if (put_cmsg(msg, SOL_SOCKET, SCM_PIDFD, sizeof(int), &pidfd)) {
+		if (pidfd_file) {
+			put_unused_fd(pidfd);
+			fput(pidfd_file);
+		}
+
+		return;
+	}
+
+	if (pidfd_file)
+		fd_install(pidfd, pidfd_file);
+}
+#endif
+
 static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
 				struct scm_cookie *scm, int flags)
 {
 	if (!msg->msg_control) {
-		if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp ||
-		    scm_has_secdata(sock))
+		if (test_bit(SOCK_PASSCRED, &sock->flags) ||
+		    test_bit(SOCK_PASSPIDFD, &sock->flags) ||
+		    scm->fp || scm_has_secdata(sock))
 			msg->msg_flags |= MSG_CTRUNC;
 		scm_destroy(scm);
 		return;
@@ -141,6 +175,11 @@ static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
 		put_cmsg(msg, SOL_SOCKET, SCM_CREDENTIALS, sizeof(ucreds), &ucreds);
 	}
 
+#if IS_BUILTIN(CONFIG_UNIX)
+	if (test_bit(SOCK_PASSPIDFD, &sock->flags))
+		scm_pidfd_recv(msg, scm);
+#endif
+
 	scm_destroy_cred(scm);
 
 	scm_passec(sock, msg, scm);
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 638230899e98..b76169fdb80b 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -132,6 +132,8 @@
 
 #define SO_RCVMARK		75
 
+#define SO_PASSPIDFD		76
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/core/sock.c b/net/core/sock.c
index 5440e67bcfe3..f6c415ef151f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1246,6 +1246,15 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 			clear_bit(SOCK_PASSCRED, &sock->flags);
 		break;
 
+#if IS_BUILTIN(CONFIG_UNIX)
+	case SO_PASSPIDFD:
+		if (valbool)
+			set_bit(SOCK_PASSPIDFD, &sock->flags);
+		else
+			clear_bit(SOCK_PASSPIDFD, &sock->flags);
+		break;
+#endif
+
 	case SO_TIMESTAMP_OLD:
 	case SO_TIMESTAMP_NEW:
 	case SO_TIMESTAMPNS_OLD:
@@ -1732,6 +1741,12 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 		v.val = !!test_bit(SOCK_PASSCRED, &sock->flags);
 		break;
 
+#if IS_BUILTIN(CONFIG_UNIX)
+	case SO_PASSPIDFD:
+		v.val = !!test_bit(SOCK_PASSPIDFD, &sock->flags);
+		break;
+#endif
+
 	case SO_PEERCRED:
 	{
 		struct ucred peercred;
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index d4258869ac48..5a80eb23089f 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -355,6 +355,9 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 	case SO_BROADCAST:
 	case SO_BSDCOMPAT:
 	case SO_PASSCRED:
+#if IS_BUILTIN(CONFIG_UNIX)
+	case SO_PASSPIDFD:
+#endif
 	case SO_PASSSEC:
 	case SO_RXQ_OVFL:
 	case SO_WIFI_STATUS:
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index cc695c9f09ec..aac40106d036 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1361,7 +1361,8 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		if (err)
 			goto out;
 
-		if (test_bit(SOCK_PASSCRED, &sock->flags) &&
+		if ((test_bit(SOCK_PASSCRED, &sock->flags) ||
+		     test_bit(SOCK_PASSPIDFD, &sock->flags)) &&
 		    !unix_sk(sk)->addr) {
 			err = unix_autobind(sk);
 			if (err)
@@ -1469,7 +1470,8 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	if (err)
 		goto out;
 
-	if (test_bit(SOCK_PASSCRED, &sock->flags) && !u->addr) {
+	if ((test_bit(SOCK_PASSCRED, &sock->flags) ||
+	     test_bit(SOCK_PASSPIDFD, &sock->flags)) && !u->addr) {
 		err = unix_autobind(sk);
 		if (err)
 			goto out;
@@ -1670,6 +1672,8 @@ static void unix_sock_inherit_flags(const struct socket *old,
 {
 	if (test_bit(SOCK_PASSCRED, &old->flags))
 		set_bit(SOCK_PASSCRED, &new->flags);
+	if (test_bit(SOCK_PASSPIDFD, &old->flags))
+		set_bit(SOCK_PASSPIDFD, &new->flags);
 	if (test_bit(SOCK_PASSSEC, &old->flags))
 		set_bit(SOCK_PASSSEC, &new->flags);
 }
@@ -1819,8 +1823,10 @@ static bool unix_passcred_enabled(const struct socket *sock,
 				  const struct sock *other)
 {
 	return test_bit(SOCK_PASSCRED, &sock->flags) ||
+	       test_bit(SOCK_PASSPIDFD, &sock->flags) ||
 	       !other->sk_socket ||
-	       test_bit(SOCK_PASSCRED, &other->sk_socket->flags);
+	       test_bit(SOCK_PASSCRED, &other->sk_socket->flags) ||
+	       test_bit(SOCK_PASSPIDFD, &other->sk_socket->flags);
 }
 
 /*
@@ -1922,7 +1928,8 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			goto out;
 	}
 
-	if (test_bit(SOCK_PASSCRED, &sock->flags) && !u->addr) {
+	if ((test_bit(SOCK_PASSCRED, &sock->flags) ||
+	     test_bit(SOCK_PASSPIDFD, &sock->flags)) && !u->addr) {
 		err = unix_autobind(sk);
 		if (err)
 			goto out;
@@ -2824,7 +2831,8 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 			/* Never glue messages from different writers */
 			if (!unix_skb_scm_eq(skb, &scm))
 				break;
-		} else if (test_bit(SOCK_PASSCRED, &sock->flags)) {
+		} else if (test_bit(SOCK_PASSCRED, &sock->flags) ||
+			   test_bit(SOCK_PASSPIDFD, &sock->flags)) {
 			/* Copy credentials */
 			scm_set_cred(&scm, UNIXCB(skb).pid, UNIXCB(skb).uid, UNIXCB(skb).gid);
 			unix_set_secdata(&scm, skb);
diff --git a/tools/include/uapi/asm-generic/socket.h b/tools/include/uapi/asm-generic/socket.h
index 8756df13be50..fbbc4bf53ee3 100644
--- a/tools/include/uapi/asm-generic/socket.h
+++ b/tools/include/uapi/asm-generic/socket.h
@@ -121,6 +121,8 @@
 
 #define SO_RCVMARK		75
 
+#define SO_PASSPIDFD		76
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
-- 
2.34.1


