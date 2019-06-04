Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27F8935212
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfFDVoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:44:01 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:4701 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDVoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:44:00 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x54Lhwei011976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 4 Jun 2019 15:43:58 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x54Lhw3Y020053
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 4 Jun 2019 15:43:58 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com, andrew@lunn.ch,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next v3 00/19] Xilinx axienet driver updates (v3)
Date:   Tue,  4 Jun 2019 15:43:27 -0600
Message-Id: <1559684626-24775-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a series of enhancements and bug fixes in order to get the mainline
version of this driver into a more generally usable state, including on
x86 or ARM platforms. It also converts the driver to use the phylink API
in order to provide support for SFP modules.

Changes since v2:
-Fixed MDIO bus parent detection as suggested by Andrew Lunn
-Use clock framework to detect AXI bus clock rather than having to explicitly
 specify MDIO clock divisor
-Hold MDIO bus lock around device resets to avoid concurrent MDIO accesses
-Fix bug in "Make missing MAC address non-fatal" patch

Robert Hancock (19):
  net: axienet: Fix casting of pointers to u32
  net: axienet: Use standard IO accessors
  net: axienet: fix MDIO bus naming
  net: axienet: add X86 and ARM as supported platforms
  net: axienet: Use clock framework to get device clock rate
  net: axienet: fix teardown order of MDIO bus
  net: axienet: Re-initialize MDIO registers properly after reset
  net: axienet: Cleanup DMA device reset and halt process
  net: axienet: Make RX/TX ring sizes configurable
  net: axienet: Add DMA registers to ethtool register dump
  net: axienet: Support shared interrupts
  net: axienet: Add optional support for Ethernet core interrupt
  net: axienet: Fix race condition causing TX hang
  net: axienet: Make missing MAC address non-fatal
  net: axienet: stop interface during shutdown
  net: axienet: Fix MDIO bus parent node detection
  net: axienet: document axistream-connected attribute
  net: axienet: make use of axistream-connected attribute optional
  net: axienet: convert to phylink API

 .../devicetree/bindings/net/xilinx_axienet.txt     |  26 +-
 drivers/net/ethernet/xilinx/Kconfig                |   6 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |  35 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  | 677 ++++++++++++++-------
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c  | 112 ++--
 5 files changed, 593 insertions(+), 263 deletions(-)

-- 
1.8.3.1

