Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3BE3197BE
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 02:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhBLBG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 20:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhBLBGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 20:06:25 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7593C061574;
        Thu, 11 Feb 2021 17:05:44 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id q2so9009318edi.4;
        Thu, 11 Feb 2021 17:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mE/OVlXJFK1GimzChU0IMobvC2t4RAJYhxND9dZJsvY=;
        b=bHy9naBQqEYCJdPmyYg7EB5tRKfXeGjhU0sW1LfOvR//3Mk+6YoX6bdojQAbDxfkMK
         7KVNtbaV3JxPz5X+nuWQCSgG0GFmHBJHOe32FsjoJLO83jQGUwj8BfEFijss1HhkCpxB
         ueumz3wYFrKtJrPWnz8CAdGIe/AULhttcIHXBNcevT/2V/4CeWsqfu5VNyxQeJo4Bu/g
         mPnw8fzlLY5/L9yW4qf/RNulzYPLRg6wbW4/FWFQ/TP7uZ3Cyd7I/QCeMXmA7AaLH4MM
         OdduONNr1bk14giWUbNwp8TMzJwaUFXla34ENu9r2KB52SqlYY4efDMc1qo7hQLBFKY8
         jQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mE/OVlXJFK1GimzChU0IMobvC2t4RAJYhxND9dZJsvY=;
        b=rXO2Fu4S0pGaTvbWFpsCfs6DRIx6E3YTmVPSi8yrEi2PKCKGegUb90NUKXVZhBlv+w
         OSJtLDJX4YM4nucb1pl5NrL4jdy9pETt9WAAvAl29+Yi+jbku9s6LZ8nYY/NcpJJyygz
         JF84vZHgJD+p0/qSqgL6+KfHqWPMWUFdlTlaNsaWs8S73sF/pWatShvpb7PquZcMrv1C
         x/8mido14ip7Oyc1UHX06deb/52hKdKf1ExbSNMqQqE+XRnOqq+RjwoEZNUF2Y4mAJ58
         Mrd4P/buKKVeOv3a65VA2PVD8v2o/KXh7aJ9i2Zmt86NBWvN/o1G9OuMBHdcSKrubCUe
         XBMg==
X-Gm-Message-State: AOAM530LeENRm+0lkx12VYAarVnTpzzV2n6fWPfuM/jUkF53JNvuis5R
        13ofEnsfQQVVO3KA4k6aCSc=
X-Google-Smtp-Source: ABdhPJzia/I4O9+eAYOLguF3V7ApJSYuV6J2LNIlfyS+JbWkQxXcyU9MtGYebpKky304PIH27FaUKQ==
X-Received: by 2002:a05:6402:289:: with SMTP id l9mr872805edv.218.1613091943526;
        Thu, 11 Feb 2021 17:05:43 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z13sm5019580edc.73.2021.02.11.17.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 17:05:42 -0800 (PST)
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
Subject: [PATCH v4 net-next 0/9] Cleanup in brport flags switchdev offload for DSA
Date:   Fri, 12 Feb 2021 03:05:22 +0200
Message-Id: <20210212010531.2722925-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The initial goal of this series was to have better support for
standalone ports mode on the DSA drivers like ocelot/felix and sja1105.
This turned out to require some API adjustments in both directions:
to the information presented to and by the switchdev notifier, and to
the API presented to the switch drivers by the DSA layer.

Vladimir Oltean (9):
  net: switchdev: propagate extack to port attributes
  net: bridge: offload all port flags at once in br_setport
  net: bridge: don't print in br_switchdev_set_port_flag
  net: dsa: configure better brport flags when ports leave the bridge
  net: switchdev: pass flags and mask to both {PRE_,}BRIDGE_FLAGS
    attributes
  net: dsa: act as ass passthrough for bridge port flags
  net: mscc: ocelot: use separate flooding PGID for broadcast
  net: mscc: ocelot: offload bridge port flags to device
  net: dsa: sja1105: offload bridge port flags to device

 drivers/net/dsa/b53/b53_common.c              |  91 ++++---
 drivers/net/dsa/b53/b53_priv.h                |   2 -
 drivers/net/dsa/mv88e6xxx/chip.c              | 163 ++++++++++---
 drivers/net/dsa/mv88e6xxx/chip.h              |   6 +-
 drivers/net/dsa/mv88e6xxx/port.c              |  52 ++--
 drivers/net/dsa/mv88e6xxx/port.h              |  19 +-
 drivers/net/dsa/ocelot/felix.c                |  22 ++
 drivers/net/dsa/sja1105/sja1105.h             |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 222 +++++++++++++++++-
 drivers/net/dsa/sja1105/sja1105_spi.c         |   6 +
 .../marvell/prestera/prestera_switchdev.c     |  26 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  53 +++--
 drivers/net/ethernet/mscc/ocelot.c            | 100 +++++++-
 drivers/net/ethernet/mscc/ocelot_net.c        |  52 +++-
 drivers/net/ethernet/rocker/rocker_main.c     |  10 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  27 ++-
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       |  34 ++-
 include/net/dsa.h                             |  10 +-
 include/net/switchdev.h                       |  13 +-
 include/soc/mscc/ocelot.h                     |  20 +-
 net/bridge/br_netlink.c                       | 116 +++------
 net/bridge/br_private.h                       |   6 +-
 net/bridge/br_switchdev.c                     |  23 +-
 net/bridge/br_sysfs_if.c                      |   7 +-
 net/dsa/dsa_priv.h                            |  11 +-
 net/dsa/port.c                                |  76 ++++--
 net/dsa/slave.c                               |  10 +-
 net/switchdev/switchdev.c                     |  11 +-
 28 files changed, 870 insertions(+), 320 deletions(-)

-- 
2.25.1

