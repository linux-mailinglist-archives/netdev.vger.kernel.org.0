Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F436C795C
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 09:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbjCXIGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 04:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbjCXIGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 04:06:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045FC23A47
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 01:06:21 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pfcRB-00077Q-IS; Fri, 24 Mar 2023 09:06:13 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pfcR8-006KcM-Qy; Fri, 24 Mar 2023 09:06:10 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pfcR7-00ENyp-G5; Fri, 24 Mar 2023 09:06:09 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net v2 0/6] net: dsa: microchip: ksz8: fixes for stable
Date:   Fri, 24 Mar 2023 09:06:02 +0100
Message-Id: <20230324080608.3428714-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v2:
- use proper Fixes tag
- add Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com> on all
  reviewed patches except the ksz8863_smi patch.

These fixes address issues such as incomplete FDB extraction, incorrect
FID extraction and configuration, incorrect timestamp extraction, and
ghost entry extraction from an empty dynamic MAC table. These updates
ensure proper functioning of the FDB/MDB functionality for the
ksz8863/ksz8873 series of chips.

Oleksij Rempel (6):
  net: dsa: microchip: ksz8: fix ksz8_fdb_dump()
  net: dsa: microchip: ksz8: fix ksz8_fdb_dump() to extract all 1024
    entries
  net: dsa: microchip: ksz8: fix offset for the timestamp filed
  net: dsa: microchip: ksz8: ksz8_fdb_dump: avoid extracting ghost entry
    from empty dynamic MAC table.
  net: dsa: microchip: ksz8863_smi: fix bulk access
  net: dsa: microchip: ksz8: fix MDB configuration with non-zero VID

 drivers/net/dsa/microchip/ksz8795.c     | 11 +++++------
 drivers/net/dsa/microchip/ksz8863_smi.c |  9 ---------
 drivers/net/dsa/microchip/ksz_common.c  | 12 ++++++------
 3 files changed, 11 insertions(+), 21 deletions(-)

-- 
2.30.2

