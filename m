Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D617A50D28C
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 17:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239513AbiDXPA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 11:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239540AbiDXO64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 10:58:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60D3393C7;
        Sun, 24 Apr 2022 07:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1650812156; x=1682348156;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZDgnc/AWZ2GzndkIPVq+n1FwfPAm1cIU+Eo/I6edMr8=;
  b=xYrIR3MrNdU+6i45nG9EjDe0vs4a4CnyDUg7YCNedK+KrQ5d2bB5trka
   uhamCaGWTj2qcrpkQpljhLYEM+qgAHCOKbX1htlEoeppMz3fjkQ4q7Oav
   H+oPfUKHZb8IgErkstsCTCDstFk6iyC/SKx3/NgC35EkSGSlvbCwGKV12
   mVJFYEwlHpfgtl311itruu+wr2ZNwmhM/Chozdj+oFOXin7N/qzE4WQOF
   I3XpNDRPxzv6J5kYg4tfGc61m7KJEiZLGP/p01v0JYIAI3jjVi6aWC75l
   4iU4lsvhXBxc7diZoDn5Gpw3xfawcMQhVGUgF198ZrSv7QI9V8yY4RcnI
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,286,1643698800"; 
   d="scan'208";a="153623567"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Apr 2022 07:55:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 24 Apr 2022 07:55:54 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sun, 24 Apr 2022 07:55:52 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <UNGLinuxDriver@microchip.com>, <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/5] net: lan966x: Change the PTP pin used to read/write the PHC.
Date:   Sun, 24 Apr 2022 16:58:21 +0200
Message-ID: <20220424145824.2931449-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220424145824.2931449-1-horatiu.vultur@microchip.com>
References: <20220424145824.2931449-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To read/write a value to a PHC, it is required to use a PTP pin.
Currently it is used pin 5, but change to pin 7 as is the last pin.
All the other pins will have different functions.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index 0a1041da4384..3e455a3fad08 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -16,7 +16,7 @@
  */
 #define LAN966X_1PPB_FORMAT		3480517749LL
 
-#define TOD_ACC_PIN		0x5
+#define TOD_ACC_PIN		0x7
 
 enum {
 	PTP_PIN_ACTION_IDLE = 0,
-- 
2.33.0

