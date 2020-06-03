Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4064E1ED93F
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 01:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgFCXcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 19:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgFCXc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 19:32:27 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139C2C08C5C6
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 16:32:23 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x207so2492125pfc.5
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 16:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E2i6w7VHcupsldYagZ/6rCe1Mdx99xg86fdTZZUfCKg=;
        b=BSSBuJdfCCsYebsR+o8mWvPlj2+jmHV8HlsJhlCh544z8256IFtFfhexR8PBrj1fnx
         euybBxtLOvS1XoFlhCiGaNy0/k9kRF+L9tHula9U81EF2IdtLF1QUFk7MtlPjcpkmvvy
         3D7sRA2hTUyyTjOz7n4q+LL1aHKS1c8Y9AiyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E2i6w7VHcupsldYagZ/6rCe1Mdx99xg86fdTZZUfCKg=;
        b=X4m13tH4QQrScZ+3C3rIh8THCje0dkmSgTNN5W2HLrDlomqHBbKiXOFYQJZeCzieHe
         21t9jalj2LM7EHvmftF6Ozz5zE5H4++WeypauAptT4/VoH6W9h+psF/vkvQmVUWnDdE1
         Ue9sckXJbKYMQZsuCLsiTBlbgSlw6wIPFn+SuK9UOK6qQ5JfzsQvSFcYbiiC+keKT3l9
         ZPUTW7G15tB/EsKpGwG4B8CP/A01vhZKL9FDixiPqDwLTYQ+17nxC9NO0AKZpuOE5dqF
         6cI8qvZXbgZg1OaV+OxvWmJT63Im9y5bAyXBcvNT5LGwRSlUsCsLKa7Dnh50g1WNu2qv
         KVzw==
X-Gm-Message-State: AOAM533Qnbp+6sROMmPxt6KDRvpwNFQqvYD2pHqCMfMVuEOs4/dbL3IJ
        vHN8PpzBObtdjgdseZvNhA9Eag==
X-Google-Smtp-Source: ABdhPJyyKzZBEUb46eWjyRpZqpatiFFrSaZEwcPrgk6LLJz5uFIrmm2RyKnruh/EOOfAO57Vt/yvow==
X-Received: by 2002:aa7:8c48:: with SMTP id e8mr1387181pfd.23.1591227141468;
        Wed, 03 Jun 2020 16:32:21 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j16sm2623814pfa.179.2020.06.03.16.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 16:32:16 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mm@kvack.org, clang-built-linux@googlegroups.com
Subject: [PATCH 09/10] treewide: Remove uninitialized_var() usage
Date:   Wed,  3 Jun 2020 16:32:02 -0700
Message-Id: <20200603233203.1695403-10-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200603233203.1695403-1-keescook@chromium.org>
References: <20200603233203.1695403-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using uninitialized_var() is dangerous as it papers over real bugs[1]
(or can in the future), and suppresses unrelated compiler warnings
(e.g. "unused variable"). If the compiler thinks it is uninitialized,
either simply initialize the variable or make compiler changes.

I preparation for removing[2] the[3] macro[4], remove all remaining
needless uses with the following script:

git grep '\buninitialized_var\b' | cut -d: -f1 | sort -u | \
	xargs perl -pi -e \
		's/\buninitialized_var\(([^\)]+)\)/\1/g;
		 s:\s*/\* (GCC be quiet|to make compiler happy) \*/$::g;'

drivers/video/fbdev/riva/riva_hw.c was manually tweaked to avoid
pathological white-space.

No outstanding warnings were found building allmodconfig with GCC 9.3.0
for x86_64, i386, arm64, arm, powerpc, powerpc64le, s390x, mips, sparc64,
alpha, and m68k.

[1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
[2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
[3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
[4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/mach-sa1100/assabet.c                   |  2 +-
 arch/arm/mm/alignment.c                          |  2 +-
 arch/ia64/kernel/process.c                       |  2 +-
 arch/ia64/mm/discontig.c                         |  2 +-
 arch/ia64/mm/tlb.c                               |  2 +-
 arch/mips/lib/dump_tlb.c                         |  2 +-
 arch/mips/mm/init.c                              |  2 +-
 arch/mips/mm/tlb-r4k.c                           |  6 +++---
 arch/powerpc/kvm/book3s_64_mmu_radix.c           |  2 +-
 arch/powerpc/kvm/book3s_pr.c                     |  2 +-
 arch/powerpc/kvm/powerpc.c                       |  2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pic.c        |  2 +-
 arch/s390/kernel/smp.c                           |  2 +-
 arch/x86/kernel/quirks.c                         | 10 +++++-----
 arch/x86/kvm/mmu/mmu.c                           |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h                   |  2 +-
 arch/x86/kvm/x86.c                               |  2 +-
 block/blk-merge.c                                |  2 +-
 drivers/acpi/acpi_pad.c                          |  2 +-
 drivers/ata/libata-scsi.c                        |  2 +-
 drivers/atm/zatm.c                               |  2 +-
 drivers/block/drbd/drbd_nl.c                     |  6 +++---
 drivers/block/rbd.c                              |  2 +-
 drivers/clk/clk-gate.c                           |  2 +-
 drivers/clk/spear/clk-vco-pll.c                  |  2 +-
 drivers/crypto/nx/nx-842-powernv.c               |  2 +-
 drivers/firewire/ohci.c                          | 14 +++++++-------
 drivers/gpu/drm/bridge/sil-sii8620.c             |  2 +-
 drivers/gpu/drm/drm_edid.c                       |  2 +-
 drivers/gpu/drm/exynos/exynos_drm_dsi.c          |  6 +++---
 drivers/gpu/drm/i915/display/intel_fbc.c         |  2 +-
 drivers/gpu/drm/i915/gt/intel_lrc.c              |  2 +-
 drivers/gpu/drm/i915/intel_uncore.c              |  2 +-
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c  |  4 ++--
 drivers/i2c/busses/i2c-rk3x.c                    |  2 +-
 drivers/ide/ide-acpi.c                           |  2 +-
 drivers/ide/ide-atapi.c                          |  2 +-
 drivers/ide/ide-io-std.c                         |  4 ++--
 drivers/ide/ide-io.c                             |  8 ++++----
 drivers/ide/ide-sysfs.c                          |  2 +-
 drivers/ide/umc8672.c                            |  2 +-
 drivers/idle/intel_idle.c                        |  2 +-
 drivers/infiniband/core/uverbs_cmd.c             |  4 ++--
 drivers/infiniband/hw/cxgb4/cm.c                 |  2 +-
 drivers/infiniband/hw/cxgb4/cq.c                 |  2 +-
 drivers/infiniband/hw/mlx4/qp.c                  |  6 +++---
 drivers/infiniband/hw/mlx5/cq.c                  |  6 +++---
 drivers/infiniband/hw/mlx5/devx.c                |  2 +-
 drivers/infiniband/hw/mlx5/qp.c                  |  2 +-
 drivers/infiniband/hw/mthca/mthca_qp.c           | 10 +++++-----
 drivers/infiniband/sw/siw/siw_qp_rx.c            |  2 +-
 drivers/input/serio/serio_raw.c                  |  2 +-
 drivers/input/touchscreen/sur40.c                |  2 +-
 drivers/iommu/intel-iommu.c                      |  2 +-
 drivers/md/dm-io.c                               |  2 +-
 drivers/md/dm-ioctl.c                            |  2 +-
 drivers/md/dm-snap-persistent.c                  |  2 +-
 drivers/md/dm-table.c                            |  2 +-
 drivers/md/dm-writecache.c                       |  2 +-
 drivers/md/raid5.c                               |  2 +-
 drivers/media/dvb-frontends/rtl2832.c            |  2 +-
 drivers/media/tuners/qt1010.c                    |  4 ++--
 drivers/media/usb/gspca/vicam.c                  |  2 +-
 drivers/media/usb/uvc/uvc_video.c                |  8 ++++----
 drivers/memstick/host/jmb38x_ms.c                |  2 +-
 drivers/memstick/host/tifm_ms.c                  |  2 +-
 drivers/mmc/host/sdhci.c                         |  2 +-
 drivers/mtd/nand/raw/nand_ecc.c                  |  2 +-
 drivers/mtd/nand/raw/s3c2410.c                   |  2 +-
 drivers/mtd/parsers/afs.c                        |  4 ++--
 drivers/mtd/ubi/eba.c                            |  2 +-
 drivers/net/can/janz-ican3.c                     |  2 +-
 drivers/net/ethernet/broadcom/bnx2.c             |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c  |  4 ++--
 drivers/net/ethernet/neterion/s2io.c             |  2 +-
 drivers/net/ethernet/qlogic/qla3xxx.c            |  2 +-
 drivers/net/ethernet/sun/cassini.c               |  2 +-
 drivers/net/ethernet/sun/niu.c                   |  6 +++---
 drivers/net/wan/z85230.c                         |  2 +-
 drivers/net/wireless/ath/ath10k/core.c           |  2 +-
 drivers/net/wireless/ath/ath6kl/init.c           |  2 +-
 drivers/net/wireless/ath/ath9k/init.c            |  2 +-
 drivers/net/wireless/broadcom/b43/debugfs.c      |  2 +-
 drivers/net/wireless/broadcom/b43/dma.c          |  2 +-
 drivers/net/wireless/broadcom/b43/lo.c           |  2 +-
 drivers/net/wireless/broadcom/b43/phy_n.c        |  2 +-
 drivers/net/wireless/broadcom/b43/xmit.c         | 12 ++++++------
 .../net/wireless/broadcom/b43legacy/debugfs.c    |  2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c   |  2 +-
 drivers/net/wireless/intel/iwlegacy/3945.c       |  2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c   |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c  |  4 ++--
 drivers/pci/pcie/aer.c                           |  2 +-
 drivers/platform/x86/hdaps.c                     |  4 ++--
 drivers/scsi/dc395x.c                            |  2 +-
 drivers/scsi/pm8001/pm8001_hwi.c                 |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                 |  2 +-
 drivers/ssb/driver_chipcommon.c                  |  4 ++--
 drivers/tty/cyclades.c                           |  2 +-
 drivers/tty/isicom.c                             |  2 +-
 drivers/usb/musb/cppi_dma.c                      |  2 +-
 drivers/usb/storage/sddr55.c                     |  4 ++--
 drivers/vhost/net.c                              |  6 +++---
 drivers/video/fbdev/matrox/matroxfb_maven.c      |  6 +++---
 drivers/video/fbdev/pm3fb.c                      |  6 +++---
 drivers/video/fbdev/riva/riva_hw.c               |  3 +--
 drivers/virtio/virtio_ring.c                     |  6 +++---
 fs/afs/dir.c                                     |  2 +-
 fs/afs/security.c                                |  2 +-
 fs/dlm/netlink.c                                 |  2 +-
 fs/erofs/data.c                                  |  4 ++--
 fs/erofs/zdata.c                                 |  2 +-
 fs/f2fs/data.c                                   |  2 +-
 fs/fat/dir.c                                     |  2 +-
 fs/fuse/control.c                                |  4 ++--
 fs/fuse/cuse.c                                   |  2 +-
 fs/fuse/file.c                                   |  2 +-
 fs/gfs2/aops.c                                   |  2 +-
 fs/gfs2/bmap.c                                   |  2 +-
 fs/gfs2/lops.c                                   |  2 +-
 fs/hfsplus/unicode.c                             |  2 +-
 fs/isofs/namei.c                                 |  4 ++--
 fs/jffs2/erase.c                                 |  2 +-
 fs/nfsd/nfsctl.c                                 |  2 +-
 fs/ocfs2/alloc.c                                 |  4 ++--
 fs/ocfs2/dir.c                                   | 14 +++++++-------
 fs/ocfs2/extent_map.c                            |  4 ++--
 fs/ocfs2/namei.c                                 |  2 +-
 fs/ocfs2/refcounttree.c                          |  2 +-
 fs/ocfs2/xattr.c                                 |  2 +-
 fs/omfs/file.c                                   |  2 +-
 fs/overlayfs/copy_up.c                           |  4 ++--
 fs/ubifs/commit.c                                |  6 +++---
 fs/ubifs/dir.c                                   |  2 +-
 fs/ubifs/file.c                                  |  4 ++--
 fs/ubifs/journal.c                               |  4 ++--
 fs/ubifs/lpt.c                                   |  2 +-
 fs/ubifs/tnc.c                                   |  6 +++---
 fs/ubifs/tnc_misc.c                              |  4 ++--
 fs/udf/balloc.c                                  |  2 +-
 fs/xfs/xfs_bmap_util.c                           |  2 +-
 include/net/flow_offload.h                       |  2 +-
 kernel/async.c                                   |  4 ++--
 kernel/audit.c                                   |  2 +-
 kernel/debug/kdb/kdb_io.c                        |  2 +-
 kernel/dma/debug.c                               |  2 +-
 kernel/events/core.c                             |  2 +-
 kernel/events/uprobes.c                          |  2 +-
 kernel/exit.c                                    |  2 +-
 kernel/futex.c                                   | 14 +++++++-------
 kernel/locking/lockdep.c                         | 16 ++++++++--------
 kernel/trace/ring_buffer.c                       |  2 +-
 lib/radix-tree.c                                 |  2 +-
 lib/test_lockup.c                                |  2 +-
 mm/frontswap.c                                   |  2 +-
 mm/ksm.c                                         |  2 +-
 mm/memcontrol.c                                  |  2 +-
 mm/memory.c                                      |  2 +-
 mm/mempolicy.c                                   |  4 ++--
 mm/page_alloc.c                                  |  2 +-
 mm/percpu.c                                      |  2 +-
 mm/slub.c                                        |  4 ++--
 mm/swap.c                                        |  4 ++--
 net/dccp/options.c                               |  2 +-
 net/ipv4/netfilter/nf_socket_ipv4.c              |  6 +++---
 net/ipv6/ip6_flowlabel.c                         |  2 +-
 net/ipv6/netfilter/nf_socket_ipv6.c              |  2 +-
 net/netfilter/nf_conntrack_ftp.c                 |  2 +-
 net/netfilter/nfnetlink_log.c                    |  2 +-
 net/netfilter/nfnetlink_queue.c                  |  4 ++--
 net/sched/cls_flow.c                             |  2 +-
 net/sched/sch_cake.c                             |  2 +-
 net/sched/sch_cbq.c                              |  2 +-
 net/sched/sch_fq_codel.c                         |  2 +-
 net/sched/sch_fq_pie.c                           |  2 +-
 net/sched/sch_hfsc.c                             |  2 +-
 net/sched/sch_htb.c                              |  2 +-
 net/sched/sch_sfq.c                              |  2 +-
 net/sunrpc/svcsock.c                             |  4 ++--
 net/sunrpc/xprtsock.c                            | 10 +++++-----
 net/tls/tls_sw.c                                 |  2 +-
 sound/core/control_compat.c                      |  2 +-
 sound/isa/sb/sb16_csp.c                          |  2 +-
 sound/usb/endpoint.c                             |  2 +-
 184 files changed, 284 insertions(+), 285 deletions(-)

diff --git a/arch/arm/mach-sa1100/assabet.c b/arch/arm/mach-sa1100/assabet.c
index d96a101e5504..2f305c7ce1cb 100644
--- a/arch/arm/mach-sa1100/assabet.c
+++ b/arch/arm/mach-sa1100/assabet.c
@@ -653,7 +653,7 @@ static void __init map_sa1100_gpio_regs( void )
  */
 static void __init get_assabet_scr(void)
 {
-	unsigned long uninitialized_var(scr), i;
+	unsigned long scr, i;
 
 	GPDR |= 0x3fc;			/* Configure GPIO 9:2 as outputs */
 	GPSR = 0x3fc;			/* Write 0xFF to GPIO 9:2 */
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 84718eddae60..9620dc4678cd 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -799,7 +799,7 @@ static int alignment_get_thumb(struct pt_regs *regs, u16 *ip, u16 *inst)
 static int
 do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 {
-	union offset_union uninitialized_var(offset);
+	union offset_union offset;
 	unsigned long instrptr;
 	int (*handler)(unsigned long addr, u32 instr, struct pt_regs *regs);
 	unsigned int type;
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 10cb9382ab76..eebe3ee7b5b5 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -444,7 +444,7 @@ static void
 do_copy_task_regs (struct task_struct *task, struct unw_frame_info *info, void *arg)
 {
 	unsigned long mask, sp, nat_bits = 0, ar_rnat, urbs_end, cfm;
-	unsigned long uninitialized_var(ip);	/* GCC be quiet */
+	unsigned long ip;
 	elf_greg_t *dst = arg;
 	struct pt_regs *pt;
 	char nat;
diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
index 4f33f6e7e206..5dc6cf9116f0 100644
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -180,7 +180,7 @@ static void *per_cpu_node_setup(void *cpu_data, int node)
 void __init setup_per_cpu_areas(void)
 {
 	struct pcpu_alloc_info *ai;
-	struct pcpu_group_info *uninitialized_var(gi);
+	struct pcpu_group_info *gi;
 	unsigned int *cpu_map;
 	void *base;
 	unsigned long base_offset;
diff --git a/arch/ia64/mm/tlb.c b/arch/ia64/mm/tlb.c
index 72cc568bc841..71c19918e387 100644
--- a/arch/ia64/mm/tlb.c
+++ b/arch/ia64/mm/tlb.c
@@ -369,7 +369,7 @@ EXPORT_SYMBOL(flush_tlb_range);
 
 void ia64_tlb_init(void)
 {
-	ia64_ptce_info_t uninitialized_var(ptce_info); /* GCC be quiet */
+	ia64_ptce_info_t ptce_info;
 	u64 tr_pgbits;
 	long status;
 	pal_vm_info_1_u_t vm_info_1;
diff --git a/arch/mips/lib/dump_tlb.c b/arch/mips/lib/dump_tlb.c
index 83ed37298e66..0ba6f746485f 100644
--- a/arch/mips/lib/dump_tlb.c
+++ b/arch/mips/lib/dump_tlb.c
@@ -80,7 +80,7 @@ static void dump_tlb(int first, int last)
 	unsigned int pagemask, guestctl1 = 0, c0, c1, i;
 	unsigned long asidmask = cpu_asid_mask(&current_cpu_data);
 	int asidwidth = DIV_ROUND_UP(ilog2(asidmask) + 1, 4);
-	unsigned long uninitialized_var(s_mmid);
+	unsigned long s_mmid;
 #ifdef CONFIG_32BIT
 	bool xpa = cpu_has_xpa && (read_c0_pagegrain() & PG_ELPA);
 	int pwidth = xpa ? 11 : 8;
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 79684000de0e..378af36891e9 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -84,7 +84,7 @@ void setup_zero_pages(void)
 static void *__kmap_pgprot(struct page *page, unsigned long addr, pgprot_t prot)
 {
 	enum fixed_addresses idx;
-	unsigned int uninitialized_var(old_mmid);
+	unsigned int old_mmid;
 	unsigned long vaddr, flags, entrylo;
 	unsigned long old_ctx;
 	pte_t pte;
diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index d7a9d5f211f0..839e96c0bf8a 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -120,7 +120,7 @@ void local_flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 		if (size <= (current_cpu_data.tlbsizeftlbsets ?
 			     current_cpu_data.tlbsize / 8 :
 			     current_cpu_data.tlbsize / 2)) {
-			unsigned long old_entryhi, uninitialized_var(old_mmid);
+			unsigned long old_entryhi, old_mmid;
 			int newpid = cpu_asid(cpu, mm);
 
 			old_entryhi = read_c0_entryhi();
@@ -214,7 +214,7 @@ void local_flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
 	int cpu = smp_processor_id();
 
 	if (cpu_context(cpu, vma->vm_mm) != 0) {
-		unsigned long uninitialized_var(old_mmid);
+		unsigned long old_mmid;
 		unsigned long flags, old_entryhi;
 		int idx;
 
@@ -383,7 +383,7 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
 #ifdef CONFIG_XPA
 	panic("Broken for XPA kernels");
 #else
-	unsigned int uninitialized_var(old_mmid);
+	unsigned int old_mmid;
 	unsigned long flags;
 	unsigned long wired;
 	unsigned long old_pagemask;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index aa12cd4078b3..e9ef7e05bb0d 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -33,7 +33,7 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid,
 					      gva_t eaddr, void *to, void *from,
 					      unsigned long n)
 {
-	int uninitialized_var(old_pid), old_lpid;
+	int old_pid, old_lpid;
 	unsigned long quadrant, ret = n;
 	bool is_load = !!to;
 
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index a0f6813f4560..a71fa7204882 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1829,7 +1829,7 @@ static int kvmppc_vcpu_run_pr(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 {
 	int ret;
 #ifdef CONFIG_ALTIVEC
-	unsigned long uninitialized_var(vrsave);
+	unsigned long vrsave;
 #endif
 
 	/* Check if we can run the vcpu at all */
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index ad2f172c26a6..ab25ab276394 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1110,7 +1110,7 @@ static inline u32 dp_to_sp(u64 fprd)
 static void kvmppc_complete_mmio_load(struct kvm_vcpu *vcpu,
                                       struct kvm_run *run)
 {
-	u64 uninitialized_var(gpr);
+	u64 gpr;
 
 	if (run->mmio.len > sizeof(gpr)) {
 		printk(KERN_ERR "bad MMIO length: %d\n", run->mmio.len);
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pic.c b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
index fc98912f42cf..76a8102bdb98 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pic.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
@@ -340,7 +340,7 @@ static int mpc52xx_irqhost_map(struct irq_domain *h, unsigned int virq,
 {
 	int l1irq;
 	int l2irq;
-	struct irq_chip *uninitialized_var(irqchip);
+	struct irq_chip *irqchip;
 	void *hndlr;
 	int type;
 	u32 reg;
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 10dbb12eb14d..8b0aa78ab409 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -145,7 +145,7 @@ static int pcpu_sigp_retry(struct pcpu *pcpu, u8 order, u32 parm)
 
 static inline int pcpu_stopped(struct pcpu *pcpu)
 {
-	u32 uninitialized_var(status);
+	u32 status;
 
 	if (__pcpu_sigp(pcpu->address, SIGP_SENSE,
 			0, &status) != SIGP_CC_STATUS_STORED)
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 896d74cb5081..1b10717c9321 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -95,7 +95,7 @@ static void ich_force_hpet_resume(void)
 static void ich_force_enable_hpet(struct pci_dev *dev)
 {
 	u32 val;
-	u32 uninitialized_var(rcba);
+	u32 rcba;
 	int err = 0;
 
 	if (hpet_address || force_hpet_address)
@@ -185,7 +185,7 @@ static void hpet_print_force_info(void)
 static void old_ich_force_hpet_resume(void)
 {
 	u32 val;
-	u32 uninitialized_var(gen_cntl);
+	u32 gen_cntl;
 
 	if (!force_hpet_address || !cached_dev)
 		return;
@@ -207,7 +207,7 @@ static void old_ich_force_hpet_resume(void)
 static void old_ich_force_enable_hpet(struct pci_dev *dev)
 {
 	u32 val;
-	u32 uninitialized_var(gen_cntl);
+	u32 gen_cntl;
 
 	if (hpet_address || force_hpet_address)
 		return;
@@ -298,7 +298,7 @@ static void vt8237_force_hpet_resume(void)
 
 static void vt8237_force_enable_hpet(struct pci_dev *dev)
 {
-	u32 uninitialized_var(val);
+	u32 val;
 
 	if (hpet_address || force_hpet_address)
 		return;
@@ -429,7 +429,7 @@ static void nvidia_force_hpet_resume(void)
 
 static void nvidia_force_enable_hpet(struct pci_dev *dev)
 {
-	u32 uninitialized_var(val);
+	u32 val;
 
 	if (hpet_address || force_hpet_address)
 		return;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fd59fee84631..ca21061c61a8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1986,7 +1986,7 @@ static int kvm_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			 unsigned long data)
 {
 	u64 *sptep;
-	struct rmap_iterator uninitialized_var(iter);
+	struct rmap_iterator iter;
 	int young = 0;
 
 	for_each_rmap_spte(rmap_head, &iter, sptep)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 9bdf9b7d9a96..1a5fb266b525 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -314,7 +314,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 {
 	int ret;
 	pt_element_t pte;
-	pt_element_t __user *uninitialized_var(ptep_user);
+	pt_element_t __user *ptep_user;
 	gfn_t table_gfn;
 	u64 pt_access, pte_access;
 	unsigned index, accessed_dirty, pte_pkey;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c17e6eb9ad43..eddf4fa46da3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9833,7 +9833,7 @@ void kvm_arch_sync_events(struct kvm *kvm)
 int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 {
 	int i, r;
-	unsigned long hva, uninitialized_var(old_npages);
+	unsigned long hva, old_npages;
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	struct kvm_memory_slot *slot;
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index f0b0bae075a0..006402edef6b 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -473,7 +473,7 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
 			     struct scatterlist *sglist,
 			     struct scatterlist **sg)
 {
-	struct bio_vec uninitialized_var(bvec), bvprv = { NULL };
+	struct bio_vec bvec, bvprv = { NULL };
 	struct bvec_iter iter;
 	int nsegs = 0;
 	bool new_bio = false;
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index e7dc0133f817..6cc4c92d9ff9 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -88,7 +88,7 @@ static void round_robin_cpu(unsigned int tsk_index)
 	cpumask_var_t tmp;
 	int cpu;
 	unsigned long min_weight = -1;
-	unsigned long uninitialized_var(preferred_cpu);
+	unsigned long preferred_cpu;
 
 	if (!alloc_cpumask_var(&tmp, GFP_KERNEL))
 		return;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 435781a16875..fcb00f2825fe 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -93,7 +93,7 @@ static ssize_t ata_scsi_park_show(struct device *device,
 	struct ata_link *link;
 	struct ata_device *dev;
 	unsigned long now;
-	unsigned int uninitialized_var(msecs);
+	unsigned int msecs;
 	int rc = 0;
 
 	ap = ata_shost_to_port(sdev->host);
diff --git a/drivers/atm/zatm.c b/drivers/atm/zatm.c
index 57f97b95a453..165eebe06e39 100644
--- a/drivers/atm/zatm.c
+++ b/drivers/atm/zatm.c
@@ -940,7 +940,7 @@ static int open_tx_first(struct atm_vcc *vcc)
 	    vcc->qos.txtp.max_pcr >= ATM_OC3_PCR);
 	if (unlimited && zatm_dev->ubr != -1) zatm_vcc->shaper = zatm_dev->ubr;
 	else {
-		int uninitialized_var(pcr);
+		int pcr;
 
 		if (unlimited) vcc->qos.txtp.max_sdu = ATM_MAX_AAL5_PDU;
 		if ((zatm_vcc->shaper = alloc_shaper(vcc->dev,&pcr,
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index da4a3ebe04ef..c0017cc51ecc 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -3423,7 +3423,7 @@ int drbd_adm_dump_devices(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nlattr *resource_filter;
 	struct drbd_resource *resource;
-	struct drbd_device *uninitialized_var(device);
+	struct drbd_device *device;
 	int minor, err, retcode;
 	struct drbd_genlmsghdr *dh;
 	struct device_info device_info;
@@ -3512,7 +3512,7 @@ int drbd_adm_dump_connections(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nlattr *resource_filter;
 	struct drbd_resource *resource = NULL, *next_resource;
-	struct drbd_connection *uninitialized_var(connection);
+	struct drbd_connection *connection;
 	int err = 0, retcode;
 	struct drbd_genlmsghdr *dh;
 	struct connection_info connection_info;
@@ -3674,7 +3674,7 @@ int drbd_adm_dump_peer_devices(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nlattr *resource_filter;
 	struct drbd_resource *resource;
-	struct drbd_device *uninitialized_var(device);
+	struct drbd_device *device;
 	struct drbd_peer_device *peer_device = NULL;
 	int minor, err, retcode;
 	struct drbd_genlmsghdr *dh;
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 67d65ac785e9..3253192e3cef 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1973,7 +1973,7 @@ static int rbd_object_map_update_finish(struct rbd_obj_request *obj_req,
 	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
 	struct ceph_osd_data *osd_data;
 	u64 objno;
-	u8 state, new_state, uninitialized_var(current_state);
+	u8 state, new_state, current_state;
 	bool has_current_state;
 	void *p;
 
diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
index 2ca1f2ac38a6..070dc47e95a1 100644
--- a/drivers/clk/clk-gate.c
+++ b/drivers/clk/clk-gate.c
@@ -56,7 +56,7 @@ static void clk_gate_endisable(struct clk_hw *hw, int enable)
 {
 	struct clk_gate *gate = to_clk_gate(hw);
 	int set = gate->flags & CLK_GATE_SET_TO_DISABLE ? 1 : 0;
-	unsigned long uninitialized_var(flags);
+	unsigned long flags;
 	u32 reg;
 
 	set ^= enable;
diff --git a/drivers/clk/spear/clk-vco-pll.c b/drivers/clk/spear/clk-vco-pll.c
index c08dec30bfa6..d01b2ee7cdd8 100644
--- a/drivers/clk/spear/clk-vco-pll.c
+++ b/drivers/clk/spear/clk-vco-pll.c
@@ -147,7 +147,7 @@ static int clk_pll_set_rate(struct clk_hw *hw, unsigned long drate,
 	struct clk_pll *pll = to_clk_pll(hw);
 	struct pll_rate_tbl *rtbl = pll->vco->rtbl;
 	unsigned long flags = 0, val;
-	int uninitialized_var(i);
+	int i;
 
 	clk_pll_round_rate_index(hw, drate, NULL, &i);
 
diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index c037a2403b82..2db33280d189 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -854,7 +854,7 @@ static int __init nx842_powernv_probe_vas(struct device_node *pn)
 	struct device_node *dn;
 	int chip_id, vasid, ret = 0;
 	int nx_fifo_found = 0;
-	int uninitialized_var(ct);
+	int ct;
 
 	chip_id = of_get_ibm_chip_id(pn);
 	if (chip_id < 0) {
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 33269316f111..4f49382ee49c 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -1099,7 +1099,7 @@ static void context_tasklet(unsigned long data)
 static int context_add_buffer(struct context *ctx)
 {
 	struct descriptor_buffer *desc;
-	dma_addr_t uninitialized_var(bus_addr);
+	dma_addr_t bus_addr;
 	int offset;
 
 	/*
@@ -1289,7 +1289,7 @@ static int at_context_queue_packet(struct context *ctx,
 				   struct fw_packet *packet)
 {
 	struct fw_ohci *ohci = ctx->ohci;
-	dma_addr_t d_bus, uninitialized_var(payload_bus);
+	dma_addr_t d_bus, payload_bus;
 	struct driver_data *driver_data;
 	struct descriptor *d, *last;
 	__le32 *header;
@@ -2445,7 +2445,7 @@ static int ohci_set_config_rom(struct fw_card *card,
 {
 	struct fw_ohci *ohci;
 	__be32 *next_config_rom;
-	dma_addr_t uninitialized_var(next_config_rom_bus);
+	dma_addr_t next_config_rom_bus;
 
 	ohci = fw_ohci(card);
 
@@ -2933,10 +2933,10 @@ static struct fw_iso_context *ohci_allocate_iso_context(struct fw_card *card,
 				int type, int channel, size_t header_size)
 {
 	struct fw_ohci *ohci = fw_ohci(card);
-	struct iso_context *uninitialized_var(ctx);
-	descriptor_callback_t uninitialized_var(callback);
-	u64 *uninitialized_var(channels);
-	u32 *uninitialized_var(mask), uninitialized_var(regs);
+	struct iso_context *ctx;
+	descriptor_callback_t callback;
+	u64 *channels;
+	u32 *mask, regs;
 	int index, ret = -EBUSY;
 
 	spin_lock_irq(&ohci->lock);
diff --git a/drivers/gpu/drm/bridge/sil-sii8620.c b/drivers/gpu/drm/bridge/sil-sii8620.c
index 92acd336aa89..6cd8e012de5d 100644
--- a/drivers/gpu/drm/bridge/sil-sii8620.c
+++ b/drivers/gpu/drm/bridge/sil-sii8620.c
@@ -986,7 +986,7 @@ static void sii8620_set_auto_zone(struct sii8620 *ctx)
 
 static void sii8620_stop_video(struct sii8620 *ctx)
 {
-	u8 uninitialized_var(val);
+	u8 val;
 
 	sii8620_write_seq_static(ctx,
 		REG_TPI_INTR_EN, 0,
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index fed653f13c26..b98fa573e706 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -3051,7 +3051,7 @@ static int drm_cvt_modes(struct drm_connector *connector,
 	const u8 empty[3] = { 0, 0, 0 };
 
 	for (i = 0; i < 4; i++) {
-		int uninitialized_var(width), height;
+		int width, height;
 		cvt = &(timing->data.other_data.data.cvt[i]);
 
 		if (!memcmp(cvt->code, empty, 3))
diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
index ee96a95fb6be..7a6f6df5e954 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -547,9 +547,9 @@ static unsigned long exynos_dsi_pll_find_pms(struct exynos_dsi *dsi,
 	unsigned long best_freq = 0;
 	u32 min_delta = 0xffffffff;
 	u8 p_min, p_max;
-	u8 _p, uninitialized_var(best_p);
-	u16 _m, uninitialized_var(best_m);
-	u8 _s, uninitialized_var(best_s);
+	u8 _p, best_p;
+	u16 _m, best_m;
+	u8 _s, best_s;
 
 	p_min = DIV_ROUND_UP(fin, (12 * MHZ));
 	p_max = fin / (6 * MHZ);
diff --git a/drivers/gpu/drm/i915/display/intel_fbc.c b/drivers/gpu/drm/i915/display/intel_fbc.c
index 1c26673acb2d..c3a83c06c1b5 100644
--- a/drivers/gpu/drm/i915/display/intel_fbc.c
+++ b/drivers/gpu/drm/i915/display/intel_fbc.c
@@ -474,7 +474,7 @@ static int intel_fbc_alloc_cfb(struct drm_i915_private *dev_priv,
 			       unsigned int size, unsigned int fb_cpp)
 {
 	struct intel_fbc *fbc = &dev_priv->fbc;
-	struct drm_mm_node *uninitialized_var(compressed_llb);
+	struct drm_mm_node *compressed_llb;
 	int ret;
 
 	drm_WARN_ON(&dev_priv->drm,
diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 87e6c5bdd2dc..8b1b7463fff8 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1103,7 +1103,7 @@ static struct i915_request *
 __unwind_incomplete_requests(struct intel_engine_cs *engine)
 {
 	struct i915_request *rq, *rn, *active = NULL;
-	struct list_head *uninitialized_var(pl);
+	struct list_head *pl;
 	int prio = I915_PRIORITY_INVALID;
 
 	lockdep_assert_held(&engine->active.lock);
diff --git a/drivers/gpu/drm/i915/intel_uncore.c b/drivers/gpu/drm/i915/intel_uncore.c
index a61cb8ca4d50..c8fd2bcb17ee 100644
--- a/drivers/gpu/drm/i915/intel_uncore.c
+++ b/drivers/gpu/drm/i915/intel_uncore.c
@@ -1991,7 +1991,7 @@ int __intel_wait_for_register_fw(struct intel_uncore *uncore,
 				 unsigned int slow_timeout_ms,
 				 u32 *out_value)
 {
-	u32 uninitialized_var(reg_value);
+	u32 reg_value;
 #define done (((reg_value = intel_uncore_read_fw(uncore, reg)) & mask) == value)
 	int ret;
 
diff --git a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
index 3feff0c45b3f..542dcf7eddd6 100644
--- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
@@ -517,8 +517,8 @@ dw_mipi_dsi_get_lane_mbps(void *priv_data, const struct drm_display_mode *mode,
 	unsigned long best_freq = 0;
 	unsigned long fvco_min, fvco_max, fin, fout;
 	unsigned int min_prediv, max_prediv;
-	unsigned int _prediv, uninitialized_var(best_prediv);
-	unsigned long _fbdiv, uninitialized_var(best_fbdiv);
+	unsigned int _prediv, best_prediv;
+	unsigned long _fbdiv, best_fbdiv;
 	unsigned long min_delta = ULONG_MAX;
 
 	dsi->format = format;
diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index 73272d4296bb..b0959ad5834c 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -415,7 +415,7 @@ static void rk3x_i2c_handle_read(struct rk3x_i2c *i2c, unsigned int ipd)
 {
 	unsigned int i;
 	unsigned int len = i2c->msg->len - i2c->processed;
-	u32 uninitialized_var(val);
+	u32 val;
 	u8 byte;
 
 	/* we only care for MBRF here. */
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 7d4e5c08f133..05e18d658141 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -180,7 +180,7 @@ static int ide_get_dev_handle(struct device *dev, acpi_handle *handle,
 static acpi_handle ide_acpi_hwif_get_handle(ide_hwif_t *hwif)
 {
 	struct device		*dev = hwif->gendev.parent;
-	acpi_handle		uninitialized_var(dev_handle);
+	acpi_handle		dev_handle;
 	u64			pcidevfn;
 	acpi_handle		chan_handle;
 	int			err;
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 80bc3bf82f4d..2162bc80f09e 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -609,7 +609,7 @@ static int ide_delayed_transfer_pc(ide_drive_t *drive)
 
 static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 {
-	struct ide_atapi_pc *uninitialized_var(pc);
+	struct ide_atapi_pc *pc;
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
 	ide_expiry_t *expiry;
diff --git a/drivers/ide/ide-io-std.c b/drivers/ide/ide-io-std.c
index 18c20a7aa0ce..94bdcf1ea186 100644
--- a/drivers/ide/ide-io-std.c
+++ b/drivers/ide/ide-io-std.c
@@ -173,7 +173,7 @@ void ide_input_data(ide_drive_t *drive, struct ide_cmd *cmd, void *buf,
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 
 	if (io_32bit) {
-		unsigned long uninitialized_var(flags);
+		unsigned long flags;
 
 		if ((io_32bit & 2) && !mmio) {
 			local_irq_save(flags);
@@ -217,7 +217,7 @@ void ide_output_data(ide_drive_t *drive, struct ide_cmd *cmd, void *buf,
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 
 	if (io_32bit) {
-		unsigned long uninitialized_var(flags);
+		unsigned long flags;
 
 		if ((io_32bit & 2) && !mmio) {
 			local_irq_save(flags);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index c31f1d2b3b07..1a53c7a75224 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -622,12 +622,12 @@ static int drive_is_ready(ide_drive_t *drive)
 void ide_timer_expiry (struct timer_list *t)
 {
 	ide_hwif_t	*hwif = from_timer(hwif, t, timer);
-	ide_drive_t	*uninitialized_var(drive);
+	ide_drive_t	*drive;
 	ide_handler_t	*handler;
 	unsigned long	flags;
 	int		wait = -1;
 	int		plug_device = 0;
-	struct request	*uninitialized_var(rq_in_flight);
+	struct request	*rq_in_flight;
 
 	spin_lock_irqsave(&hwif->lock, flags);
 
@@ -780,13 +780,13 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 {
 	ide_hwif_t *hwif = (ide_hwif_t *)dev_id;
 	struct ide_host *host = hwif->host;
-	ide_drive_t *uninitialized_var(drive);
+	ide_drive_t *drive;
 	ide_handler_t *handler;
 	unsigned long flags;
 	ide_startstop_t startstop;
 	irqreturn_t irq_ret = IRQ_NONE;
 	int plug_device = 0;
-	struct request *uninitialized_var(rq_in_flight);
+	struct request *rq_in_flight;
 
 	if (host->host_flags & IDE_HFLAG_SERIALIZE) {
 		if (hwif != host->cur_port)
diff --git a/drivers/ide/ide-sysfs.c b/drivers/ide/ide-sysfs.c
index b9dfeb2e8bd6..c08a8a0916e2 100644
--- a/drivers/ide/ide-sysfs.c
+++ b/drivers/ide/ide-sysfs.c
@@ -131,7 +131,7 @@ static struct device_attribute *ide_port_attrs[] = {
 
 int ide_sysfs_register_port(ide_hwif_t *hwif)
 {
-	int i, uninitialized_var(rc);
+	int i, rc;
 
 	for (i = 0; ide_port_attrs[i]; i++) {
 		rc = device_create_file(hwif->portdev, ide_port_attrs[i]);
diff --git a/drivers/ide/umc8672.c b/drivers/ide/umc8672.c
index 870e235e30af..cf996f788292 100644
--- a/drivers/ide/umc8672.c
+++ b/drivers/ide/umc8672.c
@@ -108,7 +108,7 @@ static void umc_set_speeds(u8 speeds[])
 static void umc_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	ide_hwif_t *mate = hwif->mate;
-	unsigned long uninitialized_var(flags);
+	unsigned long flags;
 	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
 	printk("%s: setting umc8672 to PIO mode%d (speed %d)\n",
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index f4495841bf68..aae53e650638 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -132,7 +132,7 @@ static __cpuidle int intel_idle(struct cpuidle_device *dev,
 	struct cpuidle_state *state = &drv->states[index];
 	unsigned long eax = flg2MWAIT(state->flags);
 	unsigned long ecx = 1; /* break on interrupt flag */
-	bool uninitialized_var(tick);
+	bool tick;
 	int cpu = smp_processor_id();
 
 	/*
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 060b4ebbd2ba..f6f084e84892 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1574,7 +1574,7 @@ static int ib_uverbs_open_qp(struct uverbs_attr_bundle *attrs)
 	struct ib_uverbs_create_qp_resp resp;
 	struct ib_uqp_object           *obj;
 	struct ib_xrcd		       *xrcd;
-	struct ib_uobject	       *uninitialized_var(xrcd_uobj);
+	struct ib_uobject	       *xrcd_uobj;
 	struct ib_qp                   *qp;
 	struct ib_qp_open_attr          attr = {};
 	int ret;
@@ -3394,7 +3394,7 @@ static int __uverbs_create_xsrq(struct uverbs_attr_bundle *attrs,
 	struct ib_usrq_object           *obj;
 	struct ib_pd                    *pd;
 	struct ib_srq                   *srq;
-	struct ib_uobject               *uninitialized_var(xrcd_uobj);
+	struct ib_uobject               *xrcd_uobj;
 	struct ib_srq_init_attr          attr;
 	int ret;
 	struct ib_device *ib_dev;
diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 30e08bcc9afb..77bc02a9228e 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3282,7 +3282,7 @@ static int get_lladdr(struct net_device *dev, struct in6_addr *addr,
 
 static int pick_local_ip6addrs(struct c4iw_dev *dev, struct iw_cm_id *cm_id)
 {
-	struct in6_addr uninitialized_var(addr);
+	struct in6_addr addr;
 	struct sockaddr_in6 *la6 = (struct sockaddr_in6 *)&cm_id->m_local_addr;
 	struct sockaddr_in6 *ra6 = (struct sockaddr_in6 *)&cm_id->m_remote_addr;
 
diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index b1bb61c65f4f..352b8af1998a 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -754,7 +754,7 @@ static int poll_cq(struct t4_wq *wq, struct t4_cq *cq, struct t4_cqe *cqe,
 static int __c4iw_poll_cq_one(struct c4iw_cq *chp, struct c4iw_qp *qhp,
 			      struct ib_wc *wc, struct c4iw_srq *srq)
 {
-	struct t4_cqe uninitialized_var(cqe);
+	struct t4_cqe cqe;
 	struct t4_wq *wq = qhp ? &qhp->wq : NULL;
 	u32 credit = 0;
 	u8 cqe_flushed;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index cf51e3cbd969..f9ca6e000a81 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -3541,11 +3541,11 @@ static int _mlx4_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 	int nreq;
 	int err = 0;
 	unsigned ind;
-	int uninitialized_var(size);
-	unsigned uninitialized_var(seglen);
+	int size;
+	unsigned seglen;
 	__be32 dummy;
 	__be32 *lso_wqe;
-	__be32 uninitialized_var(lso_hdr_sz);
+	__be32 lso_hdr_sz;
 	__be32 blh;
 	int i;
 	struct mlx4_ib_dev *mdev = to_mdev(ibqp->device);
diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 146ba2966744..ef57f68d8f97 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -924,8 +924,8 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
 	u32 out[MLX5_ST_SZ_DW(create_cq_out)];
-	int uninitialized_var(index);
-	int uninitialized_var(inlen);
+	int index;
+	int inlen;
 	u32 *cqb = NULL;
 	void *cqc;
 	int cqe_size;
@@ -1245,7 +1245,7 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata)
 	__be64 *pas;
 	int page_shift;
 	int inlen;
-	int uninitialized_var(cqe_size);
+	int cqe_size;
 	unsigned long flags;
 
 	if (!MLX5_CAP_GEN(dev->mdev, cq_resize)) {
diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 46e1ab771f10..bda1a95457f9 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -2533,7 +2533,7 @@ static ssize_t devx_async_event_read(struct file *filp, char __user *buf,
 {
 	struct devx_async_event_file *ev_file = filp->private_data;
 	struct devx_event_subscription *event_sub;
-	struct devx_async_event_data *uninitialized_var(event);
+	struct devx_async_event_data *event;
 	int ret = 0;
 	size_t eventsz;
 	bool omit_data;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 2210759843ba..f156663773b9 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5037,7 +5037,7 @@ static int _mlx5_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 	struct mlx5_wqe_xrc_seg *xrc;
 	struct mlx5_bf *bf;
 	void *cur_edge;
-	int uninitialized_var(size);
+	int size;
 	unsigned long flags;
 	unsigned idx;
 	int err = 0;
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index d04c245359eb..c6e95d0d760a 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -1639,8 +1639,8 @@ int mthca_tavor_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 	 * without initializing f0 and size0, and they are in fact
 	 * never used uninitialized.
 	 */
-	int uninitialized_var(size0);
-	u32 uninitialized_var(f0);
+	int size0;
+	u32 f0;
 	int ind;
 	u8 op0 = 0;
 
@@ -1835,7 +1835,7 @@ int mthca_tavor_post_receive(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 	 * without initializing size0, and it is in fact never used
 	 * uninitialized.
 	 */
-	int uninitialized_var(size0);
+	int size0;
 	int ind;
 	void *wqe;
 	void *prev_wqe;
@@ -1943,8 +1943,8 @@ int mthca_arbel_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 	 * without initializing f0 and size0, and they are in fact
 	 * never used uninitialized.
 	 */
-	int uninitialized_var(size0);
-	u32 uninitialized_var(f0);
+	int size0;
+	u32 f0;
 	int ind;
 	u8 op0 = 0;
 
diff --git a/drivers/infiniband/sw/siw/siw_qp_rx.c b/drivers/infiniband/sw/siw/siw_qp_rx.c
index 650520244ed0..9ccce2909ac4 100644
--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -332,7 +332,7 @@ static struct siw_wqe *siw_rqe_get(struct siw_qp *qp)
 	struct siw_srq *srq;
 	struct siw_wqe *wqe = NULL;
 	bool srq_event = false;
-	unsigned long uninitialized_var(flags);
+	unsigned long flags;
 
 	srq = qp->srq;
 	if (srq) {
diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index e9647ebff187..1e4770094415 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -159,7 +159,7 @@ static ssize_t serio_raw_read(struct file *file, char __user *buffer,
 {
 	struct serio_raw_client *client = file->private_data;
 	struct serio_raw *serio_raw = client->serio_raw;
-	char uninitialized_var(c);
+	char c;
 	ssize_t read = 0;
 	int error;
 
diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 34d31c7ec8ba..76142ca90c33 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -456,7 +456,7 @@ static void sur40_poll(struct input_dev *input)
 {
 	struct sur40_state *sur40 = input_get_drvdata(input);
 	int result, bulk_read, need_blobs, packet_blobs, i;
-	u32 uninitialized_var(packet_id);
+	u32 packet_id;
 
 	struct sur40_header *header = &sur40->bulk_in_buffer->header;
 	struct sur40_blob *inblob = &sur40->bulk_in_buffer->blobs[0];
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 0182cff2c7ac..b0c43e852b4e 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2313,7 +2313,7 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 			    unsigned long nr_pages, int prot)
 {
 	struct dma_pte *first_pte = NULL, *pte = NULL;
-	phys_addr_t uninitialized_var(pteval);
+	phys_addr_t pteval;
 	unsigned long sg_res = 0;
 	unsigned int largepage_lvl = 0;
 	unsigned long lvl_pages = 0;
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 81ffc59d05c9..4312007d2d34 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -306,7 +306,7 @@ static void do_region(int op, int op_flags, unsigned region,
 	struct request_queue *q = bdev_get_queue(where->bdev);
 	unsigned short logical_block_size = queue_logical_block_size(q);
 	sector_t num_sectors;
-	unsigned int uninitialized_var(special_cmd_max_sectors);
+	unsigned int special_cmd_max_sectors;
 
 	/*
 	 * Reject unsupported discard and write same requests.
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index ac83f5002ce5..b95f822ff39a 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1844,7 +1844,7 @@ static int ctl_ioctl(struct file *file, uint command, struct dm_ioctl __user *us
 	int ioctl_flags;
 	int param_flags;
 	unsigned int cmd;
-	struct dm_ioctl *uninitialized_var(param);
+	struct dm_ioctl *param;
 	ioctl_fn fn = NULL;
 	size_t input_param_size;
 	struct dm_ioctl param_kernel;
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 963d3774c93e..247089c2be25 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -613,7 +613,7 @@ static int persistent_read_metadata(struct dm_exception_store *store,
 						    chunk_t old, chunk_t new),
 				    void *callback_context)
 {
-	int r, uninitialized_var(new_snapshot);
+	int r, new_snapshot;
 	struct pstore *ps = get_info(store);
 
 	/*
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 8277b959e00b..89d7cda07640 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -642,7 +642,7 @@ static int validate_hardware_logical_block_alignment(struct dm_table *table,
 	 */
 	unsigned short remaining = 0;
 
-	struct dm_target *uninitialized_var(ti);
+	struct dm_target *ti;
 	struct queue_limits ti_limits;
 	unsigned i;
 
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 613c171b1b6d..f4931c948f63 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1714,7 +1714,7 @@ static void writecache_writeback(struct work_struct *work)
 {
 	struct dm_writecache *wc = container_of(work, struct dm_writecache, writeback_work);
 	struct blk_plug plug;
-	struct wc_entry *f, *uninitialized_var(g), *e = NULL;
+	struct wc_entry *f, *g, *e = NULL;
 	struct rb_node *node, *next_node;
 	struct list_head skipped;
 	struct writeback_list wbl;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ab8067f9ce8c..401b366af076 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2601,7 +2601,7 @@ static void raid5_end_write_request(struct bio *bi)
 	struct stripe_head *sh = bi->bi_private;
 	struct r5conf *conf = sh->raid_conf;
 	int disks = sh->disks, i;
-	struct md_rdev *uninitialized_var(rdev);
+	struct md_rdev *rdev;
 	sector_t first_bad;
 	int bad_sectors;
 	int replacement = 0;
diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 6ec277421390..e5bffaaeed38 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -640,7 +640,7 @@ static int rtl2832_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
-	u32 uninitialized_var(tmp);
+	u32 tmp;
 	u8 u8tmp, buf[2];
 	u16 u16tmp;
 
diff --git a/drivers/media/tuners/qt1010.c b/drivers/media/tuners/qt1010.c
index 85bbdd4ecdbb..e48faf942830 100644
--- a/drivers/media/tuners/qt1010.c
+++ b/drivers/media/tuners/qt1010.c
@@ -215,7 +215,7 @@ static int qt1010_set_params(struct dvb_frontend *fe)
 static int qt1010_init_meas1(struct qt1010_priv *priv,
 			     u8 oper, u8 reg, u8 reg_init_val, u8 *retval)
 {
-	u8 i, val1, uninitialized_var(val2);
+	u8 i, val1, val2;
 	int err;
 
 	qt1010_i2c_oper_t i2c_data[] = {
@@ -250,7 +250,7 @@ static int qt1010_init_meas1(struct qt1010_priv *priv,
 static int qt1010_init_meas2(struct qt1010_priv *priv,
 			    u8 reg_init_val, u8 *retval)
 {
-	u8 i, uninitialized_var(val);
+	u8 i, val;
 	int err;
 	qt1010_i2c_oper_t i2c_data[] = {
 		{ QT1010_WR, 0x07, reg_init_val },
diff --git a/drivers/media/usb/gspca/vicam.c b/drivers/media/usb/gspca/vicam.c
index 179b2ec3df57..d98343fd33fe 100644
--- a/drivers/media/usb/gspca/vicam.c
+++ b/drivers/media/usb/gspca/vicam.c
@@ -225,7 +225,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 {
 	int ret;
 	const struct ihex_binrec *rec;
-	const struct firmware *uninitialized_var(fw);
+	const struct firmware *fw;
 	u8 *firmware_buf;
 
 	ret = request_ihex_firmware(&fw, VICAM_FIRMWARE,
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 8fa77a81dd7f..a65d5353a441 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -765,9 +765,9 @@ static void uvc_video_stats_decode(struct uvc_streaming *stream,
 	unsigned int header_size;
 	bool has_pts = false;
 	bool has_scr = false;
-	u16 uninitialized_var(scr_sof);
-	u32 uninitialized_var(scr_stc);
-	u32 uninitialized_var(pts);
+	u16 scr_sof;
+	u32 scr_stc;
+	u32 pts;
 
 	if (stream->stats.stream.nb_frames == 0 &&
 	    stream->stats.frame.nb_packets == 0)
@@ -1828,7 +1828,7 @@ static int uvc_video_start_transfer(struct uvc_streaming *stream,
 		struct usb_host_endpoint *best_ep = NULL;
 		unsigned int best_psize = UINT_MAX;
 		unsigned int bandwidth;
-		unsigned int uninitialized_var(altsetting);
+		unsigned int altsetting;
 		int intfnum = stream->intfnum;
 
 		/* Isochronous endpoint, select the alternate setting. */
diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 0a9c5ddf2f59..383091517ed7 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -314,7 +314,7 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 	}
 
 	while (length) {
-		unsigned int uninitialized_var(p_off);
+		unsigned int p_off;
 
 		if (host->req->long_data) {
 			pg = nth_page(sg_page(&host->req->sg),
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index 5b966b54d6e9..fc35c7404429 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -198,7 +198,7 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 		host->block_pos);
 
 	while (length) {
-		unsigned int uninitialized_var(p_off);
+		unsigned int p_off;
 
 		if (host->req->long_data) {
 			pg = nth_page(sg_page(&host->req->sg),
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 37b1158c1c0c..1ee866a38794 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -493,7 +493,7 @@ static void sdhci_read_block_pio(struct sdhci_host *host)
 {
 	unsigned long flags;
 	size_t blksize, len, chunk;
-	u32 uninitialized_var(scratch);
+	u32 scratch;
 	u8 *buf;
 
 	DBG("PIO reading\n");
diff --git a/drivers/mtd/nand/raw/nand_ecc.c b/drivers/mtd/nand/raw/nand_ecc.c
index 09fdced659f5..b6a46b1b7781 100644
--- a/drivers/mtd/nand/raw/nand_ecc.c
+++ b/drivers/mtd/nand/raw/nand_ecc.c
@@ -131,7 +131,7 @@ void __nand_calculate_ecc(const unsigned char *buf, unsigned int eccsize,
 	/* rp0..rp15..rp17 are the various accumulated parities (per byte) */
 	uint32_t rp0, rp1, rp2, rp3, rp4, rp5, rp6, rp7;
 	uint32_t rp8, rp9, rp10, rp11, rp12, rp13, rp14, rp15, rp16;
-	uint32_t uninitialized_var(rp17);	/* to make compiler happy */
+	uint32_t rp17;
 	uint32_t par;		/* the cumulative parity for all data */
 	uint32_t tmppar;	/* the cumulative parity for this iteration;
 				   for rp12, rp14 and rp16 at the end of the
diff --git a/drivers/mtd/nand/raw/s3c2410.c b/drivers/mtd/nand/raw/s3c2410.c
index 0009c1820e21..93dbe35dd30b 100644
--- a/drivers/mtd/nand/raw/s3c2410.c
+++ b/drivers/mtd/nand/raw/s3c2410.c
@@ -291,7 +291,7 @@ static int s3c2410_nand_setrate(struct s3c2410_nand_info *info)
 	int tacls_max = (info->cpu_type == TYPE_S3C2412) ? 8 : 4;
 	int tacls, twrph0, twrph1;
 	unsigned long clkrate = clk_get_rate(info->clk);
-	unsigned long uninitialized_var(set), cfg, uninitialized_var(mask);
+	unsigned long set, cfg, mask;
 	unsigned long flags;
 
 	/* calculate the timing information for the controller */
diff --git a/drivers/mtd/parsers/afs.c b/drivers/mtd/parsers/afs.c
index 752b6cf005f7..980e332bdac4 100644
--- a/drivers/mtd/parsers/afs.c
+++ b/drivers/mtd/parsers/afs.c
@@ -126,8 +126,8 @@ static int afs_parse_v1_partition(struct mtd_info *mtd,
 	 * Static checks cannot see that we bail out if we have an error
 	 * reading the footer.
 	 */
-	u_int uninitialized_var(iis_ptr);
-	u_int uninitialized_var(img_ptr);
+	u_int iis_ptr;
+	u_int img_ptr;
 	u_int ptr;
 	size_t sz;
 	int ret;
diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 5133e1be5331..0edecfdbd01f 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -599,7 +599,7 @@ int ubi_eba_read_leb(struct ubi_device *ubi, struct ubi_volume *vol, int lnum,
 	int err, pnum, scrub = 0, vol_id = vol->vol_id;
 	struct ubi_vid_io_buf *vidb;
 	struct ubi_vid_hdr *vid_hdr;
-	uint32_t uninitialized_var(crc);
+	uint32_t crc;
 
 	err = leb_read_lock(ubi, vol_id, lnum);
 	if (err)
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index a761092e6ac9..f929db893957 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1451,7 +1451,7 @@ static int ican3_napi(struct napi_struct *napi, int budget)
 
 	/* process all communication messages */
 	while (true) {
-		struct ican3_msg uninitialized_var(msg);
+		struct ican3_msg msg;
 		ret = ican3_recv_msg(mod, &msg);
 		if (ret)
 			break;
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index e1c236cab2a7..c8cc14eadbb4 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -1455,7 +1455,7 @@ bnx2_test_and_disable_2g5(struct bnx2 *bp)
 static void
 bnx2_enable_forced_2g5(struct bnx2 *bp)
 {
-	u32 uninitialized_var(bmcr);
+	u32 bmcr;
 	int err;
 
 	if (!(bp->phy_flags & BNX2_PHY_FLAG_2_5G_CAPABLE))
@@ -1499,7 +1499,7 @@ bnx2_enable_forced_2g5(struct bnx2 *bp)
 static void
 bnx2_disable_forced_2g5(struct bnx2 *bp)
 {
-	u32 uninitialized_var(bmcr);
+	u32 bmcr;
 	int err;
 
 	if (!(bp->phy_flags & BNX2_PHY_FLAG_2_5G_CAPABLE))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 91bd258ecf1b..65d0baef351a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -486,8 +486,8 @@ static int req_pages_handler(struct notifier_block *nb,
 
 int mlx5_satisfy_startup_pages(struct mlx5_core_dev *dev, int boot)
 {
-	u16 uninitialized_var(func_id);
-	s32 uninitialized_var(npages);
+	u16 func_id;
+	s32 npages;
 	int err;
 
 	err = mlx5_cmd_query_pages(dev, &func_id, &npages, boot);
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 67e62603fe3b..15b8b1bf8163 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -7276,7 +7276,7 @@ static int rx_osm_handler(struct ring_info *ring_data, struct RxD_t * rxdp)
 	int ring_no = ring_data->ring_no;
 	u16 l3_csum, l4_csum;
 	unsigned long long err = rxdp->Control_1 & RXD_T_CODE;
-	struct lro *uninitialized_var(lro);
+	struct lro *lro;
 	u8 err_mask;
 	struct swStat *swstats = &sp->mac_control.stats_info->sw_stat;
 
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 0fade19e00d4..0d0e38debbc2 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -3769,7 +3769,7 @@ static int ql3xxx_probe(struct pci_dev *pdev,
 	struct net_device *ndev = NULL;
 	struct ql3_adapter *qdev = NULL;
 	static int cards_found;
-	int uninitialized_var(pci_using_dac), err;
+	int pci_using_dac, err;
 
 	err = pci_enable_device(pdev);
 	if (err) {
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index f1c8615ab6f0..851206924790 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -2283,7 +2283,7 @@ static int cas_rx_ringN(struct cas *cp, int ring, int budget)
 	drops = 0;
 	while (1) {
 		struct cas_rx_comp *rxc = rxcs + entry;
-		struct sk_buff *uninitialized_var(skb);
+		struct sk_buff *skb;
 		int type, len;
 		u64 words[4];
 		int i, dring;
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 9a5004f674c7..1b697e4cd7dc 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -429,7 +429,7 @@ static int serdes_init_niu_1g_serdes(struct niu *np)
 	struct niu_link_config *lp = &np->link_config;
 	u16 pll_cfg, pll_sts;
 	int max_retry = 100;
-	u64 uninitialized_var(sig), mask, val;
+	u64 sig, mask, val;
 	u32 tx_cfg, rx_cfg;
 	unsigned long i;
 	int err;
@@ -526,7 +526,7 @@ static int serdes_init_niu_10g_serdes(struct niu *np)
 	struct niu_link_config *lp = &np->link_config;
 	u32 tx_cfg, rx_cfg, pll_cfg, pll_sts;
 	int max_retry = 100;
-	u64 uninitialized_var(sig), mask, val;
+	u64 sig, mask, val;
 	unsigned long i;
 	int err;
 
@@ -714,7 +714,7 @@ static int esr_write_glue0(struct niu *np, unsigned long chan, u32 val)
 
 static int esr_reset(struct niu *np)
 {
-	u32 uninitialized_var(reset);
+	u32 reset;
 	int err;
 
 	err = mdio_write(np, np->port, NIU_ESR_DEV_ADDR,
diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index 7ad3d24195ba..138930c66ad2 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -702,7 +702,7 @@ EXPORT_SYMBOL(z8530_nop);
 irqreturn_t z8530_interrupt(int irq, void *dev_id)
 {
 	struct z8530_dev *dev=dev_id;
-	u8 uninitialized_var(intr);
+	u8 intr;
 	static volatile int locker=0;
 	int work=0;
 	struct z8530_irqhandler *irqs;
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index f26cc6989dad..791ab09ef3ee 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2242,7 +2242,7 @@ static int ath10k_init_uart(struct ath10k *ar)
 
 static int ath10k_init_hw_params(struct ath10k *ar)
 {
-	const struct ath10k_hw_params *uninitialized_var(hw_params);
+	const struct ath10k_hw_params *hw_params;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(ath10k_hw_params_list); i++) {
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index aa1c71a76ef7..811fad6d60c0 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1575,7 +1575,7 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 
 int ath6kl_init_hw_params(struct ath6kl *ar)
 {
-	const struct ath6kl_hw *uninitialized_var(hw);
+	const struct ath6kl_hw *hw;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(hw_list); i++) {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 17c318902cb8..68cc7803b91a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -230,7 +230,7 @@ static unsigned int ath9k_reg_rmw(void *hw_priv, u32 reg_offset, u32 set, u32 cl
 	struct ath_hw *ah = hw_priv;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_softc *sc = (struct ath_softc *) common->priv;
-	unsigned long uninitialized_var(flags);
+	unsigned long flags;
 	u32 val;
 
 	if (NR_CPUS > 1 && ah->config.serialize_regmode == SER_REG_MODE_ON) {
diff --git a/drivers/net/wireless/broadcom/b43/debugfs.c b/drivers/net/wireless/broadcom/b43/debugfs.c
index dc1819ca52ac..89a25aefb327 100644
--- a/drivers/net/wireless/broadcom/b43/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43/debugfs.c
@@ -493,7 +493,7 @@ static ssize_t b43_debugfs_read(struct file *file, char __user *userbuf,
 	struct b43_wldev *dev;
 	struct b43_debugfs_fops *dfops;
 	struct b43_dfs_file *dfile;
-	ssize_t uninitialized_var(ret);
+	ssize_t ret;
 	char *buf;
 	const size_t bufsize = 1024 * 16; /* 16 kiB buffer */
 	const size_t buforder = get_order(bufsize);
diff --git a/drivers/net/wireless/broadcom/b43/dma.c b/drivers/net/wireless/broadcom/b43/dma.c
index 9733c64bf978..ca671fc13116 100644
--- a/drivers/net/wireless/broadcom/b43/dma.c
+++ b/drivers/net/wireless/broadcom/b43/dma.c
@@ -37,7 +37,7 @@
 static u32 b43_dma_address(struct b43_dma *dma, dma_addr_t dmaaddr,
 			   enum b43_addrtype addrtype)
 {
-	u32 uninitialized_var(addr);
+	u32 addr;
 
 	switch (addrtype) {
 	case B43_DMA_ADDR_LOW:
diff --git a/drivers/net/wireless/broadcom/b43/lo.c b/drivers/net/wireless/broadcom/b43/lo.c
index 5d97cf06eceb..338b6545a1e7 100644
--- a/drivers/net/wireless/broadcom/b43/lo.c
+++ b/drivers/net/wireless/broadcom/b43/lo.c
@@ -729,7 +729,7 @@ struct b43_lo_calib *b43_calibrate_lo_setting(struct b43_wldev *dev,
 	};
 	int max_rx_gain;
 	struct b43_lo_calib *cal;
-	struct lo_g_saved_values uninitialized_var(saved_regs);
+	struct lo_g_saved_values saved_regs;
 	/* Values from the "TXCTL Register and Value Table" */
 	u16 txctl_reg;
 	u16 txctl_value;
diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index 88cdcea10d61..771f69ff145e 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -5647,7 +5647,7 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
 	u8 rfctl[2];
 	u8 afectl_core;
 	u16 tmp[6];
-	u16 uninitialized_var(cur_hpf1), uninitialized_var(cur_hpf2), cur_lna;
+	u16 cur_hpf1, cur_hpf2, cur_lna;
 	u32 real, imag;
 	enum nl80211_band band;
 
diff --git a/drivers/net/wireless/broadcom/b43/xmit.c b/drivers/net/wireless/broadcom/b43/xmit.c
index 058745219516..2ff005b453cd 100644
--- a/drivers/net/wireless/broadcom/b43/xmit.c
+++ b/drivers/net/wireless/broadcom/b43/xmit.c
@@ -422,10 +422,10 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 	if ((rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) ||
 	    (rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT)) {
 		unsigned int len;
-		struct ieee80211_hdr *uninitialized_var(hdr);
+		struct ieee80211_hdr *hdr;
 		int rts_rate, rts_rate_fb;
 		int rts_rate_ofdm, rts_rate_fb_ofdm;
-		struct b43_plcp_hdr6 *uninitialized_var(plcp);
+		struct b43_plcp_hdr6 *plcp;
 		struct ieee80211_rate *rts_cts_rate;
 
 		rts_cts_rate = ieee80211_get_rts_cts_rate(dev->wl->hw, info);
@@ -436,7 +436,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 		rts_rate_fb_ofdm = b43_is_ofdm_rate(rts_rate_fb);
 
 		if (rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
-			struct ieee80211_cts *uninitialized_var(cts);
+			struct ieee80211_cts *cts;
 
 			switch (dev->fw.hdr_format) {
 			case B43_FW_HDR_598:
@@ -458,7 +458,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 			mac_ctl |= B43_TXH_MAC_SENDCTS;
 			len = sizeof(struct ieee80211_cts);
 		} else {
-			struct ieee80211_rts *uninitialized_var(rts);
+			struct ieee80211_rts *rts;
 
 			switch (dev->fw.hdr_format) {
 			case B43_FW_HDR_598:
@@ -650,8 +650,8 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 	const struct b43_rxhdr_fw4 *rxhdr = _rxhdr;
 	__le16 fctl;
 	u16 phystat0, phystat3;
-	u16 uninitialized_var(chanstat), uninitialized_var(mactime);
-	u32 uninitialized_var(macstat);
+	u16 chanstat, mactime;
+	u32 macstat;
 	u16 chanid;
 	int padding, rate_idx;
 
diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.c b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
index fa133dfb2ecb..e7e4293c01f2 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -190,7 +190,7 @@ static ssize_t b43legacy_debugfs_read(struct file *file, char __user *userbuf,
 	struct b43legacy_wldev *dev;
 	struct b43legacy_debugfs_fops *dfops;
 	struct b43legacy_dfs_file *dfile;
-	ssize_t uninitialized_var(ret);
+	ssize_t ret;
 	char *buf;
 	const size_t bufsize = 1024 * 16; /* 16 KiB buffer */
 	const size_t buforder = get_order(bufsize);
diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index 8b6b657c4b85..d7f8dbcfaa9c 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -2580,7 +2580,7 @@ static void b43legacy_put_phy_into_reset(struct b43legacy_wldev *dev)
 static int b43legacy_switch_phymode(struct b43legacy_wl *wl,
 				      unsigned int new_mode)
 {
-	struct b43legacy_wldev *uninitialized_var(up_dev);
+	struct b43legacy_wldev *up_dev;
 	struct b43legacy_wldev *down_dev;
 	int err;
 	bool gmode = false;
diff --git a/drivers/net/wireless/intel/iwlegacy/3945.c b/drivers/net/wireless/intel/iwlegacy/3945.c
index 2ac494f5ae22..fd63eba47ba2 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945.c
@@ -2100,7 +2100,7 @@ il3945_txpower_set_from_eeprom(struct il_priv *il)
 
 		/* set tx power value for all OFDM rates */
 		for (rate_idx = 0; rate_idx < IL_OFDM_RATES; rate_idx++) {
-			s32 uninitialized_var(power_idx);
+			s32 power_idx;
 			int rc;
 
 			/* use channel group's clip-power table,
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index da6d4202611c..a159d1d18c2c 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -2769,7 +2769,7 @@ il4965_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
 	struct ieee80211_tx_info *info;
 	struct il4965_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32 status = le32_to_cpu(tx_resp->u.status);
-	int uninitialized_var(tid);
+	int tid;
 	int sta_id;
 	int freed;
 	u8 *qc = NULL;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index 5b071b70bc08..0ae9cfc65272 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -618,8 +618,8 @@ static void _rtl92cu_init_chipn_two_out_ep_priority(struct ieee80211_hw *hw,
 						     u8 queue_sel)
 {
 	u16 beq, bkq, viq, voq, mgtq, hiq;
-	u16 uninitialized_var(valuehi);
-	u16 uninitialized_var(valuelow);
+	u16 valuehi;
+	u16 valuelow;
 
 	switch (queue_sel) {
 	case (TX_SELE_HQ | TX_SELE_LQ):
diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index f4274d301235..7070276c5bef 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1283,7 +1283,7 @@ static irqreturn_t aer_isr(int irq, void *context)
 {
 	struct pcie_device *dev = (struct pcie_device *)context;
 	struct aer_rpc *rpc = get_service_data(dev);
-	struct aer_err_source uninitialized_var(e_src);
+	struct aer_err_source e_src;
 
 	if (kfifo_is_empty(&rpc->aer_fifo))
 		return IRQ_NONE;
diff --git a/drivers/platform/x86/hdaps.c b/drivers/platform/x86/hdaps.c
index 04c4da6692d7..a72270932ec3 100644
--- a/drivers/platform/x86/hdaps.c
+++ b/drivers/platform/x86/hdaps.c
@@ -365,7 +365,7 @@ static ssize_t hdaps_variance_show(struct device *dev,
 static ssize_t hdaps_temp1_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	u8 uninitialized_var(temp);
+	u8 temp;
 	int ret;
 
 	ret = hdaps_readb_one(HDAPS_PORT_TEMP1, &temp);
@@ -378,7 +378,7 @@ static ssize_t hdaps_temp1_show(struct device *dev,
 static ssize_t hdaps_temp2_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	u8 uninitialized_var(temp);
+	u8 temp;
 	int ret;
 
 	ret = hdaps_readb_one(HDAPS_PORT_TEMP2, &temp);
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index e95f5b3bef4d..37c6cc374079 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4126,7 +4126,7 @@ static int adapter_sg_tables_alloc(struct AdapterCtlBlk *acb)
 	const unsigned srbs_per_page = PAGE_SIZE/SEGMENTX_LEN;
 	int srb_idx = 0;
 	unsigned i = 0;
-	struct SGentry *uninitialized_var(ptr);
+	struct SGentry *ptr;
 
 	for (i = 0; i < DC395x_MAX_SRB_CNT; i++)
 		acb->srb_array[i].segment_x = NULL;
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index fb9848e1d481..0b4499210b95 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4202,7 +4202,7 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 	struct outbound_queue_table *circularQ;
 	void *pMsg1 = NULL;
-	u8 uninitialized_var(bc);
+	u8 bc;
 	u32 ret = MPI_IO_STATUS_FAIL;
 	unsigned long flags;
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 4d205ebaee87..05c944a3bdca 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4182,7 +4182,7 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 	struct outbound_queue_table *circularQ;
 	void *pMsg1 = NULL;
-	u8 uninitialized_var(bc);
+	u8 bc;
 	u32 ret = MPI_IO_STATUS_FAIL;
 	unsigned long flags;
 	u32 regval;
diff --git a/drivers/ssb/driver_chipcommon.c b/drivers/ssb/driver_chipcommon.c
index 3861cb659cb9..6c647ba4ba0b 100644
--- a/drivers/ssb/driver_chipcommon.c
+++ b/drivers/ssb/driver_chipcommon.c
@@ -119,7 +119,7 @@ void ssb_chipco_set_clockmode(struct ssb_chipcommon *cc,
 static enum ssb_clksrc chipco_pctl_get_slowclksrc(struct ssb_chipcommon *cc)
 {
 	struct ssb_bus *bus = cc->dev->bus;
-	u32 uninitialized_var(tmp);
+	u32 tmp;
 
 	if (cc->dev->id.revision < 6) {
 		if (bus->bustype == SSB_BUSTYPE_SSB ||
@@ -149,7 +149,7 @@ static enum ssb_clksrc chipco_pctl_get_slowclksrc(struct ssb_chipcommon *cc)
 /* Get maximum or minimum (depending on get_max flag) slowclock frequency. */
 static int chipco_pctl_clockfreqlimit(struct ssb_chipcommon *cc, int get_max)
 {
-	int uninitialized_var(limit);
+	int limit;
 	enum ssb_clksrc clocksrc;
 	int divisor = 1;
 	u32 tmp;
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index a6aabfd6e2da..097266342e5e 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -3643,7 +3643,7 @@ static int cy_pci_probe(struct pci_dev *pdev,
 	struct cyclades_card *card;
 	void __iomem *addr0 = NULL, *addr2 = NULL;
 	char *card_name = NULL;
-	u32 uninitialized_var(mailbox);
+	u32 mailbox;
 	unsigned int device_id, nchan = 0, card_no, i, j;
 	unsigned char plx_ver;
 	int retval, irq;
diff --git a/drivers/tty/isicom.c b/drivers/tty/isicom.c
index fc38f96475bf..3b2f9fb01aa0 100644
--- a/drivers/tty/isicom.c
+++ b/drivers/tty/isicom.c
@@ -1514,7 +1514,7 @@ static unsigned int card_count;
 static int isicom_probe(struct pci_dev *pdev,
 	const struct pci_device_id *ent)
 {
-	unsigned int uninitialized_var(signature), index;
+	unsigned int signature, index;
 	int retval = -EPERM;
 	struct isi_board *board = NULL;
 
diff --git a/drivers/usb/musb/cppi_dma.c b/drivers/usb/musb/cppi_dma.c
index b4d6d9bb3239..c545b27ea568 100644
--- a/drivers/usb/musb/cppi_dma.c
+++ b/drivers/usb/musb/cppi_dma.c
@@ -1146,7 +1146,7 @@ irqreturn_t cppi_interrupt(int irq, void *dev_id)
 	struct musb_hw_ep	*hw_ep = NULL;
 	u32			rx, tx;
 	int			i, index;
-	unsigned long		uninitialized_var(flags);
+	unsigned long		flags;
 
 	cppi = container_of(musb->dma_controller, struct cppi, controller);
 	if (cppi->irq)
diff --git a/drivers/usb/storage/sddr55.c b/drivers/usb/storage/sddr55.c
index ba955d65eb0e..c8a988d2cfdd 100644
--- a/drivers/usb/storage/sddr55.c
+++ b/drivers/usb/storage/sddr55.c
@@ -554,8 +554,8 @@ static int sddr55_reset(struct us_data *us)
 
 static unsigned long sddr55_get_capacity(struct us_data *us) {
 
-	unsigned char uninitialized_var(manufacturerID);
-	unsigned char uninitialized_var(deviceID);
+	unsigned char manufacturerID;
+	unsigned char deviceID;
 	int result;
 	struct sddr55_card_info *info = (struct sddr55_card_info *)us->extra;
 
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 2927f02cc7e1..d7fc9eb1b8bc 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -861,7 +861,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 	struct tun_msg_ctl ctl;
 	size_t len, total_len = 0;
 	int err;
-	struct vhost_net_ubuf_ref *uninitialized_var(ubufs);
+	struct vhost_net_ubuf_ref *ubufs;
 	bool zcopy_used;
 	int sent_pkts = 0;
 
@@ -1041,7 +1041,7 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 	/* len is always initialized before use since we are always called with
 	 * datalen > 0.
 	 */
-	u32 uninitialized_var(len);
+	u32 len;
 
 	while (datalen > 0 && headcount < quota) {
 		if (unlikely(seg >= UIO_MAXIOV)) {
@@ -1098,7 +1098,7 @@ static void handle_rx(struct vhost_net *net)
 {
 	struct vhost_net_virtqueue *nvq = &net->vqs[VHOST_NET_VQ_RX];
 	struct vhost_virtqueue *vq = &nvq->vq;
-	unsigned uninitialized_var(in), log;
+	unsigned in, log;
 	struct vhost_log *vq_log;
 	struct msghdr msg = {
 		.msg_name = NULL,
diff --git a/drivers/video/fbdev/matrox/matroxfb_maven.c b/drivers/video/fbdev/matrox/matroxfb_maven.c
index eda893b7a2e9..9a98c4a6ba33 100644
--- a/drivers/video/fbdev/matrox/matroxfb_maven.c
+++ b/drivers/video/fbdev/matrox/matroxfb_maven.c
@@ -300,7 +300,7 @@ static int matroxfb_mavenclock(const struct matrox_pll_ctl *ctl,
 		unsigned int* in, unsigned int* feed, unsigned int* post,
 		unsigned int* htotal2) {
 	unsigned int fvco;
-	unsigned int uninitialized_var(p);
+	unsigned int p;
 
 	fvco = matroxfb_PLL_mavenclock(&maven1000_pll, ctl, htotal, vtotal, in, feed, &p, htotal2);
 	if (!fvco)
@@ -732,8 +732,8 @@ static int maven_find_exact_clocks(unsigned int ht, unsigned int vt,
 
 	for (x = 0; x < 8; x++) {
 		unsigned int c;
-		unsigned int uninitialized_var(a), uninitialized_var(b),
-			     uninitialized_var(h2);
+		unsigned int a, b,
+			     h2;
 		unsigned int h = ht + 2 + x;
 
 		if (!matroxfb_mavenclock((m->mode == MATROXFB_OUTPUT_MODE_PAL) ? &maven_PAL : &maven_NTSC, h, vt, &a, &b, &c, &h2)) {
diff --git a/drivers/video/fbdev/pm3fb.c b/drivers/video/fbdev/pm3fb.c
index 7497bd36334c..a8faf46adeb1 100644
--- a/drivers/video/fbdev/pm3fb.c
+++ b/drivers/video/fbdev/pm3fb.c
@@ -821,9 +821,9 @@ static void pm3fb_write_mode(struct fb_info *info)
 
 	wmb();
 	{
-		unsigned char uninitialized_var(m);	/* ClkPreScale */
-		unsigned char uninitialized_var(n);	/* ClkFeedBackScale */
-		unsigned char uninitialized_var(p);	/* ClkPostScale */
+		unsigned char m;	/* ClkPreScale */
+		unsigned char n;	/* ClkFeedBackScale */
+		unsigned char p;	/* ClkPostScale */
 		unsigned long pixclock = PICOS2KHZ(info->var.pixclock);
 
 		(void)pm3fb_calculate_clock(pixclock, &m, &n, &p);
diff --git a/drivers/video/fbdev/riva/riva_hw.c b/drivers/video/fbdev/riva/riva_hw.c
index 08c9ee46978e..4168ac464565 100644
--- a/drivers/video/fbdev/riva/riva_hw.c
+++ b/drivers/video/fbdev/riva/riva_hw.c
@@ -1245,8 +1245,7 @@ int CalcStateExt
 )
 {
     int pixelDepth;
-    int uninitialized_var(VClk),uninitialized_var(m),
-        uninitialized_var(n),	uninitialized_var(p);
+    int VClk, m, n, p;
 
     /*
      * Save mode parameters.
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 58b96baa8d48..a2de775801af 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -424,7 +424,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 	struct vring_virtqueue *vq = to_vvq(_vq);
 	struct scatterlist *sg;
 	struct vring_desc *desc;
-	unsigned int i, n, avail, descs_used, uninitialized_var(prev), err_idx;
+	unsigned int i, n, avail, descs_used, prev, err_idx;
 	int head;
 	bool indirect;
 
@@ -1101,8 +1101,8 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
 	struct vring_packed_desc *desc;
 	struct scatterlist *sg;
 	unsigned int i, n, c, descs_used, err_idx;
-	__le16 uninitialized_var(head_flags), flags;
-	u16 head, id, uninitialized_var(prev), curr, avail_used_flags;
+	__le16 head_flags, flags;
+	u16 head, id, prev, curr, avail_used_flags;
 
 	START_USE(vq);
 
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index d1e1caa23c8b..9b7f612f3996 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1028,7 +1028,7 @@ static int afs_d_revalidate_rcu(struct dentry *dentry)
 static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 {
 	struct afs_vnode *vnode, *dir;
-	struct afs_fid uninitialized_var(fid);
+	struct afs_fid fid;
 	struct dentry *parent;
 	struct inode *inode;
 	struct key *key;
diff --git a/fs/afs/security.c b/fs/afs/security.c
index ce9de1e6742b..207a54ce4540 100644
--- a/fs/afs/security.c
+++ b/fs/afs/security.c
@@ -401,7 +401,7 @@ int afs_check_permit(struct afs_vnode *vnode, struct key *key,
 int afs_permission(struct inode *inode, int mask)
 {
 	struct afs_vnode *vnode = AFS_FS_I(inode);
-	afs_access_t uninitialized_var(access);
+	afs_access_t access;
 	struct key *key;
 	int ret = 0;
 
diff --git a/fs/dlm/netlink.c b/fs/dlm/netlink.c
index e7f550327d5d..e338c407cb75 100644
--- a/fs/dlm/netlink.c
+++ b/fs/dlm/netlink.c
@@ -113,7 +113,7 @@ static void fill_data(struct dlm_lock_data *data, struct dlm_lkb *lkb)
 
 void dlm_timeout_warn(struct dlm_lkb *lkb)
 {
-	struct sk_buff *uninitialized_var(send_skb);
+	struct sk_buff *send_skb;
 	struct dlm_lock_data *data;
 	size_t size;
 	int rv;
diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 64b56c7df023..d0542151e8c4 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -265,7 +265,7 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
  */
 static int erofs_raw_access_readpage(struct file *file, struct page *page)
 {
-	erofs_off_t uninitialized_var(last_block);
+	erofs_off_t last_block;
 	struct bio *bio;
 
 	trace_erofs_readpage(page, true);
@@ -282,7 +282,7 @@ static int erofs_raw_access_readpage(struct file *file, struct page *page)
 
 static void erofs_raw_access_readahead(struct readahead_control *rac)
 {
-	erofs_off_t uninitialized_var(last_block);
+	erofs_off_t last_block;
 	struct bio *bio = NULL;
 	struct page *page;
 
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index be50a4d9d273..24a26aaf847f 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1161,7 +1161,7 @@ static void z_erofs_submit_queue(struct super_block *sb,
 	struct z_erofs_decompressqueue *q[NR_JOBQUEUES];
 	void *bi_private;
 	/* since bio will be NULL, no need to initialize last_index */
-	pgoff_t uninitialized_var(last_index);
+	pgoff_t last_index;
 	unsigned int nr_bios = 0;
 	struct bio *bio = NULL;
 
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 03ec97f28235..926f1e9e887d 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2762,7 +2762,7 @@ static int f2fs_write_cache_pages(struct address_space *mapping,
 	};
 #endif
 	int nr_pages;
-	pgoff_t uninitialized_var(writeback_index);
+	pgoff_t writeback_index;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	pgoff_t done_index;
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index b4ddf48fa444..c4a274285858 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1284,7 +1284,7 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 	struct super_block *sb = dir->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct buffer_head *bh, *prev, *bhs[3]; /* 32*slots (672bytes) */
-	struct msdos_dir_entry *uninitialized_var(de);
+	struct msdos_dir_entry *de;
 	int err, free_slots, i, nr_bhs;
 	loff_t pos, i_pos;
 
diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index c23f6f243ad4..a1303ad303ba 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -120,7 +120,7 @@ static ssize_t fuse_conn_max_background_write(struct file *file,
 					      const char __user *buf,
 					      size_t count, loff_t *ppos)
 {
-	unsigned uninitialized_var(val);
+	unsigned val;
 	ssize_t ret;
 
 	ret = fuse_conn_limit_write(file, buf, count, ppos, &val,
@@ -162,7 +162,7 @@ static ssize_t fuse_conn_congestion_threshold_write(struct file *file,
 						    const char __user *buf,
 						    size_t count, loff_t *ppos)
 {
-	unsigned uninitialized_var(val);
+	unsigned val;
 	struct fuse_conn *fc;
 	ssize_t ret;
 
diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index 030f094910c3..2cc17816d7b1 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -270,7 +270,7 @@ static int cuse_parse_one(char **pp, char *end, char **keyp, char **valp)
 static int cuse_parse_devinfo(char *p, size_t len, struct cuse_devinfo *devinfo)
 {
 	char *end = p + len;
-	char *uninitialized_var(key), *uninitialized_var(val);
+	char *key, *val;
 	int rc;
 
 	while (true) {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index bac51c32d660..ca43817df3c8 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2917,7 +2917,7 @@ static void fuse_register_polled_file(struct fuse_conn *fc,
 {
 	spin_lock(&fc->lock);
 	if (RB_EMPTY_NODE(&ff->polled_node)) {
-		struct rb_node **link, *uninitialized_var(parent);
+		struct rb_node **link, *parent;
 
 		link = fuse_find_polled_node(fc, ff->kh, &parent);
 		BUG_ON(*link);
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 72c9560f4467..baa17c781870 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -335,7 +335,7 @@ static int gfs2_write_cache_jdata(struct address_space *mapping,
 	int done = 0;
 	struct pagevec pvec;
 	int nr_pages;
-	pgoff_t uninitialized_var(writeback_index);
+	pgoff_t writeback_index;
 	pgoff_t index;
 	pgoff_t end;
 	pgoff_t done_index;
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 6306eaae378b..8dfe09f52cbc 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1761,7 +1761,7 @@ static int punch_hole(struct gfs2_inode *ip, u64 offset, u64 length)
 	u64 lblock = (offset + (1 << bsize_shift) - 1) >> bsize_shift;
 	__u16 start_list[GFS2_MAX_META_HEIGHT];
 	__u16 __end_list[GFS2_MAX_META_HEIGHT], *end_list = NULL;
-	unsigned int start_aligned, uninitialized_var(end_aligned);
+	unsigned int start_aligned, end_aligned;
 	unsigned int strip_h = ip->i_height - 1;
 	u32 btotal = 0;
 	int ret, state;
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index cb2a11b458c6..ed1da4323967 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -419,7 +419,7 @@ static bool gfs2_jhead_pg_srch(struct gfs2_jdesc *jd,
 			      struct page *page)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(jd->jd_inode);
-	struct gfs2_log_header_host uninitialized_var(lh);
+	struct gfs2_log_header_host lh;
 	void *kaddr = kmap_atomic(page);
 	unsigned int offset;
 	bool ret = false;
diff --git a/fs/hfsplus/unicode.c b/fs/hfsplus/unicode.c
index c8d1b2be7854..73342c925a4b 100644
--- a/fs/hfsplus/unicode.c
+++ b/fs/hfsplus/unicode.c
@@ -398,7 +398,7 @@ int hfsplus_hash_dentry(const struct dentry *dentry, struct qstr *str)
 	astr = str->name;
 	len = str->len;
 	while (len > 0) {
-		int uninitialized_var(dsize);
+		int dsize;
 		size = asc2unichar(sb, astr, len, &c);
 		astr += size;
 		len -= size;
diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
index cac468f04820..402769881c32 100644
--- a/fs/isofs/namei.c
+++ b/fs/isofs/namei.c
@@ -152,8 +152,8 @@ isofs_find_entry(struct inode *dir, struct dentry *dentry,
 struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 {
 	int found;
-	unsigned long uninitialized_var(block);
-	unsigned long uninitialized_var(offset);
+	unsigned long block;
+	unsigned long offset;
 	struct inode *inode;
 	struct page *page;
 
diff --git a/fs/jffs2/erase.c b/fs/jffs2/erase.c
index 83b8f06b4a64..7e9abdb89712 100644
--- a/fs/jffs2/erase.c
+++ b/fs/jffs2/erase.c
@@ -401,7 +401,7 @@ static void jffs2_mark_erased_block(struct jffs2_sb_info *c, struct jffs2_eraseb
 {
 	size_t retlen;
 	int ret;
-	uint32_t uninitialized_var(bad_offset);
+	uint32_t bad_offset;
 
 	switch (jffs2_block_check_erase(c, jeb, &bad_offset)) {
 	case -EAGAIN:	goto refile;
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 3bb2db947d29..40eed413ea59 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -351,7 +351,7 @@ static ssize_t write_unlock_fs(struct file *file, char *buf, size_t size)
 static ssize_t write_filehandle(struct file *file, char *buf, size_t size)
 {
 	char *dname, *path;
-	int uninitialized_var(maxsize);
+	int maxsize;
 	char *mesg = buf;
 	int len;
 	struct auth_domain *dom;
diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 2f834add165b..4c1b90442d6f 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4707,7 +4707,7 @@ int ocfs2_insert_extent(handle_t *handle,
 			struct ocfs2_alloc_context *meta_ac)
 {
 	int status;
-	int uninitialized_var(free_records);
+	int free_records;
 	struct buffer_head *last_eb_bh = NULL;
 	struct ocfs2_insert_type insert = {0, };
 	struct ocfs2_extent_rec rec;
@@ -7051,7 +7051,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 	int need_free = 0;
 	u32 bit_off, num;
 	handle_t *handle;
-	u64 uninitialized_var(block);
+	u64 block;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 5761060d2ba8..bdfba9db558a 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -848,9 +848,9 @@ static int ocfs2_dx_dir_lookup(struct inode *inode,
 			       u64 *ret_phys_blkno)
 {
 	int ret = 0;
-	unsigned int cend, uninitialized_var(clen);
-	u32 uninitialized_var(cpos);
-	u64 uninitialized_var(blkno);
+	unsigned int cend, clen;
+	u32 cpos;
+	u64 blkno;
 	u32 name_hash = hinfo->major_hash;
 
 	ret = ocfs2_dx_dir_lookup_rec(inode, el, name_hash, &cpos, &blkno,
@@ -894,7 +894,7 @@ static int ocfs2_dx_dir_search(const char *name, int namelen,
 			       struct ocfs2_dir_lookup_result *res)
 {
 	int ret, i, found;
-	u64 uninitialized_var(phys);
+	u64 phys;
 	struct buffer_head *dx_leaf_bh = NULL;
 	struct ocfs2_dx_leaf *dx_leaf;
 	struct ocfs2_dx_entry *dx_entry = NULL;
@@ -4393,9 +4393,9 @@ static int ocfs2_dx_dir_remove_index(struct inode *dir,
 int ocfs2_dx_dir_truncate(struct inode *dir, struct buffer_head *di_bh)
 {
 	int ret;
-	unsigned int uninitialized_var(clen);
-	u32 major_hash = UINT_MAX, p_cpos, uninitialized_var(cpos);
-	u64 uninitialized_var(blkno);
+	unsigned int clen;
+	u32 major_hash = UINT_MAX, p_cpos, cpos;
+	u64 blkno;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	struct buffer_head *dx_root_bh = NULL;
 	struct ocfs2_dx_root_block *dx_root;
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index e3e2d1b2af51..f3926765c3f0 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -403,7 +403,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 {
 	int i, ret, tree_height, len;
 	struct ocfs2_dinode *di;
-	struct ocfs2_extent_block *uninitialized_var(eb);
+	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list *el;
 	struct ocfs2_extent_rec *rec;
 	struct buffer_head *eb_bh = NULL;
@@ -599,7 +599,7 @@ int ocfs2_get_clusters(struct inode *inode, u32 v_cluster,
 		       unsigned int *extent_flags)
 {
 	int ret;
-	unsigned int uninitialized_var(hole_len), flags = 0;
+	unsigned int hole_len, flags = 0;
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_extent_rec rec;
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 5381020aaa9a..c46bf7f581a1 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2498,7 +2498,7 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
 	struct buffer_head *new_di_bh = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
 	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
-	u64 uninitialized_var(di_blkno), suballoc_loc;
+	u64 di_blkno, suballoc_loc;
 	u16 suballoc_bit;
 
 	status = ocfs2_inode_lock(dir, &parent_di_bh, 1);
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index cfb77f70c888..3b397fa9c9e8 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1063,7 +1063,7 @@ static int ocfs2_get_refcount_rec(struct ocfs2_caching_info *ci,
 				  struct buffer_head **ret_bh)
 {
 	int ret = 0, i, found;
-	u32 low_cpos, uninitialized_var(cpos_end);
+	u32 low_cpos, cpos_end;
 	struct ocfs2_extent_list *el;
 	struct ocfs2_extent_rec *rec = NULL;
 	struct ocfs2_extent_block *eb = NULL;
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 90c830e3758e..9ccd19d8f7b1 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1211,7 +1211,7 @@ static int ocfs2_xattr_block_get(struct inode *inode,
 	struct ocfs2_xattr_value_root *xv;
 	size_t size;
 	int ret = -ENODATA, name_offset, name_len, i;
-	int uninitialized_var(block_off);
+	int block_off;
 
 	xs->bucket = ocfs2_xattr_bucket_new(inode);
 	if (!xs->bucket) {
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index d7b5f09d298c..2c7b70ee1388 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -220,7 +220,7 @@ static int omfs_get_block(struct inode *inode, sector_t block,
 	struct buffer_head *bh;
 	sector_t next, offset;
 	int ret;
-	u64 uninitialized_var(new_block);
+	u64 new_block;
 	u32 max_extents;
 	int extent_count;
 	struct omfs_extent *oe;
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 9709cf22cab3..507cda8ee9dc 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -47,7 +47,7 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 {
 	ssize_t list_size, size, value_size = 0;
 	char *buf, *name, *value = NULL;
-	int uninitialized_var(error);
+	int error;
 	size_t slen;
 
 	if (!(old->d_inode->i_opflags & IOP_XATTR) ||
@@ -786,7 +786,7 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 	struct path upperpath, datapath;
 	int err;
 	char *capability = NULL;
-	ssize_t uninitialized_var(cap_size);
+	ssize_t cap_size;
 
 	ovl_path_upper(c->dentry, &upperpath);
 	if (WARN_ON(upperpath.dentry == NULL))
diff --git a/fs/ubifs/commit.c b/fs/ubifs/commit.c
index ad292c5a43a9..b5cdac9b0368 100644
--- a/fs/ubifs/commit.c
+++ b/fs/ubifs/commit.c
@@ -552,11 +552,11 @@ int dbg_old_index_check_init(struct ubifs_info *c, struct ubifs_zbranch *zroot)
  */
 int dbg_check_old_index(struct ubifs_info *c, struct ubifs_zbranch *zroot)
 {
-	int lnum, offs, len, err = 0, uninitialized_var(last_level), child_cnt;
+	int lnum, offs, len, err = 0, last_level, child_cnt;
 	int first = 1, iip;
 	struct ubifs_debug_info *d = c->dbg;
-	union ubifs_key uninitialized_var(lower_key), upper_key, l_key, u_key;
-	unsigned long long uninitialized_var(last_sqnum);
+	union ubifs_key lower_key, upper_key, l_key, u_key;
+	unsigned long long last_sqnum;
 	struct ubifs_idx_node *idx;
 	struct list_head list;
 	struct idx_node *i;
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index ef85ec167a84..9d042942d8b2 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1260,7 +1260,7 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct ubifs_budget_req ino_req = { .dirtied_ino = 1,
 			.dirtied_ino_d = ALIGN(old_inode_ui->data_len, 8) };
 	struct timespec64 time;
-	unsigned int uninitialized_var(saved_nlink);
+	unsigned int saved_nlink;
 	struct fscrypt_name old_nm, new_nm;
 
 	/*
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 49fe062ce45e..b77d1637bbbc 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -222,7 +222,7 @@ static int write_begin_slow(struct address_space *mapping,
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 	pgoff_t index = pos >> PAGE_SHIFT;
 	struct ubifs_budget_req req = { .new_page = 1 };
-	int uninitialized_var(err), appending = !!(pos + len > inode->i_size);
+	int err, appending = !!(pos + len > inode->i_size);
 	struct page *page;
 
 	dbg_gen("ino %lu, pos %llu, len %u, i_size %lld",
@@ -426,7 +426,7 @@ static int ubifs_write_begin(struct file *file, struct address_space *mapping,
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 	struct ubifs_inode *ui = ubifs_inode(inode);
 	pgoff_t index = pos >> PAGE_SHIFT;
-	int uninitialized_var(err), appending = !!(pos + len > inode->i_size);
+	int err, appending = !!(pos + len > inode->i_size);
 	int skipped_read = 0;
 	struct page *page;
 
diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index e5ec1afe1c66..2e6264318bd9 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -1222,7 +1222,7 @@ int ubifs_jnl_rename(struct ubifs_info *c, const struct inode *old_dir,
 	int aligned_dlen1, aligned_dlen2, plen = UBIFS_INO_NODE_SZ;
 	int last_reference = !!(new_inode && new_inode->i_nlink == 0);
 	int move = (old_dir != new_dir);
-	struct ubifs_inode *uninitialized_var(new_ui);
+	struct ubifs_inode *new_ui;
 	u8 hash_old_dir[UBIFS_HASH_ARR_SZ];
 	u8 hash_new_dir[UBIFS_HASH_ARR_SZ];
 	u8 hash_new_inode[UBIFS_HASH_ARR_SZ];
@@ -1507,7 +1507,7 @@ int ubifs_jnl_truncate(struct ubifs_info *c, const struct inode *inode,
 	union ubifs_key key, to_key;
 	struct ubifs_ino_node *ino;
 	struct ubifs_trun_node *trun;
-	struct ubifs_data_node *uninitialized_var(dn);
+	struct ubifs_data_node *dn;
 	int err, dlen, len, lnum, offs, bit, sz, sync = IS_SYNC(inode);
 	struct ubifs_inode *ui = ubifs_inode(inode);
 	ino_t inum = inode->i_ino;
diff --git a/fs/ubifs/lpt.c b/fs/ubifs/lpt.c
index e21abf250951..6e0a153b7194 100644
--- a/fs/ubifs/lpt.c
+++ b/fs/ubifs/lpt.c
@@ -275,7 +275,7 @@ uint32_t ubifs_unpack_bits(const struct ubifs_info *c, uint8_t **addr, int *pos,
 	const int k = 32 - nrbits;
 	uint8_t *p = *addr;
 	int b = *pos;
-	uint32_t uninitialized_var(val);
+	uint32_t val;
 	const int bytes = (nrbits + b + 7) >> 3;
 
 	ubifs_assert(c, nrbits > 0);
diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index e8e7b0e9532e..f609f6cdde70 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -892,7 +892,7 @@ static int fallible_resolve_collision(struct ubifs_info *c,
 				      int adding)
 {
 	struct ubifs_znode *o_znode = NULL, *znode = *zn;
-	int uninitialized_var(o_n), err, cmp, unsure = 0, nn = *n;
+	int o_n, err, cmp, unsure = 0, nn = *n;
 
 	cmp = fallible_matches_name(c, &znode->zbranch[nn], nm);
 	if (unlikely(cmp < 0))
@@ -1514,8 +1514,8 @@ int ubifs_tnc_locate(struct ubifs_info *c, const union ubifs_key *key,
  */
 int ubifs_tnc_get_bu_keys(struct ubifs_info *c, struct bu_info *bu)
 {
-	int n, err = 0, lnum = -1, uninitialized_var(offs);
-	int uninitialized_var(len);
+	int n, err = 0, lnum = -1, offs;
+	int len;
 	unsigned int block = key_block(c, &bu->key);
 	struct ubifs_znode *znode;
 
diff --git a/fs/ubifs/tnc_misc.c b/fs/ubifs/tnc_misc.c
index 49cb34c3f324..ccaf94ea5be3 100644
--- a/fs/ubifs/tnc_misc.c
+++ b/fs/ubifs/tnc_misc.c
@@ -126,8 +126,8 @@ int ubifs_search_zbranch(const struct ubifs_info *c,
 			 const struct ubifs_znode *znode,
 			 const union ubifs_key *key, int *n)
 {
-	int beg = 0, end = znode->child_cnt, uninitialized_var(mid);
-	int uninitialized_var(cmp);
+	int beg = 0, end = znode->child_cnt, mid;
+	int cmp;
 	const struct ubifs_zbranch *zbr = &znode->zbranch[0];
 
 	ubifs_assert(c, end > beg);
diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 02f03fadb75b..8e597db4d971 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -564,7 +564,7 @@ static udf_pblk_t udf_table_new_block(struct super_block *sb,
 	udf_pblk_t newblock = 0;
 	uint32_t adsize;
 	uint32_t elen, goal_elen = 0;
-	struct kernel_lb_addr eloc, uninitialized_var(goal_eloc);
+	struct kernel_lb_addr eloc, goal_eloc;
 	struct extent_position epos, goal_epos;
 	int8_t etype;
 	struct udf_inode_info *iinfo = UDF_I(table);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f37f5cc4b19f..30525861c596 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -126,7 +126,7 @@ xfs_bmap_rtalloc(
 	 * pick an extent that will space things out in the rt area.
 	 */
 	if (ap->eof && ap->offset == 0) {
-		xfs_rtblock_t uninitialized_var(rtx); /* realtime extent no */
+		xfs_rtblock_t rtx; /* realtime extent no */
 
 		error = xfs_rtpick_extent(mp, ap->tp, ralen, &rtx);
 		if (error)
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index efc8350b42fb..804a3e687b8d 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -293,7 +293,7 @@ flow_action_mixed_hw_stats_check(const struct flow_action *action,
 				 struct netlink_ext_ack *extack)
 {
 	const struct flow_action_entry *action_entry;
-	u8 uninitialized_var(last_hw_stats);
+	u8 last_hw_stats;
 	int i;
 
 	if (flow_offload_has_one_action(action))
diff --git a/kernel/async.c b/kernel/async.c
index 4f9c1d614016..33258e6e20f8 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -111,7 +111,7 @@ static void async_run_entry_fn(struct work_struct *work)
 	struct async_entry *entry =
 		container_of(work, struct async_entry, work);
 	unsigned long flags;
-	ktime_t uninitialized_var(calltime), delta, rettime;
+	ktime_t calltime, delta, rettime;
 
 	/* 1) run (and print duration) */
 	if (initcall_debug && system_state < SYSTEM_RUNNING) {
@@ -287,7 +287,7 @@ EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
  */
 void async_synchronize_cookie_domain(async_cookie_t cookie, struct async_domain *domain)
 {
-	ktime_t uninitialized_var(starttime), delta, endtime;
+	ktime_t starttime, delta, endtime;
 
 	if (initcall_debug && system_state < SYSTEM_RUNNING) {
 		pr_debug("async_waiting @ %i\n", task_pid_nr(current));
diff --git a/kernel/audit.c b/kernel/audit.c
index 8c201f414226..ec38479f9228 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1800,7 +1800,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 {
 	struct audit_buffer *ab;
 	struct timespec64 t;
-	unsigned int uninitialized_var(serial);
+	unsigned int serial;
 
 	if (audit_initialized != AUDIT_INITIALIZED)
 		return NULL;
diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 924bc9298a42..af0a26a521eb 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -554,7 +554,7 @@ int vkdb_printf(enum kdb_msgsrc src, const char *fmt, va_list ap)
 	char *cp, *cp2, *cphold = NULL, replaced_byte = ' ';
 	char *moreprompt = "more> ";
 	struct console *c;
-	unsigned long uninitialized_var(flags);
+	unsigned long flags;
 
 	/* Serialize kdb_printf if multiple cpus try to write at once.
 	 * But if any cpu goes recursive in kdb, just print the output,
diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 9e1777c81f55..dac55dff431f 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -882,7 +882,7 @@ static int device_dma_allocations(struct device *dev, struct dma_debug_entry **o
 static int dma_debug_device_change(struct notifier_block *nb, unsigned long action, void *data)
 {
 	struct device *dev = data;
-	struct dma_debug_entry *uninitialized_var(entry);
+	struct dma_debug_entry *entry;
 	int count;
 
 	if (dma_debug_disabled())
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e296c5c59c6f..40c74fa55cca 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11485,7 +11485,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	struct perf_event *group_leader = NULL, *output_event = NULL;
 	struct perf_event *event, *sibling;
 	struct perf_event_attr attr;
-	struct perf_event_context *ctx, *uninitialized_var(gctx);
+	struct perf_event_context *ctx, *gctx;
 	struct file *event_file = NULL;
 	struct fd group = {NULL, 0};
 	struct task_struct *task = NULL;
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index ece7e13f6e4a..ff60e630a0ba 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -2187,7 +2187,7 @@ static void handle_swbp(struct pt_regs *regs)
 {
 	struct uprobe *uprobe;
 	unsigned long bp_vaddr;
-	int uninitialized_var(is_swbp);
+	int is_swbp;
 
 	bp_vaddr = uprobe_get_swbp_addr(regs);
 	if (bp_vaddr == get_trampoline_vaddr())
diff --git a/kernel/exit.c b/kernel/exit.c
index 1b772f2c671b..281fccb7b7ee 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -94,7 +94,7 @@ static void __exit_signal(struct task_struct *tsk)
 	struct signal_struct *sig = tsk->signal;
 	bool group_dead = thread_group_leader(tsk);
 	struct sighand_struct *sighand;
-	struct tty_struct *uninitialized_var(tty);
+	struct tty_struct *tty;
 	u64 utime, stime;
 
 	sighand = rcu_dereference_check(tsk->sighand,
diff --git a/kernel/futex.c b/kernel/futex.c
index b4b9f960b610..d1cd451158bc 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1326,7 +1326,7 @@ static int lookup_pi_state(u32 __user *uaddr, u32 uval,
 static int lock_pi_update_atomic(u32 __user *uaddr, u32 uval, u32 newval)
 {
 	int err;
-	u32 uninitialized_var(curval);
+	u32 curval;
 
 	if (unlikely(should_fail_futex(true)))
 		return -EFAULT;
@@ -1496,7 +1496,7 @@ static void mark_wake_futex(struct wake_q_head *wake_q, struct futex_q *q)
  */
 static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_pi_state *pi_state)
 {
-	u32 uninitialized_var(curval), newval;
+	u32 curval, newval;
 	struct task_struct *new_owner;
 	bool postunlock = false;
 	DEFINE_WAKE_Q(wake_q);
@@ -2370,7 +2370,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 				struct task_struct *argowner)
 {
 	struct futex_pi_state *pi_state = q->pi_state;
-	u32 uval, uninitialized_var(curval), newval;
+	u32 uval, curval, newval;
 	struct task_struct *oldowner, *newowner;
 	u32 newtid;
 	int ret, err = 0;
@@ -2996,7 +2996,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags,
  */
 static int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
 {
-	u32 uninitialized_var(curval), uval, vpid = task_pid_vnr(current);
+	u32 curval, uval, vpid = task_pid_vnr(current);
 	union futex_key key = FUTEX_KEY_INIT;
 	struct futex_hash_bucket *hb;
 	struct futex_q *top_waiter;
@@ -3479,7 +3479,7 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr,
 			      bool pi, bool pending_op)
 {
-	u32 uval, uninitialized_var(nval), mval;
+	u32 uval, nval, mval;
 	int err;
 
 	/* Futex address must be 32bit aligned */
@@ -3609,7 +3609,7 @@ static void exit_robust_list(struct task_struct *curr)
 	struct robust_list_head __user *head = curr->robust_list;
 	struct robust_list __user *entry, *next_entry, *pending;
 	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
-	unsigned int uninitialized_var(next_pi);
+	unsigned int next_pi;
 	unsigned long futex_offset;
 	int rc;
 
@@ -3909,7 +3909,7 @@ static void compat_exit_robust_list(struct task_struct *curr)
 	struct compat_robust_list_head __user *head = curr->compat_robust_list;
 	struct robust_list __user *entry, *next_entry, *pending;
 	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
-	unsigned int uninitialized_var(next_pi);
+	unsigned int next_pi;
 	compat_uptr_t uentry, next_uentry, upending;
 	compat_long_t futex_offset;
 	int rc;
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index dd3cc0854c32..14504ccdc48f 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1723,7 +1723,7 @@ static int noop_count(struct lock_list *entry, void *data)
 static unsigned long __lockdep_count_forward_deps(struct lock_list *this)
 {
 	unsigned long  count = 0;
-	struct lock_list *uninitialized_var(target_entry);
+	struct lock_list *target_entry;
 
 	__bfs_forwards(this, (void *)&count, noop_count, &target_entry);
 
@@ -1749,7 +1749,7 @@ unsigned long lockdep_count_forward_deps(struct lock_class *class)
 static unsigned long __lockdep_count_backward_deps(struct lock_list *this)
 {
 	unsigned long  count = 0;
-	struct lock_list *uninitialized_var(target_entry);
+	struct lock_list *target_entry;
 
 	__bfs_backwards(this, (void *)&count, noop_count, &target_entry);
 
@@ -1804,7 +1804,7 @@ check_noncircular(struct held_lock *src, struct held_lock *target,
 		  struct lock_trace **const trace)
 {
 	int ret;
-	struct lock_list *uninitialized_var(target_entry);
+	struct lock_list *target_entry;
 	struct lock_list src_entry = {
 		.class = hlock_class(src),
 		.parent = NULL,
@@ -1842,7 +1842,7 @@ static noinline int
 check_redundant(struct held_lock *src, struct held_lock *target)
 {
 	int ret;
-	struct lock_list *uninitialized_var(target_entry);
+	struct lock_list *target_entry;
 	struct lock_list src_entry = {
 		.class = hlock_class(src),
 		.parent = NULL,
@@ -2244,8 +2244,8 @@ static int check_irq_usage(struct task_struct *curr, struct held_lock *prev,
 {
 	unsigned long usage_mask = 0, forward_mask, backward_mask;
 	enum lock_usage_bit forward_bit = 0, backward_bit = 0;
-	struct lock_list *uninitialized_var(target_entry1);
-	struct lock_list *uninitialized_var(target_entry);
+	struct lock_list *target_entry1;
+	struct lock_list *target_entry;
 	struct lock_list this, that;
 	int ret;
 
@@ -3438,7 +3438,7 @@ check_usage_forwards(struct task_struct *curr, struct held_lock *this,
 {
 	int ret;
 	struct lock_list root;
-	struct lock_list *uninitialized_var(target_entry);
+	struct lock_list *target_entry;
 
 	root.parent = NULL;
 	root.class = hlock_class(this);
@@ -3465,7 +3465,7 @@ check_usage_backwards(struct task_struct *curr, struct held_lock *this,
 {
 	int ret;
 	struct lock_list root;
-	struct lock_list *uninitialized_var(target_entry);
+	struct lock_list *target_entry;
 
 	root.parent = NULL;
 	root.class = hlock_class(this);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b8e1ca48be50..b57e9f4da21c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -577,7 +577,7 @@ static void rb_wake_up_waiters(struct irq_work *work)
  */
 int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
 {
-	struct ring_buffer_per_cpu *uninitialized_var(cpu_buffer);
+	struct ring_buffer_per_cpu *cpu_buffer;
 	DEFINE_WAIT(wait);
 	struct rb_irq_work *work;
 	int ret = 0;
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 34e406fe561f..8e4a3a4397f2 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1029,7 +1029,7 @@ void *radix_tree_tag_clear(struct radix_tree_root *root,
 {
 	struct radix_tree_node *node, *parent;
 	unsigned long maxindex;
-	int uninitialized_var(offset);
+	int offset;
 
 	radix_tree_load_root(root, &node, &maxindex);
 	if (index > maxindex)
diff --git a/lib/test_lockup.c b/lib/test_lockup.c
index ea09ca335b21..29ee4d5dbb10 100644
--- a/lib/test_lockup.c
+++ b/lib/test_lockup.c
@@ -168,7 +168,7 @@ static int master_cpu;
 
 static void test_lock(bool master, bool verbose)
 {
-	u64 uninitialized_var(wait_start);
+	u64 wait_start;
 
 	if (measure_lock_wait)
 		wait_start = local_clock();
diff --git a/mm/frontswap.c b/mm/frontswap.c
index 60bb20e8a951..fd3337702513 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -446,7 +446,7 @@ static int __frontswap_shrink(unsigned long target_pages,
 void frontswap_shrink(unsigned long target_pages)
 {
 	unsigned long pages_to_unuse = 0;
-	int uninitialized_var(type), ret;
+	int type, ret;
 
 	/*
 	 * we don't want to hold swap_lock while doing a very
diff --git a/mm/ksm.c b/mm/ksm.c
index 281c00129a2e..d7bd8565f2d1 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2387,7 +2387,7 @@ static struct rmap_item *scan_get_next_rmap_item(struct page **page)
 static void ksm_do_scan(unsigned int scan_npages)
 {
 	struct rmap_item *rmap_item;
-	struct page *uninitialized_var(page);
+	struct page *page;
 
 	while (scan_npages-- && likely(!freezing(current))) {
 		cond_resched();
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f973a025569b..914ad73a5d5a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1021,7 +1021,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 				   struct mem_cgroup *prev,
 				   struct mem_cgroup_reclaim_cookie *reclaim)
 {
-	struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
+	struct mem_cgroup_reclaim_iter *iter;
 	struct cgroup_subsys_state *css = NULL;
 	struct mem_cgroup *memcg = NULL;
 	struct mem_cgroup *pos = NULL;
diff --git a/mm/memory.c b/mm/memory.c
index 21438278afca..146ffb2a5c7d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2205,7 +2205,7 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 {
 	pte_t *pte;
 	int err = 0;
-	spinlock_t *uninitialized_var(ptl);
+	spinlock_t *ptl;
 
 	if (create) {
 		pte = (mm == &init_mm) ?
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 48ba9729062e..fe7ae403566e 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1237,7 +1237,7 @@ int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
 static struct page *new_page(struct page *page, unsigned long start)
 {
 	struct vm_area_struct *vma;
-	unsigned long uninitialized_var(address);
+	unsigned long address;
 
 	vma = find_vma(current->mm, start);
 	while (vma) {
@@ -1632,7 +1632,7 @@ static int kernel_get_mempolicy(int __user *policy,
 				unsigned long flags)
 {
 	int err;
-	int uninitialized_var(pval);
+	int pval;
 	nodemask_t nodes;
 
 	addr = untagged_addr(addr);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ca864102bebe..a044156fe992 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -967,7 +967,7 @@ static inline void __free_one_page(struct page *page,
 		int migratetype, bool report)
 {
 	struct capture_control *capc = task_capc(zone);
-	unsigned long uninitialized_var(buddy_pfn);
+	unsigned long buddy_pfn;
 	unsigned long combined_pfn;
 	unsigned int max_order;
 	struct page *buddy;
diff --git a/mm/percpu.c b/mm/percpu.c
index 696367b18222..b626766160ce 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -2513,7 +2513,7 @@ static struct pcpu_alloc_info * __init pcpu_build_alloc_info(
 	const size_t static_size = __per_cpu_end - __per_cpu_start;
 	int nr_groups = 1, nr_units = 0;
 	size_t size_sum, min_unit_size, alloc_size;
-	int upa, max_upa, uninitialized_var(best_upa);	/* units_per_alloc */
+	int upa, max_upa, best_upa;	/* units_per_alloc */
 	int last_allocs, group, unit;
 	unsigned int cpu, tcpu;
 	struct pcpu_alloc_info *ai;
diff --git a/mm/slub.c b/mm/slub.c
index 336be3224092..ab5066f5550f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1218,7 +1218,7 @@ static noinline int free_debug_processing(
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 	void *object = head;
 	int cnt = 0;
-	unsigned long uninitialized_var(flags);
+	unsigned long flags;
 	int ret = 0;
 
 	spin_lock_irqsave(&n->list_lock, flags);
@@ -2901,7 +2901,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 	struct page new;
 	unsigned long counters;
 	struct kmem_cache_node *n = NULL;
-	unsigned long uninitialized_var(flags);
+	unsigned long flags;
 
 	stat(s, FREE_SLOWPATH);
 
diff --git a/mm/swap.c b/mm/swap.c
index 0ac463d44cff..06f216893451 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -824,8 +824,8 @@ void release_pages(struct page **pages, int nr)
 	LIST_HEAD(pages_to_free);
 	struct pglist_data *locked_pgdat = NULL;
 	struct lruvec *lruvec;
-	unsigned long uninitialized_var(flags);
-	unsigned int uninitialized_var(lock_batch);
+	unsigned long flags;
+	unsigned int lock_batch;
 
 	for (i = 0; i < nr; i++) {
 		struct page *page = pages[i];
diff --git a/net/dccp/options.c b/net/dccp/options.c
index 3b42f5c6a63d..9fed0ae21e63 100644
--- a/net/dccp/options.c
+++ b/net/dccp/options.c
@@ -56,7 +56,7 @@ int dccp_parse_options(struct sock *sk, struct dccp_request_sock *dreq,
 					(dh->dccph_doff * 4);
 	struct dccp_options_received *opt_recv = &dp->dccps_options_received;
 	unsigned char opt, len;
-	unsigned char *uninitialized_var(value);
+	unsigned char *value;
 	u32 elapsed_time;
 	__be32 opt_val;
 	int rc;
diff --git a/net/ipv4/netfilter/nf_socket_ipv4.c b/net/ipv4/netfilter/nf_socket_ipv4.c
index c94445b44d8c..2d42e4c35a20 100644
--- a/net/ipv4/netfilter/nf_socket_ipv4.c
+++ b/net/ipv4/netfilter/nf_socket_ipv4.c
@@ -84,11 +84,11 @@ nf_socket_get_sock_v4(struct net *net, struct sk_buff *skb, const int doff,
 struct sock *nf_sk_lookup_slow_v4(struct net *net, const struct sk_buff *skb,
 				  const struct net_device *indev)
 {
-	__be32 uninitialized_var(daddr), uninitialized_var(saddr);
-	__be16 uninitialized_var(dport), uninitialized_var(sport);
+	__be32 daddr, saddr;
+	__be16 dport, sport;
 	const struct iphdr *iph = ip_hdr(skb);
 	struct sk_buff *data_skb = NULL;
-	u8 uninitialized_var(protocol);
+	u8 protocol;
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn const *ct;
diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index d64b83e85642..e6e1190a6ed9 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -535,7 +535,7 @@ int ipv6_flowlabel_opt_get(struct sock *sk, struct in6_flowlabel_req *freq,
 
 int ipv6_flowlabel_opt(struct sock *sk, char __user *optval, int optlen)
 {
-	int uninitialized_var(err);
+	int err;
 	struct net *net = sock_net(sk);
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct in6_flowlabel_req freq;
diff --git a/net/ipv6/netfilter/nf_socket_ipv6.c b/net/ipv6/netfilter/nf_socket_ipv6.c
index b9df879c48d3..6fd54744cbc3 100644
--- a/net/ipv6/netfilter/nf_socket_ipv6.c
+++ b/net/ipv6/netfilter/nf_socket_ipv6.c
@@ -97,7 +97,7 @@ nf_socket_get_sock_v6(struct net *net, struct sk_buff *skb, int doff,
 struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 				  const struct net_device *indev)
 {
-	__be16 uninitialized_var(dport), uninitialized_var(sport);
+	__be16 dport, sport;
 	const struct in6_addr *daddr = NULL, *saddr = NULL;
 	struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct sk_buff *data_skb = NULL;
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 9eca90414bb7..b22801f97bce 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -382,7 +382,7 @@ static int help(struct sk_buff *skb,
 	int ret;
 	u32 seq;
 	int dir = CTINFO2DIR(ctinfo);
-	unsigned int uninitialized_var(matchlen), uninitialized_var(matchoff);
+	unsigned int matchlen, matchoff;
 	struct nf_ct_ftp_master *ct_ftp_info = nfct_help_data(ct);
 	struct nf_conntrack_expect *exp;
 	union nf_inet_addr *daddr;
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 0ba020ca38e6..f02992419850 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -689,7 +689,7 @@ nfulnl_log_packet(struct net *net,
 	struct nfnl_log_net *log = nfnl_log_pernet(net);
 	const struct nfnl_ct_hook *nfnl_ct = NULL;
 	struct nf_conn *ct = NULL;
-	enum ip_conntrack_info uninitialized_var(ctinfo);
+	enum ip_conntrack_info ctinfo;
 
 	if (li_user && li_user->type == NF_LOG_TYPE_ULOG)
 		li = li_user;
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 3243a31f6e82..dadfc06245a3 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -388,7 +388,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	struct net_device *indev;
 	struct net_device *outdev;
 	struct nf_conn *ct = NULL;
-	enum ip_conntrack_info uninitialized_var(ctinfo);
+	enum ip_conntrack_info ctinfo;
 	struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
 	char *secdata = NULL;
@@ -1168,7 +1168,7 @@ static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
 	struct nfqnl_instance *queue;
 	unsigned int verdict;
 	struct nf_queue_entry *entry;
-	enum ip_conntrack_info uninitialized_var(ctinfo);
+	enum ip_conntrack_info ctinfo;
 	struct nfnl_ct_hook *nfnl_ct;
 	struct nf_conn *ct = NULL;
 	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index 80ae7b9fa90a..354c3cc90741 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -225,7 +225,7 @@ static u32 flow_get_skgid(const struct sk_buff *skb)
 
 static u32 flow_get_vlan_tag(const struct sk_buff *skb)
 {
-	u16 uninitialized_var(tag);
+	u16 tag;
 
 	if (vlan_get_tag(skb, &tag) < 0)
 		return 0;
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 1496e87cd07b..933d5e322c54 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1631,7 +1631,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 {
 	struct cake_sched_data *q = qdisc_priv(sch);
 	int len = qdisc_pkt_len(skb);
-	int uninitialized_var(ret);
+	int ret;
 	struct sk_buff *ack = NULL;
 	ktime_t now = ktime_get();
 	struct cake_tin_data *b;
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 39b427dc7512..ce4519358106 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -360,7 +360,7 @@ cbq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	    struct sk_buff **to_free)
 {
 	struct cbq_sched_data *q = qdisc_priv(sch);
-	int uninitialized_var(ret);
+	int ret;
 	struct cbq_class *cl = cbq_classify(skb, sch, &ret);
 
 #ifdef CONFIG_NET_CLS_ACT
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 436160be9c18..d84d23b6183d 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -187,7 +187,7 @@ static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
 	unsigned int idx, prev_backlog, prev_qlen;
 	struct fq_codel_flow *flow;
-	int uninitialized_var(ret);
+	int ret;
 	unsigned int pkt_len;
 	bool memory_limited;
 
diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index fb760cee824e..4d307f17e084 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -130,7 +130,7 @@ static int fq_pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 {
 	struct fq_pie_sched_data *q = qdisc_priv(sch);
 	struct fq_pie_flow *sel_flow;
-	int uninitialized_var(ret);
+	int ret;
 	u8 memory_limited = false;
 	u8 enqueue = false;
 	u32 pkt_len;
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index 433f2190960f..92ad4115e473 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1533,7 +1533,7 @@ hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 {
 	unsigned int len = qdisc_pkt_len(skb);
 	struct hfsc_class *cl;
-	int uninitialized_var(err);
+	int err;
 	bool first;
 
 	cl = hfsc_classify(skb, sch, &err);
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 8184c87da8be..6feab225b4ba 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -579,7 +579,7 @@ static inline void htb_deactivate(struct htb_sched *q, struct htb_class *cl)
 static int htb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		       struct sk_buff **to_free)
 {
-	int uninitialized_var(ret);
+	int ret;
 	unsigned int len = qdisc_pkt_len(skb);
 	struct htb_sched *q = qdisc_priv(sch);
 	struct htb_class *cl = htb_classify(skb, sch, &ret);
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 5a6def5e4e6d..15f400dcb400 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -349,7 +349,7 @@ sfq_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 	unsigned int hash, dropped;
 	sfq_index x, qlen;
 	struct sfq_slot *slot;
-	int uninitialized_var(ret);
+	int ret;
 	struct sk_buff *head;
 	int delta;
 
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 023514e392b3..2faae72da362 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -524,7 +524,7 @@ static int svc_udp_sendto(struct svc_rqst *rqstp)
 		.msg_control	= cmh,
 		.msg_controllen	= sizeof(buffer),
 	};
-	unsigned int uninitialized_var(sent);
+	unsigned int sent;
 	int err;
 
 	svc_release_udp_skb(rqstp);
@@ -1075,7 +1075,7 @@ static int svc_tcp_sendto(struct svc_rqst *rqstp)
 	struct msghdr msg = {
 		.msg_flags	= 0,
 	};
-	unsigned int uninitialized_var(sent);
+	unsigned int sent;
 	int err;
 
 	svc_release_skb(rqstp);
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 845d0be805ec..9d258e1ca382 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -496,8 +496,8 @@ xs_read_stream_request(struct sock_xprt *transport, struct msghdr *msg,
 		int flags, struct rpc_rqst *req)
 {
 	struct xdr_buf *buf = &req->rq_private_buf;
-	size_t want, uninitialized_var(read);
-	ssize_t uninitialized_var(ret);
+	size_t want, read;
+	ssize_t ret;
 
 	xs_read_header(transport, buf);
 
@@ -844,7 +844,7 @@ static int xs_local_send_request(struct rpc_rqst *req)
 	struct msghdr msg = {
 		.msg_flags	= XS_SENDMSG_FLAGS,
 	};
-	unsigned int uninitialized_var(sent);
+	unsigned int sent;
 	int status;
 
 	/* Close the stream if the previous transmission was incomplete */
@@ -915,7 +915,7 @@ static int xs_udp_send_request(struct rpc_rqst *req)
 		.msg_namelen	= xprt->addrlen,
 		.msg_flags	= XS_SENDMSG_FLAGS,
 	};
-	unsigned int uninitialized_var(sent);
+	unsigned int sent;
 	int status;
 
 	xs_pktdump("packet data:",
@@ -999,7 +999,7 @@ static int xs_tcp_send_request(struct rpc_rqst *req)
 		.msg_flags	= XS_SENDMSG_FLAGS,
 	};
 	bool vm_wait = false;
-	unsigned int uninitialized_var(sent);
+	unsigned int sent;
 	int status;
 
 	/* Close the stream if the previous transmission was incomplete */
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 8c2763eb6aae..8595d583edb3 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -670,7 +670,7 @@ static int tls_push_record(struct sock *sk, int flags,
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 	struct tls_rec *rec = ctx->open_rec, *tmp = NULL;
-	u32 i, split_point, uninitialized_var(orig_end);
+	u32 i, split_point, orig_end;
 	struct sk_msg *msg_pl, *msg_en;
 	struct aead_request *req;
 	bool split;
diff --git a/sound/core/control_compat.c b/sound/core/control_compat.c
index d55be1db1a8a..02df1d7db9a1 100644
--- a/sound/core/control_compat.c
+++ b/sound/core/control_compat.c
@@ -223,7 +223,7 @@ static int copy_ctl_value_from_user(struct snd_card *card,
 {
 	struct snd_ctl_elem_value32 __user *data32 = userdata;
 	int i, type, size;
-	int uninitialized_var(count);
+	int count;
 	unsigned int indirect;
 
 	if (copy_from_user(&data->id, &data32->id, sizeof(data->id)))
diff --git a/sound/isa/sb/sb16_csp.c b/sound/isa/sb/sb16_csp.c
index 4ad0ff0c4508..270af863e198 100644
--- a/sound/isa/sb/sb16_csp.c
+++ b/sound/isa/sb/sb16_csp.c
@@ -102,7 +102,7 @@ static void info_read(struct snd_info_entry *entry, struct snd_info_buffer *buff
 int snd_sb_csp_new(struct snd_sb *chip, int device, struct snd_hwdep ** rhwdep)
 {
 	struct snd_sb_csp *p;
-	int uninitialized_var(version);
+	int version;
 	int err;
 	struct snd_hwdep *hw;
 
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 4a9a2f6ef5a4..76d02d295175 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -310,7 +310,7 @@ static void queue_pending_output_urbs(struct snd_usb_endpoint *ep)
 	while (test_bit(EP_FLAG_RUNNING, &ep->flags)) {
 
 		unsigned long flags;
-		struct snd_usb_packet_info *uninitialized_var(packet);
+		struct snd_usb_packet_info *packet;
 		struct snd_urb_ctx *ctx = NULL;
 		int err, i;
 
-- 
2.25.1

