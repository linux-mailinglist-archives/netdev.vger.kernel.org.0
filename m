Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 342BEABA7B
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394086AbfIFOPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:15:47 -0400
Received: from inva020.nxp.com ([92.121.34.13]:48496 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731458AbfIFOPr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 10:15:47 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6BD1C1A05D4;
        Fri,  6 Sep 2019 16:15:45 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 5E6FF1A0210;
        Fri,  6 Sep 2019 16:15:45 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 22CB32061D;
        Fri,  6 Sep 2019 16:15:45 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     alexandru.marginean@nxp.com, netdev@vger.kernel.org
Subject: [PATCH net-next 0/5] enetc: Link mode init w/o bootloader
Date:   Fri,  6 Sep 2019 17:15:39 +0300
Message-Id: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The theme of this set is to clear the dependency on bootloader
for PHY link mode protocol init (i.e. SGMII, SXGMII) and MAC
configuration for the ENETC controller.

First patch fixes the DT extracted PHY mode handling.
The second one is a refactoring that prepares the introduction
of the internal MDIO bus.
Internal MDIO bus support is added along with SerDes protocol
configuration routines (3rd patch).
Then after a minor cleanup (patch 4), DT link mode information
is being used to configure the MAC instead of relying on
bootloader configurations.

Alex Marginean (1):
  enetc: Use DT protocol information to set up the ports

Claudiu Manoil (4):
  enetc: Fix if_mode extraction
  enetc: Make mdio accessors more generic
  enetc: Initialize SerDes for SGMII and SXGMII protocols
  enetc: Drop redundant device node check

 .../net/ethernet/freescale/enetc/enetc_hw.h   |  18 +++
 .../net/ethernet/freescale/enetc/enetc_mdio.c |  91 +++++++++----
 .../net/ethernet/freescale/enetc/enetc_mdio.h |   2 +-
 .../ethernet/freescale/enetc/enetc_pci_mdio.c |   2 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 127 +++++++++++++-----
 .../net/ethernet/freescale/enetc/enetc_pf.h   |   5 +
 6 files changed, 182 insertions(+), 63 deletions(-)

-- 
2.17.1

