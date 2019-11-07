Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 160B2F3361
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 16:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389353AbfKGPfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 10:35:11 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45384 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729954AbfKGPfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 10:35:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573140909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BzEyez2H23edMWUzeroDzzDUe6EbJTfa2zTwff9g92s=;
        b=iytoKoHykz8YhCd5O48nU5ObA9o3jLo8P15TM0U2VcVQPg/x6e7Hr5Qa3j4gO0uSqttAOY
        OgwLfTp0x5ODyLzDUyK9cBN58lQJI3x2Gl4CSaSsetY0I49gmlFVL4x9U2Ft2tcqirL7Kp
        vnva7uDFSHOsVxHnhV4DEiFhMMeqIfo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-TZdOIwyWM0aw-ZFtUujj9Q-1; Thu, 07 Nov 2019 10:35:05 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 000FF477;
        Thu,  7 Nov 2019 15:35:00 +0000 (UTC)
Received: from gondolin (ovpn-117-222.ams2.redhat.com [10.36.117.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCE1260BEC;
        Thu,  7 Nov 2019 15:34:51 +0000 (UTC)
Date:   Thu, 7 Nov 2019 16:34:48 +0100
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
Subject: Re: [PATCH V11 6/6] docs: sample driver to demonstrate how to
 implement virtio-mdev framework
Message-ID: <20191107163448.4d20b75b.cohuck@redhat.com>
In-Reply-To: <20191107151109.23261-7-jasowang@redhat.com>
References: <20191107151109.23261-1-jasowang@redhat.com>
        <20191107151109.23261-7-jasowang@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: TZdOIwyWM0aw-ZFtUujj9Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Nov 2019 23:11:09 +0800
Jason Wang <jasowang@redhat.com> wrote:

> This sample driver creates mdev device that simulate virtio net device
> over virtio mdev transport. The device is implemented through vringh
> and workqueue. A device specific dma ops is to make sure HVA is used
> directly as the IOVA. This should be sufficient for kernel virtio
> driver to work.
>=20
> Only 'virtio' type is supported right now. I plan to add 'vhost' type
> on top which requires some virtual IOMMU implemented in this sample
> driver.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  MAINTAINERS                        |   1 +
>  samples/Kconfig                    |  10 +
>  samples/vfio-mdev/Makefile         |   1 +
>  samples/vfio-mdev/mvnet_loopback.c | 687 +++++++++++++++++++++++++++++
>  4 files changed, 699 insertions(+)
>  create mode 100644 samples/vfio-mdev/mvnet_loopback.c

Acked-by: Cornelia Huck <cohuck@redhat.com>

