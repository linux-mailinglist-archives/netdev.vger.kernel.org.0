Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C1643E484
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhJ1PFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:05:06 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:57062 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbhJ1PFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 11:05:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635433357; x=1666969357;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KzEXNmitDgGuJgcY9h5RZZw0TNXdOgzZXQtviu5aAX0=;
  b=JMDgVK/t/WHmbg8xyC34DNY60kWlbzxNl+fP6mSw09xuf4DxdvaVJYK3
   G2Qz+UugUznr7ujcxEe6weQs3+ENTsIPkzj8aPcBaf8ywNEhbCZsPIzRv
   SVQYQSlLvjPBVo/39JbQVhYUDE2jj/UR3N+hsg6iDUDkjVgyb/uPr9hWm
   BFeWhBY7wGeDeXymxuHER2ZvSbDY2FyFxt/weOpiyFy0WYBhZrbnoFzaX
   UegqqEet3016JYLPdj+16aOl6ml52Pdd8QGpH6sgoi4uykJWqdZ6aHGzb
   SSJw52StvhzXz/i09r8dMUsBk7NqMXRDdIxnD00n93PE7OBivzfxP9wUX
   Q==;
IronPort-SDR: RyCFiatNvDwMX18sROhvwA2nl7QiddGnrbOFgjycCFF8F54OlXp2RJ/eGdodQ1IdeUDDRsvKkz
 8DGWVY+ekTCn+HGkowOu22u5ndo+wcFNaTVD5de+RSFlsanCGh8EYXUcZ4kfvAZQWKR1iS79L0
 BSaTTnWczChFyL5+CFfMnTUYaMtG579RtPrfpHLHBCVoivNiIddnZwpq2Tr5E8RqhjbX3ba3Y3
 6rJPvBZMmQ06iVGD7+sICc1VmkswTGlXDt7t7YTyj8BVpyLadkJYLCae0h/J7WG/5WXCcp3+mE
 tAPtizDls8Tbh/LAZmbwV42i
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="141421202"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2021 08:02:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 28 Oct 2021 08:02:35 -0700
Received: from validation1-XPS-8900.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 28 Oct 2021 08:02:35 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <bryan.whitehead@microchip.com>, <UNGLinuxDriver@microchip.com>,
        "Yuiko Oshino" <yuiko.oshino@microchip.com>
Subject: [PATCH net] net: ethernet: microchip: lan743x: Increase rx ring size to improve rx performance
Date:   Thu, 28 Oct 2021 11:03:15 -0400
Message-ID: <20211028150315.19270-1-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increase the rx ring size (LAN743X_RX_RING_SIZE) to improve rx performance on some platforms.
Tested on x86 PC with EVB-LAN7430.
The iperf3.7 TCPIP improved from 881 Mbps to 922 Mbps, and UDP improved from 817 Mbps to 936 Mbps.

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 34c22eea0124..aaf7aaeaba0c 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -831,7 +831,7 @@ struct lan743x_rx_buffer_info {
 	unsigned int    buffer_length;
 };
 
-#define LAN743X_RX_RING_SIZE        (65)
+#define LAN743X_RX_RING_SIZE        (128)
 
 #define RX_PROCESS_RESULT_NOTHING_TO_DO     (0)
 #define RX_PROCESS_RESULT_BUFFER_RECEIVED   (1)
-- 
2.25.1

