Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F521D6CB3
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgEQT7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:59:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36248 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgEQT7C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 15:59:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xmusiM6K19tphwSLZwR25/NXWnZ1OD6/au1PxLg894Q=; b=rxWoF8oiHUxocp93I+gwSTJ0rj
        +INfBNgNkBaFLdbYHuM308B4661aqUGTb2p1nmVZ63QHooW7BQ4W25Sg+wRscyqyESBwEeq1m9ylA
        Z/hMYfEf/iBA7xdZ9WnPzmIO/qB33kYf1rCmzD69C/jz9hGi3J690+UlKfxUmTgbDB88=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jaPR6-002YoS-1a; Sun, 17 May 2020 21:59:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/7] Raw PHY TDR data
Date:   Sun, 17 May 2020 21:58:44 +0200
Message-Id: <20200517195851.610435-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some ethernet PHYs allow access to raw TDR data in addition to summary
diagnostics information. Add support for retrieving this data via
netlink ethtool. The basic structure in the core is the same as for
normal phy diagnostics, the PHY driver simply uses different helpers
to fill the netlink message with different data.

There is a graphical tool under development, as well a ethtool(1)
which can dump the data as text and JSON.

Thanks for Chris Healy for lots of testing.

Andrew Lunn (7):
  net: ethtool: Add attributes for cable test TDR data
  net: ethtool: Add generic parts of cable test TDR
  net: ethtool: Add helpers for cable test TDR data
  net: phy: marvell: Add support for amplitude graph
  net: ethtool: Allow PHY cable test TDR data to configured
  net : phy: marvell: Speedup TDR data retrieval by only changing page
    once
  net: phy: marvell: Configure TDR pulse based on measurement length

 Documentation/networking/ethtool-netlink.rst |  79 ++++++
 drivers/net/phy/marvell.c                    | 276 ++++++++++++++++++-
 drivers/net/phy/phy.c                        |  67 ++++-
 include/linux/ethtool_netlink.h              |  25 +-
 include/linux/phy.h                          |  17 ++
 include/uapi/linux/ethtool_netlink.h         |  67 +++++
 net/ethtool/cabletest.c                      | 209 +++++++++++++-
 net/ethtool/netlink.c                        |   5 +
 net/ethtool/netlink.h                        |   1 +
 9 files changed, 734 insertions(+), 12 deletions(-)

-- 
2.26.2

