Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39BA932A32E
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382056AbhCBIsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:48:36 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17917 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347514AbhCBF3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 00:29:36 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603dcbbf0009>; Mon, 01 Mar 2021 21:23:11 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 2 Mar 2021 05:23:09 +0000
Date:   Tue, 2 Mar 2021 07:23:06 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>, <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] vdpa/mlx5: Fix wrong use of bit numbers
Message-ID: <20210302052306.GA227464@mtl-vdi-166.wap.labs.mlnx>
References: <20210301062817.39331-1-elic@nvidia.com>
 <959916f2-5fc9-bdb4-31ca-632fe0d98979@redhat.com>
 <20210301103214-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210301103214-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614662591; bh=wBB6MQw+SyLdjXxml/9vKVN7x4w0HR+GxTmyhn7I07s=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=MwbEyNcOtell+6MV1oUSSBHgilUfxVGPpik8njqbSYxQi2TAsjTOF/VPHDZ+1L9Gs
         fBQ87O/2oGRs6twXJePEiOe/E9Cl1/y9ttnuCOGp9hqVlC8gYKEsL6EqvaHLHGbKFS
         IsmNB4N5tAv5DAnGG8D0BGF7aPfXzt+jNzRJ9w5fRocQIC2Qpa5/sJsq3EN6ukhVOK
         7q81QIzIv4SnXx8QuapwlY+YsIpgwUTreR8CkH2/s0pLO7YI9KcXlAzUYf1UHkZCS+
         ifaF595go020tUNXn0qxDHcmWGorVR52oMghdbp720oH5KFoFGZ5okajDx6TYu4DAd
         0YeVslCVZ+8Ug==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 10:33:14AM -0500, Michael S. Tsirkin wrote:
> On Mon, Mar 01, 2021 at 03:52:45PM +0800, Jason Wang wrote:
> >=20
> > On 2021/3/1 2:28 =E4=B8=8B=E5=8D=88, Eli Cohen wrote:
> > > VIRTIO_F_VERSION_1 is a bit number. Use BIT_ULL() with mask
> > > conditionals.
> > >=20
> > > Also, in mlx5_vdpa_is_little_endian() use BIT_ULL for consistency wit=
h
> > > the rest of the code.
> > >=20
> > > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 d=
evices")
> > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> >=20
> >=20
> > Acked-by: Jason Wang <jasowang@redhat.com>
>=20
> And CC stable I guess?

Is this a question or a request? :-)

>=20
> >=20
> > > ---
> > >   drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/ne=
t/mlx5_vnet.c
> > > index dc7031132fff..7d21b857a94a 100644
> > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > @@ -821,7 +821,7 @@ static int create_virtqueue(struct mlx5_vdpa_net =
*ndev, struct mlx5_vdpa_virtque
> > >   	MLX5_SET(virtio_q, vq_ctx, event_qpn_or_msix, mvq->fwqp.mqp.qpn);
> > >   	MLX5_SET(virtio_q, vq_ctx, queue_size, mvq->num_ent);
> > >   	MLX5_SET(virtio_q, vq_ctx, virtio_version_1_0,
> > > -		 !!(ndev->mvdev.actual_features & VIRTIO_F_VERSION_1));
> > > +		 !!(ndev->mvdev.actual_features & BIT_ULL(VIRTIO_F_VERSION_1)));
> > >   	MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
> > >   	MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr);
> > >   	MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
> > > @@ -1578,7 +1578,7 @@ static void teardown_virtqueues(struct mlx5_vdp=
a_net *ndev)
> > >   static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev =
*mvdev)
> > >   {
> > >   	return virtio_legacy_is_little_endian() ||
> > > -		(mvdev->actual_features & (1ULL << VIRTIO_F_VERSION_1));
> > > +		(mvdev->actual_features & BIT_ULL(VIRTIO_F_VERSION_1));
> > >   }
> > >   static __virtio16 cpu_to_mlx5vdpa16(struct mlx5_vdpa_dev *mvdev, u1=
6 val)
>=20
