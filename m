Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4E62F4B13
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbhAMMNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbhAMMNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:13:46 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64581C0617A3
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:12:32 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id y23so1403242wmi.1
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=chtmYzDo6YZa3nS5UTeYXFkh5EkhTkZCSDsjSSulFTk=;
        b=sUmB6f2ZBC81J14OmsdR4qBzhyLD3igo5EAqs/g/MSlyf9tthNRP+5ArsiFyWo2eIl
         FMCCMvOv1n1kczMhgpxnh+g+8BpCH5b/kNQUgQcHIQpfRKNCjUoZVcGJe9z8z80ivTuU
         9WYHTqMdkROonXjl6LUzrRmrPUANz7E3W4UmpqnvrnKcSugDImw3ehig7WNx95u9T4xc
         acSkoWnkXg3kangreyjxmg4er38qZVQ3Zg2pnstVaJT5XX0mXcKUyskIknR6yF0kExY9
         vZpvUlQUANx1aLqygzHAMKXsPWDtrJ2HLiG8GlMlHdeKJQaUefvQfq/G9gCQnrOPcbH8
         yp1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=chtmYzDo6YZa3nS5UTeYXFkh5EkhTkZCSDsjSSulFTk=;
        b=tCJAiig3FGTVlQozgJvPsMRxcfLBGBGNg/SiR0n/jHKBqp3xb6rAzfxKv+nItI0EMq
         ukAuLuiu+OJ0bLvj77OqkjWaII50Fyu5oYk5z/X5qu4hGQci+iN9506HKFoC6RKZ6HLy
         jc8JJLDtQbYY+yzKQ4x3pG1+T0qXfP3jJm0QIvJSvX+LIJ4p3e5o/CkIEPZLJk5puB0O
         9X4VROtrO4xbHtoMRFDYMyEc1XEb/NpNIexZWhlmvv9+d36C7mh6F4jntomZEXIkY5d0
         ksBIC2zvU7JMRn8nrhVqHHIYG8UOiaUBB4wCs5hnTEfcjRdR/I19LY9laNVSb1C0d9wR
         UkGA==
X-Gm-Message-State: AOAM5318S3JWU2YWkrDaSFKgR6NKUD3JnrCCCwGfRfyoWWWI70rRML2h
        Q5ue1DTQeG7/RiF96r7Y0onhJEnfFH1xrKpj
X-Google-Smtp-Source: ABdhPJw5UlBj9y5dHSnZAOqCwZtQYnmD9yExDZY4Y3DUYycdHTcFj3s6gyhfjQsikA/ZWD26PvAqyw==
X-Received: by 2002:a1c:e042:: with SMTP id x63mr1950330wmg.68.1610539950795;
        Wed, 13 Jan 2021 04:12:30 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id r7sm2675973wmh.2.2021.01.13.04.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 04:12:30 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, mlxsw@nvidia.com
Subject: [patch net-next RFC 06/10] netdevsim: introduce line card support
Date:   Wed, 13 Jan 2021 13:12:18 +0100
Message-Id: <20210113121222.733517-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210113121222.733517-1-jiri@resnulli.us>
References: <20210113121222.733517-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Add support for line card objects. Expose them over debugfs and allow
user to specify number of line cards to be created for a new device.
Similar to ports, the number of line cards is fixed.

Extend "new_device" sysfs file write by third number to allow to specify
number line cards like this:
$ echo "10 4 2" >/sys/bus/netdevsim/new_device

This command asks to create two line cards. By default, if this number
is not preset, no line card is created.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/bus.c       |  17 +++--
 drivers/net/netdevsim/dev.c       | 108 +++++++++++++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h |  15 +++++
 3 files changed, 133 insertions(+), 7 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 0e9511661601..ed57c012e660 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -179,29 +179,34 @@ static struct device_type nsim_bus_dev_type = {
 };
 
 static struct nsim_bus_dev *
-nsim_bus_dev_new(unsigned int id, unsigned int port_count);
+nsim_bus_dev_new(unsigned int id, unsigned int port_count,
+		 unsigned int linecard_count);
 
 static ssize_t
 new_device_store(struct bus_type *bus, const char *buf, size_t count)
 {
 	struct nsim_bus_dev *nsim_bus_dev;
+	unsigned int linecard_count;
 	unsigned int port_count;
 	unsigned int id;
 	int err;
 
-	err = sscanf(buf, "%u %u", &id, &port_count);
+	err = sscanf(buf, "%u %u %u", &id, &port_count, &linecard_count);
 	switch (err) {
 	case 1:
 		port_count = 1;
 		fallthrough;
 	case 2:
+		linecard_count = 0;
+		fallthrough;
+	case 3:
 		if (id > INT_MAX) {
 			pr_err("Value of \"id\" is too big.\n");
 			return -EINVAL;
 		}
 		break;
 	default:
-		pr_err("Format for adding new device is \"id port_count\" (uint uint).\n");
+		pr_err("Format for adding new device is \"id port_count linecard_count\" (uint uint uint).\n");
 		return -EINVAL;
 	}
 
@@ -212,7 +217,7 @@ new_device_store(struct bus_type *bus, const char *buf, size_t count)
 		goto err;
 	}
 
-	nsim_bus_dev = nsim_bus_dev_new(id, port_count);
+	nsim_bus_dev = nsim_bus_dev_new(id, port_count, linecard_count);
 	if (IS_ERR(nsim_bus_dev)) {
 		err = PTR_ERR(nsim_bus_dev);
 		goto err;
@@ -312,7 +317,8 @@ static struct bus_type nsim_bus = {
 };
 
 static struct nsim_bus_dev *
-nsim_bus_dev_new(unsigned int id, unsigned int port_count)
+nsim_bus_dev_new(unsigned int id, unsigned int port_count,
+		 unsigned int linecard_count)
 {
 	struct nsim_bus_dev *nsim_bus_dev;
 	int err;
@@ -328,6 +334,7 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count)
 	nsim_bus_dev->dev.bus = &nsim_bus;
 	nsim_bus_dev->dev.type = &nsim_bus_dev_type;
 	nsim_bus_dev->port_count = port_count;
+	nsim_bus_dev->linecard_count = linecard_count;
 	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
 	mutex_init(&nsim_bus_dev->nsim_bus_reload_lock);
 	/* Disallow using nsim_bus_dev */
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 816af1f55e2c..d81ccfa05a28 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -203,6 +203,10 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	nsim_dev->ports_ddir = debugfs_create_dir("ports", nsim_dev->ddir);
 	if (IS_ERR(nsim_dev->ports_ddir))
 		return PTR_ERR(nsim_dev->ports_ddir);
+	nsim_dev->linecards_ddir = debugfs_create_dir("linecards",
+						      nsim_dev->ddir);
+	if (IS_ERR(nsim_dev->linecards_ddir))
+		return PTR_ERR(nsim_dev->linecards_ddir);
 	debugfs_create_bool("fw_update_status", 0600, nsim_dev->ddir,
 			    &nsim_dev->fw_update_status);
 	debugfs_create_u32("fw_update_overwrite_mask", 0600, nsim_dev->ddir,
@@ -237,6 +241,7 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 
 static void nsim_dev_debugfs_exit(struct nsim_dev *nsim_dev)
 {
+	debugfs_remove_recursive(nsim_dev->linecards_ddir);
 	debugfs_remove_recursive(nsim_dev->ports_ddir);
 	debugfs_remove_recursive(nsim_dev->ddir);
 }
@@ -265,6 +270,32 @@ static void nsim_dev_port_debugfs_exit(struct nsim_dev_port *nsim_dev_port)
 	debugfs_remove_recursive(nsim_dev_port->ddir);
 }
 
+static int
+nsim_dev_linecard_debugfs_init(struct nsim_dev *nsim_dev,
+			       struct nsim_dev_linecard *nsim_dev_linecard)
+{
+	char linecard_ddir_name[16];
+	char dev_link_name[32];
+
+	sprintf(linecard_ddir_name, "%u", nsim_dev_linecard->linecard_index);
+	nsim_dev_linecard->ddir = debugfs_create_dir(linecard_ddir_name,
+						     nsim_dev->linecards_ddir);
+	if (IS_ERR(nsim_dev_linecard->ddir))
+		return PTR_ERR(nsim_dev_linecard->ddir);
+
+	sprintf(dev_link_name, "../../../" DRV_NAME "%u",
+		nsim_dev->nsim_bus_dev->dev.id);
+	debugfs_create_symlink("dev", nsim_dev_linecard->ddir, dev_link_name);
+
+	return 0;
+}
+
+static void
+nsim_dev_linecard_debugfs_exit(struct nsim_dev_linecard *nsim_dev_linecard)
+{
+	debugfs_remove_recursive(nsim_dev_linecard->ddir);
+}
+
 static int nsim_dev_resources_register(struct devlink *devlink)
 {
 	struct devlink_resource_size_params params = {
@@ -998,6 +1029,64 @@ static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
 	return err;
 }
 
+static int __nsim_dev_linecard_add(struct nsim_dev *nsim_dev,
+				   unsigned int linecard_index)
+{
+	struct nsim_dev_linecard *nsim_dev_linecard;
+	int err;
+
+	nsim_dev_linecard = kzalloc(sizeof(*nsim_dev_linecard), GFP_KERNEL);
+	if (!nsim_dev_linecard)
+		return -ENOMEM;
+	nsim_dev_linecard->nsim_dev = nsim_dev;
+	nsim_dev_linecard->linecard_index = linecard_index;
+
+	err = nsim_dev_linecard_debugfs_init(nsim_dev, nsim_dev_linecard);
+	if (err)
+		goto err_linecard_free;
+
+	list_add(&nsim_dev_linecard->list, &nsim_dev->linecard_list);
+
+	return 0;
+
+err_linecard_free:
+	kfree(nsim_dev_linecard);
+	return err;
+}
+
+static void __nsim_dev_linecard_del(struct nsim_dev_linecard *nsim_dev_linecard)
+{
+	list_del(&nsim_dev_linecard->list);
+	nsim_dev_linecard_debugfs_exit(nsim_dev_linecard);
+	kfree(nsim_dev_linecard);
+}
+
+static void nsim_dev_linecard_del_all(struct nsim_dev *nsim_dev)
+{
+	struct nsim_dev_linecard *nsim_dev_linecard, *tmp;
+
+	list_for_each_entry_safe(nsim_dev_linecard, tmp,
+				 &nsim_dev->linecard_list, list)
+		__nsim_dev_linecard_del(nsim_dev_linecard);
+}
+
+static int nsim_dev_linecard_add_all(struct nsim_dev *nsim_dev,
+				     unsigned int linecard_count)
+{
+	int i, err;
+
+	for (i = 0; i < linecard_count; i++) {
+		err = __nsim_dev_linecard_add(nsim_dev, i);
+		if (err)
+			goto err_linecard_del_all;
+	}
+	return 0;
+
+err_linecard_del_all:
+	nsim_dev_linecard_del_all(nsim_dev);
+	return err;
+}
+
 static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 				  struct netlink_ext_ack *extack)
 {
@@ -1009,6 +1098,7 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	nsim_dev = devlink_priv(devlink);
 	INIT_LIST_HEAD(&nsim_dev->port_list);
 	mutex_init(&nsim_dev->port_list_lock);
+	INIT_LIST_HEAD(&nsim_dev->linecard_list);
 	nsim_dev->fw_update_status = true;
 	nsim_dev->fw_update_overwrite_mask = 0;
 
@@ -1030,10 +1120,14 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	if (err)
 		goto err_traps_exit;
 
-	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	err = nsim_dev_linecard_add_all(nsim_dev, nsim_bus_dev->linecard_count);
 	if (err)
 		goto err_health_exit;
 
+	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	if (err)
+		goto err_linecard_del_all;
+
 	nsim_dev->take_snapshot = debugfs_create_file("take_snapshot",
 						      0200,
 						      nsim_dev->ddir,
@@ -1041,6 +1135,8 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 						&nsim_dev_take_snapshot_fops);
 	return 0;
 
+err_linecard_del_all:
+	nsim_dev_linecard_del_all(nsim_dev);
 err_health_exit:
 	nsim_dev_health_exit(nsim_dev);
 err_traps_exit:
@@ -1068,6 +1164,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	get_random_bytes(nsim_dev->switch_id.id, nsim_dev->switch_id.id_len);
 	INIT_LIST_HEAD(&nsim_dev->port_list);
 	mutex_init(&nsim_dev->port_list_lock);
+	INIT_LIST_HEAD(&nsim_dev->linecard_list);
 	nsim_dev->fw_update_status = true;
 	nsim_dev->fw_update_overwrite_mask = 0;
 	nsim_dev->max_macs = NSIM_DEV_MAX_MACS_DEFAULT;
@@ -1116,14 +1213,20 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_health_exit;
 
-	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	err = nsim_dev_linecard_add_all(nsim_dev, nsim_bus_dev->linecard_count);
 	if (err)
 		goto err_bpf_dev_exit;
 
+	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	if (err)
+		goto err_linecard_del_all;
+
 	devlink_params_publish(devlink);
 	devlink_reload_enable(devlink);
 	return 0;
 
+err_linecard_del_all:
+	nsim_dev_linecard_del_all(nsim_dev);
 err_bpf_dev_exit:
 	nsim_bpf_dev_exit(nsim_dev);
 err_health_exit:
@@ -1156,6 +1259,7 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 		return;
 	debugfs_remove(nsim_dev->take_snapshot);
 	nsim_dev_port_del_all(nsim_dev);
+	nsim_dev_linecard_del_all(nsim_dev);
 	nsim_dev_health_exit(nsim_dev);
 	nsim_dev_traps_exit(devlink);
 	nsim_dev_dummy_region_exit(nsim_dev);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 48163c5f2ec9..df10f9d11e9d 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -180,20 +180,33 @@ struct nsim_dev_health {
 int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink);
 void nsim_dev_health_exit(struct nsim_dev *nsim_dev);
 
+struct nsim_dev_linecard;
+
 struct nsim_dev_port {
 	struct list_head list;
 	struct devlink_port devlink_port;
+	struct nsim_dev_linecard *linecard;
 	unsigned int port_index;
 	struct dentry *ddir;
 	struct netdevsim *ns;
 };
 
+struct nsim_dev;
+
+struct nsim_dev_linecard {
+	struct list_head list;
+	struct nsim_dev *nsim_dev;
+	unsigned int linecard_index;
+	struct dentry *ddir;
+};
+
 struct nsim_dev {
 	struct nsim_bus_dev *nsim_bus_dev;
 	struct nsim_fib_data *fib_data;
 	struct nsim_trap_data *trap_data;
 	struct dentry *ddir;
 	struct dentry *ports_ddir;
+	struct dentry *linecards_ddir;
 	struct dentry *take_snapshot;
 	struct bpf_offload_dev *bpf_dev;
 	bool bpf_bind_accept;
@@ -206,6 +219,7 @@ struct nsim_dev {
 	struct netdev_phys_item_id switch_id;
 	struct list_head port_list;
 	struct mutex port_list_lock; /* protects port list */
+	struct list_head linecard_list;
 	bool fw_update_status;
 	u32 fw_update_overwrite_mask;
 	u32 max_macs;
@@ -287,6 +301,7 @@ struct nsim_bus_dev {
 	struct device dev;
 	struct list_head list;
 	unsigned int port_count;
+	unsigned int linecard_count;
 	struct net *initial_net; /* Purpose of this is to carry net pointer
 				  * during the probe time only.
 				  */
-- 
2.26.2

