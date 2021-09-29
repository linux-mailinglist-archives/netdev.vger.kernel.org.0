Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD4641BF62
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 08:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244415AbhI2G6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 02:58:14 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:45050 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229536AbhI2G6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 02:58:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Uq.dnIy_1632898588;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Uq.dnIy_1632898588)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 29 Sep 2021 14:56:29 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next] intel: Simplify bool conversion
Date:   Wed, 29 Sep 2021 14:56:26 +0800
Message-Id: <1632898586-96655-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:
./drivers/net/ethernet/intel/i40e/i40e_xsk.c:229:35-40: WARNING:
conversion to bool not needed here
./drivers/net/ethernet/intel/ice/ice_xsk.c:399:35-40: WARNING:
conversion to bool not needed here

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 6f85879..ea06e95 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -226,7 +226,7 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 	rx_desc->wb.qword1.status_error_len = 0;
 	i40e_release_rx_desc(rx_ring, ntu);
 
-	return count == nb_buffs ? true : false;
+	return count == nb_buffs;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 7682eaa..35b6e81 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -396,7 +396,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 	rx_desc->wb.status_error0 = 0;
 	ice_release_rx_desc(rx_ring, ntu);
 
-	return count == nb_buffs ? true : false;
+	return count == nb_buffs;
 }
 
 /**
-- 
1.8.3.1

