Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF142EC6B7
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbhAFXS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727641AbhAFXS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 18:18:27 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9133FC061786
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 15:17:46 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id g20so7386603ejb.1
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 15:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TCZPX5Zl4xRD9kRnj2gZK9C2/4Of926MHhlrcREnVcI=;
        b=Dk/u8Jl5ZTPGz8zfMkbV3RWwltfeMRYVRrMm/Z7jUCv6GUZMky04oLFcsAlbEMIIUB
         +DWUUm7u3EmC8mungXm71QhHPN1s65uclFQVP3bbLgnu5eaphOtbCpgh8d0muWZXyFT5
         WLbfYZIyALAHDp/zpUMDVUxIRCWhDODTmQbiu1hFf5JyTWKZEhNEtCOpNryaM/ssEou7
         PkbZ5VqewzDp9exzYGhxAKfdCvUix/dDGsgFLzJfygQX0N8QFVlCcg+8FCYJC7ZBNavS
         /3IeJ2XvckNyeIBcGf4/HmV2wuVOzYfzA0C8/lRRtPoBECADfzGXa2uhO7piENbqIn8E
         UZUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TCZPX5Zl4xRD9kRnj2gZK9C2/4Of926MHhlrcREnVcI=;
        b=OtAclxKMQGodAouSU9W7jNLdWLdjdUnafSU4KHZkHaQM7MSju+peNx9b79y73P6CdW
         kB+hZs35V/IzYHLjumODYd5x0spdp2SZBNKkkYnaonRuvJPAO3/9aRpgZlLD9hJvLWd9
         XyWK9GyS2w6oatqv2+Oocs/4cklyLMVB+yE0CdRDHmWeVZUNuG8bBbmrYgQqUHziW2ex
         txoAOAnFQslgGjyIIA3r4zKsdxFAOGmUATgNuv0LLPG+ikPlDx0A6aMd10m9TArUDCja
         NTFHnauivuoiyYYT8i6iFxjtOnuNNwTmybW36sBTFi/pxdEROk7jmdgregVEJKrIP7YI
         emqA==
X-Gm-Message-State: AOAM531lKT9Yqly35eZt4+cujQYrWaMiHzQp6hVSHPBA+CmVnSkuo0U5
        g0EzE1oCpVQP2RajdQ/kfo0=
X-Google-Smtp-Source: ABdhPJxM5/LukKugokkYW7l85FDHzesNanIL3rGjCkcH3X1e9R9dL8eGFchXJneWALltdeBuJbTsog==
X-Received: by 2002:a17:906:b002:: with SMTP id v2mr4520279ejy.531.1609975065343;
        Wed, 06 Jan 2021 15:17:45 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a6sm1958263edv.74.2021.01.06.15.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 15:17:44 -0800 (PST)
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
Subject: [PATCH v3 net-next 00/11] Get rid of the switchdev transactional model
Date:   Thu,  7 Jan 2021 01:17:17 +0200
Message-Id: <20210106231728.1363126-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Changes in v3:
- Resolved a build warning in mv88e6xxx and tested that it actually
  works properly, which resulted in an extra patch (02/11.
- Addressed Ido's minor feedback in commit 10/11 relating to a comment.

Changes in v2:
- Got rid of the vid_begin -> vid_end range too from the switchdev API.
- Actually propagating errors from DSA MDB and VLAN notifiers.

This series comes after the late realization that the prepare/commit
separation imposed by switchdev does not help literally anybody:
https://patchwork.kernel.org/project/netdevbpf/patch/20201212203901.351331-1-vladimir.oltean@nxp.com/

We should kill it before it inflicts even more damage to the error
handling logic in drivers.

Also remove the unused VLAN ranges feature from the switchdev VLAN
objects, which simplifies all drivers by quite a bit.

Vladimir Oltean (11):
  net: switchdev: remove vid_begin -> vid_end range from VLAN objects
  net: dsa: mv88e6xxx: deny vid 0 on the CPU port and DSA links too
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

 drivers/net/dsa/b53/b53_common.c              |  96 ++++------
 drivers/net/dsa/b53/b53_priv.h                |  15 +-
 drivers/net/dsa/bcm_sf2.c                     |   2 -
 drivers/net/dsa/bcm_sf2_cfp.c                 |  10 +-
 drivers/net/dsa/dsa_loop.c                    |  68 +++----
 drivers/net/dsa/hirschmann/hellcreek.c        |  39 ++--
 drivers/net/dsa/lan9303-core.c                |  12 +-
 drivers/net/dsa/lantiq_gswip.c                | 100 ++++-------
 drivers/net/dsa/microchip/ksz8795.c           |  76 ++++----
 drivers/net/dsa/microchip/ksz9477.c           |  96 +++++-----
 drivers/net/dsa/microchip/ksz_common.c        |  25 +--
 drivers/net/dsa/microchip/ksz_common.h        |   8 +-
 drivers/net/dsa/mt7530.c                      |  52 ++----
 drivers/net/dsa/mv88e6xxx/chip.c              | 155 ++++++++--------
 drivers/net/dsa/ocelot/felix.c                |  69 ++------
 drivers/net/dsa/qca8k.c                       |  37 ++--
 drivers/net/dsa/realtek-smi-core.h            |   9 +-
 drivers/net/dsa/rtl8366.c                     | 152 +++++++---------
 drivers/net/dsa/rtl8366rb.c                   |   1 -
 drivers/net/dsa/sja1105/sja1105.h             |   3 +-
 drivers/net/dsa/sja1105/sja1105_devlink.c     |   9 +-
 drivers/net/dsa/sja1105/sja1105_main.c        |  97 ++++------
 .../marvell/prestera/prestera_switchdev.c     |  62 ++-----
 .../mellanox/mlxsw/spectrum_switchdev.c       | 167 +++++-------------
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
 40 files changed, 714 insertions(+), 1488 deletions(-)

-- 
2.25.1

