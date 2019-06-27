Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6287F579AE
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 04:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfF0CuH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Jun 2019 22:50:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45858 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbfF0CuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 22:50:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0B20814DE884A;
        Wed, 26 Jun 2019 19:50:07 -0700 (PDT)
Date:   Wed, 26 Jun 2019 19:50:06 -0700 (PDT)
Message-Id: <20190626.195006.2073691861982062351.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 19:50:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix ppp_mppe crypto soft dependencies, from Takashi Iawi.

2) Fix TX completion to be finite, from Sergej Benilov.

3) Use register_pernet_device to avoid a dst leak in tipc, from Xin
   Long.

4) Double free of TX cleanup in Dirk van der Merwe.

5) Memory leak in packet_set_ring(), from Eric Dumazet.

6) Out of bounds read in qmi_wwan, from Bjørn Mork.

7) Fix iif used in mcast/bcast looped back packets, from Stephen
   Suryaputra.

8) Fix neighbour resolution on raw ipv6 sockets, from Nicolas Dichtel.

Please pull, thanks a lot!

The following changes since commit c356dc4b540edd6c02b409dd8cf3208ba2804c38:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2019-06-21 22:23:35 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net 

for you to fetch changes up to 89ed5b519004a7706f50b70f611edbd3aaacff2c:

  af_packet: Block execution of tasks waiting for transmit to complete in AF_PACKET (2019-06-26 19:38:29 -0700)

----------------------------------------------------------------
Antoine Tenart (1):
      net: macb: do not copy the mac address if NULL

Bjørn Mork (1):
      qmi_wwan: Fix out-of-bounds read

David S. Miller (2):
      Merge branch 'smc-fixes'
      Merge branch 'ipv6-fix-neighbour-resolution-with-raw-socket'

Dirk van der Merwe (1):
      net/tls: fix page double free on TX cleanup

Dmitry Bogdanov (1):
      net: aquantia: fix vlans not working over bridged network

Eiichi Tsukata (1):
      net/ipv6: Fix misuse of proc_dointvec "skip_notify_on_dev_down"

Eric Dumazet (1):
      net/packet: fix memory leak in packet_set_ring()

Huaping Zhou (1):
      net/smc: hold conns_lock before calling smc_lgr_register_conn()

Marek Vasut (1):
      net: dsa: microchip: Use gpiod_set_value_cansleep()

Neil Horman (1):
      af_packet: Block execution of tasks waiting for transmit to complete in AF_PACKET

Nicolas Dichtel (2):
      ipv6: constify rt6_nexthop()
      ipv6: fix neighbour resolution with raw socket

Petr Oros (1):
      be2net: fix link failure after ethtool offline test

Roland Hii (2):
      net: stmmac: fixed new system time seconds value calculation
      net: stmmac: set IC bit when transmitting frames with HW timestamp

Sergej Benilov (1):
      sis900: fix TX completion

Stephen Suryaputra (2):
      ipv4: Use return value of inet_iif() for __raw_v4_lookup in the while loop
      ipv4: reset rt_iif for recirculated mcast/bcast out pkts

Takashi Iwai (1):
      ppp: mppe: Add softdep to arc4

Xin Long (3):
      tipc: change to use register_pernet_device
      tipc: check msg->req data len in tipc_nl_compat_bearer_disable
      sctp: change to hold sk after auth shkey is created successfully

YueHaibing (4):
      net/sched: cbs: Fix error path of cbs_module_init
      bonding: Always enable vlan tx offload
      net/smc: Fix error path in smc_init
      team: Always enable vlan tx offload

 drivers/net/bonding/bond_main.c                           |  2 +-
 drivers/net/dsa/microchip/ksz_common.c                    |  6 +++---
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c       | 10 ++++++++--
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c           |  1 +
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h           |  1 +
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c | 19 +++++++++++++------
 drivers/net/ethernet/cadence/macb_main.c                  |  2 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c            | 28 ++++++++++++++++++++++------
 drivers/net/ethernet/sis/sis900.c                         | 16 ++++++++--------
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c     |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c         | 22 ++++++++++++++--------
 drivers/net/ppp/ppp_mppe.c                                |  1 +
 drivers/net/team/team.c                                   |  2 +-
 drivers/net/usb/qmi_wwan.c                                |  2 +-
 drivers/net/vrf.c                                         |  2 +-
 include/net/ip6_route.h                                   |  4 ++--
 include/net/route.h                                       |  1 +
 include/net/tls.h                                         | 15 ---------------
 net/bluetooth/6lowpan.c                                   |  4 ++--
 net/ipv4/ip_output.c                                      | 12 ++++++++++++
 net/ipv4/raw.c                                            |  2 +-
 net/ipv4/route.c                                          | 33 +++++++++++++++++++++++++++++++++
 net/ipv6/ip6_output.c                                     |  2 +-
 net/ipv6/route.c                                          |  5 +++--
 net/netfilter/nf_flow_table_ip.c                          |  2 +-
 net/packet/af_packet.c                                    | 23 +++++++++++++++++++----
 net/packet/internal.h                                     |  1 +
 net/sched/sch_cbs.c                                       |  9 +++++++--
 net/sctp/endpointola.c                                    |  8 ++++----
 net/smc/af_smc.c                                          |  5 ++++-
 net/smc/smc_core.c                                        |  3 +++
 net/tipc/core.c                                           | 12 ++++++------
 net/tipc/netlink_compat.c                                 | 18 +++++++++++++++---
 net/tls/tls_main.c                                        |  3 ++-
 34 files changed, 194 insertions(+), 84 deletions(-)
