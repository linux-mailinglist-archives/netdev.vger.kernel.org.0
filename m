Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E8E141DD0
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 13:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgASMpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 07:45:50 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:34278 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726778AbgASMpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jan 2020 07:45:49 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 63BC919E2682614D77C0;
        Sun, 19 Jan 2020 20:45:47 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Sun, 19 Jan 2020 20:45:39 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH -next] net: hns3: replace snprintf with scnprintf in hns3_update_strings
Date:   Sun, 19 Jan 2020 20:40:53 +0800
Message-ID: <20200119124053.30262-1-chenzhou10@huawei.com>
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
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 6e0212b..fa01888 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -423,9 +423,8 @@ static void *hns3_update_strings(u8 *data, const struct hns3_stats *stats,
 			data[ETH_GSTRING_LEN - 1] = '\0';
 
 			/* first, prepend the prefix string */
-			n1 = snprintf(data, MAX_PREFIX_SIZE, "%s%d_",
+			n1 = scnprintf(data, MAX_PREFIX_SIZE, "%s%d_",
 				      prefix, i);
-			n1 = min_t(uint, n1, MAX_PREFIX_SIZE - 1);
 			size_left = (ETH_GSTRING_LEN - 1) - n1;
 
 			/* now, concatenate the stats string to it */
-- 
2.7.4

