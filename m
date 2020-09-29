Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8364827D4BF
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730214AbgI2Roo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:44:44 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:31337 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730165AbgI2Ron (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 13:44:43 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 08THiVJx024825;
        Tue, 29 Sep 2020 10:44:38 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net-next v3 2/3] cxgb4: Avoid log flood
Date:   Tue, 29 Sep 2020 23:14:24 +0530
Message-Id: <20200929174425.12256-3-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200929174425.12256-1-rohitm@chelsio.com>
References: <20200929174425.12256-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changing these logs to dynamic debugs. If issue is seen, these
logs can be enabled at run time.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index b154190e1ee2..743af9e654aa 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -690,8 +690,8 @@ int cxgb4_set_ktls_feature(struct adapter *adap, bool enable)
 			 * ULD is/are already active, return failure.
 			 */
 			if (cxgb4_uld_in_use(adap)) {
-				dev_warn(adap->pdev_dev,
-					 "ULD connections (tid/stid) active. Can't enable kTLS\n");
+				dev_dbg(adap->pdev_dev,
+					"ULD connections (tid/stid) active. Can't enable kTLS\n");
 				return -EINVAL;
 			}
 			ret = t4_set_params(adap, adap->mbox, adap->pf,
@@ -699,7 +699,7 @@ int cxgb4_set_ktls_feature(struct adapter *adap, bool enable)
 			if (ret)
 				return ret;
 			refcount_set(&adap->chcr_ktls.ktls_refcount, 1);
-			pr_info("kTLS has been enabled. Restrictions placed on ULD support\n");
+			pr_debug("kTLS has been enabled. Restrictions placed on ULD support\n");
 		} else {
 			/* ktls settings already up, just increment refcount. */
 			refcount_inc(&adap->chcr_ktls.ktls_refcount);
@@ -716,7 +716,7 @@ int cxgb4_set_ktls_feature(struct adapter *adap, bool enable)
 					    0, 1, &params, &params);
 			if (ret)
 				return ret;
-			pr_info("kTLS is disabled. Restrictions on ULD support removed\n");
+			pr_debug("kTLS is disabled. Restrictions on ULD support removed\n");
 		}
 	}
 
-- 
2.18.1

