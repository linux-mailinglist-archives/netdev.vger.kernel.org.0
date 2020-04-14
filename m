Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0A01A83FB
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391130AbgDNP5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390836AbgDNP5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 11:57:44 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12C43206D5;
        Tue, 14 Apr 2020 15:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586879864;
        bh=l9chY58r4Tu+9R4PzxN5YUOPlEav1oY44s9ex1BCTiU=;
        h=From:To:Cc:Subject:Date:From;
        b=RmfeK+QXiZNsEB5mIch9WsDk4/qNwCzlX5P4rjmP4AY5P3vOOlJghPsTIBHs0eBIR
         Me0t9pQsM0nYSapcMNqDL9gLd4x85XbI5Y1kIuy/urlAu08nfY+Oer1UtKqSHDDiKO
         yctIxm0KdJPeKAZcHtq3MsIiyUKWSGWtJaEjdkfk=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Borislav Petkov <bp@suse.de>, Ion Badulescu <ionut@badula.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jessica Yu <jeyu@kernel.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Pensando Drivers <drivers@pensando.io>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sebastian Reichel <sre@kernel.org>,
        Shannon Nelson <snelson@pensando.io>,
        Veaceslav Falico <vfalico@gmail.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: [PATCH net-next 0/4] Remove vermagic header from global include folder
Date:   Tue, 14 Apr 2020 18:57:28 +0300
Message-Id: <20200414155732.1236944-1-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

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
 kernel/module.c                                      | 2 +-
 {include/linux => kernel}/vermagic.h                 | 0
 net/ethtool/ioctl.c                                  | 3 +--
 14 files changed, 5 insertions(+), 25 deletions(-)
 rename {include/linux => kernel}/vermagic.h (100%)

--
2.25.2

