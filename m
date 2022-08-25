Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDA85A0DF6
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 12:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240881AbiHYKeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 06:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240846AbiHYKeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 06:34:14 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576FFA3D63
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:34:12 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id u5so16225298wrt.11
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Mgn/UMq9Tran0+zvWQuUcnqY1WcLgrUXupcVmqZnAmE=;
        b=7I6prp3ouOKn7j4MgxfJEtPNNZU6fwgmejOmsokYgtmmTybj3p3H1G88U0vYD6/WKN
         txbY6S47BGrwS4+tKogoD7Z5RPW/zUNOYsYyQrJ2KIkU+gpIP/sQ8CKc6bNlvJdicvL8
         EXDMvcFTdPj9qwnVOgv3/VRFbdTBRNkqnzD+OuD0DF8OBFxumMcdaAiA4KZP6lX/WYJ9
         KtlOQiUpN8VNjL/G4bUPRFUU8hLxbJvy9j+QfBQtgrnr1fz0hY1aeFQyLRTcOMbA9Zg+
         6GXIk/RSX/We65gSpKW/0krLWIh2fjl80+aqOEckhPa753YgPD72sXspPeKl8rEaS5uF
         2Ctw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Mgn/UMq9Tran0+zvWQuUcnqY1WcLgrUXupcVmqZnAmE=;
        b=Ys3t26wju6AA0FlUc177xDJHjN9kYh8qSmj/sOzzIilR8hd0cUkHBZnWp0GWZlleQz
         gJ/l1GbWEJROOLfxsXPAGjE1e14fhPPWDYdGXf4JV7e8N2xzByRrTL0r2VSDOTCk0TYu
         KIoCvetQtuVoPmxtjdOMk1Lo/4EIFm7+hmWyAz0xe39BCCQ6q/2JL8Bk+jCsgmcpm1/s
         tQyzRHweLXiP+s7QLfqkYapGtqw4tUuddiFfPpONQf5cEpC+dAh/USFGdZWzozfUGvQE
         INKWc/volpQPF8p1UxmfBTo4TGePYbf6pxTVmjEUN6ORAmx+nRNSbDYIR88op1xVW4QS
         WP3A==
X-Gm-Message-State: ACgBeo24BFei9gseoJdmMrqvrZc1tKtRwkzEFnGdQVbvhlf3K5qv5jy6
        grkuI0TZYjPcNgOSBay7oXRKz81I8Wy1d5Xi
X-Google-Smtp-Source: AA6agR6Ynw2K5lxxNDki4qCK8lbRR4JZrTWdkjgdxBgPUA1SZzQ2XAAgxOS6+VfgKwyDFzz3u/+obA==
X-Received: by 2002:a5d:4302:0:b0:225:5303:39e5 with SMTP id h2-20020a5d4302000000b00225530339e5mr1881878wrq.380.1661423650509;
        Thu, 25 Aug 2022 03:34:10 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j9-20020adff549000000b0022586045c89sm288831wrp.69.2022.08.25.03.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 03:34:09 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next 4/7] net: devlink: add port_init/fini() helpers to allow pre-register/post-unregister functions
Date:   Thu, 25 Aug 2022 12:33:57 +0200
Message-Id: <20220825103400.1356995-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220825103400.1356995-1-jiri@resnulli.us>
References: <20220825103400.1356995-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 7b41ebbaf379..bc7c423891c2 100644
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
@@ -1564,6 +1565,9 @@ void devlink_set_features(struct devlink *devlink, u64 features);
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
index af13f95384d9..a9b31a05d611 100644
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
@@ -9754,6 +9756,44 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
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
@@ -9778,14 +9818,13 @@ int devl_port_register(struct devlink *devlink,
 
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
@@ -9835,7 +9874,6 @@ void devl_port_unregister(struct devlink_port *devlink_port)
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	list_del(&devlink_port->list);
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
-	WARN_ON(!list_empty(&devlink_port->region_list));
 	mutex_destroy(&devlink_port->reporters_lock);
 	devlink_port->registered = false;
 }
@@ -11249,6 +11287,8 @@ devlink_port_region_create(struct devlink_port *port,
 	struct devlink_region *region;
 	int err = 0;
 
+	ASSERT_DEVLINK_PORT_INITIALIZED(port);
+
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-- 
2.37.1

