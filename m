Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40BA2C6C69
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 21:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731143AbgK0UGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 15:06:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731432AbgK0UEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 15:04:31 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5425620B80;
        Fri, 27 Nov 2020 20:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606507469;
        bh=QOWTUaSUDVIgxCF3JnfMjWg59bCQYAfSI9X22UZgDnM=;
        h=From:To:Cc:Subject:Date:From;
        b=dLIB5NlcKj373i2ha+29gEXbU0K1mbWI4IsNxI+ovvNSqCUJ4DZ15Zanhaaj+8L8C
         8bqeYOcdZIHKqTEGkK6BJtDe+fIRuiXr0qzbGu/31RPQUWHJcEneImE1zNFX8hUtaI
         Nz3PL/kBM9L6FidjcHMqAvPz5a5btmz35M8Rx/j4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking
Date:   Fri, 27 Nov 2020 12:04:28 -0800
Message-Id: <20201127200428.221620-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 4d02da974ea85a62074efedf354e82778f910d82:

  Merge tag 'net-5.10-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-11-19 13:33:16 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc6

for you to fetch changes up to d0742c49cab58ee6e2de40f1958b736aedf779b6:

  Merge tag 'linux-can-fixes-for-5.10-20201127' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can (2020-11-27 11:13:39 -0800)

----------------------------------------------------------------
Networking fixes for 5.10-rc6, including fixes from the WiFi driver,
and can subtrees.

Current release - regressions:

 - gro_cells: reduce number of synchronize_net() calls

 - ch_ktls: release a lock before jumping to an error path

Current release - always broken:

 - tcp: Allow full IP tos/IPv6 tclass to be reflected in L3 header

Previous release - regressions:

 - net/tls: fix missing received data after fast remote close

 - vsock/virtio: discard packets only when socket is really closed

 - sock: set sk_err to ee_errno on dequeue from errq

 - cxgb4: fix the panic caused by non smac rewrite

Previous release - always broken:

 - tcp: fix corner cases around setting ECN with BPF selection
        of congestion control

 - tcp: fix race condition when creating child sockets from
        syncookies on loopback interface

 - usbnet: ipheth: fix connectivity with iOS 14

 - tun: honor IOCB_NOWAIT flag

 - net/packet: fix packet receive on L3 devices without visible
               hard header

 - devlink: Make sure devlink instance and port are in same net
            namespace

 - net: openvswitch: fix TTL decrement action netlink message format

 - bonding: wait for sysfs kobject destruction before freeing
            struct slave

 - net: stmmac: fix upstream patch applied to the wrong context

 - bnxt_en: fix return value and unwind in probe error paths

Misc:

 - devlink: add extra layer of categorization to the reload stats
            uAPI before it's released

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alexander Duyck (3):
      tcp: Allow full IP tos/IPv6 tclass to be reflected in L3 header
      tcp: Set INET_ECN_xmit configuration in tcp_reinit_congestion_control
      tcp: Set ECT0 bit in tos/tclass for synack when BPF needs ECN

Alexandra Winter (1):
      s390/qeth: Remove pnso workaround

Anmol Karn (1):
      rose: Fix Null pointer dereference in rose_send_frame()

Antonio Borneo (1):
      net: stmmac: fix incorrect merge of patch upstream

Avraham Stern (1):
      iwlwifi: mvm: write queue_sync_state only for sync

Chi-Hsien Lin (1):
      MAINTAINERS: update maintainers list for Cypress

Eelco Chaudron (1):
      net: openvswitch: fix TTL decrement action netlink message format

Emmanuel Grumbach (2):
      iwlwifi: mvm: use the HOT_SPOT_CMD to cancel an AUX ROC
      iwlwifi: mvm: properly cancel a session protection for P2P

Eric Dumazet (1):
      gro_cells: reduce number of synchronize_net() calls

Eyal Birger (1):
      net/packet: fix packet receive on L3 devices without visible hard header

Ezequiel Garcia (1):
      dpaa2-eth: Fix compile error due to missing devlink support

Ioana Ciornei (1):
      dpaa2-eth: select XGMAC_MDIO for MDIO bus support

Jakub Kicinski (10):
      Merge branch 'tcp-address-issues-with-ect0-not-being-set-in-dctcp-packets'
      Merge branch 's390-qeth-fixes-2020-11-20'
      Merge branch 'ibmvnic-fixes-in-reset-path'
      Merge tag 'wireless-drivers-2020-11-23' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge branch 'fixes-for-ena-driver'
      Merge branch 'ibmvnic-null-pointer-dereference'
      Merge tag 'batadv-net-pullrequest-20201124' of git://git.open-mesh.org/linux-merge
      Documentation: netdev-FAQ: suggest how to post co-dependent series
      Merge branch 'devlink-port-attribute-fixes'
      Merge tag 'linux-can-fixes-for-5.10-20201127' of git://git.kernel.org/.../mkl/linux-can

Jamie Iles (1):
      bonding: wait for sysfs kobject destruction before freeing struct slave

Jens Axboe (1):
      tun: honor IOCB_NOWAIT flag

Jesper Dangaard Brouer (1):
      MAINTAINERS: Update page pool entry

Johannes Berg (2):
      iwlwifi: pcie: limit memory read spin time
      iwlwifi: pcie: set LTR to avoid completion timeout

Julian Wiedmann (4):
      s390/qeth: make af_iucv TX notification call more robust
      s390/qeth: fix af_iucv notification race
      s390/qeth: fix tear down of async TX buffers
      net/af_iucv: set correct sk_protocol for child sockets

Krzysztof Kozlowski (1):
      nfc: s3fwrn5: use signed integer for parsing GPIO numbers

Lijun Pan (6):
      ibmvnic: fix call_netdevice_notifiers in do_reset
      ibmvnic: notify peers when failover and migration happen
      ibmvnic: skip tx timeout reset while in resetting
      ibmvnic: fix NULL pointer dereference in reset_sub_crq_queues
      ibmvnic: fix NULL pointer dereference in ibmvic_reset_crq
      ibmvnic: enhance resetting status check during module exit

Lincoln Ramsay (1):
      aquantia: Remove the build_skb path

Marc Kleine-Budde (4):
      can: gs_usb: fix endianess problem with candleLight firmware
      can: mcp251xfd: mcp251xfd_probe(): bail out if no IRQ was given
      can: m_can: m_can_open(): remove IRQF_TRIGGER_FALLING from request_threaded_irq()'s flags
      can: m_can: fix nominal bitiming tseg2 min for version >= 3.1

Martin Habets (1):
      MAINTAINERS: Change Solarflare maintainers

Maxim Mikityanskiy (1):
      net/tls: Protect from calling tls_dev_del for TLS RX twice

Michael Chan (1):
      bnxt_en: Release PCI regions when DMA mask setup fails during probe.

Min Li (1):
      ptp: clockmatrix: bug fix for idtcm_strverscmp

Mordechay Goodstein (1):
      iwlwifi: sta: set max HE max A-MPDU according to HE capa

Moshe Shemesh (1):
      devlink: Fix reload stats structure

Oliver Hartkopp (1):
      can: af_can: can_rx_unregister(): remove WARN() statement from list operation sanity check

Pankaj Sharma (1):
      can: m_can: m_can_dev_setup(): add support for bosch mcan version 3.3.0

Paolo Abeni (1):
      mptcp: fix NULL ptr dereference on bad MPJ

Parav Pandit (2):
      devlink: Hold rtnl lock while reading netdev attributes
      devlink: Make sure devlink instance and port are in same net namespace

Raju Rangoju (1):
      cxgb4: fix the panic caused by non smac rewrite

Ricardo Dias (1):
      tcp: fix race condition when creating child sockets from syncookies

Rohit Maheshwari (1):
      ch_ktls: lock is not freed

Sara Sharon (1):
      iwlwifi: mvm: fix kernel panic in case of assert during CSA

Shay Agroskin (3):
      net: ena: handle bad request id in ena_netdev
      net: ena: set initial DMA width to avoid intel iommu issue
      net: ena: fix packet's addresses for rx_offset feature

Stefano Garzarella (1):
      vsock/virtio: discard packets only when socket is really closed

Sylwester Dziedziuch (1):
      i40e: Fix removing driver while bare-metal VFs pass traffic

Taehee Yoo (1):
      batman-adv: set .owner to THIS_MODULE

Tom Rix (1):
      rtw88: fix fw_fifo_addr check

Tom Seewald (1):
      cxgb4: Fix build failure when CONFIG_TLS=m

Vadim Fedorenko (1):
      net/tls: missing received data after fast remote close

Vladimir Oltean (1):
      enetc: Let the hardware auto-advance the taprio base-time of 0

Wang Hai (1):
      ipv6: addrlabel: fix possible memory leak in ip6addrlbl_net_init

Willem de Bruijn (1):
      sock: set sk_err to ee_errno on dequeue from errq

Yan-Hsuan Chuang (1):
      MAINTAINERS: update Yan-Hsuan's email address

Yves-Alexis Perez (1):
      usbnet: ipheth: fix connectivity with iOS 14

Zhang Changzhong (2):
      bnxt_en: fix error return code in bnxt_init_one()
      bnxt_en: fix error return code in bnxt_init_board()

 Documentation/networking/netdev-FAQ.rst            |  26 ++++
 MAINTAINERS                                        |  16 +--
 drivers/net/bonding/bond_main.c                    |  61 +++++++---
 drivers/net/bonding/bond_sysfs_slave.c             |  18 +--
 drivers/net/can/m_can/m_can.c                      |   6 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   4 +
 drivers/net/can/usb/gs_usb.c                       | 131 +++++++++++----------
 drivers/net/ethernet/amazon/ena/ena_eth_com.c      |   3 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  80 +++++--------
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   | 126 ++++++++------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   4 +-
 drivers/net/ethernet/chelsio/Kconfig               |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   3 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      |   4 +-
 drivers/net/ethernet/freescale/dpaa2/Kconfig       |   2 +
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |  14 +--
 drivers/net/ethernet/ibm/ibmvnic.c                 |  23 +++-
 drivers/net/ethernet/ibm/ibmvnic.h                 |   3 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  22 ++--
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  26 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +-
 drivers/net/tun.c                                  |  14 ++-
 drivers/net/usb/ipheth.c                           |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |  10 +-
 .../net/wireless/intel/iwlwifi/fw/api/time-event.h |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |  10 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  18 +++
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    | 103 ++++++++++------
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |  20 ++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  36 ++++--
 drivers/net/wireless/realtek/rtw88/fw.c            |   2 +-
 drivers/nfc/s3fwrn5/i2c.c                          |   4 +-
 drivers/ptp/ptp_clockmatrix.c                      |  49 +++-----
 drivers/s390/net/qeth_core.h                       |   9 +-
 drivers/s390/net/qeth_core_main.c                  |  82 ++++++++-----
 drivers/s390/net/qeth_l2_main.c                    |  18 +--
 include/linux/netdevice.h                          |   5 +
 include/net/bonding.h                              |   8 ++
 include/net/inet_hashtables.h                      |   5 +-
 include/net/tls.h                                  |   6 +
 include/uapi/linux/devlink.h                       |   2 +
 include/uapi/linux/openvswitch.h                   |   2 +
 net/batman-adv/log.c                               |   1 +
 net/can/af_can.c                                   |   7 +-
 net/core/devlink.c                                 |  56 ++++++---
 net/core/gro_cells.c                               |   7 +-
 net/core/skbuff.c                                  |   2 +-
 net/dccp/ipv4.c                                    |   2 +-
 net/dccp/ipv6.c                                    |   2 +-
 net/ipv4/inet_connection_sock.c                    |   2 +-
 net/ipv4/inet_hashtables.c                         |  68 +++++++++--
 net/ipv4/tcp_cong.c                                |   5 +
 net/ipv4/tcp_ipv4.c                                |  28 ++++-
 net/ipv6/addrlabel.c                               |  26 ++--
 net/ipv6/tcp_ipv6.c                                |  26 +++-
 net/iucv/af_iucv.c                                 |   4 +-
 net/mptcp/subflow.c                                |   5 +-
 net/openvswitch/actions.c                          |   7 +-
 net/openvswitch/flow_netlink.c                     |  74 +++++++++---
 net/packet/af_packet.c                             |  18 +--
 net/rose/rose_loopback.c                           |  17 ++-
 net/tls/tls_device.c                               |   5 +-
 net/tls/tls_sw.c                                   |   6 +
 net/vmw_vsock/virtio_transport_common.c            |   8 +-
 66 files changed, 864 insertions(+), 507 deletions(-)
