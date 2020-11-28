Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE912C6E0D
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 02:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732191AbgK1BA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 20:00:26 -0500
Received: from www62.your-server.de ([213.133.104.62]:53400 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732207AbgK1AwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 19:52:21 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kioS8-0004Es-OG; Sat, 28 Nov 2020 01:51:04 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2020-11-28
Date:   Sat, 28 Nov 2020 01:51:04 +0100
Message-Id: <20201128005104.1205-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26001/Fri Nov 27 14:45:56 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 6 non-merge commits during the last 6 day(s) which contain
a total of 9 files changed, 61 insertions(+), 23 deletions(-).

The main changes are:

1) Do not reference the skb for xsk's generic TX side since when looped
   back into RX it might crash in generic XDP, from Björn Töpel.

2) Fix umem cleanup on a partially set up xsk socket when being destroyed,
   from Magnus Karlsson.

3) Fix an incorrect netdev reference count when failing xsk_bind() operation,
   from Marek Majtyka.

4) Fix bpftool to set an error code on failed calloc() in build_btf_type_table(),
   from Zhen Lei.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Björn Töpel, Hulk Robot, Magnus Karlsson, Marek Majtyka, Yonghong Song

----------------------------------------------------------------

The following changes since commit 3383176efc0fb0c0900a191026468a58668b4214:

  bnxt_en: fix error return code in bnxt_init_board() (2020-11-19 21:49:01 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 9a44bc9449cfe7e39dbadf537ff669fb007a9e63:

  bpf: Add MAINTAINERS entry for BPF LSM (2020-11-25 21:40:27 +0100)

----------------------------------------------------------------
Björn Töpel (1):
      net, xsk: Avoid taking multiple skbuff references

Jesper Dangaard Brouer (1):
      MAINTAINERS: Update XDP and AF_XDP entries

KP Singh (1):
      bpf: Add MAINTAINERS entry for BPF LSM

Magnus Karlsson (1):
      xsk: Fix umem cleanup bug at socket destruct

Marek Majtyka (1):
      xsk: Fix incorrect netdev reference count

Zhen Lei (1):
      bpftool: Fix error return value in build_btf_type_table

 MAINTAINERS               | 23 +++++++++++++++++++++--
 include/linux/netdevice.h | 14 +++++++++++++-
 include/net/xdp_sock.h    |  1 +
 net/core/dev.c            |  8 ++------
 net/xdp/xdp_umem.c        | 19 ++++++++++++++++---
 net/xdp/xdp_umem.h        |  2 +-
 net/xdp/xsk.c             | 10 ++--------
 net/xdp/xsk_buff_pool.c   |  6 ++++--
 tools/bpf/bpftool/btf.c   |  1 +
 9 files changed, 61 insertions(+), 23 deletions(-)
