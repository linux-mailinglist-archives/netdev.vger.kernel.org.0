Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C5065FF92
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 12:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbjAFLbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 06:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjAFLbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 06:31:37 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCF11A073;
        Fri,  6 Jan 2023 03:31:34 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1738B1C000C;
        Fri,  6 Jan 2023 11:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1673004693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hS7wvPjpYD+YRt/6yWHg36Yax1aVk1VS5LVh5KThhKk=;
        b=RoYUrkQOh9Nr43MAGFUIbG8RoY5DnN/Fw8MUtH1pa/aBKtNZbJ8cMw7UsnSmiHbDcLn8ba
        ZJOlV99/YLQZWhJ+zKCxQ3F6ezux10BIt7t1qgCOlEmxCY8ywOozl8DOAHYTYY7WT2bf3Y
        ykjpXokUYQ+1w9gGrmeYBv5gxzaV4xjcnsMJf0MDVl8WVr73N9il6o31MKkoAfmBT3y35d
        AwwPab1hQ+eAIwtPHxVb7v6OM6C865SxNyQ98B6VrqB/vCFmlgSRzG3skDvwnS4guut5JZ
        QoeeTCjEIdIjOkMTqp6VSA23ESUcfQt/t4JnuVqRbqN2xJwGHOZOn292OxttEA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 0/2] ieee802154: Beaconing support
Date:   Fri,  6 Jan 2023 12:31:27 +0100
Message-Id: <20230106113129.694750-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Scanning being now supported, we can eg. play with hwsim to verify
everything works as soon as this series including beaconing support gets
merged.

Thanks,
Miquèl

Miquel Raynal (2):
  ieee802154: Add support for user beaconing requests
  mac802154: Handle basic beaconing

 include/net/cfg802154.h         |  23 +++++
 include/net/ieee802154_netdev.h |  16 ++++
 include/net/nl802154.h          |   3 +
 net/ieee802154/header_ops.c     |  24 +++++
 net/ieee802154/nl802154.c       |  93 ++++++++++++++++++++
 net/ieee802154/nl802154.h       |   1 +
 net/ieee802154/rdev-ops.h       |  28 ++++++
 net/ieee802154/trace.h          |  21 +++++
 net/mac802154/cfg.c             |  31 ++++++-
 net/mac802154/ieee802154_i.h    |  18 ++++
 net/mac802154/iface.c           |   3 +
 net/mac802154/main.c            |   1 +
 net/mac802154/scan.c            | 151 ++++++++++++++++++++++++++++++++
 13 files changed, 411 insertions(+), 2 deletions(-)

-- 
2.34.1

