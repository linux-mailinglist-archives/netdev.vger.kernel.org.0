Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9CD315DCF
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 04:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhBJDg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 22:36:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48034 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhBJDg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 22:36:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 177CC4D2CA80E;
        Tue,  9 Feb 2021 19:36:17 -0800 (PST)
Date:   Tue, 09 Feb 2021 19:36:11 -0800 (PST)
Message-Id: <20210209.193611.1524785817913120444.davem@davemloft.net>
To:     torvalds@linux-foundation.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Networking 
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 09 Feb 2021 19:36:17 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Another pile of networing fixes:

1) ath9k build error fix from Arnd Bergmann

2) dma memory leak fix in mediatec driver from Lorenzo Bianconi.

3) bpf int3 kprobe fix from Alexei Starovoitov.

4) bpf stackmap integer overflow fix from Bui Quang Minh.

5) Add usb device ids for Cinterion MV31 to qmi_qwwan driver, from
   Christoph Schemmel.

6) Don't update deleted entry in xt_recent netfilter module, from Jazsef Kadlecsik.

7) Use after free in nftables, fix from Pablo Neira Ayuso.

8) Header checksum fix in flowtable from Sven Auhagen.

9) Validate user controlled length in qrtr code, from Sabyrzhan Tasbolatov.

10) Fix race in xen/netback, from Juergen Gross,

11) New device ID in cxgb4, from Raju Rangoju.

12) Fix ring locking in rxrpc release call, from David Howells.

13) Don't return LAPB error codes from x25_open(), from Xie He.

14) Missing error returns in gsi_channel_setup() from Alex Elder.

15) Get skb_copy_and_csum_datagram working properly with odd segment sizes,
    from Willem de Bruijn.

16) Missing RFS/RSS table init in enetc driver, from Vladimir Oltean.

17) Do teardown on probe failure in DSA, from Vladimir Oltean.

18) Fix compilation failures of txtimestamp selftest, from Vadim Fedorenko.

19) Limit rx per-napi gro queue size to fix latency regression,  from Eric Dumazet.

20) dpaa_eth xdp fixes from Camelia Groza.

21) Missing txq mode update when switching CBS off, in stmmac driver,
    from Mohammad Athari Bin Ismail.

22) Failover pending logic fix in ibmvnic driver, from Sukadev Bhattiprolu.

23) Null deref fix in vmw_vsock, from Norbert Slusarek.

24) Missing verdict update in xdp paths of ena driver, from Shay Agroskin.

25) seq_file iteration fix in sctp from Neil Brown.

26) bpf 32-bit src register truncation fix on div/mod, from Daniel Borkmann.

27) Fix jmp32 pruning in bpf verifier, from  Daniel Borkmann.

28) Fix locking in vsock_shutdown(),  from Stefano Garzarella.

29) Various missing index bound checks in hns3 driver, from Yufeng Mo.

30) Flush ports on .phylink_mac_link_down() in dsa felix driver, from Vladimir Oltean.

31) Don't mix up stp and mrp port states in bridge layer, from Horatiu Vultur.

32) Fix locking during netif_tx_disable(), from Edwin Peer.

Please pull, thanks a lot!

The following changes since commit 3aaf0a27ffc29b19a62314edd684b9bc6346f9a8:

  Merge tag 'clang-format-for-linux-v5.11-rc7' of git://github.com/ojeda/linux (2021-02-02 10:46:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to b8776f14a47046796fe078c4a2e691f58e00ae06:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2021-02-09 18:55:17 -0800)

----------------------------------------------------------------
Alex Elder (1):
      net: ipa: set error code in gsi_channel_setup()

Alexei Starovoitov (1):
      bpf: Unbreak BPF_PROG_TYPE_KPROBE when kprobe is called via do_int3

Andrea Parri (Microsoft) (1):
      hv_netvsc: Reset the RSC count if NVSP_STAT_FAIL in netvsc_receive()

Arnd Bergmann (1):
      ath9k: fix build error with LEDS_CLASS=m

Bui Quang Minh (1):
      bpf: Check for integer overflow when using roundup_pow_of_two()

Camelia Groza (3):
      dpaa_eth: reserve space for the xdp_frame under the A050385 erratum
      dpaa_eth: reduce data alignment requirements for the A050385 erratum
      dpaa_eth: try to move the data in place for the A050385 erratum

Christoph Schemmel (1):
      NET: usb: qmi_wwan: Adding support for Cinterion MV31

Daniel Borkmann (3):
      bpf: Fix verifier jsgt branch analysis on max bound
      bpf: Fix verifier jmp32 pruning decision logic
      bpf: Fix 32 bit src register truncation on div/mod

David Howells (1):
      rxrpc: Fix clearance of Tx/Rx ring when releasing a call

David S. Miller (4):
      Merge branch 'bridge-mrp'
      Merge branch 'hns3-fixes'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

Edwin Peer (1):
      net: watchdog: hold device global xmit lock during tx disable

Eric Dumazet (1):
      net: gro: do not keep too many GRO packets in napi->rx_list

Fabian Frederick (1):
      selftests: netfilter: fix current year

Florian Westphal (1):
      netfilter: conntrack: skip identical origin tuple in same zone only

Horatiu Vultur (2):
      bridge: mrp: Fix the usage of br_mrp_port_switchdev_set_state
      switchdev: mrp: Remove SWITCHDEV_ATTR_ID_MRP_PORT_STAT

Jakub Kicinski (3):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge branch 'dpaa_eth-a050385-erratum-workaround-fixes-under-xdp'
      Merge tag 'wireless-drivers-2021-02-05' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers

Jozsef Kadlecsik (1):
      netfilter: xt_recent: Fix attempt to update deleted entry

Juergen Gross (1):
      xen/netback: avoid race in xenvif_rx_ring_slots_available()

Lorenzo Bianconi (1):
      mt76: dma: fix a possible memory leak in mt76_add_fragment()

Mohammad Athari Bin Ismail (1):
      net: stmmac: set TxQ mode back to DCB after disabling CBS

NeilBrown (1):
      net: fix iteration for sctp transport seq_files

Norbert Slusarek (2):
      net/vmw_vsock: fix NULL pointer dereference
      net/vmw_vsock: improve locking in vsock_connect_timeout()

Pablo Neira Ayuso (2):
      netfilter: nftables: fix possible UAF over chains from packet path in netns
      netfilter: nftables: relax check for stateful expressions in set definition

Raju Rangoju (1):
      cxgb4: Add new T6 PCI device id 0x6092

Sabyrzhan Tasbolatov (1):
      net/qrtr: restrict user-controlled length in qrtr_tun_write_iter()

Shay Agroskin (1):
      net: ena: Update XDP verdict upon failure

Stefano Garzarella (2):
      vsock/virtio: update credit only if socket is not closed
      vsock: fix locking in vsock_shutdown()

Sukadev Bhattiprolu (1):
      ibmvnic: Clear failover_pending if unable to schedule

Sven Auhagen (1):
      netfilter: flowtable: fix tcp and udp header checksum update

Vadim Fedorenko (2):
      selftests/tls: fix selftest with CHACHA20-POLY1305
      selftests: txtimestamp: fix compilation issue

Vladimir Oltean (3):
      net: enetc: initialize the RFS and RSS memories
      net: dsa: call teardown method on probe failure
      net: dsa: felix: implement port flushing on .phylink_mac_link_down

Willem de Bruijn (1):
      udp: fix skb_copy_and_csum_datagram with odd segment sizes

Xie He (1):
      net: hdlc_x25: Return meaningful error code in x25_open

Yufeng Mo (3):
      net: hns3: add a check for queue_id in hclge_reset_vf_queue()
      net: hns3: add a check for tqp_index in hclge_get_ring_chain_from_mbx()
      net: hns3: add a check for index in hclge_get_rss_key()

 drivers/net/dsa/ocelot/felix.c                          | 17 ++++++++++++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c            |  6 +++++-
 drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h      |  1 +
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c          | 42 ++++++++++++++++++++++++++++++++++++++----
 drivers/net/ethernet/freescale/enetc/enetc_hw.h         |  2 ++
 drivers/net/ethernet/freescale/enetc/enetc_pf.c         | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |  7 +++++++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c  | 29 +++++++++++++++++++++++++----
 drivers/net/ethernet/ibm/ibmvnic.c                      | 17 ++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot.c                      | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_io.c                   |  8 ++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c         |  7 ++++++-
 drivers/net/hyperv/netvsc.c                             |  5 ++++-
 drivers/net/hyperv/rndis_filter.c                       |  2 --
 drivers/net/ipa/gsi.c                                   |  1 +
 drivers/net/usb/qmi_wwan.c                              |  1 +
 drivers/net/wan/hdlc_x25.c                              |  6 +++---
 drivers/net/wireless/ath/ath9k/Kconfig                  |  8 ++------
 drivers/net/wireless/mediatek/mt76/dma.c                |  8 +++++---
 drivers/net/xen-netback/rx.c                            |  9 ++++++++-
 include/linux/netdevice.h                               |  2 ++
 include/linux/uio.h                                     |  8 +++++++-
 include/net/switchdev.h                                 |  2 --
 include/soc/mscc/ocelot.h                               |  2 ++
 kernel/bpf/stackmap.c                                   |  2 ++
 kernel/bpf/verifier.c                                   | 38 ++++++++++++++++++++------------------
 kernel/trace/bpf_trace.c                                |  3 ---
 lib/iov_iter.c                                          | 24 ++++++++++++++----------
 net/bridge/br_mrp.c                                     |  9 ++++++---
 net/bridge/br_mrp_switchdev.c                           |  7 +++----
 net/bridge/br_private_mrp.h                             |  3 +--
 net/core/datagram.c                                     | 12 ++++++++++--
 net/core/dev.c                                          | 11 ++++++-----
 net/dsa/dsa2.c                                          |  7 +++++--
 net/mac80211/Kconfig                                    |  2 +-
 net/netfilter/nf_conntrack_core.c                       |  3 ++-
 net/netfilter/nf_flow_table_core.c                      |  4 ++--
 net/netfilter/nf_tables_api.c                           | 53 ++++++++++++++++++++++++++++++++++-------------------
 net/netfilter/xt_recent.c                               | 12 ++++++++++--
 net/qrtr/tun.c                                          |  6 ++++++
 net/rxrpc/call_object.c                                 |  2 --
 net/sctp/proc.c                                         | 16 ++++++++++++----
 net/vmw_vsock/af_vsock.c                                | 15 +++++++--------
 net/vmw_vsock/hyperv_transport.c                        |  4 ----
 net/vmw_vsock/virtio_transport_common.c                 |  4 ++--
 tools/testing/selftests/net/tls.c                       | 15 ++++++++++-----
 tools/testing/selftests/net/txtimestamp.c               |  6 +++---
 tools/testing/selftests/netfilter/nft_meta.sh           |  2 +-
 48 files changed, 429 insertions(+), 134 deletions(-)
