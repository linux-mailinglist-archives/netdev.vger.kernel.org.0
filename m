Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F173D569F9C
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 12:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbiGGKVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 06:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235003AbiGGKVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 06:21:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9451A2BFE
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 03:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657189303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2Ycw1zECzq4gnTY7RXP2JL3HSW+2VoZY5kcSb6tFb0Q=;
        b=jBeibS4KNvBYCqe8TE38hJEFGaiMkNK/a1JWF1NLWYGjDepK9Tsa44c8uFuOuwWFXT+tG3
        EeHen+RdCkcL8eS6cklYjL/Pp2mzaASTEyFv+Sz08y0UvFw3cOic6IFntH5cXxsPSyznLb
        tuwUDigoIdMq4PplzKHw9MWIjN/bFr0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-2IuL0U8gPamSaXLqmhfnag-1; Thu, 07 Jul 2022 06:21:42 -0400
X-MC-Unique: 2IuL0U8gPamSaXLqmhfnag-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD478811E76;
        Thu,  7 Jul 2022 10:21:41 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94CB7492C3B;
        Thu,  7 Jul 2022 10:21:40 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.19-rc6
Date:   Thu,  7 Jul 2022 12:21:25 +0200
Message-Id: <20220707102125.212793-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

No known regressions on our radar at this point.

The following changes since commit 5e8379351dbde61ea383e514f0f9ecb2c047cf4e:

  Merge tag 'net-5.19-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-06-30 15:26:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc6

for you to fetch changes up to 07266d066301b97ad56a693f81b29b7ced429b27:

  Merge branch 'wireguard-patches-for-5-19-rc6' (2022-07-06 20:04:10 -0700)

----------------------------------------------------------------
Networking fixes for 5.19-rc6, including fixes from bpf, netfilter,
can, bluetooth

Current release - regressions:
  - bluetooth: fix deadlock on hci_power_on_sync.

Previous releases - regressions:
  - sched: act_police: allow 'continue' action offload

  - eth: usbnet: fix memory leak in error case

  - eth: ibmvnic: properly dispose of all skbs during a failover.

Previous releases - always broken:
  - bpf:
    - fix insufficient bounds propagation from adjust_scalar_min_max_vals
    - clear page contiguity bit when unmapping pool

  - netfilter: nft_set_pipapo: release elements in clone from abort path

  - mptcp: netlink: issue MP_PRIO signals from userspace PMs

  - can:
    - rcar_canfd: fix data transmission failed on R-Car V3U
    - gs_usb: gs_usb_open/close(): fix memory leak

Misc:
  - add Wenjia as SMC maintainer

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Alexei Starovoitov (1):
      bpf, docs: Better scale maintenance of BPF subsystem

Daniel Borkmann (4):
      bpf: Fix incorrect verifier simulation around jmp32's jeq/jne
      bpf: Fix insufficient bounds propagation from adjust_scalar_min_max_vals
      bpf, selftests: Add verifier test case for imm=0,umin=0,umax=1 scalar
      bpf, selftests: Add verifier test case for jmp32's jeq/jne

David S. Miller (5):
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'netdev-docs'
      Merge branch 'act_police-continue-offload-fix'
      Merge branch 'mptcp-path-manager-fixes'

Duoming Zhou (1):
      net: rose: fix UAF bug caused by rose_t0timer_expiry

Duy Nguyen (1):
      can: rcar_canfd: Fix data transmission failed on R-Car V3U

Gal Pressman (1):
      Revert "tls: rx: move counting TlsDecryptErrors for sync"

Geliang Tang (1):
      mptcp: update MIB_RMSUBFLOW in cmd_sf_destroy

Hangbin Liu (1):
      selftests/net: fix section name when using xdp_dummy.o

Heiner Kallweit (1):
      r8169: fix accessing unset transport header

Ivan Malov (1):
      xsk: Clear page contiguity bit when unmapping pool

Jakub Kicinski (7):
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      docs: netdev: document that patch series length limit
      docs: netdev: document reverse xmas tree
      docs: netdev: add a cheat sheet for the rules
      Merge tag 'linux-can-fixes-for-5.19-20220704' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge tag 'for-net-2022-07-05' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge branch 'wireguard-patches-for-5-19-rc6'

Jason A. Donenfeld (5):
      wireguard: selftests: set fake real time in init
      wireguard: selftests: use virt machine on m68k
      wireguard: selftests: always call kernel makefile
      wireguard: selftests: use microvm on x86
      crypto: s390 - do not depend on CRYPTO_HW for SIMD implementations

Jimmy Assarsson (3):
      can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info
      can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression
      can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits

Karsten Graul (1):
      MAINTAINERS: add Wenjia as SMC maintainer

Kishen Maloor (2):
      mptcp: netlink: issue MP_PRIO signals from userspace PMs
      selftests: mptcp: userspace PM support for MP_PRIO signals

Li kunyu (1):
      net: usb: Fix typo in code

Liang He (1):
      can: grcan: grcan_probe(): remove extra of_node_get()

Lukasz Cieplicki (1):
      i40e: Fix dropped jumbo frames statistics

Marc Kleine-Budde (5):
      can: m_can: m_can_chip_config(): actually enable internal timestamping
      can: m_can: m_can_{read_fifo,echo_tx_event}(): shift timestamp to full 32 bits
      can: mcp251xfd: mcp251xfd_stop(): add missing hrtimer_cancel()
      can: mcp251xfd: mcp251xfd_register_get_dev_id(): use correct length to read dev_id
      can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix endianness conversion

Masami Hiramatsu (Google) (1):
      fprobe, samples: Add module parameter descriptions

Mat Martineau (2):
      mptcp: Avoid acquiring PM lock for subflow priority changes
      mptcp: Acquire the subflow socket lock before modifying MP_PRIO flags

Michael Walle (1):
      net: lan966x: hardcode the number of external ports

Norbert Zulinski (1):
      i40e: Fix VF's MAC Address change on VM

Oliver Hartkopp (1):
      can: bcm: use call_rcu() instead of costly synchronize_rcu()

Oliver Neukum (1):
      usbnet: fix memory leak in error case

Pablo Neira Ayuso (2):
      netfilter: nf_tables: stricter validation of element data
      netfilter: nft_set_pipapo: release elements in clone from abort path

Paolo Abeni (3):
      Merge branch 'fix-bridge_vlan_aware-sh-and-bridge_vlan_unaware-sh-with-iff_unicast_flt'
      mptcp: fix locking in mptcp_nl_cmd_sf_destroy()
      mptcp: fix local endpoint accounting

Rhett Aultman (1):
      can: gs_usb: gs_usb_open/close(): fix memory leak

Rick Lindsley (1):
      ibmvnic: Properly dispose of all skbs during a failover.

Srinivas Neeli (1):
      Revert "can: xilinx_can: Limit CANFD brp to 2"

Thomas Kopp (2):
      can: mcp251xfd: mcp251xfd_regmap_crc_read(): improve workaround handling for mcp2517fd
      can: mcp251xfd: mcp251xfd_regmap_crc_read(): update workaround broken CRC on TBC register

Vasyl Vavrychuk (1):
      Bluetooth: core: Fix deadlock on hci_power_on_sync.

Vlad Buslov (2):
      net/sched: act_police: allow 'continue' action offload
      net/mlx5e: Fix matchall police parameters validation

Vladimir Oltean (3):
      selftests: forwarding: fix flood_unicast_test when h2 supports IFF_UNICAST_FLT
      selftests: forwarding: fix learning_test when h1 supports IFF_UNICAST_FLT
      selftests: forwarding: fix error message in learning_test

Vladis Dronov (1):
      wireguard: Kconfig: select CRYPTO_CHACHA_S390

 Documentation/process/maintainer-netdev.rst        |  36 +++
 MAINTAINERS                                        | 116 +++++++--
 crypto/Kconfig                                     | 114 +++++++++
 drivers/crypto/Kconfig                             | 115 ---------
 drivers/net/Kconfig                                |   1 +
 drivers/net/can/grcan.c                            |   1 -
 drivers/net/can/m_can/m_can.c                      |   8 +-
 drivers/net/can/rcar/rcar_canfd.c                  |   5 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   6 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c   |  22 +-
 drivers/net/can/usb/gs_usb.c                       |  23 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h        |  25 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   | 285 ++++++++++++---------
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   | 119 +++++----
 drivers/net/can/xilinx_can.c                       |   4 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   9 +
 drivers/net/ethernet/intel/i40e/i40e.h             |  16 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  73 ++++++
 drivers/net/ethernet/intel/i40e/i40e_register.h    |  13 +
 drivers/net/ethernet/intel/i40e/i40e_type.h        |   1 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  13 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   8 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |   1 +
 drivers/net/ethernet/realtek/r8169_main.c          |  10 +-
 drivers/net/usb/catc.c                             |   2 +-
 drivers/net/usb/usbnet.c                           |  17 +-
 include/net/flow_offload.h                         |   1 +
 kernel/bpf/verifier.c                              | 113 ++++----
 net/bluetooth/hci_core.c                           |   3 +
 net/bluetooth/hci_sync.c                           |   1 -
 net/can/bcm.c                                      |  18 +-
 net/mptcp/options.c                                |   3 +
 net/mptcp/pm_netlink.c                             |  46 +++-
 net/mptcp/pm_userspace.c                           |  51 +++-
 net/mptcp/protocol.c                               |   9 +-
 net/mptcp/protocol.h                               |   9 +-
 net/netfilter/nf_tables_api.c                      |   9 +-
 net/netfilter/nft_set_pipapo.c                     |  48 ++--
 net/rose/rose_route.c                              |   4 +-
 net/sched/act_police.c                             |   2 +-
 net/tls/tls_sw.c                                   |   8 +-
 net/xdp/xsk_buff_pool.c                            |   1 +
 samples/fprobe/fprobe_example.c                    |   7 +
 tools/testing/selftests/bpf/verifier/jmp32.c       |  21 ++
 tools/testing/selftests/bpf/verifier/jump.c        |  22 ++
 tools/testing/selftests/net/forwarding/lib.sh      |   6 +-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c      |  73 +++++-
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |  32 +++
 tools/testing/selftests/net/udpgro.sh              |   2 +-
 tools/testing/selftests/net/udpgro_bench.sh        |   2 +-
 tools/testing/selftests/net/udpgro_frglist.sh      |   2 +-
 tools/testing/selftests/net/udpgro_fwd.sh          |   2 +-
 tools/testing/selftests/net/veth.sh                |   6 +-
 tools/testing/selftests/wireguard/qemu/Makefile    |  20 +-
 .../selftests/wireguard/qemu/arch/arm.config       |   1 +
 .../selftests/wireguard/qemu/arch/armeb.config     |   1 +
 .../selftests/wireguard/qemu/arch/i686.config      |   8 +-
 .../selftests/wireguard/qemu/arch/m68k.config      |  10 +-
 .../selftests/wireguard/qemu/arch/mips.config      |   1 +
 .../selftests/wireguard/qemu/arch/mipsel.config    |   1 +
 .../selftests/wireguard/qemu/arch/powerpc.config   |   1 +
 .../selftests/wireguard/qemu/arch/x86_64.config    |   7 +-
 tools/testing/selftests/wireguard/qemu/init.c      |  11 +
 65 files changed, 1089 insertions(+), 524 deletions(-)

