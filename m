Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF216166EA
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiKBQDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiKBQCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:02:33 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2C82C650
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 09:02:30 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id m29-20020a05600c3b1d00b003c6bf423c71so1613315wms.0
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 09:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uMxPzizBadbscVuJ9Hytv5gqKfIS420ghAxYHWb0bUw=;
        b=RDQbUMAHAXpVl4qzOyditNZiv3b570QEhsJQf4vmblJaLmaPV+uM/grMBl2/XpXEKI
         tVDyMeK5QBhhEWei5MCDvGiNmS6iNmzCgny23r6fxj7GDy88zcK2EHTl1SC2vnxR+iq6
         Q67XAlAA86aVWYXYpDP8KNIUEM+KoHS/uxMlpNNlXYSPGGsi4Yws4rhVooCUXiRap3da
         cPPWjb09LSB3zmcHRkYIedguGb2uqC4KAco7IhOy89E2v+rI1kU8g8NrB0T2Ufkcb7Y0
         nEWdR4ztRTPPCrlsGa7TByyTatA3XNOz1OKDRUEEPcDwd0dRG8Aik6ttD3EUKZ/p36OO
         PVvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uMxPzizBadbscVuJ9Hytv5gqKfIS420ghAxYHWb0bUw=;
        b=oJs2dhAoW5KwtjeB3yzoecGV5NsYYqYSOBZ39A1g2CPRbiwxkYTf3m4TDo2zdhWkvk
         MPYTZ0HT0/jEBb76escb8TzZT00++c7WQNv+ZFoWY1mROXZk5Hd1PbaMqiXg7Ty7excf
         6mMBpitlEjV1VPRiOmCteC/xHAsA0e+FrBeVSrZm/ENSOfVkAUbkdZgPSZHfU4sd284i
         cQiJ/qag8SkgDyGxkRiYKp5eCySwrXBTg/TH4UnxCku6mSeU/zn2Qfio1ctJWuj0QKhb
         Y7dvgbH7rOGtMtgJjk99TJOGsxdJZUJ1wiUI36CbyvNCQHNNIuMrqBmWGbo9LohjBZ3D
         +4hA==
X-Gm-Message-State: ACrzQf0mvgdCsJlMEN3ZyFaVHvTObjBlbMaPW1xYiB6Bd58T92QLKC2C
        hBbPtE3nBBk0anyqGCy9YXUXAoUBaja0FcDW0Yc=
X-Google-Smtp-Source: AMsMyM6EB5ejiYOfVtaOiOwCL96y2XCn47G/7B1N6qnENHb0DE8tmEc/G9K0+Lr1IY16GekpVDvg4w==
X-Received: by 2002:a05:600c:3d8a:b0:3c6:f241:cb36 with SMTP id bi10-20020a05600c3d8a00b003c6f241cb36mr16082973wmb.115.1667404950215;
        Wed, 02 Nov 2022 09:02:30 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id f5-20020a5d64c5000000b0022cd96b3ba6sm17114913wri.90.2022.11.02.09.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:02:29 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v4 11/13] net: devlink: use devlink_port pointer instead of ndo_get_devlink_port
Date:   Wed,  2 Nov 2022 17:02:09 +0100
Message-Id: <20221102160211.662752-12-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221102160211.662752-1-jiri@resnulli.us>
References: <20221102160211.662752-1-jiri@resnulli.us>
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

Use newly introduced devlink_port pointer instead of getting it calling
to ndo_get_devlink_port op.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c   | 12 ++----------
 net/core/net-sysfs.c |  4 ++--
 net/ethtool/ioctl.c  | 11 ++---------
 3 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4a0ba86b86ed..3a454d0045e5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -12505,14 +12505,6 @@ static void __devlink_compat_running_version(struct devlink *devlink,
 	nlmsg_free(msg);
 }
 
-static struct devlink_port *netdev_to_devlink_port(struct net_device *dev)
-{
-	if (!dev->netdev_ops->ndo_get_devlink_port)
-		return NULL;
-
-	return dev->netdev_ops->ndo_get_devlink_port(dev);
-}
-
 void devlink_compat_running_version(struct devlink *devlink,
 				    char *buf, size_t len)
 {
@@ -12558,7 +12550,7 @@ int devlink_compat_phys_port_name_get(struct net_device *dev,
 	 */
 	ASSERT_RTNL();
 
-	devlink_port = netdev_to_devlink_port(dev);
+	devlink_port = dev->devlink_port;
 	if (!devlink_port)
 		return -EOPNOTSUPP;
 
@@ -12574,7 +12566,7 @@ int devlink_compat_switch_id_get(struct net_device *dev,
 	 * devlink_port instance cannot disappear in the middle. No need to take
 	 * any devlink lock as only permanent values are accessed.
 	 */
-	devlink_port = netdev_to_devlink_port(dev);
+	devlink_port = dev->devlink_port;
 	if (!devlink_port || !devlink_port->switch_port)
 		return -EOPNOTSUPP;
 
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 8409d41405df..679b84cc8794 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -532,7 +532,7 @@ static ssize_t phys_port_name_show(struct device *dev,
 	 * returning early without hitting the trylock/restart below.
 	 */
 	if (!netdev->netdev_ops->ndo_get_phys_port_name &&
-	    !netdev->netdev_ops->ndo_get_devlink_port)
+	    !netdev->devlink_port)
 		return -EOPNOTSUPP;
 
 	if (!rtnl_trylock())
@@ -562,7 +562,7 @@ static ssize_t phys_switch_id_show(struct device *dev,
 	 * because recurse is false when calling dev_get_port_parent_id.
 	 */
 	if (!netdev->netdev_ops->ndo_get_port_parent_id &&
-	    !netdev->netdev_ops->ndo_get_devlink_port)
+	    !netdev->devlink_port)
 		return -EOPNOTSUPP;
 
 	if (!rtnl_trylock())
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 57e7238a4136..b6835136c53f 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -44,16 +44,9 @@ struct ethtool_devlink_compat {
 
 static struct devlink *netdev_to_devlink_get(struct net_device *dev)
 {
-	struct devlink_port *devlink_port;
-
-	if (!dev->netdev_ops->ndo_get_devlink_port)
-		return NULL;
-
-	devlink_port = dev->netdev_ops->ndo_get_devlink_port(dev);
-	if (!devlink_port)
+	if (!dev->devlink_port)
 		return NULL;
-
-	return devlink_try_get(devlink_port->devlink);
+	return devlink_try_get(dev->devlink_port->devlink);
 }
 
 /*
-- 
2.37.3

