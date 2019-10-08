Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D30CF95B
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 14:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730845AbfJHMKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 08:10:51 -0400
Received: from inva020.nxp.com ([92.121.34.13]:53766 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730439AbfJHMKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 08:10:50 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A9DBD1A00FC;
        Tue,  8 Oct 2019 14:10:48 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9CC9F1A002E;
        Tue,  8 Oct 2019 14:10:48 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 53B482060B;
        Tue,  8 Oct 2019 14:10:48 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, laurentiu.tudor@nxp.com,
        linux-kernel@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH 00/20] DPAA fixes
Date:   Tue,  8 Oct 2019 15:10:21 +0300
Message-Id: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's a series of fixes and changes for the DPAA 1.x drivers.
Fixing some boot time dependency issues, removing some dead code,
changing the buffers used for reception, fixing the DMA devices,
some cleanups.

Laurentiu Tudor (3):
  fsl/fman: don't touch liodn base regs reserved on non-PAMU SoCs
  dpaa_eth: defer probing after qbman
  fsl/fman: add API to get the device behind a fman port

Madalin Bucur (17):
  dpaa_eth: remove redundant code
  dpaa_eth: change DMA device
  fsl/fman: remove unused struct member
  dpaa_eth: use only one buffer pool per interface
  dpaa_eth: use page backed rx buffers
  dpaa_eth: perform DMA unmapping before read
  dpaa_eth: avoid timestamp read on error paths
  dpaa_eth: simplify variables used in dpaa_cleanup_tx_fd()
  dpaa_eth: use fd information in dpaa_cleanup_tx_fd()
  dpaa_eth: use a page to store the SGT
  soc: fsl: qbman: allow registering a device link for the portal user
  dpaa_eth: register a device link for the qman portal used
  dpaa_eth: add dropped frames to percpu ethtool stats
  dpaa_eth: remove netdev_err() for user errors
  dpaa_eth: extend delays in ndo_stop
  dpaa_eth: add dpaa_dma_to_virt()
  dpaa_eth: cleanup skb_to_contig_fd()

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     | 407 +++++++++++----------
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h     |  12 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c   |   6 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |  56 ++-
 drivers/net/ethernet/freescale/fman/fman.c         |   6 +-
 drivers/net/ethernet/freescale/fman/fman_port.c    |  17 +-
 drivers/net/ethernet/freescale/fman/fman_port.h    |   2 +
 drivers/soc/fsl/qbman/qman.c                       |   7 +
 include/soc/fsl/qman.h                             |  11 +
 9 files changed, 285 insertions(+), 239 deletions(-)

-- 
2.1.0

