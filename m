Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADDE0365BC
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfFEUms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:42:48 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:45354 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFEUms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 16:42:48 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x55KghDb005110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 5 Jun 2019 14:42:44 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x55Kghiq021149
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 5 Jun 2019 14:42:43 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com, andrew@lunn.ch,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next v4 00/20] Xilinx axienet driver updates (v4)
Date:   Wed,  5 Jun 2019 14:42:13 -0600
Message-Id: <1559767353-17301-1-git-send-email-hancock@sedsystems.ca>
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

Changes since v3:
-Added patch to document mdio child node
-Removed goto in backward-compatibility clock rate determination code in
 "net: axienet: Use clock framework to get device clock rate"
-Added previous Reviewed-by: tags where patches have not been modified
 since review

Robert Hancock (20):
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
  net: axienet: document device tree mdio child node
  net: axienet: Fix MDIO bus parent node detection
  net: axienet: document axistream-connected attribute
  net: axienet: make use of axistream-connected attribute optional
  net: axienet: convert to phylink API

 .../devicetree/bindings/net/xilinx_axienet.txt     |  29 +-
 drivers/net/ethernet/xilinx/Kconfig                |   6 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |  35 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  | 677 ++++++++++++++-------
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c  | 111 ++--
 5 files changed, 593 insertions(+), 265 deletions(-)

-- 
1.8.3.1

