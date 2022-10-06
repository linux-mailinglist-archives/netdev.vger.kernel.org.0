Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE62B5F684F
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 15:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiJFNip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 09:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiJFNie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 09:38:34 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E792ABD7A;
        Thu,  6 Oct 2022 06:38:34 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1665063512; bh=tc1drKYFpJhrlGsD/iL8OAMIaHmbnzSgTDEWN72RbNk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Mx6L9f7YjfixGyE4DsQqe7yKhUtuzIf444kmbr4nqq6lHuNe3r1DjOlaPZvvnxilR
         wLia3Yo+2FmMg/Ep410H1/Mj83tXNgAm6TeCPt9s8uKqkkEiR1VYD0AZ7b4VeWiQZ/
         ZxRaH+KbLguVyAxLeq5dtkh+AGTtahtDLQDHopqpaHbWR/vVuvBrdx90bMZTIOUXHl
         WL+DpYyrvx7jdF/E4nrPnjxXmLKEbTuKGBm+aB6o19FNZm/v9q8veFH/gHdcC2b8LV
         pb8/LcfDPAeTEUwlRS16mAIPDszkAf7985CDf3hcWE0E3z4Ne3bfJE3wnZm1YKhztT
         TYmR/q7PSxFaw==
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v1 3/5] treewide: use get_random_u32() when possible
In-Reply-To: <20221005214844.2699-4-Jason@zx2c4.com>
References: <20221005214844.2699-1-Jason@zx2c4.com>
 <20221005214844.2699-4-Jason@zx2c4.com>
Date:   Thu, 06 Oct 2022 15:38:31 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87tu4hdqco.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> The prandom_u32() function has been a deprecated inline wrapper around
> get_random_u32() for several releases now, and compiles down to the
> exact same code. Replace the deprecated wrapper with a direct call to
> the real function.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  Documentation/networking/filter.rst            |  2 +-
>  drivers/infiniband/hw/cxgb4/cm.c               |  4 ++--
>  drivers/infiniband/hw/hfi1/tid_rdma.c          |  2 +-
>  drivers/infiniband/hw/mlx4/mad.c               |  2 +-
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  2 +-
>  drivers/md/raid5-cache.c                       |  2 +-
>  drivers/mtd/nand/raw/nandsim.c                 |  2 +-
>  drivers/net/bonding/bond_main.c                |  2 +-
>  drivers/net/ethernet/broadcom/cnic.c           |  2 +-
>  .../chelsio/inline_crypto/chtls/chtls_cm.c     |  2 +-
>  drivers/net/ethernet/rocker/rocker_main.c      |  6 +++---
>  .../net/wireless/marvell/mwifiex/cfg80211.c    |  4 ++--
>  .../net/wireless/microchip/wilc1000/cfg80211.c |  2 +-
>  .../net/wireless/quantenna/qtnfmac/cfg80211.c  |  2 +-
>  drivers/nvme/common/auth.c                     |  2 +-
>  drivers/scsi/cxgbi/cxgb4i/cxgb4i.c             |  4 ++--
>  drivers/target/iscsi/cxgbit/cxgbit_cm.c        |  2 +-
>  drivers/thunderbolt/xdomain.c                  |  2 +-
>  drivers/video/fbdev/uvesafb.c                  |  2 +-
>  fs/exfat/inode.c                               |  2 +-
>  fs/ext2/ialloc.c                               |  2 +-
>  fs/ext4/ialloc.c                               |  4 ++--
>  fs/ext4/ioctl.c                                |  4 ++--
>  fs/ext4/mmp.c                                  |  2 +-
>  fs/f2fs/namei.c                                |  2 +-
>  fs/fat/inode.c                                 |  2 +-
>  fs/nfsd/nfs4state.c                            |  4 ++--
>  fs/ubifs/journal.c                             |  2 +-
>  fs/xfs/libxfs/xfs_ialloc.c                     |  2 +-
>  fs/xfs/xfs_icache.c                            |  2 +-
>  fs/xfs/xfs_log.c                               |  2 +-
>  include/net/netfilter/nf_queue.h               |  2 +-
>  include/net/red.h                              |  2 +-
>  include/net/sock.h                             |  2 +-
>  kernel/kcsan/selftest.c                        |  2 +-
>  lib/random32.c                                 |  2 +-
>  lib/reed_solomon/test_rslib.c                  |  6 +++---
>  lib/test_fprobe.c                              |  2 +-
>  lib/test_kprobes.c                             |  2 +-
>  lib/test_rhashtable.c                          |  6 +++---
>  mm/shmem.c                                     |  2 +-
>  net/802/garp.c                                 |  2 +-
>  net/802/mrp.c                                  |  2 +-
>  net/core/pktgen.c                              |  4 ++--
>  net/ipv4/tcp_cdg.c                             |  2 +-
>  net/ipv4/udp.c                                 |  2 +-
>  net/ipv6/ip6_flowlabel.c                       |  2 +-
>  net/ipv6/output_core.c                         |  2 +-
>  net/netfilter/ipvs/ip_vs_conn.c                |  2 +-
>  net/netfilter/xt_statistic.c                   |  2 +-
>  net/openvswitch/actions.c                      |  2 +-
>  net/rds/bind.c                                 |  2 +-
>  net/sched/sch_cake.c                           |  2 +-
>  net/sched/sch_netem.c                          | 18 +++++++++---------
>  net/sunrpc/auth_gss/gss_krb5_wrap.c            |  4 ++--
>  net/sunrpc/xprt.c                              |  2 +-
>  net/unix/af_unix.c                             |  2 +-
>  57 files changed, 79 insertions(+), 79 deletions(-)

For sch_cake:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
