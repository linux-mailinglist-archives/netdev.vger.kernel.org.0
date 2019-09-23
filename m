Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77640BB609
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 15:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437505AbfIWN7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 09:59:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404910AbfIWN7x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 09:59:53 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 142CFC053B26
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 13:59:52 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id z128so17703303qke.8
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 06:59:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FtApu15nyFEPJdV270MkGcXi5No4IIGcISN59p+vUsI=;
        b=C1n1/VzA11jjRsw2h3o5os2Am885t3+jcMAJNBVO1AODVpufuy4yJlZQa8Sv7Ta+2c
         9s/V82IRzMjt5q7W7RXXalm/AaZ/LoZzweRuvjZglObDdXDgHk6/oPE/2mNJfnmxfTXU
         HSfXVW+KZDdNZl0q8rp4Xn3i+okUuvv7dt0ZB66MK6Qgbr8Y75EOXq3X4rpE1stZ2joZ
         zBT/PTE+AYMMOauW6Dca1j1TTBSwLiGjHIilTl+LSlwU+hYfFEruhT+5JbfQNnQmp1GR
         4hMNXkxmFb6aTysKuc83Pirgv3E6/E6frLwbUx1jI3VjqkE4JRG7dP9l4sM6zHMm5prB
         uSTQ==
X-Gm-Message-State: APjAAAWbikd7s100jfBlrWb3tVwqP6WLB6N98UpADRfWOsPmTGpAosHN
        mEklvCjgqX7lGOMA8NeCDelimS/ao7AJtLfBG4JyZYiY9+TzZN2PUUjVikImoswGI5qzcGprB/9
        u7IdRdLRNaDOPNqzR
X-Received: by 2002:a37:a8ce:: with SMTP id r197mr17291087qke.374.1569247191423;
        Mon, 23 Sep 2019 06:59:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyzyB1a60cl+6jXMDuajGY7ZKBy6qBhwd1rCHqj2guL5sYzzKUt4czPqrsZBqxQFgz2+CkCug==
X-Received: by 2002:a37:a8ce:: with SMTP id r197mr17291071qke.374.1569247191247;
        Mon, 23 Sep 2019 06:59:51 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id j2sm4848892qki.15.2019.09.23.06.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 06:59:50 -0700 (PDT)
Date:   Mon, 23 Sep 2019 09:59:38 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com
Subject: Re: [PATCH 0/6] mdev based hardware virtio offloading support
Message-ID: <20190923095820-mutt-send-email-mst@kernel.org>
References: <20190923130331.29324-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923130331.29324-1-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 09:03:25PM +0800, Jason Wang wrote:
> Hi all:
> 
> There are hardware that can do virtio datapath offloading while having
> its own control path. This path tries to implement a mdev based
> unified API to support using kernel virtio driver to drive those
> devices. This is done by introducing a new mdev transport for virtio
> (virtio_mdev) and register itself as a new kind of mdev driver. Then
> it provides a unified way for kernel virtio driver to talk with mdev
> device implementation.
> 
> Though the series only contains kernel driver support, the goal is to
> make the transport generic enough to support userspace drivers. This
> means vhost-mdev[1] could be built on top as well by resuing the
> transport.
> 
> A sample driver is also implemented which simulate a virito-net
> loopback ethernet device on top of vringh + workqueue. This could be
> used as a reference implementation for real hardware driver.
> 
> Consider mdev framework only support VFIO device and driver right now,
> this series also extend it to support other types. This is done
> through introducing class id to the device and pairing it with
> id_talbe claimed by the driver. On top, this seris also decouple
> device specific parents ops out of the common ones.
> 
> Pktgen test was done with virito-net + mvnet loop back device.
> 
> Please review.
> 
> [1] https://lkml.org/lkml/2019/9/16/869
> 
> Changes from RFC-V2:
> - silent compile warnings on some specific configuration
> - use u16 instead u8 for class id
> - reseve MDEV_ID_VHOST for future vhost-mdev work
> - introduce "virtio" type for mvnet and make "vhost" type for future
>   work
> - add entries in MAINTAINER
> - tweak and typos fixes in commit log
> 
> Changes from RFC-V1:
> 
> - rename device id to class id
> - add docs for class id and device specific ops (device_ops)
> - split device_ops into seperate headers
> - drop the mdev_set_dma_ops()
> - use device_ops to implement the transport API, then it's not a part
>   of UAPI any more
> - use GFP_ATOMIC in mvnet sample device and other tweaks
> - set_vring_base/get_vring_base support for mvnet device
> 
> Jason Wang (6):
>   mdev: class id support
>   mdev: introduce device specific ops
>   mdev: introduce virtio device and its device ops
>   virtio: introduce a mdev based transport
>   vringh: fix copy direction of vringh_iov_push_kern()
>   docs: sample driver to demonstrate how to implement virtio-mdev
>     framework


That's pretty clean, so how about we start by just merging this?
Alex are you going to handle this through your next tree?
If yes, pls include:

Acked-by: Michael S. Tsirkin <mst@redhat.com>



>  .../driver-api/vfio-mediated-device.rst       |  11 +-
>  MAINTAINERS                                   |   3 +
>  drivers/gpu/drm/i915/gvt/kvmgt.c              |  17 +-
>  drivers/s390/cio/vfio_ccw_ops.c               |  17 +-
>  drivers/s390/crypto/vfio_ap_ops.c             |  14 +-
>  drivers/vfio/mdev/Kconfig                     |   7 +
>  drivers/vfio/mdev/Makefile                    |   1 +
>  drivers/vfio/mdev/mdev_core.c                 |  21 +-
>  drivers/vfio/mdev/mdev_driver.c               |  14 +
>  drivers/vfio/mdev/mdev_private.h              |   1 +
>  drivers/vfio/mdev/vfio_mdev.c                 |  37 +-
>  drivers/vfio/mdev/virtio_mdev.c               | 416 +++++++++++
>  drivers/vhost/vringh.c                        |   8 +-
>  include/linux/mdev.h                          |  47 +-
>  include/linux/mod_devicetable.h               |   8 +
>  include/linux/vfio_mdev.h                     |  53 ++
>  include/linux/virtio_mdev.h                   | 144 ++++
>  samples/Kconfig                               |   7 +
>  samples/vfio-mdev/Makefile                    |   1 +
>  samples/vfio-mdev/mbochs.c                    |  19 +-
>  samples/vfio-mdev/mdpy.c                      |  19 +-
>  samples/vfio-mdev/mtty.c                      |  17 +-
>  samples/vfio-mdev/mvnet.c                     | 688 ++++++++++++++++++
>  23 files changed, 1481 insertions(+), 89 deletions(-)
>  create mode 100644 drivers/vfio/mdev/virtio_mdev.c
>  create mode 100644 include/linux/vfio_mdev.h
>  create mode 100644 include/linux/virtio_mdev.h
>  create mode 100644 samples/vfio-mdev/mvnet.c
> 
> -- 
> 2.19.1
