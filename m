Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFC667E835
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 15:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbjA0O0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 09:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbjA0O0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 09:26:32 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9AE8B13D58;
        Fri, 27 Jan 2023 06:26:26 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,251,1669042800"; 
   d="scan'208";a="150776280"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 27 Jan 2023 23:26:25 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 969BF433ACC3;
        Fri, 27 Jan 2023 23:26:25 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v4 0/4] net: ethernet: renesas: rswitch: Modify initialization for SERDES and PHY
Date:   Fri, 27 Jan 2023 23:26:17 +0900
Message-Id: <20230127142621.1761278-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So, I would like to change the MACTYPE as SGMII by software for the platform.

The patch [1/4] sets phydev->host_interfaces by phylink for Marvell PHY
driver (marvell10g) to initialize the MACTYPE.

The patch [2/4] siplifies the rswitch driver, the patch [3/4] enables
the ovr_host_interfaces flag, and the patch [4/4] phy_power_on() calling
to initialize the Ethernet SERDES PHY driver (r8a779f0-eth-serdes)
for each channel.

Changes from v3:
https://lore.kernel.org/all/20230127014812.1656340-1-yoshihiro.shimoda.uh@renesas.com/
 - Keep a pointer of "port" and more simplify the code.

Changes from v2:
 - Add some blank lines for readability.

Changes from v1:
 - Add a new flag (ovr_host_interfaces) into phylink_config in the patch [1/4].
 - Add a new patch [3/4] for the new flag.
 - Add a error message to the patch [4/4/] for MLO_AN_INBAND mode.


Yoshihiro Shimoda (4):
  net: phylink: Set host_interfaces for a non-sfp PHY
  net: ethernet: renesas: rswitch: Simplify struct phy * handling
  net: ethernet: renesas: rswitch: Enable ovr_host_interfaces
  net: ethernet: renesas: rswitch: Add phy_power_{on,off}() calling

 drivers/net/ethernet/renesas/rswitch.c | 116 ++++++++-----------------
 drivers/net/ethernet/renesas/rswitch.h |   2 +
 drivers/net/phy/phylink.c              |  11 +++
 include/linux/phylink.h                |   3 +
 4 files changed, 54 insertions(+), 78 deletions(-)

-- 
2.25.1

