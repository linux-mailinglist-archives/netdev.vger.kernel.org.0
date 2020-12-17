Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3C52DC9F7
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 01:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgLQAfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbgLQAfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 19:35:38 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90C0C061794;
        Wed, 16 Dec 2020 16:34:57 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id y128so4560070ybf.10;
        Wed, 16 Dec 2020 16:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wXbiOWlu/SzBLKPWExoJ6MCxXjSp0oEVp36iYixZQW0=;
        b=Vsswb0Gq8rQgRuOzI5+QLTrFiSBSWH+iEeH/U+8F8u8DJAXPjjWxEq+GIW7BgownZy
         Gv0PeQ0Y87ReyiMJgF2qNt5SFz5M/+RLwH8lrjwLJmu8J4s7n4bYbgmE2H/1+HFOZ5JJ
         64g2QcK2vnZ7aoWTu+3XPHEsZtMfIXj5vU2A8MuzwQv78bhOwITLx2/+t24RH5T9camH
         NGtEkivmbY+tR9dNKVLGkibKs+yOWoV4611svjOhjbgAYxA3z6ghZFTlZ+Jh2dAB/OT4
         8JfngUbeudps0uuDUlA6TLQ07QB+Qjds9hRx9jEBM2DzQJ0pX36ekKzVrp0n3x3EAw5o
         t1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wXbiOWlu/SzBLKPWExoJ6MCxXjSp0oEVp36iYixZQW0=;
        b=rUFMAlz49KWKrvmZqU0vQM64tUJ1SZtMWu1mRURyjRzU6/uETKIecBH0QU6A1m9aB0
         GQ1FS2OhkXzhhMoRTKmUsSpxHzjZZxxrvqWE786OPBBWa2ZEe1TCfvolpvrFtpoUgtNx
         1KXP7bvZndJXSbqeLPW5T4pA8WkQ7TMwzBJzk3xU9hZmj5kqcDA5qOuqCTpsml6zA2MC
         AzlHkPf1W9MZ4D+zZ/j+8mh6K88SfM4OMtdj+15SxoC7sLxOPX84sbqAEgv2mLdw8iEy
         jqErEKo3H3qvUQK+6/Bm4dgnlq3zaZsZga6kbMQ4xHSwLAOnJ5jMiRtRWCVRq3c+Q+Hl
         jXhQ==
X-Gm-Message-State: AOAM530G3XCxUNNWoieeBRoqRNj1a7s2z2/pDWDy+F/UPr2saEfgWHkL
        xyZ4Qi55FZjx1BC7Vkk6WN32ASl4wdJhwbOe2Y8=
X-Google-Smtp-Source: ABdhPJxid8iDzN640UZtRY3k659ZBI7Mxi59/ofndTRQFRrSqNZldWQN43x2Y+ScoMwI3TZ6jrLK2Es5Q4MP+Gv6648=
X-Received: by 2002:a25:e804:: with SMTP id k4mr50192621ybd.230.1608165296717;
 Wed, 16 Dec 2020 16:34:56 -0800 (PST)
MIME-Version: 1.0
References: <20201215233702.3301881-1-songliubraving@fb.com> <20201215233702.3301881-2-songliubraving@fb.com>
In-Reply-To: <20201215233702.3301881-2-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Dec 2020 16:34:46 -0800
Message-ID: <CAEf4BzYNAd7V=EevVYiz48+q=UjNnRBzfQFA4tTYCX8a9Wfu7A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 3:37 PM Song Liu <songliubraving@fb.com> wrote:
>
> Introduce task_vma bpf_iter to print memory information of a process. It
> can be used to print customized information similar to /proc/<pid>/maps.
>
> task_vma iterator releases mmap_lock before calling the BPF program.
> Therefore, we cannot pass vm_area_struct directly to the BPF program. A
> new __vm_area_struct is introduced to keep key information of a vma. On
> each iteration, task_vma gathers information in __vm_area_struct and
> passes it to the BPF program.
>
> If the vma maps to a file, task_vma also holds a reference to the file
> while calling the BPF program.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  include/linux/bpf.h    |   2 +-
>  kernel/bpf/task_iter.c | 205 ++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 205 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 07cb5d15e7439..49dd1e29c8118 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1325,7 +1325,7 @@ enum bpf_iter_feature {
>         BPF_ITER_RESCHED        = BIT(0),
>  };
>
> -#define BPF_ITER_CTX_ARG_MAX 2
> +#define BPF_ITER_CTX_ARG_MAX 3
>  struct bpf_iter_reg {
>         const char *target;
>         bpf_iter_attach_target_t attach_target;
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index 0458a40edf10a..15a066b442f75 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -304,9 +304,183 @@ static const struct seq_operations task_file_seq_ops = {
>         .show   = task_file_seq_show,
>  };
>
> +/*
> + * Key information from vm_area_struct. We need this because we cannot
> + * assume the vm_area_struct is still valid after each iteration.
> + */
> +struct __vm_area_struct {
> +       __u64 start;
> +       __u64 end;
> +       __u64 flags;
> +       __u64 pgoff;

I'd keep the original names of the fields (vm_start, vm_end, etc). But
there are some more fields which seem useful, like vm_page_prot,
vm_mm, etc.

It's quite unfortunate, actually, that bpf_iter program doesn't get
access to the real vm_area_struct, because it won't be able to do much
beyond using fields that we pre-defined here. E.g., there could be
interesting things to do with vm_mm, but unfortunately it won't be
possible.

Is there any way to still provide access to the original
vm_area_struct and let BPF programs use BTF magic to follow all those
pointers (like vm_mm) safely?

> +};
> +

[...]
