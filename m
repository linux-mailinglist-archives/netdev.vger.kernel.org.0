Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAFE16B89A
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 05:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgBYEqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 23:46:32 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33351 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbgBYEqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 23:46:31 -0500
Received: by mail-pg1-f193.google.com with SMTP id 6so6272140pgk.0;
        Mon, 24 Feb 2020 20:46:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0AG14jTTmuC8Ce4j6r6xn2NvGLpa8PEm7k6iaI+N0/E=;
        b=o5YQBl/HNbnjGmFE3/pLmTLb+NEa6YQRP49VNBoem54UxowdWk3WIgZSmT2TwOTsRd
         BWibc6G+EkO/GEXXcWKB+hklGerxsISRE75z8WaT9ygSwWEs2v2AoUOmSVZrJQMGxvVi
         Zlwn4FSgyK493lYYJMxx4AqPmoxbczQT4wIpcU+XchUcXaIT15Gst7+x/Nc2gezSGrOf
         X2oJtMNen2JGSTxSbRo+ihpiY8ZuyLE00dNaPbFVjSwCvHakn/GLbzLWhm92xZ/VZ1rp
         00Ib7EnqSF59lt+b41gMHfG2y8vxK0x5UWE2qB8Nr5c2S4Tk3nkmAWHlNaSCRkrzztU4
         wBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0AG14jTTmuC8Ce4j6r6xn2NvGLpa8PEm7k6iaI+N0/E=;
        b=ILTi2B96u5lQ1KwBADzFGvownVIWzeQezzHCkM9T+gnJ/lXamjQIuvciowpEVXsT7O
         2b4Mt3pRyhRa4K/n1IxNiEYqNOqzvP5GfEXQyJSGPgR1zrhVqNnPS3rqvihimjgpMhVK
         nafGvAM5mhoHRGj6VnQU5/3PUaXfdCF15TLjwwUuMOw99jCfHducFibf8XcDUYLFo4Lb
         muUoIc3+5YJjnAaCvlbcibYIrLGh0mPdeR1+iXf5T6a0e7fUntcVFRzrw/k4G803NU26
         PVfFSoo2cdtjkSWzdIuTMX95j9lnbJA2H3D+2KeHZ9BRHgCvtvzN6UmzTw8cMfTNFnGj
         MtaQ==
X-Gm-Message-State: APjAAAXoed9jyZlIKE5aFK9ZiG+VkRPHIgubsycBSggvEBJSYV5wa3dj
        noVuEcQW8bA8ikt0U/NPMKrjas/Ztho=
X-Google-Smtp-Source: APXvYqzxm7+7ae+8FzdC2KYNKetTh5IsuLDFyVPp5TK+yxXbgy7ePsnMVBdG46hIjJfQZs0ud/Tpaw==
X-Received: by 2002:a63:4555:: with SMTP id u21mr19787015pgk.66.1582605990685;
        Mon, 24 Feb 2020 20:46:30 -0800 (PST)
Received: from kernel.rdqbwbcbjylexclmhxlbqg5jve.hx.internal.cloudapp.net ([65.52.171.215])
        by smtp.gmail.com with ESMTPSA id l13sm1170879pjq.23.2020.02.24.20.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 20:46:30 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Petar Penkov <ppenkov.kernel@gmail.com>,
        Song Liu <song@kernel.org>,
        Lingpeng Chen <forrest0579@gmail.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v4 bpf-next 3/3] selftests/bpf: add selftest for get_netns_id helper
Date:   Tue, 25 Feb 2020 04:45:38 +0000
Message-Id: <20200225044538.61889-4-forrest0579@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225044538.61889-1-forrest0579@gmail.com>
References: <CAPhsuW6QkQ8-pXamQVzTXLPzyb4-FCeF_6To7sa_=gd7Ea5VpA@mail.gmail.com>
 <20200225044538.61889-1-forrest0579@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

adding selftest for new bpf helper function get_netns_id

Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/progs/test_tcpbpf_kern.c    | 11 +++++
 .../testing/selftests/bpf/test_tcpbpf_user.c  | 46 ++++++++++++++++++-
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
index 1f1966e86e9f..d7d851ddd2cc 100644
--- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
@@ -28,6 +28,13 @@ struct {
 	__type(value, int);
 } sockopt_results SEC(".maps");
 
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} netns_number SEC(".maps");
+
 static inline void update_event_map(int event)
 {
 	__u32 key = 0;
@@ -61,6 +68,7 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 	int rv = -1;
 	int v = 0;
 	int op;
+	__u64 netns_id;
 
 	op = (int) skops->op;
 
@@ -144,6 +152,9 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 		__u32 key = 0;
 
 		bpf_map_update_elem(&sockopt_results, &key, &v, BPF_ANY);
+
+		netns_id = bpf_get_netns_id(skops);
+		bpf_map_update_elem(&netns_number, &key, &netns_id, BPF_ANY);
 		break;
 	default:
 		rv = -1;
diff --git a/tools/testing/selftests/bpf/test_tcpbpf_user.c b/tools/testing/selftests/bpf/test_tcpbpf_user.c
index 3ae127620463..fef2f4d77ecc 100644
--- a/tools/testing/selftests/bpf/test_tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/test_tcpbpf_user.c
@@ -76,6 +76,41 @@ int verify_sockopt_result(int sock_map_fd)
 	return ret;
 }
 
+int verify_netns(__u64 netns_id)
+{
+	char buf1[40];
+	char buf2[40];
+	int ret = 0;
+	ssize_t len = 0;
+
+	len = readlink("/proc/self/ns/net", buf1, 39);
+	sprintf(buf2, "net:[%llu]", netns_id);
+
+	if (len <= 0) {
+		printf("FAILED: readlink /proc/self/ns/net");
+		return ret;
+	}
+
+	if (strncmp(buf1, buf2, len)) {
+		printf("FAILED: netns don't match");
+		ret = 1;
+	}
+	return ret;
+}
+
+int verify_netns_result(int netns_map_fd)
+{
+	__u32 key = 0;
+	__u64 res = 0;
+	int ret = 0;
+	int rv;
+
+	rv = bpf_map_lookup_elem(netns_map_fd, &key, &res);
+	EXPECT_EQ(0, rv, "d");
+
+	return verify_netns(res);
+}
+
 static int bpf_find_map(const char *test, struct bpf_object *obj,
 			const char *name)
 {
@@ -92,7 +127,7 @@ static int bpf_find_map(const char *test, struct bpf_object *obj,
 int main(int argc, char **argv)
 {
 	const char *file = "test_tcpbpf_kern.o";
-	int prog_fd, map_fd, sock_map_fd;
+	int prog_fd, map_fd, sock_map_fd, netns_map_fd;
 	struct tcpbpf_globals g = {0};
 	const char *cg_path = "/foo";
 	int error = EXIT_FAILURE;
@@ -137,6 +172,10 @@ int main(int argc, char **argv)
 	if (sock_map_fd < 0)
 		goto err;
 
+	netns_map_fd = bpf_find_map(__func__, obj, "netns_number");
+	if (netns_map_fd < 0)
+		goto err;
+
 retry_lookup:
 	rv = bpf_map_lookup_elem(map_fd, &key, &g);
 	if (rv != 0) {
@@ -161,6 +200,11 @@ int main(int argc, char **argv)
 		goto err;
 	}
 
+	if (verify_netns_result(netns_map_fd)) {
+		printf("FAILED: Wrong netns stats\n");
+		goto err;
+	}
+
 	printf("PASSED!\n");
 	error = 0;
 err:
-- 
2.20.1

