Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125442732B0
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 21:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgIUTVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 15:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgIUTVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 15:21:31 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C495DC061755;
        Mon, 21 Sep 2020 12:21:31 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id v60so11062850ybi.10;
        Mon, 21 Sep 2020 12:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6zOCyCAt5dSOUkjchfsL4+jShYSEXRJ8JxFzICLYSbc=;
        b=pUpEP6yzD4/KTspsufCfL+5j4vpzNWbIAyOommBjdlGk8bO3hD6g26YI+MUwsybCuH
         Ou37eMjLXcZ+oluFV9m8E1Nbmka1h+6N6FzjPmCLCbL8zWF++x4h9mhJZOiIib0HCrGn
         k/S5pDZsZ8rDAS0I0ksHGrnIlOWOWHLTdKjjDdKUJH+Ggy5B29qgQGyOg6giyCB562pf
         0ArISdAwGbNW1dsXbGF9Zq0OYqbflDs+dZY39cAI+bZGautQRuAVIE8IKeczJvN63jcO
         prkGJb1FkAJ2iWqASkuqryb0aKNaGK3BLG1tUlWPQQ084uu0AasbZCyymMid7NwCWj09
         jxtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6zOCyCAt5dSOUkjchfsL4+jShYSEXRJ8JxFzICLYSbc=;
        b=M/rarK9kiN/JNI+FWA9W3+JzbrmaB/BNC5TLSOSZa5NukCBjI6FsfLOCrEa61HlxWD
         pJmhYsinrFngk0TWioNHwDRJJlBk69zwabxpTwHKznSFsaXo/8qlCzHNqI4MPXYyld8U
         Y0YgkoVeNfB/lgXkzf93/y8zkL21tdtafTGKaifcHrIV1BgiXcxR7x5DmrfqoXS1DKdq
         wQfz4YFoHc9hWcwNxbafXa5nnFJFVGXbhlxXvd5nkrGr+At36I81g5WyeOx3ENuoRRRU
         RY7FrBmy8CnNzRB4AFiwXWl/JCs3VdAggBeGXR5lesrZauw3TB5H1Fz3TyzwNU95kpTg
         q+eQ==
X-Gm-Message-State: AOAM5328UCQETWBlH+s2y3gy4gcmBgYxEy+WUrdqr3T7EQJHrQk2ZREp
        0McFkMnwZ3bnKoIu+kQi18batbVPo0k0/b0cmGc=
X-Google-Smtp-Source: ABdhPJzJsoyyEBkjBbzm0q/P9QGohlj9SxcCOn8bXiYSJZoi5o4o+1xUCF0+DrxVvnG/77aOROeFOjfsFfO4K/IilR0=
X-Received: by 2002:a25:33c4:: with SMTP id z187mr1850240ybz.27.1600716090971;
 Mon, 21 Sep 2020 12:21:30 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1600417359.git.Tony.Ambardar@gmail.com> <b38db205a66238f70823039a8c531535864eaac5.1600417359.git.Tony.Ambardar@gmail.com>
In-Reply-To: <b38db205a66238f70823039a8c531535864eaac5.1600417359.git.Tony.Ambardar@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 12:21:20 -0700
Message-ID: <CAEf4BzYzVzWEePW6H=2NXY1egeYn4VFVWpnP9EZgqKd+ckZLeg@mail.gmail.com>
Subject: Re: [PATCH bpf v1 1/3] bpf: fix sysfs export of empty BTF section
To:     Tony Ambardar <tony.ambardar@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 10:05 PM Tony Ambardar <tony.ambardar@gmail.com> wrote:
>
> If BTF data is missing or removed from the ELF section it is still exported
> via sysfs as a zero-length file:
>
>   root@OpenWrt:/# ls -l /sys/kernel/btf/vmlinux
>   -r--r--r--    1 root    root    0 Jul 18 02:59 /sys/kernel/btf/vmlinux
>
> Moreover, reads from this file succeed and leak kernel data:
>
>   root@OpenWrt:/# hexdump -C /sys/kernel/btf/vmlinux|head -10
>   000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |................|
>   *
>   000cc0 00 00 00 00 00 00 00 00 00 00 00 00 80 83 b0 80 |................|
>   000cd0 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |................|
>   000ce0 00 00 00 00 00 00 00 00 00 00 00 00 57 ac 6e 9d |............W.n.|
>   000cf0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |................|
>   *
>   002650 00 00 00 00 00 00 00 10 00 00 00 01 00 00 00 01 |................|
>   002660 80 82 9a c4 80 85 97 80 81 a9 51 68 00 00 00 02 |..........Qh....|
>   002670 80 25 44 dc 80 85 97 80 81 a9 50 24 81 ab c4 60 |.%D.......P$...`|
>
> This situation was first observed with kernel 5.4.x, cross-compiled for a
> MIPS target system. Fix by adding a sanity-check for export of zero-length
> data sections.
>
> Fixes: 341dfcf8d78e ("btf: expose BTF info through sysfs")
>
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> ---

Apparently sysfs infrastructure doesn't validate read position and
size when bin_attribute's size is 0, and just expects read callback to
handle such situation explicitly. Preventing sysfs entry from
registering seems like a good solution. Thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/sysfs_btf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/bpf/sysfs_btf.c b/kernel/bpf/sysfs_btf.c
> index 3b495773de5a..11b3380887fa 100644
> --- a/kernel/bpf/sysfs_btf.c
> +++ b/kernel/bpf/sysfs_btf.c
> @@ -30,15 +30,15 @@ static struct kobject *btf_kobj;
>
>  static int __init btf_vmlinux_init(void)
>  {
> -       if (!__start_BTF)
> +       bin_attr_btf_vmlinux.size = __stop_BTF - __start_BTF;
> +
> +       if (!__start_BTF || bin_attr_btf_vmlinux.size == 0)
>                 return 0;
>
>         btf_kobj = kobject_create_and_add("btf", kernel_kobj);
>         if (!btf_kobj)
>                 return -ENOMEM;
>
> -       bin_attr_btf_vmlinux.size = __stop_BTF - __start_BTF;
> -
>         return sysfs_create_bin_file(btf_kobj, &bin_attr_btf_vmlinux);
>  }
>
> --
> 2.25.1
>
