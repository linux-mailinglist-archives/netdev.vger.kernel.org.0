Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A011C6A82
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 09:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgEFHxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 03:53:48 -0400
Received: from inva021.nxp.com ([92.121.34.21]:49626 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgEFHxs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 03:53:48 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 376A4200B13;
        Wed,  6 May 2020 09:53:46 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D8A98200B0B;
        Wed,  6 May 2020 09:53:36 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 965C2402A8;
        Wed,  6 May 2020 15:53:24 +0800 (SGT)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        linux-devel@linux.nxdi.nxp.com
Subject: [PATCH v1 net-next 0/6] net: ocelot: VCAP IS1 and ES0 support
Date:   Wed,  6 May 2020 15:48:54 +0800
Message-Id: <20200506074900.28529-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series patches adds support for VCAP IS1 and ES0 module.

VCAP IS1 supports FLOW_ACTION_VLAN_MANGLE action to filter MAC, IP,
VLAN, protocol, and TCP/UDP ports keys and retag vlan tag.

VCAP ES0 supports FLOW_ACTION_VLAN_PUSH action to filter vlan keys
and push a specific vlan tag to frames.

Vladimir Oltean (3):
  net: mscc: ocelot: introduce a new ocelot_target_{read,write} API
  net: mscc: ocelot: generalize existing code for VCAP IS2
  net: dsa: tag_ocelot: use VLAN information from tagging header when
    available

Xiaoliang Yang (3):
  net: mscc: ocelot: change vcap to be compatible with full and quad
    entry
  net: mscc: ocelot: VCAP IS1 support
  net: mscc: ocelot: VCAP ES0 support

 drivers/net/dsa/ocelot/felix.c            |   2 -
 drivers/net/dsa/ocelot/felix.h            |   2 -
 drivers/net/dsa/ocelot/felix_vsc9959.c    | 186 +++++-
 drivers/net/ethernet/mscc/ocelot.c        |  10 +
 drivers/net/ethernet/mscc/ocelot_ace.c    | 727 ++++++++++++++++------
 drivers/net/ethernet/mscc/ocelot_ace.h    |  12 +
 drivers/net/ethernet/mscc/ocelot_board.c  |   5 +-
 drivers/net/ethernet/mscc/ocelot_flower.c |  33 +-
 drivers/net/ethernet/mscc/ocelot_io.c     |  17 +
 drivers/net/ethernet/mscc/ocelot_regs.c   |  21 +-
 drivers/net/ethernet/mscc/ocelot_s2.h     |  64 --
 include/soc/mscc/ocelot.h                 |  39 +-
 include/soc/mscc/ocelot_vcap.h            | 200 +++++-
 net/dsa/tag_ocelot.c                      |  29 +
 14 files changed, 1041 insertions(+), 306 deletions(-)
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_s2.h

-- 
2.17.1

