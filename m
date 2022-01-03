Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418A2483145
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 14:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbiACNId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 08:08:33 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:6231 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbiACNId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 08:08:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641215312; x=1672751312;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=w4QtoPnTah0uUSfe6Jg24WSCWog3QOVMW9euB1f1QZM=;
  b=gaeQoJyp0jiDXSYWlwm6eNbt3k3G1EORGnYZVNMau3YAyL4dxi4wXODc
   vkrclTZ/IybH/1NrQHl+pcmj17EfC1cAY8AqxvRX7VfF/I5dwkHhjIMss
   GDsl0Broc8vKMcCq1ixBmtCWU74J1pjBbNKhOQVL9tFgabkVbCTR/jayT
   D/1yTgzZdkAmA8R8aDlxqyGg6JG1pRO01dSanagoDC4AXsAulkL6q5dD1
   lKl5NR1TpH7m13vk5QXjdMLHI7Eep2bCLihqoI5qowu78QZHLjqxH1u1I
   UdAHyC4qlQZlxKw/klB8HVvEErPDtVAPv0I5IrqH9aqMaS5jp1aBZJPAa
   Q==;
IronPort-SDR: rVUNA7/Tv8aEpue8wzDpkzmRtEbpZ2BH0E0DyUo5zINzp+voChmcfvw3wqNHw4cXnYpc6K4b3e
 WL+hMKhCvPHCJAEHYOxnh0d5+h6DaoUg0DFGFo0Fv11OF7rbMdGrdlKxVnisFaDYTxlh2taqIE
 BquyWhu37WPFBGYAwHKL0en07N2BBVOkuMffdQp3SJ4/kIbvwgAYtSsEj4OFfXB/EdmTLmEndI
 BaE/LLbH9nWNcVD8yjMrhbIkKqp9qyHkCHfbqP27sDZzdvsxpGdEmYpzo5DKdn/fuxbNpKBm9y
 j6cqbgXvOpElP30s1MZr6W/k
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="141458428"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Jan 2022 06:08:31 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 3 Jan 2022 06:08:31 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 3 Jan 2022 06:08:29 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/3] net: lan966x: Extend switchdev with mdb support
Date:   Mon, 3 Jan 2022 14:10:36 +0100
Message-ID: <20220103131039.3473876-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends lan966x with mdb support by implementing
the switchdev callbacks: SWITCHDEV_OBJ_ID_PORT_MDB and
SWITCHDEV_OBJ_ID_HOST_MDB.
It adds support for both ipv4/ipv6 entries and l2 entries.

Horatiu Vultur (3):
  net: lan966x: Add function lan966x_mac_cpu_copy()
  net: lan966x: Add PGID_FIRST and PGID_LAST
  net: lan966x: Extend switchdev with mdb support

 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_mac.c  |  27 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |   2 +
 .../ethernet/microchip/lan966x/lan966x_main.h |  24 +-
 .../ethernet/microchip/lan966x/lan966x_mdb.c  | 500 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h |   6 +
 .../microchip/lan966x/lan966x_switchdev.c     |   8 +
 .../ethernet/microchip/lan966x/lan966x_vlan.c |   7 +-
 8 files changed, 568 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mdb.c

-- 
2.33.0

