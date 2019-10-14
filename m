Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2E59D68CF
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 19:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbfJNRtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 13:49:53 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41115 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729776AbfJNRtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 13:49:53 -0400
Received: by mail-wr1-f67.google.com with SMTP id p4so4849866wrm.8;
        Mon, 14 Oct 2019 10:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XXUMrGZIb6oF2ZXlkY6NvVGKtm0a8dgxsmrS0PyzrVM=;
        b=I/j8jtNurZb03wO5OtpFMwdIEKSI/vQc1BpvLpGl7ryBO321tGoGGD/dOPskkClYgw
         od4t5zjq2+ndwxdNXh+zb0qgGfEDiYNC8CJI5nF9z0sOJtW/AfXcRs9u9iWNzfztTASm
         zRmpLe4p98ADBn7rdM7pjSDzk7VKVIejQmclv2xjvGruv1pY+/Z3iKi3Ri2jzo/vZXKZ
         U1CtlK0iIYAuWGsQk/PJUF6nLEzNapqKj/Nhjmq1INYWCFMOd1+W22by2mHCL9aIRP7o
         dRogtOEYzA8TV/asYmxRHwEpPsFleBrtG5/5o48RbATHAQ6SxNYlqC7Ip8//tVEgp69R
         zJfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XXUMrGZIb6oF2ZXlkY6NvVGKtm0a8dgxsmrS0PyzrVM=;
        b=iDRSjREZaDKP5Nl1ZIDtb+r//1i4tkubJ4zWmetRoiPdlb8lgy2+BIK5rPvHL6sZtp
         ImF4NY/a/hyHRrQCeexUiB2lTsvFxRMfaRwgwKofZvmYepbRMEwrFZPjqUdiZLJKF+YL
         ouA58MaQRhrUpY9YS5DOXKjTDQFuO52TGDk35JYJhpuE2IUum3VjzM4XvTn5CgDGqpeQ
         0HDMou1ApeI0JN3tPHNTzRGmFbBhmyHLnw/ENj/A1/qXaH66CgG/KgWtly5PdsUFwo7t
         3acTWr4gUUf3fcgcRz3NMKWwNj7dySP19sfPBzperEXZJYgDNSLStL072CSAwlKhSqZk
         1iOA==
X-Gm-Message-State: APjAAAXuo8DuEGJjVZXJtylxFGpO5+TpNp9+f95232UhWL7TqAUawFyo
        vnceqEb2zSAIh/SV3lWC9MM=
X-Google-Smtp-Source: APXvYqy78vv8xomOjJzk/rQmkBz13qhvU+ercRByH/EBEIZm2MrjAU0AN+KF4wDSX2QXx60c7i4efw==
X-Received: by 2002:adf:fa92:: with SMTP id h18mr26866005wrr.220.1571075388812;
        Mon, 14 Oct 2019 10:49:48 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id o70sm26093856wme.29.2019.10.14.10.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 10:49:48 -0700 (PDT)
Date:   Mon, 14 Oct 2019 18:49:46 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com,
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
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com
Subject: Re: [PATCH V3 0/7] mdev based hardware virtio offloading support
Message-ID: <20191014174946.GC5359@stefanha-x1.localdomain>
References: <20191011081557.28302-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XMCwj5IQnwKtuyBG"
Content-Disposition: inline
In-Reply-To: <20191011081557.28302-1-jasowang@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2019 at 04:15:50PM +0800, Jason Wang wrote:
> There are hardware that can do virtio datapath offloading while having
> its own control path. This path tries to implement a mdev based
> unified API to support using kernel virtio driver to drive those
> devices. This is done by introducing a new mdev transport for virtio
> (virtio_mdev) and register itself as a new kind of mdev driver. Then
> it provides a unified way for kernel virtio driver to talk with mdev
> device implementation.
>=20
> Though the series only contains kernel driver support, the goal is to
> make the transport generic enough to support userspace drivers. This
> means vhost-mdev[1] could be built on top as well by resuing the
> transport.
>=20
> A sample driver is also implemented which simulate a virito-net
> loopback ethernet device on top of vringh + workqueue. This could be
> used as a reference implementation for real hardware driver.
>=20
> Consider mdev framework only support VFIO device and driver right now,
> this series also extend it to support other types. This is done
> through introducing class id to the device and pairing it with
> id_talbe claimed by the driver. On top, this seris also decouple
> device specific parents ops out of the common ones.

I was curious so I took a quick look and posted comments.

I guess this driver runs inside the guest since it registers virtio
devices?

If this is used with physical PCI devices that support datapath
offloading then how are physical devices presented to the guest without
SR-IOV?

Stefan

--XMCwj5IQnwKtuyBG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2ktToACgkQnKSrs4Gr
c8jgRgf/WWO5uJxyZLwosUbr+PGHcqci4COe1VGy3Aveab34yl0NQekiPT6CEG5k
PLqiRN9UlPXnMq5H6tsIptfG1mBTxJpF0H7FVRGvwKnV+NizCllURp1Eb1y6ucTd
j3Rg8JZAwDCdJsZ8d2o4JXQKv9CIavomjp0ZQNIdRiKJ8gOueiWydBgCOSO/l0dh
t/YI7ENprVpSg56pZba9Y3eueA6Gt4oSfHZbgtQWXBueHkyN90em9JoDAktAOu1m
PZAQykFnCUGV7RwfK2jUW+WIgh8mSrhu36zoyl9OAASnmHeiMBCTqpvHTKzRH180
fEnf2WwIaOxFvEnbfxu/3ljKyhjEaA==
=X6sM
-----END PGP SIGNATURE-----

--XMCwj5IQnwKtuyBG--
