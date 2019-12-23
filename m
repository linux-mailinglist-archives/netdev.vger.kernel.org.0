Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68980129404
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 11:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfLWKOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 05:14:19 -0500
Received: from inva021.nxp.com ([92.121.34.21]:41654 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfLWKOT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 05:14:19 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0C5FA200A44;
        Mon, 23 Dec 2019 11:14:17 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id F39922007E5;
        Mon, 23 Dec 2019 11:14:16 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 7C1E82033F;
        Mon, 23 Dec 2019 11:14:16 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk,
        andrew@lunn.ch
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, shawnguo@kernel.org,
        leoyang.li@nxp.com, devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net-next v2 0/7] Add PHY connection types for XFI and SFI
Date:   Mon, 23 Dec 2019 12:14:06 +0200
Message-Id: <1577096053-20507-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For a long time the only 10G interface mode registered in the code was
XGMII and some PHYs and MACs that actually supported other modes just
used that to denote 10G. Recently more modes were added (USXGMII,
10GKR) to better match the actual HW support. In this respect, the use
of 10GBase-KR to denote not only backplane but also XFI and SFI can be
improved upon. This patch series introduces XFI and SFI PHY connection
types and initial users for them.


Changes from v1:
  Reorder patches to avoid issues with git bisect
  Add devicetree bindings entry for XFI, SFI

Madalin Bucur (7):
  net: phy: add interface modes for XFI, SFI
  net: fsl/fman: rename IF_MODE_XGMII to IF_MODE_10G
  net: fsl/fman: add support for PHY_INTERFACE_MODE_XFI
  net: fsl/fman: add support for PHY_INTERFACE_MODE_SFI
  net: phy: aquantia: add support for PHY_INTERFACE_MODE_XFI
  dt-bindings: net: add xfi, sfi to phy-connection-type
  arm64: dts: ls104xardb: set correct PHY interface mode

 Documentation/devicetree/bindings/net/ethernet-controller.yaml |  2 ++
 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts              |  2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts              |  4 ++--
 drivers/net/ethernet/freescale/fman/fman_memac.c               | 10 +++++++---
 drivers/net/ethernet/freescale/fman/mac.c                      | 10 +++++++---
 drivers/net/phy/aquantia_main.c                                |  5 ++++-
 include/linux/phy.h                                            |  7 ++++++-
 7 files changed, 29 insertions(+), 11 deletions(-)

-- 
2.1.0

