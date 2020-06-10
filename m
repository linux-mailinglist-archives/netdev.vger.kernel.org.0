Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA221F4C80
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 06:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgFJEp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 00:45:26 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43653 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726090AbgFJEpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 00:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591764313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=VxmhQ3VVJqCwy8aaYD5pSLwJjZ0VIqyd7EjfATRpmNc=;
        b=NG6tSwBkc81oFBWN+wllwaRWgcFg2SyhzLht96520428SbsMntcJimy0TcM3D8hBcfn7F5
        cz1kK1RT+WAAYobpsQouRZiXNC83FKW6em2Ff2UDcOWcVaxnyuO9Znc8HDLCNPJ2Gkk5bm
        180Y6JKS7WwBD6TDaiwtjW6elgnwPRQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-CU48r9ZZMUW5diM0kc7KFg-1; Wed, 10 Jun 2020 00:45:06 -0400
X-MC-Unique: CU48r9ZZMUW5diM0kc7KFg-1
Received: by mail-wr1-f72.google.com with SMTP id i6so512507wrr.23
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 21:45:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=VxmhQ3VVJqCwy8aaYD5pSLwJjZ0VIqyd7EjfATRpmNc=;
        b=NUWN22Ixrg5RW/jmQ4b/SKBOZalxc+5XCT0V68ouT6kHweZiVUGhU6CgVn/hNrV8Oz
         2t5WZ98Z6IMDWc2a9EsTq2+LRDwNxxZuxo13wa1N648whZBvyll1AUct/2Sbju5xf+80
         qQD4iTAUzuUhtIXInj/XQ3XGLZ+q5EmZ+uAzj+fKOf8ihIcMfO93aCEG9Y5TIimi9ghX
         1Y+0Tf5h6hr9vgWmgTza6k8YunSFHlbhnivLkjcOFajRqB7dhZL6ayUXk6u+K9nBesxB
         koTgHJpcrLUxW5p5bFeRmgmla8KSkH3asfevYqd6PdI8Wl0MuOvhuzfgPdC8jdn5mXpP
         CgQw==
X-Gm-Message-State: AOAM533iwOz+peNo8rzy6GrmlCaMcoo3ww8igs1O7d8dghAEBwkWyxCF
        C2+smkCh0zvD+4YCJn93OfH8rtobW4x7HhkY1UiSXzNchE40sy5ZSipW3mRTNEf0haLEp1yA4hI
        0Mc6mENVm87Gjd1RR
X-Received: by 2002:a5d:5001:: with SMTP id e1mr1496124wrt.56.1591764305579;
        Tue, 09 Jun 2020 21:45:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywRytP6FIoM+W4oWypswZZXFPjrrjECTCkbmv+pP0bloGWVKqtSdiGopJ/ccnY8HzNdJNBwg==
X-Received: by 2002:a5d:5001:: with SMTP id e1mr1496086wrt.56.1591764305280;
        Tue, 09 Jun 2020 21:45:05 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id q128sm5199346wma.38.2020.06.09.21.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 21:45:04 -0700 (PDT)
Date:   Wed, 10 Jun 2020 00:44:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        anshuman.khandual@arm.com, anthony.yznaga@oracle.com,
        arei.gonglei@huawei.com, cai@lca.pw, clabbe@baylibre.com,
        dan.j.williams@intel.com, davem@davemloft.net, david@redhat.com,
        dyoung@redhat.com, elfring@users.sourceforge.net,
        glider@google.com, gregkh@linuxfoundation.org,
        guennadi.liakhovetski@linux.intel.com, hannes@cmpxchg.org,
        herbert@gondor.apana.org.au, hulkci@huawei.com,
        imammedo@redhat.com, jasowang@redhat.com, jgross@suse.com,
        kernelfans@gmail.com, konrad.wilk@oracle.com, lenb@kernel.org,
        lingshan.zhu@intel.com, linux-acpi@vger.kernel.org, lkp@intel.com,
        longpeng2@huawei.com, matej.genci@nutanix.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com,
        mst@redhat.com, osalvador@suse.com, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, pasha.tatashin@soleen.com,
        pavel.tatashin@microsoft.com, rafael@kernel.org,
        richard.weiyang@gmail.com, rjw@rjwysocki.net, rppt@linux.ibm.com,
        stable@vger.kernel.org, stefanha@redhat.com,
        teawaterz@linux.alibaba.com, vbabka@suse.cz, zou_wei@huawei.com
Subject: [GIT PULL] virtio: features, fixes
Message-ID: <20200610004455-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a single commit here that I tweaked since linux-next - the
change is in printk format string which I consider trivial enough not
force wait for more testing. A couple of hashes are different from
what's in linux-next though.  I also upgraded the machine I used to sign
the tag (didn't change the key) - hope the signature is still ok. If not
pls let me know!

The following changes since commit 3d77e6a8804abcc0504c904bd6e5cdf3a5cf8162:

  Linux 5.7 (2020-05-31 16:49:15 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 044e4b09223039e571e6ec540e25552054208765:

  vhost/test: fix up after API change (2020-06-09 06:42:06 -0400)

----------------------------------------------------------------
virtio: features, fixes

virtio-mem
doorbell mapping for vdpa
config interrupt support in ifc
fixes all over the place

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Alexander Duyck (1):
      virtio-balloon: Disable free page reporting if page poison reporting is not enabled

David Hildenbrand (17):
      MAINTAINERS: Add myself as virtio-balloon co-maintainer
      virtio-mem: Paravirtualized memory hotplug
      MAINTAINERS: Add myself as virtio-mem maintainer
      virtio-mem: Allow to specify an ACPI PXM as nid
      virtio-mem: Paravirtualized memory hotunplug part 1
      virtio-mem: Paravirtualized memory hotunplug part 2
      mm: Allow to offline unmovable PageOffline() pages via MEM_GOING_OFFLINE
      virtio-mem: Allow to offline partially unplugged memory blocks
      mm/memory_hotplug: Introduce offline_and_remove_memory()
      virtio-mem: Offline and remove completely unplugged memory blocks
      virtio-mem: Better retry handling
      virtio-mem: Add parent resource for all added "System RAM"
      virtio-mem: Drop manual check for already present memory
      virtio-mem: Unplug subblocks right-to-left
      virtio-mem: Use -ETXTBSY as error code if the device is busy
      virtio-mem: Try to unplug the complete online memory block first
      virtio-mem: Don't rely on implicit compiler padding for requests

Guennadi Liakhovetski (1):
      vhost: (cosmetic) remove a superfluous variable initialisation

Jason Wang (4):
      vhost: allow device that does not depend on vhost worker
      vhost: use mmgrab() instead of mmget() for non worker device
      vdpa: introduce get_vq_notification method
      vhost_vdpa: support doorbell mapping via mmap

Longpeng(Mike) (3):
      crypto: virtio: Fix src/dst scatterlist calculation in __virtio_crypto_skcipher_do_req()
      crypto: virtio: Fix use-after-free in virtio_crypto_skcipher_finalize_req()
      crypto: virtio: Fix dest length calculation in __virtio_crypto_skcipher_do_req()

Markus Elfring (1):
      virtio-mmio: Delete an error message in vm_find_vqs()

Matej Genci (1):
      virtio: add VIRTIO_RING_NO_LEGACY

Michael S. Tsirkin (6):
      virtio: force spec specified alignment on types
      vhost: revert "vhost: disable for OABI"
      vhost_vdpa: disable doorbell mapping for !MMU
      virtio-mem: drop unnecessary initialization
      virtio_mem: convert device block size into 64bit
      vhost/test: fix up after API change

Samuel Zou (1):
      vdpasim: Fix some coccinelle warnings

Zhu Lingshan (5):
      ifcvf: move IRQ request/free to status change handlers
      ifcvf: ignore continuous setting same status value
      vhost_vdpa: Support config interrupt in vdpa
      vhost: replace -1 with VHOST_FILE_UNBIND in ioctls
      ifcvf: implement config interrupt in IFCVF

 MAINTAINERS                                |   18 +-
 drivers/acpi/numa/srat.c                   |    1 +
 drivers/crypto/virtio/virtio_crypto_algs.c |   21 +-
 drivers/misc/mic/Kconfig                   |    2 +-
 drivers/net/caif/Kconfig                   |    2 +-
 drivers/vdpa/Kconfig                       |    2 +-
 drivers/vdpa/ifcvf/ifcvf_base.c            |    3 +
 drivers/vdpa/ifcvf/ifcvf_base.h            |    4 +
 drivers/vdpa/ifcvf/ifcvf_main.c            |  146 ++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c           |    7 +-
 drivers/vhost/Kconfig                      |   17 +-
 drivers/vhost/net.c                        |    2 +-
 drivers/vhost/scsi.c                       |    2 +-
 drivers/vhost/test.c                       |    2 +-
 drivers/vhost/vdpa.c                       |  112 +-
 drivers/vhost/vhost.c                      |  100 +-
 drivers/vhost/vhost.h                      |    8 +-
 drivers/vhost/vringh.c                     |    6 +-
 drivers/vhost/vsock.c                      |    2 +-
 drivers/virtio/Kconfig                     |   17 +
 drivers/virtio/Makefile                    |    1 +
 drivers/virtio/virtio_balloon.c            |    9 +-
 drivers/virtio/virtio_mem.c                | 1965 ++++++++++++++++++++++++++++
 drivers/virtio/virtio_mmio.c               |    4 +-
 drivers/virtio/virtio_pci_modern.c         |    1 +
 include/linux/memory_hotplug.h             |    1 +
 include/linux/page-flags.h                 |   10 +
 include/linux/vdpa.h                       |   16 +
 include/linux/vringh.h                     |    6 +-
 include/uapi/linux/vhost.h                 |    4 +
 include/uapi/linux/virtio_ids.h            |    1 +
 include/uapi/linux/virtio_mem.h            |  211 +++
 include/uapi/linux/virtio_ring.h           |   48 +-
 mm/memory_hotplug.c                        |   81 +-
 mm/page_alloc.c                            |   26 +
 mm/page_isolation.c                        |    9 +
 36 files changed, 2723 insertions(+), 144 deletions(-)
 create mode 100644 drivers/virtio/virtio_mem.c
 create mode 100644 include/uapi/linux/virtio_mem.h

