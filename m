Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2E01EDA60
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 03:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgFDBXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 21:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgFDBXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 21:23:40 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE48C03E96D;
        Wed,  3 Jun 2020 18:23:40 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id s18so4546739ioe.2;
        Wed, 03 Jun 2020 18:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=Oy/zDqNjq7SkcdboqqLXPIMOvB9IosDdE2odvmngmFQ=;
        b=QMUmfD+mGPLSIrSh6Z52gke0Y69lbkXlGocfwe5BXfhpazYPT9h6lzeu4ujRC66zks
         Iw7H4sVBeqhctBmbN+AgyXqkm7Ut4/jKV7ZNheRel0tEPis66+TpM9cZUA4un7PN0Gn5
         T8aSP0uK+F90swmr+WRku62Hcvu2fXD1ClZoQpihtCjW4M+nWvaqAgLH4dbMKIkfW7Yq
         dGNyLuUfDoVNj5JdA1fVycINYOzdUdjhcUSBgHvqilqqRyyWQO9b66YWAN0vZ1f36i+4
         xgO7mm4dmxCCo8d9aKgKcaUmUMaCFxT6SV4eW4YVYBphQuOWJAldnP1G1yrAzgc3rVel
         M0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=Oy/zDqNjq7SkcdboqqLXPIMOvB9IosDdE2odvmngmFQ=;
        b=YDwY1VPywINP5lRTghYpKHYkofDKzcEyRp9svhammvdej0tEYHN4D9+zK7GvgKkcQl
         SodWd+LlNXWL3AAy5Qlb7fJluSbR6DmfxNwBZlBgnKtahcwzVSU8+Dj5JSMdhBSWQLQf
         gQPtKgFrVagEPwBHFqChmK2YV6N9xrWlZXxR169cVXqt2t7KGXuutvxcu+FK1mzGpKkf
         D7FEwu3OqGlMyi0SyxVzt3JlLNQ6qSXIlVj2MAnllks8DFpGG7Oeh2S0mwYN4SxZgrEb
         WKOb0lXfwHMb/hQDNiqsuDscn4z3jXcMFCY7fu+BzNd+V0QcN3G3jO6OGFEiu34XvbRr
         Fwbg==
X-Gm-Message-State: AOAM530l5Qk2CqQ0fo7Ny2xDCQHmF6ZYT7TW0KbbdrxHpiCw0ztqoJoQ
        fKpYNbqy1RTxdTy8cNFMa45xQYH4YbCoTg1ALto=
X-Google-Smtp-Source: ABdhPJxuo6WtjdQmHxN5z3/gGupqGGmO6y/8UjM4X5GvoGqvuVNiOzQvqGosI5ucp/nNVsFnLKFrNvI7DgyMBpPwQ7M=
X-Received: by 2002:a05:6602:2c45:: with SMTP id x5mr2149656iov.80.1591233818415;
 Wed, 03 Jun 2020 18:23:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200603233203.1695403-1-keescook@chromium.org>
In-Reply-To: <20200603233203.1695403-1-keescook@chromium.org>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 4 Jun 2020 03:23:28 +0200
Message-ID: <CA+icZUVZwjM9o7aNXAkYu8K2BQAajw=60varP4g+NizCqu5gRw@mail.gmail.com>
Subject: Re: [PATCH 00/10] Remove uninitialized_var() macro
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mm@kvack.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 4, 2020 at 1:32 AM Kees Cook <keescook@chromium.org> wrote:
>
> Using uninitialized_var() is dangerous as it papers over real bugs[1]
> (or can in the future), and suppresses unrelated compiler warnings
> (e.g. "unused variable"). If the compiler thinks it is uninitialized,
> either simply initialize the variable or make compiler changes.
>
> As recommended[2] by[3] Linus[4], remove the macro.
>
> Most of the 300 uses don't cause any warnings on gcc 9.3.0, so they're in
> a single treewide commit in this series. A few others needed to actually
> get cleaned up, and I broke those out into individual patches.
>
> -Kees
>

Hi Kees,

what is the base for your patchset?
I would like to test on top of Linux v5.7.

Can you place the series in your Git tree for easy fetching, please?

Thanks.

Regards,
- Sedat -

> [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
>
> Kees Cook (10):
>   x86/mm/numa: Remove uninitialized_var() usage
>   drbd: Remove uninitialized_var() usage
>   b43: Remove uninitialized_var() usage
>   rtlwifi: rtl8192cu: Remove uninitialized_var() usage
>   ide: Remove uninitialized_var() usage
>   clk: st: Remove uninitialized_var() usage
>   spi: davinci: Remove uninitialized_var() usage
>   checkpatch: Remove awareness of uninitialized_var() macro
>   treewide: Remove uninitialized_var() usage
>   compiler: Remove uninitialized_var() macro
>
>  arch/arm/mach-sa1100/assabet.c                 |  2 +-
>  arch/arm/mm/alignment.c                        |  2 +-
>  arch/ia64/kernel/process.c                     |  2 +-
>  arch/ia64/mm/discontig.c                       |  2 +-
>  arch/ia64/mm/tlb.c                             |  2 +-
>  arch/mips/lib/dump_tlb.c                       |  2 +-
>  arch/mips/mm/init.c                            |  2 +-
>  arch/mips/mm/tlb-r4k.c                         |  6 +++---
>  arch/powerpc/kvm/book3s_64_mmu_radix.c         |  2 +-
>  arch/powerpc/kvm/book3s_pr.c                   |  2 +-
>  arch/powerpc/kvm/powerpc.c                     |  2 +-
>  arch/powerpc/platforms/52xx/mpc52xx_pic.c      |  2 +-
>  arch/s390/kernel/smp.c                         |  2 +-
>  arch/x86/kernel/quirks.c                       | 10 +++++-----
>  arch/x86/kvm/mmu/mmu.c                         |  2 +-
>  arch/x86/kvm/mmu/paging_tmpl.h                 |  2 +-
>  arch/x86/kvm/x86.c                             |  2 +-
>  arch/x86/mm/numa.c                             | 18 +++++++++---------
>  block/blk-merge.c                              |  2 +-
>  drivers/acpi/acpi_pad.c                        |  2 +-
>  drivers/ata/libata-scsi.c                      |  2 +-
>  drivers/atm/zatm.c                             |  2 +-
>  drivers/block/drbd/drbd_nl.c                   |  6 +++---
>  drivers/block/drbd/drbd_state.c                |  2 +-
>  drivers/block/rbd.c                            |  2 +-
>  drivers/clk/clk-gate.c                         |  2 +-
>  drivers/clk/spear/clk-vco-pll.c                |  2 +-
>  drivers/clk/st/clkgen-fsyn.c                   |  1 -
>  drivers/crypto/nx/nx-842-powernv.c             |  2 +-
>  drivers/firewire/ohci.c                        | 14 +++++++-------
>  drivers/gpu/drm/bridge/sil-sii8620.c           |  2 +-
>  drivers/gpu/drm/drm_edid.c                     |  2 +-
>  drivers/gpu/drm/exynos/exynos_drm_dsi.c        |  6 +++---
>  drivers/gpu/drm/i915/display/intel_fbc.c       |  2 +-
>  drivers/gpu/drm/i915/gt/intel_lrc.c            |  2 +-
>  drivers/gpu/drm/i915/intel_uncore.c            |  2 +-
>  .../gpu/drm/rockchip/dw-mipi-dsi-rockchip.c    |  4 ++--
>  drivers/i2c/busses/i2c-rk3x.c                  |  2 +-
>  drivers/ide/ide-acpi.c                         |  2 +-
>  drivers/ide/ide-atapi.c                        |  2 +-
>  drivers/ide/ide-io-std.c                       |  4 ++--
>  drivers/ide/ide-io.c                           |  8 ++++----
>  drivers/ide/ide-sysfs.c                        |  2 +-
>  drivers/ide/ide-taskfile.c                     |  1 -
>  drivers/ide/umc8672.c                          |  2 +-
>  drivers/idle/intel_idle.c                      |  2 +-
>  drivers/infiniband/core/uverbs_cmd.c           |  4 ++--
>  drivers/infiniband/hw/cxgb4/cm.c               |  2 +-
>  drivers/infiniband/hw/cxgb4/cq.c               |  2 +-
>  drivers/infiniband/hw/mlx4/qp.c                |  6 +++---
>  drivers/infiniband/hw/mlx5/cq.c                |  6 +++---
>  drivers/infiniband/hw/mlx5/devx.c              |  2 +-
>  drivers/infiniband/hw/mlx5/qp.c                |  2 +-
>  drivers/infiniband/hw/mthca/mthca_qp.c         | 10 +++++-----
>  drivers/infiniband/sw/siw/siw_qp_rx.c          |  2 +-
>  drivers/input/serio/serio_raw.c                |  2 +-
>  drivers/input/touchscreen/sur40.c              |  2 +-
>  drivers/iommu/intel-iommu.c                    |  2 +-
>  drivers/md/dm-io.c                             |  2 +-
>  drivers/md/dm-ioctl.c                          |  2 +-
>  drivers/md/dm-snap-persistent.c                |  2 +-
>  drivers/md/dm-table.c                          |  2 +-
>  drivers/md/dm-writecache.c                     |  2 +-
>  drivers/md/raid5.c                             |  2 +-
>  drivers/media/dvb-frontends/rtl2832.c          |  2 +-
>  drivers/media/tuners/qt1010.c                  |  4 ++--
>  drivers/media/usb/gspca/vicam.c                |  2 +-
>  drivers/media/usb/uvc/uvc_video.c              |  8 ++++----
>  drivers/memstick/host/jmb38x_ms.c              |  2 +-
>  drivers/memstick/host/tifm_ms.c                |  2 +-
>  drivers/mmc/host/sdhci.c                       |  2 +-
>  drivers/mtd/nand/raw/nand_ecc.c                |  2 +-
>  drivers/mtd/nand/raw/s3c2410.c                 |  2 +-
>  drivers/mtd/parsers/afs.c                      |  4 ++--
>  drivers/mtd/ubi/eba.c                          |  2 +-
>  drivers/net/can/janz-ican3.c                   |  2 +-
>  drivers/net/ethernet/broadcom/bnx2.c           |  4 ++--
>  .../ethernet/mellanox/mlx5/core/pagealloc.c    |  4 ++--
>  drivers/net/ethernet/neterion/s2io.c           |  2 +-
>  drivers/net/ethernet/qlogic/qla3xxx.c          |  2 +-
>  drivers/net/ethernet/sun/cassini.c             |  2 +-
>  drivers/net/ethernet/sun/niu.c                 |  6 +++---
>  drivers/net/wan/z85230.c                       |  2 +-
>  drivers/net/wireless/ath/ath10k/core.c         |  2 +-
>  drivers/net/wireless/ath/ath6kl/init.c         |  2 +-
>  drivers/net/wireless/ath/ath9k/init.c          |  2 +-
>  drivers/net/wireless/broadcom/b43/debugfs.c    |  2 +-
>  drivers/net/wireless/broadcom/b43/dma.c        |  2 +-
>  drivers/net/wireless/broadcom/b43/lo.c         |  2 +-
>  drivers/net/wireless/broadcom/b43/phy_n.c      | 12 ++++++++----
>  drivers/net/wireless/broadcom/b43/xmit.c       | 12 ++++++------
>  .../net/wireless/broadcom/b43legacy/debugfs.c  |  2 +-
>  drivers/net/wireless/broadcom/b43legacy/main.c |  2 +-
>  drivers/net/wireless/intel/iwlegacy/3945.c     |  2 +-
>  drivers/net/wireless/intel/iwlegacy/4965-mac.c |  2 +-
>  .../wireless/realtek/rtlwifi/rtl8192cu/hw.c    |  8 ++++----
>  drivers/pci/pcie/aer.c                         |  2 +-
>  drivers/platform/x86/hdaps.c                   |  4 ++--
>  drivers/scsi/dc395x.c                          |  2 +-
>  drivers/scsi/pm8001/pm8001_hwi.c               |  2 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c               |  2 +-
>  drivers/spi/spi-davinci.c                      |  1 -
>  drivers/ssb/driver_chipcommon.c                |  4 ++--
>  drivers/tty/cyclades.c                         |  2 +-
>  drivers/tty/isicom.c                           |  2 +-
>  drivers/usb/musb/cppi_dma.c                    |  2 +-
>  drivers/usb/storage/sddr55.c                   |  4 ++--
>  drivers/vhost/net.c                            |  6 +++---
>  drivers/video/fbdev/matrox/matroxfb_maven.c    |  6 +++---
>  drivers/video/fbdev/pm3fb.c                    |  6 +++---
>  drivers/video/fbdev/riva/riva_hw.c             |  3 +--
>  drivers/virtio/virtio_ring.c                   |  6 +++---
>  fs/afs/dir.c                                   |  2 +-
>  fs/afs/security.c                              |  2 +-
>  fs/dlm/netlink.c                               |  2 +-
>  fs/erofs/data.c                                |  4 ++--
>  fs/erofs/zdata.c                               |  2 +-
>  fs/f2fs/data.c                                 |  2 +-
>  fs/fat/dir.c                                   |  2 +-
>  fs/fuse/control.c                              |  4 ++--
>  fs/fuse/cuse.c                                 |  2 +-
>  fs/fuse/file.c                                 |  2 +-
>  fs/gfs2/aops.c                                 |  2 +-
>  fs/gfs2/bmap.c                                 |  2 +-
>  fs/gfs2/lops.c                                 |  2 +-
>  fs/hfsplus/unicode.c                           |  2 +-
>  fs/isofs/namei.c                               |  4 ++--
>  fs/jffs2/erase.c                               |  2 +-
>  fs/nfsd/nfsctl.c                               |  2 +-
>  fs/ocfs2/alloc.c                               |  4 ++--
>  fs/ocfs2/dir.c                                 | 14 +++++++-------
>  fs/ocfs2/extent_map.c                          |  4 ++--
>  fs/ocfs2/namei.c                               |  2 +-
>  fs/ocfs2/refcounttree.c                        |  2 +-
>  fs/ocfs2/xattr.c                               |  2 +-
>  fs/omfs/file.c                                 |  2 +-
>  fs/overlayfs/copy_up.c                         |  4 ++--
>  fs/ubifs/commit.c                              |  6 +++---
>  fs/ubifs/dir.c                                 |  2 +-
>  fs/ubifs/file.c                                |  4 ++--
>  fs/ubifs/journal.c                             |  4 ++--
>  fs/ubifs/lpt.c                                 |  2 +-
>  fs/ubifs/tnc.c                                 |  6 +++---
>  fs/ubifs/tnc_misc.c                            |  4 ++--
>  fs/udf/balloc.c                                |  2 +-
>  fs/xfs/xfs_bmap_util.c                         |  2 +-
>  include/linux/compiler-clang.h                 |  2 --
>  include/linux/compiler-gcc.h                   |  6 ------
>  include/linux/page-flags-layout.h              |  2 +-
>  include/net/flow_offload.h                     |  2 +-
>  kernel/async.c                                 |  4 ++--
>  kernel/audit.c                                 |  2 +-
>  kernel/debug/kdb/kdb_io.c                      |  2 +-
>  kernel/dma/debug.c                             |  2 +-
>  kernel/events/core.c                           |  2 +-
>  kernel/events/uprobes.c                        |  2 +-
>  kernel/exit.c                                  |  2 +-
>  kernel/futex.c                                 | 14 +++++++-------
>  kernel/locking/lockdep.c                       | 16 ++++++++--------
>  kernel/trace/ring_buffer.c                     |  2 +-
>  lib/radix-tree.c                               |  2 +-
>  lib/test_lockup.c                              |  2 +-
>  mm/frontswap.c                                 |  2 +-
>  mm/ksm.c                                       |  2 +-
>  mm/memcontrol.c                                |  2 +-
>  mm/memory.c                                    |  2 +-
>  mm/mempolicy.c                                 |  4 ++--
>  mm/page_alloc.c                                |  2 +-
>  mm/percpu.c                                    |  2 +-
>  mm/slub.c                                      |  4 ++--
>  mm/swap.c                                      |  4 ++--
>  net/dccp/options.c                             |  2 +-
>  net/ipv4/netfilter/nf_socket_ipv4.c            |  6 +++---
>  net/ipv6/ip6_flowlabel.c                       |  2 +-
>  net/ipv6/netfilter/nf_socket_ipv6.c            |  2 +-
>  net/netfilter/nf_conntrack_ftp.c               |  2 +-
>  net/netfilter/nfnetlink_log.c                  |  2 +-
>  net/netfilter/nfnetlink_queue.c                |  4 ++--
>  net/sched/cls_flow.c                           |  2 +-
>  net/sched/sch_cake.c                           |  2 +-
>  net/sched/sch_cbq.c                            |  2 +-
>  net/sched/sch_fq_codel.c                       |  2 +-
>  net/sched/sch_fq_pie.c                         |  2 +-
>  net/sched/sch_hfsc.c                           |  2 +-
>  net/sched/sch_htb.c                            |  2 +-
>  net/sched/sch_sfq.c                            |  2 +-
>  net/sunrpc/svcsock.c                           |  4 ++--
>  net/sunrpc/xprtsock.c                          | 10 +++++-----
>  net/tls/tls_sw.c                               |  2 +-
>  scripts/checkpatch.pl                          | 18 ++++++------------
>  sound/core/control_compat.c                    |  2 +-
>  sound/isa/sb/sb16_csp.c                        |  2 +-
>  sound/usb/endpoint.c                           |  2 +-
>  tools/include/linux/compiler.h                 |  2 --
>  tools/virtio/linux/kernel.h                    |  2 --
>  195 files changed, 310 insertions(+), 328 deletions(-)
>
> --
> 2.25.1
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200603233203.1695403-1-keescook%40chromium.org.
