Return-Path: <netdev+bounces-5626-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1423A7124A2
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:29:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 964E4281793
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:29:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A60F0168BC;
	Fri, 26 May 2023 10:28:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98599168B1
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:28:48 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B9710A
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:46 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f623adec61so6330515e9.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685096925; x=1687688925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G0ibMTfqEAUGD7f4ennvsCgGF5awjbSBU6IUNdL6/4o=;
        b=hsHnFXbuprKdheJpz5yJoZj4k7EKegeFrHesHssPF4n2zGKsxzg0i8gUZLJ3buEn9e
         NaZOKpI/wWirn1E9xUW9ZStrRIFrjRxDw1TZvX5FyYubVl+nmLl5gtfbpIzMDPs2dDr1
         Cj+uadHU2bgYTJhrIccBoVn4BufuawxMThgTunbGYQYnRA11jLKzg1xIdR9tzPlGu2Ec
         BCr2FSgOeZchz6vV1q94lK0JGTZkk3KbrnqzFaKsh2Mr/gzKsAw5yhAeX6acgNRv/lJK
         dRvMLyXeD/Jh1cLl+dX+SFSqetW3cAL9N7PnOniJ32ZMD9MrwgLc7QZUp7lxNKyuRnob
         gmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685096925; x=1687688925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G0ibMTfqEAUGD7f4ennvsCgGF5awjbSBU6IUNdL6/4o=;
        b=Anwm4JfmMWRzp0exudNp8jW0EgTIk8Z9nVsZN/+/Hbo0InkXr5Cuhr9t5zhU3w9Bc1
         RsDGC8gX45Ab9ws/r3nNK2pOmZP22lNV4DzjwEtwkvM47KZIQYJD2d/FxGZ9HSVmJ/tm
         FDl84ttK4uEPM4xWrbedbMRtbN3RUy68IgpXRnDuXasmCy10sTy69BDRetgOHzq3nPgo
         VRGNOlPZmTSRcM9CkMPlLGb6SXbYDexl1AEMBZ9a9tPQtI6wEwLSxqCGve5e89A2Uhbp
         0aw+Swa4czz0A4tT28ZILEQ8Ymh/c4Ese3s2B2MBpBBVOhoG+L3CxDmWk7WWCvMF+yCm
         UC9w==
X-Gm-Message-State: AC+VfDwnPUE6bn/VjdIZV0j15+RmiDlsofrLH5m7FXL9ORlSft8W1131
	J2fJ7vAsaikvqUddIDye1plEmJ4p1xEtK+G/KnTzBw==
X-Google-Smtp-Source: ACHHUZ52G02/l45y+lcoJxqqnjuXXW4yCk8b0XgY9OwrKdx2IAR0f6LXWE3a9vkHyfbVnuHeRc2bBQ==
X-Received: by 2002:a7b:cd8c:0:b0:3f6:459:eba3 with SMTP id y12-20020a7bcd8c000000b003f60459eba3mr1260605wmj.0.1685096925183;
        Fri, 26 May 2023 03:28:45 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id p20-20020a1c7414000000b003f60eb72cf5sm8510739wmc.2.2023.05.26.03.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:28:44 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	leon@kernel.org,
	saeedm@nvidia.com,
	moshe@nvidia.com,
	jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com,
	tariqt@nvidia.com,
	idosch@nvidia.com,
	petrm@nvidia.com,
	simon.horman@corigine.com,
	ecree.xilinx@gmail.com,
	habetsm.xilinx@gmail.com,
	michal.wilczynski@intel.com,
	jacob.e.keller@intel.com
Subject: [patch net-next v2 01/15] devlink: introduce port ops placeholder
Date: Fri, 26 May 2023 12:28:27 +0200
Message-Id: <20230526102841.2226553-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230526102841.2226553-1-jiri@resnulli.us>
References: <20230526102841.2226553-1-jiri@resnulli.us>
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

In devlink, some of the objects have separate ops registered alongside
with the object itself. Port however have ops in devlink_ops structure.
For drivers what register multiple kinds of ports with different ops
this is not convenient. Introduce devlink_port_ops and a set
of functions that allow drivers to pass ops pointer during
port registration.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- fixed function names in kdoc comments
- use dummy empty ops in case ops is null
---
 include/net/devlink.h  | 41 +++++++++++++++++++++++++++++++++++------
 net/devlink/leftover.c | 30 +++++++++++++++++++-----------
 2 files changed, 54 insertions(+), 17 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 1bd56c8d6f3c..850148b98f70 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -123,6 +123,7 @@ struct devlink_port {
 	struct list_head list;
 	struct list_head region_list;
 	struct devlink *devlink;
+	const struct devlink_port_ops *ops;
 	unsigned int index;
 	spinlock_t type_lock; /* Protects type and type_eth/ib
 			       * structures consistency.
@@ -1649,15 +1650,43 @@ void devl_unregister(struct devlink *devlink);
 void devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
 void devlink_free(struct devlink *devlink);
+
+/**
+ * struct devlink_port_ops - Port operations
+ */
+struct devlink_port_ops {
+};
+
 void devlink_port_init(struct devlink *devlink,
 		       struct devlink_port *devlink_port);
 void devlink_port_fini(struct devlink_port *devlink_port);
-int devl_port_register(struct devlink *devlink,
-		       struct devlink_port *devlink_port,
-		       unsigned int port_index);
-int devlink_port_register(struct devlink *devlink,
-			  struct devlink_port *devlink_port,
-			  unsigned int port_index);
+
+int devl_port_register_with_ops(struct devlink *devlink,
+				struct devlink_port *devlink_port,
+				unsigned int port_index,
+				const struct devlink_port_ops *ops);
+
+static inline int devl_port_register(struct devlink *devlink,
+				     struct devlink_port *devlink_port,
+				     unsigned int port_index)
+{
+	return devl_port_register_with_ops(devlink, devlink_port,
+					   port_index, NULL);
+}
+
+int devlink_port_register_with_ops(struct devlink *devlink,
+				   struct devlink_port *devlink_port,
+				   unsigned int port_index,
+				   const struct devlink_port_ops *ops);
+
+static inline int devlink_port_register(struct devlink *devlink,
+					struct devlink_port *devlink_port,
+					unsigned int port_index)
+{
+	return devlink_port_register_with_ops(devlink, devlink_port,
+					      port_index, NULL);
+}
+
 void devl_port_unregister(struct devlink_port *devlink_port);
 void devlink_port_unregister(struct devlink_port *devlink_port);
 void devlink_port_type_eth_set(struct devlink_port *devlink_port);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 0410137a4a31..14bb82403c2d 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -6793,12 +6793,15 @@ void devlink_port_fini(struct devlink_port *devlink_port)
 }
 EXPORT_SYMBOL_GPL(devlink_port_fini);
 
+static const struct devlink_port_ops devlink_port_dummy_ops = {};
+
 /**
- * devl_port_register() - Register devlink port
+ * devl_port_register_with_ops() - Register devlink port
  *
  * @devlink: devlink
  * @devlink_port: devlink port
  * @port_index: driver-specific numerical identifier of the port
+ * @ops: port ops
  *
  * Register devlink port with provided port index. User can use
  * any indexing, even hw-related one. devlink_port structure
@@ -6806,9 +6809,10 @@ EXPORT_SYMBOL_GPL(devlink_port_fini);
  * Note that the caller should take care of zeroing the devlink_port
  * structure.
  */
-int devl_port_register(struct devlink *devlink,
-		       struct devlink_port *devlink_port,
-		       unsigned int port_index)
+int devl_port_register_with_ops(struct devlink *devlink,
+				struct devlink_port *devlink_port,
+				unsigned int port_index,
+				const struct devlink_port_ops *ops)
 {
 	int err;
 
@@ -6819,6 +6823,7 @@ int devl_port_register(struct devlink *devlink,
 	devlink_port_init(devlink, devlink_port);
 	devlink_port->registered = true;
 	devlink_port->index = port_index;
+	devlink_port->ops = ops ? ops : &devlink_port_dummy_ops;
 	spin_lock_init(&devlink_port->type_lock);
 	INIT_LIST_HEAD(&devlink_port->reporter_list);
 	err = xa_insert(&devlink->ports, port_index, devlink_port, GFP_KERNEL);
@@ -6830,14 +6835,15 @@ int devl_port_register(struct devlink *devlink,
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(devl_port_register);
+EXPORT_SYMBOL_GPL(devl_port_register_with_ops);
 
 /**
- *	devlink_port_register - Register devlink port
+ *	devlink_port_register_with_ops - Register devlink port
  *
  *	@devlink: devlink
  *	@devlink_port: devlink port
  *	@port_index: driver-specific numerical identifier of the port
+ *	@ops: port ops
  *
  *	Register devlink port with provided port index. User can use
  *	any indexing, even hw-related one. devlink_port structure
@@ -6847,18 +6853,20 @@ EXPORT_SYMBOL_GPL(devl_port_register);
  *
  *	Context: Takes and release devlink->lock <mutex>.
  */
-int devlink_port_register(struct devlink *devlink,
-			  struct devlink_port *devlink_port,
-			  unsigned int port_index)
+int devlink_port_register_with_ops(struct devlink *devlink,
+				   struct devlink_port *devlink_port,
+				   unsigned int port_index,
+				   const struct devlink_port_ops *ops)
 {
 	int err;
 
 	devl_lock(devlink);
-	err = devl_port_register(devlink, devlink_port, port_index);
+	err = devl_port_register_with_ops(devlink, devlink_port,
+					  port_index, ops);
 	devl_unlock(devlink);
 	return err;
 }
-EXPORT_SYMBOL_GPL(devlink_port_register);
+EXPORT_SYMBOL_GPL(devlink_port_register_with_ops);
 
 /**
  * devl_port_unregister() - Unregister devlink port
-- 
2.39.2


