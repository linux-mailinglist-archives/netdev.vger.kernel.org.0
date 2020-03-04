Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C647179A52
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388178AbgCDUmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:42:50 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37954 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728482AbgCDUmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 15:42:49 -0500
Received: by mail-qk1-f194.google.com with SMTP id j7so2815256qkd.5;
        Wed, 04 Mar 2020 12:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y5Ky3RnrstKzYFwSJbD0y3YJuOUDmcCn0OUSxFr3kjs=;
        b=pSk4ExAQesGPiRkrJ4m00/3RVcmAmGlJgQUb5vmLH7+GRgdGDIRD3GfX6ewBFztnD2
         ldGhLdH1lHCoiY0YM1qiK1CtLCmBHZ0403AOR7mNWGlDLI4Vm4GaLVHRin4nXAkC+GT5
         EZTrHwwcoH3sjTOOW5BhX0YXVaY46Y2RWiKlF7B476jPo5XINnkD0nH59HwHyZhsQ6vD
         BGP854EDkNLZvzjFydVbBnzJ/b7smMgz/xxRYwE3Sil0o2xXQpDpTGTe8s3aA7sjGj1g
         MshwFhx9hCu76TirTz8KODlsgb+odSNf9VHkFm+4GWRi7C8Mz8gEbnExlKObm697leiX
         HbsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y5Ky3RnrstKzYFwSJbD0y3YJuOUDmcCn0OUSxFr3kjs=;
        b=R9qcFvUt0dRCGBl1PNAGU5S0L3DIyN1QVogiJF/qqdKparj0oacRbCTq+Bod6exaBA
         qgGVJZnBMAV2Ub27U0ONfJGBheRzaMP6Nrc2BnhbBlaxYXfa0xNLdwi5hSUkNfPn7R6o
         H1sMbN9IyLglZiDfmbfVgXlzzxEFbmzcYlUybM784vTSl/T9HuPmp6OBdn/1tIdjKEg6
         qexGW6hlBHe3sQNeKT94o4vTY1uRD8lv0ScIIh4fWBivgV18vuDaglSiOjX/KIWdXuiX
         An1kf1qlI6rUfoH/6MGMGC3BW3cWBeR9rWDgBPzdN94I4T73zQhVKl57Bne/V0N97zAk
         cT4A==
X-Gm-Message-State: ANhLgQ0/oY71OVEqutzGAukcTinufKeryzYuTS7FhjaaASuW67VlKRia
        KJt4sPbOELWxsmjf8RszYum2C/dl034=
X-Google-Smtp-Source: ADFU+vs/fU4OISIPlNO4ygCwyMz7YhRvm6N60yw7Yxep3TCJbDZWcHw4ZPVdt+cQbjpTsjTboIQB7Q==
X-Received: by 2002:a37:8046:: with SMTP id b67mr4691395qkd.218.1583354568564;
        Wed, 04 Mar 2020 12:42:48 -0800 (PST)
Received: from localhost.localdomain (pc-184-104-160-190.cm.vtr.net. [190.160.104.184])
        by smtp.googlemail.com with ESMTPSA id 82sm1750232qko.91.2020.03.04.12.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 12:42:48 -0800 (PST)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v17 1/3] fs/nsfs.c: added ns_match
Date:   Wed,  4 Mar 2020 17:41:55 -0300
Message-Id: <20200304204157.58695-2-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200304204157.58695-1-cneirabustos@gmail.com>
References: <20200304204157.58695-1-cneirabustos@gmail.com>
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
index b13bfd406820..4f1205725cfe 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -247,6 +247,20 @@ struct file *proc_ns_fget(int fd)
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
index 4626b1ac3b6c..adff08bfecf9 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -85,6 +85,8 @@ typedef struct ns_common *ns_get_path_helper_t(void *);
 extern int ns_get_path_cb(struct path *path, ns_get_path_helper_t ns_get_cb,
 			    void *private_data);
 
+extern bool ns_match(const struct ns_common *ns, dev_t dev, ino_t ino);
+
 extern int ns_get_name(char *buf, size_t size, struct task_struct *task,
 			const struct proc_ns_operations *ns_ops);
 extern void nsfs_init(void);
-- 
2.20.1

