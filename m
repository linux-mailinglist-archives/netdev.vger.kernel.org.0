Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9817D388513
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 05:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352947AbhESDBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 23:01:30 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2976 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352943AbhESDB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 23:01:29 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FlHbP60N4zBvbm;
        Wed, 19 May 2021 10:57:21 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 11:00:08 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 19
 May 2021 11:00:07 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ericvh@gmail.com>, <lucho@ionkov.net>, <asmadeus@codewreck.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <v9fs-developer@lists.sourceforge.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net/9p: use DEVICE_ATTR_RO macro
Date:   Wed, 19 May 2021 10:56:39 +0800
Message-ID: <20210519025639.12108-1-yuehaibing@huawei.com>
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
 net/9p/trans_virtio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 93f2f8654882..43339f314a86 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -528,8 +528,8 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	return err;
 }
 
-static ssize_t p9_mount_tag_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
+static ssize_t mount_tag_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
 {
 	struct virtio_chan *chan;
 	struct virtio_device *vdev;
@@ -544,7 +544,7 @@ static ssize_t p9_mount_tag_show(struct device *dev,
 	return tag_len + 1;
 }
 
-static DEVICE_ATTR(mount_tag, 0444, p9_mount_tag_show, NULL);
+static DEVICE_ATTR_RO(mount_tag);
 
 /**
  * p9_virtio_probe - probe for existence of 9P virtio channels
-- 
2.17.1

