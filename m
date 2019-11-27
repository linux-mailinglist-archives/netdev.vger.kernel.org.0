Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E29610C0C3
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 00:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbfK0Xnx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Nov 2019 18:43:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37750 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbfK0Xnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 18:43:52 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 21B2914B8FE24;
        Wed, 27 Nov 2019 15:43:52 -0800 (PST)
Date:   Wed, 27 Nov 2019 15:43:49 -0800 (PST)
Message-Id: <20191127.154349.1004587494590963649.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 Nov 2019 15:43:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This is mostly to fix the iwlwifi regression:

1) Flush GRO state properly in iwlwifi driver, from Alexander Lobakin.

2) Validate TIPC link name with properly length macro, from John
   Rutherford.

3) Fix completion init and device query timeouts in ibmvnic, from
   Thomas Falcon.

4) Fix SKB size calculation for netlink messages in psample, from
   Nikolay Aleksandrov.

5) Similar kind of fix for OVS flow dumps, from Paolo Abeni.

6) Handle queue allocation failure unwind properly in gve driver, we
   could try to release pages we didn't allocate.  From Jeroen de
   Borst.

7) Serialize TX queue SKB list accesses properly in mscc ocelot
   driver.  From Yangbo Lu.

Please pull, thanks a lot!

The following changes since commit be2eca94d144e3ffed565c483a58ecc76a869c98:

  Merge tag 'for-linus-5.5-1' of git://github.com/cminyard/linux-ipmi (2019-11-25 21:41:48 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net 

for you to fetch changes up to bac139a846697b290c74fefd6af54a9e192de315:

  net: usb: aqc111: Use the correct style for SPDX License Identifier (2019-11-27 11:27:01 -0800)

----------------------------------------------------------------
Alexander Lobakin (1):
      net: wireless: intel: iwlwifi: fix GRO_NORMAL packet stalling

Dan Murphy (1):
      net: phy: dp83869: Fix return paths to return proper values

David S. Miller (3):
      Merge branch 'ibmvnic-Harden-device-commands-and-queries'
      Merge branch 'net-func-cast'
      Merge branch 'mscc-skb-lists'

Jeroen de Borst (1):
      gve: Fix the queue page list allocated pages count

John Rutherford (1):
      tipc: fix link name length check

Maciej ¯enczykowski (4):
      net: Fix a documentation bug wrt. ip_unprivileged_port_start
      net-sctp: replace some sock_net(sk) with just 'net'
      net: port < inet_prot_sock(net) --> inet_port_requires_bind_service(net, port)
      net: inet_is_local_reserved_port() port arg should be unsigned short

Nikolay Aleksandrov (1):
      net: psample: fix skb_over_panic

Nishad Kamdar (2):
      net: phy: Use the correct style for SPDX License Identifier
      net: usb: aqc111: Use the correct style for SPDX License Identifier

Paolo Abeni (1):
      openvswitch: fix flow command message size

Phong Tran (2):
      net: hso: Fix -Wcast-function-type
      net: usbnet: Fix -Wcast-function-type

Thomas Falcon (4):
      ibmvnic: Fix completion structure initialization
      ibmvnic: Terminate waiting device threads after loss of service
      ibmvnic: Bound waits for device queries
      ibmvnic: Serialize device queries

Yangbo Lu (2):
      net: mscc: ocelot: avoid incorrect consuming in skbs list
      net: mscc: ocelot: use skb queue instead of skbs list

 Documentation/networking/ip-sysctl.txt       |   9 ++---
 drivers/net/ethernet/google/gve/gve_main.c   |   3 +-
 drivers/net/ethernet/ibm/ibmvnic.c           | 192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------
 drivers/net/ethernet/ibm/ibmvnic.h           |   2 ++
 drivers/net/ethernet/mscc/ocelot.c           |  55 ++++++++++-------------------
 drivers/net/phy/aquantia.h                   |   4 +--
 drivers/net/phy/bcm-phy-lib.h                |   2 +-
 drivers/net/phy/dp83869.c                    |  49 +++++++++++++-------------
 drivers/net/phy/mdio-cavium.h                |   2 +-
 drivers/net/phy/mdio-i2c.h                   |   2 +-
 drivers/net/phy/mdio-xgene.h                 |   2 +-
 drivers/net/usb/aqc111.h                     |   4 +--
 drivers/net/usb/hso.c                        |   5 +--
 drivers/net/usb/usbnet.c                     |   9 ++++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c |  13 +++++--
 include/net/ip.h                             |  12 +++----
 include/soc/mscc/ocelot.h                    |   9 +----
 net/ipv4/af_inet.c                           |   2 +-
 net/ipv6/af_inet6.c                          |   2 +-
 net/netfilter/ipvs/ip_vs_ctl.c               |   2 +-
 net/openvswitch/datapath.c                   |   6 +++-
 net/psample/psample.c                        |   2 +-
 net/sctp/socket.c                            |  16 ++++-----
 net/tipc/netlink_compat.c                    |   4 +--
 security/selinux/hooks.c                     |   4 +--
 25 files changed, 277 insertions(+), 135 deletions(-)
