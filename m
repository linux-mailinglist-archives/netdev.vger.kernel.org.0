Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456FB1EC86F
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 06:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgFCE2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 00:28:23 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:31608 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgFCE2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 00:28:22 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0534SFD5004350;
        Tue, 2 Jun 2020 21:28:16 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net] crypto/chcr: error seen if CONFIG_CHELSIO_TLS_DEVICE isn't set
Date:   Wed,  3 Jun 2020 09:58:13 +0530
Message-Id: <20200603042813.21914-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cxgb4_uld_in_use() is used only by cxgb4_ktls_det_feature() which
is under CONFIG_CHELSIO_TLS_DEVICE macro.

Fixes: a3ac249a1ab5 ("cxgb4/chcr: Enable ktls settings at run time")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index 0307e9c69a47..08439e215efe 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -663,6 +663,7 @@ static int uld_attach(struct adapter *adap, unsigned int uld)
 	return 0;
 }
 
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
 static bool cxgb4_uld_in_use(struct adapter *adap)
 {
 	const struct tid_info *t = &adap->tids;
@@ -670,7 +671,6 @@ static bool cxgb4_uld_in_use(struct adapter *adap)
 	return (atomic_read(&t->conns_in_use) || t->stids_in_use);
 }
 
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
 /* cxgb4_set_ktls_feature: request FW to enable/disable ktls settings.
  * @adap: adapter info
  * @enable: 1 to enable / 0 to disable ktls settings.
-- 
2.18.1

