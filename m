Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE8EAF3375
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 16:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbfKGPgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 10:36:50 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47887 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727606AbfKGPgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 10:36:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573141008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FAhytQLph68txo2Lut8xXgNzL31NY3OX1jJJVRGMRL8=;
        b=iNzmf3Uv9c0xAm8X2aqzbpwgTxxbBGiKLwxAK11sfWhCYD6Yfu2fCMtsWaKmDIhJLYiE6A
        jDZ/AdJlqdWTChLXrmwlROq7luZwTiB7t6uPZ3M6wqGfWR2UNvX8HoVVfdyp14dFWubsTK
        mWa9tuuOgTgtk4FCfLLMH6pgjlYXJj4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-lwzusoTTONmDNFvxeSwQlg-1; Thu, 07 Nov 2019 10:36:45 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1925107ACC3;
        Thu,  7 Nov 2019 15:36:41 +0000 (UTC)
Received: from gondolin (ovpn-117-222.ams2.redhat.com [10.36.117.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 927595DA76;
        Thu,  7 Nov 2019 15:36:09 +0000 (UTC)
Date:   Thu, 7 Nov 2019 16:36:06 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        farman@linux.ibm.com, pasic@linux.ibm.com, sebott@linux.ibm.com,
        oberpar@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com, rdunlap@infradead.org
Subject: Re: [PATCH V11 3/6] mdev: introduce device specific ops
Message-ID: <20191107163606.293a4f62.cohuck@redhat.com>
In-Reply-To: <20191107151109.23261-4-jasowang@redhat.com>
References: <20191107151109.23261-1-jasowang@redhat.com>
        <20191107151109.23261-4-jasowang@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: lwzusoTTONmDNFvxeSwQlg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Nov 2019 23:11:06 +0800
Jason Wang <jasowang@redhat.com> wrote:

> Currently, except for the create and remove, the rest of
> mdev_parent_ops is designed for vfio-mdev driver only and may not help
> for kernel mdev driver. With the help of class id, this patch
> introduces device specific callbacks inside mdev_device
> structure. This allows different set of callback to be used by
> vfio-mdev and virtio-mdev.
>=20
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  .../driver-api/vfio-mediated-device.rst       | 35 +++++++++----
>  MAINTAINERS                                   |  1 +
>  drivers/gpu/drm/i915/gvt/kvmgt.c              | 18 ++++---
>  drivers/s390/cio/vfio_ccw_ops.c               | 18 ++++---
>  drivers/s390/crypto/vfio_ap_ops.c             | 14 +++--
>  drivers/vfio/mdev/mdev_core.c                 | 24 ++++++++-
>  drivers/vfio/mdev/mdev_private.h              |  5 ++
>  drivers/vfio/mdev/vfio_mdev.c                 | 37 ++++++-------
>  include/linux/mdev.h                          | 43 ++++-----------
>  include/linux/mdev_vfio_ops.h                 | 52 +++++++++++++++++++
>  samples/vfio-mdev/mbochs.c                    | 20 ++++---
>  samples/vfio-mdev/mdpy.c                      | 20 ++++---
>  samples/vfio-mdev/mtty.c                      | 18 ++++---
>  13 files changed, 206 insertions(+), 99 deletions(-)
>  create mode 100644 include/linux/mdev_vfio_ops.h

You dropped my R-b :(, here it is again:

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

