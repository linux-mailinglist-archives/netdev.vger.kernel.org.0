Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A58FF21E1
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbfKFWg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:36:58 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:60543 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbfKFWg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 17:36:58 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id EFB9723E40;
        Wed,  6 Nov 2019 23:36:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1573079815;
        bh=0Cgnak2q2pgGiqu0fUxgRYjBqp9MNgljwA9whngru/8=;
        h=From:To:Cc:Subject:Date:From;
        b=oN0HuX8TDY08mBidhtFIjFi5aeLyPuODkvfLMHX/uLGtCbv2ty2Jtf+vVvj5E1jTw
         cihwbIe4uPu1gkiE+F0GqlqYu39oOV5sUIkC4YVisPIsEtCFsckqe5LvlEBrQTk1hM
         xqcJzORr2bJ25jlA6sUeMF187+/8xwZzNn1+ShBU=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH v2 0/6] net: phy: at803x device tree binding
Date:   Wed,  6 Nov 2019 23:36:11 +0100
Message-Id: <20191106223617.1655-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a device tree binding to configure the clock and the RGMII voltage.

Changes since v1:
 - rebased to latest net-next
 - renamed "Atheros" to "Qualcomm Atheros"
 - add a new patch to remove config_init() from AR9331

Changes since the RFC:
 - renamed the Kconfig entry to "Qualcomm Atheros.." and reordered the
   item
 - renamed the prefix from atheros to qca
 - use the correct name AR803x (instead of AT803x) in new files and
   dt-bindings.
 - listed the PHY maintainers in the new schema. Hopefully, thats ok.
 - fixed a typo in the bindings schema
 - run dtb_checks and dt_binding_check and fixed the schema
 - dropped the rgmii-io-1v8 property; instead provide two regulators vddh
   and vddio, add one consumer vddio-supply
 - fix the clock settings for the AR8030/AR8035
 - only the AR8031 supports chaning the LDO and the PLL mode in software.
   Check if we have the correct PHY.
 - new patch to mention the AR8033 which is the same as the AR8031 just
   without PTP support
 - new patch which corrects any displayed PHY names and comments. Be
   consistent.

Michael Walle (6):
  net: phy: at803x: fix Kconfig description
  dt-bindings: net: phy: Add support for AT803X
  net: phy: at803x: add device tree binding
  net: phy: at803x: mention AR8033 as same as AR8031
  net: phy: at803x: fix the PHY names
  net: phy: at803x: remove config_init for AR9331

 .../devicetree/bindings/net/qca,ar803x.yaml   | 111 ++++++
 MAINTAINERS                                   |   2 +
 drivers/net/phy/Kconfig                       |  10 +-
 drivers/net/phy/at803x.c                      | 321 +++++++++++++++++-
 include/dt-bindings/net/qca-ar803x.h          |  13 +
 5 files changed, 441 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/qca,ar803x.yaml
 create mode 100644 include/dt-bindings/net/qca-ar803x.h

-- 
2.20.1

