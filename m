Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C09D2B2BD9
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 07:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgKNG7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 01:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgKNG7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 01:59:09 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C173C0613D1;
        Fri, 13 Nov 2020 22:59:08 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id c129so10827883yba.8;
        Fri, 13 Nov 2020 22:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kr6KK+cr1KiDDXktNJ5mYWiTxYa+mqYyBfAGNUFkpTI=;
        b=jvS7cbXAOZIrM+/kWyvKvVAegeLDEhcNDIp6QNuGW7/eMAt1lL2RQ9+Ap+ppj4JajO
         gpazIIWqTT6CTokEbmp1bV4VwrCMRSaj4DPnqps4q2oQjRnFqqimbezE72ZDJmVUuw9a
         ARAf8uHL25WOzEDsUKzfL+2zJj/wsQXHzfgO7rIibUVeFFMJWCqUXK6QIptHEGVg7TR6
         UK0hrG5K28AnKCTviJ8YuuFZTHE+K8KQ6Cw4NQlj4rlpYwn2YX8HG1CUS8y57QrQ7+Bt
         Xusc3x7udUA+nkYKWmfg2Y1tZUnVChJNNwMTBiQTteqzh37MDj58XkYul76qFCkNHC8r
         K2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kr6KK+cr1KiDDXktNJ5mYWiTxYa+mqYyBfAGNUFkpTI=;
        b=mXmaYlSVrJIKZgqEIceWg8ukRO9ghR0tWcJhZUfSJ3OTY5PPLlnKL5z4BM5610L2es
         dUSbCvbhtntKdLRVKLEbVuyUkpe4dnhte2035d0MtdMKsGBTII0GF45+gT24WhpPddHN
         2qgf1YbK7Gx40EeO/aRlpdmkPFntG951qwtJ2SMNrp/JBBmEPdezNdVktdJyBLzlBQ3h
         ooBCRacGIodpWEGH3XDjon5k38Xzxr9FlpdT7wCfdI2ccQnOVJcqKGNg7No4nHuu8wwe
         CVr2ij0vN9IARLlJ5ZqHrDLsN5Q9w8KENoih5V8+vcuDWIENXLY37fyiF9vuHfWFgyp+
         LPJw==
X-Gm-Message-State: AOAM530H/EOktZmFALqJsqLy4YLUq1Y2E37i3ksKe5qy9f+085icoCyn
        8kzTyhNOJLFU7mSu5HghNex1qoKaStgiLX0ka54=
X-Google-Smtp-Source: ABdhPJxcVb5xS+Ze4iFGYIBExqjZbiTpT5dSMLH7J3e4BbpY+XN2bHQjOK6QheeQMfxlyG9T2SN1Ds0oMnd+Jk8NwIU=
X-Received: by 2002:a25:3d7:: with SMTP id 206mr8634612ybd.27.1605337147244;
 Fri, 13 Nov 2020 22:59:07 -0800 (PST)
MIME-Version: 1.0
References: <1605291013-22575-1-git-send-email-alan.maguire@oracle.com> <1605291013-22575-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1605291013-22575-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Nov 2020 22:58:56 -0800
Message-ID: <CAEf4BzaaUdMnfADQdT=myDJtQtHoQ_aW7T8XidrCkYZ=pGXuaQ@mail.gmail.com>
Subject: Re: [RFC bpf-next 1/3] bpf: add module support to btf display helpers
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 10:11 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> bpf_snprintf_btf and bpf_seq_printf_btf use a "struct btf_ptr *"
> argument that specifies type information about the type to
> be displayed.  Augment this information to include a module
> name, allowing such display to support module types.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  include/linux/btf.h            |  8 ++++++++
>  include/uapi/linux/bpf.h       |  5 ++++-
>  kernel/bpf/btf.c               | 18 ++++++++++++++++++
>  kernel/trace/bpf_trace.c       | 42 ++++++++++++++++++++++++++++++++----------
>  tools/include/uapi/linux/bpf.h |  5 ++++-
>  5 files changed, 66 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 2bf6418..d55ca00 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -209,6 +209,14 @@ static inline const struct btf_var_secinfo *btf_type_var_secinfo(
>  const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
>  const char *btf_name_by_offset(const struct btf *btf, u32 offset);
>  struct btf *btf_parse_vmlinux(void);
> +#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
> +struct btf *bpf_get_btf_module(const char *name);
> +#else
> +static inline struct btf *bpf_get_btf_module(const char *name)
> +{
> +       return ERR_PTR(-ENOTSUPP);
> +}
> +#endif
>  struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
>  #else
>  static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 162999b..26978be 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3636,7 +3636,8 @@ struct bpf_stack_build_id {
>   *             the pointer data is carried out to avoid kernel crashes during
>   *             operation.  Smaller types can use string space on the stack;
>   *             larger programs can use map data to store the string
> - *             representation.
> + *             representation.  Module-specific data structures can be
> + *             displayed if the module name is supplied.
>   *
>   *             The string can be subsequently shared with userspace via
>   *             bpf_perf_event_output() or ring buffer interfaces.
> @@ -5076,11 +5077,13 @@ struct bpf_sk_lookup {
>   * potentially to specify additional details about the BTF pointer
>   * (rather than its mode of display) - is included for future use.
>   * Display flags - BTF_F_* - are passed to bpf_snprintf_btf separately.
> + * A module name can be specified for module-specific data.
>   */
>  struct btf_ptr {
>         void *ptr;
>         __u32 type_id;
>         __u32 flags;            /* BTF ptr flags; unused at present. */
> +       const char *module;     /* optional module name. */

I think module name is a wrong API here, similarly how type name was
wrong API for specifying the type (and thus we use type_id here).
Using the module's BTF ID seems like a more suitable interface. That's
what I'm going to use for all kinds of existing BPF APIs that expect
BTF type to attach BPF programs.

Right now, we use only type_id and implicitly know that it's in
vmlinux BTF. With module BTFs, we now need a pair of BTF object ID +
BTF type ID to uniquely identify the type. vmlinux BTF now can be
specified in two different ways: either leaving BTF object ID as zero
(for simplicity and backwards compatibility) or specifying it's actual
BTF obj ID (which pretty much always should be 1, btw). This feels
like a natural extension, WDYT?

And similar to type_id, no one should expect users to specify these
IDs by hand, Clang built-in and libbpf should work together to figure
this out for the kernel to use.

BTW, with module names there is an extra problem for end users. Some
types could be either built-in or built as a module (e.g., XFS data
structures). Why would we require BPF users to care which is the case
on any given host? It feels right now that we should just extend the
existing __builtin_btf_type_id() helper to generate ldimm64
instructions that would encode both BTF type ID and BTF object ID.
This would just naturally add transparent module BTF support without
BPF programs having to do any changes.

But we need to do a bit of thinking and experimentation with Yonghong,
haven't gotten around to this yet, you are running a bit ahead of me
with module BTFs. :)

>  };
>
>  /*

[...]

>  struct btf_ptr {
>         void *ptr;
>         __u32 type_id;
>         __u32 flags;            /* BTF ptr flags; unused at present. */

Also, if flags are not used at present, can we repurpose it to just
encode btf_obj_id and avoid (at least for now) the backwards
compatibility checks based on btf_ptr size?

> +       const char *module;     /* optional module name. */
>  };
>
>  /*
> --
> 1.8.3.1
>
