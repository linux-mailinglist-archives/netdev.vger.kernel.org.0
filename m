Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D353ABBD5
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 17:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbfIFPKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 11:10:23 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:42946 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbfIFPKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 11:10:23 -0400
Received: by mail-ua1-f65.google.com with SMTP id w16so2147980uap.9;
        Fri, 06 Sep 2019 08:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S3FbC4FTkQ+kbO4J/kQIM6G9ud3dS3/G95LWwoCOKoU=;
        b=i5HXTJX/4U4H8q53pLIw63ONb+Mnq9AAn8LwSebP5dq6/M3FQgbn8tB4lAX1Y4k24a
         rcz8mMcjk5VnKew7wwaA4mPTm3oVMvo3Cy6LitJWyB/YkGsEQNfug2DJFsjJr1QYo+St
         dTZjy3LE6xw8BBGCMX2PNgC5CsfT1mYq5uL9CwQi3DI1/IL80AnqSdG5NDS43Ssdscud
         3wg0SxSGYZnAq1PLf7KRbeLrDcAcsjwlNONE45bRMphuQfsFzzop4jwRICU8jysVNKlq
         Uckik3e0Q9gRmWW7b6fvx2i3HP8ELPem796CEhG5SicJBoCLi+vt3QEJo818ArEOGXr2
         NQtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=S3FbC4FTkQ+kbO4J/kQIM6G9ud3dS3/G95LWwoCOKoU=;
        b=TD7LHlA1BzyAf2mqtzC0ZTOXWKB4va+5aNPoP0Oi2+Nfz/kgXdG84DNkvnu4fIssG6
         4Gkq+h1qH8qa1Mu7spF4k1zbQwbZakKirGmnAot9rcVF0KBqW6GS1p7yQ9yXRJtc5ye/
         kaNcw4rR2LwWZ71imSF7v552XQXFNJ216dM6aCOb6jy8cduVYJubvvgUd2ES6onY7VjM
         xiZc8zPveAmTSm95+6IhXmFBCReObN3StpkVRwaR1D0M8IhMGLHG/cQ6djarRAHPMO7U
         rCx2/GSK9CvwSANl9p32Nn9xnM1aNBaSOEhiKa5HahMKVxzXv9lDs8LK2QiisLhm9/AY
         SZyw==
X-Gm-Message-State: APjAAAUxzw3kuiq3604DKbhCHhMmwXE6rdz+AHoDc5b+ZVTKXxkHSFD1
        FnIWVeIIbT29U9Lf9S0GMXKGmAYdpEY=
X-Google-Smtp-Source: APXvYqzNvM+e0QOpH0Ztt5wx5kzGK/0ufcKqgzQr0rGJkRFqWC+WqK4j7YRBafzIlLmn7VK9RoFz0w==
X-Received: by 2002:ab0:649a:: with SMTP id p26mr4301691uam.11.1567782621473;
        Fri, 06 Sep 2019 08:10:21 -0700 (PDT)
Received: from localhost.localdomain ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id o15sm4833822vkc.38.2019.09.06.08.10.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 08:10:20 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        cneirabustos@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next v10 1/4] fs/namei.c: make available filename_lookup() for bpf helpers.
Date:   Fri,  6 Sep 2019 11:09:49 -0400
Message-Id: <20190906150952.23066-2-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906150952.23066-1-cneirabustos@gmail.com>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 fs/internal.h         | 2 --
 fs/namei.c            | 1 -
 include/linux/namei.h | 4 ++++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 315fcd8d237c..6647e15dd419 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -59,8 +59,6 @@ extern int finish_clean_context(struct fs_context *fc);
 /*
  * namei.c
  */
-extern int filename_lookup(int dfd, struct filename *name, unsigned flags,
-			   struct path *path, struct path *root);
 extern int user_path_mountpoint_at(int, const char __user *, unsigned int, struct path *);
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct path *);
diff --git a/fs/namei.c b/fs/namei.c
index 209c51a5226c..a89fc72a4a10 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -19,7 +19,6 @@
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/pagemap.h>
 #include <linux/fsnotify.h>
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 9138b4471dbf..b45c8b6f7cb4 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -6,6 +6,7 @@
 #include <linux/path.h>
 #include <linux/fcntl.h>
 #include <linux/errno.h>
+#include <linux/fs.h>
 
 enum { MAX_NESTED_LINKS = 8 };
 
@@ -97,6 +98,9 @@ extern void unlock_rename(struct dentry *, struct dentry *);
 
 extern void nd_jump_link(struct path *path);
 
+extern int filename_lookup(int dfd, struct filename *name, unsigned flags,
+			   struct path *path, struct path *root);
+
 static inline void nd_terminate_link(void *name, size_t len, size_t maxlen)
 {
 	((char *) name)[min(len, maxlen)] = '\0';
-- 
2.11.0

