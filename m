Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD5418CBE3
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 11:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbgCTKlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 06:41:01 -0400
Received: from inva020.nxp.com ([92.121.34.13]:51626 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgCTKlA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 06:41:00 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 175341A055F;
        Fri, 20 Mar 2020 11:40:59 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E59DA1A0538;
        Fri, 20 Mar 2020 11:40:52 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 351E4402E4;
        Fri, 20 Mar 2020 18:40:45 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: [PATCH 0/6] Support programmable pins for Ocelot PTP driver
Date:   Fri, 20 Mar 2020 18:37:20 +0800
Message-Id: <20200320103726.32559-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ocelot PTP clock driver had been embedded into ocelot.c driver.
It had supported basic gettime64/settime64/adjtime/adjfine functions
by now which were used by both Ocelot switch and Felix switch.

This patch-set is to move current ptp clock code out of ocelot.c driver
maintaining as a single ptp_ocelot.c driver, and to implement 4
programmable pins (with only periodic signal function for now).

Yangbo Lu (6):
  ptp: move ocelot ptp clock code out of Ethernet driver
  MAINTAINERS: add entry for Microsemi Ocelot PTP driver
  net: mscc: ocelot: fix timestamp info if ptp clock does not work
  net: mscc: ocelot: redefine PTP pins
  net: mscc: ocelot: add wave programming registers definitions
  ptp_ocelot: support 4 programmable pins

 MAINTAINERS                                        |   9 +
 drivers/net/dsa/ocelot/felix.c                     |   3 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   2 +
 drivers/net/ethernet/mscc/ocelot.c                 | 207 +-------------
 drivers/net/ethernet/mscc/ocelot.h                 |   3 +-
 drivers/net/ethernet/mscc/ocelot_board.c           |   1 +
 drivers/net/ethernet/mscc/ocelot_regs.c            |   2 +
 drivers/ptp/Kconfig                                |  10 +
 drivers/ptp/Makefile                               |   1 +
 drivers/ptp/ptp_ocelot.c                           | 310 +++++++++++++++++++++
 include/soc/mscc/ocelot.h                          |  15 +-
 .../net/ethernet => include/soc}/mscc/ocelot_ptp.h |   3 +
 include/soc/mscc/ptp_ocelot.h                      |  34 +++
 13 files changed, 395 insertions(+), 205 deletions(-)
 create mode 100644 drivers/ptp/ptp_ocelot.c
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_ptp.h (88%)
 create mode 100644 include/soc/mscc/ptp_ocelot.h

-- 
2.7.4

