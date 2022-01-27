Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D35449DF20
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239185AbiA0KVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:21:43 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:53483 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239181AbiA0KVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:21:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643278902; x=1674814902;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iBEp2VA/o5PKjaqCeq0vgFIhlxKoKzKUuFPwKxXg/VA=;
  b=tJBdLhPIOP6yGeVNQ/qgF/uqbpnwGhpamLca0PnyMtdXdny+Zut0+Wd/
   BYpIbTIr22/UtmZ2fhZC8tOfKWTz5dQtYAhmLpcmfXfr5N1Fzl+3atiAS
   HGdjlbDr1qb9VXp/k8Js1Xyz7nwhjIPSmT+HnIXBNwHFSyzNehoFO7G5w
   YELTjq6YqD9DvadX8DDpKIQG7YZtIKHw6DXZOAwlylcGbD3rihwz7xMqW
   6LCo6WuduN4dHRtr/LNSI6qBf/5d7rZMWV36dYEVxuYn12zdq60Wr6bkT
   MAMIL3U3axrU+bQBO4dZ7Zp5HTJSWmZCyhDBs7K7BkToL3JwVlDgmP2ch
   Q==;
IronPort-SDR: FB1R/JBbCSawIwXPz0CPd5Fll/es1pUBDz4PcU/H33VPfF09NSNIX8+eaLrjaMBVFCuxvrLVFb
 tbXPUN8nsAp+PCYktzUQ7QdJHLejojUIQJiPJycyURh4zGq9txxXBnuVtzBv79Fn15DXO5kEfN
 hkZ5UYBBTYKNIkv9X+8J6EYTHdmSTLQNyBAqVlV3YzlLYMR4Ugy/bSnRBoJqwFSr5SYzmw/7pa
 ryqKO2ylpJzIDlAnDFYs93zXehky7+M0dhlBnNvj9PerZjOz8jzTiCt7LvbR8jRJXy2tq4/RnY
 ozSjYRXPvq3jbE6J6vNPwkG2
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="151628232"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2022 03:21:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 03:21:37 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 27 Jan 2022 03:21:35 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <richardcochran@gmail.com>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/7] net: lan966x: Add PTP Hardward Clock support
Date:   Thu, 27 Jan 2022 11:23:26 +0100
Message-ID: <20220127102333.987195-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for PTP Hardware Clock (PHC) for lan966x.
The switch supports both PTP 1-step and 2-step modes.

Horatiu Vultur (7):
  dt-bindings: net: lan966x: Extend with the ptp interrupt
  net: lan966x: Add registers that are use for ptp functionality
  net: lan966x: Add support for ptp clocks
  net: lan966x: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP
  net: lan966x: Update extraction/injection for timestamping
  net: lan966x: Add support for ptp interrupts
  net: lan966x: Implement get_ts_info

 .../net/microchip,lan966x-switch.yaml         |   2 +
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../microchip/lan966x/lan966x_ethtool.c       |  36 +
 .../ethernet/microchip/lan966x/lan966x_main.c |  89 ++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  51 ++
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 630 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h | 103 +++
 7 files changed, 908 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c

-- 
2.33.0

