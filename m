Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78BE79B81F
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 23:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390167AbfHWV0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 17:26:07 -0400
Received: from mail.nic.cz ([217.31.204.67]:35804 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388270AbfHWV0G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 17:26:06 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 92A8F140D17;
        Fri, 23 Aug 2019 23:26:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566595564; bh=shQGBLkvIwEKW2pKCQ2JfqO1wRHSw3zKMUTM2QbDpjI=;
        h=From:To:Date;
        b=FT7t/wrzUeGe1sBipRV87RMgKC5WVid4ilOCYH5jgzxMHxmERLB/cB//6QMJTWPCf
         gwEL11gRiLK+N+HZtSD0Z5xh4+EpAfAmqd3vHZqCozVcYKcqWXyIQJKzaepWBuDxgf
         ddoBVR0wKowEY8nF7Gd9o33Qw04euWAsZnt8n0LM=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v2 0/9] net: dsa: mv88e6xxx: Peridot/Topaz SERDES changes
Date:   Fri, 23 Aug 2019 23:25:54 +0200
Message-Id: <20190823212603.13456-1-marek.behun@nic.cz>
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

this is the second version of changes for the Topaz/Peridot family of
switches. The patches apply on net-next.
Changes since v1:
 - addressed David's reverse christmas tree issue
 - as suggested by Andrew and Vivien, the hidden port register functions
   were moved to port_hidden.c and the macros remain (with changed names)
   in port.h
 - the hidden port functions were renamed from mv88e6390_* to
   mv88e6xxx_*, since they apply not only on Peridot
 - I removed the second patch, since the extra newline character it deleted
   was at a place that was reworked and moved in subsequent patch

Marek

Marek Behún (9):
  net: dsa: mv88e6xxx: support 2500base-x in SGMII IRQ handler
  net: dsa: mv88e6xxx: move hidden registers operations in own file
  net: dsa: mv88e6xxx: fix port hidden register macros
  net: dsa: mv88e6xxx: create chip->info->ops->serdes_get_lane method
  net: dsa: mv88e6xxx: add serdes_get_lane method for Topaz family
  net: dsa: mv88e6xxx: rename port cmode macro
  net: dsa: mv88e6xxx: simplify SERDES code for Topaz and Peridot
  net: dsa: mv88e6xxx: support Block Address setting in hidden registers
  net: dsa: mv88e6xxx: fully support SERDES on Topaz family

 drivers/net/dsa/mv88e6xxx/Makefile      |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c        |  88 +++--------
 drivers/net/dsa/mv88e6xxx/chip.h        |   3 +
 drivers/net/dsa/mv88e6xxx/port.c        |  88 ++++++++---
 drivers/net/dsa/mv88e6xxx/port.h        |  30 ++--
 drivers/net/dsa/mv88e6xxx/port_hidden.c |  70 +++++++++
 drivers/net/dsa/mv88e6xxx/serdes.c      | 194 ++++++++++--------------
 drivers/net/dsa/mv88e6xxx/serdes.h      |   9 +-
 8 files changed, 273 insertions(+), 210 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/port_hidden.c

-- 
2.21.0

