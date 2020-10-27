Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C98D29C500
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 19:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1824040AbgJ0SCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 14:02:00 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36583 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1823727AbgJ0SA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 14:00:59 -0400
Received: by mail-io1-f68.google.com with SMTP id u19so2533427ion.3
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 11:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ed3AIF7qFllVghkuMSpgY+e4IbkAvQfdceeKpQaUdxk=;
        b=UoiZn2ejgC7wXGBMzC5P1HZYY0nl6Wa3KE0/4S9Ciuieo7WYMXpDS0Iaqpc4XiAPdO
         qMSPbldaS4qotDJxt10RTbnG9MLtwWkVWivTQZrOtp1ibfKEiirPfM/hcYKscWcE5G9+
         hdA0OqGIyHCG+6wpH2Tcj5TcpWPTkljgGKnbGOzRrgHXz7X+jipA9gLH6g8zN/Jx0l4s
         /OKkLzKstGxFD2CYIuU1B33wI1K0Ml8+qKW5x8c0LoZzpt+1zSKoX87G79JYtOSZ/rG6
         gJ+d5QJ1DFf7m/UdqRG6MK7XEwKpEIVQ7cBBbC41y7jJlAMtCPK8jhzSkqrf6tO37h92
         JCSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ed3AIF7qFllVghkuMSpgY+e4IbkAvQfdceeKpQaUdxk=;
        b=NrZEIipYZkMx9BKnxXgapJ58dfEoNVpOWHnMOLkTFja2MT+wvmEcCEiv8q1DYR9lFI
         HRhkxjZga6Tb3PQqmqBnIxprrgcaqzALbf3vEhl9nvtdutx2/a+sAKmXxbfITWJUn60U
         Y6vKcdIp6qLwMtCkY6Eta4xNb12yCmWSR8qXAJsxAWa4zIormj+EvqOL6wqYFG0nfyPC
         h2OXA9R5gpvJeCogAxGWl1Bf+lsrpuQxzgbGZAdTRWq1rChw5NY+8BcvdOiC7/ezIGHM
         EqMJ4NMCjNUd0u+ALLirYYTiZ2h7JdflrC7slIDe0sJCcsLiretLr1dnUvCVhstbm+sB
         MhFw==
X-Gm-Message-State: AOAM5339iAhMEAJAXIr5NBrL0/2CAnFcYj9hsMG0Sz+ZLQIJLbcaNkd5
        gk7eYuXZEGK+oEIt6gMnhsh0+qOUcDlrqnNuExq9rA==
X-Google-Smtp-Source: ABdhPJwN08N0ZyzhoITVdnvB4ryeaKood+3vq0iIUYgCE2JJfuXumCj2bIDB2qD60OdiaWwDhRbGH3iAIo+DCc+ziro=
X-Received: by 2002:a6b:f401:: with SMTP id i1mr3323522iog.130.1603821657825;
 Tue, 27 Oct 2020 11:00:57 -0700 (PDT)
MIME-Version: 1.0
References: <20201027121725.24660-1-brgl@bgdev.pl> <20201027121725.24660-4-brgl@bgdev.pl>
 <20201027112607-mutt-send-email-mst@kernel.org> <685d850347a1191bba8ba7766fc409b140d18f03.camel@perches.com>
 <CAMpxmJU0C84DjPmqmWvPgv0zwgGLhkpKLRDuKkZHAa=wi+LvBA@mail.gmail.com> <2767969b94fd66db1fb0fc13b5783ae65b7deb2f.camel@perches.com>
In-Reply-To: <2767969b94fd66db1fb0fc13b5783ae65b7deb2f.camel@perches.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Tue, 27 Oct 2020 19:00:46 +0100
Message-ID: <CAMRc=McvW_E0aE2Ep=3aZvb=kNDMz6=ZH-EQzARAD-tyJG5Rrg@mail.gmail.com>
Subject: Re: [PATCH 3/8] vhost: vringh: use krealloc_array()
To:     Joe Perches <joe@perches.com>
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        linux-media <linux-media@vger.kernel.org>,
        linux-drm <dri-devel@lists.freedesktop.org>,
        linaro-mm-sig@lists.linaro.org,
        LKML <linux-kernel@vger.kernel.org>, linux-edac@vger.kernel.org,
        linux-gpio <linux-gpio@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>, linux-mm@kvack.org,
        Linux-ALSA <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 6:08 PM Joe Perches <joe@perches.com> wrote:
>
> On Tue, 2020-10-27 at 17:58 +0100, Bartosz Golaszewski wrote:
> > On Tue, Oct 27, 2020 at 5:50 PM Joe Perches <joe@perches.com> wrote:
> > >
> > > On Tue, 2020-10-27 at 11:28 -0400, Michael S. Tsirkin wrote:
> > > > On Tue, Oct 27, 2020 at 01:17:20PM +0100, Bartosz Golaszewski wrote:
> > > > > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > > > >
> > > > > Use the helper that checks for overflows internally instead of manually
> > > > > calculating the size of the new array.
> > > > >
> > > > > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > > >
> > > > No problem with the patch, it does introduce some symmetry in the code.
> > >
> > > Perhaps more symmetry by using kmemdup
> > > ---
> > >  drivers/vhost/vringh.c | 23 ++++++++++-------------
> > >  1 file changed, 10 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > > index 8bd8b403f087..99222a3651cd 100644
> > > --- a/drivers/vhost/vringh.c
> > > +++ b/drivers/vhost/vringh.c
> > > @@ -191,26 +191,23 @@ static int move_to_indirect(const struct vringh *vrh,
> > >  static int resize_iovec(struct vringh_kiov *iov, gfp_t gfp)
> > >  {
> > >         struct kvec *new;
> > > -       unsigned int flag, new_num = (iov->max_num & ~VRINGH_IOV_ALLOCATED) * 2;
> > > +       size_t new_num = (iov->max_num & ~VRINGH_IOV_ALLOCATED) * 2;
> > > +       size_t size;
> > >
> > >         if (new_num < 8)
> > >                 new_num = 8;
> > >
> > > -       flag = (iov->max_num & VRINGH_IOV_ALLOCATED);
> > > -       if (flag)
> > > -               new = krealloc(iov->iov, new_num * sizeof(struct iovec), gfp);
> > > -       else {
> > > -               new = kmalloc_array(new_num, sizeof(struct iovec), gfp);
> > > -               if (new) {
> > > -                       memcpy(new, iov->iov,
> > > -                              iov->max_num * sizeof(struct iovec));
> > > -                       flag = VRINGH_IOV_ALLOCATED;
> > > -               }
> > > -       }
> > > +       if (unlikely(check_mul_overflow(new_num, sizeof(struct iovec), &size)))
> > > +               return -ENOMEM;
> > > +
> >
> > The whole point of using helpers such as kmalloc_array() is not doing
> > these checks manually.
>
> Tradeoffs for in readability for overflow and not mistyping or doing
> the multiplication of iov->max_num * sizeof(struct iovec) twice.
>

It's out of scope for this series - I want to add users for
krealloc_array(), not refactor code I don't really know. If the
maintainer of this bit objects, it can be dropped.

> Just fyi:
>
> the realloc doesn't do a multiplication overflow test as written so the
> suggestion is slightly more resistant to defect.
>

I'm not sure what your point is. I used krealloc_array() exactly for
this reason - to add the overflow test.

BTW I suppose kmalloc_array() here can be replaced with
krealloc_array() if the original pointer is NULL the first time it's
called.

Bartosz
