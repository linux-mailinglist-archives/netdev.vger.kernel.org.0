Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5812F434E
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbhAMEoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:44:02 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:63689 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbhAMEoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 23:44:02 -0500
Received: from heptagon.blr.asicdesigners.com (heptagon.blr.asicdesigners.com [10.193.186.108])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 10D4h8xq031936;
        Tue, 12 Jan 2021 20:43:09 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net] ch_ipsec: Remove initialization of rxq related data
Date:   Wed, 13 Jan 2021 10:13:02 +0530
Message-Id: <20210113044302.25522-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0.rc1.6.gae46588
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removing initialization of nrxq and rxq_size in uld_info. As
ipsec uses nic queues only, there is no need to create uld
rx queues for ipsec.

Fixes: 1b77be463929e ("crypto/chcr: Moving chelsio's inline ipsec functionality to /drivers/net")
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 .../net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c   | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
index 47d9268a7e3c..585590520076 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
@@ -92,9 +92,6 @@ static const struct xfrmdev_ops ch_ipsec_xfrmdev_ops = {
 
 static struct cxgb4_uld_info ch_ipsec_uld_info = {
 	.name = CHIPSEC_DRV_MODULE_NAME,
-	.nrxq = MAX_ULD_QSETS,
-	/* Max ntxq will be derived from fw config file*/
-	.rxq_size = 1024,
 	.add = ch_ipsec_uld_add,
 	.state_change = ch_ipsec_uld_state_change,
 	.tx_handler = ch_ipsec_xmit,
-- 
2.28.0.rc1.6.gae46588

