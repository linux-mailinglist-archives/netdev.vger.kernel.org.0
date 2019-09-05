Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB112AA74D
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 17:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390461AbfIEP1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 11:27:30 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:46270 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390456AbfIEP11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 11:27:27 -0400
Received: by mail-pf1-f201.google.com with SMTP id f2so2084751pfk.13
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 08:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lTHI3kK5VYAt2CUHcJhzYihkdJRkFD9/pz9e86BhyNk=;
        b=dbRXurRGjsoIm7XS6NUTHIkKM1cvq603d5n3+CY+WiSo1vSDjJYST127Frp1uhdu0L
         lM4dGvObc0J7TY53KOogvQGXgV5lMyiNEg6EZwxiH7ap449GfPzbg4m9GopUWASdTzOp
         T2ktnzhPkTPBm5OsxFZm+AwNKkD6PJoHQLs4xa9UiTzQGg902UWcSks0GM6eRUQ1pAdX
         QkvFE7Q1rB/RpAywXRBkPwR8M7VXU5WBZ3Tg/08SY5iM1G84P7MrHSTCfLIJ4E/+GhNL
         /qFeKK2RRLymO87CXQYEekdGY8cO6SAJTzxVq9djiv26zVWT9DB5nAwGh9wUwlPQhnFO
         0zNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lTHI3kK5VYAt2CUHcJhzYihkdJRkFD9/pz9e86BhyNk=;
        b=YAVuUVwp+Czuty8REig087gdJU6XVwrvpsgw8AKeZhm3XAzO7OaSgf0B4MBA4AQACa
         zTUcUa5UJthFkOWEDZoU1ag7nXLj2sD1XUPlHmR0bhmNAu1gjWPeACLfFaSs67WlBKYO
         uSmMi7+gswMaHHqEzFJgclD6lPzLLyYfd8KTKtSlkFUpRCD0Mb038P2ty/MVHn0YnK4N
         VlRMqY63KVgDQ8SjZotXV4qQwtQpE18xAGBfx/06h5erH18CGdurZpi+WH3eKs+3x07E
         Lk64iZIBFAbVb7wFbnqQdM3apJqtJqZgnUvRXp0EbfXXBavZwk44urQys1dKGuY8ychK
         1pHg==
X-Gm-Message-State: APjAAAXl7JUejCRNAKslh6CkdV+RGjyIFa6GgcTTEYRFNqbuQ9bQIKSl
        3Ru+Dy9HZfpHrTsX+1DpDwiegb3mYXTTwYHoNwQ/qa70pE4Vtc0SDKrJnLFeXxr8bt2IOn/QulG
        nW+5jghNO4Tbbhag81afEwfWFZ0MS4eryK8aImcwr7O7+9Hxywp/s8g==
X-Google-Smtp-Source: APXvYqzO8KFBDN3XXKCFYnMJLJFUojMRg9vpzHWGOumWWaLiCBuyWxzMLc+IFQ1ZmGVP32wVLBTmThY=
X-Received: by 2002:a63:7e41:: with SMTP id o1mr3786395pgn.212.1567697246413;
 Thu, 05 Sep 2019 08:27:26 -0700 (PDT)
Date:   Thu,  5 Sep 2019 08:27:09 -0700
In-Reply-To: <20190905152709.111193-1-sdf@google.com>
Message-Id: <20190905152709.111193-7-sdf@google.com>
Mime-Version: 1.0
References: <20190905152709.111193-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH bpf-next v2 6/6] selftests/bpf: test_progs: convert test_tcp_rtt
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the files, adjust includes, remove entry from Makefile & .gitignore

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/.gitignore        |  1 -
 tools/testing/selftests/bpf/Makefile          |  3 +-
 .../{test_tcp_rtt.c => prog_tests/tcp_rtt.c}  | 83 ++++++-------------
 3 files changed, 28 insertions(+), 59 deletions(-)
 rename tools/testing/selftests/bpf/{test_tcp_rtt.c => prog_tests/tcp_rtt.c} (76%)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 5b06bb45b500..7470327edcfe 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -39,4 +39,3 @@ libbpf.so.*
 test_hashmap
 test_btf_dump
 xdping
-test_tcp_rtt
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index fe786df1174b..811f1b24d02b 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -28,7 +28,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
-	test_btf_dump test_cgroup_attach xdping test_tcp_rtt
+	test_btf_dump test_cgroup_attach xdping
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
@@ -108,7 +108,6 @@ $(OUTPUT)/test_netcnt: cgroup_helpers.c
 $(OUTPUT)/test_sock_fields: cgroup_helpers.c
 $(OUTPUT)/test_sysctl: cgroup_helpers.c
 $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
-$(OUTPUT)/test_tcp_rtt: cgroup_helpers.c
 
 .PHONY: force
 
diff --git a/tools/testing/selftests/bpf/test_tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
similarity index 76%
rename from tools/testing/selftests/bpf/test_tcp_rtt.c
rename to tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
index 93916a69823e..fdc0b3614a9e 100644
--- a/tools/testing/selftests/bpf/test_tcp_rtt.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
@@ -1,24 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <error.h>
-#include <errno.h>
-#include <stdio.h>
-#include <unistd.h>
-#include <sys/types.h>
-#include <sys/socket.h>
-#include <netinet/in.h>
-#include <netinet/tcp.h>
-#include <pthread.h>
-
-#include <linux/filter.h>
-#include <bpf/bpf.h>
-#include <bpf/libbpf.h>
-
-#include "bpf_rlimit.h"
-#include "bpf_util.h"
+#include <test_progs.h>
 #include "cgroup_helpers.h"
 
-#define CG_PATH                                "/tcp_rtt"
-
 struct tcp_rtt_storage {
 	__u32 invoked;
 	__u32 dsack_dups;
@@ -31,8 +14,8 @@ static void send_byte(int fd)
 {
 	char b = 0x55;
 
-	if (write(fd, &b, sizeof(b)) != 1)
-		error(1, errno, "Failed to send single byte");
+	if (CHECK_FAIL(write(fd, &b, sizeof(b)) != 1))
+		perror("Failed to send single byte");
 }
 
 static int wait_for_ack(int fd, int retries)
@@ -66,8 +49,10 @@ static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 invoked,
 	int err = 0;
 	struct tcp_rtt_storage val;
 
-	if (bpf_map_lookup_elem(map_fd, &client_fd, &val) < 0)
-		error(1, errno, "Failed to read socket storage");
+	if (CHECK_FAIL(bpf_map_lookup_elem(map_fd, &client_fd, &val) < 0)) {
+		perror("Failed to read socket storage");
+		return -1;
+	}
 
 	if (val.invoked != invoked) {
 		log_err("%s: unexpected bpf_tcp_sock.invoked %d != %d",
@@ -225,61 +210,47 @@ static void *server_thread(void *arg)
 	int fd = *(int *)arg;
 	int client_fd;
 
-	if (listen(fd, 1) < 0)
-		error(1, errno, "Failed to listed on socket");
+	if (CHECK_FAIL(listen(fd, 1)) < 0) {
+		perror("Failed to listed on socket");
+		return NULL;
+	}
 
 	client_fd = accept(fd, (struct sockaddr *)&addr, &len);
-	if (client_fd < 0)
-		error(1, errno, "Failed to accept client");
+	if (CHECK_FAIL(client_fd < 0)) {
+		perror("Failed to accept client");
+		return NULL;
+	}
 
 	/* Wait for the next connection (that never arrives)
 	 * to keep this thread alive to prevent calling
 	 * close() on client_fd.
 	 */
-	if (accept(fd, (struct sockaddr *)&addr, &len) >= 0)
-		error(1, errno, "Unexpected success in second accept");
+	if (CHECK_FAIL(accept(fd, (struct sockaddr *)&addr, &len) >= 0)) {
+		perror("Unexpected success in second accept");
+		return NULL;
+	}
 
 	close(client_fd);
 
 	return NULL;
 }
 
-int main(int args, char **argv)
+void test_tcp_rtt(void)
 {
 	int server_fd, cgroup_fd;
-	int err = EXIT_SUCCESS;
 	pthread_t tid;
 
-	if (setup_cgroup_environment())
-		goto cleanup_obj;
-
-	cgroup_fd = create_and_get_cgroup(CG_PATH);
-	if (cgroup_fd < 0)
-		goto cleanup_cgroup_env;
-
-	if (join_cgroup(CG_PATH))
-		goto cleanup_cgroup;
+	cgroup_fd = test__join_cgroup("/tcp_rtt");
+	if (CHECK_FAIL(cgroup_fd < 0))
+		return;
 
 	server_fd = start_server();
-	if (server_fd < 0) {
-		err = EXIT_FAILURE;
-		goto cleanup_cgroup;
-	}
+	if (CHECK_FAIL(server_fd < 0))
+		goto close_cgroup_fd;
 
 	pthread_create(&tid, NULL, server_thread, (void *)&server_fd);
-
-	if (run_test(cgroup_fd, server_fd))
-		err = EXIT_FAILURE;
-
+	CHECK_FAIL(run_test(cgroup_fd, server_fd));
 	close(server_fd);
-
-	printf("test_sockopt_sk: %s\n",
-	       err == EXIT_SUCCESS ? "PASSED" : "FAILED");
-
-cleanup_cgroup:
+close_cgroup_fd:
 	close(cgroup_fd);
-cleanup_cgroup_env:
-	cleanup_cgroup_environment();
-cleanup_obj:
-	return err;
 }
-- 
2.23.0.187.g17f5b7556c-goog

