Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 318292C5B0
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfE1LtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:49:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53543 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbfE1Ls4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:48:56 -0400
Received: by mail-wm1-f67.google.com with SMTP id d17so2559973wmb.3
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 04:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BRhuSyE6UCohJUZ9s8GR3j6mbNNiDsPz+HkCnf+nWTs=;
        b=0yzhwyiF9Zw9DKJ+HlrHWCagE8XxfodDZEZhcrW8UXJTRNvL+XPIq6MD3Z8LIMktEQ
         dV+Tvv04UAbjJMguig7w/EZ70wsX7AcBs/YAPL4vLu/GMhyf53XJDzy0FfS0XeVzK1Br
         W1gYUkbJihaOy0Oojp9sxYkg8xdCPoP4CjcNVl0+InkLHdYb4ZBhjmsAjzoYBAeiVnIV
         fHipGtlhXaV6cewV+q9r7H27Rr3sK0hcp2skT0n61BQ4QkcEvnbBO8SmzS5JogXrE++O
         OB/m8isjfTooVw8xuZNTHH71A58YWalAeCTuwethYmU1sgEJBHhBIwcH1qS2tOmY6hjs
         doAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BRhuSyE6UCohJUZ9s8GR3j6mbNNiDsPz+HkCnf+nWTs=;
        b=U1EiYQBKkt83uGybtidmlajkWnB8Uuud2/uCi5qEfNMEyn79ACDFlfm8Ehu7f2Outa
         AJI6QH7lRqA++U5LSBfqUwz7n5fiEak2R1hm+ju5iA1maOid/IgUUNYrhRkqm6U0bQ5e
         1S7nZpDbldcJAtyDFQDe7xK0r0Ck0HGzG1kOpTtmucPDUnfABqG38DmAqiWb95iiGoKl
         Oci7Jhb3L4IcO+BRBzpOcHTmuy0axl9zexGSZLPFaoijurdj81+piHafmtq/f1aPA33P
         gR9mj+9ecR/62ue8JEE6dUnM4U/M3y+kztRE/UZktGLmXS1kHcnMZ7u4NaZ94DEfLHYj
         2S/w==
X-Gm-Message-State: APjAAAUKyp3HYeyKx69bfP6Key2XBDUGWBc4Kx0XxYa+BAG9oos37Tk1
        Wvq6e06BcUZ0ZMAJudALbayrINMFXjY=
X-Google-Smtp-Source: APXvYqw+0McTSxUDLLBAgfdXYuTVPoUjV6ASzvd7DS+iQkjZEmLoawLrfU8BWehDEkxZK5PljXKpkw==
X-Received: by 2002:a1c:6c0a:: with SMTP id h10mr2779468wmc.135.1559044133827;
        Tue, 28 May 2019 04:48:53 -0700 (PDT)
Received: from localhost (ip-89-177-126-215.net.upcbroadband.cz. [89.177.126.215])
        by smtp.gmail.com with ESMTPSA id h17sm16165404wrq.79.2019.05.28.04.48.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 04:48:53 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v2 7/7] netdevsim: implement fake flash updating with notifications
Date:   Tue, 28 May 2019 13:48:46 +0200
Message-Id: <20190528114846.1983-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190528114846.1983-1-jiri@resnulli.us>
References: <20190528114846.1983-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- added debugfs toggle to enable/disable flash status notifications
---
 drivers/net/netdevsim/dev.c       | 44 +++++++++++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 45 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index b509b941d5ca..c5c417a3c0ce 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -38,6 +38,8 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	nsim_dev->ports_ddir = debugfs_create_dir("ports", nsim_dev->ddir);
 	if (IS_ERR_OR_NULL(nsim_dev->ports_ddir))
 		return PTR_ERR_OR_ZERO(nsim_dev->ports_ddir) ?: -EINVAL;
+	debugfs_create_bool("fw_update_status", 0600, nsim_dev->ddir,
+			    &nsim_dev->fw_update_status);
 	return 0;
 }
 
@@ -220,8 +222,49 @@ static int nsim_dev_reload(struct devlink *devlink,
 	return 0;
 }
 
+#define NSIM_DEV_FLASH_SIZE 500000
+#define NSIM_DEV_FLASH_CHUNK_SIZE 1000
+#define NSIM_DEV_FLASH_CHUNK_TIME_MS 10
+
+static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
+				 const char *component,
+				 struct netlink_ext_ack *extack)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	int i;
+
+	if (nsim_dev->fw_update_status) {
+		devlink_flash_update_begin_notify(devlink);
+		devlink_flash_update_status_notify(devlink,
+						   "Preparing to flash",
+						   component, 0, 0);
+	}
+
+	for (i = 0; i < NSIM_DEV_FLASH_SIZE / NSIM_DEV_FLASH_CHUNK_SIZE; i++) {
+		if (nsim_dev->fw_update_status)
+			devlink_flash_update_status_notify(devlink, "Flashing",
+							   component,
+							   i * NSIM_DEV_FLASH_CHUNK_SIZE,
+							   NSIM_DEV_FLASH_SIZE);
+		msleep(NSIM_DEV_FLASH_CHUNK_TIME_MS);
+	}
+
+	if (nsim_dev->fw_update_status) {
+		devlink_flash_update_status_notify(devlink, "Flashing",
+						   component,
+						   NSIM_DEV_FLASH_SIZE,
+						   NSIM_DEV_FLASH_SIZE);
+		devlink_flash_update_status_notify(devlink, "Flashing done",
+						   component, 0, 0);
+		devlink_flash_update_end_notify(devlink);
+	}
+
+	return 0;
+}
+
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.reload = nsim_dev_reload,
+	.flash_update = nsim_dev_flash_update,
 };
 
 static struct nsim_dev *
@@ -240,6 +283,7 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 	get_random_bytes(nsim_dev->switch_id.id, nsim_dev->switch_id.id_len);
 	INIT_LIST_HEAD(&nsim_dev->port_list);
 	mutex_init(&nsim_dev->port_list_lock);
+	nsim_dev->fw_update_status = true;
 
 	nsim_dev->fib_data = nsim_fib_create();
 	if (IS_ERR(nsim_dev->fib_data)) {
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 3f398797c2bc..79c05af2a7c0 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -157,6 +157,7 @@ struct nsim_dev {
 	struct netdev_phys_item_id switch_id;
 	struct list_head port_list;
 	struct mutex port_list_lock; /* protects port list */
+	bool fw_update_status;
 };
 
 int nsim_dev_init(void);
-- 
2.17.2

