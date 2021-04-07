Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03DF3575D5
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbhDGUX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:23:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356084AbhDGUXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:23:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99C166100A;
        Wed,  7 Apr 2021 20:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827014;
        bh=3pp/V5WqRTMXmzvQNlzMjpnEPlUPC9IV8V62zXrSulY=;
        h=From:To:Cc:Subject:Date:From;
        b=Kg8xD3hkBCF+xv9xm0Jn+erl+1G8ArTyI0sKP0YNDJJtmsFic/oHI4noAH/dFln7E
         CkkQv89OERcQiRc5B72m1OVmGm5vmPtVd34eQTaoDTW/A6FQIbgsbIJP9pxKtzZWq1
         dLIExhdxAJz/AP+4qCY4JiJrLxkDBVznfXYIM8/pjv45DA3hIvJMviOTEM3FrZVr6p
         Fe4LgPhsJZzZF9ClGI24qLxrTVGwMsoUWHfzI66lkUTFarBhHo6fFBZOc6VjhLyXVC
         AMG0kh44TvIF1Pn1GPaIAZPMOBMfvbM0/2Xrfh5LsoWhcbwSTUsy1W9aknsW1t7vzA
         O6+1pzGnmqMrw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 00/16] net: phy: marvell10g updates
Date:   Wed,  7 Apr 2021 22:22:38 +0200
Message-Id: <20210407202254.29417-1-kabel@kernel.org>
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

Changes since v3:
- added Andrew's Reviewed-by tags
- removed patches adding variadic-macro library and bitmap
  initialization macro - it causes warning that we are not currently
  able to fix easily. Instead the supported_interfaces bitmap is now
  initialized via a chip specific method
- added explanation of mactype initialization to commit message of patch
  07/16
- fixed repeated word in commit message of second to last patch

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

Marek Behún (16):
  net: phy: marvell10g: rename register
  net: phy: marvell10g: fix typo
  net: phy: marvell10g: allow 5gbase-r and usxgmii
  net: phy: marvell10g: indicate 88X33x0 only port control registers
  net: phy: marvell10g: add all MACTYPE definitions for 88X33x0
  net: phy: marvell10g: add MACTYPE definitions for 88E21xx
  net: phy: marvell10g: support all rate matching modes
  net: phy: marvell10g: check for correct supported interface mode
  net: phy: marvell10g: store temperature read method in chip strucutre
  net: phy: marvell10g: support other MACTYPEs
  net: phy: marvell10g: add separate structure for 88X3340
  net: phy: marvell10g: fix driver name for mv88e2110
  net: phy: add constants for 2.5G and 5G speed in PCS speed register
  net: phy: marvell10g: differentiate 88E2110 vs 88E2111
  net: phy: marvell10g: change module description
  MAINTAINERS: add myself as maintainer of marvell10g driver

 MAINTAINERS                  |   1 +
 drivers/net/phy/marvell10g.c | 384 +++++++++++++++++++++++++++++------
 include/linux/marvell_phy.h  |   6 +-
 include/uapi/linux/mdio.h    |   2 +
 4 files changed, 333 insertions(+), 60 deletions(-)

-- 
2.26.2

