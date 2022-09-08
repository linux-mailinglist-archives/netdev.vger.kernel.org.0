Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD3A5B1ADE
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 13:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiIHLG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 07:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIHLG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 07:06:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3736EBE4C1
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 04:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662635216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xL9zKh/M+MTFoAa+TFKYW1CEVc0Dis/piOqO58DdPyc=;
        b=bQP5Vh9c+z9VXrKHQZmZA/DkbBIMN9TXDxgfpGgTU3Vsmzl+Pz96BN60w3a+QcM8tHwxPv
        oPw1G33bQDQnOzNN59j36ryTBAXyy/EYb24+XLZtgTXId7CsFpWaC4liuj0M1J7rHCKGRP
        RLY4sDjZOI5CCp6Rxtp9cs04qyE18HY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-VtdmsV5WMp6iB2uyDAftrw-1; Thu, 08 Sep 2022 07:06:55 -0400
X-MC-Unique: VtdmsV5WMp6iB2uyDAftrw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9876C3815D37;
        Thu,  8 Sep 2022 11:06:54 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F7A040B40C9;
        Thu,  8 Sep 2022 11:06:53 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.0-rc5
Date:   Thu,  8 Sep 2022 13:06:10 +0200
Message-Id: <20220908110610.28284-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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

The following changes since commit 42e66b1cc3a070671001f8a1e933a80818a192bf:

  Merge tag 'net-6.0-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-09-01 09:20:42 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc5

for you to fetch changes up to 2f09707d0c972120bf794cfe0f0c67e2c2ddb252:

  sch_sfb: Also store skb len before calling child enqueue (2022-09-08 11:12:58 +0200)

----------------------------------------------------------------
Networking fixes for 6.0-rc5, including fixes from rxrpc, netfilter,
wireless and bluetooth subtrees

Current release - regressions:
  - skb: export skb drop reaons to user by TRACE_DEFINE_ENUM

  - bluetooth: fix regression preventing ACL packet transmission

Current release - new code bugs:
  - dsa: microchip: fix kernel oops on ksz8 switches

  - dsa: qca8k: fix NULL pointer dereference for of_device_get_match_data

Previous releases - regressions:
  - netfilter: clean up hook list when offload flags check fails

  - wifi: mt76: fix crash in chip reset fail

  - rxrpc: fix ICMP/ICMP6 error handling

  - ice: fix DMA mappings leak

  - i40e: fix kernel crash during module removal

Previous releases - always broken:
  - ipv6: sr: fix out-of-bounds read when setting HMAC data.

  - tcp: TX zerocopy should not sense pfmemalloc status

  - sch_sfb: don't assume the skb is still around after enqueueing to child

  - netfilter: drop dst references before setting

  - wifi: wilc1000: fix DMA on stack objects

  - rxrpc: fix an insufficiently large sglist in rxkad_verify_packet_2()

  - fec: use a spinlock to guard `fep->ptp_clk_on`

Misc:
  - usb: qmi_wwan: add Quectel RM520N

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Ajay.Kathat@microchip.com (1):
      wifi: wilc1000: fix DMA on stack objects

Arun Ramadoss (1):
      net: phy: lan87xx: change interrupt src of link_up to comm_ready

Christian Marangi (1):
      net: dsa: qca8k: fix NULL pointer dereference for of_device_get_match_data

Christophe JAILLET (1):
      stmmac: intel: Simplify intel_eth_pci_remove()

Csókás Bence (1):
      net: fec: Use a spinlock to guard `fep->ptp_clk_on`

Dan Carpenter (1):
      tipc: fix shift wrapping bug in map_get()

David Howells (6):
      rxrpc: Fix ICMP/ICMP6 error handling
      rxrpc: Fix an insufficiently large sglist in rxkad_verify_packet_2()
      rxrpc: Fix local destruction being repeated
      rxrpc: Fix calc of resend age
      afs: Use the operation issue time instead of the reply time for callbacks
      rxrpc: Remove rxrpc_get_reply_time() which is no longer used

David Leadbeater (1):
      netfilter: nf_conntrack_irc: Fix forged IP logic

David Lebrun (1):
      ipv6: sr: fix out-of-bounds read when setting HMAC data.

David S. Miller (7):
      Merge tag 'rxrpc-fixes-20220901' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'wireless-2022-09-03' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge branch 'bonding-fixes'
      Merge tag 'for-net-2022-09-02' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge branch 'dsa-felix-fixes'

Deren Wu (1):
      wifi: mt76: mt7921e: fix crash in chip reset fail

Eric Dumazet (1):
      tcp: TX zerocopy should not sense pfmemalloc status

Greg Kroah-Hartman (1):
      net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()

Hangbin Liu (3):
      bonding: use unspecified address if no available link local address
      bonding: add all node mcast address when slave up
      bonding: accept unsolicited NA message

Harsh Modi (1):
      netfilter: br_netfilter: Drop dst references before setting.

Heiner Kallweit (1):
      Revert "net: phy: meson-gxl: improve link-up behavior"

Ivan Vecera (2):
      i40e: Fix kernel crash during module removal
      iavf: Detach device during reset task

Jakub Kicinski (1):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

Johannes Berg (3):
      wifi: mac80211: mlme: release deflink channel in error case
      wifi: mac80211: fix locking in auth/assoc timeout
      wifi: use struct_group to copy addresses

Lorenzo Bianconi (2):
      net: ethernet: mtk_eth_soc: fix typo in __mtk_foe_entry_clear
      net: ethernet: mtk_eth_soc: check max allowed hash in mtk_ppe_check_skb

Luiz Augusto von Dentz (1):
      Bluetooth: hci_sync: Fix hci_read_buffer_size_sync

Menglong Dong (1):
      net: skb: export skb drop reaons to user by TRACE_DEFINE_ENUM

Michal Swiatkowski (1):
      ice: use bitmap_free instead of devm_kfree

Mukesh Sisodiya (1):
      wifi: mac80211: fix link warning in RX agg timer expiry

Neal Cardwell (1):
      tcp: fix early ETIMEDOUT after spurious non-SACK RTO

Oleksij Rempel (1):
      net: dsa: microchip: fix kernel oops on ksz8 switches

Pablo Neira Ayuso (2):
      netfilter: remove nf_conntrack_helper sysctl and modparam toggles
      netfilter: nf_tables: clean up hook list when offload flags check fails

Paul Durrant (1):
      xen-netback: only remove 'hotplug-status' when the vif is actually destroyed

Przemyslaw Patynowski (2):
      ice: Fix DMA mappings leak
      i40e: Fix ADQ rate limiting for PF

Soenke Huster (1):
      wifi: mac80211_hwsim: check length for virtio packets

Stanislaw Gruszka (1):
      wifi: iwlegacy: 4965: corrected fix for potential off-by-one overflow in il4965_rs_fill_link_cmd()

Toke Høiland-Jørgensen (2):
      sch_sfb: Don't assume the skb is still around after enqueueing to child
      sch_sfb: Also store skb len before calling child enqueue

Vladimir Oltean (3):
      net: dsa: felix: tc-taprio intervals smaller than MTU should send at least one packet
      net: dsa: felix: disable cut-through forwarding for frames oversized for tc-taprio
      net: dsa: felix: access QSYS_TAG_CONFIG under tas_lock in vsc9959_sched_speed_set

Wei Fang (1):
      net: fec: add pm_qos support on imx6q platform

Yacan Liu (1):
      net/smc: Fix possible access to freed memory in link clear

jerry.meng (1):
      net: usb: qmi_wwan: add Quectel RM520N

 Documentation/networking/rxrpc.rst                 |  11 -
 drivers/net/bonding/bond_main.c                    |  20 +-
 drivers/net/dsa/microchip/ksz_common.c             |  30 ++-
 drivers/net/dsa/ocelot/felix_vsc9959.c             | 161 +++++++----
 drivers/net/dsa/qca/qca8k-8xxx.c                   |   2 +-
 drivers/net/ethernet/freescale/fec.h               |   6 +-
 drivers/net/ethernet/freescale/fec_main.c          |  26 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |  28 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c      |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   3 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   3 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  14 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |  17 --
 drivers/net/ethernet/intel/ice/ice_main.c          |  10 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  63 +++++
 drivers/net/ethernet/intel/ice/ice_xsk.h           |   8 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c |   4 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c            |   2 +-
 drivers/net/ethernet/mediatek/mtk_ppe.h            |   3 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   2 -
 drivers/net/phy/meson-gxl.c                        |   8 +-
 drivers/net/phy/microchip_t1.c                     |  58 +++-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |   5 +-
 drivers/net/wireless/mac80211_hwsim.c              |   7 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |   2 +-
 drivers/net/wireless/microchip/wilc1000/netdev.h   |   1 +
 drivers/net/wireless/microchip/wilc1000/sdio.c     |  39 ++-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |  15 +-
 drivers/net/xen-netback/xenbus.c                   |   2 +-
 fs/afs/flock.c                                     |   2 +-
 fs/afs/fsclient.c                                  |   2 +-
 fs/afs/internal.h                                  |   3 +-
 fs/afs/rxrpc.c                                     |   7 +-
 fs/afs/yfsclient.c                                 |   3 +-
 include/linux/ieee80211.h                          |   8 +-
 include/linux/skbuff.h                             |  21 ++
 include/linux/udp.h                                |   1 +
 include/net/af_rxrpc.h                             |   2 -
 include/net/dropreason.h                           |  67 +++++
 include/net/netfilter/nf_conntrack.h               |   2 -
 include/net/netns/conntrack.h                      |   1 -
 include/net/udp_tunnel.h                           |   4 +
 include/trace/events/skb.h                         |  15 +-
 net/bluetooth/hci_sync.c                           |  12 +-
 net/bridge/br_netfilter_hooks.c                    |   2 +
 net/bridge/br_netfilter_ipv6.c                     |   1 +
 net/core/.gitignore                                |   1 -
 net/core/Makefile                                  |  22 +-
 net/core/datagram.c                                |   2 +-
 net/core/skbuff.c                                  |   6 +-
 net/ipv4/tcp.c                                     |   2 +-
 net/ipv4/tcp_input.c                               |  25 +-
 net/ipv4/udp.c                                     |   2 +
 net/ipv4/udp_tunnel_core.c                         |   1 +
 net/ipv6/addrconf.c                                |   8 +-
 net/ipv6/seg6.c                                    |   5 +
 net/ipv6/udp.c                                     |   5 +-
 net/mac80211/mlme.c                                |  12 +-
 net/mac80211/rx.c                                  |   4 +
 net/mac80211/wpa.c                                 |   4 +-
 net/netfilter/nf_conntrack_core.c                  |   7 +-
 net/netfilter/nf_conntrack_helper.c                |  80 +-----
 net/netfilter/nf_conntrack_irc.c                   |   5 +-
 net/netfilter/nf_conntrack_netlink.c               |   5 -
 net/netfilter/nf_conntrack_standalone.c            |  10 -
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nft_ct.c                             |   3 -
 net/rxrpc/ar-internal.h                            |   1 +
 net/rxrpc/call_event.c                             |   2 +-
 net/rxrpc/local_object.c                           |   4 +
 net/rxrpc/peer_event.c                             | 293 ++++++++++++++++++---
 net/rxrpc/recvmsg.c                                |  43 ---
 net/rxrpc/rxkad.c                                  |   2 +-
 net/sched/sch_sfb.c                                |  13 +-
 net/smc/smc_core.c                                 |   1 +
 net/smc/smc_core.h                                 |   2 +
 net/smc/smc_wr.c                                   |   5 +
 net/smc/smc_wr.h                                   |   5 +
 net/tipc/monitor.c                                 |   2 +-
 net/wireless/lib80211_crypt_ccmp.c                 |   2 +-
 .../selftests/netfilter/nft_conntrack_helper.sh    |  36 ++-
 82 files changed, 913 insertions(+), 420 deletions(-)
 delete mode 100644 net/core/.gitignore

