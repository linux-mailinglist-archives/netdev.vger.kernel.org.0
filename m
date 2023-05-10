Return-Path: <netdev+bounces-1506-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F2F6FE0B7
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:46:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EE721C20D76
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:46:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 328AD14AB7;
	Wed, 10 May 2023 14:46:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF836FBB
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:46:30 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F9559D7
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:46:25 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f41d087b3bso47033445e9.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683729984; x=1686321984;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HidoVOZI5viFHk8yG/jlIRmOesHn+Q2OlcX3/CG4RZM=;
        b=YI/XDRan/FARkRd6GLLpdd+XFLuKjDKDCx2qK5Bm7zmobspnkXYvzoovdBQBDJknZy
         M/uXrxtpKwRJpYUu8nS+Stm6CJz5f3e1K02498LkLpEeRaP99SxoeyE1oJUR1mpYCKHg
         GPDW3K4Z4DgYX0tjUAz4evJAuSvTTbd7kuOnM1PPqBqTc4Xeo77gqLa/9WSue3eua9Gu
         ENqULdJteyegdlNvwgoqLXK3S59E1mMELo/Xt5fng3mJm7hzUC0lf6ebzdHVGKuk0wQk
         YtLc+WIJcX0xsQcMMAOlUGcvQIniX6KTExg4mqOWuVAPFZ+8T+77cVhidYK3/3HqTZHh
         FdrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683729984; x=1686321984;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HidoVOZI5viFHk8yG/jlIRmOesHn+Q2OlcX3/CG4RZM=;
        b=OoKEDPTxf5V/AGgbxOgi7RVDxIIQynR+LU81UUa0jmwSeCE1hjmJ6zT3ViOm1sau54
         uRIOPU/H2m9RAelKcMD7tMzgp2b0G8XdiSVMU43yvUoVPFJ0E4RnBPRmg/PP95vXP108
         E51d7B5+Zxrmh+4Hooidr2utGuQ8A9SoYk9a8obiSl+H4992vIuLxtMp271/Q2SO0WlR
         6wMwuWq+C4duegCfRPckxpw3nZuJu1bD+016v2Rqj5JbHWY1khj2y+FkDiY1aBp9k4Mf
         Me321yDOkzV6KZ5z4owKbrKrIbmWfUQqybiMU3i5lqRKDvwhG27tRNa05czvB+DcPX/K
         OXFw==
X-Gm-Message-State: AC+VfDyeQV3FFzcCNudPXc6Coup7VW/8Sb0IZkltqQidMofrdY5y01Jj
	s6T8q4AdEhDOd8wQ4zfCYJAZ7iXMJKuQ+M7Geks=
X-Google-Smtp-Source: ACHHUZ77w6BCjFPuZjU8WaJq12IgmD1piZhO6cc73WwhRBT4HXXZxqt2Mo4RkV/k6tHS+r4eC1KuzA==
X-Received: by 2002:a7b:c391:0:b0:3f4:29dc:6ebf with SMTP id s17-20020a7bc391000000b003f429dc6ebfmr4830334wmj.38.1683729983756;
        Wed, 10 May 2023 07:46:23 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f5-20020a1c6a05000000b003f4266965fbsm8659388wmc.5.2023.05.10.07.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 07:46:22 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	jacob.e.keller@intel.com,
	saeedm@nvidia.com,
	moshe@nvidia.com
Subject: [patch net] devlink: change per-devlink netdev notifier to static one
Date: Wed, 10 May 2023 16:46:21 +0200
Message-Id: <20230510144621.932017-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jiri Pirko <jiri@nvidia.com>

The commit 565b4824c39f ("devlink: change port event netdev notifier
from per-net to global") changed original per-net notifier to be
per-devlink instance. That fixed the issue of non-receiving events
of netdev uninit if that moved to a different namespace.
That worked fine in -net tree.

However, later on when commit ee75f1fc44dd ("net/mlx5e: Create
separate devlink instance for ethernet auxiliary device") and
commit 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in
case of PCI device suspend") were merged, a deadlock was introduced
when removing a namespace with devlink instance with another nested
instance.

Here there is the bad flow example resulting in deadlock with mlx5:
net_cleanup_work -> cleanup_net (takes down_read(&pernet_ops_rwsem) ->
devlink_pernet_pre_exit() -> devlink_reload() ->
mlx5_devlink_reload_down() -> mlx5_unload_one_devl_locked() ->
mlx5_detach_device() -> del_adev() -> mlx5e_remove() ->
mlx5e_destroy_devlink() -> devlink_free() ->
unregister_netdevice_notifier() (takes down_write(&pernet_ops_rwsem)

Steps to reproduce:
$ modprobe mlx5_core
$ ip netns add ns1
$ devlink dev reload pci/0000:08:00.0 netns ns1
$ ip netns del ns1

Resolve this by converting the notifier from per-devlink instance to
a static one registered during init phase and leaving it registered
forever. Use this notifier for all devlink port instances created
later on.

Note what a tree needs this fix only in case all of the cited fixes
commits are present.

Reported-by: Moshe Shemesh <moshe@nvidia.com>
Fixes: 565b4824c39f ("devlink: change port event netdev notifier from per-net to global")
Fixes: ee75f1fc44dd ("net/mlx5e: Create separate devlink instance for ethernet auxiliary device")
Fixes: 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in case of PCI device suspend")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/core.c          | 16 +++++++---------
 net/devlink/devl_internal.h |  1 -
 net/devlink/leftover.c      |  5 ++---
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index 777b091ef74d..0e58eee44bdb 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -204,11 +204,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	if (ret < 0)
 		goto err_xa_alloc;
 
-	devlink->netdevice_nb.notifier_call = devlink_port_netdevice_event;
-	ret = register_netdevice_notifier(&devlink->netdevice_nb);
-	if (ret)
-		goto err_register_netdevice_notifier;
-
 	devlink->dev = dev;
 	devlink->ops = ops;
 	xa_init_flags(&devlink->ports, XA_FLAGS_ALLOC);
@@ -233,8 +228,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 
 	return devlink;
 
-err_register_netdevice_notifier:
-	xa_erase(&devlinks, devlink->index);
 err_xa_alloc:
 	kfree(devlink);
 	return NULL;
@@ -266,8 +259,6 @@ void devlink_free(struct devlink *devlink)
 	xa_destroy(&devlink->params);
 	xa_destroy(&devlink->ports);
 
-	WARN_ON_ONCE(unregister_netdevice_notifier(&devlink->netdevice_nb));
-
 	xa_erase(&devlinks, devlink->index);
 
 	devlink_put(devlink);
@@ -303,6 +294,10 @@ static struct pernet_operations devlink_pernet_ops __net_initdata = {
 	.pre_exit = devlink_pernet_pre_exit,
 };
 
+static struct notifier_block devlink_port_netdevice_nb __net_initdata = {
+	.notifier_call = devlink_port_netdevice_event,
+};
+
 static int __init devlink_init(void)
 {
 	int err;
@@ -311,6 +306,9 @@ static int __init devlink_init(void)
 	if (err)
 		goto out;
 	err = register_pernet_subsys(&devlink_pernet_ops);
+	if (err)
+		goto out;
+	err = register_netdevice_notifier(&devlink_port_netdevice_nb);
 
 out:
 	WARN_ON(err);
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index e133f423294a..62921b2eb0d3 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -50,7 +50,6 @@ struct devlink {
 	u8 reload_failed:1;
 	refcount_t refcount;
 	struct rcu_work rwork;
-	struct notifier_block netdevice_nb;
 	char priv[] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index dffca2f9bfa7..cd0254968076 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7073,10 +7073,9 @@ int devlink_port_netdevice_event(struct notifier_block *nb,
 	struct devlink_port *devlink_port = netdev->devlink_port;
 	struct devlink *devlink;
 
-	devlink = container_of(nb, struct devlink, netdevice_nb);
-
-	if (!devlink_port || devlink_port->devlink != devlink)
+	if (!devlink_port)
 		return NOTIFY_OK;
+	devlink = devlink_port->devlink;
 
 	switch (event) {
 	case NETDEV_POST_INIT:
-- 
2.39.2


