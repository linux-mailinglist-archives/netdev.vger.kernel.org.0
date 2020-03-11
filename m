Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 927621824EC
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbgCKWdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729799AbgCKWdK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:33:10 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98AFA20739;
        Wed, 11 Mar 2020 22:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583965990;
        bh=FuUkCquS4t6XrBlpoBFCfOoz7fzFNICKUH8nqVH4pdo=;
        h=From:To:Cc:Subject:Date:From;
        b=rQMo0a4nNVwrAaaPbo0KtSchbprRVmhLDiGWtB1U8M+9vEoPu/WaBsKmkw+ztbUmK
         bb080VYc9WNgjuhDy55sF3QDHgBlwIQjy3m/6HxHGhpEBCj7qOMQ14tGUyUXZgDoFo
         VFtNwQdFjkSrAVLDkVXnfP1HlI8nGe1bH1w0idHM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        madalin.bucur@nxp.com, fugang.duan@nxp.com, claudiu.manoil@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/15] ethtool: consolidate irq coalescing - part 4
Date:   Wed, 11 Mar 2020 15:32:47 -0700
Message-Id: <20200311223302.2171564-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Convert more drivers following the groundwork laid in a recent
patch set [1] and continued in [2], [3]. The aim of the effort
is to consolidate irq coalescing parameter validation in the core.

This set converts 15 drivers in drivers/net/ethernet - remaining
Intel drivers, Freescale/NXP, and others.
2 more conversion sets to come.

[1] https://lore.kernel.org/netdev/20200305051542.991898-1-kuba@kernel.org/
[2] https://lore.kernel.org/netdev/20200306010602.1620354-1-kuba@kernel.org/
[3] https://lore.kernel.org/netdev/20200310021512.1861626-1-kuba@kernel.org/

Jakub Kicinski (15):
  net: be2net: reject unsupported coalescing params
  net: dpaa: reject unsupported coalescing params
  net: fec: reject unsupported coalescing params
  net: gianfar: reject unsupported coalescing params
  net: hns: reject unsupported coalescing params
  net: hns3: reject unsupported coalescing params
  net: e1000: reject unsupported coalescing params
  net: fm10k: reject unsupported coalescing params
  net: i40e: reject unsupported coalescing params
  net: iavf: reject unsupported coalescing params
  net: igb: let core reject the unsupported coalescing parameters
  net: igbvf: reject unsupported coalescing params
  net: igc: let core reject the unsupported coalescing parameters
  net: ixgbe: reject unsupported coalescing params
  net: ixgbevf: reject unsupported coalescing params

 .../net/ethernet/emulex/benet/be_ethtool.c    |  3 +++
 .../ethernet/freescale/dpaa/dpaa_ethtool.c    |  6 ++---
 drivers/net/ethernet/freescale/fec_main.c     |  2 ++
 .../net/ethernet/freescale/gianfar_ethtool.c  |  2 ++
 .../net/ethernet/hisilicon/hns/hns_ethtool.c  |  5 +++++
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  7 ++++++
 .../net/ethernet/intel/e1000/e1000_ethtool.c  |  1 +
 .../net/ethernet/intel/fm10k/fm10k_ethtool.c  |  2 ++
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  5 +++++
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  4 ++++
 drivers/net/ethernet/intel/igb/igb_ethtool.c  | 22 +------------------
 drivers/net/ethernet/intel/igbvf/ethtool.c    |  1 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c  | 22 +------------------
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  1 +
 drivers/net/ethernet/intel/ixgbevf/ethtool.c  |  1 +
 include/linux/ethtool.h                       |  8 +++++++
 16 files changed, 46 insertions(+), 46 deletions(-)

-- 
2.24.1

