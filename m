Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0992A42042
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 11:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407924AbfFLJIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 05:08:22 -0400
Received: from nsg-static-220.246.72.182.airtel.in ([182.72.246.220]:48466
        "EHLO swlab-raju.vitesse.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407716AbfFLJIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 05:08:22 -0400
X-Greylist: delayed 655 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jun 2019 05:08:22 EDT
Received: by swlab-raju.vitesse.org (Postfix, from userid 1001)
        id 3FDBF1521A92; Wed, 12 Jun 2019 14:27:10 +0530 (IST)
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, f.fainelli@gmail.com, andrew@lunn.ch,
        Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Subject: [RFC, net-next v0 0/2] Microsemi PHY cable
Date:   Wed, 12 Jun 2019 14:27:05 +0530
Message-Id: <1560329827-6345-1-git-send-email-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches add the Microsemi PHY cable diagnostics command 
with PHY Netlink Interface.

1. phy_netlink.c and phy_netlink.h files add for PHY diagnostics features
implementation through PHY Netlink interface.
2. phy.c contain the generic functions of "PHY diagnostics". This layer
independ of the communication layer (i.e. Netlink or IOCTL etc)
3. mscc.c contain the 4-pair ethernet PHY driver along with
PHY diagnostics feature.

Patches test on VSC8531 Microsemi PHY - Beaglebone Black target

Test results:
------------
# nl-app eth0 request
GroupID = 2
GroupName = phy_monitor

Cable Diagnostics Request:
Operation Status : Success
Cable Pairs mask : 0xf
Timeout count    : 84
Cable diagnostics results:
    Pair A: Correctly terminated pair, Loop Length: 0 m
    Pair B: Correctly terminated pair, Loop Length: 0 m
    Pair C: Correctly terminated pair, Loop Length: 0 m
    Pair D: Correctly terminated pair, Loop Length: 0 m
 
Application git repository path:
-------------------------------
https://github.com/lakkarajun/bbb_nl_app

Raju Lakkaraju (2):
  net: phy: mscc: Add PHY Netlink Interface along with Cable Diagnostics
    command
  net: phy: mscc: Add PHY driver for Cable Diagnostics command

 drivers/net/phy/Kconfig       |   6 ++
 drivers/net/phy/Makefile      |   1 +
 drivers/net/phy/mscc.c        | 128 ++++++++++++++++++++++++
 drivers/net/phy/phy.c         |  17 ++++
 drivers/net/phy/phy_netlink.c | 226 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h           |  88 ++++++++++++++++
 include/linux/phy_netlink.h   |  48 +++++++++
 7 files changed, 514 insertions(+)
 create mode 100644 drivers/net/phy/phy_netlink.c
 create mode 100644 include/linux/phy_netlink.h

-- 
2.7.4

