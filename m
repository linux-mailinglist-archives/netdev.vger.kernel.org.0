Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B366021DE04
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729849AbgGMQ6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbgGMQ6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:58:49 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F24DC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:58:49 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id o18so18023320eje.7
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Se+RMC6PBBYO1KiXUzIQNpYowHDNutuTr29Ez5hrrI=;
        b=VQ2a8g0rqjmUmCHSeyygSlPPNjv8wx3qIdnRZWPdk9YagmVWj1Azy0msQsxv/JGzCZ
         ld1PGRIytdKtWKE1VtQ0M5YkE7Y4+AvPiaMobzBiqfXOlJnxSv51Zt340quVcBNaqEGC
         HiS91VxRhoJt9eAkxIGmntlMZltEwp9yjJzYrpcdeH46C/AwnoEe1zykaxjEYd7wEwup
         IRjzcK+uHLhy6c5q3+SY0//h55CHO+BVpMQQKy8VZdX9R+pjj/qzR1WnnQLjXFfSK48G
         FJccWnTCrjSkS9djGZCyG0gMKh0iceWuQe0jDzRmrKpQPnFt8pjupnbkwElBvMnZOU6A
         xykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Se+RMC6PBBYO1KiXUzIQNpYowHDNutuTr29Ez5hrrI=;
        b=APUD/tCtoIu3dSsAXbYsYLHysaXj0OxKk4ad1KLd7z8lPB1IrS+yGziuA7RNq38uC4
         v5LsWt5RBNQbvGtPmkaieP43hi5vxr5rzMgkT5eiCirNpG3NrZsLqwWzHUf2eh2DEW3o
         FkIr6LmTyfCevzRfBO4FGHj2I5ORlyXJoPVL2tobjNr3Eaat5eqzDV2uzj8LrHbVv4L7
         PKYxvQpH3E4QDxuGQUlVuDSxUTH2E7Pu9+CoXQXh6Sp9rGwSTvGSr0AsON2tRV0ck9W1
         4F8YijOhLAMTo5TGkzU/PTipcf64yNN+zEUYpuZxQkj9QSKVOYCmyVoFkyWaGHO65f5L
         DWMw==
X-Gm-Message-State: AOAM533/sJtdeMpIaeVNP6XPAIy9rAp/zOT6RIWAM6syVh5J48jOpG4V
        qbcE2RKssQyu4aJ1s31tdHRtWj3E
X-Google-Smtp-Source: ABdhPJz7bo4DoW1/j0IgKtvXzsKNzILuCAnCBiRkBnQwRIqO9twUEmKwL4Ulfs/B/W9ABirbeS9ijQ==
X-Received: by 2002:a17:906:1499:: with SMTP id x25mr641117ejc.406.1594659528000;
        Mon, 13 Jul 2020 09:58:48 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id y1sm12986732ede.7.2020.07.13.09.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:58:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru
Subject: [PATCH v4 net-next 00/11] New DSA driver for VSC9953 Seville switch
Date:   Mon, 13 Jul 2020 19:57:00 +0300
Message-Id: <20200713165711.2518150-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Looking at the Felix and Ocelot drivers, Maxim asked if it would be
possible to use them as a base for a new driver for the Seville switch
inside NXP T1040. Turns out, it is! The result is that the mscc_felix
driver was extended to probe on Seville.

The biggest challenge seems to be getting register read/write API
generic enough to cover such wild bitfield variations between hardware
generations.

Currently, both felix and seville are built under the same kernel config
option (NET_DSA_MSCC_FELIX). This has both some advantages (no need to
duplicate the Lynx PCS code from felix_vsc9959.c) and some disadvantages
(Seville needs to depend on PCI and on ENETC_MDIO). This will be further
refined as time progresses.

The driver has been completely reviewed. Previous submission was here,
it wasn't accepted due to a conflict with Mark Brown's tree, very late
in the release cycle:

https://patchwork.ozlabs.org/project/netdev/cover/20200531122640.1375715-1-olteanv@gmail.com/

So this is more of a repost, with the only changes being related to
rebasing on top of the cleanup I had to do in Ocelot.

Maxim Kochetkov (4):
  soc: mscc: ocelot: add MII registers description
  net: mscc: ocelot: convert SYS_PAUSE_CFG register access to regfield
  net: mscc: ocelot: extend watermark encoding function
  net: dsa: felix: introduce support for Seville VSC9953 switch

Vladimir Oltean (7):
  net: mscc: ocelot: convert port registers to regmap
  net: mscc: ocelot: convert QSYS_SWITCH_PORT_MODE and SYS_PORT_MODE to
    regfields
  net: dsa: felix: create a template for the DSA tags on xmit
  net: mscc: ocelot: split writes to pause frame enable bit and to
    thresholds
  net: mscc: ocelot: disable flow control on NPI interface
  net: dsa: felix: move probing to felix_vsc9959.c
  docs: devicetree: add bindings for Seville DSA switch inside Felix
    driver

 .../devicetree/bindings/net/dsa/ocelot.txt    |  105 +-
 drivers/net/dsa/ocelot/Kconfig                |   12 +-
 drivers/net/dsa/ocelot/Makefile               |    3 +-
 drivers/net/dsa/ocelot/felix.c                |  232 +---
 drivers/net/dsa/ocelot/felix.h                |   28 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        |  303 ++++-
 drivers/net/dsa/ocelot/seville_vsc9953.c      | 1104 +++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c            |   73 +-
 drivers/net/ethernet/mscc/ocelot.h            |    9 +-
 drivers/net/ethernet/mscc/ocelot_io.c         |   18 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |    5 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |   82 +-
 include/soc/mscc/ocelot.h                     |   68 +-
 include/soc/mscc/ocelot_dev.h                 |   78 --
 include/soc/mscc/ocelot_qsys.h                |   13 -
 include/soc/mscc/ocelot_sys.h                 |   23 -
 net/dsa/tag_ocelot.c                          |   21 +-
 17 files changed, 1767 insertions(+), 410 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/seville_vsc9953.c

-- 
2.25.1

