Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAC243BD54
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 00:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240110AbhJZWjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 18:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240091AbhJZWiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 18:38:09 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBABC061224;
        Tue, 26 Oct 2021 15:35:39 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 75so972737pga.3;
        Tue, 26 Oct 2021 15:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l6j46Ws58hCljuR8NCqQZteT2C36qK9PN69x2iQopUA=;
        b=ooOVukM+tvv/6Usnc0yRUaKWdgMPRT9NtGkk7dWAcVeuYX99Paoe+Gt/dq6tj6mzyZ
         WSRkGPlbAP4jVx2zkyViJm9gaQAdn112odFoEqsh9KUEEK5WuS1Z3sYf4FVQNt/vN7B0
         UR4kWtuje3JRdZqEYSKxeOgwwdss1ML54eY5pTzQfo+jyML5a8/vjE0jZ1NQ/t+yFwu8
         jjbVlZSOyQnxBKpn3iWax3vqRUxemPFgjqPSOe4buV9m9rwOfsvEaHea2EIO2Lki9DDm
         OCx7RMs8ME59vVSxYQGkyMkc8na/dm6BhgtK76wBlkz2vFUvUYBHagQv8XMAwZNaMOHa
         VT9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l6j46Ws58hCljuR8NCqQZteT2C36qK9PN69x2iQopUA=;
        b=uVKftl+zMzvJWrA9uzPHie+rP02rXigBsKytVU9bcJnmQwEgSzsFay2+smKl23LWxx
         A9C/UvLzE2C9rNh3/l97Wps5I4GpRYFsoC6QGVsqvxJI/sx3ILrh9bq5LvoJcIZKDxRs
         l0KnioVu4qAQk4FqFUUnrQjIkss2OBPZtQRxZngi9YoxlTsS1LASWH58321797aPjwfv
         tP1vlkk43IRpOQ0nKMl7K+znfWtelLi9s1KucpPrg/VwoPuAvz8+gm+aJ81bbWt3Qtxi
         evUeVfPGZHpCEkNZb9xkB1zJaVDZf75qAeWqSQWx1lO5Ql6Cy6XjlJIAFb859gjyuzup
         oHqw==
X-Gm-Message-State: AOAM531AFiYJXxzaFUW3gPfVJa5pOMKNYLi/aWgJi4w42/T9lNcuYCdD
        YwEzymLKpVAd5sq6pegQl/a6uz6g8A==
X-Google-Smtp-Source: ABdhPJyTwyYZW37oXHntJ8ujr2kfQrwGwGJSEcryH5FPfTnrKXWFPoeXOSIUH5biu+XjgFVdLCHvWQ==
X-Received: by 2002:a63:18b:: with SMTP id 133mr20602512pgb.156.1635287738890;
        Tue, 26 Oct 2021 15:35:38 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j6sm19757369pgq.0.2021.10.26.15.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 15:35:38 -0700 (PDT)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Burton <jevburton@google.com>
Subject: [PATCH v2] libbpf: Deprecate bpf_objects_list
Date:   Tue, 26 Oct 2021 22:35:28 +0000
Message-Id: <20211026223528.413950-1-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

Add a flag to `enum libbpf_strict_mode' to disable the global
`bpf_objects_list', preventing race conditions when concurrent threads
call bpf_object__open() or bpf_object__close().

bpf_object__next() will return NULL if this option is set.

Callers may achieve the same workflow by tracking bpf_objects in
application code.

  [0] Closes: https://github.com/libbpf/libbpf/issues/293

Signed-off-by: Joe Burton <jevburton@google.com>
---
 tools/lib/bpf/libbpf.c        | 8 +++++++-
 tools/lib/bpf/libbpf.h        | 3 ++-
 tools/lib/bpf/libbpf_legacy.h | 6 ++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2fbed2d4a645..59d39ce9f375 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1148,6 +1148,7 @@ static struct bpf_object *bpf_object__new(const char *path,
 					  size_t obj_buf_sz,
 					  const char *obj_name)
 {
+	bool strict = (libbpf_mode & LIBBPF_STRICT_NO_OBJECT_LIST);
 	struct bpf_object *obj;
 	char *end;
 
@@ -1188,7 +1189,8 @@ static struct bpf_object *bpf_object__new(const char *path,
 	obj->loaded = false;
 
 	INIT_LIST_HEAD(&obj->list);
-	list_add(&obj->list, &bpf_objects_list);
+	if (!strict)
+		list_add(&obj->list, &bpf_objects_list);
 	return obj;
 }
 
@@ -7935,6 +7937,10 @@ struct bpf_object *
 bpf_object__next(struct bpf_object *prev)
 {
 	struct bpf_object *next;
+	bool strict = (libbpf_mode & LIBBPF_STRICT_NO_OBJECT_LIST);
+
+	if (strict)
+		return NULL;
 
 	if (!prev)
 		next = list_first_entry(&bpf_objects_list,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index e1900819bfab..defabdbe7760 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -168,7 +168,8 @@ LIBBPF_API struct bpf_program *
 bpf_object__find_program_by_name(const struct bpf_object *obj,
 				 const char *name);
 
-LIBBPF_API struct bpf_object *bpf_object__next(struct bpf_object *prev);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "track bpf_objects in application code instead")
+struct bpf_object *bpf_object__next(struct bpf_object *prev);
 #define bpf_object__for_each_safe(pos, tmp)			\
 	for ((pos) = bpf_object__next(NULL),		\
 		(tmp) = bpf_object__next(pos);		\
diff --git a/tools/lib/bpf/libbpf_legacy.h b/tools/lib/bpf/libbpf_legacy.h
index 29ccafab11a8..5ba5c9beccfa 100644
--- a/tools/lib/bpf/libbpf_legacy.h
+++ b/tools/lib/bpf/libbpf_legacy.h
@@ -57,6 +57,12 @@ enum libbpf_strict_mode {
 	 * function name instead of section name.
 	 */
 	LIBBPF_STRICT_SEC_NAME = 0x04,
+	/*
+	 * Disable the global 'bpf_objects_list'. Maintaining this list adds
+	 * a race condition to bpf_object__open() and bpf_object__close().
+	 * Clients can maintain it on their own if it is valuable for them.
+	 */
+	LIBBPF_STRICT_NO_OBJECT_LIST = 0x08,
 
 	__LIBBPF_STRICT_LAST,
 };
-- 
2.33.0.1079.g6e70778dc9-goog

