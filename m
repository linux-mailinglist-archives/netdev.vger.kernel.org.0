Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E32305A63
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 12:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237412AbhA0LxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 06:53:10 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11203 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237209AbhA0Lvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 06:51:40 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DQhj13GF9zl9Dw;
        Wed, 27 Jan 2021 19:49:25 +0800 (CST)
Received: from localhost (10.174.242.175) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Wed, 27 Jan 2021
 19:50:46 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <jerry.lilijun@huawei.com>, <xudingke@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] ice: remove redundant null check on pf
Date:   Wed, 27 Jan 2021 19:50:44 +0800
Message-ID: <1611748244-20592-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.242.175]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

Before calling ice_set_dflt_mib(), the 'pf' has been dereferenced.
So the additional check is unnecessary, just remove it.

Addresses-Coverity: ("Dereference before null check")
Fixes: 7d9c9b791f9e ("ice: Implement LFC workaround")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6e251dfffc91..43117cb4ef18 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -788,11 +788,6 @@ static void ice_set_dflt_mib(struct ice_pf *pf)
 	struct ice_hw *hw;
 	u32 ouisubtype;
 
-	if (!pf) {
-		dev_dbg(dev, "%s NULL pf pointer\n", __func__);
-		return;
-	}
-
 	hw = &pf->hw;
 	mib_type = SET_LOCAL_MIB_TYPE_LOCAL_MIB;
 	lldpmib = kzalloc(ICE_LLDPDU_SIZE, GFP_KERNEL);
-- 
2.23.0

