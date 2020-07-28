Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1638A23130C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732978AbgG1TrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730048AbgG1TrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 15:47:15 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F57C061794;
        Tue, 28 Jul 2020 12:47:15 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id w9so15803229qts.6;
        Tue, 28 Jul 2020 12:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ThwLY3fNICycCY8BtQTgJp/05j62cqHvgz64dBHPh1w=;
        b=EvSRQaPAOyMtYNEGVgl5dqv17e9x48u/0X3d+0ybr3gsJkmMfH4r4mKTN4nFOWQdcM
         HSxDrsL1jbId+/kYHmlBNtOMoe0JeRDXYGvbpD1PRN2wt947ogu0DBftOjGF3nEo8etu
         aI88nxkLEsHSGBIpvd7ngYmNzjfplU/eLLA0iRSPWF8KmGtJa6BAiEGA4/llD36pC7Mx
         AS7/f0J4/mUIfdPIUL8wHshfdnEEzOqR8awmgp+p5jWMinQHamN/bpUc4YJe+GnhYt8/
         O9K2AFroAFAAsCINfkQ3LZ6VV8ycr74vbGXRQypJLdYoXnefheeu47tJ8WylLUxGG1KD
         27Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ThwLY3fNICycCY8BtQTgJp/05j62cqHvgz64dBHPh1w=;
        b=DDHiBTlwXgRKGOJlBuwy8PybyRzdgHm/0CcAYkuMu36kR3+9Yg2IWFEuYV/zJXhp2Q
         DvxiEr2lJeVtKzZNS6EY794FLZ1Ys9RVBsMSidKrntsddCJMVvIcySpg77WxWMfJvhX5
         UM7Mdq0HNgX1zhXpKHFJstGVyoboDayLzHqvPp7AciXhR6pqsobJ550DHefKxWuLDZKV
         PNxLR7PXDj7GppWche/nxMzSb9TmJ8bGgiGfAnqvKBRZQi5VSkAx04dI5NJ3nZQayjuM
         8OcGT3x5j1l2ddeFUkH2zoZ4t6uCNButdkWkohknBilL9h5GBJR8Udl3WCQry3a69RAV
         p+fg==
X-Gm-Message-State: AOAM5323tt0NsOn2dLejdHzXtlo5+5xfLEdf0YwdF7iss2LngCaiN3wi
        +bUHRGlUWV5b+DKzCWFI4GzZJNbnSHFEvJg1KtI=
X-Google-Smtp-Source: ABdhPJzKwKDN4Mvv7UiFgY5GopQtuc6vrJLAQ0kblLrfhczBiYUiQ8lZ4ekejgo24kCptxeSC8mVQ9l2MA9+b6+bJwM=
X-Received: by 2002:ac8:777a:: with SMTP id h26mr28078911qtu.141.1595965634394;
 Tue, 28 Jul 2020 12:47:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200722211223.1055107-1-jolsa@kernel.org> <20200722211223.1055107-10-jolsa@kernel.org>
In-Reply-To: <20200722211223.1055107-10-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 12:47:03 -0700
Message-ID: <CAEf4BzZ48nhqGhij9qe7Hc_JD6RpZoh-4NnVvqR=V1YN4ff2sA@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 09/13] bpf: Add d_path helper
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

On Wed, Jul 22, 2020 at 2:14 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding d_path helper function that returns full path for
> given 'struct path' object, which needs to be the kernel
> BTF 'path' object. The path is returned in buffer provided
> 'buf' of size 'sz' and is zero terminated.
>
>   bpf_d_path(&file->f_path, buf, size);
>
> The helper calls directly d_path function, so there's only
> limited set of function it can be called from. Adding just
> very modest set for the start.
>
> Updating also bpf.h tools uapi header and adding 'path' to
> bpf_helpers_doc.py script.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/uapi/linux/bpf.h       | 13 +++++++++
>  kernel/trace/bpf_trace.c       | 48 ++++++++++++++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py     |  2 ++
>  tools/include/uapi/linux/bpf.h | 13 +++++++++
>  4 files changed, 76 insertions(+)
>

[...]

>
> +BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
> +{
> +       char *p = d_path(path, buf, sz - 1);
> +       int len;
> +
> +       if (IS_ERR(p)) {
> +               len = PTR_ERR(p);
> +       } else {
> +               len = strlen(p);
> +               if (len && p != buf)
> +                       memmove(buf, p, len);

not sure if it's worth it, but if len == sz - 1 then memmove is not
necessary. Again, don't know if worth it, as it's probably not going
to be a common case.

> +               buf[len] = 0;
> +               /* Include the trailing NUL. */
> +               len++;
> +       }
> +
> +       return len;
> +}
> +
> +BTF_SET_START(btf_whitelist_d_path)
> +BTF_ID(func, vfs_truncate)
> +BTF_ID(func, vfs_fallocate)
> +BTF_ID(func, dentry_open)
> +BTF_ID(func, vfs_getattr)
> +BTF_ID(func, filp_close)
> +BTF_SET_END(btf_whitelist_d_path)


We should probably comply with an updated coding style ([0]) and use
an allowlist name for this?

  [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=49decddd39e5f6132ccd7d9fdc3d7c470b0061bb

> +
> +static bool bpf_d_path_allowed(const struct bpf_prog *prog)
> +{
> +       return btf_id_set_contains(&btf_whitelist_d_path, prog->aux->attach_btf_id);
> +}
> +
> +BTF_ID_LIST(bpf_d_path_btf_ids)
> +BTF_ID(struct, path)
> +
> +static const struct bpf_func_proto bpf_d_path_proto = {
> +       .func           = bpf_d_path,
> +       .gpl_only       = false,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_BTF_ID,
> +       .arg2_type      = ARG_PTR_TO_MEM,
> +       .arg3_type      = ARG_CONST_SIZE,

I feel like we had a discussion about ARG_CONST_SIZE vs
ARG_CONST_SIZE_OR_ZERO before, maybe on some different thread.
Basically, this >0 restriction was a major nuisance for
bpf_perf_event_output() cases, so much that we changed it to _OR_ZERO.
In practice, while it might never be the case that we have sz == 0
passed into the function, having to prove this to the verifier is a
PITA. Unless there is a very strong reason not to, let's mark this as
ARG_CONST_SIZE_OR_ZERO and handle sz == 0 case as a noop?

> +       .btf_id         = bpf_d_path_btf_ids,
> +       .allowed        = bpf_d_path_allowed,
> +};
> +

[...]
