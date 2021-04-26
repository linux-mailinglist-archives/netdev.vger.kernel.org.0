Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A239F36B098
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 11:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhDZJdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 05:33:08 -0400
Received: from inva020.nxp.com ([92.121.34.13]:42476 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232592AbhDZJc7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 05:32:59 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4AC1D1A3502;
        Mon, 26 Apr 2021 11:32:05 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 32DBD1A34EF;
        Mon, 26 Apr 2021 11:31:59 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 5B0D5402F3;
        Mon, 26 Apr 2021 11:31:51 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net-next, v2, 0/7] Support Ocelot PTP Sync one-step timestamping
Date:   Mon, 26 Apr 2021 17:37:55 +0800
Message-Id: <20210426093802.38652-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set is to support Ocelot PTP Sync one-step timestamping.
Actually before that, this patch-set cleans up and optimizes the
DSA slave tx timestamp request handling process.

Changes for v2:
	- Split tx timestamp optimization patch.
	- Updated doc patch.
	- Freed skb->cb usage in dsa core driver, and moved to device
	  drivers.
	- Other minor fixes.

Yangbo Lu (7):
  net: dsa: check tx timestamp request in core driver
  net: dsa: no longer identify PTP packet in core driver
  net: dsa: free skb->cb usage in core driver
  net: dsa: no longer clone skb in core driver
  docs: networking: timestamping: update for DSA switches
  net: mscc: ocelot: convert to ocelot_port_txtstamp_request()
  net: mscc: ocelot: support PTP Sync one-step timestamping

 Documentation/networking/timestamping.rst     | 63 ++++++++------
 .../net/dsa/hirschmann/hellcreek_hwtstamp.c   | 28 ++++---
 .../net/dsa/hirschmann/hellcreek_hwtstamp.h   |  4 +-
 drivers/net/dsa/mv88e6xxx/hwtstamp.c          | 26 ++++--
 drivers/net/dsa/mv88e6xxx/hwtstamp.h          | 10 +--
 drivers/net/dsa/ocelot/felix.c                | 19 +++--
 drivers/net/dsa/sja1105/sja1105_main.c        |  2 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c         | 16 ++--
 drivers/net/dsa/sja1105/sja1105_ptp.h         |  4 +-
 drivers/net/ethernet/mscc/ocelot.c            | 83 +++++++++++++++++--
 drivers/net/ethernet/mscc/ocelot_net.c        | 20 ++---
 include/linux/dsa/sja1105.h                   |  3 +-
 include/net/dsa.h                             | 18 +---
 include/soc/mscc/ocelot.h                     | 21 ++++-
 net/dsa/Kconfig                               |  2 +
 net/dsa/slave.c                               | 23 +----
 net/dsa/tag_ocelot.c                          | 27 +-----
 net/dsa/tag_ocelot_8021q.c                    | 41 +++------
 18 files changed, 230 insertions(+), 180 deletions(-)


base-commit: 0ea1041bfa3aa2971f858edd9e05477c2d3d54a0
-- 
2.25.1

