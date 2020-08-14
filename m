Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98351244C68
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 18:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgHNQG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 12:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgHNQGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 12:06:25 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DFCC061384;
        Fri, 14 Aug 2020 09:06:21 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mw10so4597207pjb.2;
        Fri, 14 Aug 2020 09:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SVVgujljZTtyJP6NnksQakHSy/XVCreM9mOqtMP8xFc=;
        b=ZZIGW/jLmpzk1d8NA4T7bUfo0j+jVcUhskU2RVTwoT5W3++oJCwv4kxx/pSVQhR2D2
         7bj0hFcWXTSgTQBNAKKv/wwS4sLjfq86l8EUsD6rVX7UopuQucjogCN1VsoXbPEM/2/N
         3gksrhGnVSSTjdJD6w5hTJua7m8ryaM1egfphkOk5RV6U5r6A1CS27UuXwYKlF4zy5ey
         bu04sjTeBTpesueoncTwVWJaBRtQF+CE488jmDuRstb2F0fPOrIYNHqWkSmY/iK5KytN
         8AAZuvEEKGnMA10TANHHXOYTay/MXnO5lf2UxZSE7XVMzGmyrcSfFNahn8DmgmQ305lV
         V70w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SVVgujljZTtyJP6NnksQakHSy/XVCreM9mOqtMP8xFc=;
        b=Y2hUmGyn4Di8Cotjkl1tR2ZjyFbkp1jFZEnd1TCgTw5OzNNTJYn9HxUBlo9zFzdlpm
         6H7HhRWY7OcG1ENnHL9zCO4ACjOkWSxcWVQnpsLZOW+IWYv5PhJDZpXdW28m8cHmDVbV
         xXf96xDDUiy/svmdDsL0fXVDypcBRbLb1vrs6qaHVN8ooCTzQK0Wj0NFieeaq1g/cbBH
         g9vg4hCo9iZzu64huUJYvG3dvLZKo0Y0n1NCvg88k1fWUp4VyKrD9qShsA+90XFZGMo+
         voFK2L2MlrTS0xq9JZ+t7be8xyQ3tmKDhQEG2JZTmCQong0cQoXkXGkWPW6TKhCcx3h0
         R8UA==
X-Gm-Message-State: AOAM532+Pf6iNHnAabTDS49TvUrKtUEE0EXu2A2NaxXq+1VN05PsKYLu
        4L+lWwX9XD8nccDYd6bN3qyyaGyeXvRMt4yBSyk=
X-Google-Smtp-Source: ABdhPJzaWHQZ9DlZxR8aScqhOBpp10HepOQyWepHBDjcHkVmyg0GkAryg0PXMwKwf4QZhhkhZUe54A==
X-Received: by 2002:a17:902:246:: with SMTP id 64mr2507754plc.70.1597421180418;
        Fri, 14 Aug 2020 09:06:20 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id w130sm9834458pfd.104.2020.08.14.09.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 09:06:20 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org (open list),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM)
Subject: [RFC 1/3] Initialize devlink health dump framework for the dlge driver
Date:   Sat, 15 Aug 2020 00:05:59 +0800
Message-Id: <20200814160601.901682-2-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200814160601.901682-1-coiby.xu@gmail.com>
References: <20200814160601.901682-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize devlink health dump framework for the dlge driver so the
coredump could be done via devlink.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/Makefile      |  2 +-
 drivers/staging/qlge/qlge.h        |  9 +++++++
 drivers/staging/qlge/qlge_health.c | 43 ++++++++++++++++++++++++++++++
 drivers/staging/qlge/qlge_health.h |  2 ++
 drivers/staging/qlge/qlge_main.c   | 21 +++++++++++++++
 5 files changed, 76 insertions(+), 1 deletion(-)
 create mode 100644 drivers/staging/qlge/qlge_health.c
 create mode 100644 drivers/staging/qlge/qlge_health.h

diff --git a/drivers/staging/qlge/Makefile b/drivers/staging/qlge/Makefile
index 1dc2568e820c..0a1e4c8dd546 100644
--- a/drivers/staging/qlge/Makefile
+++ b/drivers/staging/qlge/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_QLGE) += qlge.o
 
-qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o
+qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o qlge_health.o
diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index fc8c5ca8935d..055ded6dab60 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2061,6 +2061,14 @@ struct nic_operations {
 	int (*port_initialize) (struct ql_adapter *);
 };
 
+
+
+struct qlge_devlink {
+        struct ql_adapter *qdev;
+        struct net_device *ndev;
+        struct devlink_health_reporter *reporter;
+};
+
 /*
  * The main Adapter structure definition.
  * This structure has all fields relevant to the hardware.
@@ -2078,6 +2086,7 @@ struct ql_adapter {
 	struct pci_dev *pdev;
 	struct net_device *ndev;	/* Parent NET device */
 
+	struct qlge_devlink *devlink;
 	/* Hardware information */
 	u32 chip_rev_id;
 	u32 fw_rev_id;
diff --git a/drivers/staging/qlge/qlge_health.c b/drivers/staging/qlge/qlge_health.c
new file mode 100644
index 000000000000..292f6b1827e1
--- /dev/null
+++ b/drivers/staging/qlge/qlge_health.c
@@ -0,0 +1,43 @@
+#include "qlge.h"
+#include "qlge_health.h"
+
+static int
+qlge_reporter_coredump(struct devlink_health_reporter *reporter,
+			struct devlink_fmsg *fmsg, void *priv_ctx,
+			struct netlink_ext_ack *extack)
+{
+	return 0;
+}
+
+static const struct devlink_health_reporter_ops qlge_reporter_ops = {
+		.name = "dummy",
+		.dump = qlge_reporter_coredump,
+};
+
+int qlge_health_create_reporters(struct qlge_devlink *priv)
+{
+	int err;
+
+	struct devlink_health_reporter *reporter;
+	struct devlink *devlink;
+
+	devlink = priv_to_devlink(priv);
+	reporter =
+		devlink_health_reporter_create(devlink, &qlge_reporter_ops,
+					       0,
+					       priv);
+	if (IS_ERR(reporter)) {
+		netdev_warn(priv->ndev,
+			    "Failed to create reporter, err = %ld\n",
+			    PTR_ERR(reporter));
+		return PTR_ERR(reporter);
+	}
+	priv->reporter = reporter;
+
+	if (err)
+		return err;
+
+	return 0;
+}
+
+
diff --git a/drivers/staging/qlge/qlge_health.h b/drivers/staging/qlge/qlge_health.h
new file mode 100644
index 000000000000..07d3bafab845
--- /dev/null
+++ b/drivers/staging/qlge/qlge_health.h
@@ -0,0 +1,2 @@
+#include <net/devlink.h>
+int qlge_health_create_reporters(struct qlge_devlink *priv);
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 1650de13842f..b2be7f4b7dd6 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -42,6 +42,7 @@
 #include <net/ip6_checksum.h>
 
 #include "qlge.h"
+#include "qlge_health.h"
 
 char qlge_driver_name[] = DRV_NAME;
 const char qlge_driver_version[] = DRV_VERSION;
@@ -4550,6 +4551,8 @@ static void ql_timer(struct timer_list *t)
 	mod_timer(&qdev->timer, jiffies + (5 * HZ));
 }
 
+static const struct devlink_ops qlge_devlink_ops;
+
 static int qlge_probe(struct pci_dev *pdev,
 		      const struct pci_device_id *pci_entry)
 {
@@ -4557,6 +4560,13 @@ static int qlge_probe(struct pci_dev *pdev,
 	struct ql_adapter *qdev = NULL;
 	static int cards_found;
 	int err = 0;
+	struct devlink *devlink;
+	struct qlge_devlink *qlge_dl;
+
+	devlink = devlink_alloc(&qlge_devlink_ops, sizeof(struct qlge_devlink));
+	if (!devlink)
+		return -ENOMEM;
+	qlge_dl = devlink_priv(devlink);
 
 	ndev = alloc_etherdev_mq(sizeof(struct ql_adapter),
 				 min(MAX_CPUS,
@@ -4615,6 +4625,15 @@ static int qlge_probe(struct pci_dev *pdev,
 		free_netdev(ndev);
 		return err;
 	}
+
+	err = devlink_register(devlink, &pdev->dev);
+	if (err)
+		devlink_free(devlink);
+
+	qlge_health_create_reporters(qlge_dl);
+	qlge_dl->qdev = qdev;
+	qlge_dl->ndev = ndev;
+	qdev->devlink = qlge_dl;
 	/* Start up the timer to trigger EEH if
 	 * the bus goes dead
 	 */
@@ -4647,6 +4666,8 @@ static void qlge_remove(struct pci_dev *pdev)
 	unregister_netdev(ndev);
 	ql_release_all(pdev);
 	pci_disable_device(pdev);
+	devlink_unregister(priv_to_devlink(qdev->devlink));
+	devlink_health_reporter_destroy(qdev->devlink->reporter);
 	free_netdev(ndev);
 }
 
-- 
2.27.0

