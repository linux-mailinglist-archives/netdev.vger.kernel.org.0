Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4285195DD
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 01:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfEIXzi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 9 May 2019 19:55:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42962 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfEIXzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 19:55:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 01C6E14DEA669;
        Thu,  9 May 2019 16:55:36 -0700 (PDT)
Date:   Thu, 09 May 2019 16:55:36 -0700 (PDT)
Message-Id: <20190509.165536.716778200205224094.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 16:55:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Several bug fixes, many are quick merge-window regression cures:

1) When NLM_F_EXCL is not set, allow same fib rule insertion.  From
   Hangbin Liu.

2) Several cures in sja1105 DSA driver (while loop exit condition fix,
   return of negative u8, etc.) from Vladimir Oltean.

3) Handle tx/rx delays in realtek PHY driver properly, from Serge
   Semin.

4) Double free in cls_matchall, from Pieter Jansen van Vuuren.

5) Disable SIOCSHWTSTAMP in macvlan/vlan containers, from Hangbin Liu.

6) Endainness fixes in aqc111, from Oliver Neukum.

7) Handle errors in packet_init properly, from Haibing Yue.

8) Various W=1 warning fixes in kTLS, from Jakub Kicinski.

Please pull, thanks a lot!

The following changes since commit 80f232121b69cc69a31ccb2b38c1665d770b0710:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2019-05-07 22:03:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net 

for you to fetch changes up to 6c9f05441477e29783e8391d06c067e4a3b23d47:

  nfp: add missing kdoc (2019-05-09 16:41:46 -0700)

----------------------------------------------------------------
Cheng Han (1):
      dwmac4_prog_mtl_tx_algorithms() missing write operation

Claudiu Manoil (1):
      ptp_qoriq: fix NULL access if ptp dt node missing

Colin Ian King (3):
      net: dsa: lantiq: fix spelling mistake "brigde" -> "bridge"
      net: hns3: remove redundant assignment of l2_hdr to itself
      net: dsa: sja1105: fix check on while loop exit

David Ahern (1):
      ipv4: Fix raw socket lookup for local traffic

David S. Miller (4):
      Merge branch 'phy-realtek-delays'
      Merge tag 'batadv-net-for-davem-20190509' of git://git.open-mesh.org/linux-merge
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch 'tls-warnings'

Gary Lin (1):
      docs/btf: fix the missing section marks

Geert Uytterhoeven (1):
      openvswitch: Replace removed NF_NAT_NEEDED with IS_ENABLED(CONFIG_NF_NAT)

Hangbin Liu (3):
      fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied
      macvlan: disable SIOCSHWTSTAMP in container
      vlan: disable SIOCSHWTSTAMP in container

Jakub Kicinski (4):
      net/tcp: use deferred jump label for TCP acked data hook
      net/tls: remove set but not used variables
      net/tls: handle errors from padding_length()
      nfp: add missing kdoc

Jason Wang (2):
      tuntap: fix dividing by zero in ebpf queue selection
      tuntap: synchronize through tfiles array instead of tun->numqueues

Jiong Wang (1):
      nfp: bpf: fix static check error through tightening shift amount adjustment

Kefeng Wang (1):
      net: aquantia: fix undefined devm_hwmon_device_register_with_info reference

Linus Lüssing (1):
      batman-adv: mcast: fix multicast tt/tvlv worker locking

Lorenz Bauer (1):
      selftests: bpf: initialize bpf_object pointers where needed

Oliver Neukum (3):
      aqc111: fix endianness issue in aqc111_change_mtu
      aqc111: fix writing to the phy on BE
      aqc111: fix double endianness swap on BE

Paolo Abeni (1):
      selinux: do not report error on connect(AF_UNSPEC)

Parthasarathy Bhuvaragan (1):
      tipc: fix hanging clients using poll with EPOLLOUT flag

Pieter Jansen van Vuuren (2):
      nfp: reintroduce ndo_get_port_parent_id for representor ports
      net/sched: avoid double free on matchall reoffload

Serge Semin (2):
      net: phy: realtek: Add rtl8211e rx/tx delays config
      net: phy: realtek: Change TX-delay setting for RGMII modes only

Simon Wunderlich (1):
      batman-adv: Start new development cycle

Vladimir Oltean (1):
      net: dsa: sja1105: Don't return a negative in u8 sja1105_stp_state_get

Wang Hai (1):
      net: dsa: sja1105: Make 'sja1105et_regs' and 'sja1105pqrs_regs' static

YueHaibing (1):
      packet: Fix error path in packet_init

 Documentation/bpf/btf.rst                                 |  2 ++
 drivers/net/dsa/lantiq_gswip.c                            |  8 ++++----
 drivers/net/dsa/sja1105/sja1105_main.c                    |  6 +++++-
 drivers/net/dsa/sja1105/sja1105_spi.c                     | 11 ++++++-----
 drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.c       |  5 +++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c           |  2 +-
 drivers/net/ethernet/netronome/nfp/bpf/jit.c              | 13 ++++++++++++-
 drivers/net/ethernet/netronome/nfp/ccm.h                  |  2 ++
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c         |  1 +
 drivers/net/ethernet/netronome/nfp/nfp_port.c             | 16 ++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c         |  2 ++
 drivers/net/macvlan.c                                     |  2 ++
 drivers/net/phy/realtek.c                                 | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/net/tun.c                                         | 14 ++++++++++++--
 drivers/net/usb/aqc111.c                                  | 31 +++++++++++++++++++++++--------
 drivers/ptp/ptp_qoriq.c                                   |  3 +++
 include/net/tcp.h                                         |  2 +-
 net/8021q/vlan_dev.c                                      |  4 +++-
 net/batman-adv/main.c                                     |  1 +
 net/batman-adv/main.h                                     |  2 +-
 net/batman-adv/multicast.c                                | 11 +++--------
 net/batman-adv/types.h                                    |  5 +++++
 net/core/fib_rules.c                                      |  6 +++---
 net/ipv4/raw.c                                            |  4 ++--
 net/ipv4/tcp_input.c                                      | 16 +++++++++++-----
 net/openvswitch/conntrack.c                               |  4 ++--
 net/packet/af_packet.c                                    | 25 ++++++++++++++++++++-----
 net/sched/cls_matchall.c                                  |  1 +
 net/tipc/socket.c                                         |  4 ++--
 net/tls/tls_device.c                                      |  6 ++----
 net/tls/tls_sw.c                                          | 30 ++++++++++++++++++++++--------
 security/selinux/hooks.c                                  |  8 ++++----
 tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c  |  2 +-
 tools/testing/selftests/bpf/prog_tests/task_fd_query_tp.c |  2 +-
 tools/testing/selftests/bpf/prog_tests/tp_attach_query.c  |  3 +++
 35 files changed, 250 insertions(+), 74 deletions(-)
