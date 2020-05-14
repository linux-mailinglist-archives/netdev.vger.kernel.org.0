Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D046C1D2974
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgENIAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725955AbgENIAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:00:08 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A886EC061A0E
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:05 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l11so2644469wru.0
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LxiKwe63FtUym2hYC0zoHVQTlvrxg5XLv5yLWaD9fEo=;
        b=UeCZEBRs20fQXYUJ0r4rTsxGg5GcFmWuh+lzieEtDQHE6NKCFyIP95HcoRaJphptG5
         74JYw+/BDgF0+IGCJKhnHi2sLi9epciTNrn5bNRabbYKCppawHl9heC30ToTWy8S+k7K
         bX2hvRdeMZyAwM2HRTSbE7gTewUuiRny5XmWOo+XV3wnsrYxyzDOekfkIC8mT2wEbEzO
         igxRgI47NryMgg+Oy9pl5skMNrp+Un81sJEPKNc3dUOYJnkSblhpuqBZ3a/jPmmHjshf
         C9AGxQFsPEl2nOzoQkl7j+thuirCBjnt6vDkFMZ1oNrZL2ANTi+lKoWUYkba21FsTb26
         ORag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LxiKwe63FtUym2hYC0zoHVQTlvrxg5XLv5yLWaD9fEo=;
        b=X6396dVdyL8YirwdDpeI8Wnqe9ZHLbFsyXYkGmzCUdCP/HQsAdL47RBDctsSz+0rO7
         YrOXF9/saHgVb3E/+03D5KjESdlEbNFCuCT7VQlzoHG053UG8DucpO3E86Lc8iZS7C4L
         Qx8+hbr4kjXF2TzpVYiKkD4W2/0mAGNZyGjXO7KZ5LLC6erunumSirKes7Xc30mJQjdK
         iNMyaW2P2IQ3uuwE4Y+22ewcpHUhUuirT2rjrKDvNwXtouDGW4h0CfvU1LZtpiOmxK4w
         ONyFACT4s39CEl+lL5+WC02yXQq9KwT0IIqg4QE9Q4fk+HKnkJnZP/S3E31rUjTryB0d
         HdLQ==
X-Gm-Message-State: AOAM533uqsrYCHRRIfhkZNY/NtzoRBIvabPfSkCBzBp45+WCTZA6ausN
        k5EHfoHBjPXZNuBrVGlFyjbgIw==
X-Google-Smtp-Source: ABdhPJwI5TAiw6JGHe10xqjfyRvp21tN6e/WVtsWSo1V4Qnb8O2x5Ne8GkVd7g59r7PlsF292M6lGw==
X-Received: by 2002:a05:6000:1083:: with SMTP id y3mr3740674wrw.425.1589443204180;
        Thu, 14 May 2020 01:00:04 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 81sm23337446wme.16.2020.05.14.01.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 01:00:03 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v3 00/15] mediatek: add support for MediaTek Ethernet MAC
Date:   Thu, 14 May 2020 09:59:27 +0200
Message-Id: <20200514075942.10136-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

This adds support for the Ethernet Controller present on MediaTeK SoCs from
the MT8* family.

First we convert the existing DT bindings for the PERICFG controller to YAML
and add a new compatible string for mt8516 variant of it. Then we add the DT
bindings for the MAC.

Next we do some cleanup of the mediatek ethernet drivers directory and update
the devres documentation with existing networking devres helpers.

The following patches introduce a resource managed variant of
register_netdev() and move all networking devres helpers into a separate .c
file.

The largest patch in the series adds the actual new driver.

The rest of the patches add DT fixups for the boards already supported
upstream.

v1 -> v2:
- add a generic helper for retrieving the net_device associated with given
  private data
- fix several typos in commit messages
- remove MTK_MAC_VERSION and don't set the driver version
- use NET_IP_ALIGN instead of a magic number (2) but redefine it as it defaults
  to 0 on arm64
- don't manually turn the carrier off in mtk_mac_enable()
- process TX cleanup in napi poll callback
- configure pause in the adjust_link callback
- use regmap_read_poll_timeout() instead of handcoding the polling
- use devres_find() to verify that struct net_device is managed by devres in
  devm_register_netdev()
- add a patch moving all networking devres helpers into net/devres.c
- tweak the dma barriers: remove where unnecessary and add comments to the
  remaining barriers
- don't reset internal counters when enabling the NIC
- set the net_device's mtu size instead of checking the framesize in
  ndo_start_xmit() callback
- fix a race condition in waking up the netif queue
- don't emit log messages on OOM errors
- use dma_set_mask_and_coherent()
- use eth_hw_addr_random()
- rework the receive callback so that we reuse the previous skb if unmapping
  fails, like we already do if skb allocation fails
- rework hash table operations: add proper timeout handling and clear bits when
  appropriate

v2 -> v3:
- drop the patch adding priv_to_netdev() and store the netdev pointer in the
  driver private data
- add an additional dma_wmb() after reseting the descriptor in
  mtk_mac_ring_pop_tail()
- check the return value of dma_set_mask_and_coherent()
- improve the DT bindings for mtk-eth-mac: make the reg property in the example
  use single-cell address and size, extend the description of the PERICFG
  phandle and document the mdio sub-node
- add a patch converting the old .txt bindings for PERICFG to yaml
- limit reading the DMA memory by storing the mapped addresses in the driver
  private structure
- add a patch documenting the existing networking devres helpers

Bartosz Golaszewski (15):
  dt-bindings: convert the binding document for mediatek PERICFG to yaml
  dt-bindings: add new compatible to mediatek,pericfg
  dt-bindings: net: add a binding document for MediaTek Ethernet MAC
  net: ethernet: mediatek: rename Kconfig prompt
  net: ethernet: mediatek: remove unnecessary spaces from Makefile
  Documentation: devres: add a missing section for networking helpers
  net: move devres helpers into a separate source file
  net: devres: define a separate devres structure for
    devm_alloc_etherdev()
  net: devres: provide devm_register_netdev()
  net: ethernet: mtk-eth-mac: new driver
  ARM64: dts: mediatek: add pericfg syscon to mt8516.dtsi
  ARM64: dts: mediatek: add the ethernet node to mt8516.dtsi
  ARM64: dts: mediatek: add an alias for ethernet0 for pumpkin boards
  ARM64: dts: mediatek: add ethernet pins for pumpkin boards
  ARM64: dts: mediatek: enable ethernet on pumpkin boards

 .../arm/mediatek/mediatek,pericfg.txt         |   36 -
 .../arm/mediatek/mediatek,pericfg.yaml        |   64 +
 .../bindings/net/mediatek,eth-mac.yaml        |   89 +
 .../driver-api/driver-model/devres.rst        |    5 +
 arch/arm64/boot/dts/mediatek/mt8516.dtsi      |   17 +
 .../boot/dts/mediatek/pumpkin-common.dtsi     |   34 +
 drivers/net/ethernet/mediatek/Kconfig         |    8 +-
 drivers/net/ethernet/mediatek/Makefile        |    3 +-
 drivers/net/ethernet/mediatek/mtk_eth_mac.c   | 1578 +++++++++++++++++
 include/linux/netdevice.h                     |    2 +
 net/Makefile                                  |    2 +-
 net/devres.c                                  |   95 +
 net/ethernet/eth.c                            |   28 -
 13 files changed, 1894 insertions(+), 67 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.txt
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
 create mode 100644 Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml
 create mode 100644 drivers/net/ethernet/mediatek/mtk_eth_mac.c
 create mode 100644 net/devres.c

-- 
2.25.0

