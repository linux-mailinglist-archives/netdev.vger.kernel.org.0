Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84517663867
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 06:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjAJFCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 00:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjAJFCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 00:02:19 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44A6C1EC62;
        Mon,  9 Jan 2023 21:02:18 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.96,314,1665414000"; 
   d="scan'208";a="148802734"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 10 Jan 2023 14:02:17 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 3E17C400721C;
        Tue, 10 Jan 2023 14:02:17 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v2 0/4] net: ethernet: renesas: rswitch: Modify initialization for SERDES and PHY
Date:   Tue, 10 Jan 2023 14:02:02 +0900
Message-Id: <20230110050206.116110-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch [1/4] sets phydev->host_interfaces by phylink for Marvell PHY
driver (marvell10g) to initialize the MACTYPE.

The patch [2/4] siplifies the rswitch driver, the patch [3/4] enables
the ovr_host_interfaces flag, and the patch [4/4] phy_power_on() calling
to initialize the Ethernet SERDES PHY driver (r8a779f0-eth-serdes)
for each channel.

Changes from v1:
https://lore.kernel.org/all/20221226071425.3895915-1-yoshihiro.shimoda.uh@renesas.com/
 - Add a new flag (ovr_host_interfaces) into phylink_config in the patch [1/4].
 - Add a new patch [3/4] for the new flag.
 - Add a error message to the patch [4/4/] for MLO_AN_INBAND mode.

Yoshihiro Shimoda (4):
  net: phylink: Set host_interfaces for a non-sfp PHY
  net: ethernet: renesas: rswitch: Simplify struct phy * handling
  net: ethernet: renesas: rswitch: Enable ovr_host_interfaces
  net: ethernet: renesas: rswitch: Add phy_power_{on,off}() calling

 drivers/net/ethernet/renesas/rswitch.c | 53 +++++++++++++++-----------
 drivers/net/ethernet/renesas/rswitch.h |  1 +
 drivers/net/phy/phylink.c              |  9 +++++
 include/linux/phylink.h                |  3 ++
 4 files changed, 44 insertions(+), 22 deletions(-)

-- 
2.25.1

