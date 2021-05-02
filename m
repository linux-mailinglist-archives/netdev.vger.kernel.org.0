Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93B1370AC8
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 10:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhEBIgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 04:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhEBIgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 04:36:21 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052BCC06174A;
        Sun,  2 May 2021 01:35:29 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id u48-20020a4a97330000b02901fa060b8066so590656ooi.8;
        Sun, 02 May 2021 01:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WLNkx73hcHcrQZ3KilQZwxG3DTJfVww0RQQLOCneQHc=;
        b=u96t6QK91NThmWMffJGUKZbNrihPegTeh5QQ3TN5DqkJT8bvNDNFbtvhN2sc5YeZk3
         L2VPrmUlMkBVrwDBAGdaMSrZpBV1cIIGFgxZPrevLUQSHi9ujzb1iDRX09+/4T+HCCkh
         IMG2EDYU9koiOUt0kU9Z1VsEkLternAja9B6RFKdDqSkm+ALtXYpfQNDzyXDe2hX9heI
         ILIlpY1Wxq8RM2KKPyDCKdIRHsYPZf0lUCAwE6A91LbWLVXCt1TFXfJz5JPiQEaX/uW8
         w9bcaLM0M7KwEWk6LAu3BIzX+Tt0yHS1s61JElqMhZ0ZXcTgFbx3sXDtop7S15mtyH2o
         jd3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WLNkx73hcHcrQZ3KilQZwxG3DTJfVww0RQQLOCneQHc=;
        b=XjY/AoXukXTluPCuou/Hze2WeiWlnsN7OgHHZGHBh0Cmx9hLqR/x5c8on60AbqCsYg
         lF//kK4eAmUo4X9FMw5gsy86a6UUAD84DBhVuL7dhGUPwY1ZKL1unOV7CW8lw1oSyrDp
         f0zPnCtv2WtaYbSEVa5yfHJL9+vmYVqEjALfpzTGr4MmS4sm+qwGJOHeuuXrbumpwPh+
         YsTzskoY3UEYB7H96KxRSNuSRh8Or2IHMtLq5KvB+mJCVO8v1HVQ9Q8ep2qAkVxuJ8rV
         1vMQX1x6e1D924apVkDt4f85OwsgU7G5UBylUhCcLqceOHNGQMRSjEzf2jQe92fGZHPm
         gEsQ==
X-Gm-Message-State: AOAM531NkQSK53y+0zR9RLe6FEA0HYcoeJpLgxx7D7H3bDj3q/18PhRC
        x35+9psfGFwI5QylUfUtPvQyUElXwPABAnzL55mfnej9cGfDbQ==
X-Google-Smtp-Source: ABdhPJzbg180RQ3aXNIhT0V2QAp6y9NeYHqTD9HXlyR1IEYkEWythQz+WAQfqoJ6vomF90EBTeDBUGaw7cxzO0xLbTU=
X-Received: by 2002:a4a:e934:: with SMTP id a20mr4356990ooe.27.1619944528389;
 Sun, 02 May 2021 01:35:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210430062632.21304-1-heiko.thiery@gmail.com>
 <YIxVWXqBkkS6l5lB@pevik> <YIxaf3hu2mRUbBGn@pevik>
In-Reply-To: <YIxaf3hu2mRUbBGn@pevik>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Sun, 2 May 2021 10:35:17 +0200
Message-ID: <CAEyMn7Z4cr1=WYde4uxwu2tjEgX2Lwwx3S+vmFP8EZVVMaWRjg@mail.gmail.com>
Subject: Re: [PATCH iproute2-next v2] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
To:     Petr Vorel <petr.vorel@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Petr,

Am Fr., 30. Apr. 2021 um 21:29 Uhr schrieb Petr Vorel <petr.vorel@gmail.com>:
>
> Hi,
>
> > > +++ b/lib/fs.c
> > > @@ -30,6 +30,27 @@
> > >  /* if not already mounted cgroup2 is mounted here for iproute2's use */
> > >  #define MNT_CGRP2_PATH  "/var/run/cgroup2"
>
> > > +
> > > +#ifndef defined HAVE_HANDLE_AT
> > This is also wrong, it must be:
> > #ifndef HAVE_HANDLE_AT
>
> > > +struct file_handle {
> > > +   unsigned handle_bytes;
> > > +   int handle_type;
> > > +   unsigned char f_handle[];
> > > +};
> > > +
> > > +int name_to_handle_at(int dirfd, const char *pathname,
> > > +   struct file_handle *handle, int *mount_id, int flags)
> > > +{
> > > +   return syscall(name_to_handle_at, 5, dirfd, pathname, handle,
> > > +                  mount_id, flags);
> > Also I overlooked bogus 5 parameter, why is here? Correct is:
>
> >       return syscall(__NR_name_to_handle_at, dfd, pathname, handle,
> >                          mount_id, flags);
> Uh, one more typo on my side, sorry (dfd => dirfd):
>         return syscall(__NR_name_to_handle_at, dirfd, pathname, handle,
>                            mount_id, flags);
>

Thanks for the review and finding the sloppiness. I really should test
the changes before. Nevertheless, I will prepare a new version and
test it this time.

BR,
-- 
Heiko
