Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CECF53327C
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 22:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241436AbiEXUcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 16:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240565AbiEXUcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 16:32:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1305E16C;
        Tue, 24 May 2022 13:32:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A37B1B81B9B;
        Tue, 24 May 2022 20:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9713DC34117;
        Tue, 24 May 2022 20:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653424321;
        bh=2Ojgkjiyy0CP+cRSp57NIknBuimxWWIndC6JoEVogLo=;
        h=From:To:Cc:Subject:Date:From;
        b=b0H6IgB+dkZYjncgeycPfR9oMOLsZWrbTZ2l9gy7XhcJ4UNobwJw6X11uVFK6aQuZ
         Ouik8oUM61CnBcFIztByiHVEVP8tqdPkgZ9BK9/h/j9+CDE0tjSMroetYli3eZhBlM
         lfwtY5rkXLTplbzBmH72V4WcuHaWg6uBfTkOhhguA0nk30njL2bnSNVZlEi5iwk5Ji
         7EvcdZ3whgU4rVhIklIPy7GWh7nbJ0H69uxzo8OErKbZRGvwC3UvkvFRzMihP5EvRd
         GliqnBlUtA7xKEyF9rvu5CxYfRfYck+1Tu+uLqppcVnLjbEpv6IQO+e3FgaE022uSK
         Rj8PoQFo16lDQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.19
Date:   Tue, 24 May 2022 13:31:59 -0700
Message-Id: <20220524203159.1189780-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

We have a conflict with the sysctl changes, delete both sides:
https://lore.kernel.org/all/20220414112812.652190b5@canb.auug.org.au/
(the resolution from Stephen is a bit hard to read, but just delete).

There may be a warning if you pull after the bitmap tree PR, too:
https://lore.kernel.org/all/20220524082256.3b8033a9@canb.auug.org.au/

The following changes since commit d904c8cc0302393640bc29ee62193f88ddc53126:

  Merge tag 'net-5.18-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-05-19 05:50:29 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-5.19

for you to fetch changes up to 57d7becda9c9e612e6b00676f2eecfac3e719e88:

  Merge branch 'ptp-ocp-various-updates' (2022-05-24 11:40:01 -0700)

----------------------------------------------------------------
Networking changes for 5.19.

Core
----

 - Support TCPv6 segmentation offload with super-segments larger than
   64k bytes using the IPv6 Jumbogram extension header (AKA BIG TCP).

 - Generalize skb freeing deferral to per-cpu lists, instead of
   per-socket lists.

 - Add a netdev statistic for packets dropped due to L2 address
   mismatch (rx_otherhost_dropped).

 - Continue work annotating skb drop reasons.

 - Accept alternative netdev names (ALT_IFNAME) in more netlink
   requests.

 - Add VLAN support for AF_PACKET SOCK_RAW GSO.

 - Allow receiving skb mark from the socket as a cmsg.

 - Enable memcg accounting for veth queues, sysctl tables and IPv6.

BPF
---

 - Add libbpf support for User Statically-Defined Tracing (USDTs).

 - Speed up symbol resolution for kprobes multi-link attachments.

 - Support storing typed pointers to referenced and unreferenced
   objects in BPF maps.

 - Add support for BPF link iterator.

 - Introduce access to remote CPU map elements in BPF per-cpu map.

 - Allow middle-of-the-road settings for the
   kernel.unprivileged_bpf_disabled sysctl.

 - Implement basic types of dynamic pointers e.g. to allow for
   dynamically sized ringbuf reservations without extra memory copies.

Protocols
---------

 - Retire port only listening_hash table, add a second bind table
   hashed by port and address. Avoid linear list walk when binding
   to very popular ports (e.g. 443).

 - Add bridge FDB bulk flush filtering support allowing user space
   to remove all FDB entries matching a condition.

 - Introduce accept_unsolicited_na sysctl for IPv6 to implement
   router-side changes for RFC9131.

 - Support for MPTCP path manager in user space.

 - Add MPTCP support for fallback to regular TCP for connections
   that have never connected additional subflows or transmitted
   out-of-sequence data (partial support for RFC8684 fallback).

 - Avoid races in MPTCP-level window tracking, stabilize and improve
   throughput.

 - Support lockless operation of GRE tunnels with seq numbers enabled.

 - WiFi support for host based BSS color collision detection.

 - Add support for SO_TXTIME/SCM_TXTIME on CAN sockets.

 - Support transmission w/o flow control in CAN ISOTP (ISO 15765-2).

 - Support zero-copy Tx with TLS 1.2 crypto offload (sendfile).

 - Allow matching on the number of VLAN tags via tc-flower.

 - Add tracepoint for tcp_set_ca_state().

Driver API
----------

 - Improve error reporting from classifier and action offload.

 - Add support for listing line cards in switches (devlink).

 - Add helpers for reporting page pool statistics with ethtool -S.

 - Add support for reading clock cycles when using PTP virtual clocks,
   instead of having the driver convert to time before reporting.
   This makes it possible to report time from different vclocks.

 - Support configuring low-latency Tx descriptor push via ethtool.

 - Separate Clause 22 and Clause 45 MDIO accesses more explicitly.

New hardware / drivers
----------------------

 - Ethernet:
   - Marvell's Octeon NIC PCI Endpoint support (octeon_ep)
   - Sunplus SP7021 SoC (sp7021_emac)
   - Add support for Renesas RZ/V2M (in ravb)
   - Add support for MediaTek mt7986 switches (in mtk_eth_soc)

 - Ethernet PHYs:
   - ADIN1100 industrial PHYs (w/ 10BASE-T1L and SQI reporting)
   - TI DP83TD510 PHY
   - Microchip LAN8742/LAN88xx PHYs

 - WiFi:
   - Driver for pureLiFi X, XL, XC devices (plfxlc)
   - Driver for Silicon Labs devices (wfx)
   - Support for WCN6750 (in ath11k)
   - Support Realtek 8852ce devices (in rtw89)

 - Mobile:
   - MediaTek T700 modems (Intel 5G 5000 M.2 cards)

 - CAN:
  - ctucanfd: add support for CTU CAN FD open-source IP core
    from Czech Technical University in Prague

Drivers
-------

 - Delete a number of old drivers still using virt_to_bus().

 - Ethernet NICs:
   - intel: support TSO on tunnels MPLS
   - broadcom: support multi-buffer XDP
   - nfp: support VF rate limiting
   - sfc: use hardware tx timestamps for more than PTP
   - mlx5: multi-port eswitch support
   - hyper-v: add support for XDP_REDIRECT
   - atlantic: XDP support (including multi-buffer)
   - macb: improve real-time perf by deferring Tx processing to NAPI

 - High-speed Ethernet switches:
   - mlxsw: implement basic line card information querying
   - prestera: add support for traffic policing on ingress and egress

 - Embedded Ethernet switches:
   - lan966x: add support for packet DMA (FDMA)
   - lan966x: add support for PTP programmable pins
   - ti: cpsw_new: enable bc/mc storm prevention

 - Qualcomm 802.11ax WiFi (ath11k):
   - Wake-on-WLAN support for QCA6390 and WCN6855
   - device recovery (firmware restart) support
   - support setting Specific Absorption Rate (SAR) for WCN6855
   - read country code from SMBIOS for WCN6855/QCA6390
   - enable keep-alive during WoWLAN suspend
   - implement remain-on-channel support

 - MediaTek WiFi (mt76):
   - support Wireless Ethernet Dispatch offloading packet movement
     between the Ethernet switch and WiFi interfaces
   - non-standard VHT MCS10-11 support
   - mt7921 AP mode support
   - mt7921 IPv6 NS offload support

 - Ethernet PHYs:
   - micrel: ksz9031/ksz9131: cabletest support
   - lan87xx: SQI support for T1 PHYs
   - lan937x: add interrupt support for link detection

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Abhishek Kumar (1):
      ath10k: skip ath10k_halt during suspend for driver state RESTARTING

Ahmad Fatoum (1):
      Bluetooth: hci_sync: use hci_skb_event() helper

Ajay Singh (5):
      wilc1000: increase firmware version array size
      wilc1000: use fixed function base register value to access SDIO_FBR_ENABLE_CSA
      wilc1000: fix crash observed in AP mode with cfg80211_register_netdevice()
      wilc1000: use 'u64' datatype for cookie variable
      wilc1000: add valid vmm_entry check before fetching from TX queue

Akira Yokosawa (1):
      docs: ctucanfd: Use 'kernel-figure' directive instead of 'figure'

Alaa Mohamed (6):
      selftests: net: fib_rule_tests: add support to select a test to run
      igb: Convert kmap() to kmap_local_page()
      rtnetlink: add extack support in fdb del handlers
      net: vxlan: Add extack support to vxlan_fdb_delete
      net: vxlan: Fix kernel coding style
      net: mscc: fix the alignment in ocelot_port_fdb_del()

Alan Maguire (11):
      libbpf: auto-resolve programs/libraries when necessary for uprobes
      libbpf: Support function name-based attach uprobes
      libbpf: Add auto-attach for uprobes based on section name
      selftests/bpf: Add tests for u[ret]probe attach by name
      selftests/bpf: Add tests for uprobe auto-attach via skeleton
      libbpf: Improve library identification for uprobe binary path resolution
      libbpf: Improve string parsing for uprobe auto-attach
      selftests/bpf: Uprobe tests should verify param/return values
      libbpf: Usdt aarch64 arg parsing support
      bpf: refine kernel.unprivileged_bpf_disabled behaviour
      selftests/bpf: add tests verifying unprivileged bpf behaviour

Alex Elder (17):
      net: ipa: compute proper aggregation limit
      net: ipa: drop an unneeded transaction reference
      net: ipa: rename a GSI error code
      net: ipa: ignore endianness if there is no header
      net: ipa: open-code ether_setup()
      net: ipa: move endpoint configuration data definitions
      net: ipa: rename a few endpoint config data types
      net: ipa: save a copy of endpoint default config
      net: ipa: make endpoint HOLB drop configurable
      net: ipa: support hard aggregation limits
      net: ipa: specify RX aggregation time limit in config data
      net: ipa: kill gsi_trans_commit_wait_timeout()
      net: ipa: count the number of modem TX endpoints
      net: ipa: get rid of ipa_cmd_info->direction
      net: ipa: remove command direction argument
      net: ipa: remove command info pool
      net: ipa: use data space for command opcodes

Alexander Duyck (2):
      net: allow gso_max_size to exceed 65536
      net: allow gro_max_size to exceed 65536

Alexander Lobakin (6):
      samples: bpf: Fix linking xdp_router_ipv4 after migration
      ice: switch: add and use u16[] aliases to ice_adv_lkup_elem::{h, m}_u
      ice: switch: unobscurify bitops loop in ice_fill_adv_dummy_packet()
      ice: switch: use a struct to pass packet template params
      ice: switch: use convenience macros to declare dummy pkt templates
      ice: switch: convert packet template match code to rodata

Alexander Wetzel (1):
      rtl818x: Prevent using not initialized queues

Alexandru Ardelean (1):
      net: phy: adin1100: Add initial support for ADIN1100 industrial PHY

Alexandru Tachici (6):
      ethtool: Add 10base-T1L link mode entry
      net: phy: Add 10-BaseT1L registers
      net: phy: Add BaseT1 auto-negotiation registers
      net: phy: Add 10BASE-T1L support in phy-c45
      net: phy: adin1100: Add SQI support
      dt-bindings: net: phy: Add 10-baseT1L 2.4 Vpp

Alexei Starovoitov (15):
      Merge branch 'Add libbpf support for USDTs'
      Merge branch 'Ensure type tags are always ordered first in BTF'
      Merge branch 'Introduce typed pointer support in BPF maps'
      Merge branch 'Teach libbpf to "fix up" BPF verifier log'
      Merge branch 'libbpf: allow to opt-out from BPF map creation'
      Merge branch 'Add source ip in bpf tunnel key'
      Merge branch 'bpf: bpf link iterator'
      Merge branch 'bpf: Speed up symbol resolving in kprobe multi link'
      Merge branch 'selftests: xsk: add busy-poll testing plus various fixes'
      Merge branch 'Follow ups for kptr series'
      Merge branch 'Introduce access remote cpu elem support in BPF percpu map'
      bpf: Fix combination of jit blinding and pointers to bpf subprogs.
      selftests/bpf: Check combination of jit blinding and pointers to bpf subprogs.
      Merge branch 'Start libbpf 1.0 dev cycle'
      Merge branch 'bpf: refine kernel.unprivileged_bpf_disabled behaviour'

Alvin Šipraga (1):
      net: dsa: realtek: rtl8366rb: Serialize indirect PHY register access

Amit Cohen (2):
      selftests: fib_nexthops: Make the test more robust
      selftests: fib_nexthops: Make ping timeout configurable

Andrea Parri (Microsoft) (1):
      hv_netvsc: Print value of invalid ID in netvsc_send_{completion,tx_complete}()

Andrejs Cainikovs (2):
      mwifiex: Select firmware based on strapping
      mwifiex: Add SD8997 SDIO-UART firmware

Andrew Lunn (5):
      net: phylink: Convert to mdiobus_c45_{read|write}
      net: phy: Convert to mdiobus_c45_{read|write}
      net: phy: bcm87xx: Use mmd helpers
      net: dsa: sja1105: Convert to mdiobus_c45_read
      net: pcs: pcs-xpcs: Convert to mdiobus_c45_read

Andrii Nakryiko (63):
      Merge branch 'libbpf: name-based u[ret]probe attach'
      Merge branch 'bpf/bpftool: add program & link type names'
      libbpf: Add BPF-side of USDT support
      libbpf: Wire up USDT API and bpf_link integration
      libbpf: Add USDT notes parsing and resolution logic
      libbpf: Wire up spec management and other arch-independent USDT logic
      libbpf: Add x86-specific USDT arg spec parsing logic
      selftests/bpf: Add basic USDT selftests
      selftests/bpf: Add urandom_read shared lib and USDTs
      Merge branch 'libbpf: uprobe name-based attach followups'
      libbpf: Fix use #ifdef instead of #if to avoid compiler warning
      Merge branch 'Add USDT support for s390'
      libbpf: Use strlcpy() in path resolution fallback logic
      libbpf: Allow WEAK and GLOBAL bindings during BTF fixup
      libbpf: Don't error out on CO-RE relos for overriden weak subprogs
      libbpf: Use weak hidden modifier for USDT BPF-side API functions
      selftests/bpf: Add CO-RE relos into linked_funcs selftests
      Merge branch 'bpf: RLIMIT_MEMLOCK cleanups'
      libbpf: Support opting out from autoloading BPF programs declaratively
      selftests/bpf: Use non-autoloaded programs in few tests
      Merge branch 'Support riscv libbpf USDT arg parsing logic'
      bpf: Allow attach TRACING programs through LINK_CREATE command
      libbpf: Teach bpf_link_create() to fallback to bpf_raw_tracepoint_open()
      selftests/bpf: Switch fexit_stress to bpf_link_create() API
      libbpf: Fix anonymous type check in CO-RE logic
      libbpf: Drop unhelpful "program too large" guess
      libbpf: Fix logic for finding matching program for CO-RE relocation
      libbpf: Avoid joining .BTF.ext data with BPF programs by section name
      selftests/bpf: Add CO-RE relos and SEC("?...") to linked_funcs selftests
      libbpf: Record subprog-resolved CO-RE relocations unconditionally
      libbpf: Refactor CO-RE relo human description formatting routine
      libbpf: Simplify bpf_core_parse_spec() signature
      libbpf: Fix up verifier log for unguarded failed CO-RE relos
      selftests/bpf: Add libbpf's log fixup logic selftests
      libbpf: Allow "incomplete" basic tracing SEC() definitions
      libbpf: Support target-less SEC() definitions for BTF-backed programs
      selftests/bpf: Use target-less SEC() definitions in various tests
      libbpf: Append "..." in fixed up log if CO-RE spec is truncated
      libbpf: Use libbpf_mem_ensure() when allocating new map
      libbpf: Allow to opt-out from creating BPF maps
      selftests/bpf: Test bpf_map__set_autocreate() and related log fixup logic
      selftests/bpf: Prevent skeleton generation race
      libbpf: Make __kptr and __kptr_ref unconditionally use btf_type_tag() attr
      libbpf: Improve usability of field-based CO-RE helpers
      selftests/bpf: Use both syntaxes for field-based CO-RE helpers
      libbpf: Complete field-based CO-RE helpers with field offset helper
      selftests/bpf: Add bpf_core_field_offset() tests
      libbpf: Provide barrier() and barrier_var() in bpf_helpers.h
      libbpf: Automatically fix up BPF_MAP_TYPE_RINGBUF size, if necessary
      selftests/bpf: Test libbpf's ringbuf size fix up logic
      Merge branch 'bpftool: fix feature output when helper probes fail'
      Merge branch 'Attach a cookie to a tracing program.'
      libbpf: Clean up ringbuf size adjustment implementation
      selftests/bpf: make fexit_stress test run in serial mode
      libbpf: Add safer high-level wrappers for map operations
      selftests/bpf: Convert some selftests to high-level BPF map APIs
      selftests/bpf: Fix usdt_400 test case
      libbpf: fix memory leak in attach_tp for target-less tracepoint program
      libbpf: fix up global symbol counting logic
      libbpf: start 1.0 development cycle
      libbpf: remove bpf_create_map*() APIs
      Merge branch 'bpf: mptcp: Support for mptcp_sock'
      Merge branch 'Dynamic pointers'

Andy Gospodarek (11):
      bnxt: refactor bnxt_rx_xdp to separate xdp_init_buff/xdp_prepare_buff
      bnxt: add flag to denote that an xdp program is currently attached
      bnxt: refactor bnxt_rx_pages operate on skb_shared_info
      bnxt: rename bnxt_rx_pages to bnxt_rx_agg_pages_skb
      bnxt: adding bnxt_rx_agg_pages_xdp for aggregated xdp
      bnxt: set xdp_buff pfmemalloc flag if needed
      bnxt: change receive ring space parameters
      bnxt: add page_pool support for aggregation ring when using xdp
      bnxt: adding bnxt_xdp_build_skb to build skb from multibuffer xdp_buff
      bnxt: support transmit and free of aggregation buffers
      bnxt: XDP multibuffer enablement

Andy Shevchenko (2):
      firmware: tee_bnxt: Use UUID API for exporting the UUID
      bcma: gpio: Switch to use fwnode instead of of_node

Anilkumar Kolli (1):
      ath11k: Reuse the available memory after firmware reload

Ansuel Smith (6):
      net: dsa: qca8k: drop MTU tracking from qca8k_priv
      net: dsa: qca8k: drop port_sts from qca8k_priv
      net: dsa: qca8k: rework and simplify mdiobus logic
      net: dsa: qca8k: drop dsa_switch_ops from qca8k_priv
      net: dsa: qca8k: correctly handle mdio read error
      net: dsa: qca8k: unify bus id naming with legacy and OF mdio bus

Artem Savkov (4):
      selftests/bpf: Use bpf_num_possible_cpus() in per-cpu map allocations
      selftests/bpf: Fix attach tests retcode checks
      selftests/bpf: Fix prog_tests uprobe_autoattach compilation error
      selftests/bpf: Fix map tests errno checks

Arun Ajith S (2):
      net/ipv6: Introduce accept_unsolicited_na knob to implement router-side changes for RFC9131
      net/ipv6: Enforce limits for accept_unsolicited_na sysctl

Arun Ramadoss (13):
      net: phy: LAN87xx: add ethtool SQI support
      MAINTAINERS: Add maintainers for Microchip T1 Phy driver
      net: phy: LAN937x: add interrupt support for link detection
      net: dsa: ksz: added the generic port_stp_state_set function
      net: dsa: ksz9477: move get_stats64 to ksz_common.c
      net: dsa: microchip: ksz8795: update the port_cnt value in ksz_chip_data
      net: dsa: microchip: move ksz_chip_data to ksz_common
      net: dsa: microchip: perform the compatibility check for dev probed
      net: dsa: microchip: move struct mib_names to ksz_chip_data
      net: dsa: microchip: move port memory allocation to ksz_common
      net: dsa: microchip: move get_strings to ksz_common
      net: dsa: microchip: add the phylink get_caps
      net: dsa: microchip: remove unused members in ksz_device

Arınç ÜNAL (1):
      net: bridge: offload BR_HAIRPIN_MODE, BR_ISOLATED, BR_MULTICAST_TO_UNICAST

Avraham Stern (1):
      iwlwifi: mei: clear the sap data header before sending

Aya Levin (1):
      net/mlx5e: Allow relaxed ordering over VFs

Baochen Qiang (8):
      ath11k: enable PLATFORM_CAP_PCIE_GLOBAL_RESET QMI host capability
      ath11k: Remove unnecessary delay in ath11k_core_suspend
      ath11k: Add support for SAR
      ath11k: Don't use GFP_KERNEL in atomic context
      ath11k: Handle keepalive during WoWLAN suspend and resume
      ath11k: Implement remain-on-channel support
      ath11k: Don't check arvif->is_started before sending management frames
      ath11k: Designating channel frequency when sending management frames

Baowen Zheng (1):
      nfp: support 802.1ad VLAN assingment to VF

Benjamin Stürz (1):
      wcn36xx: Improve readability of wcn36xx_caps_name

Benjamin Tissoires (1):
      bpf: Allow kfunc in tracing and syscall programs.

Bernard Zhao (1):
      ethernet/ti: delete if NULL check befort devm_kfree

Bert Kenward (1):
      sfc: use hardware tx timestamps for more than PTP

Biju Das (1):
      dt-bindings: can: renesas,rcar-canfd: Document RZ/G2UL support

Bin Chen (2):
      rtnetlink: verify rate parameters for calls to ndo_set_vf_rate
      nfp: VF rate limit support

Bjorn Helgaas (2):
      net: wan: atp: remove unused eeprom_delay()
      net: remove comments that mention obsolete __SLOW_DOWN_IO

Björn Töpel (1):
      xsk: Improve xdp_do_redirect() error codes

Bo Jiao (2):
      mt76: mt7915: disable RX_HDR_TRANS_SHORT
      mt76: mt7615/mt7915: do reset_work with mt76's work queue

Boris Pismenny (1):
      tls: Add opt-in zerocopy mode of sendfile()

Boris Sukholitko (5):
      net/sched: flower: Helper function for vlan ethtype checks
      net/sched: flower: Reduce identation after is_key_vlan refactoring
      flow_dissector: Add number of vlan tags dissector
      net/sched: flower: Add number of vlan tags filter
      net/sched: flower: Consider the number of tags for vlan filters

Borislav Petkov (2):
      IB/mlx5: Fix undefined behavior due to shift overflowing the constant
      bnx2x: Fix undefined behavior due to shift overflowing the constant

Brian Gix (1):
      Bluetooth: Keep MGMT pending queue ordered FIFO

Carl Huang (6):
      ath11k: Add basic WoW functionalities
      ath11k: Add WoW net-detect functionality
      ath11k: implement hardware data filter
      ath11k: purge rx pktlog when entering WoW
      ath11k: support ARP and NS offload
      ath11k: support GTK rekey offload

Casper Andersson (1):
      net: sparx5: Add handling of host MDB entries

Chandrashekar Devegowda (1):
      net: wwan: t7xx: Add AT and MBIM WWAN ports

Chia-Yuan Li (5):
      rtw89: pci: refine pci pre_init function
      rtw89: ser: configure D-MAC interrupt mask
      rtw89: ser: configure C-MAC interrupt mask
      rtw89: 8852c: disable firmware watchdog if CPU disabled
      rtw89: 8852c: add 8852c specific BT-coexistence initial function

Chih-Kang Chang (3):
      rtw88: add HT MPDU density value for each chip
      rtw88: fix not disabling beacon filter after disconnection
      rtw88: fix hw scan may cause disconnect issue

Chin-Yen Lee (1):
      rtw88: adjust adaptivity option to 1

Ching-Te Ku (1):
      rtw89: coex: Add case for scan offload

Chris Chiu (2):
      rtl8xxxu: feed antenna information for cfg80211
      rtl8xxxu: fill up txrate info for gen1 chips

Chris Packham (3):
      dt-bindings: net: orion-mdio: Convert to JSON schema
      arm64: dts: armada-3720-turris-mox: Correct reg property for mdio devices
      dt-bindings: net: marvell,orion-mdio: Set unevaluatedProperties to false

Christophe JAILLET (4):
      mt76: mt7921: Fix the error handling path of mt7921_pci_probe()
      octeon_ep: Fix a memory leak in the error handling path of octep_request_irqs()
      octeon_ep: Fix irq releasing in the error handling path of octep_request_irqs()
      hinic: Avoid some over memory allocation

Christophe Leroy (4):
      orinoco: Prepare cleanup of powerpc's asm/prom.h
      can: mscan: mpc5xxx_can: Prepare cleanup of powerpc's asm/prom.h
      sungem: Prepare cleanup of powerpc's asm/prom.h
      net: ethernet: Prepare cleanup of powerpc's asm/prom.h

Coco Li (2):
      fou: Remove XRFM from NET_FOU Kconfig
      ipv6: Add hop-by-hop header to jumbograms in ip6_output

Colin Foster (4):
      net: mdio: mscc-miim: add local dev variable to cleanup probe function
      net: ethernet: ocelot: remove the need for num_stats initializer
      net: mscc: ocelot: remove unnecessary variable
      net: mscc: ocelot: add missed parentheses around macro argument

Colin Ian King (11):
      libbpf: Fix spelling mistake "libaries" -> "libraries"
      ath11k: Fix spelling mistake "reseting" -> "resetting"
      octeon_ep: Fix spelling mistake "inerrupts" -> "interrupts"
      myri10ge: remove redundant assignment to variable status
      net: hns3: Fix spelling mistake "actvie" -> "active"
      x25: remove redundant pointer dev
      ath11k: remove redundant assignment to variables vht_mcs and he_mcs
      net: ethernet: SP7021: Fix spelling mistake "Interrput" -> "Interrupt"
      mt76: mt7915: make read-only array ppet16_ppet8_ru3_ru0 static const
      mt76: mt7921: make read-only array ppet16_ppet8_ru3_ru0 static const
      selftests/bpf: Fix spelling mistake: "unpriviliged" -> "unprivileged"

Dan Carpenter (5):
      net: ethernet: mtk_eth_soc: use after free in __mtk_ppe_check_skb()
      ath9k_htc: fix potential out of bounds access with invalid rxstatus->rs_keyix
      net: ethernet: mtk_eth_soc: add check for allocation failure
      net: ethernet: SP7021: fix a use after free of skb->len
      net: ethernet: mtk_eth_soc: fix error code in mtk_flow_offload_replace()

Daniel Borkmann (1):
      Merge branch 'pr/bpf-sysctl' into bpf-next

Daniel Müller (1):
      selftests/bpf: Enable CONFIG_FPROBE for self tests

Daniele Palmas (1):
      net: usb: qmi_wwan: add Telit 0x1057 composition

Danielle Ratson (1):
      selftests: netdevsim: Increase sleep time in hw_stats_l3.sh test

David Ahern (1):
      net: Make msg_zerocopy_alloc static

David Bentham (1):
      net: ethernet: mtk_eth_soc: add ipv6 flow offload support

David Howells (12):
      rxrpc: Allow list of in-use local UDP endpoints to be viewed in /proc
      rxrpc: Use refcount_t rather than atomic_t
      rxrpc: Fix locking issue
      rxrpc: Automatically generate trace tag enums
      rxrpc: Return an error to sendmsg if call failed
      rxrpc, afs: Fix selection of abort codes
      afs: Adjust ACK interpretation to try and cope with NAT
      rxrpc: Fix listen() setting the bar too high for the prealloc rings
      rxrpc: Don't try to resend the request if we're receiving the reply
      rxrpc: Fix overlapping ACK accounting
      rxrpc: Don't let ack.previousPacket regress
      rxrpc: Fix decision on when to generate an IDLE ACK

David Ober (1):
      net: usb: r8152: Add in new Devices that are supported for Mac-Passthru

David S. Miller (80):
      Merge branch 'mscc-miim'
      Merge branch 'mtk_eth_soc-flo-offload-plus-wireless'
      Merge branch 'tls-rx-refactor-part-1'
      Merge branch 'bnxt-xdp-multi-buffer'
      Merge branch 'aspeed-mdio-c45'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/nex t-queue
      Merge branch 'net-sched-offload-failure-error-reporting'
      Merge branch 'tls-rx-refactoring-part-2'
      Merge branch 'icmp-skb-reason'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Merge branch 'mptcp-next'
      Merge branch 'tls-rx-refactor-part-3'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'net-ti-storm-prevention-support'
      Merge branch 'br-flush-filtering'
      Merge branch 'octeon_ep-driver'
      Merge branch 'ip-ingress-skb-reason'
      Merge branch 'mneta-page_pool_get_stats'
      Merge branch 'mlxsw-line-card-prep'
      Merge branch 'emaclite-cleanups'
      Merge branch 'qca8k_preiv-shrink'
      Merge branch 'tcp-drop-reason-additions'
      Merge branch 'mlxsw-line-card'
      Merge branch 'dsa-cross-chip-notifier-cleanup'
      Merge branch 'atlantic-xdp-multi-buffer'
      Merge branch 'hns3-next'
      Merge branch 'net-sched-flower-num-vlan-tags'
      Merge tag 'linux-can-next-for-5.19-20220419' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'mlxsw-line-card-status-tracking'
      Merge branch 'ipv6-only-sock'
      Merge branch 'zynqmp-phy-config-optional'
      Merge branch 'ipv6-RT_ONLINK-remove-prep'
      Merge branch 'mptcp-tcp-fallback'
      Merge branch 'dsa-selftests'
      Merge branch 'mlxsw-line-card-model'
      Merge branch 'mptcp-MP_FAIL-timeout'
      Merge branch 'lan966x-ptp-programmable-pins'
      Merge branch 'remove-virt_to_bus-drivers'
      Merge branch 'remove-NAPI_POLL_WEIGHT-copies'
      Merge branch 'ipv6-net-opts'
      Merge branch 'lan966x-phy-reset-remove'
      Merge branch 'UDP-sock_wfree-opts'
      Merge branch 'adin1100-industrial-PHY-support'
      Merge branch 'mptcp-pathmanager-api'
      Merge tag 'mlx5-updates-2022-05-03' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'sfc-Siena-subdir'
      Merge branch 'mlxsw-updates'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'nfp-flower-rework'
      Merge branch 'tso-gso-limit-split'
      Merge branch 'switch-drivers-to-netif_napi_add_weight'
      Merge branch 'mlxsw-dedicated-router-notification-block'
      Merge tag 'batadv-next-pullrequest-20220508' of git://git.open-mesh.org/linux-merge
      Merge branch 'wwan-t7xx'
      Merge branch 'vxlan_fdb_delete-extack'
      Merge branch 'add-ti-dp83td510-support'
      Merge branch 'lan8742-phy'
      Merge branch 'hns3-next'
      Merge tag 'mlx5-updates-2022-05-09' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'debug-net'
      Merge branch 'lan95xx-no-polling'
      Merge branch 'bnxt_en-next'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Merge branch 'Renesas-RSZ-V2M-support'
      Merge branch 'big-tcp'
      Merge branch 'sk_bound_dev_if-annotations'
      Merge branch 'skb-drop-reason-boundary'
      Merge branch 'net-skb-defer-freeing-polish'
      Merge tag 'mlx5-updates-2022-05-17' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'dsa-microchip-ksz_switch-refactor'
      Merge branch 'armada-3720-turris-mox-and-orion-mdio'
      Merge branch 'net-ipa-next'
      Merge branch 'ipa-next'
      Merge branch 'rxrpc-misc'
      Merge branch 'rxrpc-fixes'
      Merge branch 'ocelot-selftests'
      Merge branch 'dpaa2-swtso-fixes'
      Merge branch 'net-gcc12-warnings'
      Merge branch 'mt7986-support'
      Merge branch 'dsa-multi-cpu-port-part-two'

David Thompson (2):
      mlxbf_gige: increase MDIO polling rate to 5us
      mlxbf_gige: remove driver-managed interrupt counts

Deren Wu (2):
      mt76: fix antenna config missing in 6G cap
      mt76: mt7921: add ipv6 NS offload support

Dimitri John Ledkov (1):
      cfg80211: declare MODULE_FIRMWARE for regulatory.db

Dmitrii Dolgov (4):
      bpf: Add bpf_link iterator
      selftests/bpf: Fix result check for test_bpf_hash_map
      selftests/bpf: Use ASSERT_* instead of CHECK
      selftests/bpf: Add bpf link iter test

Dominique Martinet (2):
      bpftool, musl compat: Replace nftw with FTW_ACTIONRETVAL
      bpftool, musl compat: Replace sys/fcntl.h by fcntl.h

Dongliang Mu (1):
      rtlwifi: Use pr_warn instead of WARN_ONCE

Duoming Zhou (1):
      NFC: hci: fix sleep in atomic context bugs in nfc_hci_hcp_message_tx

Dylan Hung (3):
      dt-bindings: net: add reset property for aspeed, ast2600-mdio binding
      net: mdio: add reset control for Aspeed MDIO
      ARM: dts: aspeed: add reset properties into MDIO nodes

Dylan Muller (1):
      nfp: update nfp_X logging definitions

Edmond Gagnon (1):
      wcn36xx: Implement tx_rate reporting

Eli Cohen (3):
      net/mlx5: Lag, refactor lag state machine
      net/mlx5: Remove unused argument
      net/mlx5: Support multiport eswitch mode

Emmanuel Grumbach (2):
      iwlwifi: mvm: fix assert 1F04 upon reconfig
      iwlwifi: mvm: always tell the firmware to accept MCAST frames in BSS

Eric Dumazet (47):
      tcp: add accessors to read/set tp->snd_cwnd
      net_sched: make qdisc_reset() smaller
      ipv6: fix NULL deref in ip6_rcv_core()
      tcp: consume incoming skb leading to a reset
      tcp: get rid of rst_seq_match
      tcp: add drop reason support to tcp_validate_incoming()
      tcp: make tcp_rcv_state_process() drop monitor friendly
      tcp: add drop reasons to tcp_rcv_state_process()
      tcp: add two drop reasons for tcp_ack()
      tcp: add drop reason support to tcp_prune_ofo_queue()
      tcp: make tcp_rcv_synsent_state_process() drop monitor friend
      tcp: add drop reasons to tcp_rcv_synsent_state_process()
      tcp: add drop reason support to tcp_ofo_queue()
      tcp: fix signed/unsigned comparison
      net: generalize skb freeing deferral to per-cpu lists
      net: make sure net_rx_action() calls skb_defer_free_flush()
      tcp: drop skb dst in tcp_rcv_established()
      net: add include/net/net_debug.h
      net: add CONFIG_DEBUG_NET
      net: warn if transport header was not set
      net: remove two BUG() from skb_checksum_help()
      net: add more debug info in skb_checksum_help()
      inet: add READ_ONCE(sk->sk_bound_dev_if) in INET_MATCH()
      net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes
      net: limit GSO_MAX_SIZE to 524280 bytes
      tcp_cubic: make hystart_ack_delay() aware of BIG TCP
      ipv6: add struct hop_jumbo_hdr definition
      ipv6/gso: remove temporary HBH/jumbo header
      ipv6/gro: insert temporary HBH/jumbo header
      net: loopback: enable BIG TCP packets
      veth: enable BIG TCP packets
      mlx4: support BIG TCP packets
      mlx5: support BIG TCP packets
      net: annotate races around sk->sk_bound_dev_if
      sctp: read sk->sk_bound_dev_if once in sctp_rcv()
      tcp: sk->sk_bound_dev_if once in inet_request_bound_dev_if()
      net: core: add READ_ONCE/WRITE_ONCE annotations for sk->sk_bound_dev_if
      dccp: use READ_ONCE() to read sk->sk_bound_dev_if
      inet: add READ_ONCE(sk->sk_bound_dev_if) in inet_csk_bind_conflict()
      net_sched: em_meta: add READ_ONCE() in var_sk_bound_if()
      l2tp: use add READ_ONCE() to fetch sk->sk_bound_dev_if
      ipv6: add READ_ONCE(sk->sk_bound_dev_if) in INET6_MATCH()
      inet: rename INET_MATCH()
      net: fix possible race in skb_attempt_defer_free()
      net: use napi_consume_skb() in skb_defer_free_flush()
      net: add skb_defer_max sysctl
      net: call skb_defer_free_flush() before each napi_poll()

Erik Stromdahl (2):
      ath10k: add support for MSDU IDs for USB devices
      ath10k: enable napi on RX path for usb

Erin MacNeil (1):
      net: SO_RCVMARK socket option for SO_MARK with recvmsg()

Ethan Yang (1):
      net: usb: qmi_wwan: add support for Sierra Wireless EM7590

Evelyn Tsai (1):
      mt76: fix MBSS index condition in DBDC mode

Eyal Birger (2):
      selftests/bpf: Remove unused variable from bpf_sk_assign test
      net: align SO_RCVMARK required privileges with SO_MARK

Fabio Estevam (2):
      net: phy: micrel: Allow probing without .driver_data
      net: phy: micrel: Use the kszphy probe/suspend/resume

Fei Qin (1):
      nfp: support VxLAN inner TSO with GSO_PARTIAL offload

Felix Fietkau (27):
      net: ethernet: mtk_eth_soc: add support for coherent DMA
      arm64: dts: mediatek: mt7622: add support for coherent DMA
      net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)
      net: ethernet: mtk_eth_soc: implement flow offloading to WED devices
      arm64: dts: mediatek: mt7622: introduce nodes for Wireless Ethernet Dispatch
      net: ethernet: mtk_eth_soc: support TC_SETUP_BLOCK for PPE offload
      net: ethernet: mtk_eth_soc: allocate struct mtk_ppe separately
      net: ethernet: mtk_eth_soc: rework hardware flow table management
      net: ethernet: mtk_eth_soc: remove bridge flow offload type entry support
      net: ethernet: mtk_eth_soc: support creating mac address based offload entries
      net: ethernet: mtk_eth_soc/wed: fix sparse endian warnings
      mac80211: upgrade passive scan to active scan on DFS channels after beacon rx
      mt76: mt7915: fix DBDC default band selection on MT7915D
      mt76: mt7915: rework hardware/phy initialization
      mt76: reduce tx queue lock hold time
      mt76: dma: use kzalloc instead of devm_kzalloc for txwi
      mt76: mt7915: accept rx frames with non-standard VHT MCS10-11
      mt76: mt7921: accept rx frames with non-standard VHT MCS10-11
      mt76: fix use-after-free by removing a non-RCU wcid pointer
      mt76: fix rx reordering with non explicit / psmp ack policy
      mt76: do not attempt to reorder received 802.3 packets without agg session
      mt76: fix encap offload ethernet type check
      mt76: fix tx status related use-after-free race on station removal
      mt76: dma: add wrapper macro for accessing queue registers
      mt76: add support for overriding the device used for DMA mapping
      mt76: make number of tokens configurable dynamically
      mt76: mt7915: add Wireless Ethernet Dispatch support

Feng Zhou (3):
      bpf: add bpf_map_lookup_percpu_elem for percpu map
      selftests/bpf: add test case for bpf_map_lookup_percpu_elem
      selftests/bpf: Fix some bugs in map_lookup_percpu_elem testcase

Florent Fourcot (5):
      rtnetlink: return ENODEV when ifname does not exist and group is given
      rtnetlink: enable alt_ifname for setlink/newlink
      rtnetlink: return ENODEV when IFLA_ALT_IFNAME is used in dellink
      rtnetlink: return EINVAL when request cannot succeed
      Revert "rtnetlink: return EINVAL when request cannot succeed"

Florian Westphal (26):
      netfilter: ecache: move to separate structure
      netfilter: conntrack: split inner loop of list dumping to own function
      netfilter: cttimeout: inc/dec module refcount per object, not per use refcount
      selftests: netfilter: add fib expression forward test case
      mptcp: diag: switch to context structure
      mptcp: remove locking in mptcp_diag_fill_info
      mptcp: listen diag dump support
      selftests/mptcp: add diag listen tests
      mptcp: netlink: split mptcp_pm_parse_addr into two functions
      mptcp: netlink: allow userspace-driven subflow establishment
      netfilter: ecache: use dedicated list for event redelivery
      netfilter: conntrack: include ecache dying list in dumps
      netfilter: conntrack: remove the percpu dying list
      netfilter: cttimeout: decouple unlink and free on netns destruction
      netfilter: remove nf_ct_unconfirmed_destroy helper
      netfilter: extensions: introduce extension genid count
      netfilter: cttimeout: decouple unlink and free on netns destruction
      netfilter: conntrack: remove __nf_ct_unconfirmed_destroy
      netfilter: conntrack: remove unconfirmed list
      netfilter: conntrack: avoid unconditional local_bh_disable
      netfilter: nfnetlink: allow to detect if ctnetlink listeners exist
      netfilter: conntrack: un-inline nf_ct_ecache_ext_add
      netfilter: conntrack: add nf_conntrack_events autodetect mode
      netfilter: prefer extension check to pointer check
      netfilter: conntrack: remove pr_debug callsites from tcp tracker
      mptcp: sockopt: add TCP_DEFER_ACCEPT support

GONG, Ruiqi (1):
      net: mpls: fix memdup.cocci warning

Gal Pressman (4):
      net/mlx5e: Remove unused mlx5e_dcbnl_build_rep_netdev function
      net/mlx5e: IPoIB, Improve ethtool rxnfc callback structure in IPoIB
      net/mlx5e: Support partial GSO for tunnels over vlans
      net/mlx5e: Add XDP SQs to uplink representors steering tables

Gaosheng Cui (1):
      libbpf: Remove redundant non-null checks on obj_elf

Gavin Li (2):
      net/mlx5: Add exit route when waiting for FW
      net/mlx5: Increase FW pre-init timeout for health recovery

Geert Uytterhoeven (3):
      can: ctucanfd: Let users select instead of depend on CAN_CTUCANFD
      dt-bindings: can: renesas,rcar-canfd: Make interrupt-names required
      net: smc911x: Fix min() use in debug code

Geliang Tang (25):
      mptcp: add pm_nl_pernet helpers
      selftests/bpf: Drop duplicate max/min definitions
      mptcp: don't send RST for single subflow
      mptcp: add the fallback check
      mptcp: track and update contiguous data status
      mptcp: infinite mapping sending
      mptcp: infinite mapping receiving
      mptcp: add mib for infinite map sending
      mptcp: dump infinite_map field in mptcp_dump_mpext
      selftests: mptcp: add infinite map mibs check
      selftests: mptcp: add infinite map testcase
      mptcp: use mptcp_stop_timer
      mptcp: add data lock for sk timers
      mptcp: add MP_FAIL response support
      mptcp: reset subflow when MP_FAIL doesn't respond
      selftests: mptcp: check MP_FAIL response mibs
      selftests: mptcp: print extra msg in chk_csum_nr
      selftests: mptcp: fix a mp_fail test warning
      selftests: mptcp: add MP_FAIL reset testcase
      bpf: Add bpf_skc_to_mptcp_sock_proto
      selftests/bpf: Enable CONFIG_IKCONFIG_PROC in config
      selftests/bpf: Test bpf_skc_to_mptcp_sock
      selftests/bpf: Verify token of struct mptcp_sock
      selftests/bpf: Verify ca_name of struct mptcp_sock
      selftests/bpf: Verify first of struct mptcp_sock

Gerhard Engleder (6):
      ptp: Add cycles support for virtual clocks
      ptp: Request cycles for TX timestamp
      ptp: Pass hwtstamp to ptp_convert_timestamp()
      ptp: Support late timestamp determination
      ptp: Speed up vclock lookup
      tsnep: Add free running cycle counter support

Grant Seltzer (4):
      libbpf: Add error returns to two API functions
      libbpf: Update API functions usage to check error
      libbpf: Add documentation to API functions
      libbpf: Improve libbpf API documentation link position

Grygorii Strashko (4):
      net: ethernet: ti: cpsw: drop CPSW_HEADROOM define
      drivers: net: cpsw: ale: add broadcast/multicast rate limit support
      net: ethernet: ti: am65-cpsw: enable bc/mc storm prevention support
      net: ethernet: ti: cpsw_new: enable bc/mc storm prevention support

Guangbin Huang (2):
      net: hns3: add query vf ring and vector map relation
      net: hns3: fix incorrect type of argument in declaration of function hclge_comm_get_rss_indir_tbl

Guangguan Wang (3):
      net/smc: align the connect behaviour with TCP
      net/smc: send cdc msg inline if qp has sufficient inline space
      net/smc: rdma write inline if qp has sufficient inline space

Guillaume Nault (9):
      ipv4: Use dscp_t in struct fib_rt_info
      ipv4: Use dscp_t in struct fib_entry_notifier_info
      netdevsim: Use dscp_t in struct nsim_fib4_rt
      mlxsw: Use dscp_t in struct mlxsw_sp_fib4_entry
      net: marvell: prestera: Use dscp_t in struct prestera_kern_fib_cache
      ipv4: Don't reset ->flowi4_scope in ip_rt_fix_tos().
      ipv4: Avoid using RTO_ONLINK with ip_route_connect().
      ipv4: Initialise ->flowi4_scope properly in ICMP handlers.
      qed: Remove IP services API.

Guo Zhengkui (3):
      ipv6: exthdrs: use swap() instead of open coding it
      rtlwifi: btcoex: fix if == else warning
      net: smc911x: replace ternary operator with min()

Gustavo A. R. Silva (2):
      iwlwifi: fw: Replace zero-length arrays with flexible-array members
      iwlwifi: mei: Replace zero-length array with flexible-array member

H. Nikolaus Schaller (1):
      wl1251: dynamically allocate memory used for DMA

Haijun Liu (10):
      net: wwan: t7xx: Add control DMA interface
      net: wwan: t7xx: Add core components
      net: wwan: t7xx: Add port proxy infrastructure
      net: wwan: t7xx: Add control port
      net: wwan: t7xx: Data path HW layer
      net: wwan: t7xx: Add data path interface
      net: wwan: t7xx: Add WWAN network interface
      net: wwan: t7xx: Introduce power management
      net: wwan: t7xx: Runtime PM
      net: wwan: t7xx: Device deep sleep lock/unlock

Haim Dreyfuss (1):
      iwlwifi: mvm: use NULL instead of ERR_PTR when parsing wowlan status

Haiyang Zhang (1):
      hv_netvsc: Add support for XDP_REDIRECT

Haiyue Wang (1):
      bpf: Correct the comment for BTF kind bitfield

Hamid Zamani (1):
      brcmfmac: use ISO3166 country code and 0 rev as fallback on brcmfmac43602 chips

Hangbin Liu (3):
      net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO
      selftests/bpf: Add missed ima_setup.sh in Makefile
      bonding: fix missed rcu protection

Hangyu Hua (1):
      mac80211: tx: delete a redundant if statement in ieee80211_check_fast_xmit()

Hao Chen (4):
      net: hns3: refactor hns3_set_ringparam()
      net: hns3: add log for setting tx spare buf size
      net: hns3: remove unnecessary line wrap for hns3_set_tunable
      net: hns3: fix access null pointer issue when set tx-buf-size as 0

Haowen Bai (12):
      selftests/bpf: Return true/false (not 1/0) from bool functions
      b43legacy: Fix assigning negative value to unsigned variable
      b43: Fix assigning negative value to unsigned variable
      ipw2x00: Fix potential NULL dereference in libipw_xmit()
      libbpf: Potential NULL dereference in usdt_manager_attach_usdt()
      sfc: ef10: Fix assigning negative value to unsigned variable
      ar5523: Use kzalloc instead of kmalloc/memset
      net: eql: Use kzalloc instead of kmalloc/memset
      tsnep: Remove useless null check before call of_node_put()
      net: mscc: ocelot: Remove useless code
      net/mlx5: Remove useless kfree
      net: thunderx: remove null check after call container_of()

Hari Chandrakanthan (2):
      ath11k: change fw build id format in driver init log
      ath11k: disable spectral scan during spectral deinit

Harini Katakam (1):
      net: macb: Fix PTP one step sync support

Hongbin Wang (1):
      ip6_tunnel: Remove duplicate assignments

Horatiu Vultur (11):
      net: lan966x: Add registers that are used for FDMA.
      net: lan966x: Expose functions that are needed by FDMA
      net: lan966x: Add FDMA functionality
      net: lan966x: Update FDMA to change MTU.
      dt-bindings: net: lan966x: Extend with the ptp external interrupt.
      net: lan966x: Change the PTP pin used to read/write the PHC.
      net: lan966x: Add registers used to configure the PTP pin
      net: lan966x: Add support for PTP_PF_PEROUT
      net: lan966x: Add support for PTP_PF_EXTTS
      net: lan966x: Fix compilation error
      net: lan966x: Fix use of pointer after being freed

Hsuan Hung (1):
      rtw89: 8852c: add settings to decrease the effect of DC

Ian Wienand (1):
      net: ethernet: set default assignment identifier to NET_NAME_ENUM

Ido Schimmel (17):
      net/sched: matchall: Take verbose flag into account when logging error messages
      net/sched: flower: Take verbose flag into account when logging error messages
      net/sched: act_api: Add extack to offload_act_setup() callback
      net/sched: act_gact: Add extack messages for offload failure
      net/sched: act_mirred: Add extack message for offload failure
      net/sched: act_mpls: Add extack messages for offload failure
      net/sched: act_pedit: Add extack message for offload failure
      net/sched: act_police: Add extack messages for offload failure
      net/sched: act_skbedit: Add extack messages for offload failure
      net/sched: act_tunnel_key: Add extack message for offload failure
      net/sched: act_vlan: Add extack message for offload failure
      net/sched: cls_api: Add extack message for unsupported action offload
      net/sched: matchall: Avoid overwriting error messages
      net/sched: flower: Avoid overwriting error messages
      mlxsw: spectrum_acl: Do not report activity for multicast routes
      mlxsw: spectrum_switchdev: Only query FDB notifications when necessary
      mlxsw: spectrum_router: Only query neighbour activity when necessary

Ilya Leoshkevich (5):
      selftests/bpf: Define SYS_NANOSLEEP_KPROBE_NAME for aarch64
      libbpf: Support Debian in resolve_full_path()
      libbpf: Minor style improvements in USDT code
      libbpf: Make BPF-side of USDT support work on big-endian machines
      libbpf: Add s390-specific USDT arg spec parsing logic

Ioana Ciornei (3):
      dpaa2-eth: retrieve the virtual address before dma_unmap
      dpaa2-eth: use the correct software annotation field
      dpaa2-eth: unmap the SGT buffer before accessing its contents

Ismael Luceno (1):
      Bluetooth: btusb: Add 0x0bda:0x8771 Realtek 8761BUV devices

Jacob Keller (6):
      ice: add newline to dev_dbg in ice_vf_fdir_dump_info
      ice: always check VF VSI pointer values
      ice: remove return value comment for ice_reset_all_vfs
      ice: fix wording in comment for ice_reset_vf
      ice: add a function comment for ice_cfg_mac_antispoof
      ice: remove period on argument description in ice_for_each_vf

Jaehee Park (2):
      selftests: net: vrf_strict_mode_test: add support to select a test to run
      wfx: use container_of() to get vif

Jakob Koschel (3):
      bpf: Replace usage of supported with dedicated list iterator variable
      netfilter: nf_tables: replace unnecessary use of list_for_each_entry_continue()
      rtlwifi: replace usage of found with dedicated list iterator variable

Jakub Kicinski (180):
      net: wan: remove the lanmedia (lmc) driver
      net: hyperv: remove use of bpf_op_t
      net: unexport a handful of dev_* functions
      net: extract a few internals from netdevice.h
      Merge branch 'net-create-a-net-core-internal-header'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      tls: rx: jump to a more appropriate label
      tls: rx: drop pointless else after goto
      tls: rx: don't store the record type in socket context
      tls: rx: don't store the decryption status in socket context
      tls: rx: init decrypted status in tls_read_size()
      tls: rx: use a define for tag length
      tls: rx: replace 'back' with 'offset'
      tls: rx: don't issue wake ups when data is decrypted
      tls: rx: refactor decrypt_skb_update()
      tls: hw: rx: use return value of tls_device_decrypted() to carry status
      net: atm: remove the ambassador driver
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      tls: rx: drop unnecessary arguments from tls_setup_from_iter()
      tls: rx: don't report text length from the bowels of decrypt
      tls: rx: wrap decryption arguments in a structure
      tls: rx: simplify async wait
      tls: rx: factor out writing ContentType to cmsg
      tls: rx: don't handle async in tls_sw_advance_skb()
      tls: rx: don't track the async count
      tls: rx: pull most of zc check out of the loop
      tls: rx: inline consuming the skb at the end of the loop
      tls: rx: clear ctx->recv_pkt earlier
      tls: rx: jump out for cases which need to leave skb on list
      Merge branch 'ipv4-convert-several-tos-fields-to-dscp_t'
      Merge branch 'mlx5-next' of https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux
      Merge branch 'net-lan966x-add-support-for-fdma'
      Merge branch 'mlxsw-extend-device-registers-for-line-cards-support'
      tls: rx: consistently use unlocked accessors for rx_list
      tls: rx: reuse leave_on_list label for psock
      tls: rx: move counting TlsDecryptErrors for sync
      tls: rx: don't handle TLS 1.3 in the async crypto callback
      tls: rx: assume crypto always calls our callback
      tls: rx: treat process_rx_list() errors as transient
      tls: rx: return the already-copied data on crypto error
      tls: rx: use async as an in-out argument
      tls: rx: use MAX_IV_SIZE for allocations
      tls: rx: only copy IV from the packet for TLS 1.2
      Merge branch 'net-ethool-add-support-to-get-set-tx-push-by-ethtool-g-g'
      Merge branch 'ibmvnic-use-a-set-of-ltbs-per-pool'
      Merge branch 'add-ethtool-sqi-support-for-lan87xx-t1-phy'
      net: tls: fix async vs NIC crypto offload
      net: atm: remove support for Fujitsu FireStream ATM devices
      net: atm: remove support for Madge Horizon ATM devices
      net: atm: remove support for ZeitNet ZN122x ATM devices
      net: wan: remove support for COSA and SRP synchronous serial boards
      net: wan: remove support for Z85230-based devices
      net: hamradio: remove support for DMA SCC devices
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      eth: remove copies of the NAPI_POLL_WEIGHT define
      eth: smsc: remove a copy of the NAPI_POLL_WEIGHT define
      eth: cpsw: remove a copy of the NAPI_POLL_WEIGHT define
      eth: pch_gbe: remove a copy of the NAPI_POLL_WEIGHT define
      eth: mtk_eth_soc: remove a copy of the NAPI_POLL_WEIGHT define
      usb: lan78xx: remove a copy of the NAPI_POLL_WEIGHT define
      slic: remove a copy of the NAPI_POLL_WEIGHT define
      net: bgmac: remove a copy of the NAPI_POLL_WEIGHT define
      eth: atlantic: remove a copy of the NAPI_POLL_WEIGHT define
      eth: benet: remove a copy of the NAPI_POLL_WEIGHT define
      eth: gfar: remove a copy of the NAPI_POLL_WEIGHT define
      eth: vxge: remove a copy of the NAPI_POLL_WEIGHT define
      eth: spider: remove a copy of the NAPI_POLL_WEIGHT define
      eth: velocity: remove a copy of the NAPI_POLL_WEIGHT define
      qeth: remove a copy of the NAPI_POLL_WEIGHT define
      Merge branch 'net-phy-micrel-add-coma-mode-support'
      Merge branch 'mptcp-path-manager-mode-selection'
      Merge branch 'tcp-pass-back-data-left-in-socket-after-receive' of git://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux
      eth: remove remaining copies of the NAPI_POLL_WEIGHT define
      can: m_can: remove a copy of the NAPI_POLL_WEIGHT define
      rtnl: allocate more attr tables on the heap
      rtnl: split __rtnl_newlink() into two functions
      rtnl: move rtnl_newlink_create()
      ath10k: remove a copy of the NAPI_POLL_WEIGHT define
      wil6210: use NAPI_POLL_WEIGHT for napi budget
      rtw88: remove a copy of the NAPI_POLL_WEIGHT define
      Stefan Schmidt says:
      Merge branch 'ocelot-stats-improvement'
      Merge branch 'vsock-virtio-add-support-for-device-suspend-resume'
      Merge branch 'mptcp-userspace-path-manager-prerequisites'
      netdev: reshuffle netif_napi_add() APIs to allow dropping weight
      Merge tag 'wireless-next-2022-05-03' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge branch 'ocelot-vcap-cleanups'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Revert "Merge branch 'mlxsw-line-card-model'"
      jme: remove an unnecessary indirection
      net: switch to netif_napi_add_tx()
      net: move snowflake callers to netif_napi_add_tx_weight()
      Merge branch 'mptcp-improve-mptcp-level-window-tracking'
      wil6210: switch to netif_napi_add_tx()
      mt76: switch to netif_napi_add_tx()
      qtnfmac: switch to netif_napi_add_weight()
      net: add netif_inherit_tso_max()
      net: don't allow user space to lift the device limits
      net: make drivers set the TSO limit not the GSO limit
      net: move netif_set_gso_max helpers
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'simplify-migration-of-host-filtered-addresses-in-felix-driver'
      um: vector: switch to netif_napi_add_weight()
      caif_virtio: switch to netif_napi_add_weight()
      eth: switch to netif_napi_add_weight()
      r8152: switch to netif_napi_add_weight()
      net: virtio: switch to netif_napi_add_weight()
      net: wan: switch to netif_napi_add_weight()
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'nfp-support-corigine-pcie-vendor-id'
      eth: dpaa2-mac: remove a dead-code NULL check on fwnode parent
      Merge branch 'move-siena-into-a-separate-subdirectory'
      net: fix kdoc on __dev_queue_xmit()
      skbuff: add a basic intro doc
      skbuff: rewrite the doc for data-only skbs
      skbuff: render the checksum comment to documentation
      Merge branch 'docs-document-some-aspects-of-struct-sk_buff'
      Merge branch 'net-phy-add-comments-for-lan8742-phy-support'
      net: appletalk: remove Apple/Farallon LocalTalk PC support
      eth: amd: remove NI6510 support (ni65)
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'macb-napi-improvements'
      Merge branch 'count-tc-taprio-window-drops-in-enetc-driver'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      skbuff: replace a BUG_ON() with the new DEBUG_NET_WARN_ON_ONCE()
      net: update the register_netdevice() kdoc
      Merge branch 'dsa-changes-for-multiple-cpu-ports-part-1'
      Merge branch 'restructure-struct-ocelot_port'
      Merge branch 'make-sfc-siena-ko-specific-to-siena'
      Merge branch 'net-inet-retire-port-only-listening_hash'
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next
      eth: sfc: remove remnants of the out-of-tree napi_weight module param
      Merge branch 'mptcp-updates-for-net-next'
      Merge branch 'net-skb-remove-skb_data_area_size'
      Merge tag 'linux-can-next-for-5.19-20220516' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'net-smc-send-and-write-inline-optimization-for-smc'
      Merge branch 'adin-add-support-for-clock-output'
      Merge branch 'octeon_ep-fix-the-error-handling-path-of-octep_request_irqs'
      net/mlx5: fix multiple definitions of mlx5_lag_mpesw_init / mlx5_lag_mpesw_cleanup
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge tag 'wireless-next-2022-05-19' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      can: can-dev: move to netif_napi_add_weight()
      Merge tag 'linux-can-next-for-5.19-20220519' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      net: tls: fix messing up lists when bpf enabled
      Merge branch 'mtk_eth_soc-phylink-updates'
      Merge branch 'lantiq_gswip-two-small-fixes'
      net: wwan: iosm: remove pointless null check
      net: ipa: don't proceed to out-of-bound write
      docs: change the title of networking docs
      Merge branch 'mptcp-miscellaneous-fixes-and-a-new-test-case'
      eth: mtk_ppe: fix up after merge
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      tcp_ipv6: set the drop_reason in the right place
      net: stmmac: fix out-of-bounds access in a selftest
      net: avoid strange behavior with skb_defer_max == 1
      Merge branch 'amt-fix-several-bugs-in-gateway-mode'
      eth: bnxt: make ulp_id unsigned to make GCC 12 happy
      wwan: iosm: use a flexible array rather than allocate short objects
      Merge branch 'add-a-bhash2-table-hashed-by-port-address'
      net: wrap the wireless pointers in struct net_device in an ifdef
      eth: mtk_eth_soc: silence the GCC 12 array-bounds warning
      eth: ice: silence the GCC 12 array-bounds warning
      eth: tg3: silence the GCC 12 array-bounds warning
      wifi: plfxlc: remove redundant NULL-check for GCC 12
      wifi: ath9k: silence array-bounds warning on GCC 12
      wifi: rtlwifi: remove always-true condition pointed out by GCC 12
      wifi: ath6k: silence false positive -Wno-dangling-pointer warning on GCC 12
      wifi: iwlwifi: use unsigned to silence a GCC 12 warning
      wifi: brcmfmac: work around a GCC 12 -Warray-bounds warning
      wifi: carl9170: silence a GCC 12 -Warray-bounds warning
      Merge branch 'fix-silence-gcc-12-warnings-in-drivers-net-wireless'
      eth: de4x5: remove support for Generic DECchip & DIGITAL EtherWORKS PCI/EISA
      can: kvaser_usb: silence a GCC 12 -Warray-bounds warning
      Merge tag 'for-net-2022-05-23' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge tag 'for-net-next-2022-05-23' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
      Merge tag 'linux-can-next-for-5.19-20220523' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'ptp-ocp-various-updates'

Jason Wang (1):
      bpftool: Declare generator name

Jeff Daly (1):
      ixgbe: Fix module_param allow_unsupported_sfp type

Jeffrey Ji (1):
      net-core: rx_otherhost_dropped to core_stats

Jeremy Sowden (2):
      netfilter: bitwise: replace hard-coded size with `sizeof` expression
      netfilter: bitwise: improve error goto labels

Jerome Marchand (1):
      samples: bpf: Don't fail for a missing VMLINUX_BTF when VMLINUX_H is provided

Jian Shen (1):
      net: hns3: refine the definition for struct hclge_pf_to_vf_msg

Jiapeng Chong (7):
      bpf: Use swap() instead of open coding it
      plfxlc: Remove unused include <linux/version.h>
      can: ctucanfd: remove unused including <linux/version.h>
      can: ctucanfd: ctucan_platform_probe(): remove unnecessary print function dev_err()
      ROSE: Remove unused code and clean up some inconsistent indenting
      ssb: remove unreachable code
      net: ethernet: Use swap() instead of open coding it

Jie Wang (7):
      net: ethtool: extend ringparam set/get APIs for tx_push
      net: ethtool: move checks before rtnl_lock() in ethnl_set_rings
      net: hns3: add tx push support in hns3 ring param process
      net: hns3: add failure logs in hclge_set_vport_mtu
      net: hns3: add byte order conversion for PF to VF mailbox message
      net: hns3: add byte order conversion for VF to PF mailbox message
      net: page_pool: add page allocation stats for two fast page allocate path

Jimmy Hon (2):
      rtw88: 8821ce: add support for device ID 0xb821
      rtw88: 8821ce: Disable PCIe ASPM L1 for 8821CE using chip ID

Jiri Olsa (6):
      kallsyms: Make kallsyms_on_each_symbol generally available
      ftrace: Add ftrace_lookup_symbols function
      fprobe: Resolve symbols with ftrace_lookup_symbols
      bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link
      selftests/bpf: Add attach bench test
      libbpf: Add bpf_program__set_insns function

Jiri Pirko (30):
      devlink: add support to create line card and expose to user
      devlink: implement line card provisioning
      devlink: implement line card active state
      devlink: add port to line card relationship set
      mlxsw: spectrum: Allow lane to start from non-zero index
      mlxsw: spectrum: Allocate port mapping array of structs instead of pointers
      mlxsw: reg: Add Ports Mapping Event Configuration Register
      mlxsw: Narrow the critical section of devl_lock during ports creation/removal
      mlxsw: spectrum: Introduce port mapping change event processing
      mlxsw: reg: Add Management DownStream Device Query Register
      mlxsw: reg: Add Management DownStream Device Control Register
      mlxsw: reg: Add Management Binary Code Transfer Register
      mlxsw: core_linecards: Add line card objects and implement provisioning
      mlxsw: core_linecards: Implement line card activation process
      mlxsw: core: Extend driver ops by remove selected ports op
      mlxsw: spectrum: Add port to linecard mapping
      selftests: mlxsw: Introduce devlink line card provision/unprovision/activation tests
      mlxsw: core_linecards: Introduce ops for linecards status change tracking
      mlxsw: core_linecards: Fix size of array element during ini_files allocation
      devlink: introduce line card devices support
      devlink: introduce line card info get message
      devlink: introduce line card device info infrastructure
      mlxsw: reg: Extend MDDQ by device_info
      mlxsw: core_linecards: Probe provisioned line cards for devices and attach them
      selftests: mlxsw: Check devices on provisioned line card
      mlxsw: core_linecards: Expose HW revision and INI version
      selftests: mlxsw: Check line card info on provisioned line card
      mlxsw: reg: Extend MDDQ device_info by FW version fields
      mlxsw: core_linecards: Expose device FW version over device info
      selftests: mlxsw: Check device info on activated line card

Joachim Wiberg (4):
      net: bridge: add support for host l2 mdb entries
      selftests: forwarding: new test, verify host mdb entries
      selftests: forwarding: add TCPDUMP_EXTRA_FLAGS to lib.sh
      selftests: forwarding: multiple instances in tcpdump helper

Joanne Koong (9):
      bpf: Add MEM_UNINIT as a bpf_type_flag
      net: Add a second bind table hashed by port and address
      selftests: Add test for timing a bind request to a port with a populated bhash entry
      bpf: Add verifier support for dynptrs
      bpf: Add bpf_dynptr_from_mem for local dynptrs
      bpf: Dynptr support for ring buffers
      bpf: Add bpf_dynptr_read and bpf_dynptr_write
      bpf: Add dynptr data slices
      selftests/bpf: Dynptr tests

Joe Damato (3):
      i40e: Add support for MPLS + TSO
      ice: Add mpls+tso support
      i40e: Add tx_stopped stat

Joe Perches (1):
      rtw89: rtw89_ser: add const to struct state_ent and event_ent

Johannes Berg (21):
      net: ensure net_todo_list is processed quickly
      nl80211: show SSID for P2P_GO interfaces
      cfg80211: remove cfg80211_get_chan_state()
      nl80211: don't hold RTNL in color change request
      nl80211: rework internal_flags usage
      wil6210: remove 'freq' debugfs
      mac80211: unify CCMP/GCMP AAD construction
      mac80211: fix typo in documentation
      mac80211: remove stray multi_sta_back_32bit docs
      mac80211: mlme: move in RSSI reporting code
      mac80211: use ifmgd->bssid instead of ifmgd->associated->bssid
      mac80211: mlme: use local SSID copy
      mac80211: remove unused argument to ieee80211_sta_connection_lost()
      mac80211: remove useless bssid copy
      mac80211: mlme: track assoc_bss/associated separately
      cfg80211: fix kernel-doc for cfg80211_beacon_data
      mac80211: refactor freeing the next_beacon
      iwlwifi: pcie: simplify MSI-X cause mapping
      iwlwifi: mvm: clean up authorized condition
      iwlwifi: fw: init SAR GEO table only if data is present
      iwlwifi: mei: fix potential NULL-ptr deref

Johnson Lin (3):
      rtw89: packed IGI configuration flow into function for DIG feature
      rtw89: disabled IGI configuration for unsupported hardware
      rtw89: Skip useless dig gain and igi related settings for 8852C

Jonas Jelonek (2):
      mac80211: extend current rate control tx status API
      mac80211: minstrel_ht: support ieee80211_rate_status

Jonathan Lemon (8):
      ptp: ocp: 32-bit fixups for pci start address
      ptp: ocp: Remove #ifdefs around PCI IDs
      ptp: ocp: revise firmware display
      ptp: ocp: parameterize input/output sma selectors
      ptp: ocp: constify selectors
      ptp: ocp: vectorize the sma accessor functions
      ptp: ocp: add .init function for sma_op vector
      ptp: ocp: fix PPS source selector debugfs reporting

Jonathan Neuschäfer (1):
      net: calxedaxgmac: Fix typo (doubled "the")

Josua Mayer (3):
      dt-bindings: net: adin: document phy clock output properties
      net: phy: adin: add support for clock output
      ARM: dts: imx6qdl-sr-som: update phy configuration for som revision 1.9

Julia Lawall (12):
      ath6kl: fix typos in comments
      net: sparx5: switchdev: fix typo in comment
      net: mvpp2: fix typo in comment
      net/mlx5: fix typo in comment
      net: qed: fix typos in comments
      cirrus: cs89x0: fix typo in comment
      net: marvell: prestera: fix typo in comment
      nfp: flower: fix typo in comment
      qed: fix typos in comments
      libbpf: Fix typo in comment
      s390/bpf: Fix typo in comment
      can: peak_usb: fix typo in comment

Jérôme Pouiller (1):
      wfx: get out from the staging area

KP Singh (2):
      bpf: Fix usage of trace RCU in local storage.
      bpftool: bpf_link_get_from_fd support for LSM programs in lskel

Kaixi Fan (3):
      bpf: Add source ip in "struct bpf_tunnel_key"
      selftests/bpf: Move vxlan tunnel testcases to test_progs
      selftests/bpf: Replace bpf_trace_printk in tunnel kernel code

Kalesh AP (1):
      bnxt_en: parse and report result field when NVRAM package install fails

Kalle Valo (10):
      ath11k: mhi: remove state machine
      ath11k: mhi: add error handling for suspend and resume
      ath11k: mhi: remove unnecessary goto from ath11k_mhi_start()
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge branch 'wfx-move-out-of-staging'
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      ath11k: mac: fix too long line
      ath10k: mac: fix too long lines
      Merge tag 'mt76-for-kvalo-2022-05-12' of https://github.com/nbd168/wireless
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Karthikeyan Kathirvel (1):
      ath11k: Change max no of active probe SSID and BSSID to fw capability

Karthikeyan Periyasamy (2):
      ath11k: Refactor the peer delete
      ath11k: Add peer rhash table support

Kees Cook (1):
      fortify: Provide a memcpy trap door for sharp corners

Kevin Lo (1):
      rtw88: use the correct bit in the REG_HCI_OPT_CTRL register

Kevin Mitchell (1):
      netfilter: conntrack: skip verification of zero UDP checksum

Kishen Maloor (17):
      mptcp: bypass in-kernel PM restrictions for non-kernel PMs
      mptcp: store remote id from MP_JOIN SYN/ACK in local ctx
      mptcp: reflect remote port (not 0) in ANNOUNCED events
      mptcp: establish subflows from either end of connection
      mptcp: expose server_side attribute in MPTCP netlink events
      mptcp: allow ADD_ADDR reissuance by userspace PMs
      mptcp: handle local addrs announced by userspace PMs
      mptcp: read attributes of addr entries managed by userspace PMs
      mptcp: netlink: Add MPTCP_PM_CMD_ANNOUNCE
      selftests: mptcp: support MPTCP_PM_CMD_ANNOUNCE
      mptcp: netlink: Add MPTCP_PM_CMD_REMOVE
      selftests: mptcp: support MPTCP_PM_CMD_REMOVE
      selftests: mptcp: support MPTCP_PM_CMD_SUBFLOW_CREATE
      selftests: mptcp: support MPTCP_PM_CMD_SUBFLOW_DESTROY
      selftests: mptcp: capture netlink events
      selftests: mptcp: create listeners to receive MPJs
      selftests: mptcp: functional tests for the userspace PM type

Kris Bahnsen (1):
      can: Fix Links to Technologic Systems web resources

Kui-Feng Lee (5):
      bpf, x86: Generate trampolines from bpf_tramp_links
      bpf, x86: Create bpf_tramp_run_ctx on the caller thread's stack
      bpf, x86: Attach a cookie to fentry/fexit/fmod_ret/lsm.
      libbpf: Assign cookies to links in libbpf.
      selftest/bpf: The test cases of BPF cookie for fentry/fexit/fmod_ret/lsm.

Kumar Kartikeya Dwivedi (27):
      bpf: Do write access check for kfunc and global func
      bpf: Check PTR_TO_MEM | MEM_RDONLY in check_helper_mem_access
      bpf: Reject writes for PTR_TO_MAP_KEY in check_helper_mem_access
      selftests/bpf: Test passing rdonly mem to global func
      selftests/bpf: Test for writes to map key from BPF helpers
      bpf: Ensure type tags precede modifiers in BTF
      selftests/bpf: Add tests for type tag order validation
      bpf: Make btf_find_field more generic
      bpf: Move check_ptr_off_reg before check_map_access
      bpf: Allow storing unreferenced kptr in map
      bpf: Tag argument to be released in bpf_func_proto
      bpf: Allow storing referenced kptr in map
      bpf: Prevent escaping of kptr loaded from maps
      bpf: Adapt copy_map_value for multiple offset case
      bpf: Populate pairs of btf_id and destructor kfunc in btf
      bpf: Wire up freeing of referenced kptr
      bpf: Teach verifier about kptr_get kfunc helpers
      bpf: Make BTF type match stricter for release arguments
      libbpf: Add kptr type tag macros to bpf_helpers.h
      selftests/bpf: Add C tests for kptr
      selftests/bpf: Add verifier tests for kptr
      selftests/bpf: Add test for strict BTF type check
      bpf: Fix sparse warning for bpf_kptr_xchg_proto
      bpf: Prepare prog_test_struct kfuncs for runtime tests
      selftests/bpf: Add negative C tests for kptrs
      selftests/bpf: Add tests for kptr_ref refcounting
      bpf: Suppress 'passing zero to PTR_ERR' warning

Kuniyuki Iwashima (2):
      ipv6: Remove __ipv6_only_sock().
      ipv6: Use ipv6_only_sock() helper in condition.

Larysa Zaremba (1):
      bpftool: Use sysfs vmlinux when dumping BTF by ID

Lavanya Suresh (1):
      mac80211: disable BSS color collision detection in case of no free colors

Lech Perczak (3):
      cdc_ether: export usbnet_cdc_zte_rx_fixup
      rndis_host: enable the bogus MAC fixup for ZTE devices from cdc_ether
      rndis_host: limit scope of bogus MAC address detection to ZTE devices

Leon Romanovsky (48):
      net/mlx5_fpga: Drop INNOVA TLS support
      net/mlx5: Reliably return TLS device capabilities
      net/mlx5: Remove indirection in TLS build
      net/mlx5: Remove tls vs. ktls separation as it is the same
      net/mlx5: Cleanup kTLS function names and their exposure
      net/mlx5_fpga: Drop INNOVA IPsec support
      net/mlx5: Delete metadata handling logic
      net/mlx5: Remove not-used IDA field from IPsec struct
      net/mlx5: Remove XFRM no_trailer flag
      net/mlx5: Remove FPGA ipsec specific statistics
      RDMA/mlx5: Delete never supported IPsec flow action
      RDMA/mlx5: Drop crypto flow steering API
      RDMA/core: Delete IPsec flow action logic from the core
      net/mlx5: Remove ipsec vs. ipsec offload file separation
      net/mlx5: Remove useless IPsec device checks
      net/mlx5: Unify device IPsec capabilities check
      net/mlx5: Align flow steering allocation namespace to common style
      net/mlx5: Remove not-needed IPsec config
      net/mlx5: Move IPsec file to relevant directory
      net/mlx5: Reduce kconfig complexity while building crypto support
      net/mlx5: Remove ipsec_ops function table
      net/mlx5: Remove not-implemented IPsec capabilities
      octeon_ep: Remove custom driver version
      net/mlx5: Simplify IPsec flow steering init/cleanup functions
      net/mlx5: Check IPsec TX flow steering namespace in advance
      net/mlx5: Don't hide fallback to software IPsec in FS code
      net/mlx5: Reduce useless indirection in IPsec FS add/delete flows
      net/mlx5: Store IPsec ESN update work in XFRM state
      net/mlx5: Remove useless validity check
      net/mlx5: Merge various control path IPsec headers into one file
      net/mlx5: Remove indirections from esp functions
      net/mlx5: Simplify HW context interfaces by using SA entry
      net/mlx5: Clean IPsec FS add/delete rules
      net/mlx5: Make sure that no dangling IPsec FS pointers exist
      net/mlx5: Don't advertise IPsec netdev support for non-IPsec device
      net/mlx5: Simplify IPsec capabilities logic
      net/mlx5: Remove not-supported ICV length
      net/mlx5: Cleanup XFRM attributes struct
      net/mlx5: Don't perform lookup after already known sec_path
      net/mlx5: Allow future addition of IPsec object modifiers
      xfrm: free not used XFRM_ESP_NO_TRAILER flag
      xfrm: delete not used number of external headers
      xfrm: rename xfrm_state_offload struct to allow reuse
      xfrm: store and rely on direction to construct offload flags
      ixgbe: propagate XFRM offload state direction instead of flags
      netdevsim: rely on XFRM state direction instead of flags
      net/mlx5e: Use XFRM state direction instead of flags
      xfrm: drop not needed flags variable in XFRM offload struct

Leszek Polak (1):
      net: phy: marvell: Add errata section 5.1 for Alaska PHY

Lin Ma (1):
      NFC: NULL out the dev->rfkill to prevent UAF

Linus Walleij (1):
      Bluetooth: btbcm: Support per-board firmware variants

Liu Jian (4):
      bpf: Enlarge offset check value to INT_MAX in bpf_skb_{load,store}_bytes
      net: Change skb_ensure_writable()'s write_len param to unsigned int type
      selftests/bpf: Add test for skb_load_bytes
      bpf, sockmap: Call skb_linearize only when required in sk_psock_skb_ingress_enqueue

Lorenzo Bianconi (41):
      samples: bpf: Convert xdp_router_ipv4 to XDP samples helper
      dt-bindings: net: mediatek: add optional properties for the SoC ethernet core
      dt-bindings: arm: mediatek: document WED binding for MT7622
      dt-bindings: arm: mediatek: document the pcie mirror node on MT7622
      net: netfilter: Reports ct direction in CT lookup helpers for XDP and TC-BPF
      samples, bpf: Move routes monitor in xdp_router_ipv4 in a dedicated thread
      mac80211: protect ieee80211_assign_beacon with next_beacon check
      mac80211: introduce BSS color collision detection
      page_pool: Add recycle stats to page_pool_put_page_bulk
      net: ethernet: mtk_eth_soc: use standard property for cci-control-port
      net: page_pool: introduce ethtool stats
      net: mvneta: add support for page_pool_get_stats
      dt-bindings: net: mediatek,net: convert to the json-schema
      mt76: mt7921u: add suspend/resume support
      mt76: mt7921: rely on mt76_dev rxfilter in mt7921_configure_filter
      mt76: mt7921: honor pm user configuration in mt7921_sniffer_interface_iter
      mt76: mt7915: fix unbounded shift in mt7915_mcu_beacon_mbss
      mt76: mt7915: fix possible uninitialized pointer dereference in mt7986_wmac_gpio_setup
      mt76: mt7915: fix possible NULL pointer dereference in mt7915_mac_fill_rx_vector
      mt76: mt7915: do not pass data pointer to mt7915_mcu_muru_debug_set
      mt76: mt7915: report rx mode value in mt7915_mac_fill_rx_rate
      mt76: mt7915: use 0xff to initialize bitrate_mask in mt7915_init_bitrate_mask
      mt76: mt7915: configure soc clocks in mt7986_wmac_init
      mt76: add gfp to mt76_mcu_msg_alloc signature
      ixgbe: add xdp frags support to ndo_xdp_xmit
      arm64: dts: mediatek: mt7986: introduce ethernet nodes
      dt-bindings: net: mediatek,net: add mt7986-eth binding
      net: ethernet: mtk_eth_soc: rely on GFP_KERNEL for dma_alloc_coherent whenever possible
      net: ethernet: mtk_eth_soc: move tx dma desc configuration in mtk_tx_set_dma_desc
      net: ethernet: mtk_eth_soc: add txd_size to mtk_soc_data
      net: ethernet: mtk_eth_soc: rely on txd_size in mtk_tx_alloc/mtk_tx_clean
      net: ethernet: mtk_eth_soc: rely on txd_size in mtk_desc_to_tx_buf
      net: ethernet: mtk_eth_soc: rely on txd_size in txd_to_idx
      net: ethernet: mtk_eth_soc: add rxd_size to mtk_soc_data
      net: ethernet: mtk_eth_soc: rely on txd_size field in mtk_poll_tx/mtk_poll_rx
      net: ethernet: mtk_eth_soc: rely on rxd_size field in mtk_rx_alloc/mtk_rx_clean
      net: ethernet: mtk_eth_soc: introduce device register map
      net: ethernet: mtk_eth_soc: introduce MTK_NETSYS_V2 support
      net: ethernet: mtk_eth_soc: convert ring dma pointer to void
      net: ethernet: mtk_eth_soc: convert scratch_ring pointer to void
      net: ethernet: mtk_eth_soc: introduce support for mt7986 chipset

Louis Peens (10):
      nfp: flower: add infrastructure for pre_tun rework
      nfp: flower: add/remove predt_list entries
      nfp: flower: enforce more strict pre_tun checks
      nfp: flower: fixup ipv6/ipv4 route lookup for neigh events
      nfp: flower: update nfp_tun_neigh structs
      nfp: flower: rework tunnel neighbour configuration
      nfp: flower: link pre_tun flow rules with neigh entries
      nfp: flower: remove unused neighbour cache
      nfp: flower: enable decap_v2 bit
      nfp: flower: fix 'variable 'flow6' set but not used'

Lu Wei (2):
      net/mlxbf_gige: use eth_zero_addr() to clear mac address
      ax25: merge repeat codes in ax25_dev_device_down()

Luiz Angelo Daros de Luca (4):
      docs: net: dsa: describe issues with checksum offload
      dt-bindings: net: dsa: realtek: cleanup compatible strings
      net: dsa: realtek: remove realtek,rtl8367s string
      net: dsa: OF-ware slave_mii_bus

Luiz Augusto von Dentz (7):
      Bluetooth: HCI: Add HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN quirk
      Bluetooth: Print broken quirks
      Bluetooth: btusb: Set HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN for QCA
      Bluetooth: MGMT: Add conditions for setting HCI_CONN_FLAG_REMOTE_WAKEUP
      Bluetooth: hci_sync: Fix attempting to suspend with unfiltered passive scan
      Bluetooth: eir: Add helpers for managing service data
      Bluetooth: hci_conn: Fix hci_connect_le_sync

Lukas Bulwahn (1):
      MAINTAINERS: rectify entry for XILINX CAN DRIVER

Lukas Wunner (8):
      net: phy: Deduplicate interrupt disablement on PHY attach
      usbnet: Run unregister_netdev() before unbind() again
      usbnet: smsc95xx: Don't clear read-only PHY interrupt
      usbnet: smsc95xx: Don't reset PHY behind PHY driver's back
      usbnet: smsc95xx: Avoid link settings race on interrupt reception
      usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polling
      net: phy: smsc: Cache interrupt mask
      net: phy: smsc: Cope with hot-removal in interrupt handler

Lv Ruyi (5):
      bnx2x: Fix spelling mistake "regiser" -> "register"
      sfc: Fix spelling mistake "writting" -> "writing"
      rtlwifi: Fix spelling mistake "cacluated" -> "calculated"
      rtlwifi: rtl8192cu: Fix spelling mistake "writting" -> "writing"
      ixp4xx_eth: fix error check return value of platform_get_irq()

Maciej Fijalkowski (16):
      xsk: Diversify return codes in xsk_rcv_check()
      ice, xsk: Decorate ICE_XDP_REDIR with likely()
      ixgbe, xsk: Decorate IXGBE_XDP_REDIR with likely()
      ice, xsk: Terminate Rx side of NAPI when XSK Rx queue gets full
      i40e, xsk: Terminate Rx side of NAPI when XSK Rx queue gets full
      ixgbe, xsk: Terminate Rx side of NAPI when XSK Rx queue gets full
      ice, xsk: Diversify return values from xsk_wakeup call paths
      i40e, xsk: Diversify return values from xsk_wakeup call paths
      ixgbe, xsk: Diversify return values from xsk_wakeup call paths
      mlx5, xsk: Diversify return values from xsk_wakeup call paths
      stmmac, xsk: Diversify return values from xsk_wakeup call paths
      ice, xsk: Avoid refilling single Rx descriptors
      xsk: Drop ternary operator from xskq_cons_has_entries
      ixgbe, xsk: Get rid of redundant 'fallthrough'
      i40e, xsk: Get rid of redundant 'fallthrough'
      ice: introduce common helper for retrieving VSI by vsi_num

Magnus Karlsson (10):
      selftests: xsk: cleanup bash scripts
      selftests: xsk: do not send zero-length packets
      selftests: xsk: run all tests for busy-poll
      selftests: xsk: fix reporting of failed tests
      selftests: xsk: add timeout to tests
      selftests: xsk: cleanup veth pair at ctrl-c
      selftests: xsk: introduce validation functions
      selftests: xsk: make the stats tests normal tests
      selftests: xsk: make stat tests not spin on getsockopt
      MAINTAINERS: Add maintainer to AF_XDP

Manikanta Pubbisetty (19):
      ath11k: PCI changes to support WCN6750
      ath11k: Refactor PCI code to support WCN6750
      ath11k: Choose MSI config based on HW revision
      ath11k: Refactor MSI logic to support WCN6750
      ath11k: Remove core PCI references from PCI common code
      ath11k: Do not put HW in DBS mode for WCN6750
      ath11k: WMI changes to support WCN6750
      ath11k: Update WBM idle ring HP after FW mode on
      dt: bindings: net: add bindings of WCN6750 for ath11k
      ath11k: Move parameters in bus_params to hw_params
      ath11k: Add HW params for WCN6750
      ath11k: Add register access logic for WCN6750
      ath11k: Fetch device information via QMI for WCN6750
      ath11k: Add QMI changes for WCN6750
      ath11k: HAL changes to support WCN6750
      ath11k: Datapath changes to support WCN6750
      ath11k: Add support for WCN6750 device
      ath11k: Add support for targets without trustzone
      ath11k: Fix RX de-fragmentation issue on WCN6750

Marc Kleine-Budde (9):
      can: rx-offload: rename can_rx_offload_queue_sorted() -> can_rx_offload_queue_timestamp()
      can: bittiming: can_calc_bittiming(): prefer small bit rate pre-scalers over larger ones
      can: xilinx_can: mark bit timing constants as const
      dt-binding: can: mcp251xfd: add binding information for mcp251863
      can: mcp251xfd: add support for mcp251863
      can: raw: raw_sendmsg(): remove not needed setting of skb->sk
      can: raw: add support for SO_TXTIME/SCM_TXTIME
      dt-bindings: can: ctucanfd: include common CAN controller bindings
      can: ctucanfd: platform: add missing dependency to HAS_IOMEM

Marcel Ziswiler (1):
      net: stmmac: dwmac-imx: comment spelling fix

Marcin Szycik (1):
      Revert "ice: Hide bus-info in ethtool for PRs in switchdev mode"

Marcin Wojtas (1):
      net: dsa: remove unused headers

Marek Behún (1):
      net: dsa: mv88e6xxx: Cosmetic change spaces to tabs in dsa_switch_ops

Marek Vasut (1):
      net: phy: micrel: ksz9031/ksz9131: add cabletest support

Mark Bloch (22):
      net/mlx5e: TC, set proper dest type
      net/mlx5: fs, split software and IFC flow destination definitions
      net/mlx5: fs, refactor software deletion rule
      net/mlx5: fs, jump to exit point and don't fall through
      net/mlx5: fs, add unused destination type
      net/mlx5: fs, do proper bookkeeping for forward destinations
      net/mlx5: fs, delete the FTE when there are no rules attached to it
      net/mlx5: fs, call the deletion function of the node
      net/mlx5: fs, an FTE should have no dests when deleted
      net/mlx5: Lag, expose number of lag ports
      net/mlx5: devcom only supports 2 ports
      net/mlx5: Lag, move E-Switch prerequisite check into lag code
      net/mlx5: Lag, use lag lock
      net/mlx5: Lag, filter non compatible devices
      net/mlx5: Lag, store number of ports inside lag object
      net/mlx5: Lag, support single FDB only on 2 ports
      net/mlx5: Lag, use hash when in roce lag on 4 ports
      net/mlx5: Lag, use actual number of lag ports
      net/mlx5: Support devices with more than 2 ports
      net/mlx5: Lag, refactor dmesg print
      net/mlx5: Lag, use buckets in hash mode
      net/mlx5: Lag, add debugfs to query hardware lag state

Martin Blumenstingl (2):
      net: dsa: lantiq_gswip: Fix start index in gswip_port_fdb()
      net: dsa: lantiq_gswip: Fix typo in gswip_port_fdb_dump() error print

Martin Habets (23):
      sfc: efx_default_channel_type APIs can be static
      sfc: Remove duplicate definition of efx_xmit_done
      sfc: Remove global definition of efx_reset_type_names
      sfc: Disable Siena support
      sfc: Copy a subset of mcdi_pcol.h to siena
      sfc: Move Siena specific files
      sfc: Copy shared files needed for Siena (part 1)
      sfc: Copy shared files needed for Siena (part 2)
      sfc/siena: Remove build references to missing functionality
      sfc/siena: Rename functions in efx headers to avoid conflicts with sfc
      sfc/siena: Rename RX/TX functions to avoid conflicts with sfc
      sfc/siena: Rename peripheral functions to avoid conflicts with sfc
      sfc/siena: Rename functions in mcdi headers to avoid conflicts with sfc
      sfc/siena: Rename functions in nic_common.h to avoid conflicts with sfc
      sfc/siena: Inline functions in sriov.h to avoid conflicts with sfc
      sfc: Add a basic Siena module
      siena: Make MTD support specific for Siena
      siena: Make SRIOV support specific for Siena
      siena: Make HWMON support specific for Siena
      sfc/siena: Make MCDI logging support specific for Siena
      sfc/siena: Make PTP and reset support specific for Siena
      sfc/siena: Reinstate SRIOV init/fini function calls
      sfc/siena: Remove duplicate check on segments

Martin Jerabek (1):
      can: ctucanfd: add support for CTU CAN FD open-source IP core - bus independent part.

Martin KaFai Lau (4):
      net: inet: Remove count from inet_listen_hashbucket
      net: inet: Open code inet_hash2 and inet_unhash2
      net: inet: Retire port only listening_hash
      net: selftests: Stress reuseport listen

Martin Liška (1):
      eth: sun: cassini: remove dead code

Martin Willi (1):
      netfilter: Use l3mdev flow key when re-routing mangled packets

Mat Martineau (9):
      mptcp: Remove redundant assignments in path manager init
      mptcp: Add a member to mptcp_pm_data to track kernel vs userspace mode
      mptcp: Bypass kernel PM when userspace PM is enabled
      mptcp: Make kernel path manager check for userspace-managed sockets
      mptcp: Add a per-namespace sysctl to set the default path manager type
      selftests: mptcp: Add tests for userspace PM type
      selftests: mptcp: ADD_ADDR echo test with missing userspace daemon
      mptcp: Check for orphaned subflow before handling MP_FAIL timer
      mptcp: Do not traverse the subflow connection list without lock

Mateusz Palczewski (1):
      i40e: Add Ethernet Connection X722 for 10GbE SFP+ support

Max Chou (1):
      Bluetooth: btrtl: Add support for RTL8852C

Maxim Mikityanskiy (1):
      net/mlx5e: Drop error CQE handling from the XSK RX handler

MeiChia Chiu (1):
      mt76: mt7915: add support for 6G in-band discovery

Meng Tang (2):
      ath10k: Use of_device_get_match_data() helper
      ipw2x00: use DEVICE_ATTR_*() macro

Menglong Dong (18):
      net: sock: introduce sock_queue_rcv_skb_reason()
      net: skb: rename SKB_DROP_REASON_PTYPE_ABSENT
      net: icmp: introduce __ping_queue_rcv_skb() to report drop reasons
      net: icmp: add skb drop reasons to icmp protocol
      skb: add some helpers for skb drop reasons
      net: ipv4: add skb drop reasons to ip_error()
      net: ipv6: add skb drop reasons to ip6_pkt_drop()
      net: ip: add skb drop reasons to ip forwarding
      net: icmp: introduce function icmpv6_param_prob_reason()
      net: ipv6: remove redundant statistics in ipv6_hop_jumbo()
      net: ipv6: add skb drop reasons to TLV parse
      net: ipv6: add skb drop reasons to ip6_rcv_core()
      net: ipv6: add skb drop reasons to ip6_protocol_deliver_rcu()
      bpf: Compute map_btf_id during build time
      net: dm: check the boundary of skb drop reasons
      net: skb: check the boundrary of drop reason in kfree_skb_reason()
      net: skb: change the definition SKB_DR_SET()
      net: tcp: reset 'drop_reason' to NOT_SPCIFIED in tcp_v{4,6}_rcv()

Michael Chan (1):
      bnxt_en: Update firmware interface to 1.10.2.95

Michael Trimarchi (1):
      net: fec: Avoid allocating rx buffer using ATOMIC in ndo_open

Michael Walle (9):
      dt-bindings: net: convert mscc-miim to YAML format
      dt-bindings: net: mscc-miim: add clock and clock-frequency
      net: phy: mscc-miim: add support to set MDIO bus frequency
      dt-bindings: net: micrel: add coma-mode-gpios property
      net: phy: micrel: move the PHY timestamping check
      net: phy: micrel: add coma mode GPIO
      dt-bindings: net: lan966x: remove PHY reset
      net: lan966x: remove PHY reset support
      dt-bindings: net: lan966x: fix example

Michal Simek (1):
      net: emaclite: Update copyright text to correct format

Michal Swiatkowski (2):
      ice: get switch id on switchdev devices
      ice: link representors to PCI device

Milan Landaverde (5):
      bpftool: Add syscall prog type
      bpftool: Add missing link types
      bpftool: Handle libbpf_probe_prog_type errors
      bpftool: Adjust for error codes from libbpf probes
      bpftool: Output message if no helpers found in feature probing

Min Li (2):
      ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS support
      ptp: ptp_clockmatrix: return -EBUSY if phase pull-in is in progress

Minghao Chi (28):
      ath9k: Use platform_get_irq() to get the interrupt
      net: stmmac: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
      net/cadence: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
      wlcore: debugfs: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      net: ethernet: ti: cpsw: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
      net: ethernet: ti: am65-cpsw-nuss: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
      net: ethernet: ti: cpsw_new: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      net: stmmac: stmmac_main: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
      net: ethernet: ti: cpsw_priv: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
      net: ethernet: ti: davinci_emac: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
      can: flexcan: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
      drivers: net: davinci_mdio: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
      net: ethernet: ti: am65-cpsw-ethtool: use pm_runtime_resume_and_get
      wlcore: main: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wlcore: sysfs: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wlcore: testmode: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wlcore: vendor_cmd: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wlcore: sdio: using pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wlcore: cmd: using pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wil6210: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wl18xx: debugfs: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wl12xx: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wl12xx: scan: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      net/funeth: simplify the return expression of fun_dl_info_get()
      octeontx2-pf: Remove unnecessary synchronize_irq() before free_irq()
      qed: Remove unnecessary synchronize_irq() before free_irq()
      net: vxge: Remove unnecessary synchronize_irq() before free_irq()
      net: qede: Remove unnecessary synchronize_irq() before free_irq()

Miquel Raynal (15):
      net: ieee802154: ca8210: Fix lifs/sifs periods
      net: mac802154: Convert the symbol duration into nanoseconds
      net: mac802154: Set durations automatically
      net: ieee802154: Drop duration settings when the core does it already
      net: ieee802154: Enhance/fix the names of the MLME return codes
      net: ieee802154: Fill the list of MLME return codes
      net: mac802154: Save a global error code on transmissions
      net: mac802154: Create an offloaded transmission error helper
      net: mac802154: Create an error helper for asynchronous offloading errors
      net: ieee802154: at86rf230: Call _xmit_hw_error() when failing to offload frames
      net: ieee802154: at86rf230: Forward Tx trac errors
      net: ieee802154: atusb: Call _xmit_hw_error() upon transmission error
      net: ieee802154: ca8210: Use core return codes instead of hardcoding them
      net: ieee802154: ca8210: Call _xmit_error() when a transmission fails
      net: mac802154: Fix symbol durations

Miri Korenblit (1):
      iwlwifi: mvm: remove vif_count

Mordechay Goodstein (1):
      iwlwifi: mvm: add OTP info in case of init failure

Moshe Shemesh (1):
      net/mlx5: Add last command failure syndrome to debugfs

Moshe Tal (1):
      net/mlx5e: Correct the calculation of max channels for rep

Muhammad Usama Anjum (1):
      net: selftests: Add stress_reuseport_listen to .gitignore

Muna Sinada (2):
      cfg80211: support disabling EHT mode
      mac80211: support disabling EHT mode

Mykola Lysenko (6):
      selftests/bpf: Improve by-name subtest selection logic in prog_tests
      selftests/bpf: Refactor prog_tests logging and test execution
      bpf/selftests: Add granular subtest output for prog_test
      selftests/bpf: Fix two memory leaks in prog_tests
      selftests/bpf: Fix subtest number formatting in test_progs
      selftests/bpf: Remove filtered subtests from output

Nabil S. Alramli (1):
      i40e: Add vsi.tx_restart to i40e ethtool stats

Nagarajan Maran (1):
      ath11k: fix driver initialization failure with WoW unsupported hw

Nathan Chancellor (1):
      ath6kl: Use cc-disable-warning to disable -Wdangling-pointer

Nathan Rossi (1):
      net: dsa: mv88e6xxx: Single chip mode detection for MV88E6*41

Nick Desaulniers (1):
      net, uapi: remove inclusion of arpa/inet.h

Nicolas Rybowski (1):
      selftests/bpf: Add MPTCP test base

Niels Dossche (7):
      ath11k: acquire ab->base_lock in unassign when finding the peer by addr
      mwifiex: add mutex lock for call in mwifiex_dfs_chan_sw_work_queue
      ipv6: fix locking issues with loops over idev->addr_list
      octeontx2-af: debugfs: fix error return of allocations
      Bluetooth: use hdev lock in activate_scan for hci_is_adv_monitoring
      Bluetooth: use hdev lock for accept_list and reject_list in conn req
      Bluetooth: protect le accept and resolv lists with hdev->lock

Nikolay Aleksandrov (12):
      net: rtnetlink: add msg kind names
      net: rtnetlink: add helper to extract msg type's kind
      net: rtnetlink: use BIT for flag values
      net: netlink: add NLM_F_BULK delete request modifier
      net: rtnetlink: add bulk delete support flag
      net: add ndo_fdb_del_bulk
      net: rtnetlink: add NLM_F_BULK support to rtnl_fdb_del
      net: bridge: fdb: add ndo_fdb_del_bulk
      net: bridge: fdb: add support for fine-grained flushing
      net: rtnetlink: add ndm flags and state mask attributes
      net: bridge: fdb: add support for flush filtering based on ndm flags and state
      net: bridge: fdb: add support for flush filtering based on ifindex and vlan

Nikolay Borisov (1):
      selftests/bpf: Fix vfs_link kprobe definition

Nobuhiro Iwamatsu (1):
      dt-bindings: net: toshiba,visconti-dwmac: Update the common clock properties

Oleksij Rempel (7):
      net: phy: genphy_c45_baset1_an_config_aneg: do no set unknown configuration
      net: phy: introduce genphy_c45_pma_baset1_setup_master_slave()
      net: phy: genphy_c45_pma_baset1_setup_master_slave: do no set unknown configuration
      net: phy: introduce genphy_c45_pma_baset1_read_master_slave()
      net: phy: genphy_c45_pma_baset1_read_master_slave: read actual configuration
      net: phy: export genphy_c45_baset1_read_status()
      net: phy: dp83td510: Add support for the DP83TD510 Ethernet PHY

Oliver Hartkopp (6):
      net: remove noblock parameter from skb_recv_datagram()
      net: remove noblock parameter from recvmsg() entities
      can: isotp: add support for transmission without flow control
      can: isotp: isotp_bind(): return -EINVAL on incorrect CAN ID formatting
      can: isotp: isotp_bind(): do not validate unused address information
      can: can-dev: remove obsolete CAN LED support

Pablo Neira Ayuso (2):
      netfilter: nft_fib: reverse path filter for policy-based routing on iif
      netfilter: conntrack: add nf_ct_iter_data object for nf_ct_iterate_cleanup*()

Paolo Abeni (30):
      mptcp: optimize release_cb for the common case
      mptcp: reset the packet scheduler on incoming MP_PRIO
      mptcp: reset the packet scheduler on PRIO change
      Merge branch 'net-bridge-add-support-for-host-l2-mdb-entries'
      Merge branch 'net-dsa-mt7530-updates-for-phylink-changes'
      Merge branch 'sfc-remove-some-global-definitions'
      Merge branch 'rndis_host-handle-bogus-mac-addresses-in-zte-rndis-devices'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      geneve: avoid indirect calls in GRO path, when possible
      Merge branch 'net-sched-allow-user-to-select-txqueue'
      Merge branch 'rtnetlink-improve-alt_ifname-config-and-fix-dangerous-group-usage'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'add-reset-deassertion-for-aspeed-mdio'
      Merge branch 'devices-always-netif_f_lltx'
      Merge tag 'linux-can-next-for-5.19-20220502' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'use-mmd-c45-helpers'
      Merge branch 'net-more-heap-allocation-and-split-of-rtnl_newlink'
      Merge branch 'use-standard-sysctl-macro'
      Merge branch 'mlxsw-remove-size-limitations-on-egress-descriptor-buffer'
      Merge tag 'mlx5-updates-2022-05-02' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      mptcp: really share subflow snd_wnd
      mptcp: add mib for xmit window sharing
      tcp: allow MPTCP to update the announced window
      mptcp: never shrink offered window
      mptcp: add more offered MIBs counter
      Merge branch 'ptp-support-hardware-clocks-with-additional-free-running-cycle-counter'
      Merge branch 'this-is-a-patch-series-for-ethernet-driver-of-sunplus-sp7021-soc'
      Merge branch 'nfp-vf-rate-limit-support'
      Revert "mptcp: add data lock for sk timers"
      mptcp: stop using the mptcp_has_another_subflow() helper

Pavan Chebbi (2):
      bnxt_en: Configure ptp filters during bnxt open
      bnxt_en: Enable packet timestamping for all RX packets

Pavel Begunkov (9):
      net: inline sock_alloc_send_skb
      net: inline skb_zerocopy_iter_dgram
      net: inline dev_queue_xmit()
      ipv6: help __ip6_finish_output() inlining
      ipv6: refactor ip6_finish_output2()
      sock: dedup sock_def_write_space wmem_alloc checks
      sock: optimise UDP sock_wfree() refcounting
      sock: optimise sock_def_write_space barriers
      tcp: optimise skb_zerocopy_iter_stream()

Pavel Löbl (1):
      brcmfmac: allow setting wlan MAC address using device tree

Pavel Pisa (11):
      dt-bindings: vendor-prefix: add prefix for the Czech Technical University in Prague.
      dt-bindings: net: can: binding for CTU CAN FD open-source IP core.
      can: ctucanfd: CTU CAN FD open-source IP core - PCI bus support.
      can: ctucanfd: CTU CAN FD open-source IP core - platform/SoC support.
      docs: ctucanfd: CTU CAN FD open-source IP core documentation.
      MAINTAINERS: Add maintainers for CTU CAN FD IP core driver
      docs: networking: device drivers: can: add ctucanfd to index
      docs: networking: device drivers: can: ctucanfd: update author e-mail
      can: ctucanfd: remove inline keyword from local static functions
      can: ctucanfd: remove debug statements
      can: ctucanfd: remove PCI module debug parameters

Peilin Ye (2):
      ip_gre: Make GRE and GRETAP devices always NETIF_F_LLTX
      ip6_gre: Make IP6GRE and IP6GRETAP devices always NETIF_F_LLTX

Peng Li (3):
      net: hns3: update the comment of function hclgevf_get_mbx_resp
      net: hns3: fix the wrong words in comments
      net: hns3: replace magic value by HCLGE_RING_REG_OFFSET

Pengcheng Yang (1):
      tcp: use tcp_skb_sent_after() instead in RACK

Peter Chiu (4):
      mt76: mt7915: update mt7986 patch in mt7986_wmac_adie_patch_7976()
      mt76: mt7915: fix twt table_mask to u16 in mt7915_dev
      mt76: mt7915: reject duplicated twt flows
      mt76: mt7915: limit minimum twt duration

Peter Seiderer (3):
      mac80211: minstrel_ht: fix where rate stats are stored (fixes debugfs output)
      ath9k: fix ath_get_rate_txpower() to respect the rate list end tag
      mac80211: minstrel_ht: fill all requested rates

Petr Machata (19):
      mlxsw: reg: Add "desc" field to SBPR
      mlxsw: Configure descriptor buffers
      selftests: forwarding: lib: Add start_traffic_pktsize() helpers
      selftests: mlxsw: Add a test for soaking up a burst of traffic
      selftests: mlxsw: bail_on_lldpad before installing the cleanup trap
      selftests: router_vid_1: Add a diagram, fix coding style
      selftests: router.sh: Add a diagram
      mlxsw: spectrum_dcb: Do not warn about priority changes
      mlxsw: Treat LLDP packets as control
      mlxsw: spectrum: Tolerate enslaving of various devices to VRF
      mlxsw: spectrum_router: Add a dedicated notifier block
      mlxsw: spectrum: Move handling of VRF events to router code
      mlxsw: spectrum: Move handling of HW stats events to router code
      mlxsw: spectrum: Move handling of router events to router code
      mlxsw: spectrum: Move handling of tunnel events to router code
      mlxsw: spectrum: Update a comment
      mlxsw: spectrum_router: Take router lock in router notifier handler
      selftests: lib: Add a generic helper for obtaining HW stats
      selftests: forwarding: Add a tunnel-based test for L3 HW stats

Phil Edworthy (5):
      dt-bindings: net: renesas,etheravb: Document RZ/V2M SoC
      ravb: Separate handling of irq enable/disable regs into feature
      ravb: Support separate Line0 (Desc), Line1 (Err) and Line2 (Mgmt) irqs
      ravb: Use separate clock for gPTP
      ravb: Add support for RZ/V2M

Phil Sutter (3):
      netfilter: nf_log_syslog: Merge MAC header dumpers
      netfilter: nf_log_syslog: Don't ignore unknown protocols
      netfilter: nf_log_syslog: Consolidate entry checks

Pieter Jansen van Vuuren (1):
      sfc: add EF100 VF support via a write to sriov_numvfs

Ping Gan (1):
      tcp: Add tracepoint for tcp_set_ca_state

Ping-Ke Shih (79):
      rtw89: reduce export symbol number of mac size and quota
      rtw89: add chip_info::h2c_desc_size/fill_txdesc_fwcmd to support new chips
      rtw89: pci: support variant of fill_txaddr_info
      rtw89: support variant of fill_txdesc
      rtw89: support hardware generate security header
      rtw89: read RX bandwidth from v1 type RX descriptor
      rtw89: handle potential uninitialized variable
      rtw89: pci: add register definition to rtw89_pci_info to generalize pci code
      rtw89: pci: add pci attributes to configure operating mode
      rtw89: pci: add LTR setting for v1 chip
      rtw89: pci: set address info registers depends on chips
      rtw89: pci: add deglitch setting
      rtw89: pci: add L1 settings
      rtw89: extend dmac_pre_init to support 8852C
      rtw89: update STA scheduler parameters for v1 chip
      rtw89: add chip_ops::{enable,disable}_bb_rf to support v1 chip
      rtw89: Turn on CR protection of CMAC
      rtw89: 8852c: update security engine setting
      rtw89: update scheduler setting
      rtw89: initialize NAV control
      rtw89: update TMAC parameters
      rtw89: update ptcl_init
      rtw89: ser: configure top ERR IMR for firmware to recover
      rtw89: change station scheduler setting for hardware TX mode
      rtw89: reset BA CAM
      rtw88: do PHY calibration while starting AP
      rtw89: extend H2C of CMAC control info
      rtw89: add new H2C to configure security CAM via DCTL for V1 chip
      rtw89: configure security CAM for V1 chip
      rtw89: pci: correct return value handling of rtw89_write16_mdio_mask()
      rtw89: 8852c: add BB and RF parameters tables
      rtw89: 8852c: add TX power by rate and limit tables
      rtw89: 8852c: phy: configure TSSI bandedge
      rtw89: 8852c: add BB initial and reset functions
      rtw89: 8852c: add efuse gain offset parser
      rtw89: 8852c: add HFC parameters
      rtw89: 8852c: add set channel function of RF part
      rtw89: 8852c: set channel of MAC part
      rtw89: 8852c: add set channel of BB part
      rtw89: 8852c: add help function of set channel
      rtw89: pci: add variant IMR/ISR and configure functions
      rtw89: pci: add variant RPWM/CPWM to enter low power mode
      rtw89: pci: reclaim TX BD only if it really need
      rtw89: pci: add a separate interrupt handler for low power mode
      rtw89: ser: re-enable interrupt in threadfn if under_recovery
      rtw89: ps: access TX/RX rings via another registers in low power mode
      rtw89: pci: allow to process RPP prior to TX BD
      rtw89: don't flush hci queues and send h2c if power is off
      rtw89: add RF H2C to notify firmware
      rtw89: 8852c: configure default BB TX/RX path
      rtw89: 8852c: implement chip_ops related to TX power
      rtw89: 8852c: implement chip_ops::get_thermal
      rtw89: 8852c: fill freq and band of RX status by PPDU report
      rtw89: 8852c: add chip_ops related to BTC
      rtw89: 8852c: rfk: add RFK tables
      rtw89: 8852c: rfk: add DACK
      rtw89: 8852c: rfk: add LCK
      rtw89: 8852c: rfk: add TSSI
      rtw89: 8852c: rfk: add RCK
      rtw89: 8852c: rfk: add RX DCK
      rtw89: 8852c: rfk: add IQK
      rtw89: 8852c: rfk: add DPK
      rtw89: 8852c: rfk: get calibrated channels to notify firmware
      rtw89: 8852c: add chip_ops::bb_ctrl_btc_preagc
      rtw89: 8852c: add basic and remaining chip_info
      rtw89: ps: fine tune polling interval while changing low power mode
      rtw89: correct AID settings of beamformee
      rtw89: 8852c: correct register definitions used by 8852c
      rtw89: 8852c: fix warning of FIELD_PREP() mask type
      rtw89: 8852c: add 8852ce to Makefile and Kconfig
      mac80211: consider Order bit to fill CCMP AAD
      rtw89: correct setting of RX MPDU length
      rtw89: correct CCA control
      rtw89: add debug select to dump MAC pages 0x30 to 0x33
      rtw89: add debug entry to dump BSSID CAM
      rtw89: add ieee80211::sta_rc_update ops
      rtw89: 8852c: set TX antenna path
      rtw89: cfo: check mac_id to avoid out-of-bounds
      rtw89: pci: only mask out INT indicator register for disable interrupt v1

Po Hao Huang (3):
      rtw89: change idle mode condition during hw_scan
      rtw89: packet offload handler to avoid warning
      rtw89: fix misconfiguration on hw_scan channel time

Po Liu (1):
      net: enetc: count the tc-taprio window drops

Po-Hao Huang (8):
      rtw88: change idle mode condition during hw_scan
      rtw88: add ieee80211:sta_rc_update ops
      rtw88: fix incorrect frequency reported
      rtw88: Add update beacon flow for AP mode
      rtw88: 8821c: Enable TX report for management frames
      rtw88: 8821c: fix debugfs rssi value
      rtw88: fix uninitialized 'tim_offset' warning
      rtw88: pci: 8821c: Disable 21ce completion timeout

Potin Lai (3):
      net: mdio: aspeed: move reg accessing part into separate functions
      net: mdio: aspeed: Introduce read write function for c22 and c45
      net: mdio: aspeed: Add c45 support

Prabhakar Kushwaha (1):
      qede: Reduce verbosity of ptp tx timestamp

Prasanna Vengateshan (1):
      net: dsa: move mib->cnt_ptr reset code to ksz_common.c

Pu Lehui (3):
      riscv, bpf: Implement more atomic operations for RV64
      libbpf: Fix usdt_cookie being cast to 32 bits
      libbpf: Support riscv USDT argument parsing logic

Quentin Monnet (1):
      selftests/bpf: Fix parsing of prog types in UAPI hdr for bpftool sync

Radhey Shyam Pandey (3):
      net: emaclite: Fix coding style
      dt-bindings: net: cdns,macb: Drop phy-names property for ZynqMP SGMII PHY
      net: macb: In ZynqMP initialization make SGMII phy configuration optional

Rameshkumar Sundaram (1):
      nl80211: Parse NL80211_ATTR_HE_BSS_COLOR as a part of nl80211_parse_beacon

Randy Dunlap (1):
      net: dsa: restrict SMSC_LAN9303_I2C kconfig

Ren Zhijie (1):
      sfc: siena: Fix Kconfig dependencies

Ricardo Martinez (6):
      list: Add list_next_entry_circular() and list_prev_entry_circular()
      net: skb: introduce skb_data_area_size()
      net: wwan: t7xx: Add maintainers and documentation
      net: wwan: t7xx: Avoid calls to skb_data_area_size()
      net: skb: Remove skb_data_area_size()
      net: wwan: t7xx: Fix smatch errors

Rikard Falkeborn (1):
      Bluetooth: btintel: Constify static struct regmap_bus

Robert Hancock (5):
      net: phy: marvell: update abilities and advertising when switching to SGMII
      net: macb: simplify/cleanup NAPI reschedule checking
      net: macb: use NAPI for TX completion path
      net: axienet: Be more careful about updating tx_bd_tail
      net: axienet: Use NAPI for TX completion path

Robert Marko (1):
      ath10k: support bus and device specific API 1 BDF selection

Robin Murphy (1):
      sfc: Stop using iommu_present()

Rolf Eike Beer (2):
      net: tulip: convert to devres
      net: tulip: fix build with CONFIG_GSC

Runqing Yang (1):
      libbpf: Fix a bug with checking bpf_probe_read_kernel() support in old kernels

Russell King (1):
      net: mtk_eth_soc: correct 802.3z duplex setting

Russell King (Oracle) (22):
      net: dsa: mt7530: 1G can also support 1000BASE-X link mode
      net: dsa: mt7530: populate supported_interfaces and mac_capabilities
      net: dsa: mt7530: remove interface checks
      net: dsa: mt7530: drop use of phylink_helper_basex_speed()
      net: dsa: mt7530: only indicate linkmodes that can be supported
      net: dsa: mt7530: switch to use phylink_get_linkmodes()
      net: dsa: mt7530: partially convert to phylink_pcs
      net: dsa: mt7530: move autoneg handling to PCS validation
      net: dsa: mt7530: mark as non-legacy
      net: phylink: remove phylink_helper_basex_speed()
      net: dsa: mt753x: fix pcs conversion regression
      net: mtk_eth_soc: remove unused mac->mode
      net: mtk_eth_soc: remove unused sgmii flags
      net: mtk_eth_soc: add mask and update PCS speed definitions
      net: mtk_eth_soc: correct 802.3z speed setting
      net: mtk_eth_soc: stop passing phylink state to sgmii setup
      net: mtk_eth_soc: provide mtk_sgmii_config()
      net: mtk_eth_soc: add fixme comment for state->speed use
      net: mtk_eth_soc: move MAC_MCR setting to mac_finish()
      net: mtk_eth_soc: move restoration of SYSCFG0 to mac_finish()
      net: mtk_eth_soc: convert code structure to suit split PCS support
      net: mtk_eth_soc: partially convert to phylink_pcs

Ryder Lee (7):
      mt76: mt7915: always call mt7915_wfsys_reset() during init
      mt76: mt7915: remove SCS feature
      mt76: mt7915: rework SER debugfs knob
      mt76: mt7915: introduce mt7915_mac_severe_check()
      mt76: mt7915: move MT_INT_MASK_CSR to init.c
      mt76: mt7915: improve error handling for fw_debug knobs
      mt76: mt7915: add more statistics from fw_util debugfs knobs

Saeed Mahameed (3):
      net/mlx5: sparse: error: context imbalance in 'mlx5_vf_get_core_dev'
      net/mlx5e: CT: Add ct driver counters
      sfc: siena: Have a unique wrapper ifndef for efx channels header

Sasha Neftin (3):
      igc: Remove igc_set_spd_dplx method
      igc: Remove unused phy_type enum
      igc: Change type of the 'igc_check_downshift' method

Sean Wang (8):
      mt76: mt7921: Add AP mode support
      mt76: mt7921: fix kernel crash at mt7921_pci_remove
      mt76: connac: use skb_put_data instead of open coding
      Bluetooth: mt7921s: Fix the incorrect pointer check
      Bluetooth: btusb: Add a new PID/VID 0489/e0c8 for MT7921
      Bluetooth: btmtksdio: fix use-after-free at btmtksdio_recv_event
      Bluetooth: btmtksdio: fix possible FW initialization failure
      Bluetooth: btmtksdio: fix the reset takes too long

Shay Drory (2):
      net/mlx5: Delete redundant default assignment of runtime devlink params
      net/mlx5: Print initializing field in case of timeout

Shayne Chen (1):
      mt76: mt7915: add debugfs knob for RF registers read/write

Shravya Kumbham (1):
      net: emaclite: Remove custom BUFFER_ALIGN macro

Simon Wunderlich (1):
      batman-adv: Start new development cycle

Song Chen (1):
      sample: bpf: syscall_tp_user: Print result of verify_map

Song Liu (3):
      bpf: Fill new bpf_prog_pack with illegal instructions
      x86/alternative: Introduce text_poke_set
      bpf: Introduce bpf_arch_text_invalidate for bpf_prog_pack

Sridhar Samudrala (1):
      ice: Expose RSS indirection tables for queue groups via ethtool

Srinivasan R (1):
      wireless: Fix Makefile to be in alphabetical order

Srinivasan Raju (2):
      wireless: add plfxlc driver for pureLiFi X, XL, XC devices
      plfxlc: fix le16_to_cpu warning for beacon_interval

Sriram R (1):
      mac80211: prepare sta handling for MLO support

Stanislav Fomichev (2):
      bpf: Move rcu lock management out of BPF_PROG_RUN routines
      bpf: Use bpf_prog_run_array_cg_flags everywhere

Stefano Garzarella (2):
      vsock/virtio: factor our the code to initialize and delete VQs
      vsock/virtio: add support for device suspend/resume

Steffen Klassert (1):
      Merge  branch 'Be explicit with XFRM offload direction'

Stephen Rothwell (1):
      netfilter: ctnetlink: fix up for "netfilter: conntrack: remove unconfirmed list"

Steven Rostedt (1):
      Bluetooth: hci_qca: Use del_timer_sync() before freeing

Sukadev Bhattiprolu (6):
      ibmvnic: rename local variable index to bufidx
      ibmvnic: define map_rxpool_buf_to_ltb()
      ibmvnic: define map_txpool_buf_to_ltb()
      ibmvnic: convert rxpool ltb to a set of ltbs
      ibmvnic: Allow multiple ltbs in rxpool ltb_set
      ibmvnic: Allow multiple ltbs in txpool ltb_set

Suman Ghosh (1):
      octeontx2-pf: Add support for adaptive interrupt coalescing

Sven Auhagen (1):
      netfilter: flowtable: nft_flow_route use more data for reverse route

Taehee Yoo (5):
      net: atlantic: Implement xdp control plane
      net: atlantic: Implement xdp data plane
      net: atlantic: Implement .ndo_xdp_xmit handler
      amt: fix gateway mode stuck
      amt: fix memory leak for advertisement message

Takshak Chahande (2):
      bpf: Extend batch operations for map-in-map bpf-maps
      selftests/bpf: Handle batch operations for map-in-map bpf-maps

Tariq Toukan (5):
      net/mlx5: Inline db alloc API function
      net/mlx5: Allocate virtually contiguous memory in vport.c
      net/mlx5: Allocate virtually contiguous memory in pci_irq.c
      net/mlx5e: Allocate virtually contiguous memory for VLANs list
      net/mlx5e: Allocate virtually contiguous memory for reps structures

Tetsuo Handa (2):
      wwan_hwsim: Avoid flush_scheduled_work() usage
      wfx: avoid flush_workqueue(system_highpri_wq) usage

Thibaut VARÈNE (1):
      ath9k: fix QCA9561 PA bias level

Tiezhu Yang (5):
      bpf, docs: Remove duplicated word "instructions"
      bpf, docs: BPF_FROM_BE exists as alias for BPF_TO_BE
      bpf, docs: Fix typo "respetively" to "respectively"
      net: sysctl: Use SYSCTL_TWO instead of &two
      bpf: Print some info if disable bpf_jit_enable failed

Tim Harvey (1):
      Bluetooth: btbcm: Add entry for BCM4373A0 UART Bluetooth

Toke Høiland-Jørgensen (1):
      mac80211: Improve confusing comment around tx_info clearing

Tom Rix (3):
      mlxsw: spectrum_router: simplify list unwinding
      USB2NET : SR9800 : change SR9800_BULKIN_SIZE from global to static
      net: fddi: skfp: smt: Remove extra parameters to vararg macro

Tommaso Merciai (1):
      net: phy: DP83822: enable rgmii mode if phy_interface_is_rgmii

Tonghao Zhang (5):
      net: sched: use queue_mapping to pick tx queue
      net: sched: support hash selecting tx queue
      net: sysctl: use shared sysctl macro
      net: sysctl: introduce sysctl SYSCTL_THREE
      selftests/sysctl: add sysctl macro test

Ulf Hansson (1):
      brcmfmac: Avoid keeping power to SDIO card unless WOWL is used

Uwe Kleine-König (2):
      net: fec: Do proper error checking for optional clks
      net: fec: Do proper error checking for enet_out clk

Vadim Fedorenko (2):
      ptp: ocp: add Celestica timecard PCI ids
      ptp: ocp: Add firmware header checks

Vadim Pasternak (22):
      mlxsw: reg: Extend MTMP register with new slot number field
      mlxsw: reg: Extend MTBR register with new slot number field
      mlxsw: reg: Extend MCIA register with new slot number field
      mlxsw: reg: Extend MCION register with new slot number field
      mlxsw: reg: Extend PMMP register with new slot number field
      mlxsw: reg: Extend MGPIR register with new slot fields
      mlxsw: core_env: Pass slot index during PMAOS register write call
      mlxsw: reg: Add new field to Management General Peripheral Information Register
      mlxsw: core: Extend interfaces for cable info access with slot argument
      mlxsw: core: Extend port module data structures for line cards
      mlxsw: core: Move port module events enablement to a separate function
      mlxsw: core_hwmon: Extend internal structures to support multi hwmon objects
      mlxsw: core_hwmon: Introduce slot parameter in hwmon interfaces
      mlxsw: core_thermal: Extend internal structures to support multi thermal areas
      mlxsw: core_thermal: Add line card id prefix to line card thermal zone name
      mlxsw: core_thermal: Use exact name of cooling devices for binding
      mlxsw: core_thermal: Use common define for thermal zone name length
      mlxsw: core: Add bus argument to environment init API
      mlxsw: core_env: Split module power mode setting to a separate function
      mlxsw: core_env: Add interfaces for line card initialization and de-initialization
      mlxsw: core_thermal: Add interfaces for line card initialization and de-initialization
      mlxsw: core_hwmon: Add interfaces for line card initialization and de-initialization

Vasily Averin (2):
      net: enable memcg accounting for veth queues
      memcg: accounting for objects allocated for new netdevice

Vasyl Vavrychuk (1):
      Bluetooth: core: Fix missing power_on work cancel on HCI close

Veerasenareddy Burru (7):
      octeon_ep: Add driver framework and device initialization
      octeon_ep: add hardware configuration APIs
      octeon_ep: Add mailbox for control commands
      octeon_ep: add Tx/Rx ring resource setup and cleanup
      octeon_ep: add support for ndo ops
      octeon_ep: add Tx/Rx processing and interrupt support
      octeon_ep: add ethtool support for Octeon PCI Endpoint NIC

Vincent Mailhol (2):
      can: slcan: slc_xmit(): use can_dropped_invalid_skb() instead of manual check
      can: mcp251xfd: silence clang's -Wunaligned-access warning

Vincent Whitchurch (1):
      net: stmmac: remove unused get_addr() callback

Vladimir Isaev (1):
      libbpf: Add ARC support to bpf_tracing.h

Vladimir Oltean (48):
      net: dsa: move reset of VLAN filtering to dsa_port_switchdev_unsync_attrs
      net: dsa: make cross-chip notifiers more efficient for host events
      net: dsa: use dsa_tree_for_each_user_port in dsa_slave_change_mtu
      net: dsa: avoid one dsa_to_port() in dsa_slave_change_mtu
      net: dsa: drop dsa_slave_priv from dsa_slave_change_mtu
      net: dsa: don't emit targeted cross-chip notifiers for MTU change
      selftests: forwarding: add option to run tests with stable MAC addresses
      selftests: forwarding: add helpers for IP multicast group joins/leaves
      selftests: forwarding: add helper for retrieving IPv6 link-local address of interface
      selftests: forwarding: add a no_forwarding.sh test
      selftests: forwarding: add a test for local_termination.sh
      selftests: drivers: dsa: add a subset of forwarding selftests
      selftests: forwarding: add Per-Stream Filtering and Policing test for Ocelot
      selftests: forwarding: add basic QoS classification test for Ocelot switches
      net: mscc: ocelot: use list_add_tail in ocelot_vcap_filter_add_to_block()
      net: mscc: ocelot: add to tail of empty list in ocelot_vcap_filter_add_to_block
      net: mscc: ocelot: use list_for_each_entry in ocelot_vcap_filter_add_to_block
      net: mscc: ocelot: drop port argument from qos_policer_conf_set
      net: mscc: ocelot: don't use magic numbers for OCELOT_POLICER_DISCARD
      net: dsa: felix: use PGID_CPU for FDB entry migration on NPI port
      net: dsa: felix: stop migrating FDBs back and forth on tag proto change
      net: dsa: felix: perform MDB migration based on ocelot->multicast list
      net: dsa: delete dsa_port_walk_{fdbs,mdbs}
      selftests: forwarding: tc_actions: allow mirred egress test to run on non-offloaded h2
      net: dsa: ocelot: accept 1000base-X for VSC9959 and VSC9953
      net: enetc: manage ENETC_F_QBV in priv->active_offloads only when enabled
      net: enetc: kill PHY-less mode for PFs
      net: dsa: felix: program host FDB entries towards PGID_CPU for tag_8021q too
      net: dsa: felix: bring the NPI port indirection for host MDBs to surface
      net: dsa: felix: bring the NPI port indirection for host flooding to surface
      net: dsa: introduce the dsa_cpu_ports() helper
      net: dsa: felix: manage host flooding using a specific driver callback
      net: dsa: remove port argument from ->change_tag_protocol()
      net: dsa: felix: dynamically determine tag_8021q CPU port for traps
      net: dsa: felix: reimplement tagging protocol change with function pointers
      net: mscc: ocelot: delete ocelot_port :: xmit_template
      net: mscc: ocelot: minimize holes in struct ocelot_port
      net: mscc: ocelot: move ocelot_port_private :: chip_port to ocelot_port :: index
      selftests: ocelot: tc_flower_chains: streamline test output
      selftests: ocelot: tc_flower_chains: use conventional interface names
      selftests: ocelot: tc_flower_chains: reorder interfaces
      net: mscc: ocelot: offload tc action "ok" using an empty action vector
      net: dsa: fix missing adjustment of host broadcast flooding
      net: dsa: felix: move the updating of PGID_CPU to the ocelot lib
      net: dsa: felix: update bridge fwd mask from ocelot lib when changing tag_8021q CPU
      net: dsa: felix: directly call ocelot_port_{set,unset}_dsa_8021q_cpu
      net: mscc: ocelot: switch from {,un}set to {,un}assign for tag_8021q CPU ports
      net: dsa: felix: tag_8021q preparation for multiple CPU ports

Volodymyr Mytnyk (2):
      prestera: acl: add action hw_stats support
      net: prestera: add police action support

Wan Jiabing (4):
      ath10k: simplify if-if to if-else
      wil6210: simplify if-if to if-else
      ath9k: hif_usb: simplify if-if to if-else
      ice: use min_t() to make code cleaner in ice_gnss

Wang Qing (2):
      net: ethernet: xilinx: use of_property_read_bool() instead of of_get_property
      net: usb: remove duplicate assignment

Wells Lu (3):
      devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
      net: ethernet: Add driver for Sunplus SP7021
      net: ethernet: Fix unmet direct dependencies detected for NVMEM_SUNPLUS_OCOTP

Wen Gong (16):
      ath11k: remove unused ATH11K_BD_IE_BOARD_EXT
      ath11k: disable regdb support for QCA6390
      ath11k: add support for device recovery for QCA6390/WCN6855
      ath11k: add synchronization operation between reconfigure of mac80211 and ath11k_base
      ath11k: Add hw-restart option to simulate_fw_crash
      ath11k: fix the warning of dev_wake in mhi_pm_disable_transition()
      ath11k: add fallback board name without variant while searching board-2.bin
      ath11k: add read variant from SMBIOS for download board data
      ath11k: store and send country code to firmware after recovery
      ath11k: add support to search regdb data in board-2.bin for WCN6855
      ath11k: reduce the wait time of 11d scan and hw scan while add interface
      ath11k: add support for extended wmi service bit
      ath11k: read country code from SMBIOS for WCN6855/QCA6390
      ath11k: fix warning of not found station for bssid in message
      ath11k: change management tx queue to avoid connection timed out
      ath11k: reset 11d state in process of recovery

Wenli Looi (7):
      ath9k: make ATH_SREV macros more consistent
      ath9k: split set11nRateFlags and set11nChainSel
      ath9k: use AR9300_MAX_CHAINS when appropriate
      ath9k: fix ar9003_get_eepmisc
      ath9k: refactor ar9003_hw_spur_mitigate_ofdm
      ath9k: add functions to get paprd rate mask
      ath9k: make is2ghz consistent in ar9003_eeprom

William Tu (1):
      netfilter: nf_conncount: reduce unnecessary GC

Wojciech Drewek (1):
      ice: return ENOSPC when exceeding ICE_MAX_CHAIN_WORDS

Wolfram Sang (1):
      dt-bindings: can: renesas,rcar-canfd: document r8a77961 support

Xiaomeng Tong (2):
      qed: remove an unneed NULL check on list iterator
      carl9170: tx: fix an incorrect use of list iterator

Xin Long (2):
      dn_route: set rt neigh to blackhole_netdev instead of loopback_dev in ifdown
      Documentation: add description for net.core.gro_normal_batch

Xiu Jianfeng (2):
      octeontx2-pf: Use memset_startat() helper in otx2_stop()
      stcp: Use memset_after() to zero sctp_stream_out_ext

Xu Kuohai (6):
      arm64, insn: Add ldr/str with immediate offset
      bpf, arm64: Optimize BPF store/load using arm64 str/ldr(immediate offset)
      bpf, arm64: Adjust the offset of str/ldr(immediate) to positive number
      bpf, tests: Add tests for BPF_LDX/BPF_STX with different offsets
      bpf, tests: Add load store test case for tail call
      bpf, arm64: Sign return address for JITed code

Yafang Shao (4):
      samples/bpf: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
      selftests/bpf: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
      bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
      tools/runqslower: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK

Yajun Deng (1):
      arp: fix unused variable warnning when CONFIG_PROC_FS=n

Yan Zhu (1):
      bpf: Move BPF sysctls from kernel/sysctl.c to BPF core

Yang Li (4):
      wcn36xx: clean up some inconsistent indenting
      ath9k: Remove unnecessary print function dev_err()
      rtw89: remove unneeded semicolon
      net: ethernet: fix platform_no_drv_owner.cocci warning

Yang Yingliang (6):
      net: ethernet: mtk_eth_soc: fix return value check in mtk_wed_add_hw()
      octeon_ep: fix error return code in octep_probe()
      ath11k: fix missing unlock on error in ath11k_wow_op_resume()
      ethernet: broadcom/sb1250-mac: remove BUG_ON in sbmac_probe()
      net: ethernet: sunplus: add missing of_node_put() in spl2sw_mdio_init()
      net: wwan: t7xx: use GFP_ATOMIC under spin lock in t7xx_cldma_gpd_set_next_ptr()

Yauheni Kaliuta (1):
      bpf, test_offload.py: Skip base maps without names

Ying Hsu (1):
      Bluetooth: fix dangling sco_conn and use-after-free in sco_sock_timeout

Yinjun Zhang (2):
      nfp: flower: utilize the tuple iifidx in offloading ct flows
      nfp: flower: support ct merging when mangle action exists

Yonghong Song (4):
      selftests/bpf: Limit unroll_count for pyperf600 test
      selftests/bpf: Workaround a verifier issue for test exhandler
      selftests/bpf: fix a few clang compilation errors
      selftests/bpf: fix btf_dump/btf_dump due to recent clang change

Yongzhi Liu (1):
      hv_netvsc: Fix potential dereference of NULL pointer

Yosry Ahmed (1):
      selftests/bpf: Fix building bpf selftests statically

Youghandhar Chintala (1):
      ath10k: Trigger sta disconnect on hardware restart

Yu Xiao (2):
      nfp: vendor neutral strings for chip and Corigne in strings for driver
      nfp: support Corigine PCIE vendor ID

Yu Zhe (3):
      bpf: Remove unnecessary type castings
      batman-adv: remove unnecessary type castings
      ipv4: remove unnecessary type castings

Yuchung Cheng (1):
      tcp: improve PRR loss recovery

YueHaibing (3):
      net: ethernet: ti: am65-cpsw: Fix build error without PHYLINK
      ath11k: Fix build warning without CONFIG_IPV6
      net: wwan: t7xx: Fix return type of t7xx_dl_add_timedout()

Yufeng Mo (2):
      net: hns3: add ethtool parameter check for CQE/EQE mode
      net: hns3: remove the affinity settings of vector0

Yuiko Oshino (4):
      net: phy: microchip: update LAN88xx phy ID and phy ID mask.
      net: phy: smsc: add LAN8742 phy support.
      net: phy: microchip: add comments for the modified LAN88xx phy ID mask.
      net: phy: smsc: add comments for the LAN8742 phy ID mask.

Yunbo Yu (2):
      net: cdc-ncm: Move spin_lock_bh() to spin_lock()
      mt76: mt7603: move spin_lock_bh() to spin_lock()

Yuntao Wang (12):
      bpf: Remove redundant assignment to smap->map.value_size
      selftests/bpf: Fix cd_flavor_subdir() of test_progs
      libbpf: Don't return -EINVAL if hdr_len < offsetofend(core_relo_len)
      selftests/bpf: Fix file descriptor leak in load_kallsyms()
      selftests/bpf: Fix issues in parse_num_list()
      selftests/bpf: Fix return value checks in perf_event_stackmap test
      bpf: Fix excessive memory allocation in stack_map_alloc()
      bpf: Remove redundant assignment to meta.seq in __task_seq_show()
      libbpf: Remove unnecessary type cast
      bpf: Remove unused parameter from find_kfunc_desc_btf()
      bpf: Fix potential array overflow in bpf_trampoline_get_progs()
      selftests/bpf: Add missing trampoline program type to trampoline_count test

Zheng Bin (2):
      net: hinic: add missing destroy_workqueue in hinic_pf_to_mgmt_init
      octeon_ep: add missing destroy_workqueue in octep_init_module

Zhengchao Shao (2):
      samples/bpf: Reduce the sampling interval in xdp1_user
      samples/bpf: Detach xdp prog when program exits unexpectedly in xdp_rxq_info_user

Zijun Hu (2):
      Bluetooth: btusb: add support for Qualcomm WCN785x
      Bluetooth: btusb: Set HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for QCA

Ziyang Xuan (2):
      net/mlx5: use kvfree() for kvzalloc() in mlx5_ct_fs_smfs_matcher_create
      octeon_ep: delete unnecessary NULL check

Zong-Zhe Yang (17):
      rtw89: ser: fix CAM leaks occurring in L2 reset
      rtw89: mac: move table of mem base addr to common
      rtw89: mac: correct decision on error status by scenario
      rtw89: ser: control hci interrupts on/off by state
      rtw89: ser: dump memory for fw payload engine while L2 reset
      rtw89: ser: dump fw backtrace while L2 reset
      rtw89: reconstruct fw feature
      rtw89: support FW crash simulation
      rtw89: add UK to regulation type
      rtw89: 8852a: update txpwr tables to HALRF_027_00_038
      rtw89: regd: consider 6G band
      rtw89: regd: update mapping table to R59-R32
      rtw89: ser: fix unannotated fall-through
      rtw89: 8852c: add TX power track tables
      rtw89: 8852c: support bb gain info
      rtw89: 8852c: update txpwr tables to HALRF_027_00_052
      rtw89: convert rtw89_band to nl80211_band precisely

jianghaoran (1):
      ipv6: Don't send rs packets to the interface of ARPHRD_TUNNEL

liuyacan (3):
      net/smc: postpone sk_refcnt increment in connect()
      net/smc: fix listen processing for SMC-Rv2
      Revert "net/smc: fix listen processing for SMC-Rv2"

 Documentation/admin-guide/devices.txt              |     2 +-
 Documentation/admin-guide/sysctl/net.rst           |    17 +
 Documentation/bpf/instruction-set.rst              |     4 +-
 Documentation/bpf/libbpf/index.rst                 |     3 +-
 .../arm/mediatek/mediatek,mt7622-pcie-mirror.yaml  |    42 +
 .../bindings/arm/mediatek/mediatek,mt7622-wed.yaml |    50 +
 .../devicetree/bindings/net/adi,adin.yaml          |    15 +
 .../bindings/net/aspeed,ast2600-mdio.yaml          |     6 +
 .../devicetree/bindings/net/can/ctu,ctucanfd.yaml  |    66 +
 .../bindings/net/can/microchip,mcp251xfd.yaml      |    19 +-
 .../bindings/net/can/renesas,rcar-canfd.yaml       |     5 +-
 .../devicetree/bindings/net/cdns,macb.yaml         |     8 -
 .../devicetree/bindings/net/ethernet-phy.yaml      |     9 +
 .../bindings/net/marvell,orion-mdio.yaml           |    60 +
 .../devicetree/bindings/net/marvell-orion-mdio.txt |    54 -
 .../devicetree/bindings/net/mediatek,net.yaml      |   434 +
 .../devicetree/bindings/net/mediatek-net.txt       |    98 -
 Documentation/devicetree/bindings/net/micrel.txt   |     9 +
 .../bindings/net/microchip,lan966x-switch.yaml     |     8 +-
 .../devicetree/bindings/net/mscc,miim.yaml         |    61 +
 .../devicetree/bindings/net/mscc-miim.txt          |    26 -
 .../devicetree/bindings/net/renesas,etheravb.yaml  |    82 +-
 .../bindings/net/sunplus,sp7021-emac.yaml          |   141 +
 .../bindings/net/toshiba,visconti-dwmac.yaml       |     3 +-
 .../bindings/net/wireless/qcom,ath11k.yaml         |   361 +-
 .../{staging => }/net/wireless/silabs,wfx.yaml     |     2 +-
 .../devicetree/bindings/vendor-prefixes.yaml       |     2 +
 .../networking/device_drivers/appletalk/index.rst  |     1 -
 .../networking/device_drivers/appletalk/ltpc.rst   |   144 -
 .../device_drivers/can/ctu/ctucanfd-driver.rst     |   639 +
 .../device_drivers/can/ctu/fsm_txt_buffer_user.svg |   151 +
 .../networking/device_drivers/can/index.rst        |     1 +
 .../device_drivers/ethernet/dec/de4x5.rst          |   189 -
 .../networking/device_drivers/ethernet/index.rst   |     2 +-
 .../device_drivers/ethernet/marvell/octeon_ep.rst  |    35 +
 Documentation/networking/device_drivers/index.rst  |     1 -
 .../networking/device_drivers/wan/index.rst        |    18 -
 .../networking/device_drivers/wan/z8530book.rst    |   256 -
 .../networking/device_drivers/wwan/index.rst       |     1 +
 .../networking/device_drivers/wwan/t7xx.rst        |   120 +
 .../networking/devlink/devlink-linecard.rst        |   122 +
 Documentation/networking/devlink/index.rst         |     1 +
 Documentation/networking/dsa/dsa.rst               |    17 +
 Documentation/networking/ethtool-netlink.rst       |     8 +
 Documentation/networking/index.rst                 |     5 +-
 Documentation/networking/ip-sysctl.rst             |    27 +
 Documentation/networking/mptcp-sysctl.rst          |    18 +
 Documentation/networking/nf_conntrack-sysctl.rst   |     5 +-
 Documentation/networking/skbuff.rst                |    37 +
 MAINTAINERS                                        |    63 +-
 arch/alpha/include/uapi/asm/socket.h               |     2 +
 arch/arm/boot/dts/aspeed-g6.dtsi                   |     4 +
 arch/arm/boot/dts/imx6qdl-sr-som.dtsi              |    10 +
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |    12 +-
 arch/arm64/boot/dts/mediatek/mt7622.dtsi           |    32 +-
 arch/arm64/boot/dts/mediatek/mt7986a-rfb.dts       |    74 +
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi          |    39 +
 arch/arm64/boot/dts/mediatek/mt7986b-rfb.dts       |    70 +
 arch/arm64/include/asm/insn.h                      |     9 +
 arch/arm64/lib/insn.c                              |    67 +-
 arch/arm64/net/bpf_jit.h                           |    17 +
 arch/arm64/net/bpf_jit_comp.c                      |   255 +-
 arch/mips/configs/gpr_defconfig                    |     5 -
 arch/mips/configs/mtx1_defconfig                   |     6 -
 arch/mips/include/uapi/asm/socket.h                |     2 +
 arch/parisc/include/uapi/asm/socket.h              |     2 +
 arch/powerpc/configs/chrp32_defconfig              |     1 -
 arch/powerpc/configs/ppc6xx_defconfig              |     1 -
 arch/riscv/net/bpf_jit.h                           |    67 +
 arch/riscv/net/bpf_jit_comp64.c                    |   110 +-
 arch/s390/net/bpf_jit_comp.c                       |     2 +-
 arch/sparc/include/uapi/asm/socket.h               |     1 +
 arch/um/drivers/vector_kern.c                      |     3 +-
 arch/x86/include/asm/text-patching.h               |     1 +
 arch/x86/kernel/alternative.c                      |    67 +-
 arch/x86/net/bpf_jit_comp.c                        |    79 +-
 drivers/atm/Kconfig                                |    79 -
 drivers/atm/Makefile                               |     4 -
 drivers/atm/ambassador.c                           |  2400 ---
 drivers/atm/ambassador.h                           |   648 -
 drivers/atm/firestream.c                           |  2057 --
 drivers/atm/firestream.h                           |   502 -
 drivers/atm/horizon.c                              |  2853 ---
 drivers/atm/horizon.h                              |   492 -
 drivers/atm/nicstarmac.c                           |     5 -
 drivers/atm/uPD98401.h                             |   293 -
 drivers/atm/uPD98402.c                             |   266 -
 drivers/atm/uPD98402.h                             |   107 -
 drivers/atm/zatm.c                                 |  1652 --
 drivers/atm/zatm.h                                 |   104 -
 drivers/bcma/driver_gpio.c                         |     7 +-
 drivers/bluetooth/btbcm.c                          |    53 +-
 drivers/bluetooth/btintel.c                        |     2 +-
 drivers/bluetooth/btmtksdio.c                      |    26 +-
 drivers/bluetooth/btrtl.c                          |    13 +
 drivers/bluetooth/btusb.c                          |    23 +-
 drivers/bluetooth/hci_qca.c                        |     4 +-
 drivers/firmware/broadcom/tee_bnxt_fw.c            |     2 +-
 drivers/infiniband/core/device.c                   |     2 -
 .../infiniband/core/uverbs_std_types_flow_action.c |   383 +-
 drivers/infiniband/hw/mlx5/fs.c                    |   223 +-
 drivers/infiniband/hw/mlx5/gsi.c                   |     2 +-
 drivers/infiniband/hw/mlx5/main.c                  |    32 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |     1 +
 drivers/infiniband/hw/mlx5/qp.c                    |     2 +-
 drivers/isdn/mISDN/socket.c                        |     2 +-
 drivers/media/rc/bpf-lirc.c                        |     8 +-
 drivers/net/Space.c                                |     3 -
 drivers/net/amt.c                                  |    11 +-
 drivers/net/appletalk/Kconfig                      |    11 -
 drivers/net/appletalk/Makefile                     |     1 -
 drivers/net/appletalk/ltpc.c                       |  1277 --
 drivers/net/appletalk/ltpc.h                       |    74 -
 drivers/net/bonding/bond_main.c                    |    29 +-
 drivers/net/caif/caif_virtio.c                     |     3 +-
 drivers/net/can/Kconfig                            |    18 +-
 drivers/net/can/Makefile                           |     1 +
 drivers/net/can/at91_can.c                         |    12 +-
 drivers/net/can/c_can/c_can_main.c                 |    19 +-
 drivers/net/can/ctucanfd/Kconfig                   |    34 +
 drivers/net/can/ctucanfd/Makefile                  |    10 +
 drivers/net/can/ctucanfd/ctucanfd.h                |    82 +
 drivers/net/can/ctucanfd/ctucanfd_base.c           |  1452 ++
 drivers/net/can/ctucanfd/ctucanfd_kframe.h         |    77 +
 drivers/net/can/ctucanfd/ctucanfd_kregs.h          |   325 +
 drivers/net/can/ctucanfd/ctucanfd_pci.c            |   294 +
 drivers/net/can/ctucanfd/ctucanfd_platform.c       |   131 +
 drivers/net/can/dev/Makefile                       |     2 -
 drivers/net/can/dev/bittiming.c                    |     2 +-
 drivers/net/can/dev/dev.c                          |     5 -
 drivers/net/can/dev/rx-offload.c                   |    11 +-
 drivers/net/can/flexcan/flexcan-core.c             |    23 +-
 drivers/net/can/grcan.c                            |     2 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c              |     9 -
 drivers/net/can/janz-ican3.c                       |     2 +-
 drivers/net/can/led.c                              |   140 -
 drivers/net/can/m_can/m_can.c                      |    22 +-
 drivers/net/can/m_can/m_can.h                      |     1 -
 drivers/net/can/mscan/mpc5xxx_can.c                |     2 +
 drivers/net/can/mscan/mscan.c                      |     2 +-
 drivers/net/can/pch_can.c                          |     2 +-
 drivers/net/can/rcar/rcar_can.c                    |    12 +-
 drivers/net/can/rcar/rcar_canfd.c                  |    11 +-
 drivers/net/can/sja1000/Kconfig                    |     2 +-
 drivers/net/can/sja1000/sja1000.c                  |    11 -
 drivers/net/can/sja1000/tscan1.c                   |     7 +-
 drivers/net/can/slcan.c                            |     4 +-
 drivers/net/can/spi/hi311x.c                       |     8 -
 drivers/net/can/spi/mcp251x.c                      |    10 -
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |    25 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c       |     2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |    14 +-
 drivers/net/can/sun4i_can.c                        |     7 -
 drivers/net/can/ti_hecc.c                          |    12 +-
 drivers/net/can/usb/kvaser_usb/Makefile            |     5 +
 drivers/net/can/usb/mcba_usb.c                     |     8 -
 drivers/net/can/usb/peak_usb/pcan_usb.c            |     2 +-
 drivers/net/can/usb/usb_8dev.c                     |    11 -
 drivers/net/can/xilinx_can.c                       |    16 +-
 drivers/net/dsa/Kconfig                            |     3 +-
 drivers/net/dsa/lantiq_gswip.c                     |     9 +-
 drivers/net/dsa/microchip/ksz8795.c                |   287 +-
 drivers/net/dsa/microchip/ksz8795_reg.h            |     3 -
 drivers/net/dsa/microchip/ksz8795_spi.c            |    35 +-
 drivers/net/dsa/microchip/ksz8863_smi.c            |    10 +-
 drivers/net/dsa/microchip/ksz9477.c                |   331 +-
 drivers/net/dsa/microchip/ksz9477_i2c.c            |    30 +-
 drivers/net/dsa/microchip/ksz9477_reg.h            |     4 -
 drivers/net/dsa/microchip/ksz9477_spi.c            |    30 +-
 drivers/net/dsa/microchip/ksz_common.c             |   621 +-
 drivers/net/dsa/microchip/ksz_common.h             |    89 +-
 drivers/net/dsa/mt7530.c                           |   332 +-
 drivers/net/dsa/mt7530.h                           |    26 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |    78 +-
 drivers/net/dsa/ocelot/felix.c                     |   695 +-
 drivers/net/dsa/ocelot/felix.h                     |    18 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |     7 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c           |     6 +-
 drivers/net/dsa/qca8k.c                            |   145 +-
 drivers/net/dsa/qca8k.h                            |    12 +-
 drivers/net/dsa/realtek/rtl8365mb.c                |     2 +-
 drivers/net/dsa/realtek/rtl8366rb.c                |    37 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |     5 +-
 drivers/net/eql.c                                  |     3 +-
 drivers/net/ethernet/3com/typhoon.c                |     2 +-
 drivers/net/ethernet/Kconfig                       |     1 +
 drivers/net/ethernet/Makefile                      |     1 +
 drivers/net/ethernet/adaptec/starfire.c            |     2 +-
 drivers/net/ethernet/alacritech/slic.h             |     2 -
 drivers/net/ethernet/alacritech/slicoss.c          |     2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |     4 +-
 drivers/net/ethernet/amd/Kconfig                   |    10 -
 drivers/net/ethernet/amd/Makefile                  |     1 -
 drivers/net/ethernet/amd/amd8111e.c                |     2 +-
 drivers/net/ethernet/amd/ni65.c                    |  1251 --
 drivers/net/ethernet/amd/ni65.h                    |   121 -
 drivers/net/ethernet/amd/pcnet32.c                 |     3 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h               |     3 +-
 drivers/net/ethernet/apple/bmac.c                  |     1 -
 drivers/net/ethernet/apple/mace.c                  |     1 -
 drivers/net/ethernet/aquantia/atlantic/aq_cfg.h    |     3 +-
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |     9 +
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |    87 +
 drivers/net/ethernet/aquantia/atlantic/aq_main.h   |     2 +
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   136 +
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h    |     5 +
 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c    |     2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |   409 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.h   |    21 +-
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    |    25 +-
 drivers/net/ethernet/aquantia/atlantic/aq_vec.h    |     6 +
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c  |     6 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |    10 +-
 drivers/net/ethernet/arc/emac_main.c               |     3 +-
 drivers/net/ethernet/atheros/ag71xx.c              |     3 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |     2 +-
 drivers/net/ethernet/broadcom/Makefile             |     5 +
 drivers/net/ethernet/broadcom/bcm4908_enet.c       |     2 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |     4 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |     2 +-
 drivers/net/ethernet/broadcom/bgmac.c              |     2 +-
 drivers/net/ethernet/broadcom/bgmac.h              |     2 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h    |    10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   313 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |    18 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |     2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |    86 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h  |     2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      |   415 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |    80 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h      |     2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |    12 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h      |    12 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   191 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h      |    16 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |     3 +-
 drivers/net/ethernet/broadcom/sb1250-mac.c         |     9 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |     3 +-
 drivers/net/ethernet/cadence/macb.h                |     6 +-
 drivers/net/ethernet/cadence/macb_main.c           |   353 +-
 drivers/net/ethernet/cadence/macb_ptp.c            |     4 +-
 drivers/net/ethernet/calxeda/xgmac.c               |     2 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |     2 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c |     2 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |     3 -
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      |     2 +-
 .../ethernet/chelsio/inline_crypto/chtls/chtls.h   |     2 +-
 .../chelsio/inline_crypto/chtls/chtls_io.c         |    22 +-
 drivers/net/ethernet/cirrus/cs89x0.c               |     2 +-
 drivers/net/ethernet/cortina/gemini.c              |     4 +-
 drivers/net/ethernet/dec/tulip/Kconfig             |    15 -
 drivers/net/ethernet/dec/tulip/Makefile            |     1 -
 drivers/net/ethernet/dec/tulip/de4x5.c             |  5591 ------
 drivers/net/ethernet/dec/tulip/de4x5.h             |  1017 -
 drivers/net/ethernet/dec/tulip/eeprom.c            |     7 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c        |    66 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c       |     2 -
 drivers/net/ethernet/emulex/benet/be.h             |     3 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |     4 +-
 drivers/net/ethernet/engleder/tsnep_hw.h           |     9 +-
 drivers/net/ethernet/engleder/tsnep_main.c         |    36 +-
 drivers/net/ethernet/engleder/tsnep_ptp.c          |    28 +
 drivers/net/ethernet/ezchip/nps_enet.c             |     4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |    12 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   |     3 -
 drivers/net/ethernet/freescale/enetc/enetc.c       |    13 +-
 drivers/net/ethernet/freescale/enetc/enetc.h       |     2 +
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |     2 +
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |     1 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |    30 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |     6 +
 drivers/net/ethernet/freescale/fec_main.c          |    20 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c       |     2 +
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c   |     1 +
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |     3 +-
 drivers/net/ethernet/freescale/gianfar.c           |     6 +-
 drivers/net/ethernet/freescale/gianfar.h           |     3 -
 .../net/ethernet/fungible/funeth/funeth_devlink.c  |     8 +-
 drivers/net/ethernet/fungible/funeth/funeth_main.c |     3 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c        |     3 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |     4 +-
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |    73 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |     4 +
 .../hisilicon/hns3/hns3_common/hclge_comm_cmd.c    |     2 +
 .../hisilicon/hns3/hns3_common/hclge_comm_cmd.h    |     1 +
 .../hisilicon/hns3/hns3_common/hclge_comm_rss.h    |     2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |     5 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   144 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h |     6 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |     2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |    30 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |     6 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   195 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_trace.h   |     2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |    62 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |     2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |    88 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h |     2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c  |     2 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c    |     2 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |     3 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       |     3 +-
 drivers/net/ethernet/ibm/ehea/ehea.h               |     1 +
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |     2 +
 drivers/net/ethernet/ibm/emac/mal.c                |     4 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |     2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   311 +-
 drivers/net/ethernet/ibm/ibmvnic.h                 |    54 +-
 drivers/net/ethernet/intel/e100.c                  |     2 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |     1 +
 drivers/net/ethernet/intel/i40e/i40e_common.c      |     1 +
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |     5 +-
 drivers/net/ethernet/intel/i40e/i40e_devids.h      |     1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |     2 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |    25 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |    49 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |     1 +
 drivers/net/ethernet/intel/i40e/i40e_txrx_common.h |     1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |    39 +-
 drivers/net/ethernet/intel/ice/Makefile            |     5 +
 drivers/net/ethernet/intel/ice/ice.h               |    15 +
 drivers/net/ethernet/intel/ice/ice_devlink.c       |    27 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |    77 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c          |     3 +-
 drivers/net/ethernet/intel/ice/ice_idc.c           |    15 -
 drivers/net/ethernet/intel/ice/ice_main.c          |    22 +-
 drivers/net/ethernet/intel/ice/ice_repr.c          |     8 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c         |    32 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   494 +-
 drivers/net/ethernet/intel/ice/ice_switch.h        |    12 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |     1 -
 drivers/net/ethernet/intel/ice/ice_txrx.c          |    29 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |     1 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |    43 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.h        |     4 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |    27 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |     9 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |    53 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |     4 +-
 drivers/net/ethernet/intel/igc/igc.h               |     1 -
 drivers/net/ethernet/intel/igc/igc_base.c          |     2 -
 drivers/net/ethernet/intel/igc/igc_hw.h            |     7 -
 drivers/net/ethernet/intel/igc/igc_main.c          |    50 -
 drivers/net/ethernet/intel/igc/igc_phy.c           |    16 +-
 drivers/net/ethernet/intel/igc/igc_phy.h           |     2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c     |     9 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.h     |     2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   107 +-
 .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |     1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |    53 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |     6 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.h         |     2 +-
 drivers/net/ethernet/jme.c                         |     2 +-
 drivers/net/ethernet/jme.h                         |     2 -
 drivers/net/ethernet/lantiq_etop.c                 |     8 +-
 drivers/net/ethernet/lantiq_xrx200.c               |     4 +-
 drivers/net/ethernet/marvell/Kconfig               |     2 +
 drivers/net/ethernet/marvell/Makefile              |     1 +
 drivers/net/ethernet/marvell/mv643xx_eth.c         |     2 +-
 drivers/net/ethernet/marvell/mvneta.c              |    22 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |     4 +-
 drivers/net/ethernet/marvell/octeon_ep/Kconfig     |    20 +
 drivers/net/ethernet/marvell/octeon_ep/Makefile    |     9 +
 .../net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c |   737 +
 .../net/ethernet/marvell/octeon_ep/octep_config.h  |   204 +
 .../ethernet/marvell/octeon_ep/octep_ctrl_mbox.c   |   245 +
 .../ethernet/marvell/octeon_ep/octep_ctrl_mbox.h   |   170 +
 .../ethernet/marvell/octeon_ep/octep_ctrl_net.c    |   194 +
 .../ethernet/marvell/octeon_ep/octep_ctrl_net.h    |   299 +
 .../net/ethernet/marvell/octeon_ep/octep_ethtool.c |   463 +
 .../net/ethernet/marvell/octeon_ep/octep_main.c    |  1181 ++
 .../net/ethernet/marvell/octeon_ep/octep_main.h    |   357 +
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h         |   367 +
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c  |   507 +
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.h  |   199 +
 drivers/net/ethernet/marvell/octeon_ep/octep_tx.c  |   334 +
 drivers/net/ethernet/marvell/octeon_ep/octep_tx.h  |   284 +
 drivers/net/ethernet/marvell/octeontx2/Kconfig     |     1 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |     4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |     5 -
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |    10 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |    45 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |    29 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |    23 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |     1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |     2 +-
 .../net/ethernet/marvell/prestera/prestera_acl.c   |    42 +-
 .../net/ethernet/marvell/prestera/prestera_acl.h   |    12 +
 .../ethernet/marvell/prestera/prestera_flower.c    |    28 +
 .../net/ethernet/marvell/prestera/prestera_hw.c    |    81 +
 .../net/ethernet/marvell/prestera/prestera_hw.h    |    13 +
 .../ethernet/marvell/prestera/prestera_router.c    |    11 +-
 .../net/ethernet/marvell/prestera/prestera_rxtx.c  |     2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c          |     3 +-
 drivers/net/ethernet/marvell/skge.c                |     3 +-
 drivers/net/ethernet/marvell/sky2.c                |     3 +-
 drivers/net/ethernet/mediatek/Kconfig              |     4 +
 drivers/net/ethernet/mediatek/Makefile             |    10 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  1062 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   360 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c            |   369 +-
 drivers/net/ethernet/mediatek/mtk_ppe.h            |    89 +-
 drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c    |     1 -
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |   191 +-
 drivers/net/ethernet/mediatek/mtk_sgmii.c          |   176 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |     3 +-
 drivers/net/ethernet/mediatek/mtk_wed.c            |   880 +
 drivers/net/ethernet/mediatek/mtk_wed.h            |   135 +
 drivers/net/ethernet/mediatek/mtk_wed_debugfs.c    |   175 +
 drivers/net/ethernet/mediatek/mtk_wed_ops.c        |     8 +
 drivers/net/ethernet/mediatek/mtk_wed_regs.h       |   251 +
 drivers/net/ethernet/mellanox/mlx4/en_cq.c         |     3 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |     3 +
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |    47 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |    58 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    16 +-
 .../net/ethernet/mellanox/mlx5/core/accel/accel.h  |    36 -
 .../net/ethernet/mellanox/mlx5/core/accel/ipsec.c  |   179 -
 .../net/ethernet/mellanox/mlx5/core/accel/ipsec.h  |    96 -
 .../mellanox/mlx5/core/accel/ipsec_offload.c       |   385 -
 .../mellanox/mlx5/core/accel/ipsec_offload.h       |    38 -
 .../net/ethernet/mellanox/mlx5/core/accel/tls.c    |   125 -
 .../net/ethernet/mellanox/mlx5/core/accel/tls.h    |   156 -
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c    |     6 -
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |     7 +-
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |     2 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |    49 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |    24 +-
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |     3 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |     6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h |     2 -
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |     1 -
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |    22 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |    14 +
 .../ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c |     2 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |     1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |    53 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |     6 -
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |     1 -
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |     2 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |    11 +-
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  |     2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   204 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   110 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |   365 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h         |    11 +-
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    |   205 +
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |   249 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |     3 -
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c      |    65 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |    71 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |    86 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |     2 +-
 .../core/en_accel/{tls_stats.c => ktls_stats.c}    |    51 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |    20 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h        |    28 +-
 .../mellanox/mlx5/core/en_accel/ktls_utils.h       |     1 -
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.c |   247 -
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.h |   132 -
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |   390 -
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h         |    91 -
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |     5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |     9 -
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |     4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |    35 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |    36 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |    79 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |     9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |     1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |    28 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |     7 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   105 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |    28 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |     8 -
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |     3 +
 .../net/ethernet/mellanox/mlx5/core/fpga/core.h    |     3 -
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   |  1582 --
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.h   |    62 -
 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c |   622 -
 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h |    74 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |    20 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |    61 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |     1 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |     3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |     2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |    14 +-
 .../net/ethernet/mellanox/mlx5/core/lag/debugfs.c  |   174 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   681 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  |    55 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   |     4 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |   101 +
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.h    |    26 +
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.c |   129 +-
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.h |    15 +-
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.c   |    16 +-
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.h   |     2 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c |     1 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h |     1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |    67 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |     3 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |     8 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |    21 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |    52 +-
 .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h  |     3 -
 .../mellanox/mlxbf_gige/mlxbf_gige_ethtool.c       |     8 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_intr.c |     9 -
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c |     2 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c |     6 +-
 drivers/net/ethernet/mellanox/mlxsw/Makefile       |     3 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |    58 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h         |    79 +-
 drivers/net/ethernet/mellanox/mlxsw/core_env.c     |   681 +-
 drivers/net/ethernet/mellanox/mlxsw/core_env.h     |    47 +-
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c   |   311 +-
 .../net/ethernet/mellanox/mlxsw/core_linecards.c   |  1142 ++
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |   250 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c      |    39 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |   465 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   348 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |    27 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl_tcam.c    |     5 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c |    26 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c |    13 -
 .../net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |    35 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   201 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.h  |     2 +
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |    31 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_trap.c    |     2 +-
 drivers/net/ethernet/mellanox/mlxsw/trap.h         |     6 +
 drivers/net/ethernet/microchip/lan743x_main.c      |     6 +-
 drivers/net/ethernet/microchip/lan966x/Makefile    |     2 +-
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |   842 +
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |    84 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |   121 +
 .../net/ethernet/microchip/lan966x/lan966x_port.c  |     3 +
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |   276 +-
 .../net/ethernet/microchip/lan966x/lan966x_regs.h  |   146 +
 .../net/ethernet/microchip/sparx5/sparx5_fdma.c    |     3 +-
 .../net/ethernet/microchip/sparx5/sparx5_port.c    |     2 +-
 .../ethernet/microchip/sparx5/sparx5_switchdev.c   |    12 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      |     4 +-
 drivers/net/ethernet/moxa/moxart_ether.c           |     2 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   244 +-
 drivers/net/ethernet/mscc/ocelot.h                 |     1 -
 drivers/net/ethernet/mscc/ocelot_fdma.c            |     4 +-
 drivers/net/ethernet/mscc/ocelot_flower.c          |    16 +
 drivers/net/ethernet/mscc/ocelot_net.c             |    79 +-
 drivers/net/ethernet/mscc/ocelot_police.c          |    26 +-
 drivers/net/ethernet/mscc/ocelot_police.h          |     2 +-
 drivers/net/ethernet/mscc/ocelot_vcap.c            |    42 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         |     2 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |     6 +-
 drivers/net/ethernet/natsemi/natsemi.c             |     2 -
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |    13 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.h     |     2 -
 drivers/net/ethernet/netronome/nfp/crypto/tls.c    |     2 +-
 drivers/net/ethernet/netronome/nfp/flower/action.c |     3 +-
 .../net/ethernet/netronome/nfp/flower/conntrack.c  |   268 +-
 .../net/ethernet/netronome/nfp/flower/lag_conf.c   |     2 +-
 drivers/net/ethernet/netronome/nfp/flower/main.h   |   110 +-
 drivers/net/ethernet/netronome/nfp/flower/match.c  |    51 +-
 .../net/ethernet/netronome/nfp/flower/metadata.c   |    19 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |    86 +-
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |   515 +-
 drivers/net/ethernet/netronome/nfp/nfp_main.c      |    38 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |    13 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c  |     5 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c |    91 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h |    12 +
 .../net/ethernet/netronome/nfp/nfp_netvf_main.c    |    12 +-
 .../ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c  |    18 +-
 .../net/ethernet/netronome/nfp/nfpcore/nfp_cpp.h   |    26 +-
 .../net/ethernet/netronome/nfp/nfpcore/nfp_dev.h   |     8 +
 drivers/net/ethernet/nvidia/forcedeth.c            |     6 +-
 drivers/net/ethernet/nxp/lpc_eth.c                 |     2 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |    12 +-
 drivers/net/ethernet/qlogic/qed/Makefile           |     3 +-
 drivers/net/ethernet/qlogic/qed/qed_dbg_hsi.h      |     2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c         |     1 -
 .../ethernet/qlogic/qed/qed_nvmetcp_ip_services.c  |   238 -
 drivers/net/ethernet/qlogic/qed/qed_vf.h           |     2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |     1 -
 drivers/net/ethernet/qlogic/qede/qede_ptp.c        |    10 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c     |     9 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |     3 +-
 drivers/net/ethernet/realtek/8139cp.c              |     2 +-
 drivers/net/ethernet/realtek/atp.h                 |     4 -
 drivers/net/ethernet/realtek/r8169_main.c          |     8 +-
 drivers/net/ethernet/renesas/ravb.h                |     6 +
 drivers/net/ethernet/renesas/ravb_main.c           |   109 +-
 drivers/net/ethernet/renesas/ravb_ptp.c            |     6 +-
 drivers/net/ethernet/rocker/rocker_main.c          |     3 +-
 drivers/net/ethernet/sfc/Kconfig                   |    15 +-
 drivers/net/ethernet/sfc/Makefile                  |     5 +-
 drivers/net/ethernet/sfc/ef10.c                    |     2 +-
 drivers/net/ethernet/sfc/ef100.c                   |    27 +-
 drivers/net/ethernet/sfc/ef100_nic.c               |    18 +-
 drivers/net/ethernet/sfc/ef100_sriov.c             |    56 +
 drivers/net/ethernet/sfc/ef100_sriov.h             |    14 +
 drivers/net/ethernet/sfc/efx.c                     |    19 +-
 drivers/net/ethernet/sfc/efx.h                     |     1 -
 drivers/net/ethernet/sfc/efx_channels.c            |    59 +-
 drivers/net/ethernet/sfc/efx_channels.h            |     3 -
 drivers/net/ethernet/sfc/efx_common.c              |     4 +-
 drivers/net/ethernet/sfc/falcon/efx.c              |    10 +-
 drivers/net/ethernet/sfc/falcon/rx.c               |     4 +-
 drivers/net/ethernet/sfc/falcon/tx.c               |     3 +-
 drivers/net/ethernet/sfc/mcdi_pcol.h               |     4 +-
 drivers/net/ethernet/sfc/net_driver.h              |     5 -
 drivers/net/ethernet/sfc/nic.h                     |     4 -
 drivers/net/ethernet/sfc/siena/Kconfig             |    46 +
 drivers/net/ethernet/sfc/siena/Makefile            |    11 +
 drivers/net/ethernet/sfc/siena/bitfield.h          |   614 +
 drivers/net/ethernet/sfc/siena/efx.c               |  1325 ++
 drivers/net/ethernet/sfc/siena/efx.h               |   218 +
 drivers/net/ethernet/sfc/siena/efx_channels.c      |  1370 ++
 drivers/net/ethernet/sfc/siena/efx_channels.h      |    45 +
 drivers/net/ethernet/sfc/siena/efx_common.c        |  1408 ++
 drivers/net/ethernet/sfc/siena/efx_common.h        |   118 +
 drivers/net/ethernet/sfc/siena/enum.h              |   176 +
 drivers/net/ethernet/sfc/siena/ethtool.c           |   282 +
 drivers/net/ethernet/sfc/siena/ethtool_common.c    |  1340 ++
 drivers/net/ethernet/sfc/siena/ethtool_common.h    |    60 +
 drivers/net/ethernet/sfc/{ => siena}/farch.c       |    77 +-
 drivers/net/ethernet/sfc/siena/farch_regs.h        |  2929 +++
 drivers/net/ethernet/sfc/siena/filter.h            |   309 +
 drivers/net/ethernet/sfc/siena/io.h                |   310 +
 drivers/net/ethernet/sfc/siena/mcdi.c              |  2260 +++
 drivers/net/ethernet/sfc/siena/mcdi.h              |   386 +
 drivers/net/ethernet/sfc/siena/mcdi_mon.c          |   531 +
 drivers/net/ethernet/sfc/siena/mcdi_pcol.h         | 17204 ++++++++++++++++
 drivers/net/ethernet/sfc/siena/mcdi_port.c         |   110 +
 drivers/net/ethernet/sfc/siena/mcdi_port.h         |    17 +
 drivers/net/ethernet/sfc/siena/mcdi_port_common.c  |  1282 ++
 drivers/net/ethernet/sfc/siena/mcdi_port_common.h  |    58 +
 drivers/net/ethernet/sfc/siena/mtd.c               |   124 +
 drivers/net/ethernet/sfc/siena/net_driver.h        |  1715 ++
 drivers/net/ethernet/sfc/siena/nic.c               |   530 +
 drivers/net/ethernet/sfc/siena/nic.h               |   206 +
 drivers/net/ethernet/sfc/siena/nic_common.h        |   251 +
 drivers/net/ethernet/sfc/siena/ptp.c               |  2201 +++
 drivers/net/ethernet/sfc/siena/ptp.h               |    45 +
 drivers/net/ethernet/sfc/siena/rx.c                |   400 +
 drivers/net/ethernet/sfc/siena/rx_common.c         |  1094 ++
 drivers/net/ethernet/sfc/siena/rx_common.h         |   110 +
 drivers/net/ethernet/sfc/siena/selftest.c          |   807 +
 drivers/net/ethernet/sfc/siena/selftest.h          |    52 +
 drivers/net/ethernet/sfc/{ => siena}/siena.c       |   168 +-
 drivers/net/ethernet/sfc/{ => siena}/siena_sriov.c |    35 +-
 drivers/net/ethernet/sfc/{ => siena}/siena_sriov.h |     9 +-
 drivers/net/ethernet/sfc/siena/sriov.h             |    83 +
 drivers/net/ethernet/sfc/siena/tx.c                |   392 +
 drivers/net/ethernet/sfc/siena/tx.h                |    40 +
 drivers/net/ethernet/sfc/siena/tx_common.c         |   448 +
 drivers/net/ethernet/sfc/siena/tx_common.h         |    39 +
 drivers/net/ethernet/sfc/siena/vfdi.h              |   252 +
 drivers/net/ethernet/sfc/siena/workarounds.h       |    28 +
 drivers/net/ethernet/sfc/tx.c                      |     3 +-
 drivers/net/ethernet/sfc/tx_common.c               |     3 +-
 drivers/net/ethernet/smsc/smc911x.c                |     6 +-
 drivers/net/ethernet/smsc/smsc911x.c               |     3 +-
 drivers/net/ethernet/smsc/smsc9420.c               |     2 +-
 drivers/net/ethernet/smsc/smsc9420.h               |     1 -
 drivers/net/ethernet/socionext/sni_ave.c           |     3 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c    |     4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |     6 -
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |     6 -
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |     6 -
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |     4 -
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    |     6 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    27 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |    24 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |    13 +-
 drivers/net/ethernet/sun/cassini.c                 |     4 +-
 drivers/net/ethernet/sun/sungem.c                  |     1 -
 drivers/net/ethernet/sunplus/Kconfig               |    32 +
 drivers/net/ethernet/sunplus/Makefile              |     6 +
 drivers/net/ethernet/sunplus/spl2sw_define.h       |   270 +
 drivers/net/ethernet/sunplus/spl2sw_desc.c         |   228 +
 drivers/net/ethernet/sunplus/spl2sw_desc.h         |    19 +
 drivers/net/ethernet/sunplus/spl2sw_driver.c       |   565 +
 drivers/net/ethernet/sunplus/spl2sw_int.c          |   273 +
 drivers/net/ethernet/sunplus/spl2sw_int.h          |    13 +
 drivers/net/ethernet/sunplus/spl2sw_mac.c          |   274 +
 drivers/net/ethernet/sunplus/spl2sw_mac.h          |    18 +
 drivers/net/ethernet/sunplus/spl2sw_mdio.c         |   131 +
 drivers/net/ethernet/sunplus/spl2sw_mdio.h         |    12 +
 drivers/net/ethernet/sunplus/spl2sw_phy.c          |    92 +
 drivers/net/ethernet/sunplus/spl2sw_phy.h          |    12 +
 drivers/net/ethernet/sunplus/spl2sw_register.h     |    86 +
 drivers/net/ethernet/synopsys/dwc-xlgmac.h         |     3 +-
 drivers/net/ethernet/ti/Kconfig                    |     1 +
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c        |     6 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |    37 +-
 drivers/net/ethernet/ti/am65-cpsw-qos.c            |   193 +-
 drivers/net/ethernet/ti/am65-cpsw-qos.h            |     8 +
 drivers/net/ethernet/ti/cpsw.c                     |    45 +-
 drivers/net/ethernet/ti/cpsw_ale.c                 |    66 +
 drivers/net/ethernet/ti/cpsw_ale.h                 |     2 +
 drivers/net/ethernet/ti/cpsw_new.c                 |    46 +-
 drivers/net/ethernet/ti/cpsw_priv.c                |   235 +-
 drivers/net/ethernet/ti/cpsw_priv.h                |    10 +-
 drivers/net/ethernet/ti/davinci_emac.c             |    12 +-
 drivers/net/ethernet/ti/davinci_mdio.c             |    18 +-
 drivers/net/ethernet/ti/netcp_core.c               |     5 +-
 drivers/net/ethernet/toshiba/spider_net.c          |     3 +-
 drivers/net/ethernet/toshiba/spider_net.h          |     1 -
 drivers/net/ethernet/toshiba/tc35815.c             |     2 +-
 drivers/net/ethernet/via/via-velocity.c            |     3 +-
 drivers/net/ethernet/via/via-velocity.h            |     1 -
 drivers/net/ethernet/wiznet/w5100.c                |     2 +-
 drivers/net/ethernet/wiznet/w5300.c                |     2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |     2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |    54 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   168 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |    55 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |     2 +-
 drivers/net/ethernet/xscale/ptp_ixp46x.c           |     2 +-
 drivers/net/fddi/skfp/smt.c                        |     2 +-
 drivers/net/geneve.c                               |    10 +-
 drivers/net/hamradio/Kconfig                       |    34 -
 drivers/net/hamradio/Makefile                      |     1 -
 drivers/net/hamradio/dmascc.c                      |  1450 --
 drivers/net/hyperv/hyperv_net.h                    |    69 +-
 drivers/net/hyperv/netvsc.c                        |    16 +-
 drivers/net/hyperv/netvsc_bpf.c                    |   101 +-
 drivers/net/hyperv/netvsc_drv.c                    |   155 +-
 drivers/net/hyperv/rndis_filter.c                  |     4 +-
 drivers/net/ieee802154/Kconfig                     |     7 -
 drivers/net/ieee802154/at86rf230.c                 |   163 +-
 drivers/net/ieee802154/atusb.c                     |    37 +-
 drivers/net/ieee802154/ca8210.c                    |   181 +-
 drivers/net/ieee802154/mcr20a.c                    |     5 -
 drivers/net/ipa/gsi.c                              |    20 +-
 drivers/net/ipa/gsi.h                              |     1 -
 drivers/net/ipa/gsi_reg.h                          |     2 +-
 drivers/net/ipa/gsi_trans.c                        |    38 +-
 drivers/net/ipa/gsi_trans.h                        |    24 +-
 drivers/net/ipa/ipa.h                              |     2 +
 drivers/net/ipa/ipa_cmd.c                          |    78 +-
 drivers/net/ipa/ipa_cmd.h                          |    11 -
 drivers/net/ipa/ipa_data-v3.1.c                    |     2 +
 drivers/net/ipa/ipa_data-v3.5.1.c                  |     2 +
 drivers/net/ipa/ipa_data-v4.11.c                   |     2 +
 drivers/net/ipa/ipa_data-v4.2.c                    |     2 +
 drivers/net/ipa/ipa_data-v4.5.c                    |     2 +
 drivers/net/ipa/ipa_data-v4.9.c                    |     2 +
 drivers/net/ipa/ipa_data.h                         |    70 +-
 drivers/net/ipa/ipa_endpoint.c                     |   214 +-
 drivers/net/ipa/ipa_endpoint.h                     |    85 +-
 drivers/net/ipa/ipa_interrupt.c                    |     6 +-
 drivers/net/ipa/ipa_modem.c                        |    13 +-
 drivers/net/ipvlan/ipvlan_main.c                   |     6 +-
 drivers/net/loopback.c                             |     2 +
 drivers/net/macvlan.c                              |     9 +-
 drivers/net/mdio/mdio-aspeed.c                     |   138 +-
 drivers/net/mdio/mdio-mscc-miim.c                  |    81 +-
 drivers/net/netdevsim/fib.c                        |     9 +-
 drivers/net/netdevsim/ipsec.c                      |     2 +-
 drivers/net/pcs/pcs-xpcs.c                         |     6 +-
 drivers/net/phy/Kconfig                            |    13 +
 drivers/net/phy/Makefile                           |     2 +
 drivers/net/phy/adin.c                             |    40 +
 drivers/net/phy/adin1100.c                         |   292 +
 drivers/net/phy/bcm87xx.c                          |    36 +-
 drivers/net/phy/dp83822.c                          |     9 +-
 drivers/net/phy/dp83td510.c                        |   209 +
 drivers/net/phy/marvell.c                          |    53 +-
 drivers/net/phy/micrel.c                           |   269 +-
 drivers/net/phy/microchip.c                        |    10 +-
 drivers/net/phy/microchip_t1.c                     |    50 +
 drivers/net/phy/phy-c45.c                          |   297 +-
 drivers/net/phy/phy-core.c                         |     3 +-
 drivers/net/phy/phy.c                              |    18 +-
 drivers/net/phy/phy_device.c                       |    10 +-
 drivers/net/phy/phylink.c                          |    64 +-
 drivers/net/phy/smsc.c                             |    59 +-
 drivers/net/ppp/pppoe.c                            |     3 +-
 drivers/net/sungem_phy.c                           |     6 +-
 drivers/net/tun.c                                  |     3 +-
 drivers/net/usb/aqc111.c                           |     2 +-
 drivers/net/usb/asix_devices.c                     |     6 +-
 drivers/net/usb/ax88179_178a.c                     |     2 +-
 drivers/net/usb/cdc_ether.c                        |     3 +-
 drivers/net/usb/cdc_ncm.c                          |     8 +-
 drivers/net/usb/lan78xx.c                          |     6 +-
 drivers/net/usb/qmi_wwan.c                         |     3 +-
 drivers/net/usb/r8152.c                            |    41 +-
 drivers/net/usb/rndis_host.c                       |    47 +-
 drivers/net/usb/smsc95xx.c                         |   152 +-
 drivers/net/usb/sr9800.h                           |     2 +-
 drivers/net/usb/usbnet.c                           |     6 +-
 drivers/net/veth.c                                 |     6 +-
 drivers/net/virtio_net.c                           |     9 +-
 drivers/net/vxlan/vxlan_core.c                     |    43 +-
 drivers/net/wan/Kconfig                            |    72 -
 drivers/net/wan/Makefile                           |     5 -
 drivers/net/wan/cosa.c                             |  2052 --
 drivers/net/wan/cosa.h                             |   104 -
 drivers/net/wan/fsl_ucc_hdlc.c                     |     2 +-
 drivers/net/wan/hd64572.c                          |     3 +-
 drivers/net/wan/hostess_sv11.c                     |   336 -
 drivers/net/wan/ixp4xx_hss.c                       |     2 +-
 drivers/net/wan/lapbether.c                        |     2 +-
 drivers/net/wan/lmc/Makefile                       |    18 -
 drivers/net/wan/lmc/lmc.h                          |    33 -
 drivers/net/wan/lmc/lmc_debug.c                    |    65 -
 drivers/net/wan/lmc/lmc_debug.h                    |    52 -
 drivers/net/wan/lmc/lmc_ioctl.h                    |   255 -
 drivers/net/wan/lmc/lmc_main.c                     |  2009 --
 drivers/net/wan/lmc/lmc_media.c                    |  1206 --
 drivers/net/wan/lmc/lmc_proto.c                    |   106 -
 drivers/net/wan/lmc/lmc_proto.h                    |    18 -
 drivers/net/wan/lmc/lmc_var.h                      |   468 -
 drivers/net/wan/sealevel.c                         |   352 -
 drivers/net/wan/z85230.c                           |  1641 --
 drivers/net/wan/z85230.h                           |   407 -
 drivers/net/wireless/Kconfig                       |     2 +
 drivers/net/wireless/Makefile                      |     4 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |     7 +-
 drivers/net/wireless/ath/ath10k/ahb.c              |     9 +-
 drivers/net/wireless/ath/ath10k/core.c             |    38 +-
 drivers/net/wireless/ath/ath10k/core.h             |     3 -
 drivers/net/wireless/ath/ath10k/hw.h               |     2 +
 drivers/net/wireless/ath/ath10k/mac.c              |   106 +-
 drivers/net/wireless/ath/ath10k/pci.c              |     2 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |     2 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |     2 +-
 drivers/net/wireless/ath/ath10k/usb.c              |    27 +
 drivers/net/wireless/ath/ath11k/Makefile           |     3 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |   331 +-
 drivers/net/wireless/ath/ath11k/ahb.h              |     9 +
 drivers/net/wireless/ath/ath11k/ce.c               |     4 +-
 drivers/net/wireless/ath/ath11k/core.c             |   579 +-
 drivers/net/wireless/ath/ath11k/core.h             |   155 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |     4 +
 drivers/net/wireless/ath/ath11k/dp_tx.c            |     8 +-
 drivers/net/wireless/ath/ath11k/hal.c              |    15 +-
 drivers/net/wireless/ath/ath11k/hal.h              |    17 +-
 drivers/net/wireless/ath/ath11k/htc.c              |     6 +
 drivers/net/wireless/ath/ath11k/hw.c               |   209 +-
 drivers/net/wireless/ath/ath11k/hw.h               |    45 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   722 +-
 drivers/net/wireless/ath/ath11k/mac.h              |     5 +
 drivers/net/wireless/ath/ath11k/mhi.c              |   285 +-
 drivers/net/wireless/ath/ath11k/mhi.h              |    17 +-
 drivers/net/wireless/ath/ath11k/pci.c              |   984 +-
 drivers/net/wireless/ath/ath11k/pci.h              |    28 +-
 drivers/net/wireless/ath/ath11k/pcic.c             |   748 +
 drivers/net/wireless/ath/ath11k/pcic.h             |    46 +
 drivers/net/wireless/ath/ath11k/peer.c             |   373 +-
 drivers/net/wireless/ath/ath11k/peer.h             |    10 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   286 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |    28 +-
 drivers/net/wireless/ath/ath11k/reg.c              |     4 +
 drivers/net/wireless/ath/ath11k/spectral.c         |    17 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   856 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |   448 +-
 drivers/net/wireless/ath/ath11k/wow.c              |   797 +
 drivers/net/wireless/ath/ath11k/wow.h              |    45 +
 drivers/net/wireless/ath/ath6kl/Makefile           |     5 +
 drivers/net/wireless/ath/ath6kl/htc_mbox.c         |     2 +-
 drivers/net/wireless/ath/ath9k/Makefile            |     5 +
 drivers/net/wireless/ath/ath9k/ahb.c               |    10 +-
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |     9 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |     2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |    85 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |     2 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |     9 +-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c      |    10 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |    25 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |     2 +-
 drivers/net/wireless/ath/ath9k/debug_sta.c         |     4 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |     5 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |    20 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |     8 +
 drivers/net/wireless/ath/ath9k/mac.h               |     6 +-
 drivers/net/wireless/ath/ath9k/main.c              |     2 +-
 drivers/net/wireless/ath/ath9k/reg.h               |    10 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |     8 +-
 drivers/net/wireless/ath/carl9170/Makefile         |     5 +
 drivers/net/wireless/ath/carl9170/main.c           |     8 +-
 drivers/net/wireless/ath/carl9170/tx.c             |     8 +-
 drivers/net/wireless/ath/wcn36xx/hal.h             |     7 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   160 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |    98 +-
 drivers/net/wireless/ath/wcn36xx/smd.h             |     2 +
 drivers/net/wireless/ath/wcn36xx/txrx.c            |    29 +
 drivers/net/wireless/ath/wcn36xx/txrx.h            |     1 +
 drivers/net/wireless/ath/wil6210/cfg80211.c        |     5 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |    14 -
 drivers/net/wireless/ath/wil6210/netdev.c          |    14 +-
 drivers/net/wireless/ath/wil6210/pm.c              |     5 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |     1 -
 drivers/net/wireless/broadcom/b43/phy_n.c          |     2 +-
 drivers/net/wireless/broadcom/b43legacy/phy.c      |     2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    39 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |     3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |    23 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |     1 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |     4 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |     3 +
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |     2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |    64 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |   119 +-
 drivers/net/wireless/intel/ipw2x00/libipw_tx.c     |     2 +-
 drivers/net/wireless/intel/iwlegacy/3945-rs.c      |     6 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |    22 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |     6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |    22 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c      |     2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c       |     4 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |     3 +
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |     4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |     4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/filter.h |     2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |     4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |     2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h   |     2 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |     2 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |    10 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |     2 +
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |     3 +
 drivers/net/wireless/intel/iwlwifi/mei/sap.h       |     2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |    15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |    32 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |    55 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |     1 -
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |     3 +
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |    38 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |    35 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |    44 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |     8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    33 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |     6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |    48 +-
 drivers/net/wireless/intersil/orinoco/airport.c    |     1 +
 drivers/net/wireless/mac80211_hwsim.c              |     4 +-
 drivers/net/wireless/marvell/mwifiex/11h.c         |     2 +
 drivers/net/wireless/marvell/mwifiex/sdio.c        |    23 +-
 drivers/net/wireless/marvell/mwifiex/sdio.h        |     6 +
 drivers/net/wireless/marvell/mwl8k.c               |    48 +-
 drivers/net/wireless/mediatek/mt76/agg-rx.c        |     8 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   215 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |    14 +-
 drivers/net/wireless/mediatek/mt76/mcu.c           |     8 +-
 drivers/net/wireless/mediatek/mt76/mmio.c          |     9 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |    50 +-
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |     8 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |    12 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |    16 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |     8 +-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |    10 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |     8 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |     2 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |    90 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |     1 -
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |     4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |     8 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |    10 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   205 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |    61 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |     2 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   129 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   251 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |     2 +
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |    72 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   288 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |    39 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |    39 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |    26 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |    99 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |    61 +-
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    |    41 +-
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |     6 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |    15 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |    43 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   155 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   122 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    15 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |    10 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |     5 +
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |    62 +-
 .../net/wireless/mediatek/mt76/mt7921/usb_mac.c    |     7 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |    53 +-
 drivers/net/wireless/mediatek/mt7601u/mac.c        |     2 +-
 drivers/net/wireless/mediatek/mt7601u/tx.c         |     4 +-
 drivers/net/wireless/microchip/wilc1000/hif.h      |     2 +-
 drivers/net/wireless/microchip/wilc1000/mon.c      |     4 +-
 drivers/net/wireless/microchip/wilc1000/netdev.c   |     3 +-
 drivers/net/wireless/microchip/wilc1000/sdio.c     |     2 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |     7 +-
 drivers/net/wireless/purelifi/Kconfig              |    17 +
 drivers/net/wireless/purelifi/Makefile             |     2 +
 drivers/net/wireless/purelifi/plfxlc/Kconfig       |    14 +
 drivers/net/wireless/purelifi/plfxlc/Makefile      |     3 +
 drivers/net/wireless/purelifi/plfxlc/chip.c        |    98 +
 drivers/net/wireless/purelifi/plfxlc/chip.h        |    70 +
 drivers/net/wireless/purelifi/plfxlc/firmware.c    |   276 +
 drivers/net/wireless/purelifi/plfxlc/intf.h        |    52 +
 drivers/net/wireless/purelifi/plfxlc/mac.c         |   754 +
 drivers/net/wireless/purelifi/plfxlc/mac.h         |   184 +
 drivers/net/wireless/purelifi/plfxlc/usb.c         |   891 +
 drivers/net/wireless/purelifi/plfxlc/usb.h         |   198 +
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   |     4 +-
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   |     4 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |     8 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c   |     2 +-
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |     8 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   146 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |    44 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    |    16 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |    40 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |    15 +-
 drivers/net/wireless/realtek/rtlwifi/rc.c          |    20 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |    26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |     8 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |    26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |     6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |    30 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |     2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |    26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |     5 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |     4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |    12 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |     8 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |    26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.c   |     2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |    26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |     8 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |    12 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |     8 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |    30 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |     6 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |     2 +-
 drivers/net/wireless/realtek/rtw88/bf.c            |     2 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |    31 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |     4 +-
 drivers/net/wireless/realtek/rtw88/mac.c           |     2 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    44 +-
 drivers/net/wireless/realtek/rtw88/main.c          |    73 +-
 drivers/net/wireless/realtek/rtw88/main.h          |     8 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |    19 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |     2 +-
 drivers/net/wireless/realtek/rtw88/reg.h           |     2 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |     1 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |     5 +
 .../net/wireless/realtek/rtw88/rtw8821c_table.c    |     2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821ce.c     |     4 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |     1 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |     1 +
 drivers/net/wireless/realtek/rtw88/rx.c            |     3 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |    31 +-
 drivers/net/wireless/realtek/rtw88/tx.h            |     4 +
 drivers/net/wireless/realtek/rtw89/Kconfig         |    18 +-
 drivers/net/wireless/realtek/rtw89/Makefile        |     9 +
 drivers/net/wireless/realtek/rtw89/cam.c           |    57 +-
 drivers/net/wireless/realtek/rtw89/cam.h           |     4 +
 drivers/net/wireless/realtek/rtw89/coex.c          |    24 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   193 +-
 drivers/net/wireless/realtek/rtw89/core.h          |   295 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |    75 +-
 drivers/net/wireless/realtek/rtw89/debug.h         |     1 +
 drivers/net/wireless/realtek/rtw89/fw.c            |   301 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |   388 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   736 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |    82 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |    16 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   954 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |   389 +
 drivers/net/wireless/realtek/rtw89/phy.c           |   481 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |    76 +-
 drivers/net/wireless/realtek/rtw89/ps.c            |    34 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |  1907 +-
 drivers/net/wireless/realtek/rtw89/regd.c          |   513 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |    81 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c  |    16 +-
 .../net/wireless/realtek/rtw89/rtw8852a_table.c    |   605 +-
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c     |    40 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |  2561 ++-
 drivers/net/wireless/realtek/rtw89/rtw8852c.h      |    20 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c  |  4041 ++++
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.h  |    28 +
 .../wireless/realtek/rtw89/rtw8852c_rfk_table.c    |   781 +
 .../wireless/realtek/rtw89/rtw8852c_rfk_table.h    |    67 +
 .../net/wireless/realtek/rtw89/rtw8852c_table.c    | 19470 +++++++++++++++++++
 .../net/wireless/realtek/rtw89/rtw8852c_table.h    |    36 +
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c     |    48 +
 drivers/net/wireless/realtek/rtw89/ser.c           |   250 +-
 drivers/net/wireless/realtek/rtw89/txrx.h          |   107 +
 drivers/net/wireless/realtek/rtw89/util.h          |    30 +
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |    12 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |     8 +-
 drivers/net/wireless/silabs/Kconfig                |    18 +
 drivers/net/wireless/silabs/Makefile               |     3 +
 .../{staging => net/wireless/silabs}/wfx/Kconfig   |     0
 .../{staging => net/wireless/silabs}/wfx/Makefile  |     0
 drivers/{staging => net/wireless/silabs}/wfx/bh.c  |     6 +-
 drivers/{staging => net/wireless/silabs}/wfx/bh.h  |     0
 drivers/{staging => net/wireless/silabs}/wfx/bus.h |     0
 .../wireless/silabs}/wfx/bus_sdio.c                |     0
 .../{staging => net/wireless/silabs}/wfx/bus_spi.c |     0
 .../{staging => net/wireless/silabs}/wfx/data_rx.c |     5 +-
 .../{staging => net/wireless/silabs}/wfx/data_rx.h |     0
 .../{staging => net/wireless/silabs}/wfx/data_tx.c |     3 +-
 .../{staging => net/wireless/silabs}/wfx/data_tx.h |     0
 .../{staging => net/wireless/silabs}/wfx/debug.c   |     0
 .../{staging => net/wireless/silabs}/wfx/debug.h   |     0
 .../{staging => net/wireless/silabs}/wfx/fwio.c    |     0
 .../{staging => net/wireless/silabs}/wfx/fwio.h    |     0
 .../wireless/silabs}/wfx/hif_api_cmd.h             |     0
 .../wireless/silabs}/wfx/hif_api_general.h         |     0
 .../wireless/silabs}/wfx/hif_api_mib.h             |     0
 .../{staging => net/wireless/silabs}/wfx/hif_rx.c  |     0
 .../{staging => net/wireless/silabs}/wfx/hif_rx.h  |     0
 .../{staging => net/wireless/silabs}/wfx/hif_tx.c  |     2 +-
 .../{staging => net/wireless/silabs}/wfx/hif_tx.h  |     0
 .../wireless/silabs}/wfx/hif_tx_mib.c              |     0
 .../wireless/silabs}/wfx/hif_tx_mib.h              |     0
 .../{staging => net/wireless/silabs}/wfx/hwio.c    |     0
 .../{staging => net/wireless/silabs}/wfx/hwio.h    |     0
 drivers/{staging => net/wireless/silabs}/wfx/key.c |     4 +-
 drivers/{staging => net/wireless/silabs}/wfx/key.h |     0
 .../{staging => net/wireless/silabs}/wfx/main.c    |     6 +
 .../{staging => net/wireless/silabs}/wfx/main.h    |     0
 .../{staging => net/wireless/silabs}/wfx/queue.c   |     3 +-
 .../{staging => net/wireless/silabs}/wfx/queue.h   |     0
 .../{staging => net/wireless/silabs}/wfx/scan.c    |    11 +-
 .../{staging => net/wireless/silabs}/wfx/scan.h    |     0
 drivers/{staging => net/wireless/silabs}/wfx/sta.c |    84 +-
 drivers/{staging => net/wireless/silabs}/wfx/sta.h |     0
 .../{staging => net/wireless/silabs}/wfx/traces.h  |     0
 drivers/{staging => net/wireless/silabs}/wfx/wfx.h |     7 +-
 drivers/net/wireless/st/cw1200/sta.c               |     4 +-
 drivers/net/wireless/ti/wl1251/event.c             |    22 +-
 drivers/net/wireless/ti/wl1251/io.c                |    20 +-
 drivers/net/wireless/ti/wl1251/tx.c                |    15 +-
 drivers/net/wireless/ti/wl18xx/debugfs.c           |    18 +-
 drivers/net/wireless/ti/wlcore/cmd.c               |    14 +-
 drivers/net/wireless/ti/wlcore/debugfs.c           |    52 +-
 drivers/net/wireless/ti/wlcore/main.c              |   241 +-
 drivers/net/wireless/ti/wlcore/scan.c              |     6 +-
 drivers/net/wireless/ti/wlcore/sdio.c              |     3 +-
 drivers/net/wireless/ti/wlcore/sysfs.c             |     6 +-
 drivers/net/wireless/ti/wlcore/testmode.c          |    12 +-
 drivers/net/wireless/ti/wlcore/tx.c                |     6 +-
 drivers/net/wireless/ti/wlcore/vendor_cmd.c        |    18 +-
 drivers/net/wwan/Kconfig                           |    14 +
 drivers/net/wwan/Makefile                          |     1 +
 drivers/net/wwan/iosm/iosm_ipc_coredump.h          |     5 +-
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c      |    10 -
 drivers/net/wwan/t7xx/Makefile                     |    20 +
 drivers/net/wwan/t7xx/t7xx_cldma.c                 |   281 +
 drivers/net/wwan/t7xx/t7xx_cldma.h                 |   180 +
 drivers/net/wwan/t7xx/t7xx_dpmaif.c                |  1281 ++
 drivers/net/wwan/t7xx/t7xx_dpmaif.h                |   179 +
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c             |  1339 ++
 drivers/net/wwan/t7xx/t7xx_hif_cldma.h             |   127 +
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c            |   574 +
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h            |   206 +
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c         |  1243 ++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h         |   116 +
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c         |   683 +
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.h         |    78 +
 drivers/net/wwan/t7xx/t7xx_mhccif.c                |   122 +
 drivers/net/wwan/t7xx/t7xx_mhccif.h                |    37 +
 drivers/net/wwan/t7xx/t7xx_modem_ops.c             |   727 +
 drivers/net/wwan/t7xx/t7xx_modem_ops.h             |    88 +
 drivers/net/wwan/t7xx/t7xx_netdev.c                |   423 +
 drivers/net/wwan/t7xx/t7xx_netdev.h                |    55 +
 drivers/net/wwan/t7xx/t7xx_pci.c                   |   761 +
 drivers/net/wwan/t7xx/t7xx_pci.h                   |   120 +
 drivers/net/wwan/t7xx/t7xx_pcie_mac.c              |   262 +
 drivers/net/wwan/t7xx/t7xx_pcie_mac.h              |    31 +
 drivers/net/wwan/t7xx/t7xx_port.h                  |   135 +
 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c         |   273 +
 drivers/net/wwan/t7xx/t7xx_port_proxy.c            |   509 +
 drivers/net/wwan/t7xx/t7xx_port_proxy.h            |    98 +
 drivers/net/wwan/t7xx/t7xx_port_wwan.c             |   176 +
 drivers/net/wwan/t7xx/t7xx_reg.h                   |   350 +
 drivers/net/wwan/t7xx/t7xx_state_monitor.c         |   550 +
 drivers/net/wwan/t7xx/t7xx_state_monitor.h         |   135 +
 drivers/net/wwan/wwan_hwsim.c                      |    22 +-
 drivers/net/xen-netback/interface.c                |     3 +-
 drivers/nfc/st21nfca/se.c                          |    17 +-
 drivers/nfc/st21nfca/st21nfca.h                    |     1 +
 drivers/ptp/ptp_clock.c                            |    31 +-
 drivers/ptp/ptp_clockmatrix.c                      |   321 +-
 drivers/ptp/ptp_clockmatrix.h                      |     7 +-
 drivers/ptp/ptp_ocp.c                              |   559 +-
 drivers/ptp/ptp_private.h                          |    11 +
 drivers/ptp/ptp_sysfs.c                            |    11 +-
 drivers/ptp/ptp_vclock.c                           |    82 +-
 drivers/s390/net/qeth_core.h                       |     2 -
 drivers/s390/net/qeth_core_main.c                  |     3 +-
 drivers/s390/net/qeth_l2_main.c                    |     4 +-
 drivers/s390/net/qeth_l3_main.c                    |     4 +-
 drivers/scsi/fcoe/fcoe.c                           |     2 +-
 drivers/ssb/pci.c                                  |     1 -
 drivers/staging/Kconfig                            |     1 -
 drivers/staging/Makefile                           |     1 -
 drivers/staging/wfx/TODO                           |     6 -
 fs/afs/misc.c                                      |     5 +-
 fs/afs/rotate.c                                    |     4 +
 fs/afs/rxrpc.c                                     |     8 +-
 fs/afs/write.c                                     |     1 +
 fs/proc/proc_sysctl.c                              |     4 +-
 fs/seq_file.c                                      |    32 +
 include/linux/bpf-cgroup.h                         |     8 +-
 include/linux/bpf.h                                |   351 +-
 include/linux/bpf_local_storage.h                  |     4 +-
 include/linux/bpf_types.h                          |     1 +
 include/linux/bpf_verifier.h                       |    23 +-
 include/linux/btf.h                                |    23 +
 include/linux/btf_ids.h                            |     3 +-
 include/linux/can/dev.h                            |    10 -
 include/linux/can/led.h                            |    51 -
 include/linux/can/rx-offload.h                     |     4 +-
 include/linux/ethtool.h                            |     4 +
 include/linux/fortify-string.h                     |    16 +
 include/linux/ftrace.h                             |     6 +
 include/linux/icmpv6.h                             |    11 +-
 include/linux/ieee802154.h                         |    81 +-
 include/linux/ipv6.h                               |     6 +-
 include/linux/kallsyms.h                           |     7 +-
 include/linux/list.h                               |    36 +
 include/linux/mdio.h                               |    70 +
 include/linux/mfd/idt8a340_reg.h                   |    12 +-
 include/linux/mlx5/accel.h                         |   156 -
 include/linux/mlx5/driver.h                        |    17 +-
 include/linux/mlx5/fs.h                            |    12 +
 include/linux/mlx5/mlx5_ifc.h                      |    23 +-
 include/linux/mlx5/mlx5_ifc_fpga.h                 |   211 -
 include/linux/mlx5/port.h                          |     2 +-
 include/linux/netdevice.h                          |   378 +-
 include/linux/phy.h                                |     8 +-
 include/linux/phylink.h                            |     6 -
 include/linux/ptp_classify.h                       |     3 +
 include/linux/ptp_clock_kernel.h                   |    42 +-
 include/linux/qed/qed_fcoe_if.h                    |     4 +-
 include/linux/qed/qed_iscsi_if.h                   |     4 +-
 include/linux/qed/qed_nvmetcp_if.h                 |     2 +-
 include/linux/qed/qed_nvmetcp_ip_services_if.h     |    29 -
 include/linux/rtnetlink.h                          |     1 +
 include/linux/seq_file.h                           |     4 +
 include/linux/skbuff.h                             |   419 +-
 include/linux/soc/mediatek/mtk_wed.h               |   131 +
 include/linux/socket.h                             |     6 +-
 include/linux/string.h                             |     4 +
 include/linux/sysctl.h                             |     9 +-
 include/linux/usb/rndis_host.h                     |     1 +
 include/linux/usb/usbnet.h                         |     1 +
 include/net/act_api.h                              |     3 +-
 include/net/bluetooth/hci.h                        |    10 +
 include/net/bluetooth/hci_core.h                   |     8 +-
 include/net/cfg80211.h                             |    16 +-
 include/net/cfg802154.h                            |     8 +-
 include/net/devlink.h                              |    48 +
 include/net/dsa.h                                  |    25 +-
 include/net/flow_dissector.h                       |     9 +
 include/net/if_inet6.h                             |     8 +
 include/net/inet6_hashtables.h                     |    28 +-
 include/net/inet_connection_sock.h                 |     5 +-
 include/net/inet_hashtables.h                      |   145 +-
 include/net/inet_sock.h                            |     5 +-
 include/net/ip.h                                   |     2 +-
 include/net/ip_fib.h                               |     4 +-
 include/net/ipv6.h                                 |    44 +
 include/net/mac80211.h                             |   126 +-
 include/net/mac802154.h                            |    19 +
 include/net/mptcp.h                                |    11 +-
 include/net/net_debug.h                            |   157 +
 include/net/netfilter/nf_conntrack.h               |    23 +-
 include/net/netfilter/nf_conntrack_core.h          |     2 +-
 include/net/netfilter/nf_conntrack_count.h         |     1 +
 include/net/netfilter/nf_conntrack_ecache.h        |    53 +-
 include/net/netfilter/nf_conntrack_extend.h        |    31 +-
 include/net/netfilter/nf_conntrack_labels.h        |    10 +-
 include/net/netfilter/nf_conntrack_timeout.h       |     8 -
 include/net/netfilter/nf_reject.h                  |    21 +-
 include/net/netns/conntrack.h                      |     8 +-
 include/net/page_pool.h                            |    21 +
 include/net/ping.h                                 |     4 +-
 include/net/pkt_cls.h                              |     6 +-
 include/net/route.h                                |    36 +-
 include/net/rtnetlink.h                            |    16 +-
 include/net/sctp/sctp.h                            |     2 +-
 include/net/sock.h                                 |    64 +-
 include/net/strparser.h                            |     4 +
 include/net/tc_act/tc_gact.h                       |    15 +
 include/net/tc_act/tc_skbedit.h                    |    13 +
 include/net/tcp.h                                  |    45 +-
 include/net/tls.h                                  |    16 +-
 include/net/udp.h                                  |     8 +-
 include/net/xfrm.h                                 |    20 +-
 include/rdma/ib_verbs.h                            |     8 -
 include/soc/mscc/ocelot.h                          |    42 +-
 include/soc/mscc/ocelot_vcap.h                     |     2 +-
 include/trace/events/mptcp.h                       |     6 +-
 include/trace/events/rxrpc.h                       |   265 +-
 include/trace/events/skb.h                         |    21 +-
 include/trace/events/tcp.h                         |    47 +-
 include/uapi/asm-generic/socket.h                  |     2 +
 include/uapi/linux/atm_zatm.h                      |    47 -
 include/uapi/linux/bpf.h                           |   125 +
 include/uapi/linux/btf.h                           |     4 +-
 include/uapi/linux/can/isotp.h                     |    25 +-
 include/uapi/linux/devlink.h                       |    23 +
 include/uapi/linux/ethtool.h                       |     1 +
 include/uapi/linux/ethtool_netlink.h               |     1 +
 include/uapi/linux/if_link.h                       |     7 +
 include/uapi/linux/ipv6.h                          |     1 +
 include/uapi/linux/mdio.h                          |    75 +
 include/uapi/linux/mptcp.h                         |     8 +
 include/uapi/linux/neighbour.h                     |     2 +
 include/uapi/linux/netlink.h                       |     1 +
 include/uapi/linux/nl80211.h                       |     2 +
 include/uapi/linux/pkt_cls.h                       |     2 +
 include/uapi/linux/tc_act/tc_skbedit.h             |     2 +
 include/uapi/linux/tipc_config.h                   |    28 +-
 include/uapi/linux/tls.h                           |     2 +
 kernel/bpf/Makefile                                |     2 +-
 kernel/bpf/arraymap.c                              |    61 +-
 kernel/bpf/bloom_filter.c                          |     6 +-
 kernel/bpf/bpf_inode_storage.c                     |    10 +-
 kernel/bpf/bpf_iter.c                              |    32 +-
 kernel/bpf/bpf_local_storage.c                     |    29 +-
 kernel/bpf/bpf_lsm.c                               |    17 +
 kernel/bpf/bpf_struct_ops.c                        |    81 +-
 kernel/bpf/bpf_task_storage.c                      |     9 +-
 kernel/bpf/btf.c                                   |   640 +-
 kernel/bpf/cgroup.c                                |   106 +-
 kernel/bpf/core.c                                  |    29 +-
 kernel/bpf/cpumap.c                                |     6 +-
 kernel/bpf/devmap.c                                |    10 +-
 kernel/bpf/hashtab.c                               |   133 +-
 kernel/bpf/helpers.c                               |   223 +-
 kernel/bpf/link_iter.c                             |   107 +
 kernel/bpf/local_storage.c                         |     7 +-
 kernel/bpf/lpm_trie.c                              |     6 +-
 kernel/bpf/map_in_map.c                            |     5 +-
 kernel/bpf/queue_stack_maps.c                      |    10 +-
 kernel/bpf/reuseport_array.c                       |     6 +-
 kernel/bpf/ringbuf.c                               |    88 +-
 kernel/bpf/stackmap.c                              |     7 +-
 kernel/bpf/syscall.c                               |   500 +-
 kernel/bpf/task_iter.c                             |     1 -
 kernel/bpf/trampoline.c                            |   118 +-
 kernel/bpf/verifier.c                              |   819 +-
 kernel/kallsyms.c                                  |     3 +-
 kernel/sysctl.c                                    |    79 -
 kernel/trace/bpf_trace.c                           |   144 +-
 kernel/trace/fprobe.c                              |    32 +-
 kernel/trace/ftrace.c                              |    62 +
 lib/test_bpf.c                                     |   315 +-
 lib/test_sysctl.c                                  |    32 +
 net/8021q/vlan.c                                   |     3 +-
 net/8021q/vlan_dev.c                               |     3 +-
 net/Kconfig.debug                                  |     7 +
 net/appletalk/ddp.c                                |     3 +-
 net/atm/common.c                                   |     4 +-
 net/ax25/af_ax25.c                                 |     3 +-
 net/ax25/ax25_dev.c                                |    22 +-
 net/batman-adv/bridge_loop_avoidance.c             |     4 +-
 net/batman-adv/hard-interface.c                    |     2 +
 net/batman-adv/main.h                              |     2 +-
 net/batman-adv/translation-table.c                 |    12 +-
 net/bluetooth/af_bluetooth.c                       |     7 +-
 net/bluetooth/eir.c                                |    31 +
 net/bluetooth/eir.h                                |     4 +
 net/bluetooth/hci_conn.c                           |     7 +-
 net/bluetooth/hci_core.c                           |     2 -
 net/bluetooth/hci_event.c                          |    35 +-
 net/bluetooth/hci_request.c                        |     4 +-
 net/bluetooth/hci_sock.c                           |     3 +-
 net/bluetooth/hci_sync.c                           |    90 +-
 net/bluetooth/mgmt.c                               |    18 +
 net/bluetooth/mgmt_util.c                          |     2 +-
 net/bluetooth/sco.c                                |    23 +-
 net/bpf/bpf_dummy_struct_ops.c                     |    24 +-
 net/bpf/test_run.c                                 |    86 +-
 net/bridge/br_device.c                             |     1 +
 net/bridge/br_fdb.c                                |   160 +-
 net/bridge/br_if.c                                 |    12 +-
 net/bridge/br_mdb.c                                |    12 +-
 net/bridge/br_netlink.c                            |     9 +-
 net/bridge/br_private.h                            |    21 +-
 net/bridge/br_switchdev.c                          |     3 +-
 net/bridge/br_sysfs_br.c                           |     6 +-
 net/caif/caif_socket.c                             |     2 +-
 net/can/bcm.c                                      |     7 +-
 net/can/isotp.c                                    |   130 +-
 net/can/j1939/socket.c                             |     4 +-
 net/can/raw.c                                      |    20 +-
 net/core/bpf_sk_storage.c                          |    11 +-
 net/core/datagram.c                                |     7 +-
 net/core/datagram.h                                |    15 -
 net/core/dev.c                                     |   232 +-
 net/core/dev.h                                     |   112 +
 net/core/dev_addr_lists.c                          |     2 +
 net/core/dev_ioctl.c                               |     2 +
 net/core/devlink.c                                 |   653 +-
 net/core/drop_monitor.c                            |     2 +-
 net/core/filter.c                                  |    37 +-
 net/core/flow_dissector.c                          |    20 +
 net/core/gro.c                                     |     8 +
 net/core/link_watch.c                              |     1 +
 net/core/neighbour.c                               |     2 +-
 net/core/net-procfs.c                              |     2 +
 net/core/net-sysfs.c                               |    22 +-
 net/core/page_pool.c                               |    83 +-
 net/core/rtnetlink.c                               |   449 +-
 net/core/skbuff.c                                  |    67 +-
 net/core/skmsg.c                                   |    22 +-
 net/core/sock.c                                    |   126 +-
 net/core/sock_map.c                                |    10 +-
 net/core/sysctl_net_core.c                         |    29 +-
 net/dccp/dccp.h                                    |     4 +-
 net/dccp/ipv4.c                                    |     7 +-
 net/dccp/ipv6.c                                    |     6 +-
 net/dccp/proto.c                                   |    40 +-
 net/decnet/dn_route.c                              |     2 +-
 net/dsa/dsa.c                                      |    49 -
 net/dsa/dsa2.c                                     |    25 +-
 net/dsa/dsa_priv.h                                 |    29 +-
 net/dsa/port.c                                     |   136 +-
 net/dsa/slave.c                                    |    67 +-
 net/dsa/switch.c                                   |   198 +-
 net/dsa/tag_8021q.c                                |    10 +-
 net/ethernet/eth.c                                 |     2 +-
 net/ethtool/common.c                               |     3 +
 net/ethtool/netlink.h                              |     2 +-
 net/ethtool/rings.c                                |    54 +-
 net/ieee802154/socket.c                            |    12 +-
 net/ipv4/Kconfig                                   |     1 -
 net/ipv4/af_inet.c                                 |    11 +-
 net/ipv4/arp.c                                     |     7 +-
 net/ipv4/datagram.c                                |     7 +-
 net/ipv4/devinet.c                                 |     2 +-
 net/ipv4/esp4.c                                    |     6 -
 net/ipv4/fib_frontend.c                            |     4 +-
 net/ipv4/fib_rules.c                               |     2 +-
 net/ipv4/fib_semantics.c                           |     4 +-
 net/ipv4/fib_trie.c                                |    12 +-
 net/ipv4/fou.c                                     |     1 -
 net/ipv4/icmp.c                                    |    77 +-
 net/ipv4/igmp.c                                    |     4 +-
 net/ipv4/inet_connection_sock.c                    |   245 +-
 net/ipv4/inet_diag.c                               |     5 +-
 net/ipv4/inet_fragment.c                           |     2 +-
 net/ipv4/inet_hashtables.c                         |   329 +-
 net/ipv4/ip_forward.c                              |    13 +-
 net/ipv4/ip_gre.c                                  |    50 +-
 net/ipv4/ip_input.c                                |     1 +
 net/ipv4/ipmr.c                                    |     2 +-
 net/ipv4/netfilter.c                               |     3 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |    10 +-
 net/ipv4/netfilter/nft_fib_ipv4.c                  |     4 +
 net/ipv4/ping.c                                    |    40 +-
 net/ipv4/raw.c                                     |     6 +-
 net/ipv4/route.c                                   |    51 +-
 net/ipv4/sysctl_net_ipv4.c                         |    16 +-
 net/ipv4/tcp.c                                     |    83 +-
 net/ipv4/tcp_bbr.c                                 |    22 +-
 net/ipv4/tcp_bic.c                                 |    14 +-
 net/ipv4/tcp_bpf.c                                 |    15 +-
 net/ipv4/tcp_cdg.c                                 |    30 +-
 net/ipv4/tcp_cong.c                                |    30 +-
 net/ipv4/tcp_cubic.c                               |    26 +-
 net/ipv4/tcp_dctcp.c                               |    11 +-
 net/ipv4/tcp_highspeed.c                           |    18 +-
 net/ipv4/tcp_htcp.c                                |    10 +-
 net/ipv4/tcp_hybla.c                               |    18 +-
 net/ipv4/tcp_illinois.c                            |    12 +-
 net/ipv4/tcp_input.c                               |   177 +-
 net/ipv4/tcp_ipv4.c                                |    30 +-
 net/ipv4/tcp_lp.c                                  |     6 +-
 net/ipv4/tcp_metrics.c                             |    12 +-
 net/ipv4/tcp_nv.c                                  |    24 +-
 net/ipv4/tcp_output.c                              |    46 +-
 net/ipv4/tcp_rate.c                                |     2 +-
 net/ipv4/tcp_recovery.c                            |    15 +-
 net/ipv4/tcp_scalable.c                            |     4 +-
 net/ipv4/tcp_vegas.c                               |    21 +-
 net/ipv4/tcp_veno.c                                |    24 +-
 net/ipv4/tcp_westwood.c                            |     3 +-
 net/ipv4/tcp_yeah.c                                |    30 +-
 net/ipv4/udp.c                                     |    16 +-
 net/ipv4/udp_bpf.c                                 |    17 +-
 net/ipv4/udp_impl.h                                |     4 +-
 net/ipv6/addrconf.c                                |    51 +-
 net/ipv6/af_inet6.c                                |     7 +-
 net/ipv6/datagram.c                                |    10 +-
 net/ipv6/esp6.c                                    |     6 -
 net/ipv6/exthdrs.c                                 |    44 +-
 net/ipv6/icmp.c                                    |    31 +-
 net/ipv6/inet6_hashtables.c                        |    11 +-
 net/ipv6/ip6_gre.c                                 |    34 +-
 net/ipv6/ip6_input.c                               |    41 +-
 net/ipv6/ip6_offload.c                             |    56 +-
 net/ipv6/ip6_output.c                              |    56 +-
 net/ipv6/ip6_tunnel.c                              |     2 -
 net/ipv6/ndisc.c                                   |    20 +-
 net/ipv6/netfilter.c                               |     3 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |     4 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |     4 +
 net/ipv6/raw.c                                     |     6 +-
 net/ipv6/route.c                                   |     6 +-
 net/ipv6/sysctl_net_ipv6.c                         |     6 +-
 net/ipv6/tcp_ipv6.c                                |     6 +-
 net/ipv6/udp.c                                     |    23 +-
 net/ipv6/udp_impl.h                                |     4 +-
 net/iucv/af_iucv.c                                 |     3 +-
 net/key/af_key.c                                   |     4 +-
 net/l2tp/l2tp_ip.c                                 |     8 +-
 net/l2tp/l2tp_ip6.c                                |    12 +-
 net/l2tp/l2tp_ppp.c                                |     3 +-
 net/mac80211/agg-rx.c                              |    12 +-
 net/mac80211/agg-tx.c                              |     6 +-
 net/mac80211/airtime.c                             |     4 +-
 net/mac80211/cfg.c                                 |    81 +-
 net/mac80211/chan.c                                |     8 +-
 net/mac80211/debugfs.c                             |     1 +
 net/mac80211/debugfs_netdev.c                      |     2 +-
 net/mac80211/debugfs_sta.c                         |    12 +-
 net/mac80211/eht.c                                 |     6 +-
 net/mac80211/ethtool.c                             |     4 +-
 net/mac80211/he.c                                  |     8 +-
 net/mac80211/ht.c                                  |     8 +-
 net/mac80211/ibss.c                                |    26 +-
 net/mac80211/ieee80211_i.h                         |    12 +-
 net/mac80211/key.c                                 |     9 +-
 net/mac80211/main.c                                |     4 +-
 net/mac80211/mesh_hwmp.c                           |     2 +-
 net/mac80211/mesh_plink.c                          |    24 +-
 net/mac80211/mlme.c                                |   135 +-
 net/mac80211/ocb.c                                 |     2 +-
 net/mac80211/offchannel.c                          |     2 +-
 net/mac80211/rate.c                                |     8 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   177 +-
 net/mac80211/rc80211_minstrel_ht.h                 |     2 +-
 net/mac80211/rx.c                                  |   131 +-
 net/mac80211/s1g.c                                 |     4 +-
 net/mac80211/scan.c                                |    20 +
 net/mac80211/sta_info.c                            |   110 +-
 net/mac80211/sta_info.h                            |   155 +-
 net/mac80211/status.c                              |   130 +-
 net/mac80211/tdls.c                                |    26 +-
 net/mac80211/trace.h                               |     4 +-
 net/mac80211/tx.c                                  |    28 +-
 net/mac80211/util.c                                |    40 -
 net/mac80211/vht.c                                 |    78 +-
 net/mac80211/wpa.c                                 |   103 +-
 net/mac802154/cfg.c                                |     1 +
 net/mac802154/ieee802154_i.h                       |     2 +
 net/mac802154/main.c                               |    54 +-
 net/mac802154/util.c                               |    22 +-
 net/mctp/af_mctp.c                                 |     4 +-
 net/mctp/test/route-test.c                         |     8 +-
 net/mpls/af_mpls.c                                 |     3 +-
 net/mptcp/Makefile                                 |     4 +-
 net/mptcp/bpf.c                                    |    21 +
 net/mptcp/ctrl.c                                   |    21 +
 net/mptcp/mib.c                                    |     5 +
 net/mptcp/mib.h                                    |     7 +
 net/mptcp/mptcp_diag.c                             |   105 +-
 net/mptcp/options.c                                |    69 +-
 net/mptcp/pm.c                                     |   108 +-
 net/mptcp/pm_netlink.c                             |   266 +-
 net/mptcp/pm_userspace.c                           |   429 +
 net/mptcp/protocol.c                               |   123 +-
 net/mptcp/protocol.h                               |   101 +-
 net/mptcp/sockopt.c                                |    21 +-
 net/mptcp/subflow.c                                |    72 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |     4 +-
 net/netfilter/nf_conncount.c                       |    11 +
 net/netfilter/nf_conntrack_bpf.c                   |    22 +-
 net/netfilter/nf_conntrack_core.c                  |   304 +-
 net/netfilter/nf_conntrack_ecache.c                |   178 +-
 net/netfilter/nf_conntrack_extend.c                |    32 +-
 net/netfilter/nf_conntrack_helper.c                |     5 -
 net/netfilter/nf_conntrack_netlink.c               |   152 +-
 net/netfilter/nf_conntrack_proto.c                 |    10 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |    52 +-
 net/netfilter/nf_conntrack_standalone.c            |     2 +-
 net/netfilter/nf_conntrack_timeout.c               |     7 +-
 net/netfilter/nf_log_syslog.c                      |   136 +-
 net/netfilter/nf_nat_masquerade.c                  |     5 +-
 net/netfilter/nf_tables_api.c                      |     6 +-
 net/netfilter/nfnetlink.c                          |    40 +-
 net/netfilter/nfnetlink_cttimeout.c                |    61 +-
 net/netfilter/nft_bitwise.c                        |    13 +-
 net/netfilter/nft_fib.c                            |     4 +
 net/netfilter/nft_flow_offload.c                   |     8 +
 net/netlink/af_netlink.c                           |     3 +-
 net/netrom/af_netrom.c                             |     3 +-
 net/nfc/core.c                                     |     1 +
 net/nfc/llcp_sock.c                                |     3 +-
 net/nfc/rawsock.c                                  |     3 +-
 net/packet/af_packet.c                             |    22 +-
 net/phonet/datagram.c                              |     4 +-
 net/phonet/pep.c                                   |     7 +-
 net/qrtr/af_qrtr.c                                 |     3 +-
 net/rose/af_rose.c                                 |     3 +-
 net/rose/rose_route.c                              |    25 +-
 net/rxrpc/af_rxrpc.c                               |     2 +-
 net/rxrpc/ar-internal.h                            |    38 +-
 net/rxrpc/call_accept.c                            |    10 +-
 net/rxrpc/call_event.c                             |     7 +-
 net/rxrpc/call_object.c                            |    62 +-
 net/rxrpc/conn_client.c                            |    30 +-
 net/rxrpc/conn_object.c                            |    51 +-
 net/rxrpc/conn_service.c                           |     8 +-
 net/rxrpc/input.c                                  |    62 +-
 net/rxrpc/local_object.c                           |    68 +-
 net/rxrpc/net_ns.c                                 |     7 +-
 net/rxrpc/output.c                                 |    20 +-
 net/rxrpc/peer_object.c                            |    40 +-
 net/rxrpc/proc.c                                   |    85 +-
 net/rxrpc/recvmsg.c                                |     8 +-
 net/rxrpc/sendmsg.c                                |     6 +
 net/rxrpc/skbuff.c                                 |     1 -
 net/rxrpc/sysctl.c                                 |     4 +-
 net/sched/act_api.c                                |     4 +-
 net/sched/act_csum.c                               |     3 +-
 net/sched/act_ct.c                                 |     3 +-
 net/sched/act_gact.c                               |    13 +-
 net/sched/act_gate.c                               |     3 +-
 net/sched/act_mirred.c                             |     4 +-
 net/sched/act_mpls.c                               |    10 +-
 net/sched/act_pedit.c                              |     4 +-
 net/sched/act_police.c                             |    20 +-
 net/sched/act_sample.c                             |     3 +-
 net/sched/act_skbedit.c                            |    65 +-
 net/sched/act_tunnel_key.c                         |     4 +-
 net/sched/act_vlan.c                               |     4 +-
 net/sched/cls_api.c                                |    22 +-
 net/sched/cls_flower.c                             |   104 +-
 net/sched/cls_matchall.c                           |    19 +-
 net/sched/em_meta.c                                |     7 +-
 net/sched/sch_generic.c                            |    12 +-
 net/sctp/input.c                                   |     4 +-
 net/sctp/ipv6.c                                    |     4 +-
 net/sctp/output.c                                  |     3 +-
 net/sctp/socket.c                                  |    18 +-
 net/sctp/stream_sched.c                            |     9 +-
 net/sctp/ulpevent.c                                |     2 +-
 net/smc/af_smc.c                                   |    52 +-
 net/smc/smc_ib.c                                   |     1 +
 net/smc/smc_tx.c                                   |    17 +-
 net/smc/smc_wr.c                                   |     5 +-
 net/socket.c                                       |    75 +-
 net/sunrpc/svcsock.c                               |     2 +-
 net/sunrpc/xprtsock.c                              |     2 +-
 net/tls/tls_device.c                               |    59 +-
 net/tls/tls_main.c                                 |    55 +
 net/tls/tls_sw.c                                   |   491 +-
 net/unix/af_unix.c                                 |    11 +-
 net/unix/unix_bpf.c                                |     5 +-
 net/vmw_vsock/virtio_transport.c                   |   197 +-
 net/vmw_vsock/vmci_transport.c                     |     5 +-
 net/wireless/chan.c                                |    93 +-
 net/wireless/core.h                                |    14 +-
 net/wireless/ibss.c                                |     4 +-
 net/wireless/nl80211.c                             |   417 +-
 net/wireless/reg.c                                 |     4 +
 net/x25/af_x25.c                                   |     3 +-
 net/x25/x25_proc.c                                 |     3 +-
 net/xdp/xsk.c                                      |     4 +-
 net/xdp/xsk_queue.h                                |     4 +-
 net/xdp/xskmap.c                                   |     6 +-
 net/xfrm/espintcp.c                                |     4 +-
 net/xfrm/xfrm_device.c                             |    15 +-
 net/xfrm/xfrm_state.c                              |     4 +-
 net/xfrm/xfrm_user.c                               |     5 +-
 samples/bpf/Makefile                               |    19 +-
 samples/bpf/cpustat_user.c                         |     1 -
 samples/bpf/hbm.c                                  |     5 +-
 samples/bpf/ibumad_user.c                          |     1 -
 samples/bpf/map_perf_test_user.c                   |     1 -
 samples/bpf/offwaketime_user.c                     |     1 -
 samples/bpf/sockex2_user.c                         |     1 -
 samples/bpf/sockex3_user.c                         |     1 -
 samples/bpf/spintest_user.c                        |     1 -
 samples/bpf/syscall_tp_user.c                      |     4 +-
 samples/bpf/task_fd_query_user.c                   |     1 -
 samples/bpf/test_lru_dist.c                        |     1 -
 samples/bpf/test_map_in_map_user.c                 |     1 -
 samples/bpf/test_overhead_user.c                   |     1 -
 samples/bpf/tracex2_user.c                         |     1 -
 samples/bpf/tracex3_user.c                         |     1 -
 samples/bpf/tracex4_user.c                         |     1 -
 samples/bpf/tracex5_user.c                         |     1 -
 samples/bpf/tracex6_user.c                         |     1 -
 samples/bpf/xdp1_user.c                            |     3 +-
 samples/bpf/xdp_adjust_tail_user.c                 |     1 -
 samples/bpf/xdp_monitor_user.c                     |     1 -
 samples/bpf/xdp_redirect_cpu_user.c                |     1 -
 samples/bpf/xdp_redirect_map_multi_user.c          |     1 -
 samples/bpf/xdp_redirect_user.c                    |     1 -
 samples/bpf/xdp_router_ipv4.bpf.c                  |   180 +
 samples/bpf/xdp_router_ipv4_kern.c                 |   186 -
 samples/bpf/xdp_router_ipv4_user.c                 |   456 +-
 samples/bpf/xdp_rxq_info_user.c                    |    23 +-
 samples/bpf/xdp_sample_pkts_user.c                 |     1 -
 samples/bpf/xdp_sample_user.c                      |     1 -
 samples/bpf/xdp_tx_iptunnel_user.c                 |     1 -
 samples/bpf/xdpsock_user.c                         |     9 +-
 samples/bpf/xsk_fwd.c                              |     7 +-
 scripts/bpf_doc.py                                 |     4 +
 tools/bpf/bpftool/btf.c                            |    62 +-
 tools/bpf/bpftool/common.c                         |     8 -
 tools/bpf/bpftool/feature.c                        |    26 +-
 tools/bpf/bpftool/gen.c                            |     5 +-
 tools/bpf/bpftool/link.c                           |     4 +
 tools/bpf/bpftool/main.c                           |     6 +-
 tools/bpf/bpftool/main.h                           |     2 -
 tools/bpf/bpftool/map.c                            |     2 -
 tools/bpf/bpftool/perf.c                           |   112 +-
 tools/bpf/bpftool/pids.c                           |     1 -
 tools/bpf/bpftool/prog.c                           |     4 +-
 tools/bpf/bpftool/struct_ops.c                     |     2 -
 tools/bpf/bpftool/tracelog.c                       |     2 +-
 tools/bpf/runqslower/runqslower.c                  |    18 +-
 tools/include/uapi/asm-generic/socket.h            |     2 +
 tools/include/uapi/asm/bpf_perf_event.h            |     2 +
 tools/include/uapi/linux/bpf.h                     |   125 +
 tools/include/uapi/linux/btf.h                     |     4 +-
 tools/include/uapi/linux/if_link.h                 |     2 +
 tools/lib/bpf/Build                                |     3 +-
 tools/lib/bpf/Makefile                             |     4 +-
 tools/lib/bpf/bpf.c                                |   136 +-
 tools/lib/bpf/bpf.h                                |    46 +-
 tools/lib/bpf/bpf_core_read.h                      |    37 +-
 tools/lib/bpf/bpf_helpers.h                        |    26 +
 tools/lib/bpf/bpf_tracing.h                        |    23 +
 tools/lib/bpf/btf.c                                |    15 +-
 tools/lib/bpf/libbpf.c                             |  1273 +-
 tools/lib/bpf/libbpf.h                             |   279 +-
 tools/lib/bpf/libbpf.map                           |    17 +-
 tools/lib/bpf/libbpf_internal.h                    |    37 +
 tools/lib/bpf/libbpf_version.h                     |     4 +-
 tools/lib/bpf/relo_core.c                          |   104 +-
 tools/lib/bpf/relo_core.h                          |     6 +
 tools/lib/bpf/usdt.bpf.h                           |   259 +
 tools/lib/bpf/usdt.c                               |  1518 ++
 tools/testing/selftests/bpf/Makefile               |    39 +-
 tools/testing/selftests/bpf/bench.c                |     1 -
 tools/testing/selftests/bpf/bpf_rlimit.h           |    28 -
 tools/testing/selftests/bpf/bpf_tcp_helpers.h      |    13 +
 tools/testing/selftests/bpf/config                 |     4 +
 tools/testing/selftests/bpf/flow_dissector_load.c  |     6 +-
 tools/testing/selftests/bpf/get_cgroup_id_user.c   |     4 +-
 .../selftests/bpf/map_tests/map_in_map_batch_ops.c |   252 +
 tools/testing/selftests/bpf/network_helpers.c      |    40 +-
 tools/testing/selftests/bpf/network_helpers.h      |     2 +
 .../testing/selftests/bpf/prog_tests/arg_parsing.c |   107 +
 .../selftests/bpf/prog_tests/attach_probe.c        |    95 +-
 .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |    89 +
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |   265 +-
 .../selftests/bpf/prog_tests/bpf_mod_race.c        |     4 +-
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |     6 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |   100 +-
 .../selftests/bpf/prog_tests/core_autosize.c       |     2 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |    13 +-
 .../testing/selftests/bpf/prog_tests/core_retro.c  |    17 +-
 tools/testing/selftests/bpf/prog_tests/dynptr.c    |   137 +
 .../selftests/bpf/prog_tests/fexit_stress.c        |     4 +-
 tools/testing/selftests/bpf/prog_tests/for_each.c  |    42 +-
 .../selftests/bpf/prog_tests/helper_restricted.c   |    10 +-
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |   159 +-
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c |    17 +-
 .../selftests/bpf/prog_tests/linked_funcs.c        |     6 +
 tools/testing/selftests/bpf/prog_tests/log_fixup.c |   149 +
 .../selftests/bpf/prog_tests/lookup_and_delete.c   |    15 +-
 tools/testing/selftests/bpf/prog_tests/map_kptr.c  |   148 +
 .../bpf/prog_tests/map_lookup_percpu_elem.c        |    58 +
 tools/testing/selftests/bpf/prog_tests/mptcp.c     |   174 +
 tools/testing/selftests/bpf/prog_tests/netcnt.c    |     2 +-
 .../bpf/prog_tests/prog_tests_framework.c          |    56 +
 .../selftests/bpf/prog_tests/reference_tracking.c  |    23 +-
 .../selftests/bpf/prog_tests/ringbuf_multi.c       |    12 -
 .../selftests/bpf/prog_tests/skb_load_bytes.c      |    45 +
 tools/testing/selftests/bpf/prog_tests/snprintf.c  |     4 +-
 .../selftests/bpf/prog_tests/stacktrace_build_id.c |     8 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c       |    11 +-
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |     1 -
 .../selftests/bpf/prog_tests/test_global_funcs.c   |     1 +
 .../selftests/bpf/prog_tests/test_strncmp.c        |    25 +-
 .../testing/selftests/bpf/prog_tests/test_tunnel.c |   423 +
 tools/testing/selftests/bpf/prog_tests/timer_mim.c |     2 +-
 .../selftests/bpf/prog_tests/trampoline_count.c    |   134 +-
 .../selftests/bpf/prog_tests/unpriv_bpf_disabled.c |   312 +
 .../selftests/bpf/prog_tests/uprobe_autoattach.c   |    50 +
 tools/testing/selftests/bpf/prog_tests/usdt.c      |   419 +
 tools/testing/selftests/bpf/progs/bpf_iter.h       |     7 +
 .../selftests/bpf/progs/bpf_iter_bpf_link.c        |    21 +
 .../bpf/progs/btf__core_reloc_size___diff_offs.c   |     3 +
 .../bpf/progs/btf_dump_test_case_syntax.c          |     2 +-
 .../testing/selftests/bpf/progs/core_reloc_types.h |    18 +
 tools/testing/selftests/bpf/progs/dynptr_fail.c    |   588 +
 tools/testing/selftests/bpf/progs/dynptr_success.c |   164 +
 tools/testing/selftests/bpf/progs/exhandler_kern.c |    13 +-
 .../bpf/progs/for_each_map_elem_write_key.c        |    27 +
 tools/testing/selftests/bpf/progs/kprobe_multi.c   |    14 +
 .../selftests/bpf/progs/kprobe_multi_empty.c       |    12 +
 tools/testing/selftests/bpf/progs/linked_funcs1.c  |    15 +-
 tools/testing/selftests/bpf/progs/linked_funcs2.c  |    15 +-
 tools/testing/selftests/bpf/progs/loop5.c          |     1 -
 tools/testing/selftests/bpf/progs/map_kptr.c       |   292 +
 tools/testing/selftests/bpf/progs/map_kptr_fail.c  |   418 +
 tools/testing/selftests/bpf/progs/mptcp_sock.c     |    88 +
 .../selftests/bpf/progs/perf_event_stackmap.c      |     4 +-
 tools/testing/selftests/bpf/progs/profiler.inc.h   |     5 +-
 tools/testing/selftests/bpf/progs/profiler1.c      |     1 -
 tools/testing/selftests/bpf/progs/pyperf.h         |     6 +-
 tools/testing/selftests/bpf/progs/pyperf600.c      |    11 +-
 tools/testing/selftests/bpf/progs/skb_load_bytes.c |    19 +
 tools/testing/selftests/bpf/progs/strncmp_test.c   |     8 +-
 .../selftests/bpf/progs/test_attach_probe.c        |    64 +-
 .../testing/selftests/bpf/progs/test_bpf_cookie.c  |    56 +-
 .../bpf/progs/test_core_reloc_existence.c          |    11 +-
 .../selftests/bpf/progs/test_core_reloc_size.c     |    31 +-
 .../selftests/bpf/progs/test_global_func17.c       |    16 +
 .../selftests/bpf/progs/test_helper_restricted.c   |    16 +-
 .../bpf/progs/test_ksyms_btf_write_check.c         |    18 +-
 .../selftests/bpf/progs/test_l4lb_noinline.c       |     2 +-
 tools/testing/selftests/bpf/progs/test_log_fixup.c |    64 +
 .../bpf/progs/test_map_lookup_percpu_elem.c        |    76 +
 .../selftests/bpf/progs/test_module_attach.c       |     2 +-
 .../testing/selftests/bpf/progs/test_pkt_access.c  |     2 -
 .../selftests/bpf/progs/test_ringbuf_multi.c       |     2 +
 tools/testing/selftests/bpf/progs/test_sk_assign.c |     4 +-
 .../selftests/bpf/progs/test_sk_lookup_kern.c      |    18 +-
 tools/testing/selftests/bpf/progs/test_subprogs.c  |     8 +
 .../selftests/bpf/progs/test_task_pt_regs.c        |     2 +-
 .../selftests/bpf/progs/test_trampoline_count.c    |    16 +-
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |   371 +-
 .../selftests/bpf/progs/test_unpriv_bpf_disabled.c |    83 +
 .../selftests/bpf/progs/test_uprobe_autoattach.c   |    73 +
 .../selftests/bpf/progs/test_urandom_usdt.c        |    70 +
 tools/testing/selftests/bpf/progs/test_usdt.c      |    96 +
 .../selftests/bpf/progs/test_usdt_multispec.c      |    32 +
 .../selftests/bpf/progs/test_xdp_noinline.c        |    12 +-
 tools/testing/selftests/bpf/progs/trigger_bench.c  |     2 +-
 tools/testing/selftests/bpf/sdt-config.h           |     6 +
 tools/testing/selftests/bpf/sdt.h                  |   513 +
 .../selftests/bpf/test_bpftool_synctypes.py        |     2 +-
 tools/testing/selftests/bpf/test_cgroup_storage.c  |     7 +-
 tools/testing/selftests/bpf/test_dev_cgroup.c      |     4 +-
 tools/testing/selftests/bpf/test_lpm_map.c         |    43 +-
 tools/testing/selftests/bpf/test_lru_map.c         |    70 +-
 tools/testing/selftests/bpf/test_offload.py        |     2 +-
 tools/testing/selftests/bpf/test_progs.c           |  1006 +-
 tools/testing/selftests/bpf/test_progs.h           |    89 +-
 .../selftests/bpf/test_skb_cgroup_id_user.c        |     4 +-
 tools/testing/selftests/bpf/test_sock.c            |     6 +-
 tools/testing/selftests/bpf/test_sock_addr.c       |     4 +-
 tools/testing/selftests/bpf/test_sockmap.c         |     5 +-
 tools/testing/selftests/bpf/test_sysctl.c          |     6 +-
 tools/testing/selftests/bpf/test_tag.c             |     4 +-
 .../selftests/bpf/test_tcp_check_syncookie_user.c  |     4 +-
 tools/testing/selftests/bpf/test_tcpnotify_user.c  |     1 -
 tools/testing/selftests/bpf/test_tunnel.sh         |   124 +-
 tools/testing/selftests/bpf/test_verifier.c        |    55 +-
 tools/testing/selftests/bpf/test_verifier_log.c    |     5 +-
 tools/testing/selftests/bpf/test_xsk.sh            |    53 +-
 tools/testing/selftests/bpf/testing_helpers.c      |    91 +-
 tools/testing/selftests/bpf/testing_helpers.h      |     8 +
 tools/testing/selftests/bpf/trace_helpers.c        |     9 +-
 tools/testing/selftests/bpf/urandom_read.c         |    63 +-
 tools/testing/selftests/bpf/urandom_read_aux.c     |     9 +
 tools/testing/selftests/bpf/urandom_read_lib1.c    |    13 +
 tools/testing/selftests/bpf/urandom_read_lib2.c    |     8 +
 tools/testing/selftests/bpf/verifier/calls.c       |    20 +
 tools/testing/selftests/bpf/verifier/map_kptr.c    |   469 +
 .../testing/selftests/bpf/verifier/ref_tracking.c  |     2 +-
 tools/testing/selftests/bpf/verifier/sock.c        |     6 +-
 tools/testing/selftests/bpf/xdp_redirect_multi.c   |     1 -
 tools/testing/selftests/bpf/xdping.c               |     8 +-
 tools/testing/selftests/bpf/xdpxceiver.c           |   553 +-
 tools/testing/selftests/bpf/xdpxceiver.h           |    42 +-
 tools/testing/selftests/bpf/xsk_prereqs.sh         |    47 +-
 .../drivers/net/dsa/bridge_locked_port.sh          |     1 +
 .../selftests/drivers/net/dsa/bridge_mdb.sh        |     1 +
 .../selftests/drivers/net/dsa/bridge_mld.sh        |     1 +
 .../selftests/drivers/net/dsa/bridge_vlan_aware.sh |     1 +
 .../selftests/drivers/net/dsa/bridge_vlan_mcast.sh |     1 +
 .../drivers/net/dsa/bridge_vlan_unaware.sh         |     1 +
 .../selftests/drivers/net/dsa/forwarding.config    |     2 +
 tools/testing/selftests/drivers/net/dsa/lib.sh     |     1 +
 .../selftests/drivers/net/dsa/local_termination.sh |     1 +
 .../selftests/drivers/net/dsa/no_forwarding.sh     |     1 +
 .../drivers/net/mlxsw/devlink_linecard.sh          |   280 +
 .../selftests/drivers/net/mlxsw/qos_burst.sh       |   480 +
 .../selftests/drivers/net/mlxsw/qos_headroom.sh    |     4 +-
 .../testing/selftests/drivers/net/mlxsw/qos_pfc.sh |     4 +-
 .../selftests/drivers/net/mlxsw/sch_red_ets.sh     |     5 +-
 .../selftests/drivers/net/mlxsw/sch_red_root.sh    |     5 +-
 .../selftests/drivers/net/netdevsim/hw_stats_l3.sh |     4 +-
 .../selftests/drivers/net/ocelot/basic_qos.sh      |   253 +
 tools/testing/selftests/drivers/net/ocelot/psfp.sh |   327 +
 .../drivers/net/ocelot/tc_flower_chains.sh         |   202 +-
 tools/testing/selftests/net/.gitignore             |     2 +
 tools/testing/selftests/net/Makefile               |     5 +
 tools/testing/selftests/net/bind_bhash_test.c      |   119 +
 tools/testing/selftests/net/fib_nexthops.sh        |    53 +-
 tools/testing/selftests/net/fib_rule_tests.sh      |    12 +-
 tools/testing/selftests/net/forwarding/Makefile    |     2 +
 .../testing/selftests/net/forwarding/bridge_mdb.sh |   103 +
 .../selftests/net/forwarding/hw_stats_l3.sh        |    16 +-
 .../selftests/net/forwarding/hw_stats_l3_gre.sh    |   109 +
 tools/testing/selftests/net/forwarding/lib.sh      |   144 +-
 .../selftests/net/forwarding/local_termination.sh  |   299 +
 .../selftests/net/forwarding/no_forwarding.sh      |   261 +
 tools/testing/selftests/net/forwarding/router.sh   |    18 +
 .../selftests/net/forwarding/router_vid_1.sh       |    27 +-
 .../testing/selftests/net/forwarding/tc_actions.sh |     2 +-
 tools/testing/selftests/net/forwarding/tsn_lib.sh  |   235 +
 tools/testing/selftests/net/mptcp/config           |     8 +
 tools/testing/selftests/net/mptcp/diag.sh          |    38 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   243 +-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c      |   645 +-
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |   779 +
 .../selftests/net/ndisc_unsolicited_na_test.sh     |   255 +
 .../selftests/net/stress_reuseport_listen.c        |   105 +
 .../selftests/net/stress_reuseport_listen.sh       |    25 +
 .../testing/selftests/net/vrf_strict_mode_test.sh  |    48 +-
 tools/testing/selftests/netfilter/nft_fib.sh       |    50 +
 tools/testing/selftests/sysctl/sysctl.sh           |    23 +
 1931 files changed, 162345 insertions(+), 59902 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-pcie-mirror.yaml
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
 create mode 100644 Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
 create mode 100644 Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/marvell-orion-mdio.txt
 create mode 100644 Documentation/devicetree/bindings/net/mediatek,net.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/mediatek-net.txt
 create mode 100644 Documentation/devicetree/bindings/net/mscc,miim.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/mscc-miim.txt
 create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
 rename Documentation/devicetree/bindings/{staging => }/net/wireless/silabs,wfx.yaml (98%)
 delete mode 100644 Documentation/networking/device_drivers/appletalk/ltpc.rst
 create mode 100644 Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
 create mode 100644 Documentation/networking/device_drivers/can/ctu/fsm_txt_buffer_user.svg
 delete mode 100644 Documentation/networking/device_drivers/ethernet/dec/de4x5.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst
 delete mode 100644 Documentation/networking/device_drivers/wan/index.rst
 delete mode 100644 Documentation/networking/device_drivers/wan/z8530book.rst
 create mode 100644 Documentation/networking/device_drivers/wwan/t7xx.rst
 create mode 100644 Documentation/networking/devlink/devlink-linecard.rst
 create mode 100644 Documentation/networking/skbuff.rst
 delete mode 100644 drivers/atm/ambassador.c
 delete mode 100644 drivers/atm/ambassador.h
 delete mode 100644 drivers/atm/firestream.c
 delete mode 100644 drivers/atm/firestream.h
 delete mode 100644 drivers/atm/horizon.c
 delete mode 100644 drivers/atm/horizon.h
 delete mode 100644 drivers/atm/uPD98401.h
 delete mode 100644 drivers/atm/uPD98402.c
 delete mode 100644 drivers/atm/uPD98402.h
 delete mode 100644 drivers/atm/zatm.c
 delete mode 100644 drivers/atm/zatm.h
 delete mode 100644 drivers/net/appletalk/ltpc.c
 delete mode 100644 drivers/net/appletalk/ltpc.h
 create mode 100644 drivers/net/can/ctucanfd/Kconfig
 create mode 100644 drivers/net/can/ctucanfd/Makefile
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd.h
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_base.c
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_kframe.h
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_kregs.h
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_pci.c
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_platform.c
 delete mode 100644 drivers/net/can/led.c
 delete mode 100644 drivers/net/ethernet/amd/ni65.c
 delete mode 100644 drivers/net/ethernet/amd/ni65.h
 delete mode 100644 drivers/net/ethernet/dec/tulip/de4x5.c
 delete mode 100644 drivers/net/ethernet/dec/tulip/de4x5.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/Kconfig
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/Makefile
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_config.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_main.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_main.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_rx.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_tx.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_tx.h
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed.h
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_ops.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_regs.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/accel.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
 rename drivers/net/ethernet/mellanox/mlx5/core/en_accel/{tls_stats.c => ktls_stats.c} (63%)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
 delete mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_sriov.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_sriov.h
 create mode 100644 drivers/net/ethernet/sfc/siena/Kconfig
 create mode 100644 drivers/net/ethernet/sfc/siena/Makefile
 create mode 100644 drivers/net/ethernet/sfc/siena/bitfield.h
 create mode 100644 drivers/net/ethernet/sfc/siena/efx.c
 create mode 100644 drivers/net/ethernet/sfc/siena/efx.h
 create mode 100644 drivers/net/ethernet/sfc/siena/efx_channels.c
 create mode 100644 drivers/net/ethernet/sfc/siena/efx_channels.h
 create mode 100644 drivers/net/ethernet/sfc/siena/efx_common.c
 create mode 100644 drivers/net/ethernet/sfc/siena/efx_common.h
 create mode 100644 drivers/net/ethernet/sfc/siena/enum.h
 create mode 100644 drivers/net/ethernet/sfc/siena/ethtool.c
 create mode 100644 drivers/net/ethernet/sfc/siena/ethtool_common.c
 create mode 100644 drivers/net/ethernet/sfc/siena/ethtool_common.h
 rename drivers/net/ethernet/sfc/{ => siena}/farch.c (97%)
 create mode 100644 drivers/net/ethernet/sfc/siena/farch_regs.h
 create mode 100644 drivers/net/ethernet/sfc/siena/filter.h
 create mode 100644 drivers/net/ethernet/sfc/siena/io.h
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi.c
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi.h
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi_mon.c
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi_pcol.h
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi_port.c
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi_port.h
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi_port_common.c
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi_port_common.h
 create mode 100644 drivers/net/ethernet/sfc/siena/mtd.c
 create mode 100644 drivers/net/ethernet/sfc/siena/net_driver.h
 create mode 100644 drivers/net/ethernet/sfc/siena/nic.c
 create mode 100644 drivers/net/ethernet/sfc/siena/nic.h
 create mode 100644 drivers/net/ethernet/sfc/siena/nic_common.h
 create mode 100644 drivers/net/ethernet/sfc/siena/ptp.c
 create mode 100644 drivers/net/ethernet/sfc/siena/ptp.h
 create mode 100644 drivers/net/ethernet/sfc/siena/rx.c
 create mode 100644 drivers/net/ethernet/sfc/siena/rx_common.c
 create mode 100644 drivers/net/ethernet/sfc/siena/rx_common.h
 create mode 100644 drivers/net/ethernet/sfc/siena/selftest.c
 create mode 100644 drivers/net/ethernet/sfc/siena/selftest.h
 rename drivers/net/ethernet/sfc/{ => siena}/siena.c (89%)
 rename drivers/net/ethernet/sfc/{ => siena}/siena_sriov.c (98%)
 rename drivers/net/ethernet/sfc/{ => siena}/siena_sriov.h (94%)
 create mode 100644 drivers/net/ethernet/sfc/siena/sriov.h
 create mode 100644 drivers/net/ethernet/sfc/siena/tx.c
 create mode 100644 drivers/net/ethernet/sfc/siena/tx.h
 create mode 100644 drivers/net/ethernet/sfc/siena/tx_common.c
 create mode 100644 drivers/net/ethernet/sfc/siena/tx_common.h
 create mode 100644 drivers/net/ethernet/sfc/siena/vfdi.h
 create mode 100644 drivers/net/ethernet/sfc/siena/workarounds.h
 create mode 100644 drivers/net/ethernet/sunplus/Kconfig
 create mode 100644 drivers/net/ethernet/sunplus/Makefile
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_define.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_desc.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_desc.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_driver.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_int.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_int.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mac.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mac.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mdio.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mdio.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_phy.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_phy.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_register.h
 delete mode 100644 drivers/net/hamradio/dmascc.c
 create mode 100644 drivers/net/phy/adin1100.c
 create mode 100644 drivers/net/phy/dp83td510.c
 delete mode 100644 drivers/net/wan/cosa.c
 delete mode 100644 drivers/net/wan/cosa.h
 delete mode 100644 drivers/net/wan/hostess_sv11.c
 delete mode 100644 drivers/net/wan/lmc/Makefile
 delete mode 100644 drivers/net/wan/lmc/lmc.h
 delete mode 100644 drivers/net/wan/lmc/lmc_debug.c
 delete mode 100644 drivers/net/wan/lmc/lmc_debug.h
 delete mode 100644 drivers/net/wan/lmc/lmc_ioctl.h
 delete mode 100644 drivers/net/wan/lmc/lmc_main.c
 delete mode 100644 drivers/net/wan/lmc/lmc_media.c
 delete mode 100644 drivers/net/wan/lmc/lmc_proto.c
 delete mode 100644 drivers/net/wan/lmc/lmc_proto.h
 delete mode 100644 drivers/net/wan/lmc/lmc_var.h
 delete mode 100644 drivers/net/wan/sealevel.c
 delete mode 100644 drivers/net/wan/z85230.c
 delete mode 100644 drivers/net/wan/z85230.h
 create mode 100644 drivers/net/wireless/ath/ath11k/pcic.c
 create mode 100644 drivers/net/wireless/ath/ath11k/pcic.h
 create mode 100644 drivers/net/wireless/purelifi/Kconfig
 create mode 100644 drivers/net/wireless/purelifi/Makefile
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/Kconfig
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/Makefile
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/chip.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/chip.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/firmware.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/intf.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/mac.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/mac.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/usb.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/usb.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852c_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852c_table.h
 create mode 100644 drivers/net/wireless/silabs/Kconfig
 create mode 100644 drivers/net/wireless/silabs/Makefile
 rename drivers/{staging => net/wireless/silabs}/wfx/Kconfig (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/Makefile (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/bh.c (98%)
 rename drivers/{staging => net/wireless/silabs}/wfx/bh.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/bus.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/bus_sdio.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/bus_spi.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/data_rx.c (93%)
 rename drivers/{staging => net/wireless/silabs}/wfx/data_rx.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/data_tx.c (99%)
 rename drivers/{staging => net/wireless/silabs}/wfx/data_tx.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/debug.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/debug.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/fwio.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/fwio.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_api_cmd.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_api_general.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_api_mib.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_rx.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_rx.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_tx.c (99%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_tx.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_tx_mib.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_tx_mib.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hwio.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hwio.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/key.c (99%)
 rename drivers/{staging => net/wireless/silabs}/wfx/key.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/main.c (98%)
 rename drivers/{staging => net/wireless/silabs}/wfx/main.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/queue.c (98%)
 rename drivers/{staging => net/wireless/silabs}/wfx/queue.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/scan.c (92%)
 rename drivers/{staging => net/wireless/silabs}/wfx/scan.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/sta.c (90%)
 rename drivers/{staging => net/wireless/silabs}/wfx/sta.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/traces.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/wfx.h (95%)
 create mode 100644 drivers/net/wwan/t7xx/Makefile
 create mode 100644 drivers/net/wwan/t7xx/t7xx_cldma.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_cldma.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_dpmaif.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_dpmaif.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_cldma.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_cldma.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_mhccif.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_mhccif.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_modem_ops.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_modem_ops.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_netdev.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_netdev.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pcie_mac.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pcie_mac.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_proxy.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_proxy.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_wwan.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_reg.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_state_monitor.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_state_monitor.h
 delete mode 100644 drivers/staging/wfx/TODO
 delete mode 100644 include/linux/can/led.h
 delete mode 100644 include/linux/mlx5/accel.h
 delete mode 100644 include/linux/qed/qed_nvmetcp_ip_services_if.h
 create mode 100644 include/linux/soc/mediatek/mtk_wed.h
 create mode 100644 include/net/net_debug.h
 delete mode 100644 include/uapi/linux/atm_zatm.h
 create mode 100644 kernel/bpf/link_iter.c
 delete mode 100644 net/core/datagram.h
 create mode 100644 net/core/dev.h
 create mode 100644 net/mptcp/bpf.c
 create mode 100644 net/mptcp/pm_userspace.c
 create mode 100644 samples/bpf/xdp_router_ipv4.bpf.c
 delete mode 100644 samples/bpf/xdp_router_ipv4_kern.c
 create mode 100644 tools/lib/bpf/usdt.bpf.h
 create mode 100644 tools/lib/bpf/usdt.c
 delete mode 100644 tools/testing/selftests/bpf/bpf_rlimit.h
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_in_map_batch_ops.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/arg_parsing.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/dynptr.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/log_fixup.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_kptr.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/prog_tests_framework.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_tunnel.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/unpriv_bpf_disabled.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/usdt.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_link.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_size___diff_offs.c
 create mode 100644 tools/testing/selftests/bpf/progs/dynptr_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/dynptr_success.c
 create mode 100644 tools/testing/selftests/bpf/progs/for_each_map_elem_write_key.c
 create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
 create mode 100644 tools/testing/selftests/bpf/progs/map_kptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/map_kptr_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/mptcp_sock.c
 create mode 100644 tools/testing/selftests/bpf/progs/skb_load_bytes.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func17.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_log_fixup.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_unpriv_bpf_disabled.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_urandom_usdt.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_usdt.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_usdt_multispec.c
 create mode 100644 tools/testing/selftests/bpf/sdt-config.h
 create mode 100644 tools/testing/selftests/bpf/sdt.h
 create mode 100644 tools/testing/selftests/bpf/urandom_read_aux.c
 create mode 100644 tools/testing/selftests/bpf/urandom_read_lib1.c
 create mode 100644 tools/testing/selftests/bpf/urandom_read_lib2.c
 create mode 100644 tools/testing/selftests/bpf/verifier/map_kptr.c
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_locked_port.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_mdb.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_mld.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_vlan_aware.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_vlan_mcast.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_vlan_unaware.sh
 create mode 100644 tools/testing/selftests/drivers/net/dsa/forwarding.config
 create mode 120000 tools/testing/selftests/drivers/net/dsa/lib.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/local_termination.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/no_forwarding.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/qos_burst.sh
 create mode 100755 tools/testing/selftests/drivers/net/ocelot/basic_qos.sh
 create mode 100755 tools/testing/selftests/drivers/net/ocelot/psfp.sh
 create mode 100644 tools/testing/selftests/net/bind_bhash_test.c
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb.sh
 create mode 100755 tools/testing/selftests/net/forwarding/hw_stats_l3_gre.sh
 mode change 100644 => 100755 tools/testing/selftests/net/forwarding/lib.sh
 create mode 100755 tools/testing/selftests/net/forwarding/local_termination.sh
 create mode 100755 tools/testing/selftests/net/forwarding/no_forwarding.sh
 create mode 100644 tools/testing/selftests/net/forwarding/tsn_lib.sh
 create mode 100755 tools/testing/selftests/net/mptcp/userspace_pm.sh
 create mode 100755 tools/testing/selftests/net/ndisc_unsolicited_na_test.sh
 create mode 100644 tools/testing/selftests/net/stress_reuseport_listen.c
 create mode 100755 tools/testing/selftests/net/stress_reuseport_listen.sh
