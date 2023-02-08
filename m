Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D9968F2F4
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjBHQQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjBHQQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:16:11 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A1C4ABD3;
        Wed,  8 Feb 2023 08:16:09 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E7FE8C000E;
        Wed,  8 Feb 2023 16:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675872968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qlvnkFV8VWKfamM60da0SN3gJp83h4aWTne8pK7HrZY=;
        b=es879cjvBkfP0gfI8FUTFM6eNhzWD2cIimV/rYKfyAet5Bpbe1DzEqpsY+0QnEwQNzYn7n
        CxFwN6e1OShOS3YCn/HfY916OYH5LSx697sBadn4iWfXjqhdC8Eam8qKl+Xii4/rdH3zbC
        3phTWO7byyg88z3yKxm8O3LApyokemiF17/B8falmK/WySogP74qi2qI+UPXnG/GPF9fEL
        NaHZHfBaJC5cielLWmRYvD49mTWU/J0VwxKxxY6Zg+D29egNCtnbgdtWDi0+vOM9daX8jU
        lTtRzqYpSpVwKGLM4bebR3kVWw2a27uVHxGA379p5TKGA37FVdFE3yx0HzEz5Q==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 0/3] net: dsa: rzn1-a5psw: add support for vlan and .port_bridge_flags
Date:   Wed,  8 Feb 2023 17:17:46 +0100
Message-Id: <20230208161749.331965-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
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

While adding support for VLAN, bridge_vlan_unaware.sh and
bridge_vlan_aware.sh were executed and requires .port_bridge_flags
to disable flooding on some specific port. Thus, this series adds
both vlan support and .port_bridge_flags.

----
V3:
 - Target net-next tree and correct version...

V2:
 - Fixed a few formatting errors
 - Add .port_bridge_flags implementation

Clément Léger (3):
  net: dsa: rzn1-a5psw: use a5psw_reg_rmw() to modify flooding
    resolution
  net: dsa: rzn1-a5psw: add support for .port_bridge_flags
  net: dsa: rzn1-a5psw: add vlan support

 drivers/net/dsa/rzn1_a5psw.c | 224 ++++++++++++++++++++++++++++++++++-
 drivers/net/dsa/rzn1_a5psw.h |   8 +-
 2 files changed, 223 insertions(+), 9 deletions(-)

-- 
2.39.0

