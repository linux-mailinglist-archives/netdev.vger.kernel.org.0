Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A1B3778F9
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 00:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhEIWVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 18:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhEIWVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 18:21:16 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4263C061573;
        Sun,  9 May 2021 15:20:12 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id s20-20020a4ae9940000b02902072d5df239so614435ood.2;
        Sun, 09 May 2021 15:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S6Nf8JbLGGWqrqhWXQQ/oWuBX0KLtTZTx7RqDf42bpE=;
        b=rbstFNT8qNJyYSKn0TYLj1LJ6FVHQXbsMybOCj+IAkDhxLMGOo8C99X8y/mRhj6jH3
         CxcZV/EveHVZ7zFMcYYhnY7dC+hHmBCNzTr65rigSzfk4IpfH/lvGGKHIR5Il42EkZ0D
         O7AIJcsg7h+zOzUCHmHTPqQkloPATtP/04+Q5GEMeTNlFHyusp2FZGfDZfZUYTMGX6wh
         /8f/XmVZsOY570+xdr8RePeoW4ffg0KAKhb4BXWHbFaY4NGPm5oUdZ3sqDsrlYMewSGM
         zg6FTgUsvSL8+AicxAibuDjCFZdzUZyYhbYR/i+uuteuiPkSHyWWv8ILVc4Hd7g84ucI
         XPcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S6Nf8JbLGGWqrqhWXQQ/oWuBX0KLtTZTx7RqDf42bpE=;
        b=EsADaJXT3zRtBWdc5eVJfE1AsBT2Bxrk8JYfbgb2GK6/zWmcvYhvnTB85ORcQ730if
         8GeASe7LTFijeMj0ldyK4HY/F5RkM9JxFRzE13jex0ZPCQ8cPMwInOY54Ghu77mTxpZI
         +5R2wFhtDA4d1anKaPIiP1GhGyJvpQ2Ffq4PtaHgj9jGvWchthEdRFzz9s0etiKbHVk4
         sSVEcAOZlNzIYL5pPvihorG3jtckYUOqpZ/2xgstJPFOWOLXyV+nwSWx/ecfe8SemA6P
         /8NpoJNVu608v4+e7j92zF9bbUAM08dw1AN0c48ikwCOhzF1YD8++CRqUpX2jIHsAlQK
         VbCw==
X-Gm-Message-State: AOAM532RHTZN8ysp4/WOjfuvcDYc68r2YfbN8ul0nGYnxTOpd9+2CgcT
        wkbJ+CtrhhBnzOfgUTkIU4IXDZd0CvE=
X-Google-Smtp-Source: ABdhPJwRk3R7G4gby9+eKfLC2gBGDLOBMwdzMoHer90kd8n6ZgW6Wy/fhxyUftAiknrMJuEyHj4new==
X-Received: by 2002:a4a:946b:: with SMTP id j40mr13053029ooi.10.1620598811843;
        Sun, 09 May 2021 15:20:11 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:5d79:6512:fce6:88aa])
        by smtp.googlemail.com with ESMTPSA id m25sm2259266oih.15.2021.05.09.15.20.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 15:20:11 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
To:     Heiko Thiery <heiko.thiery@gmail.com>, netdev@vger.kernel.org
Cc:     petr.vorel@gmail.com, linux-kernel@vger.kernel.org,
        stephen@networkplumber.org, Dmitry Yakunin <zeil@yandex-team.ru>
References: <20210508064925.8045-1-heiko.thiery@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6ba0adf4-5177-c50a-e921-bee898e3fdb9@gmail.com>
Date:   Sun, 9 May 2021 16:20:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508064925.8045-1-heiko.thiery@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/21 12:49 AM, Heiko Thiery wrote:
> With commit d5e6ee0dac64 the usage of functions name_to_handle_at() and
> open_by_handle_at() are introduced. But these function are not available
> e.g. in uclibc-ng < 1.0.35. To have a backward compatibility check for the
> availability in the configure script and in case of absence do a direct
> syscall.
> 
> Fixes: d5e6ee0dac64 ("ss: introduce cgroup2 cache and helper functions")
> Cc: Dmitry Yakunin <zeil@yandex-team.ru>
> Cc: Petr Vorel <petr.vorel@gmail.com>
> Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
> ---
> v3:
>  - use correct syscall number (thanks to Petr Vorel)
>  - add #include <sys/syscall.h> (thanks to Petr Vorel)
>  - remove bogus parameters (thanks to Petr Vorel)
>  - fix #ifdef (thanks to Petr Vorel)
>  - added Fixes tag (thanks to David Ahern)
>  - build test with buildroot 2020.08.3 using uclibc 1.0.34
> 
> v2:
>  - small correction to subject
>  - removed IP_CONFIG_HANDLE_AT:=y option since it is not required
>  - fix indentation in check function
>  - removed empty lines (thanks to Petr Vorel)
>  - add #define _GNU_SOURCE in check (thanks to Petr Vorel)
>  - check only for name_to_handle_at (thanks to Petr Vorel)
> 
>  configure | 28 ++++++++++++++++++++++++++++
>  lib/fs.c  | 25 +++++++++++++++++++++++++
>  2 files changed, 53 insertions(+)
> 
> diff --git a/configure b/configure
> index 2c363d3b..179eae08 100755
> --- a/configure
> +++ b/configure
> @@ -202,6 +202,31 @@ EOF
>      rm -f $TMPDIR/setnstest.c $TMPDIR/setnstest
>  }
>  
> +check_name_to_handle_at()
> +{
> +    cat >$TMPDIR/name_to_handle_at_test.c <<EOF
> +#define _GNU_SOURCE
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
> +    if $CC -I$INCLUDE -o $TMPDIR/name_to_handle_at_test $TMPDIR/name_to_handle_at_test.c >/dev/null 2>&1; then
> +        echo "yes"
> +        echo "CFLAGS += -DHAVE_HANDLE_AT" >>$CONFIG
> +    else
> +        echo "no"
> +    fi
> +    rm -f $TMPDIR/name_to_handle_at_test.c $TMPDIR/name_to_handle_at_test
> +}
> +
>  check_ipset()
>  {
>      cat >$TMPDIR/ipsettest.c <<EOF
> @@ -492,6 +517,9 @@ fi
>  echo -n "libc has setns: "
>  check_setns
>  
> +echo -n "libc has name_to_handle_at: "
> +check_name_to_handle_at
> +
>  echo -n "SELinux support: "
>  check_selinux
>  
> diff --git a/lib/fs.c b/lib/fs.c
> index f161d888..05697a7e 100644
> --- a/lib/fs.c
> +++ b/lib/fs.c
> @@ -25,11 +25,36 @@
>  
>  #include "utils.h"
>  
> +#ifndef HAVE_HANDLE_AT
> +# include <sys/syscall.h>
> +#endif
> +
>  #define CGROUP2_FS_NAME "cgroup2"
>  
>  /* if not already mounted cgroup2 is mounted here for iproute2's use */
>  #define MNT_CGRP2_PATH  "/var/run/cgroup2"
>  
> +
> +#ifndef HAVE_HANDLE_AT
> +struct file_handle {
> +	unsigned handle_bytes;
> +	int handle_type;
> +	unsigned char f_handle[];
> +};
> +
> +static int name_to_handle_at(int dirfd, const char *pathname,
> +	struct file_handle *handle, int *mount_id, int flags)
> +{
> +	return syscall(__NR_name_to_handle_at, dirfd, pathname, handle,
> +	               mount_id, flags);
> +}
> +
> +static int open_by_handle_at(int mount_fd, struct file_handle *handle, int flags)
> +{
> +	return syscall(__NR_open_by_handle_at, mount_fd, handle, flags);
> +}
> +#endif
> +
>  /* return mount path of first occurrence of given fstype */
>  static char *find_fs_mount(const char *fs_to_find)
>  {
> 

This causes compile failures if anyone is reusing a tree. It would be
good to require config.mk to be updated if configure is newer.
