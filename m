Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F4449F7DC
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 12:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348056AbiA1LIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 06:08:38 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:39359 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348018AbiA1LIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 06:08:30 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D8097100002;
        Fri, 28 Jan 2022 11:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643368107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rOgnF39nJ4WjkUt9EjPNDK2qMMF7SgmIh7VdDAIJW6I=;
        b=J04MAzoKxRw4YkfydEfg0iLJzqwqzF4pz/VoaIRYJwb5X0OsdA1P3/owe40vgoVuPNohwt
        Y6DVvhn2wFVrxlFz7c2uaHP4eD5IGObEp27gWoXLrDyPgz88HXRXB328CHY3X86oqaaKdK
        SJ8sRf7WFh7omXQq3kPX3pOO1ZLnXher/L3yJ/Q12wAh4O38IE86qznu2ZXHncxLAeHWzw
        eN7rz47wzQfp3VyLuIgPFG7ae4aQp2P7l1BFPL6bS3w27DME7YS00DEXR9iSp2Dit+F+vn
        MqUAOrEU6Qrx1efsyl64ettPHw91f1QobCRw4RNaSQYMj/uZsDwM+CZc8hCsdw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v2 0/5] ieee802154: Improve durations handling
Date:   Fri, 28 Jan 2022 12:08:20 +0100
Message-Id: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These paches try to enhance the support of the various delays by adding
into the core the necessary logic to derive the actual symbol duration
(and then the lifs/sifs durations) depending on the protocol used. The
symbol duration type is also updated to fit smaller numbers.

Having the symbol durations properly set is a mandatory step in order to
use the scanning feature that will soon be introduced.

Miquel Raynal (5):
  net: ieee802154: Improve the way supported channels are declared
  net: ieee802154: Give more details to the core about the channel
    configurations
  net: mac802154: Convert the symbol duration into nanoseconds
  net: mac802154: Set durations automatically
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

