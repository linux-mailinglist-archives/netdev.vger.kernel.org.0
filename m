Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDEB4673F3
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 10:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379687AbhLCJ3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 04:29:18 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15695 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379605AbhLCJ3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 04:29:11 -0500
Received: from kwepemi500007.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J56n21kQ5zZdMy;
        Fri,  3 Dec 2021 17:23:02 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500007.china.huawei.com (7.221.188.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 17:25:46 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 17:25:40 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 05/11] net: hns3: modify one argument type of function hclge_ncl_config_data_print
Date:   Fri, 3 Dec 2021 17:20:53 +0800
Message-ID: <20211203092059.24947-6-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203092059.24947-1-huangguangbin2@huawei.com>
References: <20211203092059.24947-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The argument len will not be changed in hclge_ncl_config_data_print(), it
is no need to declare as a pointer, so modify it into int type.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 1d039e18dd72..1579ca336d06 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1764,7 +1764,7 @@ hclge_dbg_get_imp_stats_info(struct hclge_dev *hdev, char *buf, int len)
 #define HCLGE_MAX_NCL_CONFIG_LENGTH	16384
 
 static void hclge_ncl_config_data_print(struct hclge_desc *desc, int *index,
-					char *buf, int *len, int *pos)
+					char *buf, int len, int *pos)
 {
 #define HCLGE_CMD_DATA_NUM		6
 
@@ -1776,7 +1776,7 @@ static void hclge_ncl_config_data_print(struct hclge_desc *desc, int *index,
 			if (i == 0 && j == 0)
 				continue;
 
-			*pos += scnprintf(buf + *pos, *len - *pos,
+			*pos += scnprintf(buf + *pos, len - *pos,
 					  "0x%04x | 0x%08x\n", offset,
 					  le32_to_cpu(desc[i].data[j]));
 
@@ -1814,7 +1814,7 @@ hclge_dbg_dump_ncl_config(struct hclge_dev *hdev, char *buf, int len)
 		if (ret)
 			return ret;
 
-		hclge_ncl_config_data_print(desc, &index, buf, &len, &pos);
+		hclge_ncl_config_data_print(desc, &index, buf, len, &pos);
 	}
 
 	return 0;
-- 
2.33.0

