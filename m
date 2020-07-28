Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC694231639
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 01:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbgG1Xfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 19:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730346AbgG1Xf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 19:35:29 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E60DC061794;
        Tue, 28 Jul 2020 16:35:29 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id m9so10016845qvx.5;
        Tue, 28 Jul 2020 16:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aKtYUNKZ4EAbUdHPrlHd5OqyFQEGTzRyJpzUiSU45kE=;
        b=LXsV9SefhI0h6Vx3hprMRrvj6Co4GEPSleoEnC0gNSmyVkOWmoWjEYwLeTlJv9K2fo
         UBU12mcGRXNN8Nmn/WLnC39QWzuobqYWnP1GmdaCsA7UTT00dIlzMFzzn5Z2E0hZCBQW
         afBLzRB3StBK+5IIlO1615bk+4LI+Kbbb4ukc75g6V/eRb/ei5oUSdrZn4tvITK80e6W
         qyFoFqVC2gr4FfeERIP6+Sj6LFqMSO67/l9Phbtai5cNEUYICjLZ2pjeF/f9ocniK6Kd
         WRovsZvjD46Lm3ZaXirl9v71QT72SZVayLDs04CgzeNLHRn2Zpu2pE9432CrSOzWWj0n
         mZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aKtYUNKZ4EAbUdHPrlHd5OqyFQEGTzRyJpzUiSU45kE=;
        b=T2VwUGqgbXRX9BjlMzehjwtimoawkkvvNDaVVKIZTkqygoigkMBG6TciWMy+6mXMpI
         tDCaxs/i+vPAr8JxATd6lKeuXc1uL9ZAkNq+Ru9lRmC/KTPgnlgYNXD9zqTEJBjcQfS2
         SnnFQWI04ZKCjV/ulBIw4xM5U5kngz+xByubLjtzUS7WQsumIiO9bTMlFfSoBre6Opdy
         38rvaYErFAKJYFe1P9jUE5oZlzt4gtz97J85FByLLCMwCwWEky+Vs9p6VoVFARA2u4zF
         99JHRxVeVu3ZqGHrHxc5RHp+e1ApEN5LevmbNhza7VXli1CJWAUuk8eRS7v5adfu7WCW
         MsJw==
X-Gm-Message-State: AOAM532RkP8pa+K97NZ1mxfqP7X+qm2BhQUgnOuS2W1p3WBKw/tIHmiL
        daGNT7m18Lj/dgsQ/HMnc8DqF/fS0P+6QAdRgGs48gXfeFE=
X-Google-Smtp-Source: ABdhPJwcHoPkzXYWh/CPkoJKXwNGxEZsPtT62qS2kpoWg+Zx8Tg5l2ZnxxzsmOA2+y7JpXNhmTKMny+AwUW0zZ4OvKo=
X-Received: by 2002:a05:6214:8f4:: with SMTP id dr20mr28450394qvb.228.1595979327410;
 Tue, 28 Jul 2020 16:35:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200722211223.1055107-1-jolsa@kernel.org> <20200722211223.1055107-8-jolsa@kernel.org>
In-Reply-To: <20200722211223.1055107-8-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 16:35:16 -0700
Message-ID: <CAEf4BzacqauEc8=o29EBUsmvTMs3FZ+-Kcc4cSJ9Te4yh5-7qg@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 07/13] bpf: Add btf_struct_ids_match function
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 2:13 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding btf_struct_ids_match function to check if given address provided
> by BTF object + offset is also address of another nested BTF object.
>
> This allows to pass an argument to helper, which is defined via parent
> BTF object + offset, like for bpf_d_path (added in following changes):
>
>   SEC("fentry/filp_close")
>   int BPF_PROG(prog_close, struct file *file, void *id)
>   {
>     ...
>     ret = bpf_d_path(&file->f_path, ...
>
> The first bpf_d_path argument is hold by verifier as BTF file object
> plus offset of f_path member.
>
> The btf_struct_ids_match function will walk the struct file object and
> check if there's nested struct path object on the given offset.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h   |  2 ++
>  kernel/bpf/btf.c      | 29 +++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c | 18 ++++++++++++------
>  3 files changed, 43 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index bae557ff2da8..c981e258fed3 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1306,6 +1306,8 @@ int btf_struct_access(struct bpf_verifier_log *log,
>                       const struct btf_type *t, int off, int size,
>                       enum bpf_access_type atype,
>                       u32 *next_btf_id);
> +bool btf_struct_ids_match(struct bpf_verifier_log *log,
> +                         int off, u32 id, u32 mid);
>  int btf_resolve_helper_id(struct bpf_verifier_log *log,
>                           const struct bpf_func_proto *fn, int);
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 1ab5fd5bf992..562d4453fad3 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4140,6 +4140,35 @@ int btf_struct_access(struct bpf_verifier_log *log,
>         return -EINVAL;
>  }
>
> +bool btf_struct_ids_match(struct bpf_verifier_log *log,
> +                         int off, u32 id, u32 mid)
> +{
> +       const struct btf_type *type;
> +       u32 nid;
> +       int err;
> +

mid and nid are terrible names, especially as an input argument name.
mid == need_type_id? nid == cur_type_id or something along those
lines?

> +       do {
> +               type = btf_type_by_id(btf_vmlinux, id);
> +               if (!type)
> +                       return false;
> +               err = btf_struct_walk(log, type, off, 1, &nid);
> +               if (err < 0)
> +                       return false;
> +
> +               /* We found nested struct object. If it matches
> +                * the requested ID, we're done. Otherwise let's
> +                * continue the search with offset 0 in the new
> +                * type.
> +                */
> +               if (err == walk_struct && mid == nid)
> +                       return true;
> +               off = 0;
> +               id = nid;
> +       } while (err == walk_struct);

This seems like a slightly more obvious control flow:

again:

   ...

   if (err != walk_struct)
      return false;

   if (mid != nid) {
      off = 0;
      id = nid;
      goto again;
   }

   return true;

> +
> +       return false;
> +}
> +
>  int btf_resolve_helper_id(struct bpf_verifier_log *log,
>                           const struct bpf_func_proto *fn, int arg)
>  {

[...]
