Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F4D29D659
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731197AbgJ1WON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:14:13 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6661 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731162AbgJ1WOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:14:01 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CLh5c4Qw1z15NSX;
        Wed, 28 Oct 2020 16:08:04 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Wed, 28 Oct 2020 16:07:51 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] net: wan: sdla: Use bitwise instead of arithmetic
Date:   Wed, 28 Oct 2020 16:19:51 +0800
Message-ID: <1603873191-106077-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccinelle warnings:

./drivers/net/wan/sdla.c:841:38-39: WARNING: sum of probable bitmasks, consider |

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/net/wan/sdla.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/sdla.c b/drivers/net/wan/sdla.c
index bc2c1c7..cf43f4c 100644
--- a/drivers/net/wan/sdla.c
+++ b/drivers/net/wan/sdla.c
@@ -838,7 +838,8 @@ static void sdla_receive(struct net_device *dev)
 		case SDLA_S502A:
 		case SDLA_S502E:
 			if (success)
-				__sdla_read(dev, SDLA_502_RCV_BUF + SDLA_502_DATA_OFS, skb_put(skb,len), len);
+				__sdla_read(dev, SDLA_502_RCV_BUF | SDLA_502_DATA_OFS,
+					    skb_put(skb, len), len);
 
 			SDLA_WINDOW(dev, SDLA_502_RCV_BUF);
 			cmd->opp_flag = 0;
-- 
2.6.2

