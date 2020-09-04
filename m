Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9915425D175
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 08:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgIDGep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 02:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgIDGen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 02:34:43 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F2DC061244;
        Thu,  3 Sep 2020 23:34:43 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d19so3810721pgl.10;
        Thu, 03 Sep 2020 23:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rc/G3FvCK68XOkOF3U68/RmVeAl00BksfK7WI0ZmGFk=;
        b=eSvsI8hUIFQ2WdwQBy5JrQyn5GOuQzQWYV5Gfg8Dw6nTc1NtSTDKRg2NgG5ACPt9zC
         Y1yb9kVluK6PHGVGGzdRHJvVr9E8PoR8AMh2/3Tu70ixZVCTwgR4pmrnLpwovYXljfX8
         HP6QD0DG+JYKo7R9wawMSWTD7aHI16sQ5vm+EtfCX6bKMkyDTUyILh7UAKxZ7GH+PHgg
         6WTFCPZ6LSmF2rPmZHNNf9wAnDg1Xp51rdcWtWWmMwevfUGIH4gE+ZI4X9hk/fagFWWS
         QirFFj+sOB6fzbDnJJzaMIF4eqfOTRDmIVRhHL+ThQ+FXm81DY6IixabqzpIZM1dvRiE
         iZdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rc/G3FvCK68XOkOF3U68/RmVeAl00BksfK7WI0ZmGFk=;
        b=gFv0w9XS28aa4Aj9WSMCR69WBPIZHVeEZwSCWtg6WWCC1fCnuwZF35zuJE5hE2Z/Iv
         yPNo844v/c5cH4qs31EcY/FSVwzNQ0xGxqwkd8aRd3O4xVHF1M3wM85U0k3qbu6+tfdc
         tw2DnkZ47eyWz968m50XC3VdCKx6jhR65Lxiaf7rkJgmrEsr9qKOK66hyjljxUEVxeLG
         b24rMw7FktWvIgVR/+HZDgEkOh6dJu3jpCgV37lNEhMkNpBEeup1baAwY/QwQM7qeWq1
         ryXsiDhgjfhtpX5+ko8nQ7Qt5SqE5XAcVItEAND+Tk1WiyXQX7l/ddEFQRFcYsxugPmt
         jOhQ==
X-Gm-Message-State: AOAM531McgsY8y7BrDYuDGfEV8jbKmF/qntinP7qKDm3QpZ/iwtFEgjO
        SGOMe2APjrj48xpYQLHlkg==
X-Google-Smtp-Source: ABdhPJzjpgzbY9fQ0OJ179Bd6yMFJ0wTa+/Gi/JkplENpu5d6jUmE4eW864O+JkupHia/6zlLJvoxg==
X-Received: by 2002:a63:1b65:: with SMTP id b37mr6200567pgm.453.1599201283170;
        Thu, 03 Sep 2020 23:34:43 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id l22sm5499182pfc.27.2020.09.03.23.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 23:34:42 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 1/2] samples: bpf: Replace bpf_program__title() with bpf_program__section_name()
Date:   Fri,  4 Sep 2020 15:34:33 +0900
Message-Id: <20200904063434.24963-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From commit 521095842027 ("libbpf: Deprecate notion of BPF program
"title" in favor of "section name""), the term title has been replaced
with section name in libbpf.

Since the bpf_program__title() has been deprecated, this commit
switches this function to bpf_program__section_name(). Due to
this commit, the compilation warning issue has also been resolved.

Fixes: 521095842027 ("libbpf: Deprecate notion of BPF program "title" in favor of "section name"")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/sockex3_user.c          | 6 +++---
 samples/bpf/spintest_user.c         | 6 +++---
 samples/bpf/tracex5_user.c          | 6 +++---
 samples/bpf/xdp_redirect_cpu_user.c | 2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/samples/bpf/sockex3_user.c b/samples/bpf/sockex3_user.c
index 4dbee7427d47..7793f6a6ae7e 100644
--- a/samples/bpf/sockex3_user.c
+++ b/samples/bpf/sockex3_user.c
@@ -29,8 +29,8 @@ int main(int argc, char **argv)
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_program *prog;
 	struct bpf_object *obj;
+	const char *section;
 	char filename[256];
-	const char *title;
 	FILE *f;
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
@@ -58,8 +58,8 @@ int main(int argc, char **argv)
 	bpf_object__for_each_program(prog, obj) {
 		fd = bpf_program__fd(prog);
 
-		title = bpf_program__title(prog, false);
-		if (sscanf(title, "socket/%d", &key) != 1) {
+		section = bpf_program__section_name(prog);
+		if (sscanf(section, "socket/%d", &key) != 1) {
 			fprintf(stderr, "ERROR: finding prog failed\n");
 			goto cleanup;
 		}
diff --git a/samples/bpf/spintest_user.c b/samples/bpf/spintest_user.c
index 847da9284fa8..f090d0dc60d6 100644
--- a/samples/bpf/spintest_user.c
+++ b/samples/bpf/spintest_user.c
@@ -17,7 +17,7 @@ int main(int ac, char **argv)
 	long key, next_key, value;
 	struct bpf_program *prog;
 	int map_fd, i, j = 0;
-	const char *title;
+	const char *section;
 	struct ksym *sym;
 
 	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
@@ -51,8 +51,8 @@ int main(int ac, char **argv)
 	}
 
 	bpf_object__for_each_program(prog, obj) {
-		title = bpf_program__title(prog, false);
-		if (sscanf(title, "kprobe/%s", symbol) != 1)
+		section = bpf_program__section_name(prog);
+		if (sscanf(section, "kprobe/%s", symbol) != 1)
 			continue;
 
 		/* Attach prog only when symbol exists */
diff --git a/samples/bpf/tracex5_user.c b/samples/bpf/tracex5_user.c
index 98dad57a96c4..c17d3fb5fd64 100644
--- a/samples/bpf/tracex5_user.c
+++ b/samples/bpf/tracex5_user.c
@@ -39,8 +39,8 @@ int main(int ac, char **argv)
 	struct bpf_program *prog;
 	struct bpf_object *obj;
 	int key, fd, progs_fd;
+	const char *section;
 	char filename[256];
-	const char *title;
 	FILE *f;
 
 	setrlimit(RLIMIT_MEMLOCK, &r);
@@ -78,9 +78,9 @@ int main(int ac, char **argv)
 	}
 
 	bpf_object__for_each_program(prog, obj) {
-		title = bpf_program__title(prog, false);
+		section = bpf_program__section_name(prog);
 		/* register only syscalls to PROG_ARRAY */
-		if (sscanf(title, "kprobe/%d", &key) != 1)
+		if (sscanf(section, "kprobe/%d", &key) != 1)
 			continue;
 
 		fd = bpf_program__fd(prog);
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 004c0622c913..3dd366e9474d 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -111,7 +111,7 @@ static void print_avail_progs(struct bpf_object *obj)
 
 	bpf_object__for_each_program(pos, obj) {
 		if (bpf_program__is_xdp(pos))
-			printf(" %s\n", bpf_program__title(pos, false));
+			printf(" %s\n", bpf_program__section_name(pos));
 	}
 }
 
-- 
2.25.1

