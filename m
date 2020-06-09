Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8931F1F364A
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 10:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgFIIrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 04:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728196AbgFIIrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 04:47:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8677C08C5C3
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 01:47:41 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jiZun-0008CA-4X; Tue, 09 Jun 2020 10:47:25 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jiZuh-0003gS-BX; Tue, 09 Jun 2020 10:47:19 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        "John W. Linville" <linville@tuxdriver.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH v3 0/3] Add support for SQI and master-slave
Date:   Tue,  9 Jun 2020 10:47:15 +0200
Message-Id: <20200609084718.14110-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is extending ethtool to make it more usable on automotive
PHYs like NXP TJA11XX.

They make use of new KAPI (currently in net-next, will go probably to the
kernel 5.8-rc1):
- PHY master-slave role configuration and status informaton. Mostly needed
  for 100Base-T1 PHYs due the lack of autonegatiation support.
- Signal Quality Index to investigate cable related issues.

changes v3:
- rename "Port mode" to "master-slave"
- use [preferred|forced]-[master|slave] for information and
  configuration

changes v2:
- add master-slave information to the "ethtool --help" and man page
- move KAPI update changes to the separate patch. 

Oleksij Rempel (3):
  update UAPI header copies
  netlink: add master/slave configuration support
  netlink: add LINKSTATE SQI support

 ethtool.8.in                 |  19 ++
 ethtool.c                    |   1 +
 netlink/desc-ethtool.c       |   4 +
 netlink/settings.c           |  66 +++++++
 uapi/linux/ethtool.h         |  25 ++-
 uapi/linux/ethtool_netlink.h | 326 +++++++++++++++++++++++++++++++++++
 uapi/linux/genetlink.h       |   2 +
 uapi/linux/if_link.h         |   7 +-
 uapi/linux/net_tstamp.h      |   6 +
 uapi/linux/netlink.h         | 103 +++++++++++
 uapi/linux/rtnetlink.h       |   6 +
 11 files changed, 561 insertions(+), 4 deletions(-)

-- 
2.27.0

