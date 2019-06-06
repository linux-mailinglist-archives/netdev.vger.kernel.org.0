Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2BEF380AC
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfFFW3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:29:14 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:32141 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfFFW3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:29:14 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x56MTAjb007019
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 6 Jun 2019 16:29:10 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x56MTAOx028001
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 6 Jun 2019 16:29:10 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com, andrew@lunn.ch,
        davem@davemloft.net, Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next v5 00/20] Xilinx axienet driver updates (v5)
Date:   Thu,  6 Jun 2019 16:28:04 -0600
Message-Id: <1559860104-927-1-git-send-email-hancock@sedsystems.ca>
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

Changes since v4:
-Use reverse christmas tree variable order

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

