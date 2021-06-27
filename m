Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433823B532F
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 13:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhF0L5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 07:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhF0L5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 07:57:02 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB61C061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:38 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id bu12so24148383ejb.0
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=npfiwu2jfDBCE30/VYlpsY2Ap9hU1mr5xUJ3tiTnGss=;
        b=oNGqpDkE6uRc9cxdPZEbEhu6YyQqRBLn3n5vHK9WjAyY7AC3pCMyk4ezYNRZdkmUDM
         oBr01wiwGMqQBy5NvscT4PtoLhkglo3jHydbYxP15IHpURCOYvoPGS0088ja3DjyEDYu
         w1FNVt4s4W6hen56adebQpc6G3isGIozEawQKPp1eTAv2/td51/6BymDgVnJu95Y0nyR
         G2S9nnnMxwrpcezMuIIAmj2ZNOht3gymu/z///tRmul3KPo9GUalPHMGiVZWD0Nsvkl6
         EpB65MeNqOCS+ujACorB49juJrHgflcTHnbm85k1mJQyWDdNfeV8zdOc44otV2zLM1zk
         LXJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=npfiwu2jfDBCE30/VYlpsY2Ap9hU1mr5xUJ3tiTnGss=;
        b=KRisN/45HWIL61kP2cTmv2GmFDce+VDMqE7mlgnnom5sRpCUD4p77IQoHVlzRUhl2K
         eaog1QLe+wO4u8ErL6H0oYvwQ+nyy+SUTW6iJNZXeiQWcs8LGGArwx3dV1jcjUiBK7H2
         AQTdFzSTsycVGoMhTbY+g2WBhy47tae7tbJeeYkLs8SlVNMY0WJN9EtU+Rlnrd+q/jjP
         X8Z9DeevChyH4pl5SHZxKkPmkwk4gqEmHyyazkq6w9zP+vBIn1Ax1o3UdZHeIt455uMA
         CwiHrATMzLyuT7hGXsnGguLgVtK4LDXGv/pxNZtToPo2PkPdacfOYt4m6BFrj/JHJVFh
         u0Xg==
X-Gm-Message-State: AOAM531lOQjH5MGD5RmaCDSQOKgHjcdLFf8smYhB35OY3/ux/ALRJdsq
        Mh0mTjT+84R9FfG59J3fjmI=
X-Google-Smtp-Source: ABdhPJzKFAVJOgwmUG+VGqrjB9yIOiSQIcMUR7AH3cNsync895Uir/YUXOMlaOxxvA0QTh81xZefPw==
X-Received: by 2002:a17:906:1f11:: with SMTP id w17mr19676299ejj.33.1624794876505;
        Sun, 27 Jun 2021 04:54:36 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7683688edu.49.2021.06.27.04.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 04:54:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 0/8] Cleanup for the bridge replay helpers
Date:   Sun, 27 Jun 2021 14:54:21 +0300
Message-Id: <20210627115429.1084203-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch series brings some improvements to the logic added to the
bridge and DSA to handle LAG interfaces sandwiched between a bridge and
a DSA switch port.

        br0
        /  \
       /    \
     bond0  swp2
     /  \
    /    \
  swp0  swp1

In particular, it ensures that the switchdev object additions and
deletions are well balanced per physical port. This is important for
future work in the area of offloading local bridge FDB entries to
hardware in the context of DSA requesting a replay of those entries at
bridge join time (this will be submitted in a future patch series).
Due to some difficulty ensuring that the deletion of local FDB entries
pointing towards the bridge device itself is notified to switchdev in
time (before the switchdev port disconnects from the bridge), this is
potentially still not the final form in which the replay helpers will
exist. I'm thinking about moving from the pull mode (in which DSA
requests the replay) to a push mode (in which the bridge initiates the
replay). Nonetheless, these preliminary changes are needed either way.

The patch series also addresses some feedback from Nikolai which is long
overdue by now (sorry).

Switchdev driver maintainers were deliberately omitted due to the
trivial nature of the driver changes (just a function prototype).

Changes in v2:
- fix build issue in patch 4 (function prototype mismatch)
- move switchdev object unsync to the NETDEV_PRECHANGEUPPER code path

Vladimir Oltean (8):
  net: bridge: include the is_local bit in br_fdb_replay
  net: ocelot: delete call to br_fdb_replay
  net: switchdev: add a context void pointer to struct
    switchdev_notifier_info
  net: bridge: ignore switchdev events for LAG ports which didn't
    request replay
  net: bridge: constify variables in the replay helpers
  net: bridge: allow the switchdev replay functions to be called for
    deletion
  net: dsa: refactor the prechangeupper sanity checks into a dedicated
    function
  net: dsa: replay a deletion of switchdev objects for ports leaving a
    bridged LAG

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   2 +-
 .../marvell/prestera/prestera_switchdev.c     |   6 +-
 .../mellanox/mlx5/core/en/rep/bridge.c        |   3 +
 .../mellanox/mlxsw/spectrum_switchdev.c       |   6 +-
 .../microchip/sparx5/sparx5_switchdev.c       |   2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  29 +++--
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c |   6 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c      |   6 +-
 include/linux/if_bridge.h                     |  30 ++---
 include/net/switchdev.h                       |  13 ++-
 net/bridge/br_fdb.c                           |  23 ++--
 net/bridge/br_mdb.c                           |  23 ++--
 net/bridge/br_stp.c                           |   4 +-
 net/bridge/br_vlan.c                          |  15 ++-
 net/dsa/dsa_priv.h                            |   4 +
 net/dsa/port.c                                |  58 +++++++--
 net/dsa/slave.c                               | 110 +++++++++++++++---
 net/switchdev/switchdev.c                     |  25 ++--
 18 files changed, 267 insertions(+), 98 deletions(-)

-- 
2.25.1

