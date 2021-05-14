Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B11380713
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 12:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbhENKXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 06:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbhENKXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 06:23:45 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509A2C061574;
        Fri, 14 May 2021 03:22:34 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id d24so17742234ios.2;
        Fri, 14 May 2021 03:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vciAZqDU3ir+miOY/c7xjJLyqmaPkD7glWg5FdGX3lY=;
        b=XANmncykDgONXxd5g+YwoNKuC8fm4sVElj64OHGnox0hzdUjbNah0fUBzBQ6MEwuQb
         9s9paqy7FfmSKHdswHuDJLeL+wVWi8a9UNtM4XAXay4Jc4+kHrHXSjnVjLviFh+Vh1UP
         wH6tbAQUWHA4gBTxH73mLNsqGqJUWoYxMt10lhvQxQV9hq7fHGE/UDEBUVKTvfVSHgv2
         oWNq2Iw3wCeCx/jWUtH25lPJMNTQAYIp9LbhbQ5N/bVOoKTp8kX+6xPOpIYpInPXQpuY
         OKF1SoRhc6E6X3NpGvIQzz7woCBL+85Nc/N0mxAjii0MK+ZlGq+twA3SxWPdyrq2LtK0
         epMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vciAZqDU3ir+miOY/c7xjJLyqmaPkD7glWg5FdGX3lY=;
        b=n2AfuUst/066x+z3GZO7AghiSvkK64Bf3tZIc/p4vdRd0we4QVzoLrXw02EnFIRzhJ
         p1RaSwmBsyVj3ZW8WWmBfP3sHeYC7oWAVfGXI2AusnAjRd52sOgN/rVp5nBRDd+ELiYR
         pGrnMRGJ7ZzvDVRujvDYVou0jji3PVg6cIu3HEeupDVvjcJtUjweacLHU9xuJbdlYUGh
         vsmGkgHWtYwvhpXm2GnCGW58oLK8IssMbc098s5Vs50AwALByLRsR3Gv2jRup54Jh/iQ
         TEp3Y+Z8bxq1SsIE2c5ddmVfXR7AxqPE4vGTEprTN6sXxny/RXkjT+mOBXybnEtRMoM7
         Bz6A==
X-Gm-Message-State: AOAM530OHVC1abyuhmtOQPyHUMslzqB2jyV6NWHuHjrFVnBpKiZCDCV4
        9Lte34xyDrjckTlamC8tjG8ce1kkNHAahhv727Lguzpb2OxQ7w==
X-Google-Smtp-Source: ABdhPJxCBq0WKbmQfe3tbmghJnthfS9nt+aIfJHRG+QvcfF51Uf8VEpK99LZaz+JVXwkI8sjGr8+khCEf1RbMwYacpA=
X-Received: by 2002:a05:6638:963:: with SMTP id o3mr33954478jaj.0.1620987753729;
 Fri, 14 May 2021 03:22:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210508064925.8045-1-heiko.thiery@gmail.com> <6ba0adf4-5177-c50a-e921-bee898e3fdb9@gmail.com>
In-Reply-To: <6ba0adf4-5177-c50a-e921-bee898e3fdb9@gmail.com>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Fri, 14 May 2021 12:22:22 +0200
Message-ID: <CAEyMn7a4Z3U-fUvFLcWmPW3hf-x6LfcTi8BZrcDfhhFF0_9=ow@mail.gmail.com>
Subject: Re: [PATCH iproute2-next v3] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, petr.vorel@gmail.com,
        linux-kernel@vger.kernel.org, stephen@networkplumber.org,
        Dmitry Yakunin <zeil@yandex-team.ru>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Am Mo., 10. Mai 2021 um 00:20 Uhr schrieb David Ahern <dsahern@gmail.com>:
>
> On 5/8/21 12:49 AM, Heiko Thiery wrote:
> > With commit d5e6ee0dac64 the usage of functions name_to_handle_at() and
> > open_by_handle_at() are introduced. But these function are not available
> > e.g. in uclibc-ng < 1.0.35. To have a backward compatibility check for the
> > availability in the configure script and in case of absence do a direct
> > syscall.
> >
> > Fixes: d5e6ee0dac64 ("ss: introduce cgroup2 cache and helper functions")
> > Cc: Dmitry Yakunin <zeil@yandex-team.ru>
> > Cc: Petr Vorel <petr.vorel@gmail.com>
> > Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
> > ---
> > v3:
> >  - use correct syscall number (thanks to Petr Vorel)
> >  - add #include <sys/syscall.h> (thanks to Petr Vorel)
> >  - remove bogus parameters (thanks to Petr Vorel)
> >  - fix #ifdef (thanks to Petr Vorel)
> >  - added Fixes tag (thanks to David Ahern)
> >  - build test with buildroot 2020.08.3 using uclibc 1.0.34
> >
> > v2:
> >  - small correction to subject
> >  - removed IP_CONFIG_HANDLE_AT:=y option since it is not required
> >  - fix indentation in check function
> >  - removed empty lines (thanks to Petr Vorel)
> >  - add #define _GNU_SOURCE in check (thanks to Petr Vorel)
> >  - check only for name_to_handle_at (thanks to Petr Vorel)
> >
> >  configure | 28 ++++++++++++++++++++++++++++
> >  lib/fs.c  | 25 +++++++++++++++++++++++++
> >  2 files changed, 53 insertions(+)
> >
> > diff --git a/configure b/configure
> > index 2c363d3b..179eae08 100755
> > --- a/configure
> > +++ b/configure
> > @@ -202,6 +202,31 @@ EOF
> >      rm -f $TMPDIR/setnstest.c $TMPDIR/setnstest
> >  }
> >
> > +check_name_to_handle_at()
> > +{
> > +    cat >$TMPDIR/name_to_handle_at_test.c <<EOF
> > +#define _GNU_SOURCE
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <fcntl.h>
> > +int main(int argc, char **argv)
> > +{
> > +     struct file_handle *fhp;
> > +     int mount_id, flags, dirfd;
> > +     char *pathname;
> > +     name_to_handle_at(dirfd, pathname, fhp, &mount_id, flags);
> > +     return 0;
> > +}
> > +EOF
> > +    if $CC -I$INCLUDE -o $TMPDIR/name_to_handle_at_test $TMPDIR/name_to_handle_at_test.c >/dev/null 2>&1; then
> > +        echo "yes"
> > +        echo "CFLAGS += -DHAVE_HANDLE_AT" >>$CONFIG
> > +    else
> > +        echo "no"
> > +    fi
> > +    rm -f $TMPDIR/name_to_handle_at_test.c $TMPDIR/name_to_handle_at_test
> > +}
> > +
> >  check_ipset()
> >  {
> >      cat >$TMPDIR/ipsettest.c <<EOF
> > @@ -492,6 +517,9 @@ fi
> >  echo -n "libc has setns: "
> >  check_setns
> >
> > +echo -n "libc has name_to_handle_at: "
> > +check_name_to_handle_at
> > +
> >  echo -n "SELinux support: "
> >  check_selinux
> >
> > diff --git a/lib/fs.c b/lib/fs.c
> > index f161d888..05697a7e 100644
> > --- a/lib/fs.c
> > +++ b/lib/fs.c
> > @@ -25,11 +25,36 @@
> >
> >  #include "utils.h"
> >
> > +#ifndef HAVE_HANDLE_AT
> > +# include <sys/syscall.h>
> > +#endif
> > +
> >  #define CGROUP2_FS_NAME "cgroup2"
> >
> >  /* if not already mounted cgroup2 is mounted here for iproute2's use */
> >  #define MNT_CGRP2_PATH  "/var/run/cgroup2"
> >
> > +
> > +#ifndef HAVE_HANDLE_AT
> > +struct file_handle {
> > +     unsigned handle_bytes;
> > +     int handle_type;
> > +     unsigned char f_handle[];
> > +};
> > +
> > +static int name_to_handle_at(int dirfd, const char *pathname,
> > +     struct file_handle *handle, int *mount_id, int flags)
> > +{
> > +     return syscall(__NR_name_to_handle_at, dirfd, pathname, handle,
> > +                    mount_id, flags);
> > +}
> > +
> > +static int open_by_handle_at(int mount_fd, struct file_handle *handle, int flags)
> > +{
> > +     return syscall(__NR_open_by_handle_at, mount_fd, handle, flags);
> > +}
> > +#endif
> > +
> >  /* return mount path of first occurrence of given fstype */
> >  static char *find_fs_mount(const char *fs_to_find)
> >  {
> >
>
> This causes compile failures if anyone is reusing a tree. It would be
> good to require config.mk to be updated if configure is newer.

Do you mean the config.mk should have a dependency to configure in the
Makefile? Wouldn't that be better as a separate patch?

Thanks
-- 
Heiko
