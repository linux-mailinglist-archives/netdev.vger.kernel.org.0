Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955AC1B08C8
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 14:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgDTMID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 08:08:03 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2413 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725944AbgDTMIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 08:08:02 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BEAFDC9AE20436C7EF10;
        Mon, 20 Apr 2020 20:07:59 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Apr 2020
 20:07:49 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] ptp: Remove unneeded conversion to bool
Date:   Mon, 20 Apr 2020 20:34:31 +0800
Message-ID: <20200420123431.7040-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The '==' expression itself is bool, no need to convert it to bool again.
This fixes the following coccicheck warning:

drivers/ptp/ptp_ines.c:403:55-60: WARNING: conversion to bool not
needed here
drivers/ptp/ptp_ines.c:404:55-60: WARNING: conversion to bool not
needed here

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/ptp/ptp_ines.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ines.c b/drivers/ptp/ptp_ines.c
index dfda54cbd866..52d77db39829 100644
--- a/drivers/ptp/ptp_ines.c
+++ b/drivers/ptp/ptp_ines.c
@@ -400,8 +400,8 @@ static int ines_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 	ines_write32(port, ts_stat_rx, ts_stat_rx);
 	ines_write32(port, ts_stat_tx, ts_stat_tx);
 
-	port->rxts_enabled = ts_stat_rx == TS_ENABLE ? true : false;
-	port->txts_enabled = ts_stat_tx == TS_ENABLE ? true : false;
+	port->rxts_enabled = ts_stat_rx == TS_ENABLE;
+	port->txts_enabled = ts_stat_tx == TS_ENABLE;
 
 	spin_unlock_irqrestore(&port->lock, flags);
 
-- 
2.21.1

