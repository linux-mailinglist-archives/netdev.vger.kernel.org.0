Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40151D1B2C
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389685AbgEMQfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:35:33 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:45481 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbgEMQfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:35:33 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 34C0422FB6;
        Wed, 13 May 2020 18:35:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1589387731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oEq5wlRLOUG99yUlxbIpKcDi8/8HUwfYR3JjS9c9Gcw=;
        b=lJrZ0aJ5G69zcouyvZGme/yaEXv2Bt4Og429RV+PHnzzxuH2Dm9XX3wOZ8k6SMEDwmkPGN
        dypvjDE8rijpy0Ic+sjXRMn1WfrVwvIFkfAPRnholc/GCMEBeZG6uUHSxMRRvmARaa+OdN
        McivRfhJYWycF35+Fm0II5vclyZj6Wg=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 0/4] net: phy: broadcom: cable tester support
Date:   Wed, 13 May 2020 18:35:20 +0200
Message-Id: <20200513163524.31256-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add cable tester support for the Broadcom PHYs. Support for it was
developed on a BCM54140 Quad PHY which RDB register access.

If there is a link partner the results are not as good as with an open
cable. I guess we could retry if the measurement until all pairs had at
least one valid result.

changes since v1:
 - added Reviewed-by: tags
 - removed "div by 2" for cross shorts, just mention it in the commit
   message. The results are inconclusive if the tests are repeated. So
   just report the length as is for now.
 - fixed typo in commit message

Michael Walle (4):
  net: phy: broadcom: add exp register access methods without buslock
  net: phy: broadcom: add bcm_phy_modify_exp()
  net: phy: broadcom: add cable test support
  net: phy: bcm54140: add cable diagnostics support

 drivers/net/phy/bcm-phy-lib.c | 259 +++++++++++++++++++++++++++++++++-
 drivers/net/phy/bcm-phy-lib.h |  10 ++
 drivers/net/phy/bcm54140.c    |   3 +
 include/linux/brcmphy.h       |  52 +++++++
 4 files changed, 317 insertions(+), 7 deletions(-)

-- 
2.20.1

