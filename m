Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638D84CD2F2
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 12:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238359AbiCDLHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 06:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiCDLHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 06:07:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D95F4FC69;
        Fri,  4 Mar 2022 03:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646391992; x=1677927992;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=p8Fa23wYHcovyCGBRwDb95f17RKV5nETuLwfv0uMp7M=;
  b=JXUetVdN2nlOwy8H8rZhIucjnPTuEYXYzzRmVL9ozuU1iQKtgjGqqy+4
   DuqntJhjRhyW+ihwRBvlWteB3Ns84/GUyd/4/x2q0iFjXR2RSbJ+SGibW
   o6FqHOyCj57fTqNZ17Jq5DuAEBrsngr86frgqlAEkUjpzZIVfVYpQh0ex
   1Zmbzi0Y2QTgYgH82fs2h4eo3CgxzzNEePnLBsadwqCe9rtXH3U9MZzeE
   551yA3Cu45NGQxBI6uPGf3NX5018VorWlWzJfWiyqzDrJ8pZt7m6hMVp5
   wErnrjc/KjKQTXlZjCJSfYYyQOXRD0FLeAKYw65V9rDYcuo7f8pRyZ+bu
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,155,1643698800"; 
   d="scan'208";a="87822961"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 04:06:31 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 04:06:30 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 04:06:28 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <casper.casan@gmail.com>,
        <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/9] net: sparx5: Add PTP Hardware Clock support
Date:   Fri, 4 Mar 2022 12:08:51 +0100
Message-ID: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for PTP Hardware Clock (PHC) for sparx5.

Horatiu Vultur (9):
  net: sparx5: Move ifh from port to local variable
  dt-bindings: net: sparx5: Extend with the ptp interrupt
  dts: sparx5: Enable ptp interrupt
  net: sparx5: Add registers that are used by ptp functionality
  net: sparx5: Add support for ptp clocks
  net: sparx5: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP
  net: sparx5: Update extraction/injection for timestamping
  net: sparx5: Add support for ptp interrupts
  net: sparx5: Implement get_ts_info

 .../bindings/net/microchip,sparx5-switch.yaml |   2 +
 arch/arm64/boot/dts/microchip/sparx5.dtsi     |   5 +-
 .../net/ethernet/microchip/sparx5/Makefile    |   3 +-
 .../microchip/sparx5/sparx5_ethtool.c         |  34 +
 .../ethernet/microchip/sparx5/sparx5_fdma.c   |   2 +
 .../ethernet/microchip/sparx5/sparx5_main.c   |  21 +
 .../ethernet/microchip/sparx5/sparx5_main.h   |  66 +-
 .../microchip/sparx5/sparx5_main_regs.h       | 335 ++++++++-
 .../ethernet/microchip/sparx5/sparx5_netdev.c |  42 +-
 .../ethernet/microchip/sparx5/sparx5_packet.c |  37 +-
 .../ethernet/microchip/sparx5/sparx5_ptp.c    | 685 ++++++++++++++++++
 11 files changed, 1221 insertions(+), 11 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c

-- 
2.33.0

