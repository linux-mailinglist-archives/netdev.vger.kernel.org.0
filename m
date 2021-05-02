Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3AB370B42
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 13:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhEBLRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 07:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhEBLRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 07:17:09 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB38C06174A;
        Sun,  2 May 2021 04:16:17 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id y7so3679824ejj.9;
        Sun, 02 May 2021 04:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=hegzbX+BG3ARJokqf9dzmUxJ1A8+FLEQIrCPeGFPuyc=;
        b=Tdx1rLv8CwXhcmPAtpYne5+asLQjsSFJZ34ac061bpRMRbd9YY1qi4F+BDP53GZUku
         dmwPpzaVQJjCcsTy6wU+LZAQp3dj7HaUemaFhUkQd8FM3QjIAkCFmH1tgUXlK3znP+Cp
         cqfAscrz6Re0B1Y6ViUWHdmeVvsoMO493qgiGDLGSBQ4dqp38+uEqUa8OQu5OkpzbXHA
         kglUeqkjJ8o4ectasYRy035ns7UFKbDCx7s6wUVwkXMi2BwUE9ETuEAmPZsw8elskF8b
         iOs8REJJR3JaiUK+kCINza4HRp1UOAvOGt8O2nlMrSdWuQO/zn3UdT+ALJp1t0+i+JNa
         VMvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=hegzbX+BG3ARJokqf9dzmUxJ1A8+FLEQIrCPeGFPuyc=;
        b=Q8pGPbGlyaUJoyCxhUsLRoWO4yYLWixqLiwGnS9XrMM+7e8avmJ2b8UPbVHkXWGUSZ
         qlt2mSTXSt1F8YrfxwAlgMTwxbgibckM/u29cE0Mt876cbLUqZmzgT28UIbbohDieSwL
         7cmoAoIYfob6LltCtzSDkWcSEnSYIfMX9RnPv/PILcwUA2STPxc7TLSd6k1vJDeQVZXe
         9+AsBpgzPfw7eorcUxCRiOsnyUi9S6TVjoFoFmCOf1ptj0jGuzAKsS7yQ/Iom8PY0KZx
         ErtmFiMScbZhtLunz+cJZpN+A/G1LPoQp3XhkpbAQajRRWtD5FqZYe8hkp0QSJKsPvzS
         J29g==
X-Gm-Message-State: AOAM5317UvmQ1ZmUXInWM0TRSxP43sNaZ8hDh/+ByHikXplAIZ8eELOa
        MWVan088G/SAhVkLEkj0DgI=
X-Google-Smtp-Source: ABdhPJzrVZqz9AkhBdUMOBPTMJy5KJQG9HBattxg6glnKyB85/diKYjDqALTu10qChCnNRQM9D9SrQ==
X-Received: by 2002:a17:906:cb2:: with SMTP id k18mr12575167ejh.183.1619954176335;
        Sun, 02 May 2021 04:16:16 -0700 (PDT)
Received: from pevik ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id r15sm5406495edp.62.2021.05.02.04.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 04:16:15 -0700 (PDT)
Date:   Sun, 2 May 2021 13:16:12 +0200
From:   Petr Vorel <petr.vorel@gmail.com>
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2-next v2] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
Message-ID: <YI6J/EBwxd0+p5Ux@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210430062632.21304-1-heiko.thiery@gmail.com>
 <YIxVWXqBkkS6l5lB@pevik>
 <YIxaf3hu2mRUbBGn@pevik>
 <CAEyMn7Z4cr1=WYde4uxwu2tjEgX2Lwwx3S+vmFP8EZVVMaWRjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEyMn7Z4cr1=WYde4uxwu2tjEgX2Lwwx3S+vmFP8EZVVMaWRjg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Petr,

> Am Fr., 30. Apr. 2021 um 21:29 Uhr schrieb Petr Vorel <petr.vorel@gmail.com>:

> > Hi,

> > > > +++ b/lib/fs.c
> > > > @@ -30,6 +30,27 @@
> > > >  /* if not already mounted cgroup2 is mounted here for iproute2's use */
> > > >  #define MNT_CGRP2_PATH  "/var/run/cgroup2"

> > > > +
> > > > +#ifndef defined HAVE_HANDLE_AT
> > > This is also wrong, it must be:
> > > #ifndef HAVE_HANDLE_AT

> > > > +struct file_handle {
> > > > +   unsigned handle_bytes;
> > > > +   int handle_type;
> > > > +   unsigned char f_handle[];
> > > > +};
> > > > +
> > > > +int name_to_handle_at(int dirfd, const char *pathname,
> > > > +   struct file_handle *handle, int *mount_id, int flags)
> > > > +{
> > > > +   return syscall(name_to_handle_at, 5, dirfd, pathname, handle,
> > > > +                  mount_id, flags);
> > > Also I overlooked bogus 5 parameter, why is here? Correct is:

> > >       return syscall(__NR_name_to_handle_at, dfd, pathname, handle,
> > >                          mount_id, flags);
> > Uh, one more typo on my side, sorry (dfd => dirfd):
> >         return syscall(__NR_name_to_handle_at, dirfd, pathname, handle,
> >                            mount_id, flags);


> Thanks for the review and finding the sloppiness. I really should test
> the changes before. Nevertheless, I will prepare a new version and
> test it this time.
I tested ss with changed I proposed and it looks like it's ok.
But I run ss on qemu without any daemon running => I'll retest your v3 once you
post it with some daemons running so that the code is really triggered.

Kind regards,
Petr

> BR,
