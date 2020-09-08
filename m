Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6092607D6
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 02:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgIHAwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 20:52:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48814 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728088AbgIHAwb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 20:52:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kFRro-00Di69-7x; Tue, 08 Sep 2020 02:52:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 0/7] net: dsa: mv88e6xxx: Add devlink regions support
Date:   Tue,  8 Sep 2020 02:51:48 +0200
Message-Id: <20200908005155.3267736-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of devlink regions to allow read access to some of the
internal of the switches. The switch itself will never trigger a
region snapshot, it is assumed it is performed from user space as
needed.

v2:
Remove left of debug print
Comment ATU format is generic to mv88e6xxx
Combine declaration and the assignment on a single line.

Andrew Lunn (7):
  net: dsa: Add helper to convert from devlink to ds
  net: dsa: Add devlink regions support to DSA
  net: dsa: mv88e6xxx: Move devlink code into its own file
  net: dsa: mv88e6xxx: Create helper for FIDs in use
  net: dsa: mv88e6xxx: Add devlink regions
  net: dsa: wire up devlink info get
  net: dsa: mv88e6xxx: Implement devlink info get callback

 drivers/net/dsa/mv88e6xxx/Makefile  |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c    | 290 ++----------
 drivers/net/dsa/mv88e6xxx/chip.h    |  14 +
 drivers/net/dsa/mv88e6xxx/devlink.c | 686 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/devlink.h |  21 +
 include/net/dsa.h                   |  13 +-
 net/dsa/dsa.c                       |  36 +-
 net/dsa/dsa2.c                      |  19 +-
 8 files changed, 807 insertions(+), 273 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/devlink.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/devlink.h

-- 
2.28.0

