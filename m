Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22C9465096
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 15:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhLAO5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 09:57:55 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:61196 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350065AbhLAO5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 09:57:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638370474; x=1669906474;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0qvWck5Yix73HsfxULTOKRP79t2JigsTEYRwVg5Gvdg=;
  b=ZG/zDOMOabVfG2GrIMDw3zYmqcvLU4U5w6xiYVKqjkGM2Z8DOc1uRENU
   A4IE1IBxVpCl6XCz/BDHQAPtzYQ0zaZAXZZ59HEgGHzsB4SG9GiQP0Z75
   VkfScI2AeiMiGrvT5UEUv16jbgGLLogZ5j154yq5XIb1LYqyzDSFw3ZiT
   zm9SE+tDHT1YfvsDD1SikSSw2YnBK5f2GP+QJmjqVpjG6Fv76Iwz7zl+2
   shylImuxU/vHE5ojf2lO5E/BgtAT0HFHMQuIqPY1z6Fl0zlTI1DVT1MjT
   JnjtnA02rbqkSeQmKa9w25Go/O1BRmsVGcJJ0j02Yzg2gzGizjXwam/yd
   Q==;
IronPort-SDR: gxo3uT2B/bnm9RGb0LowVFeh/JX+LbgIuXlsHrD7FI7LZodTvmMPqd+MRyE2lTaTJIwSIiMuZQ
 wL7PIw8bjH/Wp3rOTzXEdPjrVv9isK9lNUoRWbrzpdCUXKzslJsgQQ1GaIbrGS3Fe0kOa38TFu
 mSoi8TCVjUaU47M7w9LHZ9NCjYtlbG1StIqgOvSwLKHZ3IJV/xQIKDvEUDwnNo9FYC+407c1aA
 +i0f/J3/PjPWPOfO/dqMBQ3w0n2T02aDLSPxcV1Uw7CQ1dhPOtsF1+zYWkh2mOHELB5mrKYO9g
 CQTgAdm+fB5rtplFZ783bJza
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="145139566"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Dec 2021 07:54:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 1 Dec 2021 07:54:29 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 1 Dec 2021 07:54:28 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <dan.carpenter@oracle.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: lan966x: Fix duplicate check in frame extraction
Date:   Wed, 1 Dec 2021 15:53:51 +0100
Message-ID: <20211201145351.152208-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The blamed commit generates the following smatch static checker warning:

 drivers/net/ethernet/microchip/lan966x/lan966x_main.c:515 lan966x_xtr_irq_handler()
         warn: duplicate check 'sz < 0' (previous on line 502)

This patch fixes this issue removing the duplicate check 'sz < 0'

Fixes: d28d6d2e37d10d ("net: lan966x: add port module support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index e9e4dca6542d..be5e2b3a7f43 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -512,11 +512,6 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, void *args)
 			*buf = val;
 		}
 
-		if (sz < 0) {
-			err = sz;
-			break;
-		}
-
 		skb->protocol = eth_type_trans(skb, dev);
 
 		netif_rx_ni(skb);
-- 
2.33.0

