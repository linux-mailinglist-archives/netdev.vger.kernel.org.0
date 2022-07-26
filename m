Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8345815A3
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 16:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239345AbiGZOqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 10:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiGZOq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 10:46:29 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D24B19037
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 07:46:21 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id x23-20020a05600c179700b003a30e3e7989so8323994wmo.0
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 07:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GgRFdXtV/6N0rgKqQftuiRSl5dwcrK5EGgkk62OocgE=;
        b=xJNHfkKZZKLeQh6WWv18vK1D9dO6PWKiq3/xIdtiT7fEGsJql0OYJvXNV4RmMqaGiM
         wnOlc3Kx5EuH0Otfmvp7lHLuf+4rNgyI+xhCPttbILSJr/IKYSXl8iPn1M30Dm4HydVd
         vase6qpos0MzJvcZEphu9atbuGMXCcpNJaz56fgdcqxjCdehsEjfhYeVxKH8YWKDoMCM
         TyM21ZNc2CYy69cKLcGS2riMIc0SCZrGaK7EX1WfEkZdNmYCg51lplsIWjhZUwahFtjZ
         ZmJOdg8Y8xxiJOYEjB6c8L70Pw3OrPG2h2gbhXjSFkP6wvInxjY1vUTSa7ibT9cWfqvk
         jWTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GgRFdXtV/6N0rgKqQftuiRSl5dwcrK5EGgkk62OocgE=;
        b=TIayhKK7/Q3Co5jUTi75hNlvRpV41zbeHVF3uH5w8xQ6A78aNi+Ujx6cQns0atUcjG
         IowgfuF7bHg/4h590DnSSvdjkZ5BT4HgqsrWqrihlWcZcSCFIgUUNexHcCFkjANUTNBz
         brW70UM1Y4K1zS8vegp/TMvqbx0WgmdjPzYRjtICFZlseVmKYZxmz1kGbLcJwb0fhz2E
         T710cf4AlyAWq1Ie7Q4y9kM4D1LuI+Rzw5EUn5eA0G5aTzj5zAxuiLwQUHyM5TuvcQkE
         bDPcFNguSgpqDM+klYGoY72Jy5lSJRJPKUXb5/5aREmgdK7kPQysCdqzdOmFjtCh9Gf4
         ylLA==
X-Gm-Message-State: AJIora9aCOPKwVARqWYN62dlU21qSpKx7dqGxnNFmLmIuy7x6YkrA/Pq
        8Yk2x7pnKlrVDDcMh3bZupYVj9ryUYtLgdS6Fps=
X-Google-Smtp-Source: AGRyM1vDsGhcqIudn1hkJIvjGvNcSuYiGeV1dA9zeDsFt0qkBdbnUYkaw5WwGIXVZSHy4wvGJDV1IA==
X-Received: by 2002:a05:600c:1c26:b0:3a3:2251:c3cb with SMTP id j38-20020a05600c1c2600b003a32251c3cbmr25148816wms.126.1658846779771;
        Tue, 26 Jul 2022 07:46:19 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id bq23-20020a5d5a17000000b0021e57963c4asm8530359wrb.77.2022.07.26.07.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 07:46:07 -0700 (PDT)
Date:   Tue, 26 Jul 2022 16:45:44 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [patch net-next RFC] net: dsa: move port_setup/teardown to be
 called outside devlink port registered area
Message-ID: <Yt/+GKVZi+WtAftm@nanopsycho>
References: <20220726124105.495652-1-jiri@resnulli.us>
 <20220726134309.qiloewsgtkojf6yq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726134309.qiloewsgtkojf6yq@skbuf>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 26, 2022 at 03:43:09PM CEST, olteanv@gmail.com wrote:
>Hi Jiri,
>
>On Tue, Jul 26, 2022 at 02:41:05PM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Move port_setup() op to be called before devlink_port_register() and
>> port_teardown() after devlink_port_unregister().
>> 
>> RFC note: I don't see why this would not work, but I have no way to
>> test this does not break things. But I think it makes sense to move this
>> alongside the rest of the devlink port code, the reinit() function
>> also gets much nicer, as clearly the fact that
>> port_setup()->devlink_port_region_create() was called in dsa_port_setup
>> did not fit the flow.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>
>devlink_port->devlink isn't set (it's set in devl_port_register), so
>when devlink_port_region_create() calls devl_lock(devlink), it blasts
>right through that NULL pointer:
>
>[    4.966960] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000320
>[    5.009201] [0000000000000320] user address but active_mm is swapper
>[    5.015616] Internal error: Oops: 96000004 [#1] PREEMPT SMP
>[    5.024244] CPU: 1 PID: 8 Comm: kworker/u4:0 Not tainted 5.19.0-rc7-07010-ga9b9500ffaac-dirty #3395
>[    5.033281] Hardware name: CZ.NIC Turris Mox Board (DT)
>[    5.038499] Workqueue: events_unbound deferred_probe_work_func
>[    5.044342] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>[    5.051297] pc : __mutex_lock+0x5c/0x460
>[    5.055220] lr : __mutex_lock+0x50/0x460
>[    5.133818] Call trace:
>[    5.136258]  __mutex_lock+0x5c/0x460
>[    5.139831]  mutex_lock_nested+0x40/0x50
>[    5.143750]  devlink_port_region_create+0x54/0x15c
>[    5.148542]  dsa_devlink_port_region_create+0x64/0x90
>[    5.153592]  mv88e6xxx_setup_devlink_regions_port+0x30/0x60
>[    5.159165]  mv88e6xxx_port_setup+0x10/0x20
>[    5.163345]  dsa_port_devlink_setup+0x60/0x150
>[    5.167786]  dsa_register_switch+0x938/0x119c
>[    5.172138]  mv88e6xxx_probe+0x714/0x770
>[    5.176058]  mdio_probe+0x34/0x70
>[    5.179370]  really_probe.part.0+0x9c/0x2ac
>[    5.183550]  __driver_probe_device+0x98/0x144
>[    5.187902]  driver_probe_device+0xac/0x14c

Oh yes, could you please try together with following patch? (nevermind
chicken-egg problem you may spot now)

Subject: [patch net-next RFC] net: devlink: convert region creation/destroy()
 to be forbidden on registered devlink/port

No need to create or destroy region when devlink or devlink ports are
registered. Limit the possibility to call the region create/destroy()
only for non-registered devlink or devlink port. Benefit from that and
avoid need to take devl_lock.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/dev.c |  8 ++--
 include/net/devlink.h       |  5 ---
 net/core/devlink.c          | 78 ++++++++-----------------------------
 3 files changed, 20 insertions(+), 71 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 925dc8a5254d..3f0c19e30650 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -557,15 +557,15 @@ static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
 				      struct devlink *devlink)
 {
 	nsim_dev->dummy_region =
-		devl_region_create(devlink, &dummy_region_ops,
-				   NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
-				   NSIM_DEV_DUMMY_REGION_SIZE);
+		devlink_region_create(devlink, &dummy_region_ops,
+				      NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
+				      NSIM_DEV_DUMMY_REGION_SIZE);
 	return PTR_ERR_OR_ZERO(nsim_dev->dummy_region);
 }
 
 static void nsim_dev_dummy_region_exit(struct nsim_dev *nsim_dev)
 {
-	devl_region_destroy(nsim_dev->dummy_region);
+	devlink_region_destroy(nsim_dev->dummy_region);
 }
 
 static int
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 9edb4a28cf30..2416750e050d 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1666,10 +1666,6 @@ int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 				       union devlink_param_value init_val);
 void devlink_param_value_changed(struct devlink *devlink, u32 param_id);
-struct devlink_region *devl_region_create(struct devlink *devlink,
-					  const struct devlink_region_ops *ops,
-					  u32 region_max_snapshots,
-					  u64 region_size);
 struct devlink_region *
 devlink_region_create(struct devlink *devlink,
 		      const struct devlink_region_ops *ops,
@@ -1678,7 +1674,6 @@ struct devlink_region *
 devlink_port_region_create(struct devlink_port *port,
 			   const struct devlink_port_region_ops *ops,
 			   u32 region_max_snapshots, u64 region_size);
-void devl_region_destroy(struct devlink_region *region);
 void devlink_region_destroy(struct devlink_region *region);
 void devlink_port_region_destroy(struct devlink_region *region);
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4e0c4f9265e8..15d28aba69fc 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5701,8 +5701,7 @@ static void devlink_nl_region_notify(struct devlink_region *region,
 	struct sk_buff *msg;
 
 	WARN_ON(cmd != DEVLINK_CMD_REGION_NEW && cmd != DEVLINK_CMD_REGION_DEL);
-	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
-		return;
+	ASSERT_DEVLINK_REGISTERED(devlink);
 
 	msg = devlink_nl_region_notify_build(region, snapshot, cmd, 0, 0);
 	if (IS_ERR(msg))
@@ -11131,21 +11130,22 @@ void devlink_param_value_changed(struct devlink *devlink, u32 param_id)
 EXPORT_SYMBOL_GPL(devlink_param_value_changed);
 
 /**
- * devl_region_create - create a new address region
+ * devlink_region_create - create a new address region
  *
  * @devlink: devlink
  * @ops: region operations and name
  * @region_max_snapshots: Maximum supported number of snapshots for region
  * @region_size: size of region
  */
-struct devlink_region *devl_region_create(struct devlink *devlink,
-					  const struct devlink_region_ops *ops,
-					  u32 region_max_snapshots,
-					  u64 region_size)
+struct devlink_region *
+devlink_region_create(struct devlink *devlink,
+		      const struct devlink_region_ops *ops,
+		      u32 region_max_snapshots,
+		      u64 region_size)
 {
 	struct devlink_region *region;
 
-	devl_assert_locked(devlink);
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
@@ -11164,35 +11164,9 @@ struct devlink_region *devl_region_create(struct devlink *devlink,
 	INIT_LIST_HEAD(&region->snapshot_list);
 	mutex_init(&region->snapshot_lock);
 	list_add_tail(&region->list, &devlink->region_list);
-	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
 	return region;
 }
-EXPORT_SYMBOL_GPL(devl_region_create);
-
-/**
- *	devlink_region_create - create a new address region
- *
- *	@devlink: devlink
- *	@ops: region operations and name
- *	@region_max_snapshots: Maximum supported number of snapshots for region
- *	@region_size: size of region
- *
- *	Context: Takes and release devlink->lock <mutex>.
- */
-struct devlink_region *
-devlink_region_create(struct devlink *devlink,
-		      const struct devlink_region_ops *ops,
-		      u32 region_max_snapshots, u64 region_size)
-{
-	struct devlink_region *region;
-
-	devl_lock(devlink);
-	region = devl_region_create(devlink, ops, region_max_snapshots,
-				    region_size);
-	devl_unlock(devlink);
-	return region;
-}
 EXPORT_SYMBOL_GPL(devlink_region_create);
 
 /**
@@ -11202,8 +11176,6 @@ EXPORT_SYMBOL_GPL(devlink_region_create);
  *	@ops: region operations and name
  *	@region_max_snapshots: Maximum supported number of snapshots for region
  *	@region_size: size of region
- *
- *	Context: Takes and release devlink->lock <mutex>.
  */
 struct devlink_region *
 devlink_port_region_create(struct devlink_port *port,
@@ -11214,11 +11186,11 @@ devlink_port_region_create(struct devlink_port *port,
 	struct devlink_region *region;
 	int err = 0;
 
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(port);
+
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-	devl_lock(devlink);
-
 	if (devlink_port_region_get_by_name(port, ops->name)) {
 		err = -EEXIST;
 		goto unlock;
@@ -11238,9 +11210,7 @@ devlink_port_region_create(struct devlink_port *port,
 	INIT_LIST_HEAD(&region->snapshot_list);
 	mutex_init(&region->snapshot_lock);
 	list_add_tail(&region->list, &port->region_list);
-	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
-	devl_unlock(devlink);
 	return region;
 
 unlock:
@@ -11250,16 +11220,18 @@ devlink_port_region_create(struct devlink_port *port,
 EXPORT_SYMBOL_GPL(devlink_port_region_create);
 
 /**
- * devl_region_destroy - destroy address region
+ * devlink_region_destroy - destroy address region
  *
  * @region: devlink region to destroy
  */
-void devl_region_destroy(struct devlink_region *region)
+void devlink_region_destroy(struct devlink_region *region)
 {
-	struct devlink *devlink = region->devlink;
 	struct devlink_snapshot *snapshot, *ts;
 
-	devl_assert_locked(devlink);
+	if (region->port)
+		ASSERT_DEVLINK_PORT_NOT_REGISTERED(region->port);
+	else
+		ASSERT_DEVLINK_NOT_REGISTERED(region->devlink);
 
 	/* Free all snapshots of region */
 	list_for_each_entry_safe(snapshot, ts, &region->snapshot_list, list)
@@ -11268,26 +11240,8 @@ void devl_region_destroy(struct devlink_region *region)
 	list_del(&region->list);
 	mutex_destroy(&region->snapshot_lock);
 
-	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_DEL);
 	kfree(region);
 }
-EXPORT_SYMBOL_GPL(devl_region_destroy);
-
-/**
- *	devlink_region_destroy - destroy address region
- *
- *	@region: devlink region to destroy
- *
- *	Context: Takes and release devlink->lock <mutex>.
- */
-void devlink_region_destroy(struct devlink_region *region)
-{
-	struct devlink *devlink = region->devlink;
-
-	devl_lock(devlink);
-	devl_region_destroy(region);
-	devl_unlock(devlink);
-}
 EXPORT_SYMBOL_GPL(devlink_region_destroy);
 
 /**
-- 
2.35.3


