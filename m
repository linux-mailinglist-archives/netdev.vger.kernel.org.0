Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84296BD099
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 14:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjCPNRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 09:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjCPNRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 09:17:38 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D3ECD646
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 06:17:14 -0700 (PDT)
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6A55441B67
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 13:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678972632;
        bh=mKoRo4SwM93Mj0Ez4DVaUZmdns1DfPb0shyS9HBPsf4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=HkGC6sqbjTHZNgHJQ9x18Ky0sCkpmaBmQkr10LYc77hlJ7sw9tlgZogpKU+gMF312
         EmjArsdHksrqrtw5rSFGAi8ItTn6/CcYPsxLwyu5MP82bweAWmlNv9i/An5RMDX5s6
         eh/zFXJbuL+7NSspXNhcOJx+3oUA5JAVwxFvXXGKg3FdMTBTzEJ8AKSpcqwgJFwWNT
         6oLR0nIzFWQjqftW81F8prp6AhP4/3eu5ToY5jHnoHce4XzvOWEyWDFqkZCUSkBywZ
         kN7se4SYlBsipri+eojl91LYfwr2QV0lgc1XmBY5od2hI3UXkyBYwCjAgrLBNvGl6M
         3kgDNAZjMoVvQ==
Received: by mail-ed1-f72.google.com with SMTP id h11-20020a0564020e8b00b004e59d4722a3so3011064eda.6
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 06:17:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678972632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mKoRo4SwM93Mj0Ez4DVaUZmdns1DfPb0shyS9HBPsf4=;
        b=Pp2+MExbVCQ/b7hQyzDEpitRLd1P4RCGoFwPvQJHLIXQz/1VlDZblmsGPky8/aLWub
         4Vtjnanh2iB2JX9buLsSXY+x5LFjE/HahFS0RLwwq3RvWo4p8ZiNupSp3LaqGgSSQkxR
         rfk0K4A4eN1v4FZHYJieCqhXqCrgWh2inovSLHMPPTSJdkUjqpv/DPSup3rSK5LBQ5xu
         DBGAgbPjzTGgoFe4pUu6qp7+guhNHeTD+isiH3F6rZgMOdf4FJ4mKOIhE5eY632BjpR8
         eEKDyJAXqp7XcZ+m0WV8cnwlcFsPg2hoddPkR8TZIOMx/dbnnu8Fv+O4/+5HTlqC/JBK
         cO7Q==
X-Gm-Message-State: AO0yUKVHXuMN5iT5XCGi6iaUHpEqbzlMzyZJhe5V6aASsl4elKIjYxMf
        Eqqpm145XXKMpj917uxMJGo52RKsVkQArQ8fY3C789bukJW1Y/vvGkvp8DR+f+8/DdYPvn989ht
        xe7hOCF/AdjPifKuMYYm4z872S9bwCRQHjw==
X-Received: by 2002:a05:6402:1018:b0:4fc:9a22:e0d2 with SMTP id c24-20020a056402101800b004fc9a22e0d2mr6450791edu.14.1678972632254;
        Thu, 16 Mar 2023 06:17:12 -0700 (PDT)
X-Google-Smtp-Source: AK7set8AZ6IZz/e9zfm1oQZj5U0KdlnAl4k6i5Mwqfg8G4vNUcONa38ZkunHJ33c5ydPsTSh+LjIWg==
X-Received: by 2002:a05:6402:1018:b0:4fc:9a22:e0d2 with SMTP id c24-20020a056402101800b004fc9a22e0d2mr6450778edu.14.1678972632078;
        Thu, 16 Mar 2023 06:17:12 -0700 (PDT)
Received: from amikhalitsyn.. ([2a02:8109:bd40:1414:5e7c:880e:420d:8cc7])
        by smtp.gmail.com with ESMTPSA id d20-20020a50cd54000000b004fd1ee3f723sm3812336edj.67.2023.03.16.06.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 06:17:11 -0700 (PDT)
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
        linux-arch@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 3/3] selftests: net: add SCM_PIDFD / SO_PEERPIDFD test
Date:   Thu, 16 Mar 2023 14:15:26 +0100
Message-Id: <20230316131526.283569-4-aleksandr.mikhalitsyn@canonical.com>
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

Basic test to check consistency between:
- SCM_CREDENTIALS and SCM_PIDFD
- SO_PEERCRED and SO_PEERPIDFD

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
Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/af_unix/Makefile  |   3 +-
 .../testing/selftests/net/af_unix/scm_pidfd.c | 336 ++++++++++++++++++
 3 files changed, 339 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/af_unix/scm_pidfd.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index a6911cae368c..f2d23a1df596 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -25,6 +25,7 @@ reuseport_bpf_cpu
 reuseport_bpf_numa
 reuseport_dualstack
 rxtimestamp
+scm_pidfd
 sk_bind_sendto_listen
 sk_connect_zero_addr
 socket
diff --git a/tools/testing/selftests/net/af_unix/Makefile b/tools/testing/selftests/net/af_unix/Makefile
index 1e4b397cece6..221c387a7d7f 100644
--- a/tools/testing/selftests/net/af_unix/Makefile
+++ b/tools/testing/selftests/net/af_unix/Makefile
@@ -1,3 +1,4 @@
-TEST_GEN_PROGS := diag_uid test_unix_oob unix_connect
+CFLAGS += $(KHDR_INCLUDES)
+TEST_GEN_PROGS := diag_uid test_unix_oob unix_connect scm_pidfd
 
 include ../../lib.mk
diff --git a/tools/testing/selftests/net/af_unix/scm_pidfd.c b/tools/testing/selftests/net/af_unix/scm_pidfd.c
new file mode 100644
index 000000000000..fa502510ee9e
--- /dev/null
+++ b/tools/testing/selftests/net/af_unix/scm_pidfd.c
@@ -0,0 +1,336 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <error.h>
+#include <limits.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/socket.h>
+#include <linux/socket.h>
+#include <unistd.h>
+#include <string.h>
+#include <errno.h>
+#include <sys/un.h>
+#include <sys/signal.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#define clean_errno() (errno == 0 ? "None" : strerror(errno))
+#define log_err(MSG, ...)                                                   \
+	fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", __FILE__, __LINE__, \
+		clean_errno(), ##__VA_ARGS__)
+
+#ifndef SCM_PIDFD
+#define SCM_PIDFD 0x04
+#endif
+
+static pid_t client_pid;
+static char sock_name[32];
+
+static void die(int status)
+{
+	unlink(sock_name);
+	kill(client_pid, SIGTERM);
+	exit(status);
+}
+
+static void child_die()
+{
+	kill(getppid(), SIGTERM);
+	exit(1);
+}
+
+static int safe_int(const char *numstr, int *converted)
+{
+	char *err = NULL;
+	long sli;
+
+	errno = 0;
+	sli = strtol(numstr, &err, 0);
+	if (errno == ERANGE && (sli == LONG_MAX || sli == LONG_MIN))
+		return -ERANGE;
+
+	if (errno != 0 && sli == 0)
+		return -EINVAL;
+
+	if (err == numstr || *err != '\0')
+		return -EINVAL;
+
+	if (sli > INT_MAX || sli < INT_MIN)
+		return -ERANGE;
+
+	*converted = (int)sli;
+	return 0;
+}
+
+static int char_left_gc(const char *buffer, size_t len)
+{
+	size_t i;
+
+	for (i = 0; i < len; i++) {
+		if (buffer[i] == ' ' || buffer[i] == '\t')
+			continue;
+
+		return i;
+	}
+
+	return 0;
+}
+
+static int char_right_gc(const char *buffer, size_t len)
+{
+	int i;
+
+	for (i = len - 1; i >= 0; i--) {
+		if (buffer[i] == ' ' || buffer[i] == '\t' ||
+		    buffer[i] == '\n' || buffer[i] == '\0')
+			continue;
+
+		return i + 1;
+	}
+
+	return 0;
+}
+
+static char *trim_whitespace_in_place(char *buffer)
+{
+	buffer += char_left_gc(buffer, strlen(buffer));
+	buffer[char_right_gc(buffer, strlen(buffer))] = '\0';
+	return buffer;
+}
+
+/* borrowed (with all helpers) from pidfd/pidfd_open_test.c */
+static pid_t get_pid_from_fdinfo_file(int pidfd, const char *key, size_t keylen)
+{
+	int ret;
+	char path[512];
+	FILE *f;
+	size_t n = 0;
+	pid_t result = -1;
+	char *line = NULL;
+
+	snprintf(path, sizeof(path), "/proc/self/fdinfo/%d", pidfd);
+
+	f = fopen(path, "re");
+	if (!f)
+		return -1;
+
+	while (getline(&line, &n, f) != -1) {
+		char *numstr;
+
+		if (strncmp(line, key, keylen))
+			continue;
+
+		numstr = trim_whitespace_in_place(line + 4);
+		ret = safe_int(numstr, &result);
+		if (ret < 0)
+			goto out;
+
+		break;
+	}
+
+out:
+	free(line);
+	fclose(f);
+	return result;
+}
+
+static int cmsg_check(int fd)
+{
+	struct msghdr msg = { 0 };
+	struct cmsghdr *cmsg;
+	struct iovec iov;
+	struct ucred *ucred = NULL;
+	int data = 0;
+	char control[CMSG_SPACE(sizeof(struct ucred)) +
+		     CMSG_SPACE(sizeof(int))] = { 0 };
+	int *pidfd = NULL;
+	pid_t parent_pid;
+	int err;
+
+	iov.iov_base = &data;
+	iov.iov_len = sizeof(data);
+
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+	msg.msg_control = control;
+	msg.msg_controllen = sizeof(control);
+
+	err = recvmsg(fd, &msg, 0);
+	if (err < 0) {
+		log_err("recvmsg");
+		return 1;
+	}
+
+	if (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC)) {
+		log_err("recvmsg: truncated");
+		return 1;
+	}
+
+	for (cmsg = CMSG_FIRSTHDR(&msg); cmsg != NULL;
+	     cmsg = CMSG_NXTHDR(&msg, cmsg)) {
+		if (cmsg->cmsg_level == SOL_SOCKET &&
+		    cmsg->cmsg_type == SCM_PIDFD) {
+			if (cmsg->cmsg_len < sizeof(*pidfd)) {
+				log_err("CMSG parse: SCM_PIDFD wrong len");
+				return 1;
+			}
+
+			pidfd = (void *)CMSG_DATA(cmsg);
+		}
+
+		if (cmsg->cmsg_level == SOL_SOCKET &&
+		    cmsg->cmsg_type == SCM_CREDENTIALS) {
+			if (cmsg->cmsg_len < sizeof(*ucred)) {
+				log_err("CMSG parse: SCM_CREDENTIALS wrong len");
+				return 1;
+			}
+
+			ucred = (void *)CMSG_DATA(cmsg);
+		}
+	}
+
+	/* send(pfd, "x", sizeof(char), 0) */
+	if (data != 'x') {
+		log_err("recvmsg: data corruption");
+		return 1;
+	}
+
+	if (!pidfd) {
+		log_err("CMSG parse: SCM_PIDFD not found");
+		return 1;
+	}
+
+	if (!ucred) {
+		log_err("CMSG parse: SCM_CREDENTIALS not found");
+		return 1;
+	}
+
+	/* pidfd from SCM_PIDFD should point to the parent process PID */
+	parent_pid =
+		get_pid_from_fdinfo_file(*pidfd, "Pid:", sizeof("Pid:") - 1);
+	if (parent_pid != getppid()) {
+		log_err("wrong SCM_PIDFD %d != %d", parent_pid, getppid());
+		return 1;
+	}
+
+	return 0;
+}
+
+void client(struct sockaddr_un *listen_addr)
+{
+	int cfd;
+	socklen_t len;
+	struct ucred peer_cred;
+	int peer_pidfd;
+	pid_t peer_pid;
+	int on = 0;
+
+	cfd = socket(AF_UNIX, SOCK_STREAM, 0);
+	if (cfd < 0) {
+		log_err("socket");
+		child_die();
+	}
+
+	if (connect(cfd, (struct sockaddr *)listen_addr,
+		    sizeof(*listen_addr)) != 0) {
+		log_err("connect");
+		child_die();
+	}
+
+	on = 1;
+	if (setsockopt(cfd, SOL_SOCKET, SO_PASSCRED, &on, sizeof(on))) {
+		log_err("Failed to set SO_PASSCRED");
+		child_die();
+	}
+
+	if (setsockopt(cfd, SOL_SOCKET, SO_PASSPIDFD, &on, sizeof(on))) {
+		log_err("Failed to set SO_PASSPIDFD");
+		child_die();
+	}
+
+	if (cmsg_check(cfd)) {
+		log_err("cmsg_check failed");
+		child_die();
+	}
+
+	len = sizeof(peer_cred);
+	if (getsockopt(cfd, SOL_SOCKET, SO_PEERCRED, &peer_cred, &len)) {
+		log_err("Failed to get SO_PEERCRED");
+		child_die();
+	}
+
+	len = sizeof(peer_pidfd);
+	if (getsockopt(cfd, SOL_SOCKET, SO_PEERPIDFD, &peer_pidfd, &len)) {
+		log_err("Failed to get SO_PEERPIDFD");
+		child_die();
+	}
+
+	/* pid from SO_PEERCRED should point to the parent process PID */
+	if (peer_cred.pid != getppid()) {
+		log_err("Failed to get SO_PEERPIDFD");
+		child_die();
+	}
+
+	peer_pid = get_pid_from_fdinfo_file(peer_pidfd,
+					    "Pid:", sizeof("Pid:") - 1);
+	if (peer_pid != peer_cred.pid) {
+		log_err("Failed to get SO_PEERPIDFD");
+		child_die();
+	}
+}
+
+int main(int argc, char **argv)
+{
+	int lfd, pfd;
+	int child_status = 0;
+	struct sockaddr_un listen_addr;
+
+	lfd = socket(AF_UNIX, SOCK_STREAM, 0);
+	if (lfd < 0) {
+		perror("socket");
+		exit(1);
+	}
+
+	memset(&listen_addr, 0, sizeof(listen_addr));
+	listen_addr.sun_family = AF_UNIX;
+	sprintf(sock_name, "scm_pidfd_%d", getpid());
+	unlink(sock_name);
+	strcpy(listen_addr.sun_path, sock_name);
+
+	if ((bind(lfd, (struct sockaddr *)&listen_addr, sizeof(listen_addr))) !=
+	    0) {
+		perror("socket bind failed");
+		exit(1);
+	}
+
+	if (listen(lfd, 1) < 0) {
+		perror("listen");
+		exit(1);
+	}
+
+	client_pid = fork();
+	if (client_pid < 0) {
+		perror("fork");
+		exit(1);
+	}
+
+	if (client_pid == 0) {
+		client(&listen_addr);
+		exit(0);
+	}
+
+	pfd = accept(lfd, NULL, NULL);
+	if (pfd < 0) {
+		perror("accept");
+		die(1);
+	}
+
+	if (send(pfd, "x", sizeof(char), 0) < 0) {
+		perror("send");
+		die(1);
+	}
+
+	waitpid(client_pid, &child_status, 0);
+	die(WIFEXITED(child_status) ? WEXITSTATUS(child_status) : 1);
+	die(0);
+}
\ No newline at end of file
-- 
2.34.1

