Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3423362D22F
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 05:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238754AbiKQEPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 23:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbiKQEO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 23:14:59 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC79645EC7;
        Wed, 16 Nov 2022 20:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668658497; x=1700194497;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YHDDmL+dktUpY7s/Oq9i3upLhyUoiijdZ9tCeqndfIo=;
  b=PVvvbd9JHzGT8A1VApjdISFLeYG8xtqkLg7hAewLn0+PaXhXe1HZInEd
   SvfO5VQAmfvWZrV3CigaBv+tEDaroX1BGmQPC/K03PGaJ2x9OKDnjIfLZ
   He8yD2f7JsLuS1Mh2p/OgSNchKbd1Fn5RwlbZTm1RX8DbYpBLEe00vJ1G
   JXCGuslrIdxeafQaUv9xik0Q6spr1DGHx3Q20rr+F9CyPH4adBhzdWs7J
   mj1v8SQCijaRp6Ncc/EzjlG8nLEUtwAcmnFbdUA5dZOa3r7w/rXySpWPb
   bvKgIMDBmDM4+KJhXFGESih9UbjjQpsSlO9z8l1iohGQyytzzqyhkLZfJ
   g==;
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="189317624"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Nov 2022 21:14:56 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 16 Nov 2022 21:14:54 -0700
Received: from che-lt-i64410lx.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 16 Nov 2022 21:14:50 -0700
From:   Balamanikandan Gunasundar 
        <balamanikandan.gunasundar@microchip.com>
To:     <ludovic.desroches@microchip.com>, <ulf.hansson@linaro.org>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <3chas3@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-atm-general@lists.sourceforge.net>,
        <netdev@vger.kernel.org>, <linus.walleij@linaro.org>,
        <hari.prasathge@microchip.com>
CC:     <balamanikandan.gunasundar@microchip.com>
Subject: [PATCH v2 0/2] mmc: atmel-mci: Convert to gpio descriptors
Date:   Thu, 17 Nov 2022 09:44:28 +0530
Message-ID: <20221117041430.9108-1-balamanikandan.gunasundar@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v2:

[PATCH 1/2] mmc: atmel-mci: Convert to gpio descriptors

 - Remove "#include <linux/gpio.h>" as it is not necessary

[PATCH 2/2] mmc: atmel-mci: move atmel MCI header file

 - Move linux/atmel-mci.h into drivers/mmc/host/atmel-mci.c as it is
   used only by one file

Balamanikandan Gunasundar (2):
  mmc: atmel-mci: Convert to gpio descriptors
  mmc: atmel-mci: move atmel MCI header file

 drivers/mmc/host/atmel-mci.c | 119 ++++++++++++++++++++++-------------
 include/linux/atmel-mci.h    |  46 --------------
 2 files changed, 77 insertions(+), 88 deletions(-)
 delete mode 100644 include/linux/atmel-mci.h

-- 
2.25.1

