Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF41465F2C
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 09:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355888AbhLBIR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 03:17:28 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:28886 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238808AbhLBIR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 03:17:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638432845; x=1669968845;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oe7zcoowQgEHVGpjtJfI6TDyuWQjuKKi7fuPLhWieJ8=;
  b=2AdX8bhn16P2XBI/moTJnsOKWBB1eHQ6d++7D+g+YRLPW4NQkTzBYyk4
   IFAKjjimmRo1lhU8qOBdkY4bStVsf1Z5bLp3I0f5ZNlroWh6Ps0pUGd+8
   LEXQECGhU8AuG2L7G5dVAvrimZeiUGAgRJQ04fDar7t14PP+/8JoAuPOD
   T0KnalWD+1JSJwg3fq/VBrQmH+cqeWAsxaqADnXBaLC960pFJwnfTD5zF
   S44J6z3Ytf/bNA3fzEPo3xT9oYs7fuefz4QVBIxrohzhVPZs4flE3Nvtd
   ZV4O6Imf8A+s60l8kE1/OzPcGFFl9u9wtHrO9QKCmmJvQb25p4Wb24mmJ
   A==;
IronPort-SDR: 2oTRgjLKN7YMqT4l/f1sc9bSc0YuDg2cUh1NV92VJ6NYNfK7koNUl6JG0Zd2wYP+Y7LwQOiW2u
 iP/wiTs7wmQW/93WDu/y4aCpukC/QsUInpHqv9H8hQ2ib7NoykfvWw+9xk67fCkIxuxAOi8B26
 ny87rDtstboiknpuf2ucL2yYhRJCXD//zgaiPNj23XqA9aP5wuo/HECh6nsKpzU69nQ+7VcluR
 CM2k4/Gf4pC44BqHwX1vaNzzaNm9KUGVAPTEZ9a2TTVkBi2y4uhjMISGyRu1+h/H/NpbsmfuVk
 K7lwmT5K/DUwiw623PMtFLXU
X-IronPort-AV: E=Sophos;i="5.87,281,1631602800"; 
   d="scan'208";a="153979466"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Dec 2021 01:14:04 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 2 Dec 2021 01:14:04 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 2 Dec 2021 01:14:02 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <rdunlap@infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] net: lan966x: Fix builds for lan966x driver
Date:   Thu, 2 Dec 2021 09:15:11 +0100
Message-ID: <20211202081511.409564-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The lan966x is using the function 'packing' to create/extract the
information for the IFH, that is used to be added in front of the frames
when they are injected/extracted.
Therefore update the Kconfig to select config option 'PACKING' whenever
lan966x driver is enabled.

Fixes: db8bcaad539314 ("net: lan966x: add the basic lan966x driver")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/Kconfig b/drivers/net/ethernet/microchip/lan966x/Kconfig
index 83ac4266b417..2860a8c9923d 100644
--- a/drivers/net/ethernet/microchip/lan966x/Kconfig
+++ b/drivers/net/ethernet/microchip/lan966x/Kconfig
@@ -3,5 +3,6 @@ config LAN966X_SWITCH
 	depends on HAS_IOMEM
 	depends on OF
 	select PHYLINK
+	select PACKING
 	help
 	  This driver supports the Lan966x network switch device.
-- 
2.33.0

