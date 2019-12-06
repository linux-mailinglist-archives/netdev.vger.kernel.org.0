Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE59114D23
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 09:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfLFIFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 03:05:21 -0500
Received: from mga12.intel.com ([192.55.52.136]:40601 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbfLFIFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Dec 2019 03:05:21 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 00:05:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,283,1571727600"; 
   d="asc'?scan'208";a="294792853"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.13.116])
  by orsmga001.jf.intel.com with ESMTP; 06 Dec 2019 00:05:18 -0800
Date:   Fri, 6 Dec 2019 16:03:54 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/6] VFIO mdev aggregated resources handling
Message-ID: <20191206080354.GA15502@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
 <AM0PR05MB4866CA9B70A8BEC1868AF8C8D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108081925.GH4196@zhen-hp.sh.intel.com>
 <AM0PR05MB4866757033043CC007B5C9CBD15D0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191205060618.GD4196@zhen-hp.sh.intel.com>
 <AM0PR05MB4866C265B6C9D521A201609DD15C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <AM0PR05MB4866C265B6C9D521A201609DD15C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019.12.05 18:59:36 +0000, Parav Pandit wrote:
> > >
> > > > On 2019.11.07 20:37:49 +0000, Parav Pandit wrote:
> > > > > Hi,
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On
> > > > > > Behalf Of Zhenyu Wang
> > > > > > Sent: Thursday, October 24, 2019 12:08 AM
> > > > > > To: kvm@vger.kernel.org
> > > > > > Cc: alex.williamson@redhat.com; kwankhede@nvidia.com;
> > > > > > kevin.tian@intel.com; cohuck@redhat.com
> > > > > > Subject: [PATCH 0/6] VFIO mdev aggregated resources handling
> > > > > >
> > > > > > Hi,
> > > > > >
> > > > > > This is a refresh for previous send of this series. I got
> > > > > > impression that some SIOV drivers would still deploy their own
> > > > > > create and config method so stopped effort on this. But seems
> > > > > > this would still be useful for some other SIOV driver which may
> > > > > > simply want capability to aggregate resources. So here's refres=
hed
> > series.
> > > > > >
> > > > > > Current mdev device create interface depends on fixed mdev type,
> > > > > > which get uuid from user to create instance of mdev device. If
> > > > > > user wants to use customized number of resource for mdev device,
> > > > > > then only can create new
> > > > > Can you please give an example of 'resource'?
> > > > > When I grep [1], [2] and [3], I couldn't find anything related to=
 '
> > aggregate'.
> > > >
> > > > The resource is vendor device specific, in SIOV spec there's ADI
> > > > (Assignable Device Interface) definition which could be e.g queue
> > > > for net device, context for gpu, etc. I just named this interface as
> > 'aggregate'
> > > > for aggregation purpose, it's not used in spec doc.
> > > >
> > >
> > > Some 'unknown/undefined' vendor specific resource just doesn't work.
> > > Orchestration tool doesn't know which resource and what/how to config=
ure
> > for which vendor.
> > > It has to be well defined.
> > >
> > > You can also find such discussion in recent lgpu DRM cgroup patches s=
eries
> > v4.
> > >
> > > Exposing networking resource configuration in non-net namespace aware
> > mdev sysfs at PCI device level is no-go.
> > > Adding per file NET_ADMIN or other checks is not the approach we foll=
ow in
> > kernel.
> > >
> > > devlink has been a subsystem though under net, that has very rich int=
erface
> > for syscaller, device health, resource management and many more.
> > > Even though it is used by net driver today, its written for generic d=
evice
> > management at bus/device level.
> > >
> > > Yuval has posted patches to manage PCI sub-devices [1] and updated ve=
rsion
> > will be posted soon which addresses comments.
> > >
> > > For any device slice resource management of mdev, sub-function etc, we
> > should be using single kernel interface as devlink [2], [3].
> > >
> > > [1]
> > > https://lore.kernel.org/netdev/1573229926-30040-1-git-send-email-yuval
> > > av@mellanox.com/ [2]
> > > http://man7.org/linux/man-pages/man8/devlink-dev.8.html
> > > [3] http://man7.org/linux/man-pages/man8/devlink-resource.8.html
> > >
> > > Most modern device configuration that I am aware of is usually done v=
ia well
> > defined ioctl() of the subsystem (vhost, virtio, vfio, rdma, nvme and m=
ore) or
> > via netlink commands (net, devlink, rdma and more) not via sysfs.
> > >
> >=20
> > Current vfio/mdev configuration is via documented sysfs ABI instead of =
other
> > ways. So this adhere to that way to introduce more configurable method =
on
> > mdev device for standard, it's optional and not actually vendor specifi=
c e.g vfio-
> > ap.
> >=20
> Some unknown/undefined resource as 'aggregate' is just not an ABI.
> It has to be well defined, as 'hardware_address', 'num_netdev_sqs' or som=
ething similar appropriate to that mdev device class.
> If user wants to set a parameter for a mdev regardless of vendor, they mu=
st have single way to do so.

The idea is not specific for some device class, but for each mdev
type's resource, and be optional for each vendor. If more device class
specific way is preferred, then we might have very different ways for
different vendors. Better to avoid that, so here means to aggregate
number of mdev type's resources for target instance, instead of defining
kinds of mdev types for those number of resources.

>=20
> > I'm not sure how many devices support devlink now, or if really make se=
nse to
> > utilize devlink for other devices except net, or if really make sense t=
o take
> > mdev resource configuration from there...
> >=20
> This is about adding new knobs not the existing one.
> It has to be well defined. 'aggregate' is not the word that describes it.
> If this is something very device specific, it should be prefixed with 'mi=
sc_' something.. or it should be misc_X ioctl().
> Miscellaneous not so well defined class of devices are usually registered=
 using misc_register().
> Similarly attributes has to be well defined, otherwise, it should fall un=
der misc category specially when you are pointing to 3 well defined specifi=
cations.
>

Any suggestion for naming it?

> > > >
> > > > >
> > > > > > mdev type for that which may not be flexible. This requirement
> > > > > > comes not only from to be able to allocate flexible resources
> > > > > > for KVMGT, but also from Intel scalable IO virtualization which
> > > > > > would use vfio/mdev to be able to allocate arbitrary resources =
on mdev
> > instance.
> > > > More info on [1] [2] [3].
> > > > > >
> > > > > > To allow to create user defined resources for mdev, it trys to
> > > > > > extend mdev create interface by adding new "aggregate=3Dxxx"
> > > > > > parameter following UUID, for target mdev type if aggregation is
> > > > > > supported, it can create new mdev device which contains
> > > > > > resources combined by number of instances, e.g
> > > > > >
> > > > > >     echo "<uuid>,aggregate=3D10" > create
> > > > > >
> > > > > > VM manager e.g libvirt can check mdev type with "aggregation"
> > > > > > attribute which can support this setting. If no "aggregation"
> > > > > > attribute found for mdev type, previous behavior is still kept
> > > > > > for one instance allocation. And new sysfs attribute
> > > > > > "aggregated_instances" is created for each mdev device to show
> > > > > > allocated
> > > > number.
> > > > > >
> > > > > > References:
> > > > > > [1]
> > > > > > https://software.intel.com/en-us/download/intel-virtualization-t
> > > > > > echn
> > > > > > ology- for-directed-io-architecture-specification
> > > > > > [2]
> > > > > > https://software.intel.com/en-us/download/intel-scalable-io-virt
> > > > > > uali
> > > > > > zation-
> > > > > > technical-specification
> > > > > > [3] https://schd.ws/hosted_files/lc32018/00/LC3-SIOV-final.pdf
> > > > > >
> > > > > > Zhenyu Wang (6):
> > > > > >   vfio/mdev: Add new "aggregate" parameter for mdev create
> > > > > >   vfio/mdev: Add "aggregation" attribute for supported mdev type
> > > > > >   vfio/mdev: Add "aggregated_instances" attribute for supported=
 mdev
> > > > > >     device
> > > > > >   Documentation/driver-api/vfio-mediated-device.rst: Update for
> > > > > >     vfio/mdev aggregation support
> > > > > >   Documentation/ABI/testing/sysfs-bus-vfio-mdev: Update for vfi=
o/mdev
> > > > > >     aggregation support
> > > > > >   drm/i915/gvt: Add new type with aggregation support
> > > > > >
> > > > > >  Documentation/ABI/testing/sysfs-bus-vfio-mdev | 24 ++++++
> > > > > >  .../driver-api/vfio-mediated-device.rst       | 23 ++++++
> > > > > >  drivers/gpu/drm/i915/gvt/gvt.c                |  4 +-
> > > > > >  drivers/gpu/drm/i915/gvt/gvt.h                | 11 ++-
> > > > > >  drivers/gpu/drm/i915/gvt/kvmgt.c              | 53 +++++++++++=
+-
> > > > > >  drivers/gpu/drm/i915/gvt/vgpu.c               | 56 +++++++++++=
+-
> > > > > >  drivers/vfio/mdev/mdev_core.c                 | 36 ++++++++-
> > > > > >  drivers/vfio/mdev/mdev_private.h              |  6 +-
> > > > > >  drivers/vfio/mdev/mdev_sysfs.c                | 79 +++++++++++=
+++++++-
> > > > > >  include/linux/mdev.h                          | 19 +++++
> > > > > >  10 files changed, 294 insertions(+), 17 deletions(-)
> > > > > >
> > > > > > --
> > > > > > 2.24.0.rc0
> > > > >
> > > >
> > > > --
> > > > Open Source Technology Center, Intel ltd.
> > > >
> > > > $gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827
> >=20
> > --
> > Open Source Technology Center, Intel ltd.
> >=20
> > $gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXeoLagAKCRCxBBozTXgY
J0mSAJ9yhwfg8z8EzL9+GC/QfAG1PLsjpwCePcwCU5VQWGjt4064spJNqQc2mn8=
=PtSN
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
