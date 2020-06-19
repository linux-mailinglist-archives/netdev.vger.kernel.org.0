Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9440E200151
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 06:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgFSEfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 00:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgFSEfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 00:35:21 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2669C06174E;
        Thu, 18 Jun 2020 21:35:21 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id q198so18547qka.2;
        Thu, 18 Jun 2020 21:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UHDqRDDn14CCzdKqC28UmPBH/SBHhyryYRfif8mXRbU=;
        b=YoBRFl58kLm197oyvuhKNBW59LiqXC6iGENPVH0notwvCSDX76ytqUEKKF4GsStMyq
         +wFPWrEeL3GJMnT8XVFVdOzMN8IbM5SOiIxIBxUxQrfnAB812ntJjTrbSNapdTPx1bLd
         MVd0BEU2Rou9XWlKv2vu0j0L+AUhdxS03XYW655uzDVg3BXgiA1Hr4Tki4c2i9lVG2Fa
         MC26/ByfpMY8TBhTCXvRJZ860D9ozQhmSbSVU06jLflNhQG9A6cG3jUPYSnm1hzUrxbA
         pY7+QKZOojnIMFqPsq4u9QiMx59gCpPDsVOi8i5p7ILhJa0deqsmBiICIA8scM4LhWtJ
         Fvuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UHDqRDDn14CCzdKqC28UmPBH/SBHhyryYRfif8mXRbU=;
        b=WeZszqrnmo8mOZ+CMqxkHg4MBGiKI3bjyRww5syIw+KQn+ddQdXrzw7X8rW6/fqg4u
         nZW6bCeZUwKEYNOT8fHbtwXp1/mpV2TBLf0gmcIdogvZryq9r8Rzz3FLM2Abd+S5Q28I
         DE6rjk/0avxb/OgPDMoiFf1ciUNZHWajq6PW97rHv2ufk/y8b60exVeFqYoutBAySCMX
         LZ0l7FbsWj55c+dIUBd9m21gYaW3PU7ae7sBV+tnOxf4I8QaGXLrYdM0RdidePzGLlPU
         AwMP8Ke+43iQirffN0w+oQo4Ehp3ODigSG59Zuw9UxjIimKLNpCCnJDYzCy3rTOYKHlV
         WvpQ==
X-Gm-Message-State: AOAM532042LJlrmCtSXjVVWy+aNLRH+77MJmQ1k788iO4Uhr4VaOvK8a
        mFDe0WkYoXlm1/ziFVH97bWAMFtm4d3Xv8rcrv8=
X-Google-Smtp-Source: ABdhPJyXGoTJBEJ/bQVt361A2IU+wLuAOnopA8a3Mh76EofUBII6u5BH76GiTKt1KOaeVRdTGYeOn1yvnrtaLaqve00=
X-Received: by 2002:a37:a89:: with SMTP id 131mr1769977qkk.92.1592541321008;
 Thu, 18 Jun 2020 21:35:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-10-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-10-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 21:35:10 -0700
Message-ID: <CAEf4BzY=d5y_-fXvomG7SjkbK7DZn5=-f+sdCYRdZh9qeynQrQ@mail.gmail.com>
Subject: Re: [PATCH 09/11] bpf: Add d_path helper
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

On Tue, Jun 16, 2020 at 3:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding d_path helper function that returns full path
> for give 'struct path' object, which needs to be the
> kernel BTF 'path' object.
>
> The helper calls directly d_path function.
>
> Updating also bpf.h tools uapi header and adding
> 'path' to bpf_helpers_doc.py script.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h            |  4 ++++
>  include/uapi/linux/bpf.h       | 14 ++++++++++++-
>  kernel/bpf/btf_ids.c           | 11 ++++++++++
>  kernel/trace/bpf_trace.c       | 38 ++++++++++++++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py     |  2 ++
>  tools/include/uapi/linux/bpf.h | 14 ++++++++++++-
>  6 files changed, 81 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index a94e85c2ec50..d35265b6c574 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1752,5 +1752,9 @@ extern int bpf_skb_output_btf_ids[];
>  extern int bpf_seq_printf_btf_ids[];
>  extern int bpf_seq_write_btf_ids[];
>  extern int bpf_xdp_output_btf_ids[];
> +extern int bpf_d_path_btf_ids[];
> +
> +extern int btf_whitelist_d_path[];
> +extern int btf_whitelist_d_path_cnt;

So with suggestion from previous patch, this would be declared as:

extern const struct btf_id_set btf_whitelist_d_path;

>
>  #endif /* _LINUX_BPF_H */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index c65b374a5090..e308746b9344 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3252,6 +3252,17 @@ union bpf_attr {
>   *             case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
>   *             is returned or the error code -EACCES in case the skb is not
>   *             subject to CHECKSUM_UNNECESSARY.
> + *
> + * int bpf_d_path(struct path *path, char *buf, u32 sz)
> + *     Description
> + *             Return full path for given 'struct path' object, which
> + *             needs to be the kernel BTF 'path' object. The path is
> + *             returned in buffer provided 'buf' of size 'sz'.
> + *
> + *     Return
> + *             length of returned string on success, or a negative
> + *             error in case of failure
> + *
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -3389,7 +3400,8 @@ union bpf_attr {
>         FN(ringbuf_submit),             \
>         FN(ringbuf_discard),            \
>         FN(ringbuf_query),              \
> -       FN(csum_level),
> +       FN(csum_level),                 \
> +       FN(d_path),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/kernel/bpf/btf_ids.c b/kernel/bpf/btf_ids.c
> index d8d0df162f04..853c8fd59b06 100644
> --- a/kernel/bpf/btf_ids.c
> +++ b/kernel/bpf/btf_ids.c
> @@ -13,3 +13,14 @@ BTF_ID(struct, seq_file)
>
>  BTF_ID_LIST(bpf_xdp_output_btf_ids)
>  BTF_ID(struct, xdp_buff)
> +
> +BTF_ID_LIST(bpf_d_path_btf_ids)
> +BTF_ID(struct, path)
> +
> +BTF_WHITELIST_ENTRY(btf_whitelist_d_path)
> +BTF_ID(func, vfs_truncate)
> +BTF_ID(func, vfs_fallocate)
> +BTF_ID(func, dentry_open)
> +BTF_ID(func, vfs_getattr)
> +BTF_ID(func, filp_close)
> +BTF_WHITELIST_END(btf_whitelist_d_path)

Oh, so that's why you added btf_ids.c. Do you think centralizing all
those BTF ID lists in one file is going to be more convenient? I lean
towards keeping them closer to where they are used, as it was with all
those helper BTF IDS. But I wonder what others think...

> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index c1866d76041f..0ff5d8434d40 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1016,6 +1016,42 @@ static const struct bpf_func_proto bpf_send_signal_thread_proto = {
>         .arg1_type      = ARG_ANYTHING,
>  };
>

[...]
