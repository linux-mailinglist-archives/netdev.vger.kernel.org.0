Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9FE80F34
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfHDWtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:49:21 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35553 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbfHDWtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:49:20 -0400
Received: by mail-pl1-f196.google.com with SMTP id w24so35682099plp.2;
        Sun, 04 Aug 2019 15:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YZWsn+x3jxp8fDI44kijDFRG/svqEg676iUchgN7QlQ=;
        b=B1sMPAcstI1puFk4w0cpCwyzsYpSCgnvkOWm4iaJnV8UBmRJR0FrVO7eeE2XgV7/DO
         DR3tgluGLB1/vbyPlZSBhbH+uo9CrzBJ1Q1rSPrUCEwEtdEEdHEsEYUhdaEO6ERTThp5
         mEExF0x3pWqACoKcpQ4jZSYPKI1ZJek74ypeshcY0SnsNOjJI1e96tP2zvVBSu1jKr+e
         Ym/g1QeiNeLfwG1YUwV1crKOGP7UibjO/7uqLpqDUr9tSTViDlNhIsYnzcFJ7cH459WG
         UptxQms1lJSvYFzHsJjq9KZpFUhZyY+WV1c+r9r6Bw6gMAdbrBCCcRHzjatxpXqpGNbN
         SemQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YZWsn+x3jxp8fDI44kijDFRG/svqEg676iUchgN7QlQ=;
        b=sVMyLVLXBMyeX3jOJsBDWOD72fcsPOmIEsGXzpOjHCz4rbcCj8X/TiZdaMEqhRO4k5
         m1Qf6uh+68xXTAG0Tu6jhwLYlho/zFoIIGq7rD+Dl5uMCahm0o0xm42dG/lIk/abakD7
         zUAcJwck4jcB/UIsOlrVKueNwpA9848eRR3iv7cgTHc0W5oivneHbOjK6MgdT2a6uJGR
         lvLwBwZuaWRB6aVmO4Xe0382IUZ9kcEXjNGlOY/nGYThneyBgMbdrKGo79aS+e5EZovl
         QoGUL5nyvpVYS8eeaj7iOuOV0EnxQDOyQ/NOJXDARjY6Gc/39Zx0NDyTuo2M1dFC3Ggh
         UUkA==
X-Gm-Message-State: APjAAAWeYdN6oUavHHmr/hc2IfYdfsKsxoCC7WPPpe7sbN/NxQQYjm0H
        dE37ovswcqE4Jyu9Egl9t2s=
X-Google-Smtp-Source: APXvYqxKaZcQUZ6UkPpcjP3XTdHmlP5C8HsDSLXmXJQis54EHd1b2U7WGwbPzUzQrFqhwr6YKPwdiw==
X-Received: by 2002:a17:902:a413:: with SMTP id p19mr142672660plq.134.1564958958984;
        Sun, 04 Aug 2019 15:49:18 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.49.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:49:18 -0700 (PDT)
From:   john.hubbard@gmail.com
X-Google-Original-From: jhubbard@nvidia.com
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org,
        devel@driverdev.osuosl.org, devel@lists.orangefs.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        sparclinux@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH v2 00/34] put_user_pages(): miscellaneous call sites
Date:   Sun,  4 Aug 2019 15:48:41 -0700
Message-Id: <20190804224915.28669-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

Changes since v1:

* 9 out of 34 patches have been reviewed or ack'd or changed:
    * Picked up Keith's Reviewed-by for patch 26 (gup_benchmark).
    * Picked up ACKs for patches 3, 10, 15, 16 (ceph, genwqe,
      staging/vc04_services, drivers/tee).

* Patch 6 (i915): adjusted drivers/gpu/drm/i915/gem/i915_gem_userptr.c to
  match the latest linux.git: the code has already been fixed in linux.git,
  as of the latest -rc, to do a set_page_dirty_lock(), instead of
  set_page_dirty(). So all that it needs now is a conversion to
  put_user_page(). I've done that in a way (avoiding the changed API call)
  that allows patch 6 to go up via either Andrew's -mm tree, or the drm
  tree, just in case. See that patch's comments for slightly more detail.

* Patch 20 (xen): applied Juergen's recommended fix, and speculatively
  (pending his approval) added his Signed-off-by (also noted in the patch
  comments).

* Improved patch 31 (NFS) as recommended by Calum Mackay.

* Includes the latest version of patch 1. (Patch 1 has been separately
  reposted [3], with those updates. And it's included here in order to
  make this series apply directly to linux.git, as noted in the original
  cover letter below.)

Cover letter from v1:

These are best characterized as miscellaneous conversions: many (not all)
call sites that don't involve biovec or iov_iter, nor mm/. It also leaves
out a few call sites that require some more work. These are mostly pretty
simple ones.

It's probably best to send all of these via Andrew's -mm tree, assuming
that there are no significant merge conflicts with ongoing work in other
trees (which I doubt, given that these are small changes).

These patches apply to the latest linux.git. Patch #1 is also already in
Andrew's tree, but given the broad non-linux-mm Cc list, I thought it
would be more convenient to just include that patch here, so that people
can use linux.git as the base--even though these are probably destined
for linux-mm.

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions"). That commit
has an extensive description of the problem and the planned steps to
solve it, but the highlites are:

1) Provide put_user_page*() routines, intended to be used
for releasing pages that were pinned via get_user_pages*().

2) Convert all of the call sites for get_user_pages*(), to
invoke put_user_page*(), instead of put_page(). This involves dozens of
call sites, and will take some time.

3) After (2) is complete, use get_user_pages*() and put_user_page*() to
implement tracking of these pages. This tracking will be separate from
the existing struct page refcounting.

4) Use the tracking and identification of these pages, to implement
special handling (especially in writeback paths) when the pages are
backed by a filesystem.

And a few references, also from that commit:

[1] https://lwn.net/Articles/774411/ : "DMA and get_user_pages()"
[2] https://lwn.net/Articles/753027/ : "The Trouble with get_user_pages()"

[3] "mm/gup: add make_dirty arg to put_user_pages_dirty_lock()"
    https://lore.kernel.org/r/20190804214042.4564-1-jhubbard@nvidia.com

Ira Weiny (1):
  fs/binfmt_elf: convert put_page() to put_user_page*()

John Hubbard (33):
  mm/gup: add make_dirty arg to put_user_pages_dirty_lock()
  net/rds: convert put_page() to put_user_page*()
  net/ceph: convert put_page() to put_user_page*()
  x86/kvm: convert put_page() to put_user_page*()
  drm/etnaviv: convert release_pages() to put_user_pages()
  drm/i915: convert put_page() to put_user_page*()
  drm/radeon: convert put_page() to put_user_page*()
  media/ivtv: convert put_page() to put_user_page*()
  media/v4l2-core/mm: convert put_page() to put_user_page*()
  genwqe: convert put_page() to put_user_page*()
  scif: convert put_page() to put_user_page*()
  vmci: convert put_page() to put_user_page*()
  rapidio: convert put_page() to put_user_page*()
  oradax: convert put_page() to put_user_page*()
  staging/vc04_services: convert put_page() to put_user_page*()
  drivers/tee: convert put_page() to put_user_page*()
  vfio: convert put_page() to put_user_page*()
  fbdev/pvr2fb: convert put_page() to put_user_page*()
  fsl_hypervisor: convert put_page() to put_user_page*()
  fs/exec.c: convert put_page() to put_user_page*()
  xen: convert put_page() to put_user_page*()
  orangefs: convert put_page() to put_user_page*()
  uprobes: convert put_page() to put_user_page*()
  futex: convert put_page() to put_user_page*()
  mm/frame_vector.c: convert put_page() to put_user_page*()
  mm/gup_benchmark.c: convert put_page() to put_user_page*()
  mm/memory.c: convert put_page() to put_user_page*()
  mm/madvise.c: convert put_page() to put_user_page*()
  mm/process_vm_access.c: convert put_page() to put_user_page*()
  crypt: convert put_page() to put_user_page*()
  fs/nfs: convert put_page() to put_user_page*()
  goldfish_pipe: convert put_page() to put_user_page*()
  kernel/events/core.c: convert put_page() to put_user_page*()

 arch/x86/kvm/svm.c                            |   4 +-
 crypto/af_alg.c                               |   7 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c         |   4 +-
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c   |   6 +-
 drivers/gpu/drm/radeon/radeon_ttm.c           |   2 +-
 drivers/infiniband/core/umem.c                |   5 +-
 drivers/infiniband/hw/hfi1/user_pages.c       |   5 +-
 drivers/infiniband/hw/qib/qib_user_pages.c    |  13 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c      |   5 +-
 drivers/infiniband/sw/siw/siw_mem.c           |  19 +--
 drivers/media/pci/ivtv/ivtv-udma.c            |  14 +--
 drivers/media/pci/ivtv/ivtv-yuv.c             |  11 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c     |   3 +-
 drivers/misc/genwqe/card_utils.c              |  17 +--
 drivers/misc/mic/scif/scif_rma.c              |  17 ++-
 drivers/misc/vmw_vmci/vmci_context.c          |   2 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c       |  11 +-
 drivers/platform/goldfish/goldfish_pipe.c     |   9 +-
 drivers/rapidio/devices/rio_mport_cdev.c      |   9 +-
 drivers/sbus/char/oradax.c                    |   2 +-
 .../interface/vchiq_arm/vchiq_2835_arm.c      |  10 +-
 drivers/tee/tee_shm.c                         |  10 +-
 drivers/vfio/vfio_iommu_type1.c               |   8 +-
 drivers/video/fbdev/pvr2fb.c                  |   3 +-
 drivers/virt/fsl_hypervisor.c                 |   7 +-
 drivers/xen/privcmd.c                         |  32 ++---
 fs/binfmt_elf.c                               |   2 +-
 fs/binfmt_elf_fdpic.c                         |   2 +-
 fs/exec.c                                     |   2 +-
 fs/nfs/direct.c                               |  11 +-
 fs/orangefs/orangefs-bufmap.c                 |   7 +-
 include/linux/mm.h                            |   5 +-
 kernel/events/core.c                          |   2 +-
 kernel/events/uprobes.c                       |   6 +-
 kernel/futex.c                                |  10 +-
 mm/frame_vector.c                             |   4 +-
 mm/gup.c                                      | 115 ++++++++----------
 mm/gup_benchmark.c                            |   2 +-
 mm/madvise.c                                  |   2 +-
 mm/memory.c                                   |   2 +-
 mm/process_vm_access.c                        |  18 +--
 net/ceph/pagevec.c                            |   8 +-
 net/rds/info.c                                |   5 +-
 net/rds/message.c                             |   2 +-
 net/rds/rdma.c                                |  15 ++-
 virt/kvm/kvm_main.c                           |   4 +-
 46 files changed, 164 insertions(+), 295 deletions(-)

-- 
2.22.0

