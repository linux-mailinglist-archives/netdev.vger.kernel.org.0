Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD74F38B00A
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 15:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237471AbhETNeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 09:34:05 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3629 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235618AbhETNeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 09:34:05 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fm9bP2NHQzmW7J;
        Thu, 20 May 2021 21:30:25 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 21:32:42 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 20
 May 2021 21:32:41 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <yuehaibing@huawei.com>
CC:     <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] Bluetooth: RFCOMM: Use DEVICE_ATTR_RO macro
Date:   Thu, 20 May 2021 21:32:35 +0800
Message-ID: <20210520133235.32244-1-yuehaibing@huawei.com>
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
 net/bluetooth/rfcomm/tty.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index c76dcc0f679b..4e095746e002 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -198,20 +198,22 @@ static void rfcomm_reparent_device(struct rfcomm_dev *dev)
 	hci_dev_put(hdev);
 }
 
-static ssize_t show_address(struct device *tty_dev, struct device_attribute *attr, char *buf)
+static ssize_t address_show(struct device *tty_dev,
+			    struct device_attribute *attr, char *buf)
 {
 	struct rfcomm_dev *dev = dev_get_drvdata(tty_dev);
 	return sprintf(buf, "%pMR\n", &dev->dst);
 }
 
-static ssize_t show_channel(struct device *tty_dev, struct device_attribute *attr, char *buf)
+static ssize_t channel_show(struct device *tty_dev,
+			    struct device_attribute *attr, char *buf)
 {
 	struct rfcomm_dev *dev = dev_get_drvdata(tty_dev);
 	return sprintf(buf, "%d\n", dev->channel);
 }
 
-static DEVICE_ATTR(address, 0444, show_address, NULL);
-static DEVICE_ATTR(channel, 0444, show_channel, NULL);
+static DEVICE_ATTR_RO(address);
+static DEVICE_ATTR_RO(channel);
 
 static struct rfcomm_dev *__rfcomm_dev_add(struct rfcomm_dev_req *req,
 					   struct rfcomm_dlc *dlc)
-- 
2.17.1

