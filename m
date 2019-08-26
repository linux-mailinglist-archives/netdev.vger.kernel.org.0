Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4109E9CF7E
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 14:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731982AbfHZMVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 08:21:19 -0400
Received: from mail.nic.cz ([217.31.204.67]:58442 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727234AbfHZMVS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 08:21:18 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id C3E61140B28;
        Mon, 26 Aug 2019 14:21:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566822076; bh=LsZbIdUQhjIqGvnJ1hKt5NjYacLNqkCivJhOZta1Yxc=;
        h=From:To:Date;
        b=evRGdQpPPAgfLfalElk3xdFEpUDn90xDt4j96QfGo2u6ssDEz9QuTeKd5Y003TCUA
         yJXTvP5uvBPanngEZZ2adbA5slDyu9L+2gSNdaIjSgqihs2jpVeIA5H4Id21oymmuH
         rDtQTqS409YN4FODZujFB/XHSoLI1MTt/suV6mnA=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v4 0/6] net: dsa: mv88e6xxx: Peridot/Topaz SERDES changes
Date:   Mon, 26 Aug 2019 14:21:03 +0200
Message-Id: <20190826122109.20660-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this is the fourth version of changes for the Topaz/Peridot family of
switches. The patches apply on net-next.
Changes since v3:
 - there was a mistake in the serdes_get_lane implementations for
   6390 (patch 3/6). These methods returned -ENODEV if no lane was
   to be on port, but they should return 0. This is now fixed.

Tested on Turris Mox with Peridot, Topaz, and Peridot + Topaz.

Marek

Marek Behún (6):
  net: dsa: mv88e6xxx: support 2500base-x in SGMII IRQ handler
  net: dsa: mv88e6xxx: update code operating on hidden registers
  net: dsa: mv88e6xxx: create serdes_get_lane chip operation
  net: dsa: mv88e6xxx: simplify SERDES code for Topaz and Peridot
  net: dsa: mv88e6xxx: rename port cmode macro
  net: dsa: mv88e6xxx: fully support SERDES on Topaz family

 drivers/net/dsa/mv88e6xxx/Makefile      |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c        |  88 +++-----
 drivers/net/dsa/mv88e6xxx/chip.h        |   3 +
 drivers/net/dsa/mv88e6xxx/port.c        |  98 ++++++---
 drivers/net/dsa/mv88e6xxx/port.h        |  30 ++-
 drivers/net/dsa/mv88e6xxx/port_hidden.c |  70 ++++++
 drivers/net/dsa/mv88e6xxx/serdes.c      | 275 +++++++++++-------------
 drivers/net/dsa/mv88e6xxx/serdes.h      |  27 ++-
 8 files changed, 333 insertions(+), 259 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/port_hidden.c

-- 
2.21.0

