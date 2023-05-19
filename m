Return-Path: <netdev+bounces-3809-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E99CE708EAB
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 06:12:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 669181C2082A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 04:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 955633D3BA;
	Fri, 19 May 2023 04:07:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837D5566C;
	Fri, 19 May 2023 04:07:20 +0000 (UTC)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F43310DF;
	Thu, 18 May 2023 21:07:19 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-643a1fed360so2031961b3a.3;
        Thu, 18 May 2023 21:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684469238; x=1687061238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/61Dd2DU59fhyIeFPysOqmpRUlvbvp/lnU8ooWFLyfU=;
        b=nWup8tl+OCaSvE7OAegJ/p+J9GdFWD2Qps5HA3kdb/TRCu+02HXMwbHds1V6WBx2Ki
         P/pIF0HX/bkcfj4fUI2NTLNRrWHFVX0BzR+MepmtpZPewR19qFcvsHeUfGEFy1DCDwPz
         tHw/QsUTAvNiIeevflTPBXiVwgBry58OMom3d1Qd36zKDB3bjYNHDmNl1tTUSSC/puO+
         2J7Fx/K9T3UFiIaTlKrJLKCxFfW00obdh8Ok326N1qvq8FU7C3w/DtmE5j+zApVOQhAI
         eha16YgJHyDROdPNyX6JOdkrkLcECWpuRWMaL0xzH+E12mNaTw8fiJQtaeKdSixV3E47
         fDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684469238; x=1687061238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/61Dd2DU59fhyIeFPysOqmpRUlvbvp/lnU8ooWFLyfU=;
        b=OAGRY2qvhwDJhp6vBgio7MpwBkrSO0UuIDawXaF/1GJsEaCVFVUK/d2qN+aZp8uj4Y
         JD/8dnV4dRxZLcVlcMRLk5t3ANtsvvqc9R3n37wC+YFNa1K8IsuVnj8RVi1gjYzvvI5G
         4DwPfBHwJyB93We89NPWXMO/CSGyrE9ebl/oaJnwofjYIkipwdOg9E4q3UzJO/eOHl4R
         aCBJPyGRdhk+M//BSPcLb2/qF6kdCfLv8wUx+e9bexu1AwljM35sgm1BKeLM/DLQSjKu
         8w8erQfaM0R0T7rG5B8SDnZx9SRRAi+RDSKoN7gI/bRNzqY3CfmEJvZcAz6/hnZ5UzyA
         muhQ==
X-Gm-Message-State: AC+VfDwpkD7OgQHbxNJBIiBIxH5kwCAXzDhmCJufkHkRjF/xcJ/MdN8V
	dH4U3fmIDjW73j6lT3bLBEN85OIcdiU=
X-Google-Smtp-Source: ACHHUZ5/m11Ma4/qQgzwI75q/jZtXARehbwupCwq8JCVzD45/6d9b0Ymzdz/b2B06MbuhUXE2cGYTg==
X-Received: by 2002:a05:6a20:2624:b0:100:a2ca:7ca8 with SMTP id i36-20020a056a20262400b00100a2ca7ca8mr611421pze.54.1684469238436;
        Thu, 18 May 2023 21:07:18 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:706:628a:e6ce:c8a9])
        by smtp.gmail.com with ESMTPSA id x11-20020aa784cb000000b00625d84a0194sm434833pfn.107.2023.05.18.21.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 21:07:17 -0700 (PDT)
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
Subject: [PATCH bpf v9 10/14] bpf: sockmap, build helper to create connected socket pair
Date: Thu, 18 May 2023 21:06:55 -0700
Message-Id: <20230519040659.670644-11-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230519040659.670644-1-john.fastabend@gmail.com>
References: <20230519040659.670644-1-john.fastabend@gmail.com>
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
index d516418a0a18..8b4a540cbd65 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
@@ -264,4 +264,122 @@ static inline struct sockaddr *sockaddr(struct sockaddr_storage *ss)
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
index 3deffaa04885..5ba808186186 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -34,58 +34,6 @@
 
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
@@ -728,31 +676,12 @@ static const char *redir_mode_str(enum redir_mode mode)
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
@@ -763,36 +692,13 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
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
@@ -800,12 +706,12 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
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
@@ -814,13 +720,10 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
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


