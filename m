Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400666CB0BF
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 23:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbjC0VfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 17:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbjC0VfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 17:35:24 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC46273D;
        Mon, 27 Mar 2023 14:35:21 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pguUj-0008Kx-2f;
        Mon, 27 Mar 2023 23:35:13 +0200
Date:   Mon, 27 Mar 2023 22:35:00 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: [RFC PATCH net-next 0/2] net: dsa: add support for MT7988
Message-ID: <ZCIMBBzDmfZlu5T8@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MediaTek MT7988 SoC comes with a built-in switch very similar to
previous MT7530 and MT7531. However, the switch address space is mapped
into the SoCs memory space rather than being connected via MDIO.
Using MMIO simplifies register access and also removes the need for a bus
lock, and for that reason also makes interrupt handling more light-weight.

Note that this is different from previous SoCs like MT7621 and MT7623N
which also came with an integrated MT7530-like switch which yet had to be
accessed via MDIO.

split-off the part of the driver registering an MDIO driver, then add
another module acting as MMIO/platform driver.

Daniel Golle (2):
  net: dsa: mt7530: split-off MDIO driver
  net: dsa: mt7530: introduce MMIO driver for MT7988 SoC

 drivers/net/dsa/Kconfig       |  16 +-
 drivers/net/dsa/Makefile      |   4 +-
 drivers/net/dsa/mt7530-mdio.c | 165 +++++++++++++++
 drivers/net/dsa/mt7530-mmio.c | 126 ++++++++++++
 drivers/net/dsa/mt7530.c      | 375 ++++++++++++++++++----------------
 drivers/net/dsa/mt7530.h      |  39 ++--
 6 files changed, 526 insertions(+), 199 deletions(-)
 create mode 100644 drivers/net/dsa/mt7530-mdio.c
 create mode 100644 drivers/net/dsa/mt7530-mmio.c

-- 
2.39.2

