Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE1F5EBC9C
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbiI0IB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbiI0IAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:00:25 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB451B14D7
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:56:52 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id s14so13773855wro.0
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=uVlYMwxUZmUiLO0mqm9NPaCo3OwuW8oSwVqJKpysQNY=;
        b=JptOo60gFjdWNgzFwg4yu11/jJDIAbNzeNXCRuGb38PvIgsMXYFLibudDHPd6bHkcQ
         Gnuqc1dLfzID3otKdvFNh7+k7NWqGqQYUYuLu1HnmYO96Ngxbi+6z3b+McvX0b6/CsKe
         GJTzl257a2YgwVkAltzhXqEFnTrrfiiY0rbkymSg6ZFgRqS6BC48kwnv+NgUPKekdzxr
         G00W7kTNDxCgOQsndSVqZk/c833gMSQ/GLTZrsuKgiA6GjWGd33nTXQSXEncdBpzLAl5
         A34AS9y5tBB7CFS6Zj8AjQoIjTSA+awdtBjR6XWscqC+KeIcTXYyhy7MgFZyzF4BV2F+
         dPuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=uVlYMwxUZmUiLO0mqm9NPaCo3OwuW8oSwVqJKpysQNY=;
        b=56Pir9OrDfsK8ZTTTfozQGv7bQ+vO1piHfjv3OesNlbt8q5dmJuYkSWJdYjFWHYTcU
         IbsoPs41dXIzDK8xxItQ73Z4mlopDIiMeKy49ZJT73Q3t1zuabgN0EqX0mVtomDwUer/
         O6V3tI0y7bHX3//2BVZbHgDw0h2vt1IZ871T64ASNAI2ibG6iJ5xcW34zzmRtU17UszF
         QOngpYdnf7VFsS54YFs2gEcIkdQgyMLLHIE2Bpdemh3Z9Yrpx4Ebh2sRNL5hheH8NTEq
         pbf/nFay6+e7lC1xsBc/3ceM0NS0U5LQovmbCo7b3ROxNUvCz4e5woqtcNPNpr7jIZYk
         RZCA==
X-Gm-Message-State: ACrzQf26EPt88f1pqZ+a3T9SROSMaB1YUeGMP4tOGdV4TFbWYFt9FPwd
        VyYTUhcd8jb3TBkXUFCDowOtU1IrlS7l8h4B
X-Google-Smtp-Source: AMsMyM4aSHbod+7GXRKRNdM8wHiDfUHPJ3AmCiYxC+f5jjq0b2oeLAB5Tel4d4DwxmDE1zB7On16fw==
X-Received: by 2002:a5d:457b:0:b0:22b:24d6:1a9f with SMTP id a27-20020a5d457b000000b0022b24d61a9fmr15292421wrc.201.1664265412020;
        Tue, 27 Sep 2022 00:56:52 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e9-20020adfe389000000b00228daaa84aesm1097857wrm.25.2022.09.27.00.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 00:56:51 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next v2 3/7] net: devlink: add port_init/fini() helpers to allow pre-register/post-unregister functions
Date:   Tue, 27 Sep 2022 09:56:41 +0200
Message-Id: <20220927075645.2874644-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220927075645.2874644-1-jiri@resnulli.us>
References: <20220927075645.2874644-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

To be consistent with devlink regions, devlink port regions are going to
be forbidden to be created once devlink port is registered. Prepare for
this and introduce new set of helpers to allow driver to initialize
devlink pointer and region list before devlink_register() is called
That allows port regions to be created before devlink port registration
and destroyed after devlink port unregistration.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h |  6 +++++-
 net/core/devlink.c    | 46 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index bcacd8dab297..ba6b8b094943 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -130,7 +130,8 @@ struct devlink_port {
 	struct devlink_port_attrs attrs;
 	u8 attrs_set:1,
 	   switch_port:1,
-	   registered:1;
+	   registered:1,
+	   initialized:1;
 	struct delayed_work type_warn_dw;
 	struct list_head reporter_list;
 	struct mutex reporters_lock; /* Protects reporter_list */
@@ -1563,6 +1564,9 @@ void devlink_set_features(struct devlink *devlink, u64 features);
 void devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
 void devlink_free(struct devlink *devlink);
+void devlink_port_init(struct devlink *devlink,
+		       struct devlink_port *devlink_port);
+void devlink_port_fini(struct devlink_port *devlink_port);
 int devl_port_register(struct devlink *devlink,
 		       struct devlink_port *devlink_port,
 		       unsigned int port_index);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 17529e6b2bbf..89baa7c0938b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -375,6 +375,8 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 	WARN_ON_ONCE(!(devlink_port)->registered)
 #define ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port)			\
 	WARN_ON_ONCE((devlink_port)->registered)
+#define ASSERT_DEVLINK_PORT_INITIALIZED(devlink_port)				\
+	WARN_ON_ONCE(!(devlink_port)->initialized)
 
 static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
 						      unsigned int port_index)
@@ -9852,6 +9854,44 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
 	cancel_delayed_work_sync(&devlink_port->type_warn_dw);
 }
 
+/**
+ * devlink_port_init() - Init devlink port
+ *
+ * @devlink: devlink
+ * @devlink_port: devlink port
+ *
+ * Initialize essencial stuff that is needed for functions
+ * that may be called before devlink port registration.
+ * Call to this function is optional and not needed
+ * in case the driver does not use such functions.
+ */
+void devlink_port_init(struct devlink *devlink,
+		       struct devlink_port *devlink_port)
+{
+	if (devlink_port->initialized)
+		return;
+	devlink_port->devlink = devlink;
+	INIT_LIST_HEAD(&devlink_port->region_list);
+	devlink_port->initialized = true;
+}
+EXPORT_SYMBOL_GPL(devlink_port_init);
+
+/**
+ * devlink_port_fini() - Deinitialize devlink port
+ *
+ * @devlink_port: devlink port
+ *
+ * Deinitialize essencial stuff that is in use for functions
+ * that may be called after devlink port unregistration.
+ * Call to this function is optional and not needed
+ * in case the driver does not use such functions.
+ */
+void devlink_port_fini(struct devlink_port *devlink_port)
+{
+	WARN_ON(!list_empty(&devlink_port->region_list));
+}
+EXPORT_SYMBOL_GPL(devlink_port_fini);
+
 /**
  * devl_port_register() - Register devlink port
  *
@@ -9876,14 +9916,13 @@ int devl_port_register(struct devlink *devlink,
 
 	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
 
+	devlink_port_init(devlink, devlink_port);
 	devlink_port->registered = true;
-	devlink_port->devlink = devlink;
 	devlink_port->index = port_index;
 	spin_lock_init(&devlink_port->type_lock);
 	INIT_LIST_HEAD(&devlink_port->reporter_list);
 	mutex_init(&devlink_port->reporters_lock);
 	list_add_tail(&devlink_port->list, &devlink->port_list);
-	INIT_LIST_HEAD(&devlink_port->region_list);
 
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 	devlink_port_type_warn_schedule(devlink_port);
@@ -9933,7 +9972,6 @@ void devl_port_unregister(struct devlink_port *devlink_port)
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	list_del(&devlink_port->list);
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
-	WARN_ON(!list_empty(&devlink_port->region_list));
 	mutex_destroy(&devlink_port->reporters_lock);
 	devlink_port->registered = false;
 }
@@ -11347,6 +11385,8 @@ devlink_port_region_create(struct devlink_port *port,
 	struct devlink_region *region;
 	int err = 0;
 
+	ASSERT_DEVLINK_PORT_INITIALIZED(port);
+
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-- 
2.37.1

