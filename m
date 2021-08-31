Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13AD3FCEA5
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 22:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241085AbhHaUia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 16:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230236AbhHaUi3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 16:38:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3D346103A;
        Tue, 31 Aug 2021 20:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630442253;
        bh=HqDHY/NJb4JG7DUu4BCr/dNuvqxYvfNUwmuXSEYw19I=;
        h=From:To:Cc:Subject:Date:From;
        b=o5lzt4EuazslNdcyajS0n9r84FqW2cA+TZ4QZtVOWQ6P2ZMJ133ShmGfIBE+pinyG
         BSI9/Mdr+sv5uzzar5jlGlCUVjZKG1puQYZytWa9fY+XvqtSCTz1sji2Ho5YAhZ1Hk
         rhxZ5rJtm8zTxPdtBveMIkfMorJdhVl0b143POBf3pNOGSVSjxLtxSVpHB5V3bsyrs
         wvvD2fEhWa8NKOTetAZj6w0pkm+6wrmURwUkWGI0vO1CsjIghXPErZcHMciHab6avx
         u+mJshiuIw0HrXcKHNTEBLTRKCTy+Z085YPlVu6UB8wS+zfO6HiizeEkDxGFjBbFwX
         qwyhV8mcjOESg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [GIT PULL] Networking for v5.15
Date:   Tue, 31 Aug 2021 13:37:27 -0700
Message-Id: <20210831203727.3852294-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

No conflicts at the time of writing. There were conflicts with
char-misc but I believe Greg dropped the commits in question.

The following changes since commit 73367f05b25dbd064061aee780638564d15b01d1:

  Merge tag 'nfsd-5.14-1' of git://linux-nfs.org/~bfields/linux (2021-08-26 13:26:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-5.15

for you to fetch changes up to 29ce8f9701072fc221d9c38ad952de1a9578f95c:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-08-31 09:06:04 -0700)

----------------------------------------------------------------
Core:

 - Enable memcg accounting for various networking objects.

BPF:

 - Introduce bpf timers.

 - Add perf link and opaque bpf_cookie which the program can read
   out again, to be used in libbpf-based USDT library.

 - Add bpf_task_pt_regs() helper to access user space pt_regs
   in kprobes, to help user space stack unwinding.

 - Add support for UNIX sockets for BPF sockmap.

 - Extend BPF iterator support for UNIX domain sockets.

 - Allow BPF TCP congestion control progs and bpf iterators to call
   bpf_setsockopt(), e.g. to switch to another congestion control
   algorithm.

Protocols:

 - Support IOAM Pre-allocated Trace with IPv6.

 - Support Management Component Transport Protocol.

 - bridge: multicast: add vlan support.

 - netfilter: add hooks for the SRv6 lightweight tunnel driver.

 - tcp:
    - enable mid-stream window clamping (by user space or BPF)
    - allow data-less, empty-cookie SYN with TFO_SERVER_COOKIE_NOT_REQD
    - more accurate DSACK processing for RACK-TLP

 - mptcp:
    - add full mesh path manager option
    - add partial support for MP_FAIL
    - improve use of backup subflows
    - optimize option processing

 - af_unix: add OOB notification support.

 - ipv6: add IFLA_INET6_RA_MTU to expose MTU value advertised by
         the router.

 - mac80211: Target Wake Time support in AP mode.

 - can: j1939: extend UAPI to notify about RX status.

Driver APIs:

 - Add page frag support in page pool API.

 - Many improvements to the DSA (distributed switch) APIs.

 - ethtool: extend IRQ coalesce uAPI with timer reset modes.

 - devlink: control which auxiliary devices are created.

 - Support CAN PHYs via the generic PHY subsystem.

 - Proper cross-chip support for tag_8021q.

 - Allow TX forwarding for the software bridge data path to be
   offloaded to capable devices.

Drivers:

 - veth: more flexible channels number configuration.

 - openvswitch: introduce per-cpu upcall dispatch.

 - Add internet mix (IMIX) mode to pktgen.

 - Transparently handle XDP operations in the bonding driver.

 - Add LiteETH network driver.

 - Renesas (ravb):
   - support Gigabit Ethernet IP

 - NXP Ethernet switch (sja1105)
   - fast aging support
   - support for "H" switch topologies
   - traffic termination for ports under VLAN-aware bridge

 - Intel 1G Ethernet
    - support getcrosststamp() with PCIe PTM (Precision Time
      Measurement) for better time sync
    - support Credit-Based Shaper (CBS) offload, enabling HW traffic
      prioritization and bandwidth reservation

 - Broadcom Ethernet (bnxt)
    - support pulse-per-second output
    - support larger Rx rings

 - Mellanox Ethernet (mlx5)
    - support ethtool RSS contexts and MQPRIO channel mode
    - support LAG offload with bridging
    - support devlink rate limit API
    - support packet sampling on tunnels

 - Huawei Ethernet (hns3):
    - basic devlink support
    - add extended IRQ coalescing support
    - report extended link state

 - Netronome Ethernet (nfp):
    - add conntrack offload support

 - Broadcom WiFi (brcmfmac):
    - add WPA3 Personal with FT to supported cipher suites
    - support 43752 SDIO device

 - Intel WiFi (iwlwifi):
    - support scanning hidden 6GHz networks
    - support for a new hardware family (Bz)

 - Xen pv driver:
    - harden netfront against malicious backends

 - Qualcomm mobile
    - ipa: refactor power management and enable automatic suspend
    - mhi: move MBIM to WWAN subsystem interfaces

Refactor:

 - Ambient BPF run context and cgroup storage cleanup.

 - Compat rework for ndo_ioctl.

Old code removal:

 - prism54 remove the obsoleted driver, deprecated by the p54 driver.

 - wan: remove sbni/granch driver.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aaron Ma (1):
      Bluetooth: btusb: Add support for Foxconn Mediatek Chip

Abhishek Naik (1):
      iwlwifi: skip first element in the WTAS ACPI table

Ahmad Fatoum (1):
      brcmfmac: pcie: fix oops on failure to resume and reprobe

Alan Maguire (10):
      libbpf: Allow specification of "kprobe/function+offset"
      libbpf: BTF dumper support for typed data
      selftests/bpf: Add ASSERT_STRNEQ() variant for test_progs
      selftests/bpf: Add dump type data tests to btf dump tests
      libbpf: Clarify/fix unaligned data issues for btf typed dump
      libbpf: Fix compilation errors on ppc64le for btf dump typed data
      libbpf: Btf typed dump does not need to allocate dump data
      libbpf: Avoid use of __int128 in typed dump display
      selftests/bpf: Add __int128-specific tests for typed data dump
      libbpf: Propagate errors when retrieving enum value for typed data display

Alex Elder (61):
      net: ipa: fix IPA v4.11 interconnect data
      dt-bindings: net: qcom,ipa: make imem interconnect optional
      arm64: dts: qcom: sc7280: add IPA information
      arm64: dts: qcom: sc7180: define ipa_fw_mem node
      net: ipa: fix ipa_cmd_table_valid()
      net: ipa: always validate filter and route tables
      net: ipa: kill the remaining conditional validation code
      net: ipa: use WARN_ON() rather than assertions
      net: ipa: enable inline checksum offload for IPA v4.5+
      net: ipa: kill ipa_modem_setup()
      net: ipa: configure memory regions early
      net: ipa: set up IPA interrupts earlier
      net: ipa: set up the microcontroller earlier
      net: ipa: introduce ipa_uc_clock()
      net: ipa: make IPA interrupt handler threaded only
      net: ipa: clear disabled IPA interrupt conditions
      net: ipa: get rid of some unneeded IPA interrupt code
      net: ipa: kill ipa_interrupt_process_all()
      net: ipa: get clock in ipa_probe()
      net: ipa: get another clock for ipa_setup()
      net: ipa: add clock reference for remoteproc SSR
      net: ipa: add a clock reference for netdev operations
      net: ipa: don't suspend endpoints if setup not complete
      Revert "Merge branch 'qcom-dts-updates'"
      net: ipa: use gsi->version for channel suspend/resume
      net: ipa: move version check for channel suspend/resume
      net: ipa: move some GSI setup functions
      net: ipa: have gsi_irq_setup() return an error code
      net: ipa: move gsi_irq_init() code into setup
      net: ipa: disable GSI interrupts while suspended
      net: ipa: fix IPA v4.9 interconnects
      net: ipa: don't suspend/resume modem if not up
      net: ipa: reorder netdev pointer assignments
      net: ipa: improve IPA clock error messages
      net: ipa: move IPA power operations to ipa_clock.c
      net: ipa: move ipa_suspend_handler()
      net: ipa: move IPA flags field
      net: ipa: have ipa_clock_get() return a value
      net: ipa: disable clock in suspend
      net: ipa: resume in ipa_clock_get()
      net: ipa: use runtime PM core
      net: ipa: get rid of extra clock reference
      net: ipa: kill IPA clock reference count
      net: ipa: kill ipa_clock_get_additional()
      net: ipa: always inline ipa_aggr_granularity_val()
      dt-bindings: net: qcom,ipa: make imem interconnect optional
      net: ipa: enable wakeup in ipa_power_setup()
      net: ipa: distinguish system from runtime suspend
      net: ipa: re-enable transmit in PM WQ context
      net: ipa: ensure hardware has power in ipa_start_xmit()
      net: ipa: don't stop TX on suspend
      net: ipa: don't hold clock reference while netdev open
      net: ipa: fix TX queue race
      net: ipa: don't use ipa_clock_get() in "ipa_main.c"
      net: ipa: don't use ipa_clock_get() in "ipa_smp2p.c"
      net: ipa: don't use ipa_clock_get() in "ipa_uc.c"
      net: ipa: don't use ipa_clock_get() in "ipa_modem.c"
      net: ipa: kill ipa_clock_get()
      net: ipa: use autosuspend
      net: ipa: rename ipa_clock_* symbols
      net: ipa: rename "ipa_clock.c"

Alexandra Winter (3):
      s390/qeth: Register switchdev event handler
      s390/qeth: Switchdev event handler
      s390/qeth: Update MACs of LEARNING_SYNC device

Alexei Starovoitov (27):
      Merge branch 'bpf: support input xdp_md context in BPF_PROG_TEST_RUN'
      Merge branch 'Generic XDP improvements'
      bpf: Sync tools/include/uapi/linux/bpf.h
      bpf: Prepare bpf_prog_put() to be called from irq context.
      bpf: Factor out bpf_spin_lock into helpers.
      bpf: Introduce bpf timers.
      bpf: Add map side support for bpf timers.
      bpf: Prevent pointer mismatch in bpf_timer_init.
      bpf: Remember BTF of inner maps.
      bpf: Relax verifier recursion check.
      bpf: Implement verifier support for validation of async callbacks.
      bpf: Teach stack depth check about async callbacks.
      selftests/bpf: Add bpf_timer test.
      selftests/bpf: Add a test with bpf_timer in inner map.
      Merge branch 'Add bpf_get_func_ip helper'
      Merge branch 'sockmap: add sockmap support for unix datagram socket'
      libbpf: Cleanup the layering between CORE and bpf_program.
      libbpf: Split bpf_core_apply_relo() into bpf_program independent helper.
      libbpf: Move CO-RE types into relo_core.h.
      libbpf: Split CO-RE logic into relo_core.c.
      Merge branch 'Refactor cgroup_bpf internals to use more specific attach_type'
      Merge branch 'selftests/bpf: minor fixups'
      Merge branch 'bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SK_MSG'
      Merge branch 'Improve XDP samples usability and output'
      Merge branch 'bpf: Add bpf_task_pt_regs() helper'
      Merge branch 'selftests: xsk: various simplifications'
      Merge branch 'bpf: tcp: Allow bpf-tcp-cc to call bpf_(get|set)sockopt'

Alok Prasad (1):
      qed: Enable automatic recovery on error condition.

Amit Cohen (4):
      mlxsw: spectrum: Add infrastructure for parsing configuration
      mlxsw: Convert existing consumers to use new API for parsing configuration
      mlxsw: Remove old parsing depth infrastructure
      mlxsw: spectrum_router: Increase parsing depth for multipath hash

Andrey Ignatov (1):
      bpf: Fix possible out of bound write in narrow load handling

Andrii Nakryiko (33):
      bpf: Add ambient BPF runtime context stored in current
      Merge branch 'Add btf_custom_path in bpf_obj_open_opts'
      Merge branch 'libbpf: BTF dumper support for typed data'
      Merge branch 'libbpf: BTF typed dump cleanups'
      Merge branch 'libbpf: btf typed data dumping fixes (__int128 usage, error propagation)'
      Merge branch 'bpf: Allow bpf tcp iter to do bpf_(get|set)sockopt'
      Merge branch 'libbpf: Move CO-RE logic into separate file.'
      Merge branch 'libbpf: rename btf__get_from_id() and btf__load() APIs, support split BTF'
      Merge branch 'tools: bpftool: update, synchronise and validate types and options'
      bpf: Fix bpf_prog_test_run_xdp logic after incorrect merge resolution
      selftests/bpf: Rename reference_tracking BPF programs
      Merge branch 'samples/bpf: xdpsock: Minor enhancements'
      Merge branch 'bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_CGROUP_SOCKOPT'
      Merge branch 'BPF iterator for UNIX domain socket.'
      bpf: Refactor BPF_PROG_RUN into a function
      bpf: Refactor BPF_PROG_RUN_ARRAY family of macros into functions
      bpf: Refactor perf_event_set_bpf_prog() to use struct bpf_prog input
      bpf: Implement minimal BPF perf link
      bpf: Allow to specify user-provided bpf_cookie for BPF perf links
      bpf: Add bpf_get_attach_cookie() BPF helper to access bpf_cookie value
      libbpf: Re-build libbpf.so when libbpf.map changes
      libbpf: Remove unused bpf_link's destroy operation, but add dealloc
      libbpf: Use BPF perf link when supported by kernel
      libbpf: Add bpf_cookie support to bpf_link_create() API
      libbpf: Add bpf_cookie to perf_event, kprobe, uprobe, and tp attach APIs
      selftests/bpf: Test low-level perf BPF link API
      selftests/bpf: Extract uprobe-related helpers into trace_helpers.{c,h}
      selftests/bpf: Add bpf_cookie selftests for high-level APIs
      libbpf: Add uprobe ref counter offset support for USDT semaphores
      selftests/bpf: Add ref_ctr_offset selftests
      Merge branch 'sockmap: add sockmap support for unix stream socket'
      Merge branch 'selftests/bpf: Improve the usability of test_progs'
      Merge branch 'selftests/bpf: fix flaky send_signal test'

Andy Shevchenko (6):
      net: wwan: iosm: Switch to use module_pci_driver() macro
      can: mcp251xfd: mcp251xfd_probe(): try to get crystal clock rate from property
      can: mcp251xfd: Fix header block to clarify independence from OF
      Bluetooth: hci_bcm: Fix kernel doc comments
      wwan: core: Unshadow error code returned by ida_alloc_range()
      ray_cs: use %*ph to print small buffer

Angelo Dureghello (3):
      can: flexcan: add platform data header
      can: flexcan: add mcf5441x support
      can: flexcan: update Kconfig to enable coldfire

Angus Ainslie (2):
      Bluetooth: btbcm: add patch ram for bluetooth
      brcmfmac: add 43752 SDIO ids and initialization

Antoine Tenart (1):
      bonding: improve nl error msg when device can't be enslaved because of IFF_MASTER

Aravindhan Gunasekaran (1):
      igc: Add support for CBS offloading

Archie Pusaka (4):
      Bluetooth: btrtl: Set MSFT opcode for RTL8852
      Bluetooth: hci_h5: add WAKEUP_DISABLE flag
      Bluetooth: hci_h5: btrtl: Maintain flow control if wakeup is enabled
      Bluetooth: hci_h5: Add runtime suspend

Arend van Spriel (4):
      brcmfmac: use different error value for invalid ram base address
      brcmfmac: increase core revision column aligning core list
      brcmfmac: add xtlv support to firmware interface layer
      brcmfmac: support chipsets with different core enumeration space

Ariel Levkovich (1):
      net/mlx5: E-Switch, set flow source for send to uplink rule

Arnd Bergmann (53):
      bpf: Fix pointer cast warning
      compat: make linux/compat.h available everywhere
      ethtool: improve compat ioctl handling
      net: socket: rework SIOC?IFMAP ioctls
      net: socket: remove register_gifconf
      net: socket: simplify dev_ifconf handling
      net: socket: rework compat_ifreq_ioctl()
      net: split out SIOCDEVPRIVATE handling from dev_ioctl
      staging: rtlwifi: use siocdevprivate
      staging: wlan-ng: use siocdevprivate
      hostap: use ndo_siocdevprivate
      bridge: use ndo_siocdevprivate
      phonet: use siocdevprivate
      tulip: use ndo_siocdevprivate
      bonding: use siocdevprivate
      appletalk: use ndo_siocdevprivate
      hamachi: use ndo_siocdevprivate
      tehuti: use ndo_siocdevprivate
      eql: use ndo_siocdevprivate
      fddi: use ndo_siocdevprivate
      net: usb: use ndo_siocdevprivate
      slip/plip: use ndo_siocdevprivate
      qeth: use ndo_siocdevprivate
      cxgb3: use ndo_siocdevprivate
      hamradio: use ndo_siocdevprivate
      airo: use ndo_siocdevprivate
      ip_tunnel: use ndo_siocdevprivate
      hippi: use ndo_siocdevprivate
      sb1000: use ndo_siocdevprivate
      ppp: use ndo_siocdevprivate
      wan: use ndo_siocdevprivate
      wan: cosa: remove dead cosa_net_ioctl() function
      dev_ioctl: pass SIOCDEVPRIVATE data separately
      dev_ioctl: split out ndo_eth_ioctl
      net: split out ndo_siowandev ioctl
      net: socket: return changed ifreq from SIOCDEVPRIVATE
      net: bridge: move bridge ioctls out of .ndo_do_ioctl
      net: bonding: move ioctl handling to private ndo operation
      bcmgenet: remove call to netdev_boot_setup_check
      natsemi: sonic: stop calling netdev_boot_setup_check
      appletalk: ltpc: remove static probing
      3c509: stop calling netdev_boot_setup_check
      cs89x0: rework driver configuration
      m68k: remove legacy probing
      move netdev_boot_setup into Space.c
      make legacy ISA probe optional
      wan: remove stale Kconfig entries
      wan: remove sbni/granch driver
      wan: hostess_sv11: use module_init/module_exit helpers
      ethernet: isa: convert to module_init/module_exit
      ethernet: fix PTP_1588_CLOCK dependencies
      ixp4xx_eth: make ptp support a platform driver
      ixp4xx_eth: fix compile-testing

Aswath Govindraju (1):
      dt-bindings: net: can: Document power-domains property

Avraham Stern (4):
      iwlwifi: mvm: silently drop encrypted frames for unknown station
      iwlwifi: mvm: don't schedule the roc_done_wk if it is already running
      iwlwifi: mvm: add support for range request command version 13
      iwlwifi: mvm: add support for responder config command version 9

Benjamin Poirier (1):
      doc: Document unexpected tcp_l3mdev_accept=1 behavior

Biju Das (22):
      ravb: Use unsigned int for num_tx_desc variable in struct ravb_private
      ravb: Add struct ravb_hw_info to driver data
      ravb: Add aligned_tx to struct ravb_hw_info
      ravb: Add max_rx_len to struct ravb_hw_info
      ravb: Add stats_len to struct ravb_hw_info
      ravb: Add gstrings_stats and gstrings_size to struct ravb_hw_info
      ravb: Add net_features and net_hw_features to struct ravb_hw_info
      ravb: Add internal delay hw feature to struct ravb_hw_info
      ravb: Add tx_counters to struct ravb_hw_info
      ravb: Remove the macros NUM_TX_DESC_GEN[23]
      ravb: Add multi_irq to struct ravb_hw_info
      ravb: Add no_ptp_cfg_active to struct ravb_hw_info
      ravb: Add ptp_cfg_active to struct ravb_hw_info
      ravb: Factorise ravb_ring_free function
      ravb: Factorise ravb_ring_format function
      ravb: Factorise ravb_ring_init function
      ravb: Factorise ravb_rx function
      ravb: Factorise ravb_adjust_link function
      ravb: Factorise ravb_set_features
      ravb: Factorise ravb_dmac_init function
      ravb: Factorise ravb_emac_init function
      ravb: Add reset support

Bill Wendling (1):
      bnx2x: remove unused variable 'cur_data_offset'

Bjorn Andersson (1):
      wcn36xx: Allow firmware name to be overridden by DT

Bodong Wang (1):
      net/mlx5: DR, Reduce print level for FT chaining level check

Bongsu Jeon (8):
      nfc: virtual_ncidev: Use wait queue instead of polling
      selftests: nci: Remove the polling code to read a NCI frame
      selftests: nci: Fix the typo
      selftests: nci: Fix the code for next nlattr offset
      selftests: nci: Fix the wrong condition
      selftests: nci: Add the flags parameter for the send_cmd_mt_nla
      selftests: nci: Extract the start/stop discovery function
      selftests: nci: Add the NCI testcase reading T4T Tag

Brett Creeley (1):
      ice: Only lock to update netdev dev_addr

Cai Huoqing (10):
      net: bonding: bond_alb: Remove the dependency on ipx network layer
      net/mlx5: Fix typo in comments
      net/mlx5e: Make use of netdev_warn()
      net: Remove net/ipx.h and uapi/linux/ipx.h header files
      MAINTAINERS: Remove the ipx network layer info
      can: rcar: Kconfig: Add helper dependency on COMPILE_TEST
      net: ethernet: actions: Add helper dependency on COMPILE_TEST
      net: mdio-ipq4019: Make use of devm_platform_ioremap_resource()
      net: mdio: mscc-miim: Make use of the helper function devm_platform_ioremap_resource()
      net/mlxbf_gige: Make use of devm_platform_ioremap_resourcexxx()

Changbin Du (2):
      net: in_irq() cleanup
      s390/net: replace in_irq() with in_hardirq()

Chengfeng Ye (1):
      selftests/bpf: Fix potential unreleased lock

Chethan T N (1):
      Bluetooth: btusb: Enable MSFT extension for Intel next generation controllers

Chih-Kang Chang (1):
      mac80211: Fix insufficient headroom issue for AMSDU

Chin-Yen Lee (6):
      rtw88: adjust the log level for failure of tx report
      rtw88: 8822ce: set CLKREQ# signal to low during suspend
      rtw88: use read_poll_timeout instead of fixed sleep
      rtw88: refine the setting of rsvd pages for different firmware
      rtw88: wow: report wow reason through mac80211 api
      rtw88: wow: fix size access error of probe request

Chris Chiu (2):
      rtl8xxxu: disable interrupt_in transfer for 8188cu and 8192cu
      rtl8xxxu: Fix the handling of TX A-MPDU aggregation

Chris Mi (8):
      net/mlx5e: Move esw/sample to en/tc/sample
      net/mlx5e: Move sample attribute to flow attribute
      net/mlx5e: CT, Use xarray to manage fte ids
      net/mlx5e: Introduce post action infrastructure
      net/mlx5e: Refactor ct to use post action infrastructure
      net/mlx5e: TC, Remove CONFIG_NET_TC_SKB_EXT dependency when restoring tunnel
      net/mlx5e: TC, Restore tunnel info for sample offload
      net/mlx5e: TC, Support sample offload action for tunneled traffic

Christophe JAILLET (24):
      ath: switch from 'pci_' to 'dma_' API
      ath11k: Remove some duplicate code
      net: switchdev: Simplify 'mlxsw_sp_mc_write_mdb_entry()'
      cavium: switch from 'pci_' to 'dma_' API
      net: wwan: iosm: switch from 'pci_' to 'dma_' API
      net: atlantic: switch from 'pci_' to 'dma_' API
      net: broadcom: switch from 'pci_' to 'dma_' API
      net: chelsio: switch from 'pci_' to 'dma_' API
      net: ec_bhf: switch from 'pci_' to 'dma_' API
      net: jme: switch from 'pci_' to 'dma_' API
      forcedeth: switch from 'pci_' to 'dma_' API
      qtnfmac: switch from 'pci_' to 'dma_' API
      net: sunhme: Remove unused macros
      myri10ge: switch from 'pci_' to 'dma_' API
      vmxnet3: switch from 'pci_' to 'dma_' API
      net: 8139cp: switch from 'pci_' to 'dma_' API
      net/mellanox: switch from 'pci_' to 'dma_' API
      qlcnic: switch from 'pci_' to 'dma_' API
      hinic: switch from 'pci_' to 'dma_' API
      net: spider_net: switch from 'pci_' to 'dma_' API
      fddi: switch from 'pci_' to 'dma_' API
      niu: switch from 'pci_' to 'dma_' API
      intel: switch from 'pci_' to 'dma_' API
      net: pasemi: Remove usage of the deprecated "pci-dma-compat.h" API

Claudiu Beznea (3):
      wilc1000: use goto labels on error path
      wilc1000: dispose irq on failure path
      wilc1000: use devm_clk_get_optional()

Coco Li (2):
      selftests/net: GRO coalesce test
      selftests/net: toeplitz test

Colin Ian King (29):
      atm: idt77252: clean up trigraph warning on ??) string
      net: marvell: clean up trigraph warning on ??! string
      6lowpan: iphc: Fix an off-by-one check of array index
      bpf: Remove redundant intiialization of variable stype
      net: dsa: sja1105: remove redundant re-assignment of pointer table
      netdevsim: make array res_ids static const, makes object smaller
      net: phy: mscc: make some arrays static const, makes object smaller
      cxgb4: make the array match_all_mac static, makes object smaller
      net: marvell: make the array name static, makes object smaller
      qlcnic: make the array random_data static const, makes object smaller
      dpaa2-eth: make the array faf_bits static const, makes object smaller
      net: 3c509: make the array if_names static const, makes object smaller
      net/mlx4: make the array states static const, makes object smaller
      octeontx2-af: Fix spelling mistake "Makesure" -> "Make sure"
      mctp: remove duplicated assignment of pointer hdr
      Bluetooth: increase BTNAMSIZ to 21 chars to fix potential buffer overflow
      tulip: Remove deadcode on startup true condition
      bpf, tests: Fix spelling mistake "shoft" -> "shift"
      i40e: Fix spelling mistake "dissable" -> "disable"
      bpf: Remove redundant initialization of variable allow
      hinic: make array speeds static const, makes object smaller
      net: hns3: make array spec_opcode static const, makes object smaller
      net: ethernet: ti: cpsw: make array stpa static const, makes object smaller
      octeontx2-af: remove redudant second error check on variable err
      rtlwifi: rtl8192de: Remove redundant variable initializations
      rtlwifi: rtl8192de: make arrays static const, makes object smaller
      mwifiex: make arrays static const, makes object smaller
      brcmsmac: make array addr static const, makes object smaller
      rsi: make array fsm_state static const, makes object smaller

Cong Wang (14):
      sock_map: Relax config dependency to CONFIG_NET
      sock_map: Lift socket state restriction for datagram sockets
      af_unix: Implement ->read_sock() for sockmap
      af_unix: Set TCP_ESTABLISHED for datagram sockets too
      af_unix: Add a dummy ->close() for sockmap
      af_unix: Implement ->psock_update_sk_prot()
      af_unix: Implement unix_dgram_bpf_recvmsg()
      selftests/bpf: Factor out udp_socketpair()
      selftests/bpf: Factor out add_to_sockmap()
      selftests/bpf: Add a test case for unix sockmap
      selftests/bpf: Add test cases for redirection between udp and unix
      unix_bpf: Fix a potential deadlock in unix_dgram_bpf_recvmsg()
      net_sched: refactor TC action init API
      bpf, unix: Check socket type in unix_bpf_update_proto()

Corey Minyard (1):
      ipsec: Remove unneeded extra variable in esp4 esp_ssg_unref()

DENG Qingfang (7):
      net: dsa: mt7530: enable assisted learning on CPU port
      net: dsa: mt7530: use independent VLAN learning on VLAN-unaware bridges
      net: dsa: mt7530: set STP state on filter ID 1
      net: dsa: mt7530: always install FDB entries with IVL and FID 1
      net: dsa: mt7530: drop untagged frames on VLAN-aware ports without PVID
      net: dsa: mt7530: fix VLAN traffic leaks again
      net: dsa: mt7530: manually set up VLAN ID 0

Dan Carpenter (7):
      Bluetooth: sco: prevent information leak in sco_conn_defer_accept()
      vrf: fix NULL dereference in vrf_finish_output()
      mac80211: remove unnecessary NULL check in ieee80211_register_hw()
      rsi: fix error code in rsi_load_9116_firmware()
      rsi: fix an error code in rsi_probe()
      ath6kl: wmi: fix an error code in ath6kl_wmi_sync_point()
      net: qrtr: make checks in qrtr_endpoint_post() stricter

Daniel Borkmann (3):
      Merge branch 'bpf-timers'
      Merge branch 'bpf-perf-link'
      bpf: Undo off-by-one in interpreter tail call count limit

Daniel Xu (6):
      bpf: Add BTF_ID_LIST_GLOBAL_SINGLE macro
      bpf: Consolidate task_struct BTF_ID declarations
      bpf: Extend bpf_base_func_proto helpers with bpf_get_current_task_btf()
      bpf: Add bpf_task_pt_regs() helper
      bpf: selftests: Add bpf_task_pt_regs() selftest
      bpf: Fix bpf-next builds without CONFIG_BPF_EVENTS

Dario Binacchi (5):
      dt-bindings: net: can: c_can: convert to json-schema
      can: c_can: remove struct c_can_priv::priv field
      can: c_can: exit c_can_do_tx() early if no frames have been sent
      can: c_can: support tx ring algorithm
      can: c_can: cache frames to operate as a true FIFO

Dave Marchevsky (1):
      bpf: Migrate cgroup_bpf to internal cgroup_bpf_attach_type enum

David Ahern (1):
      ipv4: Fix refcount warning for new fib_info

David Mosberger-Tang (1):
      wilc1000: Convert module-global "isinit" to device-specific variable

David S. Miller (149):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/t nguy/next-queue
      Merge branch 'vmxnet3-version-6'
      Merge branch 'bridge-vlan-multicast'
      Merge branch 'veth-flexible-channel-numbers'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'bridge-vlan-multicast'
      Merge branch 'veth-flexible-channel-numbers'
      Merge branch 's390-next'
      Merge branch 'tag_8021q-cross-chip'
      Merge branch 'fdb-fanout'
      Merge branch 'qcom-dts-updates'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'ipv6-ioam'
      Merge branch 'bridge-port-offload'
      Merge branch 'nfp-flower-ct-offload'
      Merge branch 'net-remove-compat-alloc-user-space'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'bridge-tx-fwd'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'nfc-const'
      Merge branch 'hns3-devlink'
      Merge tag 'linux-can-next-for-5.15-20210725' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge tag 'mlx5-updates-2021-07-24' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'sja1105-bridge-port-traffic-termination'
      Merge branch 'ipa-kill-validation'
      Merge branch 'ipa-clock'
      Merge branch 'ovs-upcall-issues'
      Merge branch 'tcp-rack'
      Merge branch 'ndo_ioctl-rework'
      Merge branch 'ionic-next'
      Merge branch 'ipa-interrupts'
      Merge branch 'ipa-clock-refs'
      Merge branch 'devlink-register'
      Merge branch 'fec-next'
      Merge branch 'bnxt_en-ptp'
      Merge branch 'switchdev-notifiers'
      Merge branch 'skb-gro-optimize'
      Merge branch 'nfc-const'
      Merge branch 'mctp'
      Merge branch 'sja110-vlan-fixes'
      Merge branch 'dpaa2-switch-add-mirroring-support'
      Merge branch 'octeon-drr-config'
      Merge tag 'mlx5-updates-2021-08-02' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'skb_expand_head'
      Merge branch 'bnxt_en-rx-ring'
      Merge branch 'ethtool-runtime-pm'
      Merge branch 'Space-cleanup'
      Merge branch 'dpaa2-switch-next'
      Merge branch 'queues'
      Merge branch 'mhi-mbim'
      Merge branch 'ipa-pm-irqs'
      Merge branch 'm7530-sw-fallback'
      Merge tag 'linux-can-next-for-5.15-20210804' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'sja1105-H'
      Merge branch 'ipa-runtime-pm'
      Merge branch 'bridge-ioctl-fixes'
      wwan: mhi: Fix build.
      Merge branch 'GRO-Toeplitz-selftests'
      Revert "wwan: mhi: Fix build."
      Merge branch 'cpsw-emac-skb_put_padto'
      Merge branch 'ptp-ocp-fixes'
      Merge branch 'dsa-cpu-flood'
      Merge branch 's390-qeth'
      Merge branch 'sja1105-fast-ageing'
      Merge branch 'dsa-fast-ageing'
      Merge branch 'iucv-next'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next
      Merge branch 'ipa-runtime-pm'
      Merge branch 'bridge-global-mcast'
      Merge branch 'devlink-aux-devices'
      Merge branch 'dsa-tagger-helpers'
      Merge branch 'pktgen-imix'
      Merge branch 'dsa-cross-chip-notifiers'
      Merge tag 'mlx5-updates-2021-08-11' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'mptcp-improve-backup-subflows'
      Merge branch 'devlink-cleanup-for-delay-event'
      Merge branch 'bridgge-mcast'
      Merge branch 'iupa-last-things-before-pm-conversion'
      Merge branch 'ipq-mdio'
      Merge branch 'pktgen-samples'
      Merge branch 'ocelot-phylink'
      Merge branch 'stmmac-per-queue-stats'
      Merge branch 'bridge-mcast-fixes'
      Merge tag 'mlx5-updates-2021-08-16' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'octeonx2-mcam-management-rework'
      Merge branch 'bridge-vlan-fixes'
      Merge branch 'mptcp-mesh-path-manager'
      Merge branch 'nci-ext'
      Merge branch 'ravb-gbit'
      Merge branch 'indirect-qdisc-order'
      Merge tag 'batadv-next-pullrequest-20210819' of git://git.open-mesh.org/linux-merge
      Merge tag 'for-net-next-2021-08-19' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
      Merge tag 'mlx5-updates-2021-08-19' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge tag 'batadv-next-pullrequest-20210820' of git://git.open-mesh.org/linux-merge
      Merge branch 'sparx5-dma'
      Merge branch 'gmii2rgmii-loopback'
      Merge branch 'dpaa2-switch-phylikn-fixes'
      Merge branch 'ocelot-phylink-fixes'
      Merge branch 'ocelot-vlan'
      Merge branch 'ipa-kill-off-ipa_clock_get'
      Merge branch 'bridge-vlan'
      Merge branch 'ipa-autosuspend'
      Merge branch 'dsa-docs'
      Merge branch 'octeontx2-misc-fixes'
      Merge branch 'mlxsw-refactor-parser'
      Revert "cxgb4: Search VPD with pci_vpd_find_ro_info_keyword()"
      Revert "bnxt: Search VPD with pci_vpd_find_ro_info_keyword()"
      Revert "bnxt: Read VPD with pci_vpd_alloc()"
      Revert "bnx2x: Search VPD with pci_vpd_find_ro_info_keyword()"
      Revert "bnxt: Search VPD with pci_vpd_find_ro_info_keyword()"
      Revert "bnx2: Search VPD with pci_vpd_find_ro_info_keyword()"
      Revert "Revert "cxgb4: Search VPD with pci_vpd_find_ro_info_keyword()""
      Revert "bnx2x: Read VPD with pci_vpd_alloc()"
      Revert "cxgb4: Validate VPD checksum with pci_vpd_check_csum()"
      Revert "sfc: falcon: Search VPD with pci_vpd_find_ro_info_keyword()"
      Revert "sfc: falcon: Read VPD with pci_vpd_alloc()"
      Merge tag 'wireless-drivers-next-2021-08-22' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
      Merge branch 'mptcp-refactor'
      Merge branch 'dsa-sw-bridging'
      Merge branch 'xen-harden-netfront'
      Merge branch 'lan7800-improvements'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'mptcp-next'
      Merge branch 'mana-EQ-sharing'
      Merge branch 'dsa-sja1105-vlan-tags'
      Merge branch 'ravb-gbit-refactor'
      Merge tag 'linux-can-next-for-5.15-20210825' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'octeontx2-traffic-shaping'
      Merge branch 'pktgen-samples-next'
      Merge branch 'ionic-next'
      Merge tag 'mac80211-next-for-net-next-2021-08-26' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
      Merge branch 'LiteETH-driver'
      Merge tag 'mlx5-fixes-2021-08-26' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'mptcp-Optimize-received-options-handling'
      Merge tag 'mlx5-updates-2021-08-26' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ ipsec-next
      Merge branch 'hns3-cleanups'
      Merge branch 'hns3-next'
      Merge branch 'ionic-queue-mgmt'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next- queue
      Merge tag 'wireless-drivers-next-2021-08-29' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
      Merge branch 'bnxt_en-fw-messages'
      Merge branch 'hns3-cleanups'
      Merge branch 'IXP46x-PTP-Timer'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next
      Merge branch 'inet-exceptions-less-predictable'
      Merge branch 'octeon-npc-fixes'

Davide Caratti (1):
      net/sched: store the last executed chain also for clsact egress

Desmond Cheong Zhi Xi (7):
      Bluetooth: skip invalid hci_sync_conn_complete_evt
      Bluetooth: schedule SCO timeouts with delayed_work
      Bluetooth: avoid circular locks in sco_sock_connect
      Bluetooth: switch to lock_sock in SCO
      Bluetooth: serialize calls to sco_sock_{set,clear}_timer
      Bluetooth: switch to lock_sock in RFCOMM
      Bluetooth: fix repeated calls to sco_sock_kill

Di Zhu (1):
      ipvlan: Add handling of NETDEV_UP events

Dima Chumak (1):
      net/mlx5: Lag, fix multipath lag activation

Dmytro Linkin (7):
      net/mlx5: E-switch, Move QoS related code to dedicated file
      net/mlx5: E-switch, Enable devlink port tx_{share|max} rate control
      net/mlx5: E-switch, Introduce rate limiting groups API
      net/mlx5: E-switch, Allow setting share/max tx rate limits of rate groups
      net/mlx5: E-switch, Allow to add vports to rate groups
      net/mlx5: E-switch, Add QoS tracepoints
      net/mlx5e: Use correct eswitch for stack devices with lag

Dongliang Mu (2):
      usb: hso: fix error handling code of hso_create_net_device
      usb: hso: remove the bailout parameter

Dror Moshe (1):
      iwlwifi: move get pnvm file name to a separate function

Dust Li (1):
      selftests/net: remove min gso test in packet_snd

Edwin Peer (11):
      bnxt_en: remove DMA mapping for KONG response
      bnxt_en: Refactor the HWRM_VER_GET firmware calls
      bnxt_en: move HWRM API implementation into separate file
      bnxt_en: introduce new firmware message API based on DMA pools
      bnxt_en: discard out of sequence HWRM responses
      bnxt_en: add HWRM request assignment API
      bnxt_en: add support for HWRM request slices
      bnxt_en: use link_lock instead of hwrm_cmd_lock to protect link_info
      bnxt_en: update all firmware calls to use the new APIs
      bnxt_en: remove legacy HWRM interface
      bnxt_en: support multiple HWRM commands in flight

Eli Cohen (2):
      net/core: Remove unused field from struct flow_indr_dev
      net: Fix offloading indirect devices dependency on qdisc order creation

Emmanuel Grumbach (1):
      nl80211: vendor-cmd: add Intel vendor commands for iwlmei usage

Eran Ben Elisha (1):
      net/mlx5: Fix variable type to match 64bit

Eric Dumazet (9):
      net/tcp_fastopen: remove tcp_fastopen_ctx_lock
      tcp: avoid indirect call in tcp_new_space()
      tcp: tweak len/truesize ratio for coalesce candidates
      ipv6: exthdrs: get rid of indirect calls in ip6_parse_tlv()
      ipv6: make exception cache less predictible
      ipv4: make exception cache less predictible
      af_unix: fix potential NULL deref in unix_dgram_connect()
      ipv4: fix endianness issue in inet_rtm_getroute_build_skb()
      fou: remove sparse errors

Evgeniy Litvinenko (2):
      libbpf: Add bpf_map__pin_path function
      selftests/bpf: Document vmtest.sh dependencies

Fabio Estevam (1):
      dt-bindings: net: fec: Fix indentation

Faiz Abbas (2):
      dt-bindings: net: can: Document transceiver implementation as phy
      can: m_can: Add support for transceiver as phy

Florian Westphal (13):
      netfilter: ipt_CLUSTERIP: only add arp mangle hook when required
      netfilter: ipt_CLUSTERIP: use clusterip_net to store pernet warning
      netfilter: remove xt pernet data
      netfilter: ebtables: do not hook tables by default
      netfilter: ctnetlink: add and use a helper for mark parsing
      netfilter: ctnetlink: allow to filter dump by status bits
      netfilter: x_tables: never register tables by default
      netfilter: nf_queue: move hookfn registration out of struct net
      netfilter: ecache: remove one indent level
      netfilter: ecache: remove another indent level
      netfilter: ecache: add common helper for nf_conntrack_eventmask_report
      netfilter: ecache: prepare for event notifier merge
      netfilter: ecache: remove nf_exp_event_notifier structure

Forest Crossman (1):
      Bluetooth: btusb: Add support for LG LGSBWAC92/TWCM-K505D

Fugang Duan (3):
      net: fec: add imx8mq and imx8qm new versions support
      net: fec: add eee mode tx lpi support
      net: fec: add MAC internal delayed clock feature support

Geert Uytterhoeven (1):
      ravb: Remove checks for unsupported internal delay modes

Geetha sowjanya (6):
      octeontx2-af: Handle return value in block reset.
      octeontx2-af: Use DMA_ATTR_FORCE_CONTIGUOUS attribute in DMA alloc
      octeontx2-af: Check capability flag while freeing ipolicer memory
      octeontx2-af: cn10k: Use FLIT0 register instead of FLIT1
      octeontx2-af: cn10k: Set cache lines for NPA batch alloc
      octeontx2-af: Use NDC TX for transmit packet data

Geliang Tang (11):
      mptcp: drop flags and ifindex arguments
      mptcp: remote addresses fullmesh
      mptcp: local addresses fullmesh
      selftests: mptcp: set and print the fullmesh flag
      selftests: mptcp: add fullmesh testcases
      selftests: mptcp: delete uncontinuous removing ids
      mptcp: MP_FAIL suboption sending
      mptcp: MP_FAIL suboption receiving
      mptcp: send out MP_FAIL when data checksum fails
      mptcp: add the mibs for MP_FAIL
      selftests: mptcp: add MP_FAIL mibs check

George Cherian (1):
      octeontx2-af: Add free rsrc count mbox msg

Gerhard Engleder (3):
      net: phy: Support set_loopback override
      net: phy: Uniform PHY driver access
      net: phy: gmii2rgmii: Support PHY loopback

Gilad Naaman (1):
      net-next: When a bond have a massive amount of VLANs with IPv6 addresses, performance of changing link state, attaching a VRF, changing an IPv6 address, etc. go down dramtically.

Grant Seltzer (1):
      libbpf: Rename libbpf documentation index file

Gregory Greenman (2):
      iwlwifi: mvm: support version 11 of wowlan statuses notification
      iwlwifi: mvm: introduce iwl_stored_beacon_notif_v3

Grygorii Strashko (5):
      net: ethernet: ti: cpsw: switch to use skb_put_padto()
      net: ethernet: ti: davinci_emac: switch to use skb_put_padto()
      net: ethernet: ti: davinci_cpdma: drop frame padding
      net: ethernet: ti: am65-cpsw: use napi_complete_done() in TX completion
      net: ethernet: ti: davinci_cpdma: revert "drop frame padding"

Grzegorz Siwik (1):
      igb: Add counter to i21x doublecheck

Guangbin Huang (11):
      docs: ethtool: Add two link extended substates of bad signal integrity
      ethtool: add two link extended substates of bad signal integrity
      net: hns3: add header file hns3_ethtoo.h
      net: hns3: add support ethtool extended link state
      net: hns3: add macros for mac speeds of firmware command
      net: hns3: refactor function hclge_parse_capability()
      net: hns3: refactor function hclgevf_parse_capability()
      net: hns3: add new function hclge_get_speed_bit()
      net: hns3: don't config TM DWRR twice when set ETS
      net: hns3: reconstruct function hclge_ets_validate()
      net: hns3: refine function hclge_dbg_dump_tm_pri()

Guojia Liao (1):
      net: hns3: clean up a type mismatch warning

Gustavo A. R. Silva (8):
      ipv4: ip_output.c: Fix out-of-bounds warning in ip_copy_addrs()
      flow_dissector: Fix out-of-bounds warnings
      net/ipv4: Replace one-element array with flexible-array member
      net/ipv4: Revert use of struct_size() helper
      net/ipv4/ipv6: Replace one-element arraya with flexible-array members
      net/ipv4/igmp: Use struct_size() helper
      net/ipv6/mcast: Use struct_size() helper
      mwifiex: usb: Replace one-element array with flexible-array member

Haimin Zhang (1):
      fix array-index-out-of-bounds in taprio_change

Haiyang Zhang (3):
      net: mana: Move NAPI from EQ to CQ
      net: mana: Add support for EQ sharing
      net: mana: Add WARN_ON_ONCE in case of CQE read overflow

Haiyue Wang (1):
      gve: fix the wrong AdminQ buffer overflow check

Hangbin Liu (1):
      bonding: add new option lacp_active

Hans de Goede (1):
      Bluetooth: hci_h5: Disable the hci_suspend_notifier for btrtl devices

Hao Chen (11):
      devlink: add documentation for hns3 driver
      net: hns3: add devlink reload support for PF
      net: hns3: add devlink reload support for VF
      net: hns3: uniform type of function parameter cmd
      net: hns3: remove unnecessary "static" of local variables in function
      net: hns3: add required space in comment
      net: hns3: modify a print format of hns3_dbg_queue_map()
      net: hnss3: use max() to simplify code
      net: hns3: uniform parameter name of hclge_ptp_clean_tx_hwts()
      net: hns3: add some required spaces
      net: hns3: remove unnecessary spaces

Hao Luo (1):
      libbpf: Support weak typed ksyms.

Hari Prasath (2):
      net: macb: Add PTP support for SAMA5D29
      dt-bindings: net: macb: add documentation for sama5d29 ethernet interface

Hariprasad Kelam (2):
      octeontx2-af: cn10K: Get NPC counters value
      octeontx2-pf: Don't mask out supported link modes

Harman Kalra (2):
      octeontx2-af: nix and lbk in loop mode in 98xx
      octeontx2-af: cn10K: support for sched lmtst and other features

He Fengqing (1):
      bpf: Fix potential memleak and UAF in the verifier.

Heiko Carstens (1):
      net/iucv: get rid of register asm usage

Heiner Kallweit (20):
      ethtool: runtime-resume netdev parent before ethtool ioctl ops
      ethtool: move implementation of ethnl_ops_begin/complete to netlink.c
      ethtool: move netif_device_present check from ethnl_parse_header_dev_get to ethnl_ops_begin
      ethtool: runtime-resume netdev parent in ethnl_ops_begin
      ethtool: return error from ethnl_ops_begin if dev is NULL
      r8169: rename rtl_csi_access_enable to rtl_set_aspm_entry_latency
      sfc: falcon: Read VPD with pci_vpd_alloc()
      sfc: falcon: Search VPD with pci_vpd_find_ro_info_keyword()
      bnx2: Search VPD with pci_vpd_find_ro_info_keyword()
      bnx2: Replace open-coded version with swab32s()
      bnx2x: Read VPD with pci_vpd_alloc()
      bnx2x: Search VPD with pci_vpd_find_ro_info_keyword()
      bnxt: Read VPD with pci_vpd_alloc()
      bnxt: Search VPD with pci_vpd_find_ro_info_keyword()
      cxgb4: Validate VPD checksum with pci_vpd_check_csum()
      cxgb4: Remove unused vpd_param member ec
      cxgb4: Search VPD with pci_vpd_find_ro_info_keyword()
      cxgb4: improve printing NIC information
      r8169: enable ASPM L0s state
      r8169: add rtl_enable_exit_l1

Hengqi Chen (3):
      tools/resolve_btfids: Emit warnings and patch zero id for missing symbols
      libbpf: Add btf__load_vmlinux_btf/btf__load_module_btf
      selftests/bpf: Test btf__load_vmlinux_btf/btf__load_module_btf APIs

Horatiu Vultur (1):
      net: mscc: ocelot: be able to reuse a devlink_port after teardown

Hu Haowen (1):
      Documentation: networking: add ioam6-sysctl into index

Huazhong Tan (1):
      net: hns3: add hns3_state_init() to do state initialization

Ian Mackinnon (1):
      Bluetooth: btusb: Load Broadcom firmware for Dell device 413c:8197

Ilan Peer (5):
      iwlwifi: mvm: Do not use full SSIDs in 6GHz scan
      iwlwifi: mvm: Add support for hidden network scan on 6GHz band
      iwlwifi: mvm: Fix umac scan request probe parameters
      iwlwifi: mvm: Refactor setting of SSIDs for 6GHz scan
      iwlwifi: mvm: Fix scan channel flags settings

Ilya Leoshkevich (1):
      selftests/bpf: Fix test_core_autosize on big-endian machines

Ioana Ciornei (18):
      docs: networking: dpaa2: add documentation for the switch driver
      dpaa2-switch: rename dpaa2_switch_tc_parse_action to specify the ACL
      dpaa2-switch: rename dpaa2_switch_acl_tbl into filter_block
      dpaa2-switch: reorganize dpaa2_switch_cls_flower_replace
      dpaa2-switch: reorganize dpaa2_switch_cls_matchall_replace
      dpaa2-switch: add API for setting up mirroring
      dpaa2-switch: add support for port mirroring
      dpaa2-switch: add VLAN based mirroring
      dpaa2-switch: offload shared block mirror filters when binding to a port
      docs: networking: dpaa2: document mirroring support on the switch
      dpaa2-switch: request all interrupts sources on the DPSW
      dpaa2-switch: use the port index in the IRQ handler
      dpaa2-switch: do not enable the DPSW at probe time
      dpaa2-switch: no need to check link state right after ndo_open
      bus: fsl-mc: extend fsl_mc_get_endpoint() to pass interface ID
      dpaa2-switch: integrate the MAC endpoint support
      dpaa2-switch: add a prefix to HW ethtool stats
      dpaa2-switch: export MAC statistics in ethtool

Ismael Ferreras Morezuelas (1):
      Bluetooth: btusb: Make the CSR clone chip force-suspend workaround more generic

Ivan Bornyakov (1):
      net: phy: marvell: add SFP support for 88E1510

Jacob Keller (4):
      ice: fix Tx queue iteration for Tx timestamp enablement
      ice: remove dead code for allocating pin_config
      ice: add lock around Tx timestamp tracker flush
      ice: restart periodic outputs around time changes

Jakub Kicinski (28):
      Merge branch 'nfc-constify-pointed-data-missed-part'
      Merge branch 'clean-devlink-net-namespace-operations'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      virtio-net: realign page_to_skb() after merges
      net: add netif_set_real_num_queues() for device reconfig
      nfp: use netif_set_real_num_queues()
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'add-frag-page-support-in-page-pool'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux
      Merge branch 'bonding-cleanup-header-file-and-error-msgs'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'kconfig-symbol-clean-up-on-net'
      Merge branch 'net-hns3-add-support-ethtool-extended-link-state'
      Merge branch 'ptp-ocp-minor-updates-and-fixes'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'linux-can-next-for-5.15-20210819' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge tag 'mac80211-next-for-net-next-2021-08-20' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
      netdevice: move xdp_rxq within netdev_rx_queue
      Merge branch 'ethtool-extend-coalesce-uapi'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      bnxt: count packets discarded because of netpoll
      bnxt: count discards due to memory allocation errors
      Merge branch 'bnxt-add-rx-discards-stats-for-oom-and-netpool'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net

Jason Wang (5):
      net: ixp4xx_hss: use dma_pool_zalloc
      net: qed: remove unneeded return variables
      libbpf: Fix comment typo
      net/mlx4: Use ARRAY_SIZE to get an array's size
      dpaa2-eth: Replace strlcpy with strscpy

Jeremy Kerr (11):
      mctp: Add MCTP base
      mctp: Add base socket/protocol definitions
      mctp: Add base packet definitions
      mctp: Add sockaddr_mctp to uapi
      mctp: Add initial driver infrastructure
      mctp: Add device handling and netlink interface
      mctp: Add initial routing framework
      mctp: Populate socket implementation
      mctp: Implement message fragmentation & reassembly
      mctp: Add MCTP overview document
      mctp: Specify route types, require rtm_type in RTM_*ROUTE messages

Jerin Jacob (2):
      octeontx2-af: Enhance mailbox trace entry
      octeontx2-af: Allow to configure flow tag LSB byte as RSS adder

Jesper Dangaard Brouer (1):
      samples/bpf: xdp_redirect_cpu_user: Cpumap qsize set larger default

Jian Shen (1):
      net: hns3: refine function hns3_set_default_feature()

Jiang Wang (6):
      af_unix: Add read_sock for stream socket types
      af_unix: Add unix_stream_proto for sockmap
      selftest/bpf: Add tests for sockmap with unix stream type.
      selftest/bpf: Change udp to inet in some function names
      selftest/bpf: Add new tests in sockmap for unix stream to tcp.
      af_unix: Fix NULL pointer bug in unix_shutdown

Jiapeng Chong (1):
      net/mlx5: Fix missing return value in mlx5_devlink_eswitch_inline_mode_set()

Jiaran Zhang (1):
      net: hns3: initialize each member of structure array on a separate line

Jing Yangyang (1):
      ssb: fix boolreturn.cocci warning

Jiri Olsa (10):
      bpf, x86: Store caller's ip in trampoline stack
      bpf: Enable BPF_TRAMP_F_IP_ARG for trampolines with call_get_func_ip
      bpf: Add bpf_get_func_ip helper for tracing programs
      bpf: Add bpf_get_func_ip helper for kprobe programs
      selftests/bpf: Add test for bpf_get_func_ip helper
      libbpf: Add bpf_program__attach_kprobe_opts function
      selftests/bpf: Add test for bpf_get_func_ip in kprobe+offset probe
      libbpf: Fix func leak in attach_kprobe
      libbpf: Allow decimal offset for kprobes
      libbpf: Export bpf_program__attach_kprobe_opts function

Joakim Zhang (15):
      dt-bindings: net: fec: convert fsl,*fec bindings to yaml
      ARM: dts: imx35: correct node name for FEC
      ARM: dts: imx7-mba7: remove un-used "phy-reset-delay" property
      dt-bindings: net: snps,dwmac: add missing DWMAC IP version
      dt-bindings: net: imx-dwmac: convert imx-dwmac bindings to yaml
      arm64: dts: imx8mp: change interrupt order per dt-binding
      dt-bindings: net: fsl,fec: improve the binding a bit
      ARM: dts: imx6qdl: move phy properties into phy device node
      dt-bindings: net: fsl,fec: update compatible items
      dt-bindings: net: fsl,fec: add RGMII internal clock delay
      arm64: dts: imx8m: add "fsl,imx8mq-fec" compatible string for FEC
      arm64: dts: imx8qxp: add "fsl,imx8qm-fec" compatible string for FEC
      net: fec: fix MAC internal delay doesn't work
      net: fec: fix build error for ARCH m68k
      net: fec: add WoL support for i.MX8MQ

Joel Stanley (2):
      dt-bindings: net: Add bindings for LiteETH
      net: Add driver for LiteX's LiteETH network interface

Johan Almbladh (18):
      bpf/tests: Fix copy-and-paste error in double word test
      bpf/tests: Do not PASS tests without actually testing the result
      bpf: Fix off-by-one in tail call count limiting
      bpf, tests: Add BPF_JMP32 test cases
      bpf, tests: Add BPF_MOV tests for zero and sign extension
      bpf, tests: Fix typos in test case descriptions
      bpf, tests: Add more tests of ALU32 and ALU64 bitwise operations
      bpf, tests: Add more ALU32 tests for BPF_LSH/RSH/ARSH
      bpf, tests: Add more BPF_LSH/RSH/ARSH tests for ALU64
      bpf, tests: Add more ALU64 BPF_MUL tests
      bpf, tests: Add tests for ALU operations implemented with function calls
      bpf, tests: Add word-order tests for load/store of double words
      bpf, tests: Add branch conversion JIT test
      bpf, tests: Add test for 32-bit context pointer argument passing
      bpf, tests: Add tests for atomic operations
      bpf, tests: Add tests for BPF_CMPXCHG
      bpf, tests: Add tail call test suite
      mac80211: Fix monitor MTU limit so that A-MSDUs get through

Johannes Berg (36):
      mac80211: include <linux/rbtree.h>
      cfg80211: fix BSS color notify trace enum confusion
      iwlwifi: nvm: enable IEEE80211_HE_PHY_CAP10_HE_MU_M1RU_MAX_LTF
      iwlwifi: mvm: avoid FW restart while shutting down
      iwlwifi: pcie: optimise struct iwl_rx_mem_buffer layout
      iwlwifi: pcie: free RBs during configure
      iwlwifi: prepare for synchronous error dumps
      iwlwifi: pcie: dump error on FW reset handshake failures
      iwlwifi: mvm: set replay counter on key install
      iwlwifi: mvm: restrict FW SMPS request
      iwlwifi: mvm: avoid static queue number aliasing
      iwlwifi: mvm: clean up number of HW queues
      iwlwifi: mvm: treat MMPDUs in iwl_mvm_mac_tx() as bcast
      iwlwifi: split off Bz devices into their own family
      iwlwifi: give Bz devices their own name
      iwlwifi: read MAC address from correct place on Bz
      iwlwifi: pcie: implement Bz device startup
      iwlwifi: implement Bz NMI behaviour
      iwlwifi: pcie: implement Bz reset flow
      iwlwifi: mvm: support new station key API
      iwlwifi: mvm: simplify __iwl_mvm_set_sta_key()
      iwlwifi: mvm: d3: separate TKIP data from key iteration
      iwlwifi: mvm: d3: remove fixed cmd_flags argument
      iwlwifi: mvm: d3: refactor TSC/RSC configuration
      iwlwifi: mvm: d3: add separate key iteration for GTK type
      iwlwifi: mvm: d3: make key reprogramming iteration optional
      iwlwifi: mvm: d3: implement RSC command version 5
      iwlwifi: mvm: fix access to BSS elements
      iwlwifi: fw: correctly limit to monitor dump
      iwlwifi: pcie: avoid dma unmap/remap in crash dump
      iwlwifi: fix __percpu annotation
      iwlwifi: api: remove datamember from struct
      iwlwifi: fw: fix debug dump data declarations
      iwlwifi: allow debug init in RF-kill
      iwlwifi: mvm: don't use FW key ID in beacon protection
      um: vector: adjust to coalesce API changes

John Crispin (2):
      nl80211: add support for BSS coloring
      mac80211: add support for BSS color change

John Efstathiades (10):
      lan78xx: Fix white space and style issues
      lan78xx: Remove unused timer
      lan78xx: Set flow control threshold to prevent packet loss
      lan78xx: Remove unused pause frame queue
      lan78xx: Add missing return code checks
      lan78xx: Fix exception on link speed change
      lan78xx: Fix partial packet errors on suspend/resume
      lan78xx: Fix race conditions in suspend/resume handling
      lan78xx: Fix race condition in disconnect handling
      lan78xx: Limit number of driver warning messages

John Fastabend (1):
      bpf, selftests: Fix test_maps now that sockmap supports UDP

Jonas Dreßler (1):
      mwifiex: pcie: add DMI-based quirk implementation for Surface devices

Jonathan Lemon (12):
      ptp: ocp: Expose various resources on the timecard.
      ptp: ocp: Fix the error handling path for the class device.
      ptp: ocp: Add the mapping for the external PPS registers.
      ptp: ocp: Remove devlink health and unused parameters.
      ptp: ocp: Use 'gnss' naming instead of 'gps'
      ptp: ocp: Rename version string shown by devlink.
      ptp: ocp: Remove pending_image indicator from devlink
      ptp: ocp: Fix uninitialized variable warning spotted by clang.
      ptp: ocp: Fix error path for pci_ocp_device_init()
      ptp: ocp: Have Kconfig select NET_DEVLINK
      MAINTAINERS: Update for ptp_ocp driver.
      ptp: ocp: Simplify Kconfig.

Jonathan Toppins (2):
      bonding: remove extraneous definitions from bonding.h
      bonding: combine netlink and console error messages

Jose Blanquicet (1):
      selftests/bpf: Fix bpf-iter-tcp4 test to print correctly the dest IP

Joseph Gates (1):
      wcn36xx: Ensure finish scan is not requested before start scan

Juergen Gross (4):
      xen/netfront: read response from backend only once
      xen/netfront: don't read data from request on the ring page
      xen/netfront: disentangle tx_skb_freelist
      xen/netfront: don't trust the backend response data blindly

Juhee Kang (7):
      samples: bpf: Fix tracex7 error raised on the missing argument
      samples: bpf: Add the omitted xdp samples to .gitignore
      samples: pktgen: pass the environment variable of normal user to sudo
      samples: pktgen: add missing IPv6 option to pktgen scripts
      samples: pktgen: fix to print when terminated normally
      samples: pktgen: add trap SIGINT for printing execution result
      pktgen: document the latest pktgen usage options

Julian Wiedmann (6):
      s390/qeth: remove OSN support
      s390/qeth: clean up QETH_PROT_* naming
      s390/qeth: clean up device_type management
      net/af_iucv: support drop monitoring
      net/af_iucv: clean up a try_then_request_module()
      net/af_iucv: remove wrappers around iucv (de-)registration

Jun Miao (2):
      Bluetooth: btusb: Fix a unspported condition to set available debug features
      atm: horizon: Fix spelling mistakes in TX comment

Jussi Maki (10):
      selftests/bpf: Use ping6 only if available in tc_redirect
      net, bonding: Refactor bond_xmit_hash for use with xdp_buff
      net, core: Add support for XDP redirection to slave device
      net, bonding: Add XDP support to the bonding driver
      bpf, devmap: Exclude XDP broadcast to master device
      net, core: Allow netdev_lower_get_next_private_rcu in bh context
      selftests/bpf: Fix xdp_tx.c prog section name
      selftests/bpf: Add tests for XDP bonding
      net, bonding: Disallow vlan+srcmac with XDP
      selftests/bpf: Fix running of XDP bonding tests

Justin Iurman (7):
      uapi: IPv6 IOAM headers definition
      ipv6: ioam: Data plane support for Pre-allocated Trace
      ipv6: ioam: IOAM Generic Netlink API
      ipv6: ioam: Support for IOAM injection with lwtunnels
      ipv6: ioam: Documentation for new IOAM sysctls
      selftests: net: Test for the IOAM insertion with IPv6
      selftests: net: improved IOAM tests

Kai-Heng Feng (1):
      Bluetooth: Move shutdown callback before flushing tx and rx queue

Kalle Valo (3):
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge commit 'e257d969f36503b8eb1240f32653a1afb3109f86' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next

Kangmin Park (3):
      mpls: defer ttl decrement in mpls_forward()
      Bluetooth: Fix return value in hci_dev_do_close()
      net: bridge: change return type of br_handle_ingress_vlan_tunnel

Kees Cook (7):
      igb: Avoid memcpy() over-reading of ETH_SS_STATS
      e100: Avoid memcpy() over-reading of ETH_SS_STATS
      mac80211: radiotap: Use BIT() instead of shifts
      mac80211: Use flex-array for radiotap header bitmap
      Bluetooth: mgmt: Pessimize compile-time bounds-check
      ipw2x00: Avoid field-overflowing memcpy()
      ray_cs: Split memcpy() to avoid bounds check warning

Kiran K (1):
      Bluetooth: Fix race condition in handling NOP command

Krzysztof Kozlowski (39):
      nfc: port100: constify protocol list array
      nfc: constify payload argument in nci_send_cmd()
      nfc: constify nci_ops
      nfc: s3fwrn5: constify nci_ops
      nfc: constify nci_driver_ops (prop_ops and core_ops)
      nfc: constify nfc_phy_ops
      nfc: st21nfca: constify file-scope arrays
      nfc: constify pointer to nfc_vendor_cmd
      nfc: constify nfc_hci_gate
      nfc: constify nfc_ops
      nfc: constify nfc_hci_ops
      nfc: constify nfc_llc_ops
      nfc: constify nfc_digital_ops
      nfc: constify passed nfc_dev
      nfc: mei_phy: constify buffer passed to mei_nfc_send()
      nfc: port100: constify several pointers
      nfc: trf7970a: constify several pointers
      nfc: virtual_ncidev: constify pointer to nfc_dev
      nfc: nfcsim: constify drvdata (struct nfcsim)
      nfc: fdp: drop unneeded cast for printing firmware size in dev_dbg()
      nfc: fdp: use unsigned int as loop iterator
      nfc: fdp: constify several pointers
      nfc: microread: constify several pointers
      nfc: mrvl: constify several pointers
      nfc: mrvl: constify static nfcmrvl_if_ops
      nfc: mrvl: correct nfcmrvl_spi_parse_dt() device_node argument
      nfc: annotate af_nfc_exit() as __exit
      nfc: hci: annotate nfc_llc_init() as __init
      nfc: constify several pointers to u8, char and sk_buff
      nfc: constify local pointer variables
      nfc: nci: constify several pointers to u8, sk_buff and other structs
      nfc: hci: cleanup unneeded spaces
      nfc: hci: pass callback data param as pointer in nci_request()
      nfc: microread: remove unused header includes
      nfc: mrvl: remove unused header includes
      nfc: pn544: remove unused header includes
      nfc: st-nci: remove unused header includes
      nfc: st21nfca: remove unused header includes
      nfc: st95hf: remove unused header includes

Kumar Kartikeya Dwivedi (28):
      net: core: Split out code to run generic XDP prog
      bitops: Add non-atomic bitops for pointers
      bpf: cpumap: Implement generic cpumap
      bpf: devmap: Implement devmap prog execution for generic XDP
      bpf: Tidy xdp attach selftests
      samples: bpf: Fix a couple of warnings
      tools: include: Add ethtool_drvinfo definition to UAPI header
      samples: bpf: Add basic infrastructure for XDP samples
      samples: bpf: Add BPF support for redirect tracepoint
      samples: bpf: Add redirect tracepoint statistics support
      samples: bpf: Add BPF support for xdp_exception tracepoint
      samples: bpf: Add xdp_exception tracepoint statistics support
      samples: bpf: Add BPF support for cpumap tracepoints
      samples: bpf: Add cpumap tracepoint statistics support
      samples: bpf: Add BPF support for devmap_xmit tracepoint
      samples: bpf: Add devmap_xmit tracepoint statistics support
      samples: bpf: Add vmlinux.h generation support
      samples: bpf: Convert xdp_monitor_kern.o to XDP samples helper
      samples: bpf: Convert xdp_monitor to XDP samples helper
      samples: bpf: Convert xdp_redirect_kern.o to XDP samples helper
      samples: bpf: Convert xdp_redirect to XDP samples helper
      samples: bpf: Convert xdp_redirect_cpu_kern.o to XDP samples helper
      samples: bpf: Convert xdp_redirect_cpu to XDP samples helper
      samples: bpf: Convert xdp_redirect_map_kern.o to XDP samples helper
      samples: bpf: Convert xdp_redirect_map to XDP samples helper
      samples: bpf: Convert xdp_redirect_map_multi_kern.o to XDP samples helper
      samples: bpf: Convert xdp_redirect_map_multi to XDP samples helper
      samples: bpf: Fix uninitialized variable in xdp_redirect_cpu

Kuniyuki Iwashima (5):
      bpf: Fix a typo of reuseport map in bpf.h.
      bpf: af_unix: Implement BPF iterator for UNIX domain socket.
      bpf: Support "%c" in bpf_bprintf_prepare().
      selftest/bpf: Implement sample UNIX domain socket iterator program.
      selftest/bpf: Extend the bpf_snprintf() test for "%c".

Kurt Kanzenbach (5):
      igc: Add possibility to add flex filter
      igc: Integrate flex filter into ethtool ops
      igc: Make flex filter more flexible
      igc: Export LEDs
      Revert "igc: Export LEDs"

Lad Prabhakar (3):
      dt-bindings: net: can: renesas,rcar-canfd: Document RZ/G2L SoC
      can: rcar_canfd: Add support for RZ/G2L family
      can: rcar_canfd: rcar_canfd_handle_channel_tx(): fix redundant assignment

Lahav Schlesinger (2):
      net: Support filtering interfaces on no master
      selftests: vrf: Add test for SNAT over VRF

Larry Finger (1):
      Bluetooth: Add additional Bluetooth part for Realtek 8852AE

Len Baker (4):
      Bluetooth: btmrvl_sdio: Remove all strcpy() uses
      drivers/net/usb: Remove all strcpy() uses
      ipw2x00: Use struct_size helper instead of open-coded arithmetic
      rtw88: Remove unnecessary check code

Leon Romanovsky (20):
      ionic: drop useless check of PCI driver data validity
      ionic: cleanly release devlink instance
      net: ti: am65-cpsw-nuss: fix wrong devlink release order
      net/mlx5: Don't rely on always true registered field
      devlink: Remove duplicated registration check
      devlink: Break parameter notification sequence to be before/after unload/load driver
      devlink: Allocate devlink directly in requested net namespace
      netdevsim: Forbid devlink reload when adding or deleting ports
      netdevsim: Protect both reload_down and reload_up paths
      devlink: Simplify devlink port API calls
      devlink: Set device as early as possible
      devlink: Fix port_type_set function pointer check
      net/mlx5: Delete impossible dev->state checks
      devlink: Simplify devlink_pernet_pre_exit call
      devlink: Remove check of always valid devlink pointer
      devlink: Count struct devlink consumers
      devlink: Use xarray to store devlink instances
      devlink: Clear whole devlink_flash_notify struct
      net: hns3: remove always exist devlink pointer check
      net/mlx5: Remove all auxiliary devices at the unregister event

Li RongQing (1):
      virtio_net: reduce raw_smp_processor_id() calling in virtnet_xdp_get_sq

Li Zhijian (5):
      selftests/bpf: Enlarge select() timeout for test_maps
      selftests/bpf: Make test_doc_build.sh work from script directory
      selftests/bpf: Add default bpftool built by selftests to PATH
      selftests/bpf: Add missing files required by test_bpftool.sh for installing
      selftests/bpf: Exit with KSFT_SKIP if no Makefile found

Linus Lüssing (2):
      batman-adv: bcast: remove remaining skb-copy calls
      batman-adv: bcast: remove remaining skb-copy calls

Linus Walleij (6):
      brcmfmac: firmware: Allow per-board firmware binaries
      brcmfmac: firmware: Fix firmware loading
      ssb: Drop legacy header include
      ixp4xx_eth: Stop referring to GPIOs
      ixp4xx_eth: Add devicetree bindings
      ixp4xx_eth: Probe the PTP module from the device tree

Lior Nahmanson (1):
      net/mlx5: Add DCS caps & fields support

Liu Jian (1):
      igmp: Add ip_mc_list lock in ip_check_mc_rcu

Loic Poulain (4):
      wwan: core: Fix missing RTM_NEWLINK event for default link
      net: wwan: Add MHI MBIM network driver
      net: mhi: Remove MBIM protocol
      wcn36xx: Fix missing frame timestamp for beacon/probe-resp

Lorenzo Bianconi (2):
      ieee80211: add TWT element definitions
      mac80211: introduce individual TWT support in AP mode

Louis Peens (8):
      nfp: flower: refactor match functions to take flow_rule as input
      nfp: flower: refactor action offload code slightly
      nfp: flower-ct: calculate required key_layers
      nfp: flower-ct: compile match sections of flow_payload
      nfp: flower-ct: add actions into flow_pay for offload
      nfp: flower-ct: add flow_pay to the offload table
      nfp: flower-ct: add offload calls to the nfp
      nfp: flower-tc: add flow stats updates for ct

Luca Coelho (15):
      iwlwifi: print PNVM complete notification status in hexadecimal
      iwlwifi: pcie: remove spaces from queue names
      iwlwifi: mvm: remove check for vif in iwl_mvm_vif_from_mac80211()
      iwlwifi: rename ACPI_SAR_NUM_CHAIN_LIMITS to ACPI_SAR_NUM_CHAINS
      iwlwifi: convert flat SAR profile table to a struct version
      iwlwifi: remove ACPI_SAR_NUM_TABLES definition
      iwlwifi: pass number of chains and sub-bands to iwl_sar_set_profile()
      iwlwifi: acpi: support reading and storing WRDS revision 1 and 2
      iwlwifi: support reading and storing EWRD revisions 1 and 2
      iwlwifi: remove unused ACPI_WGDS_TABLE_SIZE definition
      iwlwifi: convert flat GEO profile table to a struct version
      iwlwifi: acpi: support reading and storing WGDS revision 2
      iwlwifi: bump FW API to 65 for AX devices
      iwlwifi: acpi: fill in WGDS table with defaults
      iwlwifi: acpi: fill in SAR tables with defaults

Luiz Augusto von Dentz (4):
      Bluetooth: HCI: Add proper tracking for enable status of adv instances
      Bluetooth: Fix not generating RPA when required
      Bluetooth: Fix handling of LE Enhanced Connection Complete
      Bluetooth: Store advertising handle so it can be re-enabled

Lukas Bulwahn (5):
      intersil: remove obsolete prism54 wireless driver
      net: Kconfig: remove obsolete reference to config MICROBLAZE_64K_PAGES
      net: 802: remove dead leftover after ipx driver removal
      net: dpaa_eth: remove dead select in menuconfig FSL_DPAA_ETH
      netfilter: x_tables: handle xt_register_template() returning an error value

Luke Hsiao (1):
      tcp: enable data-less, empty-cookie SYN with TFO_SERVER_COOKIE_NOT_REQD

Luo Jie (3):
      net: mdio: Add the reset function for IPQ MDIO driver
      MDIO: Kconfig: Specify more IPQ chipset supported
      dt-bindings: net: Add the properties for ipq4019 MDIO

Lv Ruyi (2):
      ipv6: remove duplicated 'net/lwtunnel.h' include
      ipv6: seg6: remove duplicated include

Magnus Karlsson (16):
      selftests: xsk: Remove color mode
      selftests: xsk: Remove the num_tx_packets option
      selftests: xsk: Remove unused variables
      selftests: xsk: Return correct error codes
      selftests: xsk: Simplify the retry code
      selftests: xsk: Remove end-of-test packet
      selftests: xsk: Disassociate umem size with packets sent
      selftests: xsk: Rename worker_* functions that are not thread entry points
      selftests: xsk: Simplify packet validation in xsk tests
      selftests: xsk: Validate tx stats on tx thread
      selftests: xsk: Decrease sending speed
      selftests: xsk: Simplify cleanup of ifobjects
      selftests: xsk: Generate packet directly in umem
      selftests: xsk: Generate packets from specification
      selftests: xsk: Make enums lower case
      selftests: xsk: Preface options with opt

Maor Dickman (1):
      net/mlx5: E-Switch, Set vhca id valid flag when creating indir fwd group

Maor Gottlieb (6):
      net/mlx5e: Rename traffic type enums
      net/mlx5e: Rename some related TTC args and functions
      net/mlx5e: Decouple TTC logic from mlx5e
      net/mlx5: Move TTC logic to fs_ttc
      net/mlx5: Embed mlx5_ttc_table
      net/mlx5: Fix inner TTC table creation

Marc Kleine-Budde (21):
      can: j1939: fix checkpatch warnings
      can: j1939: replace fall through comment by fallthrough pseudo-keyword
      can: j1939: j1939_session_completed(): use consistent name se_skb for the session skb
      can: j1939: j1939_session_tx_dat(): use consistent name se_skcb for session skb control buffer
      can: j1939: j1939_xtp_rx_dat_one(): use separate pointer for session skb control buffer
      can: rx-offload: add skb queue for use during ISR
      can: rx-offload: can_rx_offload_irq_finish(): directly call napi_schedule()
      can: rx-offload: can_rx_offload_threaded_irq_finish(): add new function to be called from threaded interrupt
      can: bittiming: fix documentation for struct can_tdc
      can: m_can: remove support for custom bit timing
      can: mcp251xfd: mcp251xfd_open(): request IRQ as shared
      can: peak_pci: convert comments to network style comments
      can: peak_pci: fix checkpatch warnings
      can: j1939: j1939_session_tx_dat(): fix typo
      can: flexcan: flexcan_clks_enable(): add missing variable initialization
      mailmap: update email address of Matthias Fuchs and Thomas Körper
      can: mcp251xfd: mark some instances of struct mcp251xfd_priv as const
      can: tcan4x5x: cdev_to_priv(): remove stray empty line
      can: m_can: fix block comment style
      can: c_can: c_can_do_tx(): fix typo in comment
      can: c_can: rename IF_RX -> IF_NAPI

Marek Vasut (1):
      net: phy: Fix data type in DP83822 dp8382x_disable_wol()

Mark Bloch (12):
      net/mlx5: Return mdev from eswitch
      net/mlx5: Lag, add initial logic for shared FDB
      RDMA/mlx5: Fill port info based on the relevant eswitch
      {net, RDMA}/mlx5: Extend send to vport rules
      RDMA/mlx5: Add shared FDB support
      net/mlx5: E-Switch, Add event callback for representors
      net/mlx5: Add send to vport rules on paired device
      net/mlx5: Lag, properly lock eswitch if needed
      net/mlx5: Lag, move lag destruction to a workqueue
      net/mlx5: E-Switch, add logic to enable shared FDB
      net/mlx5: Lag, Create shared FDB when in switchdev mode
      net/sched: cls_api, reset flags on replay

Mark Brown (1):
      net: mscc: Fix non-GPL export of regmap APIs

Mark Gray (4):
      openvswitch: Introduce per-cpu upcall dispatch
      openvswitch: update kdoc OVS_DP_ATTR_PER_CPU_PIDS
      openvswitch: fix alignment issues
      openvswitch: fix sparse warning incorrect type

Martin KaFai Lau (12):
      tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos
      tcp: seq_file: Refactor net and family matching
      bpf: tcp: seq_file: Remove bpf_seq_afinfo from tcp_iter_state
      tcp: seq_file: Add listening_get_first()
      tcp: seq_file: Replace listening_hash with lhash2
      bpf: tcp: Bpf iter batching and lock_sock
      bpf: tcp: Support bpf_(get|set)sockopt in bpf tcp iter
      bpf: selftest: Test batching and bpf_(get|set)sockopt in bpf tcp iter
      bpf: tcp: Allow bpf-tcp-cc to call bpf_(get|set)sockopt
      bpf: selftests: Add sk_state to bpf_tcp_helpers.h
      bpf: selftests: Add connect_to_fd_opts to network_helpers
      bpf: selftests: Add dctcp fallback test

Martin Kaiser (1):
      niu: read property length only if we use it

Martin Schiller (1):
      net: phy: intel-xway: Add RGMII internal delay configuration

Martynas Pumputis (5):
      libbpf: Fix reuse of pinned map on older kernel
      libbpf: Fix removal of inner map in bpf_object__create_map
      selftests/bpf: Check inner map deletion
      selftests/bpf: Mute expected invalid map creation error msg
      libbpf: Fix race when pinning maps in parallel

Matt Johnston (5):
      mctp: Add netlink route management
      mctp: Add neighbour implementation
      mctp: Add neighbour netlink interface
      mctp: Add dest neighbour lladdr to route output
      mctp: Allow per-netns default networks

Matt Kline (3):
      can: m_can: Disable IRQs on FIFO bus errors
      can: m_can: Batch FIFO reads during CAN receive
      can: m_can: Batch FIFO writes during CAN transmit

Matthew Cover (1):
      bpf, samples: Add missing mprog-disable to xdp_redirect_cpu's optstring

Matthieu Baerts (1):
      ipv6: fix "'ioam6_if_id_max' defined but not used" warn

Max Chou (1):
      Bluetooth: btusb: Remove WAKEUP_DISABLE and add WAKEUP_AUTOSUSPEND for Realtek devices

Maxim Mikityanskiy (21):
      net/mlx5e: Prohibit inner indir TIRs in IPoIB
      net/mlx5e: Block LRO if firmware asks for tunneled LRO
      net/mlx5: Take TIR destruction out of the TIR list lock
      net/mlx5e: Check if inner FT is supported outside of create/destroy functions
      net/mlx5e: Convert RQT to a dedicated object
      net/mlx5e: Move mlx5e_build_rss_params() call to init_rx
      net/mlx5e: Move RX resources to a separate struct
      net/mlx5e: Take RQT out of TIR and group RX resources
      net/mlx5e: Use mlx5e_rqt_get_rqtn to access RQT hardware id
      net/mlx5e: Remove mlx5e_priv usage from mlx5e_build_*tir_ctx*()
      net/mlx5e: Remove lro_param from mlx5e_build_indir_tir_ctx_common()
      net/mlx5e: Remove mdev from mlx5e_build_indir_tir_ctx_common()
      net/mlx5e: Create struct mlx5e_rss_params_hash
      net/mlx5e: Convert TIR to a dedicated object
      net/mlx5e: Move management of indir traffic types to rx_res
      net/mlx5e: Use the new TIR API for kTLS
      net/mlx5e: Use a new initializer to build uniform indir table
      net/mlx5e: Introduce mlx5e_channels API to get RQNs
      net/mlx5e: Hide all implementation details of mlx5e_rx_res
      net/mlx5e: Allocate the array of channels according to the real max_nch
      sch_htb: Fix inconsistency when leaf qdisc creation fails

Miaoqing Pan (1):
      ath9k: fix sleeping in atomic context

Michael Chan (4):
      bnxt_en: Move bnxt_ptp_init() from bnxt_open() back to bnxt_init_one()
      bnxt_en: Do not read the PTP PHC during chip reset
      bnxt_en: Don't use static arrays for completion ring pages
      bnxt_en: Increase maximum RX ring size if jumbo ring is not used

Michael Schmitz (2):
      ax88796: export ax_NS8390_init() hook
      xsurf100: drop include of lib8390.c

Michael Sun (2):
      Bluetooth: btusb: Add valid le states quirk
      Bluetooth: btusb: Enable MSFT extension for WCN6855 controller

MichelleJin (1):
      net: bridge: use mld2r_ngrec instead of icmpv6_dataun

Mikhail Rudenko (1):
      brcmfmac: use separate firmware for 43430 revision 2

Miri Korenblit (2):
      iwlwifi: mvm: Read the PPAG and SAR tables at INIT stage
      iwlwifi: mvm: load regdomain at INIT stage

Mordechay Goodstein (3):
      iwlwifi: iwl-nvm-parse: set STBC flags for HE phy capabilities
      iwlwifi: iwl-dbg-tlv: add info about loading external dbg bin
      iwlwifi: mvm: remove trigger EAPOL time event

Muhammad Falak R Wani (2):
      samples, bpf: Add an explict comment to handle nested vlan tagging.
      samples/bpf: Define MAX_ENTRIES instead of a magic number in offwaketime

Muhammad Husaini Zulkifli (2):
      igc: Set QBVCYCLET_S to 0 for TSN Basic Scheduling
      igc: Increase timeout value for Speed 100/1000/2500

Mukesh Sisodiya (2):
      iwlwifi: yoyo: cleanup internal buffer allocation in D3
      iwlwifi: yoyo: support for new DBGI_SRAM region

Nathan Chancellor (3):
      net: ethernet: stmmac: Do not use unreachable() in ipq806x_gmac_probe()
      cxgb4: Properly revert VPD changes
      rtlwifi: rtl8192de: Fix initialization of place in _rtl92c_phy_get_rightchnlplace()

Naveen Mamindlapalli (2):
      octeontx2-af: add proper return codes for AF mailbox handlers
      octeontx2-pf: send correct vlan priority mask to npc_install_flow_req

Neal Cardwell (1):
      tcp: more accurately check DSACKs to grow RACK reordering window

Neil Spring (1):
      tcp: enable mid stream window clamp

Nick Richardson (5):
      pktgen: Remove redundant clone_skb override
      pktgen: Parse internet mix (imix) input
      pktgen: Add imix distribution bins
      pktgen: Add output for imix results
      pktgen: Remove fill_imix_distribution() CONFIG_XFRM dependency

Niklas Söderlund (3):
      nfp: fix return statement in nfp_net_parse_meta()
      samples/bpf: xdpsock: Make the sample more useful outside the tree
      samples/bpf: xdpsock: Remove forward declaration of ip_fast_csum()

Nikolay Aleksandrov (52):
      net: bridge: multicast: factor out port multicast context
      net: bridge: multicast: factor out bridge multicast context
      net: bridge: multicast: use multicast contexts instead of bridge or port
      net: bridge: vlan: add global and per-port multicast context
      net: bridge: multicast: add vlan state initialization and control
      net: bridge: add vlan mcast snooping knob
      net: bridge: multicast: add helper to get port mcast context from port group
      net: bridge: multicast: use the port group to port context helper
      net: bridge: multicast: check if should use vlan mcast ctx
      net: bridge: multicast: add vlan querier and query support
      net: bridge: multicast: include router port vlan id in notifications
      net: bridge: vlan: add support for global options
      net: bridge: vlan: add support for dumping global vlan options
      net: bridge: vlan: notify when global options change
      net: bridge: vlan: add mcast snooping control
      net: bridge: multicast: fix igmp/mld port context null pointer dereferences
      net: bridge: multicast: add mdb context support
      net: bridge: multicast: add context support for host-joined groups
      net: bridge: fix ioctl locking
      net: bridge: fix ioctl old_deviceless bridge argument
      net: core: don't call SIOCBRADD/DELIF for non-bridge devices
      net: bridge: vlan: add support for mcast igmp/mld version global options
      net: bridge: vlan: add support for mcast last member count global option
      net: bridge: vlan: add support for mcast startup query count global option
      net: bridge: vlan: add support for mcast last member interval global option
      net: bridge: vlan: add support for mcast membership interval global option
      net: bridge: vlan: add support for mcast querier interval global option
      net: bridge: vlan: add support for mcast query interval global option
      net: bridge: vlan: add support for mcast query response interval global option
      net: bridge: vlan: add support for mcast startup query interval global option
      net: bridge: mcast: move querier state to the multicast context
      net: bridge: mcast: querier and query state affect only current context type
      net: bridge: vlan: add support for mcast querier global option
      net: bridge: vlan: add support for mcast router global option
      net: bridge: mcast: use the proper multicast context when dumping router ports
      net: bridge: vlan: use br_rports_fill_info() to export mcast router ports
      net: bridge: vlan: fix global vlan option range dumping
      net: bridge: mcast: record querier port device ifindex instead of pointer
      net: bridge: mcast: make sure querier port/address updates are consistent
      net: bridge: mcast: consolidate querier selection for ipv4 and ipv6
      net: bridge: mcast: dump ipv4 querier state
      net: bridge: mcast: dump ipv6 querier state
      net: bridge: vlan: dump mcast ctx querier state
      net: bridge: mcast: don't dump querier state if snooping is disabled
      net: bridge: mcast: drop sizeof for nest attribute's zero size
      net: bridge: mcast: account for ipv6 size when dumping querier state
      net: bridge: vlan: enable mcast snooping for existing master vlans
      net: bridge: vlan: account for router port lists when notifying
      net: bridge: mcast: use the correct vlan group helper
      net: bridge: mcast: toggle also host vlan state in br_multicast_toggle_vlan
      net: bridge: mcast: br_multicast_set_port_router takes multicast context as argument
      net: bridge: vlan: convert mcast router global option to per-vlan entry

Nithin Dabilpuram (3):
      octeontx2-af: Change the order of queue work and interrupt disable
      octeontx2-af: Wait for TX link idle for credits change
      octeontx2-af: enable tx shaping feature for 96xx C0

Oleksij Rempel (9):
      net: usb: asix: ax88772: do not poll for PHY before registering it
      net: usb: asix: ax88772: add missing stop
      net: selftests: add MTU test
      can: j1939: rename J1939_ERRQUEUE_* to J1939_ERRQUEUE_TX_*
      can: j1939: extend UAPI to notify about RX status
      net: phy: nxp-tja11xx: log critical health state
      dt-bindings: can-controller: add support for termination-gpios
      dt-bindings: can: fsl,flexcan: enable termination-* bindings
      can: dev: provide optional GPIO based termination support

Pablo Neira Ayuso (3):
      netfilter: nft_compat: use nfnetlink_unicast()
      netfilter: flowtable: remove nf_ct_l4proto_find() call
      netfilter: ctnetlink: missing counters and timestamp in nfnetlink_{log,queue}

Pali Rohár (3):
      phy: marvell: phy-mvebu-cp110-comphy: Rename HS-SGMMI to 2500Base-X
      phy: marvell: phy-mvebu-a3700-comphy: Rename HS-SGMMI to 2500Base-X
      phy: marvell: phy-mvebu-a3700-comphy: Remove unsupported modes

Paolo Abeni (29):
      veth: always report zero combined channels
      veth: factor out initialization helper
      veth: implement support for set_channel ethtool op
      veth: create by default nr_possible_cpus queues
      selftests: net: veth: add tests for set_channel
      sk_buff: introduce 'slow_gro' flags
      sk_buff: track dst status in slow_gro
      sk_buff: track extension status in slow_gro
      net: optimize GRO for the common case.
      skbuff: allow 'slow_gro' for skb carring sock reference
      veth: use skb_prepare_for_gro()
      sk_buff: avoid potentially clearing 'slow_gro' field
      net: fix GRO skb truesize update
      mptcp: more accurate timeout
      mptcp: less aggressive retransmission strategy
      mptcp: handle pending data on closed subflow
      mptcp: cleanup sysctl data and helpers
      mptcp: faster active backup recovery
      mptcp: add mibs for stale subflows processing
      mptcp: backup flag from incoming MPJ ack option
      selftests: mptcp: add testcase for active-back
      mptcp: optimize out option generation
      mptcp: shrink mptcp_out_options struct
      selftests/net: allow GRO coalesce test on veth
      mptcp: do not set unconditionally csum_reqd on incoming opt
      mptcp: better binary layout for mptcp_options_received
      mptcp: consolidate in_opt sub-options fields in a bitmask
      mptcp: optimize the input options processing
      mptcp: make the locking tx schema more readable

Parav Pandit (14):
      devlink: Add new "enable_eth" generic device param
      devlink: Add new "enable_rdma" generic device param
      devlink: Add new "enable_vnet" generic device param
      devlink: Create a helper function for one parameter registration
      devlink: Add API to register and unregister single parameter
      devlink: Add APIs to publish, unpublish individual parameter
      net/mlx5: Fix unpublish devlink parameters
      net/mlx5: Support enable_eth devlink dev param
      net/mlx5: Support enable_rdma devlink dev param
      net/mlx5: Support enable_vnet devlink dev param
      net/mlx5: SF, use recent sysfs api
      net/mlx5: Reorganize current and maximal capabilities to be per-type
      net/mlx5: Allocate individual capability
      net/mlx5: Initialize numa node for all core devices

Pauli Virtanen (1):
      Bluetooth: btusb: check conditions before enabling USB ALT 3 for WBS

Pavan Chebbi (4):
      bnxt_en: 1PPS support for 5750X family chips
      bnxt_en: 1PPS functions to configure TSIO pins
      bnxt_en: Event handler for PPS events
      bnxt_en: Log if an invalid signal detected on TSIO pin

Pavel Skripkin (6):
      net: cipso: fix warnings in netlbl_cipsov4_add_std
      net: xfrm: fix shift-out-of-bounce
      net: hso: drop unused function argument
      net: pch_gbe: remove mii_ethtool_gset() error handling
      net: mii: make mii_ethtool_gset() return void
      Bluetooth: add timeout sanity check to hci_inquiry

Pavel Tikhomirov (1):
      sock: allow reading and changing sk_userlocks with setsockopt

Paweł Drewniak (1):
      brcmfmac: Add WPA3 Personal with FT to supported cipher suites

Peilin Ye (4):
      netdevsim: Add multi-queue support
      net/sched: act_skbmod: Add SKBMOD_F_ECN option support
      tc-testing: Add control-plane selftest for skbmod SKBMOD_F_ECN option
      tc-testing: Add control-plane selftests for sch_mq

Peng Li (14):
      net: at91_can: remove redundant blank lines
      net: at91_can: add blank line after declarations
      net: at91_can: fix the code style issue about macro
      net: at91_can: use BIT macro
      net: at91_can: fix the alignment issue
      net: at91_can: add braces {} to all arms of the statement
      net: at91_can: remove redundant space
      net: at91_can: fix the comments style issue
      net: hns3: remove redundant param mbx_event_pending
      net: hns3: use memcpy to simplify code
      net: hns3: remove redundant param to simplify code
      net: hns3: package new functions to simplify hclgevf_mbx_handler code
      net: hns3: merge some repetitive macros
      net: hns3: reconstruct function hns3_self_test

Peter Collingbourne (1):
      net: don't unconditionally copy_from_user a struct ifreq for socket ioctls

Ping-Ke Shih (1):
      rtw88: wow: build wow function only if CONFIG_PM is on

Piotr Kwapulinski (1):
      i40e: add support for PTP external synchronization clock

Po-Hao Huang (2):
      rtw88: 8822c: add tx stbc support under HT mode
      rtw88: change beacon filter default mode

Po-Hsu Lin (1):
      selftests/net: Use kselftest skip code for skipped tests

Prankur Gupta (2):
      bpf: Add support for {set|get} socket options from setsockopt BPF
      selftests/bpf: Add tests for {set|get} socket option from setsockopt BPF

Quentin Monnet (14):
      libbpf: Return non-null error on failures in libbpf_find_prog_btf_id()
      libbpf: Rename btf__load() as btf__load_into_kernel()
      libbpf: Rename btf__get_from_id() as btf__load_from_kernel_by_id()
      tools: Free BTF objects at various locations
      tools: Replace btf__get_from_id() with btf__load_from_kernel_by_id()
      libbpf: Add split BTF support for btf__load_from_kernel_by_id()
      tools: bpftool: Support dumping split BTF by id
      tools: bpftool: Slightly ease bash completion updates
      selftests/bpf: Check consistency between bpftool source, doc, completion
      tools: bpftool: Complete and synchronise attach or map types
      tools: bpftool: Update and synchronise option list in doc and help msg
      selftests/bpf: Update bpftool's consistency script for checking options
      tools: bpftool: Document and add bash completion for -L, -B options
      tools: bpftool: Complete metrics list in "bpftool prog profile" doc

Radha Mohan Chintakuntla (1):
      octeontx2-af: Add SDP interface support

Rafał Miłecki (1):
      dt-bindings: net: brcm,unimac-mdio: convert to the json-schema

Rakesh Babu (1):
      octeontx2-pf: Ntuple filters support for VF netdev

Randy Dunlap (3):
      Bluetooth: btrsi: use non-kernel-doc comment for copyright
      ptp: ocp: don't allow on S390
      net: RxRPC: make dependent Kconfig symbols be shown indented

Rao Shoaib (3):
      af_unix: Add OOB support
      af_unix: fix holding spinlock in oob handling
      af_unix: check socket state when queuing OOB

Richard Laing (2):
      bus: mhi: pci-generic: configurable network interface MRU
      net: mhi: Improve MBIM packet counting

Rocco Yue (3):
      ipv6: remove unnecessary local variable
      net: add extack arg for link ops
      ipv6: add IFLA_INET6_RA_MTU to expose mtu value

Roi Dayan (9):
      net/mlx5e: Remove redundant tc act includes
      net/mlx5e: Remove redundant filter_dev arg from parse_tc_fdb_actions()
      net/mlx5e: Remove redundant cap check for flow counter
      net/mlx5e: Remove redundant parse_attr arg
      net/mlx5e: Remove redundant assignment of counter to null
      net/mlx5e: Return -EOPNOTSUPP if more relevant when parsing tc actions
      net/mlx5e: Add an option to create a shared mapping
      net/mlx5e: Use shared mappings for restoring from metadata
      net/mlx5e: Fix possible use-after-free deleting fdb rule

Ronak Doshi (7):
      vmxnet3: prepare for version 6 changes
      vmxnet3: add support for 32 Tx/Rx queues
      vmxnet3: remove power of 2 limitation on the queues
      vmxnet3: add support for ESP IPv6 RSS
      vmxnet3: set correct hash type based on rss information
      vmxnet3: increase maximum configurable mtu to 9190
      vmxnet3: update to version 6

Roy, UjjaL (1):
      bpf, doc: Add heading and example for extensions in cbpf

Russell King (1):
      net: phy: at803x: simplify custom phy id matching

Russell King (Oracle) (4):
      net: mvneta: deny disabling autoneg for 802.3z modes
      net: mvpp2: deny disabling autoneg for 802.3z modes
      net: phylink: add phy change pause mode debug
      net: phylink: cleanup ksettings_set

Ryoga Saito (1):
      netfilter: add netfilter hooks to SRv6 data plane

Saeed Mahameed (2):
      ethtool: Fix rxnfc copy to user buffer overflow
      net/mlx5e: Remove mlx5e dependency from E-Switch sample

Sandipan Das (1):
      MAINTAINERS: Remove self from powerpc BPF JIT

Sasha Neftin (9):
      e1000e: Add handshake with the CSME to support S0ix
      e1000e: Add polling mechanism to indicate CSME DPG exit
      e1000e: Additional PHY power saving in S0ix
      e1000e: Add support for Lunar Lake
      e1000e: Add support for the next LOM generation
      e1000e: Add space to the debug print
      igc: Check if num of q_vectors is smaller than max before array access
      igc: Remove _I_PHY_ID checking
      igc: Remove phy->type checking

Sean Anderson (1):
      brcmfmac: Set SDIO workqueue as WQ_HIGHPRI

Sebastian Andrzej Siewior (3):
      virtio_net: Replace deprecated CPU-hotplug functions.
      net: Replace deprecated CPU-hotplug functions.
      net/iucv: Replace deprecated CPU-hotplug functions.

Shai Malin (5):
      qed: Remove the qed module version
      qede: Remove the qede module version
      qed: Avoid db_recovery during recovery
      qed: Skip DORQ attention handling during recovery
      qed: Remove redundant prints from the iWARP SYN handling

Shannon Nelson (21):
      ionic: minimize resources when under kdump
      ionic: monitor fw status generation
      ionic: print firmware version on identify
      ionic: init reconfig err to 0
      ionic: use fewer inits on the buf_info struct
      ionic: increment num-vfs before configure
      ionic: remove unneeded comp union fields
      ionic: block some ethtool operations when fw in reset
      ionic: enable rxhash only with multiple queues
      ionic: add function tag to debug string
      ionic: remove old work task types
      ionic: flatten calls to set-rx-mode
      ionic: sync the filters in the work task
      ionic: refactor ionic_lif_addr to remove a layer
      ionic: handle mac filter overflow
      ionic: fire watchdog again after fw_down
      ionic: squelch unnecessary fw halted message
      ionic: fill mac addr earlier in add_addr
      ionic: add queue lock around open and stop
      ionic: pull hwstamp queue_lock up a level
      ionic: recreate hwstamp queues on ifup

Shaokun Zhang (2):
      netxen_nic: Remove the repeated declaration
      mctp: Remove the repeated declaration

Shaul Triebitz (4):
      iwlwifi: mvm: set BROADCAST_TWT_SUPPORTED in MAC policy
      iwlwifi: mvm: trigger WRT when no beacon heard
      iwlwifi: add 'Rx control frame to MBSSID' HE capability
      iwlwifi: mvm: support broadcast TWT alone

Shay Drory (3):
      net/mlx5: Align mlx5_irq structure
      net/mlx5: Change SF missing dedicated MSI-X err message to dbg
      net/mlx5: Refcount mlx5_irq with integer

Shuyi Cheng (3):
      libbpf: Introduce 'btf_custom_path' to 'bpf_obj_open_opts'
      libbpf: Fix the possible memory leak on error
      selftests/bpf: Switch existing selftests to using open_opts for custom BTF

Simon Wunderlich (1):
      batman-adv: Start new development cycle

Slark Xiao (1):
      net: Add depends on OF_NET for LiteX's LiteETH

Song Yoong Siang (1):
      net: phy: marvell: Add WAKE_PHY support to WOL event

Sriram R (1):
      cfg80211: use wiphy DFS domain if it is self-managed

Stanislav Fomichev (6):
      bpf: Increase supported cgroup storage value size
      selftests/bpf: Move netcnt test under test_progs
      bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_CGROUP_SOCKOPT
      selftests/bpf: Verify bpf_get_netns_cookie in BPF_PROG_TYPE_CGROUP_SOCKOPT
      bpf: Use kvmalloc for map values in syscall
      bpf: Use kvmalloc for map keys in syscalls

Steen Hegelund (2):
      net: sparx5: switchdev: adding frame DMA functionality
      arm64: dts: sparx5: Add the Sparx5 switch frame DMA support

Stefan Assmann (4):
      i40e: improve locking of mac_filter_hash
      iavf: do not override the adapter state in the watchdog task
      iavf: fix locking of critical sections
      iavf: use mutexes for locking of critical sections

Stefan Raspl (1):
      net/smc: Allow SMC-D 1MB DMB allocations

Stefan Wahren (1):
      net: qualcomm: fix QCA7000 checksum handling

Steffen Klassert (1):
      xfrm: Add possibility to set the default to block if we have no policy

Stephane Grosjean (5):
      can: peak_pci: Add name and FW version of the card in kernel buffer
      can: peak_usb: pcan_usb_get_device_id(): read value only in case of success
      can: peak_usb: PCAN-USB: add support of loopback and one-shot mode
      can: peak_usb: pcan_usb_encode_msg(): add information
      can: peak_usb: pcan_usb_decode_error(): upgrade handling of bus state changes

Subbaraya Sundeep (11):
      octeontx2-af: Modify install flow error codes
      octeontx2-af: Allocate low priority entries for PF
      octeontx2-pf: Allow VLAN priority also in ntuple filters
      octeontx2-pf: Fix NIX1_RX interface backpressure
      octeontx2-af: cn10k: Fix SDP base channel number
      octeontx2-pf: cleanup transmit link deriving logic
      octeontx2-af: Add PTP device id for CN10K and 95O silcons
      octeontx2-pf: Add vlan-etype to ntuple filters
      octeontx2-af: Fix loop in free and unmap counter
      octeontx2-af: Fix mailbox errors in nix_rss_flowkey_cfg
      octeontx2-af: Fix static code analyzer reported issues

Sudarsana Reddy Kalluru (1):
      atlantic: Fix driver resume flow.

Sunil Goutham (15):
      octeontx2-af: cn10k: DWRR MTU configuration
      octeontx2-pf: cn10k: Config DWRR weight based on MTU
      octeontx2-af: Add debug messages for failures
      octeontx2-pf: Enable NETIF_F_RXALL support for VF driver
      octeontx2-pf: Sort the allocated MCAM entry indices
      octeontx2-pf: Unify flow management variables
      octeontx2-pf: devlink params support to set mcam entry count
      octeontx2-pf: Add check for non zero mcam flows
      octeontx2-pf: Don't install VLAN offload rule if netdev is down
      octeontx2-pf: Fix algorithm index in MCAM rules with RSS action
      octeontx2-af: Remove channel verification while installing MCAM rules
      octeontx2-af: Add mbox to retrieve bandwidth profile free count
      octeontx2-pf: Fix inconsistent license text
      octeontx2-af: Fix inconsistent license text
      octeontx2-af: Set proper errorcode for IPv4 checksum errors

Sven Eckelmann (8):
      batman-adv: Move IRC channel to hackint.org
      batman-adv: Switch to kstrtox.h for kstrtou64
      batman-adv: Check ptr for NULL before reducing its refcnt
      batman-adv: Drop NULL check before dropping references
      batman-adv: Move IRC channel to hackint.org
      batman-adv: Switch to kstrtox.h for kstrtou64
      batman-adv: Check ptr for NULL before reducing its refcnt
      batman-adv: Drop NULL check before dropping references

Tal Gilboa (1):
      IB/mlx5: Rename is_apu_thread_cq function to is_apu_cq

Tang Bin (5):
      bcm63xx_enet: delete a redundant assignment
      via-rhine: Use of_device_get_match_data to simplify code
      via-velocity: Use of_device_get_match_data to simplify code
      can: mscan: mpc5xxx_can: mpc5xxx_can_probe(): use of_device_get_match_data to simplify code
      can: mscan: mpc5xxx_can: mpc5xxx_can_probe(): remove useless BUG_ON()

Tariq Toukan (11):
      net/mlx5e: Do not try enable RSS when resetting indir table
      net/mlx5e: Introduce TIR create/destroy API in rx_res
      net/mlx5e: Introduce abstraction of RSS context
      net/mlx5e: Convert RSS to a dedicated object
      net/mlx5e: Dynamically allocate TIRs in RSS contexts
      net/mlx5e: Support multiple RSS contexts
      net/mlx5e: Support flow classification into RSS contexts
      net/mlx5e: Abstract MQPRIO params
      net/mlx5e: Maintain MQPRIO mode parameter
      net/mlx5e: Handle errors of netdev_set_num_tc()
      net/mlx5e: Support MQPRIO channel mode

Tedd Ho-Jeong An (13):
      Bluetooth: mgmt: Fix wrong opcode in the response for add_adv cmd
      Bluetooth: Add support hdev to allocate private data
      Bluetooth: btintel: Add combined setup and shutdown functions
      Bluetooth: btintel: Refactoring setup routine for legacy ROM sku
      Bluetooth: btintel: Add btintel data struct
      Bluetooth: btintel: Fix the first HCI command not work with ROM device
      Bluetooth: btintel: Fix the LED is not turning off immediately
      Bluetooth: btintel: Add combined set_diag functions
      Bluetooth: btintel: Refactoring setup routine for bootloader devices
      Bluetooth: btintel: Move hci quirks to setup routine
      Bluetooth: btintel: Clean the exported function to static
      Bluetooth: btintel: Fix the legacy bootloader returns tlv based version
      Bluetooth: btintel: Combine setting up MSFT extension

Tetsuo Handa (1):
      Bluetooth: defer cleanup of resources in hci_unregister_dev()

Tobias Klauser (1):
      selftests/bpf: Remove unused variable in tc_tunnel prog

Tobias Waldekranz (4):
      net: bridge: disambiguate offload_fwd_mark
      net: bridge: switchdev: recycle unused hwdoms
      net: bridge: switchdev: allow the TX data plane forwarding to be offloaded
      net: dsa: tag_dsa: offload the bridge forwarding process

Tom Rix (1):
      iwlwifi: remove trailing semicolon in macro definition

Tonghao Zhang (1):
      qdisc: add new field for qdisc_enqueue tracepoint

Tree Davies (1):
      net/e1000e: Fix spelling mistake "The" -> "This"

Tsuchiya Yuto (1):
      mwifiex: pcie: add reset_d3cold quirk for Surface gen4+ devices

Tuo Li (1):
      mwifiex: drop redundant null-pointer check in mwifiex_dnld_cmd_to_fw()

Ugo Rémery (1):
      rtw88: add quirk to disable pci caps on HP Pavilion 14-ce0xxx

Vadim Fedorenko (2):
      net: ipv6: introduce ip6_dst_mtu_maybe_forward
      net: ipv4: Consolidate ipv4_mtu and ip_dst_mtu_maybe_forward

Vasily Averin (13):
      memcg: enable accounting for net_device and Tx/Rx queues
      memcg: enable accounting for IP address and routing-related objects
      memcg: enable accounting for inet_bin_bucket cache
      memcg: enable accounting for VLAN group array
      memcg: ipv6/sit: account and don't WARN on ip_tunnel_prl structs allocation
      memcg: enable accounting for scm_fp_list objects
      skbuff: introduce skb_expand_head()
      ipv6: use skb_expand_head in ip6_finish_output2
      ipv6: use skb_expand_head in ip6_xmit
      ipv4: use skb_expand_head in ip_finish_output2
      vrf: use skb_expand_head in vrf_finish_output
      ax25: use skb_expand_head
      bpf: use skb_expand_head in bpf_out_neigh_v4/6

Vidya (1):
      octeontx2-af: configure npc for cn10k to allow packets from cpt

Vignesh Raghavendra (1):
      net: ti: am65-cpsw-nuss: fix RX IRQ state after .ndo_stop()

Vijayakannan Ayyathurai (2):
      net: stmmac: add ethtool per-queue statistic framework
      net: stmmac: add ethtool per-queue irq statistic support

Vincent Li (1):
      selftests, bpf: test_tc_tunnel.sh nc: Cannot use -p and -l

Vincent Mailhol (11):
      can: netlink: clear data_bittiming if FD is turned off
      can: netlink: remove redundant check in can_validate()
      can: etas_es58x: fix three typos in author name and documentation
      can: etas_es58x: use error pointer during device probing
      can: etas_es58x: use devm_kzalloc() to allocate device resources
      can: etas_es58x: add es58x_free_netdevs() to factorize code
      can: etas_es58x: use sizeof and sizeof_field macros instead of constant values
      can: etas_es58x: rewrite the message cast in es58{1,_fd}_tx_can_msg to increase readability
      can: netlink: allow user to turn off unsupported features
      MAINTAINERS: add Vincent MAILHOL as maintainer for the ETAS ES58X CAN/USB driver
      can: etas_es58x: clean-up documentation of struct es58x_fd_tx_conf_msg

Vinicius Costa Gomes (7):
      igc: Allow for Flex Filters to be installed
      Revert "PCI: Make pci_enable_ptm() private"
      PCI: Add pcie_ptm_enabled()
      igc: Enable PCIe PTM
      igc: Add support for PTP getcrosststamp()
      igc: Use default cycle 'start' and 'end' values for queues
      igc: Simplify TSN flags handling

Vlad Buslov (6):
      net/mlx5: Bridge, release bridge in same function where it is taken
      net/mlx5: Bridge, obtain core device from eswitch instead of priv
      net/mlx5: Bridge, identify port by vport_num+esw_owner_vhca_id pair
      net/mlx5: Bridge, extract FDB delete notification to function
      net/mlx5: Bridge, allow merged eswitch connectivity
      net/mlx5: Bridge, support LAG

Vladimir Oltean (99):
      net: dsa: sja1105: delete the best_effort_vlan_filtering mode
      net: dsa: tag_8021q: use "err" consistently instead of "rc"
      net: dsa: tag_8021q: use symbolic error names
      net: dsa: tag_8021q: remove struct packet_type declaration
      net: dsa: tag_8021q: create dsa_tag_8021q_{register,unregister} helpers
      net: dsa: build tag_8021q.c as part of DSA core
      net: dsa: let the core manage the tag_8021q context
      net: dsa: make tag_8021q operations part of the core
      net: dsa: tag_8021q: absorb dsa_8021q_setup into dsa_tag_8021q_{,un}register
      net: dsa: tag_8021q: manage RX VLANs dynamically at bridge join/leave time
      net: dsa: tag_8021q: add proper cross-chip notifier support
      net: switchdev: introduce helper for checking dynamically learned FDB entries
      net: switchdev: introduce a fanout helper for SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
      net: dsa: use switchdev_handle_fdb_{add,del}_to_device
      net: phy: at803x: finish the phy id checking simplification
      net: switchdev: remove stray semicolon in switchdev_handle_fdb_del_to_device shim
      net: switchdev: recurse into __switchdev_handle_fdb_del_to_device
      net: dpaa2-switch: use extack in dpaa2_switch_port_bridge_join
      net: dpaa2-switch: refactor prechangeupper sanity checks
      net: bridge: switchdev: let drivers inform which bridge ports are offloaded
      net: bridge: guard the switchdev replay helpers against a NULL notifier block
      net: bridge: move the switchdev object replay helpers to "push" mode
      net: switchdev: fix FDB entries towards foreign ports not getting propagated to us
      net: dsa: track the number of switches in a tree
      net: dsa: add support for bridge TX forwarding offload
      net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in the PVT
      net: bridge: fix build when setting skb->offload_fwd_mark with CONFIG_NET_SWITCHDEV=n
      net: bridge: update BROPT_VLAN_ENABLED before notifying switchdev in br_vlan_filter_toggle
      net: bridge: add a helper for retrieving port VLANs from the data path
      net: dsa: sja1105: delete vlan delta save/restore logic
      net: dsa: sja1105: deny 8021q uppers on ports
      net: dsa: sja1105: deny more than one VLAN-aware bridge
      net: dsa: sja1105: add support for imprecise RX
      net: dsa: sja1105: add bridge TX data plane offload based on tag_8021q
      Revert "net: dsa: Allow drivers to filter packets they can decode source port from"
      net: build all switchdev drivers as modules when the bridge is a module
      net: bridge: switchdev: replay the entire FDB for each port
      net: bridge: switchdev: treat local FDBs the same as entries towards the bridge
      net: dsa: sja1105: be stateless when installing FDB entries
      net: dsa: sja1105: reset the port pvid when leaving a VLAN-aware bridge
      net: dsa: sja1105: make sure untagged packets are dropped on ingress ports with no pvid
      net: dsa: tag_sja1105: fix control packets on SJA1110 being received on an imprecise port
      net: dsa: don't set skb->offload_fwd_mark when not offloading the bridge
      net: dsa: mt7530: drop paranoid checks in .get_tag_protocol()
      net: dsa: remove the struct packet_type argument from dsa_device_ops::rcv()
      net: bridge: switchdev: fix incorrect use of FDB flags when picking the dst device
      net: dsa: tag_sja1105: consistently fail with arbitrary input
      net: make switchdev_bridge_port_{,unoffload} loosely coupled with the bridge
      Revert "net: build all switchdev drivers as modules when the bridge is a module"
      net: dsa: rename teardown_default_cpu to teardown_cpu_ports
      net: dsa: give preference to local CPU ports
      net: dsa: sja1105: configure the cascade ports based on topology
      net: dsa: sja1105: manage the forwarding domain towards DSA ports
      net: dsa: sja1105: manage VLANs on cascade ports
      net: dsa: sja1105: increase MTU to account for VLAN header on DSA ports
      net: dsa: sja1105: suppress TX packets from looping back in "H" topologies
      net: dsa: sja1105: enable address learning on cascade ports
      net: dsa: tag_sja1105: optionally build as module when switch driver is module if PTP is enabled
      net: dsa: stop syncing the bridge mcast_router attribute at join time
      net: dsa: mt7530: remove the .port_set_mrouter implementation
      net: dsa: don't disable multicast flooding to the CPU even without an IGMP querier
      net: dsa: don't fast age standalone ports
      net: dsa: centralize fast ageing when address learning is turned off
      net: dsa: don't fast age bridge ports with learning turned off
      net: dsa: flush the dynamic FDB of the software bridge when fast ageing a port
      net: dsa: sja1105: rely on DSA core tracking of port learning state
      net: dsa: sja1105: add FDB fast ageing support
      net: dsa: still fast-age ports joining a bridge if they can't configure learning
      net: dsa: avoid fast ageing twice when port leaves a bridge
      net: dsa: create a helper that strips EtherType DSA headers on RX
      net: dsa: create a helper which allocates space for EtherType DSA headers
      net: dsa: create a helper for locating EtherType DSA headers on RX
      net: dsa: create a helper for locating EtherType DSA headers on TX
      net: dsa: print more information when a cross-chip notifier fails
      net: dsa: tag_8021q: don't broadcast during setup/teardown
      net: dsa: tag_8021q: fix notifiers broadcast when they shouldn't, and vice versa
      net: dsa: felix: stop calling ocelot_port_{enable,disable}
      net: mscc: ocelot: convert to phylink
      net: dsa: sja1105: reorganize probe, remove, setup and teardown ordering
      net: dsa: tag_sja1105: be dsa_loop-safe
      net: dpaa2-switch: phylink_disconnect_phy needs rtnl_lock
      net: dpaa2-switch: call dpaa2_switch_port_disconnect_mac on probe error path
      net: mscc: ocelot: allow probing to continue with ports that fail to register
      net: mscc: ocelot: transmit the "native VLAN" error via extack
      net: mscc: ocelot: transmit the VLAN filtering restrictions via extack
      net: mscc: ocelot: use helpers for port VLAN membership
      docs: devlink: remove the references to sja1105
      docs: net: dsa: sja1105: update list of limitations
      docs: net: dsa: remove references to struct dsa_device_ops::filter
      docs: net: dsa: document the new methods for bridge TX forwarding offload
      net: dsa: track unique bridge numbers across all DSA switch trees
      net: dsa: don't call switchdev_bridge_port_unoffload for unoffloaded bridge ports
      net: dsa: properly fall back to software bridging
      net: dsa: don't advertise 'rx-vlan-filter' when not needed
      net: dsa: let drivers state that they need VLAN filtering while standalone
      net: dsa: sja1105: prevent tag_8021q VLANs from being received on user ports
      net: dsa: sja1105: drop untagged packets on the CPU and DSA ports
      net: dsa: tag_sja1105: stop asking the sja1105 driver in sja1105_xmit_tpid
      net: phy: marvell10g: fix broken PHY interrupts for anyone after us in the driver probe list

Voon Weifeng (2):
      net: phy: marvell10g: enable WoL for 88X3310 and 88E2110
      net: stmmac: fix INTR TBU status affecting irq count statistic

Wai Paulo Valerio Wang (1):
      Bluetooth: btusb: Add support for IMC Networks Mediatek Chip

Wei Wang (1):
      net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()

Wei Yongjun (2):
      wwan: mhi: Fix missing spin_lock_init() in mhi_mbim_probe()
      iwlwifi: mvm: fix old-style static const declaration

Wen Gong (3):
      ieee80211: add definition of regulatory info in 6 GHz operation information
      ieee80211: add definition for transmit power envelope element
      mac80211: parse transmit power envelope element

Wentao_Liang (1):
      net/mlx5: DR, fix a potential use-after-free bug

Wong Vee Khee (1):
      net: pcs: xpcs: Add Pause Mode support for SGMII and 2500BaseX

Xin Long (2):
      tipc: keep the skb in rcv queue until the whole data is read
      tipc: fix an use-after-free issue in tipc_recvmsg

Xiyu Yang (1):
      net: sched: Fix qdisc_rate_table refcount leak when get tcf_block failed

Xu Liang (2):
      net: phy: add API to read 802.3-c45 IDs
      net: phy: add Maxlinear GPY115/21x/24x driver

Xu Liu (4):
      bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SOCK_OPS
      selftests/bpf: Test for get_netns_cookie
      bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SK_MSG
      selftests/bpf: Test for get_netns_cookie

Yajun Deng (14):
      rtnetlink: use nlmsg_notify() in rtnetlink_send()
      net/sched: Remove unnecessary if statement
      netlink: Deal with ESRCH error in nlmsg_notify()
      net: netlink: add the case when nlh is NULL
      net: convert fib_treeref from int to refcount_t
      net: netlink: Remove unused function
      net: Keep vertical alignment
      net: decnet: Fix refcount warning for new dn_fib_info
      net: Remove redundant if statements
      netdevice: add the case if dev is NULL
      net: procfs: add seq_puts() statement for dev_mcast
      net: net_namespace: Optimize the code
      net: ipv4: Move ip_options_fragment() out of loop
      net: ipv4: Fix the warning for dereference

Yang Yang (1):
      net: ipv4: add capability check for net administration

Yang Yingliang (4):
      can: m_can: use devm_platform_ioremap_resource_byname
      nfp: flower-ct: fix error return code in nfp_fl_ct_add_offload()
      octeontx2-pf: cn10k: Fix error return code in otx2_set_flowkey_cfg()
      net: w5100: check return value after calling platform_get_resource()

Yevgeny Kliteynik (16):
      net/mlx5: DR, Added support for REMOVE_HEADER packet reformat
      net/mlx5: DR, Split modify VLAN state to separate pop/push states
      net/mlx5: DR, Enable VLAN pop on TX and VLAN push on RX
      net/mlx5: DR, Enable QP retransmission
      net/mlx5: DR, Improve error flow in actions_build_ste_arr
      net/mlx5: DR, Warn and ignore SW steering rule insertion on QP err
      net/mlx5: DR, Support IPv6 matching on flow label for STEv0
      net/mlx5: DR, replace uintN_t with kernel-style types
      net/mlx5: DR, Use FW API when updating FW-owned flow table
      net/mlx5: DR, Add ignore_flow_level support for multi-dest flow tables
      net/mlx5: DR, Skip source port matching on FDB RX domain
      net/mlx5: DR, Merge DR_STE_SIZE enums
      net/mlx5: DR, Remove HW specific STE type from nic domain
      net/mlx5: DR, Remove rehash ctrl struct from dr_htbl
      net/mlx5: DR, Improve rule tracking memory consumption
      net/mlx5: DR, Add support for update FTE

Yinjun Zhang (2):
      nfp: flower: make the match compilation functions reusable
      nfp: add support for coalesce adaptive feature

Yonghong Song (4):
      bpf: Emit better log message if bpf_iter ctx arg btf_id == 0
      selftests/bpf: Replace CHECK with ASSERT_* macros in send_signal.c
      selftests/bpf: Fix flaky send_signal test
      bpf: Fix NULL event->prog pointer access in bpf_overflow_handler

Yonglong Li (6):
      mptcp: move drop_other_suboptions check under pm lock
      mptcp: make MPTCP_ADD_ADDR_SIGNAL and MPTCP_ADD_ADDR_ECHO separate
      mptcp: fix ADD_ADDR and RM_ADDR maybe flush addr_signal each other
      mptcp: build ADD_ADDR/echo-ADD_ADDR option according pm.add_signal
      mptcp: remove MPTCP_ADD_ADDR_IPV6 and MPTCP_ADD_ADDR_PORT
      selftests: mptcp: add_addr and echo race test

Yuchung Cheng (1):
      tcp: more accurately detect spurious TLP probes

Yucong Sun (9):
      selftests/bpf: Add exponential backoff to map_update_retriable in test_maps
      selftests/bpf: Add exponential backoff to map_delete_retriable in test_maps
      selftests/bpf: Skip loading bpf_testmod when using -l to list tests.
      selftests/bpf: Correctly display subtest skip status
      selftests/bpf: Also print test name in subtest status message
      selftests/bpf: Support glob matching for test selector.
      selftests/bpf: Adding delay in socketmap_listen to reduce flakyness
      selftests/bpf: Reduce flakyness in timer_mim
      selftests/bpf: Reduce more flakyness in sockmap_listen

YueHaibing (1):
      mac80211: Reject zero MAC address in sta_info_insert_check()

Yufeng Mo (11):
      net: hns3: add support for registering devlink for PF
      net: hns3: add support for registering devlink for VF
      net: hns3: add support for devlink get info for PF
      net: hns3: add support for devlink get info for VF
      bonding: 3ad: fix the concurrency between __bond_release_one() and bond_3ad_state_machine_handler()
      net: hns3: add support for triggering reset by ethtool
      ethtool: add two coalesce attributes for CQE mode
      ethtool: extend coalesce setting uAPI with CQE mode
      net: hns3: add support for EQE/CQE mode configuration
      net: hns3: add ethtool support for CQE/EQE mode configuration
      net: hns3: add trace event in hclge_gen_resp_to_vf()

Yunsheng Lin (6):
      page_pool: keep pp info as long as page pool owns the page
      page_pool: add interface to manipulate frag count in page pool
      page_pool: add frag page recycling support in page pool
      net: hns3: support skb's frag page recycling based on page pool
      page_pool: use relaxed atomic for release side accounting
      sock: remove one redundant SKB_FRAG_PAGE_ORDER macro

Zekun Shen (1):
      ath9k: fix OOB read ar9300_eeprom_restore_internal

Zenghui Yu (2):
      bcma: Fix memory leak for internally-handled cores
      bcma: Drop the unused parameter of bcma_scan_read32()

Zhang Qilong (1):
      iwlwifi: mvm: fix a memory leak in iwl_mvm_mac_ctxt_beacon_changed

Zhen Lei (3):
      can: esd_usb2: use DEVICE_ATTR_RO() helper macro
      can: janz-ican3: use DEVICE_ATTR_RO/RW() helper macro
      can: at91_can: use DEVICE_ATTR_RW() helper macro

Zheng Yongjun (1):
      iwlwifi: use DEFINE_MUTEX() for mutex lock

Zvi Effron (4):
      bpf: Add function for XDP meta data length check
      bpf: Support input xdp_md context in BPF_PROG_TEST_RUN
      bpf: Support specifying ingress via xdp_md context in BPF_PROG_TEST_RUN
      selftests/bpf: Add test for xdp_md context in BPF_PROG_TEST_RUN

chongjiapeng (1):
      net: phy: Remove unused including <linux/version.h>

dingsenjie (2):
      libertas: Remove unnecessary label of lbs_ethtool_get_eeprom
      mac80211: Remove unnecessary variable and label

grantseltzer (1):
      bpf: Reconfigure libbpf docs to remove unversioned API

gushengxian (1):
      can: j1939: j1939_sk_sock_destruct(): correct a grammatical error

jing yangyang (1):
      tools/net: Use bitwise instead of arithmetic operator for flags

mark-yw.chen (4):
      Bluetooth: btusb: Enable MSFT extension for Mediatek Chip (MT7921)
      Bluetooth: btusb: Record debug log for Mediatek Chip.
      Bluetooth: btusb: Support Bluetooth Reset for Mediatek Chip(MT7921)
      Bluetooth: btusb: Fix fall-through warnings

wengjianfeng (2):
      nfc: s3fwrn5: remove unnecessary label
      wilc1000: remove redundant code

zhouchuangao (1):
      qed: Remove duplicated include of kernel.h

王贇 (1):
      net: fix NULL pointer reference in cipso_v4_doi_free

 .mailmap                                           |    2 +
 Documentation/admin-guide/kernel-parameters.txt    |    2 -
 Documentation/bpf/index.rst                        |   10 +-
 Documentation/bpf/libbpf/{libbpf.rst => index.rst} |    8 +
 Documentation/bpf/libbpf/libbpf_api.rst            |   27 -
 .../bpf/libbpf/libbpf_naming_convention.rst        |    2 +-
 .../devicetree/bindings/net/brcm,unimac-mdio.txt   |   43 -
 .../devicetree/bindings/net/brcm,unimac-mdio.yaml  |   84 +
 .../devicetree/bindings/net/can/bosch,c_can.yaml   |  119 +
 .../devicetree/bindings/net/can/bosch,m_can.yaml   |    9 +
 .../devicetree/bindings/net/can/c_can.txt          |   65 -
 .../bindings/net/can/can-controller.yaml           |    9 +
 .../devicetree/bindings/net/can/fsl,flexcan.yaml   |   17 +
 .../bindings/net/can/renesas,rcar-canfd.yaml       |   69 +-
 Documentation/devicetree/bindings/net/fsl,fec.yaml |  244 ++
 Documentation/devicetree/bindings/net/fsl-fec.txt  |   95 -
 .../bindings/net/intel,ixp46x-ptp-timer.yaml       |   54 +
 .../devicetree/bindings/net/litex,liteeth.yaml     |   98 +
 Documentation/devicetree/bindings/net/macb.txt     |    1 +
 .../devicetree/bindings/net/qcom,ipa.yaml          |   24 +-
 .../devicetree/bindings/net/qcom,ipq4019-mdio.yaml |   15 +-
 Documentation/driver-api/nfc/nfc-hci.rst           |    2 +-
 Documentation/networking/batman-adv.rst            |    2 +-
 Documentation/networking/bonding.rst               |   12 +
 .../ethernet/freescale/dpaa2/index.rst             |    1 +
 .../ethernet/freescale/dpaa2/switch-driver.rst     |  217 ++
 .../device_drivers/ethernet/mellanox/mlx5.rst      |   44 +
 .../networking/devlink/devlink-params.rst          |   12 +
 Documentation/networking/devlink/hns3.rst          |   25 +
 Documentation/networking/devlink/index.rst         |    2 +-
 Documentation/networking/devlink/sja1105.rst       |   49 -
 Documentation/networking/dsa/dsa.rst               |   29 +-
 Documentation/networking/dsa/sja1105.rst           |  218 +-
 Documentation/networking/ethtool-netlink.rst       |   23 +
 Documentation/networking/filter.rst                |   27 +-
 Documentation/networking/index.rst                 |    2 +
 Documentation/networking/ioam6-sysctl.rst          |   26 +
 Documentation/networking/ip-sysctl.rst             |   17 +
 Documentation/networking/mctp.rst                  |  213 ++
 Documentation/networking/mptcp-sysctl.rst          |   12 +
 Documentation/networking/netdevices.rst            |   29 +
 Documentation/networking/nf_conntrack-sysctl.rst   |    7 +
 Documentation/networking/pktgen.rst                |   18 +-
 Documentation/networking/timestamping.rst          |    6 +-
 Documentation/networking/vrf.rst                   |   13 +
 MAINTAINERS                                        |   47 +-
 arch/alpha/include/uapi/asm/socket.h               |    2 +
 arch/arm/boot/dts/imx35.dtsi                       |    2 +-
 arch/arm/boot/dts/imx6q-novena.dts                 |   34 +-
 arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi       |   18 +-
 arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi           |   34 +-
 arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi       |   34 +-
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi          |   34 +-
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi           |   34 +-
 arch/arm/boot/dts/imx7-mba7.dtsi                   |    1 -
 arch/arm/boot/dts/imx7d-mba7.dts                   |    1 -
 arch/arm/mach-ixp4xx/common.c                      |   14 +
 arch/arm64/boot/dts/freescale/imx8mm.dtsi          |    2 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi          |    2 +-
 arch/arm64/boot/dts/freescale/imx8qxp-ss-conn.dtsi |    4 +-
 arch/arm64/boot/dts/microchip/sparx5.dtsi          |    5 +-
 arch/arm64/include/asm/compat.h                    |   14 +-
 arch/mips/include/asm/compat.h                     |   24 +-
 arch/mips/include/uapi/asm/socket.h                |    2 +
 arch/parisc/include/asm/compat.h                   |   14 +-
 arch/parisc/include/uapi/asm/socket.h              |    2 +
 arch/powerpc/include/asm/compat.h                  |   11 -
 arch/s390/include/asm/ccwgroup.h                   |    2 -
 arch/s390/include/asm/compat.h                     |   14 +-
 arch/sparc/include/asm/compat.h                    |   14 +-
 arch/sparc/include/uapi/asm/socket.h               |    2 +
 arch/um/drivers/vector_kern.c                      |    8 +-
 arch/x86/include/asm/compat.h                      |   14 +-
 arch/x86/include/asm/signal.h                      |    1 +
 arch/x86/net/bpf_jit_comp.c                        |   19 +
 drivers/atm/horizon.c                              |    6 +-
 drivers/atm/idt77252.c                             |    2 +-
 drivers/bcma/main.c                                |    6 +-
 drivers/bcma/scan.c                                |    7 +-
 drivers/bluetooth/btbcm.c                          |    1 +
 drivers/bluetooth/btintel.c                        | 1314 ++++++++-
 drivers/bluetooth/btintel.h                        |  119 +-
 drivers/bluetooth/btmrvl_sdio.c                    |   29 +-
 drivers/bluetooth/btrsi.c                          |    2 +-
 drivers/bluetooth/btrtl.c                          |   10 +-
 drivers/bluetooth/btusb.c                          | 1510 +++-------
 drivers/bluetooth/hci_bcm.c                        |    6 +
 drivers/bluetooth/hci_h5.c                         |  116 +-
 drivers/bluetooth/hci_serdev.c                     |    3 +
 drivers/bluetooth/hci_uart.h                       |    7 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |    4 +-
 drivers/bus/mhi/pci_generic.c                      |    4 +
 drivers/char/pcmcia/synclink_cs.c                  |   23 +-
 drivers/infiniband/hw/mlx5/cq.c                    |    2 +-
 drivers/infiniband/hw/mlx5/devx.c                  |    7 +-
 drivers/infiniband/hw/mlx5/ib_rep.c                |   77 +-
 drivers/infiniband/hw/mlx5/main.c                  |   44 +-
 drivers/infiniband/hw/mlx5/std_types.c             |   10 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c       |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |    8 +-
 drivers/media/rc/bpf-lirc.c                        |    6 +-
 drivers/net/Kconfig                                |   17 +-
 drivers/net/Makefile                               |    6 +-
 drivers/net/Space.c                                |  178 +-
 drivers/net/appletalk/Kconfig                      |    4 +-
 drivers/net/appletalk/ipddp.c                      |   16 +-
 drivers/net/appletalk/ltpc.c                       |    7 +-
 drivers/net/bonding/bond_3ad.c                     |   11 +-
 drivers/net/bonding/bond_alb.c                     |   32 -
 drivers/net/bonding/bond_main.c                    |  591 +++-
 drivers/net/bonding/bond_netlink.c                 |   16 +
 drivers/net/bonding/bond_options.c                 |   27 +
 drivers/net/bonding/bond_procfs.c                  |    2 +
 drivers/net/bonding/bond_sysfs.c                   |   25 +-
 drivers/net/can/Kconfig                            |    3 +-
 drivers/net/can/at91_can.c                         |  137 +-
 drivers/net/can/c_can/c_can.h                      |   25 +-
 drivers/net/can/c_can/c_can_main.c                 |  123 +-
 drivers/net/can/c_can/c_can_platform.c             |    1 -
 drivers/net/can/dev/dev.c                          |   66 +
 drivers/net/can/dev/netlink.c                      |   11 +-
 drivers/net/can/dev/rx-offload.c                   |   90 +-
 drivers/net/can/flexcan.c                          |  129 +-
 drivers/net/can/janz-ican3.c                       |   23 +-
 drivers/net/can/m_can/m_can.c                      |  266 +-
 drivers/net/can/m_can/m_can.h                      |   11 +-
 drivers/net/can/m_can/m_can_pci.c                  |   11 +-
 drivers/net/can/m_can/m_can_platform.c             |   31 +-
 drivers/net/can/m_can/tcan4x5x-core.c              |   17 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |    7 +-
 drivers/net/can/rcar/Kconfig                       |    4 +-
 drivers/net/can/rcar/rcar_canfd.c                  |  338 ++-
 drivers/net/can/sja1000/peak_pci.c                 |  119 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   30 +-
 .../net/can/spi/mcp251xfd/mcp251xfd-timestamp.c    |    4 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |    2 +-
 drivers/net/can/ti_hecc.c                          |    2 +
 drivers/net/can/usb/esd_usb2.c                     |   12 +-
 drivers/net/can/usb/etas_es58x/es581_4.c           |    5 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   82 +-
 drivers/net/can/usb/etas_es58x/es58x_core.h        |    2 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.c          |   19 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.h          |   23 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  228 +-
 drivers/net/dsa/b53/b53_common.c                   |   10 -
 drivers/net/dsa/b53/b53_priv.h                     |    2 -
 drivers/net/dsa/bcm_sf2.c                          |    1 -
 drivers/net/dsa/hirschmann/hellcreek.c             |    1 +
 drivers/net/dsa/mt7530.c                           |  173 +-
 drivers/net/dsa/mt7530.h                           |   23 +-
 drivers/net/dsa/mv88e6xxx/Kconfig                  |    1 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |  103 +-
 drivers/net/dsa/ocelot/Kconfig                     |    2 +
 drivers/net/dsa/ocelot/felix.c                     |  153 +-
 drivers/net/dsa/ocelot/felix.h                     |    2 +-
 drivers/net/dsa/sja1105/Kconfig                    |    1 +
 drivers/net/dsa/sja1105/sja1105.h                  |   33 +-
 drivers/net/dsa/sja1105/sja1105_devlink.c          |  114 +-
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c   |    6 +-
 drivers/net/dsa/sja1105/sja1105_main.c             | 1960 +++++--------
 drivers/net/dsa/sja1105/sja1105_spi.c              |   10 -
 drivers/net/dsa/sja1105/sja1105_vl.c               |   14 +-
 drivers/net/eql.c                                  |   24 +-
 drivers/net/ethernet/3com/3c509.c                  |    7 +-
 drivers/net/ethernet/3com/3c515.c                  |    3 +-
 drivers/net/ethernet/3com/3c574_cs.c               |    2 +-
 drivers/net/ethernet/3com/3c59x.c                  |    4 +-
 drivers/net/ethernet/3com/Kconfig                  |    1 +
 drivers/net/ethernet/8390/Kconfig                  |    3 +
 drivers/net/ethernet/8390/apne.c                   |   11 +-
 drivers/net/ethernet/8390/ax88796.c                |    9 +-
 drivers/net/ethernet/8390/axnet_cs.c               |    2 +-
 drivers/net/ethernet/8390/ne.c                     |    5 +-
 drivers/net/ethernet/8390/pcnet_cs.c               |    2 +-
 drivers/net/ethernet/8390/smc-ultra.c              |    9 +-
 drivers/net/ethernet/8390/wd.c                     |    7 +-
 drivers/net/ethernet/8390/xsurf100.c               |    9 +-
 drivers/net/ethernet/Kconfig                       |    1 +
 drivers/net/ethernet/Makefile                      |    1 +
 drivers/net/ethernet/actions/Kconfig               |    4 +-
 drivers/net/ethernet/actions/owl-emac.c            |    6 +-
 drivers/net/ethernet/adaptec/starfire.c            |    2 +-
 drivers/net/ethernet/agere/et131x.c                |    2 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |    2 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |    8 +-
 drivers/net/ethernet/amd/Kconfig                   |    4 +-
 drivers/net/ethernet/amd/amd8111e.c                |    2 +-
 drivers/net/ethernet/amd/atarilance.c              |   11 +-
 drivers/net/ethernet/amd/au1000_eth.c              |    2 +-
 drivers/net/ethernet/amd/lance.c                   |    6 +-
 drivers/net/ethernet/amd/mvme147.c                 |   16 +-
 drivers/net/ethernet/amd/ni65.c                    |    6 +-
 drivers/net/ethernet/amd/pcnet32.c                 |    2 +-
 drivers/net/ethernet/amd/sun3lance.c               |   19 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |    2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c       |    8 +-
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |    8 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |    2 +-
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |   15 +-
 drivers/net/ethernet/arc/emac_main.c               |    2 +-
 drivers/net/ethernet/atheros/ag71xx.c              |    2 +-
 drivers/net/ethernet/atheros/alx/main.c            |    2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |    2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |    2 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |    2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c           |    2 +-
 drivers/net/ethernet/broadcom/Kconfig              |    6 +-
 drivers/net/ethernet/broadcom/b44.c                |    2 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |    5 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |    8 +-
 drivers/net/ethernet/broadcom/bgmac.c              |    2 +-
 drivers/net/ethernet/broadcom/bnx2.c               |   70 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |    8 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |    6 -
 drivers/net/ethernet/broadcom/bnxt/Makefile        |    2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 2312 ++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  135 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c      |  185 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   90 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  573 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c     |  763 +++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h     |  145 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |  391 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h      |   53 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |  455 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       |  264 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |   31 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c      |   62 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |    2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   12 +-
 drivers/net/ethernet/broadcom/sb1250-mac.c         |    2 +-
 drivers/net/ethernet/broadcom/tg3.c                |   81 +-
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c    |   12 +-
 drivers/net/ethernet/cadence/Kconfig               |    1 +
 drivers/net/ethernet/cadence/macb_main.c           |   13 +-
 drivers/net/ethernet/cavium/Kconfig                |    4 +-
 drivers/net/ethernet/cavium/liquidio/lio_ethtool.c |    8 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |   11 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c |    6 +-
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   |    2 +-
 drivers/net/ethernet/cavium/thunder/nic_main.c     |    8 +-
 .../net/ethernet/cavium/thunder/nicvf_ethtool.c    |    4 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   10 +-
 drivers/net/ethernet/chelsio/Kconfig               |    1 +
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |   10 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   32 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c           |  101 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |    8 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |    4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   17 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |    8 +-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   20 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c         |    8 +-
 drivers/net/ethernet/cirrus/Kconfig                |   27 +-
 drivers/net/ethernet/cirrus/cs89x0.c               |   31 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c           |    2 +-
 drivers/net/ethernet/cisco/enic/enic_ethtool.c     |    8 +-
 drivers/net/ethernet/cortina/gemini.c              |    8 +-
 drivers/net/ethernet/davicom/dm9000.c              |    2 +-
 drivers/net/ethernet/dec/tulip/de4x5.c             |   11 +-
 drivers/net/ethernet/dec/tulip/media.c             |    2 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c        |    2 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c       |    2 +-
 drivers/net/ethernet/dlink/dl2k.c                  |    2 +-
 drivers/net/ethernet/dlink/sundance.c              |    2 +-
 drivers/net/ethernet/dnet.c                        |    2 +-
 drivers/net/ethernet/ec_bhf.c                      |   10 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |    8 +-
 drivers/net/ethernet/ethoc.c                       |    2 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |    2 +-
 drivers/net/ethernet/faraday/ftmac100.c            |    2 +-
 drivers/net/ethernet/fealnx.c                      |    2 +-
 drivers/net/ethernet/freescale/Kconfig             |    2 +-
 drivers/net/ethernet/freescale/dpaa/Kconfig        |    1 -
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |    2 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |    8 +-
 drivers/net/ethernet/freescale/dpaa2/Makefile      |    2 +-
 .../ethernet/freescale/dpaa2/dpaa2-eth-devlink.c   |    7 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |    4 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |    8 +-
 .../freescale/dpaa2/dpaa2-switch-ethtool.c         |   56 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch-flower.c |  530 +++-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  384 ++-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.h    |   62 +-
 drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h    |   19 +
 drivers/net/ethernet/freescale/dpaa2/dpsw.c        |   80 +
 drivers/net/ethernet/freescale/dpaa2/dpsw.h        |   36 +
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |    8 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |    2 +-
 drivers/net/ethernet/freescale/enetc/enetc_vf.c    |    2 +-
 drivers/net/ethernet/freescale/fec.h               |   31 +
 drivers/net/ethernet/freescale/fec_main.c          |  212 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c       |    2 +-
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |    2 +-
 drivers/net/ethernet/freescale/gianfar.c           |    2 +-
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |    8 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |    2 +-
 drivers/net/ethernet/google/gve/gve_adminq.c       |    6 +-
 drivers/net/ethernet/hisilicon/Kconfig             |    4 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |    8 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c        |    2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |    2 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |   12 +-
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |    2 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |    5 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   17 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  228 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   37 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  265 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h |   31 +
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |    2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   75 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   34 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |   51 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |   70 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c |  148 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h |   15 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 1665 +++++++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  186 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   30 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   11 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h |    2 +-
 .../net/ethernet/hisilicon/hns3/hns3vf/Makefile    |    2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |   29 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |   16 +-
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c        |  150 +
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.h        |   15 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   31 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   25 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |  122 +-
 drivers/net/ethernet/huawei/hinic/hinic_devlink.c  |    8 +-
 drivers/net/ethernet/huawei/hinic/hinic_devlink.h  |    4 +-
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c  |    8 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |    2 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |   19 +-
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c    |    6 +-
 drivers/net/ethernet/i825xx/82596.c                |   24 +-
 drivers/net/ethernet/i825xx/sun3_82586.c           |   17 +-
 drivers/net/ethernet/ibm/emac/core.c               |    4 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |    2 +-
 drivers/net/ethernet/intel/Kconfig                 |   12 +-
 drivers/net/ethernet/intel/e100.c                  |    6 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |    8 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |    2 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c        |   10 +-
 drivers/net/ethernet/intel/e1000e/hw.h             |    9 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   13 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.h        |    3 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |  372 +--
 drivers/net/ethernet/intel/e1000e/ptp.c            |    1 +
 drivers/net/ethernet/intel/e1000e/regs.h           |    1 +
 drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c   |    8 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   78 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   12 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   32 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c         |  756 ++++-
 drivers/net/ethernet/intel/i40e/i40e_register.h    |   29 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   23 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |    9 +-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |   22 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  122 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c       |    4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   12 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   19 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   66 +-
 drivers/net/ethernet/intel/igb/e1000_mac.c         |    6 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   11 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |    2 +-
 drivers/net/ethernet/intel/igbvf/ethtool.c         |    8 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |    2 +-
 drivers/net/ethernet/intel/igc/igc.h               |   50 +-
 drivers/net/ethernet/intel/igc/igc_base.c          |   10 +-
 drivers/net/ethernet/intel/igc/igc_defines.h       |   91 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |   49 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |  465 +++-
 drivers/net/ethernet/intel/igc/igc_phy.c           |    6 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  179 ++
 drivers/net/ethernet/intel/igc/igc_regs.h          |   43 +
 drivers/net/ethernet/intel/igc/igc_tsn.c           |  176 +-
 drivers/net/ethernet/intel/igc/igc_tsn.h           |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |    8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    2 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c       |    8 +-
 drivers/net/ethernet/jme.c                         |   84 +-
 drivers/net/ethernet/korina.c                      |    2 +-
 drivers/net/ethernet/lantiq_etop.c                 |    2 +-
 drivers/net/ethernet/litex/Kconfig                 |   28 +
 drivers/net/ethernet/litex/Makefile                |    5 +
 drivers/net/ethernet/litex/litex_liteeth.c         |  314 +++
 drivers/net/ethernet/marvell/mv643xx_eth.c         |   14 +-
 drivers/net/ethernet/marvell/mvneta.c              |   44 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   27 +-
 drivers/net/ethernet/marvell/octeontx2/Kconfig     |    4 +-
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |    5 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |    5 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |    7 +-
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |    7 +-
 drivers/net/ethernet/marvell/octeontx2/af/common.h |   31 +-
 .../ethernet/marvell/octeontx2/af/lmac_common.h    |    3 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c   |    9 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  114 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |    9 +-
 .../ethernet/marvell/octeontx2/af/npc_profile.h    |    7 +-
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    |   46 +-
 drivers/net/ethernet/marvell/octeontx2/af/ptp.h    |    3 +-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    |    2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |    2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  226 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   65 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   19 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  |  127 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |    6 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |    7 +-
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    |  117 +-
 .../ethernet/marvell/octeontx2/af/rvu_devlink.h    |    2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  706 ++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    |   18 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  135 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |   76 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.c    |   11 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   16 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_sdp.c    |  108 +
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |    7 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_switch.c |    3 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_trace.c  |    5 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_trace.h  |   15 +-
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |    7 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |    8 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h |   21 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   84 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   46 +-
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c  |  156 ++
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.h  |   20 +
 .../ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c |    3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   72 +-
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  154 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   69 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  |    5 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.h  |    6 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |    7 +-
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |    7 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   58 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |    7 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |    7 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   42 +-
 .../ethernet/marvell/prestera/prestera_devlink.c   |    7 +-
 .../ethernet/marvell/prestera/prestera_devlink.h   |    2 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |    5 +-
 .../ethernet/marvell/prestera/prestera_switchdev.c |   12 +-
 .../ethernet/marvell/prestera/prestera_switchdev.h |    3 +-
 drivers/net/ethernet/marvell/pxa168_eth.c          |    2 +-
 drivers/net/ethernet/marvell/skge.c                |   10 +-
 drivers/net/ethernet/marvell/sky2.c                |   14 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |    2 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |    2 +-
 drivers/net/ethernet/mellanox/mlx4/Kconfig         |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |    8 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |    4 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   14 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   17 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c            |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   18 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |    8 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |   76 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  176 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h  |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   84 +-
 .../net/ethernet/mellanox/mlx5/core/en/channels.c  |   46 +
 .../net/ethernet/mellanox/mlx5/core/en/channels.h  |   16 +
 .../net/ethernet/mellanox/mlx5/core/en/devlink.c   |   10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   99 +-
 .../mellanox/mlx5/core/en/fs_tt_redirect.c         |   30 +-
 .../mellanox/mlx5/core/en/fs_tt_redirect.h         |    2 +-
 .../net/ethernet/mellanox/mlx5/core/en/mapping.c   |   45 +
 .../net/ethernet/mellanox/mlx5/core/en/mapping.h   |    5 +
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   12 +
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |    6 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |   17 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h   |    4 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |  329 ++-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   48 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |    8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c   |  170 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/rqt.h   |   42 +
 drivers/net/ethernet/mellanox/mlx5/core/en/rss.c   |  588 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en/rss.h   |   49 +
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.c    |  690 +++++
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.h    |   71 +
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.c   |  164 ++
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.h   |   35 +
 .../mellanox/mlx5/core/{esw => en/tc}/sample.c     |  474 ++--
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.h |   41 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  163 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |    6 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |    2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c   |  200 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.h   |   58 +
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  |   27 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.c  |    4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   72 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.h |    4 -
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  |   12 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |   13 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |   53 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |   25 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |   29 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  140 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  671 +----
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |  156 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  871 ++----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  172 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |    8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  323 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |    1 +
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c       |   16 +
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  359 ++-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.h   |   46 +-
 .../ethernet/mellanox/mlx5/core/esw/bridge_priv.h  |    9 +
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |   26 +
 .../mlx5/core/esw/diag/bridge_tracepoint.h         |    9 +-
 .../mellanox/mlx5/core/esw/diag/qos_tracepoint.h   |  123 +
 .../ethernet/mellanox/mlx5/core/esw/indir_table.c  |    1 +
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |   20 +
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |  869 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h  |   41 +
 .../net/ethernet/mellanox/mlx5/core/esw/sample.h   |   42 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  358 +--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   68 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  399 ++-
 drivers/net/ethernet/mellanox/mlx5/core/events.c   |    2 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |    2 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   58 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |    2 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |    6 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |    8 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   76 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |  268 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.h      |    5 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |   10 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h   |    2 +
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |    2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c   |  602 ++++
 .../net/ethernet/mellanox/mlx5/core/lib/fs_ttc.h   |   70 +
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.c    |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  105 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |    7 +
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   75 +-
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   |    2 +-
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |    2 +-
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |   10 +-
 drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h    |    4 +-
 .../mellanox/mlx5/core/steering/dr_action.c        |  271 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |    1 +
 .../mellanox/mlx5/core/steering/dr_domain.c        |    8 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_fw.c   |    4 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       |   16 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  152 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   19 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |   36 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h  |    2 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |   57 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |  101 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |   68 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   51 +-
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h      |    6 -
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |    4 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c |   25 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c |    7 +-
 drivers/net/ethernet/mellanox/mlxsw/Kconfig        |    2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |    5 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   84 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |   12 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h |    1 -
 .../ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c   |   94 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c |    4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   44 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.h  |    1 +
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |   32 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |    2 +-
 drivers/net/ethernet/micrel/ksz884x.c              |    2 +-
 drivers/net/ethernet/microchip/Kconfig             |    1 +
 drivers/net/ethernet/microchip/lan743x_main.c      |    2 +-
 drivers/net/ethernet/microchip/sparx5/Makefile     |    2 +-
 .../net/ethernet/microchip/sparx5/sparx5_fdma.c    |  593 ++++
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |   23 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.h    |   69 +
 .../net/ethernet/microchip/sparx5/sparx5_packet.c  |   13 +-
 .../net/ethernet/microchip/sparx5/sparx5_port.c    |    2 +-
 .../net/ethernet/microchip/sparx5/sparx5_port.h    |    1 +
 .../ethernet/microchip/sparx5/sparx5_switchdev.c   |   24 +-
 drivers/net/ethernet/microsoft/mana/gdma.h         |   32 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   88 +-
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |    2 +-
 drivers/net/ethernet/microsoft/mana/mana.h         |   29 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  162 +-
 drivers/net/ethernet/mscc/Kconfig                  |    3 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  246 +-
 drivers/net/ethernet/mscc/ocelot.h                 |   11 +-
 drivers/net/ethernet/mscc/ocelot_net.c             |  397 ++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         |   71 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   71 +-
 drivers/net/ethernet/natsemi/jazzsonic.c           |    2 -
 drivers/net/ethernet/natsemi/natsemi.c             |    2 +-
 drivers/net/ethernet/natsemi/xtsonic.c             |    1 -
 drivers/net/ethernet/neterion/s2io.c               |    2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |    2 +-
 drivers/net/ethernet/netronome/Kconfig             |    1 +
 drivers/net/ethernet/netronome/nfp/flower/action.c |   35 +-
 .../net/ethernet/netronome/nfp/flower/conntrack.c  |  620 ++++-
 .../net/ethernet/netronome/nfp/flower/conntrack.h  |   26 +
 drivers/net/ethernet/netronome/nfp/flower/main.h   |   79 +-
 drivers/net/ethernet/netronome/nfp/flower/match.c  |  333 ++-
 .../net/ethernet/netronome/nfp/flower/metadata.c   |    7 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |   51 +-
 drivers/net/ethernet/netronome/nfp/nfp_main.c      |    2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |   20 +
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |  144 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   29 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c  |    2 +-
 drivers/net/ethernet/ni/nixge.c                    |   24 +-
 drivers/net/ethernet/nvidia/forcedeth.c            |    6 +-
 drivers/net/ethernet/nxp/lpc_eth.c                 |    2 +-
 drivers/net/ethernet/oki-semi/pch_gbe/Kconfig      |    1 +
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |   10 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.c    |    4 +-
 drivers/net/ethernet/packetengines/hamachi.c       |   63 +-
 drivers/net/ethernet/packetengines/yellowfin.c     |    2 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c           |   32 +-
 drivers/net/ethernet/pensando/Kconfig              |    2 +-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |    5 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    |   41 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |    3 +-
 .../net/ethernet/pensando/ionic/ionic_devlink.c    |   18 +-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |   29 +-
 drivers/net/ethernet/pensando/ionic/ionic_if.h     |    5 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  303 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.h    |   10 +-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |    6 +-
 drivers/net/ethernet/pensando/ionic/ionic_phc.c    |   32 +-
 .../net/ethernet/pensando/ionic/ionic_rx_filter.c  |  143 +-
 .../net/ethernet/pensando/ionic/ionic_rx_filter.h  |   14 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |   27 +-
 drivers/net/ethernet/qlogic/Kconfig                |    2 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic.h    |    1 -
 .../ethernet/qlogic/netxen/netxen_nic_ethtool.c    |    8 +-
 drivers/net/ethernet/qlogic/qed/qed.h              |   15 -
 drivers/net/ethernet/qlogic/qed/qed_dcbx.c         |    6 +-
 drivers/net/ethernet/qlogic/qed/qed_devlink.c      |    7 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c          |   22 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |    2 -
 drivers/net/ethernet/qlogic/qed/qed_main.c         |    8 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |    1 -
 .../net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.c |    1 -
 drivers/net/ethernet/qlogic/qed/qed_reg_addr.h     |    8 +
 drivers/net/ethernet/qlogic/qede/qede.h            |   13 +-
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c    |   14 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   33 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |   10 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c   |   16 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c     |   32 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |    6 +-
 drivers/net/ethernet/qualcomm/emac/emac.c          |    2 +-
 drivers/net/ethernet/qualcomm/qca_spi.c            |    2 +-
 drivers/net/ethernet/qualcomm/qca_uart.c           |    2 +-
 drivers/net/ethernet/rdc/r6040.c                   |    2 +-
 drivers/net/ethernet/realtek/8139cp.c              |   33 +-
 drivers/net/ethernet/realtek/8139too.c             |    2 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   69 +-
 drivers/net/ethernet/renesas/Kconfig               |    2 +-
 drivers/net/ethernet/renesas/ravb.h                |   36 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  379 ++-
 drivers/net/ethernet/renesas/ravb_ptp.c            |    8 +-
 drivers/net/ethernet/renesas/sh_eth.c              |    4 +-
 drivers/net/ethernet/rocker/rocker.h               |    3 +-
 drivers/net/ethernet/rocker/rocker_main.c          |    9 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c         |   19 +-
 drivers/net/ethernet/samsung/Kconfig               |    2 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c |    8 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |    2 +-
 drivers/net/ethernet/sfc/Kconfig                   |    2 +-
 drivers/net/ethernet/sfc/efx.c                     |    2 +-
 drivers/net/ethernet/sfc/ethtool.c                 |    8 +-
 drivers/net/ethernet/sfc/falcon/efx.c              |    2 +-
 drivers/net/ethernet/sfc/falcon/ethtool.c          |    8 +-
 drivers/net/ethernet/sgi/ioc3-eth.c                |    2 +-
 drivers/net/ethernet/sgi/meth.c                    |    2 +-
 drivers/net/ethernet/sis/sis190.c                  |    2 +-
 drivers/net/ethernet/sis/sis900.c                  |    2 +-
 drivers/net/ethernet/smsc/Kconfig                  |    1 +
 drivers/net/ethernet/smsc/epic100.c                |    2 +-
 drivers/net/ethernet/smsc/smc9194.c                |    6 +-
 drivers/net/ethernet/smsc/smc91c92_cs.c            |    2 +-
 drivers/net/ethernet/smsc/smsc911x.c               |    2 +-
 drivers/net/ethernet/smsc/smsc9420.c               |    2 +-
 drivers/net/ethernet/socionext/netsec.c            |   12 +-
 drivers/net/ethernet/socionext/sni_ave.c           |    2 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |    2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   13 +
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |   18 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c   |    7 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   75 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    7 +-
 drivers/net/ethernet/sun/cassini.c                 |    2 +-
 drivers/net/ethernet/sun/niu.c                     |   22 +-
 drivers/net/ethernet/sun/sungem.c                  |    2 +-
 drivers/net/ethernet/sun/sunhme.c                  |   24 -
 drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c |   14 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-net.c     |    2 +-
 drivers/net/ethernet/tehuti/tehuti.c               |   30 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   81 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h           |    2 +
 drivers/net/ethernet/ti/cpmac.c                    |    2 +-
 drivers/net/ethernet/ti/cpsw.c                     |    8 +-
 drivers/net/ethernet/ti/cpsw_ethtool.c             |    8 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |   28 +-
 drivers/net/ethernet/ti/cpsw_priv.h                |    8 +-
 drivers/net/ethernet/ti/davinci_emac.c             |   18 +-
 drivers/net/ethernet/ti/netcp_core.c               |    2 +-
 drivers/net/ethernet/ti/tlan.c                     |    2 +-
 drivers/net/ethernet/toshiba/spider_net.c          |   29 +-
 drivers/net/ethernet/toshiba/tc35815.c             |    2 +-
 drivers/net/ethernet/tundra/tsi108_eth.c           |    2 +-
 drivers/net/ethernet/via/via-rhine.c               |   11 +-
 drivers/net/ethernet/via/via-velocity.c            |   16 +-
 drivers/net/ethernet/wiznet/w5100.c                |    2 +
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   16 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   20 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |    2 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |    2 +-
 drivers/net/ethernet/xscale/Kconfig                |    4 +-
 drivers/net/ethernet/xscale/Makefile               |    6 +-
 drivers/net/ethernet/xscale/ixp46x_ts.h            |   13 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |   37 +-
 drivers/net/ethernet/xscale/ptp_ixp46x.c           |  122 +-
 drivers/net/fddi/skfp/skfddi.c                     |   60 +-
 drivers/net/hamradio/baycom_epp.c                  |    9 +-
 drivers/net/hamradio/baycom_par.c                  |   12 +-
 drivers/net/hamradio/baycom_ser_fdx.c              |   12 +-
 drivers/net/hamradio/baycom_ser_hdx.c              |   12 +-
 drivers/net/hamradio/bpqether.c                    |    9 +-
 drivers/net/hamradio/dmascc.c                      |   18 +-
 drivers/net/hamradio/hdlcdrv.c                     |   20 +-
 drivers/net/hamradio/scc.c                         |   13 +-
 drivers/net/hamradio/yam.c                         |   19 +-
 drivers/net/hippi/rrunner.c                        |   11 +-
 drivers/net/hippi/rrunner.h                        |    3 +-
 drivers/net/ipa/Makefile                           |    5 +-
 drivers/net/ipa/gsi.c                              |  241 +-
 drivers/net/ipa/gsi.h                              |   31 +-
 drivers/net/ipa/gsi_trans.c                        |   34 +-
 drivers/net/ipa/ipa.h                              |   30 +-
 drivers/net/ipa/ipa_clock.c                        |  331 ---
 drivers/net/ipa/ipa_clock.h                        |   64 -
 drivers/net/ipa/ipa_cmd.c                          |   51 +-
 drivers/net/ipa/ipa_cmd.h                          |   22 +-
 drivers/net/ipa/ipa_data-v3.1.c                    |    4 +-
 drivers/net/ipa/ipa_data-v3.5.1.c                  |    4 +-
 drivers/net/ipa/ipa_data-v4.11.c                   |   19 +-
 drivers/net/ipa/ipa_data-v4.2.c                    |    4 +-
 drivers/net/ipa/ipa_data-v4.5.c                    |    6 +-
 drivers/net/ipa/ipa_data-v4.9.c                    |   15 +-
 drivers/net/ipa/ipa_data.h                         |   10 +-
 drivers/net/ipa/ipa_endpoint.c                     |   44 +-
 drivers/net/ipa/ipa_interrupt.c                    |   83 +-
 drivers/net/ipa/ipa_interrupt.h                    |    8 +-
 drivers/net/ipa/ipa_main.c                         |  222 +-
 drivers/net/ipa/ipa_modem.c                        |  140 +-
 drivers/net/ipa/ipa_modem.h                        |    4 -
 drivers/net/ipa/ipa_power.c                        |  473 ++++
 drivers/net/ipa/ipa_power.h                        |   73 +
 drivers/net/ipa/ipa_qmi.c                          |    6 +-
 drivers/net/ipa/ipa_qmi.h                          |   19 +
 drivers/net/ipa/ipa_reg.h                          |   12 +-
 drivers/net/ipa/ipa_resource.c                     |    3 +-
 drivers/net/ipa/ipa_smp2p.c                        |   93 +-
 drivers/net/ipa/ipa_smp2p.h                        |    2 +-
 drivers/net/ipa/ipa_table.c                        |   40 +-
 drivers/net/ipa/ipa_table.h                        |   16 -
 drivers/net/ipa/ipa_uc.c                           |   70 +-
 drivers/net/ipa/ipa_uc.h                           |   22 +-
 drivers/net/ipvlan/ipvlan_main.c                   |    1 +
 drivers/net/macvlan.c                              |    8 +-
 drivers/net/mctp/Kconfig                           |    8 +
 drivers/net/mctp/Makefile                          |    0
 drivers/net/mdio/Kconfig                           |    3 +-
 drivers/net/mdio/mdio-ipq4019.c                    |   41 +
 drivers/net/mdio/mdio-mscc-miim.c                  |   12 +-
 drivers/net/mhi/Makefile                           |    3 -
 drivers/net/mhi/mhi.h                              |   41 -
 drivers/net/mhi/proto_mbim.c                       |  304 --
 drivers/net/{mhi/net.c => mhi_net.c}               |  166 +-
 drivers/net/mii.c                                  |    6 +-
 drivers/net/netdevsim/bus.c                        |   43 +-
 drivers/net/netdevsim/dev.c                        |   25 +-
 drivers/net/netdevsim/ethtool.c                    |    8 +-
 drivers/net/netdevsim/fib.c                        |    2 +-
 drivers/net/netdevsim/netdev.c                     |    6 +-
 drivers/net/netdevsim/netdevsim.h                  |    2 +
 drivers/net/pcs/pcs-xpcs.c                         |    4 +
 drivers/net/phy/Kconfig                            |    8 +
 drivers/net/phy/Makefile                           |    1 +
 drivers/net/phy/at803x.c                           |   18 +-
 drivers/net/phy/dp83822.c                          |    8 +-
 drivers/net/phy/intel-xway.c                       |   76 +
 drivers/net/phy/marvell.c                          |  144 +-
 drivers/net/phy/marvell10g.c                       |   97 +
 drivers/net/phy/mscc/mscc_ptp.c                    |    8 +-
 drivers/net/phy/mxl-gpy.c                          |  727 +++++
 drivers/net/phy/nxp-tja11xx.c                      |   13 +-
 drivers/net/phy/phy.c                              |    4 +-
 drivers/net/phy/phy_device.c                       |   27 +-
 drivers/net/phy/phylink.c                          |   21 +-
 drivers/net/phy/xilinx_gmii2rgmii.c                |   46 +-
 drivers/net/plip/plip.c                            |   12 +-
 drivers/net/ppp/ppp_generic.c                      |   14 +-
 drivers/net/sb1000.c                               |   20 +-
 drivers/net/slip/slip.c                            |   13 +-
 drivers/net/team/team_mode_loadbalance.c           |    2 +-
 drivers/net/tun.c                                  |    8 +-
 drivers/net/usb/asix_devices.c                     |   12 +-
 drivers/net/usb/ax88172a.c                         |    2 +-
 drivers/net/usb/ax88179_178a.c                     |    2 +-
 drivers/net/usb/cdc-phonet.c                       |    5 +-
 drivers/net/usb/dm9601.c                           |    2 +-
 drivers/net/usb/hso.c                              |   13 +-
 drivers/net/usb/ipheth.c                           |    2 +-
 drivers/net/usb/lan78xx.c                          | 1062 +++++--
 drivers/net/usb/mcs7830.c                          |    2 +-
 drivers/net/usb/pegasus.c                          |    5 +-
 drivers/net/usb/r8152.c                            |   10 +-
 drivers/net/usb/rtl8150.c                          |    5 +-
 drivers/net/usb/smsc75xx.c                         |    2 +-
 drivers/net/usb/smsc95xx.c                         |    2 +-
 drivers/net/usb/sr9700.c                           |    2 +-
 drivers/net/usb/sr9800.c                           |    2 +-
 drivers/net/usb/usbnet.c                           |    8 +-
 drivers/net/veth.c                                 |  307 ++-
 drivers/net/virtio_net.c                           |   52 +-
 drivers/net/vmxnet3/Makefile                       |    2 +-
 drivers/net/vmxnet3/upt1_defs.h                    |    2 +-
 drivers/net/vmxnet3/vmxnet3_defs.h                 |   50 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  268 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |   32 +-
 drivers/net/vmxnet3/vmxnet3_int.h                  |   22 +-
 drivers/net/vrf.c                                  |   21 +-
 drivers/net/wan/Kconfig                            |   51 -
 drivers/net/wan/Makefile                           |    1 -
 drivers/net/wan/c101.c                             |   33 +-
 drivers/net/wan/cosa.c                             |   15 +-
 drivers/net/wan/farsync.c                          |  123 +-
 drivers/net/wan/fsl_ucc_hdlc.c                     |   19 +-
 drivers/net/wan/hdlc.c                             |    9 +-
 drivers/net/wan/hdlc_cisco.c                       |   14 +-
 drivers/net/wan/hdlc_fr.c                          |   40 +-
 drivers/net/wan/hdlc_ppp.c                         |    8 +-
 drivers/net/wan/hdlc_raw.c                         |   14 +-
 drivers/net/wan/hdlc_raw_eth.c                     |   14 +-
 drivers/net/wan/hdlc_x25.c                         |   16 +-
 drivers/net/wan/hostess_sv11.c                     |   13 +-
 drivers/net/wan/ixp4xx_hss.c                       |   22 +-
 drivers/net/wan/lmc/lmc.h                          |    2 +-
 drivers/net/wan/lmc/lmc_main.c                     |   33 +-
 drivers/net/wan/lmc/lmc_proto.c                    |    7 -
 drivers/net/wan/lmc/lmc_proto.h                    |    1 -
 drivers/net/wan/n2.c                               |   32 +-
 drivers/net/wan/pc300too.c                         |   44 +-
 drivers/net/wan/pci200syn.c                        |   32 +-
 drivers/net/wan/sbni.c                             | 1638 -----------
 drivers/net/wan/sbni.h                             |  147 -
 drivers/net/wan/sealevel.c                         |   10 +-
 drivers/net/wan/wanxl.c                            |   21 +-
 drivers/net/wireless/ath/ath10k/pci.c              |    9 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |    5 -
 drivers/net/wireless/ath/ath11k/pci.c              |   10 +-
 drivers/net/wireless/ath/ath5k/pci.c               |    2 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |    4 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |    3 +-
 drivers/net/wireless/ath/ath9k/hw.c                |   12 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    8 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   12 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |    4 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |    4 +
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |    2 +
 drivers/net/wireless/ath/wil6210/ethtool.c         |   14 +-
 .../wireless/broadcom/brcm80211/brcmfmac/Makefile  |    3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    4 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    8 +
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |   29 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.h    |    5 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |   69 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.c    |  126 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |    8 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   30 +-
 .../wireless/broadcom/brcm80211/brcmfmac/xtlv.c    |   82 +
 .../wireless/broadcom/brcm80211/brcmfmac/xtlv.h    |   31 +
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |    2 +-
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |    1 +
 .../net/wireless/broadcom/brcm80211/include/soc.h  |    2 +-
 drivers/net/wireless/cisco/airo.c                  |   15 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |   56 +-
 drivers/net/wireless/intel/ipw2x00/libipw_tx.c     |    4 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |   52 +-
 drivers/net/wireless/intel/iwlegacy/3945.c         |   10 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |   78 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |   19 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   76 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |    4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  304 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |   66 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/coex.h   |    2 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |    3 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |   22 +-
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |    8 +-
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |  189 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |    4 +-
 .../net/wireless/intel/iwlwifi/fw/api/offload.h    |   31 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |    6 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |    8 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  144 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |    7 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |   22 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |    1 +
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |   15 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h       |   20 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |    8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   22 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   34 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h   |   24 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |   26 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   40 +-
 drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h   |    8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |    7 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |    5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  580 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   11 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |   85 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |   27 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  108 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   44 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   35 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   74 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   45 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   93 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  120 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   41 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |    8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   24 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   17 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   53 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   59 +-
 drivers/net/wireless/intersil/Kconfig              |   20 -
 drivers/net/wireless/intersil/Makefile             |    1 -
 drivers/net/wireless/intersil/hostap/hostap.h      |    3 +-
 .../net/wireless/intersil/hostap/hostap_ioctl.c    |   30 +-
 drivers/net/wireless/intersil/hostap/hostap_main.c |    3 +
 drivers/net/wireless/intersil/prism54/Makefile     |    9 -
 drivers/net/wireless/intersil/prism54/isl_38xx.c   |  245 --
 drivers/net/wireless/intersil/prism54/isl_38xx.h   |  158 --
 drivers/net/wireless/intersil/prism54/isl_ioctl.c  | 2909 --------------------
 drivers/net/wireless/intersil/prism54/isl_ioctl.h  |   35 -
 drivers/net/wireless/intersil/prism54/isl_oid.h    |  492 ----
 drivers/net/wireless/intersil/prism54/islpci_dev.c |  951 -------
 drivers/net/wireless/intersil/prism54/islpci_dev.h |  204 --
 drivers/net/wireless/intersil/prism54/islpci_eth.c |  489 ----
 drivers/net/wireless/intersil/prism54/islpci_eth.h |   59 -
 .../net/wireless/intersil/prism54/islpci_hotplug.c |  316 ---
 drivers/net/wireless/intersil/prism54/islpci_mgt.c |  491 ----
 drivers/net/wireless/intersil/prism54/islpci_mgt.h |  126 -
 drivers/net/wireless/intersil/prism54/oid_mgt.c    |  889 ------
 drivers/net/wireless/intersil/prism54/oid_mgt.h    |   46 -
 .../net/wireless/intersil/prism54/prismcompat.h    |   30 -
 drivers/net/wireless/marvell/libertas/ethtool.c    |    9 +-
 drivers/net/wireless/marvell/mwifiex/Makefile      |    1 +
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |    2 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   11 +
 drivers/net/wireless/marvell/mwifiex/pcie.h        |    1 +
 drivers/net/wireless/marvell/mwifiex/pcie_quirks.c |  161 ++
 drivers/net/wireless/marvell/mwifiex/pcie_quirks.h |   23 +
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |    4 +-
 drivers/net/wireless/marvell/mwifiex/usb.h         |    2 +-
 drivers/net/wireless/microchip/wilc1000/sdio.c     |   29 +-
 drivers/net/wireless/microchip/wilc1000/spi.c      |   44 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |   38 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   |   28 +-
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   |   28 +-
 drivers/net/wireless/ray_cs.c                      |    8 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |    2 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   37 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |   52 +-
 drivers/net/wireless/realtek/rtw88/Makefile        |    2 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |    8 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |    3 +-
 drivers/net/wireless/realtek/rtw88/main.c          |    2 +
 drivers/net/wireless/realtek/rtw88/main.h          |    6 +
 drivers/net/wireless/realtek/rtw88/pci.c           |   47 +-
 drivers/net/wireless/realtek/rtw88/pci.h           |    1 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |    1 +
 drivers/net/wireless/realtek/rtw88/tx.c            |    2 +-
 drivers/net/wireless/realtek/rtw88/wow.c           |  107 +-
 drivers/net/wireless/rsi/rsi_91x_debugfs.c         |    2 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |    4 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |    1 +
 drivers/net/wwan/Kconfig                           |   12 +
 drivers/net/wwan/Makefile                          |    1 +
 drivers/net/wwan/iosm/iosm_ipc_pcie.c              |   19 +-
 drivers/net/wwan/iosm/iosm_ipc_protocol.c          |   10 +-
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c      |   13 +-
 drivers/net/wwan/mhi_wwan_mbim.c                   |  658 +++++
 drivers/net/wwan/wwan_core.c                       |    7 +-
 drivers/net/xen-netfront.c                         |  272 +-
 drivers/nfc/fdp/fdp.c                              |   38 +-
 drivers/nfc/fdp/fdp.h                              |    4 +-
 drivers/nfc/fdp/i2c.c                              |    8 +-
 drivers/nfc/mei_phy.c                              |    4 +-
 drivers/nfc/mei_phy.h                              |    2 +-
 drivers/nfc/microread/i2c.c                        |    4 +-
 drivers/nfc/microread/mei.c                        |    1 -
 drivers/nfc/microread/microread.c                  |   15 +-
 drivers/nfc/microread/microread.h                  |    6 +-
 drivers/nfc/nfcmrvl/fw_dnld.c                      |   16 +-
 drivers/nfc/nfcmrvl/i2c.c                          |    7 +-
 drivers/nfc/nfcmrvl/main.c                         |    6 +-
 drivers/nfc/nfcmrvl/nfcmrvl.h                      |    6 +-
 drivers/nfc/nfcmrvl/spi.c                          |    7 +-
 drivers/nfc/nfcmrvl/uart.c                         |    4 +-
 drivers/nfc/nfcmrvl/usb.c                          |    2 +-
 drivers/nfc/nfcsim.c                               |    4 +-
 drivers/nfc/nxp-nci/core.c                         |    2 +-
 drivers/nfc/pn533/pn533.c                          |    2 +-
 drivers/nfc/pn544/i2c.c                            |    2 +-
 drivers/nfc/pn544/pn544.c                          |   18 +-
 drivers/nfc/pn544/pn544.h                          |    7 +-
 drivers/nfc/port100.c                              |   47 +-
 drivers/nfc/s3fwrn5/core.c                         |    7 +-
 drivers/nfc/s3fwrn5/firmware.c                     |   12 +-
 drivers/nfc/s3fwrn5/nci.c                          |    8 +-
 drivers/nfc/s3fwrn5/nci.h                          |    2 +-
 drivers/nfc/st-nci/core.c                          |    7 +-
 drivers/nfc/st-nci/i2c.c                           |    2 +-
 drivers/nfc/st-nci/ndlc.c                          |    6 +-
 drivers/nfc/st-nci/ndlc.h                          |    8 +-
 drivers/nfc/st-nci/spi.c                           |    2 +-
 drivers/nfc/st-nci/vendor_cmds.c                   |    2 +-
 drivers/nfc/st21nfca/core.c                        |    7 +-
 drivers/nfc/st21nfca/i2c.c                         |    8 +-
 drivers/nfc/st21nfca/st21nfca.h                    |    4 +-
 drivers/nfc/st21nfca/vendor_cmds.c                 |    2 +-
 drivers/nfc/st95hf/core.c                          |    3 +-
 drivers/nfc/trf7970a.c                             |   19 +-
 drivers/nfc/virtual_ncidev.c                       |   13 +-
 drivers/pci/pci.h                                  |    3 -
 drivers/pci/pcie/ptm.c                             |    9 +
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c       |   16 +-
 drivers/phy/marvell/phy-mvebu-cp110-comphy.c       |   16 +-
 drivers/ptp/Kconfig                                |   20 +-
 drivers/ptp/ptp_ocp.c                              | 1283 ++++++++-
 drivers/ptp/ptp_vclock.c                           |    2 +
 drivers/s390/cio/ccwgroup.c                        |   22 -
 drivers/s390/net/Kconfig                           |   10 +-
 drivers/s390/net/ctcm_fsms.c                       |    2 +-
 drivers/s390/net/ctcm_mpc.c                        |    2 +-
 drivers/s390/net/qeth_core.h                       |   51 +-
 drivers/s390/net/qeth_core_main.c                  |  189 +-
 drivers/s390/net/qeth_core_mpc.c                   |    3 -
 drivers/s390/net/qeth_core_mpc.h                   |   23 +-
 drivers/s390/net/qeth_core_sys.c                   |    5 -
 drivers/s390/net/qeth_ethtool.c                    |   11 +-
 drivers/s390/net/qeth_l2_main.c                    |  414 +--
 drivers/s390/net/qeth_l3_main.c                    |   19 +-
 drivers/scsi/cxgbi/cxgb4i/Kconfig                  |    1 +
 drivers/staging/octeon/ethernet.c                  |   12 +-
 drivers/staging/qlge/qlge_ethtool.c                |   10 +-
 drivers/staging/qlge/qlge_main.c                   |    5 +-
 drivers/staging/rtl8188eu/include/osdep_intf.h     |    2 +
 drivers/staging/rtl8188eu/include/rtw_android.h    |    3 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |    3 -
 drivers/staging/rtl8188eu/os_dep/os_intfs.c        |    1 +
 drivers/staging/rtl8188eu/os_dep/rtw_android.c     |   14 +-
 drivers/staging/rtl8723bs/include/osdep_intf.h     |    2 +
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c     |   18 +-
 drivers/staging/rtl8723bs/os_dep/os_intfs.c        |    1 +
 drivers/staging/wlan-ng/p80211netdev.c             |   76 +-
 drivers/tty/synclink_gt.c                          |   19 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |    2 +-
 drivers/vhost/net.c                                |    2 -
 include/asm-generic/compat.h                       |   17 +
 include/linux/bitops.h                             |   50 +
 include/linux/bpf-cgroup.h                         |  230 +-
 include/linux/bpf.h                                |  306 +-
 include/linux/bpf_types.h                          |    3 +
 include/linux/bpf_verifier.h                       |   19 +-
 include/linux/bpfptr.h                             |   12 +-
 include/linux/btf.h                                |    1 +
 include/linux/btf_ids.h                            |    9 +-
 include/linux/can/bittiming.h                      |    4 +-
 include/linux/can/dev.h                            |    8 +
 include/linux/can/platform/flexcan.h               |   23 +
 include/linux/can/rx-offload.h                     |    8 +-
 include/linux/compat.h                             |   32 +-
 include/linux/dsa/8021q.h                          |   44 +-
 include/linux/dsa/sja1105.h                        |   22 +-
 include/linux/ethtool.h                            |   26 +-
 include/linux/filter.h                             |   80 +-
 include/linux/fsl/mc.h                             |    3 +-
 include/linux/genetlink.h                          |   23 -
 include/linux/hdlc.h                               |    4 +-
 include/linux/hdlcdrv.h                            |    2 +-
 include/linux/ieee80211.h                          |  106 +-
 include/linux/if_bridge.h                          |   40 +-
 include/linux/igmp.h                               |    3 -
 include/linux/inetdevice.h                         |    9 +
 include/linux/ioam6.h                              |   13 +
 include/linux/ioam6_genl.h                         |   13 +
 include/linux/ioam6_iptunnel.h                     |   13 +
 include/linux/ipv6.h                               |    3 +
 include/linux/memcontrol.h                         |    3 +-
 include/linux/mhi.h                                |    2 +
 include/linux/mii.h                                |    2 +-
 include/linux/mlx5/device.h                        |   71 +-
 include/linux/mlx5/driver.h                        |   18 +-
 include/linux/mlx5/eswitch.h                       |   16 +
 include/linux/mlx5/fs.h                            |    2 +
 include/linux/mlx5/mlx5_ifc.h                      |   25 +-
 include/linux/mm_types.h                           |   18 +-
 include/linux/mmc/sdio_ids.h                       |    1 +
 include/linux/netdevice.h                          |   92 +-
 include/linux/netfilter/x_tables.h                 |    6 +-
 include/linux/netfilter_bridge/ebtables.h          |    2 +
 include/linux/pci.h                                |   10 +
 include/linux/perf_event.h                         |    1 +
 include/linux/phy.h                                |    1 +
 include/linux/ptp_clock_kernel.h                   |   48 +-
 include/linux/sched.h                              |    3 +
 include/linux/skbuff.h                             |   21 +-
 include/linux/socket.h                             |    6 +-
 include/linux/ssb/ssb.h                            |    2 +-
 include/linux/ssb/ssb_driver_extif.h               |    2 +-
 include/linux/trace_events.h                       |    7 +-
 include/linux/typecheck.h                          |    9 +
 include/net/Space.h                                |   10 -
 include/net/act_api.h                              |   22 +-
 include/net/af_unix.h                              |   19 +
 include/net/ax88796.h                              |    3 +
 include/net/bluetooth/hci_core.h                   |   21 +-
 include/net/bond_3ad.h                             |    1 +
 include/net/bond_options.h                         |    1 +
 include/net/bonding.h                              |   14 +-
 include/net/cfg80211.h                             |   92 +
 include/net/compat.h                               |   27 +-
 include/net/devlink.h                              |   58 +-
 include/net/dn_fib.h                               |    2 +-
 include/net/dsa.h                                  |   72 +-
 include/net/dst.h                                  |    2 +
 include/net/flow_offload.h                         |    1 +
 include/net/ieee80211_radiotap.h                   |    5 +
 include/net/if_inet6.h                             |    5 +-
 include/net/inet_hashtables.h                      |    6 +
 include/net/ioam6.h                                |   67 +
 include/net/ip.h                                   |   22 +-
 include/net/ip6_route.h                            |    5 +-
 include/net/ip_fib.h                               |    2 +-
 include/net/ip_tunnels.h                           |    3 +-
 include/net/ipx.h                                  |  171 --
 include/net/lwtunnel.h                             |    3 +
 include/net/mac80211.h                             |   41 +
 include/net/mctp.h                                 |  232 ++
 include/net/mctpdevice.h                           |   35 +
 include/net/mptcp.h                                |   29 +-
 include/net/net_namespace.h                        |    6 +-
 include/net/netfilter/nf_conntrack_ecache.h        |   32 +-
 include/net/netfilter/nf_hooks_lwtunnel.h          |    7 +
 include/net/netfilter/nf_queue.h                   |    4 +-
 include/net/netlink.h                              |    2 +-
 include/net/netns/conntrack.h                      |    1 -
 include/net/netns/ipv4.h                           |    1 -
 include/net/netns/ipv6.h                           |    3 +
 include/net/netns/mctp.h                           |   36 +
 include/net/netns/netfilter.h                      |    1 -
 include/net/netns/x_tables.h                       |   12 -
 include/net/netns/xfrm.h                           |    7 +
 include/net/nfc/digital.h                          |    4 +-
 include/net/nfc/hci.h                              |    6 +-
 include/net/nfc/nci_core.h                         |   30 +-
 include/net/nfc/nfc.h                              |   16 +-
 include/net/page_pool.h                            |   68 +-
 include/net/pkt_cls.h                              |   27 +-
 include/net/rtnetlink.h                            |    3 +-
 include/net/sch_generic.h                          |    2 +-
 include/net/sock.h                                 |   18 +-
 include/net/switchdev.h                            |  108 +
 include/net/tcp.h                                  |    1 -
 include/net/xdp.h                                  |    5 +
 include/net/xfrm.h                                 |   36 +-
 include/soc/mscc/ocelot.h                          |   26 +-
 include/trace/events/qdisc.h                       |    2 +
 include/uapi/asm-generic/socket.h                  |    2 +
 include/uapi/linux/bpf.h                           |  119 +-
 include/uapi/linux/can/j1939.h                     |    9 +
 include/uapi/linux/ethtool.h                       |    2 +
 include/uapi/linux/ethtool_netlink.h               |    2 +
 include/uapi/linux/if_arp.h                        |    1 +
 include/uapi/linux/if_bridge.h                     |   46 +
 include/uapi/linux/if_ether.h                      |    3 +
 include/uapi/linux/if_link.h                       |   13 +
 include/uapi/linux/in.h                            |   42 +-
 include/uapi/linux/in6.h                           |    1 +
 include/uapi/linux/ioam6.h                         |  133 +
 include/uapi/linux/ioam6_genl.h                    |   52 +
 include/uapi/linux/ioam6_iptunnel.h                |   20 +
 include/uapi/linux/ipv6.h                          |    3 +
 include/uapi/linux/ipx.h                           |   87 -
 include/uapi/linux/lwtunnel.h                      |    1 +
 include/uapi/linux/mctp.h                          |   36 +
 include/uapi/linux/mptcp.h                         |    1 +
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |    1 +
 include/uapi/linux/nl80211-vnd-intel.h             |   77 +
 include/uapi/linux/nl80211.h                       |   43 +
 include/uapi/linux/openvswitch.h                   |    8 +
 include/uapi/linux/pkt_cls.h                       |    1 +
 include/uapi/linux/socket.h                        |    5 +
 include/uapi/linux/tc_act/tc_skbmod.h              |    1 +
 include/uapi/linux/xfrm.h                          |   11 +
 init/main.c                                        |    6 +-
 kernel/bpf/Kconfig                                 |    2 +-
 kernel/bpf/arraymap.c                              |   21 +
 kernel/bpf/bpf_iter.c                              |   24 +-
 kernel/bpf/bpf_struct_ops.c                        |   22 +-
 kernel/bpf/bpf_task_storage.c                      |    6 +-
 kernel/bpf/btf.c                                   |   84 +-
 kernel/bpf/cgroup.c                                |  198 +-
 kernel/bpf/core.c                                  |   31 +-
 kernel/bpf/cpumap.c                                |  116 +-
 kernel/bpf/devmap.c                                |  118 +-
 kernel/bpf/hashtab.c                               |  105 +-
 kernel/bpf/helpers.c                               |  376 ++-
 kernel/bpf/local_storage.c                         |   20 +-
 kernel/bpf/map_in_map.c                            |    8 +
 kernel/bpf/stackmap.c                              |    4 +-
 kernel/bpf/syscall.c                               |  220 +-
 kernel/bpf/task_iter.c                             |   11 +-
 kernel/bpf/trampoline.c                            |   14 +-
 kernel/bpf/verifier.c                              |  385 ++-
 kernel/events/core.c                               |   77 +-
 kernel/fork.c                                      |    1 +
 kernel/trace/bpf_trace.c                           |  112 +-
 lib/test_bpf.c                                     | 2754 ++++++++++++++++--
 mm/memcontrol.c                                    |   26 +-
 net/6lowpan/debugfs.c                              |    3 +-
 net/802/Makefile                                   |    1 -
 net/802/p8023.c                                    |   60 -
 net/8021q/vlan.c                                   |    2 +-
 net/8021q/vlan_dev.c                               |    6 +-
 net/Kconfig                                        |    1 +
 net/Makefile                                       |    1 +
 net/appletalk/ddp.c                                |    4 +-
 net/ax25/ax25_ip.c                                 |    4 +-
 net/ax25/ax25_out.c                                |   13 +-
 net/ax25/ax25_route.c                              |   13 +-
 net/batman-adv/bat_iv_ogm.c                        |   75 +-
 net/batman-adv/bat_v.c                             |   30 +-
 net/batman-adv/bat_v_elp.c                         |    9 +-
 net/batman-adv/bat_v_ogm.c                         |   39 +-
 net/batman-adv/bridge_loop_avoidance.c             |   39 +-
 net/batman-adv/distributed-arp-table.c             |   27 +-
 net/batman-adv/fragmentation.c                     |    6 +-
 net/batman-adv/gateway_client.c                    |   60 +-
 net/batman-adv/gateway_client.h                    |   16 +-
 net/batman-adv/gateway_common.c                    |    2 +-
 net/batman-adv/hard-interface.c                    |   21 +-
 net/batman-adv/hard-interface.h                    |    3 +
 net/batman-adv/main.h                              |    2 +-
 net/batman-adv/multicast.c                         |   11 +-
 net/batman-adv/netlink.c                           |    6 +-
 net/batman-adv/network-coding.c                    |   24 +-
 net/batman-adv/originator.c                        |  114 +-
 net/batman-adv/originator.h                        |   96 +-
 net/batman-adv/routing.c                           |   39 +-
 net/batman-adv/send.c                              |   33 +-
 net/batman-adv/soft-interface.c                    |   27 +-
 net/batman-adv/soft-interface.h                    |   16 +-
 net/batman-adv/tp_meter.c                          |   27 +-
 net/batman-adv/translation-table.c                 |  109 +-
 net/batman-adv/translation-table.h                 |   18 +-
 net/batman-adv/tvlv.c                              |    9 +-
 net/bluetooth/cmtp/cmtp.h                          |    2 +-
 net/bluetooth/hci_core.c                           |   48 +-
 net/bluetooth/hci_event.c                          |  223 +-
 net/bluetooth/hci_request.c                        |   81 +-
 net/bluetooth/hci_sysfs.c                          |    3 +-
 net/bluetooth/mgmt.c                               |    4 +-
 net/bluetooth/rfcomm/sock.c                        |    8 +-
 net/bluetooth/sco.c                                |  106 +-
 net/bpf/test_run.c                                 |  139 +-
 net/bridge/br.c                                    |   62 +-
 net/bridge/br_device.c                             |   16 +-
 net/bridge/br_fdb.c                                |   28 +-
 net/bridge/br_forward.c                            |   16 +-
 net/bridge/br_if.c                                 |   15 +-
 net/bridge/br_input.c                              |   24 +-
 net/bridge/br_ioctl.c                              |   83 +-
 net/bridge/br_mdb.c                                |  177 +-
 net/bridge/br_multicast.c                          | 1912 ++++++++-----
 net/bridge/br_multicast_eht.c                      |   92 +-
 net/bridge/br_netlink.c                            |   61 +-
 net/bridge/br_private.h                            |  581 +++-
 net/bridge/br_private_mcast_eht.h                  |    3 +-
 net/bridge/br_private_tunnel.h                     |    6 +-
 net/bridge/br_switchdev.c                          |  246 +-
 net/bridge/br_sysfs_br.c                           |   48 +-
 net/bridge/br_sysfs_if.c                           |    4 +-
 net/bridge/br_vlan.c                               |  136 +-
 net/bridge/br_vlan_options.c                       |  427 ++-
 net/bridge/br_vlan_tunnel.c                        |   14 +-
 net/bridge/netfilter/ebtable_broute.c              |   17 +-
 net/bridge/netfilter/ebtable_filter.c              |   17 +-
 net/bridge/netfilter/ebtable_nat.c                 |   17 +-
 net/bridge/netfilter/ebtables.c                    |  109 +-
 net/can/j1939/j1939-priv.h                         |   10 +-
 net/can/j1939/socket.c                             |  143 +-
 net/can/j1939/transport.c                          |   70 +-
 net/can/raw.c                                      |    8 +-
 net/core/Makefile                                  |    2 -
 net/core/bpf_sk_storage.c                          |    4 +-
 net/core/dev.c                                     |  342 +--
 net/core/dev_addr_lists.c                          |  144 +-
 net/core/dev_ioctl.c                               |  264 +-
 net/core/devlink.c                                 |  680 +++--
 net/core/drop_monitor.c                            |    6 +-
 net/core/dst.c                                     |    6 +-
 net/core/fib_rules.c                               |    4 +-
 net/core/filter.c                                  |  134 +-
 net/core/flow_dissector.c                          |   12 +-
 net/core/flow_offload.c                            |   90 +-
 net/core/lwtunnel.c                                |    5 +
 net/core/neighbour.c                               |   29 +-
 net/core/net-procfs.c                              |   24 +-
 net/core/net_namespace.c                           |   52 +-
 net/core/page_pool.c                               |  114 +-
 net/core/pktgen.c                                  |  167 +-
 net/core/ptp_classifier.c                          |    2 +-
 net/core/rtnetlink.c                               |   31 +-
 net/core/scm.c                                     |    4 +-
 net/core/selftests.c                               |   12 +
 net/core/skbuff.c                                  |   75 +-
 net/core/sock.c                                    |   31 +-
 net/core/sock_map.c                                |   23 +-
 net/dccp/proto.c                                   |    2 +-
 net/decnet/dn_dev.c                                |    6 +-
 net/decnet/dn_fib.c                                |    9 +-
 net/decnet/dn_route.c                              |   18 +-
 net/dsa/Kconfig                                    |   13 +-
 net/dsa/Makefile                                   |    3 +-
 net/dsa/dsa.c                                      |    2 +-
 net/dsa/dsa2.c                                     |  112 +-
 net/dsa/dsa_priv.h                                 |  194 +-
 net/dsa/master.c                                   |    6 +-
 net/dsa/port.c                                     |  344 ++-
 net/dsa/slave.c                                    |  298 +-
 net/dsa/switch.c                                   |   55 +-
 net/dsa/tag_8021q.c                                |  608 ++--
 net/dsa/tag_ar9331.c                               |    3 +-
 net/dsa/tag_brcm.c                                 |   34 +-
 net/dsa/tag_dsa.c                                  |   95 +-
 net/dsa/tag_gswip.c                                |    3 +-
 net/dsa/tag_hellcreek.c                            |    5 +-
 net/dsa/tag_ksz.c                                  |    8 +-
 net/dsa/tag_lan9303.c                              |   24 +-
 net/dsa/tag_mtk.c                                  |   19 +-
 net/dsa/tag_ocelot.c                               |    5 +-
 net/dsa/tag_ocelot_8021q.c                         |    9 +-
 net/dsa/tag_qca.c                                  |   16 +-
 net/dsa/tag_rtl4_a.c                               |   21 +-
 net/dsa/tag_sja1105.c                              |  284 +-
 net/dsa/tag_trailer.c                              |    3 +-
 net/dsa/tag_xrs700x.c                              |    5 +-
 net/ethernet/eth.c                                 |    8 +-
 net/ethtool/coalesce.c                             |   29 +-
 net/ethtool/ioctl.c                                |  172 +-
 net/ethtool/netlink.c                              |   51 +-
 net/ethtool/netlink.h                              |   17 +-
 net/ieee802154/nl-phy.c                            |    3 +-
 net/ieee802154/nl802154.c                          |    3 +-
 net/ieee802154/socket.c                            |    7 +-
 net/ipv4/af_inet.c                                 |   12 +-
 net/ipv4/bpf_tcp_ca.c                              |   41 +-
 net/ipv4/devinet.c                                 |   21 +-
 net/ipv4/esp4.c                                    |    4 +-
 net/ipv4/fib_semantics.c                           |   12 +-
 net/ipv4/fib_trie.c                                |    4 +-
 net/ipv4/fou.c                                     |   10 +-
 net/ipv4/icmp.c                                    |    3 +-
 net/ipv4/igmp.c                                    |   30 +-
 net/ipv4/inet_connection_sock.c                    |    3 +-
 net/ipv4/ip_gre.c                                  |    2 +-
 net/ipv4/ip_output.c                               |   39 +-
 net/ipv4/ip_sockglue.c                             |   24 +-
 net/ipv4/ip_tunnel.c                               |    9 +-
 net/ipv4/ip_vti.c                                  |    2 +-
 net/ipv4/ipip.c                                    |    2 +-
 net/ipv4/netfilter/arptable_filter.c               |   23 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |   56 +-
 net/ipv4/netfilter/iptable_filter.c                |   24 +-
 net/ipv4/netfilter/iptable_mangle.c                |   19 +-
 net/ipv4/netfilter/iptable_nat.c                   |   20 +-
 net/ipv4/netfilter/iptable_raw.c                   |   21 +-
 net/ipv4/netfilter/iptable_security.c              |   23 +-
 net/ipv4/route.c                                   |   79 +-
 net/ipv4/tcp.c                                     |    5 +-
 net/ipv4/tcp_fastopen.c                            |   20 +-
 net/ipv4/tcp_input.c                               |   54 +-
 net/ipv4/tcp_ipv4.c                                |  411 ++-
 net/ipv4/tcp_output.c                              |    3 +-
 net/ipv4/tcp_recovery.c                            |    3 +-
 net/ipv4/udp.c                                     |    2 +-
 net/ipv4/udp_bpf.c                                 |    1 -
 net/ipv4/udp_offload.c                             |    2 +-
 net/ipv6/Kconfig                                   |   11 +
 net/ipv6/Makefile                                  |    3 +-
 net/ipv6/addrconf.c                                |   65 +-
 net/ipv6/af_inet6.c                                |   16 +-
 net/ipv6/exthdrs.c                                 |  158 +-
 net/ipv6/ioam6.c                                   |  910 ++++++
 net/ipv6/ioam6_iptunnel.c                          |  274 ++
 net/ipv6/ip6_fib.c                                 |    4 +-
 net/ipv6/ip6_gre.c                                 |   17 +-
 net/ipv6/ip6_output.c                              |   80 +-
 net/ipv6/ip6_tunnel.c                              |   21 +-
 net/ipv6/ip6_vti.c                                 |   21 +-
 net/ipv6/ip6mr.c                                   |    3 +-
 net/ipv6/ipv6_sockglue.c                           |   18 +-
 net/ipv6/mcast.c                                   |   20 +-
 net/ipv6/ndisc.c                                   |   17 +-
 net/ipv6/netfilter/ip6table_filter.c               |   23 +-
 net/ipv6/netfilter/ip6table_mangle.c               |   22 +-
 net/ipv6/netfilter/ip6table_nat.c                  |   16 +-
 net/ipv6/netfilter/ip6table_raw.c                  |   24 +-
 net/ipv6/netfilter/ip6table_security.c             |   22 +-
 net/ipv6/route.c                                   |   30 +-
 net/ipv6/seg6_iptunnel.c                           |   74 +-
 net/ipv6/seg6_local.c                              |  110 +-
 net/ipv6/sit.c                                     |   40 +-
 net/ipv6/sysctl_net_ipv6.c                         |   19 +
 net/ipv6/udp.c                                     |    2 +-
 net/iucv/af_iucv.c                                 |   72 +-
 net/iucv/iucv.c                                    |   60 +-
 net/llc/af_llc.c                                   |    6 +-
 net/mac80211/cfg.c                                 |  234 +-
 net/mac80211/driver-ops.h                          |   36 +
 net/mac80211/ibss.c                                |   15 +-
 net/mac80211/ieee80211_i.h                         |   21 +
 net/mac80211/iface.c                               |   54 +-
 net/mac80211/main.c                                |    2 +-
 net/mac80211/rx.c                                  |  102 +-
 net/mac80211/s1g.c                                 |  180 ++
 net/mac80211/sta_info.c                            |    2 +-
 net/mac80211/status.c                              |   33 +-
 net/mac80211/trace.h                               |   67 +
 net/mac80211/tx.c                                  |   33 +-
 net/mac80211/util.c                                |   12 +
 net/mctp/Kconfig                                   |   13 +
 net/mctp/Makefile                                  |    3 +
 net/mctp/af_mctp.c                                 |  395 +++
 net/mctp/device.c                                  |  423 +++
 net/mctp/neigh.c                                   |  342 +++
 net/mctp/route.c                                   | 1116 ++++++++
 net/mpls/af_mpls.c                                 |    2 +-
 net/mptcp/ctrl.c                                   |   26 +-
 net/mptcp/mib.c                                    |    4 +
 net/mptcp/mib.h                                    |    4 +
 net/mptcp/options.c                                |  462 ++--
 net/mptcp/pm.c                                     |   84 +-
 net/mptcp/pm_netlink.c                             |  203 +-
 net/mptcp/protocol.c                               |  201 +-
 net/mptcp/protocol.h                               |  114 +-
 net/mptcp/subflow.c                                |   69 +-
 net/netfilter/Makefile                             |    3 +
 net/netfilter/nf_conntrack_ecache.c                |  211 +-
 net/netfilter/nf_conntrack_netlink.c               |  132 +-
 net/netfilter/nf_conntrack_standalone.c            |   15 +
 net/netfilter/nf_flow_table_core.c                 |   12 +-
 net/netfilter/nf_flow_table_offload.c              |    4 +-
 net/netfilter/nf_hooks_lwtunnel.c                  |   53 +
 net/netfilter/nf_queue.c                           |   43 +-
 net/netfilter/nf_tables_offload.c                  |    1 +
 net/netfilter/nfnetlink_queue.c                    |   15 +-
 net/netfilter/nft_compat.c                         |    8 +-
 net/netfilter/x_tables.c                           |   98 +-
 net/netfilter/xt_CT.c                              |   11 -
 net/netfilter/xt_bpf.c                             |    2 +-
 net/netlabel/netlabel_cipso_v4.c                   |   12 +-
 net/netlabel/netlabel_unlabeled.c                  |    6 +-
 net/netlink/af_netlink.c                           |    4 +-
 net/netlink/genetlink.c                            |   17 +-
 net/netrom/nr_loopback.c                           |    3 +-
 net/netrom/nr_route.c                              |    3 +-
 net/nfc/af_nfc.c                                   |    2 +-
 net/nfc/core.c                                     |    8 +-
 net/nfc/digital_core.c                             |    4 +-
 net/nfc/hci/core.c                                 |   14 +-
 net/nfc/hci/llc.c                                  |    4 +-
 net/nfc/hci/llc.h                                  |    6 +-
 net/nfc/hci/llc_nop.c                              |    2 +-
 net/nfc/hci/llc_shdlc.c                            |   12 +-
 net/nfc/llcp.h                                     |    8 +-
 net/nfc/llcp_commands.c                            |   46 +-
 net/nfc/llcp_core.c                                |   44 +-
 net/nfc/nci/core.c                                 |  176 +-
 net/nfc/nci/data.c                                 |   12 +-
 net/nfc/nci/hci.c                                  |   52 +-
 net/nfc/nci/ntf.c                                  |   87 +-
 net/nfc/nci/rsp.c                                  |   48 +-
 net/nfc/nci/spi.c                                  |    2 +-
 net/nfc/netlink.c                                  |    4 +-
 net/nfc/nfc.h                                      |    2 +-
 net/nfc/rawsock.c                                  |    2 +-
 net/openvswitch/actions.c                          |    8 +-
 net/openvswitch/datapath.c                         |   76 +-
 net/openvswitch/datapath.h                         |   20 +
 net/packet/af_packet.c                             |   15 +-
 net/phonet/af_phonet.c                             |    3 +-
 net/phonet/pn_dev.c                                |   12 +-
 net/phonet/socket.c                                |    3 +-
 net/qrtr/qrtr.c                                    |   12 +-
 net/rxrpc/Kconfig                                  |    7 +-
 net/sched/act_api.c                                |   73 +-
 net/sched/act_bpf.c                                |    8 +-
 net/sched/act_connmark.c                           |    4 +-
 net/sched/act_csum.c                               |    7 +-
 net/sched/act_ct.c                                 |    4 +-
 net/sched/act_ctinfo.c                             |    4 +-
 net/sched/act_gact.c                               |    4 +-
 net/sched/act_gate.c                               |    4 +-
 net/sched/act_ife.c                                |    9 +-
 net/sched/act_ipt.c                                |   21 +-
 net/sched/act_mirred.c                             |   10 +-
 net/sched/act_mpls.c                               |    4 +-
 net/sched/act_nat.c                                |    6 +-
 net/sched/act_pedit.c                              |    4 +-
 net/sched/act_police.c                             |    4 +-
 net/sched/act_sample.c                             |    7 +-
 net/sched/act_simple.c                             |    4 +-
 net/sched/act_skbedit.c                            |    4 +-
 net/sched/act_skbmod.c                             |   47 +-
 net/sched/act_tunnel_key.c                         |    4 +-
 net/sched/act_vlan.c                               |    4 +-
 net/sched/cls_api.c                                |   87 +-
 net/sched/cls_basic.c                              |   10 +-
 net/sched/cls_bpf.c                                |   12 +-
 net/sched/cls_cgroup.c                             |    6 +-
 net/sched/cls_flow.c                               |    6 +-
 net/sched/cls_flower.c                             |   18 +-
 net/sched/cls_fw.c                                 |   13 +-
 net/sched/cls_matchall.c                           |   17 +-
 net/sched/cls_route.c                              |   10 +-
 net/sched/cls_rsvp.h                               |    7 +-
 net/sched/cls_tcindex.c                            |   10 +-
 net/sched/cls_u32.c                                |   24 +-
 net/sched/sch_api.c                                |   10 +-
 net/sched/sch_atm.c                                |    2 +-
 net/sched/sch_cake.c                               |    2 +-
 net/sched/sch_cbq.c                                |    4 +-
 net/sched/sch_drr.c                                |    2 +-
 net/sched/sch_dsmark.c                             |    2 +-
 net/sched/sch_ets.c                                |    2 +-
 net/sched/sch_fq_codel.c                           |    2 +-
 net/sched/sch_fq_pie.c                             |    2 +-
 net/sched/sch_hfsc.c                               |    2 +-
 net/sched/sch_htb.c                                |   99 +-
 net/sched/sch_multiq.c                             |    2 +-
 net/sched/sch_prio.c                               |    2 +-
 net/sched/sch_qfq.c                                |    2 +-
 net/sched/sch_sfb.c                                |    2 +-
 net/sched/sch_sfq.c                                |    2 +-
 net/sched/sch_taprio.c                             |    4 +-
 net/smc/smc_core.c                                 |   31 +-
 net/smc/smc_ib.c                                   |    3 +-
 net/smc/smc_pnet.c                                 |    3 +-
 net/socket.c                                       |  352 +--
 net/switchdev/switchdev.c                          |  308 +++
 net/tipc/socket.c                                  |   34 +-
 net/unix/Kconfig                                   |    5 +
 net/unix/Makefile                                  |    1 +
 net/unix/af_unix.c                                 |  441 ++-
 net/unix/unix_bpf.c                                |  174 ++
 net/wireless/nl80211.c                             |  173 +-
 net/wireless/radiotap.c                            |    9 +-
 net/wireless/rdev-ops.h                            |   13 +
 net/wireless/reg.c                                 |    9 +-
 net/wireless/scan.c                                |    3 +-
 net/wireless/trace.h                               |   46 +
 net/xfrm/xfrm_policy.c                             |   16 +
 net/xfrm/xfrm_user.c                               |   57 +
 samples/bpf/.gitignore                             |    2 +
 samples/bpf/Makefile                               |  109 +-
 samples/bpf/Makefile.target                        |   11 +
 samples/bpf/cookie_uid_helper_example.c            |   11 +-
 samples/bpf/offwaketime_kern.c                     |    9 +-
 samples/bpf/test_override_return.sh                |    1 +
 samples/bpf/tracex4_user.c                         |    2 +-
 samples/bpf/tracex7_user.c                         |    5 +
 samples/bpf/xdp1_kern.c                            |    2 +
 samples/bpf/xdp2_kern.c                            |    2 +
 samples/bpf/xdp_monitor.bpf.c                      |    8 +
 samples/bpf/xdp_monitor_kern.c                     |  257 --
 samples/bpf/xdp_monitor_user.c                     |  798 +-----
 samples/bpf/xdp_redirect.bpf.c                     |   49 +
 ..._redirect_cpu_kern.c => xdp_redirect_cpu.bpf.c} |  393 +--
 samples/bpf/xdp_redirect_cpu_user.c                | 1132 +++-----
 samples/bpf/xdp_redirect_kern.c                    |   90 -
 ..._redirect_map_kern.c => xdp_redirect_map.bpf.c} |   89 +-
 ...p_multi_kern.c => xdp_redirect_map_multi.bpf.c} |   50 +-
 samples/bpf/xdp_redirect_map_multi_user.c          |  345 +--
 samples/bpf/xdp_redirect_map_user.c                |  385 ++-
 samples/bpf/xdp_redirect_user.c                    |  270 +-
 samples/bpf/xdp_sample.bpf.c                       |  266 ++
 samples/bpf/xdp_sample.bpf.h                       |  141 +
 samples/bpf/xdp_sample_shared.h                    |   17 +
 samples/bpf/xdp_sample_user.c                      | 1673 +++++++++++
 samples/bpf/xdp_sample_user.h                      |  108 +
 samples/bpf/xdpsock_user.c                         |   20 +-
 samples/pktgen/functions.sh                        |    2 +-
 .../pktgen/pktgen_bench_xmit_mode_netif_receive.sh |   19 +-
 .../pktgen/pktgen_bench_xmit_mode_queue_xmit.sh    |   19 +-
 samples/pktgen/pktgen_sample01_simple.sh           |   13 +-
 samples/pktgen/pktgen_sample02_multiqueue.sh       |   19 +-
 .../pktgen/pktgen_sample03_burst_single_flow.sh    |    6 +-
 samples/pktgen/pktgen_sample04_many_flows.sh       |   12 +-
 samples/pktgen/pktgen_sample05_flow_per_thread.sh  |   12 +-
 ...tgen_sample06_numa_awared_queue_irq_affinity.sh |   19 +-
 scripts/bpf_doc.py                                 |    2 +
 security/selinux/hooks.c                           |    4 +-
 security/selinux/include/classmap.h                |    4 +-
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    |   48 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |    3 +-
 .../bpf/bpftool/Documentation/bpftool-feature.rst  |    2 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    |    9 +-
 tools/bpf/bpftool/Documentation/bpftool-iter.rst   |    2 +
 tools/bpf/bpftool/Documentation/bpftool-link.rst   |    3 +-
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |    3 +-
 tools/bpf/bpftool/Documentation/bpftool-net.rst    |    2 +-
 tools/bpf/bpftool/Documentation/bpftool-perf.rst   |    2 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   36 +-
 .../bpftool/Documentation/bpftool-struct_ops.rst   |    2 +-
 tools/bpf/bpftool/Documentation/bpftool.rst        |   12 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   66 +-
 tools/bpf/bpftool/btf.c                            |   11 +-
 tools/bpf/bpftool/btf_dumper.c                     |    6 +-
 tools/bpf/bpftool/cgroup.c                         |    3 +-
 tools/bpf/bpftool/common.c                         |    6 +
 tools/bpf/bpftool/feature.c                        |    1 +
 tools/bpf/bpftool/gen.c                            |    3 +-
 tools/bpf/bpftool/iter.c                           |    2 +
 tools/bpf/bpftool/link.c                           |    3 +-
 tools/bpf/bpftool/main.c                           |    3 +-
 tools/bpf/bpftool/main.h                           |    3 +-
 tools/bpf/bpftool/map.c                            |   19 +-
 tools/bpf/bpftool/net.c                            |    1 +
 tools/bpf/bpftool/perf.c                           |    5 +-
 tools/bpf/bpftool/prog.c                           |   37 +-
 tools/bpf/bpftool/struct_ops.c                     |    2 +-
 tools/bpf/resolve_btfids/main.c                    |   13 +-
 tools/include/uapi/linux/bpf.h                     |  119 +-
 tools/include/uapi/linux/ethtool.h                 |   53 +
 tools/include/uapi/linux/if_link.h                 |    2 +
 tools/lib/bpf/Build                                |    2 +-
 tools/lib/bpf/Makefile                             |   10 +-
 tools/lib/bpf/bpf.c                                |   32 +-
 tools/lib/bpf/bpf.h                                |    8 +-
 tools/lib/bpf/btf.c                                |   47 +-
 tools/lib/bpf/btf.h                                |   31 +-
 tools/lib/bpf/btf_dump.c                           |  871 +++++-
 tools/lib/bpf/libbpf.c                             | 1776 +++---------
 tools/lib/bpf/libbpf.h                             |   76 +-
 tools/lib/bpf/libbpf.map                           |   11 +
 tools/lib/bpf/libbpf_internal.h                    |  113 +-
 tools/lib/bpf/relo_core.c                          | 1295 +++++++++
 tools/lib/bpf/relo_core.h                          |  100 +
 tools/perf/util/bpf-event.c                        |   11 +-
 tools/perf/util/bpf_counter.c                      |   12 +-
 tools/testing/selftests/Makefile                   |    1 +
 tools/testing/selftests/bpf/.gitignore             |    1 -
 tools/testing/selftests/bpf/Makefile               |    7 +-
 tools/testing/selftests/bpf/README.rst             |    7 +
 tools/testing/selftests/bpf/bpf_tcp_helpers.h      |   19 +
 tools/testing/selftests/bpf/netcnt_common.h        |   38 +-
 tools/testing/selftests/bpf/network_helpers.c      |  120 +-
 tools/testing/selftests/bpf/network_helpers.h      |   11 +
 .../selftests/bpf/prog_tests/attach_probe.c        |   98 +-
 .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |  254 ++
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |   16 +
 .../selftests/bpf/prog_tests/bpf_iter_setsockopt.c |  226 ++
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |  106 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |    4 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |  615 +++++
 .../testing/selftests/bpf/prog_tests/btf_module.c  |   34 +
 .../selftests/bpf/prog_tests/core_autosize.c       |   22 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |   25 +-
 .../selftests/bpf/prog_tests/get_func_ip_test.c    |   55 +
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |    2 +-
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c |   31 +
 tools/testing/selftests/bpf/prog_tests/netcnt.c    |   82 +
 .../selftests/bpf/prog_tests/netns_cookie.c        |   80 +
 tools/testing/selftests/bpf/prog_tests/perf_link.c |   89 +
 tools/testing/selftests/bpf/prog_tests/pinning.c   |    9 +
 .../selftests/bpf/prog_tests/reference_tracking.c  |    4 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |   61 +-
 tools/testing/selftests/bpf/prog_tests/snprintf.c  |    4 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |  445 ++-
 .../selftests/bpf/prog_tests/sockopt_inherit.c     |    4 +-
 .../selftests/bpf/prog_tests/sockopt_qos_to_cc.c   |   70 +
 .../selftests/bpf/prog_tests/task_pt_regs.c        |   47 +
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |   11 +-
 tools/testing/selftests/bpf/prog_tests/timer.c     |   55 +
 tools/testing/selftests/bpf/prog_tests/timer_mim.c |   77 +
 .../testing/selftests/bpf/prog_tests/xdp_bonding.c |  520 ++++
 .../bpf/prog_tests/xdp_context_test_run.c          |  105 +
 .../selftests/bpf/prog_tests/xdp_cpumap_attach.c   |   43 +-
 .../selftests/bpf/prog_tests/xdp_devmap_attach.c   |   39 +-
 tools/testing/selftests/bpf/progs/bpf_dctcp.c      |   25 +
 .../selftests/bpf/progs/bpf_dctcp_release.c        |   26 +
 tools/testing/selftests/bpf/progs/bpf_iter.h       |    8 +
 .../selftests/bpf/progs/bpf_iter_setsockopt.c      |   72 +
 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c  |    2 +-
 tools/testing/selftests/bpf/progs/bpf_iter_unix.c  |   80 +
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |   10 +
 .../testing/selftests/bpf/progs/get_func_ip_test.c |   84 +
 .../selftests/bpf/progs/kfunc_call_test_subprog.c  |    4 +-
 tools/testing/selftests/bpf/progs/netcnt_prog.c    |    8 +-
 .../selftests/bpf/progs/netns_cookie_prog.c        |   84 +
 .../selftests/bpf/progs/sockopt_qos_to_cc.c        |   39 +
 tools/testing/selftests/bpf/progs/sockopt_sk.c     |   16 +
 .../testing/selftests/bpf/progs/test_bpf_cookie.c  |   85 +
 .../selftests/bpf/progs/test_core_autosize.c       |   20 +-
 .../testing/selftests/bpf/progs/test_ksyms_weak.c  |   56 +
 .../selftests/bpf/progs/test_map_in_map_invalid.c  |   26 +
 tools/testing/selftests/bpf/progs/test_perf_link.c |   16 +
 .../selftests/bpf/progs/test_sk_lookup_kern.c      |   14 +-
 tools/testing/selftests/bpf/progs/test_snprintf.c  |    6 +-
 .../selftests/bpf/progs/test_task_pt_regs.c        |   29 +
 tools/testing/selftests/bpf/progs/test_tc_tunnel.c |    1 -
 .../bpf/progs/test_xdp_context_test_run.c          |   20 +
 tools/testing/selftests/bpf/progs/timer.c          |  297 ++
 tools/testing/selftests/bpf/progs/timer_mim.c      |   88 +
 .../testing/selftests/bpf/progs/timer_mim_reject.c |   74 +
 tools/testing/selftests/bpf/progs/xdp_tx.c         |    2 +-
 tools/testing/selftests/bpf/test_bpftool.sh        |    6 +
 tools/testing/selftests/bpf/test_bpftool_build.sh  |    2 +-
 .../selftests/bpf/test_bpftool_synctypes.py        |  586 ++++
 tools/testing/selftests/bpf/test_doc_build.sh      |   10 +-
 tools/testing/selftests/bpf/test_maps.c            |   90 +-
 tools/testing/selftests/bpf/test_netcnt.c          |  148 -
 tools/testing/selftests/bpf/test_progs.c           |  107 +-
 tools/testing/selftests/bpf/test_progs.h           |   12 +
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |    2 +-
 tools/testing/selftests/bpf/test_xdp_veth.sh       |    2 +-
 tools/testing/selftests/bpf/test_xsk.sh            |   10 +-
 tools/testing/selftests/bpf/trace_helpers.c        |   87 +
 tools/testing/selftests/bpf/trace_helpers.h        |    4 +
 tools/testing/selftests/bpf/xdpxceiver.c           |  681 +++--
 tools/testing/selftests/bpf/xdpxceiver.h           |   63 +-
 tools/testing/selftests/bpf/xsk_prereqs.sh         |   30 +-
 tools/testing/selftests/nci/nci_dev.c              |  416 ++-
 tools/testing/selftests/net/Makefile               |    5 +
 tools/testing/selftests/net/af_unix/Makefile       |    5 +
 .../testing/selftests/net/af_unix/test_unix_oob.c  |  437 +++
 tools/testing/selftests/net/config                 |    1 +
 tools/testing/selftests/net/fcnal-test.sh          |   33 +-
 tools/testing/selftests/net/fib_rule_tests.sh      |    7 +-
 .../selftests/net/forwarding/devlink_lib.sh        |   15 +-
 tools/testing/selftests/net/forwarding/lib.sh      |   27 +-
 .../selftests/net/forwarding/router_mpath_nh.sh    |    2 +-
 .../net/forwarding/router_mpath_nh_res.sh          |    2 +-
 tools/testing/selftests/net/gro.c                  | 1095 ++++++++
 tools/testing/selftests/net/gro.sh                 |   99 +
 tools/testing/selftests/net/ioam6.sh               |  652 +++++
 tools/testing/selftests/net/ioam6_parser.c         |  720 +++++
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  345 ++-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c      |   16 +-
 tools/testing/selftests/net/psock_fanout.c         |    4 +-
 tools/testing/selftests/net/psock_snd.sh           |    3 -
 tools/testing/selftests/net/run_afpackettests      |    5 +-
 tools/testing/selftests/net/setup_loopback.sh      |  118 +
 tools/testing/selftests/net/setup_veth.sh          |   41 +
 .../selftests/net/srv6_end_dt46_l3vpn_test.sh      |    9 +-
 .../selftests/net/srv6_end_dt4_l3vpn_test.sh       |    9 +-
 .../selftests/net/srv6_end_dt6_l3vpn_test.sh       |    9 +-
 tools/testing/selftests/net/toeplitz.c             |  585 ++++
 tools/testing/selftests/net/toeplitz.sh            |  199 ++
 tools/testing/selftests/net/toeplitz_client.sh     |   28 +
 tools/testing/selftests/net/unicast_extensions.sh  |    5 +-
 tools/testing/selftests/net/veth.sh                |  183 +-
 .../testing/selftests/net/vrf_strict_mode_test.sh  |    9 +-
 .../tc-testing/tc-tests/actions/skbmod.json        |   24 +
 .../selftests/tc-testing/tc-tests/qdiscs/mq.json   |  137 +
 tools/testing/selftests/tc-testing/tdc_config.py   |    1 +
 1812 files changed, 80507 insertions(+), 41279 deletions(-)
 rename Documentation/bpf/libbpf/{libbpf.rst => index.rst} (75%)
 delete mode 100644 Documentation/bpf/libbpf/libbpf_api.rst
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
 create mode 100644 Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/c_can.txt
 create mode 100644 Documentation/devicetree/bindings/net/fsl,fec.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/fsl-fec.txt
 create mode 100644 Documentation/devicetree/bindings/net/intel,ixp46x-ptp-timer.yaml
 create mode 100644 Documentation/devicetree/bindings/net/litex,liteeth.yaml
 create mode 100644 Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-driver.rst
 create mode 100644 Documentation/networking/devlink/hns3.rst
 delete mode 100644 Documentation/networking/devlink/sja1105.rst
 create mode 100644 Documentation/networking/ioam6-sysctl.rst
 create mode 100644 Documentation/networking/mctp.rst
 create mode 100644 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
 create mode 100644 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.h
 create mode 100644 drivers/net/ethernet/litex/Kconfig
 create mode 100644 drivers/net/ethernet/litex/Makefile
 create mode 100644 drivers/net/ethernet/litex/litex_liteeth.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/channels.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/channels.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rqt.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rss.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rss.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h
 rename drivers/net/ethernet/mellanox/mlx5/core/{esw => en/tc}/sample.c (53%)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tir.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/diag/qos_tracepoint.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
 delete mode 100644 drivers/net/ipa/ipa_clock.c
 delete mode 100644 drivers/net/ipa/ipa_clock.h
 create mode 100644 drivers/net/ipa/ipa_power.c
 create mode 100644 drivers/net/ipa/ipa_power.h
 create mode 100644 drivers/net/mctp/Kconfig
 create mode 100644 drivers/net/mctp/Makefile
 delete mode 100644 drivers/net/mhi/Makefile
 delete mode 100644 drivers/net/mhi/mhi.h
 delete mode 100644 drivers/net/mhi/proto_mbim.c
 rename drivers/net/{mhi/net.c => mhi_net.c} (74%)
 create mode 100644 drivers/net/phy/mxl-gpy.c
 delete mode 100644 drivers/net/wan/sbni.c
 delete mode 100644 drivers/net/wan/sbni.h
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.h
 delete mode 100644 drivers/net/wireless/intersil/prism54/Makefile
 delete mode 100644 drivers/net/wireless/intersil/prism54/isl_38xx.c
 delete mode 100644 drivers/net/wireless/intersil/prism54/isl_38xx.h
 delete mode 100644 drivers/net/wireless/intersil/prism54/isl_ioctl.c
 delete mode 100644 drivers/net/wireless/intersil/prism54/isl_ioctl.h
 delete mode 100644 drivers/net/wireless/intersil/prism54/isl_oid.h
 delete mode 100644 drivers/net/wireless/intersil/prism54/islpci_dev.c
 delete mode 100644 drivers/net/wireless/intersil/prism54/islpci_dev.h
 delete mode 100644 drivers/net/wireless/intersil/prism54/islpci_eth.c
 delete mode 100644 drivers/net/wireless/intersil/prism54/islpci_eth.h
 delete mode 100644 drivers/net/wireless/intersil/prism54/islpci_hotplug.c
 delete mode 100644 drivers/net/wireless/intersil/prism54/islpci_mgt.c
 delete mode 100644 drivers/net/wireless/intersil/prism54/islpci_mgt.h
 delete mode 100644 drivers/net/wireless/intersil/prism54/oid_mgt.c
 delete mode 100644 drivers/net/wireless/intersil/prism54/oid_mgt.h
 delete mode 100644 drivers/net/wireless/intersil/prism54/prismcompat.h
 create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
 create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
 create mode 100644 drivers/net/wwan/mhi_wwan_mbim.c
 create mode 100644 include/linux/can/platform/flexcan.h
 create mode 100644 include/linux/ioam6.h
 create mode 100644 include/linux/ioam6_genl.h
 create mode 100644 include/linux/ioam6_iptunnel.h
 create mode 100644 include/net/ioam6.h
 delete mode 100644 include/net/ipx.h
 create mode 100644 include/net/mctp.h
 create mode 100644 include/net/mctpdevice.h
 create mode 100644 include/net/netfilter/nf_hooks_lwtunnel.h
 create mode 100644 include/net/netns/mctp.h
 delete mode 100644 include/net/netns/x_tables.h
 create mode 100644 include/uapi/linux/ioam6.h
 create mode 100644 include/uapi/linux/ioam6_genl.h
 create mode 100644 include/uapi/linux/ioam6_iptunnel.h
 delete mode 100644 include/uapi/linux/ipx.h
 create mode 100644 include/uapi/linux/mctp.h
 create mode 100644 include/uapi/linux/nl80211-vnd-intel.h
 delete mode 100644 net/802/p8023.c
 create mode 100644 net/ipv6/ioam6.c
 create mode 100644 net/ipv6/ioam6_iptunnel.c
 create mode 100644 net/mctp/Kconfig
 create mode 100644 net/mctp/Makefile
 create mode 100644 net/mctp/af_mctp.c
 create mode 100644 net/mctp/device.c
 create mode 100644 net/mctp/neigh.c
 create mode 100644 net/mctp/route.c
 create mode 100644 net/netfilter/nf_hooks_lwtunnel.c
 create mode 100644 net/unix/unix_bpf.c
 create mode 100644 samples/bpf/xdp_monitor.bpf.c
 delete mode 100644 samples/bpf/xdp_monitor_kern.c
 create mode 100644 samples/bpf/xdp_redirect.bpf.c
 rename samples/bpf/{xdp_redirect_cpu_kern.c => xdp_redirect_cpu.bpf.c} (52%)
 delete mode 100644 samples/bpf/xdp_redirect_kern.c
 rename samples/bpf/{xdp_redirect_map_kern.c => xdp_redirect_map.bpf.c} (57%)
 rename samples/bpf/{xdp_redirect_map_multi_kern.c => xdp_redirect_map_multi.bpf.c} (64%)
 create mode 100644 samples/bpf/xdp_sample.bpf.c
 create mode 100644 samples/bpf/xdp_sample.bpf.h
 create mode 100644 samples/bpf/xdp_sample_shared.h
 create mode 100644 samples/bpf/xdp_sample_user.c
 create mode 100644 samples/bpf/xdp_sample_user.h
 create mode 100644 tools/lib/bpf/relo_core.c
 create mode 100644 tools/lib/bpf/relo_core.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_module.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/netcnt.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/netns_cookie.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_link.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockopt_qos_to_cc.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/task_pt_regs.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer_mim.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_context_test_run.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_dctcp_release.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_setsockopt.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_func_ip_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/netns_cookie_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/sockopt_qos_to_cc.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_cookie.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_weak.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_map_in_map_invalid.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_perf_link.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_task_pt_regs.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_context_test_run.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer_mim.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer_mim_reject.c
 create mode 100755 tools/testing/selftests/bpf/test_bpftool_synctypes.py
 delete mode 100644 tools/testing/selftests/bpf/test_netcnt.c
 create mode 100644 tools/testing/selftests/net/af_unix/Makefile
 create mode 100644 tools/testing/selftests/net/af_unix/test_unix_oob.c
 create mode 100644 tools/testing/selftests/net/gro.c
 create mode 100755 tools/testing/selftests/net/gro.sh
 create mode 100755 tools/testing/selftests/net/ioam6.sh
 create mode 100644 tools/testing/selftests/net/ioam6_parser.c
 create mode 100755 tools/testing/selftests/net/setup_loopback.sh
 create mode 100644 tools/testing/selftests/net/setup_veth.sh
 create mode 100644 tools/testing/selftests/net/toeplitz.c
 create mode 100755 tools/testing/selftests/net/toeplitz.sh
 create mode 100755 tools/testing/selftests/net/toeplitz_client.sh
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
