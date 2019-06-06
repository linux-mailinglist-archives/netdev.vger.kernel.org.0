Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4417038023
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbfFFWAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:00:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58688 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfFFWAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:00:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8AF3714DA8187;
        Thu,  6 Jun 2019 15:00:11 -0700 (PDT)
Date:   Thu, 06 Jun 2019 15:00:10 -0700 (PDT)
Message-Id: <20190606.150010.895828876779567389.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 15:00:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Free AF_PACKET po->rollover properly, from Willem de Bruijn.

2) Read SFP eeprom in max 16 byte increments to avoid problems with
   some SFP modules, from Russell King.

3) Fix UDP socket lookup wrt. VRF, from Tim Beale.

4) Handle route invalidation properly in s390 qeth driver, from Julian
   Wiedmann.

5) Memory leak on unload in RDS, from Zhu Yanjun.

6) sctp_process_init leak, from Neil HOrman.

7) Fix fib_rules rule insertion semantic change that broke Android,
   from Hangbin Liu.

Please pull, thank you!

The following changes since commit 036e34310931e64ce4f1edead435708cd517db10:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2019-05-30 21:11:22 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net 

for you to fetch changes up to 720f1de4021f09898b8c8443f3b3e995991b6e3a:

  pktgen: do not sleep with the thread lock held. (2019-06-06 11:31:35 -0700)

----------------------------------------------------------------
Alexandra Winter (1):
      s390/qeth: fix VLAN attribute in bridge_hostnotify udev event

David S. Miller (3):
      Merge branch 'net-tls-redo-the-RX-resync-locking'
      Merge branch 's390-qeth-fixes'
      Merge branch 'ipv6-fix-EFAULT-on-sendto-with-icmpv6-and-hdrincl'

Hangbin Liu (1):
      Revert "fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied"

Ivan Khoronzhuk (1):
      net: ethernet: ti: cpsw_ethtool: fix ethtool ring param set

Jakub Kicinski (2):
      Revert "net/tls: avoid NULL-deref on resync during device removal"
      net/tls: replace the sleeping lock around RX resync with a bit lock

Julian Wiedmann (3):
      s390/qeth: handle limited IPv4 broadcast in L3 TX path
      s390/qeth: check dst entry before use
      s390/qeth: handle error when updating TX queue count

Maxime Chevallier (1):
      net: mvpp2: Use strscpy to handle stat strings

Miaohe Lin (1):
      net: ipvlan: Fix ipvlan device tso disabled while NETIF_F_IP_CSUM is set

Neil Horman (1):
      Fix memory leak in sctp_process_init

Nikita Danilov (1):
      net: aquantia: fix wol configuration not applied sometimes

Nikita Yushchenko (1):
      net: dsa: mv88e6xxx: avoid error message on remove from VLAN 0

Olivier Matz (2):
      ipv6: use READ_ONCE() for inet->hdrincl as in ipv4
      ipv6: fix EFAULT on sendto with icmpv6 and hdrincl

Paolo Abeni (2):
      net: fix indirect calls helpers for ptype list hooks.
      pktgen: do not sleep with the thread lock held.

Russell King (2):
      net: sfp: read eeprom in maximum 16 byte increments
      net: phylink: avoid reducing support mask

Sean Wang (2):
      net: ethernet: mediatek: Use hw_feature to judge if HWLRO is supported
      net: ethernet: mediatek: Use NET_IP_ALIGN to judge if HW RX_2BYTE_OFFSET is enabled

Tim Beale (1):
      udp: only choose unbound UDP socket for multicast when not in a VRF

Vivien Didelot (1):
      ethtool: fix potential userspace buffer overflow

Vladimir Oltean (2):
      net: dsa: sja1105: Don't store frame type in skb->cb
      net: dsa: sja1105: Fix link speed not working at 100 Mbps and below

Wei Liu (1):
      Update my email address

Willem de Bruijn (1):
      packet: unconditionally free po->rollover

Xin Long (3):
      selftests: set sysctl bc_forwarding properly in router_broadcast.sh
      ipv4: not do cache for local delivery if bc_forwarding is enabled
      ipv6: fix the check before getting the cookie in rt6_get_cookie

Yonglong Liu (1):
      net: hns: Fix loopback test failed at copper ports

Zhu Yanjun (2):
      net: rds: fix memory leak when unload rds_rdma
      net: rds: fix memory leak in rds_ib_flush_mr_pool

 MAINTAINERS                                                       |  2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                                  |  2 +-
 drivers/net/dsa/sja1105/sja1105_main.c                            | 32 ++++++++++++++++----------------
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c      | 14 +++++++-------
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c |  4 +++-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c                  |  4 ++++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                   |  4 ++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                       | 15 ++++++++-------
 drivers/net/ethernet/ti/cpsw_ethtool.c                            |  2 +-
 drivers/net/ipvlan/ipvlan_main.c                                  |  2 +-
 drivers/net/phy/phylink.c                                         | 13 +++++++++----
 drivers/net/phy/sfp.c                                             | 24 ++++++++++++++++++++----
 drivers/s390/net/qeth_core_main.c                                 | 22 ++++++++++++++++------
 drivers/s390/net/qeth_l2_main.c                                   |  2 +-
 drivers/s390/net/qeth_l3_main.c                                   | 32 +++++++++++++++++++++++++++-----
 include/linux/dsa/sja1105.h                                       | 12 ------------
 include/net/ip6_fib.h                                             |  3 +--
 include/net/tls.h                                                 |  4 ++++
 net/core/dev.c                                                    |  6 +++---
 net/core/ethtool.c                                                |  5 ++++-
 net/core/fib_rules.c                                              |  6 +++---
 net/core/pktgen.c                                                 | 11 +++++++++++
 net/dsa/tag_sja1105.c                                             | 10 +++-------
 net/ipv4/route.c                                                  | 24 ++++++++++++------------
 net/ipv4/udp.c                                                    |  3 +--
 net/ipv6/raw.c                                                    | 25 ++++++++++++++++++-------
 net/packet/af_packet.c                                            |  2 +-
 net/rds/ib.c                                                      |  2 +-
 net/rds/ib_rdma.c                                                 | 10 ++++++----
 net/rds/ib_recv.c                                                 |  3 +++
 net/sctp/sm_make_chunk.c                                          | 13 +++----------
 net/sctp/sm_sideeffect.c                                          |  5 +++++
 net/tls/tls_device.c                                              | 26 ++++++++++++++++++--------
 tools/testing/selftests/net/forwarding/router_broadcast.sh        |  5 ++++-
 34 files changed, 218 insertions(+), 131 deletions(-)
