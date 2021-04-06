Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DB3355E8F
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 00:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhDFWLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 18:11:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229723AbhDFWLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 18:11:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0CB9613CD;
        Tue,  6 Apr 2021 22:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617747104;
        bh=I6Q5/rhY+lnlZbhOxFWjymXM4WRnUDguGGgA8INMQro=;
        h=From:To:Cc:Subject:Date:From;
        b=uDUJ/Y+dx/7GTxnyPwqfMmT4TxY/x3iwDr34jV7BPaqovI0NuGEoPcTkfgtutsFsM
         dASDAAPjTyionKlFAULPsp5wm4kztFkXzDSgDuXuhFgvDtYG7oyhsR7fASzQcW+WHE
         iSdMjcMvxAtrh/qGlvHP80WgB0J1Kmpshq3JGgBKEUCUY663nYCu12FOZDspGl82Nt
         H1O+pR6qPWRK+dEjZIXWtQckGh8tQfGv7TRU0zyP2xjI0OhI2hN4/O52CYHwpMzFSk
         IWLBEGfHpT5hh+ou/OZ0me+JGsnBqeebEkq3979mKPntG6TS9Q2a7NH9TsU6JX4XIx
         HQLRBrKtcC+Eg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v3 00/18] net: phy: marvell10g updates
Date:   Wed,  7 Apr 2021 00:10:49 +0200
Message-Id: <20210406221107.1004-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are some updates for marvell10g PHY driver.

I am still working on some more changes for this driver, but I would
like to have at least something reviewed / applied.

Changes since v2:
- code refactored to use an additional structure mv3310_chip describing
  mv3310 specific properties / operations for PHYs supported by this
  driver
- added separate phy_driver structures for 88X3340 and 88E2111
- removed 88E2180 specific code (dual-port and quad-port SXGMII modes
  are ignored for now)

Changes since v1:
- added various MACTYPEs support also for 88E21XX
- differentiate between specific models with same PHY_ID
- better check for compatible interface
- print exact model

Marek Behún (18):
  net: phy: marvell10g: rename register
  net: phy: marvell10g: fix typo
  net: phy: marvell10g: allow 5gbase-r and usxgmii
  net: phy: marvell10g: indicate 88X33x0 only port control registers
  net: phy: marvell10g: add all MACTYPE definitions for 88X33x0
  net: phy: marvell10g: add MACTYPE definitions for 88E21xx
  net: phy: marvell10g: support all rate matching modes
  include: add library helpers for variadic macro expansion
  include: bitmap: add macro for bitmap initialization
  net: phy: marvell10g: check for correct supported interface mode
  net: phy: marvell10g: store temperature read method in chip strucutre
  net: phy: marvell10g: support other MACTYPEs
  net: phy: marvell10g: add separate structure for 88X3340
  net: phy: marvell10g: fix driver name for mv88e2110
  net: phy: add constants for 2.5G and 5G speed in PCS speed register
  net: phy: marvell10g: differentiate 88E2110 vs 88E2111
  net: phy: marvell10g: change module description
  MAINTAINERS: add myself as maintainer of marvell10g driver

 MAINTAINERS                    |   1 +
 drivers/net/phy/marvell10g.c   | 369 +++++++++++++++++++++++++++------
 include/linux/bitmap.h         |  24 +++
 include/linux/marvell_phy.h    |   6 +-
 include/linux/variadic-macro.h | 221 ++++++++++++++++++++
 include/uapi/linux/mdio.h      |   2 +
 6 files changed, 562 insertions(+), 61 deletions(-)
 create mode 100644 include/linux/variadic-macro.h

-- 
2.26.2

