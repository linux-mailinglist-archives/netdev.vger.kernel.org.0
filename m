Return-Path: <netdev+bounces-10679-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 975C372FC01
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:10:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 313652813D5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 771867471;
	Wed, 14 Jun 2023 11:10:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AFF6FD4
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:10:27 +0000 (UTC)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3521BE5;
	Wed, 14 Jun 2023 04:10:23 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-3f8d2bfec3bso5959605e9.2;
        Wed, 14 Jun 2023 04:10:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686741021; x=1689333021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=juIju8Gf3A46+CsReLgCfla8sOnVETZd+YXsqjZzcXQ=;
        b=auRXcSVKt0SVqJNfm5V4LCEGGrMXp3YbhBRGdoD1rErCHSpeoMYXmbpwKOg6G9qL/3
         IiSKMsj0QYxGRZBsllP82Z3a8+PqV1DdVHAf6UFXC5cbLvlyujrgmAViBpsyn5zttln4
         bUa4W2oZsC2/soYVc+iD5m/VGHMGC/LzL/XbWPAVB6Ud4qN6yF3pyJa7dfQBgGYLgIF5
         z8PcUJ/7rh79AUknfoy1/1rYqdxRZ7VIajOQtaDNZzq5KHK905Psv8GhFe1nkhbpJ7oh
         Sa/Hl8QBldkiEB1KwqCBRpIfNlf32QBYKSLARdIi2AmouQcA1NpJ6ZgO3fMpUJIkqbs4
         66QQ==
X-Gm-Message-State: AC+VfDxTdpKpMik3ZRVjywjMFffA1eTwBVV86tn6dgWo9+TlD0BCtAyV
	8+Hhsg1pDKIhbNa0yCh1IShIDYzXdp5YBQ==
X-Google-Smtp-Source: ACHHUZ4O36eoKja4SGdzkaczjnszz7xgxsq8Ao2I6+BBLvIXJTShxELd4LyxvaCzCynxLenmv+kYGg==
X-Received: by 2002:a1c:4b0f:0:b0:3f5:6e5:1689 with SMTP id y15-20020a1c4b0f000000b003f506e51689mr12910729wma.17.1686741020904;
        Wed, 14 Jun 2023 04:10:20 -0700 (PDT)
Received: from localhost (fwdproxy-cln-002.fbsv.net. [2a03:2880:31ff:2::face:b00c])
        by smtp.gmail.com with ESMTPSA id n5-20020a7bcbc5000000b003f7eafe9d76sm17244524wmi.37.2023.06.14.04.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 04:10:20 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	David Ahern <dsahern@kernel.org>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Mat Martineau <martineau@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: leit@fb.com,
	asml.silence@gmail.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dccp@vger.kernel.org,
	mptcp@lists.linux.dev,
	linux-sctp@vger.kernel.org,
	ast@kernel.org,
	kuniyu@amazon.com,
	martin.lau@kernel.org,
	Jason Xing <kernelxing@tencent.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Willem de Bruijn <willemb@google.com>,
	Guillaume Nault <gnault@redhat.com>,
	Andrea Righi <andrea.righi@canonical.com>
Subject: [RFC PATCH v2 1/4] net: wire up support for file_operations->uring_cmd()
Date: Wed, 14 Jun 2023 04:07:54 -0700
Message-Id: <20230614110757.3689731-2-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230614110757.3689731-1-leitao@debian.org>
References: <20230614110757.3689731-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Create the initial plumbing to call protocol specific uring_cmd
callbacks. These are io_uring specific callbacks that implement
ioctl-like operation types, such as SIOCINQ, SIOCOUTQ and others.

In order to achieve this, create uring_cmd callback placeholders in
file_ops, proto and proto_ops structures.

Create also the functions that does the plumbing from io_uring_cmd() up
to sk_proto->uring_cmd(). If the callback is not implemented,
-EOPNOTSUPP is returned.

That way, the io_uring issue path calls file_operations->uring_cmd
(sock_uring_cmd()).  This function calls proto_ops->uring_cmd
(sock_common_uring_cmd()). sock_common_uring_cmd() is responsible for
calling protocol specific (struct proto_ops) uring_cmd callback
(sock_common_uring_cmd()). sock_common_uring_cmd() then calls the proto
specific (struct proto) uring_cmd function, which are implemented in the
upcoming patch.

By the end, uring_cmd() function has access to  'struct io_uring_cmd'
which points to the whole SQE, and any field could be accessed from the
function pointer.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/net.h  |  2 ++
 include/net/sock.h   |  6 ++++++
 net/core/sock.c      | 17 +++++++++++++++--
 net/dccp/ipv4.c      |  1 +
 net/ipv4/af_inet.c   |  3 +++
 net/l2tp/l2tp_ip.c   |  1 +
 net/mptcp/protocol.c |  1 +
 net/sctp/protocol.c  |  1 +
 net/socket.c         | 13 +++++++++++++
 9 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 8defc8f1d82e..58dea87077af 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -182,6 +182,8 @@ struct proto_ops {
 	int	 	(*compat_ioctl) (struct socket *sock, unsigned int cmd,
 				      unsigned long arg);
 #endif
+	int		(*uring_cmd)(struct socket *sock, struct io_uring_cmd *cmd,
+				     unsigned int issue_flags);
 	int		(*gettstamp) (struct socket *sock, void __user *userstamp,
 				      bool timeval, bool time32);
 	int		(*listen)    (struct socket *sock, int len);
diff --git a/include/net/sock.h b/include/net/sock.h
index 62a1b99da349..a49b8b19292b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -111,6 +111,7 @@ typedef struct {
 struct sock;
 struct proto;
 struct net;
+struct io_uring_cmd;
 
 typedef __u32 __bitwise __portpair;
 typedef __u64 __bitwise __addrpair;
@@ -1259,6 +1260,9 @@ struct proto {
 
 	int			(*ioctl)(struct sock *sk, int cmd,
 					 int *karg);
+	int			(*uring_cmd)(struct sock *sk,
+					     struct io_uring_cmd *cmd,
+					     unsigned int issue_flags);
 	int			(*init)(struct sock *sk);
 	void			(*destroy)(struct sock *sk);
 	void			(*shutdown)(struct sock *sk, int how);
@@ -1934,6 +1938,8 @@ int sock_common_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			int flags);
 int sock_common_setsockopt(struct socket *sock, int level, int optname,
 			   sockptr_t optval, unsigned int optlen);
+int sock_common_uring_cmd(struct socket *sock, struct io_uring_cmd *cmd,
+			  unsigned int issue_flags);
 
 void sk_common_release(struct sock *sk);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 1df7e432fec5..339fa74db60f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3668,6 +3668,18 @@ int sock_common_setsockopt(struct socket *sock, int level, int optname,
 }
 EXPORT_SYMBOL(sock_common_setsockopt);
 
+int sock_common_uring_cmd(struct socket *sock, struct io_uring_cmd *cmd,
+			  unsigned int issue_flags)
+{
+	struct sock *sk = sock->sk;
+
+	if (!sk->sk_prot || !sk->sk_prot->uring_cmd)
+		return -EOPNOTSUPP;
+
+	return sk->sk_prot->uring_cmd(sk, cmd, issue_flags);
+}
+EXPORT_SYMBOL(sock_common_uring_cmd);
+
 void sk_common_release(struct sock *sk)
 {
 	if (sk->sk_prot->destroy)
@@ -4008,7 +4020,7 @@ static void proto_seq_printf(struct seq_file *seq, struct proto *proto)
 {
 
 	seq_printf(seq, "%-9s %4u %6d  %6ld   %-3s %6u   %-3s  %-10s "
-			"%2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c\n",
+			"%2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c\n",
 		   proto->name,
 		   proto->obj_size,
 		   sock_prot_inuse_get(seq_file_net(seq), proto),
@@ -4022,6 +4034,7 @@ static void proto_seq_printf(struct seq_file *seq, struct proto *proto)
 		   proto_method_implemented(proto->disconnect),
 		   proto_method_implemented(proto->accept),
 		   proto_method_implemented(proto->ioctl),
+		   proto_method_implemented(proto->uring_cmd),
 		   proto_method_implemented(proto->init),
 		   proto_method_implemented(proto->destroy),
 		   proto_method_implemented(proto->shutdown),
@@ -4050,7 +4063,7 @@ static int proto_seq_show(struct seq_file *seq, void *v)
 			   "maxhdr",
 			   "slab",
 			   "module",
-			   "cl co di ac io in de sh ss gs se re sp bi br ha uh gp em\n");
+			   "cl co di ac io ur in de sh ss gs se re sp bi br ha uh gp em\n");
 	else
 		proto_seq_printf(seq, list_entry(v, struct proto, node));
 	return 0;
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 3ab68415d121..1baad5ff402e 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -1001,6 +1001,7 @@ static const struct proto_ops inet_dccp_ops = {
 	/* FIXME: work on tcp_poll to rename it to inet_csk_poll */
 	.poll		   = dccp_poll,
 	.ioctl		   = inet_ioctl,
+	.uring_cmd	   = sock_common_uring_cmd,
 	.gettstamp	   = sock_gettstamp,
 	/* FIXME: work on inet_listen to rename it to sock_common_listen */
 	.listen		   = inet_dccp_listen,
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 9cd48df6a331..2947d4dd4922 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1055,6 +1055,7 @@ const struct proto_ops inet_stream_ops = {
 	.getname	   = inet_getname,
 	.poll		   = tcp_poll,
 	.ioctl		   = inet_ioctl,
+	.uring_cmd	   = sock_common_uring_cmd,
 	.gettstamp	   = sock_gettstamp,
 	.listen		   = inet_listen,
 	.shutdown	   = inet_shutdown,
@@ -1091,6 +1092,7 @@ const struct proto_ops inet_dgram_ops = {
 	.getname	   = inet_getname,
 	.poll		   = udp_poll,
 	.ioctl		   = inet_ioctl,
+	.uring_cmd	   = sock_common_uring_cmd,
 	.gettstamp	   = sock_gettstamp,
 	.listen		   = sock_no_listen,
 	.shutdown	   = inet_shutdown,
@@ -1124,6 +1126,7 @@ static const struct proto_ops inet_sockraw_ops = {
 	.getname	   = inet_getname,
 	.poll		   = datagram_poll,
 	.ioctl		   = inet_ioctl,
+	.uring_cmd	   = sock_common_uring_cmd,
 	.gettstamp	   = sock_gettstamp,
 	.listen		   = sock_no_listen,
 	.shutdown	   = inet_shutdown,
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 2b795c1064f5..3540e01455f7 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -616,6 +616,7 @@ static const struct proto_ops l2tp_ip_ops = {
 	.getname	   = l2tp_ip_getname,
 	.poll		   = datagram_poll,
 	.ioctl		   = inet_ioctl,
+	.uring_cmd	   = sock_common_uring_cmd,
 	.gettstamp	   = sock_gettstamp,
 	.listen		   = sock_no_listen,
 	.shutdown	   = inet_shutdown,
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 992b89c75631..444dacb9d804 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3883,6 +3883,7 @@ static const struct proto_ops mptcp_stream_ops = {
 	.getname	   = inet_getname,
 	.poll		   = mptcp_poll,
 	.ioctl		   = inet_ioctl,
+	.uring_cmd	   = sock_common_uring_cmd,
 	.gettstamp	   = sock_gettstamp,
 	.listen		   = mptcp_listen,
 	.shutdown	   = inet_shutdown,
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 664d1f2e9121..32b1a87d958a 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1125,6 +1125,7 @@ static const struct proto_ops inet_seqpacket_ops = {
 	.getname	   = inet_getname,	/* Semantics are different.  */
 	.poll		   = sctp_poll,
 	.ioctl		   = inet_ioctl,
+	.uring_cmd	   = sock_common_uring_cmd,
 	.gettstamp	   = sock_gettstamp,
 	.listen		   = sctp_inet_listen,
 	.shutdown	   = inet_shutdown,	/* Looks harmless.  */
diff --git a/net/socket.c b/net/socket.c
index b778fc03c6e0..44cf9841af44 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -88,6 +88,7 @@
 #include <linux/xattr.h>
 #include <linux/nospec.h>
 #include <linux/indirect_call_wrapper.h>
+#include <linux/io_uring.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -117,6 +118,7 @@ unsigned int sysctl_net_busy_poll __read_mostly;
 static ssize_t sock_read_iter(struct kiocb *iocb, struct iov_iter *to);
 static ssize_t sock_write_iter(struct kiocb *iocb, struct iov_iter *from);
 static int sock_mmap(struct file *file, struct vm_area_struct *vma);
+static int sock_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 
 static int sock_close(struct inode *inode, struct file *file);
 static __poll_t sock_poll(struct file *file,
@@ -159,6 +161,7 @@ static const struct file_operations socket_file_ops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = compat_sock_ioctl,
 #endif
+	.uring_cmd =	sock_uring_cmd,
 	.mmap =		sock_mmap,
 	.release =	sock_close,
 	.fasync =	sock_fasync,
@@ -1309,6 +1312,16 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	return err;
 }
 
+static int sock_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	struct socket *sock = cmd->file->private_data;
+
+	if (!sock->ops || !sock->ops->uring_cmd)
+		return -EOPNOTSUPP;
+
+	return sock->ops->uring_cmd(sock, cmd, issue_flags);
+}
+
 /**
  *	sock_create_lite - creates a socket
  *	@family: protocol family (AF_INET, ...)
-- 
2.34.1


