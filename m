Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5644A97D67
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbfHUOoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:44:18 -0400
Received: from mx.0dd.nl ([5.2.79.48]:53994 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728724AbfHUOoS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 10:44:18 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 5885D5FB50;
        Wed, 21 Aug 2019 16:44:16 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="gwaS1ymk";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id 16CB11D828BD;
        Wed, 21 Aug 2019 16:44:16 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 16CB11D828BD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566398656;
        bh=A8P/+l59ZXg3ee4n+RpUENIPGvXU46CDYZ5yozGyZy0=;
        h=From:To:Cc:Subject:Date:From;
        b=gwaS1ymkIdme9YJvl/6PZwGw22V6g/BtecvFvF89RjKxqbiBRBvchBwvU5IzMHzXJ
         GBCXBEZY7vMi8Q0q8PDSjEqvK42qQ5P+T8Y0IbwSaYFxXo9Z5Taj9TGNViZ8Rymw2q
         iS1iAlxOtEZ/7YqMXPkSG/XJ/9hWqvz5A0H6e2Yp3MVq3gkceYbMbiH4cegZkzMKep
         gQ8JooKnECU6GyBpMsPMVeF9KOjoNfaL3nTkyUykxkNkHS8gEFTIFq9FZI4eV86N0E
         nJdpuG5LVwzbI65n0xYZb7rXMRaTYCHiwqU8ZA2jf42PnWsRSrP83awgNDZ5M5NxB8
         7ADYJDllTVhoQ==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Stefan Roese <sr@denx.de>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next v2 0/3] net: ethernet: mediatek: convert to PHYLINK
Date:   Wed, 21 Aug 2019 16:43:33 +0200
Message-Id: <20190821144336.9259-1-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches converts mediatek driver to PHYLINK API.

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
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 502 ++++++++++++------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  68 ++-
 drivers/net/ethernet/mediatek/mtk_sgmii.c     |  65 ++-
 8 files changed, 447 insertions(+), 296 deletions(-)

--.
2.20.1
