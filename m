Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E4A124F81
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 18:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfLRRin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 12:38:43 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32832 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfLRRim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 12:38:42 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so1654066pgk.0;
        Wed, 18 Dec 2019 09:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AhKfE6tOCfM1Lz5a/uUPR4TRFtdWhoskXzdYNzZtSYA=;
        b=c72qmGJltw78P+qY1SAll2shY2/dWvkPIu9YhRgzgO+nqz3mTpC3GHHRJmQxeMbAwG
         KDdvdRrdV2Re7lInYUrXYG2miSji1dQWRUdwmV2ToD5MaffDERWw7UUnFttQtpjL2TxT
         RO7kKIffQkntsNaPb24ZimA9RCl+4qzUXhEFzwEqW5ng7YhFAczPHNBIHqYee1ELx17b
         4YR14KWxoVGNkt5h08wut6hxOrSVdQO3GxNW9apc+fVKbO8XVq+0+PGHqE+QF3+uOEfn
         IBBKgcdIjSJeaFUJsxGbTaL8HZorJYbJF9RUXYMX8Xu0Xypm6Fhn+lxhloTymst4zTNs
         DvuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AhKfE6tOCfM1Lz5a/uUPR4TRFtdWhoskXzdYNzZtSYA=;
        b=XzUbiTGRXzXsllBRjW2BDxlOzANTObf7M8qh66ADJ7NaahhOrdaN5gaOPXVqekPESG
         9F/12+mkMgzCNPjJ3IpQRTZW30TJVqa0tPqxUyB8k+8UtBlbjXxRjDV2XbZSlJiFao7z
         h6Y4c3fPZbQll1cWw81vAvOKwP3pamsgwAAUsJkaBzF2A3xChf9N9SvfV5Y8y+1ZG1wL
         40qgqTgl7ahjwAdVJMBF4AZjUm2Z6nd9yhMvSR1T0CFDQcEkMQXKbD4k9wu1SW8/HJlo
         C700XtWED02PgGv36AhrEGYLLvyki7h4Yg7nwFqpRpQttjtcV0iTQ0kulxZJ91Znkn8o
         6yGA==
X-Gm-Message-State: APjAAAVs7+2EOGxkkjNxlCn6E7qXUwdvwikzMJ8J2gVz+gMdRfF71GBJ
        0uA4JTPKSgMi+Y+EoOfnN4DZEubmAVE=
X-Google-Smtp-Source: APXvYqxpIsgMw+l2pFtasN0rzHIiZy5Fn+lNPjmRsGtq6pNX7/NwO2TR90EdIcrSZzAtDzLq4RYYvw==
X-Received: by 2002:a63:904c:: with SMTP id a73mr4339807pge.335.1576690721771;
        Wed, 18 Dec 2019 09:38:41 -0800 (PST)
Received: from bpf-kern-dev.byteswizards.com (pc-184-104-160-190.cm.vtr.net. [190.160.104.184])
        by smtp.googlemail.com with ESMTPSA id s15sm3991925pgq.4.2019.12.18.09.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:38:41 -0800 (PST)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v16 1/5] fs/nsfs.c: added ns_match
Date:   Wed, 18 Dec 2019 14:38:23 -0300
Message-Id: <20191218173827.20584-2-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191218173827.20584-1-cneirabustos@gmail.com>
References: <20191218173827.20584-1-cneirabustos@gmail.com>
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

