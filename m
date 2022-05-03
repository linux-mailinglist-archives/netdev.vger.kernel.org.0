Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A240518C7D
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 20:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241570AbiECSlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 14:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbiECSlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 14:41:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA1D20196;
        Tue,  3 May 2022 11:38:07 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o69so14727432pjo.3;
        Tue, 03 May 2022 11:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=17E+vPBmam0U7jjWivI4/nzQ5YVjAUL/ojgnwZTtVBU=;
        b=i+pdc/2h8wNDWpasVUODXyv8OtqdliQnYApfYG25Af7DflZpjDqvsiIvGl7euxNXq8
         800b+QMMVAPyASwtefqSXaH+NMKD1aMSXUq96jNclSM/iJAiZQumegr5G664iGXalKvb
         tQ7+xZ9c5vstStz6lUihIrup9/qo4zfYqEdMp5ogLyUHxYlIrdNPypioxGe9tKvhD9dz
         qtVGjzD6uWj4ZVO6d3oJ1mZNj0QcsWVEzgqxHoX6oZkagwFTo/GAdPiihUV7tbCzgQNU
         L45Q6pqNaQ/il+sv22U43M+mEQ0QUiduz8K9uwFjpGf8b/uwzpAMg0LbPhqbhW1b1JFH
         r/mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=17E+vPBmam0U7jjWivI4/nzQ5YVjAUL/ojgnwZTtVBU=;
        b=bmB7NkZfNchMD7NZkUsIjRdgwVWLxBbWfZrEBhAQY7+XOh4obtzvadKNxAiFt1fdiJ
         +f8OrfQYGsJShT599PTJi7Bwz5U0UvpHFoFtKof57zKgieVtfjyaUDupszDfqhlvyqmy
         pAEQg/KgsZ9MBLCLdxZ8l1Vk04q93FwPuzd8xtHR3aGLVZeSRtq/O6gfMGWYu0esEOSE
         1kqkTAswGntV/tPFORA1jg+moucFSl5rQPjSyeodciQplRY2gT1fnz1g4msHYhB/OydC
         xp0oCvBBKFokBfJ+N9WhFBk3Lw375rY9+Gvzk2Iraeq2xVQJGS6cDwp4YJ+Mf1rn4DDq
         w05A==
X-Gm-Message-State: AOAM530C4zPcF4LI/tANZgSJBhPJjE2tnEJqoIjaGPdSGD7NzbjXqD1G
        sVyhRW5A2MrpkEDuBOfcIYc=
X-Google-Smtp-Source: ABdhPJyDCpBXCGVDN9GxjS3o4iDxH+VsDXnGlmFAAoT0W+pe3M2/8GQC0IhJNV6bweQsIx5oQe9Eow==
X-Received: by 2002:a17:90a:7f94:b0:1cb:1853:da1b with SMTP id m20-20020a17090a7f9400b001cb1853da1bmr6132737pjl.14.1651603086813;
        Tue, 03 May 2022 11:38:06 -0700 (PDT)
Received: from mi-HP-ProDesk-680-G4-MT.xiaomi.com ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id f21-20020a170902f39500b0015e8d4eb238sm6619193ple.130.2022.05.03.11.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 11:38:06 -0700 (PDT)
From:   Guowei Du <duguoweisz@gmail.com>
To:     jack@suse.cz
Cc:     amir73il@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        jmorris@namei.org, serge@hallyn.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        keescook@chromium.org, anton@enomsg.org, ccross@android.com,
        tony.luck@intel.com, selinux@vger.kernel.org, duguoweisz@gmail.com,
        duguowei <duguowei@xiaomi.com>
Subject: [PATCH] fsnotify: add generic perm check for unlink/rmdir
Date:   Wed,  4 May 2022 02:37:50 +0800
Message-Id: <20220503183750.1977-1-duguoweisz@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: duguowei <duguowei@xiaomi.com>

For now, there have been open/access/open_exec perms for file operation,
so we add new perms check with unlink/rmdir syscall. if one app deletes
any file/dir within pubic area, fsnotify can sends fsnotify_event to
listener to deny that, even if the app have right dac/mac permissions.

Signed-off-by: duguowei <duguowei@xiaomi.com>
---
 fs/notify/fsnotify.c             |  2 +-
 include/linux/fs.h               |  2 ++
 include/linux/fsnotify.h         | 16 ++++++++++++++++
 include/linux/fsnotify_backend.h |  6 +++++-
 security/security.c              | 12 ++++++++++--
 security/selinux/hooks.c         |  4 ++++
 6 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 70a8516b78bc..9c03a5f84be0 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -581,7 +581,7 @@ static __init int fsnotify_init(void)
 {
 	int ret;
 
-	BUILD_BUG_ON(HWEIGHT32(ALL_FSNOTIFY_BITS) != 25);
+	BUILD_BUG_ON(HWEIGHT32(ALL_FSNOTIFY_BITS) != 27);
 
 	ret = init_srcu_struct(&fsnotify_mark_srcu);
 	if (ret)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bbde95387a23..9c661584db7d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -100,6 +100,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define MAY_CHDIR		0x00000040
 /* called from RCU mode, don't block */
 #define MAY_NOT_BLOCK		0x00000080
+#define MAY_UNLINK		0x00000100
+#define MAY_RMDIR		0x00000200
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index bb8467cd11ae..68f5d4aaf1ae 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -80,6 +80,22 @@ static inline int fsnotify_parent(struct dentry *dentry, __u32 mask,
 	return fsnotify(mask, data, data_type, NULL, NULL, inode, 0);
 }
 
+static inline int fsnotify_path_perm(struct path *path, struct dentry *dentry, __u32 mask)
+{
+	__u32 fsnotify_mask = 0;
+
+	if (!(mask & (MAY_UNLINK | MAY_RMDIR)))
+		return 0;
+
+	if (mask & MAY_UNLINK)
+		fsnotify_mask |= FS_UNLINK_PERM;
+
+	if (mask & MAY_RMDIR)
+		fsnotify_mask |= FS_RMDIR_PERM;
+
+	return fsnotify_parent(dentry, fsnotify_mask, path, FSNOTIFY_EVENT_PATH);
+}
+
 /*
  * Simple wrappers to consolidate calls to fsnotify_parent() when an event
  * is on a file/dentry.
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 0805b74cae44..0e2e240e8234 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -54,6 +54,8 @@
 #define FS_OPEN_PERM		0x00010000	/* open event in an permission hook */
 #define FS_ACCESS_PERM		0x00020000	/* access event in a permissions hook */
 #define FS_OPEN_EXEC_PERM	0x00040000	/* open/exec event in a permission hook */
+#define FS_UNLINK_PERM		0x00080000	/* unlink event in a permission hook */
+#define FS_RMDIR_PERM		0x00100000	/* rmdir event in a permission hook */
 
 #define FS_EXCL_UNLINK		0x04000000	/* do not send events if object is unlinked */
 /*
@@ -79,7 +81,9 @@
 #define ALL_FSNOTIFY_DIRENT_EVENTS (FS_CREATE | FS_DELETE | FS_MOVE | FS_RENAME)
 
 #define ALL_FSNOTIFY_PERM_EVENTS (FS_OPEN_PERM | FS_ACCESS_PERM | \
-				  FS_OPEN_EXEC_PERM)
+				  FS_OPEN_EXEC_PERM | \
+				  FS_UNLINK_PERM | \
+				  FS_RMDIR_PERM)
 
 /*
  * This is a list of all events that may get sent to a parent that is watching
diff --git a/security/security.c b/security/security.c
index b7cf5cbfdc67..8efc00ec02ed 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1160,16 +1160,24 @@ EXPORT_SYMBOL(security_path_mkdir);
 
 int security_path_rmdir(const struct path *dir, struct dentry *dentry)
 {
+	int ret;
 	if (unlikely(IS_PRIVATE(d_backing_inode(dir->dentry))))
 		return 0;
-	return call_int_hook(path_rmdir, 0, dir, dentry);
+	ret = call_int_hook(path_rmdir, 0, dir, dentry);
+	if (ret)
+		return ret;
+	return fsnotify_path_perm(dir, dentry, MAY_RMDIR);
 }
 
 int security_path_unlink(const struct path *dir, struct dentry *dentry)
 {
+	int ret;
 	if (unlikely(IS_PRIVATE(d_backing_inode(dir->dentry))))
 		return 0;
-	return call_int_hook(path_unlink, 0, dir, dentry);
+	ret = call_int_hook(path_unlink, 0, dir, dentry);
+	if (ret)
+		return ret;
+	return fsnotify_path_perm(dir, dentry, MAY_UNLINK);
 }
 EXPORT_SYMBOL(security_path_unlink);
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e9e959343de9..f0780f0eb903 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1801,8 +1801,12 @@ static int may_create(struct inode *dir,
 }
 
 #define MAY_LINK	0
+#ifndef MAY_UNLINK
 #define MAY_UNLINK	1
+#endif
+#ifndef MAY_RMDIR
 #define MAY_RMDIR	2
+#endif
 
 /* Check whether a task can link, unlink, or rmdir a file/directory. */
 static int may_link(struct inode *dir,
-- 
2.17.1

