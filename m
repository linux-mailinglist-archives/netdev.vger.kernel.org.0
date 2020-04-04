Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E56419E57A
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 16:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgDDOTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 10:19:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36117 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgDDOTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 10:19:19 -0400
Received: by mail-pg1-f195.google.com with SMTP id c23so5111314pgj.3;
        Sat, 04 Apr 2020 07:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2qcBk2Kee3c2H8KonoYQptPwts2tMtEwFN7KzhaQ2kA=;
        b=P6SMp6q09+//0MLio/ZPPVTPzvoaeIu3FNBLqVPC2JwNe9fyUVtAFuJeFQFKBNwVZi
         nmmiG8tMe46Y/snCkXoP0G/99FeMCDgNImcMpuZW1A4R/BE7cQx1zhSsmmcFWvMZNnxG
         BkRJGVNX4XJXrn1FFl5FECG7exdk/DTHEh2ZjV4Q8hWfFf6D6eMeyNJo3AY4rSu+/gfb
         MtOZbNnGWc2fLCgJGZrDlo6rIRmYkeiR2V5hdbUA0+gWRs/lT12A6XrBd0Zn12tl5FCB
         Ftm9ITYKuEwPuqB6j+gjQp1IA5cEPZPC7YK01SU7Jox0iZB4VM4V3MiiGDu5wlnxx0pV
         mnZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2qcBk2Kee3c2H8KonoYQptPwts2tMtEwFN7KzhaQ2kA=;
        b=lM5O0AmEOAL/7teknPKNeQFC0n4woL3RhhCo41/ugf0PFip/vuBx5cJcnKqHrQncnV
         UDS0OpTTer2J/YjzbVHHKGr82W4PCJXyBLYQoVDxv4LznbkCgL7JfWeZBv/gB/z6DQxT
         dNZDMnF/qhYu0jB1MUb5DaPPYuoYEoWqBuea43HK8gQezP71VwPxs9eSfAVENh/8me2s
         OOHRT0aQs19URQlMoM0UFjKvatL/rg0twjDrCyZIns341zDHoXroo/DH7sR15xD83zAY
         /NPs7/kz7Ql5RgQKWLgFYgn0vl/hUMDkefG8WE84fy9jkyihcyVyMbgIbIIA3k1JzjeD
         RVmw==
X-Gm-Message-State: AGi0Pub+0OP0+NQSAbENPAfE42BYP1AUfeRrGaf9onQ6n+FGkXJHTBNF
        gx9m0jqPwoHLs9616AjZ9c8=
X-Google-Smtp-Source: APiQypIlxvSawXoB+jieWeDwhpjcHlo0Wly8PQrE2MKJQn+0hWfY6iH5a17kaWCZ/i80AsCGjWVHZQ==
X-Received: by 2002:a62:76d1:: with SMTP id r200mr13447849pfc.298.1586009958356;
        Sat, 04 Apr 2020 07:19:18 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id d5sm7853360pfa.59.2020.04.04.07.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 07:19:17 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ap420073@gmail.com, mitch.a.williams@intel.com
Subject: [PATCH net v2 2/3] net: core: add netdev_class_has_file_ns() helper function
Date:   Sat,  4 Apr 2020 14:19:09 +0000
Message-Id: <20200404141909.26399-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helper function is to check whether the class file "/sys/class/net/*"
is existing or not.
In the next patch, this helper function will be used.

Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com
Fixes: b76cdba9cdb2 ("[PATCH] bonding: add sysfs functionality to bonding (large)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - use class_has_file_ns(), which is introduced by the first patch.

 include/linux/netdevice.h | 2 +-
 net/core/net-sysfs.c      | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 130a668049ab..a04c487c0975 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4555,7 +4555,7 @@ int netdev_class_create_file_ns(const struct class_attribute *class_attr,
 				const void *ns);
 void netdev_class_remove_file_ns(const struct class_attribute *class_attr,
 				 const void *ns);
-
+bool netdev_class_has_file_ns(const char *name, const void *ns);
 static inline int netdev_class_create_file(const struct class_attribute *class_attr)
 {
 	return netdev_class_create_file_ns(class_attr, NULL);
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index cf0215734ceb..8a20d658eff0 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1914,6 +1914,12 @@ void netdev_class_remove_file_ns(const struct class_attribute *class_attr,
 }
 EXPORT_SYMBOL(netdev_class_remove_file_ns);
 
+bool netdev_class_has_file_ns(const char *name, const void *ns)
+{
+	return class_has_file_ns(&net_class, name, ns);
+}
+EXPORT_SYMBOL(netdev_class_has_file_ns);
+
 int __init netdev_kobject_init(void)
 {
 	kobj_ns_type_register(&net_ns_type_operations);
-- 
2.17.1

