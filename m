Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22EFB55B22A
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 15:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbiFZNBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 09:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiFZNBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 09:01:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE4611800;
        Sun, 26 Jun 2022 06:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656248494; x=1687784494;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nOZclKukcdLDBDm4CjNMxtNVSLfCiaIovRVkWGK4I3o=;
  b=fkM1DiokHqB7C07fjMmhjCaKysaTzUc3uiMXJvsp2axTr2tmC9+fipcj
   JZ4fH/27G6jWUs4adYXi0WSkZ7/XVuRHWJd3LFfU1EcT1Mvzq2EWeh1c0
   NG7iNus47IEIuvGXSZT2EbJPGMBgo3OST6gq33P/h/mHlo5DeLgxh70Zw
   k5M/alc1Ei3sCzF03pUSHbXdj9/++iVB3Lf902pxoT1DaCMoSlUPX022L
   6goqUJMUL5ajx7I1SNnkQSbuYQrUoqRHYPht64i2e4bSFeSDifjzbfJ+y
   6fiU+hRDavqxOjbysItVqNc0KExmTwXelEALhpvbRskKhfBqp+wYXyNuV
   w==;
X-IronPort-AV: E=Sophos;i="5.92,224,1650956400"; 
   d="scan'208";a="101779742"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jun 2022 06:01:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 26 Jun 2022 06:01:33 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sun, 26 Jun 2022 06:01:31 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/8] net: lan966x: Add lag support
Date:   Sun, 26 Jun 2022 15:04:43 +0200
Message-ID: <20220626130451.1079933-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
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

Add lag support for lan966x.
First 4 patches don't do any changes to the current behaviour, they
just prepare for lag support. While the rest is to add the lag support.

Horatiu Vultur (8):
  net: lan966x: Add reqisters used to configure lag interfaces
  net: lan966x: Split lan966x_fdb_event_work
  net: lan966x: Expose lan966x_switchdev_nb and
    lan966x_switchdev_blocking_nb
  net: lan966x: Extend lan966x_foreign_bridging_check
  net: lan966x: Add lag support for lan966x.
  net: lan966x: Extend FDB to support also lag
  net: lan966x: Extend MAC to support also lag interfaces.
  net: lan966x: Update PGID when lag ports are changing link status

 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_fdb.c  | 153 +++++---
 .../ethernet/microchip/lan966x/lan966x_lag.c  | 342 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_mac.c  |  66 +++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  45 +++
 .../ethernet/microchip/lan966x/lan966x_port.c |   6 +
 .../ethernet/microchip/lan966x/lan966x_regs.h |  45 +++
 .../microchip/lan966x/lan966x_switchdev.c     | 116 ++++--
 8 files changed, 685 insertions(+), 90 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_lag.c

-- 
2.33.0

