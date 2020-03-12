Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4A7183809
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 18:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgCLRzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 13:55:02 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41381 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgCLRzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 13:55:00 -0400
Received: by mail-qk1-f195.google.com with SMTP id b5so7708593qkh.8;
        Thu, 12 Mar 2020 10:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VSYiUCpiuXuDgB+fjAC3rBPjx+1UW9OLFPso3F/idCQ=;
        b=gUpYC1lGVyMz5r1DnDZtY3l75H5r2rfjZrdHekZ1QRMisOLxiwIOKD6AmC9bxQNp56
         AOL0ZIGK9+x8zaXIKrfmXSEsIK5WSdEEQlbzsyxRpjuJSyXEz9KRAZPS2x77sabQqGzA
         1StWRrQR7q+g56RM11KryMzCUC6Gu1ybiC8je7bVgc8NipX8i764ONjp+tvcYnyhP8Oc
         xI9MjdOwdqKtKKXskq/N/r+6iNNKVOnvANppP5U6/ICJljUAdhQqW9rgOX68S8dxJegn
         zQ7NDSMzTh2c9ib1Awl/OHgfGDNLzGwBZt5tgS8LM7ojXzlmINR6AiTbZozN+o7SYL93
         x2Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VSYiUCpiuXuDgB+fjAC3rBPjx+1UW9OLFPso3F/idCQ=;
        b=i0v9OFJ0PzxbsLL37g98eziIvdLW+92Z5SYSEL/brgFeXITUPVyzkDJjgyYQoyE5eq
         k4pi9CC8V9c9StPV0E7fwaHDSY0XUJmp8qyFKAguz3HfVXM/KdlhFzUfzI4ITNM2I+1p
         UXrSt72AT0uUaKP+V5LLx+RQ95EzHLrrXdQLKbjhRMQOfAlsdH3Gr5C8pJaPZBIgghzO
         IPl3/Fx6YrEsdaHNSOkKOKjsUeco6DZAkZt//rWzoSi9DZDcHJnDQajD35cXDcuafebh
         BvTW3Q1Yo9rXeKc7S5vDWodTi2Cv38gGbuBOEVNKPM3PVcj9GLRxuJ/M4gBae28uO4Ux
         zrvQ==
X-Gm-Message-State: ANhLgQ0jVBv1dSPHq9/8m0holnkxUyF+thv2gg4hoKCe58AQVsYrgTAF
        swCljZh0E8p5hXsxYcc6CHw/CKLyeXFS50H5gx8=
X-Google-Smtp-Source: ADFU+vuwhe714t6l/4XmeiBfVKx3ehiqBI1qWX+T/ICHmLHXdGPE6rekXYzTnQym3OSxxPtoGPdwwEg9jXcqnmiRCaw=
X-Received: by 2002:a37:e40d:: with SMTP id y13mr9027538qkf.39.1584035699064;
 Thu, 12 Mar 2020 10:54:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200312140357.20174-1-quentin@isovalent.com> <1fff03e7-e52b-edcc-d427-f912bf0a4af2@iogearbox.net>
In-Reply-To: <1fff03e7-e52b-edcc-d427-f912bf0a4af2@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 12 Mar 2020 10:54:48 -0700
Message-ID: <CAEf4BzaQdv8s4cGp=ouitxczzWV1E1WeuxktDTp5JFkXXkRU=w@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: add null pointer check in bpf_object__init_user_btf_maps()
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Michal Rostecki <mrostecki@opensuse.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 8:38 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 3/12/20 3:03 PM, Quentin Monnet wrote:
> > When compiling bpftool with clang 7, after the addition of its recent
> > "bpftool prog profile" feature, Michal reported a segfault. This
> > occurred while the build process was attempting to generate the
> > skeleton needed for the profiling program, with the following command:
> >
> >      ./_bpftool gen skeleton skeleton/profiler.bpf.o > profiler.skel.h
> >
> > Tracing the error showed that bpf_object__init_user_btf_maps() does no
> > verification on obj->btf before passing it to btf__get_nr_types(), where
> > btf is dereferenced. Libbpf considers BTF information should be here
> > because of the presence of a ".maps" section in the object file (hence
> > the check on "obj->efile.btf_maps_shndx < 0" fails and we do not exit
> > from the function early), but it was unable to load BTF info as there is
> > no .BTF section.
> >
> > Add a null pointer check and error out if the pointer is null. The final
> > bpftool executable still fails to build, but at least we have a proper
> > error and no more segfault.
> >
> > Fixes: abd29c931459 ("libbpf: allow specifying map definitions using BTF")
> > Cc: Andrii Nakryiko <andriin@fb.com>
> > Reported-by: Michal Rostecki <mrostecki@opensuse.org>
> > Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>
> Applied to bpf-next, thanks! Note ...

I don't think this is the right fix. The problem was in my
5327644614a1 ("libbpf: Relax check whether BTF is mandatory") commit.
I've removed "mandatory" status of BTF if .maps is present. But that's
not right. We have the need for BTF at two levels: for libbpf itself
and for kernel, those are overlapping, but not exactly the same. BTF
is needed for libbpf when .maps, .struct_ops and externs are present.
But kernel needs it only for when .struct_ops are present. Right now
those checks are conflated together. Proper fix would be to separate
them. Can we please undo this patch? I'll post a proper fix shortly.

>
> > ---
> >   tools/lib/bpf/libbpf.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 223be01dc466..19c0c40e8a80 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -2140,6 +2140,10 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
> >               return -EINVAL;
> >       }
> >
> > +     if (!obj->btf) {
> > +             pr_warn("failed to retrieve BTF for map");
>
> I've added a '\n' here, otherwise it looks like:
>
> [...]
>    LINK     _bpftool
>    CLANG    skeleton/profiler.bpf.o
>    GEN      profiler.skel.h
> libbpf: failed to retrieve BTF for mapError: failed to open BPF object file: 0
> Makefile:129: recipe for target 'profiler.skel.h' failed
>
> Fixed version:
>
>    LINK     _bpftool
>    GEN      profiler.skel.h
> libbpf: failed to retrieve BTF for map
> Error: failed to open BPF object file: 0
> Makefile:129: recipe for target 'profiler.skel.h' failed
>
> Thanks,
> Daniel
