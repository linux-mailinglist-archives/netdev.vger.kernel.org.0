Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D0C1D5966
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 20:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgEOSr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 14:47:59 -0400
Received: from inva020.nxp.com ([92.121.34.13]:51690 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgEOSr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 14:47:59 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9BAB81A0750;
        Fri, 15 May 2020 20:47:57 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8B09B1A074F;
        Fri, 15 May 2020 20:47:57 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4024220328;
        Fri, 15 May 2020 20:47:57 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic classes
Date:   Fri, 15 May 2020 21:47:46 +0300
Message-Id: <20200515184753.15080-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for Rx traffic classes on DPAA2 Ethernet
devices.

The first two patches make the necessary changes so that multiple
traffic classes are configured and their statistics are displayed in the
debugfs. The third patch adds a static distribution to said traffic
classes based on the VLAN PCP field.

The last patches add support for the congestion group taildrop mechanism
that allows us to control the number of frames that can accumulate on a
group of Rx frame queues belonging to the same traffic class.

Changes in v2:
  - use mask as u16* in set_vlan_qos - 3/7

Ioana Radulescu (7):
  dpaa2-eth: Add support for Rx traffic classes
  dpaa2-eth: Trim debugfs FQ stats
  dpaa2-eth: Distribute ingress frames based on VLAN prio
  dpaa2-eth: Add helper functions
  dpaa2-eth: Minor cleanup in dpaa2_eth_set_rx_taildrop()
  dpaa2-eth: Add congestion group taildrop
  dpaa2-eth: Update FQ taildrop threshold and buffer pool count

 .../freescale/dpaa2/dpaa2-eth-debugfs.c       |  11 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 225 +++++++++++++++---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  44 +++-
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  24 +-
 .../net/ethernet/freescale/dpaa2/dpni-cmd.h   |  34 +++
 drivers/net/ethernet/freescale/dpaa2/dpni.c   | 131 ++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpni.h   |  36 +++
 7 files changed, 450 insertions(+), 55 deletions(-)

-- 
2.17.1

