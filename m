Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0105F56232C
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 21:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236848AbiF3Tba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 15:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbiF3Tba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 15:31:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF55433BF;
        Thu, 30 Jun 2022 12:31:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C17F622A0;
        Thu, 30 Jun 2022 19:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9478DC34115;
        Thu, 30 Jun 2022 19:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656617487;
        bh=jPdJi0/nzOffc8rPUwpuS/yuozZlbV+MszpZfmmYWak=;
        h=From:To:Cc:Subject:Date:From;
        b=SSU7urCgJeicbqm9QDMAvjOrPnVIvAXYHwnbl++bwrQZaYFwEB0xncpJMBgKdk+Jf
         9Q76lj8f8RvMxzxN0kAZ7J44p8ZfKSc9W++5C7Zw+plkwTdZc+mnvIChKixTceSoX0
         IJ9NBR5lVDhzewaepW5SXdg684DepApKXeeOTqT8rBfBpkcVGgx1ri5Q3V0zywKJM4
         C/q0Jx18FzPZ4zeWj5IWP6e65Zbsc8TiyTWXkCDUZIepTT6v+7QOLKd/mu301LGCMm
         zWszya498AMPkkAEIdkZ0u8cwXR0G2gObgGD3wp7PGLCtd/j8A6bSzeJ1H/YLKtOcm
         GoOusuCfW+9eg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.19-rc5
Date:   Thu, 30 Jun 2022 12:30:44 -0700
Message-Id: <20220630193044.3344841-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 399bd66e219e331976fe6fa6ab81a023c0c97870:

  Merge tag 'net-5.19-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-06-23 09:01:01 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc5

for you to fetch changes up to 58bf4db695287c4bb2a5fc9fc12c78fdd4c36894:

  net: dsa: felix: fix race between reading PSFP stats and port stats (2022-06-30 11:37:09 -0700)

----------------------------------------------------------------
Including fixes from netfilter.

Current release - new code bugs:

 - clear msg_get_inq in __sys_recvfrom() and __copy_msghdr_from_user()

 - mptcp:
   - invoke MP_FAIL response only when needed
   - fix shutdown vs fallback race
   - consistent map handling on failure

 - octeon_ep: use bitwise AND

Previous releases - regressions:

 - tipc: move bc link creation back to tipc_node_create, fix NPD

Previous releases - always broken:

 - tcp: add a missing nf_reset_ct() in 3WHS handling, prevent socket
   buffered skbs from keeping refcount on the conntrack module

 - ipv6: take care of disable_policy when restoring routes

 - tun: make sure to always disable and unlink NAPI instances

 - phy: don't trigger state machine while in suspend

 - netfilter: nf_tables: avoid skb access on nf_stolen

 - asix: fix "can't send until first packet is send" issue

 - usb: asix: do not force pause frames support

 - nxp-nci: don't issue a zero length i2c_master_read()

Misc:

 - ncsi: allow use of proper "mellanox" DT vendor prefix

 - act_api: add a message for user space if any actions were already
   flushed before the error was hit

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Casper Andersson (1):
      net: sparx5: mdb add/del handle non-sparx5 devices

Coleman Dietsch (1):
      selftests net: fix kselftest net fatal error

Dan Carpenter (1):
      net: fix IFF_TX_SKB_NO_LINEAR definition

Dimitris Michailidis (1):
      selftests/net: pass ipv6_args to udpgso_bench's IPv6 TCP test

Doug Berger (1):
      net: dsa: bcm_sf2: force pause link settings

Duoming Zhou (1):
      net: rose: fix UAF bugs caused by timer handler

Enguerrand de Ribaucourt (2):
      net: dp83822: disable false carrier interrupt
      net: dp83822: disable rx error interrupt

Eric Dumazet (5):
      net: clear msg_get_inq in __sys_recvfrom() and __copy_msghdr_from_user()
      tcp: add a missing nf_reset_ct() in 3WHS handling
      tunnels: do not assume mac header is set in skb_tunnel_check_pmtu()
      net: bonding: fix possible NULL deref in rlb code
      ipv6: fix lockdep splat in in6_dump_addrs()

Florian Westphal (2):
      netfilter: nf_tables: avoid skb access on nf_stolen
      netfilter: br_netfilter: do not skip all hooks with 0 priority

Geliang Tang (1):
      mptcp: invoke MP_FAIL response when needed

Hangyu Hua (1):
      net: tipc: fix possible refcount leak in tipc_sk_create()

Jakub Kicinski (8):
      net: tun: unlink NAPI from device on destruction
      Merge branch 'net-dp83822-fix-interrupt-floods'
      net: tun: stop NAPI when detaching queues
      Merge branch 'notify-user-space-if-any-actions-were-flushed-before-error'
      Merge branch 'mptcp-fixes-for-5-19'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      net: tun: avoid disabling NAPI twice
      selftest: tun: add test for NAPI dismantle

Jakub Sitnicki (1):
      selftests/bpf: Test sockmap update when socket has ULP

Jianglei Nie (1):
      net: sfp: fix memory leak in sfp_probe()

Jose Alonso (1):
      net: usb: ax88179_178a: Fix packet receiving

Krzysztof Kozlowski (2):
      net/ncsi: use proper "mellanox" DT vendor prefix
      nfc: nfcmrvl: Fix irq_of_parse_and_map() return value

Liang He (1):
      net/dsa/hirschmann: Add missing of_node_get() in hellcreek_led_setup()

Lukas Wunner (1):
      net: phy: Don't trigger state machine while in suspend

Mat Martineau (1):
      selftests: mptcp: Initialize variables to quiet gcc 12 warnings

Michael Walle (3):
      MAINTAINERS: nfc: drop Charles Gorand from NXP-NCI
      NFC: nxp-nci: Don't issue a zero length i2c_master_read()
      NFC: nxp-nci: don't print header length mismatch on i2c error

Nicolas Dichtel (1):
      ipv6: take care of disable_policy when restoring routes

Oleksij Rempel (3):
      net: asix: fix "can't send until first packet is send" issue
      net: usb: asix: do not force pause frames support
      net: phy: ax88772a: fix lost pause advertisement configuration

Oliver Neukum (1):
      usbnet: fix memory allocation in helpers

Ossama Othman (1):
      mptcp: fix conflict with <netinet/in.h>

Pablo Neira Ayuso (1):
      netfilter: nft_dynset: restore set element counter when failing to update

Paolo Abeni (6):
      mptcp: fix error mibs accounting
      mptcp: introduce MAPPING_BAD_CSUM
      mptcp: fix shutdown vs fallback race
      mptcp: consistent map handling on failure
      mptcp: fix race on unaccepted mptcp sockets
      selftests: mptcp: more stable diag tests

Petr Machata (1):
      mlxsw: spectrum_router: Fix rollback in tunnel next hop init

Shreenidhi Shedi (1):
      octeon_ep: use bitwise AND

Tong Zhang (1):
      epic100: fix use after free on rmmod

Victor Nogueira (2):
      net/sched: act_api: Notify user space if any actions were flushed before error
      selftests: tc-testing: Add testcases to test new flush behaviour

Vladimir Oltean (1):
      net: dsa: felix: fix race between reading PSFP stats and port stats

Xin Long (1):
      tipc: move bc link creation back to tipc_node_create

Yevhen Orlov (1):
      net: bonding: fix use-after-free after 802.3ad slave unbind

YueHaibing (1):
      net: ipv6: unexport __init-annotated seg6_hmac_net_init()

katrinzhou (1):
      ipv6/sit: fix ipip6_tunnel_get_prl return value

 MAINTAINERS                                        |   3 +-
 drivers/net/bonding/bond_3ad.c                     |   3 +-
 drivers/net/bonding/bond_alb.c                     |   2 +-
 drivers/net/dsa/bcm_sf2.c                          |   5 +
 drivers/net/dsa/hirschmann/hellcreek_ptp.c         |   1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   4 +
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h         |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  14 +-
 .../ethernet/microchip/sparx5/sparx5_switchdev.c   |   6 +
 drivers/net/ethernet/smsc/epic100.c                |   4 +-
 drivers/net/phy/ax88796b.c                         |   6 +-
 drivers/net/phy/dp83822.c                          |   4 +-
 drivers/net/phy/phy.c                              |  23 +++
 drivers/net/phy/phy_device.c                       |  23 +++
 drivers/net/phy/sfp.c                              |   2 +-
 drivers/net/tun.c                                  |  15 +-
 drivers/net/usb/asix.h                             |   3 +-
 drivers/net/usb/asix_common.c                      |   1 +
 drivers/net/usb/ax88179_178a.c                     | 101 +++++++++----
 drivers/net/usb/usbnet.c                           |   4 +-
 drivers/nfc/nfcmrvl/i2c.c                          |   6 +-
 drivers/nfc/nfcmrvl/spi.c                          |   6 +-
 drivers/nfc/nxp-nci/i2c.c                          |  11 +-
 include/linux/netdevice.h                          |   2 +-
 include/linux/phy.h                                |   6 +
 include/net/netfilter/nf_tables.h                  |  16 +-
 include/uapi/linux/mptcp.h                         |   9 +-
 net/bridge/br_netfilter_hooks.c                    |  21 ++-
 net/ipv4/ip_tunnel_core.c                          |   2 +-
 net/ipv4/tcp_ipv4.c                                |   6 +-
 net/ipv6/addrconf.c                                |   8 +-
 net/ipv6/route.c                                   |   9 +-
 net/ipv6/seg6_hmac.c                               |   1 -
 net/ipv6/sit.c                                     |   8 +-
 net/mptcp/options.c                                |   7 +-
 net/mptcp/pm.c                                     |  10 +-
 net/mptcp/protocol.c                               |  84 +++++++----
 net/mptcp/protocol.h                               |  24 ++-
 net/mptcp/subflow.c                                | 127 ++++++++++++----
 net/ncsi/ncsi-manage.c                             |   3 +-
 net/netfilter/nf_tables_core.c                     |  24 ++-
 net/netfilter/nf_tables_trace.c                    |  44 +++---
 net/netfilter/nft_set_hash.c                       |   2 +
 net/rose/rose_timer.c                              |  34 +++--
 net/sched/act_api.c                                |  22 ++-
 net/socket.c                                       |  16 +-
 net/tipc/node.c                                    |  41 +++---
 net/tipc/socket.c                                  |   1 +
 .../selftests/bpf/prog_tests/sockmap_ktls.c        |  84 +++++++++--
 tools/testing/selftests/net/Makefile               |   2 +-
 tools/testing/selftests/net/bpf/Makefile           |   2 +-
 tools/testing/selftests/net/mptcp/diag.sh          |  48 +++++-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_inq.c      |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_sockopt.c  |   2 +-
 tools/testing/selftests/net/tun.c                  | 162 +++++++++++++++++++++
 tools/testing/selftests/net/udpgso_bench.sh        |   2 +-
 .../tc-testing/tc-tests/actions/gact.json          |  77 ++++++++++
 58 files changed, 905 insertions(+), 254 deletions(-)
 create mode 100644 tools/testing/selftests/net/tun.c
