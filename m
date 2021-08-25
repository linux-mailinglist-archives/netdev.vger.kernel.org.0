Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C84F3F7D90
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 23:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhHYVSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 17:18:24 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:59380 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbhHYVSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 17:18:23 -0400
Received: (qmail 43948 invoked by uid 89); 25 Aug 2021 21:17:34 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 25 Aug 2021 21:17:34 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@kernel.org,
        rdunlap@infradead.org, richardcochran@gmail.com, kernel-team@fb.com
Subject: [PATCH net-next] ptp: ocp: Simplify Kconfig.
Date:   Wed, 25 Aug 2021 14:17:33 -0700
Message-Id: <20210825211733.264844-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the 'imply' statements, these apparently are not doing
what I expected.  Platform modules which are used by the driver
still need to be enabled in the overall config for them to be
used, but there isn't a hard dependency on them.

Use 'depend' for selectable modules which provide functions
used directly by the driver.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/Kconfig | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 32660dc11354..f02bedf41264 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -171,16 +171,10 @@ config PTP_1588_CLOCK_OCP
 	tristate "OpenCompute TimeCard as PTP clock"
 	depends on PTP_1588_CLOCK
 	depends on HAS_IOMEM && PCI
-	depends on SPI && I2C && MTD
+	depends on I2C && MTD
+	depends on SERIAL_8250
 	depends on !S390
-	imply SPI_MEM
-	imply SPI_XILINX
-	imply MTD_SPI_NOR
-	imply I2C_XILINX
-	select SERIAL_8250
 	select NET_DEVLINK
-
-	default n
 	help
 	  This driver adds support for an OpenCompute time card.
 
-- 
2.31.1

