Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0EFB183FFC
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 05:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgCMEIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 00:08:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgCMEIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 00:08:05 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0766C2072F;
        Fri, 13 Mar 2020 04:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584072484;
        bh=bL1y9BIELU1NMREv907uC6LDA24geoNiUSXSe3EIdRs=;
        h=From:To:Cc:Subject:Date:From;
        b=D356m9fMfjVg+gvx9Vo4Nk6qSY7+kgcnaQkclBBKjwRyg3ltw8tMGj/hd1CyeLDNe
         777ni4VoNQnN3FjxtNFjwQwyKJ0ejCQCLUM/zW8nocXuC7kWnDoiP0y54+EGAwkAUe
         jWo+jfMYrrleig/+GfhAAarRmfOcJwUsMMXKpCb8=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        cooldavid@cooldavid.org, sebastian.hesselbarth@gmail.com,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        rmk+kernel@armlinux.org.uk, mcroce@redhat.com,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, mlindner@marvell.com,
        stephen@networkplumber.org, christopher.lee@cspi.com,
        manishc@marvell.com, rahulv@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, shshaikh@marvell.com,
        nic_swsd@realtek.com, hkallweit1@gmail.com, bh74.an@samsung.com,
        romieu@fr.zoreil.com
Subject: [PATCH net-next 00/15] ethtool: consolidate irq coalescing - part 5
Date:   Thu, 12 Mar 2020 21:07:48 -0700
Message-Id: <20200313040803.2367590-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Convert more drivers following the groundwork laid in a recent
patch set [1] and continued in [2], [3], [4]. The aim of the effort
is to consolidate irq coalescing parameter validation in the core.

This set converts further 15 drivers in drivers/net/ethernet.
One more conversion sets to come.

[1] https://lore.kernel.org/netdev/20200305051542.991898-1-kuba@kernel.org/
[2] https://lore.kernel.org/netdev/20200306010602.1620354-1-kuba@kernel.org/
[3] https://lore.kernel.org/netdev/20200310021512.1861626-1-kuba@kernel.org/
[4] https://lore.kernel.org/netdev/20200311223302.2171564-1-kuba@kernel.org/

Jakub Kicinski (15):
  net: jme: reject unsupported coalescing params
  net: mv643xx_eth: reject unsupported coalescing params
  net: mvneta: reject unsupported coalescing params
  net: mvpp2: reject unsupported coalescing params
  net: octeontx2-pf: let core reject the unsupported coalescing
    parameters
  net: skge: reject unsupported coalescing params
  net: sky2: reject unsupported coalescing params
  net: myri10ge: reject unsupported coalescing params
  net: nixge: let core reject the unsupported coalescing parameters
  net: netxen: let core reject the unsupported coalescing parameters
  net: qede: reject unsupported coalescing params
  net: qlnic: let core reject the unsupported coalescing parameters
  net: r8169: reject unsupported coalescing params
  net: sxgbe: reject unsupported coalescing params
  net: via: reject unsupported coalescing params

 drivers/net/ethernet/jme.c                    |  3 +++
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  1 +
 drivers/net/ethernet/marvell/mvneta.c         |  2 ++
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  2 ++
 .../marvell/octeontx2/nic/otx2_ethtool.c      | 13 ++---------
 drivers/net/ethernet/marvell/skge.c           |  1 +
 drivers/net/ethernet/marvell/sky2.c           |  4 ++++
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  1 +
 drivers/net/ethernet/ni/nixge.c               | 22 +-----------------
 .../qlogic/netxen/netxen_nic_ethtool.c        | 21 +++--------------
 .../net/ethernet/qlogic/qede/qede_ethtool.c   |  2 ++
 .../ethernet/qlogic/qlcnic/qlcnic_ethtool.c   | 23 ++++---------------
 drivers/net/ethernet/realtek/r8169_main.c     |  2 ++
 .../ethernet/samsung/sxgbe/sxgbe_ethtool.c    |  1 +
 drivers/net/ethernet/via/via-velocity.c       |  2 ++
 15 files changed, 32 insertions(+), 68 deletions(-)

-- 
2.24.1

