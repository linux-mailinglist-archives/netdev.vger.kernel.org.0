Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5036C4944E2
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240298AbiATAl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbiATAl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:41:27 -0500
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5CCC061574;
        Wed, 19 Jan 2022 16:41:26 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id E38A7200002;
        Thu, 20 Jan 2022 00:41:20 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Xue Liu <liuxuenetmail@gmail.com>,
        Alan Ott <alan@signal11.us>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next 0/5] ieee802154: Improve symbol duration handling
Date:   Thu, 20 Jan 2022 01:41:15 +0100
Message-Id: <20220120004120.308709-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These paches try to enhance the support of the various delays by adding
into the core the necessary logic to derive the actual symbol duration
(and then the lifs/sifs durations) depending on the protocol used.

Miquel Raynal (5):
  net: ieee802154: Improve the way supported channels are declared
  net: ieee802154: Give more details to the core about the channel
    configurations
  net: mac802154: Convert the symbol duration into nanoseconds
  net: mac802154: Set the symbol duration automatically
  net: ieee802154: Drop duration settings when the core does it already

 drivers/net/ieee802154/adf7242.c         |   3 +-
 drivers/net/ieee802154/at86rf230.c       |  66 ++++++-------
 drivers/net/ieee802154/atusb.c           |  66 ++++++-------
 drivers/net/ieee802154/ca8210.c          |   7 +-
 drivers/net/ieee802154/cc2520.c          |   3 +-
 drivers/net/ieee802154/fakelb.c          |  43 ++++++---
 drivers/net/ieee802154/mac802154_hwsim.c |  76 ++++++++++++---
 drivers/net/ieee802154/mcr20a.c          |  11 +--
 drivers/net/ieee802154/mrf24j40.c        |   3 +-
 include/net/cfg802154.h                  |  60 +++++++++++-
 net/ieee802154/core.h                    |   2 +
 net/ieee802154/nl-phy.c                  |   8 +-
 net/ieee802154/nl802154.c                |  30 ++++--
 net/mac802154/cfg.c                      |   1 +
 net/mac802154/main.c                     | 113 ++++++++++++++++++++++-
 15 files changed, 361 insertions(+), 131 deletions(-)

-- 
2.27.0

