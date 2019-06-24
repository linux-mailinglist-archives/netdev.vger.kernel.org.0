Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 952D850F2C
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbfFXOxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:53:10 -0400
Received: from mx.0dd.nl ([5.2.79.48]:33434 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbfFXOxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 10:53:10 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 1EA955FA1D;
        Mon, 24 Jun 2019 16:53:09 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="QnEMZIbC";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id D98F51CC6EFD;
        Mon, 24 Jun 2019 16:53:08 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com D98F51CC6EFD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1561387988;
        bh=bS0BvauIqjunMohu89cqlu/hO+41P+Yoze5Z2dDuxPo=;
        h=From:To:Cc:Subject:Date:From;
        b=QnEMZIbCvwUm5YDuJm/qV2WrEEa0WuIgPQB7ljb8aTVz5BgySE1Ap0P+RK7xvQAPa
         R7QWjwWNmmne8vGXcRqOKjMjf8dYwohg/W2s6VZjGLziHea2LdEcVJh1MOJu1fq+Ed
         reJCpa4DzLaV2vZPGORDidCQAc5hxNQtXCX7nsFVymtzDcPFc8xHM+wGhVU81sw6iD
         9M+VYRIKr73HMgAeALVKp+UeO0EkvjmxnwPMonuF2yW0PZK6xrgKkiWe/GeWR8GGSk
         ofxqJqCctCBFWneMe4asnODxf22lZ6htR2yP0tSm+XXzMXn7Z69OWJZEkULRBPIUst
         K6qzEBj6u8mdA==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, matthias.bgg@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com
Cc:     frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH RFC net-next 0/5] net: dsa: MT7530: Convert to PHYLINK and add support for port 5
Date:   Mon, 24 Jun 2019 16:52:46 +0200
Message-Id: <20190624145251.4849-1-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here by I am sending my current patches for review.
I want to know if I am on the right track.

1. 0001-net-dsa-mt7530-Convert-to-PHYLINK-API.patch
   This patch converts mt7530 to PHYLINK API.
2. 0002-dt-bindings-net-dsa-mt7530-Add-support-for-port-5.patch
3. 0003-net-dsa-mt7530-Add-support-for-port-5.patch
   These 2 patches adding support for port 5 of the switch.

Optional:
4. 0004-dt-bindings-net-dsa-mt7530-Add-mediatek-ephy-handle-.patch
5. 0005-net-dsa-mt7530-Add-mediatek-ephy-handle-to-isolate-e.patch
   These 2 patches adding property "mediatek,ephy-handle".
   When set, it puts the external phy in isolation mode.
   This allows the switch PHY of port 0/4 to interface with 2nd GMAC of
   the SOC. The external phy, 2nd GMAC and switch port 5 shares the same
   MII bus.

FWIW: Also working on converting the mediatek ethernet driver to PHYLINK.
This need a bit more work duo to the SGMII work and support hardware which 
I don't have.
https://github.com/vDorst/linux-1/commit/54004b807cba0dcec1653c1c290c2e5aae5127c2

René van Dorst (5):
  net: dsa: mt7530: Convert to PHYLINK API
  dt-bindings: net: dsa: mt7530: Add support for port 5
  net: dsa: mt7530: Add support for port 5
  dt-bindings: net: dsa: mt7530: Add mediatek,ephy-handle to isolate
    ext. phy
  net: dsa: mt7530: Add mediatek,ephy-handle to isolate external phy

 .../devicetree/bindings/net/dsa/mt7530.txt    | 329 ++++++++++++++++
 drivers/net/dsa/mt7530.c                      | 366 +++++++++++++++---
 drivers/net/dsa/mt7530.h                      |  39 ++
 3 files changed, 688 insertions(+), 46 deletions(-)

-- 
2.20.1

