Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828139C539
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 19:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbfHYRn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 13:43:57 -0400
Received: from mx.0dd.nl ([5.2.79.48]:38696 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbfHYRn5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Aug 2019 13:43:57 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 0BDA45FA49;
        Sun, 25 Aug 2019 19:43:55 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="GGlDHOIy";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id BDD6E1D8E163;
        Sun, 25 Aug 2019 19:43:54 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com BDD6E1D8E163
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566755034;
        bh=o6wAtIg9/9bX+HgLTjY6gx3KROiRBjCVc3xSGwYT8a4=;
        h=From:To:Cc:Subject:Date:From;
        b=GGlDHOIyVmHv3TJ/Pwnx6inYEWPnk/uL9BdikBAoiAv4wjbsOUKCSt+9/rEz8C4dq
         ODy7m/c8vrCUnLkaXFvTGm+FtbTATj0DL9kkdchm/5FkCz48ivzBGDO39Cc6tdFEzI
         fPpaNR4siNWqWf8Svp7Ir9VNL47OHf91CYWMJsdzMGyp/aOT/FeIZanbPOAb19WK1f
         cxPVGncvxKPxUDm3FRYe/bQq/2SZcn33j7tNy69TRrD4/4SIpkUR+5pskKcKO3w0mW
         +EXGwVpLUK/ms8Y1YwkXiEVdxZuTY0nLu+IknfWmo2eNFGlyDZ0WvDtFn3NPIQVvQD
         YDMnzZe+iKG2A==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Frank Wunderlich <frank-w@public-files.de>,
        Stefan Roese <sr@denx.de>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next v4 0/3] net: ethernet: mediatek: convert to PHYLINK
Date:   Sun, 25 Aug 2019 19:43:38 +0200
Message-Id: <20190825174341.20750-1-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches converts mediatek driver to PHYLINK API.

v3->v4:
* Phylink improvements and clean-ups after review
v2->v3:
* Phylink improvements and clean-ups after review
v1->v2:
* Rebase for mt76x8 changes
* Phylink improvements and clean-ups after review
* SGMII port doesn't support 2.5Gbit in SGMII mode only in BASE-X mode.
  Refactor the code.


René van Dorst (3):
  net: ethernet: mediatek: Add basic PHYLINK support
  net: ethernet: mediatek: Re-add support SGMII
  dt-bindings: net: ethernet: Update mt7622 docs and dts to reflect the
    new phylink API

 .../arm/mediatek/mediatek,sgmiisys.txt        |   2 -
 .../dts/mediatek/mt7622-bananapi-bpi-r64.dts  |  28 +-
 arch/arm64/boot/dts/mediatek/mt7622.dtsi      |   1 -
 drivers/net/ethernet/mediatek/Kconfig         |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_path.c  |  75 +--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 521 ++++++++++++------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  68 ++-
 drivers/net/ethernet/mediatek/mtk_sgmii.c     |  65 ++-
 8 files changed, 470 insertions(+), 292 deletions(-)

-- 
2.20.1

