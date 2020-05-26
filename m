Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F2F1A2611
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 17:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbgDHPsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 11:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729567AbgDHPqd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 11:46:33 -0400
Received: from mail.kernel.org (ip5f5ad4d8.dynamic.kabel-deutschland.de [95.90.212.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E436F20769;
        Wed,  8 Apr 2020 15:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586360791;
        bh=NGLDDtyN8RZKYu/2cTSKBLZPkCz8Mr0c9YVBRHz1zys=;
        h=From:To:Cc:Subject:Date:From;
        b=I3LVCc26/VdF24AsOrt+PHJ6A8shQrFjca47izBLXO8vl1fetOmpTsay+HfFnjRDn
         ELpq2el4OVbLL0QQpHim4bJ4r72BlEiJ9tHPbEFlZ/E6g9CVUSW9fzJZn0GNpSqQLs
         eoPTB+ArHDBqNWFtK9BnG7DerSf9cD29j4b39qq4=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jMCuK-000cAH-Vl; Wed, 08 Apr 2020 17:46:28 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Rob Herring <robh@kernel.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Yuti Amonkar <yamonkar@cadence.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-mm@kvack.org, linux-rdma@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, linux-afs@lists.infradead.org,
        ecryptfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        ocfs2-devel@oss.oracle.com, linux-pci@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-ide@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-spi@vger.kernel.org,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Stephen Boyd <swboyd@chromium.org>,
        Sandeep Maheswaram <sanm@codeaurora.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        linux-usb@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Matthias Brugger <mbrugger@suse.com>, netdev@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: [PATCH 00/35] Documentation fixes for Kernel 5.8
Date:   Wed,  8 Apr 2020 17:45:52 +0200
Message-Id: <cover.1586359676.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jon,

I have a large list of patches this time for the Documentation/. So, I'm
starting sending them a little earier. Yet, those are meant to be applied
after the end of the merge window. They're based on today's linux-next,
with has only 49 patches pending to be applied upstream touching
Documentation/, so I don't expect much conflicts if applied early at
-rc cycle.

Most of the patches here were already submitted, but weren't
merged yet at next. So, it seems that nobody picked them yet.

In any case, most of those patches here are independent from 
the others.

The number of doc build warnings have been rising with time.
The main goal with this series is to get rid of most Sphinx warnings
and other errors.

Patches 1 to 5: fix broken references detected by this tool:

        ./scripts/documentation-file-ref-check

The other patches fix other random errors due to tags being
mis-interpreted or mis-used.

You should notice that several patches touch kernel-doc scripts.
IMHO, some of the warnings are actually due to kernel-doc being
too pedantic. So, I ended by improving some things at the toolset,
in order to make it smarter. That's the case of those patches:

	docs: scripts/kernel-doc: accept blank lines on parameter description
	scripts: kernel-doc: accept negation like !@var
	scripts: kernel-doc: proper handle @foo->bar()

The last 4 patches address problems with PDF building.

The first one address a conflict that will rise during the merge
window: Documentation/media will be removed. Instead of
just drop it from the list of PDF documents, I opted to drop the
entire list, as conf.py will auto-generate from the sources:

	docs: LaTeX/PDF: drop list of documents

Also, right now, PDF output is broken due to a namespace conflict 
at I2c (two pdf outputs there will have the same name).

	docs: i2c: rename i2c.svg to i2c_bus.svg

The third PDF patch is not really a fix, but it helps a lot to identify
if the build succeeded or not, by placing the final PDF output on
a separate dir:

	docs: Makefile: place final pdf docs on a separate dir

Finally, the last one solves a bug since the first supported Sphinx
version, with also impacts PDF output: basically while nested tables
are valid with ReST notation, the toolset only started supporting
it on PDF output since version 2.4:

	docs: update recommended Sphinx version to 2.4.4

PS.: Due to the large number of C/C, I opted to keep a smaller
set of C/C at this first e-mail (only e-mails with "L:" tag from
MAINTAINERS file).

Mauro Carvalho Chehab (35):
  MAINTAINERS: dt: update display/allwinner file entry
  docs: dt: fix broken reference to phy-cadence-torrent.yaml
  docs: fix broken references to text files
  docs: fix broken references for ReST files that moved around
  docs: filesystems: fix renamed references
  docs: amu: supress some Sphinx warnings
  docs: arm64: booting.rst: get rid of some warnings
  docs: pci: boot-interrupts.rst: improve html output
  futex: get rid of a kernel-docs build warning
  firewire: firewire-cdev.hL get rid of a docs warning
  scripts: kernel-doc: proper handle @foo->bar()
  lib: bitmap.c: get rid of some doc warnings
  ata: libata-core: fix a doc warning
  fs: inode.c: get rid of docs warnings
  docs: ras: get rid of some warnings
  docs: ras: don't need to repeat twice the same thing
  docs: watch_queue.rst: supress some Sphinx warnings
  scripts: kernel-doc: accept negation like !@var
  docs: infiniband: verbs.c: fix some documentation warnings
  docs: scripts/kernel-doc: accept blank lines on parameter description
  docs: spi: spi.h: fix a doc building warning
  docs: drivers: fix some warnings at base/platform.c when building docs
  docs: fusion: mptbase.c: get rid of a doc build warning
  docs: mm: slab.h: fix a broken cross-reference
  docs mm: userfaultfd.rst: use ``foo`` for literals
  docs: mm: userfaultfd.rst: use a cross-reference for a section
  docs: vm: index.rst: add an orphan doc to the building system
  docs: dt: qcom,dwc3.txt: fix cross-reference for a converted file
  MAINTAINERS: dt: fix pointers for ARM Integrator, Versatile and
    RealView
  docs: dt: fix a broken reference for a file converted to json
  powerpc: docs: cxl.rst: mark two section titles as such
  docs: LaTeX/PDF: drop list of documents
  docs: i2c: rename i2c.svg to i2c_bus.svg
  docs: Makefile: place final pdf docs on a separate dir
  docs: update recommended Sphinx version to 2.4.4

 Documentation/ABI/stable/sysfs-devices-node   |   2 +-
 Documentation/ABI/testing/procfs-smaps_rollup |   2 +-
 Documentation/Makefile                        |   6 +-
 Documentation/PCI/boot-interrupts.rst         |  34 +--
 Documentation/admin-guide/cpu-load.rst        |   2 +-
 Documentation/admin-guide/mm/userfaultfd.rst  | 209 +++++++++---------
 Documentation/admin-guide/nfs/nfsroot.rst     |   2 +-
 Documentation/admin-guide/ras.rst             |  18 +-
 Documentation/arm64/amu.rst                   |   5 +
 Documentation/arm64/booting.rst               |  36 +--
 Documentation/conf.py                         |  38 ----
 .../bindings/net/qualcomm-bluetooth.txt       |   2 +-
 .../bindings/phy/ti,phy-j721e-wiz.yaml        |   2 +-
 .../devicetree/bindings/usb/qcom,dwc3.txt     |   4 +-
 .../doc-guide/maintainer-profile.rst          |   2 +-
 .../driver-api/driver-model/device.rst        |   4 +-
 .../driver-api/driver-model/overview.rst      |   2 +-
 Documentation/filesystems/dax.txt             |   2 +-
 Documentation/filesystems/dnotify.txt         |   2 +-
 .../filesystems/ramfs-rootfs-initramfs.rst    |   2 +-
 Documentation/filesystems/sysfs.rst           |   2 +-
 Documentation/i2c/{i2c.svg => i2c_bus.svg}    |   2 +-
 Documentation/i2c/summary.rst                 |   2 +-
 Documentation/memory-barriers.txt             |   2 +-
 Documentation/powerpc/cxl.rst                 |   2 +
 .../powerpc/firmware-assisted-dump.rst        |   2 +-
 Documentation/process/adding-syscalls.rst     |   2 +-
 Documentation/process/submit-checklist.rst    |   2 +-
 Documentation/sphinx/requirements.txt         |   2 +-
 .../it_IT/process/adding-syscalls.rst         |   2 +-
 .../it_IT/process/submit-checklist.rst        |   2 +-
 .../translations/ko_KR/memory-barriers.txt    |   2 +-
 .../translations/zh_CN/filesystems/sysfs.txt  |   8 +-
 .../zh_CN/process/submit-checklist.rst        |   2 +-
 Documentation/virt/kvm/arm/pvtime.rst         |   2 +-
 Documentation/virt/kvm/devices/vcpu.rst       |   2 +-
 Documentation/virt/kvm/hypercalls.rst         |   4 +-
 Documentation/virt/kvm/mmu.rst                |   2 +-
 Documentation/virt/kvm/review-checklist.rst   |   2 +-
 Documentation/vm/index.rst                    |   1 +
 Documentation/watch_queue.rst                 |  34 ++-
 MAINTAINERS                                   |   7 +-
 arch/powerpc/include/uapi/asm/kvm_para.h      |   2 +-
 arch/x86/kvm/mmu/mmu.c                        |   2 +-
 drivers/ata/libata-core.c                     |   2 +-
 drivers/base/core.c                           |   2 +-
 drivers/base/platform.c                       |   6 +-
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      |   2 +-
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |   2 +-
 .../allwinner/sun8i-ss/sun8i-ss-cipher.c      |   2 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c |   2 +-
 drivers/gpu/drm/Kconfig                       |   2 +-
 drivers/gpu/drm/drm_ioctl.c                   |   2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h       |   2 +-
 drivers/hwtracing/coresight/Kconfig           |   2 +-
 drivers/infiniband/core/verbs.c               |   7 +-
 drivers/media/v4l2-core/v4l2-fwnode.c         |   2 +-
 drivers/message/fusion/mptbase.c              |   8 +-
 fs/Kconfig                                    |   2 +-
 fs/Kconfig.binfmt                             |   2 +-
 fs/adfs/Kconfig                               |   2 +-
 fs/affs/Kconfig                               |   2 +-
 fs/afs/Kconfig                                |   6 +-
 fs/bfs/Kconfig                                |   2 +-
 fs/cramfs/Kconfig                             |   2 +-
 fs/ecryptfs/Kconfig                           |   2 +-
 fs/fat/Kconfig                                |   8 +-
 fs/fuse/Kconfig                               |   2 +-
 fs/fuse/dev.c                                 |   2 +-
 fs/hfs/Kconfig                                |   2 +-
 fs/hpfs/Kconfig                               |   2 +-
 fs/inode.c                                    |   6 +-
 fs/isofs/Kconfig                              |   2 +-
 fs/namespace.c                                |   2 +-
 fs/notify/inotify/Kconfig                     |   2 +-
 fs/ntfs/Kconfig                               |   2 +-
 fs/ocfs2/Kconfig                              |   2 +-
 fs/overlayfs/Kconfig                          |   6 +-
 fs/proc/Kconfig                               |   4 +-
 fs/romfs/Kconfig                              |   2 +-
 fs/sysfs/dir.c                                |   2 +-
 fs/sysfs/file.c                               |   2 +-
 fs/sysfs/mount.c                              |   2 +-
 fs/sysfs/symlink.c                            |   2 +-
 fs/sysv/Kconfig                               |   2 +-
 fs/udf/Kconfig                                |   2 +-
 include/linux/kobject.h                       |   2 +-
 include/linux/kobject_ns.h                    |   2 +-
 include/linux/mm.h                            |   4 +-
 include/linux/relay.h                         |   2 +-
 include/linux/slab.h                          |   2 +-
 include/linux/spi/spi.h                       |   1 +
 include/linux/sysfs.h                         |   2 +-
 include/uapi/linux/ethtool_netlink.h          |   2 +-
 include/uapi/linux/firewire-cdev.h            |   2 +-
 include/uapi/linux/kvm.h                      |   4 +-
 include/uapi/rdma/rdma_user_ioctl_cmds.h      |   2 +-
 kernel/futex.c                                |   3 +
 kernel/relay.c                                |   2 +-
 lib/bitmap.c                                  |  27 +--
 lib/kobject.c                                 |   4 +-
 mm/gup.c                                      |  12 +-
 scripts/kernel-doc                            |  41 ++--
 tools/include/uapi/linux/kvm.h                |   4 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c              |   2 +-
 virt/kvm/arm/vgic/vgic.h                      |   4 +-
 106 files changed, 373 insertions(+), 338 deletions(-)
 rename Documentation/i2c/{i2c.svg => i2c_bus.svg} (99%)

-- 
2.25.2


