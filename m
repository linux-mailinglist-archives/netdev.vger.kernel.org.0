Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5984B511E21
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243437AbiD0QuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243381AbiD0QuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:50:16 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6002C99C0;
        Wed, 27 Apr 2022 09:47:04 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DBE32100002;
        Wed, 27 Apr 2022 16:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651078022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3sG7L0uG944vIk1ZB058WRn4LSlgknD9d/hEe56iunk=;
        b=NHwk88Zg3YyVFRYe9zaOpzhD58Ehq4CDaY3A6zdw/0wL8WB5GEcdX6+bKcdpQDAJbalN2d
        eX+/scueKneK5F+lPLYgLatY69W0Rl7xeCGkr4RmlzfDNb5IQAccckyVb2pphw6XPNQEGU
        U5yGxKAYPWHseTGQxxuSQfOFH6E7tUtiNmC39eR9kGGZgNH5mjn/8v00fwIh5/3D3AQz3j
        fmhnEaP5d4VS45DKcRyzSJ67soLS5J4i4aOCi+xkgwbOeV1URgtf4tk6g8XWbnn3IBltw5
        jQb2U0uwkwZZVjjgdYFcZQZpjVyn0uielyhQ7cSL4NmsbQMpM2a4khONEcCAUw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 00/11] ieee802154: Synchronous Tx support
Date:   Wed, 27 Apr 2022 18:46:48 +0200
Message-Id: <20220427164659.106447-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

New series bringing support for that famous synchronous Tx API for MLME
commands.

MLME commands will be used for during scan operations.

We need to be able to be sure that all transfers finished and that no
transfer will be queued for a short moment.

Cheers,
Miquèl

Miquel Raynal (11):
  net: mac802154: Stop exporting ieee802154_wake/stop_queue()
  net: mac802154: Change the wake/stop queue prototypes
  net: mac802154: Rename the synchronous xmit worker
  net: mac802154: Rename the main tx_work struct
  net: mac802154: Follow the count of ongoing transmissions
  net: mac802154: Hold the transmit queue when relevant
  net: mac802154: Create a hot tx path
  net: mac802154: Add a warning in the hot path
  net: mac802154: Introduce a helper to disable the queue
  net: mac802154: Introduce a tx queue flushing mechanism
  net: mac802154: Introduce a synchronous API for MLME commands

 include/net/cfg802154.h      |  5 ++
 include/net/mac802154.h      | 27 -----------
 net/ieee802154/core.c        |  1 +
 net/mac802154/cfg.c          |  5 +-
 net/mac802154/ieee802154_i.h | 74 +++++++++++++++++++++++++++++-
 net/mac802154/main.c         |  2 +-
 net/mac802154/tx.c           | 88 ++++++++++++++++++++++++++++++++----
 net/mac802154/util.c         | 55 ++++++++++++++++++----
 8 files changed, 207 insertions(+), 50 deletions(-)

-- 
2.27.0

