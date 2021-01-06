Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167E22EBE47
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbhAFNK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbhAFNK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:10:57 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E6CC061357
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 05:10:17 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id g20so5027016ejb.1
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 05:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PiZAtu8l5OqKlqCWO1C6ZHhuyEOtxTAiljgeK8sB2QI=;
        b=oLUsS3e+Atq97t1pot5pgLE9bgo0WpqfaF9391Qr4QPfaSJXh3EMzeuuRq0utOokKP
         /HblgIXKJcAmlARIImG18cGk0acXBkKQJrI9smrgkSgCmMk9Qi7097ZxLj1NNmM0stVw
         e56tatdAk8lMf4HC64UD7xO07Z6aD8vq9Jcikh6E21GwxrjFysAqDScAEiQ3zjJQcKjP
         +yUDPETZio14KJt+hKtpZD9fU9urECJE+wVBCZQuONVESeYjOXVxwyFY05m46ElDv3MI
         d2X2fv6SRRIXKT7dkbzfgaymVnxw1PvRNzx7t/P9vqucbtgojae1gPfha7ET+wVKrVSf
         V7Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PiZAtu8l5OqKlqCWO1C6ZHhuyEOtxTAiljgeK8sB2QI=;
        b=lShMNKJJL37RiwzTds+LEdg3C6MjmlRHSZ2/7byufOJPktASwbrChfUXgyZ7RCV217
         mcLoWys78S6Rufksk30hVe2qBRjSdKXpP5r9lqc/tuDTcP6gWufH6wetI0aHce1d3s+S
         PwLc76ORui2P9MQJRkGhUpGFzQVYvt5yxw4IcngB+iVFykkkhwtvn34SpB4UOtxgPYgI
         2702P6VP73lwczO3p4ikxZqDimu2c6JYV0D/pQmH3qKJxzwvZQMMOEeYJYacdeAKXxld
         xX2UscqaUzi/T0w6999Fhv9/1ua3ZnOr+4eL2HqMJ5V2n9s6STKtEAQrEffL8sy+381d
         GwLw==
X-Gm-Message-State: AOAM533FL0+GgZQpXtW235hcTnIi5Pd3qfk71LvaKFSdAc95ykKzXGsA
        azGM1ZumGIVWW2qAh/IATRg=
X-Google-Smtp-Source: ABdhPJy8NBVD3K6cG3fmdZfAd5BNLVIRfDrsKVEEApNIw5N0Ik168XPQn8UG0Rd0XnMiwHu2DnysJQ==
X-Received: by 2002:a17:906:ce51:: with SMTP id se17mr2763993ejb.314.1609938615743;
        Wed, 06 Jan 2021 05:10:15 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id p22sm1241858ejx.59.2021.01.06.05.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 05:10:15 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v2 net-next 00/10] Get rid of the switchdev transactional model
Date:   Wed,  6 Jan 2021 15:09:56 +0200
Message-Id: <20210106131006.577312-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series comes after the late realization that the prepare/commit
separation imposed by switchdev does not help literally anybody:
https://patchwork.kernel.org/project/netdevbpf/patch/20201212203901.351331-1-vladimir.oltean@nxp.com/

We should kill it before it inflicts even more damage to the error
handling logic in drivers.

Also remove the unused VLAN ranges feature from the switchdev VLAN
objects, which simplifies all drivers by quite a bit.

Vladimir Oltean (10):
  net: switchdev: remove vid_begin -> vid_end range from VLAN objects
  net: switchdev: remove the transaction structure from port object
    notifiers
  net: switchdev: delete switchdev_port_obj_add_now
  net: switchdev: remove the transaction structure from port attributes
  net: dsa: remove the transactional logic from ageing time notifiers
  net: dsa: remove the transactional logic from MDB entries
  net: dsa: remove the transactional logic from VLAN objects
  net: dsa: remove obsolete comments about switchdev transactions
  mlxsw: spectrum_switchdev: remove transactional logic for VLAN objects
  net: switchdev: delete the transaction object

 drivers/net/dsa/b53/b53_common.c              |  96 +++++-----
 drivers/net/dsa/b53/b53_priv.h                |  15 +-
 drivers/net/dsa/bcm_sf2.c                     |   2 -
 drivers/net/dsa/bcm_sf2_cfp.c                 |  10 +-
 drivers/net/dsa/dsa_loop.c                    |  68 +++-----
 drivers/net/dsa/hirschmann/hellcreek.c        |  39 ++---
 drivers/net/dsa/lan9303-core.c                |  12 +-
 drivers/net/dsa/lantiq_gswip.c                | 100 ++++-------
 drivers/net/dsa/microchip/ksz8795.c           |  76 ++++----
 drivers/net/dsa/microchip/ksz9477.c           |  96 +++++-----
 drivers/net/dsa/microchip/ksz_common.c        |  25 +--
 drivers/net/dsa/microchip/ksz_common.h        |   8 +-
 drivers/net/dsa/mt7530.c                      |  52 ++----
 drivers/net/dsa/mv88e6xxx/chip.c              | 147 ++++++++--------
 drivers/net/dsa/ocelot/felix.c                |  69 ++------
 drivers/net/dsa/qca8k.c                       |  37 ++--
 drivers/net/dsa/realtek-smi-core.h            |   9 +-
 drivers/net/dsa/rtl8366.c                     | 152 +++++++---------
 drivers/net/dsa/rtl8366rb.c                   |   1 -
 drivers/net/dsa/sja1105/sja1105.h             |   3 +-
 drivers/net/dsa/sja1105/sja1105_devlink.c     |   9 +-
 drivers/net/dsa/sja1105/sja1105_main.c        |  97 ++++------
 .../marvell/prestera/prestera_switchdev.c     |  62 ++-----
 .../mellanox/mlxsw/spectrum_switchdev.c       | 165 +++++-------------
 drivers/net/ethernet/mscc/ocelot.c            |  32 ++--
 drivers/net/ethernet/mscc/ocelot_net.c        |  69 ++------
 drivers/net/ethernet/rocker/rocker.h          |   6 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  61 ++-----
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  43 ++---
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  70 ++------
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       | 115 +++++-------
 include/net/dsa.h                             |  11 +-
 include/net/switchdev.h                       |  27 +--
 include/soc/mscc/ocelot.h                     |   3 +-
 net/bridge/br_switchdev.c                     |   6 +-
 net/dsa/dsa_priv.h                            |  27 +--
 net/dsa/port.c                                | 103 +++++------
 net/dsa/slave.c                               |  79 +++------
 net/dsa/switch.c                              |  89 ++--------
 net/switchdev/switchdev.c                     | 101 ++---------
 40 files changed, 710 insertions(+), 1482 deletions(-)

-- 
2.25.1

