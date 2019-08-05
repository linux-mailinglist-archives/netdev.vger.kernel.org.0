Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B01381298
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 08:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfHEGzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 02:55:48 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40929 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbfHEGzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 02:55:48 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so77600679eds.7;
        Sun, 04 Aug 2019 23:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2vcIiINY4WBP+S4p7ZvCljxe/AGpBFsXIl5B5dC7+jY=;
        b=IGZvj4IgmpHw+kKQTtY8eeb5E9cDO3t0ezYt8tkNMicugTeGnGIQ7+XxTUdxszd8qU
         tm0/jRpIWihYTtvPPiWRHkiXFnslsPz1U67otEH+hSX2gDtw38tvjxjKw5jXUVcAjbji
         Sef3EjUl9wORFtI68cJqtqXCtFhbVd/9o40ndI8II/QaM2ZbHB/ovA1T/1GaxbBLovhZ
         mZYpjg3DTgTBOsTyoboXlxBwe8Bw4f5hzg6Mk4zpTsbzrBMD9vkv3wGQDNLoNVRmZQA2
         1YnwyBDVkjAJADw/cf4V3UdeDkSn/7+P2BCV9sPKO8aKKZVwfYO616s2KRVRpi9zCh2a
         6hjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2vcIiINY4WBP+S4p7ZvCljxe/AGpBFsXIl5B5dC7+jY=;
        b=cbnsYt/4M/WVyV/1eKUhBXBDqXrDo0Vh2mS3eevPaQOEfoaNgb1pEqc2vYrCyzM5lU
         KBSK73B4sSrP4o8Yuwy69+kzXxwaHPqPGKg53U/ZTO+ERa/HL8UXLCdd7woDEAyaQzcA
         +vqyeNedM0r5a2X5cqFHk9r3uGlcTlBh6P3NpsUSH+0+iM3NGNfrjTshJjqHJFB8E8z7
         9LmvblKMNb2kjbk4SIGo++vbq+SltIbVPq01UOJ28YcU6dF2kFtI5m2YQbdVVuNoGMJa
         JmLqfkaGW3/oiL9J895mzR7SkV8GuKQm0b661OxGi7ofZ89QELtBBP0rL8XqKpIXSyJa
         NGBg==
X-Gm-Message-State: APjAAAV5BZbLVlG5RVdErLWZ3RMr1JKu72aR3YYoBRNuGhiAblo0ZzSA
        /i3c4/iq0IN+nOt1KHvTumwo9gAnJJDeHe6nHqfAb+MIvRs=
X-Google-Smtp-Source: APXvYqzXx3p2Pz7Q7wMxZKubkTIW6zu3x3Sr+7578oy+fMgP1ypqnD0LxU8UEDkWZatK5ntlXt5G6vS3t/3Q9WQXIx8=
X-Received: by 2002:aa7:cf8e:: with SMTP id z14mr131881877edx.40.1564988145755;
 Sun, 04 Aug 2019 23:55:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190802164828.20243-1-hslester96@gmail.com> <20190804125858.GJ4832@mtr-leonro.mtl.com>
 <CANhBUQ2H5MU0m2xM0AkJGPf7+MJBZ3Eq5rR0kgeOoKRi4q1j6Q@mail.gmail.com> <20190805061320.GN4832@mtr-leonro.mtl.com>
In-Reply-To: <20190805061320.GN4832@mtr-leonro.mtl.com>
From:   Chuhong Yuan <hslester96@gmail.com>
Date:   Mon, 5 Aug 2019 14:55:34 +0800
Message-ID: <CANhBUQ0tUTXQKq__zvhNCUxXTFfDyr2xKF+Cwupod9xmvSrw2A@mail.gmail.com>
Subject: Re: [PATCH v2] net/mlx5e: Use refcount_t for refcount
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 5, 2019 at 2:13 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Sun, Aug 04, 2019 at 10:44:47PM +0800, Chuhong Yuan wrote:
> > On Sun, Aug 4, 2019 at 8:59 PM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Sat, Aug 03, 2019 at 12:48:28AM +0800, Chuhong Yuan wrote:
> > > > refcount_t is better for reference counters since its
> > > > implementation can prevent overflows.
> > > > So convert atomic_t ref counters to refcount_t.
> > >
> > > I'm not thrilled to see those automatic conversion patches, especially
> > > for flows which can't overflow. There is nothing wrong in using atomic_t
> > > type of variable, do you have in mind flow which will cause to overflow?
> > >
> > > Thanks
> >
> > I have to say that these patches are not done automatically...
> > Only the detection of problems is done by a script.
> > All conversions are done manually.
>
> Even worse, you need to audit usage of atomic_t and replace there
> it can overflow.
>
> >
> > I am not sure whether the flow can cause an overflow.
>
> It can't.
>
> > But I think it is hard to ensure that a data path is impossible
> > to have problems in any cases including being attacked.
>
> It is not data path, and I doubt that such conversion will be allowed
> in data paths without proving that no performance regression is introduced.
>>
>
> > So I think it is better to do this minor revision to prevent
> > potential risk, just like we have done in mlx5/core/cq.c.
>
> mlx5/core/cq.c is a different beast, refcount there means actual users
> of CQ which are limited in SW, so in theory, they have potential
> to be overflown.
>
> It is not the case here, there your are adding new port.
> There is nothing wrong with atomic_t.
>

Thanks for your explanation!
I will pay attention to this point in similar cases.
But it seems that the semantic of refcount is not always as clear as here...

Regards,
Chuhong


> Thanks
>
> >
> > Regards,
> > Chuhong
> >
> > > >
> > > > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> > > > ---
> > > > Changes in v2:
> > > >   - Add #include.
> > > >
> > > >  drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c | 9 +++++----
> > > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
> > > > index b9d4f4e19ff9..148b55c3db7a 100644
> > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
> > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
> > > > @@ -32,6 +32,7 @@
> > > >
> > > >  #include <linux/kernel.h>
> > > >  #include <linux/module.h>
> > > > +#include <linux/refcount.h>
> > > >  #include <linux/mlx5/driver.h>
> > > >  #include <net/vxlan.h>
> > > >  #include "mlx5_core.h"
> > > > @@ -48,7 +49,7 @@ struct mlx5_vxlan {
> > > >
> > > >  struct mlx5_vxlan_port {
> > > >       struct hlist_node hlist;
> > > > -     atomic_t refcount;
> > > > +     refcount_t refcount;
> > > >       u16 udp_port;
> > > >  };
> > > >
> > > > @@ -113,7 +114,7 @@ int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
> > > >
> > > >       vxlanp = mlx5_vxlan_lookup_port(vxlan, port);
> > > >       if (vxlanp) {
> > > > -             atomic_inc(&vxlanp->refcount);
> > > > +             refcount_inc(&vxlanp->refcount);
> > > >               return 0;
> > > >       }
> > > >
> > > > @@ -137,7 +138,7 @@ int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
> > > >       }
> > > >
> > > >       vxlanp->udp_port = port;
> > > > -     atomic_set(&vxlanp->refcount, 1);
> > > > +     refcount_set(&vxlanp->refcount, 1);
> > > >
> > > >       spin_lock_bh(&vxlan->lock);
> > > >       hash_add(vxlan->htable, &vxlanp->hlist, port);
> > > > @@ -170,7 +171,7 @@ int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port)
> > > >               goto out_unlock;
> > > >       }
> > > >
> > > > -     if (atomic_dec_and_test(&vxlanp->refcount)) {
> > > > +     if (refcount_dec_and_test(&vxlanp->refcount)) {
> > > >               hash_del(&vxlanp->hlist);
> > > >               remove = true;
> > > >       }
> > > > --
> > > > 2.20.1
> > > >
