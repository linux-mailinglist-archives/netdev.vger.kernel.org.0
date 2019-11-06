Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B76C3F223B
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfKFW6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:58:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55089 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727524AbfKFW6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 17:58:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573081098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Clhu2rt+kpo43UbuiVcjjHoWtjEgIjo2tHeRtPjlyQ=;
        b=bZQe086k/IHnAuMY7ONkhRZddgHCeTz99r92g31HRvHEpYqODSOG66hMNdJeyg5OwNZjIh
        AMzG76nktxoFwj2Wb4bJOEsht7+aMBYXCoWM70wrBfiOa+3BFdCgfulYMCtZzg1AEUvdaU
        IMB6uxhYJFoFZ1Hx/p3oDZ/uKrI6tyk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-YbiNC0ioPxK3IgeNVq5zwQ-1; Wed, 06 Nov 2019 17:58:14 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2C16107ACC3;
        Wed,  6 Nov 2019 22:58:10 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF7AB5C1BB;
        Wed,  6 Nov 2019 22:58:00 +0000 (UTC)
Date:   Wed, 6 Nov 2019 15:58:00 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        mst@redhat.com, tiwei.bie@intel.com,
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
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
Subject: Re: [PATCH V9 6/6] docs: sample driver to demonstrate how to
 implement virtio-mdev framework
Message-ID: <20191106155800.0b8418ec@x1.home>
In-Reply-To: <88efad07-70aa-3879-31e7-ace4d2ad63a1@infradead.org>
References: <20191106070548.18980-1-jasowang@redhat.com>
        <20191106070548.18980-7-jasowang@redhat.com>
        <88efad07-70aa-3879-31e7-ace4d2ad63a1@infradead.org>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: YbiNC0ioPxK3IgeNVq5zwQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Nov 2019 14:50:30 -0800
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 11/5/19 11:05 PM, Jason Wang wrote:
> > diff --git a/samples/Kconfig b/samples/Kconfig
> > index c8dacb4dda80..13a2443e18e0 100644
> > --- a/samples/Kconfig
> > +++ b/samples/Kconfig
> > @@ -131,6 +131,16 @@ config SAMPLE_VFIO_MDEV_MDPY
> >  =09  mediated device.  It is a simple framebuffer and supports
> >  =09  the region display interface (VFIO_GFX_PLANE_TYPE_REGION).
> > =20
> > +config SAMPLE_VIRTIO_MDEV_NET
> > +=09tristate "Build VIRTIO net example mediated device sample code -- l=
oadable modules only"
> > +=09depends on VIRTIO_MDEV && VHOST_RING && m
> > +=09help
> > +=09  Build a networking sample device for use as a virtio
> > +=09  mediated device. The device coopreates with virtio-mdev bus =20
>=20
> typo here:
> =09                              cooperates
>=20

I can fix this on commit relative to V10 if there are no other issues
raised:

diff --git a/samples/Kconfig b/samples/Kconfig
index 13a2443e18e0..b7116d97cbbe 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -136,7 +136,7 @@ config SAMPLE_VIRTIO_MDEV_NET
        depends on VIRTIO_MDEV && VHOST_RING && m
        help
          Build a networking sample device for use as a virtio
-         mediated device. The device coopreates with virtio-mdev bus
+         mediated device. The device cooperates with virtio-mdev bus
          driver to present an virtio ethernet driver for
          kernel. It simply loopbacks all packets from its TX
          virtqueue to its RX virtqueue.

Thanks,
Alex

