Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCC1BE8EC1
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 18:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbfJ2R5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 13:57:07 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:43361 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfJ2R5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 13:57:06 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 77DE622E07;
        Tue, 29 Oct 2019 18:48:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572371332;
        bh=RCNspeC1Ti2bR8xaR18uPqh3L4hI0ngXx7w3MFF8udI=;
        h=From:To:Cc:Subject:Date:From;
        b=tX4838poUDH8IDslIqg8j1gOEwLUI3122XfqbRIer1pvk+V3pgABHPskWha53Thl6
         N/kPKE22LlJdqHvBEDjCqC5hFYyRL/QZacQDVEWBq/BGLuNlVsjslCK9inA59Bkn17
         E7eFwQE2cCh0VVGWrn3ETVe09bNuaosvWVnXEH6Y=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/3] net: phy: initialize PHYs via device tree properties
Date:   Tue, 29 Oct 2019 18:48:16 +0100
Message-Id: <20191029174819.3502-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was trying to configure the Atheros PHY for my board. There are fixups
all over the place, for example to enable the 125MHz clock output in almost
any i.MX architecture. Instead of adding another fixup in architecture
specific code, try to provide a generic way to init the PHY registers.

This patch series tries to pick up the "broadcom,reg-init" and
"marvell,reg-init" device tree properties idea and make it a more generic
"reg-init" which is handled by phy_device instead of a particular phy
driver.

Michael Walle (3):
  dt-bindings: net: phy: Add reg-init property
  net: phy: export __phy_{read|write}_page
  net: phy: Use device tree properties to initialize any PHYs

 .../devicetree/bindings/net/ethernet-phy.yaml | 31 ++++++
 MAINTAINERS                                   |  1 +
 drivers/net/phy/phy-core.c                    | 24 ++++-
 drivers/net/phy/phy_device.c                  | 97 ++++++++++++++++++-
 include/dt-bindings/net/phy.h                 | 18 ++++
 include/linux/phy.h                           |  2 +
 6 files changed, 170 insertions(+), 3 deletions(-)
 create mode 100644 include/dt-bindings/net/phy.h

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>

-- 
2.20.1

