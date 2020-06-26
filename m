Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E2520BB8A
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgFZV2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFZV2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 17:28:42 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF22C03E979;
        Fri, 26 Jun 2020 14:28:42 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id j10so8555898qtq.11;
        Fri, 26 Jun 2020 14:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gydKA1hO0VAz0nB5N0AB8M1MYJXtcpKM107dDDv6C3I=;
        b=NvG+WtxHs6lIwXduOd46oFfnZURyvzEBNZ3BP3RjnoushtnHUhCAO7gas/FTDdpG27
         WDnwzggSUba3ltwSBF9SCdXLgLKQGdQkvLuoN/4QWtT9zGKRgryRVIc5zWZy8q+0MMG/
         YnyUY5QJEAKjTOq7WGFdZ/yxzdTtmHu2iLKzjVPPhBv5mnbCUE1kGsGWJM6AFBHSds7j
         Ll4CIj8gdVKCYH5bzT5NQXYcl/EavTQqENn/mTbQHAHspGSdhMoTxyMQjUj5zXrcz7/5
         XaKoxNDY9O+O2kv/WOVKqcOvYQhV7IauOESNmgdithqYOEwXkL81TeLs5Hqgmf4QLegn
         Ev4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gydKA1hO0VAz0nB5N0AB8M1MYJXtcpKM107dDDv6C3I=;
        b=YnTa5IYFz0GrrBZF8E92wnxgnoLQ98lE7TK3CJKPXvNpi10PIMUw/oInokmnY6aK+q
         C5KL67XyNmI9ET4s99wlawyMujr4LOKhPMQMJ2gh3/8Gb7A7pgrXEMI8olMk+ah12Hsv
         KF+2khLVyGEQrcJf6QSZvFPrN166Q99a3exndHH5Zv5iz5HGgUrZ4lzfjdJNjrwPMIdW
         tsbazV/TL0khGPiUbIZlylhbdWT6aIR8wnaUSKZAtuP8NuEJqwky1ba09Q2lp/Z3B3yq
         CDinG3WfuoWMJBe/1Dl10KU+PXx6h1bndTNGGBRZmZ1RSQRN4ks6Db4uaLJTMfwO87yX
         ckzQ==
X-Gm-Message-State: AOAM530I2wnscWlo+i4lyROOwVN1oVVkgu3TaUJ9OLxl4n7qSEscRUFZ
        1t0Mr2QIn7BENM+BnuV00/S930nU4Qw8fjD3mb8=
X-Google-Smtp-Source: ABdhPJwkWO19E6lWyxrUcS56Bvj/K/pn/9t/SA+lxDyQ0+Y5hzdo0UpRgs7zFIJ0bPgOTkhcjlSEISpwjColO8AL6DE=
X-Received: by 2002:ac8:1991:: with SMTP id u17mr4732103qtj.93.1593206921794;
 Fri, 26 Jun 2020 14:28:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org> <20200625221304.2817194-3-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 14:28:30 -0700
Message-ID: <CAEf4BzZw-asXypkTnzEEn7B86Yy3uUHZaj2qaUxd68hvpS73Eg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 02/14] bpf: Compile resolve_btfids tool at
 kernel compilation start
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 4:47 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The resolve_btfids tool will be used during the vmlinux linking,
> so it's necessary it's ready for it.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Not sure about clean target, but otherwise looks good to me.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  Makefile           | 22 ++++++++++++++++++----
>  tools/Makefile     |  3 +++
>  tools/bpf/Makefile |  5 ++++-
>  3 files changed, 25 insertions(+), 5 deletions(-)
>

[...]

> diff --git a/tools/bpf/Makefile b/tools/bpf/Makefile
> index 6df1850f8353..89ae235b790e 100644
> --- a/tools/bpf/Makefile
> +++ b/tools/bpf/Makefile
> @@ -123,5 +123,8 @@ runqslower_install:
>  runqslower_clean:
>         $(call descend,runqslower,clean)
>
> +resolve_btfids:
> +       $(call descend,resolve_btfids)
> +

I think we talked about this. Did we decide that resolve_btfids_clean
is not necessary?

>  .PHONY: all install clean bpftool bpftool_install bpftool_clean \
> -       runqslower runqslower_install runqslower_clean
> +       runqslower runqslower_install runqslower_clean resolve_btfids
> --
> 2.25.4
>
