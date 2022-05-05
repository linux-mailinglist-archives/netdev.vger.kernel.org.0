Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB39651BD45
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 12:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355781AbiEEKfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 06:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238250AbiEEKfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 06:35:11 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A101210FEC
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 03:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651746690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Y2f31+KLvcVlSUSW7RUeEuI1kWt5V/CnuS4tzxxow8s=;
        b=eynLhft1MxTjwObgfX1KBcCIZFYe50mdEuz7W8udLSeax8NFoe1uM6eBxjVZ4LhBnKF66N
        cyZNH0rU0L3PHLSnahyxwCFTbHmfl4PSBUJRTGg2g4OanWNpty5vtxQsTqulruiO1vimZe
        og7PIdld+luGYdJKzZq4k1Bj43zYxu8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-OgeasoXBPPudDTU8CYBkMQ-1; Thu, 05 May 2022 06:31:25 -0400
X-MC-Unique: OgeasoXBPPudDTU8CYBkMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22135803D4E;
        Thu,  5 May 2022 10:31:25 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DABA3111DCF2;
        Thu,  5 May 2022 10:31:23 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.18-rc6
Date:   Thu,  5 May 2022 12:31:11 +0200
Message-Id: <20220505103111.20628-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 249aca0d3d631660aa3583c6a3559b75b6e971b4:

  Merge tag 'net-5.18-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-04-28 12:34:50 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc6

for you to fetch changes up to 4071bf121d59944d5cd2238de0642f3d7995a997:

  NFC: netlink: fix sleep in atomic bug when firmware download timeout (2022-05-05 10:18:15 +0200)

----------------------------------------------------------------
Networking fixes for 5.18-rc6, including fixes from can, rxrpc and
wireguard

Previous releases - regressions:
  - igmp: respect RCU rules in ip_mc_source() and ip_mc_msfilter()

  - mld: respect RCU rules in ip6_mc_source() and ip6_mc_msfilter()

  - rds: acquire netns refcount on TCP sockets

  - rxrpc: enable IPv6 checksums on transport socket

  - nic: hinic: fix bug of wq out of bound access

  - nic: thunder: don't use pci_irq_vector() in atomic context

  - nic: bnxt_en: fix possible bnxt_open() failure caused by wrong RFS flag

  - nic: mlx5e:
    - lag, fix use-after-free in fib event handler
    - fix deadlock in sync reset flow

Previous releases - always broken:
  - tcp: fix insufficient TCP source port randomness

  - can: grcan: grcan_close(): fix deadlock

  - nfc: reorder destructive operations in to avoid bugs

Misc:
  - wireguard: improve selftests reliability

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Andreas Larsson (2):
      can: grcan: grcan_probe(): fix broken system id check for errata workaround needs
      can: grcan: only use the NAPI poll budget for RX

Ariel Levkovich (4):
      net/mlx5e: Fix wrong source vport matching on tunnel rule
      net/mlx5e: TC, Fix ct_clear overwriting ct action metadata
      net/mlx5e: TC, fix decap fallback to uplink when int port not supported
      net/mlx5e: Avoid checking offload capability in post_parse action

Arun Ramadoss (1):
      net: dsa: ksz9477: port mirror sniffing limited to one port

Aya Levin (1):
      net/mlx5: Fix slab-out-of-bounds while reading resource dump menu

Daniel Hellstrom (1):
      can: grcan: use ofdev->dev when allocating DMA memory

David Howells (1):
      rxrpc: Enable IPv6 checksums on transport socket

David S. Miller (2):
      Merge branch 'nfc-fixes'
      Merge tag 'mlx5-fixes-2022-05-03' of git://git.kernel.org/pub/scm/linux/kernel/g it/saeed/linux

Duoming Zhou (4):
      can: grcan: grcan_close(): fix deadlock
      nfc: replace improper check device_is_registered() in netlink related functions
      nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs
      NFC: netlink: fix sleep in atomic bug when firmware download timeout

Eric Dumazet (3):
      net: igmp: respect RCU rules in ip_mc_source() and ip_mc_msfilter()
      mld: respect RCU rules in ip6_mc_source() and ip6_mc_msfilter()
      tcp: resalt the secret every 10 seconds

Hangbin Liu (2):
      selftests/net: add missing tests to Makefile
      selftests/net/forwarding: add missing tests to Makefile

Ido Schimmel (1):
      selftests: mirror_gre_bridge_1q: Avoid changing PVID while interface is operational

Jakub Kicinski (5):
      Merge tag 'linux-can-fixes-for-5.18-20220429' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'selftests-net-add-missing-tests-to-makefile'
      Merge branch 'bnxt_en-bug-fixes'
      Merge branch 'wireguard-patches-for-5-18-rc6'
      Merge branch 'insufficient-tcp-source-port-randomness'

Jason A. Donenfeld (6):
      wireguard: selftests: make routing loop test non-fatal
      wireguard: selftests: limit parallelism to $(nproc) tests at once
      wireguard: selftests: use newer toolchains to fill out architectures
      wireguard: selftests: restore support for ccache
      wireguard: selftests: bump package deps
      wireguard: selftests: set panic_on_warn=1 from cmdline

Marc Kleine-Budde (2):
      selftests/net: so_txtime: fix parsing of start time stamp on 32 bit systems
      selftests/net: so_txtime: usage(): fix documentation of default clock

Mark Bloch (1):
      net/mlx5: Fix matching on inner TTC

Mark Zhang (1):
      net/mlx5e: Fix the calling of update_buffer_lossy() API

Matthew Hagan (1):
      net: sfp: Add tx-fault workaround for Huawei MA5671A SFP ONT

Michael Chan (2):
      bnxt_en: Initiallize bp->ptp_lock first before using it
      bnxt_en: Fix unnecessary dropping of RX packets

Moshe Shemesh (2):
      net/mlx5: Fix deadlock in sync reset flow
      net/mlx5: Avoid double clear or set of sync reset requested

Moshe Tal (1):
      net/mlx5e: Fix trust state reset in reload

Niels Dossche (1):
      net: mdio: Fix ENOMEM return value in BCM6368 mux bus controller

Oliver Hartkopp (1):
      can: isotp: remove re-binding of bound socket

Paolo Abeni (1):
      Merge branch 'emaclite-improve-error-handling-and-minor-cleanup'

Paul Blakey (1):
      net/mlx5e: CT: Fix queued up restore put() executing after relevant ft release

Qiao Ma (1):
      hinic: fix bug of wq out of bound access

Russell King (Oracle) (1):
      net: dsa: b53: convert to phylink_pcs

Sergey Shtylyov (1):
      smsc911x: allow using IRQ0

Shravya Kumbham (2):
      net: emaclite: Don't advertise 1000BASE-T and do auto negotiation
      net: emaclite: Add error handling for of_address_to_resource()

Somnath Kotur (1):
      bnxt_en: Fix possible bnxt_open() failure caused by wrong RFS flag

Tan Tee Min (1):
      net: stmmac: disable Split Header (SPH) for Intel platforms

Tetsuo Handa (1):
      net: rds: acquire refcount on TCP sockets

Thomas Gleixner (1):
      pci_irq_vector() can't be used in atomic context any longer. This conflicts with the usage of this function in nic_mbx_intr_handler().

Vlad Buslov (4):
      net/mlx5e: Don't match double-vlan packets if cvlan is not set
      net/mlx5e: Lag, Fix use-after-free in fib event handler
      net/mlx5e: Lag, Fix fib_info pointer assignment
      net/mlx5e: Lag, Don't skip fib events on current dst

Vladimir Oltean (1):
      selftests: ocelot: tc_flower_chains: specify conform-exceed action for policer

Willy Tarreau (6):
      secure_seq: use the 64 bits of the siphash for port offset calculation
      tcp: use different parts of the port_offset for index and offset
      tcp: add small random increments to the source port
      tcp: dynamically allocate the perturb table used by source ports
      tcp: increase source port perturb table to 2^16
      tcp: drop the hash_32() part from the index calculation

Yang Yingliang (4):
      net: ethernet: mediatek: add missing of_node_put() in mtk_sgmii_init()
      net: dsa: mt7530: add missing of_node_put() in mt7530_setup()
      net: stmmac: dwmac-sun8i: add missing of_node_put() in sun8i_dwmac_register_mdio_mux()
      net: cpsw: add missing of_node_put() in cpsw_probe_dt()

 drivers/net/can/grcan.c                            |  46 ++---
 drivers/net/dsa/b53/b53_common.c                   |  36 +---
 drivers/net/dsa/b53/b53_priv.h                     |  24 +--
 drivers/net/dsa/b53/b53_serdes.c                   |  74 +++++---
 drivers/net/dsa/b53/b53_serdes.h                   |   9 +-
 drivers/net/dsa/b53/b53_srab.c                     |   4 +-
 drivers/net/dsa/microchip/ksz9477.c                |  38 +++-
 drivers/net/dsa/mt7530.c                           |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  13 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |  15 +-
 drivers/net/ethernet/cavium/thunder/nic_main.c     |  16 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c    |   7 +-
 drivers/net/ethernet/mediatek/mtk_sgmii.c          |   1 +
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.c    |  31 +++-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |   4 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c |  34 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  24 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |  11 ++
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  10 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  11 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  60 +++---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   |  38 ++--
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h   |   7 +-
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c   |   2 +
 drivers/net/ethernet/smsc/smsc911x.c               |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |   5 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |  30 ++-
 drivers/net/mdio/mdio-mux-bcm6368.c                |   2 +-
 drivers/net/phy/sfp.c                              |  12 +-
 drivers/nfc/nfcmrvl/main.c                         |   2 +-
 include/linux/stmmac.h                             |   1 +
 include/net/inet_hashtables.h                      |   2 +-
 include/net/secure_seq.h                           |   4 +-
 net/can/isotp.c                                    |  25 +--
 net/core/secure_seq.c                              |  16 +-
 net/ipv4/igmp.c                                    |   9 +-
 net/ipv4/inet_hashtables.c                         |  42 +++--
 net/ipv6/inet6_hashtables.c                        |   4 +-
 net/ipv6/mcast.c                                   |   8 +-
 net/nfc/core.c                                     |  29 ++-
 net/nfc/netlink.c                                  |   4 +-
 net/rds/tcp.c                                      |   8 +
 net/rxrpc/local_object.c                           |   3 +
 .../drivers/net/ocelot/tc_flower_chains.sh         |   2 +-
 tools/testing/selftests/net/Makefile               |   3 +-
 tools/testing/selftests/net/forwarding/Makefile    |  33 ++++
 .../net/forwarding/mirror_gre_bridge_1q.sh         |   3 +
 tools/testing/selftests/net/so_txtime.c            |   4 +-
 tools/testing/selftests/wireguard/netns.sh         |  34 ++--
 tools/testing/selftests/wireguard/qemu/.gitignore  |   1 +
 tools/testing/selftests/wireguard/qemu/Makefile    | 205 ++++++++++++++-------
 .../selftests/wireguard/qemu/arch/aarch64.config   |   5 +-
 .../wireguard/qemu/arch/aarch64_be.config          |   5 +-
 .../selftests/wireguard/qemu/arch/arm.config       |   5 +-
 .../selftests/wireguard/qemu/arch/armeb.config     |   5 +-
 .../selftests/wireguard/qemu/arch/i686.config      |   2 +-
 .../selftests/wireguard/qemu/arch/m68k.config      |   2 +-
 .../selftests/wireguard/qemu/arch/mips.config      |   2 +-
 .../selftests/wireguard/qemu/arch/mips64.config    |   2 +-
 .../selftests/wireguard/qemu/arch/mips64el.config  |   2 +-
 .../selftests/wireguard/qemu/arch/mipsel.config    |   2 +-
 .../selftests/wireguard/qemu/arch/powerpc.config   |   2 +-
 .../selftests/wireguard/qemu/arch/powerpc64.config |  13 ++
 .../wireguard/qemu/arch/powerpc64le.config         |   2 +-
 .../selftests/wireguard/qemu/arch/riscv32.config   |  12 ++
 .../selftests/wireguard/qemu/arch/riscv64.config   |  12 ++
 .../selftests/wireguard/qemu/arch/s390x.config     |   6 +
 .../selftests/wireguard/qemu/arch/x86_64.config    |   2 +-
 tools/testing/selftests/wireguard/qemu/init.c      |   6 -
 76 files changed, 724 insertions(+), 386 deletions(-)
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/powerpc64.config
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/riscv32.config
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/riscv64.config
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/s390x.config

