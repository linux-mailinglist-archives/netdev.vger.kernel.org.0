Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4EE46757B
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 11:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351976AbhLCKtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 05:49:17 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:5276 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244330AbhLCKtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 05:49:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638528353; x=1670064353;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eM8gk6nuiMyvZl4Wht/YwImBBjJo9IuoMykWHAHYhhM=;
  b=eA36BdrkXDu0MtzPagIMEuAEEkJWVckbA+EUsmotFYzwlOw72lyerLSY
   xlwnXGHau2VwwWNIufS5W35mb+JFMAScxZHzFBjUG3XtODDRAj0yXvKHm
   jyb4BRdqtOgk1cxekIyDwOHWJijkP7MtRGLp5bK8zOfNDfMvhmVH/fU/F
   L2McYn06IQLkExwj7jRd5+wqb4cNEe3C+yEPLtJDjo/2zN4LJhv0C834R
   Ed1yczxDdjGsWv6JaE3dVmHHarcIGclWrsrxuI7wvzUnEuMY8DGJrOhyr
   W1nd51rqP7wrysM8KumfMLdixqmROWxX30OEIc3dFTSALyEYKqOv7yjvz
   A==;
IronPort-SDR: yr5+QnPJD6dOklguX+h6dXJKoLXOpGzW1eSsIY1AGZPfxZwJBnY2h+bp/daQX9pGNTc8yQU5OG
 1aHITf4yfQ14QS27UGWB2F/DKAxEKqfi4HKvJgEAccrXo3oBEno38O9v/XaIme+tyBf66+KerF
 ZwwBaDmpR0PCId8iXVczW15tW34vnpYVXFvvjIFJ7WWNM885V5xYfZ+sMhQTPIjsNfMVbct1BD
 cKFvd7lLHFeJr3iyxgHJ375fK8CldK2A2jM8TNRfAYoEqNyBQmgLz5ZMLgPFOAqBrMBcUdqb76
 hkw+CnjYIseeaBRTW0B49qgC
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="154153442"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2021 03:45:52 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 3 Dec 2021 03:45:52 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 3 Dec 2021 03:45:50 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/6] net: lan966x: Add switchdev and vlan support
Date:   Fri, 3 Dec 2021 11:46:39 +0100
Message-ID: <20211203104645.1476704-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends lan966x with switchdev and vlan support.
The first patches just adds new registers and extend the MAC table to
handle the interrupts when a new address is learn/forget.
The last 2 patches adds the vlan and the switchdev support.

Horatiu Vultur (6):
  net: lan966x: Add registers that are used for switch and vlan
    functionality
  dt-bindings: net: lan966x: Extend with the analyzer interrupt
  net: lan966x: add support for interrupts from analyzer
  net: lan966x: More MAC table functionality
  net: lan966x: Add vlan support
  net: lan966x: Add switchdev support

 .../net/microchip,lan966x-switch.yaml         |   2 +
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 337 +++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |  92 ++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  71 ++-
 .../ethernet/microchip/lan966x/lan966x_regs.h | 129 +++++
 .../microchip/lan966x/lan966x_switchdev.c     | 544 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_vlan.c | 439 ++++++++++++++
 8 files changed, 1602 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c

-- 
2.33.0

