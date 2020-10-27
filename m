Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E3829BEFC
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 18:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1814690AbgJ0Q67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 12:58:59 -0400
Received: from mail-ej1-f65.google.com ([209.85.218.65]:42384 "EHLO
        mail-ej1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1794055AbgJ0Q65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 12:58:57 -0400
Received: by mail-ej1-f65.google.com with SMTP id h24so3234502ejg.9
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 09:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jbe/1MUIOazjJNoYCLbZSaF/EYC3tySch0SP+bPnG10=;
        b=jVifv3wcHJtbLJO22cQhSQScaHCOkHk0uy60SV24XvvF7WpqIaa807hmufMDVKqnPF
         3xm47weUtJacIjSqbcrwXivMAtenN13kZafFSMO2m8dHHXFLXYX56OUdOoMTcRWlbgDG
         Thpj0UzfAOOdteCoRx63Xv7ZHZnjkyReDZ1Swoq+LyDarWGF0Mhj1KXWH3CO+MSgLHKb
         ZCBeQPWb0noZpqy+qKiKznJoq/vsPZZzkzwPD8DcAe8kPG1EHjLxd45J8Yu892ID37T7
         4/FpLOCqsI/vnQoRJn422RcKliIdkwc27vyhzCgMqyr6Vk10qaJ+O1CUPcx0OY5r8WIV
         v25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jbe/1MUIOazjJNoYCLbZSaF/EYC3tySch0SP+bPnG10=;
        b=aq49ag0Yrwt5z0DE7Ko44s8E5CI2aC+Zfl9MfqFp89a4eYsCBFVeYh0bOT2I6S1B5i
         jzo/YJ5C4k4PXacJ6dmQKvYmxWz+CNIh1ep5zLvLk+akjAQaUbMKSVj04nsch+8UxRjC
         Ibwj65PEk3B9QWi3RJnNB/Cp3KuBfZ7OPcgmmxBYuSc+gaIq4DJ2bowmwfdPRxzkjPqy
         hv5Obl20bZ1n3lpr6GCJihmNAz2hcrvp0g4WfhuQe1TZddzA2mQ0Ef90qL+q3WP7QD58
         n/R4hVQPzIgXcZp+K38NzXWHZQTeHBj/8lNtc3fZ0AxwvI/9J+hjXULlRlxMK2fvejyr
         UsQQ==
X-Gm-Message-State: AOAM532mU/sYRBoNZGBT2SYNR6aXj5lc1mzU0YQpaS5uP/VtH6bFClJx
        dOMJOFyGYYhbsRNbe76OEqeOb3t2mg8uQU0O65hoLw==
X-Google-Smtp-Source: ABdhPJzA1XzwQDZrf0aO0vJ0GFK7TlKkhiOIHp72TDLrdQ3tpl8EeLXanxCM3mEYAMp7LHDhMqHnk4D8XhUXPqwrAS0=
X-Received: by 2002:a17:906:d159:: with SMTP id br25mr3508153ejb.155.1603817934690;
 Tue, 27 Oct 2020 09:58:54 -0700 (PDT)
MIME-Version: 1.0
References: <20201027121725.24660-1-brgl@bgdev.pl> <20201027121725.24660-4-brgl@bgdev.pl>
 <20201027112607-mutt-send-email-mst@kernel.org> <685d850347a1191bba8ba7766fc409b140d18f03.camel@perches.com>
In-Reply-To: <685d850347a1191bba8ba7766fc409b140d18f03.camel@perches.com>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Tue, 27 Oct 2020 17:58:43 +0100
Message-ID: <CAMpxmJU0C84DjPmqmWvPgv0zwgGLhkpKLRDuKkZHAa=wi+LvBA@mail.gmail.com>
Subject: Re: [PATCH 3/8] vhost: vringh: use krealloc_array()
To:     Joe Perches <joe@perches.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
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

On Tue, Oct 27, 2020 at 5:50 PM Joe Perches <joe@perches.com> wrote:
>
> On Tue, 2020-10-27 at 11:28 -0400, Michael S. Tsirkin wrote:
> > On Tue, Oct 27, 2020 at 01:17:20PM +0100, Bartosz Golaszewski wrote:
> > > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > >
> > > Use the helper that checks for overflows internally instead of manually
> > > calculating the size of the new array.
> > >
> > > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> >
> > No problem with the patch, it does introduce some symmetry in the code.
>
> Perhaps more symmetry by using kmemdup
> ---
>  drivers/vhost/vringh.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 8bd8b403f087..99222a3651cd 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -191,26 +191,23 @@ static int move_to_indirect(const struct vringh *vrh,
>  static int resize_iovec(struct vringh_kiov *iov, gfp_t gfp)
>  {
>         struct kvec *new;
> -       unsigned int flag, new_num = (iov->max_num & ~VRINGH_IOV_ALLOCATED) * 2;
> +       size_t new_num = (iov->max_num & ~VRINGH_IOV_ALLOCATED) * 2;
> +       size_t size;
>
>         if (new_num < 8)
>                 new_num = 8;
>
> -       flag = (iov->max_num & VRINGH_IOV_ALLOCATED);
> -       if (flag)
> -               new = krealloc(iov->iov, new_num * sizeof(struct iovec), gfp);
> -       else {
> -               new = kmalloc_array(new_num, sizeof(struct iovec), gfp);
> -               if (new) {
> -                       memcpy(new, iov->iov,
> -                              iov->max_num * sizeof(struct iovec));
> -                       flag = VRINGH_IOV_ALLOCATED;
> -               }
> -       }
> +       if (unlikely(check_mul_overflow(new_num, sizeof(struct iovec), &size)))
> +               return -ENOMEM;
> +

The whole point of using helpers such as kmalloc_array() is not doing
these checks manually.

Bartosz

> +       if (iov->max_num & VRINGH_IOV_ALLOCATED)
> +               new = krealloc(iov->iov, size, gfp);
> +       else
> +               new = kmemdup(iov->iov, size, gfp);
>         if (!new)
>                 return -ENOMEM;
>         iov->iov = new;
> -       iov->max_num = (new_num | flag);
> +       iov->max_num = new_num | VRINGH_IOV_ALLOCATED;
>         return 0;
>  }
>
>
>
