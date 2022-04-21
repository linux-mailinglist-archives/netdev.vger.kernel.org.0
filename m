Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBEA509E0B
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 12:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387523AbiDUKzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 06:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386413AbiDUKzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 06:55:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EF831408C
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 03:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650538376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=c+pS09ATXc5qfcDsfDqiD5I59v90hx8odyi8sTVEL54=;
        b=PNWbgpbxdTGTJkLE+Itr0uE3Zd+2IruAmwEnZYnaG2c953No4At8AxnA/IZGDjUmgBd2Oo
        8rd56MT+59lvjqyVYfPdBgRZoFpz3QU5IgPefgS1ULmxN+ovIonj23UZSV8ux+SIm9b45L
        EeKMBmHGVlMHSfC94Soxn6IIf2Cfd5U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-Hp0fm0l3PU6uU36HoWGvwA-1; Thu, 21 Apr 2022 06:52:55 -0400
X-MC-Unique: Hp0fm0l3PU6uU36HoWGvwA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3CE41014A60;
        Thu, 21 Apr 2022 10:52:54 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.32.181.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DAED145BA74;
        Thu, 21 Apr 2022 10:52:54 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.18-rc4
Date:   Thu, 21 Apr 2022 12:52:18 +0200
Message-Id: <20220421105218.18005-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit d20339fa93e9810fcf87518bdd62e44f62bb64ee:

  Merge tag 'net-5.18-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-04-14 11:58:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc4

for you to fetch changes up to bc6de2878429e85c1f1afaa566f7b5abb2243eef:

  drivers: net: hippi: Fix deadlock in rr_close() (2022-04-21 10:30:45 +0200)

----------------------------------------------------------------
Networking fixes for 5.18-rc4, including fixes from xfrm and can.

Current release - regressions:

  - rxrpc: restore removed timer deletion

Current release - new code bugs:

  - gre: fix device lookup for l3mdev use-case

  - xfrm: fix egress device lookup for l3mdev use-case

Previous releases - regressions:

  - sched: cls_u32: fix netns refcount changes in u32_change()

  - smc: fix sock leak when release after smc_shutdown()

  - xfrm: limit skb_page_frag_refill use to a single page

  - eth: atlantic: invert deep par in pm functions, preventing null
	derefs

  - eth: stmmac: use readl_poll_timeout_atomic() in atomic state

Previous releases - always broken:

  - gre: fix skb_under_panic on xmit

  - openvswitch: fix OOB access in reserve_sfa_size()

  - dsa: hellcreek: calculate checksums in tagger

  - eth: ice: fix crash in switchdev mode

  - eth: igc:
    - fix infinite loop in release_swfw_sync
    - fix scheduling while atomic

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Arun Ramadoss (1):
      net: phy: LAN937x: added PHY_POLL_CABLE_TEST flag

David Ahern (3):
      xfrm: Pass flowi_oif or l3mdev as oif to xfrm_dst_lookup
      l3mdev: l3mdev_master_upper_ifindex_by_index_rcu should be using netdev_master_upper_dev_get_rcu
      net: Handle l3mdev in ip_tunnel_init_flow

David Howells (1):
      rxrpc: Restore removed timer deletion

David S. Miller (3):
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'linux-can-fixes-for-5.18-20220417' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can

Duoming Zhou (1):
      drivers: net: hippi: Fix deadlock in rr_close()

Eric Dumazet (4):
      net/sched: cls_u32: fix netns refcount changes in u32_change()
      net/sched: cls_u32: fix possible leak in u32_init_knode()
      ipv6: make ip6_rt_gc_expire an atomic_t
      netlink: reset network and mac headers in netlink_dump()

Hangbin Liu (1):
      net/packet: fix packet_sock xmit return value checking

Horatiu Vultur (1):
      net: lan966x: Make sure to release ptp interrupt

Ido Schimmel (2):
      selftests: mlxsw: vxlan_flooding: Prevent flooding of unwanted packets
      selftests: mlxsw: vxlan_flooding_ipv6: Prevent flooding of unwanted packets

Jakub Kicinski (3):
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'net-sched-two-fixes-for-cls_u32'
      Merge branch 'l3mdev-fix-ip-tunnel-case-after-recent-l3mdev-change'

Jianglei Nie (1):
      ice: Fix memory leak in ice_get_orom_civd_data()

Kevin Hao (1):
      net: stmmac: Use readl_poll_timeout_atomic() in atomic state

Krzysztof Kozlowski (1):
      nfc: MAINTAINERS: add Bug entry

Kurt Kanzenbach (1):
      net: dsa: hellcreek: Calculate checksums in tagger

Maciej Fijalkowski (2):
      ice: xsk: check if Rx ring was filled up to the end
      ice: allow creating VFs for !CONFIG_NET_SWITCHDEV

Manuel Ullmann (1):
      net: atlantic: invert deep par in pm functions, preventing null derefs

Nicolas Dichtel (1):
      doc/ip-sysctl: add bc_forwarding

Oliver Hartkopp (1):
      can: isotp: stop timeout monitoring when no first frame was sent

Paolo Valerio (1):
      openvswitch: fix OOB access in reserve_sfa_size()

Peilin Ye (2):
      ip6_gre: Avoid updating tunnel->tun_hlen in __gre6_xmit()
      ip6_gre: Fix skb_under_panic in __gre6_xmit()

Sabrina Dubroca (1):
      esp: limit skb_page_frag_refill use to a single page

Sasha Neftin (3):
      igc: Fix infinite loop in release_swfw_sync
      igc: Fix BUG: scheduling while atomic
      e1000e: Fix possible overflow in LTR decoding

Stephen Hemminger (1):
      net: restore alpha order to Ethernet devices in config

Sukadev Bhattiprolu (1):
      powerpc: Update MAINTAINERS for ibmvnic and VAS

Tony Lu (1):
      net/smc: Fix sock leak when release after smc_shutdown()

Vinicius Costa Gomes (1):
      igc: Fix suspending when PTM is active

Vladimir Oltean (1):
      net: mscc: ocelot: fix broken IP multicast flooding

Wojciech Drewek (1):
      ice: fix crash in switchdev mode

suresh kumar (1):
      bonding: do not discard lowest hash bit for non layer3+4 hashing

 Documentation/networking/ip-sysctl.rst             |  7 ++++++
 MAINTAINERS                                        |  3 +--
 drivers/net/bonding/bond_main.c                    | 13 +++++++----
 drivers/net/ethernet/Kconfig                       | 26 +++++++++++-----------
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |  8 +++----
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  4 ++--
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |  3 ++-
 drivers/net/ethernet/intel/ice/ice_eswitch.h       |  2 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c           |  1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  7 +++++-
 drivers/net/ethernet/intel/igc/igc_i225.c          | 11 +++++++--
 drivers/net/ethernet/intel/igc/igc_phy.c           |  4 ++--
 drivers/net/ethernet/intel/igc/igc_ptp.c           | 15 ++++++++++++-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |  2 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |  3 +++
 drivers/net/ethernet/mscc/ocelot.c                 |  2 ++
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |  4 ++--
 drivers/net/hippi/rrunner.c                        |  2 ++
 drivers/net/phy/microchip_t1.c                     |  1 +
 include/net/esp.h                                  |  2 --
 include/net/ip_tunnels.h                           | 11 +++++++--
 include/net/netns/ipv6.h                           |  4 ++--
 net/can/isotp.c                                    | 10 ++++++++-
 net/dsa/tag_hellcreek.c                            |  8 +++++++
 net/ipv4/esp4.c                                    |  5 ++---
 net/ipv4/ip_gre.c                                  |  4 ++--
 net/ipv4/ip_tunnel.c                               |  9 ++++----
 net/ipv6/esp6.c                                    |  5 ++---
 net/ipv6/ip6_gre.c                                 | 14 +++++++-----
 net/ipv6/route.c                                   | 11 ++++-----
 net/l3mdev/l3mdev.c                                |  2 +-
 net/netlink/af_netlink.c                           |  7 ++++++
 net/openvswitch/flow_netlink.c                     |  2 +-
 net/packet/af_packet.c                             | 13 +++++++----
 net/rxrpc/net_ns.c                                 |  2 ++
 net/sched/cls_u32.c                                | 24 +++++++++++---------
 net/smc/af_smc.c                                   |  4 +++-
 net/xfrm/xfrm_policy.c                             |  4 +++-
 .../net/mlxsw/spectrum-2/vxlan_flooding_ipv6.sh    | 17 ++++++++++++++
 .../selftests/drivers/net/mlxsw/vxlan_flooding.sh  | 17 ++++++++++++++
 40 files changed, 210 insertions(+), 83 deletions(-)

