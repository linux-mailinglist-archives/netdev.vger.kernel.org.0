Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A3D682AF1
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjAaK6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjAaK6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:58:05 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC53DB469;
        Tue, 31 Jan 2023 02:58:03 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 26FDDC000A;
        Tue, 31 Jan 2023 10:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675162682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dwXbGWxyljGp3lNjRbwA7G7wCPaKvF9kyuYS7yoepok=;
        b=Q0thTiuQH58l6D0C1TV5XfwoifURTvgyzWmh7ISqtoTG/hp7OhN6D0/lIMK23OIl3ab7Xj
        AUdS9vqY8WenhFkPp5H110baDkuhIOY6m3fro7hTz2OsXVlE2lMrjeQbxMcJGIxu1eBh1b
        l2sS+hSwur9/33wWsJSVqKx+2VIqXCZOzBFRp6r/OwQmlMPZdG5/6Yg/Q0JEnQd2FcFghk
        IXK/AE5e8VbyWxHpka8h7K0V3Wh97Kig4oEYla04vQF0WZzoXHEE65G612OoirmjczsEMJ
        jjpZqwgz43qrU+aNu2hRT7ucQfXbBApuNJbTD85c89bDdUAjpxD+EzkwcL9E1A==
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
Subject: [wpan-next 0/4] ieee802154: Active scan support
Date:   Tue, 31 Jan 2023 11:57:53 +0100
Message-Id: <20230131105757.163034-1-miquel.raynal@bootlin.com>
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

Hello,
Following the initial support for passive scan and beaconing, here is an
addition to support active scans.
Thanks,
Miquèl

Miquel Raynal (4):
  ieee802154: Add support for user active scan requests
  mac802154: Handle active scanning
  ieee802154: Add support for allowing to answer BEACON_REQ
  mac802154: Handle received BEACON_REQ

 include/net/ieee802154_netdev.h | 20 +++++++++-
 net/ieee802154/header_ops.c     | 36 +++++++++++++++++
 net/ieee802154/nl802154.c       |  3 +-
 net/mac802154/ieee802154_i.h    | 21 ++++++++++
 net/mac802154/main.c            |  2 +
 net/mac802154/rx.c              | 70 ++++++++++++++++++++++++++++++++-
 net/mac802154/scan.c            | 65 +++++++++++++++++++++++++++---
 7 files changed, 209 insertions(+), 8 deletions(-)

-- 
2.34.1

