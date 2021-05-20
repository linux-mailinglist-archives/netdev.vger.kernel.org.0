Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBE538B038
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 15:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237905AbhETNnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 09:43:22 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3447 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239378AbhETNmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 09:42:45 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fm9mp1rVQzBvJn;
        Thu, 20 May 2021 21:38:34 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 21:41:20 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 20
 May 2021 21:41:19 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: usb: hso: use DEVICE_ATTR_RO macro
Date:   Thu, 20 May 2021 21:41:16 +0800
Message-ID: <20210520134116.36872-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEVICE_ATTR_RO helper instead of plain DEVICE_ATTR,
which makes the code a bit shorter and easier to read.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/usb/hso.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 63e394cafc17..d84258c70d0c 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -457,9 +457,8 @@ static const struct usb_device_id hso_ids[] = {
 MODULE_DEVICE_TABLE(usb, hso_ids);
 
 /* Sysfs attribute */
-static ssize_t hso_sysfs_show_porttype(struct device *dev,
-				       struct device_attribute *attr,
-				       char *buf)
+static ssize_t hsotype_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
 {
 	struct hso_device *hso_dev = dev_get_drvdata(dev);
 	char *port_name;
@@ -505,7 +504,7 @@ static ssize_t hso_sysfs_show_porttype(struct device *dev,
 
 	return sprintf(buf, "%s\n", port_name);
 }
-static DEVICE_ATTR(hsotype, 0444, hso_sysfs_show_porttype, NULL);
+static DEVICE_ATTR_RO(hsotype);
 
 static struct attribute *hso_serial_dev_attrs[] = {
 	&dev_attr_hsotype.attr,
-- 
2.17.1

