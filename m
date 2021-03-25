Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB587348AF5
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhCYIBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:01:08 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13694 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhCYIAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 04:00:36 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F5csf6xDGznVJy;
        Thu, 25 Mar 2021 15:57:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Mar 2021 16:00:29 +0800
From:   Daode Huang <huangdaode@huawei.com>
To:     <csully@google.com>, <sagis@google.com>, <jonolson@google.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <awogbemila@google.com>,
        <yangchun@google.com>, <kuozhao@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 1/2] net: gve: convert strlcpy to strscpy
Date:   Thu, 25 Mar 2021 15:56:31 +0800
Message-ID: <1616658992-135804-2-git-send-email-huangdaode@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1616658992-135804-1-git-send-email-huangdaode@huawei.com>
References: <1616658992-135804-1-git-send-email-huangdaode@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Usage of strlcpy in linux kernel has been recently deprecated[1], so
convert gve driver to strscpy

[1] https://lore.kernel.org/lkml/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL
=V6A6G1oUZcprmknw@mail.gmail.com/

Signed-off-by: Daode Huang <huangdaode@huawei.com>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 0901fa6..e40e052 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -14,9 +14,9 @@ static void gve_get_drvinfo(struct net_device *netdev,
 {
 	struct gve_priv *priv = netdev_priv(netdev);
 
-	strlcpy(info->driver, "gve", sizeof(info->driver));
-	strlcpy(info->version, gve_version_str, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(priv->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, "gve", sizeof(info->driver));
+	strscpy(info->version, gve_version_str, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(priv->pdev), sizeof(info->bus_info));
 }
 
 static void gve_set_msglevel(struct net_device *netdev, u32 value)
-- 
2.8.1

