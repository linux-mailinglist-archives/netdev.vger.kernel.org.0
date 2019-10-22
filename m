Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34DAEE0C66
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732790AbfJVTSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 15:18:08 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45065 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfJVTSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 15:18:08 -0400
Received: by mail-qt1-f193.google.com with SMTP id c21so28444654qtj.12;
        Tue, 22 Oct 2019 12:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AhKfE6tOCfM1Lz5a/uUPR4TRFtdWhoskXzdYNzZtSYA=;
        b=VUZQpossR5/DSU3TtkLRvDciKo/SEJ+BTyo2LJuV+tFZAIZeJIV6KOaIAQLA4OOtpg
         ux9j6WF8w+wYWBa6P+I9bo7bZIFeKP9e+hzaMRkbN+Hb4LhADQ0CwtEKogZ8RAROrVxI
         wznb0FmBUhhEP2qa9b+Mm0njPe/AtASN2YyFBNOkHeZRho0ETzZ7ALVHvM9lS8qUELk/
         IYTEMmrmuMEJoaacIImOOzbblah0SyAN7P5LkD7UBd0ECkiQDPqEVlgo/wO6u2gvT1m9
         Ub13QvFtQK9TRoPdLrElXcdA7s4thTDq6bQyW7UMJrJTTFtEg0D9QTar66gvmGhE2Ui/
         7oGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AhKfE6tOCfM1Lz5a/uUPR4TRFtdWhoskXzdYNzZtSYA=;
        b=Gt4kFHB3/hnQEJgRC+/buZftwd6bf6MNtI5WnimHgtpNFdoggQpJfOGsCPZYdx/7v8
         jyYJQwcHNXAsWWKZZfU5Pm4xx64x+C4KnQPQlFKnd6j3oH4AdSjq1kN+ZZMhp5X+cqFP
         3xyQRBGNevR5TbXBYxVzncWH90x8OmLyJD/phZoCV8zjXxO0kpP0RkjlD5bMuDSbTR4y
         e3/DxFuBN3nUVWuVGb0uWBJuH6O0lWQh7CgNaIIdfNFjYAySLWiWb6tYBmtGULTDNZs1
         iC2oK96V6AscATmhMoW6usik4ob7tQTZTmxuqSMRjmI8yQbAVq3GM0CLBUDxJUCKQFEh
         ejgA==
X-Gm-Message-State: APjAAAWVBQLcE5xLUDRdEY39d2xahAiTZ9Cq7nrpUEXqoDykA0cr9bka
        zwsXE2bkTZTJk7NG4ZD92jPbyGPls1WoSsnh
X-Google-Smtp-Source: APXvYqybe/SbRxnnsrSqqjNtPeQFgjh3jRvTIO9mKKkRShBJajm9Ks24DGOdrZ8M7tlTwXl5lUtfIA==
X-Received: by 2002:a0c:d0e1:: with SMTP id b30mr4874313qvh.197.1571771885223;
        Tue, 22 Oct 2019 12:18:05 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id r36sm8015969qta.27.2019.10.22.12.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 12:18:04 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v15 1/5] fs/nsfs.c: added ns_match
Date:   Tue, 22 Oct 2019 16:17:47 -0300
Message-Id: <20191022191751.3780-2-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191022191751.3780-1-cneirabustos@gmail.com>
References: <20191022191751.3780-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ns_match returns true if the namespace inode and dev_t matches the ones
provided by the caller.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 fs/nsfs.c               | 14 ++++++++++++++
 include/linux/proc_ns.h |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index a0431642c6b5..ef59cf347285 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -245,6 +245,20 @@ struct file *proc_ns_fget(int fd)
 	return ERR_PTR(-EINVAL);
 }
 
+/**
+ * ns_match() - Returns true if current namespace matches dev/ino provided.
+ * @ns_common: current ns
+ * @dev: dev_t from nsfs that will be matched against current nsfs
+ * @ino: ino_t from nsfs that will be matched against current nsfs
+ *
+ * Return: true if dev and ino matches the current nsfs.
+ */
+bool ns_match(const struct ns_common *ns, dev_t dev, ino_t ino)
+{
+	return (ns->inum == ino) && (nsfs_mnt->mnt_sb->s_dev == dev);
+}
+
+
 static int nsfs_show_path(struct seq_file *seq, struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index d31cb6215905..1da9f33489f3 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -82,6 +82,8 @@ typedef struct ns_common *ns_get_path_helper_t(void *);
 extern void *ns_get_path_cb(struct path *path, ns_get_path_helper_t ns_get_cb,
 			    void *private_data);
 
+extern bool ns_match(const struct ns_common *ns, dev_t dev, ino_t ino);
+
 extern int ns_get_name(char *buf, size_t size, struct task_struct *task,
 			const struct proc_ns_operations *ns_ops);
 extern void nsfs_init(void);
-- 
2.20.1

