Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C83B35BBF5
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 10:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236973AbhDLITZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 04:19:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54492 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237091AbhDLITY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 04:19:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618215546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xJgn3g7ogKt5V6b/6xvZZCO2WGaaJCBspvi1WlJo2ZE=;
        b=BmqIkCzEGFtaHoL42wQWb9VnwL6oXSo7DLTQoEcECLMqWdLyZ6NY0l0Iaue6dmMm2duDjr
        AVLdHJKq8I/O2M6ZRzha5ZHs8/tSspk5yCdkp1DU9wtbkbbVvpwuYgUMpCoumY7PgUSM63
        Vyv7WGgVh3Hs/vXfQbNLaLqIxt/L/ow=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-QJKVA3aONcSqrhpNrmuY_g-1; Mon, 12 Apr 2021 04:19:03 -0400
X-MC-Unique: QJKVA3aONcSqrhpNrmuY_g-1
Received: by mail-ej1-f70.google.com with SMTP id qx17so671708ejb.5
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 01:19:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xJgn3g7ogKt5V6b/6xvZZCO2WGaaJCBspvi1WlJo2ZE=;
        b=GJe+JEgUi+xHs8TgLGyf402o06oCrVbTsB1FNLk9vUAtkBqhUEkLr4ZSU2TOV1d+Ba
         nJZvpH4OCoR2+b2wjKl+I/dvyzY6yLhfHySOcNDtLf/Q9yuMaa3EaQlJ0rgLJ9s3agzO
         lc0ImKuQiOLWJ/D4XSUviQ1oG+I+PMdCwZrHNFCw2vAykzE3QwqpoDHex8LyGlhtTTZv
         gQn1IhErBo3Ids/D3dpYFYqm7nRtdNTyOKNaOXowhDyG9JwHexvJOaDCQkbrXwZnuxaP
         KHQSqxUQwPabDWSIhbyhw9MUzxngZAj0uxqAG+pzJCeIHr8sITCrXDFh1FTzDmK5GM7c
         KyPg==
X-Gm-Message-State: AOAM530vsgYJ+LgIgQybkPXSDeMyeGKg+nwkXkPtzCyfWsggXcZfBmgU
        zduq4tmO7YNpGE9xjxIrxfV/Myi2fTznh6h8IGmH9W0uapU3c3avY0dxzgbbyU8vpq095BUDxJK
        XCr1/n6cvBDIRRvsN
X-Received: by 2002:a17:906:2808:: with SMTP id r8mr17703895ejc.140.1618215542209;
        Mon, 12 Apr 2021 01:19:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBU/GPnTLafg+51MT/N1zJPs8q0egQivnnyULLF6QWNsMSlyND5OuEZ/l/Y8KbZi9Vck2WWQ==
X-Received: by 2002:a17:906:2808:: with SMTP id r8mr17703884ejc.140.1618215541979;
        Mon, 12 Apr 2021 01:19:01 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id a12sm5932454edx.91.2021.04.12.01.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 01:19:01 -0700 (PDT)
Date:   Mon, 12 Apr 2021 10:18:58 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Laurent Vivier <lvivier@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH v4 00/14] vdpa: add vdpa simulator for block device
Message-ID: <20210412081858.wpoitvzyj474yp7s@steredhat>
References: <20210315163450.254396-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210315163450.254396-1-sgarzare@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,
do you think this series is in an acceptable state to be queued for the 
next merge window?

All patches should be already acked by Jason, let me know if I need to 
change anything.

Thanks,
Stefano

On Mon, Mar 15, 2021 at 05:34:36PM +0100, Stefano Garzarella wrote:
>v4:
>- added support for iproute2 vdpa management tool in vdpa_sim_blk
>- removed get/set_config patches
>  - 'vdpa: add return value to get_config/set_config callbacks'
>  - 'vhost/vdpa: remove vhost_vdpa_config_validate()'
>- added get_config_size() patches
>  - 'vdpa: add get_config_size callback in vdpa_config_ops'
>  - 'vhost/vdpa: use get_config_size callback in vhost_vdpa_config_validate()'
>
>v3: https://lore.kernel.org/lkml/20210204172230.85853-1-sgarzare@redhat.com/
>v2: https://lore.kernel.org/lkml/20210128144127.113245-1-sgarzare@redhat.com/
>v1: https://lore.kernel.org/lkml/93f207c0-61e6-3696-f218-e7d7ea9a7c93@redhat.com/
>
>This series is the second part of the v1 linked above. The first part with
>refactoring of vdpa_sim has already been merged.
>
>The patches are based on Max Gurtovoy's work and extend the block simulator to
>have a ramdisk behaviour.
>
>As mentioned in the v1 there was 2 issues and I fixed them in this series:
>1. The identical mapping in the IOMMU used until now in vdpa_sim created issues
>   when mapping different virtual pages with the same physical address.
>   Fixed by patch "vdpa_sim: use iova module to allocate IOVA addresses"
>
>2. There was a race accessing the IOMMU between the vdpasim_blk_work() and the
>   device driver that map/unmap DMA regions. Fixed by patch "vringh: add
>   'iotlb_lock' to synchronize iotlb accesses"
>
>I used the Xie's patch coming from VDUSE series to allow vhost-vdpa to use
>block devices, and I added get_config_size() callback to allow any device
>in vhost-vdpa.
>
>The series also includes small fixes for vringh, vdpa, and vdpa_sim that I
>discovered while implementing and testing the block simulator.
>
>Thanks for your feedback,
>Stefano
>
>Max Gurtovoy (1):
>  vdpa: add vdpa simulator for block device
>
>Stefano Garzarella (12):
>  vdpa_sim: use iova module to allocate IOVA addresses
>  vringh: add 'iotlb_lock' to synchronize iotlb accesses
>  vringh: reset kiov 'consumed' field in __vringh_iov()
>  vringh: explain more about cleaning riov and wiov
>  vringh: implement vringh_kiov_advance()
>  vringh: add vringh_kiov_length() helper
>  vdpa_sim: cleanup kiovs in vdpasim_free()
>  vdpa: add get_config_size callback in vdpa_config_ops
>  vhost/vdpa: use get_config_size callback in
>    vhost_vdpa_config_validate()
>  vdpa_sim_blk: implement ramdisk behaviour
>  vdpa_sim_blk: handle VIRTIO_BLK_T_GET_ID
>  vdpa_sim_blk: add support for vdpa management tool
>
>Xie Yongji (1):
>  vhost/vdpa: Remove the restriction that only supports virtio-net
>    devices
>
> drivers/vdpa/vdpa_sim/vdpa_sim.h     |   2 +
> include/linux/vdpa.h                 |   4 +
> include/linux/vringh.h               |  19 +-
> drivers/vdpa/ifcvf/ifcvf_main.c      |   6 +
> drivers/vdpa/mlx5/net/mlx5_vnet.c    |   6 +
> drivers/vdpa/vdpa_sim/vdpa_sim.c     | 127 ++++++----
> drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 338 +++++++++++++++++++++++++++
> drivers/vdpa/virtio_pci/vp_vdpa.c    |   8 +
> drivers/vhost/vdpa.c                 |  15 +-
> drivers/vhost/vringh.c               |  69 ++++--
> drivers/vdpa/Kconfig                 |   8 +
> drivers/vdpa/vdpa_sim/Makefile       |   1 +
> 12 files changed, 529 insertions(+), 74 deletions(-)
> create mode 100644 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
>
>-- 
>2.30.2
>
>_______________________________________________
>Virtualization mailing list
>Virtualization@lists.linux-foundation.org
>https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>

