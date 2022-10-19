Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B73603B90
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 10:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiJSIf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 04:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiJSIf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 04:35:26 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85ACC37FA8;
        Wed, 19 Oct 2022 01:35:24 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,195,1661785200"; 
   d="scan'208";a="137157441"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 19 Oct 2022 17:35:23 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id DAF66422C047;
        Wed, 19 Oct 2022 17:35:23 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v4 0/3] net: ethernet: renesas: Add Ethernet Switch driver
Date:   Wed, 19 Oct 2022 17:35:15 +0900
Message-Id: <20221019083518.933070-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        KHOP_HELO_FCRDNS,SPF_HELO_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is based on next-20221017.
Add minimal support for R-Car S4-8 Etherent Switch. This hardware
supports a lot of features. But, this driver only supports it as
act as an ethernet controller for now.

Notes that this driver requires modification of marvell10g driver.
I'll submit the patches as RFC later.

Changes from v3:
 https://lore.kernel.org/all/20220922052803.3442561-1-yoshihiro.shimoda.uh@renesas.com/
 - Rebased on next-20221017.
 - Rename dt-binding file.
 - Fix a lot of things about dt-binding.
 - Remove unneeded clocks/resets property.
 - Fix a lot of things about the rswitch driver.
 -- Fix a lot of sparse warnings.
 -- Naming of definitations/variables for readability.
 -- Add supports for all ports, especially using direct descriptor mode
    for sending frames from CPU to the specific user port.
 --- Refactor the initialization sequence to support all ports.
     (Especially, this is for SERDES which needs all black magic...)
 - Add protection for multiple registers access in the ptp driver.

Changes from v2:
 https://lore.kernel.org/all/20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com/
 - Separate patcheas into each subsystem.
 - Add spin lock protection for multiple registers access in patch [3/3].

Yoshihiro Shimoda (3):
  dt-bindings: net: renesas: Document Renesas Ethernet Switch
  net: ethernet: renesas: Add Ethernet Switch driver
  net: ethernet: renesas: rswitch: Add R-Car Gen4 gPTP support

 .../net/renesas,r8a779f0-ether-switch.yaml    |  265 +++
 drivers/net/ethernet/renesas/Kconfig          |   11 +
 drivers/net/ethernet/renesas/Makefile         |    4 +
 drivers/net/ethernet/renesas/rcar_gen4_ptp.c  |  181 ++
 drivers/net/ethernet/renesas/rcar_gen4_ptp.h  |   72 +
 drivers/net/ethernet/renesas/rswitch.c        | 1874 +++++++++++++++++
 drivers/net/ethernet/renesas/rswitch.h        |  980 +++++++++
 7 files changed, 3387 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml
 create mode 100644 drivers/net/ethernet/renesas/rcar_gen4_ptp.c
 create mode 100644 drivers/net/ethernet/renesas/rcar_gen4_ptp.h
 create mode 100644 drivers/net/ethernet/renesas/rswitch.c
 create mode 100644 drivers/net/ethernet/renesas/rswitch.h

-- 
2.25.1

