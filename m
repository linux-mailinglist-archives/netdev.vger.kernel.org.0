Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAA1617B65
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 12:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiKCLPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 07:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiKCLO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 07:14:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD31ECE39
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 04:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667474036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=grQuoVZO8/uFM5eFofAPEbGhKa2a6nKBUUr6rFmURGw=;
        b=cgS7MXCXzS04b9T12dOlz9l/ht/KQ81ESosP1dVvBnJ/KvqIcGeoQVFW2oEWs+0oDvZOz5
        P70OZp1Nm4h0+9OzLp9qXtajlt5RTfUlBgketYNvee9y0REQhhpdAKfeCYxljN9xdvyreE
        rtXqsgVtbcp3S3WZyZQjGasB88SJntM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-H6DVQeL7PdCV2PIbFsJ0Vg-1; Thu, 03 Nov 2022 07:13:50 -0400
X-MC-Unique: H6DVQeL7PdCV2PIbFsJ0Vg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FEFA801231;
        Thu,  3 Nov 2022 11:13:50 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D6044A9254;
        Thu,  3 Nov 2022 11:13:49 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.1-rc4
Date:   Thu,  3 Nov 2022 12:13:03 +0100
Message-Id: <20221103111303.57385-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 23758867219c8d84c8363316e6dd2f9fd7ae3049:

  Merge tag 'net-6.1-rc3-2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-10-27 13:36:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc4

for you to fetch changes up to 715aee0fde73d5ebac58e2339cef14f2da42e9e3:

  Merge branch 'vsock-remove-an-unused-variable-and-fix-infinite-sleep' (2022-11-03 10:49:32 +0100)

----------------------------------------------------------------
Networking fixes for 6.1-rc4, including fixes from bluetooth and
netfilter.

Current release - regressions:

  - net: several zerocopy flags fixes

  - netfilter: fix possible memory leak in nf_nat_init()

  - openvswitch: add missing .resv_start_op

Previous releases - regressions:

  - neigh: fix null-ptr-deref in neigh_table_clear()

  - sched: fix use after free in red_enqueue()

  - dsa: fall back to default tagger if we can't load the one from DT

  - bluetooth: fix use-after-free in l2cap_conn_del()

Previous releases - always broken:

  - netfilter: netlink notifier might race to release objects

  - nfc: fix potential memory leak of skb

  - bluetooth: fix use-after-free caused by l2cap_reassemble_sdu

  - bluetooth: use skb_put to set length

  - eth: tun: fix bugs for oversize packet when napi frags enabled

  - eth: lan966x: fixes for when MTU is changed

  - eth: dwmac-loongson: fix invalid mdio_node

----------------------------------------------------------------
Alexandru Tachici (1):
      net: ethernet: adi: adin1110: Fix notifiers

Chen Zhongjin (4):
      net: dsa: Fix possible memory leaks in dsa_loop_init()
      netfilter: nf_nat: Fix possible memory leak in nf_nat_init()
      net/smc: Fix possible leaked pernet namespace in smc_init()
      net, neigh: Fix null-ptr-deref in neigh_table_clear()

Christophe JAILLET (1):
      sfc: Fix an error handling path in efx_pci_probe()

Dan Carpenter (1):
      net: sched: Fix use after free in red_enqueue()

David S. Miller (2):
      Merge branch 'nfc-skb-leaks'
      Merge branch 'misdn-fixes'

Dexuan Cui (2):
      vsock: remove the unused 'wait' in vsock_connectible_recvmsg()
      vsock: fix possible infinite sleep in vsock_connectible_wait_data()

Florian Westphal (1):
      netlink: introduce bigendian integer types

Gaosheng Cui (1):
      net: mdio: fix undefined behavior in bit shift for __mdiobus_register

Govindarajulu Varadarajan (1):
      enic: MAINTAINERS: Update enic maintainers

Hawkins Jiawei (1):
      Bluetooth: L2CAP: Fix memory leak in vhci_write

Horatiu Vultur (4):
      net: lan966x: Fix the MTU calculation
      net: lan966x: Adjust maximum frame size when vlan is enabled/disabled
      net: lan966x: Fix FDMA when MTU is changed
      net: lan966x: Fix unmapping of received frames using FDMA

Ido Schimmel (1):
      bridge: Fix flushing of dynamic FDB entries

Jakub Kicinski (6):
      netlink: hide validation union fields from kdoc
      net: openvswitch: add missing .resv_start_op
      Merge branch 'a-few-corrections-for-sock_support_zc'
      Merge branch 'net-lan966x-fixes-for-when-mtu-is-changed'
      Merge tag 'for-net-2022-10-02' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

Jason A. Donenfeld (1):
      ipvs: use explicitly signed chars

Jozsef Kadlecsik (1):
      netfilter: ipset: enforce documented limit to prevent allocating huge memory

Liu Peibao (1):
      stmmac: dwmac-loongson: fix invalid mdio_node

Luiz Augusto von Dentz (4):
      Bluetooth: hci_conn: Fix not restoring ISO buffer count on disconnect
      Bluetooth: L2CAP: Fix accepting connection request for invalid SPSM
      Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
      Bluetooth: L2CAP: Fix attempting to access uninitialized memory

Maxim Mikityanskiy (1):
      Bluetooth: L2CAP: Fix use-after-free caused by l2cap_reassemble_sdu

Nick Child (1):
      ibmvnic: Free rwi on reset success

Pablo Neira Ayuso (2):
      netfilter: nf_tables: netlink notifier might race to release objects
      netfilter: nf_tables: release flow rule object from commit path

Paolo Abeni (1):
      Merge branch 'vsock-remove-an-unused-variable-and-fix-infinite-sleep'

Pauli Virtanen (1):
      Bluetooth: hci_conn: Fix CIS connection dst_type handling

Pavel Begunkov (3):
      udp: advertise ipv6 udp support for msghdr::ubuf_info
      net: remove SOCK_SUPPORT_ZC from sockmap
      net/ulp: remove SOCK_SUPPORT_ZC from tls sockets

Radhey Shyam Pandey (1):
      net: emaclite: update reset_lock member documentation

Rick Lindsley (1):
      ibmvnic: change maintainers for vnic driver

Shang XiaoJing (4):
      nfc: fdp: Fix potential memory leak in fdp_nci_send()
      nfc: nxp-nci: Fix potential memory leak in nxp_nci_send()
      nfc: s3fwrn5: Fix potential memory leak in s3fwrn5_nci_send()
      nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()

Soenke Huster (1):
      Bluetooth: virtio_bt: Use skb_put to set length

Stefan Metzmacher (1):
      net: also flag accepted sockets supporting msghdr originated zerocopy

Vladimir Oltean (1):
      net: dsa: fall back to default tagger if we can't load the one from DT

Yang Yingliang (2):
      mISDN: fix possible memory leak in mISDN_register_device()
      isdn: mISDN: netjet: fix wrong check of device registration

Zhang Changzhong (1):
      net: fec: fix improper use of NETDEV_TX_BUSY

Zhang Qilong (1):
      rose: Fix NULL pointer dereference in rose_send_frame()

Zhengchao Shao (4):
      ipvs: fix WARNING in __ip_vs_cleanup_batch()
      ipvs: fix WARNING in ip_vs_app_net_cleanup()
      Bluetooth: L2CAP: fix use-after-free in l2cap_conn_del()
      ipv6: fix WARNING in ip6_route_net_exit_late()

Ziyang Xuan (1):
      net: tun: fix bugs for oversize packet when napi frags enabled

 MAINTAINERS                                        |  7 +-
 drivers/bluetooth/virtio_bt.c                      |  2 +-
 drivers/isdn/hardware/mISDN/netjet.c               |  2 +-
 drivers/isdn/mISDN/core.c                          |  5 +-
 drivers/net/dsa/dsa_loop.c                         | 25 +++++--
 drivers/net/ethernet/adi/adin1110.c                | 38 +++++++---
 drivers/net/ethernet/freescale/fec_main.c          |  4 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 | 16 ++--
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  | 26 +++++--
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |  4 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |  2 +
 .../net/ethernet/microchip/lan966x/lan966x_regs.h  | 15 ++++
 .../net/ethernet/microchip/lan966x/lan966x_vlan.c  |  6 ++
 drivers/net/ethernet/sfc/efx.c                     |  8 +-
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |  7 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |  2 +-
 drivers/net/phy/mdio_bus.c                         |  2 +-
 drivers/net/tun.c                                  |  3 +-
 drivers/nfc/fdp/fdp.c                              | 10 ++-
 drivers/nfc/nfcmrvl/i2c.c                          |  7 +-
 drivers/nfc/nxp-nci/core.c                         |  7 +-
 drivers/nfc/s3fwrn5/core.c                         |  8 +-
 include/net/netlink.h                              | 48 ++++++------
 include/net/sock.h                                 |  7 ++
 lib/nlattr.c                                       | 41 ++++-------
 net/bluetooth/hci_conn.c                           | 18 +++--
 net/bluetooth/iso.c                                | 14 +++-
 net/bluetooth/l2cap_core.c                         | 86 ++++++++++++++++++----
 net/bridge/br_netlink.c                            |  2 +-
 net/bridge/br_sysfs_br.c                           |  2 +-
 net/core/neighbour.c                               |  2 +-
 net/dsa/dsa2.c                                     | 13 +++-
 net/ipv4/af_inet.c                                 |  2 +
 net/ipv4/tcp_bpf.c                                 |  4 +-
 net/ipv4/tcp_ulp.c                                 |  3 +
 net/ipv4/udp_bpf.c                                 |  4 +-
 net/ipv6/route.c                                   | 14 +++-
 net/ipv6/udp.c                                     |  1 +
 net/netfilter/ipset/ip_set_hash_gen.h              | 30 ++------
 net/netfilter/ipvs/ip_vs_app.c                     | 10 ++-
 net/netfilter/ipvs/ip_vs_conn.c                    | 30 ++++++--
 net/netfilter/nf_nat_core.c                        | 11 ++-
 net/netfilter/nf_tables_api.c                      |  8 +-
 net/netfilter/nft_payload.c                        |  6 +-
 net/openvswitch/datapath.c                         |  1 +
 net/rose/rose_link.c                               |  3 +
 net/sched/sch_red.c                                |  4 +-
 net/smc/af_smc.c                                   |  6 +-
 net/unix/unix_bpf.c                                |  8 +-
 net/vmw_vsock/af_vsock.c                           |  7 +-
 50 files changed, 401 insertions(+), 190 deletions(-)

