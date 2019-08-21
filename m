Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 086F6987D1
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbfHUX10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:27:26 -0400
Received: from mail.nic.cz ([217.31.204.67]:38012 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727644AbfHUX10 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:27:26 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id A599D140C5E;
        Thu, 22 Aug 2019 01:27:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566430044; bh=oxdsx60oSz5zYcAM7p8CMIfkwNNXooOid+pNf2LNQ80=;
        h=From:To:Date;
        b=fn7Y5O1fr4VQSk9uv1lybvG2z9Sh6Lmw8UVGZ24+/GRJU4tDitfhUxnjAbd6tSRDk
         ZsbLYY7kaCK0wdQU5GMsWYmb0W6JSbM8SgzGF+YNSv40yDqxFgfGqgM6IQxfLre7a0
         Sy8KbcMikd+Ng9CXQ3uYWcSMZ1bdesN61wnXYpb0=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next 00/10] net: dsa: mv88e6xxx: Peridot/Topaz SERDES changes
Date:   Thu, 22 Aug 2019 01:27:14 +0200
Message-Id: <20190821232724.1544-1-marek.behun@nic.cz>
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

I am sending some changes for the Topaz/Peridot family of switches.
These patches apply on net-next/master.
Summary:
 - patch 1 adds support for 2500base-x mode in the SERDES IRQ handler
 - patches 2, 4 and 7 are cosmetic patches
 - patch 3 moves the code that manipulates hidden registers into it's
   own file
 - patch 5 adds .serdes_get_lane() method into the operations structure,
   so that we can call it instead of the specific implementations
 - patch 6 adds implementation of .serdes_get_lane() for the Topaz
   family
 - patch 8 simplifies SERDES code for Topaz and Peridot, which can be
   done because of the new .serdes_get_lane() method
 - patch 9 adds support for one more parameter (Block Address) in the
   hidden_read and hidden_write functions
 - patch 10 adds full support for SERDES on the Topaz family

Marek

Marek Behún (10):
  net: dsa: mv88e6xxx: support 2500base-x in SGMII IRQ handler
  net: dsa: mv88e6xxx: remove extra newline
  net: dsa: mv88e6xxx: move hidden registers operations in own file
  net: dsa: mv88e6xxx: prefix hidden register macro names with
    MV88E6XXX_
  net: dsa: mv88e6xxx: create chip->info->ops->serdes_get_lane method
  net: dsa: mv88e6xxx: add serdes_get_lane method for Topaz family
  net: dsa: mv88e6xxx: rename port cmode macro
  net: dsa: mv88e6xxx: simplify SERDES code for Topaz and Peridot
  net: dsa: mv88e6xxx: support Block Address setting in hidden registers
  net: dsa: mv88e6xxx: fully support SERDES on Topaz family

 drivers/net/dsa/mv88e6xxx/Makefile |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c   |  89 ++++---------
 drivers/net/dsa/mv88e6xxx/chip.h   |   3 +
 drivers/net/dsa/mv88e6xxx/hidden.c |  69 ++++++++++
 drivers/net/dsa/mv88e6xxx/hidden.h |  33 +++++
 drivers/net/dsa/mv88e6xxx/port.c   |  89 +++++++++----
 drivers/net/dsa/mv88e6xxx/port.h   |  16 +--
 drivers/net/dsa/mv88e6xxx/serdes.c | 194 +++++++++++++----------------
 drivers/net/dsa/mv88e6xxx/serdes.h |   9 +-
 9 files changed, 291 insertions(+), 212 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/hidden.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/hidden.h

-- 
2.21.0

