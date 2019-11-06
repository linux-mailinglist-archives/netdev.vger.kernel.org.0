Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A7FF1474
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 11:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731410AbfKFKyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 05:54:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53362 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727239AbfKFKyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 05:54:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573037662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fGorvUTGsLqevtZBLR5OZLF/U5+vhIM/50DJzmb0OLw=;
        b=iXWBsfNdUpDjzq4hOvkzGHMswywir7BwOiFYoIECSQcNc9zO13ZlHM+SyDIvu++oQlHKUw
        +7N6i5sBjq4eIoc9947LBuE5k1xoVVXr2Ihh3K7J2wb5gaUSjB2dM6T1qUpqdfFAY9pPeh
        UfMpxrJaozuWjFDUfBc5bOr1Bds7nHs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-Tpb9DX_WP6aWI3ZLFrZQEA-1; Wed, 06 Nov 2019 05:54:19 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C2E7800C72;
        Wed,  6 Nov 2019 10:54:15 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 989315D70D;
        Wed,  6 Nov 2019 10:53:58 +0000 (UTC)
Date:   Wed, 6 Nov 2019 11:53:56 +0100
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
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
Subject: Re: [PATCH V9 4/6] mdev: introduce virtio device and its device ops
Message-ID: <20191106115356.2c3ca3b1.cohuck@redhat.com>
In-Reply-To: <20191106070548.18980-5-jasowang@redhat.com>
References: <20191106070548.18980-1-jasowang@redhat.com>
        <20191106070548.18980-5-jasowang@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: Tpb9DX_WP6aWI3ZLFrZQEA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Nov 2019 15:05:46 +0800
Jason Wang <jasowang@redhat.com> wrote:

> This patch implements basic support for mdev driver that supports
> virtio transport for kernel virtio driver.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  MAINTAINERS                      |   1 +
>  drivers/vfio/mdev/mdev_core.c    |  21 +++++
>  drivers/vfio/mdev/mdev_private.h |   2 +
>  include/linux/mdev.h             |   6 ++
>  include/linux/mdev_virtio_ops.h  | 147 +++++++++++++++++++++++++++++++
>  5 files changed, 177 insertions(+)
>  create mode 100644 include/linux/mdev_virtio_ops.h

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

