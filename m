Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACD938095E
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 14:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbhENMWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 08:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbhENMWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 08:22:09 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23595C061574;
        Fri, 14 May 2021 05:20:58 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id l7so34524660edb.1;
        Fri, 14 May 2021 05:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=2cTYvHuHAN0WL1Zhu+AnGEld65eYHPpP/ykq20D4jMk=;
        b=Z8EInJ2m0tdGAt3ZCC2KcPw3j/xM16a3OROzGvAEc0kIsNWeUNy7prAAPbNVVSSPXH
         vqqyJt1dJKTFawpJY0JU1ezpARyUC+oZfs73nSxSA72CsWbwiA0+bKVdYncweFeCmvza
         hP8XNdk+CXJ1yKGKUFs9JXFTZfwk/9sBFGgJt8de34FGASEfWMZA15VkM5ptvSe1Ykqv
         8CpVQma1WynB6gRyHUIb5/bS9/TW2HkR21zbWIe230gT0+1QVkXjCRpT//kSzCH8A4l0
         HGSdzQ3g9bkqOINI9N+P3fBun4sy/hTYHr4Kte2uM+hBWIxUAyC5fOjF7UgoN5bjqWHj
         7JdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=2cTYvHuHAN0WL1Zhu+AnGEld65eYHPpP/ykq20D4jMk=;
        b=dbnYU+Cy4K9H6YBcH260vfKyrZWhj1ME3Vr5kJUkHvpibtbRuh7b5AU1RFu3A1mXFI
         SoBTCjfVgtNjCqRl4BjyWqXXMK0mkiyS/gw723UgiyfFH+Za2032twbox3y5aSgVnhqz
         Ib2xmO2KkSgL30NdHA9u18L+uaCqF/9l89jGs7uJ4eU7CTBQxjrkM0onWlTKDYKUIsq0
         70FJitKsIFSzCoT/rM4Dd9/voOgdsslbrQUoBqvULzhi+0qOOLlEKcYGy9sq7h5sGUix
         fy/HGDbatH/ODFj7YedmuhKxwdKB/rnqtWAE7+q7O56wFugJh2AbBm2bGF9ecYI6qgGd
         nhPg==
X-Gm-Message-State: AOAM532zdM9YH2C89ZQFqWgEt2LY/P6LAGNfjFu3CNzHvVBfTERnanlC
        Tiw3qf5RA5DUzkYyQMJXvHs=
X-Google-Smtp-Source: ABdhPJz1yjhIibIkrJNKIeN+hvBVhLfofgf2+TTyNDjq1rq7rJYvkbK9MPzxDNsU7KyoniwOsMNQFQ==
X-Received: by 2002:a05:6402:2712:: with SMTP id y18mr58311789edd.41.1620994856893;
        Fri, 14 May 2021 05:20:56 -0700 (PDT)
Received: from pevik ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id k9sm3746438eje.102.2021.05.14.05.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 05:20:56 -0700 (PDT)
Date:   Fri, 14 May 2021 14:20:53 +0200
From:   Petr Vorel <petr.vorel@gmail.com>
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephen@networkplumber.org,
        Dmitry Yakunin <zeil@yandex-team.ru>
Subject: Re: [PATCH iproute2-next v3] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
Message-ID: <YJ5rJbdEc2OWemu+@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210508064925.8045-1-heiko.thiery@gmail.com>
 <6ba0adf4-5177-c50a-e921-bee898e3fdb9@gmail.com>
 <CAEyMn7a4Z3U-fUvFLcWmPW3hf-x6LfcTi8BZrcDfhhFF0_9=ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEyMn7a4Z3U-fUvFLcWmPW3hf-x6LfcTi8BZrcDfhhFF0_9=ow@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi David,

> Am Mo., 10. Mai 2021 um 00:20 Uhr schrieb David Ahern <dsahern@gmail.com>:

> > On 5/8/21 12:49 AM, Heiko Thiery wrote:
> > > With commit d5e6ee0dac64 the usage of functions name_to_handle_at() and
> > > open_by_handle_at() are introduced. But these function are not available
> > > e.g. in uclibc-ng < 1.0.35. To have a backward compatibility check for the
> > > availability in the configure script and in case of absence do a direct
> > > syscall.

> > > Fixes: d5e6ee0dac64 ("ss: introduce cgroup2 cache and helper functions")
> > > Cc: Dmitry Yakunin <zeil@yandex-team.ru>
> > > Cc: Petr Vorel <petr.vorel@gmail.com>
> > > Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
> > > ---
> > > v3:
> > >  - use correct syscall number (thanks to Petr Vorel)
> > >  - add #include <sys/syscall.h> (thanks to Petr Vorel)
> > >  - remove bogus parameters (thanks to Petr Vorel)
> > >  - fix #ifdef (thanks to Petr Vorel)
> > >  - added Fixes tag (thanks to David Ahern)
> > >  - build test with buildroot 2020.08.3 using uclibc 1.0.34

> > > v2:
> > >  - small correction to subject
> > >  - removed IP_CONFIG_HANDLE_AT:=y option since it is not required
> > >  - fix indentation in check function
> > >  - removed empty lines (thanks to Petr Vorel)
> > >  - add #define _GNU_SOURCE in check (thanks to Petr Vorel)
> > >  - check only for name_to_handle_at (thanks to Petr Vorel)

> > >  configure | 28 ++++++++++++++++++++++++++++
> > >  lib/fs.c  | 25 +++++++++++++++++++++++++
> > >  2 files changed, 53 insertions(+)

> > > diff --git a/configure b/configure
> > > index 2c363d3b..179eae08 100755
> > > --- a/configure
> > > +++ b/configure
> > > @@ -202,6 +202,31 @@ EOF
> > >      rm -f $TMPDIR/setnstest.c $TMPDIR/setnstest
> > >  }

> > > +check_name_to_handle_at()
> > > +{
> > > +    cat >$TMPDIR/name_to_handle_at_test.c <<EOF
> > > +#define _GNU_SOURCE
> > > +#include <sys/types.h>
> > > +#include <sys/stat.h>
> > > +#include <fcntl.h>
> > > +int main(int argc, char **argv)
> > > +{
> > > +     struct file_handle *fhp;
> > > +     int mount_id, flags, dirfd;
> > > +     char *pathname;
> > > +     name_to_handle_at(dirfd, pathname, fhp, &mount_id, flags);
> > > +     return 0;
> > > +}
> > > +EOF
> > > +    if $CC -I$INCLUDE -o $TMPDIR/name_to_handle_at_test $TMPDIR/name_to_handle_at_test.c >/dev/null 2>&1; then
> > > +        echo "yes"
> > > +        echo "CFLAGS += -DHAVE_HANDLE_AT" >>$CONFIG
> > > +    else
> > > +        echo "no"
> > > +    fi
> > > +    rm -f $TMPDIR/name_to_handle_at_test.c $TMPDIR/name_to_handle_at_test
> > > +}
> > > +
> > >  check_ipset()
> > >  {
> > >      cat >$TMPDIR/ipsettest.c <<EOF
> > > @@ -492,6 +517,9 @@ fi
> > >  echo -n "libc has setns: "
> > >  check_setns

> > > +echo -n "libc has name_to_handle_at: "
> > > +check_name_to_handle_at
> > > +
> > >  echo -n "SELinux support: "
> > >  check_selinux

> > > diff --git a/lib/fs.c b/lib/fs.c
> > > index f161d888..05697a7e 100644
> > > --- a/lib/fs.c
> > > +++ b/lib/fs.c
> > > @@ -25,11 +25,36 @@

> > >  #include "utils.h"

> > > +#ifndef HAVE_HANDLE_AT
> > > +# include <sys/syscall.h>
> > > +#endif
> > > +
> > >  #define CGROUP2_FS_NAME "cgroup2"

> > >  /* if not already mounted cgroup2 is mounted here for iproute2's use */
> > >  #define MNT_CGRP2_PATH  "/var/run/cgroup2"

> > > +
> > > +#ifndef HAVE_HANDLE_AT
> > > +struct file_handle {
> > > +     unsigned handle_bytes;
> > > +     int handle_type;
> > > +     unsigned char f_handle[];
> > > +};
> > > +
> > > +static int name_to_handle_at(int dirfd, const char *pathname,
> > > +     struct file_handle *handle, int *mount_id, int flags)
> > > +{
> > > +     return syscall(__NR_name_to_handle_at, dirfd, pathname, handle,
> > > +                    mount_id, flags);
> > > +}
> > > +
> > > +static int open_by_handle_at(int mount_fd, struct file_handle *handle, int flags)
> > > +{
> > > +     return syscall(__NR_open_by_handle_at, mount_fd, handle, flags);
> > > +}
> > > +#endif
> > > +
> > >  /* return mount path of first occurrence of given fstype */
> > >  static char *find_fs_mount(const char *fs_to_find)
> > >  {


> > This causes compile failures if anyone is reusing a tree. It would be
> > good to require config.mk to be updated if configure is newer.

> Do you mean the config.mk should have a dependency to configure in the
> Makefile? Wouldn't that be better as a separate patch?

I guess it should be a separate patch. I'm surprised it wasn't needed before.

Kind regards,
Petr

> Thanks
