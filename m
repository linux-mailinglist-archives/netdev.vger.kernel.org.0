Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778892EA576
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 07:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbhAEGc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 01:32:28 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:10386 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbhAEGc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 01:32:28 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4D92gc03glz7QZg;
        Tue,  5 Jan 2021 14:30:52 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.498.0; Tue, 5 Jan 2021
 14:31:36 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <jerry.lilijun@huawei.com>, <xudingke@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net v2] macvlan: remove redundant null check on data
Date:   Tue, 5 Jan 2021 14:31:34 +0800
Message-ID: <1609828294-6284-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.243.127]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

Because macvlan_common_newlink() and macvlan_changelink() already
checked NULL data parameter, so the additional check is unnecessary,
just remove it.

Fixes: 79cf79abce71 ("macvlan: add source mode")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
v2:
  * change code styles and commit log suggested by Jakub Kicinski
---
 drivers/net/macvlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index fb51329f8964..9a9a5cf36a4b 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1385,7 +1385,7 @@ static int macvlan_changelink_sources(struct macvlan_dev *vlan, u32 mode,
 				return ret;
 		}
 
-		if (!data || !data[IFLA_MACVLAN_MACADDR_DATA])
+		if (!data[IFLA_MACVLAN_MACADDR_DATA])
 			return 0;
 
 		head = nla_data(data[IFLA_MACVLAN_MACADDR_DATA]);
-- 
2.23.0

