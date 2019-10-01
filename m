Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F99C42D9
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbfJAVl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:41:59 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34742 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbfJAVl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:41:58 -0400
Received: by mail-qt1-f195.google.com with SMTP id 3so23664845qta.1;
        Tue, 01 Oct 2019 14:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p5dmhqgXzU0PAo+f6c2oMinYRJIOzYqFfyKVcX2FFw4=;
        b=urHtHhIjIp0PzGCletNHTVGjx7Ujq1Vv7ZOiT7bH9fdnhQ6LBSutYuiv1687AFDEXY
         9+IUjalGYdO1/keIVDKMdfjtj7qBdVcVCROeK8qUFfVWqlqi8E8S1XeY6Mwx5OHU7P35
         Q7VxnKrjqCRg6d3zk5c8TUR/80vmbi/KE2Bz/dWQFk3SAaj4wZAMFQN0+eV8WIgWF7qf
         l0wCnuiLfuxREKXAK60Ho7gZYmyzqYugxwg+FU2mEJJd8rdxCRVSNCxpowIIC/1EfDKz
         jqn1mdgcJMMEujPuZ/J1ZezaMSAxGM3sIuWr97Nk620fLsDA4NzqOKdYJAiU5IGxT7rR
         wj1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p5dmhqgXzU0PAo+f6c2oMinYRJIOzYqFfyKVcX2FFw4=;
        b=UpiUl780PwNj0gc06684kS56O6FAGs5PRuP3TZN9gxP8y5sC7tGkBehgQo9JLdAkfa
         aiIZpvq4eylvWoQLJO5awW6gNwDDBh5zTRz2Ml0YAXcWfVCOXGriAfLKTaFzx9LckVYo
         2pfAPPFqlbBCVBMjgIAkioGPE+0fWOZRSywI0y+GLdENx0+DDARhaKrA9Qoe7eTPUKbk
         iaSBMjDUAwYIF5lqdYToUHKhCvbSmF5ouSTM6mbGQASq8pZnfzQ/VOeS2rPCvXNGimZ8
         vAsmxWMb/Nu+s1940Ip7mw13MVCLme/V+DzzBm5iy/Q1RYHrQGouNz4EWh1WCuX56fR1
         9h3Q==
X-Gm-Message-State: APjAAAVwNY/NucjidSKpkYFefEHp+0NN1S1xsxoQkW0VvSrxR215pGSX
        FM0SOfxxXyM7mWjkEovyxy7l+84Y7vo=
X-Google-Smtp-Source: APXvYqyuCy80892fZx5otSPJdpWHyqSUBx34mODQB0K/TjlzBTPLP9f8uG+H84x+bzYkMUqQQm+bOg==
X-Received: by 2002:ac8:1417:: with SMTP id k23mr502160qtj.93.1569966117271;
        Tue, 01 Oct 2019 14:41:57 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id v13sm8559352qtp.61.2019.10.01.14.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 14:41:56 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH V12 1/4] fs/nsfs.c: added ns_match
Date:   Tue,  1 Oct 2019 18:41:38 -0300
Message-Id: <20191001214141.6294-2-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001214141.6294-1-cneirabustos@gmail.com>
References: <20191001214141.6294-1-cneirabustos@gmail.com>
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

