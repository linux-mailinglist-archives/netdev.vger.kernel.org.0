Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757BA48054C
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 01:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbhL1AIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 19:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234083AbhL1AIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 19:08:10 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEE0C06173E;
        Mon, 27 Dec 2021 16:08:10 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1n2025-0001KX-7Y; Tue, 28 Dec 2021 01:08:01 +0100
Date:   Tue, 28 Dec 2021 00:07:49 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v6 0/2] ethernet: mtk_eth_soc: implement Clause 45 MDIO access
Message-ID: <YcpVVYx8ucG3RGdG@makrotopia.org>
References: <YcnoAscVe+2YILT8@shell.armlinux.org.uk>
 <YcnlMtninjjjPhjI@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcnoAscVe+2YILT8@shell.armlinux.org.uk>
 <YcnlMtninjjjPhjI@makrotopia.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it turned out some clean-up would be needed, first address return
value and type of mdio read and write functions in mtk_eth_soc.
Then add support to access Clause 45 phy registers.

Both commits are tested on the Bananapi BPi-R64 board having MediaTek
MT7531BE DSA gigE switch using clause 22 MDIO and Ubiquiti UniFi 6 LR
access point having Aquantia AQR112C PHY using clause 45 MDIO.

v6: further clean up functions and more cleanly separate patches
v5: fix wrong variable name in first patch covered by follow-up patch
v4: clean-up return values and types, split into two commits
v3: return -1 instead of 0xffff on error in _mtk_mdio_write
v2: use MII_DEVADDR_C45_SHIFT and MII_REGADDR_C45_MASK to extract
    device id and register address. Unify read and write functions to
    have identical types and parameter names where possible as we are
    anyway already replacing both function bodies.

Daniel Golle (2):
  net: ethernet: mtk_eth_soc: fix return value of MDIO ops
  net: ethernet: mtk_eth_soc: implement Clause 45 MDIO access

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 76 +++++++++++++++------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  3 +
 2 files changed, 59 insertions(+), 20 deletions(-)

-- 
2.34.1

