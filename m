Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92078DA8D5
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 11:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393857AbfJQJnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 05:43:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36036 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbfJQJnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 05:43:46 -0400
Received: by mail-wm1-f66.google.com with SMTP id m18so1821973wmc.1;
        Thu, 17 Oct 2019 02:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j33Q+AxJlhfJ2zQyBdLBD2zOlPBTBa+TDiJdmF/d4B0=;
        b=PBJfc4iKYLoGVwZHVtTO0lO3ez5BpGeXPZAlj4Qxx0c4NWNvQiQJdK1Zm22yFqjtaV
         XO4FHG92jwHETc95eBaAqW8My3/55VjWzgdzO1Z7VFGBKZ6/SSKp6CTcrfC3PtlNKUqL
         Gz5RKw3w65f80M9hxVCyoUP5nbQbEGYqA7zONJtbqiZZSQ4kJoIXDkriUorZx149Ov6V
         hp2VI/XVNAKT6jIOvk6lx29b+UyYLiw1dTHMppE7KWb8k9vetl5lYmF5oE0pBsoCnQOR
         RSu0PTM8fVta3TCkFFq1fEmhNZJQ4CHICquFivetIufuHrOzmlAiCgVnt5JDfNQxaSMU
         /cUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j33Q+AxJlhfJ2zQyBdLBD2zOlPBTBa+TDiJdmF/d4B0=;
        b=Qo9E6J49rYFa2ZNpWd2ckIpFOhYaaqhgw1JA7U44usOR5nqZEIACEj5Sl++pp7iID8
         iZk+oJra5DXIVsEpr4uZzIjA8eFQZ7/Tq1LIQF3Imsh4M3luaLAu9gYzHZF3HUMWUjjd
         xWfmUmuMhZPNfE/3Y/YOHYC2amv2e1ZLuOVsCan9hZOZ0pY8kHodcOH/uI9/SokJ1Qr6
         VtrfU35FXnZPlku0iHy6L9BMJNBC3xdSbsmbvfEuUFdkv3qgPfYkLjSP3IVOyKrAsVtU
         Oa7p+2S1HOzpIuU3EM/SLshKTT3xhdwjYmS+aMzMQh2pDJ+uMSTuypR2fO2Xbgje8g3l
         ACJg==
X-Gm-Message-State: APjAAAU3UptI2OkoEaNJNLcjJ2TJlY71ZsJoFAJw9VwbkcLyQyelt4PF
        mTgJxKa92fQjHhlSDOcUB1U=
X-Google-Smtp-Source: APXvYqxHJt9ec/ig4bgPywnDn38DGreAT5nDreVbx5QqzUYuzF0nTYOT9L67QUVhr9q6+o+HntA0Mw==
X-Received: by 2002:a05:600c:21d2:: with SMTP id x18mr2121283wmj.146.1571305423433;
        Thu, 17 Oct 2019 02:43:43 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id l6sm2029963wmg.2.2019.10.17.02.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 02:43:42 -0700 (PDT)
Date:   Thu, 17 Oct 2019 10:43:41 +0100
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
Message-ID: <20191017094341.GF23557@stefanha-x1.localdomain>
References: <20191011081557.28302-1-jasowang@redhat.com>
 <20191014174946.GC5359@stefanha-x1.localdomain>
 <6d12ad8f-8137-e07d-d735-da59a326e8ed@redhat.com>
 <20191015143720.GA13108@stefanha-x1.localdomain>
 <ba81e603-cb7d-b152-8fae-97f070a7e460@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Pql/uPZNXIm1JCle"
Content-Disposition: inline
In-Reply-To: <ba81e603-cb7d-b152-8fae-97f070a7e460@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Pql/uPZNXIm1JCle
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2019 at 09:42:53AM +0800, Jason Wang wrote:
>=20
> On 2019/10/15 =E4=B8=8B=E5=8D=8810:37, Stefan Hajnoczi wrote:
> > On Tue, Oct 15, 2019 at 11:37:17AM +0800, Jason Wang wrote:
> > > On 2019/10/15 =E4=B8=8A=E5=8D=881:49, Stefan Hajnoczi wrote:
> > > > On Fri, Oct 11, 2019 at 04:15:50PM +0800, Jason Wang wrote:
> > > > > There are hardware that can do virtio datapath offloading while h=
aving
> > > > > its own control path. This path tries to implement a mdev based
> > > > > unified API to support using kernel virtio driver to drive those
> > > > > devices. This is done by introducing a new mdev transport for vir=
tio
> > > > > (virtio_mdev) and register itself as a new kind of mdev driver. T=
hen
> > > > > it provides a unified way for kernel virtio driver to talk with m=
dev
> > > > > device implementation.
> > > > >=20
> > > > > Though the series only contains kernel driver support, the goal i=
s to
> > > > > make the transport generic enough to support userspace drivers. T=
his
> > > > > means vhost-mdev[1] could be built on top as well by resuing the
> > > > > transport.
> > > > >=20
> > > > > A sample driver is also implemented which simulate a virito-net
> > > > > loopback ethernet device on top of vringh + workqueue. This could=
 be
> > > > > used as a reference implementation for real hardware driver.
> > > > >=20
> > > > > Consider mdev framework only support VFIO device and driver right=
 now,
> > > > > this series also extend it to support other types. This is done
> > > > > through introducing class id to the device and pairing it with
> > > > > id_talbe claimed by the driver. On top, this seris also decouple
> > > > > device specific parents ops out of the common ones.
> > > > I was curious so I took a quick look and posted comments.
> > > >=20
> > > > I guess this driver runs inside the guest since it registers virtio
> > > > devices?
> > >=20
> > > It could run in either guest or host. But the main focus is to run in=
 the
> > > host then we can use virtio drivers in containers.
> > >=20
> > >=20
> > > > If this is used with physical PCI devices that support datapath
> > > > offloading then how are physical devices presented to the guest wit=
hout
> > > > SR-IOV?
> > >=20
> > > We will do control path meditation through vhost-mdev[1] and vhost-vf=
io[2].
> > > Then we will present a full virtio compatible ethernet device for gue=
st.
> > >=20
> > > SR-IOV is not a must, any mdev device that implements the API defined=
 in
> > > patch 5 can be used by this framework.
> > What I'm trying to understand is: if you want to present a virtio-pci
> > device to the guest (e.g. using vhost-mdev or vhost-vfio), then how is
> > that related to this patch series?
>=20
>=20
> This series introduce some infrastructure that would be used by vhost-mde=
v:
>=20
> 1) allow new type of mdev devices/drivers other than vfio (through class_=
id
> and device ops)
>=20
> 2) a set of virtio specific callbacks that will be used by both vhost-mdev
> and virtio-mdev defined in patch 5
>=20
> Then vhost-mdev can be implemented on top: a new mdev class id but reuse =
the
> callback defined in 2. Through this way the parent can provides a single =
set
> of callbacks (device ops) for both kernel virtio driver (through
> virtio-mdev) or userspace virtio driver (through vhost-mdev).

Okay, thanks for explaining!

Stefan

--Pql/uPZNXIm1JCle
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2oN8wACgkQnKSrs4Gr
c8gqswf/fQBq+qX21L3QGLUXUsf7OZ9kLP3ksR+9RYfGDJaFva/fV/aULknTmAiO
OA0s+Eiw7K5Hy2ooKGPQXPYgAJhgnHqmhKgOEdsOGDWyCilYAiJzk/YXkpPvaCTp
ovWC5Fz/shXyY3m2YGPXuwnWjbCam7cqMCRVPrmzJWoS6kdvsYsPxBVnhGFOm0Ms
gbll/8mZQDQWsOZ8ZFeXLXCcHifXaiLa+yiGcZfxtV37oHsSapT+MOXEstGy4jEe
uvos/V8tSLLMOJ+zgMYGOI0oOJIejMOrLU2zxPlktTbBVcM1RQtpJL69F30gi89K
qCue5w57Z1UNfPVbXLiobIkPcZBGVw==
=EXDt
-----END PGP SIGNATURE-----

--Pql/uPZNXIm1JCle--
