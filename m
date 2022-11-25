Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE22639179
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 23:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiKYWba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 17:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiKYWbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 17:31:03 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8700558032
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:30:34 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id m19so6813566edj.8
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9FW1FPeLZx4mDcycLi1OiKzB79mBTY0nX1izjOvx9Nc=;
        b=8tSprGLZ8nCj3kaBjQQcHtEI/jJAfe8hfnr+qrlgBPsAn2tXDIcCbfcMyZHkQRO/Ne
         rf0c/a8cph7AYSBG2EdzrlfVbcMyBkumiUw8ljPnzn3+7x/RmseIOMOhREa7vDXd+lO6
         dIDUfEBW76Fi3a02PZhEwELv+9UO+S7dupup+7iVIE3CQudKJH0DMOas8Stew/zTUyLI
         EDnPymooraXi5sHrKe7LxiSBIWQU14XuCbpIv1HnV4/TUgAdV5eAcuBf7ZUYCSD72A/S
         bIWVoXvmHg6ULtMO9td8teCtDdqxwMslAEwtoFabUJTiAwfpzAONUYof/h+7BSxZ3sDM
         UsJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9FW1FPeLZx4mDcycLi1OiKzB79mBTY0nX1izjOvx9Nc=;
        b=qHGmwD1wkXfhLFUWTI7vtecQ9PbHOXPGl5kSptpoURhH9HvLKz3g4Nz+YUN4g/JDEm
         z25wefnlN7mQ4W+yARlZkJqBr0017tki+IqJoUTpuMGFtoWTPLLzC16y4H8CyzAx5s0l
         eq6+ZDBkkMRC7WBc1iY16q/ILMq2GkZqeEM9TVMu4iCaQ4XXSiDxZ0q1Rc0c4UnKagU9
         uHvxvD9pmh20AZR4/AqVA94OlpepRYuVkeApgc6X6hzRC9uE9Rhmo57jY25wOO0bYfMY
         nHIFtOk++pXum+wrZNKijIy6uXm980dK353+qYlLsVpRW8oPijhZxMQxhYd9hUfUKDmD
         gwUQ==
X-Gm-Message-State: ANoB5pnSNq/saBSNb5mIuFcAbxe7pTggk6YJ5sThD4WvAb4FX9sGSUA/
        6YlusC4DckRuzDMBsRhXvAfqLg==
X-Google-Smtp-Source: AA0mqf7bJILODfW27tRke1a0d0aPcu9kTJ8afB3UT0aTdRF2Ljoz4EQqJGD1N0FJMJxSYByaHSi39g==
X-Received: by 2002:a05:6402:ea0:b0:463:a83c:e019 with SMTP id h32-20020a0564020ea000b00463a83ce019mr20782813eda.253.1669415432901;
        Fri, 25 Nov 2022 14:30:32 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id q1-20020a056402248100b0046267f8150csm2254612eda.19.2022.11.25.14.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 14:30:32 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     Dmytro Shytyi <dmytro@shytyi.net>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 8/8] selftests: mptcp: mptfo Initiator/Listener
Date:   Fri, 25 Nov 2022 23:29:54 +0100
Message-Id: <20221125222958.958636-9-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221125222958.958636-1-matthieu.baerts@tessares.net>
References: <20221125222958.958636-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=13376; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=/yNrNZcdW7bNIcSFQjgLzGv5H2U4OMElFjPASvCJmLg=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjgUHQEWiDtRCFe+QHpCjVwW+BaTtDLjIGTeMP0jyN
 qOX0wvmJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4FB0AAKCRD2t4JPQmmgcxauEA
 DtDSvYnW8cVflXM4b5GHzHSRoYiscvMk54R/UToyGKqw/W7K0jJmt3CFEXjU3557D86eLdWee69v/2
 unV7zfWcxGLK76dNjGpsnyxxqP8Ji3NUTGSUgxwI7+DOkdrFSQ1vq97+Vrxd6hAqRZ9dMsnSDCbDA4
 nfmRXesJa817IBuRkOoM0Q3Q/rUE+nmMUrOKEygxkObZzUi8aY3Cyq3q6gAcAzEfHP5NoH39/kCZ4d
 xam9EnxdOCzHgPe3st6b+ZwBwcOamCfW6ARibftEZYi30rJFPzl1XqQfILu81qgOkEClZH80nvl6bb
 ivH+1YHSVXIGDJLslYsdUwAreIakL8cEA0NwGIRRydMc8sXYOZVzeYoFrtSHU9L7R7oaa8hKbjawt5
 hpvkrXNaSglIwXqHF39ZOkaY2lBshEyoO7k6to3ielVrudRBqmDKuukdwcYW2vaXWAFKk6Yq3GOJeh
 7jXmzJYU/Aa5uKd0uOrAJu2i4fWQ/NKaw4BLVpp2BkqSv/wzZ2qBj+BCSzkCDDDO6xRD7kfLpR2+SQ
 cfg+dIWTzuc0xXxg0vxp28wTV0bEN+KZMnWQQ0gh1xOyAPWyVj54JhCGs2dHNnExZz4Vnz4N2SeCgt
 wGfkvnIhWxsod+9Ld6Ba+iHG+E2J0OEOCeM/yt/okDYA6sz1IKzGQ0QO4rfQ==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Shytyi <dmytro@shytyi.net>

This patch first adds TFO support in mptcp_connect.c.

This can be enabled via a new option: -o MPTFO.

Once enabled, the TCP_FASTOPEN socket option is enabled for the server
side and a sendto() with MSG_FASTOPEN is used instead of a connect() for
the client side.

Note that the first SYN has a limit of bytes it can carry. In other
words, it is allowed to send less data than the provided one. We then
need to track more status info to properly allow the next sendmsg()
starting from the next part of the data to send the rest.

Also in TFO scenarios, we need to completely spool the partially xmitted
buffer -- and account for that -- before starting sendfile/mmap xmit,
otherwise the relevant tests will fail.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 .../selftests/net/mptcp/mptcp_connect.c       | 171 +++++++++++++-----
 .../selftests/net/mptcp/mptcp_connect.sh      |  21 +++
 2 files changed, 150 insertions(+), 42 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index e54653ea2ed4..8a8266957bc5 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -83,6 +83,7 @@ struct cfg_cmsg_types {
 
 struct cfg_sockopt_types {
 	unsigned int transparent:1;
+	unsigned int mptfo:1;
 };
 
 struct tcp_inq_state {
@@ -90,6 +91,13 @@ struct tcp_inq_state {
 	bool expect_eof;
 };
 
+struct wstate {
+	char buf[8192];
+	unsigned int len;
+	unsigned int off;
+	unsigned int total_len;
+};
+
 static struct tcp_inq_state tcp_inq;
 
 static struct cfg_cmsg_types cfg_cmsg_types;
@@ -232,6 +240,14 @@ static void set_transparent(int fd, int pf)
 	}
 }
 
+static void set_mptfo(int fd, int pf)
+{
+	int qlen = 25;
+
+	if (setsockopt(fd, IPPROTO_TCP, TCP_FASTOPEN, &qlen, sizeof(qlen)) == -1)
+		perror("TCP_FASTOPEN");
+}
+
 static int do_ulp_so(int sock, const char *name)
 {
 	return setsockopt(sock, IPPROTO_TCP, TCP_ULP, name, strlen(name));
@@ -300,6 +316,9 @@ static int sock_listen_mptcp(const char * const listenaddr,
 		if (cfg_sockopt_types.transparent)
 			set_transparent(sock, pf);
 
+		if (cfg_sockopt_types.mptfo)
+			set_mptfo(sock, pf);
+
 		if (bind(sock, a->ai_addr, a->ai_addrlen) == 0)
 			break; /* success */
 
@@ -330,13 +349,15 @@ static int sock_listen_mptcp(const char * const listenaddr,
 
 static int sock_connect_mptcp(const char * const remoteaddr,
 			      const char * const port, int proto,
-			      struct addrinfo **peer)
+			      struct addrinfo **peer,
+			      int infd, struct wstate *winfo)
 {
 	struct addrinfo hints = {
 		.ai_protocol = IPPROTO_TCP,
 		.ai_socktype = SOCK_STREAM,
 	};
 	struct addrinfo *a, *addr;
+	int syn_copied = 0;
 	int sock = -1;
 
 	hints.ai_family = pf;
@@ -354,14 +375,34 @@ static int sock_connect_mptcp(const char * const remoteaddr,
 		if (cfg_mark)
 			set_mark(sock, cfg_mark);
 
-		if (connect(sock, a->ai_addr, a->ai_addrlen) == 0) {
-			*peer = a;
-			break; /* success */
+		if (cfg_sockopt_types.mptfo) {
+			if (!winfo->total_len)
+				winfo->total_len = winfo->len = read(infd, winfo->buf,
+								     sizeof(winfo->buf));
+
+			syn_copied = sendto(sock, winfo->buf, winfo->len, MSG_FASTOPEN,
+					    a->ai_addr, a->ai_addrlen);
+			if (syn_copied >= 0) {
+				winfo->off = syn_copied;
+				winfo->len -= syn_copied;
+				*peer = a;
+				break; /* success */
+			}
+		} else {
+			if (connect(sock, a->ai_addr, a->ai_addrlen) == 0) {
+				*peer = a;
+				break; /* success */
+			}
+		}
+		if (cfg_sockopt_types.mptfo) {
+			perror("sendto()");
+			close(sock);
+			sock = -1;
+		} else {
+			perror("connect()");
+			close(sock);
+			sock = -1;
 		}
-
-		perror("connect()");
-		close(sock);
-		sock = -1;
 	}
 
 	freeaddrinfo(addr);
@@ -571,14 +612,14 @@ static void shut_wr(int fd)
 	shutdown(fd, SHUT_WR);
 }
 
-static int copyfd_io_poll(int infd, int peerfd, int outfd, bool *in_closed_after_out)
+static int copyfd_io_poll(int infd, int peerfd, int outfd,
+			  bool *in_closed_after_out, struct wstate *winfo)
 {
 	struct pollfd fds = {
 		.fd = peerfd,
 		.events = POLLIN | POLLOUT,
 	};
-	unsigned int woff = 0, wlen = 0, total_wlen = 0, total_rlen = 0;
-	char wbuf[8192];
+	unsigned int total_wlen = 0, total_rlen = 0;
 
 	set_nonblock(peerfd, true);
 
@@ -638,19 +679,19 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd, bool *in_closed_after
 		}
 
 		if (fds.revents & POLLOUT) {
-			if (wlen == 0) {
-				woff = 0;
-				wlen = read(infd, wbuf, sizeof(wbuf));
+			if (winfo->len == 0) {
+				winfo->off = 0;
+				winfo->len = read(infd, winfo->buf, sizeof(winfo->buf));
 			}
 
-			if (wlen > 0) {
+			if (winfo->len > 0) {
 				ssize_t bw;
 
 				/* limit the total amount of written data to the trunc value */
-				if (cfg_truncate > 0 && wlen + total_wlen > cfg_truncate)
-					wlen = cfg_truncate - total_wlen;
+				if (cfg_truncate > 0 && winfo->len + total_wlen > cfg_truncate)
+					winfo->len = cfg_truncate - total_wlen;
 
-				bw = do_rnd_write(peerfd, wbuf + woff, wlen);
+				bw = do_rnd_write(peerfd, winfo->buf + winfo->off, winfo->len);
 				if (bw < 0) {
 					if (cfg_rcv_trunc)
 						return 0;
@@ -658,10 +699,10 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd, bool *in_closed_after
 					return 111;
 				}
 
-				woff += bw;
-				wlen -= bw;
+				winfo->off += bw;
+				winfo->len -= bw;
 				total_wlen += bw;
-			} else if (wlen == 0) {
+			} else if (winfo->len == 0) {
 				/* We have no more data to send. */
 				fds.events &= ~POLLOUT;
 
@@ -717,10 +758,26 @@ static int do_recvfile(int infd, int outfd)
 	return (int)r;
 }
 
-static int do_mmap(int infd, int outfd, unsigned int size)
+static int spool_buf(int fd, struct wstate *winfo)
+{
+	while (winfo->len) {
+		int ret = write(fd, winfo->buf + winfo->off, winfo->len);
+
+		if (ret < 0) {
+			perror("write");
+			return 4;
+		}
+		winfo->off += ret;
+		winfo->len -= ret;
+	}
+	return 0;
+}
+
+static int do_mmap(int infd, int outfd, unsigned int size,
+		   struct wstate *winfo)
 {
 	char *inbuf = mmap(NULL, size, PROT_READ, MAP_SHARED, infd, 0);
-	ssize_t ret = 0, off = 0;
+	ssize_t ret = 0, off = winfo->total_len;
 	size_t rem;
 
 	if (inbuf == MAP_FAILED) {
@@ -728,7 +785,11 @@ static int do_mmap(int infd, int outfd, unsigned int size)
 		return 1;
 	}
 
-	rem = size;
+	ret = spool_buf(outfd, winfo);
+	if (ret < 0)
+		return ret;
+
+	rem = size - winfo->total_len;
 
 	while (rem > 0) {
 		ret = write(outfd, inbuf + off, rem);
@@ -772,8 +833,16 @@ static int get_infd_size(int fd)
 	return (int)count;
 }
 
-static int do_sendfile(int infd, int outfd, unsigned int count)
+static int do_sendfile(int infd, int outfd, unsigned int count,
+		       struct wstate *winfo)
 {
+	int ret = spool_buf(outfd, winfo);
+
+	if (ret < 0)
+		return ret;
+
+	count -= winfo->total_len;
+
 	while (count > 0) {
 		ssize_t r;
 
@@ -790,7 +859,8 @@ static int do_sendfile(int infd, int outfd, unsigned int count)
 }
 
 static int copyfd_io_mmap(int infd, int peerfd, int outfd,
-			  unsigned int size, bool *in_closed_after_out)
+			  unsigned int size, bool *in_closed_after_out,
+			  struct wstate *winfo)
 {
 	int err;
 
@@ -799,9 +869,9 @@ static int copyfd_io_mmap(int infd, int peerfd, int outfd,
 		if (err)
 			return err;
 
-		err = do_mmap(infd, peerfd, size);
+		err = do_mmap(infd, peerfd, size, winfo);
 	} else {
-		err = do_mmap(infd, peerfd, size);
+		err = do_mmap(infd, peerfd, size, winfo);
 		if (err)
 			return err;
 
@@ -815,7 +885,7 @@ static int copyfd_io_mmap(int infd, int peerfd, int outfd,
 }
 
 static int copyfd_io_sendfile(int infd, int peerfd, int outfd,
-			      unsigned int size, bool *in_closed_after_out)
+			      unsigned int size, bool *in_closed_after_out, struct wstate *winfo)
 {
 	int err;
 
@@ -824,9 +894,9 @@ static int copyfd_io_sendfile(int infd, int peerfd, int outfd,
 		if (err)
 			return err;
 
-		err = do_sendfile(infd, peerfd, size);
+		err = do_sendfile(infd, peerfd, size, winfo);
 	} else {
-		err = do_sendfile(infd, peerfd, size);
+		err = do_sendfile(infd, peerfd, size, winfo);
 		if (err)
 			return err;
 
@@ -839,7 +909,7 @@ static int copyfd_io_sendfile(int infd, int peerfd, int outfd,
 	return err;
 }
 
-static int copyfd_io(int infd, int peerfd, int outfd, bool close_peerfd)
+static int copyfd_io(int infd, int peerfd, int outfd, bool close_peerfd, struct wstate *winfo)
 {
 	bool in_closed_after_out = false;
 	struct timespec start, end;
@@ -851,21 +921,24 @@ static int copyfd_io(int infd, int peerfd, int outfd, bool close_peerfd)
 
 	switch (cfg_mode) {
 	case CFG_MODE_POLL:
-		ret = copyfd_io_poll(infd, peerfd, outfd, &in_closed_after_out);
+		ret = copyfd_io_poll(infd, peerfd, outfd, &in_closed_after_out,
+				     winfo);
 		break;
 
 	case CFG_MODE_MMAP:
 		file_size = get_infd_size(infd);
 		if (file_size < 0)
 			return file_size;
-		ret = copyfd_io_mmap(infd, peerfd, outfd, file_size, &in_closed_after_out);
+		ret = copyfd_io_mmap(infd, peerfd, outfd, file_size,
+				     &in_closed_after_out, winfo);
 		break;
 
 	case CFG_MODE_SENDFILE:
 		file_size = get_infd_size(infd);
 		if (file_size < 0)
 			return file_size;
-		ret = copyfd_io_sendfile(infd, peerfd, outfd, file_size, &in_closed_after_out);
+		ret = copyfd_io_sendfile(infd, peerfd, outfd, file_size,
+					 &in_closed_after_out, winfo);
 		break;
 
 	default:
@@ -999,6 +1072,7 @@ static void maybe_close(int fd)
 int main_loop_s(int listensock)
 {
 	struct sockaddr_storage ss;
+	struct wstate winfo;
 	struct pollfd polls;
 	socklen_t salen;
 	int remotesock;
@@ -1033,7 +1107,8 @@ int main_loop_s(int listensock)
 
 		SOCK_TEST_TCPULP(remotesock, 0);
 
-		copyfd_io(fd, remotesock, 1, true);
+		memset(&winfo, 0, sizeof(winfo));
+		copyfd_io(fd, remotesock, 1, true, &winfo);
 	} else {
 		perror("accept");
 		return 1;
@@ -1130,6 +1205,11 @@ static void parse_setsock_options(const char *name)
 		return;
 	}
 
+	if (strncmp(name, "MPTFO", len) == 0) {
+		cfg_sockopt_types.mptfo = 1;
+		return;
+	}
+
 	fprintf(stderr, "Unrecognized setsockopt option %s\n", name);
 	exit(1);
 }
@@ -1166,11 +1246,18 @@ void xdisconnect(int fd, int addrlen)
 
 int main_loop(void)
 {
-	int fd, ret, fd_in = 0;
+	int fd = 0, ret, fd_in = 0;
 	struct addrinfo *peer;
+	struct wstate winfo;
+
+	if (cfg_input && cfg_sockopt_types.mptfo) {
+		fd_in = open(cfg_input, O_RDONLY);
+		if (fd < 0)
+			xerror("can't open %s:%d", cfg_input, errno);
+	}
 
-	/* listener is ready. */
-	fd = sock_connect_mptcp(cfg_host, cfg_port, cfg_sock_proto, &peer);
+	memset(&winfo, 0, sizeof(winfo));
+	fd = sock_connect_mptcp(cfg_host, cfg_port, cfg_sock_proto, &peer, fd_in, &winfo);
 	if (fd < 0)
 		return 2;
 
@@ -1186,14 +1273,13 @@ int main_loop(void)
 	if (cfg_cmsg_types.cmsg_enabled)
 		apply_cmsg_types(fd, &cfg_cmsg_types);
 
-	if (cfg_input) {
+	if (cfg_input && !cfg_sockopt_types.mptfo) {
 		fd_in = open(cfg_input, O_RDONLY);
 		if (fd < 0)
 			xerror("can't open %s:%d", cfg_input, errno);
 	}
 
-	/* close the client socket open only if we are not going to reconnect */
-	ret = copyfd_io(fd_in, fd, 1, 0);
+	ret = copyfd_io(fd_in, fd, 1, 0, &winfo);
 	if (ret)
 		return ret;
 
@@ -1210,6 +1296,7 @@ int main_loop(void)
 			xerror("can't reconnect: %d", errno);
 		if (cfg_input)
 			close(fd_in);
+		memset(&winfo, 0, sizeof(winfo));
 		goto again;
 	} else {
 		close(fd);
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 621af6895f4d..60198b91a530 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -762,6 +762,23 @@ run_tests_peekmode()
 	run_tests_lo "$ns1" "$ns1" dead:beef:1::1 1 "-P ${peekmode}"
 }
 
+run_tests_mptfo()
+{
+	echo "INFO: with MPTFO start"
+	ip netns exec "$ns1" sysctl -q net.ipv4.tcp_fastopen=2
+	ip netns exec "$ns2" sysctl -q net.ipv4.tcp_fastopen=1
+
+	run_tests_lo "$ns1" "$ns2" 10.0.1.1 0 "-o MPTFO"
+	run_tests_lo "$ns1" "$ns2" 10.0.1.1 0 "-o MPTFO"
+
+	run_tests_lo "$ns1" "$ns2" dead:beef:1::1 0 "-o MPTFO"
+	run_tests_lo "$ns1" "$ns2" dead:beef:1::1 0 "-o MPTFO"
+
+	ip netns exec "$ns1" sysctl -q net.ipv4.tcp_fastopen=0
+	ip netns exec "$ns2" sysctl -q net.ipv4.tcp_fastopen=0
+	echo "INFO: with MPTFO end"
+}
+
 run_tests_disconnect()
 {
 	local peekmode="$1"
@@ -901,6 +918,10 @@ run_tests_peekmode "saveWithPeek"
 run_tests_peekmode "saveAfterPeek"
 stop_if_error "Tests with peek mode have failed"
 
+# MPTFO (MultiPath TCP Fatopen tests)
+run_tests_mptfo
+stop_if_error "Tests with MPTFO have failed"
+
 # connect to ns4 ip address, ns2 should intercept/proxy
 run_test_transparent 10.0.3.1 "tproxy ipv4"
 run_test_transparent dead:beef:3::1 "tproxy ipv6"
-- 
2.37.2

