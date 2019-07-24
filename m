Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8E5731F9
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 16:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfGXOlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 10:41:44 -0400
Received: from inva020.nxp.com ([92.121.34.13]:42042 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfGXOlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 10:41:44 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id BC5E21A037F;
        Wed, 24 Jul 2019 16:41:42 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id AECEA1A038C;
        Wed, 24 Jul 2019 16:41:42 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 393EC205EE;
        Wed, 24 Jul 2019 16:41:42 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     andrew@lunn.ch, Rob Herring <robh+dt@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, alexandru.marginean@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 0/4] enetc: Add mdio bus driver for the PCIe MDIO endpoint
Date:   Wed, 24 Jul 2019 17:41:37 +0300
Message-Id: <1563979301-596-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Second patch just registers the PCIe endpoint device containing
the MDIO registers as a standalone MDIO bus driver, to allow
an alternative way to control the MDIO bus.  The same code used
by the ENETC ports (eth controllers) to manage MDIO via local
registers applies and is reused.

Bindings are provided for the new MDIO node, similarly to ENETC
port nodes bindings.

Last patch enables the ENETC port 1 and its RGMII PHY on the
LS1028A QDS board, where the MDIO muxing configuration relies
on the MDIO support provided in the first patch.

Claudiu Manoil (4):
  enetc: Clean up local mdio bus allocation
  enetc: Add mdio bus driver for the PCIe MDIO endpoint
  dt-bindings: net: fsl: enetc: Add bindings for the central MDIO PCIe
    endpoint
  arm64: dts: fsl: ls1028a: Enable eth port1 on the ls1028a QDS board

 .../devicetree/bindings/net/fsl-enetc.txt     |  42 ++++++-
 .../boot/dts/freescale/fsl-ls1028a-qds.dts    |  40 ++++++
 .../arm64/boot/dts/freescale/fsl-ls1028a.dtsi |   6 +
 .../net/ethernet/freescale/enetc/enetc_mdio.c | 119 +++++++++++++++---
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   5 +-
 5 files changed, 190 insertions(+), 22 deletions(-)

-- 
2.17.1

