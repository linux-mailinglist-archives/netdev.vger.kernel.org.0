Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C13BCB0A
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732245AbfIXPU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:20:28 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41698 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730625AbfIXPU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:20:28 -0400
Received: by mail-qt1-f195.google.com with SMTP id x4so2587568qtq.8;
        Tue, 24 Sep 2019 08:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p5dmhqgXzU0PAo+f6c2oMinYRJIOzYqFfyKVcX2FFw4=;
        b=IQBOi4N4ItZRhQrHkWMrfJLQhpYrEu4dLY7tSIb4CKITJ1SMLe7SzFV0WRgfTnghx1
         kTx2+5N8smtyn9Hhvo2Gh6Nwq5c3vH1jZn1ticd228bgbbn3WgPuliF2YTJVfN8QYa6P
         c/ePcCz5CTRgkqYaw5Slep3s1lrOUitY5Vzcj8mRkVM47sIsFSzJe9frDMjktnpoyzR4
         BfZ4RDNfIilPSyrTSAVRbtU4+4BGvMnvMwhE9g008KhfCfBk0NqWKoG2czoeUlRjwi4H
         cA/Ww3FFitCf7Qw4vSKQ3WLZvYzXyxj1Cz+g2ETRkfkNI6OZQ3z/CwdBF/3j+KCanP5s
         6AlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p5dmhqgXzU0PAo+f6c2oMinYRJIOzYqFfyKVcX2FFw4=;
        b=gbqkgNYycnYYv6n80bpGDyWGFl4aD1mwn0pu0OsnCNF9KFkFJ9i9oJ7gS44vJZL/2C
         a8wfOY/S77ex+5wg2Fb/u3qQfC5S9VWtf99Dw2LO0yhBnxt/WwUgAJBxGakd+qfMmxUM
         f6GWsKYXY49NTDpq884YPsL3GAs//Pf4IYhBZ6ynVVeEw9yDuqoPDhPoL4WqjUQUWEkD
         uNczl/1XQ7qO6CuFGFk0NjNtJ7nSg9Z79n+sPAHzqhi641JymJgwYZXKX7DoquE3+/80
         ksJvpaJ+8B9p3cSVOVJbb4zlsOKrcx37MmygGXd5bUbseXir7etNw7Afze7lJF9/ocyV
         MwPw==
X-Gm-Message-State: APjAAAUeHD1rjb8jcjJ1lQjLeLc5nje7weVdZx7Vi5GGRCkdecSFJWWC
        ekYAlWzI8dJXdw7wVGBM0LJjuYY5KBY=
X-Google-Smtp-Source: APXvYqw9PY/lhJ73EzCXWsikiVQZ/uCl7VBROMZ9OezrOAMobg4OnZLhSNl9+6nrwsoM42hDlywdqQ==
X-Received: by 2002:aed:2259:: with SMTP id o25mr3496173qtc.55.1569338425505;
        Tue, 24 Sep 2019 08:20:25 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id h68sm1073533qkd.35.2019.09.24.08.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 08:20:24 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH bpf-next v11 1/4] fs/nsfs.c: added ns_match
Date:   Tue, 24 Sep 2019 12:20:02 -0300
Message-Id: <20190924152005.4659-2-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924152005.4659-1-cneirabustos@gmail.com>
References: <20190924152005.4659-1-cneirabustos@gmail.com>
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

