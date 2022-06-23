Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE3A55788A
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 13:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiFWLRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 07:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiFWLRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 07:17:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C96E04BB92
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 04:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655983063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qlxtbceGc9v9ykUf+1lPqFcb6Nv0A3pMmJbFZF2rabY=;
        b=HTsORTJGMtenySG7mDwEbJvMHm7Fpo14PwkPciyz8Rf1RQkl92ASy1DILR1WVxJlURwVHD
        chXO8IlNhnlIHmMXP5IIrUW7hd+HXBZSrGtBq9wrAZCTolYbAOQ37/pJygfGGvOQKIAir7
        zin4otYzagFIHiylolqw1CJ70QNy8VQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-AyvSGJfMPMuaV0kRDZzpcA-1; Thu, 23 Jun 2022 07:17:40 -0400
X-MC-Unique: AyvSGJfMPMuaV0kRDZzpcA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27FFC19711BE;
        Thu, 23 Jun 2022 11:17:40 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1848A2026D64;
        Thu, 23 Jun 2022 11:17:38 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.19-rc4
Date:   Thu, 23 Jun 2022 13:17:11 +0200
Message-Id: <20220623111711.25693-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 48a23ec6ff2b2a5effe8d3ae5f17fc6b7f35df65:

  Merge tag 'net-5.19-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-06-16 11:51:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc4

for you to fetch changes up to 12378a5a75e33f34f8586706eb61cca9e6d4690c:

  net: openvswitch: fix parsing of nw_proto for IPv6 fragments (2022-06-23 11:44:01 +0200)

----------------------------------------------------------------
Networking fixes for 5.19-rc4, including fixes from bpf and netfilter.

Current release - regressions:
  - netfilter: cttimeout: fix slab-out-of-bounds read in cttimeout_net_exit

Current release - new code bugs:
  - bpf: ftrace: keep address offset in ftrace_lookup_symbols

  - bpf: force cookies array to follow symbols sorting

Previous releases - regressions:
  - ipv4: ping: fix bind address validity check

  - tipc: fix use-after-free read in tipc_named_reinit

  - eth: veth: add updating of trans_start

Previous releases - always broken:
  - sock: redo the psock vs ULP protection check

  - netfilter: nf_dup_netdev: fix skb_under_panic

  - bpf: fix request_sock leak in sk lookup helpers

  - eth: igb: fix a use-after-free issue in igb_clean_tx_ring

  - eth: ice: prohibit improper channel config for DCB

  - eth: at803x: fix null pointer dereference on AR9331 phy

  - eth: virtio_net: fix xdp_rxq_info bug after suspend/resume

Misc:
  - eth: hinic: replace memcpy() with direct assignment

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'bpf: Fix cookie values for kprobe multi'

Anatolii Gerasymenko (2):
      ice: ethtool: advertise 1000M speeds properly
      ice: ethtool: Prohibit improper channel config for DCB

Christian Marangi (2):
      net: dsa: qca8k: reset cpu port on MTU change
      net: dsa: qca8k: reduce mgmt ethernet timeout

Ciara Loftus (1):
      xsk: Fix generic transmit when completion queue reservation fails

Claudiu Manoil (1):
      phy: aquantia: Fix AN when higher speeds than 1G are not advertised

Daniel Borkmann (1):
      bpf, docs: Update some of the JIT/maintenance entries

Eric Dumazet (2):
      net: fix data-race in dev_isalive()
      erspan: do not assume transport header is always set

Florian Westphal (4):
      netfilter: use get_random_u32 instead of prandom
      netfilter: cttimeout: fix slab-out-of-bounds read typo in cttimeout_net_exit
      netfilter: nf_dup_netdev: do not push mac header a second time
      netfilter: nf_dup_netdev: add and use recursion counter

Hoang Le (1):
      tipc: fix use-after-free Read in tipc_named_reinit

Ivan Vecera (1):
      ethtool: Fix get module eeprom fallback

Jakub Kicinski (6):
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Revert "drivers/net/ethernet/neterion/vxge: Fix a use-after-free bug in vxge-main.c"
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Revert "net/tls: fix tls_sk_proto_close executed repeatedly"
      sock: redo the psock vs ULP protection check

Jakub Sitnicki (2):
      bpf, x86: Fix tail call count offset calculation on bpf2bpf call
      selftests/bpf: Test tail call counting with bpf2bpf and data on stack

Jay Vosburgh (2):
      veth: Add updating of trans_start
      bonding: ARP monitor spams NETDEV_NOTIFY_PEERS notifiers

Jie2x Zhou (1):
      selftests: netfilter: correct PKTGEN_SCRIPT_PATHS in nft_concat_range.sh

Jiri Olsa (4):
      selftests/bpf: Shuffle cookies symbols in kprobe multi test
      ftrace: Keep address offset in ftrace_lookup_symbols
      bpf: Force cookies array to follow symbols sorting
      selftest/bpf: Fix kprobe_multi bench test

Jon Maxwell (1):
      bpf: Fix request_sock leak in sk lookup helpers

Kai-Heng Feng (1):
      igb: Make DMA faster when CPU is active on the PCIe link

Kees Cook (1):
      hinic: Replace memcpy() with direct assignment

Kumar Kartikeya Dwivedi (1):
      bpf: Limit maximum modifier chain length in btf_check_type_tags

Lorenzo Bianconi (1):
      igb: fix a use-after-free issue in igb_clean_tx_ring

Lukas Wunner (1):
      net: phy: smsc: Disable Energy Detect Power-Down in interrupt mode

Marcin Szycik (1):
      ice: ignore protocol field in GTP offload

Masami Hiramatsu (Google) (2):
      fprobe, samples: Add use_trace option and show hit/missed counter
      rethook: Reject getting a rethook if RCU is not watching

Oleksij Rempel (1):
      net: phy: at803x: fix NULL pointer dereference on AR9331 PHY

Peilin Ye (1):
      net/sched: sch_netem: Fix arithmetic in netem_dump() for 32-bit platforms

Riccardo Paolo Bestetti (2):
      ipv4: ping: fix bind address validity check
      ipv4: fix bind address validity regression tests

Rosemarie O'Riorden (1):
      net: openvswitch: fix parsing of nw_proto for IPv6 fragments

Stephan Gerhold (1):
      virtio_net: fix xdp_rxq_info bug after suspend/resume

Vadim Fedorenko (1):
      MAINTAINERS: Add a maintainer for OCP Time Card

Wentao_Liang (1):
      drivers/net/ethernet/neterion/vxge: Fix a use-after-free bug in vxge-main.c

Wojciech Drewek (1):
      ice: Fix switchdev rules book keeping

Xu Jia (1):
      hamradio: 6pack: fix array-index-out-of-bounds in decode_std_command()

Ziyang Xuan (1):
      net/tls: fix tls_sk_proto_close executed repeatedly

 MAINTAINERS                                        | 42 ++++++------
 arch/x86/net/bpf_jit_comp.c                        |  3 +-
 drivers/net/bonding/bond_main.c                    |  4 +-
 drivers/net/dsa/qca8k.c                            | 22 +++++-
 drivers/net/dsa/qca8k.h                            |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_devlink.c  |  4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       | 49 +++++++++++++-
 drivers/net/ethernet/intel/ice/ice_lib.c           | 42 ++++++++++--
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |  5 +-
 drivers/net/ethernet/intel/igb/igb_main.c          | 19 +++---
 drivers/net/hamradio/6pack.c                       |  9 ++-
 drivers/net/phy/aquantia_main.c                    | 15 ++++-
 drivers/net/phy/at803x.c                           |  6 ++
 drivers/net/phy/smsc.c                             |  6 +-
 drivers/net/veth.c                                 |  4 ++
 drivers/net/virtio_net.c                           | 25 ++-----
 include/net/inet_sock.h                            |  5 ++
 kernel/bpf/btf.c                                   |  5 ++
 kernel/trace/bpf_trace.c                           | 60 ++++++++++++-----
 kernel/trace/ftrace.c                              | 13 +++-
 kernel/trace/rethook.c                             |  9 +++
 net/core/dev.c                                     | 25 ++++---
 net/core/filter.c                                  | 34 ++++++++--
 net/core/net-sysfs.c                               |  1 +
 net/core/skmsg.c                                   |  5 ++
 net/ethtool/eeprom.c                               |  2 +-
 net/ipv4/ip_gre.c                                  | 15 +++--
 net/ipv4/ping.c                                    | 10 ++-
 net/ipv4/tcp_bpf.c                                 |  3 -
 net/ipv6/ip6_gre.c                                 | 15 +++--
 net/netfilter/nf_dup_netdev.c                      | 25 +++++--
 net/netfilter/nfnetlink_cttimeout.c                |  2 +-
 net/netfilter/nft_meta.c                           | 13 +---
 net/netfilter/nft_numgen.c                         | 12 +---
 net/openvswitch/flow.c                             |  2 +-
 net/sched/sch_netem.c                              |  4 +-
 net/tipc/core.c                                    |  3 +-
 net/tls/tls_main.c                                 |  2 +
 net/xdp/xsk.c                                      | 16 +++--
 samples/fprobe/fprobe_example.c                    | 29 ++++++--
 .../testing/selftests/bpf/prog_tests/bpf_cookie.c  | 78 +++++++++++-----------
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |  3 +
 tools/testing/selftests/bpf/prog_tests/tailcalls.c | 55 +++++++++++++++
 tools/testing/selftests/bpf/progs/kprobe_multi.c   | 24 +++----
 .../selftests/bpf/progs/tailcall_bpf2bpf6.c        | 42 ++++++++++++
 tools/testing/selftests/net/fcnal-test.sh          | 61 +++++++++++++++--
 .../selftests/netfilter/nft_concat_range.sh        |  2 +-
 47 files changed, 617 insertions(+), 215 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf6.c

