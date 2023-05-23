Return-Path: <netdev+bounces-4497-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7925C70D209
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A9481C20AD5
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 03:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B9A12B76;
	Tue, 23 May 2023 02:56:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0514EEDF;
	Tue, 23 May 2023 02:56:38 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918CCE6;
	Mon, 22 May 2023 19:56:36 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-64a9335a8e7so2933432b3a.0;
        Mon, 22 May 2023 19:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684810596; x=1687402596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RV3cy6fzT+FP/o9Z76rCWXv8erLvFM5dnU00SJ/KL7o=;
        b=FCye5yb7EdGr4f0Mw19pOJVlSUCjki10A5Xt6gsdReYkkIKmd1h8F/wyDRfMQhSt5D
         zAhrS1I2seytotbloUWwNxM5AeApfTIwxp24QPJhiWGimXh8BTQwL1vASd0PzHEj3d4r
         LFKaanYgqJEtEjAKwlh1KX7JLAfygLBt5fsaEpAYdYhtCEXqDfCdsplS9vjy/ZAm42Hn
         4kK5pq9D4cIYjKOppwiq1Ei9AEX35k9DiTjD/WWW+XvbCu/MMraZiWpHneciY3es6oFd
         OPztH2P49r7Ngbrbmxtg6THzuo87cOHleXjiEvrpS7fFwkkiwTn6YZdW4jxWkCxZPEpm
         ABbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684810596; x=1687402596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RV3cy6fzT+FP/o9Z76rCWXv8erLvFM5dnU00SJ/KL7o=;
        b=VulTJwX6+WpwVqPJ68bx1KZ8icdorb+sNEeBI1fs/LTNdT+fPuIqbNzw2DhIl+Zydn
         5u3ouiymz4cMOPkC2QtzJLJauU3458vwgZn5YvKpl/rP5AuSbJ3JQTBKGPL5j2kqYXpI
         9pUEyGuJhbOliaase3Io+QZ1sxf6bcX++cU6j/bqsYx4hXdeZhcfkjtYWhLceoJxwltq
         cN0MdIAQWhRYlfB7dJFU8raKSNenppMwpUa6H9uq2tgzH3K3AAL5n4ee/1ruX/H0i4TP
         5DV2cOTOmFIjroX8y0eVt3jOckCuUTJRZLNY541CaOcD06XekJ9Y7H3lVolRfjtnpOy+
         dhEw==
X-Gm-Message-State: AC+VfDzPUy0PLMie2mfl6CZGAJByE/uSM6yevCASc9O1mjos8TPS1uJl
	zXuWPC3yrbd7Z/LK4dW/r4k=
X-Google-Smtp-Source: ACHHUZ73KecFiVlvxWoFvhkHq1S1ka+aP5L44WOTUoFTld5TNlnM5H4g5wI9JUK6sQc1OdqWfTxwvg==
X-Received: by 2002:a17:902:d2ca:b0:1ae:8fa:cd4c with SMTP id n10-20020a170902d2ca00b001ae08facd4cmr20022292plc.7.1684810596148;
        Mon, 22 May 2023 19:56:36 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:82a6:5b19:9c99:3aad])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902748a00b001a67759f9f8sm5508285pll.106.2023.05.22.19.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 19:56:35 -0700 (PDT)
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
Subject: [PATCH bpf v10 09/14] bpf: sockmap, pull socket helpers out of listen test for general use
Date: Mon, 22 May 2023 19:56:13 -0700
Message-Id: <20230523025618.113937-10-john.fastabend@gmail.com>
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

No functional change here we merely pull the helpers in sockmap_listen.c
into a header file so we can use these in other programs. The tests we
are about to add aren't really _listen tests so doesn't make sense
to add them here.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../bpf/prog_tests/sockmap_helpers.h          | 272 ++++++++++++++++++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 263 +----------------
 2 files changed, 273 insertions(+), 262 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h b/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
new file mode 100644
index 000000000000..5aa99e6adcb4
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
@@ -0,0 +1,272 @@
+#ifndef __SOCKMAP_HELPERS__
+#define __SOCKMAP_HELPERS__
+
+#include <linux/vm_sockets.h>
+
+#define IO_TIMEOUT_SEC 30
+#define MAX_STRERR_LEN 256
+#define MAX_TEST_NAME 80
+
+/* workaround for older vm_sockets.h */
+#ifndef VMADDR_CID_LOCAL
+#define VMADDR_CID_LOCAL 1
+#endif
+
+#define __always_unused	__attribute__((__unused__))
+
+#define _FAIL(errnum, fmt...)                                                  \
+	({                                                                     \
+		error_at_line(0, (errnum), __func__, __LINE__, fmt);           \
+		CHECK_FAIL(true);                                              \
+	})
+#define FAIL(fmt...) _FAIL(0, fmt)
+#define FAIL_ERRNO(fmt...) _FAIL(errno, fmt)
+#define FAIL_LIBBPF(err, msg)                                                  \
+	({                                                                     \
+		char __buf[MAX_STRERR_LEN];                                    \
+		libbpf_strerror((err), __buf, sizeof(__buf));                  \
+		FAIL("%s: %s", (msg), __buf);                                  \
+	})
+
+/* Wrappers that fail the test on error and report it. */
+
+#define xaccept_nonblock(fd, addr, len)                                        \
+	({                                                                     \
+		int __ret =                                                    \
+			accept_timeout((fd), (addr), (len), IO_TIMEOUT_SEC);   \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("accept");                                  \
+		__ret;                                                         \
+	})
+
+#define xbind(fd, addr, len)                                                   \
+	({                                                                     \
+		int __ret = bind((fd), (addr), (len));                         \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("bind");                                    \
+		__ret;                                                         \
+	})
+
+#define xclose(fd)                                                             \
+	({                                                                     \
+		int __ret = close((fd));                                       \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("close");                                   \
+		__ret;                                                         \
+	})
+
+#define xconnect(fd, addr, len)                                                \
+	({                                                                     \
+		int __ret = connect((fd), (addr), (len));                      \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("connect");                                 \
+		__ret;                                                         \
+	})
+
+#define xgetsockname(fd, addr, len)                                            \
+	({                                                                     \
+		int __ret = getsockname((fd), (addr), (len));                  \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("getsockname");                             \
+		__ret;                                                         \
+	})
+
+#define xgetsockopt(fd, level, name, val, len)                                 \
+	({                                                                     \
+		int __ret = getsockopt((fd), (level), (name), (val), (len));   \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("getsockopt(" #name ")");                   \
+		__ret;                                                         \
+	})
+
+#define xlisten(fd, backlog)                                                   \
+	({                                                                     \
+		int __ret = listen((fd), (backlog));                           \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("listen");                                  \
+		__ret;                                                         \
+	})
+
+#define xsetsockopt(fd, level, name, val, len)                                 \
+	({                                                                     \
+		int __ret = setsockopt((fd), (level), (name), (val), (len));   \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("setsockopt(" #name ")");                   \
+		__ret;                                                         \
+	})
+
+#define xsend(fd, buf, len, flags)                                             \
+	({                                                                     \
+		ssize_t __ret = send((fd), (buf), (len), (flags));             \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("send");                                    \
+		__ret;                                                         \
+	})
+
+#define xrecv_nonblock(fd, buf, len, flags)                                    \
+	({                                                                     \
+		ssize_t __ret = recv_timeout((fd), (buf), (len), (flags),      \
+					     IO_TIMEOUT_SEC);                  \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("recv");                                    \
+		__ret;                                                         \
+	})
+
+#define xsocket(family, sotype, flags)                                         \
+	({                                                                     \
+		int __ret = socket(family, sotype, flags);                     \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("socket");                                  \
+		__ret;                                                         \
+	})
+
+#define xbpf_map_delete_elem(fd, key)                                          \
+	({                                                                     \
+		int __ret = bpf_map_delete_elem((fd), (key));                  \
+		if (__ret < 0)                                               \
+			FAIL_ERRNO("map_delete");                              \
+		__ret;                                                         \
+	})
+
+#define xbpf_map_lookup_elem(fd, key, val)                                     \
+	({                                                                     \
+		int __ret = bpf_map_lookup_elem((fd), (key), (val));           \
+		if (__ret < 0)                                               \
+			FAIL_ERRNO("map_lookup");                              \
+		__ret;                                                         \
+	})
+
+#define xbpf_map_update_elem(fd, key, val, flags)                              \
+	({                                                                     \
+		int __ret = bpf_map_update_elem((fd), (key), (val), (flags));  \
+		if (__ret < 0)                                               \
+			FAIL_ERRNO("map_update");                              \
+		__ret;                                                         \
+	})
+
+#define xbpf_prog_attach(prog, target, type, flags)                            \
+	({                                                                     \
+		int __ret =                                                    \
+			bpf_prog_attach((prog), (target), (type), (flags));    \
+		if (__ret < 0)                                               \
+			FAIL_ERRNO("prog_attach(" #type ")");                  \
+		__ret;                                                         \
+	})
+
+#define xbpf_prog_detach2(prog, target, type)                                  \
+	({                                                                     \
+		int __ret = bpf_prog_detach2((prog), (target), (type));        \
+		if (__ret < 0)                                               \
+			FAIL_ERRNO("prog_detach2(" #type ")");                 \
+		__ret;                                                         \
+	})
+
+#define xpthread_create(thread, attr, func, arg)                               \
+	({                                                                     \
+		int __ret = pthread_create((thread), (attr), (func), (arg));   \
+		errno = __ret;                                                 \
+		if (__ret)                                                     \
+			FAIL_ERRNO("pthread_create");                          \
+		__ret;                                                         \
+	})
+
+#define xpthread_join(thread, retval)                                          \
+	({                                                                     \
+		int __ret = pthread_join((thread), (retval));                  \
+		errno = __ret;                                                 \
+		if (__ret)                                                     \
+			FAIL_ERRNO("pthread_join");                            \
+		__ret;                                                         \
+	})
+
+static inline int poll_read(int fd, unsigned int timeout_sec)
+{
+	struct timeval timeout = { .tv_sec = timeout_sec };
+	fd_set rfds;
+	int r;
+
+	FD_ZERO(&rfds);
+	FD_SET(fd, &rfds);
+
+	r = select(fd + 1, &rfds, NULL, NULL, &timeout);
+	if (r == 0)
+		errno = ETIME;
+
+	return r == 1 ? 0 : -1;
+}
+
+static inline int accept_timeout(int fd, struct sockaddr *addr, socklen_t *len,
+				 unsigned int timeout_sec)
+{
+	if (poll_read(fd, timeout_sec))
+		return -1;
+
+	return accept(fd, addr, len);
+}
+
+static inline int recv_timeout(int fd, void *buf, size_t len, int flags,
+			       unsigned int timeout_sec)
+{
+	if (poll_read(fd, timeout_sec))
+		return -1;
+
+	return recv(fd, buf, len, flags);
+}
+
+static inline void init_addr_loopback4(struct sockaddr_storage *ss,
+				       socklen_t *len)
+{
+	struct sockaddr_in *addr4 = memset(ss, 0, sizeof(*ss));
+
+	addr4->sin_family = AF_INET;
+	addr4->sin_port = 0;
+	addr4->sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+	*len = sizeof(*addr4);
+}
+
+static inline void init_addr_loopback6(struct sockaddr_storage *ss,
+				       socklen_t *len)
+{
+	struct sockaddr_in6 *addr6 = memset(ss, 0, sizeof(*ss));
+
+	addr6->sin6_family = AF_INET6;
+	addr6->sin6_port = 0;
+	addr6->sin6_addr = in6addr_loopback;
+	*len = sizeof(*addr6);
+}
+
+static inline void init_addr_loopback_vsock(struct sockaddr_storage *ss,
+					    socklen_t *len)
+{
+	struct sockaddr_vm *addr = memset(ss, 0, sizeof(*ss));
+
+	addr->svm_family = AF_VSOCK;
+	addr->svm_port = VMADDR_PORT_ANY;
+	addr->svm_cid = VMADDR_CID_LOCAL;
+	*len = sizeof(*addr);
+}
+
+static inline void init_addr_loopback(int family, struct sockaddr_storage *ss,
+				      socklen_t *len)
+{
+	switch (family) {
+	case AF_INET:
+		init_addr_loopback4(ss, len);
+		return;
+	case AF_INET6:
+		init_addr_loopback6(ss, len);
+		return;
+	case AF_VSOCK:
+		init_addr_loopback_vsock(ss, len);
+		return;
+	default:
+		FAIL("unsupported address family %d", family);
+	}
+}
+
+static inline struct sockaddr *sockaddr(struct sockaddr_storage *ss)
+{
+	return (struct sockaddr *)ss;
+}
+
+#endif // __SOCKMAP_HELPERS__
diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 141c1e5944ee..7dc8dd713256 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -20,11 +20,6 @@
 #include <unistd.h>
 #include <linux/vm_sockets.h>
 
-/* workaround for older vm_sockets.h */
-#ifndef VMADDR_CID_LOCAL
-#define VMADDR_CID_LOCAL 1
-#endif
-
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
@@ -32,263 +27,7 @@
 #include "test_progs.h"
 #include "test_sockmap_listen.skel.h"
 
-#define IO_TIMEOUT_SEC 30
-#define MAX_STRERR_LEN 256
-#define MAX_TEST_NAME 80
-
-#define __always_unused	__attribute__((__unused__))
-
-#define _FAIL(errnum, fmt...)                                                  \
-	({                                                                     \
-		error_at_line(0, (errnum), __func__, __LINE__, fmt);           \
-		CHECK_FAIL(true);                                              \
-	})
-#define FAIL(fmt...) _FAIL(0, fmt)
-#define FAIL_ERRNO(fmt...) _FAIL(errno, fmt)
-#define FAIL_LIBBPF(err, msg)                                                  \
-	({                                                                     \
-		char __buf[MAX_STRERR_LEN];                                    \
-		libbpf_strerror((err), __buf, sizeof(__buf));                  \
-		FAIL("%s: %s", (msg), __buf);                                  \
-	})
-
-/* Wrappers that fail the test on error and report it. */
-
-#define xaccept_nonblock(fd, addr, len)                                        \
-	({                                                                     \
-		int __ret =                                                    \
-			accept_timeout((fd), (addr), (len), IO_TIMEOUT_SEC);   \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("accept");                                  \
-		__ret;                                                         \
-	})
-
-#define xbind(fd, addr, len)                                                   \
-	({                                                                     \
-		int __ret = bind((fd), (addr), (len));                         \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("bind");                                    \
-		__ret;                                                         \
-	})
-
-#define xclose(fd)                                                             \
-	({                                                                     \
-		int __ret = close((fd));                                       \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("close");                                   \
-		__ret;                                                         \
-	})
-
-#define xconnect(fd, addr, len)                                                \
-	({                                                                     \
-		int __ret = connect((fd), (addr), (len));                      \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("connect");                                 \
-		__ret;                                                         \
-	})
-
-#define xgetsockname(fd, addr, len)                                            \
-	({                                                                     \
-		int __ret = getsockname((fd), (addr), (len));                  \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("getsockname");                             \
-		__ret;                                                         \
-	})
-
-#define xgetsockopt(fd, level, name, val, len)                                 \
-	({                                                                     \
-		int __ret = getsockopt((fd), (level), (name), (val), (len));   \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("getsockopt(" #name ")");                   \
-		__ret;                                                         \
-	})
-
-#define xlisten(fd, backlog)                                                   \
-	({                                                                     \
-		int __ret = listen((fd), (backlog));                           \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("listen");                                  \
-		__ret;                                                         \
-	})
-
-#define xsetsockopt(fd, level, name, val, len)                                 \
-	({                                                                     \
-		int __ret = setsockopt((fd), (level), (name), (val), (len));   \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("setsockopt(" #name ")");                   \
-		__ret;                                                         \
-	})
-
-#define xsend(fd, buf, len, flags)                                             \
-	({                                                                     \
-		ssize_t __ret = send((fd), (buf), (len), (flags));             \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("send");                                    \
-		__ret;                                                         \
-	})
-
-#define xrecv_nonblock(fd, buf, len, flags)                                    \
-	({                                                                     \
-		ssize_t __ret = recv_timeout((fd), (buf), (len), (flags),      \
-					     IO_TIMEOUT_SEC);                  \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("recv");                                    \
-		__ret;                                                         \
-	})
-
-#define xsocket(family, sotype, flags)                                         \
-	({                                                                     \
-		int __ret = socket(family, sotype, flags);                     \
-		if (__ret == -1)                                               \
-			FAIL_ERRNO("socket");                                  \
-		__ret;                                                         \
-	})
-
-#define xbpf_map_delete_elem(fd, key)                                          \
-	({                                                                     \
-		int __ret = bpf_map_delete_elem((fd), (key));                  \
-		if (__ret < 0)                                               \
-			FAIL_ERRNO("map_delete");                              \
-		__ret;                                                         \
-	})
-
-#define xbpf_map_lookup_elem(fd, key, val)                                     \
-	({                                                                     \
-		int __ret = bpf_map_lookup_elem((fd), (key), (val));           \
-		if (__ret < 0)                                               \
-			FAIL_ERRNO("map_lookup");                              \
-		__ret;                                                         \
-	})
-
-#define xbpf_map_update_elem(fd, key, val, flags)                              \
-	({                                                                     \
-		int __ret = bpf_map_update_elem((fd), (key), (val), (flags));  \
-		if (__ret < 0)                                               \
-			FAIL_ERRNO("map_update");                              \
-		__ret;                                                         \
-	})
-
-#define xbpf_prog_attach(prog, target, type, flags)                            \
-	({                                                                     \
-		int __ret =                                                    \
-			bpf_prog_attach((prog), (target), (type), (flags));    \
-		if (__ret < 0)                                               \
-			FAIL_ERRNO("prog_attach(" #type ")");                  \
-		__ret;                                                         \
-	})
-
-#define xbpf_prog_detach2(prog, target, type)                                  \
-	({                                                                     \
-		int __ret = bpf_prog_detach2((prog), (target), (type));        \
-		if (__ret < 0)                                               \
-			FAIL_ERRNO("prog_detach2(" #type ")");                 \
-		__ret;                                                         \
-	})
-
-#define xpthread_create(thread, attr, func, arg)                               \
-	({                                                                     \
-		int __ret = pthread_create((thread), (attr), (func), (arg));   \
-		errno = __ret;                                                 \
-		if (__ret)                                                     \
-			FAIL_ERRNO("pthread_create");                          \
-		__ret;                                                         \
-	})
-
-#define xpthread_join(thread, retval)                                          \
-	({                                                                     \
-		int __ret = pthread_join((thread), (retval));                  \
-		errno = __ret;                                                 \
-		if (__ret)                                                     \
-			FAIL_ERRNO("pthread_join");                            \
-		__ret;                                                         \
-	})
-
-static int poll_read(int fd, unsigned int timeout_sec)
-{
-	struct timeval timeout = { .tv_sec = timeout_sec };
-	fd_set rfds;
-	int r;
-
-	FD_ZERO(&rfds);
-	FD_SET(fd, &rfds);
-
-	r = select(fd + 1, &rfds, NULL, NULL, &timeout);
-	if (r == 0)
-		errno = ETIME;
-
-	return r == 1 ? 0 : -1;
-}
-
-static int accept_timeout(int fd, struct sockaddr *addr, socklen_t *len,
-			  unsigned int timeout_sec)
-{
-	if (poll_read(fd, timeout_sec))
-		return -1;
-
-	return accept(fd, addr, len);
-}
-
-static int recv_timeout(int fd, void *buf, size_t len, int flags,
-			unsigned int timeout_sec)
-{
-	if (poll_read(fd, timeout_sec))
-		return -1;
-
-	return recv(fd, buf, len, flags);
-}
-
-static void init_addr_loopback4(struct sockaddr_storage *ss, socklen_t *len)
-{
-	struct sockaddr_in *addr4 = memset(ss, 0, sizeof(*ss));
-
-	addr4->sin_family = AF_INET;
-	addr4->sin_port = 0;
-	addr4->sin_addr.s_addr = htonl(INADDR_LOOPBACK);
-	*len = sizeof(*addr4);
-}
-
-static void init_addr_loopback6(struct sockaddr_storage *ss, socklen_t *len)
-{
-	struct sockaddr_in6 *addr6 = memset(ss, 0, sizeof(*ss));
-
-	addr6->sin6_family = AF_INET6;
-	addr6->sin6_port = 0;
-	addr6->sin6_addr = in6addr_loopback;
-	*len = sizeof(*addr6);
-}
-
-static void init_addr_loopback_vsock(struct sockaddr_storage *ss, socklen_t *len)
-{
-	struct sockaddr_vm *addr = memset(ss, 0, sizeof(*ss));
-
-	addr->svm_family = AF_VSOCK;
-	addr->svm_port = VMADDR_PORT_ANY;
-	addr->svm_cid = VMADDR_CID_LOCAL;
-	*len = sizeof(*addr);
-}
-
-static void init_addr_loopback(int family, struct sockaddr_storage *ss,
-			       socklen_t *len)
-{
-	switch (family) {
-	case AF_INET:
-		init_addr_loopback4(ss, len);
-		return;
-	case AF_INET6:
-		init_addr_loopback6(ss, len);
-		return;
-	case AF_VSOCK:
-		init_addr_loopback_vsock(ss, len);
-		return;
-	default:
-		FAIL("unsupported address family %d", family);
-	}
-}
-
-static inline struct sockaddr *sockaddr(struct sockaddr_storage *ss)
-{
-	return (struct sockaddr *)ss;
-}
+#include "sockmap_helpers.h"
 
 static int enable_reuseport(int s, int progfd)
 {
-- 
2.33.0


