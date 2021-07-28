Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FC33D93A9
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhG1Q4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhG1Q4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:56:49 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7943DC061757;
        Wed, 28 Jul 2021 09:56:47 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id z3so2103816plg.8;
        Wed, 28 Jul 2021 09:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iHMFoUx4ic/3jpkMbk5VC7m6rTgETqO4IDnqIqQNaMU=;
        b=epbwr4/v03nicDW0ddgYDM1kWeaUh8QE65WdeluGxghUOvepwyFtbwg7zEStPLZN2K
         AlHk1lRKFawCXPgQXAOPL5H6RpNeQMQ0LeE5CzI4nN0M5KWJWugeRNaTPxBRKFqu64Xl
         4GiUAO7KlPtpzZadRmDh/imSKNCWwwt97atyT9EmZduvvJBXH7LyvwfgiS7EKZ9Lvl8U
         DkMT3sOZkySA3C/z0bhcEgspbdSCnjk/Ap6/aJJKcKO7uZKsL/+whgBQeOmzM94yyxfs
         ZTgzkKs94drLBrLH7UAuf4vFowW009jNYGAJlw75g+CxB6K31NI38dHAM8SKIUr59QrP
         abww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iHMFoUx4ic/3jpkMbk5VC7m6rTgETqO4IDnqIqQNaMU=;
        b=p0a+Jw6i3CzREbEH4gAyqGSXqYYbr6dNvLPxZAc6lBmCY5iMjdl+ShGVVVymVjOScE
         fGmrWPPQeGAdn40ph15WLeyYcyVXrsLoBJas/FSJpettgKgtcTNvDd0V/0g9zTXrI8/6
         8XjmNc6fwEO6OsygOYDXsu2b9BaJ3EGxdQj5Y82EdNUzgmHS7e1qbqIkMt4BmsvAEt2H
         FoGK9APW5CzP0UzjtYWCmOPpZTs8lfG52y3o2FRfYQmpkpIaWbDM8DAtQlRhVlbkm8Hu
         /gO21KBncOsvva1j7CTCAScJt2IAvkSOGLJ6Ls+m8MJ5VM+YYQZF4bsKEH7lPQXz9hrX
         BnKA==
X-Gm-Message-State: AOAM533hWFIq35j2ocskUBxhsTTDiJZosufXuuAg/qFEWhs+FvahYaLC
        jRBr0odosvCKbbhBHPMW/2MTJl8k/GqE/Q==
X-Google-Smtp-Source: ABdhPJzQ1C5zz0+i2w4tZ89c39dbdiZHUU2Dp6cYKR6HLtMn79Cz5wPJsMLl4VR929vm0NIbdPLw5Q==
X-Received: by 2002:a17:90b:1d0b:: with SMTP id on11mr736448pjb.94.1627491406906;
        Wed, 28 Jul 2021 09:56:46 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0bb:dc30:f309:2f53:5818])
        by smtp.gmail.com with ESMTPSA id r10sm542868pff.7.2021.07.28.09.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 09:56:46 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 1/8] samples: bpf: fix a couple of warnings
Date:   Wed, 28 Jul 2021 22:25:45 +0530
Message-Id: <20210728165552.435050-2-memxor@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210728165552.435050-1-memxor@gmail.com>
References: <20210728165552.435050-1-memxor@gmail.com>
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

