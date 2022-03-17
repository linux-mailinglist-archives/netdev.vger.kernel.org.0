Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9954DCD63
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbiCQSRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbiCQSRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:17:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBE71CAF11;
        Thu, 17 Mar 2022 11:16:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39D4B616EA;
        Thu, 17 Mar 2022 18:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634B1C340E9;
        Thu, 17 Mar 2022 18:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647540988;
        bh=nWqId3WbTiLUsX7rCr5adYD6/O7uzN3/Z1DzPVUsjAo=;
        h=From:To:Cc:Subject:Date:From;
        b=IxmjVXEZtDruYHR0kyX5JDAEYEXNdg4zq6abVG4+XISdhf7m1G3ZNX0rdrRC3FfO+
         8nkiCK17TgcIFjttpGR2h2UBu5CsKO01JXfBLx85sde+LFexKn1NvEOuj4iwUoLcyr
         kFGL7L9CN1aRfpax7+vy/fkasgjdT8dI9K3Wq9iRlHQDPtwuLV2qAKIR3CFpiZ8rOy
         JYOLO9YNGRUVCGo8UyN/B1z/fRl1MGkxSCK4kylCnZcgLwUb15kIt0NMbMWFva/QPZ
         mMrrQBWIODgTiIVFTCqr7RM0S/OFCUi4306YGmWuvydwoDneVfNyLfi9d/XwPcJ/OR
         1Bt3FQGFsFUAQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.17-final
Date:   Thu, 17 Mar 2022 11:16:27 -0700
Message-Id: <20220317181627.487668-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

A few last minute revert / disable and fix patches came down from
our sub-trees. We're not waiting for any fixes at this point.

The following changes since commit 186d32bbf034417b40e2b4e773eeb8ef106c16c1:

  Merge tag 'net-5.17-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-03-10 16:47:58 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-final

for you to fetch changes up to b04683ff8f0823b869c219c78ba0d974bddea0b5:

  iavf: Fix hang during reboot/shutdown (2022-03-17 09:37:37 -0700)

----------------------------------------------------------------
Networking fixes for 5.17-final, including fixes from netfilter, ipsec,
and wireless.

Current release - regressions:

 - Revert "netfilter: nat: force port remap to prevent shadowing
   well-known ports", restore working conntrack on asymmetric paths

 - Revert "ath10k: drop beacon and probe response which leak from
   other channel", restore working AP and mesh mode on QCA9984

 - eth: intel: fix hang during reboot/shutdown

Current release - new code bugs:

 - netfilter: nf_tables: disable register tracking, it needs more
   work to cover all corner cases

Previous releases - regressions:

 - ipv6: fix skb_over_panic in __ip6_append_data when (admin-only)
   extension headers get specified

 - esp6: fix ESP over TCP/UDP, interpret ipv6_skip_exthdr's return
   value more selectively

 - bnx2x: fix driver load failure when FW not present in initrd

Previous releases - always broken:

 - vsock: stop destroying unrelated sockets in nested virtualization

 - packet: fix slab-out-of-bounds access in packet_recvmsg()

Misc:

 - add Paolo Abeni to networking maintainers!

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Claudiu Beznea (1):
      net: dsa: microchip: add spi_device_id tables

David S. Miller (1):
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Doug Berger (1):
      net: bcmgenet: skip invalid partial checksums

Eric Dumazet (1):
      net/packet: fix slab-out-of-bounds access in packet_recvmsg()

Florian Westphal (2):
      Revert "netfilter: nat: force port remap to prevent shadowing well-known ports"
      Revert "netfilter: conntrack: tag conntracks picked up in local out hook"

Haimin Zhang (1):
      af_key: add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register

Ivan Vecera (1):
      iavf: Fix hang during reboot/shutdown

Jakub Kicinski (4):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Add Paolo Abeni to networking maintainers
      Merge tag 'wireless-2022-03-16' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec

Jiasheng Jiang (2):
      atm: eni: Add check for dma_map_single
      hv_netvsc: Add check for kvmalloc_array

Jiyong Park (1):
      vsock: each transport cycles only on its own sockets

Juerg Haefliger (1):
      net: phy: mscc: Add MODULE_FIRMWARE macros

Kalle Valo (1):
      Revert "ath10k: drop beacon and probe response which leak from other channel"

Kurt Cancemi (1):
      net: phy: marvell: Fix invalid comparison in the resume and suspend functions

Maciej Fijalkowski (1):
      ice: fix NULL pointer dereference in ice_update_vsi_tx_ring_stats()

Manish Chopra (1):
      bnx2x: fix built-in kernel driver load failure

Miaoqian Lin (1):
      net: dsa: Add missing of_node_put() in dsa_port_parse_of

Michael Walle (1):
      net: mdio: mscc-miim: fix duplicate debugfs entry

Nicolas Dichtel (1):
      net: handle ARPHRD_PIMREG in dev_is_mac_header_xmit()

Niels Dossche (1):
      alx: acquire mutex for alx_reinit in alx_change_mtu

Pablo Neira Ayuso (1):
      netfilter: nf_tables: disable register tracking

Przemyslaw Patynowski (1):
      iavf: Fix double free in iavf_reset_task

Sabrina Dubroca (1):
      esp6: fix check on ipv6_skip_exthdr's return value

Sudheer Mogilappagari (1):
      ice: destroy flow director filter mutex after releasing VSIs

Tadeusz Struk (1):
      net: ipv6: fix skb_over_panic in __ip6_append_data

Vladimir Oltean (1):
      net: mscc: ocelot: fix backwards compatibility with single-chain tc-flower offload

 MAINTAINERS                                      |  2 ++
 drivers/atm/eni.c                                |  2 ++
 drivers/net/dsa/microchip/ksz8795_spi.c          | 11 ++++++
 drivers/net/dsa/microchip/ksz9477_spi.c          | 12 +++++++
 drivers/net/ethernet/atheros/alx/main.c          |  5 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h      |  2 --
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c  | 28 +++++++++------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 15 ++-------
 drivers/net/ethernet/broadcom/genet/bcmgenet.c   |  6 ++--
 drivers/net/ethernet/intel/iavf/iavf_main.c      | 15 ++++++++-
 drivers/net/ethernet/intel/ice/ice_main.c        |  7 ++--
 drivers/net/ethernet/mscc/ocelot_flower.c        | 16 ++++++++-
 drivers/net/hyperv/netvsc_drv.c                  |  3 ++
 drivers/net/mdio/mdio-mscc-miim.c                |  9 ++++-
 drivers/net/phy/marvell.c                        |  8 ++---
 drivers/net/phy/mscc/mscc_main.c                 |  3 ++
 drivers/net/wireless/ath/ath10k/wmi.c            | 33 +-----------------
 drivers/vhost/vsock.c                            |  3 +-
 include/linux/if_arp.h                           |  1 +
 include/net/af_vsock.h                           |  3 +-
 include/net/netfilter/nf_conntrack.h             |  1 -
 net/dsa/dsa2.c                                   |  1 +
 net/ipv6/esp6.c                                  |  3 +-
 net/ipv6/ip6_output.c                            |  4 +--
 net/key/af_key.c                                 |  2 +-
 net/netfilter/nf_conntrack_core.c                |  3 --
 net/netfilter/nf_nat_core.c                      | 43 ++----------------------
 net/netfilter/nf_tables_api.c                    |  9 +++--
 net/packet/af_packet.c                           | 11 +++++-
 net/vmw_vsock/af_vsock.c                         |  9 +++--
 net/vmw_vsock/virtio_transport.c                 |  7 ++--
 net/vmw_vsock/vmci_transport.c                   |  5 ++-
 tools/testing/selftests/netfilter/nft_nat.sh     |  5 ++-
 33 files changed, 154 insertions(+), 133 deletions(-)
