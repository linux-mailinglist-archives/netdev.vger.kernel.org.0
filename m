Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD2D1BD458
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgD2GEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgD2GEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:04:33 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFF0C03C1AD;
        Tue, 28 Apr 2020 23:04:33 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id ck5so596762qvb.11;
        Tue, 28 Apr 2020 23:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cCJAeLyoBkU+6A6P/hjtUnfH3mixf9wkOhn+RnpyFQU=;
        b=L4Lxk8XxhzwfAxyFxkZ82gT9EfiaTOy5nECBQkhTKjuCXr2nvejbMbCknb95jp9hVa
         Q24dfWqeyHGAEBcjuMRqqAKdXhc4CltQ2vJm/zvLgwebEdwvEJL5aEBERtHkjAzLkYWf
         p+pFDOBqBZTancF3/AT7BxkaOwth/fNqdxApsQfjA1NeirsLx4hGgwl2chiHgA7Fhzb3
         HMUNgfBQbNEcIQyT6S2mEoq7nmmzLvE9yzs2RAU53/h0uIZTb9HWPpcjGuWHYmlH7Sn/
         wxJJnso443/SqogHX5X7vXeoEBpCmrmvjQUXs5fk1aFnWdosoa1E3woP+BBU8JeuyqoB
         jMmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cCJAeLyoBkU+6A6P/hjtUnfH3mixf9wkOhn+RnpyFQU=;
        b=nNc5qxPHKLmGh2cWIHKXcgCsb1KHpUO7f+EjBV3Ci/DU0beSh/fw64DmheFlKs46So
         Wa1mxs1SF0ec7hLM4XzPZK3ll2AKqo5nBriQpO9Xf9UC7M++crrxRVC6DUMl4TGUy+OH
         NkG6HtxHlr/Z1+XkjaQkf7gfX1n8zsfGJUu6F/BXjhFN4R+Le2J1eoSNR9Bl2ChOIGdm
         8PFw0CwTQe/RXw9H9OvqVt3iNesYe40USjO6G+1mKDX6GhrivrGuF+dbFaykOqTVMtB9
         3UUtwMC6szbds5VPEh3UFiipVkwylpx1B0PBPdJ+yGFbWUiJKgOQXkd6B/kgiqfvjb6u
         plaQ==
X-Gm-Message-State: AGi0PuYc3NINcmMP/MU/RdGFqsS+DmWG4ca1I9NDB2h2soHBEwD9po9Z
        Yx2ltXcxFjeRYGpdgN8O7LjDDyJyI0WUTKSV5tFy0AJ3
X-Google-Smtp-Source: APiQypK2m04SXpfF/QUpfpeNNKQNH2pn6ZL1tWJyaRnMTpnQc59oV/rs/G/fK/5KmC0jvndb4Embz4kvD9tBcHLXUf8=
X-Received: by 2002:a0c:e844:: with SMTP id l4mr30742394qvo.247.1588140272876;
 Tue, 28 Apr 2020 23:04:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201237.2994794-1-yhs@fb.com>
In-Reply-To: <20200427201237.2994794-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Apr 2020 23:04:21 -0700
Message-ID: <CAEf4BzbVtg57x0G0VKaGy4wFqkc22Wi_xDv6OaT9oDNrfVRsog@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 1:18 PM Yonghong Song <yhs@fb.com> wrote:
>
> The bpf_map iterator is implemented.
> The bpf program is called at seq_ops show() and stop() functions.
> bpf_iter_get_prog() will retrieve bpf program and other
> parameters during seq_file object traversal. In show() function,
> bpf program will traverse every valid object, and in stop()
> function, bpf program will be called one more time after all
> objects are traversed.
>
> The first member of the bpf context contains the meta data, namely,
> the seq_file, session_id and seq_num. Here, the session_id is
> a unique id for one specific seq_file session. The seq_num is
> the number of bpf prog invocations in the current session.
> The bpf_iter_get_prog(), which will be implemented in subsequent
> patches, will have more information on how meta data are computed.
>
> The second member of the bpf context is a struct bpf_map pointer,
> which bpf program can examine.
>
> The target implementation also provided the structure definition
> for bpf program and the function definition for verifier to
> verify the bpf program. Specifically for bpf_map iterator,
> the structure is "bpf_iter__bpf_map" andd the function is
> "__bpf_iter__bpf_map".
>
> More targets will be implemented later, all of which will include
> the following, similar to bpf_map iterator:
>   - seq_ops() implementation
>   - function definition for verifier to verify the bpf program
>   - seq_file private data size
>   - additional target feature
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h   |  10 ++++
>  kernel/bpf/Makefile   |   2 +-
>  kernel/bpf/bpf_iter.c |  19 ++++++++
>  kernel/bpf/map_iter.c | 107 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c  |  13 +++++
>  5 files changed, 150 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/bpf/map_iter.c
>

[...]

> +static int __init bpf_map_iter_init(void)
> +{
> +       struct bpf_iter_reg reg_info = {
> +               .target                 = "bpf_map",
> +               .target_func_name       = "__bpf_iter__bpf_map",

I wonder if it would be better instead of strings to use a pointer to
a function here. It would preserve __bpf_iter__bpf_map function
without __init, plus it's hard to mistype the name accidentally. In
bpf_iter_reg_target() one would just need to find function in kallsyms
by function address and extract it's name.

Or that would be too much trouble?

> +               .seq_ops                = &bpf_map_seq_ops,
> +               .seq_priv_size          = sizeof(struct bpf_iter_seq_map_info),
> +               .target_feature         = 0,
> +       };
> +
> +       return bpf_iter_reg_target(&reg_info);
> +}
> +
> +late_initcall(bpf_map_iter_init);
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 7626b8024471..022187640943 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2800,6 +2800,19 @@ static int bpf_obj_get_next_id(const union bpf_attr *attr,
>         return err;
>  }
>
> +struct bpf_map *bpf_map_get_curr_or_next(u32 *id)
> +{
> +       struct bpf_map *map;
> +
> +       spin_lock_bh(&map_idr_lock);
> +       map = idr_get_next(&map_idr, id);
> +       if (map)
> +               map = __bpf_map_inc_not_zero(map, false);

When __bpf_map_inc_not_zero return ENOENT, it doesn't mean there are
no more BPF maps, it just means that the current one we got was
already released (or in the process of being released). I think you
need to retry with id+1 in such case, otherwise your iteration might
end prematurely.

> +       spin_unlock_bh(&map_idr_lock);
> +
> +       return map;
> +}
> +
>  #define BPF_PROG_GET_FD_BY_ID_LAST_FIELD prog_id
>
>  struct bpf_prog *bpf_prog_by_id(u32 id)
> --
> 2.24.1
>
