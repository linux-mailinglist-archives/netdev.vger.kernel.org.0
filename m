Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41276480576
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 02:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhL1BKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 20:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbhL1BKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 20:10:37 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B37C06173E;
        Mon, 27 Dec 2021 17:10:36 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1n210X-0001SP-9a; Tue, 28 Dec 2021 02:10:29 +0100
Date:   Tue, 28 Dec 2021 01:10:21 +0000
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
Subject: [PATCH v7 0/2] net: ethernet: mtk_soc_eth: implement Clause 45 MDIO
 access
Message-ID: <Ycpj/cEdjb0BMrny@makrotopia.org>
References: <YcnoAscVe+2YILT8@shell.armlinux.org.uk>
 <YcpVmlb1jFavCBpS@makrotopia.org>
 <YcpVtjykiS7mgtT5@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcnoAscVe+2YILT8@shell.armlinux.org.uk>
 <YcpVmlb1jFavCBpS@makrotopia.org>
 <YcpVtjykiS7mgtT5@makrotopia.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it turned out some clean-up would be needed, first address return
value and type of mdio read and write functions in mtk_eth_soc and
generally clean up and unify both functions.
Then add support to access Clause 45 phy registers.

Both commits are tested on the Bananapi BPi-R64 board having MediaTek
MT7531BE DSA gigE switch using clause 22 MDIO and Ubiquiti UniFi 6 LR
access point having Aquantia AQR112C PHY using clause 45 MDIO.

v7: remove unneeded variables and order OR-ed call parameters
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

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 75 +++++++++++++++------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  3 +
 2 files changed, 58 insertions(+), 20 deletions(-)

-- 
2.34.1

