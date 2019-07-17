Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E61E96BDE5
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 16:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfGQOMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 10:12:19 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55020 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725936AbfGQOMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 10:12:18 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0EB45297674B0A89FABF;
        Wed, 17 Jul 2019 22:12:12 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Wed, 17 Jul 2019
 22:12:04 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <olteanv@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] net: dsa: sja1105: Add missing spin_unlock
Date:   Wed, 17 Jul 2019 22:12:00 +0800
Message-ID: <20190717141200.46604-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It should call spin_unlock() before return NULL.
Detected by Coccinelle.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: f3097be21bf1 net: ("dsa: sja1105: Add a state machine for RX timestamping")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/dsa/tag_sja1105.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 1d96c9d..26363d7 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -216,6 +216,7 @@ static struct sk_buff
 		if (!skb) {
 			dev_err_ratelimited(dp->ds->dev,
 					    "Failed to copy stampable skb\n");
+			spin_unlock(&sp->data->meta_lock);
 			return NULL;
 		}
 		sja1105_transfer_meta(skb, meta);
-- 
2.7.4


