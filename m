Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68510691B64
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 10:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjBJJcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 04:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbjBJJc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 04:32:27 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B99459E6C;
        Fri, 10 Feb 2023 01:32:26 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id r17so3086759pff.9;
        Fri, 10 Feb 2023 01:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+kj35ks66WHHoBPnrkWUWvEbE3+zc9azQZ+XX4tuL+U=;
        b=mj1BkU6JTNKiu9qykCyJV7BHA3eiWWH/1vrF36+r8B/ztUuBpsVo7JpFySd8FcJ5zH
         B0pN6kW/a1RfNN+a04Z8SA3yuAaKkEkgGk5gsq7waB23J071H/PKCNDCDOVImIwMpbjJ
         KcKrugRniL8HJD/bfHF3oqRDQIGsElufku6yiqTZLJX03WmBEHnbpJj2otImz6t9ys3D
         0A5oNY0Ud4G+E0aeymFyoYV7a70Gf01Cya7XUbmNVfilQN+0wpY1QHDtff//8qKWrHtG
         hNrw1+8IzanqfA06LG0WCn3wVa2qc+TD/fsd4qjGMuOd0K3WprFE9pCJd6n1ejGMGt2F
         RxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+kj35ks66WHHoBPnrkWUWvEbE3+zc9azQZ+XX4tuL+U=;
        b=yZPGMpsJ2KTmEJsDBRTH1Hr5fxuXHLEldADmgb6TpPbUlFoo16r6yqAlUcbAGdSRNJ
         drUiWKvekRMwKwSuAVCr9/SRrmMCyWVs3N/pwxtRfjEPSe7EA861M9sFFv+kOo9BRT7X
         SNgaOyeL7T3B7Ul0NZDxkU5wUAqHu7yaB3hsl9T9WsWGMUMw3z87h7MWWNxuOE/010lz
         hORBtl+wuhpZ5iKIt60fYkM8CnXrng8KtJtEjnpktnQn/XcQclUpVek7NZ+UfVDcI/jA
         PsEsxk0SzX1GdvZy1KyqZY16E5CdgOE01p+VJP4KoR51tb6HAR+ZqXpkEMZ0SK4Ec9OJ
         YMsQ==
X-Gm-Message-State: AO0yUKUq12lwgwsO2dvxm0/W328Mi5NXr5Tis0m+zN/IQI6N6aaEZ4Xw
        uGHjkSprTtVDfxLoM+DFuHo5Y9/Aqha32BTm
X-Google-Smtp-Source: AK7set/M+g3fFo9kHQW36E4RFcnXT+sdJu0m1NSDkUL3A/qF7v2OdhoaLXZ49cE3hQd91VZ9K/zBNA==
X-Received: by 2002:a62:15c9:0:b0:5a8:4ba7:584b with SMTP id 192-20020a6215c9000000b005a84ba7584bmr7769893pfv.26.1676021545184;
        Fri, 10 Feb 2023 01:32:25 -0800 (PST)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c19-20020a62e813000000b00593edee1af6sm2860621pfi.67.2023.02.10.01.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 01:32:24 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Felix Maurer <fmaurer@redhat.com>,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf] selftests/bpf: enable mptcp before testing
Date:   Fri, 10 Feb 2023 17:32:05 +0800
Message-Id: <20230210093205.1378597-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some distros may not enable mptcp by default. Enable it before start the
mptcp server. To use the {read/write}_int_sysctl() functions, I moved
them to test_progs.c

Fixes: 8039d353217c ("selftests/bpf: Add MPTCP test base")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 15 ++++++-
 .../bpf/prog_tests/select_reuseport.c         | 43 -------------------
 tools/testing/selftests/bpf/test_progs.c      | 36 ++++++++++++++++
 tools/testing/selftests/bpf/test_progs.h      |  9 ++++
 4 files changed, 59 insertions(+), 44 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
index 59f08d6d1d53..c0a0ee7abd06 100644
--- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
+++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
@@ -11,6 +11,8 @@
 #define TCP_CA_NAME_MAX	16
 #endif
 
+#define MPTCP_ENABLED_SYSCTL "/proc/sys/net/mptcp/enabled"
+
 struct mptcp_storage {
 	__u32 invoked;
 	__u32 is_mptcp;
@@ -138,7 +140,7 @@ static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
 
 static void test_base(void)
 {
-	int server_fd, cgroup_fd;
+	int server_fd, cgroup_fd, saved_mptcp_enabled = -1;
 
 	cgroup_fd = test__join_cgroup("/mptcp");
 	if (!ASSERT_GE(cgroup_fd, 0, "test__join_cgroup"))
@@ -155,6 +157,14 @@ static void test_base(void)
 
 with_mptcp:
 	/* with MPTCP */
+	saved_mptcp_enabled = read_int_sysctl(MPTCP_ENABLED_SYSCTL);
+	if (saved_mptcp_enabled < 0)
+		goto close_cgroup_fd;
+
+	if (saved_mptcp_enabled == 0 &&
+	    write_int_sysctl(MPTCP_ENABLED_SYSCTL, 1))
+		goto close_cgroup_fd;
+
 	server_fd = start_mptcp_server(AF_INET, NULL, 0, 0);
 	if (!ASSERT_GE(server_fd, 0, "start_mptcp_server"))
 		goto close_cgroup_fd;
@@ -164,6 +174,9 @@ static void test_base(void)
 	close(server_fd);
 
 close_cgroup_fd:
+	if (saved_mptcp_enabled == 0)
+		write_int_sysctl(MPTCP_ENABLED_SYSCTL, saved_mptcp_enabled);
+
 	close(cgroup_fd);
 }
 
diff --git a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
index 64c5f5eb2994..cdf9dd626877 100644
--- a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
+++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
@@ -56,13 +56,6 @@ static union sa46 {
 	}								\
 })
 
-#define RET_ERR(condition, tag, format...) ({				\
-	if (CHECK_FAIL(condition)) {					\
-		printf(tag " " format);					\
-		return -1;						\
-	}								\
-})
-
 static int create_maps(enum bpf_map_type inner_type)
 {
 	LIBBPF_OPTS(bpf_map_create_opts, opts);
@@ -157,42 +150,6 @@ static void sa46_init_inany(union sa46 *sa, sa_family_t family)
 		sa->v4.sin_addr.s_addr = INADDR_ANY;
 }
 
-static int read_int_sysctl(const char *sysctl)
-{
-	char buf[16];
-	int fd, ret;
-
-	fd = open(sysctl, 0);
-	RET_ERR(fd == -1, "open(sysctl)",
-		"sysctl:%s fd:%d errno:%d\n", sysctl, fd, errno);
-
-	ret = read(fd, buf, sizeof(buf));
-	RET_ERR(ret <= 0, "read(sysctl)",
-		"sysctl:%s ret:%d errno:%d\n", sysctl, ret, errno);
-
-	close(fd);
-	return atoi(buf);
-}
-
-static int write_int_sysctl(const char *sysctl, int v)
-{
-	int fd, ret, size;
-	char buf[16];
-
-	fd = open(sysctl, O_RDWR);
-	RET_ERR(fd == -1, "open(sysctl)",
-		"sysctl:%s fd:%d errno:%d\n", sysctl, fd, errno);
-
-	size = snprintf(buf, sizeof(buf), "%d", v);
-	ret = write(fd, buf, size);
-	RET_ERR(ret != size, "write(sysctl)",
-		"sysctl:%s ret:%d size:%d errno:%d\n",
-		sysctl, ret, size, errno);
-
-	close(fd);
-	return 0;
-}
-
 static void restore_sysctls(void)
 {
 	if (saved_tcp_fo != -1)
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 4716e38e153a..d50599ccba9a 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -967,6 +967,42 @@ int write_sysctl(const char *sysctl, const char *value)
 	return 0;
 }
 
+int read_int_sysctl(const char *sysctl)
+{
+	char buf[16];
+	int fd, ret;
+
+	fd = open(sysctl, 0);
+	RET_ERR(fd == -1, "open(sysctl)",
+		"sysctl:%s fd:%d errno:%d\n", sysctl, fd, errno);
+
+	ret = read(fd, buf, sizeof(buf));
+	RET_ERR(ret <= 0, "read(sysctl)",
+		"sysctl:%s ret:%d errno:%d\n", sysctl, ret, errno);
+
+	close(fd);
+	return atoi(buf);
+}
+
+int write_int_sysctl(const char *sysctl, int v)
+{
+	int fd, ret, size;
+	char buf[16];
+
+	fd = open(sysctl, O_RDWR);
+	RET_ERR(fd == -1, "open(sysctl)",
+		"sysctl:%s fd:%d errno:%d\n", sysctl, fd, errno);
+
+	size = snprintf(buf, sizeof(buf), "%d", v);
+	ret = write(fd, buf, size);
+	RET_ERR(ret != size, "write(sysctl)",
+		"sysctl:%s ret:%d size:%d errno:%d\n",
+		sysctl, ret, size, errno);
+
+	close(fd);
+	return 0;
+}
+
 #define MAX_BACKTRACE_SZ 128
 void crash_handler(int signum)
 {
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 3f058dfadbaf..1522ea930bf6 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -376,6 +376,13 @@ int test__join_cgroup(const char *path);
 	___ok;								\
 })
 
+#define RET_ERR(condition, tag, format...) ({				\
+	if (CHECK_FAIL(condition)) {					\
+		printf(tag " " format);					\
+		return -1;						\
+	}								\
+})
+
 static inline __u64 ptr_to_u64(const void *ptr)
 {
 	return (__u64) (unsigned long) ptr;
@@ -394,6 +401,8 @@ int kern_sync_rcu(void);
 int trigger_module_test_read(int read_sz);
 int trigger_module_test_write(int write_sz);
 int write_sysctl(const char *sysctl, const char *value);
+int read_int_sysctl(const char *sysctl);
+int write_int_sysctl(const char *sysctl, int v);
 
 #ifdef __x86_64__
 #define SYS_NANOSLEEP_KPROBE_NAME "__x64_sys_nanosleep"
-- 
2.38.1

