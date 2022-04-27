Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76E45111A6
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 08:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358363AbiD0Gv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 02:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358349AbiD0GvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 02:51:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D4914CC1F;
        Tue, 26 Apr 2022 23:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651042096; x=1682578096;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZDgnc/AWZ2GzndkIPVq+n1FwfPAm1cIU+Eo/I6edMr8=;
  b=GwfAXRDCq4VsfGpN6CZ3oNJ5xHKS7wIBO+MD4mbYQQudZICfVVQo5X8z
   hFVscbiL/8rj4q20+r/5QFGITHg/zv/Iq24IGbe7Q6GOH04GXp3Mj1RJE
   Q4DMiZ9N4ce+d8Oz/F2il8oxFBYok9ngeVffhimmhkbDcIzkS+U1YTg8B
   MCNBvvvhFECaaOlOZfKReVarD6JG85wOKQwpfLOy7vjO3aQDPN1Zvu1HA
   75BKsgJjq6FDh8TGha1qkeB9hVwjiN1dx/m/ukW5D15IjevVE/Nhdaotr
   RnnmSp/Ntl3aELKtMIxQNBhL36T0PTUxyybrZzpYzKFBP6K8YHgioaYVd
   g==;
X-IronPort-AV: E=Sophos;i="5.90,292,1643698800"; 
   d="scan'208";a="161462360"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Apr 2022 23:48:16 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 26 Apr 2022 23:48:14 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 26 Apr 2022 23:48:11 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <UNGLinuxDriver@microchip.com>, <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 2/5] net: lan966x: Change the PTP pin used to read/write the PHC.
Date:   Wed, 27 Apr 2022 08:51:24 +0200
Message-ID: <20220427065127.3765659-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220427065127.3765659-1-horatiu.vultur@microchip.com>
References: <20220427065127.3765659-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

