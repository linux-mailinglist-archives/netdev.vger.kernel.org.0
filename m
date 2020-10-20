Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0DC293F3A
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 17:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407829AbgJTPGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 11:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727760AbgJTPGU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 11:06:20 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0096021481;
        Tue, 20 Oct 2020 15:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603206379;
        bh=ju0GFgfmQHvknG0rXi1slSIBIIPq1+eeSrJL9EokVFI=;
        h=From:To:Cc:Subject:Date:From;
        b=00C7TIl16s5cIx1IjBqLdxVErPlqMqHpOVk3eyyB3zAkB4QNZV9LIJOEWzi3lVecu
         Czd8P2/qYZ5jKACsilypJz8/d/lTL5chDsThagttz9u4KlFWKfPK8MlWysIeW2E8Mo
         tO/hR83SHqguPkpg/w+8fIoAtF/1l5jSah8WVrBQ=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH russell-kings-net-queue v2 0/3] Support for RollBall 10G copper SFP modules
Date:   Tue, 20 Oct 2020 17:06:12 +0200
Message-Id: <20201020150615.11969-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

this series should apply on linux-arm git repository, on branch
net-queue.

Some internet providers are already starting to offer 2.5G copper
connectivity to their users. On Turris Omnia the SFP port is capable
of 2.5G speed, so we tested some copper SFP modules.

This adds support to the SFP subsystem for 10G RollBall copper modules
which contain a Marvell 88X3310 PHY. By default these modules are
configured in 10GKR only mode on the host interface, and also contain
some bad information in EEPROM (the extended_cc byte).

The PHY in these modules is also accessed via a different I2C protocol
than the standard one.

Patch 1 adds support for this different I2C MDIO bus.
Patch 2 adds support for these modules into the SFP driver.
Patch 3 changes phylink code so that a PHY can be attached even though
802.3z mode is requested.

Marek

Marek Behún (3):
  net: phy: mdio-i2c: support I2C MDIO protocol for RollBall SFP modules
  net: phy: sfp: add support for multigig RollBall modules
  net: phylink: don't fail attaching phy on 1000base-x/2500base-x mode

 drivers/net/phy/mdio-i2c.c | 196 +++++++++++++++++++++++++++++++++++--
 drivers/net/phy/phylink.c  |   4 +-
 drivers/net/phy/sfp.c      |  69 +++++++++++--
 3 files changed, 250 insertions(+), 19 deletions(-)


base-commit: a32e90737c1c92653767d3c95c63c16b9b72c6c2
-- 
2.26.2

