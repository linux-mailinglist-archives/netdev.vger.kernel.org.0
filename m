Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725E0F238B
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 01:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbfKGAwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 19:52:06 -0500
Received: from mail-pf1-f175.google.com ([209.85.210.175]:43819 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728266AbfKGAwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 19:52:05 -0500
Received: by mail-pf1-f175.google.com with SMTP id 3so734982pfb.10;
        Wed, 06 Nov 2019 16:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FO/4piBniEMbwWqkTKaggf83XuvMd6htCOOOI70TJXw=;
        b=X33MCm0RMWk+GDQL5HORVSRLeX/J9HxvFepssZFjMuXUKtW/v2LiNTJSxLwDM0/wR7
         dgnudGPGlmeP0+6CgF7yEBTRk06RBtku8EhzlzcS8Zl0DtCSglGZV/wRzYAYHtmDaH0g
         dWqZzbImUNN3VuFSfkcQz+yWQSRYSwswyckmEgZptzexubfbWYJ1yD5wdd342kfJG6OX
         k/Vi+QWM7LK8/7tlPORSKkyNtz/mbnxQk1BBqXpLT4OPlkfpqLJm5OSsZ8onhuBg7nfS
         3W/4bYhkcgfMJkElzdFKsmYjo2lhECTh4iNTbPasWb9kvnsbc0f0gAaoWKsx4LI+W+Uw
         Sd1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FO/4piBniEMbwWqkTKaggf83XuvMd6htCOOOI70TJXw=;
        b=KaffP2MPuSa9fZPyhplJD6sB0+C6beacpMNI4LCMxUZhGaSuzH+y7Z7VvA1rIpAA6U
         CW0x6NxZ/vS+BJ1xMPmsrRIC8d+Af2Kj0ot0t6pqeNLfciGKW05R1/iF94kwSJErq/ub
         trfDjLmHVk1ec+kIaas/62Gvpimog8pj5u7qykMJQ3DboqnPPtxkjB70NWzYKR6VH83d
         GC/KRs2z5LoV+G9E9cc606aznXMCBXpyvNZJCrHW0iE7LI0HtORU+oF9YjJ2MGsIbusr
         LsMkVQlDgS3iJG4aSxSMMOG7XKlLNSswq4Z5mXBjnMN+ugNXa28uTnHFTV51WDboR0KR
         uvJQ==
X-Gm-Message-State: APjAAAVau1L8Z7/cbnjH1Q02JlivD3VkKumBfUbKNW0XP5mYWQE76QBz
        7ybAwouUWHGVZaKRtNIlcTFIhbafTH1e
X-Google-Smtp-Source: APXvYqx61xrTWPuF7RRAyn9DoIExDLD7Ql00jkKtEunlozT/gDzvGUFshgb2yJwJkM4KS2cA/fTtbw==
X-Received: by 2002:a63:9d03:: with SMTP id i3mr903514pgd.300.1573087923565;
        Wed, 06 Nov 2019 16:52:03 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id m68sm186606pfb.122.2019.11.06.16.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 16:52:03 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH,bpf-next v2 1/2] samples: bpf: update outdated error message
Date:   Thu,  7 Nov 2019 09:51:52 +0900
Message-Id: <20191107005153.31541-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107005153.31541-1-danieltimlee@gmail.com>
References: <20191107005153.31541-1-danieltimlee@gmail.com>
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
Acked-by: Andrii Nakryiko <andriin@fb.com>
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

