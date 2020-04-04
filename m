Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC9519E578
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 16:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgDDOTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 10:19:01 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:53107 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgDDOTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 10:19:00 -0400
Received: by mail-pj1-f68.google.com with SMTP id ng8so4398829pjb.2;
        Sat, 04 Apr 2020 07:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QJ9NcQbuYWxp/fWpC6kxDelETomxeggFMk3kc/GiT3w=;
        b=hpBie/Na48tBzqI/4U3LkzdVWiyl9ohEWuOyWf2iWNxl59ffCTcUe/kZ+IHO9Z/r/K
         HagSNmW47aSHU8YApchp3iRqQ/FrD7bE7TYE95Dk+9QIxyMokBqPmQHLTeL1MQHaGF25
         JyIVjpY3gGL3t0yXxdue5svobta1AOl2hVMUM6JfIFXeCWlN+4xAwNHALIVhna9/+D2D
         O6zPrtdqP/WKQW31sKmb7wDMJ3yIBTJOc+I0dnDjUZrgoNX8O4SfnnS+SQXe1SsBmpP7
         PkK0gLt9voe7gVbjNJ80rD9dRH04OXQdF5boeJ4Z39avMxlFyBGSoME9ifM4Sc4ZvSNS
         ym1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QJ9NcQbuYWxp/fWpC6kxDelETomxeggFMk3kc/GiT3w=;
        b=RyJapa23xmL4vOWzXf90CbCe2lHbg/+ZAzarmFLvQwLSWpI9qzT5ztdrj6gwzDtTKB
         kG6nTG5MP7wAdmyvIV0JvmrvxBtxVi7DXDzgJgPI6rm81N/w+j5ruHw7XADMf0L++X0g
         Jyt5R6lg6zESj5K+dEZxyPYfCgETQpvF7Vequz8OGQmMhuHXj8FHT8OSLg5js4vJWtn0
         zYPHMX7yqNrkDdz4uj40GLVeyVhi3d/G8NPD52YMaibUx3pyB2P7qqxo9zdHXS69B61Y
         Xz+pn4kcf8cYowrKXJ6PS11SAyujmJ4wMNSMu1sC6SA5Trlkoq+OrcJ8Kxsv6jSTiron
         eegA==
X-Gm-Message-State: AGi0PubT0umiAgqFX7eMPU6Ekb+1CgBZ+xDxiizn3GW48T5/Xq3qzoOl
        HwVO7388v47I/0Rpoacbo/w17rWL
X-Google-Smtp-Source: APiQypIMC6nsNFD/3rZQDf7SQJjt1NuRNNoDR7BqAjPZEjoXhIqxuJcbPLbhae1jR34g5VUe4gHUMw==
X-Received: by 2002:a17:90b:4d0b:: with SMTP id mw11mr16067328pjb.45.1586009939247;
        Sat, 04 Apr 2020 07:18:59 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id o11sm7104730pgh.78.2020.04.04.07.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 07:18:58 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ap420073@gmail.com, mitch.a.williams@intel.com
Subject: [PATCH net v2 1/3] class: add class_has_file_ns() helper function
Date:   Sat,  4 Apr 2020 14:18:27 +0000
Message-Id: <20200404141827.26255-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new helper function is to check whether the class file is existing
or not. This function will be used by networking stack to
check "/sys/class/net/*" file.

Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com
Fixes: b76cdba9cdb2 ("[PATCH] bonding: add sysfs functionality to bonding (large)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Implement class_has_file_ns() instead of class_find_and_get_file_ns().
 - Change headline.
 - Add kernel documentation comment.

 drivers/base/class.c         | 22 ++++++++++++++++++++++
 include/linux/device/class.h |  3 ++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index bcd410e6d70a..a2f2787f6aa7 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -105,6 +105,28 @@ void class_remove_file_ns(struct class *cls, const struct class_attribute *attr,
 		sysfs_remove_file_ns(&cls->p->subsys.kobj, &attr->attr, ns);
 }
 
+/**
+ * class_has_file_ns - check whether file is existing or not
+ * @cls: the compatibility class
+ * @name: name to look for
+ * @ns: the namespace tag to use
+ */
+bool class_has_file_ns(struct class *cls, const char *name,
+		       const void *ns)
+{
+	struct kernfs_node *kn = NULL;
+
+	if (cls) {
+		kn = kernfs_find_and_get_ns(cls->p->subsys.kobj.sd, name, ns);
+		if (kn) {
+			kernfs_put(kn);
+			return true;
+		}
+	}
+	return false;
+}
+EXPORT_SYMBOL_GPL(class_has_file_ns);
+
 static struct class *class_get(struct class *cls)
 {
 	if (cls)
diff --git a/include/linux/device/class.h b/include/linux/device/class.h
index e8d470c457d1..b3d43658b201 100644
--- a/include/linux/device/class.h
+++ b/include/linux/device/class.h
@@ -209,7 +209,8 @@ extern int __must_check class_create_file_ns(struct class *class,
 extern void class_remove_file_ns(struct class *class,
 				 const struct class_attribute *attr,
 				 const void *ns);
-
+bool class_has_file_ns(struct class *cls, const char *name,
+		       const void *ns);
 static inline int __must_check class_create_file(struct class *class,
 					const struct class_attribute *attr)
 {
-- 
2.17.1

