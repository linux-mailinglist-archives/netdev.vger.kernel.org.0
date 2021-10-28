Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1633E43F16F
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 23:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhJ1VUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 17:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230404AbhJ1VUY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 17:20:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5B1D604DA;
        Thu, 28 Oct 2021 21:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635455876;
        bh=oVmNafPD8Bpypnh5hWpuqphYZ2o+ldS+sH+iEfPIhuw=;
        h=From:To:Cc:Subject:Date:From;
        b=FGTAmizpIPeFkO0zhRBqbmjwUs2Wwt0TW/DQEoPIKR5nqiuASAPa6L4Izm+FiG3mK
         B0i/BlszeKQyFMObbQmiujQPgjOHAdx7d/cVL6aU86zH00JvtqWkJdjlvahoNJxXZR
         Ym4OlTVMayUPiYiSew91QTDGjtEwQTxHgeSUZrRvkmTjVZ9dVX/Hv2PntbOEezYzuF
         ByjIWORTOPKJ/2/a1b9khoIkgsyPb1X+OCY2wdfyxaE1jslbkzRpLERCk7FitGmhPv
         XtHp1PC7MrI3EZ/kSX6OaK4HuSRQYkgXSsdvVHMU/DJKY8o9pFktsCdX2kDs0bFYYL
         fNUEAzu6nJ/yA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] netdevsim: remove max_vfs dentry
Date:   Thu, 28 Oct 2021 14:17:53 -0700
Message-Id: <20211028211753.22612-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d395381909a3 ("netdevsim: Add max_vfs to bus_dev")
added this file and saved the dentry for no apparent reason.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/dev.c       | 8 +++-----
 drivers/net/netdevsim/netdevsim.h | 1 -
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 3d28ca14acdd..b82089cd71d1 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -265,11 +265,9 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	debugfs_create_bool("fail_trap_policer_counter_get", 0600,
 			    nsim_dev->ddir,
 			    &nsim_dev->fail_trap_policer_counter_get);
-	nsim_dev->max_vfs = debugfs_create_file("max_vfs",
-						0600,
-						nsim_dev->ddir,
-						nsim_dev->nsim_bus_dev,
-						&nsim_dev_max_vfs_fops);
+	debugfs_create_file("max_vfs", 0600, nsim_dev->ddir,
+			    nsim_dev->nsim_bus_dev, &nsim_dev_max_vfs_fops);
+
 	nsim_dev->nodes_ddir = debugfs_create_dir("rate_nodes", nsim_dev->ddir);
 	if (IS_ERR(nsim_dev->nodes_ddir)) {
 		err = PTR_ERR(nsim_dev->nodes_ddir);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index f8df2bfdb777..e58851aff9fa 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -224,7 +224,6 @@ struct nsim_dev {
 	struct dentry *ddir;
 	struct dentry *ports_ddir;
 	struct dentry *take_snapshot;
-	struct dentry *max_vfs;
 	struct dentry *nodes_ddir;
 	struct bpf_offload_dev *bpf_dev;
 	bool bpf_bind_accept;
-- 
2.31.1

