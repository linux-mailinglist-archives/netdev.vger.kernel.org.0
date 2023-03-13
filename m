Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82ACD6B7E16
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCMQuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCMQuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:50:23 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507C1206BD
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:49:59 -0700 (PDT)
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A080F3F487
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 16:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678726179;
        bh=2mQjkvSNBcslZIbfix6gMizSeAygsjTzI97sKnvehnk=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=hR+nDONO3MJu1VV86F797NKjEQEhAoH/afN7x+ZYW4VK9ISePKbXI7w84muPw73fz
         krin2pcpVqQ44iwSF3AlowJhe5uJHSOuZteVjLc/tQMXpRIvqc+1vtN36s8GeEuM4i
         x0ABmhZp1wjfZF2//MJKY0Gl0UrAFbulJhcFo7S45sP1p4hQ4E4uWb7xtb+q5WwsPL
         qFQVtd06l92RGAShQqncNv/W/gAg7jjaUF1gPgupF9e2WafsnzY0fPPMNAxjPw8uC+
         n3DYL9ekKXRLRSsyVmepNgM1FRfmPEu5KVP6yIKwrkH4mXLD3KWnRslxXvYhLLyK6R
         TfxpzmhCrNN5Q==
Received: by mail-ot1-f71.google.com with SMTP id l18-20020a056830055200b00694313ba5a9so6356925otb.17
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:49:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678726178;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2mQjkvSNBcslZIbfix6gMizSeAygsjTzI97sKnvehnk=;
        b=ZvaSUAAAPa1dTXW6JIDQ7kvtsKsbe7+MQytkRHV7gBjdH+hN7RDujIh71Vunk9x2TH
         IfLNG7XvW/F+FownR/tQolum+G9J47ogPRU9kr0jU1BponMD8dKHgCZcfQuJa/gc4VV8
         oyG2Xni7uPYKJ5BT8qXszvVYnfu/V5o06CX1lvwNv//JrKa4Xlhm4Jn2qFSLb4vq0CJf
         HgR1gdXp6bVudYBxNvvMWeMQiqA64ZziS/kWf2fxklcaszdGlvrJOLjIWub9LOQ0H8Ak
         eE9VWf0W9whPQGR6G7trRP8JhH0eHEJQGeecpDQwVO+8CC2WozYOrp0sI1owRCVP0zN1
         1xBQ==
X-Gm-Message-State: AO0yUKV4WkIj+vz+to8fXSUmTDxXVnJoHyJ+f4LrBhf1Kotj20MyfC9Z
        nUvy9vsfOpeqEox4Uofc374zO4EGVpGxApjK4IVVtxT7mfKrA6Y7LFnGuVI+7qgaYHoUTbfvMpj
        8/u9hKBxyQh6EC1oUKSBQcohw/f1vw341Pg==
X-Received: by 2002:aca:1a09:0:b0:384:4e2d:8205 with SMTP id a9-20020aca1a09000000b003844e2d8205mr6858821oia.44.1678726178559;
        Mon, 13 Mar 2023 09:49:38 -0700 (PDT)
X-Google-Smtp-Source: AK7set9An0FXg6hQONxC9LNHyvleOE9r+azmeks0MjLQLDUbl8KfcHBeOT8fKqzd76jNp6TOhGmZPw==
X-Received: by 2002:aca:1a09:0:b0:384:4e2d:8205 with SMTP id a9-20020aca1a09000000b003844e2d8205mr6858809oia.44.1678726178290;
        Mon, 13 Mar 2023 09:49:38 -0700 (PDT)
Received: from altname.. (r167-61-200-197.dialup.adsl.anteldata.net.uy. [167.61.200.197])
        by smtp.gmail.com with ESMTPSA id p203-20020acad8d4000000b00383cc29d6b2sm3323309oig.51.2023.03.13.09.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 09:49:37 -0700 (PDT)
From:   Jorge Merlino <jorge.merlino@canonical.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jorge Merlino <jorge.merlino@canonical.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] Add symlink in /sys/class/net for interface altnames
Date:   Mon, 13 Mar 2023 13:49:03 -0300
Message-Id: <20230313164903.839-1-jorge.merlino@canonical.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently interface altnames behave almost the same as the interface
principal name. One difference is that the not have a symlink in
/sys/class/net as the principal has.
This was mentioned as a TODO item in the original commit:
https://lore.kernel.org/netdev/20190719110029.29466-1-jiri@resnulli.us
This patch adds that symlink when an altname is created and removes it
when the altname is deleted.

Signed-off-by: Jorge Merlino <jorge.merlino@canonical.com>
---
 drivers/base/core.c    | 22 ++++++++++++++++++++++
 include/linux/device.h |  3 +++
 net/core/dev.c         | 11 +++++++++++
 3 files changed, 36 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index e54a10b5d..165f51438 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4223,6 +4223,28 @@ void root_device_unregister(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(root_device_unregister);
 
+/**
+ * device_add_altname_symlink - add a symlink in /sys/class/net for a device
+ * altname
+ * @dev: device getting a new altname
+ * @altname: new altname
+ */
+int device_add_altname_symlink(struct device *dev, const char *altname)
+{
+	return sysfs_create_link(&dev->class->p->subsys.kobj, &dev->kobj,
+			altname);
+}
+
+/**
+ * device_remove_altname_symlink - remove device altname symlink from
+ * /sys/class/net
+ * @dev: device losing an altname
+ * @altname: removed altname
+ */
+void device_remove_altname_symlink(struct device *dev, const char *altname)
+{
+	sysfs_delete_link(&dev->class->p->subsys.kobj, &dev->kobj, altname);
+}
 
 static void device_create_release(struct device *dev)
 {
diff --git a/include/linux/device.h b/include/linux/device.h
index 1508e637b..658d4d743 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -986,6 +986,9 @@ struct device *__root_device_register(const char *name, struct module *owner);
 
 void root_device_unregister(struct device *root);
 
+int device_add_altname_symlink(struct device *dev, const char *altname);
+void device_remove_altname_symlink(struct device *dev, const char *altname);
+
 static inline void *dev_get_platdata(const struct device *dev)
 {
 	return dev->platform_data;
diff --git a/net/core/dev.c b/net/core/dev.c
index 253584777..b40ed0b21 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -150,6 +150,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/prandom.h>
 #include <linux/once_lite.h>
+#include <linux/device.h>
 
 #include "dev.h"
 #include "net-sysfs.h"
@@ -328,6 +329,7 @@ int netdev_name_node_alt_create(struct net_device *dev, const char *name)
 {
 	struct netdev_name_node *name_node;
 	struct net *net = dev_net(dev);
+	int ret;
 
 	name_node = netdev_name_node_lookup(net, name);
 	if (name_node)
@@ -339,6 +341,11 @@ int netdev_name_node_alt_create(struct net_device *dev, const char *name)
 	/* The node that holds dev->name acts as a head of per-device list. */
 	list_add_tail(&name_node->list, &dev->name_node->list);
 
+#ifdef CONFIG_SYSFS
+	ret = device_add_altname_symlink(&dev->dev, name);
+	if (ret)
+		netdev_info(dev, "Unable to create symlink for altname: %d\n", ret);
+#endif
 	return 0;
 }
 
@@ -366,6 +373,10 @@ int netdev_name_node_alt_destroy(struct net_device *dev, const char *name)
 
 	__netdev_name_node_alt_destroy(name_node);
 
+#ifdef CONFIG_SYSFS
+	device_remove_altname_symlink(&dev->dev, name);
+#endif
+
 	return 0;
 }
 
-- 
2.37.2

