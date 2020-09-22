Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF7627396B
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 05:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgIVDyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 23:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgIVDyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 23:54:38 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB9DC061755;
        Mon, 21 Sep 2020 20:54:38 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id s19so11884470ybc.5;
        Mon, 21 Sep 2020 20:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CfXwqzOMug7BxP0M4t9uNo0tEJ6frAngNelu+lRrX84=;
        b=bcHFTzbrbm3t3mYmbyg3FTQiZKTUfbxaRjmAIeeiq8Hh9SsJH/HUK7nleM3eR9Dwf+
         ysylg8w91rN1lgT9pHFMqf/bxdhDOPxPvAtCrfuwa255n8ZzfD+Uk4R+cfQB9cgaI/+f
         Yp/9lLwm7N1Xt8OjcZ8FdpYvTQbQnzg6WCW2fhCjyQjlxhwtCbtYClQI37QMaQxHvJAA
         X+aAwd1zGjm8XKMnkpDs2XZBFKT1WRi3XmJcqTtOkTh7BkA9Vyh+6+0A7tp+11tXrRGp
         XxzMxbgGuxgh3tXx5NCZT4XF/9AA4czfn198yP+g3koEMvHDGHbrhbjrCiJyZSj+zQcy
         tc1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CfXwqzOMug7BxP0M4t9uNo0tEJ6frAngNelu+lRrX84=;
        b=GTxymkrazABpY3hV9IkmBn250stON+43JNANtS11Kt9YXs4y0Xq4EfoeKiQFDOATPP
         +Rzjkz9QqX51Jz19qSY7OgndgDfLQEAKWfW5P7LRKetXT1UlrHOWu9NR8CJNzezwOoHs
         liyWJRXioT/PtRiqAd0n0TizoCgJay/yilG4r4sNSyzPMn3hQEpggWNegrPs8caIzspm
         Wl3qXxOmvgwGbExEpREzEhE4uTQJ2pLQZUHHpUL8qwYSZ40Dl99o98ZhF2h0Kp3Syf3C
         3dUYOBrOL2YAV6GzTK+suTjyE32UaVpwr/Tdh25hIa5tNwU7Ws+aeif0Cl9DGZ0ex44E
         Trgg==
X-Gm-Message-State: AOAM532rLQN+JefJr0gNXRh6eQngOd829PyFI3mm5UbNRP7+asCy6d+S
        h09TNYPtuYYbsEXfy6dSIUOhPi0VosbThTkbWXxxSdc/UDM03Q==
X-Google-Smtp-Source: ABdhPJyI979XJ/9S7xWssX4P4khCgqQ0s/7ym9Klz7sNZ2FzpDhzk881BG993BuqIxTMky5+vkYA95R4+3IPkxKJLeQ=
X-Received: by 2002:a25:9d06:: with SMTP id i6mr4184144ybp.510.1600746877734;
 Mon, 21 Sep 2020 20:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200917135700.649909-1-luka.oreskovic@sartura.hr>
In-Reply-To: <20200917135700.649909-1-luka.oreskovic@sartura.hr>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 20:54:26 -0700
Message-ID: <CAEf4BzY0epfOGoq_Hreu0nAeX1-T9f+=TYLGrbZzBa4HLma5_A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add support for other map types to bpf_map_lookup_and_delete_elem
To:     Luka Oreskovic <luka.oreskovic@sartura.hr>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Juraj Vijtiuk <juraj.vijtiuk@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 7:16 AM Luka Oreskovic
<luka.oreskovic@sartura.hr> wrote:
>
> Since this function already exists, it made sense to implement it for
> map types other than stack and queue. This patch adds the necessary parts
> from bpf_map_lookup_elem and bpf_map_delete_elem so it works as expected
> for all map types.
>
> Signed-off-by: Luka Oreskovic <luka.oreskovic@sartura.hr>
> CC: Juraj Vijtiuk <juraj.vijtiuk@sartura.hr>
> CC: Luka Perkov <luka.perkov@sartura.hr>
> ---
>  kernel/bpf/syscall.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 2ce32cad5c8e..955de6ca8c45 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1475,6 +1475,9 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
>         if (CHECK_ATTR(BPF_MAP_LOOKUP_AND_DELETE_ELEM))
>                 return -EINVAL;
>
> +       if (attr->flags & ~BPF_F_LOCK)

If you want to use attr->flags, you need to update
BPF_MAP_LOOKUP_AND_DELETE_ELEM_LAST_FIELD few lines above. And every
new feature needs to come with selftests, so please check
tools/testing/selftests/bpf and latest patch sets adding new selftests
to see how it's done.

> +               return -EINVAL;
> +
>         f = fdget(ufd);
>         map = __bpf_map_get(f);
>         if (IS_ERR(map))
> @@ -1485,13 +1488,19 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
>                 goto err_put;
>         }
>
> +       if ((attr->flags & BPF_F_LOCK) &&
> +           !map_value_has_spin_lock(map)) {
> +               err = -EINVAL;
> +               goto err_put;
> +       }
> +
>         key = __bpf_copy_key(ukey, map->key_size);
>         if (IS_ERR(key)) {
>                 err = PTR_ERR(key);
>                 goto err_put;
>         }
>
> -       value_size = map->value_size;
> +       value_size = bpf_map_value_size(map);
>
>         err = -ENOMEM;
>         value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
> @@ -1502,7 +1511,24 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
>             map->map_type == BPF_MAP_TYPE_STACK) {
>                 err = map->ops->map_pop_elem(map, value);
>         } else {
> -               err = -ENOTSUPP;
> +               err = bpf_map_copy_value(map, key, value, attr->flags);
> +               if (err)
> +                       goto free_value;
> +
> +               if (bpf_map_is_dev_bound(map)) {
> +                       err = bpf_map_offload_delete_elem(map, key);
> +               } else if (IS_FD_PROG_ARRAY(map) ||
> +                          map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
> +                       /* These maps require sleepable context */
> +                       err = map->ops->map_delete_elem(map, key);
> +               } else {
> +                       bpf_disable_instrumentation();
> +                       rcu_read_lock();
> +                       err = map->ops->map_delete_elem(map, key);
> +                       rcu_read_unlock();
> +                       bpf_enable_instrumentation();
> +                       maybe_wait_bpf_programs(map);
> +               }

The whole point of this operation is to do lookup and deletion of
elements atomically. You can't do it with a separate lookup, followed
by a separate delete operation. Those two have to be implemented by
each type of map specifically. E.g., for hashmap, you'd have a
separate function implementation that takes a bucket lock, copies
data, and deletes entry, while still holding the lock. Of course
internally you'd want to reuse as much code as possible, but it will
be a separate bpf_map_ops operation.

>         }
>
>         if (err)
> --
> 2.26.2
>
