Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C220D2ECD40
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbhAGJvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbhAGJvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:42 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CFEC0612F5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:51:03 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id qw4so8758563ejb.12
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 01:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rVj4CmclfeGkdtlXppPTJxGuA2LguLsjMH5QlJ5c/ck=;
        b=Hxmkn+U9w530KGSGNhBz3ey+o8LSA540y+LWrKE57HUYporEeGK8XFSFNfc1odosoW
         TsJxKRoXKBbrhaAJMOh7BnM6Sgt5rOEB2FxAt/hbzSnsgRmTaioZ0iDNYjWDrXe5+uZI
         WGyz/GWa6UpXuU7SiOCgnBA15O7avDJEVCDbDiTrWCX0FBQorHqlath+L7QYvq/1qvQn
         Hw/hNgehZBsB0pK99GwkRN9NZvPwyVegWp6J3pmLbV0lSFUj97PpS9cEmzg+eKBM/Ev9
         jmQlRUUXUTz5q3YCuBIJia11WwptBETTm/yIezyvo/2elE/mRxxLq+WuL/NT4qgp19Yw
         ya8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rVj4CmclfeGkdtlXppPTJxGuA2LguLsjMH5QlJ5c/ck=;
        b=GrbRGBg6XlrrJRI9L70t9IKrxmgpctjgcUKYFbillKxLN5b5DU5Pem0XLQ4v+sE9UP
         FinAskfbFfRumARxYkv/oSkEt54qz43PzaifWTIUTZEjmbIPT7BPik32Dg2rk4YjM06g
         bqWJC7zpL+aXLzzRFjnr1VevdF1LJoGxis/wjSBtOB0fVDDFXT8GE9kD68f12d53iWZW
         FvLgyFZZmD1naGC/9dFR8QvdyJ0waW8uPneqt3RbBtL6fkpMY/D/ZL82rQmCHXyoPQYO
         lz568O5VFArD2zlIpyGp7okQOZ4YQgEkuiaewkfff0bZGIxxAzAXdbPgWQG/DwRVZkQG
         yCLg==
X-Gm-Message-State: AOAM5333jX5Ezax81VTDS2rEQEQLqrisXdsbboq2QUTzRAfU5MAlSsJs
        97kQw8MdAAzQQ5hPa+/dLfQ=
X-Google-Smtp-Source: ABdhPJy18+QQdp3rXwQbRJLeMiIZh2+ltF3mBF1PR4oSH1vGRnFtP1gNo2LEoBTnZmhHjkZhHyd+/g==
X-Received: by 2002:a17:906:90d6:: with SMTP id v22mr5800936ejw.88.1610013062682;
        Thu, 07 Jan 2021 01:51:02 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k15sm2251571ejc.79.2021.01.07.01.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 01:51:02 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 net-next 00/12] Make .ndo_get_stats64 sleepable
Date:   Thu,  7 Jan 2021 11:49:39 +0200
Message-Id: <20210107094951.1772183-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Changes in v3:
- Resolved some memory leak issues in the bonding patch 10/12.

Changes in v2:
- Addressed the recursion issues in .ndo_get_stats64 from bonding and
  net_failover.
- Renamed netdev_lists_lock to netif_lists_lock
- Stopped taking netif_lists_lock from drivers as much as possible.

This series converts all callers of dev_get_stats() to be in sleepable
context, so that we can do more work in the .ndo_get_stats64 method.

The situation today is that if we have hardware that needs to be
accessed through a slow bus like SPI, or through a firmware, we cannot
do that directly in .ndo_get_stats64, so we have to poll counters
periodically and return a cached (not up to date) copy in the atomic NDO
callback. This is undesirable on both ends: more work than strictly
needed is being done, and the end result is also worse (not guaranteed
to be up to date). So converting the code paths to be compatible with
sleeping seems to make more sense.

Vladimir Oltean (12):
  net: mark dev_base_lock for deprecation
  net: introduce a mutex for the netns interface lists
  net: procfs: hold netif_lists_lock when retrieving device statistics
  net: sysfs: don't hold dev_base_lock while retrieving device
    statistics
  s390/appldata_net_sum: hold the netdev lists lock when retrieving
    device statistics
  parisc/led: reindent the code that gathers device statistics
  parisc/led: hold the netdev lists lock when retrieving device
    statistics
  net: make dev_get_stats return void
  net: net_failover: ensure .ndo_get_stats64 can sleep
  net: bonding: ensure .ndo_get_stats64 can sleep
  net: mark ndo_get_stats64 as being able to sleep
  net: remove obsolete comments about ndo_get_stats64 context from eth
    drivers

 Documentation/networking/netdevices.rst       |   8 +-
 Documentation/networking/statistics.rst       |   9 +-
 arch/s390/appldata/appldata_net_sum.c         |  33 ++---
 drivers/leds/trigger/ledtrig-netdev.c         |   9 +-
 drivers/net/bonding/bond_main.c               | 119 +++++++++---------
 drivers/net/ethernet/cisco/enic/enic_main.c   |   1 -
 .../net/ethernet/hisilicon/hns/hns_ethtool.c  |  51 ++++----
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |   7 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c  |   7 +-
 drivers/net/ethernet/nvidia/forcedeth.c       |   2 -
 drivers/net/ethernet/sfc/efx_common.c         |   1 -
 drivers/net/ethernet/sfc/falcon/efx.c         |   1 -
 drivers/net/net_failover.c                    |  63 +++++++---
 drivers/parisc/led.c                          |  37 +++---
 drivers/scsi/fcoe/fcoe_transport.c            |   6 +-
 drivers/usb/gadget/function/rndis.c           |  45 +++----
 include/linux/netdevice.h                     |  13 +-
 include/net/bonding.h                         |  49 +++++++-
 include/net/net_failover.h                    |   9 +-
 include/net/net_namespace.h                   |   6 +
 net/8021q/vlanproc.c                          |  15 ++-
 net/core/dev.c                                |  69 ++++++----
 net/core/net-procfs.c                         |  48 +++----
 net/core/net-sysfs.c                          |  10 +-
 net/openvswitch/vport.c                       |  25 ++--
 25 files changed, 367 insertions(+), 276 deletions(-)

-- 
2.25.1

