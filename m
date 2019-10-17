Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C10BDDB098
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 17:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406592AbfJQPAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 11:00:46 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42452 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731768AbfJQPAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 11:00:45 -0400
Received: by mail-qk1-f193.google.com with SMTP id f16so2131220qkl.9;
        Thu, 17 Oct 2019 08:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p5dmhqgXzU0PAo+f6c2oMinYRJIOzYqFfyKVcX2FFw4=;
        b=k51BRc1uXGSeUt3GuXgKvxxmHEPuVIepTatdB1k/6uxcC17yc0gfVyoAUyqN2F2Vix
         6P1OEAXWw6VdSFYmywA6JhR1jZiP7vvFUpO//Re5ahA2eFSSUsz44w6ke5+91hpTUJt1
         06AFNe6uKYvCeVk15wE5EvK1AYM5eu9WSfW2qkjuRCf/av93X7A2zW7HyVVzqNOXlXN0
         WJCeLeZhJoM1zr80t7YpUqbPK6kkoR1e3SNpLPgDKfh0sU/eUwRUkd4yB4lnpxg75ynI
         2iCTru9sdZBacH2SnmTfiNek1SdB3g93JIA8+SwLY23wHN2ZKD248fujOpfO6yKiXl5u
         EnMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p5dmhqgXzU0PAo+f6c2oMinYRJIOzYqFfyKVcX2FFw4=;
        b=Rb8RZ1rxUowzZoCkVrc08zLzU9+aglg668JnskR5Y7mGqaUST1LAQl7V+CUZ23Dtkf
         XP1+5hZVi6bviu8pLeYBkgT1kte+wXzmtuLASSMOl9iIK6YTVzN0voI16agpI01li+7B
         kG/YGAd55QL9mVcn1/6cquUeYH6t45/oRAtiePS/CKsRxwdf8m3jpYx9qnEd/JoaQtmU
         ctWdnbzX/XJ0ZQyvaqD+y/1IM7pK447L2s/A3wJWPfTgUiw5ZKQmt10tm0JKeuinWxiD
         CFYoOIzTnK3yuCgr2/Xgc0CKc8aCMtWhN1ylbcnL8QPNAZpKfqLPynES3Y7VWrliE8Qh
         7Feg==
X-Gm-Message-State: APjAAAWV4/KOMhQQNiKSIAd/toWYbHuIwIYM7UP+JihT20BDdXN+uD2g
        gTzk1NOXZ1fpQeLGA2RTu2AMvzxUrdk=
X-Google-Smtp-Source: APXvYqxkmdMbFO9hxXAN2IWOVudz+DdzpYmQeZRgxUX/nhwtlE94hdDOQmo3PSVEvdZ1RouD7WDdYg==
X-Received: by 2002:a37:4701:: with SMTP id u1mr3786419qka.44.1571324444058;
        Thu, 17 Oct 2019 08:00:44 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id z20sm1550859qtu.91.2019.10.17.08.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 08:00:43 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v14 1/5] fs/nsfs.c: added ns_match
Date:   Thu, 17 Oct 2019 12:00:28 -0300
Message-Id: <20191017150032.14359-2-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017150032.14359-1-cneirabustos@gmail.com>
References: <20191017150032.14359-1-cneirabustos@gmail.com>
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

