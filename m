Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45134272C3E
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgIUQ27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:28:59 -0400
Received: from inva021.nxp.com ([92.121.34.21]:36654 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbgIUQ26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 12:28:58 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C1CFC200A6C;
        Mon, 21 Sep 2020 18:20:41 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B5F2B2009DF;
        Mon, 21 Sep 2020 18:20:41 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 6AAD2203B6;
        Mon, 21 Sep 2020 18:20:41 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, linux@armlinux.org.uk,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/3] dpaa2-mac: add PCS support through the Lynx module
Date:   Mon, 21 Sep 2020 19:20:28 +0300
Message-Id: <20200921162031.12921-1-ioana.ciornei@nxp.com>
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

Ioana Ciornei (2):
  net: pcs-lynx: add support for 10GBASER
  dpaa2-mac: add PCS support through the Lynx module

Russell King (1):
  of: add of_mdio_find_device() api

 drivers/net/ethernet/freescale/dpaa2/Kconfig  |  1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 88 ++++++++++++++++++-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  2 +
 drivers/net/pcs/pcs-lynx.c                    |  6 ++
 drivers/of/of_mdio.c                          | 38 ++++++--
 include/linux/of_mdio.h                       |  6 ++
 6 files changed, 131 insertions(+), 10 deletions(-)

-- 
2.25.1

