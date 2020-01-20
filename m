Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E68FE142B58
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 13:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbgATMzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 07:55:33 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:59114 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726589AbgATMzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 07:55:33 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 187D3E1941BD55D47292;
        Mon, 20 Jan 2020 20:55:31 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Mon, 20 Jan 2020 20:55:21 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH -next v2] net: hns3: replace snprintf with scnprintf in hns3_update_strings
Date:   Mon, 20 Jan 2020 20:50:33 +0800
Message-ID: <20200120125033.30741-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

snprintf returns the number of bytes that would be written, which may be
greater than the the actual length to be written. Here use extra code to
handle this.

scnprintf returns the number of bytes that was actually written, just use
scnprintf to simplify the code.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---

changes in v2:
- fix checkpatch style problem.

---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 6e0212b..c03856e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -423,9 +423,8 @@ static void *hns3_update_strings(u8 *data, const struct hns3_stats *stats,
 			data[ETH_GSTRING_LEN - 1] = '\0';
 
 			/* first, prepend the prefix string */
-			n1 = snprintf(data, MAX_PREFIX_SIZE, "%s%d_",
-				      prefix, i);
-			n1 = min_t(uint, n1, MAX_PREFIX_SIZE - 1);
+			n1 = scnprintf(data, MAX_PREFIX_SIZE, "%s%d_",
+				       prefix, i);
 			size_left = (ETH_GSTRING_LEN - 1) - n1;
 
 			/* now, concatenate the stats string to it */
-- 
2.7.4

