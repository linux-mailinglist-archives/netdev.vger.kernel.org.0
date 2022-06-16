Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA6D54E979
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 20:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244949AbiFPShH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 14:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiFPShG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 14:37:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE54053E0E;
        Thu, 16 Jun 2022 11:37:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F498B825A0;
        Thu, 16 Jun 2022 18:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E458C34114;
        Thu, 16 Jun 2022 18:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655404620;
        bh=PlAp1kX5OSiithpNRD7n96YjUT6MZIMuBIHY7Bctwhg=;
        h=From:To:Cc:Subject:Date:From;
        b=kM8ukHxuotZp5DsJJmG+O5ivYrr3wIwZF+DLXKpIGd9XnKBLVIBn7H2B7AKF2k1MP
         WpTWGVW65Ovu9WGWBqxb7O8lBLU1VooqqA4cIRweI8AR5T32fXx0ugUJRia8zqOXtg
         60eMYo0fay1MJqM8elZdhHuTCIF9Is/PeirYHb6xrs5IALeXCmnF0A74ySu7QXnvps
         8dlY8UYwZrfxh3CxEwSdYakDtvrdgK02WznWTioPRY7if3cxxMymbZY/vbZ4sIHzfG
         muvwdFFJN2Y8w9PLKxx2sedZktnwBPYGYJZVbbesk+2JXiFIvYNTvCIq8EUzzEhhPk
         54JBrRkPd/xnA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.19-rc3
Date:   Thu, 16 Jun 2022 11:36:59 -0700
Message-Id: <20220616183659.3471896-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit aa3398fb4b3f67d89688976098ad93721b6d7852:

  Merge tag 'devicetree-fixes-for-5.19-2' of git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux (2022-06-10 11:57:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc3

for you to fetch changes up to 2e7bf4a6af482f73f01245f08b4a953412c77070:

  net: axienet: add missing error return code in axienet_probe() (2022-06-16 11:08:38 -0700)

----------------------------------------------------------------
Mostly driver fixes.

Current release - regressions:

 - Revert "net: Add a second bind table hashed by port and address",
   needs more work

 - amd-xgbe: use platform_irq_count(), static setup of IRQ resources
   had been removed from DT core

 - dts: at91: ksz9477_evb: add phy-mode to fix port/phy validation

Current release - new code bugs:

 - hns3: modify the ring param print info

Previous releases - always broken:

 - axienet: make the 64b addressable DMA depends on 64b architectures

 - iavf: fix issue with MAC address of VF shown as zero

 - ice: fix PTP TX timestamp offset calculation

 - usb: ax88179_178a needs FLAG_SEND_ZLP

Misc:

 - document some net.sctp.* sysctls

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aleksandr Loktionov (1):
      i40e: Fix call trace in setup_tx_descriptors

Andy Chiu (2):
      net: axienet: make the 64b addresable DMA depends on 64b archectures
      net: axienet: Use iowrite64 to write all 64b descriptor pointers

Christophe JAILLET (1):
      net: bgmac: Fix an erroneous kfree() in bgmac_remove()

David S. Miller (4):
      Merge branch 'hns3-fixres'
      Merge branch 'axienet-fixes'
      xilinx:  Fix build on x86.
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Duoming Zhou (1):
      net: ax25: Fix deadlock caused by skb_recv_datagram in ax25_recvmsg

Grzegorz Szczurek (2):
      i40e: Fix adding ADQ filter to TC0
      i40e: Fix calculating the number of queue pairs

Guangbin Huang (3):
      net: hns3: set port base vlan tbl_sta to false before removing old vlan
      net: hns3: restore tm priority/qset to default settings when tc disabled
      net: hns3: fix tm port shapping of fibre port is incorrect after driver initialization

Jakub Kicinski (2):
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'documentation-add-description-for-a-couple-of-sctp-sysctl-options'

Jean-Philippe Brucker (1):
      amd-xgbe: Use platform_irq_count()

Jian Shen (1):
      net: hns3: don't push link state to VF if unalive

Jie Wang (2):
      net: hns3: modify the ring param print info
      net: hns3: fix PF rss size initialization bug

Joanne Koong (1):
      Revert "net: Add a second bind table hashed by port and address"

Jonathan Neuschäfer (1):
      docs: networking: phy: Fix a typo

Jose Alonso (1):
      net: usb: ax88179_178a needs FLAG_SEND_ZLP

Lukas Bulwahn (1):
      MAINTAINERS: add include/dt-bindings/net to NETWORKING DRIVERS

Michal Michalik (1):
      ice: Fix PTP TX timestamp offset calculation

Michal Wilczynski (1):
      iavf: Fix issue with MAC address of VF shown as zero

Oleksij Rempel (1):
      ARM: dts: at91: ksz9477_evb: fix port/phy validation

Petr Machata (1):
      mlxsw: spectrum_cnt: Reorder counter pools

Przemyslaw Patynowski (2):
      ice: Fix queue config fail handling
      ice: Fix memory corruption in VF driver

Roman Storozhenko (1):
      ice: Sync VLAN filtering features for DVM

Suman Ghosh (1):
      octeontx2-vf: Add support for adaptive interrupt coalescing

Xin Long (3):
      Documentation: add description for net.sctp.reconf_enable
      Documentation: add description for net.sctp.intl_enable
      Documentation: add description for net.sctp.ecn_enable

Yang Yingliang (1):
      net: axienet: add missing error return code in axienet_probe()

 Documentation/networking/ip-sysctl.rst             |  37 +++
 Documentation/networking/phy.rst                   |   2 +-
 MAINTAINERS                                        |   1 +
 arch/arm/boot/dts/at91-sama5d3_ksz9477_evb.dts     |   5 +
 drivers/net/ethernet/amd/xgbe/xgbe-platform.c      |   4 +-
 drivers/net/ethernet/broadcom/bgmac-bcma.c         |   1 -
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  18 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 101 ++++++---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |   1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  25 ++-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   5 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  49 ++--
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   2 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h           |  31 +++
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |   5 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |  53 +++--
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h |   2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |  51 +++++
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  29 +--
 drivers/net/usb/ax88179_178a.c                     |  26 +--
 include/net/inet_connection_sock.h                 |   3 -
 include/net/inet_hashtables.h                      |  68 +-----
 include/net/sock.h                                 |  14 --
 net/ax25/af_ax25.c                                 |  33 ++-
 net/dccp/proto.c                                   |  33 +--
 net/ipv4/inet_connection_sock.c                    | 247 ++++++---------------
 net/ipv4/inet_hashtables.c                         | 193 +---------------
 net/ipv4/tcp.c                                     |  14 +-
 tools/testing/selftests/net/.gitignore             |   1 -
 tools/testing/selftests/net/Makefile               |   2 -
 tools/testing/selftests/net/bind_bhash_test.c      | 119 ----------
 36 files changed, 433 insertions(+), 752 deletions(-)
 delete mode 100644 tools/testing/selftests/net/bind_bhash_test.c
