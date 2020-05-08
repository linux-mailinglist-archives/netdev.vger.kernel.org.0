Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E601CBAFB
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 00:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgEHW6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 18:58:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54071 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgEHW6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 18:58:14 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jXBwY-0003Ra-MI; Fri, 08 May 2020 22:58:10 +0000
From:   Colin King <colin.king@canonical.com>
To:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: lio_core: remove redundant assignment to variable tx_done
Date:   Fri,  8 May 2020 23:58:10 +0100
Message-Id: <20200508225810.484331-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable tx_done is being assigned with a value that is never read
as the function returns a few statements later.  The assignment is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/cavium/liquidio/lio_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
index d7e805749a5b..e40c64b79f66 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
@@ -782,7 +782,6 @@ static int liquidio_napi_poll(struct napi_struct *napi, int budget)
 	if ((work_done < budget && tx_done) ||
 	    (iq && iq->pkt_in_done >= MAX_REG_CNT) ||
 	    (droq->pkt_count >= MAX_REG_CNT)) {
-		tx_done = 1;
 		napi_complete_done(napi, work_done);
 
 		octeon_enable_irq(droq->oct_dev, droq->q_no);
-- 
2.25.1

