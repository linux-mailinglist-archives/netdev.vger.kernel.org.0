Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3345F8C4A
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 18:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiJIQXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 12:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiJIQXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 12:23:36 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57422B25E;
        Sun,  9 Oct 2022 09:23:34 -0700 (PDT)
X-QQ-mid: bizesmtp62t1665332593trylp2zl
Received: from localhost.localdomain ( [58.247.70.42])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 10 Oct 2022 00:22:58 +0800 (CST)
X-QQ-SSF: 01100000002000G0Z000B00A0000000
X-QQ-FEAT: /w8MRS8X6cfmlBBC5LshJPI0I3TMu0ig5IXzTnJN+KXfAenCSPdSpnrqk246V
        wX/KLp8UC0Nc8fVYMIkgqFlKByQuMeK47vuWGy8gi/emwSp31/4vxIaFbXvAM7qerf/uMrY
        pgvK1qWH2YnbVb+56NrTzcW1iUeGyvF4D74XDp5jI19lTCBDddktaayv3U02o/wkc0oXMjc
        9c+yEzRQw0W9YxLp67cGYpMyCagm/92kMaAvrsmYRC1qFYi+cyQD95HFIjmMx1f5qyFYltM
        n2R8egWl6Tr44PvmSw49gr83FVYgt8xqIoUtqx03MCLYaFOKmSk3sXVQcsv1aai3xSQ+fHF
        DwckXSiIf/OO+cxI5nLpHWSXreVst+5pSRnmGt1LNFnjL5jyWdX+ZccBVi21Q==
X-QQ-GoodBg: 0
From:   Soha Jin <soha@lohu.info>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Yangyu Chen <cyy@cyyself.name>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Soha Jin <soha@lohu.info>
Subject: [PATCH 0/3] net: stmmac: probing config with fwnode instead of of
Date:   Mon, 10 Oct 2022 00:22:44 +0800
Message-Id: <20221009162247.1336-1-soha@lohu.info>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:lohu.info:qybglogicsvr:qybglogicsvr3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches depend on two other patches:
- net: mdiobus: add fwnode_phy_is_fixed_link()
  https://lore.kernel.org/lkml/20221009162006.1289-1-soha@lohu.info/
- device property: add fwnode_is_compatible() for compatible match
  https://lore.kernel.org/lkml/20221009162155.1318-1-soha@lohu.info/

Patch 1 changes the stmmac's configuration probing from `of` to `fwnode`,
which enables the compatibility of stmmac devices described by ACPI.

Patch 2 adds Phytium's GMAC (ACPI HID PHYT0004) to the dwmac-generic
driver, this is also the device I used to test Patch 1.

Patch 3 changes all `stmmac_{probe,remove}_config_dt` to
`stmmac_platform_{probe,remove}_config`, since the function is renamed in
Patch 1.

Soha Jin (3):
  net: stmmac: use fwnode instead of of to configure driver
  net: stmmac: add Phytium's PHYT0004 to dwmac-generic compatible
    devices
  net: stmmac: switch to stmmac_platform_{probe,remove}_config

 .../ethernet/stmicro/stmmac/dwmac-anarion.c   |   4 +-
 .../stmicro/stmmac/dwmac-dwc-qos-eth.c        |   6 +-
 .../ethernet/stmicro/stmmac/dwmac-generic.c   |  30 +-
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   |   4 +-
 .../ethernet/stmicro/stmmac/dwmac-ingenic.c   |   4 +-
 .../stmicro/stmmac/dwmac-intel-plat.c         |   4 +-
 .../ethernet/stmicro/stmmac/dwmac-ipq806x.c   |   4 +-
 .../ethernet/stmicro/stmmac/dwmac-lpc18xx.c   |   4 +-
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  |   4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-meson.c |   4 +-
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   |   4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-oxnas.c |   4 +-
 .../stmicro/stmmac/dwmac-qcom-ethqos.c        |   4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    |  13 +-
 .../ethernet/stmicro/stmmac/dwmac-socfpga.c   |   4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-sti.c   |   4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-stm32.c |   4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |   6 +-
 .../net/ethernet/stmicro/stmmac/dwmac-sunxi.c |   4 +-
 .../ethernet/stmicro/stmmac/dwmac-visconti.c  |   6 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   7 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |  14 +-
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 409 ++++++++++--------
 .../ethernet/stmicro/stmmac/stmmac_platform.h |  10 +-
 include/linux/stmmac.h                        |   7 +-
 25 files changed, 320 insertions(+), 248 deletions(-)

-- 
2.30.2

