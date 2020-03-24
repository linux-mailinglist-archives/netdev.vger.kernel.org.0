Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4710B190D70
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 13:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgCXMbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 08:31:13 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46717 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbgCXMbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 08:31:12 -0400
Received: by mail-pg1-f196.google.com with SMTP id k191so7800695pgc.13;
        Tue, 24 Mar 2020 05:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=D3JI0OQU8x2pwfGu19abKz8hfaV3ClUa1LRDR1fAqM4=;
        b=Axg7D1R2KMjDIo/ri9ExJCeHa7O6Y8Ex2bB17ohf5FrjppjNzZKUc/pnyIYXAsiafS
         RjXyoB7sQCg6b9x5xZdNCYlhREFsPTQsE9EBtM/LTSMtY1USWfGCQTyk96Q13t1uX41X
         2WdkstyddM9tIrUUe7jzNcpTeVpOhO6YPGlRq0kL5XFxRFnQgEcRa+iE8pIbx44VcbUG
         dGq/mWozbThild/OnXL3cXXhapq9klN5YRs00waue2cgJcjpggJIOFKEu/cEueelV+m+
         ubAheNEpg56Wq/K+FtSWL6p2HPVtn6KmFUrUdk48D0V8kTvkvwD+PupLRWRDGAY0crCH
         s7dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=D3JI0OQU8x2pwfGu19abKz8hfaV3ClUa1LRDR1fAqM4=;
        b=DBmUbQNUyg7iwZ27sw2q6TYk+HMRWioaCzcpLIz/mCStFXuOemgY0UeMx4baGbSMZz
         Q3DJeOr5EBnEYykbRX0RKIdD9d5NCKxR09bXO7O0lcxrSBKItim6bQZURKGdYO9T8CSF
         yedcIIw3j/NlMkFDsNz7JWolifWIah28XfxFssQad0GKYwq7a20HZ+Y8aNH9hqgPMMc8
         dy0WsvihpQdFM46v4RxYfLy70/pdx1PPUUiNjmjgRUQgLNRabGKVEhWy9Tg5qBU4Chos
         kJizS9bsA8wRM6UBf8c/ZLireQIho4gYTcEERdqT8c6N1LqoBFGxsageICereeFkv0KI
         89vg==
X-Gm-Message-State: ANhLgQ2WkysdRdIgD/9Y0z+n/kwzi/0bRjq+JFomBXRppg+vKco/yRg0
        kXziKMGvnI09iOmRPzOVoUg=
X-Google-Smtp-Source: ADFU+vuvazGxt+ZX6Sa6qam11zv/P2AlsEXxrsMv96eC/57mOzFSHAsbecN95nzF/nJ2FJfdR0s4lQ==
X-Received: by 2002:a62:3147:: with SMTP id x68mr1584388pfx.62.1585053071672;
        Tue, 24 Mar 2020 05:31:11 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id w6sm15959336pfw.55.2020.03.24.05.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 05:31:10 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ap420073@gmail.com, mitch.a.williams@intel.com
Subject: [PATCH net 2/3] net: core: add netdev_class_has_file_ns() helper function
Date:   Tue, 24 Mar 2020 12:31:04 +0000
Message-Id: <20200324123104.18983-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helper function is to check whether the class file "/sys/class/net*"
is existing or not.
In the next patch, this helper function will be used.

Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com
Fixes: b76cdba9cdb2 ("[PATCH] bonding: add sysfs functionality to bonding (large)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/linux/netdevice.h |  2 +-
 net/core/net-sysfs.c      | 13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6c3f7032e8d9..e32edca79e3a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4545,7 +4545,7 @@ int netdev_class_create_file_ns(const struct class_attribute *class_attr,
 				const void *ns);
 void netdev_class_remove_file_ns(const struct class_attribute *class_attr,
 				 const void *ns);
-
+bool netdev_class_has_file_ns(const char *name, const void *ns);
 static inline int netdev_class_create_file(const struct class_attribute *class_attr)
 {
 	return netdev_class_create_file_ns(class_attr, NULL);
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 4c826b8bf9b1..78de063201bc 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1781,6 +1781,19 @@ void netdev_class_remove_file_ns(const struct class_attribute *class_attr,
 }
 EXPORT_SYMBOL(netdev_class_remove_file_ns);
 
+bool netdev_class_has_file_ns(const char *name, const void *ns)
+{
+	struct kernfs_node *kn;
+
+	kn = class_find_and_get_file_ns(&net_class, name, ns);
+	if (kn) {
+		kernfs_put(kn);
+		return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL(netdev_class_has_file_ns);
+
 int __init netdev_kobject_init(void)
 {
 	kobj_ns_type_register(&net_ns_type_operations);
-- 
2.17.1

