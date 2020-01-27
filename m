Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509A214A626
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgA0Oaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:30:52 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43100 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729066AbgA0Oaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 09:30:52 -0500
Received: by mail-pf1-f195.google.com with SMTP id s1so4388860pfh.10
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 06:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ou0kDYuq5RJq3J5tI4/vM3gS4N0SdYFivJXJ6M6m160=;
        b=CVkMFCMkXd3cPSdOIPioKUZtcXDSynz5wFIOECwHV3gM1yvCynkDo/Q2Fm1ttbq6CG
         8IPg/uQ1d5+MlHTYQpxi9vvnwbrA+fOyn+C9rT+uVY9APcJFWH+5Bk3SNDklPBdkWFXz
         uSJWg149YRmdJgHkWdN2BepFdHSwx0ki6L1DkDTqWAkofzNGi4YAyBxIxzKk9Jmo9u5C
         dOUJWIdyPb6dafyvsqlGDNhanvp0nokEAt9TG1SsM2Nqf0uLt3klusQixh8eFzYwlM2q
         s51/QEExzfB7iiuj8QwSQ/3dMJDn9nYGlLQgr4S3RnLVjIxKC3fuCtRsfG2oO31Ex1iB
         zqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ou0kDYuq5RJq3J5tI4/vM3gS4N0SdYFivJXJ6M6m160=;
        b=EglgvLtmbVr6OhMmYdNpCO7DUkHajTCWhsr/E0lyW22VDnFj0rueaeOY39QhPibCrR
         2DguwD4gOGLTGFiRObKPhHY6j/NrX21vsNFBZ7r+bbJSqO635etTwVDhKNiHAdkIq85J
         5L0s4zMz03Slnn3/nXS5fLoCNtJlrFIckBeUghMQER6KiWDVoK7ndxb9VUHLQKGz3dbt
         2sxz/EKI9JCLaASMjBmjWBzdrh7uSTq8sBIiGtLQrCH23x0wPmrg4VCbeIYUqaRrs8lP
         OER+jFPHFqiVbpkQoz4LNgAYN6BdByp6bBLnuZSYHhpbvgYEDLH5c7CtwM7Dql5Bj1o2
         j1zw==
X-Gm-Message-State: APjAAAXYy9BraPKAVDnTrCvAXd6aOMg+GKCDQPtaGYqgtpLzWpuqJk4H
        GdQfPnZTyRA37P5I2tJP8vw=
X-Google-Smtp-Source: APXvYqxcurYBFfp95Ut9cKBAYNJ+z0dgRlE+5ld11S39ngcCkaUzu4WdZyos+lncbGXQh3GgiPYJ8w==
X-Received: by 2002:a62:3846:: with SMTP id f67mr1467610pfa.29.1580135451360;
        Mon, 27 Jan 2020 06:30:51 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id s124sm7483611pfc.57.2020.01.27.06.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 06:30:50 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 4/6] netdevsim: use IS_ERR instead of IS_ERR_OR_NULL for debugfs
Date:   Mon, 27 Jan 2020 14:30:44 +0000
Message-Id: <20200127143044.1468-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Debugfs APIs return valid pointer or error pointer. it doesn't return NULL.
So, using IS_ERR is enough, not using IS_ERR_OR_NULL.

Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Fix use-after-free

 drivers/net/netdevsim/bpf.c    | 10 ++++++----
 drivers/net/netdevsim/dev.c    | 16 ++++++++--------
 drivers/net/netdevsim/health.c |  4 ++--
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index 2b74425822ab..0b362b8dac17 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -218,6 +218,7 @@ static int nsim_bpf_create_prog(struct nsim_dev *nsim_dev,
 {
 	struct nsim_bpf_bound_prog *state;
 	char name[16];
+	int ret;
 
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state)
@@ -230,9 +231,10 @@ static int nsim_bpf_create_prog(struct nsim_dev *nsim_dev,
 	/* Program id is not populated yet when we create the state. */
 	sprintf(name, "%u", nsim_dev->prog_id_gen++);
 	state->ddir = debugfs_create_dir(name, nsim_dev->ddir_bpf_bound_progs);
-	if (IS_ERR_OR_NULL(state->ddir)) {
+	if (IS_ERR(state->ddir)) {
+		ret = PTR_ERR(state->ddir);
 		kfree(state);
-		return -ENOMEM;
+		return ret;
 	}
 
 	debugfs_create_u32("id", 0400, state->ddir, &prog->aux->id);
@@ -587,8 +589,8 @@ int nsim_bpf_dev_init(struct nsim_dev *nsim_dev)
 
 	nsim_dev->ddir_bpf_bound_progs = debugfs_create_dir("bpf_bound_progs",
 							    nsim_dev->ddir);
-	if (IS_ERR_OR_NULL(nsim_dev->ddir_bpf_bound_progs))
-		return -ENOMEM;
+	if (IS_ERR(nsim_dev->ddir_bpf_bound_progs))
+		return PTR_ERR(nsim_dev->ddir_bpf_bound_progs);
 
 	nsim_dev->bpf_dev = bpf_offload_dev_create(&nsim_bpf_dev_ops, nsim_dev);
 	err = PTR_ERR_OR_ZERO(nsim_dev->bpf_dev);
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 2c23b232926b..955da8da72db 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -91,11 +91,11 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 
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
@@ -126,8 +126,8 @@ static int nsim_dev_port_debugfs_init(struct nsim_dev *nsim_dev,
 	sprintf(port_ddir_name, "%u", nsim_dev_port->port_index);
 	nsim_dev_port->ddir = debugfs_create_dir(port_ddir_name,
 						 nsim_dev->ports_ddir);
-	if (IS_ERR_OR_NULL(nsim_dev_port->ddir))
-		return -ENOMEM;
+	if (IS_ERR(nsim_dev_port->ddir))
+		return PTR_ERR(nsim_dev_port->ddir);
 
 	sprintf(dev_link_name, "../../../" DRV_NAME "%u",
 		nsim_dev->nsim_bus_dev->dev.id);
@@ -939,8 +939,8 @@ int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
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

