Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 871F8165844
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgBTHMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:12:02 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36297 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgBTHMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:12:01 -0500
Received: by mail-pf1-f196.google.com with SMTP id 185so1462319pfv.3;
        Wed, 19 Feb 2020 23:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dqVrh2Kk9feIWA6ZWXVLUQnsuwnyrHDZQbWtZXKQmmQ=;
        b=O6vXk2/UVkR/osi6fv6tEGO46n00EMpHwdQSzwGN8ducWn7350WOqTmVdjQY3pv9yr
         xika+UdIsSGOmQzolMa3sVcMcyQ7dlBlJlRy7N9CMyohSGE8YxR6lrw5gmXZynKmVlyz
         sakDaIup0hRbgIodvfNWxFKarqWCuu4sdC/a9vi9o+yWbsgdSlUi4KF/0dre47b6rpM5
         IuqWImhTkyang94KXq1Vz5LItOrtt8Uj0c323askH9p9CaZpBHAYF9F8gS83ovhbGwn/
         QnO8EZEQ1viY+J9A2EnCnRj4feTnQPrNkcBcjW/SJhqdA+vJM2jhNlj5oPQmszPK5Cc3
         C1QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dqVrh2Kk9feIWA6ZWXVLUQnsuwnyrHDZQbWtZXKQmmQ=;
        b=TthEHUtutRDKNNzLfm/izWcuxFfwkY335uC9P7xhE+IyTXOYxG1UYfcP9Ghf61fDf6
         3WmS0JsqmGoXpOrB94XTnsWOPQ33V7J0M4nERxoP3saFEEk+07LPk35ggicIBOCxdwt5
         9kHLsp5GP0lW+jGz51HfyukuUjneleK+8VD/gfDN9xuzzocg0Na18AeavqITLXY82YBU
         h5a3tww9ZaAcC4Lb8D8MSxRSnZ6Eh68UJw2AOJPemcT6b3+jDftnyd2uFVDgHlRkaGjY
         14NzPOoKOvxnSnyUH45SwMu/d6JAf7IBb/fxt5ju5k3ynaB2sCk8Dt+svAr+PGLC5DJZ
         oaBQ==
X-Gm-Message-State: APjAAAV1oankBULvFqy86bcyWo7OKr01pr3dc41cc/gWvPpmvaiLMher
        rR+J8sE97m3P1fjIOgk3BVsBITICgNo=
X-Google-Smtp-Source: APXvYqy9Aa9QSR1RhWaKUFkajo8filr6XU2mR2UtzQZVK6rvj8GllrR1rEjnnBS2egXi2TWb8oAk5A==
X-Received: by 2002:a63:5848:: with SMTP id i8mr31037928pgm.438.1582182720949;
        Wed, 19 Feb 2020 23:12:00 -0800 (PST)
Received: from kernel.rdqbwbcbjylexclmhxlbqg5jve.hx.internal.cloudapp.net ([65.52.171.215])
        by smtp.gmail.com with ESMTPSA id p4sm2148325pgh.14.2020.02.19.23.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 23:12:00 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Petar Penkov <ppenkov.kernel@gmail.com>,
        Lingpeng Chen <forrest0579@gmail.com>
Subject: [PATCH v3 bpf-next 3/3] selftests/bpf: add selftest for get_netns_id helper
Date:   Thu, 20 Feb 2020 07:10:54 +0000
Message-Id: <20200220071054.12499-4-forrest0579@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200220071054.12499-1-forrest0579@gmail.com>
References: <07e2568e-0256-29f5-1656-1ac80a69f229@iogearbox.net>
 <20200220071054.12499-1-forrest0579@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

adding selftest for new bpf helper function get_netns_id

Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
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

