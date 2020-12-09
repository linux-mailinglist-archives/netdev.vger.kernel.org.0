Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CB32D3EB2
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbgLIJ0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:26:47 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9139 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728772AbgLIJ0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:26:43 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CrWqX5xz5z15Vwk;
        Wed,  9 Dec 2020 17:25:28 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 17:25:53 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <olteanv@gmail.com>, Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: dsa: simplify the return rtl8366_vlan_prepare()
Date:   Wed, 9 Dec 2020 17:26:21 +0800
Message-ID: <20201209092621.20523-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/dsa/rtl8366.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 307466b90489..83d481ef9273 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -384,7 +384,6 @@ int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
 {
 	struct realtek_smi *smi = ds->priv;
 	u16 vid;
-	int ret;
 
 	for (vid = vlan->vid_begin; vid < vlan->vid_end; vid++)
 		if (!smi->ops->is_vlan_valid(smi, vid))
@@ -397,11 +396,7 @@ int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
 	 * FIXME: what's with this 4k business?
 	 * Just rtl8366_enable_vlan() seems inconclusive.
 	 */
-	ret = rtl8366_enable_vlan4k(smi, true);
-	if (ret)
-		return ret;
-
-	return 0;
+	return rtl8366_enable_vlan4k(smi, true);
 }
 EXPORT_SYMBOL_GPL(rtl8366_vlan_prepare);
 
-- 
2.22.0

