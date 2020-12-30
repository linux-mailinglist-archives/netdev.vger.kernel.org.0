Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE872E7667
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 07:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgL3GIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 01:08:34 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:50279 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726198AbgL3GIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 01:08:34 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UKD8vsA_1609308452;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UKD8vsA_1609308452)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 30 Dec 2020 14:07:51 +0800
From:   YANG LI <abaci-bugfix@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        YANG LI <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] liquidio: style:  Identical condition and return expression  'retval', return value is always 0.
Date:   Wed, 30 Dec 2020 14:07:30 +0800
Message-Id: <1609308450-50695-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The warning was because of the following line in function
liquidio_set_fec():

retval = wait_for_sc_completion_timeout(oct, sc, 0);
    if (retval)
	return (-EIO);

If this statement is not true, retval must be 0 and not updated
later. So, It is better to return 0 directly.

Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci <abaci@linux.alibaba.com>
---
 drivers/net/ethernet/cavium/liquidio/lio_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
index 37d0641..6e2426f 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
@@ -1747,7 +1747,7 @@ int liquidio_set_fec(struct lio *lio, int on_off)
 			oct->props[lio->ifidx].fec ? "on" : "off");
 	}
 
-	return retval;
+	return 0;
 }
 
 int liquidio_get_fec(struct lio *lio)
-- 
1.8.3.1

