Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A09894EA3EC
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 02:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiC2ACB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 20:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiC2ACA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 20:02:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51ED512D;
        Mon, 28 Mar 2022 17:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1025B81135;
        Tue, 29 Mar 2022 00:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3B0C340ED;
        Tue, 29 Mar 2022 00:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648512015;
        bh=wCMbvr56VtoEx/Ol49u4LneQr9c9hrBl8R0OVViTao0=;
        h=From:To:Cc:Subject:Date:From;
        b=LnMp6jIMGfrZN1pIQk4fIJPhe7ZJn1YCkvNZkwJUNNYun+F00vG5mDe2fDgBN/9Qf
         ls5NBi4VOuMQlA9UVOysHFGWIXJ6e3BzpJyR4rajlrQ6wh+dRWiHrJpL0jktvcwVvB
         qF+9mbeYz2xX2yUYL2/D88UGHfC9jN+rzaDTG+gw705BwvjmZVVgOe8CsSGjmiwEIq
         Zr6P/RjHkD4Vh3dUMqo8vMdZqm0lrNHLNqY3infXEQyt6T5TsCrJ303lAdRQJdCCUb
         Mx79rdEHojemjFv8GYkNYzR0sLBzq4/VhhQQlQ8WjqQc5bmatSk/DJvEuE3zJ908Nm
         5UIAjI6rNk9OA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking mid-5.18-merge-window tactical update
Date:   Mon, 28 Mar 2022 17:00:14 -0700
Message-Id: <20220329000014.1509077-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Small batch of fixes so we can fast forward cleanly and
bring in the BPF x86 patches on Thursday.

The following changes since commit 169e77764adc041b1dacba84ea90516a895d43b2:

  Merge tag 'net-next-5.18' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2022-03-24 13:13:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc0

for you to fetch changes up to 20695e9a9fd39103d1b0669470ae74030b7aa196:

  Revert "selftests: net: Add tls config dependency for tls selftests" (2022-03-28 16:15:54 -0700)

----------------------------------------------------------------
Networking fixes, including fixes from netfilter.

Current release - regressions:

 - llc: only change llc->dev when bind() succeeds, fix null-deref

Current release - new code bugs:

 - smc: fix a memory leak in smc_sysctl_net_exit()

 - dsa: realtek: make interface drivers depend on OF

Previous releases - regressions:

 - sched: act_ct: fix ref leak when switching zones

Previous releases - always broken:

 - netfilter: egress: report interface as outgoing

 - vsock/virtio: enable VQs early on probe and finish the setup
   before using them

Misc:

 - memcg: enable accounting for nft objects

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alvin Šipraga (1):
      net: dsa: realtek: make interface drivers depend on OF

Bjorn Andersson (1):
      net: stmmac: dwmac-qcom-ethqos: Enable RGMII functional clock on resume

Casper Andersson (2):
      net: sparx5: Remove unused GLAG handling in PGID
      net: sparx5: Refactor mdb handling according to feedback

Damien Le Moal (1):
      net: bnxt_ptp: fix compilation error

David S. Miller (2):
      Merge branch 'hns3-fixes'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

Duoming Zhou (1):
      net/x25: Fix null-ptr-deref caused by x25_disconnect

Eric Dumazet (2):
      llc: only change llc->dev when bind() succeeds
      net/smc: fix a memory leak in smc_sysctl_net_exit()

Florian Fainelli (1):
      net: phy: broadcom: Fix brcm_fet_config_init()

Greg Jesionowski (1):
      net: usb: ax88179_178a: add Allied Telesis AT-UMCs

Guangbin Huang (1):
      net: hns3: fix phy can not link up when autoneg off and reset

Hao Chen (4):
      net: hns3: fix ethtool tx copybreak buf size indicating not aligned issue
      net: hns3: add max order judgement for tx spare buffer
      net: hns3: add netdev reset check for hns3_set_tunable()
      net: hns3: add NULL pointer check for hns3_set/get_ringparam()

Ido Schimmel (1):
      selftests: test_vxlan_under_vrf: Fix broken test case

Jakub Kicinski (5):
      Merge branch 'vsock-virtio-enable-vqs-early-on-probe-and-finish-the-setup-before-using-them'
      Merge branch 'net-sparx5-refactor-based-on-feedback-on'
      Merge branch 'net-hns3-add-some-fixes-for-net'
      selftests: tls: skip cmsg_to_pipe tests with TLS=n
      Revert "selftests: net: Add tls config dependency for tls selftests"

Jian Shen (4):
      net: hns3: fix bug when PF set the duplicate MAC address for VFs
      net: hns3: fix port base vlan add fail when concurrent with reset
      net: hns3: add vlan list lock to protect vlan list
      net: hns3: refine the process when PF set VF VLAN

Johannes Berg (1):
      net: move net_unlink_todo() out of the header

Marcelo Ricardo Leitner (1):
      net/sched: act_ct: fix ref leak when switching zones

Naresh Kamboju (1):
      selftests: net: Add tls config dependency for tls selftests

Pablo Neira Ayuso (1):
      netfilter: nf_conntrack_tcp: preserve liberal flag in tcp options

Peng Li (1):
      net: hns3: clean residual vf config after disable sriov

Phil Sutter (1):
      netfilter: egress: Report interface as outgoing

Randy Dunlap (1):
      net: sparx5: depends on PTP_1588_CLOCK_OPTIONAL

Stefano Garzarella (3):
      vsock/virtio: initialize vdev->priv before using VQs
      vsock/virtio: read the negotiated features before using VQs
      vsock/virtio: enable VQs early on probe

Tom Rix (2):
      qlcnic: dcb: default to returning -EOPNOTSUPP
      octeontx2-af: initialize action variable

Vasily Averin (1):
      memcg: enable accounting for nft objects

Vladimir Oltean (1):
      net: enetc: report software timestamping via SO_TIMESTAMPING

Wen Gu (1):
      net/smc: Send out the remaining data in sndbuf before close

Xiaomeng Tong (1):
      net: dsa: bcm_sf2_cfp: fix an incorrect NULL check on list iterator

Zheng Yongjun (1):
      net: sparx5: switchdev: fix possible NULL pointer dereference

 drivers/net/dsa/bcm_sf2_cfp.c                      |   6 +-
 drivers/net/dsa/realtek/Kconfig                    |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h      |   2 +-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |   5 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   3 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  44 +++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  23 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 173 +++++++++++++++++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   4 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   5 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  15 +-
 drivers/net/ethernet/microchip/sparx5/Kconfig      |   1 +
 .../net/ethernet/microchip/sparx5/sparx5_fdma.c    |   2 +
 .../ethernet/microchip/sparx5/sparx5_mactable.c    |  19 +--
 .../net/ethernet/microchip/sparx5/sparx5_main.h    |   7 +-
 .../net/ethernet/microchip/sparx5/sparx5_pgid.c    |  20 +--
 .../ethernet/microchip/sparx5/sparx5_switchdev.c   |  18 +--
 .../net/ethernet/microchip/sparx5/sparx5_vlan.c    |   7 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h    |  10 +-
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |   7 +
 drivers/net/phy/broadcom.c                         |  21 +++
 drivers/net/usb/ax88179_178a.c                     |  51 ++++++
 include/linux/netdevice.h                          |  10 --
 include/linux/netfilter_netdev.h                   |   2 +-
 net/core/dev.c                                     |  10 ++
 net/llc/af_llc.c                                   |  59 ++++---
 net/netfilter/core.c                               |   2 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  17 +-
 net/netfilter/nf_tables_api.c                      |  44 +++---
 net/sched/act_ct.c                                 |  15 +-
 net/smc/smc_close.c                                |   3 +
 net/smc/smc_sysctl.c                               |   5 +
 net/vmw_vsock/virtio_transport.c                   |  11 +-
 net/x25/af_x25.c                                   |  11 +-
 .../testing/selftests/net/test_vxlan_under_vrf.sh  |   8 +-
 tools/testing/selftests/net/tls.c                  |   6 +
 38 files changed, 464 insertions(+), 194 deletions(-)
