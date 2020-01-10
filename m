Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00216136738
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 07:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731539AbgAJGN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 01:13:28 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:50116 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725797AbgAJGN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 01:13:27 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 34F0C62BC9EAFBDC0CCB;
        Fri, 10 Jan 2020 14:13:25 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Fri, 10 Jan 2020 14:13:19 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Alex Maftei <amaftei@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] sfc: remove set but not used variable 'nic_data'
Date:   Fri, 10 Jan 2020 06:09:08 +0000
Message-ID: <20200110060908.124241-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/sfc/mcdi_functions.c: In function 'efx_mcdi_ev_init':
drivers/net/ethernet/sfc/mcdi_functions.c:79:28: warning:
 variable 'nic_data' set but not used [-Wunused-but-set-variable]

commit 4438b587fe4b ("sfc: move MCDI event queue management code")
introduces this unused variable.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/sfc/mcdi_functions.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
index f022e2b9e975..8cd9e0d76e85 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.c
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -76,13 +76,10 @@ int efx_mcdi_ev_init(struct efx_channel *channel, bool v1_cut_thru, bool v2)
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_INIT_EVQ_V2_OUT_LEN);
 	size_t entries = channel->eventq.buf.len / EFX_BUF_SIZE;
 	struct efx_nic *efx = channel->efx;
-	struct efx_ef10_nic_data *nic_data;
 	size_t inlen, outlen;
 	dma_addr_t dma_addr;
 	int rc, i;
 
-	nic_data = efx->nic_data;
-
 	/* Fill event queue with all ones (i.e. empty events) */
 	memset(channel->eventq.buf.addr, 0xff, channel->eventq.buf.len);



