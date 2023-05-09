Return-Path: <netdev+bounces-1108-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BA136FC37F
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0FAB2812C1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9CC98C08;
	Tue,  9 May 2023 10:09:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5919DDDD
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:09:49 +0000 (UTC)
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314D31BC6
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 03:09:48 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-50bc2feb320so8977256a12.3
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 03:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683626986; x=1686218986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cT/FKrwRQy+Rs588uBU2UJ99lzJn6qsm6vS3DQ6eeBM=;
        b=yQLn8koZi6Ge3a77Tyc487zRth77koenYpTsiwJtpp9GQAHgF51eUuPAwJcvnwVO8t
         8Yb7bbUG5a61BzGf6oNWFmeQMP0HOvRiHbUzXNfXxUERidl6fM7L4/GaTi1UsTrjhLni
         aGCeQR1bYJvG3rs6dtN9j4ijyZunywH+ORiB5EzamK641HDfjnvm1WNoZGO2kRjLT9xp
         ZgTEuRncejVE6Ls88VB1YZSlwZiz0BaIDvm7f4AnOkHNqrByCerjjUOVMKBIw9rae7yb
         3BFkLlG0Bt25XXi9MfsiYtCg/Q33TtFPBuLXrB7CukyFKpH0NqMywfUShXAoqKemjgZf
         9sGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683626986; x=1686218986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cT/FKrwRQy+Rs588uBU2UJ99lzJn6qsm6vS3DQ6eeBM=;
        b=ZQ9cCfi8O8ZjL9svo9MVkUYo47uzW618vOPLW2Tegxhiv8VRbTs4vgcrPMP0rrf/KB
         1CzxJM5mq0gsOFMlSUm1jjZguYdRgz20KK1axfurMtUJSFZ97YmiHSdb3BhY7GIosVLG
         Z3GFLMDI8DfMI3ZSNHP/c8ULOnQhfKjom+8bKCBQBe12WPhcbF3nW0v0jB2vGW6CUVPZ
         a1/lVnT9TrJM8Hex7xW1oI7kh7eyluRpb+X6+1LjMjJf0HxWKWCmN+i/awy/Cy+Js5uT
         V7CBx0FWb1D04t3WDWDpIrvKHrltMl2heF0O6KB5BMNozZdfa4gHpY3UpQOFr4to4/0t
         d8zA==
X-Gm-Message-State: AC+VfDwmaSL4hkBRTYDdVN5y5IDF91fluw1jLdEnBicjwE5gjlJCEAJx
	hyBJttZL+ejwmH2hhVLtzq5h1ve3r00MiISUETSL6A==
X-Google-Smtp-Source: ACHHUZ7NUoqFY2jq5aIcjJt1kw1C7cejKrooqxTtiZ8QjghdMl1rmNukp5Laruu5wMgq5cwJU0gBeA==
X-Received: by 2002:a05:6402:12d5:b0:50c:9582:e968 with SMTP id k21-20020a05640212d500b0050c9582e968mr9849789edx.36.1683626986540;
        Tue, 09 May 2023 03:09:46 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w5-20020a056402128500b0050c03520f68sm581007edv.71.2023.05.09.03.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:09:46 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	jacob.e.keller@intel.com,
	saeedm@nvidia.com,
	moshe@nvidia.com
Subject: [patch net 3/3] devlink: change port event netdev notifier to be per-net and following netdev
Date: Tue,  9 May 2023 12:09:39 +0200
Message-Id: <20230509100939.760867-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230509100939.760867-1-jiri@resnulli.us>
References: <20230509100939.760867-1-jiri@resnulli.us>
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
from per-net to global") changed original per-net notifier to be global
which fixed the issue of non-receiving events of netdev uninit if that
moved to a different namespace. That worked fine in -net tree.

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

Resolve this by converting the notifier to per per-net again.
But this time also per-devlink_port and setting to follow the netdev
to different namespace when spotted, ensured by
netdev_net_notifier_follow().

Note what a tree needs this fix only in case all of the cited fixes
commits are present.

Reported-by: Moshe Shemesh <moshe@nvidia.com>
Fixes: 565b4824c39f ("devlink: change port event netdev notifier from per-net to global")
Fixes: ee75f1fc44dd ("net/mlx5e: Create separate devlink instance for ethernet auxiliary device")
Fixes: 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in case of PCI device suspend")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h  |  1 +
 net/devlink/leftover.c | 24 +++++++++++++++---------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index d0a0d1ce7db4..f252da446264 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -150,6 +150,7 @@ struct devlink_port {
 	struct devlink_rate *devlink_rate;
 	struct devlink_linecard *linecard;
 	struct notifier_block netdevice_nb;
+	struct netdev_net_notifier netdevice_nn;
 };
 
 struct devlink_port_new_attrs {
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 4b1627cb2b83..9e11db6528ce 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -6874,7 +6874,8 @@ int devl_port_register(struct devlink *devlink,
 	INIT_LIST_HEAD(&devlink_port->reporter_list);
 
 	devlink_port->netdevice_nb.notifier_call = devlink_port_netdevice_event;
-	err = register_netdevice_notifier(&devlink_port->netdevice_nb);
+	err = register_netdevice_notifier_net(devlink_net(devlink),
+					      &devlink_port->netdevice_nb);
 	if (err)
 		return err;
 
@@ -6888,7 +6889,8 @@ int devl_port_register(struct devlink *devlink,
 	return 0;
 
 err_xa_insert:
-	unregister_netdevice_notifier(&devlink_port->netdevice_nb);
+	unregister_netdevice_notifier_net(devlink_net(devlink),
+					  &devlink_port->netdevice_nb);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devl_port_register);
@@ -6928,13 +6930,16 @@ EXPORT_SYMBOL_GPL(devlink_port_register);
  */
 void devl_port_unregister(struct devlink_port *devlink_port)
 {
-	lockdep_assert_held(&devlink_port->devlink->lock);
+	struct devlink *devlink = devlink_port->devlink;
+
+	lockdep_assert_held(&devlink->lock);
 	WARN_ON(devlink_port->type != DEVLINK_PORT_TYPE_NOTSET);
 
 	devlink_port_type_warn_cancel(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
-	xa_erase(&devlink_port->devlink->ports, devlink_port->index);
-	WARN_ON_ONCE(unregister_netdevice_notifier(&devlink_port->netdevice_nb));
+	xa_erase(&devlink->ports, devlink_port->index);
+	WARN_ON_ONCE(unregister_netdevice_notifier_net(devlink_net(devlink),
+						       &devlink_port->netdevice_nb));
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
 	devlink_port->registered = false;
 }
@@ -7099,11 +7104,11 @@ static int devlink_port_netdevice_event(struct notifier_block *nb,
 		 */
 		__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH,
 					NULL);
+		netdev_net_notifier_follow(netdev, nb,
+					   &devlink_port->netdevice_nn);
 		break;
 	case NETDEV_REGISTER:
 	case NETDEV_CHANGENAME:
-		if (devlink_net(devlink_port->devlink) != dev_net(netdev))
-			return NOTIFY_OK;
 		/* Set the netdev on top of previously set type. Note this
 		 * event happens also during net namespace change so here
 		 * we take into account netdev pointer appearing in this
@@ -7113,8 +7118,6 @@ static int devlink_port_netdevice_event(struct notifier_block *nb,
 					netdev);
 		break;
 	case NETDEV_UNREGISTER:
-		if (devlink_net(devlink_port->devlink) != dev_net(netdev))
-			return NOTIFY_OK;
 		/* Clear netdev pointer, but not the type. This event happens
 		 * also during net namespace change so we need to clear
 		 * pointer to netdev that is going to another net namespace.
@@ -7128,6 +7131,9 @@ static int devlink_port_netdevice_event(struct notifier_block *nb,
 		 */
 		__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_NOTSET,
 					NULL);
+		netdev_net_notifier_unfollow(netdev,
+					     &devlink_port->netdevice_nn,
+					     devlink_net(devlink_port->devlink));
 		break;
 	}
 
-- 
2.39.2


