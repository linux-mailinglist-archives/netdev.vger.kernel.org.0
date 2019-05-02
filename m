Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DABC11F42
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 17:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfEBPWf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 May 2019 11:22:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53854 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfEBPWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 11:22:33 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9DD62149706EE;
        Thu,  2 May 2019 08:22:32 -0700 (PDT)
Date:   Thu, 02 May 2019 11:22:29 -0400 (EDT)
Message-Id: <20190502.112229.169709368531678908.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 May 2019 08:22:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Out of bounds access in xfrm IPSEC policy unlink, from Yue Haibing.

2) Missing length check for esp4 UDP encap, from Sabrina Dubroca.

3) Fix byte order of RX STBC access in mac80211, from Johannes Berg.

4) Inifnite loop in bpftool map create, from Alban Crequy.

5) Register mark fix in ebpf verifier after pkt/null checks, from Paul
   Chaignon.

6) Properly use rcu_dereference_sk_user_data in L2TP code, from Eric
   Dumazet.

7) Buffer overrun in marvell phy driver, from Andrew Lunn.

8) Several crash and statistics handling fixes to bnxt_en driver, from
   Michael Chan and Vasundhara Volam.

9) Several fixes to the TLS layer from Jakub Kicinski (copying negative
   amounts of data in reencrypt, reencrypt frag copying, blind nskb->sk
   NULL deref, etc.).

10) Several UDP GRO fixes, from Paolo Abeni and Eric Dumazet.

11) PID/UID checks on ipv6 flow labels are inverted, from Willem
    de Bruijn.

12) Use after free in l2tp, from Eric Dumazet.

13) IPV6 route destroy races, also from Eric Dumazet.

14) SCTP state machine can erroneously run recursively, fix from
    Xin Long.

15) Adjust AF_PACKET msg_name length checks, add padding bytes if
    necessary.  From Willem de Bruijn.

16) Preserve skb_iif, so that forwarded packets have consistent values
    even if fragmentation is involved.  From Shmulik Ladkani.

Please pull, thanks a lot!

The following changes since commit cd8dead0c39457e58ec1d36db93aedca811d48f1:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2019-04-24 16:18:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 

for you to fetch changes up to 4dd2b82d5adfbe0b1587ccad7a8f76d826120f37:

  udp: fix GRO packet of death (2019-05-01 22:29:56 -0400)

----------------------------------------------------------------
Alban Crequy (1):
      tools: bpftool: fix infinite loop in map create

Andrew Lunn (1):
      net: phy: marvell: Fix buffer overrun with stats counters

Bhagavathi Perumal S (1):
      mac80211: Fix kernel panic due to use of txq after free

Bjørn Mork (1):
      qmi_wwan: new Wistron, ZTE and D-Link devices

Brian Norris (1):
      ath10k: perform crash dump collection in workqueue

Cong Wang (1):
      xfrm: clean up xfrm protocol checks

Dan Carpenter (1):
      net: dsa: bcm_sf2: fix buffer overflow doing set_rxnfc

David Ahern (1):
      selftests: fib_rule_tests: Fix icmp proto with ipv6

David Howells (1):
      rxrpc: Fix net namespace cleanup

David S. Miller (7):
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch 'bnxt_en-Misc-bug-fixes'
      Merge branch 'tls-data-copies'
      Merge tag 'mac80211-for-davem-2019-04-26' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'ieee802154-for-davem-2019-04-25' of git://git.kernel.org/.../sschmidt/wpan
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec
      Merge tag 'wireless-drivers-for-davem-2019-04-30' of git://git.kernel.org/.../kvalo/wireless-drivers

Douglas Anderson (1):
      mwifiex: Make resume actually do something useful again on SDIO cards

Emmanuel Grumbach (1):
      iwlwifi: fix driver operation for 5350

Eric Dumazet (6):
      l2tp: use rcu_dereference_sk_user_data() in l2tp_udp_encap_recv()
      tcp: add sanity tests in tcp_add_backlog()
      ipv6/flowlabel: wait rcu grace period before put_pid()
      l2ip: fix possible use-after-free
      ipv6: fix races in ip6_dst_destroy()
      udp: fix GRO packet of death

Fabien Dessenne (1):
      net: ethernet: stmmac: manage the get_irq probe defer case

Greg Kroah-Hartman (1):
      iwlwifi: mvm: properly check debugfs dentry before using it

Hangbin Liu (1):
      selftests: fib_rule_tests: print the result and return 1 if any tests failed

Jakub Kicinski (3):
      net/tls: don't copy negative amounts of data in reencrypt
      net/tls: fix copy to fragments in reencrypt
      net/tls: avoid NULL pointer deref on nskb->sk in fallback

Jan Kiszka (1):
      stmmac: pci: Fix typo in IOT2000 comment

Jeremy Sowden (2):
      vti4: ipip tunnel deregistration fixes.
      vti4: removed duplicate log message.

Johannes Berg (3):
      mac80211: fix RX STBC override byte order
      iwlwifi: mvm: don't attempt debug collection in rfkill
      mac80211: don't attempt to rename ERR_PTR() debugfs dirs

Kalle Valo (3):
      Merge tag 'iwlwifi-for-kalle-2019-04-19' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge tag 'iwlwifi-for-kalle-2019-04-28' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge ath-current from git://git.kernel.org/.../kvalo/ath.git

Kangjie Lu (1):
      net: ieee802154: fix missing checks for regmap_update_bits

Luca Coelho (2):
      iwlwifi: mvm: check for length correctness in iwl_mvm_create_skb()
      iwlwifi: mvm: fix merge damage in iwl_mvm_vif_dbgfs_register()

Marcel Holtmann (1):
      genetlink: use idr_alloc_cyclic for family->id assignment

Martin KaFai Lau (1):
      ipv6: A few fixes on dereferencing rt->from

Martin Willi (1):
      xfrm: Honor original L3 slave device in xfrmi policy lookup

Matteo Croce (1):
      libbpf: add binary to gitignore

Michael Chan (5):
      bnxt_en: Improve multicast address setup logic.
      bnxt_en: Fix possible crash in bnxt_hwrm_ring_free() under error conditions.
      bnxt_en: Pass correct extended TX port statistics size to firmware.
      bnxt_en: Fix statistics context reservation logic.
      bnxt_en: Fix uninitialized variable usage in bnxt_rx_pkt().

Myungho Jung (1):
      xfrm: Reset secpath in xfrm failure

Nicholas Mc Guire (1):
      rds: ib: force endiannes annotation

Nicolas Dichtel (1):
      xfrm: update doc about xfrm[46]_gc_thresh

Paolo Abeni (1):
      udp: fix GRO reception in case of length mismatch

Paul Chaignon (2):
      bpf: mark registers in all frames after pkt/null checks
      selftests/bpf: test cases for pkt/null checks in subprogs

Peter Zijlstra (1):
      bpf: Fix preempt_enable_no_resched() abuse

Rafael J. Wysocki (1):
      ath10k: Drop WARN_ON()s that always trigger during system resume

Randy Dunlap (1):
      Documentation: fix netdev-FAQ.rst markup warning

Sabrina Dubroca (1):
      esp4: add length check for UDP encapsulation

Shahar S Matityahu (2):
      iwlwifi: don't panic in error path on non-msix systems
      iwlwifi: dbg_ini: check debug TLV type explicitly

Shaul Triebitz (1):
      iwlwifi: cfg: use family 22560 based_params for AX210 family

Shmulik Ladkani (1):
      ipv4: ip_do_fragment: Preserve skb_iif during fragmentation

Sriram R (1):
      cfg80211: Notify previous user request during self managed wiphy registration

Steffen Klassert (2):
      Revert "net: xfrm: Add '_rcu' tag for rcu protected pointer in netns_xfrm"
      xfrm4: Fix uninitialized memory read in _decode_session4

Stephen Suryaputra (1):
      vrf: Use orig netdev to count Ip6InNoRoutes and a fresh route lookup when sending dest unreach

Su Yanjun (2):
      net: xfrm: Add '_rcu' tag for rcu protected pointer in netns_xfrm
      xfrm6_tunnel: Fix potential panic when unloading xfrm6_tunnel module

Vasundhara Volam (1):
      bnxt_en: Free short FW command HWRM memory in error path in bnxt_init_one()

Willem de Bruijn (3):
      ipv6: invert flowlabel sharing check in process and user mode
      packet: in recvmsg msg_name return at least sizeof sockaddr_ll
      packet: validate msg_namelen in send directly

Xin Long (1):
      sctp: avoid running the sctp state machine recursively

YueHaibing (3):
      xfrm: policy: Fix out-of-bound array accesses in __xfrm_policy_unlink
      MIPS: eBPF: Make ebpf_to_mips_reg() static
      appletalk: Set error code if register_snap_client failed

 Documentation/networking/ip-sysctl.txt                      |  2 ++
 Documentation/networking/netdev-FAQ.rst                     |  2 +-
 arch/mips/net/ebpf_jit.c                                    |  5 ++--
 drivers/net/dsa/bcm_sf2_cfp.c                               |  6 +++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                   | 53 +++++++++++++++++++++++----------------
 drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c           |  3 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c            |  2 +-
 drivers/net/ieee802154/mcr20a.c                             |  6 +++++
 drivers/net/phy/marvell.c                                   |  6 +++--
 drivers/net/usb/qmi_wwan.c                                  | 10 ++++++++
 drivers/net/wireless/ath/ath10k/ce.c                        |  2 +-
 drivers/net/wireless/ath/ath10k/core.c                      |  1 +
 drivers/net/wireless/ath/ath10k/core.h                      |  3 +++
 drivers/net/wireless/ath/ath10k/coredump.c                  |  6 ++---
 drivers/net/wireless/ath/ath10k/mac.c                       |  4 +--
 drivers/net/wireless/ath/ath10k/pci.c                       | 24 ++++++++++++++----
 drivers/net/wireless/ath/ath10k/pci.h                       |  2 ++
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c              |  2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c               |  3 ++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h                | 15 ++++++-----
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c            |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c        |  3 +--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                 |  4 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c               | 28 ++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c             | 19 +++++++++-----
 drivers/net/wireless/marvell/mwifiex/sdio.c                 |  2 +-
 include/linux/bpf.h                                         |  2 +-
 include/net/sctp/command.h                                  |  1 -
 include/net/xfrm.h                                          | 20 ++++++++++++++-
 kernel/bpf/verifier.c                                       | 76 ++++++++++++++++++++++++++++++++++----------------------
 net/appletalk/ddp.c                                         |  1 +
 net/ipv4/esp4.c                                             | 20 +++++++++++----
 net/ipv4/esp4_offload.c                                     |  8 +++---
 net/ipv4/ip_output.c                                        |  1 +
 net/ipv4/ip_vti.c                                           |  9 +++----
 net/ipv4/tcp_ipv4.c                                         | 13 +++++++++-
 net/ipv4/udp_offload.c                                      | 16 +++++++++---
 net/ipv4/xfrm4_policy.c                                     | 24 ++++++++++--------
 net/ipv6/esp6_offload.c                                     |  8 +++---
 net/ipv6/ip6_fib.c                                          |  4 +--
 net/ipv6/ip6_flowlabel.c                                    | 22 ++++++++++------
 net/ipv6/route.c                                            | 70 +++++++++++++++++++++++++++------------------------
 net/ipv6/xfrm6_tunnel.c                                     |  6 ++++-
 net/key/af_key.c                                            |  4 ++-
 net/l2tp/l2tp_core.c                                        | 10 ++++----
 net/mac80211/debugfs_netdev.c                               |  2 +-
 net/mac80211/ht.c                                           |  5 ++--
 net/mac80211/iface.c                                        |  3 +++
 net/netlink/genetlink.c                                     |  4 +--
 net/packet/af_packet.c                                      | 37 ++++++++++++++++++---------
 net/rds/ib_recv.c                                           |  8 +++---
 net/rxrpc/call_object.c                                     | 32 ++++++++++++------------
 net/sctp/sm_sideeffect.c                                    | 29 ---------------------
 net/sctp/sm_statefuns.c                                     | 35 ++++++++++++++++++++------
 net/tls/tls_device.c                                        | 39 +++++++++++++++++++++--------
 net/tls/tls_device_fallback.c                               |  3 ++-
 net/wireless/reg.c                                          |  5 ++--
 net/xfrm/xfrm_interface.c                                   | 17 ++++++++++---
 net/xfrm/xfrm_policy.c                                      |  2 +-
 net/xfrm/xfrm_state.c                                       |  2 +-
 net/xfrm/xfrm_user.c                                        | 16 ++----------
 tools/bpf/bpftool/map.c                                     |  3 +++
 tools/lib/bpf/.gitignore                                    |  1 +
 tools/testing/selftests/bpf/verifier/calls.c                | 25 +++++++++++++++++++
 tools/testing/selftests/bpf/verifier/direct_packet_access.c | 22 ++++++++++++++++
 tools/testing/selftests/net/fib_rule_tests.sh               | 10 ++++++--
 67 files changed, 544 insertions(+), 289 deletions(-)
