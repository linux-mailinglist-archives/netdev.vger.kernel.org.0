Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD162A048D
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 12:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgJ3Lol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 07:44:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgJ3Lol (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 07:44:41 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 821362076E;
        Fri, 30 Oct 2020 11:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604058280;
        bh=n0lQDJ1aDadhtoUIdx4QC67odlRAgrRW8dLghT+WIkM=;
        h=From:To:Cc:Subject:Date:From;
        b=u+iAJyIz7yiTwXs+k5pZ6auzTV+TVpd9nPsBIJctazyKz4F2F5ZNhAtNxrUwZOLwF
         6shtOp6ZhySMZQDp4drE8Fqd4sHJcyTgUfVwxXUBAycmjVFYzzCR2qpYP9fXNtl+x1
         WWYmIqDCwvvtcw1j2tiVs/o1WSz9Xy+pXGhbMBxM=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Ben Whitten <ben.whitten@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH RFC leds + net-next 0/7] netdev trigger offloading and LEDs on Marvell PHYs
Date:   Fri, 30 Oct 2020 12:44:28 +0100
Message-Id: <20201030114435.20169-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this RFC series adds API for transparent offloading of LED triggers
to hardware and implements this for the netdev trigger.
It is then used by Marvell PHY driver, which gains support for
probing LEDs connected to a PHY chip.

When a netdev trigger is enabled on a Marvell PHY LED and configured
in a compatible setting (the network device in the trigger settings must
be the one attached to the PHY, and the link/tx/rx/interval settings
must be supported by that particular LED), instead of blinking the LED
in software, blinking is done by the PHY itself.

Marek

Marek Behún (7):
  leds: trigger: netdev: don't explicitly zero kzalloced data
  leds: trigger: netdev: simplify the driver by using bit field members
  leds: trigger: add API for HW offloading of triggers
  leds: trigger: netdev: support HW offloading
  net: phy: add simple incrementing phyindex member to phy_device struct
  net: phy: add support for LEDs connected to ethernet PHYs
  net: phy: marvell: support LEDs connected on Marvell PHYs

 Documentation/leds/leds-class.rst     |  20 ++
 drivers/leds/led-triggers.c           |   1 +
 drivers/leds/trigger/ledtrig-netdev.c | 111 +++-----
 drivers/net/phy/marvell.c             | 388 +++++++++++++++++++++++++-
 drivers/net/phy/phy_device.c          | 143 ++++++++++
 include/linux/leds.h                  |  27 ++
 include/linux/ledtrig.h               |  40 +++
 include/linux/phy.h                   |  53 ++++
 8 files changed, 709 insertions(+), 74 deletions(-)
 create mode 100644 include/linux/ledtrig.h


base-commit: cd29296fdfca919590e4004a7e4905544f4c4a32
-- 
2.26.2

