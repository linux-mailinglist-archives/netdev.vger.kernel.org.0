Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F9144BB65
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 06:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbhKJFvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 00:51:31 -0500
Received: from inva020.nxp.com ([92.121.34.13]:37950 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229485AbhKJFva (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 00:51:30 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A19BF1A0E27;
        Wed, 10 Nov 2021 06:48:42 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6A8871A0E1F;
        Wed, 10 Nov 2021 06:48:42 +0100 (CET)
Received: from lsv03186.swis.in-blr01.nxp.com (lsv03186.swis.in-blr01.nxp.com [92.120.146.182])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 3BF45183AC8B;
        Wed, 10 Nov 2021 13:48:41 +0800 (+08)
From:   Apeksha Gupta <apeksha.gupta@nxp.com>
To:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-devel@linux.nxdi.nxp.com, LnxRevLi@nxp.com,
        sachin.saxena@nxp.com, hemant.agrawal@nxp.com, nipun.gupta@nxp.com,
        Apeksha Gupta <apeksha.gupta@nxp.com>
Subject: [PATCH 0/5] drivers/net: add NXP FEC-UIO driver
Date:   Wed, 10 Nov 2021 11:18:33 +0530
Message-Id: <20211110054838.27907-1-apeksha.gupta@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series introduce the fec-uio driver, supported for the inbuilt
NIC found in the NXP i.MX 8M Mini SoC. Basic hardware initialization is
performed in kernel via userspace input/output(UIO) to support FEC
ethernet device detection in user space.

Userspace PMD uses standard UIO interface to access kernel for PHY
initialisation and for mapping the allocated memory of register &
buffer descriptor with DPDK which gives access to non-cacheable memory
for buffer descriptor.

Module fec-uio.ko will get generated.
imx8mm-evk-dpdk.dtb is required to support fec-uio driver.

Apeksha Gupta (5):
  dt-bindings: add binding for fec-uio
  net: fec: fec-uio driver
  ARM64: defconfig: Add config for fec-uio
  MAINTAINERS: add new file
  arm64: dts: imx8mm-evk-dpdk: dts for fec-uio driver

 .../devicetree/bindings/net/fsl,fec-uio.yaml  |  32 ++
 MAINTAINERS                                   |   6 +
 arch/arm64/boot/dts/freescale/Makefile        |   1 +
 .../boot/dts/freescale/imx8mm-evk-dpdk.dts    |  10 +
 arch/arm64/configs/defconfig                  |   1 +
 drivers/net/ethernet/freescale/Kconfig        |  10 +
 drivers/net/ethernet/freescale/Makefile       |   7 +-
 drivers/net/ethernet/freescale/fec_uio.c      | 437 ++++++++++++++++++
 8 files changed, 501 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/fsl,fec-uio.yaml
 create mode 100644 arch/arm64/boot/dts/freescale/imx8mm-evk-dpdk.dts
 create mode 100644 drivers/net/ethernet/freescale/fec_uio.c

-- 
2.17.1

