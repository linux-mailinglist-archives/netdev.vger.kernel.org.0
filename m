Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8C51A0A7C
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 11:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgDGJxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 05:53:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24572 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726399AbgDGJxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 05:53:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586253220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=oLjV0dR06CVtDijV8G+MbnTLMMQSd3QfbOWe/4e1HKY=;
        b=i1PKqifD4QGR8wH/WYuRMB7V80Tkg7h1YcxXwGZLZI/xiVxN8wyqgxJSePsYD+513q70Bt
        d7+S63CqIlA9jH+Qdwq3d0v0wbpOVkD9bNRz9RtunQDrQVS+CP266XK7OziE658E+VXjZf
        DrmAv58awp7YBhM0fASCHKfjfs1xCWM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-0MpTZ8R5Msuayl5-xz4RZg-1; Tue, 07 Apr 2020 05:53:38 -0400
X-MC-Unique: 0MpTZ8R5Msuayl5-xz4RZg-1
Received: by mail-wr1-f72.google.com with SMTP id y6so1467053wrq.21
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 02:53:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=oLjV0dR06CVtDijV8G+MbnTLMMQSd3QfbOWe/4e1HKY=;
        b=GPhvgiJJVipdAjTY1js5NIM9h51If+kY9vTW7ychDE7cdkO+giM4RezEr7Ldh9xw2e
         uhbxDd3z/M+eqKOu5GAAxGjwmpMSaN5QxgVwjlymr5cLTZSz4iJu4J7qCry77oMeI8OR
         sSbNnudNOBVKNf1vkxUiAYjodXNyUhhWjIsTTEvF/cTB5zlbm1AEyX0B5uVm1rVt8oAV
         /Tzm3oNzSG4K/4NxkCqksS00eGEMgscDdQXIHOW9gUu1sAOTdsrx3PrNiwj2Z1JzfiNh
         jW2COkhRMaBWjlMBYScq3FIolg332UwMhfEvWpQfh7SHsYt1LXvk49djbkwFhbwzCrig
         pDZg==
X-Gm-Message-State: AGi0PuYvWw2Szvoe1bE9kebMlMqPXt4jU7sWzUAIjsZWqatUvyoqskoO
        ZAz5G25YSFEEAQcvJD/dzvp4oJQ6ML6DZhY49WIa05TLDkss5SkVPsNMqeAIQGoBMAtHoHhGTr/
        ZDhf3SODCTbSiSakW
X-Received: by 2002:a1c:f205:: with SMTP id s5mr1517470wmc.101.1586253217555;
        Tue, 07 Apr 2020 02:53:37 -0700 (PDT)
X-Google-Smtp-Source: APiQypK618C35lkaLXiYs/X9jCrBU5V7/q45Do9tU/BXiD39k7buPrgl8FVD4cfYPT2PEopWOaQJtQ==
X-Received: by 2002:a1c:f205:: with SMTP id s5mr1517441wmc.101.1586253217223;
        Tue, 07 Apr 2020 02:53:37 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id v7sm30308497wrs.96.2020.04.07.02.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 02:53:36 -0700 (PDT)
Date:   Tue, 7 Apr 2020 05:53:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexander.h.duyck@linux.intel.com, david@redhat.com,
        eperezma@redhat.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        mhocko@kernel.org, mst@redhat.com, namit@vmware.com,
        rdunlap@infradead.org, rientjes@google.com, tiwei.bie@intel.com,
        tysand@google.com, wei.w.wang@intel.com, xiao.w.wang@intel.com,
        yuri.benditovich@daynix.com
Subject: [GIT PULL v2] vhost: cleanups and fixes
Message-ID: <20200407055334-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from PULL v1:
	reverted a commit that was also in Andrew Morton's tree,
	to resolve a merge conflict:
	this is what Stephen Rothwell was doing to resolve it
	in linux-next.


Now that many more architectures build vhost, a couple of these (um, and
arm with deprecated oabi) have reported build failures with randconfig,
however fixes for that need a bit more discussion/testing and will be
merged separately.

Not a regression - these previously simply didn't have vhost at all.
Also, there's some DMA API code in the vdpa simulator is hacky - if no
solution surfaces soon we can always disable it before release:
it's not a big deal either way as it's just test code.


The following changes since commit 16fbf79b0f83bc752cee8589279f1ebfe57b3b6e:

  Linux 5.6-rc7 (2020-03-22 18:31:56 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 835a6a649d0dd1b1f46759eb60fff2f63ed253a7:

  virtio-balloon: Revert "virtio-balloon: Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM" (2020-04-07 05:44:57 -0400)

----------------------------------------------------------------
virtio: fixes, vdpa

Some bug fixes.
The new vdpa subsystem with two first drivers.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
David Hildenbrand (1):
      virtio-balloon: Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM

Jason Wang (7):
      vhost: refine vhost and vringh kconfig
      vhost: allow per device message handler
      vhost: factor out IOTLB
      vringh: IOTLB support
      vDPA: introduce vDPA bus
      virtio: introduce a vDPA based transport
      vdpasim: vDPA device simulator

Michael S. Tsirkin (3):
      tools/virtio: option to build an out of tree module
      vdpa: move to drivers/vdpa
      virtio-balloon: Revert "virtio-balloon: Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM"

Tiwei Bie (1):
      vhost: introduce vDPA-based backend

Yuri Benditovich (3):
      virtio-net: Introduce extended RSC feature
      virtio-net: Introduce RSS receive steering feature
      virtio-net: Introduce hash report feature

Zhu Lingshan (1):
      virtio: Intel IFC VF driver for VDPA

 MAINTAINERS                      |   3 +
 arch/arm/kvm/Kconfig             |   2 -
 arch/arm64/kvm/Kconfig           |   2 -
 arch/mips/kvm/Kconfig            |   2 -
 arch/powerpc/kvm/Kconfig         |   2 -
 arch/s390/kvm/Kconfig            |   4 -
 arch/x86/kvm/Kconfig             |   4 -
 drivers/Kconfig                  |   4 +
 drivers/Makefile                 |   1 +
 drivers/misc/mic/Kconfig         |   4 -
 drivers/net/caif/Kconfig         |   4 -
 drivers/vdpa/Kconfig             |  37 ++
 drivers/vdpa/Makefile            |   4 +
 drivers/vdpa/ifcvf/Makefile      |   3 +
 drivers/vdpa/ifcvf/ifcvf_base.c  | 389 +++++++++++++++++
 drivers/vdpa/ifcvf/ifcvf_base.h  | 118 ++++++
 drivers/vdpa/ifcvf/ifcvf_main.c  | 435 +++++++++++++++++++
 drivers/vdpa/vdpa.c              | 180 ++++++++
 drivers/vdpa/vdpa_sim/Makefile   |   2 +
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 629 ++++++++++++++++++++++++++++
 drivers/vhost/Kconfig            |  45 +-
 drivers/vhost/Kconfig.vringh     |   6 -
 drivers/vhost/Makefile           |   6 +
 drivers/vhost/iotlb.c            | 177 ++++++++
 drivers/vhost/net.c              |   5 +-
 drivers/vhost/scsi.c             |   2 +-
 drivers/vhost/vdpa.c             | 883 +++++++++++++++++++++++++++++++++++++++
 drivers/vhost/vhost.c            | 233 ++++-------
 drivers/vhost/vhost.h            |  45 +-
 drivers/vhost/vringh.c           | 421 ++++++++++++++++++-
 drivers/vhost/vsock.c            |   2 +-
 drivers/virtio/Kconfig           |  13 +
 drivers/virtio/Makefile          |   1 +
 drivers/virtio/virtio_vdpa.c     | 396 ++++++++++++++++++
 include/linux/vdpa.h             | 253 +++++++++++
 include/linux/vhost_iotlb.h      |  47 +++
 include/linux/vringh.h           |  36 ++
 include/uapi/linux/vhost.h       |  24 ++
 include/uapi/linux/vhost_types.h |   8 +
 include/uapi/linux/virtio_net.h  | 102 ++++-
 tools/virtio/Makefile            |  27 +-
 41 files changed, 4310 insertions(+), 251 deletions(-)
 create mode 100644 drivers/vdpa/Kconfig
 create mode 100644 drivers/vdpa/Makefile
 create mode 100644 drivers/vdpa/ifcvf/Makefile
 create mode 100644 drivers/vdpa/ifcvf/ifcvf_base.c
 create mode 100644 drivers/vdpa/ifcvf/ifcvf_base.h
 create mode 100644 drivers/vdpa/ifcvf/ifcvf_main.c
 create mode 100644 drivers/vdpa/vdpa.c
 create mode 100644 drivers/vdpa/vdpa_sim/Makefile
 create mode 100644 drivers/vdpa/vdpa_sim/vdpa_sim.c
 delete mode 100644 drivers/vhost/Kconfig.vringh
 create mode 100644 drivers/vhost/iotlb.c
 create mode 100644 drivers/vhost/vdpa.c
 create mode 100644 drivers/virtio/virtio_vdpa.c
 create mode 100644 include/linux/vdpa.h
 create mode 100644 include/linux/vhost_iotlb.h

