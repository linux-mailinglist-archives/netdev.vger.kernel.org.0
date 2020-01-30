Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3701914DCEA
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 15:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgA3Ol0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 09:41:26 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55048 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbgA3Ol0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 09:41:26 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1344B1495BD07;
        Thu, 30 Jan 2020 06:41:24 -0800 (PST)
Date:   Thu, 30 Jan 2020 15:41:23 +0100 (CET)
Message-Id: <20200130.154123.1710430183269161404.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jan 2020 06:41:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Various mptcp fixupes from Florian Westphal and Geery Uytterhoeven.

2) Don't clear the node/port GUIDs after we've assigned the correct
   values to them.  From Leon Romanovsky.

Please pull, thanks a lot!

The following changes since commit b3a6082223369203d7e7db7e81253ac761377644:

  Merge branch 'for-v5.6' of git://git.kernel.org:/pub/scm/linux/kernel/git/jmorris/linux-security (2020-01-28 18:55:17 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to 9fbf082f569980ddd7cab348e0a118678db0e47e:

  net/core: Do not clear VF index for node/port GUIDs query (2020-01-30 15:20:26 +0100)

----------------------------------------------------------------
David S. Miller (2):
      mptcp: Fix build with PROC_FS disabled.
      Merge branch 'mptcp-fix-sockopt-crash-and-lockdep-splats'

Florian Westphal (4):
      mptcp: defer freeing of cached ext until last moment
      mptcp: fix panic on user pointer access
      mptcp: avoid a lockdep splat when mcast group was joined
      mptcp: handle tcp fallback when using syn cookies

Geert Uytterhoeven (3):
      mptcp: Fix incorrect IPV6 dependency check
      mptcp: MPTCP_HMAC_TEST should depend on MPTCP
      mptcp: Fix undefined mptcp_handle_ipv6_mapped for modular IPV6

Joe Perches (2):
      sch_choke: Use kvcalloc
      net: drop_monitor: Use kstrdup

Leon Romanovsky (1):
      net/core: Do not clear VF index for node/port GUIDs query

Lorenzo Bianconi (1):
      net: mvneta: fix XDP support if sw bm is used as fallback

Mat Martineau (1):
      Revert "MAINTAINERS: mptcp@ mailing list is moderated"

Randy Dunlap (1):
      MAINTAINERS: mptcp@ mailing list is moderated

Willem de Bruijn (1):
      udp: document udp_rcv_segment special case for looped packets

 drivers/net/ethernet/marvell/mvneta.c | 10 +++++++---
 include/linux/tcp.h                   |  2 --
 include/net/mptcp.h                   |  9 +++------
 include/net/udp.h                     |  7 +++++++
 net/core/drop_monitor.c               |  8 ++------
 net/core/rtnetlink.c                  |  4 ++--
 net/ipv4/syncookies.c                 |  4 ++++
 net/ipv4/tcp_input.c                  |  3 +++
 net/ipv6/syncookies.c                 |  3 +++
 net/ipv6/tcp_ipv6.c                   |  6 +++---
 net/mptcp/Kconfig                     |  6 ++++--
 net/mptcp/protocol.c                  | 56 +++++++++++++++++++++++++++++++++-----------------------
 net/mptcp/subflow.c                   | 13 +++++++++----
 net/sched/sch_choke.c                 |  2 +-
 14 files changed, 81 insertions(+), 52 deletions(-)
