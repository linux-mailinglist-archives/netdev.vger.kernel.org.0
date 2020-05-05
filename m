Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FC31C620F
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbgEEU3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728135AbgEEU3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:29:03 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158FAC061A0F;
        Tue,  5 May 2020 13:29:03 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id a9so2475136lfb.8;
        Tue, 05 May 2020 13:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=83UCtPNkqDZBKGoRIazdaAZRxxGX8f38Okq8k7GA4pI=;
        b=CejyCH2+i8WjwOb6iQSU/zjkgAjhZFS3kKbmAcGRM+1VtTGKGEU+WvbOY7x2voOPho
         XLjfmulIDc05d7z63UFfBbfOwjtdaXNdU6aYilayzlrXcoKs2Scd/9SK20k+tLtbbMp6
         n9nDQ3nkLOzgi5LtpjnS/IKdbwlyQQCsDCcNqYlzoRBaW4vZvEOnLbQUXDzHAGqefQGe
         Q1AP1nacbWbmjUwWFXOiAHyZXwLAXI/sGF3FtUqGf+6nDIg6RIe8xlpo4X2jbPbPgjId
         2m0DslzgGLGYJfe8SAGJ267eW+mbvJ4JEiIJQt7G2m+lSjdotbOCUzSYiGG6gAD7sGlY
         1jBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=83UCtPNkqDZBKGoRIazdaAZRxxGX8f38Okq8k7GA4pI=;
        b=SrWRSA6naDWClKDXGSjlB+VG8H59fTaPMMmO2+/oc09nrHwhOcWWpztCZh7V7woucU
         nUhmL6foCtYqgX400a2gPhdnxP1RVeM98bicfqxf8Bsf6X86IQfdWd4Y0cJTupT2U3X4
         C4FkVJprFqD/cWsUQWQhEgYc+X6LZ29WVchBF5pd5A54eQztaFfVE2dY/d1QOmt+oLK0
         Q2/tvKovvE0YA6JV38rq5WkP0znUu2shTUwSeU3kUxN13lrBQYf3gFPxPotGvcIWHfXG
         l/pafJ6KVwGFCfHuTxG86DCPlNv9NOoGzgNYMWvui8hWC+cnrJ5lxR0kgCilZyihWwvF
         bQYA==
X-Gm-Message-State: AGi0PuYtUspAyWUwQXQbqpEI5h3MP9kjUV4IBkqCalB1yBXdKRz1BIrK
        8e4GeedE/N89gwyhsD7jbSdXRqez5IheacdccYg=
X-Google-Smtp-Source: APiQypIN32pISCAGZuC8E0y4X/FTimjvo06gX0G57fdlSriZX05RtvQUHDYaxCoByWoKjEhFoEzhC0rF5wxgjntlPtc=
X-Received: by 2002:a19:c349:: with SMTP id t70mr2736495lff.139.1588710541439;
 Tue, 05 May 2020 13:29:01 -0700 (PDT)
MIME-Version: 1.0
References: <1588706059-4208-1-git-send-email-jrdr.linux@gmail.com> <0bfe4a8a-0d91-ef9b-066f-2ea7c68571b3@nvidia.com>
In-Reply-To: <0bfe4a8a-0d91-ef9b-066f-2ea7c68571b3@nvidia.com>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Wed, 6 May 2020 02:06:56 +0530
Message-ID: <CAFqt6zZMsQkOdjAb2k1EjwX=DtZ8gKfbRzwvreHOX-0vJLngNg@mail.gmail.com>
Subject: Re: [RFC] mm/gup.c: Updated return value of {get|pin}_user_pages_fast()
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Tony Luck <tony.luck@intel.com>, fenghua.yu@intel.com,
        Rob Springer <rspringer@google.com>,
        Todd Poynor <toddpoynor@google.com>, benchan@chromium.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        santosh.shilimkar@oracle.com,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        inux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        tee-dev@lists.linaro.org, Linux-MM <linux-mm@kvack.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 1:08 AM John Hubbard <jhubbard@nvidia.com> wrote:
>
> On 2020-05-05 12:14, Souptick Joarder wrote:
> > Currently {get|pin}_user_pages_fast() have 3 return value 0, -errno
> > and no of pinned pages. The only case where these two functions will
> > return 0, is for nr_pages <= 0, which doesn't find a valid use case.
> > But if at all any, then a -ERRNO will be returned instead of 0, which
> > means {get|pin}_user_pages_fast() will have 2 return values -errno &
> > no of pinned pages.
> >
> > Update all the callers which deals with return value 0 accordingly.
>
> Hmmm, seems a little shaky. In order to do this safely, I'd recommend
> first changing gup_fast/pup_fast so so that they return -EINVAL if
> the caller specified nr_pages==0, and of course auditing all callers,
> to ensure that this won't cause problems.

While auditing it was figured out, there are 5 callers which cares for
return value
0 of gup_fast/pup_fast. What problem it might cause if we change
gup_fast/pup_fast
to return -EINVAL and update all the callers in a single commit ?

>
> The gup.c documentation would also need updating in a couple of comment
> blocks, above get_user_pages_remote(), and __get_user_pages(), because
> those talk about a zero return value.

OK.

>
> This might be practical without slowing down the existing code, because
> there is already a check in place, so just tweaking it like this (untested)
> won't change performance at all:
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 11fda538c9d9..708eed79ae29 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2787,7 +2787,7 @@ static int internal_get_user_pages_fast(unsigned long start,
> int nr_pages,
>          end = start + len;
>
>          if (end <= start)
> -               return 0;
> +               return -EINVAL;
>          if (unlikely(!access_ok((void __user *)start, len)))
>                  return -EFAULT;
>
> ...although I might be missing some other things that need a similar change,
> so you should look carefully for yourself.

Do you refer to other gup APIs similar to gup_fast/pup_fast ?

>
>
> Once that change (and anything I missed) is in place, then you could go
> ahead and stop handling ret==0 cases at the call sites.
>
>
> thanks,
> --
> John Hubbard
> NVIDIA
>
> >
> > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> > ---
> >   arch/ia64/kernel/err_inject.c              | 2 +-
> >   drivers/platform/goldfish/goldfish_pipe.c  | 2 +-
> >   drivers/staging/gasket/gasket_page_table.c | 4 ++--
> >   drivers/tee/tee_shm.c                      | 2 +-
> >   mm/gup.c                                   | 6 +++---
> >   net/rds/rdma.c                             | 2 +-
> >   6 files changed, 9 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/ia64/kernel/err_inject.c b/arch/ia64/kernel/err_inject.c
> > index 8b5b8e6b..fd72218 100644
> > --- a/arch/ia64/kernel/err_inject.c
> > +++ b/arch/ia64/kernel/err_inject.c
> > @@ -143,7 +143,7 @@ static DEVICE_ATTR(name, 0644, show_##name, store_##name)
> >       int ret;
> >
> >       ret = get_user_pages_fast(virt_addr, 1, FOLL_WRITE, NULL);
> > -     if (ret<=0) {
> > +     if (ret < 0) {
> >   #ifdef ERR_INJ_DEBUG
> >               printk("Virtual address %lx is not existing.\n",virt_addr);
> >   #endif
> > diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/goldfish/goldfish_pipe.c
> > index 1ab207e..831449d 100644
> > --- a/drivers/platform/goldfish/goldfish_pipe.c
> > +++ b/drivers/platform/goldfish/goldfish_pipe.c
> > @@ -277,7 +277,7 @@ static int goldfish_pin_pages(unsigned long first_page,
> >       ret = pin_user_pages_fast(first_page, requested_pages,
> >                                 !is_write ? FOLL_WRITE : 0,
> >                                 pages);
> > -     if (ret <= 0)
> > +     if (ret < 0)
> >               return -EFAULT;
> >       if (ret < requested_pages)
> >               *iter_last_page_size = PAGE_SIZE;
> > diff --git a/drivers/staging/gasket/gasket_page_table.c b/drivers/staging/gasket/gasket_page_table.c
> > index f6d7157..1d08e1d 100644
> > --- a/drivers/staging/gasket/gasket_page_table.c
> > +++ b/drivers/staging/gasket/gasket_page_table.c
> > @@ -489,11 +489,11 @@ static int gasket_perform_mapping(struct gasket_page_table *pg_tbl,
> >                       ret = get_user_pages_fast(page_addr - offset, 1,
> >                                                 FOLL_WRITE, &page);
> >
> > -                     if (ret <= 0) {
> > +                     if (ret < 0) {
> >                               dev_err(pg_tbl->device,
> >                                       "get user pages failed for addr=0x%lx, offset=0x%lx [ret=%d]\n",
> >                                       page_addr, offset, ret);
> > -                             return ret ? ret : -ENOMEM;
> > +                             return ret;
> >                       }
> >                       ++pg_tbl->num_active_pages;
> >
> > diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
> > index bd679b7..2706a1f 100644
> > --- a/drivers/tee/tee_shm.c
> > +++ b/drivers/tee/tee_shm.c
> > @@ -230,7 +230,7 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
> >       if (rc > 0)
> >               shm->num_pages = rc;
> >       if (rc != num_pages) {
> > -             if (rc >= 0)
> > +             if (rc > 0)
> >                       rc = -ENOMEM;
> >               ret = ERR_PTR(rc);
> >               goto err;
> > diff --git a/mm/gup.c b/mm/gup.c
> > index 50681f0..8d293ed 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -2760,7 +2760,7 @@ static int internal_get_user_pages_fast(unsigned long start, int nr_pages,
> >       end = start + len;
> >
> >       if (end <= start)
> > -             return 0;
> > +             return -EINVAL;
> >       if (unlikely(!access_ok((void __user *)start, len)))
> >               return -EFAULT;
> >
> > @@ -2805,8 +2805,8 @@ static int internal_get_user_pages_fast(unsigned long start, int nr_pages,
> >    * calling get_user_pages().
> >    *
> >    * Returns number of pages pinned. This may be fewer than the number requested.
> > - * If nr_pages is 0 or negative, returns 0. If no pages were pinned, returns
> > - * -errno.
> > + * If nr_pages is 0 or negative, returns -errno. If no pages were pinned,
> > + * returns -errno.
> >    */
> >   int get_user_pages_fast(unsigned long start, int nr_pages,
> >                       unsigned int gup_flags, struct page **pages)
> > diff --git a/net/rds/rdma.c b/net/rds/rdma.c
> > index a7ae118..44b96e6 100644
> > --- a/net/rds/rdma.c
> > +++ b/net/rds/rdma.c
> > @@ -161,7 +161,7 @@ static int rds_pin_pages(unsigned long user_addr, unsigned int nr_pages,
> >               gup_flags |= FOLL_WRITE;
> >
> >       ret = pin_user_pages_fast(user_addr, nr_pages, gup_flags, pages);
> > -     if (ret >= 0 && ret < nr_pages) {
> > +     if (ret > 0 && ret < nr_pages) {
> >               unpin_user_pages(pages, ret);
> >               ret = -EFAULT;
> >       }
> >
>
