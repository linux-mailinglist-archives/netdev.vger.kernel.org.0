Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8D73A4D79
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 10:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhFLIN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 04:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFLINY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 04:13:24 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23636C061767
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 01:11:25 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id n7so2304040wri.3
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 01:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MZ5iWwPms9MLNf+qVmLdkwv/Ob0NqXbhp+LkxYNHn+E=;
        b=IvPeNEsA67XvBPQeeiok9BDqD6Dxhw2jL4VeLi4rFLd0XhCJDtj8RcedfXvcqi1piV
         3WDBlMv+pKvUfq6tc1eacREtb0uAtW6h/lnX+X790TUhboRVb1tBqQWPLpZ9aVaRjgi2
         E2JcwoVidLjIJ/3UAjQJHyZqk0gaHKqxN9hmX55+TstyVmMklYt9Ck2Id9h8N8O8DFfs
         Di7AUuOkiypDhvr5HlX9z6CZGJL0Q8LW1V8FeDT+gWBmLv/dsdOqoBSt9Jo+be1jiyRu
         fntKztloAxY3a6uxpyuotYkCVs143+KUKlUlgUJSk9d3BBvI1f58pRxuJKxEdT6Grg+2
         mAtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MZ5iWwPms9MLNf+qVmLdkwv/Ob0NqXbhp+LkxYNHn+E=;
        b=c6TovFtWFd9IK/55fmf/m0ElUSoj1WTDGZyU0hLBJaiuRBni2xZOeIukDYDhjq/FOg
         k9MwAJD1Kampuw+6DpECH49iYtPwb9n6MT2LvvuC0PkoPVJm6cVqHPoWbiSbtdMO27qQ
         w1RgZhXRFPcHWWed99IBO2MQj6AM9la4dXqbCYXYD6z5hv5v/NVDOCsiDJLxCRqn9oLR
         GmJcZiqDtniq9H9AY33x8TiBZVdlQhc9X2gNRvff5rG2V4JGbx0dghSWxbGHuHhMd8nI
         5ko0e94j01gkleyHn/Oi25ZSff/DaO1BBiuJUkKE7K5m6p+T3+ipOe4sJdVvwzgm+JBq
         sNCw==
X-Gm-Message-State: AOAM532zrbnoYzjy1r6oxktCDUyZs2H/dVK+b1PDaovaGdgOu4Nol/sR
        nolH7qscdbxK6ydYntmdlzxNGw==
X-Google-Smtp-Source: ABdhPJx7ZasY0XdHaEL2bkLfMyxE6xtsE7e9EeF8Gg553HMvKnf6k+xTMSLwH76NdjkAVWYTRkzN3g==
X-Received: by 2002:adf:f7c3:: with SMTP id a3mr8098451wrq.253.1623485483628;
        Sat, 12 Jun 2021 01:11:23 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:85ed:406e:1bc4:a268])
        by smtp.gmail.com with ESMTPSA id w13sm10619313wrc.31.2021.06.12.01.11.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Jun 2021 01:11:23 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, m.chetan.kumar@intel.com,
        johannes.berg@intel.com, leon@kernel.org, ryazanov.s.a@gmail.com,
        parav@nvidia.com, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v3 4/4] net: mhi_net: Register wwan_ops for link creation
Date:   Sat, 12 Jun 2021 10:20:57 +0200
Message-Id: <1623486057-13075-5-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623486057-13075-1-git-send-email-loic.poulain@linaro.org>
References: <1623486057-13075-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register wwan_ops for link management via wwan rtnetlink. This is
only basic support for now, since we only support creating one
single link (link-0), but is useful to validate new wwan rtnetlink
interface.

For backward compatibity support, we still register a default netdev
at probe time, except if 'create_default_iface' module parameter is
set to false.

This has been tested with iproute2 and mbimcli:
$ ip link add dev wwan0-0 parentdev-name wwan0 type wwan linkid 0
$ mbimcli -p -d /dev/wwan0p2MBIM --connect apn=free
$ ip link set dev wwan0-0 up
$ ip addr add dev wwan0 ${IP}
$ ip route replace default via ${IP}
$ ping 8.8.8.8
...

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/Kconfig   |   1 +
 drivers/net/mhi/net.c | 123 ++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 101 insertions(+), 23 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 4da68ba..30d6e2f 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -431,6 +431,7 @@ config VSOCKMON
 config MHI_NET
 	tristate "MHI network driver"
 	depends on MHI_BUS
+	select WWAN_CORE
 	help
 	  This is the network driver for MHI bus.  It can be used with
 	  QCOM based WWAN modems (like SDX55).  Say Y or M.
diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index 0d8293a..64af1e5 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -11,6 +11,7 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/u64_stats_sync.h>
+#include <linux/wwan.h>
 
 #include "mhi.h"
 
@@ -18,6 +19,12 @@
 #define MHI_NET_MAX_MTU		0xffff
 #define MHI_NET_DEFAULT_MTU	0x4000
 
+/* When set to false, the default netdev (link 0) is not created, and it's up
+ * to user to create the link (via wwan rtnetlink).
+ */
+static bool create_default_iface = true;
+module_param(create_default_iface, bool, 0);
+
 struct mhi_device_info {
 	const char *netname;
 	const struct mhi_net_proto *proto;
@@ -295,32 +302,33 @@ static void mhi_net_rx_refill_work(struct work_struct *work)
 		schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
 }
 
-static struct device_type wwan_type = {
-	.name = "wwan",
-};
-
-static int mhi_net_probe(struct mhi_device *mhi_dev,
-			 const struct mhi_device_id *id)
+static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
+			   struct netlink_ext_ack *extack)
 {
-	const struct mhi_device_info *info = (struct mhi_device_info *)id->driver_data;
-	struct device *dev = &mhi_dev->dev;
+	const struct mhi_device_info *info;
+	struct mhi_device *mhi_dev = ctxt;
 	struct mhi_net_dev *mhi_netdev;
-	struct net_device *ndev;
 	int err;
 
-	ndev = alloc_netdev(sizeof(*mhi_netdev), info->netname,
-			    NET_NAME_PREDICTABLE, mhi_net_setup);
-	if (!ndev)
-		return -ENOMEM;
+	info = (struct mhi_device_info *)mhi_dev->id->driver_data;
+
+	/* For now we only support one link (link context 0), driver must be
+	 * reworked to break 1:1 relationship for net MBIM and to forward setup
+	 * call to rmnet(QMAP) otherwise.
+	 */
+	if (if_id != 0)
+		return -EINVAL;
+
+	if (dev_get_drvdata(&mhi_dev->dev))
+		return -EBUSY;
 
 	mhi_netdev = netdev_priv(ndev);
-	dev_set_drvdata(dev, mhi_netdev);
+
+	dev_set_drvdata(&mhi_dev->dev, mhi_netdev);
 	mhi_netdev->ndev = ndev;
 	mhi_netdev->mdev = mhi_dev;
 	mhi_netdev->skbagg_head = NULL;
 	mhi_netdev->proto = info->proto;
-	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
-	SET_NETDEV_DEVTYPE(ndev, &wwan_type);
 
 	INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
 	u64_stats_init(&mhi_netdev->stats.rx_syncp);
@@ -334,7 +342,10 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	/* Number of transfer descriptors determines size of the queue */
 	mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
 
-	err = register_netdev(ndev);
+	if (extack)
+		err = register_netdevice(ndev);
+	else
+		err = register_netdev(ndev);
 	if (err)
 		goto out_err;
 
@@ -347,23 +358,89 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	return 0;
 
 out_err_proto:
-	unregister_netdev(ndev);
+	unregister_netdevice(ndev);
 out_err:
 	free_netdev(ndev);
 	return err;
 }
 
-static void mhi_net_remove(struct mhi_device *mhi_dev)
+static void mhi_net_dellink(void *ctxt, struct net_device *ndev,
+			    struct list_head *head)
 {
-	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+	struct mhi_device *mhi_dev = ctxt;
 
-	unregister_netdev(mhi_netdev->ndev);
+	if (head)
+		unregister_netdevice_queue(ndev, head);
+	else
+		unregister_netdev(ndev);
 
-	mhi_unprepare_from_transfer(mhi_netdev->mdev);
+	mhi_unprepare_from_transfer(mhi_dev);
 
 	kfree_skb(mhi_netdev->skbagg_head);
 
-	free_netdev(mhi_netdev->ndev);
+	dev_set_drvdata(&mhi_dev->dev, NULL);
+}
+
+const struct wwan_ops mhi_wwan_ops = {
+	.owner = THIS_MODULE,
+	.priv_size = sizeof(struct mhi_net_dev),
+	.setup = mhi_net_setup,
+	.newlink = mhi_net_newlink,
+	.dellink = mhi_net_dellink,
+};
+
+static int mhi_net_probe(struct mhi_device *mhi_dev,
+			 const struct mhi_device_id *id)
+{
+	const struct mhi_device_info *info = (struct mhi_device_info *)id->driver_data;
+	struct mhi_controller *cntrl = mhi_dev->mhi_cntrl;
+	struct net_device *ndev;
+	int err;
+
+	err = wwan_register_ops(&cntrl->mhi_dev->dev, &mhi_wwan_ops, mhi_dev);
+	if (err)
+		return err;
+
+	if (!create_default_iface)
+		return 0;
+
+	/* Create a default interface which is used as either RMNET real-dev,
+	 * MBIM link 0 or ip link 0)
+	 */
+	ndev = alloc_netdev(sizeof(struct mhi_net_dev), info->netname,
+			    NET_NAME_PREDICTABLE, mhi_net_setup);
+	if (!ndev) {
+		err = -ENOMEM;
+		goto err_unregister;
+	}
+
+	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
+
+	err = mhi_net_newlink(mhi_dev, ndev, 0, NULL);
+	if (err)
+		goto err_release;
+
+	return 0;
+
+err_release:
+	free_netdev(ndev);
+err_unregister:
+	wwan_unregister_ops(&cntrl->mhi_dev->dev);
+
+	return err;
+}
+
+static void mhi_net_remove(struct mhi_device *mhi_dev)
+{
+	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+	struct mhi_controller *cntrl = mhi_dev->mhi_cntrl;
+
+	/* rtnetlink takes care of removing remaining links */
+	wwan_unregister_ops(&cntrl->mhi_dev->dev);
+
+	if (create_default_iface)
+		mhi_net_dellink(mhi_dev, mhi_netdev->ndev, NULL);
 }
 
 static const struct mhi_device_info mhi_hwip0 = {
-- 
2.7.4

