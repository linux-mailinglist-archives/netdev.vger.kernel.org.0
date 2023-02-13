Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1AA3694D77
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjBMQzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjBMQyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:54:52 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C371F920;
        Mon, 13 Feb 2023 08:54:18 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 395BB240002;
        Mon, 13 Feb 2023 16:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676307257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GmyB9xq3HJ/2XaoFjgrtKHCkpb4/v3VID6f4LCfiQXM=;
        b=SMmVzWiLhNGSViOr/MqNjNORUGP7USzokJYpnhOR/fETnBDo1OJD86WJ/yjvkQLSFBjH/M
        esnT4yJ0B5IiKtVVObFcLN7OriKzWkGIrCCafOdaVTQnUnp8ulLDP0Yl/HjR4n52tPU+1h
        FDYnAxHyWToI/xQE03uJT++/KXj5ZQME+1ePJMwDJ9s5mK2UCyoy2wYyWOWfDrqv0crH4B
        Tkt5w/7oYpKrRlBxfQcK/8FzF6ceIDSUIIqI1lSCFSN/gzDCOaKnI0a30CfmEjjaAsNF6f
        x+1k51xRISEfHg4rRTouEC6S7yml9/9QjIRGcJRxqJl0MwUQUtdS5IUN/AkfWw==
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
Subject: [PATCH wpan 0/6] ieee802154: Scan/Beacon fixes
Date:   Mon, 13 Feb 2023 17:54:08 +0100
Message-Id: <20230213165414.1168401-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Following Jakub's review on Stefan's MR, a number of changes were
requested for him in order to pull the patches in net. In the mean time,
a couple of discussions happened with Alexander (return codes for
monitor scans and transmit helper used for beacons).

Hopefully this series addresses everything.

Thanks,
Miquèl

Miquel Raynal (6):
  ieee802154: Use netlink policies when relevant on scan parameters
  ieee802154: Convert scan error messages to extack
  ieee802154: Change error code on monitor scan netlink request
  mac802154: Send beacons using the MLME Tx path
  mac802154: Fix an always true condition
  ieee802154: Drop device trackers

 net/ieee802154/nl802154.c | 125 ++++++++++++++------------------------
 net/mac802154/scan.c      |  25 ++++++--
 2 files changed, 65 insertions(+), 85 deletions(-)

-- 
2.34.1

