Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9AC2D7446
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 11:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394180AbgLKKyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 05:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404186AbgLKKyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 05:54:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFFFC0613D3
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 02:53:32 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kng3C-0008DD-06; Fri, 11 Dec 2020 11:53:26 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kng39-000232-PV; Fri, 11 Dec 2020 11:53:23 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH v5 net-next 0/2] net: dsa: add stats64 support 
Date:   Fri, 11 Dec 2020 11:53:20 +0100
Message-Id: <20201211105322.7818-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v5:
- read all stats in one regmap_bulk_read() request
- protect stats with u64_stats* helpers.

changes v4:
- do no read MIBs withing stats64 call
- change polling frequency to 0.3Hz

changes v3:
- fix wrong multiplication
- cancel port workers on remove

changes v2:
- use stats64 instead of get_ethtool_stats
- add worked to poll for the stats

Oleksij Rempel (2):
  net: dsa: add optional stats64 support
  net: dsa: qca: ar9331: export stats64

 drivers/net/dsa/qca/ar9331.c | 256 ++++++++++++++++++++++++++++++++++-
 include/net/dsa.h            |   3 +
 net/dsa/slave.c              |  14 +-
 3 files changed, 271 insertions(+), 2 deletions(-)

-- 
2.29.2

