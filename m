Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7D942FC43
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 21:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238455AbhJOTlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 15:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235167AbhJOTlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 15:41:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6138C60FE3;
        Fri, 15 Oct 2021 19:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634326735;
        bh=6GkaAOBvppfuVq8yyfvpw6yQd2cz9jy0RiwvFu2c1eE=;
        h=From:To:Cc:Subject:Date:From;
        b=T1xKshqtrRKoAahpXbxm0LF5KIsQ4w7efVmgLHpfMGa4f9BRPDf7iA0nwFk5uzdaQ
         jHnOHjCnHj18A8Jp8jZKTlWAfmket2vojFhZxIlsOoC1nx1FuHwbiy3tnNBUz39MzI
         qstc5KwLxkGPMDPu04BLef0Rw24BDPrsGYDBvg+vrBtEedZymbRPMaUQ3j42qdZ4Ib
         rAfPPHBsPxBzkYCefc9MrbDXwC4AqsPxfaj6RBX5lbYfwxXV5rr0rGL9QNUwqu5qNd
         rdWAEyeJKsopEjGwHPk9Nt8ujg9mcSl/WAj3MTUj12MmRaJSrh46Bm5CyW8AcPYi5D
         wEi2hk3NgaKrg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, idosch@idosch.org,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 0/6] ethernet: add eth_hw_addr_set_port()
Date:   Fri, 15 Oct 2021 12:38:42 -0700
Message-Id: <20211015193848.779420-1-kuba@kernel.org>
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

Sending as RFC, because feedback welcome.. and it may
be weekend for Ido.

Jakub Kicinski (6):
  ethernet: add a helper for assigning port addresses
  ethernet: ocelot: use eth_hw_addr_set_port()
  ethernet: prestera: use eth_hw_addr_set_port()
  ethernet: fec: use eth_hw_addr_set_port()
  ethernet: mlxsw: use eth_hw_addr_set_port()
  ethernet: sparx5: use eth_hw_addr_set_port()

 drivers/net/ethernet/freescale/fec_main.c     |  5 +----
 .../ethernet/marvell/prestera/prestera_main.c |  5 +++--
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  9 +++-----
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  8 +++----
 .../ethernet/microchip/sparx5/sparx5_netdev.c |  4 +---
 drivers/net/ethernet/mscc/ocelot_net.c        |  3 +--
 include/linux/etherdevice.h                   | 21 +++++++++++++++++++
 7 files changed, 34 insertions(+), 21 deletions(-)

-- 
2.31.1

