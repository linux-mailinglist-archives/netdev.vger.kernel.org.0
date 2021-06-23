Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B793B1874
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhFWLKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:10:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230109AbhFWLJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:09:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624446454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ODOU5hswW+B+bZqC14Fry2tBxLecVcrhAvqccjhp3os=;
        b=Tina1GSar22ItnrlbYAEVTr9Se0oR1eHuz29aMasPalN7DPPIcMMqBVe0PotLHjR4UDnXW
        CllrrJ26Gt8ukHbtJ7ncltL6nepLRtlfHUe8b7owgxkli8mP8UgKW+wVV/Rktqq87fIKwZ
        xQjaqLwf/3OR/sUJtZupQYzG8IRv82c=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-N9cDp1qdPUOLPs6WmHgTtw-1; Wed, 23 Jun 2021 07:07:33 -0400
X-MC-Unique: N9cDp1qdPUOLPs6WmHgTtw-1
Received: by mail-ej1-f70.google.com with SMTP id c13-20020a17090603cdb029049617c6be8eso828563eja.19
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:07:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ODOU5hswW+B+bZqC14Fry2tBxLecVcrhAvqccjhp3os=;
        b=TM/W+xSS+L7Ql21EN3Jz5T+geR/GJi2MPP2m7HoPewdGlhuJ1ij9lVToSFiysRzicY
         X5Z/CbRTkdbVkapdtSxtJT8loqPR9FxxVQlUNuG7Aq+eBvOcGh50ufuEAEycaeoa+y5u
         GgZyj2/2/CUn992jYhxYQN9bxEhTUmHjUfsph48dWJIuHO09opViUwFpxTM8L9Cm/L1S
         hF1AHOoVBpCKAfeZ1sYu7wiu+//VuqjXDvkkHxmpHSONM7ilxdyCvJWYg+oQ5aanfsH/
         CIl/SbEwZv9pSB44cuzRzy0kldyG8f0nONyc8PHg/+8TcL0lfpIIvwW9Dkl336TGdeIc
         PMKg==
X-Gm-Message-State: AOAM531kTFZTQ8FLIJQBs4eMuccaCjxG097k73ny1+nDVAvHlMGQxg9q
        d36ywPOcWYOB5SFHNIoyyfxm/h7dYfe0wR7VMPYMEU18R391AUQIRh53GB4Vjlnk8FQyMJBdbxm
        PaSU+3l1N6s5npq3B
X-Received: by 2002:a05:6402:d66:: with SMTP id ec38mr11676251edb.212.1624446450488;
        Wed, 23 Jun 2021 04:07:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzE798RTK+zik4pkwc4nDgSMCxYIimq4+Qyc50RxhJ7/R3P14oFJECIBKEe/icrH26k82Sszw==
X-Received: by 2002:a05:6402:d66:: with SMTP id ec38mr11676196edb.212.1624446450033;
        Wed, 23 Jun 2021 04:07:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id ia20sm3817823ejc.96.2021.06.23.04.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:07:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F36F7180730; Wed, 23 Jun 2021 13:07:27 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v4 00/19] Clean up and document RCU-based object protection for XDP and TC BPF
Date:   Wed, 23 Jun 2021 13:07:08 +0200
Message-Id: <20210623110727.221922-1-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the discussion[0] of Hangbin's multicast patch series, Martin pointed out
that the lifetime of the RCU-protected  map entries used by XDP_REDIRECT is by
no means obvious. I promised to look into cleaning this up, and Paul helpfully
provided some hints and a new unrcu_pointer() helper to aid in this.

It seems[1] that back in the early days of XDP, local_bh_disable() did not
provide RCU protection, which is why the rcu_read_lock() calls were added
to drivers in the first place. But according to Paul[2], in recent kernels
a local_bh_disable()/local_bh_enable() pair functions as one big RCU
read-side section, so no further protection is needed. This even applies to
-rt kernels, which has an explicit rcu_read_lock() in place as part of the
local_bh_disable()[3].

This patch series is mostly a documentation exercise, cleaning up the
description of the lifetime expectations and adding __rcu annotations so
sparse and lockdep can help verify it.

Patches 1-4 are preparatory: Patch 1 adds Paul's unrcu_pointer()
helper (which has already been added to his tree), which we need for some
of the operations in devmap, patches 2 and 3 update the RCU documentation
and patch 4 adds bh context as a valid condition for map lookups. Patch 5
is the main bit that adds the __rcu annotations and updates documentation
comments. Finally, patch 6 removes unneeded rcu_read_lock()s from TC BPF,
and the rest are patches updating the drivers, with one patch per distinct
maintainer.

Unfortunately I don't have any hardware to test any of the driver patches;
Jesper helpfully verified that it doesn't break anything on i40e, but the rest
of the driver patches are only compile-tested.

[0] https://lore.kernel.org/bpf/20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com/
[1] https://lore.kernel.org/bpf/c5192ab3-1c05-8679-79f2-59d98299095b@iogearbox.net/
[2] https://lore.kernel.org/bpf/20210417002301.GO4212@paulmck-ThinkPad-P17-Gen-1/
[3] https://lore.kernel.org/bpf/20210419165837.GA975577@paulmck-ThinkPad-P17-Gen-1/

Changelog:
v4:
  - Move comment about RCU protection into core instead of leaving it in
    drivers
  - Also remove rcu_read_lock() around TC BPF program execution
  - Fold in a couple of patches from Paul updating the RCU documentation
v3:
  - Remove one other unnecessary change to hlist_for_each_entry_rcu()
  - Carry forward another ACK
v2:
  - Add a comment about RCU protection to the drivers where rcu_read_lock()
    is removed
  - Drop unnecessary patch 3 which changed dev_get_by_index_rcu()
  - Add some more text with the history to cover letter
  - Fix a few places where the wrong RCU checks were used in cpumap and
    xskmap code
  - Carry forward ACKs

Paul E. McKenney (2):
  rcu: Create an unrcu_pointer() to remove __rcu from a pointer
  doc: Clarify and expand RCU updaters and corresponding readers

Toke Høiland-Jørgensen (17):
  doc: Give XDP as example of non-obvious RCU reader/updater pairing
  bpf: allow RCU-protected lookups to happen from bh context
  xdp: add proper __rcu annotations to redirect map entries
  sched: remove unneeded rcu_read_lock() around BPF program invocation
  ena: remove rcu_read_lock() around XDP program invocation
  bnxt: remove rcu_read_lock() around XDP program invocation
  thunderx: remove rcu_read_lock() around XDP program invocation
  freescale: remove rcu_read_lock() around XDP program invocation
  net: intel: remove rcu_read_lock() around XDP program invocation
  marvell: remove rcu_read_lock() around XDP program invocation
  mlx4: remove rcu_read_lock() around XDP program invocation
  nfp: remove rcu_read_lock() around XDP program invocation
  qede: remove rcu_read_lock() around XDP program invocation
  sfc: remove rcu_read_lock() around XDP program invocation
  netsec: remove rcu_read_lock() around XDP program invocation
  stmmac: remove rcu_read_lock() around XDP program invocation
  net: ti: remove rcu_read_lock() around XDP program invocation

 Documentation/RCU/checklist.rst               | 55 ++++++++++++-------
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  3 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  2 -
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  2 -
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  8 +--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  3 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  2 -
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  6 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  6 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  6 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |  2 -
 drivers/net/ethernet/intel/igc/igc_main.c     |  7 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  2 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |  6 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 -
 drivers/net/ethernet/marvell/mvneta.c         |  2 -
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  4 --
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  8 +--
 .../ethernet/netronome/nfp/nfp_net_common.c   |  2 -
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |  6 --
 drivers/net/ethernet/sfc/rx.c                 |  9 +--
 drivers/net/ethernet/socionext/netsec.c       |  3 -
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 10 +---
 drivers/net/ethernet/ti/cpsw_priv.c           | 10 +---
 include/linux/filter.h                        | 10 ++--
 include/linux/rcupdate.h                      | 14 +++++
 include/net/xdp_sock.h                        |  2 +-
 kernel/bpf/cpumap.c                           | 13 +++--
 kernel/bpf/devmap.c                           | 49 +++++++----------
 kernel/bpf/hashtab.c                          | 21 ++++---
 kernel/bpf/helpers.c                          |  6 +-
 kernel/bpf/lpm_trie.c                         |  6 +-
 net/core/filter.c                             | 28 ++++++++++
 net/sched/act_bpf.c                           |  2 -
 net/sched/cls_bpf.c                           |  3 -
 net/xdp/xsk.c                                 |  4 +-
 net/xdp/xsk.h                                 |  4 +-
 net/xdp/xskmap.c                              | 29 ++++++----
 38 files changed, 168 insertions(+), 189 deletions(-)

-- 
2.32.0

