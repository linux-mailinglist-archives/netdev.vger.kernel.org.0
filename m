Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E185814F900
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 17:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgBAQnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 11:43:37 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45567 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbgBAQnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 11:43:37 -0500
Received: by mail-pg1-f196.google.com with SMTP id b9so5286734pgk.12
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 08:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/kEt4zzcjpbYHjUzbqL3q2amUjtkDxTI8+uF4And0EI=;
        b=H3qEuqrURBpLfDRdDQwjXBBKyHKatpRgNsNfbbn6UAlk9iIhvw7XUx1yMc/mcs07eH
         YFop6PFwCsQ+BPP3yMp6ICz+vl41zlcpbC4Gz4Jfgo/NhcKwquQEeFtueqZEFdqdXNx0
         8NoiokGR9Qqv7Ww1ZQuGGdygSEPKBAQ/gz5nmD1OHci3BbJuDfhFLyfoqISi7ZzN9734
         RhrJFsl1DxvFdN2AMGkaEW8wihMNP4wbOiCHavHWYB450zhF1xN1C21/p2GMPK1rdU8q
         6oLOySYRnIwwuV2Hh6C/qEV84ndQKRpN3FK0ufCdwExa0oE4yez7fF5zmIQ2Wix3u2KR
         186Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/kEt4zzcjpbYHjUzbqL3q2amUjtkDxTI8+uF4And0EI=;
        b=OY20Q9EXBUW9qwIw/wAIgN7S+FcAb8CRAp3E9Jz3XwjaufoDtfMqOv5rTyRSHyCxUd
         xn+2ucNC2Wd72ve2og2ZB6pK2nSSgknvy5QrvuoqbMidYTTZZutoHGjHbHi39QPz/RNN
         pufz7/lESivqBNcRy33ssHvtiDLJ0HPZ7YNJoMnN4sSc9FuaLbmDmzpGehuSn4jQr+eU
         bnsTvAcRGWxSOUSpPObChDUVcJYm42NpG+vXrCT38bpIrFzxZxXt5lxKBy5CxDEh9dUD
         NiKHOxz/97y87p5bjqi+doOH9Uz9y5/CogSG8e8atyftEDV5X+BcQk44NVN7xujkfnMc
         DRbA==
X-Gm-Message-State: APjAAAW1l30HlVW13vxI6gMbgV+9mx8fOLKzlE8a4DcheS+5WGFhEj67
        VRboKDWGXfdXensQSVSkr0KAgbGA
X-Google-Smtp-Source: APXvYqzD3NLTVPCjGO4twC4t47rHYXd2vw/QDXSRrVm5a4dYHSQKmaPSylmtPe0lBRp7WPuwZL1vQA==
X-Received: by 2002:a63:7907:: with SMTP id u7mr11871010pgc.138.1580575416472;
        Sat, 01 Feb 2020 08:43:36 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id 76sm14887679pfx.97.2020.02.01.08.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 08:43:35 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 5/7] netdevsim: use IS_ERR instead of IS_ERR_OR_NULL for debugfs
Date:   Sat,  1 Feb 2020 16:43:30 +0000
Message-Id: <20200201164330.10159-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Debugfs APIs return valid pointer or error pointer. it doesn't return NULL.
So, using IS_ERR is enough, not using IS_ERR_OR_NULL.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2 -> v3:
 - Include Reviewed-by tag

v1 -> v2:
 - Fix use-after-free
 - Include Reported-by tag

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
index 273a24245d0b..5c5427c840b6 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -77,11 +77,11 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 
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
@@ -115,8 +115,8 @@ static int nsim_dev_port_debugfs_init(struct nsim_dev *nsim_dev,
 	sprintf(port_ddir_name, "%u", nsim_dev_port->port_index);
 	nsim_dev_port->ddir = debugfs_create_dir(port_ddir_name,
 						 nsim_dev->ports_ddir);
-	if (IS_ERR_OR_NULL(nsim_dev_port->ddir))
-		return -ENOMEM;
+	if (IS_ERR(nsim_dev_port->ddir))
+		return PTR_ERR(nsim_dev_port->ddir);
 
 	sprintf(dev_link_name, "../../../" DRV_NAME "%u",
 		nsim_dev->nsim_bus_dev->dev.id);
@@ -934,8 +934,8 @@ int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
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

