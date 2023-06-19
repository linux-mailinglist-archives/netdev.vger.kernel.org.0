Return-Path: <netdev+bounces-11938-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90B5573559F
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:20:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48961281090
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F3AFD2EB;
	Mon, 19 Jun 2023 11:20:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5894DC8FA
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:20:42 +0000 (UTC)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B6510D;
	Mon, 19 Jun 2023 04:20:40 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-3f9b4a71623so1072165e9.1;
        Mon, 19 Jun 2023 04:20:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687173638; x=1689765638;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Va7bmTpXEF7kF/mIDW6B8d70UteckeUeSftDVahsY0I=;
        b=cazi9S/tVmHDQsWEwbgbA9z2pkNZmAPnCFSY5wfQkZ+A/u0bmOdsdRFfFNFqXuPnm8
         zOqP39fkeA3z/5K3gckhCJi785IthdrYlFVY7xxVLczifQlEfuYyrh7mQm77KK9o2Ts1
         Kl7lJ1RYeC53ei3WiaJ4g0csF5aUm75pFGmQtB+h2c9lIY+0cvwvnJTf7g2vKZbnTTHs
         7LoHC44eYPayDaUDuZMu5hvIRkSM3jE+/3YFOZBSWFzYEGfNfDuYaQmwbmELaQQhw4lx
         eRDM77fHqDLVotthbsKGdm67pHwk+QOalABNMpNExoNFM6c4gH0lBpuJYluaKWx5xRTN
         tB+g==
X-Gm-Message-State: AC+VfDx14IyL9RmgH5dBOIMbatLM3pWS5ujX7Ome5a2A9OQGUdNfk6YL
	C5mnIftFk+GQMYWj9NqaVWQ=
X-Google-Smtp-Source: ACHHUZ6hdDYUpXeGyIWG6UjBJm7SOFcN3Rivf6hlZLxAWGgGCDsK4MN5FPswBCDiYPPxKQdP0rbWSQ==
X-Received: by 2002:a7b:ce92:0:b0:3f9:acc:bd16 with SMTP id q18-20020a7bce92000000b003f90accbd16mr2750261wmj.7.1687173638191;
        Mon, 19 Jun 2023 04:20:38 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-007.fbsv.net. [2a03:2880:31ff:7::face:b00c])
        by smtp.gmail.com with ESMTPSA id i17-20020a5d6311000000b0030fae360f14sm25790141wru.68.2023.06.19.04.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 04:20:37 -0700 (PDT)
Date: Mon, 19 Jun 2023 04:20:35 -0700
From: Breno Leitao <leitao@debian.org>
To: axboe@kernel.dk, dsahern@kernel.org, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Mat Martineau <martineau@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>, leit@fb.com,
	asml.silence@gmail.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, dccp@vger.kernel.org,
	mptcp@lists.linux.dev, linux-sctp@vger.kernel.org, ast@kernel.org,
	kuniyu@amazon.com, martin.lau@kernel.org,
	Jason Xing <kernelxing@tencent.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Willem de Bruijn <willemb@google.com>,
	Guillaume Nault <gnault@redhat.com>,
	Andrea Righi <andrea.righi@canonical.com>
Subject: Re: [RFC PATCH v2 1/4] net: wire up support for
 file_operations->uring_cmd()
Message-ID: <ZJA6AwbRWtSiJ5pL@gmail.com>
References: <20230614110757.3689731-1-leitao@debian.org>
 <20230614110757.3689731-2-leitao@debian.org>
 <6b5e5988-3dc7-f5d6-e447-397696c0d533@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b5e5988-3dc7-f5d6-e447-397696c0d533@kernel.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 08:15:10AM -0700, David Ahern wrote:
> On 6/14/23 5:07 AM, Breno Leitao wrote:
> io_uring is just another in-kernel user of sockets. There is no reason
> for io_uring references to be in core net code. It should be using
> exposed in-kernel APIs and doing any translation of its op codes in
> io_uring/  code.

Thanks for the feedback. If we want to keep the network subsystem
untouched, then I we can do it using an approach similar to the
following. Is this a better approach moving forward?

--

From: Breno Leitao <leitao@debian.org>
Date: Mon, 19 Jun 2023 03:37:40 -0700
Subject: [RFC PATCH v2] io_uring: add initial io_uring_cmd support for sockets

Enable io_uring command operations on sockets. Create two
SOCKET_URING_OP commands that will operate on sockets.

For that, use the file_operations->uring_cmd callback, and map it to a
uring socket callback, which handles the SOCKET_URING_OP accordingly.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/io_uring.h      |  6 ++++++
 include/uapi/linux/io_uring.h |  8 ++++++++
 io_uring/uring_cmd.c          | 27 +++++++++++++++++++++++++++
 net/socket.c                  |  2 ++
 4 files changed, 43 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 7fe31b2cd02f..d1b20e2a9fb0 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -71,6 +71,7 @@ static inline void io_uring_free(struct task_struct *tsk)
 	if (tsk->io_uring)
 		__io_uring_free(tsk);
 }
+int uring_sock_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 #else
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
@@ -102,6 +103,11 @@ static inline const char *io_uring_get_opcode(u8 opcode)
 {
 	return "";
 }
+static inline int uring_sock_cmd(struct io_uring_cmd *cmd,
+				 unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #endif
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 0716cb17e436..d93a5ee7d984 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -703,6 +703,14 @@ struct io_uring_recvmsg_out {
 	__u32 flags;
 };
 
+/*
+ * Argument for IORING_OP_URING_CMD when file is a socket
+ */
+enum {
+	SOCKET_URING_OP_SIOCINQ         = 0,
+	SOCKET_URING_OP_SIOCOUTQ,
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 5e32db48696d..dcbe6493b03f 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -7,6 +7,7 @@
 #include <linux/nospec.h>
 
 #include <uapi/linux/io_uring.h>
+#include <uapi/asm-generic/ioctls.h>
 
 #include "io_uring.h"
 #include "rsrc.h"
@@ -156,3 +157,29 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 	return io_import_fixed(rw, iter, req->imu, ubuf, len);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
+
+int uring_sock_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	struct socket *sock = cmd->file->private_data;
+	struct sock *sk = sock->sk;
+	int ret, arg = 0;
+
+	if (!sk->sk_prot || !sk->sk_prot->ioctl)
+		return -EOPNOTSUPP;
+
+	switch (cmd->sqe->cmd_op) {
+	case SOCKET_URING_OP_SIOCINQ:
+		ret = sk->sk_prot->ioctl(sk, SIOCINQ, &arg);
+		if (ret)
+			return ret;
+		return arg;
+	case SOCKET_URING_OP_SIOCOUTQ:
+		ret = sk->sk_prot->ioctl(sk, SIOCOUTQ, &arg);
+		if (ret)
+			return ret;
+		return arg;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL_GPL(uring_sock_cmd);
diff --git a/net/socket.c b/net/socket.c
index b778fc03c6e0..db11e94d2259 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -88,6 +88,7 @@
 #include <linux/xattr.h>
 #include <linux/nospec.h>
 #include <linux/indirect_call_wrapper.h>
+#include <linux/io_uring.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -159,6 +160,7 @@ static const struct file_operations socket_file_ops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = compat_sock_ioctl,
 #endif
+	.uring_cmd =    uring_sock_cmd,
 	.mmap =		sock_mmap,
 	.release =	sock_close,
 	.fasync =	sock_fasync,
-- 
2.34.1


