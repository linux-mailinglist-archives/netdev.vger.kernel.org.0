Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388E8275C2E
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 17:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgIWPlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 11:41:36 -0400
Received: from inva020.nxp.com ([92.121.34.13]:51246 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgIWPlg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 11:41:36 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 0929E1A061B;
        Wed, 23 Sep 2020 17:41:35 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id F04851A019E;
        Wed, 23 Sep 2020 17:41:34 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A7BFB2033F;
        Wed, 23 Sep 2020 17:41:34 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, linux@armlinux.org.uk,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 0/3] dpaa2-mac: add PCS support through the Lynx module
Date:   Wed, 23 Sep 2020 18:41:20 +0300
Message-Id: <20200923154123.636-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set aims to add PCS support in the dpaa2-eth driver by
leveraging the Lynx PCS module.

The first two patches are some missing pieces: the first one adding
support for 10GBASER in Lynx PCS while the second one adds a new
function - of_mdio_find_device - which is helpful in retrieving the PCS
represented as a mdio_device.  The final patch adds the glue logic
between phylink and the Lynx PCS module: it retrieves the PCS
represented as an mdio_device and registers it to Lynx and phylink.
From that point on, any PCS callbacks are treated by Lynx, without
dpaa2-eth interaction.

Changes in v2:
 - move put_device() after destroy - 3/3

Ioana Ciornei (2):
  net: pcs-lynx: add support for 10GBASER
  dpaa2-mac: add PCS support through the Lynx module

Russell King (1):
  of: add of_mdio_find_device() api

 drivers/net/ethernet/freescale/dpaa2/Kconfig  |  1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 89 ++++++++++++++++++-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  2 +
 drivers/net/pcs/pcs-lynx.c                    |  6 ++
 drivers/of/of_mdio.c                          | 38 ++++++--
 include/linux/of_mdio.h                       |  6 ++
 6 files changed, 132 insertions(+), 10 deletions(-)

-- 
2.25.1

