Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 679F9F92C6
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfKLOfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:35:50 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:53848 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727149AbfKLOft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 09:35:49 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 59CACBCB7FFD305AFFB8;
        Tue, 12 Nov 2019 22:35:45 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Tue, 12 Nov 2019
 22:35:34 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <richardcochran@gmail.com>, <vincent.cheng.xh@renesas.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] ptp: ptp_clockmatrix: Fix build error
Date:   Tue, 12 Nov 2019 22:35:14 +0800
Message-ID: <20191112143514.10784-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When do randbuilding, we got this warning:

WARNING: unmet direct dependencies detected for PTP_1588_CLOCK
  Depends on [n]: NET [=y] && POSIX_TIMERS [=n]
  Selected by [y]:
  - PTP_1588_CLOCK_IDTCM [=y]

Make PTP_1588_CLOCK_IDTCM depends on PTP_1588_CLOCK to fix this.

Fixes: 3a6ba7dc7799 ("ptp: Add a ptp clock driver for IDT ClockMatrix.")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/ptp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index c48ad23..b45d2b8 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -121,7 +121,7 @@ config PTP_1588_CLOCK_KVM
 
 config PTP_1588_CLOCK_IDTCM
 	tristate "IDT CLOCKMATRIX as PTP clock"
-	select PTP_1588_CLOCK
+	depends on PTP_1588_CLOCK
 	default n
 	help
 	  This driver adds support for using IDT CLOCKMATRIX(TM) as a PTP
-- 
2.7.4


