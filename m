Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C558A38B04E
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 15:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237364AbhETNsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 09:48:04 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3448 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237283AbhETNsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 09:48:01 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fm9tn542KzBttQ;
        Thu, 20 May 2021 21:43:45 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 21:46:33 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 20
 May 2021 21:46:32 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <oliver@neukum.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: cdc_ncm: use DEVICE_ATTR_RW macro
Date:   Thu, 20 May 2021 21:46:19 +0800
Message-ID: <20210520134619.36356-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEVICE_ATTR_RW helper instead of plain DEVICE_ATTR,
which makes the code a bit shorter and easier to read.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/usb/cdc_ncm.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index b04055fd1b79..783d6139fdfa 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -192,7 +192,8 @@ static u32 cdc_ncm_check_tx_max(struct usbnet *dev, u32 new_tx)
 	return val;
 }
 
-static ssize_t cdc_ncm_show_min_tx_pkt(struct device *d, struct device_attribute *attr, char *buf)
+static ssize_t min_tx_pkt_show(struct device *d,
+			       struct device_attribute *attr, char *buf)
 {
 	struct usbnet *dev = netdev_priv(to_net_dev(d));
 	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
@@ -200,7 +201,8 @@ static ssize_t cdc_ncm_show_min_tx_pkt(struct device *d, struct device_attribute
 	return sprintf(buf, "%u\n", ctx->min_tx_pkt);
 }
 
-static ssize_t cdc_ncm_show_rx_max(struct device *d, struct device_attribute *attr, char *buf)
+static ssize_t rx_max_show(struct device *d,
+			   struct device_attribute *attr, char *buf)
 {
 	struct usbnet *dev = netdev_priv(to_net_dev(d));
 	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
@@ -208,7 +210,8 @@ static ssize_t cdc_ncm_show_rx_max(struct device *d, struct device_attribute *at
 	return sprintf(buf, "%u\n", ctx->rx_max);
 }
 
-static ssize_t cdc_ncm_show_tx_max(struct device *d, struct device_attribute *attr, char *buf)
+static ssize_t tx_max_show(struct device *d,
+			   struct device_attribute *attr, char *buf)
 {
 	struct usbnet *dev = netdev_priv(to_net_dev(d));
 	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
@@ -216,7 +219,8 @@ static ssize_t cdc_ncm_show_tx_max(struct device *d, struct device_attribute *at
 	return sprintf(buf, "%u\n", ctx->tx_max);
 }
 
-static ssize_t cdc_ncm_show_tx_timer_usecs(struct device *d, struct device_attribute *attr, char *buf)
+static ssize_t tx_timer_usecs_show(struct device *d,
+				   struct device_attribute *attr, char *buf)
 {
 	struct usbnet *dev = netdev_priv(to_net_dev(d));
 	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
@@ -224,7 +228,9 @@ static ssize_t cdc_ncm_show_tx_timer_usecs(struct device *d, struct device_attri
 	return sprintf(buf, "%u\n", ctx->timer_interval / (u32)NSEC_PER_USEC);
 }
 
-static ssize_t cdc_ncm_store_min_tx_pkt(struct device *d,  struct device_attribute *attr, const char *buf, size_t len)
+static ssize_t min_tx_pkt_store(struct device *d,
+				struct device_attribute *attr,
+				const char *buf, size_t len)
 {
 	struct usbnet *dev = netdev_priv(to_net_dev(d));
 	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
@@ -238,7 +244,9 @@ static ssize_t cdc_ncm_store_min_tx_pkt(struct device *d,  struct device_attribu
 	return len;
 }
 
-static ssize_t cdc_ncm_store_rx_max(struct device *d,  struct device_attribute *attr, const char *buf, size_t len)
+static ssize_t rx_max_store(struct device *d,
+			    struct device_attribute *attr,
+			    const char *buf, size_t len)
 {
 	struct usbnet *dev = netdev_priv(to_net_dev(d));
 	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
@@ -251,7 +259,9 @@ static ssize_t cdc_ncm_store_rx_max(struct device *d,  struct device_attribute *
 	return len;
 }
 
-static ssize_t cdc_ncm_store_tx_max(struct device *d,  struct device_attribute *attr, const char *buf, size_t len)
+static ssize_t tx_max_store(struct device *d,
+			    struct device_attribute *attr,
+			    const char *buf, size_t len)
 {
 	struct usbnet *dev = netdev_priv(to_net_dev(d));
 	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
@@ -264,7 +274,9 @@ static ssize_t cdc_ncm_store_tx_max(struct device *d,  struct device_attribute *
 	return len;
 }
 
-static ssize_t cdc_ncm_store_tx_timer_usecs(struct device *d,  struct device_attribute *attr, const char *buf, size_t len)
+static ssize_t tx_timer_usecs_store(struct device *d,
+				    struct device_attribute *attr,
+				    const char *buf, size_t len)
 {
 	struct usbnet *dev = netdev_priv(to_net_dev(d));
 	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
@@ -285,10 +297,10 @@ static ssize_t cdc_ncm_store_tx_timer_usecs(struct device *d,  struct device_att
 	return len;
 }
 
-static DEVICE_ATTR(min_tx_pkt, 0644, cdc_ncm_show_min_tx_pkt, cdc_ncm_store_min_tx_pkt);
-static DEVICE_ATTR(rx_max, 0644, cdc_ncm_show_rx_max, cdc_ncm_store_rx_max);
-static DEVICE_ATTR(tx_max, 0644, cdc_ncm_show_tx_max, cdc_ncm_store_tx_max);
-static DEVICE_ATTR(tx_timer_usecs, 0644, cdc_ncm_show_tx_timer_usecs, cdc_ncm_store_tx_timer_usecs);
+static DEVICE_ATTR_RW(min_tx_pkt);
+static DEVICE_ATTR_RW(rx_max);
+static DEVICE_ATTR_RW(tx_max);
+static DEVICE_ATTR_RW(tx_timer_usecs);
 
 static ssize_t ndp_to_end_show(struct device *d, struct device_attribute *attr, char *buf)
 {
-- 
2.17.1

