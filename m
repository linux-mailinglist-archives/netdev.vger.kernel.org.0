Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9864D6BD090
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 14:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjCPNRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 09:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjCPNRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 09:17:03 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58302C97C8
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 06:16:54 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0702641BA7
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 13:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678972613;
        bh=+MIwejgyU+YIhZQN55WZnro6zd2U2nJ4DbEoCPMF/b4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=XO8j34CAGoJ6GcjerA8biqJmw4t8YKYt3jiBrKERp04dYQVtKKQOHiUktTCs5KUxG
         yLKjBgljZY4n4caOQRHY3W+t2ccSO0auv88fbFzCbW/rT63E1HCbH4HrtWWxOhm1NH
         XMXZgR909sKaaa+/ratk0fNZhgK8YyRwkO3T/RNK9myK56I/e6POOwGQg+p/DkSp4o
         ffqijZdPNg6DxCf+pf0UuaTyS8RvMXKRaqgwxWJ0srbBmCp/58UD7zSbHKbKWJ6lPk
         VyK/Rr8BTnEdHltKrZKtSH8x8SAARgiGd5WeV7ZmdglkdLQvoObnyHbj3ja+g3Y9nh
         gPyWmipO6Yr/A==
Received: by mail-ed1-f71.google.com with SMTP id en6-20020a056402528600b004fa01232e6aso3004459edb.16
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 06:16:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678972612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+MIwejgyU+YIhZQN55WZnro6zd2U2nJ4DbEoCPMF/b4=;
        b=7mk9dRJ+/qwYO6NvWZB9X+0GmXn+Yy07/kW4+rjNIEthDiX/6iQmFJ9hMfLt2/YiQS
         ft0EGfY/nbUiU20cFcLN1s8Q8kIGdLSun0wE0gCjUAwPiWWVEA/AG6NpS4GXX7ALK/sQ
         6F29X08jIDWubpgpia9oaRxJxwxJJGJz3mecHtWUDIiZAhi60J9VHROplL08igJM29Sx
         2Ubn1/3AA89f6fEfjuGnIvCiY3Td2ziIkFHB3Es+42FWnkJFnE7phOpqVqRHkovQO/ES
         miQUO+nBQNzzpX20BACYfNQvz6FsPcMLJhzth8g8Jrmhm6CPQvT2UfrQq19eINtpr+VP
         J4bw==
X-Gm-Message-State: AO0yUKW+d6agvVnvPW/4kp08JBOd8wJCTliqbQ2BIOhMLTb4173uDlbb
        TNzAiWCQdhWhEIEY7+W/CSlh9IgGsnRb26looLqApg2y2QXphTod6i9PtwxLXVztV06PLmVUH0d
        Yw6KVtulzU32OoiJXuEmx+W4CdlYnxxB2JA==
X-Received: by 2002:a17:906:f1c6:b0:930:f953:9614 with SMTP id gx6-20020a170906f1c600b00930f9539614mr939661ejb.1.1678972611971;
        Thu, 16 Mar 2023 06:16:51 -0700 (PDT)
X-Google-Smtp-Source: AK7set8V/lOFb1LgYVO3ll64397gV8ZXvwX4voI0tL/mZcT6K9s4xeIFhKK6sp9zDKsHJ9HGiBEUBA==
X-Received: by 2002:a17:906:f1c6:b0:930:f953:9614 with SMTP id gx6-20020a170906f1c600b00930f9539614mr939646ejb.1.1678972611709;
        Thu, 16 Mar 2023 06:16:51 -0700 (PDT)
Received: from amikhalitsyn.. ([2a02:8109:bd40:1414:5e7c:880e:420d:8cc7])
        by smtp.gmail.com with ESMTPSA id d20-20020a50cd54000000b004fd1ee3f723sm3812336edj.67.2023.03.16.06.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 06:16:51 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <brauner@kernel.org>,
        linux-arch@vger.kernel.org
Subject: [PATCH net-next 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Date:   Thu, 16 Mar 2023 14:15:24 +0100
Message-Id: <20230316131526.283569-2-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316131526.283569-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230316131526.283569-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENTIALS,
but it contains pidfd instead of plain pid, which allows programmers not
to care about PID reuse problem.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 arch/alpha/include/uapi/asm/socket.h    |  2 ++
 arch/mips/include/uapi/asm/socket.h     |  2 ++
 arch/parisc/include/uapi/asm/socket.h   |  2 ++
 arch/sparc/include/uapi/asm/socket.h    |  2 ++
 include/linux/net.h                     |  1 +
 include/linux/socket.h                  |  1 +
 include/net/scm.h                       | 16 +++++++++++++++-
 include/uapi/asm-generic/socket.h       |  2 ++
 net/core/sock.c                         | 11 +++++++++++
 net/mptcp/sockopt.c                     |  1 +
 net/unix/af_unix.c                      | 18 +++++++++++++-----
 tools/include/uapi/asm-generic/socket.h |  2 ++
 12 files changed, 54 insertions(+), 6 deletions(-)

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
index 585adc1346bd..4617fbc65294 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -124,7 +124,9 @@ static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
 				struct scm_cookie *scm, int flags)
 {
 	if (!msg->msg_control) {
-		if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp ||
+		if (test_bit(SOCK_PASSCRED, &sock->flags) ||
+		    test_bit(SOCK_PASSPIDFD, &sock->flags) ||
+		    scm->fp ||
 		    scm_has_secdata(sock))
 			msg->msg_flags |= MSG_CTRUNC;
 		scm_destroy(scm);
@@ -141,6 +143,18 @@ static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
 		put_cmsg(msg, SOL_SOCKET, SCM_CREDENTIALS, sizeof(ucreds), &ucreds);
 	}
 
+	if (test_bit(SOCK_PASSPIDFD, &sock->flags)) {
+		int pidfd;
+
+		if (WARN_ON_ONCE(!scm->pid) ||
+		    !pid_has_task(scm->pid, PIDTYPE_TGID))
+			pidfd = -ESRCH;
+		else
+			pidfd = pidfd_create(scm->pid, 0);
+
+		put_cmsg(msg, SOL_SOCKET, SCM_PIDFD, sizeof(int), &pidfd);
+	}
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
index c25888795390..3f974246ba3e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1246,6 +1246,13 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 			clear_bit(SOCK_PASSCRED, &sock->flags);
 		break;
 
+	case SO_PASSPIDFD:
+		if (valbool)
+			set_bit(SOCK_PASSPIDFD, &sock->flags);
+		else
+			clear_bit(SOCK_PASSPIDFD, &sock->flags);
+		break;
+
 	case SO_TIMESTAMP_OLD:
 	case SO_TIMESTAMP_NEW:
 	case SO_TIMESTAMPNS_OLD:
@@ -1737,6 +1744,10 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 		v.val = !!test_bit(SOCK_PASSCRED, &sock->flags);
 		break;
 
+	case SO_PASSPIDFD:
+		v.val = !!test_bit(SOCK_PASSPIDFD, &sock->flags);
+		break;
+
 	case SO_PEERCRED:
 	{
 		struct ucred peercred;
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 8a9656248b0f..bd80e707d0b3 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -355,6 +355,7 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 	case SO_BROADCAST:
 	case SO_BSDCOMPAT:
 	case SO_PASSCRED:
+	case SO_PASSPIDFD:
 	case SO_PASSSEC:
 	case SO_RXQ_OVFL:
 	case SO_WIFI_STATUS:
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 0b0f18ecce44..b0ac768752fa 100644
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

