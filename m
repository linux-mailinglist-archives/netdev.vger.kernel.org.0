Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B80550D287
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 17:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239636AbiDXPAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 11:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239528AbiDXO6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 10:58:54 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C912C37A06;
        Sun, 24 Apr 2022 07:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1650812151; x=1682348151;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=j8Lu4AiqbRbjV2E8MKRFPqyrfc9jWVbRk95FXIFed+c=;
  b=qlylYjrcnuHfKO8SWgMxny1IOQB2uXjCZ1mzU1Gie9Aw1WDdhmfcNUEe
   WwqsYQWqGhKXyD6lXQckmylKEXqIlkUFo9Oz7KczJa/JpKLlh/5qWPayz
   jlfwWDOgLtVJl5MjvOTwGEsj4vxN3UBJMiAfAXfws09DezNRk2jsH4Rsz
   fpNr0q6B3Az3Yp4Ga/FbXPC3phmQwB8Y31BVWoa6+NTYe87MDm5+fT0VJ
   a7ccHYwoA37/9VujXOxsYMXuNupD/8/AFuVAqywl903kyIidIWTTXxo+5
   +SBSHFDFVvZpJpsHu9VY4UkjO3HQrFBF8WUJFSITBa0auGHgOzu1ifQRa
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,286,1643698800"; 
   d="scan'208";a="153623558"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Apr 2022 07:55:50 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 24 Apr 2022 07:55:49 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sun, 24 Apr 2022 07:55:46 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <UNGLinuxDriver@microchip.com>, <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/5] net: lan966x: Add support for PTP programmable pins
Date:   Sun, 24 Apr 2022 16:58:19 +0200
Message-ID: <20220424145824.2931449-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
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

Lan966x has 8 PTP programmable pins. The last pin is hardcoded to be used
by PHC0 and all the rest are shareable between the PHCs. The PTP pins can
implement both extts and perout functions.

Horatiu Vultur (5):
  dt-bindings: net: lan966x: Extend with the ptp external interrupt.
  net: lan966x: Change the PTP pin used to read/write the PHC.
  net: lan966x: Add registers used to configure the PTP pin
  net: lan966x: Add support for PTP_PF_PEROUT
  net: lan966x: Add support for PTP_PF_EXTTS

 .../net/microchip,lan966x-switch.yaml         |   2 +
 .../ethernet/microchip/lan966x/lan966x_main.c |  17 ++
 .../ethernet/microchip/lan966x/lan966x_main.h |   4 +
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 276 +++++++++++++++++-
 .../ethernet/microchip/lan966x/lan966x_regs.h |  40 +++
 5 files changed, 338 insertions(+), 1 deletion(-)

-- 
2.33.0

