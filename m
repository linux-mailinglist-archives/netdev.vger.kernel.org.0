Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279E12466AE
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 14:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgHQMwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 08:52:41 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:55175 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728452AbgHQMwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 08:52:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id C89B391A;
        Mon, 17 Aug 2020 08:52:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 17 Aug 2020 08:52:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=RZNNt95zD5BPj7e1BZG4LoynU6kgWATDWqYasbxe7es=; b=Hu/TDNFO
        s1bhBCLIol4zj8RhHk1V78AJnumcUzsrYdrbvCf1cF/MlRc36+O7d5uSUKeKzfGp
        tYm++DqWtbu6UM8AFQwti34OKgukfu9qUxKCVLmo6orJ7Yfwi43OnI6TlksfbixR
        LxU2Meao2qj0rzw1DvRdW2y4TvxyhNnyaQJ+3ervbdKC+R9UoClszyRKlpERYsTq
        P071ermpA3EaiixJmxzezIrf+27xNk49TtBiWklWTJVD0zeflY/WLFaTpM6HVqkt
        /bd1IXLf3g3H3UTusrPRvZkk9BRZwEfqTS81RFxjkoMYgyJwRUdOsmp2i6ezxm7G
        0hiVt14jIRrV8Q==
X-ME-Sender: <xms:jH06XzGe1TNq_rcToviyX3Ewj3R8Shq1HTcJjfL-uqSIkIOa8s0zDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudekvddrieefrdegvden
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:jH06XwV9NpkgSCH8I00z112qwAXO9frFFZYEzOOcCqyukbwcvM3ReQ>
    <xmx:jH06X1IRgr6deuKHdxpuNkYmsF2r4HglbJgH_CPw2Rt0NEdFbONWdw>
    <xmx:jH06XxF4bFEzc4VvxTi8xwusVUNFy8N0i1R1mKURD4EGEaqHD5jwzg>
    <xmx:jH06X-XRrTQjHHRL3yMXX_j0fReaTfejqPW8tcxV-0Wtsf97U73pqsMDIMs>
Received: from localhost.localdomain (bzq-79-182-63-42.red.bezeqint.net [79.182.63.42])
        by mail.messagingengine.com (Postfix) with ESMTPA id 64F9D306005F;
        Mon, 17 Aug 2020 08:52:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, dsahern@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, saeedm@nvidia.com,
        tariqt@nvidia.com, ayal@nvidia.com, eranbe@nvidia.com,
        mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 2/6] netdevsim: Add devlink metric support
Date:   Mon, 17 Aug 2020 15:50:55 +0300
Message-Id: <20200817125059.193242-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200817125059.193242-1-idosch@idosch.org>
References: <20200817125059.193242-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Register a dummy counter with devlink that is incremented by one
whenever queried.

Allow the query to fail by writing to a file in debugfs so that error
paths in the core infrastructure could be exercised.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/netdevsim/dev.c       | 92 ++++++++++++++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 32f339fedb21..075d2d4e22a5 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -692,6 +692,81 @@ static void nsim_dev_traps_exit(struct devlink *devlink)
 	kfree(nsim_dev->trap_data);
 }
 
+struct nsim_metric_data {
+	struct devlink_metric *dummy_counter;
+	struct dentry *ddir;
+	u64 dummy_counter_value;
+	bool fail_counter_get;
+};
+
+static int nsim_dev_dummy_counter_get(struct devlink_metric *metric, u64 *p_val)
+{
+	struct nsim_dev *nsim_dev = devlink_metric_priv(metric);
+	u64 *cnt;
+
+	if (nsim_dev->metric_data->fail_counter_get)
+		return -EINVAL;
+
+	cnt = &nsim_dev->metric_data->dummy_counter_value;
+	*p_val = (*cnt)++;
+
+	return 0;
+}
+
+static const struct devlink_metric_ops nsim_dev_dummy_counter_ops = {
+	.counter_get = nsim_dev_dummy_counter_get,
+};
+
+static int nsim_dev_metric_init(struct nsim_dev *nsim_dev)
+{
+	struct devlink *devlink = priv_to_devlink(nsim_dev);
+	struct nsim_metric_data *nsim_metric_data;
+	struct devlink_metric *dummy_counter;
+	int err;
+
+	nsim_metric_data = kzalloc(sizeof(*nsim_metric_data), GFP_KERNEL);
+	if (!nsim_metric_data)
+		return -ENOMEM;
+	nsim_dev->metric_data = nsim_metric_data;
+
+	dummy_counter = devlink_metric_counter_create(devlink, "dummy_counter",
+						      &nsim_dev_dummy_counter_ops,
+						      nsim_dev);
+	if (IS_ERR(dummy_counter)) {
+		err = PTR_ERR(dummy_counter);
+		goto err_free_metric_data;
+	}
+	nsim_metric_data->dummy_counter = dummy_counter;
+
+	nsim_metric_data->ddir = debugfs_create_dir("metric", nsim_dev->ddir);
+	if (IS_ERR(nsim_metric_data->ddir)) {
+		err = PTR_ERR(nsim_metric_data->ddir);
+		goto err_dummy_counter_destroy;
+	}
+
+	nsim_metric_data->fail_counter_get = false;
+	debugfs_create_bool("fail_counter_get", 0600, nsim_metric_data->ddir,
+			    &nsim_metric_data->fail_counter_get);
+
+	return 0;
+
+err_dummy_counter_destroy:
+	devlink_metric_destroy(devlink, dummy_counter);
+err_free_metric_data:
+	kfree(nsim_metric_data);
+	return err;
+}
+
+static void nsim_dev_metric_exit(struct nsim_dev *nsim_dev)
+{
+	struct nsim_metric_data *nsim_metric_data = nsim_dev->metric_data;
+	struct devlink *devlink = priv_to_devlink(nsim_dev);
+
+	debugfs_remove_recursive(nsim_metric_data->ddir);
+	devlink_metric_destroy(devlink, nsim_metric_data->dummy_counter);
+	kfree(nsim_metric_data);
+}
+
 static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 				  struct netlink_ext_ack *extack);
 static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev);
@@ -1008,10 +1083,14 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	if (err)
 		goto err_traps_exit;
 
-	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	err = nsim_dev_metric_init(nsim_dev);
 	if (err)
 		goto err_health_exit;
 
+	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	if (err)
+		goto err_metric_exit;
+
 	nsim_dev->take_snapshot = debugfs_create_file("take_snapshot",
 						      0200,
 						      nsim_dev->ddir,
@@ -1019,6 +1098,8 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 						&nsim_dev_take_snapshot_fops);
 	return 0;
 
+err_metric_exit:
+	nsim_dev_metric_exit(nsim_dev);
 err_health_exit:
 	nsim_dev_health_exit(nsim_dev);
 err_traps_exit:
@@ -1089,10 +1170,14 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_debugfs_exit;
 
-	err = nsim_bpf_dev_init(nsim_dev);
+	err = nsim_dev_metric_init(nsim_dev);
 	if (err)
 		goto err_health_exit;
 
+	err = nsim_bpf_dev_init(nsim_dev);
+	if (err)
+		goto err_metric_exit;
+
 	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
 	if (err)
 		goto err_bpf_dev_exit;
@@ -1103,6 +1188,8 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 
 err_bpf_dev_exit:
 	nsim_bpf_dev_exit(nsim_dev);
+err_metric_exit:
+	nsim_dev_metric_exit(nsim_dev);
 err_health_exit:
 	nsim_dev_health_exit(nsim_dev);
 err_debugfs_exit:
@@ -1133,6 +1220,7 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 		return;
 	debugfs_remove(nsim_dev->take_snapshot);
 	nsim_dev_port_del_all(nsim_dev);
+	nsim_dev_metric_exit(nsim_dev);
 	nsim_dev_health_exit(nsim_dev);
 	nsim_dev_traps_exit(devlink);
 	nsim_dev_dummy_region_exit(nsim_dev);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 284f7092241d..5f9a99bc4022 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -171,6 +171,7 @@ struct nsim_dev {
 	struct nsim_bus_dev *nsim_bus_dev;
 	struct nsim_fib_data *fib_data;
 	struct nsim_trap_data *trap_data;
+	struct nsim_metric_data *metric_data;
 	struct dentry *ddir;
 	struct dentry *ports_ddir;
 	struct dentry *take_snapshot;
-- 
2.26.2

