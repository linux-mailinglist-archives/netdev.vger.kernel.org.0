Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B8A38122C
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhENVBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhENVBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:30 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A55AC061574;
        Fri, 14 May 2021 14:00:17 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id a25so26930edr.12;
        Fri, 14 May 2021 14:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mdWgE6cI2x3bH7vYaDr/JQ4J+dMeZdc878Zv32lrssE=;
        b=P/N/j/ue7uIPUpU++4wwn9yPrC0AaVs9IgBMIjtY/znNcWkdnPb0vi9JehWEN58JOw
         I4BAxuYgyi35v9BcgfXSDPNKV7FDYSfG/xBlC22fc2rWIYXQJCR9+TYOrnGmG16KTUZs
         PzACKJd43OWbSnt0mtgrk9CIhSdk/Z/VDfoaM+DoEgHKOGwpTKP5uqVzmqOoynMuKsjo
         hXOraxi66fPysmmBeVzuBR1PF13j1fhuEl4zYlsGlGHE8lC2n82gCuLUSNOPrmp4Y3+L
         14Q+M69cnPoWewKuzURH9arZxf3nUMJB2pscBQWZb5yfzesrAFg8LL3W3Ym00JX57PQn
         l4Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mdWgE6cI2x3bH7vYaDr/JQ4J+dMeZdc878Zv32lrssE=;
        b=PQC47t83cCI9BPsyaUVHnWutidc0RWZtMID31zQYHUrft44lJb9utSA7Ir8wQbvtop
         WI1JMCh3mOBhOx65Ww4V+svmY6ORD2NdBOHDCZMesQ78w9zuXD7UomiaXGpi4sy9WvNq
         vRIWVwj9VNghecIrHdvBeKtwWMAvvMcU9ganVRo1GRNC22ESIJ+xaAZRFSkCXQbK77ET
         bs3UonpsswnW9yRbW6YuYA2PqFkCEs/P9kGRDm3YbMea+SnyDlH2milKZ9ZnKF+gDuqf
         6T94jEcHcffv46EOThiApMtb7wpFZiBc9+udJUAwyooDudp1Xe+SkF6qN5LKZOWRHK0m
         X+sQ==
X-Gm-Message-State: AOAM531RWl5p9lq22hvZ6qv0oLU69QAh+qn8cBkhp5mxE9naGC1NkcxI
        LAM7GJhQCioV9qikd/KSXpAx3ov8yE8ZTA==
X-Google-Smtp-Source: ABdhPJyt+XO/kKm5gxPHGXzw/EqcM4cwJBKc7qc+fdmHVVQHAFV2VL3mIQ14bh3ebnY51mVJhRE4TA==
X-Received: by 2002:aa7:d513:: with SMTP id y19mr56993183edq.9.1621026015888;
        Fri, 14 May 2021 14:00:15 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:15 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 00/25] Multiple improvement to qca8k stability
Date:   Fri, 14 May 2021 22:59:50 +0200
Message-Id: <20210514210015.18142-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently qca8337 switch are widely used on ipq8064 based router.
On these particular router it was notice a very unstable switch with
port not link detected as link with unknown speed, port dropping
randomly and general unreliability. Lots of testing and comparison
between this dsa driver and the original qsdk driver showed lack of some
additional delay and values. A main difference arised from the original
driver and the dsa one. The original driver didn't use MASTER regs to
read phy status and the dedicated mdio driver worked correctly. Now that
the dsa driver actually use these regs, it was found that these special
read/write operation required mutual exclusion to normal
qca8k_read/write operation. The add of mutex for these operation fixed
the random port dropping and now only the actual linked port randomly
dropped. Adding additional delay for set_page operation and fixing a bug
in the mdio dedicated driver fixed also this problem. The current driver
requires also more time to apply vlan switch. All of these changes and
tweak permit a now very stable and reliable dsa driver and 0 port
dropping. This series is currently tested by at least 5 user with
different routers and all reports positive results and no problems.

Changes v6:
- Fix spelling mistake
- Change ms to ns (confirmed by datasheet)
Changes v5:
- Removed mdio patch (sent separetly to try to reduce the series)
  I know it was asked to reduced this series since it big, but rework
  the new changes to skip and error check looks wrong. Since half of them
  are actually already reviewed I think it's better to keep this series as is.
- Improve rgmii configurable patch
- Move qca8k phy dedicated driver to at803x phy driver
- Add support for dedicated internal mdio driver for qca8k
Changes v4:
- Use iopoll for busy_wait function
- Better describe and split some confusing commits
- Fix bad rgmii delay configurable patch
- Drop phy generic patch to pass flags with phylink_connect_phy
- Add dsa2 patch to declare mdio node in the switch node
- Add dsa patch to permit dsa driver to declare custom get_phys_mii_mask
    Some background about the last 2 patch.
    The qca8k switch doesn't have a 1:1 map between port reg and phy reg.
    Currently it's used a function to convert port to the internal phy reg.
    I added some patch to fix this.
    - The dsa driver now check if the mdio node is present and use the of variant
      of the mdiobus_register
    - A custom phy_mii_mask is required as currently the mask is generated from
      the port reg, but in our case the mask would be different as it should be
      generated from the phy reg. To generalize this I added an extra function
      that driver can provide to pass custom phy_mii_mask.
Changes v3:
- Revert mdio writel changes (use regmap with REGCACHE disabled)
- Split propagate error patch to 4 different patch
Changes v2:
- Implemented phy driver for internal PHYs
  I'm testing cable test functions as I found some documentation that
  actually declare regs about it. Problem is that it doesn't actually
  work. It seems that the value set are ignored by the phy.
- Made the rgmii delay configurable
- Reordered patch
- Split mdio patches to more specific ones
- Reworked mdio driver to use readl/writel instead of regmap
- Reworked the entire driver to make it aware of any read/write error.
- Added phy generic patch to pass flags with phylink_connect_phy
  function

Ansuel Smith (25):
  net: dsa: qca8k: change simple print to dev variant
  net: dsa: qca8k: use iopoll macro for qca8k_busy_wait
  net: dsa: qca8k: improve qca8k read/write/rmw bus access
  net: dsa: qca8k: handle qca8k_set_page errors
  net: dsa: qca8k: handle error with qca8k_read operation
  net: dsa: qca8k: handle error with qca8k_write operation
  net: dsa: qca8k: handle error with qca8k_rmw operation
  net: dsa: qca8k: handle error from qca8k_busy_wait
  net: dsa: qca8k: add support for qca8327 switch
  devicetree: net: dsa: qca8k: Document new compatible qca8327
  net: dsa: qca8k: add priority tweak to qca8337 switch
  net: dsa: qca8k: limit port5 delay to qca8337
  net: dsa: qca8k: add GLOBAL_FC settings needed for qca8327
  net: dsa: qca8k: add support for switch rev
  net: dsa: qca8k: add ethernet-ports fallback to setup_mdio_bus
  net: dsa: qca8k: make rgmii delay configurable
  net: dsa: qca8k: clear MASTER_EN after phy read/write
  net: dsa: qca8k: dsa: qca8k: protect MASTER busy_wait with mdio mutex
  net: dsa: qca8k: enlarge mdio delay and timeout
  net: dsa: qca8k: add support for internal phy and internal mdio
  devicetree: bindings: dsa: qca8k: Document internal mdio definition
  net: dsa: qca8k: improve internal mdio read/write bus access
  net: dsa: qca8k: pass switch_revision info to phy dev_flags
  net: phy: at803x: clean whitespace errors
  net: phy: add support for qca8k switch internal PHY in at803x

 .../devicetree/bindings/net/dsa/qca8k.txt     |  40 +
 drivers/net/dsa/qca8k.c                       | 758 ++++++++++++++----
 drivers/net/dsa/qca8k.h                       |  58 +-
 drivers/net/phy/Kconfig                       |   5 +-
 drivers/net/phy/at803x.c                      | 162 +++-
 5 files changed, 835 insertions(+), 188 deletions(-)

-- 
2.30.2

