Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82135A939A
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 11:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbiIAJvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 05:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiIAJvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 05:51:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3345D130A03
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 02:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662025894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=EIkJHhI6YlCNCZPXjc8HcVZcToMwd0NwhxwtNf/mpro=;
        b=NK0EQh7aT2wkE/omhatK4TrNGJr7keS+bLzDE2RSz3pT/JDMhu5c8dUdMEBCqbpBG8Syq9
        NnHXjlobe1Y+JiKJswtElwQOizUY92Vqkck53TWGIFMpS0f0H0x7uX3PaQkHJl19HGORgE
        QoisrqyifNfj/hqUKgbVvw8KCvT6MBg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-0ej8tHy9OPiIkqsnXBR8GQ-1; Thu, 01 Sep 2022 05:51:33 -0400
X-MC-Unique: 0ej8tHy9OPiIkqsnXBR8GQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC0251C01B31;
        Thu,  1 Sep 2022 09:51:32 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC52B2166B26;
        Thu,  1 Sep 2022 09:51:31 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.0-rc4
Date:   Thu,  1 Sep 2022 11:50:47 +0200
Message-Id: <20220901095047.19518-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 4c612826bec1441214816827979b62f84a097e91:

  Merge tag 'net-6.0-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-08-25 14:03:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc4

for you to fetch changes up to a8424a9b4522a3ab9f32175ad6d848739079071f:

  net/smc: Remove redundant refcount increase (2022-09-01 10:04:45 +0200)

----------------------------------------------------------------
Networking fixes for 6.0-rc4, including fixes from bluetooth, bpf
and wireless.

Current release - regressions:
  - bpf:
    - fix wrong last sg check in sk_msg_recvmsg()
    - fix kernel BUG in purge_effective_progs()

  - mac80211:
    - fix possible leak in ieee80211_tx_control_port()
    - potential NULL dereference in ieee80211_tx_control_port()

Current release - new code bugs:
  - nfp: fix the access to management firmware hanging

Previous releases - regressions:
  - ip: fix triggering of 'icmp redirect'

  - sched: tbf: don't call qdisc_put() while holding tree lock

  - bpf: fix corrupted packets for XDP_SHARED_UMEM

  - bluetooth: hci_sync: fix suspend performance regression

  - micrel: fix probe failure

Previous releases - always broken:
  - tcp: make global challenge ack rate limitation per net-ns and default disabled

  - tg3: fix potential hang-up on system reboot

  - mac802154: fix reception for no-daddr packets

Misc:
  - r8152: add PID for the lenovo onelink+ dock

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'Fix incorrect pruning for ARG_CONST_ALLOC_SIZE_OR_ZERO'

Alvaro Karsz (1):
      net: virtio_net: fix notification coalescing comments

Andrey Zhadchenko (1):
      openvswitch: fix memory leak at failed datapath creation

Archie Pusaka (1):
      Bluetooth: hci_event: Fix checking conn for le_conn_complete_evt

Axel Rasmussen (1):
      selftests: net: sort .gitignore file

Casper Andersson (1):
      net: sparx5: fix handling uneven length packets in manual extraction

Cong Wang (1):
      kcm: fix strp_init() order and cleanup

Dan Carpenter (3):
      wifi: cfg80211: debugfs: fix return type in ht40allow_map_read()
      wifi: mac80211: potential NULL dereference in ieee80211_tx_control_port()
      net: lan966x: improve error handle in lan966x_fdma_rx_get_frame()

Daniel Borkmann (2):
      bpf: Partially revert flexible-array member replacement
      bpf: Don't use tnum_range on array range checking for poke descriptors

Daniel Müller (1):
      selftests/bpf: Add lru_bug to s390x deny list

David S. Miller (3):
      Merge tag 'wireless-2022-08-26' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'u64_stats-fixups'

David Thompson (1):
      mlxbf_gige: compute MDIO period based on i1clk

Duoming Zhou (1):
      ethernet: rocker: fix sleep in atomic context bug in neigh_timer_handler

Eric Dumazet (2):
      tcp: annotate data-race around challenge_timestamp
      tcp: make global challenge ack rate limitation per net-ns and default disabled

Eyal Birger (1):
      ip_tunnel: Respect tunnel key's "flow_flags" in IP tunnels

Florian Fainelli (1):
      net: smsc911x: Stop and start PHY during suspend and resume

Gao Xiao (1):
      nfp: fix the access to management firmware hanging

Hans de Goede (1):
      Bluetooth: hci_event: Fix vendor (unknown) opcode status handling

Horatiu Vultur (1):
      net: phy: micrel: Make the GPIO to be non-exclusive

Jakub Kicinski (4):
      Merge tag 'for-net-2022-08-25' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge tag 'ieee802154-for-net-2022-08-29' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan
      Merge branch 'tcp-tcp-challenge-ack-fixes'
      Revert "sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb"

Jean-Francois Le Fillatre (1):
      r8152: add PID for the Lenovo OneLink+ Dock

Jilin Yuan (1):
      net/ieee802154: fix repeated words in comments

Kai-Heng Feng (1):
      tg3: Disable tg3 device on system reboot to avoid triggering AER

Kumar Kartikeya Dwivedi (2):
      bpf: Do mark_chain_precision for ARG_CONST_ALLOC_SIZE_OR_ZERO
      selftests/bpf: Add regression test for pruning fix

Kuniyuki Iwashima (1):
      bpf: Fix a data-race around bpf_jit_limit.

Kurt Kanzenbach (1):
      net: dsa: hellcreek: Print warning only once

Li Qiong (1):
      ieee802154: cc2520: add rc code in cc2520_tx()

Lin Ma (1):
      ieee802154/adf7242: defer destroy_workqueue call

Liu Jian (1):
      skmsg: Fix wrong last sg check in sk_msg_recvmsg()

Lorenzo Bianconi (1):
      wifi: mac80211: always free sta in __sta_info_alloc in case of error

Luiz Augusto von Dentz (4):
      Bluetooth: hci_sync: Fix suspend performance regression
      Bluetooth: L2CAP: Fix build errors in some archs
      Bluetooth: MGMT: Fix Get Device Flags
      Bluetooth: ISO: Fix not handling shutdown condition

Magnus Karlsson (1):
      xsk: Fix corrupted packets for XDP_SHARED_UMEM

Miquel Raynal (1):
      net: mac802154: Fix a condition in the receive path

Nicolas Dichtel (1):
      ip: fix triggering of 'icmp redirect'

Pu Lehui (1):
      bpf, cgroup: Fix kernel BUG in purge_effective_progs

Randy Dunlap (1):
      Documentation: networking: correct possessive "its"

Sebastian Andrzej Siewior (2):
      net: dsa: xrs700x: Use irqsave variant for u64 stats update
      net: Use u64_stats_fetch_begin_irq() for stats fetch.

Siddh Raman Pant (2):
      wifi: mac80211: Fix UAF in ieee80211_scan_rx()
      wifi: mac80211: Don't finalize CSA in IBSS mode if state is disconnected

Tetsuo Handa (1):
      Bluetooth: hci_sync: fix double mgmt_pending_free() in remove_adv_monitor()

Tianyu Yuan (1):
      nfp: flower: fix ingress police using matchall filter

Toke Høiland-Jørgensen (1):
      sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb

Wang Hai (1):
      net/sched: fix netdevice reference leaks in attach_default_qdiscs()

Wolfram Sang (1):
      Bluetooth: move from strlcpy with unused retval to strscpy

Yacan Liu (1):
      net/smc: Remove redundant refcount increase

Yang Yingliang (1):
      wifi: mac80211: fix possible leak in ieee80211_tx_control_port()

YiFei Zhu (1):
      bpf: Restrict bpf_sys_bpf to CAP_PERFMON

Zhengchao Shao (1):
      net: sched: tbf: don't call qdisc_put() while holding tree lock

Zhengping Jiang (1):
      Bluetooth: hci_sync: hold hdev->lock when cleanup hci_conn

 Documentation/networking/devlink/netdevsim.rst     |   2 +-
 Documentation/networking/driver.rst                |   2 +-
 Documentation/networking/ip-sysctl.rst             |   5 +-
 Documentation/networking/ipvlan.rst                |   2 +-
 Documentation/networking/l2tp.rst                  |   2 +-
 Documentation/networking/switchdev.rst             |   2 +-
 drivers/net/dsa/xrs700x/xrs700x.c                  |   5 +-
 drivers/net/ethernet/broadcom/tg3.c                |   8 +-
 drivers/net/ethernet/cortina/gemini.c              |  24 ++--
 drivers/net/ethernet/fungible/funeth/funeth_txrx.h |   4 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c      |  16 +--
 drivers/net/ethernet/google/gve/gve_main.c         |  12 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |   4 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       |   4 +-
 .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h  |   4 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c | 122 ++++++++++++++++++---
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |   3 +-
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |   5 +-
 .../net/ethernet/microchip/sparx5/sparx5_packet.c  |   2 +
 .../net/ethernet/netronome/nfp/flower/qos_conf.c   |   5 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |   8 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   8 +-
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c   |   1 +
 drivers/net/ethernet/rocker/rocker_ofdpa.c         |   2 +-
 drivers/net/ethernet/smsc/smsc911x.c               |   6 +
 drivers/net/ieee802154/adf7242.c                   |   3 +-
 drivers/net/ieee802154/ca8210.c                    |   2 +-
 drivers/net/ieee802154/cc2520.c                    |   1 +
 drivers/net/netdevsim/netdev.c                     |   4 +-
 drivers/net/phy/micrel.c                           |   8 +-
 drivers/net/usb/cdc_ether.c                        |   7 ++
 drivers/net/usb/r8152.c                            |   3 +
 include/net/ip_tunnels.h                           |   4 +-
 include/net/netns/ipv4.h                           |   2 +
 include/uapi/linux/bpf.h                           |   2 +-
 include/uapi/linux/virtio_net.h                    |  14 +--
 kernel/bpf/cgroup.c                                |   4 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/bpf/syscall.c                               |   2 +-
 kernel/bpf/verifier.c                              |  13 ++-
 net/bluetooth/hci_event.c                          |  13 ++-
 net/bluetooth/hci_sync.c                           |  30 +++--
 net/bluetooth/hidp/core.c                          |   6 +-
 net/bluetooth/iso.c                                |  35 ++++--
 net/bluetooth/l2cap_core.c                         |  10 +-
 net/bluetooth/mgmt.c                               |  72 +++++++-----
 net/core/skmsg.c                                   |   4 +-
 net/dsa/tag_hellcreek.c                            |   2 +-
 net/ipv4/fib_frontend.c                            |   4 +-
 net/ipv4/ip_gre.c                                  |   2 +-
 net/ipv4/ip_tunnel.c                               |   7 +-
 net/ipv4/tcp_input.c                               |  21 ++--
 net/ipv4/tcp_ipv4.c                                |   6 +-
 net/kcm/kcmsock.c                                  |  15 ++-
 net/mac80211/ibss.c                                |   4 +
 net/mac80211/scan.c                                |  11 +-
 net/mac80211/sta_info.c                            |  10 +-
 net/mac80211/tx.c                                  |   3 +-
 net/mac802154/rx.c                                 |   2 +-
 net/mpls/af_mpls.c                                 |   4 +-
 net/openvswitch/datapath.c                         |   4 +-
 net/sched/sch_generic.c                            |  31 +++---
 net/sched/sch_tbf.c                                |   4 +-
 net/smc/af_smc.c                                   |   1 -
 net/wireless/debugfs.c                             |   3 +-
 net/xdp/xsk_buff_pool.c                            |  16 ++-
 tools/testing/selftests/bpf/DENYLIST.s390x         |   1 +
 tools/testing/selftests/bpf/verifier/precise.c     |  25 +++++
 tools/testing/selftests/net/.gitignore             |  50 ++++-----
 70 files changed, 478 insertions(+), 249 deletions(-)

