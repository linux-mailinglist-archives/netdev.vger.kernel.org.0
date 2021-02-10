Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4423B316204
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhBJJWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhBJJT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:19:59 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F48EC06174A;
        Wed, 10 Feb 2021 01:19:13 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id sa23so2855572ejb.0;
        Wed, 10 Feb 2021 01:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qNqiC3tG2xwOJq2qddxb/1WR+HrSzwiNawlUePCsQFs=;
        b=FZHA5b7/YbuGyx85UjaXr9oA7wpfJd4MyLm1ksHXD3V6l7MiRrIaewHCmrv+bq8Zi8
         hiJ22S3maNnxwqq2z4zZn9+TANcjaVDKFB6MX/1Vi3hnHUH+cTuWfy5r8n1etiZUXQdM
         LMfkTM71xfGGdEwcSrTmn70MpKhdA0FNWu4YQIStGJ4vr55WIyH7/AYfQ4SALcTXr6sk
         rxpgfNbQc9Z22hNYBB9+cL8Z/2Ue9GL8iuCl06lZN9wyyarPc4pKVqdZn0f5WJIBAoeg
         5F2jOum72Q5wcrtY5tjoR2ETeeXSk1Aai3Vc3ZChzfqCRC5WpEVJKfwwvp9XZAYFw3zI
         ccTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qNqiC3tG2xwOJq2qddxb/1WR+HrSzwiNawlUePCsQFs=;
        b=Rrri5mfHSCI3bo4MAQvUEz0usPCuGd6H09nJF1SADZyWVLZnHMgMEh3z+uvaAYOUV2
         sSIPec7KiP2EeflsrB8cFO8wREGBIHOgMrPCF+c9HzVMFQ7DBUL3hZyXlRcGKQRlH/WQ
         Mx7x2FqAuD5++QE6EH7IbyFjtkmzW8v8UuJqA+2qX4fWvVepq32j4oSXEo9DHzfZS9d7
         EVmMpz757sJivzuoevAQvrKXbt0Bt9z0KcaI/yEsuLxslE9yNrMVWbonPUQ/Ui/WnI7o
         R+gwWc5ZbuTJ9+GuhEbWfYR6nLem+5e5QF+Z+YvaVw+r0gCabB9UR7VB1KQ4NPNgX5sF
         vReQ==
X-Gm-Message-State: AOAM531/oxrdY6vLVVwMhgC4NTpp5LaKhPPV8HGPt8e7hH+GdboeCocu
        C6wAjVWRVc/2BhvLsXXlcysqLCOrF7k=
X-Google-Smtp-Source: ABdhPJwIfhzp1/ATswAZt7VNiXvQg+QbM0Af40aVGYZcs2kRvVjaRB7YpSMTSF0/8yNHzKfuuoXOFg==
X-Received: by 2002:a17:906:ce24:: with SMTP id sd4mr1980081ejb.21.1612948752399;
        Wed, 10 Feb 2021 01:19:12 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u2sm701801ejb.65.2021.02.10.01.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 01:19:11 -0800 (PST)
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
Subject: [PATCH v3 net-next 00/11] Cleanup in brport flags switchdev offload for DSA
Date:   Wed, 10 Feb 2021 11:14:34 +0200
Message-Id: <20210210091445.741269-1-olteanv@gmail.com>
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
  net: dsa: configure proper brport flags when ports leave the bridge
  net: squash switchdev attributes PRE_BRIDGE_FLAGS and BRIDGE_FLAGS
  net: dsa: kill .port_egress_floods overengineering
  net: prep switchdev drivers for concurrent
    SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS
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
 .../marvell/prestera/prestera_switchdev.c     |  54 +++--
 .../mellanox/mlxsw/spectrum_switchdev.c       |  90 ++++----
 drivers/net/ethernet/mscc/ocelot.c            |  72 +++++-
 drivers/net/ethernet/mscc/ocelot_net.c        |   7 +-
 drivers/net/ethernet/rocker/rocker.h          |   2 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  24 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  26 ++-
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  35 ++-
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       |  43 ++--
 include/net/dsa.h                             |   7 +-
 include/net/switchdev.h                       |  14 +-
 include/soc/mscc/ocelot.h                     |  18 +-
 net/bridge/br_netlink.c                       | 162 ++++++-------
 net/bridge/br_private.h                       |   6 +-
 net/bridge/br_switchdev.c                     |  33 ++-
 net/bridge/br_sysfs_if.c                      |  21 +-
 net/dsa/dsa_priv.h                            |   8 +-
 net/dsa/port.c                                |  76 ++++---
 net/dsa/slave.c                               |  10 +-
 net/switchdev/switchdev.c                     |  11 +-
 26 files changed, 654 insertions(+), 336 deletions(-)

-- 
2.25.1

