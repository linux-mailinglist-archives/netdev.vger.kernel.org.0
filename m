Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0CA72956B
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390366AbfEXKGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:06:04 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:35921 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389745AbfEXKGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 06:06:03 -0400
X-Originating-IP: 90.88.147.134
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 559E740013;
        Fri, 24 May 2019 10:05:58 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 0/5] net: mvpp2: Classifier updates, RSS
Date:   Fri, 24 May 2019 12:05:49 +0200
Message-Id: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

Here is a set of updates for the PPv2 classifier, the main feature being
the support for steering to RSS contexts, to leverage all the available
RSS tables in the controller.

The first two patches are non-critical fixes for the classifier, the
first one prevents us from allocating too much room to store the
classification rules, the second one configuring the C2 engine as
suggested by the PPv2 functionnal specs.

Patches 3 to 5 introduce support for RSS contexts in mvpp2, allowing us
to steer traffic to dedicated RSS tables.

Thanks,

Maxime

Maxime Chevallier (5):
  net: mvpp2: cls: Use the correct number of rules in various places
  net: mvpp2: cls: Bypass C2 internals FIFOs at init
  net: mvpp2: cls: Use RSS contexts to handle RSS tables
  net: mvpp2: cls: Extract the RSS context when parsing the ethtool rule
  net: mvpp2: cls: Support steering to RSS contexts

 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  20 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    | 272 ++++++++++++++++--
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.h    |  15 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  67 ++++-
 4 files changed, 326 insertions(+), 48 deletions(-)

-- 
2.20.1

