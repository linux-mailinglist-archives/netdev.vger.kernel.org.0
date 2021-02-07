Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A06312835
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 00:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhBGXXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 18:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhBGXXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 18:23:44 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B650DC061756;
        Sun,  7 Feb 2021 15:23:03 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id p20so21825804ejb.6;
        Sun, 07 Feb 2021 15:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qdOLN8iSy3qRTlCt7W2Tkt/uKoMbxQxcelWIFl4Tv0c=;
        b=Byzf7Ch6lxgMByroVpIyGbVWj+WES57XvUbGEWPQ2MDz1xZYNGbPNk9g/UBuyfdJZ0
         370tyntgVPLxpitPW7poWT9XkCvYie4tVQJvYCzW2etWEZn3SzhHcC3YkOc9tMrGVrF4
         C0oDi+3KPIy9x8XBuEYc3IGodXUknCADmCP7cKJTD9L3VMdJdGyd7DL6tXh5gdT4BC6I
         lfh5i28iucwGR6Tf5WYOiVW7P/zSvHTyzFeK+VME2GVttYIqHK31T+1nVE4FAzBbKKxQ
         IQuDdIcAeQ3vnKwNdl2INdVhnREjtNSwTEaiPdPTMUJDmsr15U1xyiMNUTkKn4TBRL7u
         0kWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qdOLN8iSy3qRTlCt7W2Tkt/uKoMbxQxcelWIFl4Tv0c=;
        b=kz2vEzBxC8RO8W/2y4Kb51u0lm03OP6R1JfX4AZMLZh1eJZe8xiJ7n6Qj6IGwBUJsZ
         cBWfrVncjHitOm/FjMBt5d2UHHkiV/KNWAmy8RP5otP/HmnqXRJY9alRgPVYmlK0sg45
         uHHU0ED1diunHUU5R+PphLhjGFC5MN489aTeeP2Og0DeXSK2tEPoqVAGBWqffb2bRJ7R
         9lBj2Amn7f/HFEkZd/r7UBepOHXxbFfn8tIUjh7Mh/dUisNDDOHv4vb4UjPp/aeUhN5q
         dHwGr9RkXPrxqmqm/upXZ3LuAUYJZqK5B8ac00dxqiEMNQgdy05WkjQa6Xs+KeD7IXxI
         zoFQ==
X-Gm-Message-State: AOAM531z+VSDB51rt00KTaplhSJDZ6I94hIx2hxDZfkjKoKF/zJ6bqCl
        tdORbEf8i1cpHy0s+u5A1Dk=
X-Google-Smtp-Source: ABdhPJxusXpCCs970jULRWNwmy+cIDjL8TtVTjsnERTVMudprC/skPz9sZt48aM94CVE/awhDDaZHQ==
X-Received: by 2002:a17:906:7687:: with SMTP id o7mr14362406ejm.209.1612740182250;
        Sun, 07 Feb 2021 15:23:02 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u21sm7540016ejj.120.2021.02.07.15.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 15:23:01 -0800 (PST)
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
Subject: [PATCH net-next 0/9] Cleanup in brport flags switchdev offload for DSA
Date:   Mon,  8 Feb 2021 01:21:32 +0200
Message-Id: <20210207232141.2142678-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The initial goal of this series was to have better support for
standalone ports mode and multiple bridges on the Ocelot/Felix DSA
driver. Proper support for standalone mode requires disabling address
learning, which in turn requires interaction with the switchdev notifier,
which is actually where most of the patches are.

Vladimir Oltean (9):
  net: bridge: don't print in br_switchdev_set_port_flag
  net: bridge: offload initial and final port flags through switchdev
  net: dsa: stop setting initial and final brport flags
  net: dsa: kill .port_egress_floods overengineering
  net: squash switchdev attributes PRE_BRIDGE_FLAGS and BRIDGE_FLAGS
  net: bridge: stop treating EOPNOTSUPP as special in
    br_switchdev_set_port_flag
  net: mscc: ocelot: use separate flooding PGID for broadcast
  net: mscc: ocelot: offload bridge port flags to device
  net: mscc: ocelot: support multiple bridges

 drivers/net/dsa/b53/b53_common.c              |  18 ++-
 drivers/net/dsa/mv88e6xxx/chip.c              |  19 ++-
 drivers/net/dsa/ocelot/felix.c                |   9 ++
 .../marvell/prestera/prestera_switchdev.c     |  16 +--
 .../mellanox/mlxsw/spectrum_switchdev.c       |  28 ++--
 drivers/net/ethernet/mscc/ocelot.c            | 135 +++++++++++++-----
 drivers/net/ethernet/mscc/ocelot_net.c        |   4 +
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |   2 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  24 +---
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  20 +--
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       |  22 +--
 include/net/dsa.h                             |   6 +-
 include/net/switchdev.h                       |   8 +-
 include/soc/mscc/ocelot.h                     |  26 ++--
 net/bridge/br_if.c                            |  24 +++-
 net/bridge/br_netlink.c                       |  67 +++++----
 net/bridge/br_private.h                       |   8 +-
 net/bridge/br_switchdev.c                     |  35 ++---
 net/dsa/dsa_priv.h                            |   4 +-
 net/dsa/port.c                                |  40 ++----
 net/dsa/slave.c                               |   3 -
 21 files changed, 285 insertions(+), 233 deletions(-)

-- 
2.25.1

