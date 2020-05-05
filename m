Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A791C57C8
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgEEODF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728135AbgEEODF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:03:05 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15D7C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 07:03:04 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id y3so2930345wrt.1
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 07:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PK31tVWfgrccN1MBhDjrbakpYyyD2tO24v7BYQEkurI=;
        b=a8DMxibRqTrZGmyZ0KLtsYlfgQSvtBtYx+i51AoL6kzVb3a3Zcw5KFc8r5emhX2L/e
         qLVl57SKF7PdhjnPEnfYmiBsHkXDn94m+UKH2rLq8YYGcxS7EN5GAv4eWBPvoY1byN7N
         QxZMFs3Qb+qVtydhG5IbCi+FEqOcJ0waPkxXqf2ILV3oLLL0N8BnwvrKySVqhV+H6q/X
         68KP5IqC6ZqPMnSBCsQ0mVeuFaW8UzGdm+AMBhfl1Jooa4pbk4UE+wnG551wvwjBL9yZ
         yo8Kq56xX0wXRuQs1Lf5bbGGIUhYjKU0+mCWMv1cZeNM2eZ0NXSh3Pl4lvUmp2tjq5pt
         c2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PK31tVWfgrccN1MBhDjrbakpYyyD2tO24v7BYQEkurI=;
        b=qCXhVWcL+3D7ygXl+U5JVMriXds+mhrR6PXDo5m0YfC8ySiWi+0oPkjXXsliS+gTsu
         ClNn4qsi+UrGgTLB2nYCYoo2Jfhs3W20wdGO1iA0reL6SkmAlsPWLGadrG1naK0bKTjj
         BKNplzk4XpNPcbRI1N3YbXSYYwYo/bI/ytpLpVD9wsxIT+KK53dK8tPj7IV3ImD2ChE7
         1vw1foQPnIKQfUFHZqXdXYGqapDLTeHBLaGmYhG64lSRRzQmnkbzviNSyP84qPojECCs
         SDUh1+qbAcwEWKj2+jMPbMN1b3FAilczwjt4OhUWwxFE3Ew43oi9QArwLYgowWK9Ug4e
         SLKA==
X-Gm-Message-State: AGi0PubFp9KdST3NWxbUg6A9IYOEpE1odNOK/lwze1rlf6o5FzTDV8Hs
        4ZE7f8UuEKvpYqeY3bx2wLIWYA==
X-Google-Smtp-Source: APiQypJK0fRzPjzYsRI0o6WTCpJIb10ZVt2+vpQjB2QmGMKqpkl9pQ80cS/ZweDjU4zPMeSAzrIc8g==
X-Received: by 2002:a5d:4711:: with SMTP id y17mr3781592wrq.49.1588687383658;
        Tue, 05 May 2020 07:03:03 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id c190sm4075755wme.4.2020.05.05.07.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 07:03:03 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 00/11] mediatek: add support for MediaTek Ethernet MAC
Date:   Tue,  5 May 2020 16:02:20 +0200
Message-Id: <20200505140231.16600-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

This adds support for the Ethernet Controller present on MediaTeK SoCs
from the MT8* family.

The first two patches add binding documents for the PERICFG syscon and
for the MAC itself.

Patches 3/11 & 4/11 do some cleanup of the mediatek ethernet drivers
directory.

Patch 5/11 provides a devres variant of register_netdev().

Patch 6/11 adds the new ethernet driver.

The rest of the patches add DT fixups for the boards already supported
upstream.

Bartosz Golaszewski (11):
  dt-bindings: add a binding document for MediaTek PERICFG controller
  dt-bindings: new: add yaml bindings for MediaTek Ethernet MAC
  net: ethernet: mediatek: rename Kconfig prompt
  net: ethernet: mediatek: remove unnecessary spaces from Makefile
  net: core: provide devm_register_netdev()
  net: ethernet: mtk-eth-mac: new driver
  ARM64: dts: mediatek: add pericfg syscon to mt8516.dtsi
  ARM64: dts: mediatek: add the ethernet node to mt8516.dtsi
  ARM64: dts: mediatek: add an alias for ethernet0 for pumpkin boards
  ARM64: dts: mediatek: add ethernet pins for pumpkin boards
  ARM64: dts: mediatek: enable ethernet on pumpkin boards

 .../arm/mediatek/mediatek,pericfg.yaml        |   34 +
 .../bindings/net/mediatek,eth-mac.yaml        |   80 +
 arch/arm64/boot/dts/mediatek/mt8516.dtsi      |   17 +
 .../boot/dts/mediatek/pumpkin-common.dtsi     |   34 +
 drivers/net/ethernet/mediatek/Kconfig         |    8 +-
 drivers/net/ethernet/mediatek/Makefile        |    3 +-
 drivers/net/ethernet/mediatek/mtk_eth_mac.c   | 1476 +++++++++++++++++
 include/linux/netdevice.h                     |    4 +
 net/core/dev.c                                |   48 +
 net/ethernet/eth.c                            |    1 +
 10 files changed, 1703 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
 create mode 100644 Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml
 create mode 100644 drivers/net/ethernet/mediatek/mtk_eth_mac.c

-- 
2.25.0

