Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828BD47FC43
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 12:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbhL0Liu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 06:38:50 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:54103 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232018AbhL0Liu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 06:38:50 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V.w75wv_1640605121;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V.w75wv_1640605121)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Dec 2021 19:38:47 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH v2] asix: Use min() instead of doing it manually
Date:   Mon, 27 Dec 2021 19:38:39 +0800
Message-Id: <20211227113839.92352-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate following coccicheck warning:

./drivers/net/usb/asix_common.c:545:12-13: WARNING opportunity for
min().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  -Modified commmit message.

 drivers/net/usb/asix_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 71682970be58..da5a7df312d2 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -542,7 +542,7 @@ static int __asix_mdio_write(struct net_device *netdev, int phy_id, int loc,
 out:
 	mutex_unlock(&dev->phy_mutex);
 
-	return ret < 0 ? ret : 0;
+	return min(ret, 0);
 }
 
 void asix_mdio_write(struct net_device *netdev, int phy_id, int loc, int val)
-- 
2.20.1.7.g153144c

