Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 434CD17EE66
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgCJCPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgCJCPQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 22:15:16 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FA0F2146E;
        Tue, 10 Mar 2020 02:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583806515;
        bh=N3yBSDZ/o1ck4t60+0YC262hFfEI4UT11s+hWLOKxcs=;
        h=From:To:Cc:Subject:Date:From;
        b=Gu5k3mc2OShgMTnpD73TjAIu9GgPALkxw7hPxI6vUGAkMGMfRdnqV4Im/t/mn/s5G
         SliCsJnXMdYs8UzyEVdXCqFl/pYbt5weQTPNoC2gdkgPwVnv0spT52FaaS0gM+ynkH
         Kp/57WNqLzjlpxhCLlMXG920vGFsZKgog7ZSkKQY=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, akiyano@amazon.com, netanel@amazon.com,
        gtzalik@amazon.com, irusskikh@marvell.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, rmody@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, aelior@marvell.com,
        skalluru@marvell.com, GR-everest-linux-l2@marvell.com,
        opendmb@gmail.com, siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, tariqt@mellanox.com, vishal@chelsio.com,
        leedom@chelsio.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/15] ethtool: consolidate irq coalescing - part 3
Date:   Mon,  9 Mar 2020 19:14:57 -0700
Message-Id: <20200310021512.1861626-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Convert more drivers following the groundwork laid in a recent
patch set [1] and continued in [2]. The aim of the effort is to
consolidate irq coalescing parameter validation in the core.

This set converts 15 drivers in drivers/net/ethernet.
3 more conversion sets to come.

None of the drivers here checked all unsupported parameters.

[1] https://lore.kernel.org/netdev/20200305051542.991898-1-kuba@kernel.org/
[2] https://lore.kernel.org/netdev/20200306010602.1620354-1-kuba@kernel.org/

Jakub Kicinski (15):
  net: ena: reject unsupported coalescing params
  net: aquantia: reject all unsupported coalescing params
  net: systemport: reject unsupported coalescing params
  net: bnx2: reject unsupported coalescing params
  net: bnx2x: reject unsupported coalescing params
  net: bcmgenet: reject unsupported coalescing params
  net: tg3: reject unsupported coalescing params
  net: bna: reject unsupported coalescing params
  net: liquidio: reject unsupported coalescing params
  net: mlx4: reject unsupported coalescing params
  net: cxgb2: reject unsupported coalescing params
  net: cxgb3: reject unsupported coalescing params
  net: cxgb4: reject unsupported coalescing params
  net: cxgb4vf: reject unsupported coalescing params
  net: gemini: reject unsupported coalescing params

 drivers/net/ethernet/amazon/ena/ena_ethtool.c     |  2 ++
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c   | 15 +++------------
 drivers/net/ethernet/broadcom/bcmsysport.c        |  6 ++++--
 drivers/net/ethernet/broadcom/bnx2.c              |  5 +++++
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c   |  1 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c    |  7 +++----
 drivers/net/ethernet/broadcom/tg3.c               |  5 +++++
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c   |  3 +++
 .../net/ethernet/cavium/liquidio/lio_ethtool.c    | 11 +++++++++++
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c         |  3 +++
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  1 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |  4 ++++
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  2 ++
 drivers/net/ethernet/cortina/gemini.c             |  2 ++
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c   |  4 ++++
 include/linux/ethtool.h                           |  5 +++++
 16 files changed, 58 insertions(+), 18 deletions(-)

-- 
2.24.1

