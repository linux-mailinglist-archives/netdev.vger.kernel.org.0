Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7618AEAF01
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfJaLhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:37:03 -0400
Received: from inva021.nxp.com ([92.121.34.21]:44094 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbfJaLhD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 07:37:03 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CA8A9200507;
        Thu, 31 Oct 2019 12:37:01 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BDD33200504;
        Thu, 31 Oct 2019 12:37:01 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8070F205E9;
        Thu, 31 Oct 2019 12:37:01 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, jakub.kicinski@netronome.com,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [net-next 00/13] DPAA Ethernet changes
Date:   Thu, 31 Oct 2019 13:36:46 +0200
Message-Id: <1572521819-10458-1-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are some more changes for the DPAA 1.x area.
In summary, these changes use pages for the receive buffers and
for the scatter-gather table fed to the HW on the Tx path, perform
a bit of cleanup in some convoluted parts of the code, add some
minor fixes related to DMA (un)mapping sequencing for a not so
common scenario, add a device link that removes the interfaces
when the QMan portal in use by them is removed.


Madalin Bucur (13):
  dpaa_eth: use only one buffer pool per interface
  dpaa_eth: use page backed rx buffers
  dpaa_eth: perform DMA unmapping before read
  dpaa_eth: avoid timestamp read on error paths
  dpaa_eth: simplify variables used in dpaa_cleanup_tx_fd()
  dpaa_eth: use fd information in dpaa_cleanup_tx_fd()
  dpaa_eth: cleanup skb_to_contig_fd()
  dpaa_eth: use a page to store the SGT
  dpaa_eth: add dropped frames to percpu ethtool stats
  dpaa_eth: remove netdev_err() for user errors
  dpaa_eth: extend delays in ndo_stop
  soc: fsl: qbman: allow registering a device link for the portal user
  dpaa_eth: register a device link for the qman portal used

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     | 274 ++++++++++-----------
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h     |   4 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c   |   6 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |  56 ++---
 drivers/soc/fsl/qbman/qman.c                       |   7 +
 include/soc/fsl/qman.h                             |  11 +
 6 files changed, 173 insertions(+), 185 deletions(-)

-- 
2.1.0

