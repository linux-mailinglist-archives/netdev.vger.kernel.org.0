Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CC129F7DD
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbgJ2WZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgJ2WZN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 18:25:13 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1A5020FC3;
        Thu, 29 Oct 2020 22:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604010313;
        bh=mP8snJsbMCkxKhRjkP0UCStPInHog+BRvsnowDDbj0s=;
        h=From:To:Cc:Subject:Date:From;
        b=EhRq0sbpTfI/+9Lm8/xsc5iWgoPD34Isbx3POHRS1AuhRZbQNL8Xa4VAyuGLnzXb2
         Say+WHUyOW7aS85K9JI9fWF3O85D0UD2PBVei5Rg+C3XeaXVv+uX6Frw4644xZc7mM
         WBpNklCznV767S5zbmGrUtAoZ8RAy+Yw34tlR8Wg=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v2 0/5] Support for RollBall 10G copper SFP modules
Date:   Thu, 29 Oct 2020 23:25:04 +0100
Message-Id: <20201029222509.27201-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this is v2 of series adding support for RollBall/Hilink SFP modules.

Checked with:
  checkpatch.pl --max-line-length=80

Changes from v1:
- wrapped to 80 columns as per Russell's request
- initialization of RollBall MDIO I2C protocol moved from sfp.c to
  mdio-i2c.c as per Russell's request
- second patch removes the 802.3z check also from phylink_sfp_config
  as suggested by Russell
- creation/destruction of mdiobus for SFP now occurs before probing
  for PHY/after releasing PHY (as suggested by Russell)
- the last patch became a little simpler after the above was done

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <rmk+kernel@armlinux.org.uk>

Marek Behún (5):
  net: phy: mdio-i2c: support I2C MDIO protocol for RollBall SFP modules
  net: phylink: allow attaching phy for SFP modules on 802.3z mode
  net: sfp: create/destroy I2C mdiobus before PHY probe/after PHY
    release
  net: phy: marvell10g: change MACTYPE if underlying MAC does not
    support it
  net: sfp: add support for multigig RollBall transceivers

 drivers/net/mdio/mdio-i2c.c   | 232 +++++++++++++++++++++++++++++++++-
 drivers/net/phy/marvell10g.c  |  31 +++++
 drivers/net/phy/phylink.c     |   5 +-
 drivers/net/phy/sfp.c         |  67 ++++++++--
 include/linux/mdio/mdio-i2c.h |   8 +-
 5 files changed, 322 insertions(+), 21 deletions(-)


base-commit: cd29296fdfca919590e4004a7e4905544f4c4a32
-- 
2.26.2

