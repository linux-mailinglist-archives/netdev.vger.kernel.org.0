Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46331CC4FA
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 00:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgEIWh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 18:37:26 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:40931 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgEIWhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 18:37:25 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C15E72330D;
        Sun, 10 May 2020 00:37:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1589063844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9hojfssJbhqsQ/uiz22V0cMRGQo20ub161THuLCwtY8=;
        b=MapAS0DfXU0ZW/E+dFeXcs9kYDC3EOMJhv+zFqq0MIWI2AA7IG0nvvE+1qMFQV7MJXhFgN
        0Pw9j8fC9Lvhn4RtYKRPqmhYYpMjY4J+0Aeq0O9aZEhv7C75DjOYY+y4RgthMhzyzcwYX9
        DMzyeH7aRZzkrBvVxDVoYHWQ7qAN43E=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 0/4] net: phy: broadcom: cable tester support
Date:   Sun, 10 May 2020 00:37:10 +0200
Message-Id: <20200509223714.30855-1-michael@walle.cc>
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

Please note that this patch depends on Andrew's latest cable testing
series:
https://lore.kernel.org/netdev/20200509162851.362346-1-andrew@lunn.ch/

Michael Walle (4):
  net: phy: broadcom: add exp register access methods without buslock
  net: phy: broadcom: add bcm_phy_modify_exp()
  net: phy: broadcom: add cable test support
  net: phy: bcm54140: add cable diagnostics support

 drivers/net/phy/bcm-phy-lib.c | 264 +++++++++++++++++++++++++++++++++-
 drivers/net/phy/bcm-phy-lib.h |  10 ++
 drivers/net/phy/bcm54140.c    |   2 +
 include/linux/brcmphy.h       |  52 +++++++
 4 files changed, 321 insertions(+), 7 deletions(-)

-- 
2.20.1

