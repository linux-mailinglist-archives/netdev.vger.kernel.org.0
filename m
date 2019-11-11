Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E51F743E
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 13:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKKMoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 07:44:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48371 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfKKMoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 07:44:17 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iU93F-00014m-Ds; Mon, 11 Nov 2019 12:44:13 +0000
From:   Colin King <colin.king@canonical.com>
To:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] cxgb4: remove redundant assignment to hdr_len
Date:   Mon, 11 Nov 2019 12:44:13 +0000
Message-Id: <20191111124413.68782-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable hdr_len is being assigned a value that is never read.
The assignment is redundant and hence can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index e346830ebca9..09059adc3067 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -3810,7 +3810,6 @@ int cxgb4_ethofld_rx_handler(struct sge_rspq *q, const __be64 *rsp,
 				      eosw_txq->state ==
 				      CXGB4_EO_STATE_FLOWC_CLOSE_REPLY) &&
 				     eosw_txq->cidx == eosw_txq->flowc_idx)) {
-				hdr_len = skb->len;
 				flits = DIV_ROUND_UP(skb->len, 8);
 				if (eosw_txq->state ==
 				    CXGB4_EO_STATE_FLOWC_OPEN_REPLY)
-- 
2.20.1

