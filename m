Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE227CCEFA
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 08:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfJFGaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 02:30:09 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37188 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfJFGaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 02:30:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id p14so10597697wro.4
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 23:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X5iP4gHFdTsFihub8cPe2/9aZbBqlCc1BJxOjipbrQw=;
        b=HdFqH1raoWb/dCCDHKDafdY1MwAJVE5onbjy+vmZa95Z+G8lDOSe4Ul3h/qpn6CgbI
         VxzsuDU2hi5N75MO7ANgF+Zx5JLnjBs/97a4eyPVx5Bp67/J3cc6ZuXGHEHSQd5rawtK
         NkCf/QBuw9GRKY/gNIO2py6rFP/vG9FPYcUalLzhWTlxzZ55gQIdt32/oO3GNgc7p97N
         j9y5i+8iWFOqbL6BhfPle5h+Rgw+jf2Gwdk9IAmKdqyah6NQlqta1TMWyz2e/CON57wK
         xmOqf0ndXRBrt4lvwx7qJ4J33CP9HK3dv/3MK6/hLYUEP1QrMLcKWZr/rFYF7Y4jvxdJ
         vJpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X5iP4gHFdTsFihub8cPe2/9aZbBqlCc1BJxOjipbrQw=;
        b=o9NqNRevrADtsgPS89Xherl+iOwXVv1S/j26ezgl8YXasCt8njuMjm/TSCDXpkFz1e
         sc2RasQa690pRp3wNPeul34OEgHXy8GdRhFck9ZxgkQsCX6aigUDTtYOa8PXMr3ahh5D
         xcmVitKEu/o+lSfl+u41stjB+yzi5bymcT5M8o2kp0GpliFhOfpItb+IU0T1SCeEl6pN
         AhTyIdJ0Q0oJtAtxMilZxekuA7hWwuAXn+Z8MwZqEqEd1WynCeilvXUWL3t5jp459VGC
         5jotaO4AjI6Zj8313y1v17yDPTj9yFAa2X6FVXylO3+5gOf7/hkqmzVm1KDV2wYfpsmv
         xykA==
X-Gm-Message-State: APjAAAVfssIV4BdVdu11fl6Fe41n8VT2lAm4nQa9vcNdQl2dcJ7uWlPj
        IiimiGOZqtoTg1ybPYka8F2vQTIEQlM=
X-Google-Smtp-Source: APXvYqzoJGoa/j89b4rBaBXopShbLgbiPnbq8KsVLqmAWAh5V5zZrfSzgTqONuQMr3O4yvyP1kQJiA==
X-Received: by 2002:a5d:4b0a:: with SMTP id v10mr11500117wrq.322.1570343404626;
        Sat, 05 Oct 2019 23:30:04 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h10sm11156085wrq.95.2019.10.05.23.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 23:30:04 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next 1/2] netdevsim: add couple of debugfs bools to debug devlink reload
Date:   Sun,  6 Oct 2019 08:30:01 +0200
Message-Id: <20191006063002.28860-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191006063002.28860-1-jiri@resnulli.us>
References: <20191006063002.28860-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add flag to disallow reload and another one that causes reload to
always fail.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/dev.c       | 20 ++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index fbc4cdcfe551..31d1752c703a 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -90,6 +90,10 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 			    &nsim_dev->test1);
 	debugfs_create_file("take_snapshot", 0200, nsim_dev->ddir, nsim_dev,
 			    &nsim_dev_take_snapshot_fops);
+	debugfs_create_bool("dont_allow_reload", 0600, nsim_dev->ddir,
+			    &nsim_dev->dont_allow_reload);
+	debugfs_create_bool("fail_reload", 0600, nsim_dev->ddir,
+			    &nsim_dev->fail_reload);
 	return 0;
 }
 
@@ -478,6 +482,14 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 
+	if (nsim_dev->dont_allow_reload) {
+		/* For testing purposes, user set debugfs dont_allow_reload
+		 * value to true. So forbid it.
+		 */
+		NL_SET_ERR_MSG_MOD(extack, "User forbidded reload for testing purposes");
+		return -EOPNOTSUPP;
+	}
+
 	nsim_dev_reload_destroy(nsim_dev);
 	return 0;
 }
@@ -487,6 +499,14 @@ static int nsim_dev_reload_up(struct devlink *devlink,
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 
+	if (nsim_dev->fail_reload) {
+		/* For testing purposes, user set debugfs fail_reload
+		 * value to true. Fail right away.
+		 */
+		NL_SET_ERR_MSG_MOD(extack, "User setup the reload to fail for testing purposes");
+		return -EINVAL;
+	}
+
 	return nsim_dev_reload_create(nsim_dev, extack);
 }
 
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 8168a5475fe7..24358385d869 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -161,6 +161,8 @@ struct nsim_dev {
 	bool fw_update_status;
 	u32 max_macs;
 	bool test1;
+	bool dont_allow_reload;
+	bool fail_reload;
 	struct devlink_region *dummy_region;
 };
 
-- 
2.21.0

