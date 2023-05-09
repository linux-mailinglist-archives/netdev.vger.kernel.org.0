Return-Path: <netdev+bounces-1109-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F9E56FC38D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:10:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E68B1C20A1C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBB4B10960;
	Tue,  9 May 2023 10:09:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E16C2D2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:09:51 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DEC10F
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 03:09:46 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so57273224a12.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 03:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683626985; x=1686218985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ODh5ZFuPRkJx7NiwWSS6sVIS1oA8JOEOyAhwG731hXU=;
        b=FziZCZasL5oJz42dXG3diSodF2+A1zzmSumldgaVLgoX25qVp3cRWQb7bofb/usgH6
         zbZtEElfYXYfpnFo/CvhuiUXIVZ6tKPMbMitcYCV4K8CC/PBtfBlZmr7n7ln27wh2Lbs
         xTHJTOBYLOSScijVubMxVDtjvNlyVa5yq/FnxPQR6kDdEpwNYT3/X8ohwhsskDgRPqVX
         SHOJTBsiaGvnyfeWeSJSIvlIaWk55ilxFYYyOitM707bGr9soD80kzH6G4cU2F35obrx
         8B/olNzOBiDZGt4a+VCoifN4IDutlZsS5/jNC8UKXOWWI/NsAspxholsUgpx1J0sr9Ej
         Sg/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683626985; x=1686218985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ODh5ZFuPRkJx7NiwWSS6sVIS1oA8JOEOyAhwG731hXU=;
        b=jNyv2qY0ZV9ZuyqKvycEOkMbnLBwcHehubW9jwTfCdOCNggfc55J7KvQyCZSXiWDSj
         hIKbNf7Elu7mti+UANxqVg3bDgeu7htNE/O5SUJ1wcW5a0TOfOvhfYBmBDZyuDBwhQQD
         qP4pSbjZbSUyUNhh11YA+gYuxXvt5oJGhbHsItBZFX4xWGaF/fJPrX7cxSFxp2gDgYtl
         ND1YBmSGobaA6DCzg9OxCboQD0iIAnBiZp3CbdyegErDGEVZeyah+2qAcjRB0oB6Ezoz
         ZFz8Hu0ciVUKE/+7lZFoA9dlY6ActdjVPW/BOnmYC2CV45xUTXzjB8NN3Tnl6/Q34CkS
         FC9Q==
X-Gm-Message-State: AC+VfDx2nJWTpyiz7CgJ6j0Jg6U/TTqIJiKYyXXJjKcFgLF3XiD4QVxU
	lfzh0VMnRerK688sMr6sAgEwlL3LDaS7UnI/aXY61w==
X-Google-Smtp-Source: ACHHUZ4wVp7JojKshJ61YCKy+KsDYR8KqHmVrou1nP0+ane8YQuUS/qAfqPkiE7LOR3XlgpOi/SRQA==
X-Received: by 2002:a17:906:730d:b0:959:b757:e49 with SMTP id di13-20020a170906730d00b00959b7570e49mr12509260ejc.1.1683626985058;
        Tue, 09 May 2023 03:09:45 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w21-20020a170906131500b0096637a19dccsm1114451ejb.210.2023.05.09.03.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:09:44 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	jacob.e.keller@intel.com,
	saeedm@nvidia.com,
	moshe@nvidia.com
Subject: [patch net 2/3] devlink: make netdev notifier per-port
Date: Tue,  9 May 2023 12:09:38 +0200
Message-Id: <20230509100939.760867-3-jiri@resnulli.us>
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

The netdev notifier is used to track changes of a netdev related to a
certain devlink port. In preparation for the next patch,
change the netdev notifier to register per devlink port instance.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h       |  1 +
 net/devlink/core.c          |  9 ---------
 net/devlink/devl_internal.h |  4 ----
 net/devlink/leftover.c      | 31 ++++++++++++++++++++++---------
 4 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6a942e70e451..d0a0d1ce7db4 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -149,6 +149,7 @@ struct devlink_port {
 
 	struct devlink_rate *devlink_rate;
 	struct devlink_linecard *linecard;
+	struct notifier_block netdevice_nb;
 };
 
 struct devlink_port_new_attrs {
diff --git a/net/devlink/core.c b/net/devlink/core.c
index 777b091ef74d..018e547bdb98 100644
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
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index e133f423294a..e595c5dcff45 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -50,7 +50,6 @@ struct devlink {
 	u8 reload_failed:1;
 	refcount_t refcount;
 	struct rcu_work rwork;
-	struct notifier_block netdevice_nb;
 	char priv[] __aligned(NETDEV_ALIGN);
 };
 
@@ -171,9 +170,6 @@ extern const struct devlink_cmd devl_cmd_selftests_get;
 void devlink_notify(struct devlink *devlink, enum devlink_command cmd);
 
 /* Ports */
-int devlink_port_netdevice_event(struct notifier_block *nb,
-				 unsigned long event, void *ptr);
-
 struct devlink_port *
 devlink_port_get_from_info(struct devlink *devlink, struct genl_info *info);
 struct devlink_port *devlink_port_get_from_attrs(struct devlink *devlink,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index dffca2f9bfa7..4b1627cb2b83 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -6841,6 +6841,9 @@ void devlink_port_fini(struct devlink_port *devlink_port)
 }
 EXPORT_SYMBOL_GPL(devlink_port_fini);
 
+static int devlink_port_netdevice_event(struct notifier_block *nb,
+					unsigned long event, void *ptr);
+
 /**
  * devl_port_register() - Register devlink port
  *
@@ -6869,14 +6872,24 @@ int devl_port_register(struct devlink *devlink,
 	devlink_port->index = port_index;
 	spin_lock_init(&devlink_port->type_lock);
 	INIT_LIST_HEAD(&devlink_port->reporter_list);
-	err = xa_insert(&devlink->ports, port_index, devlink_port, GFP_KERNEL);
+
+	devlink_port->netdevice_nb.notifier_call = devlink_port_netdevice_event;
+	err = register_netdevice_notifier(&devlink_port->netdevice_nb);
 	if (err)
 		return err;
 
+	err = xa_insert(&devlink->ports, port_index, devlink_port, GFP_KERNEL);
+	if (err)
+		goto err_xa_insert;
+
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 	devlink_port_type_warn_schedule(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
 	return 0;
+
+err_xa_insert:
+	unregister_netdevice_notifier(&devlink_port->netdevice_nb);
+	return err;
 }
 EXPORT_SYMBOL_GPL(devl_port_register);
 
@@ -6921,6 +6934,7 @@ void devl_port_unregister(struct devlink_port *devlink_port)
 	devlink_port_type_warn_cancel(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	xa_erase(&devlink_port->devlink->ports, devlink_port->index);
+	WARN_ON_ONCE(unregister_netdevice_notifier(&devlink_port->netdevice_nb));
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
 	devlink_port->registered = false;
 }
@@ -7066,16 +7080,15 @@ void devlink_port_type_clear(struct devlink_port *devlink_port)
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_clear);
 
-int devlink_port_netdevice_event(struct notifier_block *nb,
-				 unsigned long event, void *ptr)
+static int devlink_port_netdevice_event(struct notifier_block *nb,
+					unsigned long event, void *ptr)
 {
 	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
-	struct devlink_port *devlink_port = netdev->devlink_port;
-	struct devlink *devlink;
+	struct devlink_port *devlink_port;
 
-	devlink = container_of(nb, struct devlink, netdevice_nb);
+	devlink_port = container_of(nb, struct devlink_port, netdevice_nb);
 
-	if (!devlink_port || devlink_port->devlink != devlink)
+	if (netdev->devlink_port != devlink_port)
 		return NOTIFY_OK;
 
 	switch (event) {
@@ -7089,7 +7102,7 @@ int devlink_port_netdevice_event(struct notifier_block *nb,
 		break;
 	case NETDEV_REGISTER:
 	case NETDEV_CHANGENAME:
-		if (devlink_net(devlink) != dev_net(netdev))
+		if (devlink_net(devlink_port->devlink) != dev_net(netdev))
 			return NOTIFY_OK;
 		/* Set the netdev on top of previously set type. Note this
 		 * event happens also during net namespace change so here
@@ -7100,7 +7113,7 @@ int devlink_port_netdevice_event(struct notifier_block *nb,
 					netdev);
 		break;
 	case NETDEV_UNREGISTER:
-		if (devlink_net(devlink) != dev_net(netdev))
+		if (devlink_net(devlink_port->devlink) != dev_net(netdev))
 			return NOTIFY_OK;
 		/* Clear netdev pointer, but not the type. This event happens
 		 * also during net namespace change so we need to clear
-- 
2.39.2


