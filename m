Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BF830ED56
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 08:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbhBDH2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 02:28:19 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12416 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234165AbhBDH2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 02:28:15 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DWVTv5Hb4zjHZh;
        Thu,  4 Feb 2021 15:26:27 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 4 Feb 2021 15:27:23 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <gerrit@erg.abdn.ac.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <dccp@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] dccp: Return the correct errno code
Date:   Thu, 4 Feb 2021 15:28:20 +0800
Message-ID: <20210204072820.17723-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/dccp/feat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dccp/feat.c b/net/dccp/feat.c
index 788dd629c420..4cb813bee7b4 100644
--- a/net/dccp/feat.c
+++ b/net/dccp/feat.c
@@ -371,7 +371,7 @@ static int dccp_feat_clone_sp_val(dccp_feat_val *fval, u8 const *val, u8 len)
 		fval->sp.vec = kmemdup(val, len, gfp_any());
 		if (fval->sp.vec == NULL) {
 			fval->sp.len = 0;
-			return -ENOBUFS;
+			return -ENOMEM;
 		}
 	}
 	return 0;
-- 
2.22.0

