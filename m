Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C034EDF98
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 19:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiCaR0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 13:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiCaR0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 13:26:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F7C1E95C1;
        Thu, 31 Mar 2022 10:24:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 250FC61673;
        Thu, 31 Mar 2022 17:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450A9C340ED;
        Thu, 31 Mar 2022 17:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648747464;
        bh=aJuLfk9j/afIhDgeOfYALpRAHgJkoHBAex1TGi/dfhs=;
        h=From:To:Cc:Subject:Date:From;
        b=FLZkpE0jk3t0ObQE0565XT1yu1fHqnnXPJzXCgGNflOcwFuFDtrAxf95U+5Q1Qcw9
         rwrekx6xPNqmht0xMOCJkRx2LzLXP6NYr/F7r8K8eOAGFK8Jwwxrse1c8cqdLton9k
         3lF7/xHGPFUpLBxIS/pLed4+seFpv1Xt1DPvLcNwm7hT6BSFRQfM+V9onXNLakHKsI
         gQOwWsQ7qDEJgjzyDqOys/HjjXMaC5x0l37A6cFh0nz9FMP/aROIra6YmZP2XwQ5ZJ
         3nMIR3uuQmGC7cXE2jpp3xkm+ScncmToT3vwSeNmpG/rQjoq0Lq9lMQikmAPgtvGZ0
         by7kjq5BTTf8Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.18-rc1
Date:   Thu, 31 Mar 2022 10:24:23 -0700
Message-Id: <20220331172423.3669039-1-kuba@kernel.org>
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

The following changes since commit d717e4cae0fe77e10a27e8545a967b8c379873ac:

  Merge tag 'net-5.18-rc0' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-03-28 17:02:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc1

for you to fetch changes up to 9d570741aec1e1ebd37823b34a2958f24809ff24:

  vxlan: do not feed vxlan_vnifilter_dump_dev with non vxlan devices (2022-03-31 08:53:01 -0700)

----------------------------------------------------------------
Networking fixes for 5.18-rc1 and rethook patches.

Features:

 - kprobes: rethook: x86: replace kretprobe trampoline with rethook

Current release - regressions:

 - sfc: avoid null-deref on systems without NUMA awareness
   in the new queue sizing code

Current release - new code bugs:

 - vxlan: do not feed vxlan_vnifilter_dump_dev with non-vxlan devices

 - eth: lan966x: fix null-deref on PHY pointer in timestamp ioctl
   when interface is down

Previous releases - always broken:

 - openvswitch: correct neighbor discovery target mask field
   in the flow dump

 - wireguard: ignore v6 endpoints when ipv6 is disabled and fix a leak

 - rxrpc: fix call timer start racing with call destruction

 - rxrpc: fix null-deref when security type is rxrpc_no_security

 - can: fix UAF bugs around echo skbs in multiple drivers

Misc:

 - docs: move netdev-FAQ to the "process" section of the documentation

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alexei Starovoitov (3):
      Merge branch 'fprobe: Fixes for Sparse and Smatch warnings'
      Merge branch 'kprobes: rethook: x86: Replace kretprobe trampoline with rethook'
      Merge branch 'xsk: another round of fixes'

Andrii Nakryiko (1):
      selftests/bpf: fix selftest after random: Urandom_read tracepoint removal

David Howells (1):
      rxrpc: Fix call timer start racing with call destruction

Duoming Zhou (2):
      ax25: fix UAF bug in ax25_send_control()
      ax25: Fix UAF bugs in ax25 timers

Eric Dumazet (1):
      vxlan: do not feed vxlan_vnifilter_dump_dev with non vxlan devices

Geliang Tang (1):
      bpf: Sync comments for bpf_get_stack

Guangbin Huang (1):
      net: hns3: fix software vlan talbe of vlan 0 inconsistent with hardware

Hangyu Hua (3):
      can: ems_usb: ems_usb_start_xmit(): fix double dev_kfree_skb() in error path
      can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in error path
      can: mcba_usb: mcba_usb_start_xmit(): fix double dev_kfree_skb in error path

Jakub Kicinski (17):
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'wireguard-patches-for-5-18-rc1'
      docs: netdev: replace references to old archives
      docs: netdev: minor reword
      docs: netdev: move the patch marking section up
      docs: netdev: turn the net-next closed into a Warning
      docs: netdev: note that RFC postings are allowed any time
      docs: netdev: shorten the name and mention msgid for patch status
      docs: netdev: rephrase the 'Under review' question
      docs: netdev: rephrase the 'should I update patchwork' question
      docs: netdev: add a question about re-posting frequency
      docs: netdev: make the testing requirement more stringent
      docs: netdev: add missing back ticks
      docs: netdev: call out the merge window in tag checking
      docs: netdev: broaden the new vs old code formatting guidelines
      docs: netdev: move the netdev-FAQ to the process pages
      Merge tag 'linux-can-fixes-for-5.18-20220331' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can

Jason A. Donenfeld (3):
      wireguard: queueing: use CFI-safe ptr_ring cleanup function
      wireguard: selftests: simplify RNG seeding
      wireguard: socket: ignore v6 endpoints when ipv6 is disabled

Jiri Olsa (1):
      bpftool: Fix generated code in codegen_asserts

Jonathan Lemon (1):
      ptp: ocp: handle error from nvmem_device_find

Maciej Fijalkowski (2):
      ice: xsk: Stop Rx processing when ntc catches ntu
      ice: xsk: Fix indexing in ice_tx_xsk_pool()

Magnus Karlsson (2):
      xsk: Do not write NULL in SW ring at allocation failure
      ice: xsk: Eliminate unnecessary loop iteration

Marc Kleine-Budde (2):
      can: m_can: m_can_tx_handler(): fix use after free of skb
      can: gs_usb: gs_make_candev(): fix memory leak for devices with extended bit timing configuration

Martin Habets (1):
      sfc: Avoid NULL pointer dereference on systems without numa awareness

Martin Varghese (1):
      openvswitch: Fixed nd target mask field in the flow dump.

Masami Hiramatsu (5):
      fprobe: Fix smatch type mismatch warning
      fprobe: Fix sparse warning for acccessing __rcu ftrace_hash
      kprobes: Use rethook for kretprobe if possible
      x86,rethook,kprobes: Replace kretprobe with rethook on x86
      x86,kprobes: Fix optprobe trampoline to generate complete pt_regs

Michael Walle (1):
      net: lan966x: fix kernel oops on ioctl when I/F is down

Milan Landaverde (1):
      bpf/bpftool: Add unprivileged_bpf_disabled check against value of 2

Oliver Hartkopp (1):
      can: isotp: restore accidentally removed MSG_PEEK feature

Paolo Abeni (3):
      Merge branch 'fix-uaf-bugs-caused-by-ax25_release'
      Merge branch 'docs-update-and-move-the-netdev-faq'
      Merge branch 'net-hns3-add-two-fixes-for-net'

Pavel Skripkin (1):
      can: mcba_usb: properly check endpoint type

Peter Zijlstra (1):
      x86,rethook: Fix arch_rethook_trampoline() to generate a complete pt_regs

Randy Dunlap (1):
      net: sparx5: uses, depends on BRIDGE or !BRIDGE

Stéphane Graber (1):
      openvswitch: Add recirc_id to recirc warning

Tom Rix (1):
      can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix return of error value

Vinod Koul (1):
      dt-bindings: net: qcom,ethqos: Document SM8150 SoC compatible

Wang Hai (1):
      wireguard: socket: free skb in send6 when ipv6 is disabled

Xiaolong Huang (1):
      rxrpc: fix some null-ptr-deref bugs in server_key.c

Yonghong Song (1):
      selftests/bpf: Fix clang compilation errors

Yufeng Mo (1):
      net: hns3: fix the concurrency between functions reading debugfs

Yuntao Wang (1):
      bpf: Fix maximum permitted number of arguments check

Zheng Yongjun (1):
      net: dsa: felix: fix possible NULL pointer dereference

 Documentation/bpf/bpf_devel_QA.rst                 |   2 +-
 .../devicetree/bindings/net/qcom,ethqos.txt        |   4 +-
 Documentation/networking/index.rst                 |   3 +-
 Documentation/process/maintainer-handbooks.rst     |   1 +
 .../maintainer-netdev.rst}                         | 114 ++++++++++--------
 MAINTAINERS                                        |   1 +
 arch/Kconfig                                       |   8 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/include/asm/unwind.h                      |  23 ++--
 arch/x86/kernel/Makefile                           |   1 +
 arch/x86/kernel/kprobes/common.h                   |   1 +
 arch/x86/kernel/kprobes/core.c                     | 107 -----------------
 arch/x86/kernel/kprobes/opt.c                      |  25 ++--
 arch/x86/kernel/rethook.c                          | 127 +++++++++++++++++++++
 arch/x86/kernel/unwind_orc.c                       |  10 +-
 drivers/net/can/m_can/m_can.c                      |   5 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   2 +-
 drivers/net/can/usb/ems_usb.c                      |   1 -
 drivers/net/can/usb/gs_usb.c                       |   2 +
 drivers/net/can/usb/mcba_usb.c                     |  27 +++--
 drivers/net/can/usb/usb_8dev.c                     |  30 +++--
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   4 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  15 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |   1 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   6 +-
 drivers/net/ethernet/intel/ice/ice.h               |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   5 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   3 +
 drivers/net/ethernet/microchip/sparx5/Kconfig      |   1 +
 drivers/net/ethernet/sfc/efx_channels.c            |  11 +-
 drivers/net/vxlan/vxlan_vnifilter.c                |   6 +
 drivers/net/wireguard/queueing.c                   |   3 +-
 drivers/net/wireguard/socket.c                     |   5 +-
 drivers/ptp/ptp_ocp.c                              |  15 +--
 include/linux/kprobes.h                            |  51 ++++++++-
 include/trace/events/rxrpc.h                       |   8 +-
 kernel/Makefile                                    |   1 +
 kernel/bpf/btf.c                                   |   2 +-
 kernel/kprobes.c                                   | 124 ++++++++++++++++----
 kernel/trace/fprobe.c                              |   8 +-
 kernel/trace/trace_kprobe.c                        |   4 +-
 net/ax25/af_ax25.c                                 |  13 ++-
 net/can/isotp.c                                    |   2 +-
 net/openvswitch/actions.c                          |   4 +-
 net/openvswitch/flow_netlink.c                     |   4 +-
 net/rxrpc/ar-internal.h                            |  15 ++-
 net/rxrpc/call_event.c                             |   2 +-
 net/rxrpc/call_object.c                            |  40 ++++++-
 net/rxrpc/server_key.c                             |   7 +-
 net/xdp/xsk_buff_pool.c                            |   8 +-
 tools/bpf/bpftool/feature.c                        |   5 +-
 tools/bpf/bpftool/gen.c                            |   2 +-
 tools/include/uapi/linux/bpf.h                     |   8 +-
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |   3 -
 .../selftests/bpf/progs/test_stacktrace_build_id.c |  12 +-
 tools/testing/selftests/bpf/test_lpm_map.c         |   3 +-
 tools/testing/selftests/wireguard/qemu/init.c      |  26 ++---
 58 files changed, 588 insertions(+), 337 deletions(-)
 rename Documentation/{networking/netdev-FAQ.rst => process/maintainer-netdev.rst} (75%)
 create mode 100644 arch/x86/kernel/rethook.c
