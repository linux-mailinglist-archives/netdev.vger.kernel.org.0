Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D209831528E
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 16:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbhBIPUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 10:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbhBIPU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 10:20:28 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0D5C061786;
        Tue,  9 Feb 2021 07:19:47 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id q2so21088299eds.11;
        Tue, 09 Feb 2021 07:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yDRspLtelsFoyIiE67CZ331AeQ0bTafkmpJeD+VF4pk=;
        b=JC4s8djGQOzrTzuHwrVoADW5gtCbGscI01OdB+nb3cGLnM1OnabpHsTB4VGRUVRdga
         JNMJ8mq3YA4XkJA+tzZaKBd1xO3+Lbi+FFhrCB7IEaBArX9vrRQKkeFh/TJ23+zE9Qtd
         6D8lEGRdcKZUc5cquC8tNOrm2wI2clWRQi+tNFnlOSCZG45E9v2okcr4ziS9yPT9swq6
         /mnw0hQt6ez8JD0vMx+6/bMAe3nS27x74d+1dtcaDY1y71L9NLYyBN/nwX7MGwLyj+Q6
         n08dKeGS6KK7WKwNjPCnFgPvYlerVxg2jrayPTvULWk584aWaVxW0Jd16m7/7jUZVbxL
         xsYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yDRspLtelsFoyIiE67CZ331AeQ0bTafkmpJeD+VF4pk=;
        b=NReClCNWLC0YvDmM2F1NcSi/t4t8bsQ3bcfB36PzvV2oxW0jYEenap/DHbGTuwxalL
         SX5+BM0FvOPD5gM4Qsgi5MMGO/S1LcXuabDJKMKz8BitiCNqiL9DSmD65eS4vnnN6fp9
         wGsRcduLPZZpV6k0Y77xwnMp1Exapn3uQETF4EuJOy1tMyUZEQeWMbCWG1fxQquDHTjI
         drdSV/7Fwan4BNr83CAzRMD44Qo/KNGHRB+mDbE1SRBl6BTqAgVD5bAtxNQ7rS6XXqKM
         lf8BeD8pxZyqTwyVdQyS/0qgka6mt0lrUzVvybnTinDQ4MX0HZjPSEDgBYZqBzzpN31D
         RgCA==
X-Gm-Message-State: AOAM531S7vO3AVl7EenwwB3gFXSODiMwWaxr3T43jpQFCqctlzWyZjDD
        ImkZ3/b4+0I8GepJUW7GqGQ=
X-Google-Smtp-Source: ABdhPJwzLundh0R6SURzETYbLmh0kFOoqfJRsXMB3w/pZ7Zwn+UIs+6xV2v2qd7WGvgRpczdct2WAw==
X-Received: by 2002:a50:9d0b:: with SMTP id v11mr23859395ede.308.1612883986717;
        Tue, 09 Feb 2021 07:19:46 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q2sm11686108edv.93.2021.02.09.07.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 07:19:45 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH v2 net-next 00/11] Cleanup in brport flags switchdev offload for DSA
Date:   Tue,  9 Feb 2021 17:19:25 +0200
Message-Id: <20210209151936.97382-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The initial goal of this series was to have better support for
standalone ports mode and multiple bridges on the DSA drivers like
ocelot/felix and sja1105. Proper support for standalone mode requires
disabling address learning, which in turn requires interaction with the
switchdev notifier, which is actually where most of the patches are.

I also noticed that most of the drivers are actually talking either to
firmware or SPI/MDIO connected devices from the brport flags switchdev
attribute handler, so it makes sense to actually make it sleepable
instead of atomic.

Vladimir Oltean (11):
  net: switchdev: propagate extack to port attributes
  net: bridge: offload all port flags at once in br_setport
  net: bridge: don't print in br_switchdev_set_port_flag
  net: bridge: offload initial and final port flags through switchdev
  net: dsa: stop setting initial and final brport flags
  net: squash switchdev attributes PRE_BRIDGE_FLAGS and BRIDGE_FLAGS
  net: dsa: kill .port_egress_floods overengineering
  net: bridge: put SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS on the blocking
    call chain
  net: mscc: ocelot: use separate flooding PGID for broadcast
  net: mscc: ocelot: offload bridge port flags to device
  net: dsa: sja1105: offload bridge port flags to device

 drivers/net/dsa/b53/b53_common.c              |  20 +-
 drivers/net/dsa/mv88e6xxx/chip.c              |  21 +-
 drivers/net/dsa/ocelot/felix.c                |  10 +
 drivers/net/dsa/sja1105/sja1105.h             |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 212 +++++++++++++++++-
 drivers/net/dsa/sja1105/sja1105_spi.c         |   6 +
 .../marvell/prestera/prestera_switchdev.c     |  32 +--
 .../mellanox/mlxsw/spectrum_switchdev.c       |  31 +--
 drivers/net/ethernet/mscc/ocelot.c            |  72 +++++-
 drivers/net/ethernet/mscc/ocelot_net.c        |   7 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  24 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  35 ++-
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       |  43 ++--
 include/linux/if_bridge.h                     |   3 +
 include/net/dsa.h                             |   7 +-
 include/net/switchdev.h                       |  14 +-
 include/soc/mscc/ocelot.h                     |  18 +-
 net/bridge/br_if.c                            |  21 +-
 net/bridge/br_netlink.c                       | 160 ++++++-------
 net/bridge/br_private.h                       |   6 +-
 net/bridge/br_switchdev.c                     |  37 ++-
 net/dsa/dsa_priv.h                            |   8 +-
 net/dsa/port.c                                |  42 +---
 net/dsa/slave.c                               |  10 +-
 net/switchdev/switchdev.c                     |  11 +-
 25 files changed, 556 insertions(+), 296 deletions(-)

-- 
2.25.1

