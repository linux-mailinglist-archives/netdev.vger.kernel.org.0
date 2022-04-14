Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03B2500B0F
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 12:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235379AbiDNK3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 06:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241808AbiDNK3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 06:29:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0598075E59
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 03:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649932016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UHu8ZJVAgbaLDrvw/QoVq58ruVxz5F5ebHCeJtNRZsU=;
        b=GULlW23pO2WfjwCHErTHHMQEQjJgvvyMeUSP5jZwOeTBKtmb93JFxAl5POwihA1XlRprBi
        vI+TbR9TaCsuAGxJfxXffxY39ZLkF96Hnye7BPZfiiU9KJNIPIsUH1xMEUaVBAU5l+Ypoj
        TvZf5eSOjvPEYruL2ISrrIwZkKoZ3+c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-ZjQ15E76NN-b_agaB0Fs7A-1; Thu, 14 Apr 2022 06:26:53 -0400
X-MC-Unique: ZjQ15E76NN-b_agaB0Fs7A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DDE2800B21;
        Thu, 14 Apr 2022 10:26:52 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7179FC28119;
        Thu, 14 Apr 2022 10:26:51 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.18-rc3
Date:   Thu, 14 Apr 2022 12:26:41 +0200
Message-Id: <20220414102641.19082-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 73b193f265096080eac866b9a852627b475384fc:

  Merge tag 'net-5.18-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-04-07 19:01:47 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc3

for you to fetch changes up to 2df3fc4a84e917a422935cc5bae18f43f9955d31:

  net: bcmgenet: Revert "Use stronger register read/writes to assure ordering" (2022-04-14 09:13:07 +0200)

----------------------------------------------------------------
Networking fixes for 5.18-rc3, including fixes from wireless and
netfilter.

Current release - regressions:

  - smc: fix af_ops of child socket pointing to released memory

  - wifi: ath9k: fix usage of driver-private space in tx_info

Previous releases - regressions:

  - ipv6: fix panic when forwarding a pkt with no in6 dev

  - sctp: use the correct skb for security_sctp_assoc_request

  - smc: fix NULL pointer dereference in smc_pnet_find_ib()

  - sched: fix initialization order when updating chain 0 head

  - phy: don't defer probe forever if PHY IRQ provider is missing

  - dsa: revert "net: dsa: setup master before ports"

  - dsa: felix: fix tagging protocol changes with multiple CPU ports

  - eth: ice:
    - fix use-after-free when freeing @rx_cpu_rmap
    - revert "iavf: fix deadlock occurrence during resetting VF interface"

  - eth: lan966x: stop processing the MAC entry is port is wrong

Previous releases - always broken:

  - sched
    - flower: fix parsing of ethertype following VLAN header
    - taprio: check if socket flags are valid

  - nfc: add flush_workqueue to prevent uaf

  - veth: ensure eth header is in skb's linear part

  - eth: stmmac: fix altr_tse_pcs function when using a fixed-link

  - eth: macb: restart tx only if queue pointer is lagging

  - eth: macvlan: fix leaking skb in source mode with nodst option

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Alexander Lobakin (1):
      ice: arfs: fix use-after-free when freeing @rx_cpu_rmap

Alvin Šipraga (2):
      net: dsa: realtek: fix Kconfig to assure consistent driver linkage
      net: dsa: realtek: don't parse compatible string for RTL8366S

Anilkumar Kolli (1):
      Revert "ath11k: mesh: add support for 256 bitmap in blockack frames in 11ax"

Antoine Tenart (2):
      netfilter: nf_tables: nft_parse_register can return a negative value
      tun: annotate access to queue->trans_start

Arun Ramadoss (1):
      net: phy: LAN87xx: remove genphy_softreset in config_aneg

Ben Greear (1):
      mac80211: fix ht_capa printout in debugfs

Benedikt Spranger (1):
      net/sched: taprio: Check if socket flags are valid

Borislav Petkov (2):
      mt76: Fix undefined behavior due to shift overflowing the constant
      brcmfmac: sdio: Fix undefined behavior due to shift overflowing the constant

David S. Miller (1):
      Merge tag 'wireless-2022-04-13' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless

Dinh Nguyen (1):
      net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link

Dylan Hung (1):
      net: ftgmac100: access hardware register after clock ready

Florian Westphal (1):
      netfilter: nft_socket: make cgroup match work in input too

Gal Pressman (1):
      bonding: Update layer2 and layer2+3 hash formula documentation

Guillaume Nault (1):
      veth: Ensure eth header is in skb's linear part

Hongbin Wang (1):
      vxlan: fix error return code in vxlan_fdb_append

Horatiu Vultur (4):
      net: lan966x: Update lan966x_ptp_get_nominal_value
      net: lan966x: Fix IGMP snooping when frames have vlan tag
      net: lan966x: Fix when a port's upper is changed.
      net: lan966x: Stop processing the MAC entry is port is wrong.

Jakub Kicinski (5):
      flow_dissector: fix false-positive __read_overflow2_field() warning
      Merge branch 'net-smc-fixes-2022-04-08'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'net-lan966x-lan966x-fixes'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

Jeremy Linton (1):
      net: bcmgenet: Revert "Use stronger register read/writes to assure ordering"

Johannes Berg (2):
      MAINTAINERS: claim include/uapi/linux/wireless.h
      nl80211: correctly check NL80211_ATTR_REG_ALPHA2 size

Kai-Heng Feng (1):
      net: atlantic: Avoid out-of-bounds indexing

Kalle Valo (1):
      MAINTAINERS: mark wil6210 as orphan

Karsten Graul (3):
      net/smc: use memcpy instead of snprintf to avoid out of bounds read
      net/smc: Fix NULL pointer dereference in smc_pnet_find_ib()
      net/smc: Fix af_ops of child socket pointing to released memory

Kunihiko Hayashi (2):
      dt-bindings: net: ave: Clean up clocks, resets, and their names using compatible string
      dt-bindings: net: ave: Use unevaluatedProperties

Lin Ma (1):
      nfc: nci: add flush_workqueue to prevent uaf

Lorenzo Bianconi (1):
      MAINTAINERS: update Lorenzo's email address

Lv Ruyi (1):
      dpaa_eth: Fix missing of_node_put in dpaa_get_ts_info()

Marcelo Ricardo Leitner (1):
      net/sched: fix initialization order when updating chain 0 head

Martin Willi (1):
      macvlan: Fix leaking skb in source mode with nodst option

Mateusz Palczewski (1):
      Revert "iavf: Fix deadlock occurrence during resetting VF interface"

Michael Walle (1):
      net: dsa: felix: suppress -EPROBE_DEFER errors

Nicolas Dichtel (1):
      ipv6: fix panic when forwarding a pkt with no in6 dev

Petr Machata (1):
      rtnetlink: Fix handling of disabled L3 stats in RTM_GETSTATS replies

Petr Malat (1):
      sctp: Initialize daddr on peeled off socket

Rameshkumar Sundaram (1):
      cfg80211: hold bss_lock while updating nontrans_list

Toke Høiland-Jørgensen (2):
      ath9k: Properly clear TX status area before reporting to mac80211
      ath9k: Fix usage of driver-private space in tx_info

Tomas Melin (1):
      net: macb: Restart tx only if queue pointer is lagging

Vadim Pasternak (1):
      mlxsw: i2c: Fix initialization error flow

Vlad Buslov (1):
      net/sched: flower: fix parsing of ethertype following VLAN header

Vladimir Oltean (3):
      net: mdio: don't defer probe forever if PHY IRQ provider is missing
      Revert "net: dsa: setup master before ports"
      net: dsa: felix: fix tagging protocol changes with multiple CPU ports

Xin Long (1):
      sctp: use the correct skb for security_sctp_assoc_request

 .../bindings/net/socionext,uniphier-ave4.yaml      | 57 +++++++++++++++-------
 Documentation/networking/bonding.rst               |  4 +-
 MAINTAINERS                                        |  7 ++-
 drivers/base/dd.c                                  |  1 +
 drivers/net/dsa/ocelot/felix.c                     | 23 +++++++++
 drivers/net/dsa/ocelot/felix_vsc9959.c             |  2 +-
 drivers/net/dsa/realtek/Kconfig                    | 30 ++++++++----
 drivers/net/dsa/realtek/realtek-smi.c              |  5 --
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |  8 +--
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    | 24 ++++-----
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  4 +-
 drivers/net/ethernet/cadence/macb_main.c           |  8 +++
 drivers/net/ethernet/faraday/ftgmac100.c           | 10 ++--
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |  8 ++-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  7 +--
 drivers/net/ethernet/intel/ice/ice_arfs.c          |  9 +---
 drivers/net/ethernet/intel/ice/ice_lib.c           |  5 +-
 drivers/net/ethernet/intel/ice/ice_main.c          | 18 +++----
 drivers/net/ethernet/mellanox/mlxsw/i2c.c          |  1 +
 .../net/ethernet/microchip/lan966x/lan966x_mac.c   |  6 ++-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |  6 +++
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |  8 +--
 .../ethernet/microchip/lan966x/lan966x_switchdev.c |  3 +-
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c |  8 ---
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h |  4 ++
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    | 13 ++---
 drivers/net/macvlan.c                              |  8 ++-
 drivers/net/mdio/fwnode_mdio.c                     |  5 ++
 drivers/net/phy/microchip_t1.c                     |  7 +--
 drivers/net/tun.c                                  |  2 +-
 drivers/net/veth.c                                 |  2 +-
 drivers/net/vxlan/vxlan_core.c                     |  4 +-
 drivers/net/wireless/ath/ath11k/mac.c              | 22 ++++++---
 drivers/net/wireless/ath/ath9k/main.c              |  2 +-
 drivers/net/wireless/ath/ath9k/xmit.c              | 33 ++++++++-----
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |  2 +-
 include/net/flow_dissector.h                       |  2 +
 net/core/flow_dissector.c                          |  3 +-
 net/core/rtnetlink.c                               |  3 ++
 net/dsa/dsa2.c                                     | 23 ++++-----
 net/ipv6/ip6_output.c                              |  2 +-
 net/mac80211/debugfs_sta.c                         |  2 +-
 net/netfilter/nf_tables_api.c                      |  2 +-
 net/netfilter/nft_socket.c                         |  7 ++-
 net/nfc/nci/core.c                                 |  4 ++
 net/sched/cls_api.c                                |  2 +-
 net/sched/cls_flower.c                             | 18 +++++--
 net/sched/sch_taprio.c                             |  3 +-
 net/sctp/sm_statefuns.c                            |  6 +--
 net/sctp/socket.c                                  |  2 +-
 net/smc/af_smc.c                                   | 14 +++++-
 net/smc/smc_clc.c                                  |  6 ++-
 net/smc/smc_pnet.c                                 |  5 +-
 net/wireless/nl80211.c                             |  3 +-
 net/wireless/scan.c                                |  2 +
 56 files changed, 292 insertions(+), 185 deletions(-)

