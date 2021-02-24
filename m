Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0EE323C02
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 13:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbhBXMlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 07:41:51 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9228 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234537AbhBXMls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 07:41:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603649600005>; Wed, 24 Feb 2021 04:41:04 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 24 Feb 2021 12:41:02 +0000
Date:   Wed, 24 Feb 2021 14:40:59 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210224124059.GA207518@mtl-vdi-166.wap.labs.mlnx>
References: <22fe5923-635b-59f0-7643-2fd5876937c2@oracle.com>
 <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <7e6291a4-30b1-6b59-a2bf-713e7b56826d@redhat.com>
 <20210224000528-mutt-send-email-mst@kernel.org>
 <20210224064520.GA204317@mtl-vdi-166.wap.labs.mlnx>
 <20210224014700-mutt-send-email-mst@kernel.org>
 <ef775724-b5fb-ca70-ed2f-f23d8fbf4cd8@redhat.com>
 <20210224021054-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210224021054-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614170465; bh=CY4QNtNiD72euCLRiTKbC8UGQytTfwDI3C4JbViLSJ0=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=laDVWG15B6FMt40L16Yql1VJ9s2BdL/d72vcHHE7rvBeZ+KCJ6DA5iOrwvGbkHrJ6
         J1kcOm8J4GBbmT5eaaJ9D992t0uQc2r6SdKvKO+4RkiiqZsQtGhzpu3tLJ8vShdFTF
         GxQzb4gq9pumoXDpi9HK7AT54cVOHVbf0jWXxkdJBDyhO/j+toAHYehqAw2bECOoqV
         rn/3r3oa6wMG7huZTIaeQWHDAku7Ncvug9gIcP3tw66wy63DfD9zpS2LyTh1DKH94U
         qQbnPQwAkHAhXE1ZlJ48AfXrlwsFW/NXRQMGP9yebQvHCzW1w4kFyXYGSO1HNyOgtB
         yO4Q+35gXZGfg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 02:12:01AM -0500, Michael S. Tsirkin wrote:
> On Wed, Feb 24, 2021 at 02:55:13PM +0800, Jason Wang wrote:
> >=20
> > On 2021/2/24 2:47 =E4=B8=8B=E5=8D=88, Michael S. Tsirkin wrote:
> > > On Wed, Feb 24, 2021 at 08:45:20AM +0200, Eli Cohen wrote:
> > > > On Wed, Feb 24, 2021 at 12:17:58AM -0500, Michael S. Tsirkin wrote:
> > > > > On Wed, Feb 24, 2021 at 11:20:01AM +0800, Jason Wang wrote:
> > > > > > On 2021/2/24 3:35 =E4=B8=8A=E5=8D=88, Si-Wei Liu wrote:
> > > > > > >=20
> > > > > > > On 2/23/2021 5:26 AM, Michael S. Tsirkin wrote:
> > > > > > > > On Tue, Feb 23, 2021 at 10:03:57AM +0800, Jason Wang wrote:
> > > > > > > > > On 2021/2/23 9:12 =E4=B8=8A=E5=8D=88, Si-Wei Liu wrote:
> > > > > > > > > > On 2/21/2021 11:34 PM, Michael S. Tsirkin wrote:
> > > > > > > > > > > On Mon, Feb 22, 2021 at 12:14:17PM +0800, Jason Wang =
wrote:
> > > > > > > > > > > > On 2021/2/19 7:54 =E4=B8=8B=E5=8D=88, Si-Wei Liu wr=
ote:
> > > > > > > > > > > > > Commit 452639a64ad8 ("vdpa: make sure set_feature=
s is invoked
> > > > > > > > > > > > > for legacy") made an exception for legacy guests =
to reset
> > > > > > > > > > > > > features to 0, when config space is accessed befo=
re features
> > > > > > > > > > > > > are set. We should relieve the verify_min_feature=
s() check
> > > > > > > > > > > > > and allow features reset to 0 for this case.
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > It's worth noting that not just legacy guests cou=
ld access
> > > > > > > > > > > > > config space before features are set. For instanc=
e, when
> > > > > > > > > > > > > feature VIRTIO_NET_F_MTU is advertised some moder=
n driver
> > > > > > > > > > > > > will try to access and validate the MTU present i=
n the config
> > > > > > > > > > > > > space before virtio features are set.
> > > > > > > > > > > > This looks like a spec violation:
> > > > > > > > > > > >=20
> > > > > > > > > > > > "
> > > > > > > > > > > >=20
> > > > > > > > > > > > The following driver-read-only field, mtu only exis=
ts if
> > > > > > > > > > > > VIRTIO_NET_F_MTU is
> > > > > > > > > > > > set.
> > > > > > > > > > > > This field specifies the maximum MTU for the driver=
 to use.
> > > > > > > > > > > > "
> > > > > > > > > > > >=20
> > > > > > > > > > > > Do we really want to workaround this?
> > > > > > > > > > > >=20
> > > > > > > > > > > > Thanks
> > > > > > > > > > > And also:
> > > > > > > > > > >=20
> > > > > > > > > > > The driver MUST follow this sequence to initialize a =
device:
> > > > > > > > > > > 1. Reset the device.
> > > > > > > > > > > 2. Set the ACKNOWLEDGE status bit: the guest OS has
> > > > > > > > > > > noticed the device.
> > > > > > > > > > > 3. Set the DRIVER status bit: the guest OS knows how =
to drive the
> > > > > > > > > > > device.
> > > > > > > > > > > 4. Read device feature bits, and write the subset of =
feature bits
> > > > > > > > > > > understood by the OS and driver to the
> > > > > > > > > > > device. During this step the driver MAY read (but MUS=
T NOT write)
> > > > > > > > > > > the device-specific configuration
> > > > > > > > > > > fields to check that it can support the device before=
 accepting it.
> > > > > > > > > > > 5. Set the FEATURES_OK status bit. The driver MUST NO=
T accept new
> > > > > > > > > > > feature bits after this step.
> > > > > > > > > > > 6. Re-read device status to ensure the FEATURES_OK bi=
t is still set:
> > > > > > > > > > > otherwise, the device does not
> > > > > > > > > > > support our subset of features and the device is unus=
able.
> > > > > > > > > > > 7. Perform device-specific setup, including discovery=
 of virtqueues
> > > > > > > > > > > for the device, optional per-bus setup,
> > > > > > > > > > > reading and possibly writing the device=E2=80=99s vir=
tio configuration
> > > > > > > > > > > space, and population of virtqueues.
> > > > > > > > > > > 8. Set the DRIVER_OK status bit. At this point the de=
vice is =E2=80=9Clive=E2=80=9D.
> > > > > > > > > > >=20
> > > > > > > > > > >=20
> > > > > > > > > > > so accessing config space before FEATURES_OK is a spe=
c
> > > > > > > > > > > violation, right?
> > > > > > > > > > It is, but it's not relevant to what this commit tries =
to address. I
> > > > > > > > > > thought the legacy guest still needs to be supported.
> > > > > > > > > >=20
> > > > > > > > > > Having said, a separate patch has to be posted to fix t=
he guest driver
> > > > > > > > > > issue where this discrepancy is introduced to
> > > > > > > > > > virtnet_validate() (since
> > > > > > > > > > commit fe36cbe067). But it's not technically related to=
 this patch.
> > > > > > > > > >=20
> > > > > > > > > > -Siwei
> > > > > > > > > I think it's a bug to read config space in validate, we s=
hould
> > > > > > > > > move it to
> > > > > > > > > virtnet_probe().
> > > > > > > > >=20
> > > > > > > > > Thanks
> > > > > > > > I take it back, reading but not writing seems to be explici=
tly
> > > > > > > > allowed by spec.
> > > > > > > > So our way to detect a legacy guest is bogus, need to think=
 what is
> > > > > > > > the best way to handle this.
> > > > > > > Then maybe revert commit fe36cbe067 and friends, and have QEM=
U detect
> > > > > > > legacy guest? Supposedly only config space write access needs=
 to be
> > > > > > > guarded before setting FEATURES_OK.
> > > > > >=20
> > > > > > I agree. My understanding is that all vDPA must be modern devic=
e (since
> > > > > > VIRITO_F_ACCESS_PLATFORM is mandated) instead of transitional d=
evice.
> > > > > >=20
> > > > > > Thanks
> > > > > Well mlx5 has some code to handle legacy guests ...
> > > > > Eli, could you comment? Is that support unused right now?
> > > > >=20
> > > > If you mean support for version 1.0, well the knob is there but it'=
s not
> > > > set in the firmware I use. Note sure if we will support this.
> > > Hmm you mean it's legacy only right now?
> > > Well at some point you will want advanced goodies like RSS
> > > and all that is gated on 1.0 ;)
> >=20

Guys sorry, I checked again, the firmware capability is set and so is
VIRTIO_F_VERSION_1.

> >=20
> > So if my understanding is correct the device/firmware is legacy but req=
uire
> > VIRTIO_F_ACCESS_PLATFORM semanic? Looks like a spec violation?
> >=20
> > Thanks
>=20
> Legacy mode description is the spec is non-normative. As such as long as
> guests work, they work ;)
>=20
> >=20
> > >=20
> > > > > > > -Siwie
> > > > > > >=20
> > > > > > > > > > > > > Rejecting reset to 0
> > > > > > > > > > > > > prematurely causes correct MTU and link status un=
able to load
> > > > > > > > > > > > > for the very first config space access, rendering=
 issues like
> > > > > > > > > > > > > guest showing inaccurate MTU value, or failure to=
 reject
> > > > > > > > > > > > > out-of-range MTU.
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver =
for
> > > > > > > > > > > > > supported mlx5 devices")
> > > > > > > > > > > > > Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> > > > > > > > > > > > > ---
> > > > > > > > > > > > >  =C2=A0=C2=A0=C2=A0 drivers/vdpa/mlx5/net/mlx5_vn=
et.c | 15 +--------------
> > > > > > > > > > > > >  =C2=A0=C2=A0=C2=A0 1 file changed, 1 insertion(+=
), 14 deletions(-)
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > > > b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > > > index 7c1f789..540dd67 100644
> > > > > > > > > > > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > > > @@ -1490,14 +1490,6 @@ static u64
> > > > > > > > > > > > > mlx5_vdpa_get_features(struct vdpa_device *vdev)
> > > > > > > > > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 retur=
n mvdev->mlx_features;
> > > > > > > > > > > > >  =C2=A0=C2=A0=C2=A0 }
> > > > > > > > > > > > > -static int verify_min_features(struct mlx5_vdpa_=
dev *mvdev,
> > > > > > > > > > > > > u64 features)
> > > > > > > > > > > > > -{
> > > > > > > > > > > > > -=C2=A0=C2=A0=C2=A0 if (!(features & BIT_ULL(VIRT=
IO_F_ACCESS_PLATFORM)))
> > > > > > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 retur=
n -EOPNOTSUPP;
> > > > > > > > > > > > > -
> > > > > > > > > > > > > -=C2=A0=C2=A0=C2=A0 return 0;
> > > > > > > > > > > > > -}
> > > > > > > > > > > > > -
> > > > > > > > > > > > >  =C2=A0=C2=A0=C2=A0 static int setup_virtqueues(s=
truct mlx5_vdpa_net *ndev)
> > > > > > > > > > > > >  =C2=A0=C2=A0=C2=A0 {
> > > > > > > > > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int e=
rr;
> > > > > > > > > > > > > @@ -1558,18 +1550,13 @@ static int
> > > > > > > > > > > > > mlx5_vdpa_set_features(struct vdpa_device *vdev, =
u64
> > > > > > > > > > > > > features)
> > > > > > > > > > > > >  =C2=A0=C2=A0=C2=A0 {
> > > > > > > > > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struc=
t mlx5_vdpa_dev *mvdev =3D to_mvdev(vdev);
> > > > > > > > > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struc=
t mlx5_vdpa_net *ndev =3D to_mlx5_vdpa_ndev(mvdev);
> > > > > > > > > > > > > -=C2=A0=C2=A0=C2=A0 int err;
> > > > > > > > > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 print=
_features(mvdev, features, true);
> > > > > > > > > > > > > -=C2=A0=C2=A0=C2=A0 err =3D verify_min_features(m=
vdev, features);
> > > > > > > > > > > > > -=C2=A0=C2=A0=C2=A0 if (err)
> > > > > > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 retur=
n err;
> > > > > > > > > > > > > -
> > > > > > > > > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ndev-=
>mvdev.actual_features =3D features &
> > > > > > > > > > > > > ndev->mvdev.mlx_features;
> > > > > > > > > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ndev-=
>config.mtu =3D cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
> > > > > > > > > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ndev-=
>config.status |=3D cpu_to_mlx5vdpa16(mvdev,
> > > > > > > > > > > > > VIRTIO_NET_S_LINK_UP);
> > > > > > > > > > > > > -=C2=A0=C2=A0=C2=A0 return err;
> > > > > > > > > > > > > +=C2=A0=C2=A0=C2=A0 return 0;
> > > > > > > > > > > > >  =C2=A0=C2=A0=C2=A0 }
> > > > > > > > > > > > >  =C2=A0=C2=A0=C2=A0 static void mlx5_vdpa_set_con=
fig_cb(struct vdpa_device
> > > > > > > > > > > > > *vdev, struct vdpa_callback *cb)
>=20
