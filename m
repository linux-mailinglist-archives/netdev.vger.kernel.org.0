Return-Path: <netdev+bounces-4500-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50D4E70D21B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:01:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 058222811D3
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 03:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5733C17AB5;
	Tue, 23 May 2023 02:56:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4306517AAF;
	Tue, 23 May 2023 02:56:43 +0000 (UTC)
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DC7FA;
	Mon, 22 May 2023 19:56:38 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-53033a0b473so4815259a12.0;
        Mon, 22 May 2023 19:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684810597; x=1687402597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2OiIh6/gwAzSF0mWF9OG5fkwKj7b+3VvE1TExhAd9ek=;
        b=FhxuFIGtCdvzYJ7ScaVHBjXG/eiXR/m/b0Uoxpc9NiwHKvA/NuKqMoUZ7gYteg5cVK
         fKN5B+4fVbfg6kY2kFXRkr/5L6rTt64LNxOxEuzOYVF/bHHWr6gmh8VJOeXzMjpCYMiT
         JJT7uwkBuXyV5OFRevkkBt5Rbk9sLaTGQ77J1NmXlKmwAd4JizQQ5KWAKxMLJPTRSGCP
         hgyycrzygGEFxc8sMQ31MUOEkPpnHvNGJ4E8tW7RgPf+c3vCGRyvxSVdVN54WOuMupOy
         xE9wIWvXs+PbCma2hWdwmQ8s4IQMgmp/4FbVBf5xyE9XHV9Sx2sZFPcrwrmz9/kYnTj5
         wiEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684810597; x=1687402597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2OiIh6/gwAzSF0mWF9OG5fkwKj7b+3VvE1TExhAd9ek=;
        b=acPsK2xtk0i+EoLHuACttbuWU9gE1zSWKpofe2D8Hd9sreb5JfimbNIjmed6QoyiHm
         fLWC3Q8CFvPKALiFhvYlAZb7022efMnaJzaWcKsxy/vMWcwfcvUvvW7hebF0RCCV+8d8
         IZDa5LuGvxPlKCOg2GTmE3NvPiLCzvoHkPcuFAAErU00f2/AulFI852vtTs7wyfGwbsu
         fE8sTRwjSfwvuz7wi/qv92gnv+BkgnZppwDavBRvBM+A8cg0S5GDFdLvSOSAFpwj52pM
         /6b0JOUVffcuhNT9ihmZ4WjqiEdJMzVj3btgQhBSCnzUVS6Az2FI5YfKH4EkR798mhw9
         ZjQQ==
X-Gm-Message-State: AC+VfDx/2ETLWrt2am9yOaT2IXnoWbPhM3q4xW9ghGKorS+fLR27LPyF
	3TfTw+oQ6XoPK8Glo4f9DPA=
X-Google-Smtp-Source: ACHHUZ7lZ1trSa+VTrojyyyZVUojO4m9TcPItP82QyHyLOYyYuT03XfsRowLOWWiUBK6/YDnwIkYow==
X-Received: by 2002:a17:902:7785:b0:1ad:f912:c047 with SMTP id o5-20020a170902778500b001adf912c047mr10732703pll.42.1684810597576;
        Mon, 22 May 2023 19:56:37 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:82a6:5b19:9c99:3aad])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902748a00b001a67759f9f8sm5508285pll.106.2023.05.22.19.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 19:56:37 -0700 (PDT)
From: John Fastabend <john.fastabend@gmail.com>
To: jakub@cloudflare.com,
	daniel@iogearbox.net
Cc: john.fastabend@gmail.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	ast@kernel.org,
	andrii@kernel.org,
	will@isovalent.com
Subject: [PATCH bpf v10 10/14] bpf: sockmap, build helper to create connected socket pair
Date: Mon, 22 May 2023 19:56:14 -0700
Message-Id: <20230523025618.113937-11-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230523025618.113937-1-john.fastabend@gmail.com>
References: <20230523025618.113937-1-john.fastabend@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

A common operation for testing is to spin up a pair of sockets that are
connected. Then we can use these to run specific tests that need to
send data, check BPF programs and so on.

The sockmap_listen programs already have this logic lets move it into
the new sockmap_helpers header file for general use.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../bpf/prog_tests/sockmap_helpers.h          | 118 ++++++++++++++++++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 107 +---------------
 2 files changed, 123 insertions(+), 102 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h b/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
index 5aa99e6adcb4..d12665490a90 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
@@ -269,4 +269,122 @@ static inline struct sockaddr *sockaddr(struct sockaddr_storage *ss)
 	return (struct sockaddr *)ss;
 }
 
+static inline int add_to_sockmap(int sock_mapfd, int fd1, int fd2)
+{
+	u64 value;
+	u32 key;
+	int err;
+
+	key = 0;
+	value = fd1;
+	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	if (err)
+		return err;
+
+	key = 1;
+	value = fd2;
+	return xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+}
+
+static inline int create_pair(int s, int family, int sotype, int *c, int *p)
+{
+	struct sockaddr_storage addr;
+	socklen_t len;
+	int err = 0;
+
+	len = sizeof(addr);
+	err = xgetsockname(s, sockaddr(&addr), &len);
+	if (err)
+		return err;
+
+	*c = xsocket(family, sotype, 0);
+	if (*c < 0)
+		return errno;
+	err = xconnect(*c, sockaddr(&addr), len);
+	if (err) {
+		err = errno;
+		goto close_cli0;
+	}
+
+	*p = xaccept_nonblock(s, NULL, NULL);
+	if (*p < 0) {
+		err = errno;
+		goto close_cli0;
+	}
+	return err;
+close_cli0:
+	close(*c);
+	return err;
+}
+
+static inline int create_socket_pairs(int s, int family, int sotype,
+				      int *c0, int *c1, int *p0, int *p1)
+{
+	int err;
+
+	err = create_pair(s, family, sotype, c0, p0);
+	if (err)
+		return err;
+
+	err = create_pair(s, family, sotype, c1, p1);
+	if (err) {
+		close(*c0);
+		close(*p0);
+	}
+	return err;
+}
+
+static inline int enable_reuseport(int s, int progfd)
+{
+	int err, one = 1;
+
+	err = xsetsockopt(s, SOL_SOCKET, SO_REUSEPORT, &one, sizeof(one));
+	if (err)
+		return -1;
+	err = xsetsockopt(s, SOL_SOCKET, SO_ATTACH_REUSEPORT_EBPF, &progfd,
+			  sizeof(progfd));
+	if (err)
+		return -1;
+
+	return 0;
+}
+
+static inline int socket_loopback_reuseport(int family, int sotype, int progfd)
+{
+	struct sockaddr_storage addr;
+	socklen_t len;
+	int err, s;
+
+	init_addr_loopback(family, &addr, &len);
+
+	s = xsocket(family, sotype, 0);
+	if (s == -1)
+		return -1;
+
+	if (progfd >= 0)
+		enable_reuseport(s, progfd);
+
+	err = xbind(s, sockaddr(&addr), len);
+	if (err)
+		goto close;
+
+	if (sotype & SOCK_DGRAM)
+		return s;
+
+	err = xlisten(s, SOMAXCONN);
+	if (err)
+		goto close;
+
+	return s;
+close:
+	xclose(s);
+	return -1;
+}
+
+static inline int socket_loopback(int family, int sotype)
+{
+	return socket_loopback_reuseport(family, sotype, -1);
+}
+
+
 #endif // __SOCKMAP_HELPERS__
diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 7dc8dd713256..b4f6f3a50ae5 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -29,58 +29,6 @@
 
 #include "sockmap_helpers.h"
 
-static int enable_reuseport(int s, int progfd)
-{
-	int err, one = 1;
-
-	err = xsetsockopt(s, SOL_SOCKET, SO_REUSEPORT, &one, sizeof(one));
-	if (err)
-		return -1;
-	err = xsetsockopt(s, SOL_SOCKET, SO_ATTACH_REUSEPORT_EBPF, &progfd,
-			  sizeof(progfd));
-	if (err)
-		return -1;
-
-	return 0;
-}
-
-static int socket_loopback_reuseport(int family, int sotype, int progfd)
-{
-	struct sockaddr_storage addr;
-	socklen_t len;
-	int err, s;
-
-	init_addr_loopback(family, &addr, &len);
-
-	s = xsocket(family, sotype, 0);
-	if (s == -1)
-		return -1;
-
-	if (progfd >= 0)
-		enable_reuseport(s, progfd);
-
-	err = xbind(s, sockaddr(&addr), len);
-	if (err)
-		goto close;
-
-	if (sotype & SOCK_DGRAM)
-		return s;
-
-	err = xlisten(s, SOMAXCONN);
-	if (err)
-		goto close;
-
-	return s;
-close:
-	xclose(s);
-	return -1;
-}
-
-static int socket_loopback(int family, int sotype)
-{
-	return socket_loopback_reuseport(family, sotype, -1);
-}
-
 static void test_insert_invalid(struct test_sockmap_listen *skel __always_unused,
 				int family, int sotype, int mapfd)
 {
@@ -723,31 +671,12 @@ static const char *redir_mode_str(enum redir_mode mode)
 	}
 }
 
-static int add_to_sockmap(int sock_mapfd, int fd1, int fd2)
-{
-	u64 value;
-	u32 key;
-	int err;
-
-	key = 0;
-	value = fd1;
-	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
-	if (err)
-		return err;
-
-	key = 1;
-	value = fd2;
-	return xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
-}
-
 static void redir_to_connected(int family, int sotype, int sock_mapfd,
 			       int verd_mapfd, enum redir_mode mode)
 {
 	const char *log_prefix = redir_mode_str(mode);
-	struct sockaddr_storage addr;
 	int s, c0, c1, p0, p1;
 	unsigned int pass;
-	socklen_t len;
 	int err, n;
 	u32 key;
 	char b;
@@ -758,36 +687,13 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
 	if (s < 0)
 		return;
 
-	len = sizeof(addr);
-	err = xgetsockname(s, sockaddr(&addr), &len);
+	err = create_socket_pairs(s, family, sotype, &c0, &c1, &p0, &p1);
 	if (err)
 		goto close_srv;
 
-	c0 = xsocket(family, sotype, 0);
-	if (c0 < 0)
-		goto close_srv;
-	err = xconnect(c0, sockaddr(&addr), len);
-	if (err)
-		goto close_cli0;
-
-	p0 = xaccept_nonblock(s, NULL, NULL);
-	if (p0 < 0)
-		goto close_cli0;
-
-	c1 = xsocket(family, sotype, 0);
-	if (c1 < 0)
-		goto close_peer0;
-	err = xconnect(c1, sockaddr(&addr), len);
-	if (err)
-		goto close_cli1;
-
-	p1 = xaccept_nonblock(s, NULL, NULL);
-	if (p1 < 0)
-		goto close_cli1;
-
 	err = add_to_sockmap(sock_mapfd, p0, p1);
 	if (err)
-		goto close_peer1;
+		goto close;
 
 	n = write(mode == REDIR_INGRESS ? c1 : p1, "a", 1);
 	if (n < 0)
@@ -795,12 +701,12 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
 	if (n == 0)
 		FAIL("%s: incomplete write", log_prefix);
 	if (n < 1)
-		goto close_peer1;
+		goto close;
 
 	key = SK_PASS;
 	err = xbpf_map_lookup_elem(verd_mapfd, &key, &pass);
 	if (err)
-		goto close_peer1;
+		goto close;
 	if (pass != 1)
 		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
 	n = recv_timeout(c0, &b, 1, 0, IO_TIMEOUT_SEC);
@@ -809,13 +715,10 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
 	if (n == 0)
 		FAIL("%s: incomplete recv", log_prefix);
 
-close_peer1:
+close:
 	xclose(p1);
-close_cli1:
 	xclose(c1);
-close_peer0:
 	xclose(p0);
-close_cli0:
 	xclose(c0);
 close_srv:
 	xclose(s);
-- 
2.33.0


