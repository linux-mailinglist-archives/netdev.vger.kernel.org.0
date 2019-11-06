Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 299A5F1E2C
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 20:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732006AbfKFTDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 14:03:45 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54216 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727410AbfKFTDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 14:03:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573067020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mg3JgW1BuhTCB4NFaQyIC8Smk9WRddoCBLHgtm+TXAs=;
        b=iMIDHSNT7gr26XTPRz3osxiVjbF/Y2oP7YkWKF+ToGNeqe8Zyhs7SWuKmWk4Z/P2CI6kBk
        2R19so2URLyk41Zz4GLB5JEK80fJ96ICroU0OtVoI7bZtB1MKRtnb9xI2+4HfDVwLZVVN8
        nqdRTYy/fVyMuhfskINu6i8H4f033ro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-MkavMd-mPku2TkqD8XFDEg-1; Wed, 06 Nov 2019 14:03:34 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3930477;
        Wed,  6 Nov 2019 19:03:30 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA38F5C6DC;
        Wed,  6 Nov 2019 19:03:12 +0000 (UTC)
Date:   Wed, 6 Nov 2019 12:03:12 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
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
Subject: Re: [PATCH V8 0/6] mdev based hardware virtio offloading support
Message-ID: <20191106120312.77a6a318@x1.home>
In-Reply-To: <393f2dc9-8c67-d3c9-6553-640b80c15aaf@redhat.com>
References: <20191105093240.5135-1-jasowang@redhat.com>
        <20191105105834.469675f0@x1.home>
        <393f2dc9-8c67-d3c9-6553-640b80c15aaf@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: MkavMd-mPku2TkqD8XFDEg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Nov 2019 11:56:46 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 2019/11/6 =E4=B8=8A=E5=8D=881:58, Alex Williamson wrote:
> > On Tue,  5 Nov 2019 17:32:34 +0800
> > Jason Wang <jasowang@redhat.com> wrote:
> > =20
> >> Hi all:
> >>
> >> There are hardwares that can do virtio datapath offloading while
> >> having its own control path. This path tries to implement a mdev based
> >> unified API to support using kernel virtio driver to drive those
> >> devices. This is done by introducing a new mdev transport for virtio
> >> (virtio_mdev) and register itself as a new kind of mdev driver. Then
> >> it provides a unified way for kernel virtio driver to talk with mdev
> >> device implementation.
> >>
> >> Though the series only contains kernel driver support, the goal is to
> >> make the transport generic enough to support userspace drivers. This
> >> means vhost-mdev[1] could be built on top as well by resuing the
> >> transport.
> >>
> >> A sample driver is also implemented which simulate a virito-net
> >> loopback ethernet device on top of vringh + workqueue. This could be
> >> used as a reference implementation for real hardware driver.
> >>
> >> Also a real ICF VF driver was also posted here[2] which is a good
> >> reference for vendors who is interested in their own virtio datapath
> >> offloading product.
> >>
> >> Consider mdev framework only support VFIO device and driver right now,
> >> this series also extend it to support other types. This is done
> >> through introducing class id to the device and pairing it with
> >> id_talbe claimed by the driver. On top, this seris also decouple
> >> device specific parents ops out of the common ones.
> >>
> >> Pktgen test was done with virito-net + mvnet loop back device.
> >>
> >> Please review.
> >>
> >> [1] https://lkml.org/lkml/2019/10/31/440
> >> [2] https://lkml.org/lkml/2019/10/15/1226
> >>
> >> Changes from V7:
> >> - drop {set|get}_mdev_features for virtio
> >> - typo and comment style fixes =20
> >
> > Seems we're nearly there, all the remaining comments are relatively
> > superficial, though I would appreciate a v9 addressing them as well as
> > the checkpatch warnings:
> >
> > https://patchwork.freedesktop.org/series/68977/ =20
>=20
>=20
> Will do.
>=20
> Btw, do you plan to merge vhost-mdev patch on top? Or you prefer it to=20
> go through Michael's vhost tree?

I can include it if you wish.  The mdev changes are isolated enough in
that patch that I wouldn't presume it, but clearly it would require
less merge coordination to drop it in my tree.  Let me know.  Thanks,

Alex

