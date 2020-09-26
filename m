Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E5E279755
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 08:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgIZGtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 02:49:39 -0400
Received: from m17618.mail.qiye.163.com ([59.111.176.18]:11581 "EHLO
        m17618.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgIZGth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 02:49:37 -0400
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by m17618.mail.qiye.163.com (Hmail) with ESMTPA id BCF124E1403;
        Sat, 26 Sep 2020 14:49:32 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: Use kobj_to_dev() API
Date:   Sat, 26 Sep 2020 14:49:18 +0800
Message-Id: <1601102960-8322-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZS01LGUhOH01KHxpNVkpNS0pKS0lCTEhKT0lVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OSo6Hww*AT8vCgEOS08rGTNR
        Oi8aC05VSlVKTUtKSktJQkxITk9MVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFKQk5DNwY+
X-HM-Tid: 0a74c92c88689376kuwsbcf124e1403
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kobj_to_dev() instead of container_of().

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/phy/spi_ks8995.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/spi_ks8995.c b/drivers/net/phy/spi_ks8995.c
index 7475cef..ca49c1a
--- a/drivers/net/phy/spi_ks8995.c
+++ b/drivers/net/phy/spi_ks8995.c
@@ -300,7 +300,7 @@ static ssize_t ks8995_registers_read(struct file *filp, struct kobject *kobj,
 	struct device *dev;
 	struct ks8995_switch *ks8995;
 
-	dev = container_of(kobj, struct device, kobj);
+	dev = kobj_to_dev(kobj);
 	ks8995 = dev_get_drvdata(dev);
 
 	return ks8995_read(ks8995, buf, off, count);
@@ -312,7 +312,7 @@ static ssize_t ks8995_registers_write(struct file *filp, struct kobject *kobj,
 	struct device *dev;
 	struct ks8995_switch *ks8995;
 
-	dev = container_of(kobj, struct device, kobj);
+	dev = kobj_to_dev(kobj);
 	ks8995 = dev_get_drvdata(dev);
 
 	return ks8995_write(ks8995, buf, off, count);
-- 
2.7.4

