Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B8258170C
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 18:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbiGZQNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 12:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiGZQNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 12:13:16 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EDCB1E7
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 09:13:14 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id b6so9041363wmq.5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 09:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bOOu2COrwyKirYrHfvgRw32egPxfWlvaW68OHlS3zqg=;
        b=7LrxUbMcwRooXgqhOrWbvP280LznP0n94DHcqdwUNgYfqFKflM7OlnTy+BZzvunWuF
         6XUDYFVa24LD5LrhRfIbdkyKf+LSALRU1D5JUEYW9vjw7jRyx8dbrT+ah9/smC56FWw2
         G6ZNHAskslzw2fEE20/+oQIlW97S/iWpnT2jH6zqvhuj4r3XI8ZuKmfCtOYA9KG1/Q44
         d179i5cmVoeHAKhpz4n0gkrnZGRFJUx2eZWJunsi/O77f7ZxzhJMdn/rGsgy393Vl8yt
         qg+54xHozPbdMldjoOSf9RgMLN6iu6OGl/lkuzMN5Ef/2fqZGBu0+Q2K4l3PR17qkwZQ
         CgFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bOOu2COrwyKirYrHfvgRw32egPxfWlvaW68OHlS3zqg=;
        b=CmIRM7OxaQyg2DDWxBZRgeOD6Z0yokW6WFxzvoZwm6OPve97OtKdC4F5+YyEo/5/AE
         cc26brWwpuQMFUs/Vq9hx6tWLco48QICJPDdRT0NSsKuvOI0Q8NLsZfcmogGAcTA6dPz
         Osro63BVVKLii94et9kPUHMNlkqfVw4CZSUqgcV5Hen2LwGiTanNt9KlNasfvdRcxf6y
         S7WDaXfmeY0oq1qpQqQ5ALA6leGC9FJWJruse2wzShbcItWIApQFuuz4LrkHe2up2OHS
         tCgk4pFdNAJeArSz23Z37t1g1gBxoC3N20H8ib+n/j3F6y0ir9DQZjFv+BHVh2D+J/fQ
         LCGA==
X-Gm-Message-State: AJIora+FtbGazmUo84lsbs6imQd87+KEeejGuIKeOiOMESvPXRNEyv9+
        Zrie4HCiNzh9w8nprZQCLLpIaQ==
X-Google-Smtp-Source: AGRyM1vmqKy2F+ezW/IhXbmxf1HGGozX1fUbYDzpCr5QNyO101AigDw3pLc7Q2bXCqb5ROzwN521CQ==
X-Received: by 2002:a05:600c:5114:b0:3a3:3f7f:27ec with SMTP id o20-20020a05600c511400b003a33f7f27ecmr12432903wms.93.1658851993215;
        Tue, 26 Jul 2022 09:13:13 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id bt26-20020a056000081a00b0021e084d9133sm409301wrb.27.2022.07.26.09.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 09:13:12 -0700 (PDT)
Date:   Tue, 26 Jul 2022 18:13:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [patch net-next RFC] net: dsa: move port_setup/teardown to be
 called outside devlink port registered area
Message-ID: <YuASl48SzUq/IOrR@nanopsycho>
References: <20220726124105.495652-1-jiri@resnulli.us>
 <20220726134309.qiloewsgtkojf6yq@skbuf>
 <20220726124105.495652-1-jiri@resnulli.us>
 <20220726134309.qiloewsgtkojf6yq@skbuf>
 <Yt/+GKVZi+WtAftm@nanopsycho>
 <Yt/+GKVZi+WtAftm@nanopsycho>
 <20220726152059.bls6gn7ludfutamy@skbuf>
 <YuAPBwaOjjQBTc6V@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuAPBwaOjjQBTc6V@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 26, 2022 at 05:57:59PM CEST, jiri@resnulli.us wrote:
>Tue, Jul 26, 2022 at 05:20:59PM CEST, olteanv@gmail.com wrote:
>>On Tue, Jul 26, 2022 at 04:45:44PM +0200, Jiri Pirko wrote:

[..]

>
>Darn, wait. I will fixup a squash for you. Sorry.

Here it is:

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 5802e80e8fe1..ddfc03722ab5 100644
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
index 780744b550b8..6885c8928327 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1665,10 +1665,6 @@ int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
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
@@ -1677,7 +1673,6 @@ struct devlink_region *
 devlink_port_region_create(struct devlink_port *port,
 			   const struct devlink_port_region_ops *ops,
 			   u32 region_max_snapshots, u64 region_size);
-void devl_region_destroy(struct devlink_region *region);
 void devlink_region_destroy(struct devlink_region *region);
 void devlink_port_region_destroy(struct devlink_region *region);
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 98d79feeb3dc..71219f66da4e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -310,6 +310,11 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 	return devlink;
 }
 
+#define ASSERT_DEVLINK_PORT_REGISTERED(devlink_port)				\
+	WARN_ON_ONCE(!devlink_port->devlink)
+#define ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port)			\
+	WARN_ON_ONCE(devlink_port->devlink)
+
 static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
 						      unsigned int port_index)
 {
@@ -5646,8 +5651,7 @@ static void devlink_nl_region_notify(struct devlink_region *region,
 	struct sk_buff *msg;
 
 	WARN_ON(cmd != DEVLINK_CMD_REGION_NEW && cmd != DEVLINK_CMD_REGION_DEL);
-	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
-		return;
+	ASSERT_DEVLINK_REGISTERED(devlink);
 
 	msg = devlink_nl_region_notify_build(region, snapshot, cmd, 0, 0);
 	if (IS_ERR(msg))
@@ -9704,7 +9708,8 @@ int devl_port_register(struct devlink *devlink,
 	if (devlink_port_index_exists(devlink, port_index))
 		return -EEXIST;
 
-	WARN_ON(devlink_port->devlink);
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	devlink_port->devlink = devlink;
 	devlink_port->index = port_index;
 	spin_lock_init(&devlink_port->type_lock);
@@ -9788,8 +9793,8 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
 				    enum devlink_port_type type,
 				    void *type_dev)
 {
-	if (WARN_ON(!devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_REGISTERED(devlink_port);
+
 	devlink_port_type_warn_cancel(devlink_port);
 	spin_lock_bh(&devlink_port->type_lock);
 	devlink_port->type = type;
@@ -9908,8 +9913,8 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
 {
 	int ret;
 
-	if (WARN_ON(devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	devlink_port->attrs = *attrs;
 	ret = __devlink_port_attrs_set(devlink_port, attrs->flavour);
 	if (ret)
@@ -9932,8 +9937,8 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u32 contro
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
-	if (WARN_ON(devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	ret = __devlink_port_attrs_set(devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_PF);
 	if (ret)
@@ -9959,8 +9964,8 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
-	if (WARN_ON(devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	ret = __devlink_port_attrs_set(devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_VF);
 	if (ret)
@@ -9987,8 +9992,8 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
-	if (WARN_ON(devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	ret = __devlink_port_attrs_set(devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_SF);
 	if (ret)
@@ -10103,8 +10108,8 @@ EXPORT_SYMBOL_GPL(devl_rate_nodes_destroy);
 void devlink_port_linecard_set(struct devlink_port *devlink_port,
 			       struct devlink_linecard *linecard)
 {
-	if (WARN_ON(devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	devlink_port->linecard = linecard;
 }
 EXPORT_SYMBOL_GPL(devlink_port_linecard_set);
@@ -11073,21 +11078,22 @@ void devlink_param_value_changed(struct devlink *devlink, u32 param_id)
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
@@ -11105,35 +11111,9 @@ struct devlink_region *devl_region_create(struct devlink *devlink,
 	region->size = region_size;
 	INIT_LIST_HEAD(&region->snapshot_list);
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
@@ -11143,8 +11123,6 @@ EXPORT_SYMBOL_GPL(devlink_region_create);
  *	@ops: region operations and name
  *	@region_max_snapshots: Maximum supported number of snapshots for region
  *	@region_size: size of region
- *
- *	Context: Takes and release devlink->lock <mutex>.
  */
 struct devlink_region *
 devlink_port_region_create(struct devlink_port *port,
@@ -11155,11 +11133,11 @@ devlink_port_region_create(struct devlink_port *port,
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
@@ -11178,9 +11156,7 @@ devlink_port_region_create(struct devlink_port *port,
 	region->size = region_size;
 	INIT_LIST_HEAD(&region->snapshot_list);
 	list_add_tail(&region->list, &port->region_list);
-	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
-	devl_unlock(devlink);
 	return region;
 
 unlock:
@@ -11190,16 +11166,18 @@ devlink_port_region_create(struct devlink_port *port,
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
@@ -11207,26 +11185,8 @@ void devl_region_destroy(struct devlink_region *region)
 
 	list_del(&region->list);
 
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
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cac48a741f27..a8b6c6434df2 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -451,19 +451,12 @@ static int dsa_port_setup(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
 	bool dsa_port_link_registered = false;
-	struct dsa_switch *ds = dp->ds;
 	bool dsa_port_enabled = false;
 	int err = 0;
 
 	if (dp->setup)
 		return 0;
 
-	if (ds->ops->port_setup) {
-		err = ds->ops->port_setup(ds, dp->index);
-		if (err)
-			return err;
-	}
-
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
 		dsa_port_disable(dp);
@@ -506,11 +499,6 @@ static int dsa_port_setup(struct dsa_port *dp)
 		dsa_port_disable(dp);
 	if (err && dsa_port_link_registered)
 		dsa_port_link_unregister_of(dp);
-	if (err) {
-		if (ds->ops->port_teardown)
-			ds->ops->port_teardown(ds, dp->index);
-		return err;
-	}
 
 	dp->setup = true;
 
@@ -523,10 +511,17 @@ static int dsa_port_devlink_setup(struct dsa_port *dp)
 	struct dsa_switch_tree *dst = dp->ds->dst;
 	struct devlink_port_attrs attrs = {};
 	struct devlink *dl = dp->ds->devlink;
+	struct dsa_switch *ds = dp->ds;
 	const unsigned char *id;
 	unsigned char len;
 	int err;
 
+	if (ds->ops->port_setup) {
+		err = ds->ops->port_setup(ds, dp->index);
+		if (err)
+			return err;
+	}
+
 	id = (const unsigned char *)&dst->index;
 	len = sizeof(dst->index);
 
@@ -552,24 +547,23 @@ static int dsa_port_devlink_setup(struct dsa_port *dp)
 
 	devlink_port_attrs_set(dlp, &attrs);
 	err = devlink_port_register(dl, dlp, dp->index);
+	if (err) {
+		if (ds->ops->port_teardown)
+			ds->ops->port_teardown(ds, dp->index);
+		return err;
+	}
+	dp->devlink_port_setup = true;
 
-	if (!err)
-		dp->devlink_port_setup = true;
-
-	return err;
+	return 0;
 }
 
 static void dsa_port_teardown(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
-	struct dsa_switch *ds = dp->ds;
 
 	if (!dp->setup)
 		return;
 
-	if (ds->ops->port_teardown)
-		ds->ops->port_teardown(ds, dp->index);
-
 	devlink_port_type_clear(dlp);
 
 	switch (dp->type) {
@@ -597,40 +591,24 @@ static void dsa_port_teardown(struct dsa_port *dp)
 static void dsa_port_devlink_teardown(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
+	struct dsa_switch *ds = dp->ds;
 
-	if (dp->devlink_port_setup)
+	if (dp->devlink_port_setup) {
 		devlink_port_unregister(dlp);
+		if (ds->ops->port_teardown)
+			ds->ops->port_teardown(ds, dp->index);
+	}
 	dp->devlink_port_setup = false;
 }
 
 /* Destroy the current devlink port, and create a new one which has the UNUSED
- * flavour. At this point, any call to ds->ops->port_setup has been already
- * balanced out by a call to ds->ops->port_teardown, so we know that any
- * devlink port regions the driver had are now unregistered. We then call its
- * ds->ops->port_setup again, in order for the driver to re-create them on the
- * new devlink port.
+ * flavour.
  */
 static int dsa_port_reinit_as_unused(struct dsa_port *dp)
 {
-	struct dsa_switch *ds = dp->ds;
-	int err;
-
 	dsa_port_devlink_teardown(dp);
 	dp->type = DSA_PORT_TYPE_UNUSED;
-	err = dsa_port_devlink_setup(dp);
-	if (err)
-		return err;
-
-	if (ds->ops->port_setup) {
-		/* On error, leave the devlink port registered,
-		 * dsa_switch_teardown will clean it up later.
-		 */
-		err = ds->ops->port_setup(ds, dp->index);
-		if (err)
-			return err;
-	}
-
-	return 0;
+	return dsa_port_devlink_setup(dp);
 }
 
 static int dsa_devlink_info_get(struct devlink *dl,
