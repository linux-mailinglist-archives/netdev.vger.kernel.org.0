Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF20C1152
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 18:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbfI1Qs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 12:48:57 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45086 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI1Qs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 12:48:56 -0400
Received: by mail-pg1-f195.google.com with SMTP id q7so5035821pgi.12;
        Sat, 28 Sep 2019 09:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rAipZ4g31j/uo8D+iKR4GryVJ+tjL+DJFUxE/r+fXUI=;
        b=vBnsNUUXzmaYvl23HaTJ2pKU/YlSdg8DrVfHHIhFo2G7XZgV5UmnTZcr6Ao/w8zaRJ
         gKaUQPDBreN0QorXa/Ae1mXUPO9hx2SC48IufOYVZYTgd4EkAh3tSDggyYO5DSxh+jro
         9VnnBWrgy8+t5di9csIjPD/Y5thePDFXiMSL6w0g3LYlIFWqTgD05yNJ5Vwc5Yfk4tcj
         D1WlnmngLBZk7+6LOzHKgULI12ljeX6dMJiDW2Tr8Fn/epcJ3N/g3uRPJD9Q48miQUhF
         wZ0ZlpNH8hkVeGRlBUEE5kPpU85qnl2MJgws2VJ5koqE5s2gQbD5d77+TECfPit2fJWv
         BYhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rAipZ4g31j/uo8D+iKR4GryVJ+tjL+DJFUxE/r+fXUI=;
        b=aPtZesdsd7HHXPEZ+m0JXGaHTBN1F8OngjO0iSyGhkJzO58ao9riA4xIfAFNVi3d5U
         DtCmSJMPYeRQ1fjNWPr6XEE+oNy8uS0aJsUqm2B4DwRhHxG1piAxj5brL0XXrz55z1BD
         1/8b0EahNJfuQxVRKX9bRqSX+g6lB5XCgreJTkAfqOC2xtvPzAmKV8W66xyoxyC/pW8i
         OVONQnC+xWVIiT3wxT6W/FkS4duXpf3FOTYWOlU5Mqlb+0zatUfYViuXolRtGP7mj7dF
         24xtlBOLG9dWiyMUJPqLmk14ySYdyfplCvM7zic3FB2AuNTVV3h5/pPE/AwIMrEwQtXu
         PaWg==
X-Gm-Message-State: APjAAAUL6wEB2aA3vvIG8uDzZxqdxR4XvT4ApSO5TpQVxUcbOYAMgV/A
        yRTB0c9UBTTiVpjXEWklfRM=
X-Google-Smtp-Source: APXvYqyUB1mH2RxyUWuAqMVz2uw2ZYx5PE8A8v/bO8mK1DDhWfnUBFBU2EzIBNdozhWxkC1SZeDv0g==
X-Received: by 2002:a63:6e85:: with SMTP id j127mr15955708pgc.326.1569689335256;
        Sat, 28 Sep 2019 09:48:55 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id 30sm8663092pjk.25.2019.09.28.09.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 09:48:54 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, jakub.kicinski@netronome.com,
        johannes@sipsolutions.net, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jiri@resnulli.us, sd@queasysnail.net,
        roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Cc:     ap420073@gmail.com
Subject: [PATCH net v4 00/12] net: fix nested device bugs
Date:   Sat, 28 Sep 2019 16:48:31 +0000
Message-Id: <20190928164843.31800-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes several bugs that are related to nesting
device infrastructure.
Current nesting infrastructure code doesn't limit the depth level of
devices. nested devices could be handled recursively. at that moment,
it needs huge memory and stack overflow could occur.
Below devices type have same bug.
VLAN, BONDING, TEAM, MACSEC, MACVLAN, IPVLAN, VIRT_WIFI and VXLAN.
But I couldn't test all interface types so there could be more device
types which have similar problems.
Maybe qmi_wwan.c code could have same problem.
So, I would appreciate if someone test qmi_wwan.c and other modules.

Test commands:
    ip link add dummy0 type dummy
    ip link add vlan1 link dummy0 type vlan id 1

    for i in {2..100}
    do
	    let A=$i-1
	    ip link add name vlan$i link vlan$A type vlan id $i
    done
    ip link del dummy0

1st patch actually fixes the root cause.
It adds new common variables {upper/lower}_level that represent
depth level. upper_level variable is depth of upper devices.
lower_level variable is depth of lower devices.

      [U][L]       [U][L]
vlan1  1  5  vlan4  1  4
vlan2  2  4  vlan5  2  3
vlan3  3  3    |
  |            |
  +------------+
  |
vlan6  4  2
dummy0 5  1

After this patch, the nesting infrastructure code uses this variable to
check the depth level.

2, 4, 5, 6, 7 patches fix lockdep related problem.
Before this patch, devices use static lockdep map.
So, if devices that are same type is nested, lockdep will warn about
recursive situation.
These patches make these devices use dynamic lockdep key instead of
static lock or subclass.

3rd patch fixes unexpected IFF_BONDING bit unset.

8th patch fixes a refcnt leak in the macsec module.

9th patch adds ignore flag to an adjacent structure.
In order to exchange an adjacent node safely, ignore flag is needed.

10th patch makes vxlan add an adjacent link to limit depth level.

11th patch removes unnecessary variables and callback.

12th patch fix refcnt leaks in the virt_wifi module

v3 -> v4 :
 - Add new 12th patch to fix refcnt leaks in the virt_wifi module
 - Fix wrong usage netdev_upper_dev_link() in the vxlan.c
 - Preserve reverse christmas tree variable ordering in the vxlan.c
 - Add missing static keyword in the dev.c
 - Expose netdev_adjacent_change_{prepare/commit/abort} instead of
   netdev_adjacent_dev_{enable/disable}
v2 -> v3 :
 - Modify nesting infrastructure code to use iterator instead of recursive.
v1 -> v2 :
 - Make the 3rd patch do not add a new priv_flag.

Taehee Yoo (12):
  net: core: limit nested device depth
  vlan: use dynamic lockdep key instead of subclass
  bonding: fix unexpected IFF_BONDING bit unset
  bonding: use dynamic lockdep key instead of subclass
  team: use dynamic lockdep key instead of static key
  macsec: use dynamic lockdep key instead of subclass
  macvlan: use dynamic lockdep key instead of subclass
  macsec: fix refcnt leak in module exit routine
  net: core: add ignore flag to netdev_adjacent structure
  vxlan: add adjacent link to limit depth level
  net: remove unnecessary variables and callback
  virt_wifi: fix refcnt leak in module exit routine

 drivers/net/bonding/bond_alb.c                |   2 +-
 drivers/net/bonding/bond_main.c               |  81 ++-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
 drivers/net/macsec.c                          |  50 +-
 drivers/net/macvlan.c                         |  36 +-
 drivers/net/team/team.c                       |  61 ++-
 drivers/net/vxlan.c                           |  52 +-
 drivers/net/wireless/virt_wifi.c              |  51 +-
 include/linux/if_macvlan.h                    |   3 +-
 include/linux/if_team.h                       |   5 +
 include/linux/if_vlan.h                       |  13 +-
 include/linux/netdevice.h                     |  26 +-
 include/net/bonding.h                         |   4 +-
 include/net/vxlan.h                           |   1 +
 net/8021q/vlan.c                              |   1 -
 net/8021q/vlan_dev.c                          |  32 +-
 net/core/dev.c                                | 508 +++++++++++++++---
 net/core/dev_addr_lists.c                     |  12 +-
 net/smc/smc_core.c                            |   2 +-
 net/smc/smc_pnet.c                            |   2 +-
 20 files changed, 752 insertions(+), 192 deletions(-)

-- 
2.17.1

