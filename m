Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA36C3884D6
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 04:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbhESCkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 22:40:14 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3019 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbhESCkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 22:40:13 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FlH631GTjzNykh;
        Wed, 19 May 2021 10:35:23 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 10:38:52 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 19
 May 2021 10:38:52 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] tun: use DEVICE_ATTR_RO macro
Date:   Wed, 19 May 2021 10:38:50 +0800
Message-ID: <20210519023850.256-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEVICE_ATTR_RO helper instead of plain DEVICE_ATTR,
which makes the code a bit shorter and easier to read.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/tun.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 84f832806313..2ced021f4faf 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2559,15 +2559,15 @@ static int tun_flags(struct tun_struct *tun)
 	return tun->flags & (TUN_FEATURES | IFF_PERSIST | IFF_TUN | IFF_TAP);
 }
 
-static ssize_t tun_show_flags(struct device *dev, struct device_attribute *attr,
+static ssize_t tun_flags_show(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
 	struct tun_struct *tun = netdev_priv(to_net_dev(dev));
 	return sprintf(buf, "0x%x\n", tun_flags(tun));
 }
 
-static ssize_t tun_show_owner(struct device *dev, struct device_attribute *attr,
-			      char *buf)
+static ssize_t owner_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
 {
 	struct tun_struct *tun = netdev_priv(to_net_dev(dev));
 	return uid_valid(tun->owner)?
@@ -2576,8 +2576,8 @@ static ssize_t tun_show_owner(struct device *dev, struct device_attribute *attr,
 		sprintf(buf, "-1\n");
 }
 
-static ssize_t tun_show_group(struct device *dev, struct device_attribute *attr,
-			      char *buf)
+static ssize_t group_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
 {
 	struct tun_struct *tun = netdev_priv(to_net_dev(dev));
 	return gid_valid(tun->group) ?
@@ -2586,9 +2586,9 @@ static ssize_t tun_show_group(struct device *dev, struct device_attribute *attr,
 		sprintf(buf, "-1\n");
 }
 
-static DEVICE_ATTR(tun_flags, 0444, tun_show_flags, NULL);
-static DEVICE_ATTR(owner, 0444, tun_show_owner, NULL);
-static DEVICE_ATTR(group, 0444, tun_show_group, NULL);
+static DEVICE_ATTR_RO(tun_flags);
+static DEVICE_ATTR_RO(owner);
+static DEVICE_ATTR_RO(group);
 
 static struct attribute *tun_dev_attrs[] = {
 	&dev_attr_tun_flags.attr,
-- 
2.17.1

