Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4816567AB
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 08:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiL0HGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 02:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiL0HF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 02:05:58 -0500
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8A42613
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:05:57 -0800 (PST)
Received: by mail-vk1-xa2d.google.com with SMTP id f24so5747490vkl.9
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hUsyUUmMozp6gA+1F7mHGF+OouRftrba5gaMqnw0QhI=;
        b=aXPAJh/MEPBhD++SAqtA63xzbd6oX4B5oG2AwDIx4fleuGuJmXaoqH/bgr7X8dghzI
         XEUuZHhiX+DA5yrWLx0UyxWq/M01zHOg7lNfqYBAmtY4qs8ORwzIEfby+OCzlxmvNXql
         fV6OesH0xHRyqfgnxGrZBX5zUuzuJW3PCxMnpGagIv4AHbZFqy8Bw1osVp6RYs5Q8iOb
         xANhX9qfekXeri6zDIvkEIJjYINdcRWRvfCNGSkXapE8RiE4vlfT6rgGmTngfy2cyEZK
         U3kYg93PRZ868/ADSlQ13FLZEs5QWY73pqnvizBVwu7ORzee9LnjYgcZLmEBtTVrNb7T
         3rXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hUsyUUmMozp6gA+1F7mHGF+OouRftrba5gaMqnw0QhI=;
        b=d5TgYys7o3HluHFOQwWtf3dFWzy0iYni4dcwbEs5kUeFQ5SUx2i6rPrxEIYWWPC3zo
         13Xbhlv3nss77jdRRgFeHLampBgjn0TD+k+YGN+prf4UN9+AxHEEp9qEM/P2IBpBzV+f
         vgzHX8WQ4MR4OFTg7Vm2M+BLtOFDuUK3bkBHcVptRJ1ObqAn1Zehj6EonWAQF09XQ9Ko
         sUQUZ17QOj19jfYX1crFqekytRHFFgcUcRSTHftyFt2FWakbW1Hv8V1tJQixTaZGDT05
         jfsHDpMh7qIiT5wH5bBQil8eWeHKPYTT/PJIze2tnqOiju2qGTjL52MmkWuMaDC0FfLN
         4oaQ==
X-Gm-Message-State: AFqh2ko653pD3oxWv9scnVqx3vH3cnjAkDxxIQBcIBzUj2qsimrL3Fay
        SiKJ2gdLK5YPA6KU3dGR2SwFVqGzf3RL4a2cyAMCtg==
X-Google-Smtp-Source: AMrXdXtdZ2kxTy0QQcocQCLBwUESrhZ0293ip68FkcMfW4Y2gqSJIY/eJ6fp5Zr79M/2E0F8MHtwiadWx1ANQzDvw9I=
X-Received: by 2002:a05:6122:198f:b0:3d5:27c3:854d with SMTP id
 bv15-20020a056122198f00b003d527c3854dmr1796257vkb.20.1672124756482; Mon, 26
 Dec 2022 23:05:56 -0800 (PST)
MIME-Version: 1.0
References: <20221227022528.609839-1-mie@igel.co.jp> <20221227022528.609839-3-mie@igel.co.jp>
 <CACGkMEtAaYpuZtS0gx_m931nFzcvqSNK9BhvUZH_tZXTzjgQCg@mail.gmail.com>
In-Reply-To: <CACGkMEtAaYpuZtS0gx_m931nFzcvqSNK9BhvUZH_tZXTzjgQCg@mail.gmail.com>
From:   Shunsuke Mie <mie@igel.co.jp>
Date:   Tue, 27 Dec 2022 16:05:45 +0900
Message-ID: <CANXvt5rfXDYa0nLzKW5-Q-hjhw-19npXVneqBO1TcsariU6rWg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] vringh: remove vringh_iov and unite to vringh_kiov
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022=E5=B9=B412=E6=9C=8827=E6=97=A5(=E7=81=AB) 15:04 Jason Wang <jasowang@r=
edhat.com>:
>
> On Tue, Dec 27, 2022 at 10:25 AM Shunsuke Mie <mie@igel.co.jp> wrote:
> >
> > struct vringh_iov is defined to hold userland addresses. However, to us=
e
> > common function, __vring_iov, finally the vringh_iov converts to the
> > vringh_kiov with simple cast. It includes compile time check code to ma=
ke
> > sure it can be cast correctly.
> >
> > To simplify the code, this patch removes the struct vringh_iov and unif=
ies
> > APIs to struct vringh_kiov.
> >
> > Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
>
> While at this, I wonder if we need to go further, that is, switch to
> using an iov iterator instead of a vringh customized one.
I didn't see the iov iterator yet, thank you for informing me.
Is that iov_iter? https://lwn.net/Articles/625077/
> Thanks
>
> > ---
> >  drivers/vhost/vringh.c | 32 ++++++------------------------
> >  include/linux/vringh.h | 45 ++++--------------------------------------
> >  2 files changed, 10 insertions(+), 67 deletions(-)
> >
> > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > index 828c29306565..aa3cd27d2384 100644
> > --- a/drivers/vhost/vringh.c
> > +++ b/drivers/vhost/vringh.c
> > @@ -691,8 +691,8 @@ EXPORT_SYMBOL(vringh_init_user);
> >   * calling vringh_iov_cleanup() to release the memory, even on error!
> >   */
> >  int vringh_getdesc_user(struct vringh *vrh,
> > -                       struct vringh_iov *riov,
> > -                       struct vringh_iov *wiov,
> > +                       struct vringh_kiov *riov,
> > +                       struct vringh_kiov *wiov,
> >                         bool (*getrange)(struct vringh *vrh,
> >                                          u64 addr, struct vringh_range =
*r),
> >                         u16 *head)
> > @@ -708,26 +708,6 @@ int vringh_getdesc_user(struct vringh *vrh,
> >         if (err =3D=3D vrh->vring.num)
> >                 return 0;
> >
> > -       /* We need the layouts to be the identical for this to work */
> > -       BUILD_BUG_ON(sizeof(struct vringh_kiov) !=3D sizeof(struct vrin=
gh_iov));
> > -       BUILD_BUG_ON(offsetof(struct vringh_kiov, iov) !=3D
> > -                    offsetof(struct vringh_iov, iov));
> > -       BUILD_BUG_ON(offsetof(struct vringh_kiov, i) !=3D
> > -                    offsetof(struct vringh_iov, i));
> > -       BUILD_BUG_ON(offsetof(struct vringh_kiov, used) !=3D
> > -                    offsetof(struct vringh_iov, used));
> > -       BUILD_BUG_ON(offsetof(struct vringh_kiov, max_num) !=3D
> > -                    offsetof(struct vringh_iov, max_num));
> > -       BUILD_BUG_ON(sizeof(struct iovec) !=3D sizeof(struct kvec));
> > -       BUILD_BUG_ON(offsetof(struct iovec, iov_base) !=3D
> > -                    offsetof(struct kvec, iov_base));
> > -       BUILD_BUG_ON(offsetof(struct iovec, iov_len) !=3D
> > -                    offsetof(struct kvec, iov_len));
> > -       BUILD_BUG_ON(sizeof(((struct iovec *)NULL)->iov_base)
> > -                    !=3D sizeof(((struct kvec *)NULL)->iov_base));
> > -       BUILD_BUG_ON(sizeof(((struct iovec *)NULL)->iov_len)
> > -                    !=3D sizeof(((struct kvec *)NULL)->iov_len));
> > -
> >         *head =3D err;
> >         err =3D __vringh_iov(vrh, *head, (struct vringh_kiov *)riov,
> >                            (struct vringh_kiov *)wiov,
> > @@ -740,14 +720,14 @@ int vringh_getdesc_user(struct vringh *vrh,
> >  EXPORT_SYMBOL(vringh_getdesc_user);
> >
> >  /**
> > - * vringh_iov_pull_user - copy bytes from vring_iov.
> > + * vringh_iov_pull_user - copy bytes from vring_kiov.
> >   * @riov: the riov as passed to vringh_getdesc_user() (updated as we c=
onsume)
> >   * @dst: the place to copy.
> >   * @len: the maximum length to copy.
> >   *
> >   * Returns the bytes copied <=3D len or a negative errno.
> >   */
> > -ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, size_=
t len)
> > +ssize_t vringh_iov_pull_user(struct vringh_kiov *riov, void *dst, size=
_t len)
> >  {
> >         return vringh_iov_xfer(NULL, (struct vringh_kiov *)riov,
> >                                dst, len, xfer_from_user);
> > @@ -755,14 +735,14 @@ ssize_t vringh_iov_pull_user(struct vringh_iov *r=
iov, void *dst, size_t len)
> >  EXPORT_SYMBOL(vringh_iov_pull_user);
> >
> >  /**
> > - * vringh_iov_push_user - copy bytes into vring_iov.
> > + * vringh_iov_push_user - copy bytes into vring_kiov.
> >   * @wiov: the wiov as passed to vringh_getdesc_user() (updated as we c=
onsume)
> >   * @src: the place to copy from.
> >   * @len: the maximum length to copy.
> >   *
> >   * Returns the bytes copied <=3D len or a negative errno.
> >   */
> > -ssize_t vringh_iov_push_user(struct vringh_iov *wiov,
> > +ssize_t vringh_iov_push_user(struct vringh_kiov *wiov,
> >                              const void *src, size_t len)
> >  {
> >         return vringh_iov_xfer(NULL, (struct vringh_kiov *)wiov,
> > diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> > index 1991a02c6431..733d948e8123 100644
> > --- a/include/linux/vringh.h
> > +++ b/include/linux/vringh.h
> > @@ -79,18 +79,6 @@ struct vringh_range {
> >         u64 offset;
> >  };
> >
> > -/**
> > - * struct vringh_iov - iovec mangler.
> > - *
> > - * Mangles iovec in place, and restores it.
> > - * Remaining data is iov + i, of used - i elements.
> > - */
> > -struct vringh_iov {
> > -       struct iovec *iov;
> > -       size_t consumed; /* Within iov[i] */
> > -       unsigned i, used, max_num;
> > -};
> > -
> >  /**
> >   * struct vringh_kiov - kvec mangler.
> >   *
> > @@ -113,44 +101,19 @@ int vringh_init_user(struct vringh *vrh, u64 feat=
ures,
> >                      vring_avail_t __user *avail,
> >                      vring_used_t __user *used);
> >
> > -static inline void vringh_iov_init(struct vringh_iov *iov,
> > -                                  struct iovec *iovec, unsigned num)
> > -{
> > -       iov->used =3D iov->i =3D 0;
> > -       iov->consumed =3D 0;
> > -       iov->max_num =3D num;
> > -       iov->iov =3D iovec;
> > -}
> > -
> > -static inline void vringh_iov_reset(struct vringh_iov *iov)
> > -{
> > -       iov->iov[iov->i].iov_len +=3D iov->consumed;
> > -       iov->iov[iov->i].iov_base -=3D iov->consumed;
> > -       iov->consumed =3D 0;
> > -       iov->i =3D 0;
> > -}
> > -
> > -static inline void vringh_iov_cleanup(struct vringh_iov *iov)
> > -{
> > -       if (iov->max_num & VRINGH_IOV_ALLOCATED)
> > -               kfree(iov->iov);
> > -       iov->max_num =3D iov->used =3D iov->i =3D iov->consumed =3D 0;
> > -       iov->iov =3D NULL;
> > -}
> > -
> >  /* Convert a descriptor into iovecs. */
> >  int vringh_getdesc_user(struct vringh *vrh,
> > -                       struct vringh_iov *riov,
> > -                       struct vringh_iov *wiov,
> > +                       struct vringh_kiov *riov,
> > +                       struct vringh_kiov *wiov,
> >                         bool (*getrange)(struct vringh *vrh,
> >                                          u64 addr, struct vringh_range =
*r),
> >                         u16 *head);
> >
> >  /* Copy bytes from readable vsg, consuming it (and incrementing wiov->=
i). */
> > -ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, size_=
t len);
> > +ssize_t vringh_iov_pull_user(struct vringh_kiov *riov, void *dst, size=
_t len);
> >
> >  /* Copy bytes into writable vsg, consuming it (and incrementing wiov->=
i). */
> > -ssize_t vringh_iov_push_user(struct vringh_iov *wiov,
> > +ssize_t vringh_iov_push_user(struct vringh_kiov *wiov,
> >                              const void *src, size_t len);
> >
> >  /* Mark a descriptor as used. */
> > --
> > 2.25.1
> >
>
Best,
Shunsuke
