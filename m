Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94888D1268
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 17:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731667AbfJIP0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 11:26:47 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37961 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbfJIP0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 11:26:46 -0400
Received: by mail-qt1-f194.google.com with SMTP id j31so3995968qta.5;
        Wed, 09 Oct 2019 08:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p5dmhqgXzU0PAo+f6c2oMinYRJIOzYqFfyKVcX2FFw4=;
        b=JQUFbOOr0m2S/6J7hF2a2oUAuXvKLCHe0lUxqbfqt+Lj9OurgMvglKCH/Xf28yA559
         h2uD5C4Jtom4azADB4I3xcuDaSsuMa2w5phBRq5BXnn9s+Bwo34m2pEzZGLkMGfHaQPk
         fhJytCBvuTeIqr4WB907sZX6jNpUUpSqCzpDMrfoEF68bzraO0uCGUjhm1q1Ri7QAkHD
         W2KjA5GDtSD3I3XrivH3SdcbvJGKJ9X50z+8gdKqXp1joVyyZmFPhjm57Kj+ep3h/Iz/
         RhYB//ji6wY2QyoqmzrQHw7JUMIynY2vQ7QZP56xQ4k5OoxsIl6OQT6Q5fB2Rd3s7mLf
         36FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p5dmhqgXzU0PAo+f6c2oMinYRJIOzYqFfyKVcX2FFw4=;
        b=MTPE9JbJb+MVE3FM+gEsSL7xqw+FT26pyUGh8VV9kzo+UFfXCm5mripVHBDRP6E70E
         NJKbkhiRzR+5fBVSZQqsJAcAWelGkJSn2qvo2IxAvDkR0Qf7s7H+lXBNJ2kBRnbo08YR
         ca2K3WuYvv98AgbJUhxtqItxq9pbgoSoEwPcLiNhCmgzbeGzkYthln1rspF80Jw9JQaq
         L2jtJLZHj/5fHMR/vOKzGYio6cKPx1KbQ4JLKhv8FQc5uNcqdb5OnOtVRDSPlcdv08aN
         8Z7TGoeehJxoZtEujVvMbBhsOuNMD2EsBwHO8ROdBGJviihYJ7E4jqUsmChbkS1cXsPk
         mCjw==
X-Gm-Message-State: APjAAAVBtHYo5soZvlBF4qhWYtHtXbgF5xaWAp79QCQbL40GvViVk+tf
        ddYn0jBKp7nw+UftLT1G9yYZ1z67of0=
X-Google-Smtp-Source: APXvYqyUk6o30HfmfZPYSqRb/QMCORCLqqUcdLCq96cJIugL8cxFGwuq8Z65RgAmiRIXtQ8i3/qM6Q==
X-Received: by 2002:a0c:fe02:: with SMTP id x2mr4111814qvr.117.1570634805071;
        Wed, 09 Oct 2019 08:26:45 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id l189sm1049895qke.69.2019.10.09.08.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 08:26:44 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v13 1/4] fs/nsfs.c: added ns_match
Date:   Wed,  9 Oct 2019 12:26:29 -0300
Message-Id: <20191009152632.14218-2-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009152632.14218-1-cneirabustos@gmail.com>
References: <20191009152632.14218-1-cneirabustos@gmail.com>
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
 fs/nsfs.c               | 8 ++++++++
 include/linux/proc_ns.h | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index a0431642c6b5..256f6295d33d 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -245,6 +245,14 @@ struct file *proc_ns_fget(int fd)
 	return ERR_PTR(-EINVAL);
 }
 
+/* Returns true if current namespace matches dev/ino.
+ */
+bool ns_match(const struct ns_common *ns, dev_t dev, ino_t ino)
+{
+	return ((ns->inum == ino) && (nsfs_mnt->mnt_sb->s_dev == dev));
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

