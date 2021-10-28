Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC45B43E4F0
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhJ1PW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:22:57 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:34515 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhJ1PW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 11:22:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635434429; x=1666970429;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pB94F49cLE1n12c0Q4SMAlRXHilmqBw3Nn4cCVMwer4=;
  b=PVjhQAYpDo2MuTRlUSa8VXPRtXRUvPc95Gb9PN8bKHqMDzxA4gc1GNff
   FJ7u/mmnMYcXFx1FWUxLn7f4GNK/XRgepBo8iTbCHA6W5tMh5dpai2mfO
   1GnUnwHvPaOLg8+zqWnsojm/gzrKl0BeomobvEPBeysb78KwtAr4/mEJ9
   ocPrBYMOvYUOKqqMSsC8NqYf4LR1v+x6Ub/MVHR9jPRSilmSrPywOBC8M
   tC9TH9484q9dGEuiKfZeAes8cmFlpuYZX3kPpUiqYm7Iv7ocP2cURECgV
   wQpWhGgtMMv40lO82yZjk0ji316IdoG+sF8poQVnMEOFwcPjNxBh+XZNw
   Q==;
IronPort-SDR: G/dz1D1EUIn8svg72lWxctCbwnkPkwI6l+9SnlSd/yfAuWhpWJ/QN9XfyGwqmN7P1xvN5h6F6T
 XyH1D+cI/asfGhjBEr8R4yfGssAljC+xfts+JAjEhNKM7QsZLaMrVFxtJnIaCPLznwN5y4Ks4s
 ZnpA41VSnLUBuJ58Beg+nmQNYjM3akqhEDrtwrsXc2gtRlhS6Ud/Z0tMSLSc9MbMtntnCkJeSR
 V5HryOcKvWArMHIPdH6ectyo8NkXGE2RCp106EwdbGzYXTpi9n3281AqCVmglL7N7RYqotO+Ut
 EoDzcXiNVqgWlP3AYaV2IzLQ
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="137208194"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2021 08:20:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 28 Oct 2021 08:20:28 -0700
Received: from validation1-XPS-8900.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 28 Oct 2021 08:20:27 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <bryan.whitehead@microchip.com>, <UNGLinuxDriver@microchip.com>,
        "Yuiko Oshino" <yuiko.oshino@microchip.com>
Subject: [PATCH net-next] net: ethernet: microchip: lan743x: Increase rx ring size to improve rx performance
Date:   Thu, 28 Oct 2021 11:21:05 -0400
Message-ID: <20211028152105.19467-1-yuiko.oshino@microchip.com>
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

