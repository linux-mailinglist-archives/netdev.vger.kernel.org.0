Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 891A62FD89
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 16:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfE3OT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 10:19:56 -0400
Received: from inva020.nxp.com ([92.121.34.13]:48906 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfE3OTz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 10:19:55 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 85AE61A064E;
        Thu, 30 May 2019 16:19:53 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 790631A0179;
        Thu, 30 May 2019 16:19:53 +0200 (CEST)
Received: from fsr-ub1864-101.ea.freescale.net (fsr-ub1864-101.ea.freescale.net [10.171.82.13])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E3D262026B;
        Thu, 30 May 2019 16:19:52 +0200 (CEST)
From:   laurentiu.tudor@nxp.com
To:     netdev@vger.kernel.org, madalin.bucur@nxp.com, roy.pledge@nxp.com,
        camelia.groza@nxp.com, leoyang.li@nxp.com
Cc:     Joakim.Tjernlund@infinera.com, davem@davemloft.net,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: [PATCH v3 0/6] Prerequisites for NXP LS104xA SMMU enablement
Date:   Thu, 30 May 2019 17:19:45 +0300
Message-Id: <20190530141951.6704-1-laurentiu.tudor@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

This patch series contains several fixes in preparation for SMMU
support on NXP LS1043A and LS1046A chips. Once these get picked up,
I'll submit the actual SMMU enablement patches consisting in the
required device tree changes.

This patch series contains only part of the previously submitted one,
(including also the device tree changes) available here:

 https://patchwork.kernel.org/cover/10634443/

There are a couple of changes/fixes since then:
 - for consistency, renamed mmu node to smmu
 - new patch page aligning the sizes of the qbman reserved memory
 - rebased on 5.1.0-rc2

Depends on this pull request:

 http://lists.infradead.org/pipermail/linux-arm-kernel/2019-May/653554.html

Changes in v3:
 - cache iommu domain in driver's private data
 - rebased on v5.2.0-rc2
 - rework to get rid of #ifdef spaghetti (David)

Changes in v2:
 - dropped patches dealing with mapping reserved memory in iommu
 - changed logic for qman portal probe status (Leo)
 - moved "#ifdef CONFIG_PAMU" in header file (Leo)
 - rebased on v5.1.0-rc5

Laurentiu Tudor (6):
  fsl/fman: don't touch liodn base regs reserved on non-PAMU SoCs
  fsl/fman: add API to get the device behind a fman port
  dpaa_eth: defer probing after qbman
  dpaa_eth: base dma mappings on the fman rx port
  dpaa_eth: fix iova handling for contiguous frames
  dpaa_eth: fix iova handling for sg frames

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 131 ++++++++++++------
 .../net/ethernet/freescale/dpaa/dpaa_eth.h    |   2 +
 drivers/net/ethernet/freescale/fman/fman.c    |   6 +-
 .../net/ethernet/freescale/fman/fman_port.c   |  14 ++
 .../net/ethernet/freescale/fman/fman_port.h   |   2 +
 5 files changed, 108 insertions(+), 47 deletions(-)

-- 
2.17.1

