Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A12725DC2
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 07:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbfEVFnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 01:43:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50626 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfEVFnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 01:43:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F0F6B14EB68C9;
        Tue, 21 May 2019 22:43:15 -0700 (PDT)
Date:   Tue, 21 May 2019 22:43:13 -0700 (PDT)
Message-Id: <20190521.224313.1147278917444675944.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 May 2019 22:43:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Clear up some recent tipc regressions because of registration ordering.
   Fix from Junwei Hu.

2) tipc's TLV_SET() can read past the end of the supplied buffer during the
   copy.  From Chris Packham.

3) ptp example program doesn't match the kernel, from Richard Cochran.

4) Outgoing message type fix in qrtr, from Bjorn Andersson.

5) Flow control regression in stmmac, from Tan Tee Min.

6) Fix inband autonegotiation in phylink, from Russell King.

7) Fix sk_bound_dev_if handling in rawv6_bind(), from Mike Manning.

8) Fix usbnet crash after disconnect, from Kloetzke Jan.

Please pull, thanks a lot!

The following changes since commit f49aa1de98363b6c5fba4637678d6b0ba3d18065:

  Merge tag 'for-5.2-rc1-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux (2019-05-20 09:52:35 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 

for you to fetch changes up to ad70411a978d1e6e97b1e341a7bde9a79af0c93d:

  usbnet: fix kernel crash after disconnect (2019-05-21 13:46:23 -0700)

----------------------------------------------------------------
Bernd Eckstein (1):
      usbnet: ipheth: fix racing condition

Bjorn Andersson (1):
      net: qrtr: Fix message type of outgoing packets

Chris Packham (1):
      tipc: Avoid copying bytes beyond the supplied data

David S. Miller (2):
      Merge branch 'net-readx_poll_timeout'
      Merge branch 'kselftests-fib_rule_tests-fix'

Erez Alfasi (1):
      net/mlx4_en: ethtool, Remove unsupported SFP EEPROM high pages query

Gustavo A. R. Silva (2):
      macvlan: Mark expected switch fall-through
      vlan: Mark expected switch fall-through

Hangbin Liu (3):
      selftests: fib_rule_tests: fix local IPv4 address typo
      selftests: fib_rule_tests: enable forwarding before ipv4 from/iif test
      selftests: fib_rule_tests: use pre-defined DEV_ADDR

Junwei Hu (1):
      tipc: fix modprobe tipc failed after switch order of device registration

Kloetzke Jan (1):
      usbnet: fix kernel crash after disconnect

Kurt Kanzenbach (2):
      1/2] net: axienet: use readx_poll_timeout() in mdio wait function
      2/2] net: xilinx_emaclite: use readx_poll_timeout() in mdio wait function

Masanari Iida (1):
      net-next: net: Fix typos in ip-sysctl.txt

Mike Manning (1):
      ipv6: Consider sk_bound_dev_if when binding a raw socket to an address

Richard Cochran (1):
      ptp: Fix example program to match kernel.

Russell King (1):
      net: phylink: ensure inband AN works correctly

Tan, Tee Min (1):
      net: stmmac: fix ethtool flow control not able to get/set

Weifeng Voon (1):
      net: stmmac: dma channel control register need to be init first

Weitao Hou (2):
      fddi: fix typos in code comments
      networking: : fix typos in code comments

 Documentation/networking/ip-sysctl.txt               |  4 ++--
 Documentation/networking/segmentation-offloads.rst   |  4 ++--
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c      |  4 +++-
 drivers/net/ethernet/mellanox/mlx4/port.c            |  5 -----
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c |  4 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |  8 ++++----
 drivers/net/ethernet/xilinx/xilinx_axienet.h         |  5 +++++
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c    | 16 ++++++----------
 drivers/net/ethernet/xilinx/xilinx_emaclite.c        | 16 ++++++----------
 drivers/net/fddi/skfp/hwmtm.c                        |  4 ++--
 drivers/net/macvlan.c                                |  1 +
 drivers/net/phy/phylink.c                            | 37 +++++++++++++++----------------------
 drivers/net/usb/ipheth.c                             |  3 ++-
 drivers/net/usb/usbnet.c                             |  6 ++++++
 include/uapi/linux/tipc_config.h                     | 10 +++++++---
 net/8021q/vlan_dev.c                                 |  1 +
 net/ipv6/raw.c                                       |  2 ++
 net/qrtr/qrtr.c                                      |  4 ++--
 net/tipc/core.c                                      | 18 ++++++++++++------
 net/tipc/subscr.h                                    |  5 +++--
 net/tipc/topsrv.c                                    | 14 ++++++++++++--
 tools/testing/selftests/net/fib_rule_tests.sh        | 10 ++++++++--
 tools/testing/selftests/ptp/testptp.c                | 85 +------------------------------------------------------------------------------------
 23 files changed, 104 insertions(+), 162 deletions(-)
