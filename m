Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2045DCC858
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 08:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfJEGKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 02:10:38 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37437 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfJEGKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 02:10:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id f22so7720974wmc.2
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 23:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FqJ6wkNrlM6p1nXZTcG0jR6sds0lG1n7Hpfw1iakzpE=;
        b=HJU20wszFT0RZejAZbR9py+ZHPyeGrFLjlSmpQ+7VGX/bEBk39HXOiCLRUJ0gycFg4
         2WvD1uXguu0gxb9If+NTk1d8TdZfRRCeduZvkhPOiAfLKq8QNhqnsGC7kybAWMfNKYKw
         GIMdVM2yqlu91w0cdEs3KbiJJEAzkN/8bTGFpHOi6SKJsS6w0Pwd6rzsRQ/+iIM0Rn/z
         c2mk0Dt61LWbW3S+lvvCl2sGJV+G/dWAqRgFe03cwY5lyRVyFzyTgzgTBoz8Gj1fyeQs
         PsXdPPfjtzH3N//hLwV2xVGr0NDjPZPRbB0xp5ME3huSSn0Xwu0I5P2KIvdAcSa++ZLS
         No8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FqJ6wkNrlM6p1nXZTcG0jR6sds0lG1n7Hpfw1iakzpE=;
        b=Oso8PO8d1ja94dvXU7lagUOcDlNINtyGfpiPqpaGj4pHrdB7vEovIhXOMDRZdETcHY
         B5ucT+QEiamPMvyKugvzhwcRM6+A0LY1dC9umBMc8J8CS+rEqf8j3pOhZPVXXMTxEBw3
         nyRUCRMawFEBYkok9Ltxrc4etlABEjssCGOaFe0a+EYWFHwZqupn/xxxrW+9s498IShh
         EhRcnYUPLodOwG8KJ8IQrL9Q9t3LekjHjLuEJE7a5iCBlM4lmR8tchfpBAjHv+xgxf/s
         t5w1NvtfPC1gqVZ/449mPFsLsdiX9bvPhfJfl2H9DuWDaHCQv2O5TE+bGs3d2PECxz1y
         SpIQ==
X-Gm-Message-State: APjAAAUBwdf9nsSLfzIsTMSjVsLfpN60vEZR257Ux5GTCDUPr13vLzK6
        DXqiOwWdhi1SJ7/WZ5sIeJvI5vNXKEw=
X-Google-Smtp-Source: APXvYqwq7OepGzgkK6emouABLc14m0LL686ygOvAysAAot4PsILQFVg3+XtfTrw89sm9818foEOHpQ==
X-Received: by 2002:a1c:2053:: with SMTP id g80mr11091816wmg.18.1570255835364;
        Fri, 04 Oct 2019 23:10:35 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h125sm14645265wmf.31.2019.10.04.23.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 23:10:35 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com,
        jakub.kicinski@netronome.com, petrm@mellanox.com,
        tariqt@mellanox.com, saeedm@mellanox.com, shuah@kernel.org,
        mlxsw@mellanox.com
Subject: [patch net-next 1/3] net: devlink: export devlink net setter
Date:   Sat,  5 Oct 2019 08:10:31 +0200
Message-Id: <20191005061033.24235-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191005061033.24235-1-jiri@resnulli.us>
References: <20191005061033.24235-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

For newly allocated devlink instance allow drivers to set net struct

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h |  2 ++
 net/core/devlink.c    | 15 ++++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 3c9d4a063c98..4095657fc23f 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -39,6 +39,7 @@ struct devlink {
 	possible_net_t _net;
 	struct mutex lock;
 	bool reload_failed;
+	bool registered;
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
@@ -772,6 +773,7 @@ static inline struct devlink *netdev_to_devlink(struct net_device *dev)
 struct ib_device;
 
 struct net *devlink_net(const struct devlink *devlink);
+void devlink_net_set(struct devlink *devlink, struct net *net);
 struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size);
 int devlink_register(struct devlink *devlink, struct device *dev);
 void devlink_unregister(struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6d16908f34b0..c628083cdf14 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -101,11 +101,19 @@ struct net *devlink_net(const struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_net);
 
-static void devlink_net_set(struct devlink *devlink, struct net *net)
+static void __devlink_net_set(struct devlink *devlink, struct net *net)
 {
 	write_pnet(&devlink->_net, net);
 }
 
+void devlink_net_set(struct devlink *devlink, struct net *net)
+{
+	if (WARN_ON(devlink->registered))
+		return;
+	__devlink_net_set(devlink, net);
+}
+EXPORT_SYMBOL_GPL(devlink_net_set);
+
 static struct devlink *devlink_get_from_attrs(struct net *net,
 					      struct nlattr **attrs)
 {
@@ -2750,7 +2758,7 @@ static void devlink_reload_netns_change(struct devlink *devlink,
 				     DEVLINK_CMD_PARAM_DEL);
 	devlink_notify(devlink, DEVLINK_CMD_DEL);
 
-	devlink_net_set(devlink, dest_net);
+	__devlink_net_set(devlink, dest_net);
 
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
 	list_for_each_entry(param_item, &devlink->param_list, list)
@@ -6278,7 +6286,7 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	if (!devlink)
 		return NULL;
 	devlink->ops = ops;
-	devlink_net_set(devlink, &init_net);
+	__devlink_net_set(devlink, &init_net);
 	INIT_LIST_HEAD(&devlink->port_list);
 	INIT_LIST_HEAD(&devlink->sb_list);
 	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
@@ -6304,6 +6312,7 @@ int devlink_register(struct devlink *devlink, struct device *dev)
 {
 	mutex_lock(&devlink_mutex);
 	devlink->dev = dev;
+	devlink->registered = true;
 	list_add_tail(&devlink->list, &devlink_list);
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
 	mutex_unlock(&devlink_mutex);
-- 
2.21.0

