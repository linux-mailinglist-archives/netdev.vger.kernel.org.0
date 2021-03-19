Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E15534160E
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 07:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbhCSGlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 02:41:01 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14380 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbhCSGk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 02:40:29 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F1vNm38pXz90RD;
        Fri, 19 Mar 2021 14:38:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Fri, 19 Mar 2021 14:40:22 +0800
From:   Daode Huang <huangdaode@huawei.com>
To:     <luobin9@huawei.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 4/4] net: hinic: convert strlcpy to strscpy
Date:   Fri, 19 Mar 2021 14:36:25 +0800
Message-ID: <1616135785-122085-5-git-send-email-huangdaode@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1616135785-122085-1-git-send-email-huangdaode@huawei.com>
References: <1616135785-122085-1-git-send-email-huangdaode@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Usage of strlcpy in linux kernel has been recently
deprecated[1], so convert hinic driver to strscpy

[1] https://lore.kernel.org/lkml/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL
=V6A6G1oUZcprmknw@mail.gmail.com/

Signed-off-by: Daode Huang <huangdaode@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index c340d9a..c7848c3 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -543,8 +543,8 @@ static void hinic_get_drvinfo(struct net_device *netdev,
 	struct hinic_hwif *hwif = hwdev->hwif;
 	int err;
 
-	strlcpy(info->driver, HINIC_DRV_NAME, sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(hwif->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, HINIC_DRV_NAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(hwif->pdev), sizeof(info->bus_info));
 
 	err = hinic_get_mgmt_version(nic_dev, mgmt_ver);
 	if (err)
-- 
2.8.1

