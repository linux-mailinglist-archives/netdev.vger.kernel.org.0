Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D78399E64
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 12:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhFCKEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 06:04:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7088 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbhFCKEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 06:04:42 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FwhGM2hmkzYqN9;
        Thu,  3 Jun 2021 18:00:11 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 18:02:44 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 18:02:43 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] can: at91_can: use DEVICE_ATTR_RW() helper macro
Date:   Thu, 3 Jun 2021 18:02:33 +0800
Message-ID: <20210603100233.11877-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEVICE_ATTR_RW() helper macro instead of plain DEVICE_ATTR(), which
makes the code a bit shorter and easier to read.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/net/can/at91_can.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 04d0bb3ffe89661..ca736b26e218ca4 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -1176,8 +1176,8 @@ static const struct net_device_ops at91_netdev_ops = {
 	.ndo_change_mtu = can_change_mtu,
 };
 
-static ssize_t at91_sysfs_show_mb0_id(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t mb0_id_show(struct device *dev,
+			   struct device_attribute *attr, char *buf)
 {
 	struct at91_priv *priv = netdev_priv(to_net_dev(dev));
 
@@ -1187,8 +1187,8 @@ static ssize_t at91_sysfs_show_mb0_id(struct device *dev,
 		return snprintf(buf, PAGE_SIZE, "0x%03x\n", priv->mb0_id);
 }
 
-static ssize_t at91_sysfs_set_mb0_id(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
+static ssize_t mb0_id_store(struct device *dev,
+			    struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct net_device *ndev = to_net_dev(dev);
 	struct at91_priv *priv = netdev_priv(ndev);
@@ -1222,7 +1222,7 @@ static ssize_t at91_sysfs_set_mb0_id(struct device *dev,
 	return ret;
 }
 
-static DEVICE_ATTR(mb0_id, 0644, at91_sysfs_show_mb0_id, at91_sysfs_set_mb0_id);
+static DEVICE_ATTR_RW(mb0_id);
 
 static struct attribute *at91_sysfs_attrs[] = {
 	&dev_attr_mb0_id.attr,
-- 
2.26.0.106.g9fadedd


