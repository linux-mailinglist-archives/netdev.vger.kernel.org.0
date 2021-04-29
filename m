Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF92336F069
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 21:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhD2TYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 15:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234176AbhD2TUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 15:20:16 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46047C06138B;
        Thu, 29 Apr 2021 12:19:28 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id t18so10447261wry.1;
        Thu, 29 Apr 2021 12:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=lneqwX+dzGZ1u826su0AXxbuk9GjDopbRrrh6SBJZ40=;
        b=ZIWCS7S//pL+fNsSrNILgdQ/tFgW0YSqzLXiSmSWAmGAxDDikw/gf7EDKKXBZDIJ1X
         AtJ92G20fm+Q1UtXYfcIBK3KyQPIrEq5y5qWwyQv3fWKA388q4U00ympDThqFmZl3x0N
         hbJz8UBnkjICOp4Xr/qfeNZS9U5mW2rRjGVRkr48cUVRQ+kD6dNdRVRuTqIKEr+of4Uk
         fhgtKA5Vtu0d3bos/+wUWMWb7uo/kEDmngHEcvDXrNxXQ5ensae4GKCsBXzqWb8Y9H2B
         PwF8+4B7+d4DTEiDraFFtKUPq3ezYWsP1hw0f2qKP0pRsIE0L0t+GGfUMc2hEnDaF2lO
         GB5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=lneqwX+dzGZ1u826su0AXxbuk9GjDopbRrrh6SBJZ40=;
        b=XQDFXqbUIVVHbzb94cDqs4r28k5O3UHe6SAdC8fonpMKwv9ppU0UgSeWwZG5hEEnQz
         dgx3yG04CJvX+cfr4KfLX8eYQ07mVJ+2VbakRa4q+uLIWAze/P8h3lFUDTGj7AGg0z5A
         r8Hc7zLElf4kUfzoJwK9GAb/eDlW7MfsbqwYUfBwRpEDtZfd7+hvKXxzYgle7CFl8KC3
         G9feWZfM8SDpxEgpBA3Id5wPbQM7J9brvcHHXWN16vwNzaf92Svi+BDuadqClx6PZHiZ
         LLtZL+pwFhVGQc6a941QBL7slZLq+qeoNlxparLAWsc3VPGaFb+UhtY2nHoIUw1sltYP
         iVrw==
X-Gm-Message-State: AOAM531cNDY0EyRonPI+WMhDBDxv97fFEqXG9TW80hjgTaeM8eP+G68K
        iTSUOzH32CnpU2CwDF9CFePHqdYUSddmkw==
X-Google-Smtp-Source: ABdhPJxLQk4sFtSUJ6sqGgMsuG+EBDpzoBTiA6yrFSNV8deC4ucjzl3rqK/tZLPTAD9yAPlfpZO3ZA==
X-Received: by 2002:adf:d0c9:: with SMTP id z9mr1449899wrh.175.1619723966995;
        Thu, 29 Apr 2021 12:19:26 -0700 (PDT)
Received: from pevik ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id y11sm1266901wmi.41.2021.04.29.12.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 12:19:26 -0700 (PDT)
Date:   Thu, 29 Apr 2021 21:19:24 +0200
From:   Petr Vorel <petr.vorel@gmail.com>
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH] lib/fs: fix issue when {name, open}_to_handle_at() is
 not implemented
Message-ID: <YIsGvE6vu7RYkAXi@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210422084612.26374-1-heiko.thiery@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422084612.26374-1-heiko.thiery@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> With commit d5e6ee0dac64b64e the usage of functions name_to_handle_at() and
> open_by_handle_at() are introduced. But these function are not available
> e.g. in uclibc-ng < 1.0.35. To have a backward compatibility check for the
> availability in the configure script and in case of absence do a direct
> syscall.

LGTM, thanks for implementing it.
I'd consider to check only one of the functions (very unlikely only one will be
supported).

> Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
> ---
>  configure | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  lib/fs.c  | 25 ++++++++++++++++++++++++
>  2 files changed, 83 insertions(+)

> diff --git a/configure b/configure
> index 2c363d3b..f1be9977 100755
> --- a/configure
> +++ b/configure
> @@ -202,6 +202,58 @@ EOF
>      rm -f $TMPDIR/setnstest.c $TMPDIR/setnstest
>  }

> +check_name_to_handle_at()
> +{
> +
nit: empty line.
> +    cat >$TMPDIR/name_to_handle_at_test.c <<EOF
It's interesting it does not require _GNU_SOURCE ? (IMHO this is normally
required for all glibc, musl, uclibc and binder):

#define _GNU_SOURCE
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <fcntl.h>
> +int main(int argc, char **argv)
> +{
> +	struct file_handle *fhp;
> +	int mount_id, flags, dirfd;
> +	char *pathname;
> +	name_to_handle_at(dirfd, pathname, fhp, &mount_id, flags);
> +	return 0;
> +}
> +EOF
> +
> +    if $CC -I$INCLUDE -o $TMPDIR/name_to_handle_at_test $TMPDIR/name_to_handle_at_test.c >/dev/null 2>&1; then
> +	echo "IP_CONFIG_NAME_TO_HANDLE_AT:=y" >>$CONFIG
> +	echo "yes"
> +	echo "CFLAGS += -DHAVE_NAME_TO_HANDLE_AT" >>$CONFIG
> +    else
> +	echo "no"
> +    fi
> +    rm -f $TMPDIR/name_to_handle_at_test.c $TMPDIR/name_to_handle_at_test
> +}
> +
> +check_open_by_handle_at()
> +{
> +
nit: empty line.
> +    cat >$TMPDIR/open_by_handle_at_test.c <<EOF
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <fcntl.h>
> +int main(int argc, char **argv)
> +{
> +	struct file_handle *fhp;
> +	int mount_fd;
> +	open_by_handle_at(mount_fd, fhp, O_RDONLY);
> +	return 0;
> +}
> +EOF
> +    if $CC -I$INCLUDE -o $TMPDIR/open_by_handle_at_test $TMPDIR/open_by_handle_at_test.c >/dev/null 2>&1; then
> +	echo "IP_CONFIG_OPEN_BY_HANDLE_AT:=y" >>$CONFIG
> +	echo "yes"
> +	echo "CFLAGS += -DHAVE_OPEN_BY_HANDLE_AT" >>$CONFIG
> +    else
> +	echo "no"
> +    fi
> +    rm -f $TMPDIR/open_by_handle_at_test.c $TMPDIR/open_by_handle_at_test
> +}
> +
>  check_ipset()
>  {
>      cat >$TMPDIR/ipsettest.c <<EOF
> @@ -492,6 +544,12 @@ fi
>  echo -n "libc has setns: "
>  check_setns

> +echo -n "libc has name_to_handle_at: "
> +check_name_to_handle_at
> +
> +echo -n "libc has open_by_handle_at: "
> +check_open_by_handle_at
> +
>  echo -n "SELinux support: "
>  check_selinux

> diff --git a/lib/fs.c b/lib/fs.c
> index ee0b130b..c561d85b 100644
> --- a/lib/fs.c
> +++ b/lib/fs.c
> @@ -30,6 +30,31 @@
>  /* if not already mounted cgroup2 is mounted here for iproute2's use */
>  #define MNT_CGRP2_PATH  "/var/run/cgroup2"

> +
> +#if (!defined HAVE_NAME_TO_HANDLE_AT && !defined HAVE_OPEN_BY_HANDLE_AT)
> +struct file_handle {
> +	unsigned handle_bytes;
> +	int handle_type;
> +	unsigned char f_handle[];
> +};
> +#endif
> +
> +#ifndef HAVE_NAME_TO_HANDLE_AT
> +int name_to_handle_at(int dirfd, const char *pathname,
> +	struct file_handle *handle, int *mount_id, int flags)
> +{
> +	return syscall(name_to_handle_at, 5, dirfd, pathname, handle,
> +	               mount_id, flags);
> +}
> +#endif
> +
> +#ifndef HAVE_OPEN_BY_HANDLE_AT
> +int open_by_handle_at(int mount_fd, struct file_handle *handle, int flags)
> +{
> +	return syscall(open_by_handle_at, 3, mount_fd, handle, flags);
> +}
> +#endif
> +
>  /* return mount path of first occurrence of given fstype */
>  static char *find_fs_mount(const char *fs_to_find)
>  {
