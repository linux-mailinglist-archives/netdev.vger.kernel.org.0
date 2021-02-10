Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A57316A75
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 16:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhBJPq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 10:46:29 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5515 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhBJPqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 10:46:24 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6023ffa20000>; Wed, 10 Feb 2021 07:45:38 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 15:45:37 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 10 Feb 2021 15:45:35 +0000
Date:   Wed, 10 Feb 2021 17:45:31 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
CC:     Jason Wang <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>
Subject: Re: [PATCH v1] vdpa/mlx5: Restore the hardware used index after
 change map
Message-ID: <20210210154531.GA70716@mtl-vdi-166.wap.labs.mlnx>
References: <f2206fa2-0ddc-1858-54e7-71614b142e46@redhat.com>
 <20210208063736.GA166546@mtl-vdi-166.wap.labs.mlnx>
 <0d592ed0-3cea-cfb0-9b7b-9d2755da3f12@redhat.com>
 <20210208100445.GA173340@mtl-vdi-166.wap.labs.mlnx>
 <379d79ff-c8b4-9acb-1ee4-16573b601973@redhat.com>
 <20210209061232.GC210455@mtl-vdi-166.wap.labs.mlnx>
 <411ff244-a698-a312-333a-4fdbeb3271d1@redhat.com>
 <a90dd931-43cc-e080-5886-064deb972b11@oracle.com>
 <b749313c-3a44-f6b2-f9b8-3aefa2c2d72c@redhat.com>
 <24d383db-e65c-82ff-9948-58ead3fc502b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <24d383db-e65c-82ff-9948-58ead3fc502b@oracle.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612971938; bh=Mvjar+MDzte0e7PXITZH5XjchctM+p7uThBWHgJoDAw=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=ZH8qc48T1Pc6FU++CW2R8WjvPDpKbqkAig7g12u1xoTQH2LO2bw+1hAShp7eHTFPn
         xOB4Vw26mC8rwm6llfulEMLw4KhdfqUHNKcae6mCSypuronsf+eDiPeS1yB0AOaHMT
         cMUDEwQIsXbQ3EgKdf17Ltdk7hOVk27Um+5zVLijq5OrFM5KVcKY9ZxYGqa5EcO/tY
         biHfGLc4ie0jrqzDfy1spu1ffQ0kqkSDu2qOl1RBHHPNiagH2DPec5wjnUx9l5n0pv
         iJ0mOTHIfekYwDXzsy2oezjUj1V9JRensEuHIaSA1U6NpsYsfnf1VN1RKVApkoJNu2
         0QkY/88VlMZ+A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 12:59:03AM -0800, Si-Wei Liu wrote:
>=20
>=20
> On 2/9/2021 7:53 PM, Jason Wang wrote:
> >=20
> > On 2021/2/10 =E4=B8=8A=E5=8D=8810:30, Si-Wei Liu wrote:
> > >=20
> > >=20
> > > On 2/8/2021 10:37 PM, Jason Wang wrote:
> > > >=20
> > > > On 2021/2/9 =E4=B8=8B=E5=8D=882:12, Eli Cohen wrote:
> > > > > On Tue, Feb 09, 2021 at 11:20:14AM +0800, Jason Wang wrote:
> > > > > > On 2021/2/8 =E4=B8=8B=E5=8D=886:04, Eli Cohen wrote:
> > > > > > > On Mon, Feb 08, 2021 at 05:04:27PM +0800, Jason Wang wrote:
> > > > > > > > On 2021/2/8 =E4=B8=8B=E5=8D=882:37, Eli Cohen wrote:
> > > > > > > > > On Mon, Feb 08, 2021 at 12:27:18PM +0800, Jason Wang wrot=
e:
> > > > > > > > > > On 2021/2/6 =E4=B8=8A=E5=8D=887:07, Si-Wei Liu wrote:
> > > > > > > > > > > On 2/3/2021 11:36 PM, Eli Cohen wrote:
> > > > > > > > > > > > When a change of memory map
> > > > > > > > > > > > occurs, the hardware resources
> > > > > > > > > > > > are destroyed
> > > > > > > > > > > > and then re-created again with
> > > > > > > > > > > > the new memory map. In such
> > > > > > > > > > > > case, we need
> > > > > > > > > > > > to restore the hardware
> > > > > > > > > > > > available and used indices. The
> > > > > > > > > > > > driver failed to
> > > > > > > > > > > > restore the used index which is added here.
> > > > > > > > > > > >=20
> > > > > > > > > > > > Also, since the driver also
> > > > > > > > > > > > fails to reset the available and
> > > > > > > > > > > > used
> > > > > > > > > > > > indices upon device reset, fix
> > > > > > > > > > > > this here to avoid regression
> > > > > > > > > > > > caused by
> > > > > > > > > > > > the fact that used index may not be zero upon devic=
e reset.
> > > > > > > > > > > >=20
> > > > > > > > > > > > Fixes: 1a86b377aa21 ("vdpa/mlx5:
> > > > > > > > > > > > Add VDPA driver for supported
> > > > > > > > > > > > mlx5
> > > > > > > > > > > > devices")
> > > > > > > > > > > > Signed-off-by: Eli Cohen<elic@nvidia.com>
> > > > > > > > > > > > ---
> > > > > > > > > > > > v0 -> v1:
> > > > > > > > > > > > Clear indices upon device reset
> > > > > > > > > > > >=20
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0 drivers/vdpa/mlx5/net/mlx5_vnet=
.c | 18 ++++++++++++++++++
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0 1 file changed, 18 insertions(+=
)
> > > > > > > > > > > >=20
> > > > > > > > > > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > > b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > > index 88dde3455bfd..b5fe6d2ad22f 100644
> > > > > > > > > > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > > @@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 dev=
ice_addr;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 dri=
ver_addr;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16 ava=
il_index;
> > > > > > > > > > > > +=C2=A0=C2=A0=C2=A0 u16 used_index;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool re=
ady;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct =
vdpa_callback cb;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool re=
store;
> > > > > > > > > > > > @@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 vir=
tq_id;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct =
mlx5_vdpa_net *ndev;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16 ava=
il_idx;
> > > > > > > > > > > > +=C2=A0=C2=A0=C2=A0 u16 used_idx;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int fw_=
state;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
/* keep last in the struct */
> > > > > > > > > > > > @@ -804,6 +806,7 @@ static int
> > > > > > > > > > > > create_virtqueue(struct
> > > > > > > > > > > > mlx5_vdpa_net
> > > > > > > > > > > > *ndev, struct mlx5_vdpa_virtque
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
obj_context =3D
> > > > > > > > > > > > MLX5_ADDR_OF(create_virtio_net_q_in,
> > > > > > > > > > > > in,
> > > > > > > > > > > > obj_context);
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> > > > > > > > > > > > MLX5_SET(virtio_net_q_object,
> > > > > > > > > > > > obj_context, hw_available_index,
> > > > > > > > > > > > mvq->avail_idx);
> > > > > > > > > > > > +=C2=A0=C2=A0=C2=A0 MLX5_SET(virtio_net_q_object, o=
bj_context, hw_used_index,
> > > > > > > > > > > > mvq->used_idx);
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MLX5_SE=
T(virtio_net_q_object, obj_context,
> > > > > > > > > > > > queue_feature_bit_mask_12_3,
> > > > > > > > > > > > get_features_12_3(ndev->mvdev.actual_features));
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vq_ctx =
=3D
> > > > > > > > > > > > MLX5_ADDR_OF(virtio_net_q_object,
> > > > > > > > > > > > obj_context,
> > > > > > > > > > > > virtio_q_context);
> > > > > > > > > > > > @@ -1022,6 +1025,7 @@ static int
> > > > > > > > > > > > connect_qps(struct mlx5_vdpa_net
> > > > > > > > > > > > *ndev, struct mlx5_vdpa_virtqueue *m
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0 struct mlx5_virtq_attr {
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 stat=
e;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16 ava=
ilable_index;
> > > > > > > > > > > > +=C2=A0=C2=A0=C2=A0 u16 used_index;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0 };
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0 =C2=A0 static int
> > > > > > > > > > > > query_virtqueue(struct
> > > > > > > > > > > > mlx5_vdpa_net *ndev, struct
> > > > > > > > > > > > mlx5_vdpa_virtqueue *mvq,
> > > > > > > > > > > > @@ -1052,6 +1056,7 @@ static int query_virtqueue(st=
ruct
> > > > > > > > > > > > mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueu
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memset(=
attr, 0, sizeof(*attr));
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 attr->s=
tate =3D
> > > > > > > > > > > > MLX5_GET(virtio_net_q_object,
> > > > > > > > > > > > obj_context, state);
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 attr->a=
vailable_index =3D MLX5_GET(virtio_net_q_object,
> > > > > > > > > > > > obj_context, hw_available_index);
> > > > > > > > > > > > +=C2=A0=C2=A0=C2=A0 attr->used_index =3D
> > > > > > > > > > > > MLX5_GET(virtio_net_q_object,
> > > > > > > > > > > > obj_context,
> > > > > > > > > > > > hw_used_index);
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(o=
ut);
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return =
0;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0 @@ -1535,6 +1540,16 @@
> > > > > > > > > > > > static void
> > > > > > > > > > > > teardown_virtqueues(struct
> > > > > > > > > > > > mlx5_vdpa_net *ndev)
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0 }
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0 +static void clear_virtqueues(s=
truct mlx5_vdpa_net *ndev)
> > > > > > > > > > > > +{
> > > > > > > > > > > > +=C2=A0=C2=A0=C2=A0 int i;
> > > > > > > > > > > > +
> > > > > > > > > > > > +=C2=A0=C2=A0=C2=A0 for (i =3D ndev->mvdev.max_vqs =
- 1; i >=3D 0; i--) {
> > > > > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ndev->v=
qs[i].avail_idx =3D 0;
> > > > > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ndev->v=
qs[i].used_idx =3D 0;
> > > > > > > > > > > > +=C2=A0=C2=A0=C2=A0 }
> > > > > > > > > > > > +}
> > > > > > > > > > > > +
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0 /* TODO: cross-endian support *=
/
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0 static inline bool
> > > > > > > > > > > > mlx5_vdpa_is_little_endian(struct
> > > > > > > > > > > > mlx5_vdpa_dev
> > > > > > > > > > > > *mvdev)
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0 {
> > > > > > > > > > > > @@ -1610,6 +1625,7 @@ static int save_channel_info(=
struct
> > > > > > > > > > > > mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 return err;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
ri->avail_index =3D attr.available_index;
> > > > > > > > > > > > +=C2=A0=C2=A0=C2=A0 ri->used_index =3D attr.used_in=
dex;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ri->rea=
dy =3D mvq->ready;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ri->num=
_ent =3D mvq->num_ent;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ri->des=
c_addr =3D mvq->desc_addr;
> > > > > > > > > > > > @@ -1654,6 +1670,7 @@ static void restore_channels_=
info(struct
> > > > > > > > > > > > mlx5_vdpa_net *ndev)
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 continue;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 mvq->avail_idx =3D ri->avail_index;
> > > > > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mvq->us=
ed_idx =3D ri->used_index;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 mvq->ready =3D ri->ready;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 mvq->num_ent =3D ri->num_ent;
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 mvq->desc_addr =3D ri->desc_addr;
> > > > > > > > > > > > @@ -1768,6 +1785,7 @@ static void mlx5_vdpa_set_sta=
tus(struct
> > > > > > > > > > > > vdpa_device *vdev, u8 status)
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!st=
atus) {
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0
> > > > > > > > > > > > mlx5_vdpa_info(mvdev,
> > > > > > > > > > > > "performing device reset\n");
> > > > > > > > > > > > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 teardown_driver(ndev);
> > > > > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clear_v=
irtqueues(ndev);
> > > > > > > > > > > The clearing looks fine at the first
> > > > > > > > > > > glance, as it aligns with the other
> > > > > > > > > > > state cleanups floating around at
> > > > > > > > > > > the same place. However, the thing
> > > > > > > > > > > is
> > > > > > > > > > > get_vq_state() is supposed to be
> > > > > > > > > > > called right after to get sync'ed
> > > > > > > > > > > with
> > > > > > > > > > > the latest internal avail_index from
> > > > > > > > > > > device while vq is stopped. The
> > > > > > > > > > > index was saved in the driver
> > > > > > > > > > > software at vq suspension, but
> > > > > > > > > > > before the
> > > > > > > > > > > virtq object is destroyed. We
> > > > > > > > > > > shouldn't clear the avail_index too
> > > > > > > > > > > early.
> > > > > > > > > > Good point.
> > > > > > > > > >=20
> > > > > > > > > > There's a limitation on the virtio spec
> > > > > > > > > > and vDPA framework that we can not
> > > > > > > > > > simply differ device suspending from device reset.
> > > > > > > > > >=20
> > > > > > > > > Are you talking about live migration where
> > > > > > > > > you reset the device but
> > > > > > > > > still want to know how far it progressed in
> > > > > > > > > order to continue from the
> > > > > > > > > same place in the new VM?
> > > > > > > > Yes. So if we want to support live migration at we need:
> > > > > > > >=20
> > > > > > > > in src node:
> > > > > > > > 1) suspend the device
> > > > > > > > 2) get last_avail_idx via get_vq_state()
> > > > > > > >=20
> > > > > > > > in the dst node:
> > > > > > > > 3) set last_avail_idx via set_vq_state()
> > > > > > > > 4) resume the device
> > > > > > > >=20
> > > > > > > > So you can see, step 2 requires the device/driver not to fo=
rget the
> > > > > > > > last_avail_idx.
> > > > > > > >=20
> > > > > > > Just to be sure, what really matters here is the
> > > > > > > used index. Becuase the
> > > > > > > vriqtueue itself is copied from the src VM to the
> > > > > > > dest VM. The available
> > > > > > > index is alreay there and we know the hardware reads it from =
there.
> > > > > >=20
> > > > > > So for "last_avail_idx" I meant the hardware internal
> > > > > > avail index. It's not
> > > > > > stored in the virtqueue so we must migrate it from src
> > > > > > to dest and set them
> > > > > > through set_vq_state(). Then in the destination, the virtqueue =
can be
> > > > > > restarted from that index.
> > > > > >=20
> > > > > Consider this case: driver posted buffers till avail index become=
s the
> > > > > value 50. Hardware is executing but made it till 20 when virtqueu=
e was
> > > > > suspended due to live migration - this is indicated by hardware u=
sed
> > > > > index equal 20.
> > > >=20
> > > >=20
> > > > So in this case the used index in the virtqueue should be 20?
> > > > Otherwise we need not sync used index itself but all the used
> > > > entries that is not committed to the used ring.
> > >=20
> > > In other word, for mlx5 vdpa there's no such internal last_avail_idx
> > > stuff maintained by the hardware, right?
> >=20
> >=20
> > For each device it should have one otherwise it won't work correctly
> > during stop/resume. See the codes mlx5_vdpa_get_vq_state() which calls
> > query_virtqueue() that build commands to query "last_avail_idx" from th=
e
> > hardware:
> >=20
> > =C2=A0=C2=A0=C2=A0 MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, opcode,
> > MLX5_CMD_OP_QUERY_GENERAL_OBJECT);
> > =C2=A0=C2=A0=C2=A0 MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_type,
> > MLX5_OBJ_TYPE_VIRTIO_NET_Q);
> > =C2=A0=C2=A0=C2=A0 MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_id, mv=
q->virtq_id);
> > =C2=A0=C2=A0=C2=A0 MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev-=
>mvdev.res.uid);
> > =C2=A0=C2=A0=C2=A0 err =3D mlx5_cmd_exec(ndev->mvdev.mdev, in, sizeof(i=
n), out, outlen);
> > =C2=A0=C2=A0=C2=A0 if (err)
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 goto err_cmd;
> >=20
> > =C2=A0=C2=A0=C2=A0 obj_context =3D MLX5_ADDR_OF(query_virtio_net_q_out,=
 out, obj_context);
> > =C2=A0=C2=A0=C2=A0 memset(attr, 0, sizeof(*attr));
> > =C2=A0=C2=A0=C2=A0 attr->state =3D MLX5_GET(virtio_net_q_object, obj_co=
ntext, state);
> > =C2=A0=C2=A0=C2=A0 attr->available_index =3D MLX5_GET(virtio_net_q_obje=
ct, obj_context,
> > hw_available_index);
> >=20
> Eli should be able to correct me, but this hw_available_index might just =
be
> a cached value of virtqueue avail_index in the memory from the most recen=
t
> sync. I doubt it's the one you talked about in software implementation. I=
f I
> understand Eli correctly, hardware will always reload the latest avail_in=
dex
> from memory whenever it's being sync'ed again.

That's my understanding too. I am still trying to get confirmation from
hardware guys. Will send when I have them.

>=20
> <quote>
> The hardware always goes to read the available index from memory. The
> requirement to configure it when creating a new object is still a
> requirement defined by the interface so I must not violate interface
> requirments.
> </quote>
>=20
> If the hardware does everything perfectly that is able to flush pending
> requests, update descriptors, rings plus used indices all at once before =
the
> suspension, there's no need for hardware to maintain a separate internal
> index than the h/w used_index. The hardware can get started from the save=
d
> used_index upon resuming. I view this is of (hardware) implementation
> choices and thought it does not violate the virtio spec?
>=20
>=20
> >=20
> >=20
> >=20
> > > And the used_idx in the virtqueue is always in sync with the
> > > hardware used_index, and hardware is supposed to commit pending used
> > > buffers to the ring while bumping up the hardware used_index (and
> > > also committed to memory) altogether prior to suspension, is my
> > > understanding correct here? Double checking if this is the expected
> > > semantics of what
> > > modify_virtqueue(MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND) should
> > > achieve.
> > >=20

That's my understanding too.

> > > If the above is true, then it looks to me for mlx5 vdpa we should
> > > really return h/w used_idx rather than the last_avail_idx through
> > > get_vq_state(), in order to reconstruct the virt queue state post
> > > live migration. For the set_map case, the internal last_avail_idx
> > > really doesn't matter, although both indices are saved and restored
> > > transparently as-is.
> >=20

Right, that's what I think too. In fact, I discussed that already with
Jason over the phone yesterday. The conclusion was since the only thing
that matters for a network device is the used index, I tried to return
the hardware used index in get_vq_state (instead of hardware available
index) and restore the value I get in set_vq_state into the hardware
used index. I am still not done with this experiment but will update.

> >=20
> > Right, a subtle thing here is that: for the device that might have can'=
t
> > not complete all virtqueue requests during vq suspending, the
> > "last_avail_idx" might not be equal to the hardware used_idx. Thing
> > might be true for the storage devices that needs to connect to a remote
> > backend. But this is not the case of networking device, so
> > last_avail_idx should be equal to hardware used_idx here.
> Eli, since it's your hardware, does it work this way? i.e. does the firmw=
are
> interface see a case where virtqueue requests can't be completed before
> suspending vq?
>=20
This can happen regardless of what effort firmware does to complete all
pending requests. An example is the hot plugging of memory. The set map
call is called and mlx5 vdpa driver tears down the vitqueue objects
while the guest driver can still be posting requests to the virtqueue.
So we find ourselves in a situation and used index is behine the
available index.

> > But using the "last_avail_idx" or hardware avail_idx should always be
> > better in this case since it's guaranteed to correct and will have less
> > confusion. We use this convention in other types of vhost backends
> > (vhost-kernel, vhost-user).
> >=20
> > So looking at mlx5_set_vq_state(), it probably won't work since it
> > doesn't not set either hardware avail_idx or hardware used_idx:
> The saved mvq->avail_idx will be used to recreate hardware virtq object a=
nd
> the used index in create_virtqueue(), once status DRIVER_OK is set. I
> suspect we should pass the index to mvq->used_idx in
> mlx5_vdpa_set_vq_state() below instead.
>=20
Right, that's what I am checking but still no final conclusions. I need
to harness hardware guy to provide me with clear answers.
>=20
> Thanks,
> -Siwei
> >=20
> > static int mlx5_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0 =C2=A0 const struct vdpa_vq_state *state)
> > {
> > =C2=A0=C2=A0=C2=A0 struct mlx5_vdpa_dev *mvdev =3D to_mvdev(vdev);
> > =C2=A0=C2=A0=C2=A0 struct mlx5_vdpa_net *ndev =3D to_mlx5_vdpa_ndev(mvd=
ev);
> > =C2=A0=C2=A0=C2=A0 struct mlx5_vdpa_virtqueue *mvq =3D &ndev->vqs[idx];
> >=20
> > =C2=A0=C2=A0=C2=A0 if (mvq->fw_state =3D=3D MLX5_VIRTIO_NET_Q_OBJECT_ST=
ATE_RDY) {
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 mlx5_vdpa_warn(mvdev, "can't modi=
fy available index\n");
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return -EINVAL;
> > =C2=A0=C2=A0=C2=A0 }
> >=20
> > =C2=A0=C2=A0=C2=A0 mvq->avail_idx =3D state->avail_index;
> > =C2=A0=C2=A0=C2=A0 return 0;
> > }
> >=20
> > Depends on the hardware, we should either set hardware used_idx or
> > hardware avail_idx here.
> >=20
> > I think we need to clarify how device is supposed to work in the virtio
> > spec.
> >=20
> > Thanks
> >=20
> >=20
> > >=20
> > > -Siwei
> > >=20
> > > >=20
> > > >=20
> > > > > Now the vritqueue is copied to the new VM and the
> > > > > hardware now has to continue execution from index 20. We need to =
tell
> > > > > the hardware via configuring the last used_index.
> > > >=20
> > > >=20
> > > > If the hardware can not sync the index from the virtqueue, the
> > > > driver can do the synchronization by make the last_used_idx
> > > > equals to used index in the virtqueue.
> > > >=20
> > > > Thanks
> > > >=20
> > > >=20
> > > > > =C2=A0 So why don't we
> > > > > restore the used index?
> > > > >=20
> > > > > > > So it puzzles me why is set_vq_state() we do not
> > > > > > > communicate the saved
> > > > > > > used index.
> > > > > >=20
> > > > > > We don't do that since:
> > > > > >=20
> > > > > > 1) if the hardware can sync its internal used index from
> > > > > > the virtqueue
> > > > > > during device, then we don't need it
> > > > > > 2) if the hardware can not sync its internal used index,
> > > > > > the driver (e.g as
> > > > > > you did here) can do that.
> > > > > >=20
> > > > > > But there's no way for the hardware to deduce the
> > > > > > internal avail index from
> > > > > > the virtqueue, that's why avail index is sycned.
> > > > > >=20
> > > > > > Thanks
> > > > > >=20
> > > > > >=20
> > > >=20
> > >=20
> >=20
>=20
