Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2186603EB
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbjAFQHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbjAFQHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:07:17 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43811FB;
        Fri,  6 Jan 2023 08:07:14 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 4C70F1884677;
        Fri,  6 Jan 2023 16:07:11 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 337982503B65;
        Fri,  6 Jan 2023 16:07:11 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 2C36191201E4; Fri,  6 Jan 2023 16:07:11 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id D6DFB91201DF;
        Fri,  6 Jan 2023 16:07:10 +0000 (UTC)
From:   "Hans J. Schultz" <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 net-next 0/3] mv88e6xxx: Add MAB offload support
Date:   Fri,  6 Jan 2023 17:05:26 +0100
Message-Id: <20230106160529.1668452-1-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set adds MAB [1] offload support in mv88e6xxx.

Patch #1: Correct default return value for mv88e6xxx_port_bridge_flags.

Patch #2: Shorten the locked section in
          mv88e6xxx_g1_atu_prob_irq_thread_fn().

Patch #3: The MAB implementation for mv88e6xxx.

LOG:
        V2:     -FID reading patch already applied, so dropped here. [1]
                -Patch #2 here as separate patch instead of part of MAB
                 implementation patch.
                -Check if fid is MV88E6XXX_FID_STANDALONE, and not if
                 fid is zero, as that is the correct check. Do not
                 report an error.
	V3:	-Fixed an overlooked mistake and reworded the commit
		 message for patch #2.

[1] https://git.kernel.org/netdev/net-next/c/4bf24ad09bc0

Hans J. Schultz (3):
  net: dsa: mv88e6xxx: change default return of
    mv88e6xxx_port_bridge_flags
  net: dsa: mv88e6xxx: shorten the locked section in
    mv88e6xxx_g1_atu_prob_irq_thread_fn()
  net: dsa: mv88e6xxx: mac-auth/MAB implementation

 drivers/net/dsa/mv88e6xxx/Makefile      |  1 +
 drivers/net/dsa/mv88e6xxx/chip.c        | 20 +++---
 drivers/net/dsa/mv88e6xxx/chip.h        | 15 +++++
 drivers/net/dsa/mv88e6xxx/global1_atu.c | 24 ++++---
 drivers/net/dsa/mv88e6xxx/switchdev.c   | 83 +++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/switchdev.h   | 19 ++++++
 6 files changed, 148 insertions(+), 14 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.h

-- 
2.34.1

