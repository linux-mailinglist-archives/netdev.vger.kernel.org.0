Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036381E26D8
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731342AbgEZQXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 12:23:32 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:63081 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730394AbgEZQX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:23:28 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 4AEA34000A;
        Tue, 26 May 2020 16:23:26 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: [PATCH net-next 0/4] net: phy: mscc-miim: reduce waiting time between MDIO transactions
Date:   Tue, 26 May 2020 18:22:52 +0200
Message-Id: <20200526162256.466885-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series aims at reducing the waiting time between MDIO transactions
when using the MSCC MIIM MDIO controller.

I'm not sure we need patch 4/4 and we could reasonably drop it from the
series. I'm including the patch as it could help to ensure the system
is functional with a non optimal configuration.

We needed to improve the driver's performances as when using a PHY
requiring lots of registers accesses (such as the VSC85xx family),
delays would add up and ended up to be quite large which would cause
issues such as: a slow initialization of the PHY, and issues when using
timestamping operations (this feature will be sent quite soon to the
mailing lists).

Thanks,
Antoine

Antoine Tenart (4):
  net: phy: mscc-miim: use more reasonable delays
  net: phy: mscc-miim: remove redundant timeout check
  net: phy: mscc-miim: improve waiting logic
  net: phy: mscc-miim: read poll when high resolution timers are
    disabled

 drivers/net/phy/Kconfig          |  3 ++-
 drivers/net/phy/mdio-mscc-miim.c | 33 +++++++++++++++++++++++++-------
 2 files changed, 28 insertions(+), 8 deletions(-)

-- 
2.26.2

