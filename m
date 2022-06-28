Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B34755EABC
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbiF1RN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiF1RN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:13:57 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBC622B3D;
        Tue, 28 Jun 2022 10:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656436436; x=1687972436;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BWBBX17E11pU+WlFnSbbJaFOLGJD1h1BiPaWPyBF03k=;
  b=rDUE5R1y076+dtmpW0yKvpWExh8OfclzBQo5uRfckV7QswZVp7d6iRAz
   BLYEqm/s/AwRYNJ+Td9SbanojIlaF27fzQYna+MRDdxTL562m+TaxN0/V
   SyRYhg1ssg1kbESuYRQt0UQk0kdEv185JSBhL05s2AhdDKwDI0WsWEsoe
   U9poSW+Z8FodmXn+5so/UndOHXJyddasMlvMkrgH0hYGw2fhGwY3vw+5J
   08ZVapE4DK8tpjQbBVx8JaaRKKHVTxIW4LoOTMVcFY9gNrW+Xw9EqJiyH
   YPh/KQ4N0xn7WCZvmyYIYsGK3UOpdj3Q17LFXAyU32gH0wK3qbl4AsEvi
   A==;
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="162447462"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jun 2022 10:13:55 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 28 Jun 2022 10:13:54 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 28 Jun 2022 10:13:43 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [Patch net-next 0/7] net: dsa: microchip: use ksz_chip_reg for
Date:   Tue, 28 Jun 2022 22:43:22 +0530
Message-ID: <20220628171329.25503-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series tries to use the same approach as struct ksz8 for
register which has different address for different switch family. It
moves the struct ksz8 from ksz8.h to struct ksz_chip_reg. Based on the
switch detect, the corresponding mask, reg and shifts are assigned.

Arun Ramadoss (7):
  net: dsa: microchip: move ksz8->regs to ksz_common
  net: dsa: microchip: move ksz8->masks to ksz_common
  net: dsa: microchip: move ksz8->shifts to ksz_common
  net: dsa: microchip: remove the struct ksz8
  net: dsa: microchip: change the size of reg from u8 to u16
  net: dsa: microchip: add P_STP_CTRL to ksz_chip_reg
  net: dsa: microchip: move remaining register offset to ksz_chip_reg

 drivers/net/dsa/microchip/ksz8.h        |  58 -------
 drivers/net/dsa/microchip/ksz8795.c     | 221 ++++++------------------
 drivers/net/dsa/microchip/ksz8795_reg.h |   1 -
 drivers/net/dsa/microchip/ksz8863_smi.c |  17 +-
 drivers/net/dsa/microchip/ksz9477.c     |   7 +-
 drivers/net/dsa/microchip/ksz9477_reg.h |   6 -
 drivers/net/dsa/microchip/ksz_common.c  | 206 +++++++++++++++-------
 drivers/net/dsa/microchip/ksz_common.h  |  58 +++++++
 drivers/net/dsa/microchip/ksz_spi.c     |  10 +-
 9 files changed, 267 insertions(+), 317 deletions(-)


base-commit: d521bc0a0f7cdd56b646e6283d5f7296eb16793d
-- 
2.36.1

