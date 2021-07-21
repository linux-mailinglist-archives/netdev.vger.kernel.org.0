Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359E83D190C
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 23:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhGUUsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 16:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbhGUUsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 16:48:08 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4030C061757;
        Wed, 21 Jul 2021 14:28:43 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gx2so3207801pjb.5;
        Wed, 21 Jul 2021 14:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iHMFoUx4ic/3jpkMbk5VC7m6rTgETqO4IDnqIqQNaMU=;
        b=u4b8cFGiBT7S0dHtJTzrwvScA958hkHWY1RE92eKNIeFCdxPuQ2tySuwA7LRhahDyU
         xdNn91oPX25suJ2H5Bidqfx6pT4cBSzxcUblnTTuNb3j5WXKBhmhMKmmOuR/XoSxtwAs
         nTJ+MDGQObxLFJn/UeJE5Prmw4htaBluwTNEbhPeU4NM2P08tbzi1/m/OPGuRwtShW2U
         6PzpLbPADKg06gQYQH1wLS6SLhFRPChmrqznQM/yZcCTbwyOLGy2Ln93sQl29qZ60TSn
         iJIBjEXFtzmxXdoEXv3HTAabl5sESu9Y+jI09NQEmWrgLSVOdsBuA1raziZgFpDjpqQG
         egHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iHMFoUx4ic/3jpkMbk5VC7m6rTgETqO4IDnqIqQNaMU=;
        b=Mp0HKdjShfsJSLn0ibCQFdB45835bJ5Tw/DfS/23xdkwM+RrdQpAk657Xrkm+n5I+x
         AAx0Gc2lRY/zTAM3XRtJQaSsmFe1L+nLdDrIoT6LY299Zuafm2J1IzNdN0NONZlevqY1
         LC5ZhC69GtXVcVbWbX+DlI5dl+pfmPwC71eq7jQUGRDlhGRN7BH+S4OE7cZzTp2eOxFy
         a4fAWKXxSNM4wGd5ukaZ49c7VmXTGyCOJkcc8CG7ywVgQdyGh8piyslRkQkRU8zOmgcU
         cba/fEfhzG/LbbFUu+VLMcTc9h417uiAMj0490QgqQo6/XUauMnGvSggEVIE9uXaJ/7a
         pfDA==
X-Gm-Message-State: AOAM532gAGGTVaEhqzodzHZlC/dDtqEsO6BbtxU6X6HbAQF1mp7mRZ3V
        p/6LCH3Jf8/ZiFAXtMc/2sVjSk1MopDa7Q==
X-Google-Smtp-Source: ABdhPJzH0/WDavYIB1SHJ4Qfs95YzN0vXGRCp0gwelkwTFxodwhGwarYCQ1S9dTNy9/6fnYNXGv4Og==
X-Received: by 2002:a63:c041:: with SMTP id z1mr38400451pgi.49.1626902922944;
        Wed, 21 Jul 2021 14:28:42 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0bb:dc30:f309:2f53:5818])
        by smtp.gmail.com with ESMTPSA id n12sm29800433pgr.2.2021.07.21.14.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 14:28:42 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 1/8] samples: bpf: fix a couple of warnings
Date:   Thu, 22 Jul 2021 02:58:26 +0530
Message-Id: <20210721212833.701342-2-memxor@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210721212833.701342-1-memxor@gmail.com>
References: <20210721212833.701342-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cookie_uid_helper_example.c: In function ‘main’:
cookie_uid_helper_example.c:178:69: warning: ‘ -j ACCEPT’ directive
	writing 10 bytes into a region of size between 8 and 58
	[-Wformat-overflow=]
  178 |  sprintf(rules, "iptables -A OUTPUT -m bpf --object-pinned %s -j ACCEPT",
      |								       ^~~~~~~~~~
/home/kkd/src/linux/samples/bpf/cookie_uid_helper_example.c:178:9: note:
	‘sprintf’ output between 53 and 103 bytes into a destination of size 100
  178 |  sprintf(rules, "iptables -A OUTPUT -m bpf --object-pinned %s -j ACCEPT",
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  179 |         file);
      |         ~~~~~

Fix by using snprintf and a sufficiently sized buffer.

tracex4_user.c:35:15: warning: ‘write’ reading 12 bytes from a region of
	size 11 [-Wstringop-overread]
   35 |         key = write(1, "\e[1;1H\e[2J", 12); /* clear screen */
      |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use size as 11.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/cookie_uid_helper_example.c | 12 +++++++++---
 samples/bpf/tracex4_user.c              |  2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/cookie_uid_helper_example.c b/samples/bpf/cookie_uid_helper_example.c
index cc3bce8d3aac..30fdcd664da2 100644
--- a/samples/bpf/cookie_uid_helper_example.c
+++ b/samples/bpf/cookie_uid_helper_example.c
@@ -1,3 +1,4 @@
+
 /* This test is a demo of using get_socket_uid and get_socket_cookie
  * helper function to do per socket based network traffic monitoring.
  * It requires iptables version higher then 1.6.1. to load pinned eBPF
@@ -167,7 +168,7 @@ static void prog_load(void)
 static void prog_attach_iptables(char *file)
 {
 	int ret;
-	char rules[100];
+	char rules[256];
 
 	if (bpf_obj_pin(prog_fd, file))
 		error(1, errno, "bpf_obj_pin");
@@ -175,8 +176,13 @@ static void prog_attach_iptables(char *file)
 		printf("file path too long: %s\n", file);
 		exit(1);
 	}
-	sprintf(rules, "iptables -A OUTPUT -m bpf --object-pinned %s -j ACCEPT",
-		file);
+	ret = snprintf(rules, sizeof(rules),
+		       "iptables -A OUTPUT -m bpf --object-pinned %s -j ACCEPT",
+		       file);
+	if (ret < 0 || ret >= sizeof(rules)) {
+		printf("error constructing iptables command\n");
+		exit(1);
+	}
 	ret = system(rules);
 	if (ret < 0) {
 		printf("iptables rule update failed: %d/n", WEXITSTATUS(ret));
diff --git a/samples/bpf/tracex4_user.c b/samples/bpf/tracex4_user.c
index cea399424bca..566e6440e8c2 100644
--- a/samples/bpf/tracex4_user.c
+++ b/samples/bpf/tracex4_user.c
@@ -32,7 +32,7 @@ static void print_old_objects(int fd)
 	__u64 key, next_key;
 	struct pair v;
 
-	key = write(1, "\e[1;1H\e[2J", 12); /* clear screen */
+	key = write(1, "\e[1;1H\e[2J", 11); /* clear screen */
 
 	key = -1;
 	while (bpf_map_get_next_key(fd, &key, &next_key) == 0) {
-- 
2.32.0

