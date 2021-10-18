Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088074328C9
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbhJRVMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231938AbhJRVM3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:12:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93E3161002;
        Mon, 18 Oct 2021 21:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634591417;
        bh=XgMbrZiKMfPJsgN8mFe/YXKfH81rf/ghKvyT0oS9Fto=;
        h=From:To:Cc:Subject:Date:From;
        b=hsFdjpd0vQ1mPiiTSIjGWkVpyVJMAAyv4efJaTTE1V9N5EY7dhLTHMFfP8wR2wvgu
         zXwPMkxoR1midnoN0WOuE3WPHKQ8skUEG+hJb9BOtVJdr/XUHU56eZX/4OHcnvHhmX
         UUvIz/4TCbSzFxQRO56/W5+6Okoe0LoiiS7nynHEacbFQpqPFC2dJxyCssOyMckKbq
         2h9J/3oBPgxomvxUszRlXpUoDO3osVHQLD6eT7/Bk8pfT5lv6AH/D4WEGsQ1RLLY4I
         2fVxUnv8HKKZf+HS0a4v9YuJUGk98vjV7ee1oLJaBKxKaYwwHjFSvO1fyx8SlhnAjO
         6+4COjmU1g7Ag==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, f.fainelli@gmail.com, snelson@pensando.io,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/6] ethernet: add eth_hw_addr_gen() for switches
Date:   Mon, 18 Oct 2021 14:10:01 -0700
Message-Id: <20211018211007.1185777-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While doing the last polishing of the drivers/ethernet
changes I realized we have a handful of drivers offsetting
some base MAC addr by an id. So I decided to add a helper
for it. The helper takes care of wrapping which is probably
not 100% necessary but seems like a good idea. And it saves
driver side LoC (the diffstat is actually negative if we
compare against the changes I'd have to make if I was to
convert all these drivers to not operate directly on
netdev->dev_addr).

Jakub Kicinski (6):
  ethernet: add a helper for assigning port addresses
  ethernet: ocelot: use eth_hw_addr_gen()
  ethernet: prestera: use eth_hw_addr_gen()
  ethernet: fec: use eth_hw_addr_gen()
  ethernet: mlxsw: use eth_hw_addr_gen()
  ethernet: sparx5: use eth_hw_addr_gen()

 drivers/net/ethernet/freescale/fec_main.c     |  5 +----
 .../ethernet/marvell/prestera/prestera_main.c |  7 +++++--
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 10 +++------
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  8 +++----
 .../ethernet/microchip/sparx5/sparx5_netdev.c |  4 +---
 drivers/net/ethernet/mscc/ocelot_net.c        |  3 +--
 include/linux/etherdevice.h                   | 21 +++++++++++++++++++
 7 files changed, 36 insertions(+), 22 deletions(-)

-- 
2.31.1

