Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A13F1AFB54
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 16:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgDSOTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 10:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbgDSOTE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 10:19:04 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08206214AF;
        Sun, 19 Apr 2020 14:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587305943;
        bh=HGGxwLDnLH3qBDS3TOfoWeiAb1IBnNmSSrucnC+YpY4=;
        h=From:To:Cc:Subject:Date:From;
        b=wgZer+L0X/9tLbkf2Hnm+en6Yx73tH9RBpDzlz5WjPLE0ghDarParNoFmXH2p98w1
         6g+pno0FKZ/bQ3iXbgL41BpeTgBNNpnJDyRjjGOiBzZCFCYl+VeW9w/DC0kMC8EQah
         MMYG8607eDHxDRLE47wZwZzeFIEoNBB6/5mPjqFg=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Borislav Petkov <bp@suse.de>, Ion Badulescu <ionut@badula.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jessica Yu <jeyu@kernel.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Salil Mehta <salil.mehta@huawei.com>,
        Sebastian Reichel <sre@kernel.org>,
        Shannon Nelson <snelson@pensando.io>,
        Veaceslav Falico <vfalico@gmail.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: [PATCH net-next v2 0/4] Remove vermagic header from global include folder
Date:   Sun, 19 Apr 2020 17:18:46 +0300
Message-Id: <20200419141850.126507-1-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
v2:
 * Changed the implementation of patch #4 to be like Masahiro wants.
I personally don't like this implementation and changing it just to move forward
this this patchset.
v1:
https://lore.kernel.org/lkml/20200415133648.1306956-1-leon@kernel.org
 * Added tags
 * Updated patch #4 with test results
 * Changed scripts/mod/modpost.c to create inclusion of vermagic.h
   from kernel folder and not from general include/linux. This is
   needed to generate *.mod.c files, while building modules.
v0:
https://lore.kernel.org/lkml/20200414155732.1236944-1-leon@kernel.org
----------------------------------------------------------------------------

Hi,

This is followup to the failure reported by Borislav [1] and suggested
fix later on [2].

The series removes all includes of linux/vermagic.h, updates hns and
nfp to use same kernel versioning scheme (exactly like we did for
other drivers in previous cycle) and removes vermagic.h from global
include folder.

[1] https://lore.kernel.org/lkml/20200411155623.GA22175@zn.tnic
[2] https://lore.kernel.org/lkml/20200413080452.GA3772@zn.tnic

------------------------------------------------------------
1. Honestly, I have no idea if it can go to net-rc, clearly not all my
patches are fixes, so I'm sending them to the net-next.
2. Still didn't get response from kbuild, but it passed my own
compilation tests.
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=vermagic

Thanks

Leon Romanovsky (4):
  drivers: Remove inclusion of vermagic header
  net/hns: Remove custom driver version in favour of global one
  net/nfp: Update driver to use global kernel version
  kernel/module: Hide vermagic header file from general use

 drivers/net/bonding/bonding_priv.h                   | 2 +-
 drivers/net/ethernet/3com/3c509.c                    | 1 -
 drivers/net/ethernet/3com/3c515.c                    | 1 -
 drivers/net/ethernet/adaptec/starfire.c              | 1 -
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c      | 3 ---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h      | 4 ----
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c   | 4 ----
 drivers/net/ethernet/netronome/nfp/nfp_main.c        | 3 ---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 --
 drivers/net/ethernet/pensando/ionic/ionic_main.c     | 2 +-
 drivers/power/supply/test_power.c                    | 2 +-
 include/linux/vermagic.h                             | 5 +++++
 kernel/module.c                                      | 3 +++
 net/ethtool/ioctl.c                                  | 3 +--
 scripts/mod/modpost.c                                | 1 +
 15 files changed, 13 insertions(+), 24 deletions(-)

--
2.25.2

