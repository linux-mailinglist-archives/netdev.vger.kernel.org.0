Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF5D471E75
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 00:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhLLXAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 18:00:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36606 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230088AbhLLXAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 18:00:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639350000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=WYVQFnDIbcgI5d/vqJyK9JfPBSSPc6zKfbYcO57Li1U=;
        b=WmuhVWsO5mi80RT4m+no3isY1iJou4o3YpWQaknax9Wih1bUHUku36xax5VFio+o60zIc7
        1OGTA7llpIy1V9V4ymdA9oRteRF9FpbmNZ5nA42fn0bQH0A++73QEiJu0FpkduZ58GoFj1
        7cL4stQ+xqGrzmI1cpzkRO3SI4HcvFI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452-NMhOgw1SN3uMJF9600GOWA-1; Sun, 12 Dec 2021 17:59:59 -0500
X-MC-Unique: NMhOgw1SN3uMJF9600GOWA-1
Received: by mail-wm1-f69.google.com with SMTP id ay17-20020a05600c1e1100b0033f27b76819so8773391wmb.4
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 14:59:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=WYVQFnDIbcgI5d/vqJyK9JfPBSSPc6zKfbYcO57Li1U=;
        b=4WfgUfP00cE/65/sRCC3X4Hr1zxI1bammc4QFIQjHSHC9Jr6P7XFimi2nsg/TzPTMG
         5ziJg+XjaPVpM2YrSJh4DRxd0CL++jQeoaGTZ5dJYwsDOQ0u7vAsUITSOZ6WXpCVT+UG
         4T90kfsvNUD9paJdMAIdND2WbHtbvpT/U/7BQ6ns9nT9YO3Z9FAgA+iAZJzLhWREmV9t
         6c2CHT2Zvw/JzFptkjtSFBSNWGxvci8JhgFTKveX3RSTNQhItwshUapdy0bIHrM9tk8T
         CI6DBi3M9w2JJQrFlqyjWzVzbuZMvze1djI22zYJn1Al0T8fnDAgHIber0vUvBZyqIZp
         C7zA==
X-Gm-Message-State: AOAM532Cr5iyhjwmP49aye+IeOIjR+JESA7ZumTFcVVXMPxVPbs66qYu
        yIsMNudtIdPvRix94aXCe/OtLmFPVZkQ+GiWtmze3rYGFquM5fKZF08gGWPjHCC07YN5RGvelke
        OldaxZ5QOQF9aah3p
X-Received: by 2002:a05:600c:1987:: with SMTP id t7mr32456850wmq.24.1639349998391;
        Sun, 12 Dec 2021 14:59:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx2bTppYN2huiK2nylUvg6FCr00HLDzfg04TlPUjrDVfn+bIvC2GBhAeUTenJbfKS0A/G9aQQ==
X-Received: by 2002:a05:600c:1987:: with SMTP id t7mr32456804wmq.24.1639349998099;
        Sun, 12 Dec 2021 14:59:58 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:107e:eefb:294:6ac8:eff6:22df])
        by smtp.gmail.com with ESMTPSA id bd18sm5203284wmb.43.2021.12.12.14.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 14:59:57 -0800 (PST)
Date:   Sun, 12 Dec 2021 17:59:51 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, dan.carpenter@oracle.com, hch@lst.de,
        jasowang@redhat.com, jroedel@suse.de, konrad.wilk@oracle.com,
        lkp@intel.com, maz@kernel.org, mst@redhat.com, parav@nvidia.com,
        qperret@google.com, robin.murphy@arm.com, stable@vger.kernel.org,
        steven.price@arm.com, suzuki.poulose@arm.com, wei.w.wang@intel.com,
        will@kernel.org, xieyongji@bytedance.com
Subject: [GIT PULL] vhost: cleanups and fixes
Message-ID: <20211212175951-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 0fcfb00b28c0b7884635dacf38e46d60bf3d4eb1:

  Linux 5.16-rc4 (2021-12-05 14:08:22 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to bb47620be322c5e9e372536cb6b54e17b3a00258:

  vdpa: Consider device id larger than 31 (2021-12-08 15:41:50 -0500)

----------------------------------------------------------------
virtio,vdpa: bugfixes

Misc bugfixes.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Arnd Bergmann (1):
      virtio: always enter drivers/virtio/

Dan Carpenter (3):
      vduse: fix memory corruption in vduse_dev_ioctl()
      vdpa: check that offsets are within bounds
      vduse: check that offset is within bounds in get_config()

Parav Pandit (1):
      vdpa: Consider device id larger than 31

Wei Wang (1):
      virtio/vsock: fix the transport to work with VMADDR_CID_ANY

Will Deacon (1):
      virtio_ring: Fix querying of maximum DMA mapping size for virtio device

 drivers/Makefile                        | 3 +--
 drivers/vdpa/vdpa.c                     | 3 ++-
 drivers/vdpa/vdpa_user/vduse_dev.c      | 6 ++++--
 drivers/vhost/vdpa.c                    | 2 +-
 drivers/virtio/virtio_ring.c            | 2 +-
 net/vmw_vsock/virtio_transport_common.c | 3 ++-
 6 files changed, 11 insertions(+), 8 deletions(-)

