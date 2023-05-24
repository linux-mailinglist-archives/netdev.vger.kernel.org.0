Return-Path: <netdev+bounces-4967-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD68D70F614
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:19:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D2052812C9
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:19:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C70182A6;
	Wed, 24 May 2023 12:18:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1908182A3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:18:42 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7B59E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:40 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-96fe88cd2fcso154790966b.1
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684930719; x=1687522719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZuCTKHla5r1a0E8DCs+zHUGPnLiqNOmUNssR3wIlaVI=;
        b=EOYGsTPlCYmUg8LLJAAJRcGSBz1mwP0cC54TbsxQmuzVmUH3IGjrr6aP1Izb451ghA
         QharHFD2ANHP1WjSWdlJ973UVRLxqcxPQ9mgCWxaC4BLA41YjHoMfDfWpIedir6EKABm
         XhOYSHhysw1QF+vEUSmm4djegmE86a42rTxymcCS2g12lSGia+/dW6iaAu8Dh+ljzk34
         wqb3aGiou7xcCK13cxuTWNmRu88Yvlw5a78myEh8HJrV8nxn+/Y74RHCNYsQK7hRfqGu
         IOWKcfSe7y5Y+lfmvpsDaIfrI6ECXT/FmkPz3AoFik9SJDOEuvmGwGUqu4iTcFd4q7dx
         QlEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930719; x=1687522719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZuCTKHla5r1a0E8DCs+zHUGPnLiqNOmUNssR3wIlaVI=;
        b=Bns9bO6dftJRscs9qqWeZucl71cfv46Uec0ZV9YWoCU4fRBe8CF55aF0pApKNs+yfw
         6nM2epbGQuCCAxF8KiiTHHcHltNx82OFkF0yR58qaAe3OjjWBAiPTncq9jE7CvZN5yCP
         Ls1P2X6ahhEiuIgDpaI3o9cVGNGRjlK9mv33+m4R+5beqzuczvPjU/5xrbPsziYq4Ujq
         /8LVdCtd2dCBZIikXFnxA9RXVae+rIWsV/EckVnVs11j0haJZAY/GiPjy3GS86be4MTM
         6mXwA8gAX72oLggmgw5p9mFPZU8mWsByKLueLxDgYa9iJ5sYm/s1KtV3VzQyLjzD5MXJ
         4bfQ==
X-Gm-Message-State: AC+VfDzPS+7jTDdFuiv1ugx/A/ymY1QobBnnKi3X7JWBPye/EFXGOlPM
	fVk6wwZ9r570Q02uEtmSz40G8fRg/8iSrBNFEZg4cA==
X-Google-Smtp-Source: ACHHUZ4V5qc2UC5kmSXsFBH9ZYUtD+Wzm9VqmPxn0tbii0Hzo6UeBXzXV/AOAoPtig5+jRDIyxelQA==
X-Received: by 2002:a17:907:7286:b0:96f:e7cf:5004 with SMTP id dt6-20020a170907728600b0096fe7cf5004mr8832246ejc.73.1684930719354;
        Wed, 24 May 2023 05:18:39 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id p18-20020a1709060e9200b00965ac8f8a3dsm5636254ejf.173.2023.05.24.05.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:18:38 -0700 (PDT)
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
Subject: [patch net-next 01/15] devlink: introduce port ops placeholder
Date: Wed, 24 May 2023 14:18:22 +0200
Message-Id: <20230524121836.2070879-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230524121836.2070879-1-jiri@resnulli.us>
References: <20230524121836.2070879-1-jiri@resnulli.us>
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
 include/net/devlink.h  | 41 +++++++++++++++++++++++++++++++++++------
 net/devlink/leftover.c | 24 +++++++++++++++---------
 2 files changed, 50 insertions(+), 15 deletions(-)

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
index 0410137a4a31..ff1c2ed84aba 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -6799,6 +6799,7 @@ EXPORT_SYMBOL_GPL(devlink_port_fini);
  * @devlink: devlink
  * @devlink_port: devlink port
  * @port_index: driver-specific numerical identifier of the port
+ * @ops: port ops
  *
  * Register devlink port with provided port index. User can use
  * any indexing, even hw-related one. devlink_port structure
@@ -6806,9 +6807,10 @@ EXPORT_SYMBOL_GPL(devlink_port_fini);
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
 
@@ -6819,6 +6821,7 @@ int devl_port_register(struct devlink *devlink,
 	devlink_port_init(devlink, devlink_port);
 	devlink_port->registered = true;
 	devlink_port->index = port_index;
+	devlink_port->ops = ops;
 	spin_lock_init(&devlink_port->type_lock);
 	INIT_LIST_HEAD(&devlink_port->reporter_list);
 	err = xa_insert(&devlink->ports, port_index, devlink_port, GFP_KERNEL);
@@ -6830,7 +6833,7 @@ int devl_port_register(struct devlink *devlink,
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(devl_port_register);
+EXPORT_SYMBOL_GPL(devl_port_register_with_ops);
 
 /**
  *	devlink_port_register - Register devlink port
@@ -6838,6 +6841,7 @@ EXPORT_SYMBOL_GPL(devl_port_register);
  *	@devlink: devlink
  *	@devlink_port: devlink port
  *	@port_index: driver-specific numerical identifier of the port
+ *	@ops: port ops
  *
  *	Register devlink port with provided port index. User can use
  *	any indexing, even hw-related one. devlink_port structure
@@ -6847,18 +6851,20 @@ EXPORT_SYMBOL_GPL(devl_port_register);
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


