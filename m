Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA0415AF89
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 19:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgBLSOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 13:14:42 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41947 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbgBLSOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 13:14:42 -0500
Received: by mail-qt1-f196.google.com with SMTP id l21so2289570qtr.8;
        Wed, 12 Feb 2020 10:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xsycLcL/gzlPTV/lAGfSFrdeS1in1x8uvkhNwiHgjO4=;
        b=nlIAMkfRv6Ok1cnm+kt3IdRXNArk7WTAtiF721+XBV4SE7FsSHMUgoDv8zVOjeRB1G
         0L4mpGPJkPNh05rcl13p1ITTWBij89pxZpDwXE1hUUjEH5FOI2vQJVm1UAV9RMs5SZXk
         jEVZsn3fVBi5HJVzhbcrDkvj1ZrgN6eFLFNuc5QaXflWarym0fAZb/JFVSu5XTw9xfuu
         0TwzOtzU46IWICC7+4vsC5j7cRjj1TYdHjxQC0ZOD2mhyciRw4bt8QWoF6sP4XpEhVDV
         K920dM1c/zb/OlYHCmPhB9zru4pH7FkLxgM7GGH0hy0d345NuQs+6uPeaERBxZzrVdBq
         v1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xsycLcL/gzlPTV/lAGfSFrdeS1in1x8uvkhNwiHgjO4=;
        b=NFwtSM8GKpr2L2Oyb9pW+oYHwo4WV/R9VFuopdDNdKAvmFeyfwwgDgtEUb5ITxgBto
         1w7zMWV3wk8YCp/0G8hxT2v7afz9I91gM9BZtFPGQZAu+yzDEfgxzAJ/mxg1/PyeJ1wD
         zpCna09wDMBIaaw6h/fmfAm9cVWz5YiqBBdpsmtjDLQcE0FD2gEMqLS60WzilKDIkwfh
         j1O+WmzXTQuHZT+/tGZxk0UqfnXmnH1NMpZXc+Z+vnjqzJLGmrzcvrn7stD2YcmalmkC
         XaNhaEvy7zgUhjinolyn1axr3H35LS6HVlXr5EEy9hXObGw4Mx4wYVOJmFRW7iGrNIZA
         cGBw==
X-Gm-Message-State: APjAAAWhsnBau5TBHF2p0jXtvfjTijC5r/DsRoESSkQ11cR057CSVH4X
        ZDj+WLWyj8RHiE8ugnXHDUdcNHs7YkAnmyMT/YU31vi6bG8=
X-Google-Smtp-Source: APXvYqzCl0ML8rYWCdoKeWSfuDNt9un9okdnruxdPV4V3uMGF4LShU5iVMmT0r4gvl49R6tGUOu/+nvhHYGDPbNKY7Q=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr8048352qtl.171.1581531281044;
 Wed, 12 Feb 2020 10:14:41 -0800 (PST)
MIME-Version: 1.0
References: <158151067149.71757.2222114135650741733.stgit@xdp-tutorial>
 <CAEf4BzZqxQxWe5qawBOuDzvDpCHsmgfyqxWnackHd=hUQpz6bA@mail.gmail.com> <628E972C-1156-46F8-AC61-DB0D38C34C81@fb.com>
In-Reply-To: <628E972C-1156-46F8-AC61-DB0D38C34C81@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 12 Feb 2020 10:14:30 -0800
Message-ID: <CAEf4BzYFVtgW4Zyz09vuppAJA3oQ-UAT4yALeFJk2JQ70+mE2g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Add support for dynamic program attach target
To:     Song Liu <songliubraving@fb.com>
Cc:     Eelco Chaudron <echaudro@redhat.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 10:07 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Feb 12, 2020, at 9:34 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Feb 12, 2020 at 4:32 AM Eelco Chaudron <echaudro@redhat.com> wrote:
> >>
> >> Currently when you want to attach a trace program to a bpf program
> >> the section name needs to match the tracepoint/function semantics.
> >>
> >> However the addition of the bpf_program__set_attach_target() API
> >> allows you to specify the tracepoint/function dynamically.
> >>
> >> The call flow would look something like this:
> >>
> >>  xdp_fd = bpf_prog_get_fd_by_id(id);
> >>  trace_obj = bpf_object__open_file("func.o", NULL);
> >>  prog = bpf_object__find_program_by_title(trace_obj,
> >>                                           "fentry/myfunc");
> >>  bpf_program__set_attach_target(prog, xdp_fd,
> >>                                 "fentry/xdpfilt_blk_all");
> >>  bpf_object__load(trace_obj)
> >>
> >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>
>
> I am trying to solve the same problem with slightly different approach.
>
> It works as the following (with skeleton):
>
>         obj = myobject_bpf__open_opts(&opts);
>         bpf_object__for_each_program(prog, obj->obj)
>                 bpf_program__overwrite_section_name(prog, new_names[id++]);
>         err = myobject_bpf__load(obj);
>
> I don't have very strong preference. But I think my approach is simpler?

I prefer bpf_program__set_attach_target() approach. Section name is a
program identifier and a *hint* for libbpf to determine program type,
attach type, and whatever else makes sense. But there still should be
an API to set all that manually at runtime, thus
bpf_program__set_attach_target(). Doing same by overriding section
name feels like a hack, plus it doesn't handle overriding
attach_program_fd at all.

>
> Thanks,
> Song
>
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 514b1a524abb..4c29a7181d57 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -238,6 +238,8 @@ struct bpf_program {
>         __u32 line_info_rec_size;
>         __u32 line_info_cnt;
>         __u32 prog_flags;
> +
> +       char *overwritten_section_name;
>  };
>
>  struct bpf_struct_ops {
> @@ -442,6 +444,7 @@ static void bpf_program__exit(struct bpf_program *prog)
>         zfree(&prog->pin_name);
>         zfree(&prog->insns);
>         zfree(&prog->reloc_desc);
> +       zfree(&prog->overwritten_section_name);
>
>         prog->nr_reloc = 0;
>         prog->insns_cnt = 0;
> @@ -6637,7 +6640,7 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog)
>  {
>         enum bpf_attach_type attach_type = prog->expected_attach_type;
>         __u32 attach_prog_fd = prog->attach_prog_fd;
> -       const char *name = prog->section_name;
> +       const char *name = prog->overwritten_section_name ? : prog->section_name;
>         int i, err;
>
>         if (!name)
> @@ -8396,3 +8399,11 @@ void bpf_object__destroy_skeleton(struct bpf_object_skeleton *s)
>         free(s->progs);
>         free(s);
>  }
> +
> +char *bpf_program__overwrite_section_name(struct bpf_program *prog,
> +                                         const char *sec_name)
> +{
> +       prog->overwritten_section_name = strdup(sec_name);
> +
> +       return prog->overwritten_section_name;
> +}
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 3fe12c9d1f92..02f0d8b57cc4 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -595,6 +595,10 @@ bpf_program__bpil_addr_to_offs(struct bpf_prog_info_linear *info_linear);
>  LIBBPF_API void
>  bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear);
>
> +LIBBPF_API char *
> +bpf_program__overwrite_section_name(struct bpf_program *prog,
> +                                   const char *sec_name);
> +
>  /*
>   * A helper function to get the number of possible CPUs before looking up
>   * per-CPU maps. Negative errno is returned on failure.
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index b035122142bb..ed26c20729db 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -235,3 +235,8 @@ LIBBPF_0.0.7 {
>                 btf__align_of;
>                 libbpf_find_kernel_btf;
>  } LIBBPF_0.0.6;
> +
> +LIBBPF_0.0.8 {
> +       global:
> +               bpf_program__overwrite_section_name;
> +} LIBBPF_0.0.7;
