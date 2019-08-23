Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273719B13D
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 15:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405723AbfHWNpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 09:45:43 -0400
Received: from mx.0dd.nl ([5.2.79.48]:33102 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405716AbfHWNpm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 09:45:42 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id AA80F5FA7B;
        Fri, 23 Aug 2019 15:45:39 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="VphKtHb6";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id 6DD951D89681;
        Fri, 23 Aug 2019 15:45:39 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 6DD951D89681
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566567939;
        bh=4DXT2J8mfFRCiwxSqy0mkdAE2qhxEDwsE+v9BSRv9mo=;
        h=From:To:Cc:Subject:Date:From;
        b=VphKtHb6a42eRPTzPTxmHYEDVRgcxRQVC/UGv7HMIqdMhJNRa0YhE0DdufZxZXWr9
         6mNhvtcx23q2xZH35r4DFHDRuoEAOP62k2vFBE0sx+tlzT6XV6dk9s77a57krT6ONk
         JDXw+9lPhGJR8tJDKztkexhSlH0MP0Kd1W7zEBRYJMkI8SZka+IO4iCDn4akory5qJ
         8ui8zWa/x2ozqxrTgtZnyzHwl/kRTBxpIalSuSW3B2UwngipsfpubRaOysC8CH2vFY
         XiRJtIJuxCwaf6ZbR+pjPOaW4Fr8//fBFqpBArHPm8+cdlzRdSVoRJGZVTrF4sFEZN
         +OV+M5caJdarw==
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
Subject: [PATCH net-next v3 0/3] net: ethernet: mediatek: convert to PHYLINK
Date:   Fri, 23 Aug 2019 15:45:13 +0200
Message-Id: <20190823134516.27559-1-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches converts mediatek driver to PHYLINK API.

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
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 529 ++++++++++++------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  68 ++-
 drivers/net/ethernet/mediatek/mtk_sgmii.c     |  65 ++-
 8 files changed, 477 insertions(+), 293 deletions(-)

-- 
2.20.1

