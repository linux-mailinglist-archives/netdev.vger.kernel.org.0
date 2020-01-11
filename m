Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C5813827A
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 17:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbgAKQhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 11:37:51 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42266 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730425AbgAKQhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 11:37:51 -0500
Received: by mail-pf1-f196.google.com with SMTP id 4so2682554pfz.9
        for <netdev@vger.kernel.org>; Sat, 11 Jan 2020 08:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zEukTaDPVmeW1rRNEKzilX8PH74WDVyvzPN/YsnR9oI=;
        b=jhB+8hzWGxb/3FzRarBqPmYSR/8C3BG/5MejTLCYb9ixHMl0R7PWWyFMZWLLXJGBgl
         oYZaSXYTdceBklM240UUwrOgZSsPJ4//AsknURcM4wJb6UuooIdO3+kWIKQfyqbSFqPR
         uciEU1etvqVxY0Ut08PhLg8XmtZG/9TsWKOfyxYSAjGw79HOJYR0p42tzfleMw0BXrZF
         hDPEnIuX35MaqRqMJmWx+do/T2XeCDTlQw7d4o2BOn+p7I8LH2YhEJVrWlIuJEl9RyAe
         GUYnimfIOXPn+VlkQ7aOGZy3FtjxS4k3BOqid0V1CVxUKszXolMt4VNE98zSWGmYDZTE
         7M/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zEukTaDPVmeW1rRNEKzilX8PH74WDVyvzPN/YsnR9oI=;
        b=anqFl+LzX4Fb6PC6FZMD0FKy7ilxc95zyaxJTBHoAoIonoE5VrrFbOR78nHphf5U0r
         vMNLjD2j8HcANlyiteH55bpkSV3XL3p7X03Bzsdp6+B4QPAbKCfRAdOzev79aPI1CSWT
         5kxqbCx0CdEbkBMOL31Q0QUWhEoL6Y3dl1unbhN+MA5N/Ve2gakZ68Tvk5+XCXDUa0rt
         t04nyPWIlRDZpmrySsbFyRPsquEzrwFuzHmNPXvHRoyral0UePnr482NrvPKaBRHKGXd
         xTsTy84/jon0V/QpnNnm6VgznBgTywHyBdfD2nnJlVozPynh1qNh86spW1UIQWnwcFdA
         J+kw==
X-Gm-Message-State: APjAAAVxdKKTTCErgWB/RTMyu9RFFEVfuxvQ6rdavbZlzcogjA7MG8K6
        b7NC1bQRZkJNdAgHIdAQ28E=
X-Google-Smtp-Source: APXvYqzQTYadeREMELzCKqJtXRRD7bMrtv7igi2O1Xw8VJfIvZ4RqV4bpRdPnt97dl2A1oDNKK53Yw==
X-Received: by 2002:a63:214f:: with SMTP id s15mr12465342pgm.238.1578760670123;
        Sat, 11 Jan 2020 08:37:50 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id t30sm6954764pgl.75.2020.01.11.08.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 08:37:49 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 4/5] netdevsim: use IS_ERR instead of IS_ERR_OR_NULL for debugfs
Date:   Sat, 11 Jan 2020 16:37:43 +0000
Message-Id: <20200111163743.4339-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Debugfs APIs return valid pointer or error pointer. it doesn't return NULL.
So, using IS_ERR is enough, not using IS_ERR_OR_NULL.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/netdevsim/bpf.c    |  8 ++++----
 drivers/net/netdevsim/dev.c    | 16 ++++++++--------
 drivers/net/netdevsim/health.c |  4 ++--
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index 13e17c82d71c..8d2e157f6efc 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -241,9 +241,9 @@ static int nsim_bpf_create_prog(struct nsim_dev *nsim_dev,
 	/* Program id is not populated yet when we create the state. */
 	sprintf(name, "%u", nsim_dev->prog_id_gen++);
 	state->ddir = debugfs_create_dir(name, nsim_dev->ddir_bpf_bound_progs);
-	if (IS_ERR_OR_NULL(state->ddir)) {
+	if (IS_ERR(state->ddir)) {
 		kfree(state);
-		return -ENOMEM;
+		return PTR_ERR(state->ddir);
 	}
 
 	debugfs_create_u32("id", 0400, state->ddir, &prog->aux->id);
@@ -598,8 +598,8 @@ int nsim_bpf_dev_init(struct nsim_dev *nsim_dev)
 
 	nsim_dev->ddir_bpf_bound_progs = debugfs_create_dir("bpf_bound_progs",
 							    nsim_dev->ddir);
-	if (IS_ERR_OR_NULL(nsim_dev->ddir_bpf_bound_progs))
-		return -ENOMEM;
+	if (IS_ERR(nsim_dev->ddir_bpf_bound_progs))
+		return PTR_ERR(nsim_dev->ddir_bpf_bound_progs);
 
 	nsim_dev->bpf_dev = bpf_offload_dev_create(&nsim_bpf_dev_ops, nsim_dev);
 	err = PTR_ERR_OR_ZERO(nsim_dev->bpf_dev);
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index a0c80a70bb23..9ea283a02bcf 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -92,11 +92,11 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 
 	sprintf(dev_ddir_name, DRV_NAME "%u", nsim_dev->nsim_bus_dev->dev.id);
 	nsim_dev->ddir = debugfs_create_dir(dev_ddir_name, nsim_dev_ddir);
-	if (IS_ERR_OR_NULL(nsim_dev->ddir))
-		return PTR_ERR_OR_ZERO(nsim_dev->ddir) ?: -EINVAL;
+	if (IS_ERR(nsim_dev->ddir))
+		return PTR_ERR(nsim_dev->ddir);
 	nsim_dev->ports_ddir = debugfs_create_dir("ports", nsim_dev->ddir);
-	if (IS_ERR_OR_NULL(nsim_dev->ports_ddir))
-		return PTR_ERR_OR_ZERO(nsim_dev->ports_ddir) ?: -EINVAL;
+	if (IS_ERR(nsim_dev->ports_ddir))
+		return PTR_ERR(nsim_dev->ports_ddir);
 	debugfs_create_bool("fw_update_status", 0600, nsim_dev->ddir,
 			    &nsim_dev->fw_update_status);
 	debugfs_create_u32("max_macs", 0600, nsim_dev->ddir,
@@ -127,8 +127,8 @@ static int nsim_dev_port_debugfs_init(struct nsim_dev *nsim_dev,
 	sprintf(port_ddir_name, "%u", nsim_dev_port->port_index);
 	nsim_dev_port->ddir = debugfs_create_dir(port_ddir_name,
 						 nsim_dev->ports_ddir);
-	if (IS_ERR_OR_NULL(nsim_dev_port->ddir))
-		return -ENOMEM;
+	if (IS_ERR(nsim_dev_port->ddir))
+		return PTR_ERR(nsim_dev_port->ddir);
 
 	sprintf(dev_link_name, "../../../" DRV_NAME "%u",
 		nsim_dev->nsim_bus_dev->dev.id);
@@ -943,8 +943,8 @@ int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
 int nsim_dev_init(void)
 {
 	nsim_dev_ddir = debugfs_create_dir(DRV_NAME, NULL);
-	if (IS_ERR_OR_NULL(nsim_dev_ddir))
-		return -ENOMEM;
+	if (IS_ERR(nsim_dev_ddir))
+		return PTR_ERR(nsim_dev_ddir);
 	return 0;
 }
 
diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
index 9aa637d162eb..30595b1299bd 100644
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -285,8 +285,8 @@ int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink)
 	}
 
 	health->ddir = debugfs_create_dir("health", nsim_dev->ddir);
-	if (IS_ERR_OR_NULL(health->ddir)) {
-		err = PTR_ERR_OR_ZERO(health->ddir) ?: -EINVAL;
+	if (IS_ERR(health->ddir)) {
+		err = PTR_ERR(health->ddir);
 		goto err_dummy_reporter_destroy;
 	}
 
-- 
2.17.1

