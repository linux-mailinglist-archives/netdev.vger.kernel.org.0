Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A05F09DB
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730509AbfKEWvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:51:22 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:43735 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730054AbfKEWvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:51:21 -0500
Received: by mail-pg1-f178.google.com with SMTP id l24so15633445pgh.10;
        Tue, 05 Nov 2019 14:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fk46V+S2xVPEiDYYvT0tqBX58EO86MaG0C/eIy27Cy0=;
        b=KyQLqOagYAyPQIExHzJQl7Yk4LB+cnXg6z2TlbK9hLFVxwvDp6/jBaL9+hiynsw8fQ
         rAImrL5H7F5FIs/y5xOatBJM7LLacDpAxnbuiTF+6tR3Lxud0nGTnRwul5JkomtUUSiX
         CoHMiRcfYGfZl1vXKr/XQGW1W2po7kRdQzNSQ+DJisJfxWB1Jz9hafSFsuLt3JVpfQ9v
         LJVyOe80/K/QvyMjB4WkK+u0ElO1/BlxyycJFNDi7EZ5TdonKazCYsCqCSIjJAnrXWyf
         1HnWkBulhoIVWRKxW4lzvUMhd8hb4gxV1ObnpL3zm+SK1rJx4h0kXindaO7IHb1xXc5a
         coDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fk46V+S2xVPEiDYYvT0tqBX58EO86MaG0C/eIy27Cy0=;
        b=EFcHjmUz1ABubKzBBAh4FvG7oIuwJUlQw3dArhCXE9CybQiNWXFSHtJemjRASMVXfu
         nuPsGdM8hu4ZJ5Fk4pSIyghE57N0DzAw5JFQQHiaXiH3OoZr5ZItdpH+4KJm67Q6u3G1
         R5oCIolUAahNK9P1gOskEK6STHYJVxtr4eCA0bsFZE4B10iwtD117so4Vtd+O+FKgMjt
         qVm8T//3tWv/VuuY7lLKxayjgVD2N8uNYTD5XEZyNhoyCtEauIjhfjkheL/4g0Y44if3
         rHy1AYP5yPbB8FwVwjoWIcc/hhuLV8IRLMT6VRfAvicFmNZDL3Pm2Ig1SEp5qJctYSOm
         oWuA==
X-Gm-Message-State: APjAAAWC6j0YYQpgn5B7RT4yqGYDokJPzL8pevG7DCt9M3tGx5hndA9s
        VRHUYg5KJOQs4ELMgY8BAA==
X-Google-Smtp-Source: APXvYqygYO44LJqBOxs9ebwlZ2idADujSQcDLOAQj/PpfE8zHiZp3SbqAfPh3pDtdRYBRRB82tDZYg==
X-Received: by 2002:a63:4506:: with SMTP id s6mr15671050pga.27.1572994280787;
        Tue, 05 Nov 2019 14:51:20 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id r10sm18292739pgn.68.2019.11.05.14.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 14:51:20 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH,bpf-next 1/2] samples: bpf: update outdated error message
Date:   Wed,  6 Nov 2019 07:51:10 +0900
Message-Id: <20191105225111.4940-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105225111.4940-1-danieltimlee@gmail.com>
References: <20191105225111.4940-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, under samples, several methods are being used to load bpf
program.

Since using libbpf is preferred solution, lots of previously used
'load_bpf_file' from bpf_load are replaced with 'bpf_prog_load_xattr'
from libbpf.

But some of the error messages still show up as 'load_bpf_file' instead
of 'bpf_prog_load_xattr'.

This commit fixes outdated errror messages under samples and fixes some
code style issues.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/hbm.c                  | 2 +-
 samples/bpf/xdp1_user.c            | 2 +-
 samples/bpf/xdp_rxq_info_user.c    | 6 +++---
 samples/bpf/xdp_sample_pkts_user.c | 2 +-
 samples/bpf/xdp_tx_iptunnel_user.c | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index e0fbab9bec83..829b68d87687 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -147,7 +147,7 @@ static int prog_load(char *prog)
 	}
 
 	if (ret) {
-		printf("ERROR: load_bpf_file failed for: %s\n", prog);
+		printf("ERROR: bpf_prog_load_xattr failed for: %s\n", prog);
 		printf("  Output from verifier:\n%s\n------\n", bpf_log_buf);
 		ret = -1;
 	} else {
diff --git a/samples/bpf/xdp1_user.c b/samples/bpf/xdp1_user.c
index a8e5fa02e8a8..3e553eed95a7 100644
--- a/samples/bpf/xdp1_user.c
+++ b/samples/bpf/xdp1_user.c
@@ -139,7 +139,7 @@ int main(int argc, char **argv)
 	map_fd = bpf_map__fd(map);
 
 	if (!prog_fd) {
-		printf("load_bpf_file: %s\n", strerror(errno));
+		printf("bpf_prog_load_xattr: %s\n", strerror(errno));
 		return 1;
 	}
 
diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
index c7e4e45d824a..51e0d810e070 100644
--- a/samples/bpf/xdp_rxq_info_user.c
+++ b/samples/bpf/xdp_rxq_info_user.c
@@ -51,8 +51,8 @@ static const struct option long_options[] = {
 	{"sec",		required_argument,	NULL, 's' },
 	{"no-separators", no_argument,		NULL, 'z' },
 	{"action",	required_argument,	NULL, 'a' },
-	{"readmem", 	no_argument,		NULL, 'r' },
-	{"swapmac", 	no_argument,		NULL, 'm' },
+	{"readmem",	no_argument,		NULL, 'r' },
+	{"swapmac",	no_argument,		NULL, 'm' },
 	{"force",	no_argument,		NULL, 'F' },
 	{0, 0, NULL,  0 }
 };
@@ -499,7 +499,7 @@ int main(int argc, char **argv)
 	map_fd = bpf_map__fd(map);
 
 	if (!prog_fd) {
-		fprintf(stderr, "ERR: load_bpf_file: %s\n", strerror(errno));
+		fprintf(stderr, "ERR: bpf_prog_load_xattr: %s\n", strerror(errno));
 		return EXIT_FAIL;
 	}
 
diff --git a/samples/bpf/xdp_sample_pkts_user.c b/samples/bpf/xdp_sample_pkts_user.c
index 3002714e3cd5..a5760e8bf2c4 100644
--- a/samples/bpf/xdp_sample_pkts_user.c
+++ b/samples/bpf/xdp_sample_pkts_user.c
@@ -150,7 +150,7 @@ int main(int argc, char **argv)
 		return 1;
 
 	if (!prog_fd) {
-		printf("load_bpf_file: %s\n", strerror(errno));
+		printf("bpf_prog_load_xattr: %s\n", strerror(errno));
 		return 1;
 	}
 
diff --git a/samples/bpf/xdp_tx_iptunnel_user.c b/samples/bpf/xdp_tx_iptunnel_user.c
index dfb68582e243..2fe4c7f5ffe5 100644
--- a/samples/bpf/xdp_tx_iptunnel_user.c
+++ b/samples/bpf/xdp_tx_iptunnel_user.c
@@ -268,7 +268,7 @@ int main(int argc, char **argv)
 		return 1;
 
 	if (!prog_fd) {
-		printf("load_bpf_file: %s\n", strerror(errno));
+		printf("bpf_prog_load_xattr: %s\n", strerror(errno));
 		return 1;
 	}
 
-- 
2.23.0

