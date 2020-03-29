Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 625A4196A87
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 03:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgC2Bj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 21:39:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51234 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727725AbgC2Bj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 21:39:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB6A1158CB9B0;
        Sat, 28 Mar 2020 18:39:25 -0700 (PDT)
Date:   Sat, 28 Mar 2020 18:39:23 -0700 (PDT)
Message-Id: <20200328.183923.1567579026552407300.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 28 Mar 2020 18:39:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix memory leak in vti6, from Torsten Hilbrich.

2) Fix double free in xfrm_policy_timer, from YueHaibing.

3) NL80211_ATTR_CHANNEL_WIDTH attribute is put with wrong type,
   from Johannes Berg.

4) Wrong allocation failure check in qlcnic driver, from Xu Wang.

5) Get ks8851-ml IO operations right, for real this time, from
   Marek Vasut.

Please pull, thanks a lot!

The following changes since commit 1b649e0bcae71c118c1333e02249a7510ba7f70a:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-03-25 13:58:05 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to a0ba26f37ea04e025a793ef5e5ac809221728ecb:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2020-03-27 16:18:51 -0700)

----------------------------------------------------------------
David S. Miller (3):
      Merge tag 'mac80211-for-net-2020-03-26' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec
      Merge git://git.kernel.org/.../bpf/bpf

Greg Kroah-Hartman (2):
      bpf: Explicitly memset the bpf_attr structure
      bpf: Explicitly memset some bpf info structures declared on the stack

Heiner Kallweit (1):
      r8169: fix PHY driver check on platforms w/o module softdeps

Ido Schimmel (1):
      mlxsw: spectrum_mr: Fix list iteration in error path

Ilan Peer (1):
      cfg80211: Do not warn on same channel at the end of CSA

Johannes Berg (5):
      nl80211: fix NL80211_ATTR_CHANNEL_WIDTH attribute type
      ieee80211: fix HE SPR size calculation
      mac80211: drop data frames without key on encrypted links
      mac80211: mark station unauthorized before key removal
      mac80211: set IEEE80211_TX_CTRL_PORT_CTRL_PROTO for nl80211 TX

Jouni Malinen (1):
      mac80211: Check port authorization in the ieee80211_tx_dequeue() case

Madhuparna Bhowmik (1):
      ipv6: xfrm6_tunnel.c: Use built-in RCU list checking

Marek Vasut (1):
      net: ks8851-ml: Fix IO operations, again

Martin KaFai Lau (1):
      bpf: Sanitize the bpf_struct_ops tcp-cc name

Nicolas Dichtel (1):
      vti[6]: fix packet tx through bpf_redirect() in XinY cases

Raed Salem (1):
      xfrm: handle NETDEV_UNREGISTER for xfrm device

Torsten Hilbrich (1):
      vti6: Fix memory leak of skb if input policy check fails

Xin Long (3):
      xfrm: fix uctx len check in verify_sec_ctx_len
      xfrm: add the missing verify_sec_ctx_len check in xfrm_add_acquire
      esp: remove the skb from the chain when it's enqueued in cryptd_wq

Xu Wang (1):
      qlcnic: Fix bad kzalloc null test

YueHaibing (1):
      xfrm: policy: Fix doulbe free in xfrm_policy_timer

 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c     |  8 ++++----
 drivers/net/ethernet/micrel/ks8851_mll.c              | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c             | 16 +++++++---------
 include/linux/bpf.h                                   |  1 +
 include/linux/ieee80211.h                             |  4 ++--
 kernel/bpf/btf.c                                      |  3 ++-
 kernel/bpf/syscall.c                                  | 34 ++++++++++++++++++++--------------
 net/ipv4/Kconfig                                      |  1 +
 net/ipv4/bpf_tcp_ca.c                                 |  7 ++-----
 net/ipv4/ip_vti.c                                     | 38 ++++++++++++++++++++++++++++++--------
 net/ipv6/ip6_vti.c                                    | 34 ++++++++++++++++++++++++++--------
 net/ipv6/xfrm6_tunnel.c                               |  2 +-
 net/mac80211/debugfs_sta.c                            |  3 ++-
 net/mac80211/key.c                                    | 20 ++++++++++++--------
 net/mac80211/sta_info.c                               |  7 ++++++-
 net/mac80211/sta_info.h                               |  1 +
 net/mac80211/tx.c                                     | 39 +++++++++++++++++++++++++++++++++------
 net/wireless/nl80211.c                                |  2 +-
 net/wireless/scan.c                                   |  6 +++++-
 net/xfrm/xfrm_device.c                                |  9 +++++----
 net/xfrm/xfrm_policy.c                                |  2 ++
 net/xfrm/xfrm_user.c                                  |  6 +++++-
 23 files changed, 221 insertions(+), 80 deletions(-)
