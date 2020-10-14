Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B5728EA5C
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 03:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389471AbgJOBk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 21:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389051AbgJOBjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 21:39:37 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D459BC08E750;
        Wed, 14 Oct 2020 16:14:23 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id a12so665893ybg.9;
        Wed, 14 Oct 2020 16:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+TxA1eVq5hDXrXB1ainVY56azVPdjHNrlDThbfft6Xk=;
        b=dOlK7WgIMIvU6S8UBVybPwb1kihHLZuTIY7hRXp6YKjqHQVaPRvwPp8v2EdQKkBRvf
         Ndz+hd1RJ3JlYH3XpQ9ur0npCUXsU4PybX9r7dh2WmL7Ts7zSXWFI3fu1ubGTLdigFTu
         PqqAoSEmFkB76zxp/AUbYRMi5PRTwpAHZsh6sSLF14z7v8O0RWQzrQ11AZ5HD1nJEruf
         vEUyrMA5CWIP3nOztsW6E8Ts6Byj+ePQV2HLdLlAprJo4xoXzuD3gjiXfw+gVxDzo0Gf
         JRngFRrIz3bfL2tz0wC6ipAcSxq6CU0UFjiiv4eNGHpvNJTa+qWBg9LTnkxPMA667Iv1
         i68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+TxA1eVq5hDXrXB1ainVY56azVPdjHNrlDThbfft6Xk=;
        b=bOLa2FLf0oOcBTIwDexzKfFyeyP/NPpqzrtTeANxYDuHTOoV0UVA+fFbfkTirt1D4m
         ZFguu+9rh1WPvAOqwUfmJsNNMTLIPu+koINiuZMDxbjjYhFuo7YOqG+eHCm5UFayMJlz
         ywCcpJTIHfjlUSF2scpkPVx9gY9qSAJMjpbtraV7cwUsaOfA5ZscRa6Zp1uZjOpjy4ld
         HD0In5qiUNa4i6X997tswYrAjxBvUgbuTZOHkRqSK4t3WG5edwcBecQc2EOw6UGIiIJl
         KnhG37DbZLssQa/PXNIIKPj9XyFOAnq+I6Am/Pwdd28TdUsdsLzwIJh/zMrvwuQDDJhZ
         0ZNw==
X-Gm-Message-State: AOAM530MMSRyJV0df451AiGrqw+CDa8DMumhHoGFn3p+MDlI3somVSaT
        YEeFxGyNrq/ktLeBbqW3A4IuKaDmGvTTMKwmo0s=
X-Google-Smtp-Source: ABdhPJyVuXJtUXMg8l9uSGljdOWliCYwXqILkR18Z0VoBiCuN9zEZGNwqim7MP+XZwmRW+K4+3PNNKuT66dgSN0W/rI=
X-Received: by 2002:a25:8541:: with SMTP id f1mr1486159ybn.230.1602717263045;
 Wed, 14 Oct 2020 16:14:23 -0700 (PDT)
MIME-Version: 1.0
References: <20201014144612.2245396-1-yhs@fb.com>
In-Reply-To: <20201014144612.2245396-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Oct 2020 16:14:12 -0700
Message-ID: <CAEf4BzZ4J-c-ODnBD3C8NJeeLOdCqLWvFadWXR8t9eFKaGZOvw@mail.gmail.com>
Subject: Re: [PATCH net v3] net: fix pos incrementment in ipv6_route_seq_next
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Vasily Averin <vvs@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 2:53 PM Yonghong Song <yhs@fb.com> wrote:
>
> Commit 4fc427e05158 ("ipv6_route_seq_next should increase position index")
> tried to fix the issue where seq_file pos is not increased
> if a NULL element is returned with seq_ops->next(). See bug
>   https://bugzilla.kernel.org/show_bug.cgi?id=206283
> The commit effectively does:
>   - increase pos for all seq_ops->start()
>   - increase pos for all seq_ops->next()
>
> For ipv6_route, increasing pos for all seq_ops->next() is correct.
> But increasing pos for seq_ops->start() is not correct
> since pos is used to determine how many items to skip during
> seq_ops->start():
>   iter->skip = *pos;
> seq_ops->start() just fetches the *current* pos item.
> The item can be skipped only after seq_ops->show() which essentially
> is the beginning of seq_ops->next().
>
> For example, I have 7 ipv6 route entries,
>   root@arch-fb-vm1:~/net-next dd if=/proc/net/ipv6_route bs=4096
>   00000000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000400 00000001 00000000 00000001     eth0
>   fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
>   fe800000000000002050e3fffebd3be8 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>   ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000004 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   0+1 records in
>   0+1 records out
>   1050 bytes (1.0 kB, 1.0 KiB) copied, 0.00707908 s, 148 kB/s
>   root@arch-fb-vm1:~/net-next
>
> In the above, I specify buffer size 4096, so all records can be returned
> to user space with a single trip to the kernel.
>
> If I use buffer size 128, since each record size is 149, internally
> kernel seq_read() will read 149 into its internal buffer and return the data
> to user space in two read() syscalls. Then user read() syscall will trigger
> next seq_ops->start(). Since the current implementation increased pos even
> for seq_ops->start(), it will skip record #2, #4 and #6, assuming the first
> record is #1.
>
>   root@arch-fb-vm1:~/net-next dd if=/proc/net/ipv6_route bs=128

Did you test with non-zero skip= parameter as well (to force lseek)?
To make sure we don't break the scenario that original fix tried to
fix.

If that works:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

[...]

> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 141c0a4c569a..605cdd38a919 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -2622,8 +2622,10 @@ static void *ipv6_route_seq_start(struct seq_file *seq, loff_t *pos)
>         iter->skip = *pos;
>
>         if (iter->tbl) {
> +               loff_t p = 0;
> +
>                 ipv6_route_seq_setup_walk(iter, net);
> -               return ipv6_route_seq_next(seq, NULL, pos);
> +               return ipv6_route_seq_next(seq, NULL, &p);

nit: comment here wouldn't hurt for the next guy stumbling upon this
code and wondering why we ignore p afterwards

>         } else {
>                 return NULL;
>         }
> --
> 2.24.1
>
