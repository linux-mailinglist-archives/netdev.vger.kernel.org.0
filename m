Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A075E36BD89
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 04:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbhD0Cx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 22:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhD0Cxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 22:53:55 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010CCC061574;
        Mon, 26 Apr 2021 19:53:12 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id i190so757832pfc.12;
        Mon, 26 Apr 2021 19:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+advTk9699gSXqpfZDn2drfwmUJ24bU+getWzD88Oik=;
        b=fTu2CLAk9/h/PmBso59YqK8vaau6uhIB+RiNFj0ePMkMESXY8spweYtIydUoMlmPJC
         On3Vrr9LN1lVOSgRaQdPc3DosRca1oL09sobqq6Z3CJ88V1/Aw/r1aP4AQOe7LkF1bpz
         UqMGSYaTIHP2wQKxIJH2/mpJvvm/dS/6k8m5LYJtTi69AXlTk9wQceC31BDQMZenIktT
         A943ofUpJ928KXcrXQzSZ961wsjR+ckY9LegOxbGK/70dHSPTJ5OzIS/tH2XmpXg7E0P
         DjKITZg7kBhFPee102WBUyIFH3pBXwi21/KrFmRFoCkQlF0Ncc2qR3xfbijTAyhYzky7
         OZFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+advTk9699gSXqpfZDn2drfwmUJ24bU+getWzD88Oik=;
        b=Z2Hqch3TzALnBeN3gssWa1m0+9sQTi+QL4tpACKRbMKKas0htEm/Pc7lYt28icPe0V
         JLIwzp87+xQFNga687ZQbkw6mCSjkUaRawKgQ/qi7GwnL4OYkV6Ecojjjc/ZZQq7ZLAK
         X/Ly9r9VYwYG7e/z4LjFPCj1vWDWBrgGfo5FQdYSyKGjqC/vjF5IMtycbfQXIyqbsae7
         PEpSsSA6pLpByJ0E2OXPyY/V/Dt4gtogsyJc9Uz11QJhwlTvZwwKenFWuM4mBh8FNXHi
         x+t5wD4fuf0KUX/faaByApMtv2A5Yb2clCXBhjKWI5SQ5z0f+v1yrLS9drdlL6SxIDT1
         0U5g==
X-Gm-Message-State: AOAM530MtA5/BFYblEYDocggcsfoCts92f2jyrjwVGHB0RPbWfVL/ISX
        /ErsLeA4a6WcTn1u7DT9pZQ=
X-Google-Smtp-Source: ABdhPJzQsmKjh1U0MWR4tsGW78tlmi+PInRtaP5zhyJE1RDyVkC+2s9qg4qNTEKUCn8SsAZUGqxX2Q==
X-Received: by 2002:a63:5326:: with SMTP id h38mr7737902pgb.130.1619491991464;
        Mon, 26 Apr 2021 19:53:11 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1ad0])
        by smtp.gmail.com with ESMTPSA id x3sm883035pfj.95.2021.04.26.19.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 19:53:10 -0700 (PDT)
Date:   Mon, 26 Apr 2021 19:53:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 09/16] libbpf: Support for fd_idx
Message-ID: <20210427025309.yma2vy4m4qbk5srv@ast-mbp.dhcp.thefacebook.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-10-alexei.starovoitov@gmail.com>
 <CAEf4BzZ5CJmF45_aBWBHt2jYeLjs2o5VXEA3zfLDvTncW_hjZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ5CJmF45_aBWBHt2jYeLjs2o5VXEA3zfLDvTncW_hjZg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 10:14:45AM -0700, Andrii Nakryiko wrote:
> On Thu, Apr 22, 2021 at 5:27 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Add support for FD_IDX make libbpf prefer that approach to loading programs.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >  tools/lib/bpf/bpf.c             |  1 +
> >  tools/lib/bpf/libbpf.c          | 70 +++++++++++++++++++++++++++++----
> >  tools/lib/bpf/libbpf_internal.h |  1 +
> >  3 files changed, 65 insertions(+), 7 deletions(-)
> >
> 
> [...]
> 
> > +static int probe_kern_fd_idx(void)
> > +{
> > +       struct bpf_load_program_attr attr;
> > +       struct bpf_insn insns[] = {
> > +               BPF_LD_IMM64_RAW(BPF_REG_0, BPF_PSEUDO_MAP_IDX, 0),
> > +               BPF_EXIT_INSN(),
> > +       };
> > +
> > +       memset(&attr, 0, sizeof(attr));
> > +       attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
> > +       attr.insns = insns;
> > +       attr.insns_cnt = ARRAY_SIZE(insns);
> > +       attr.license = "GPL";
> > +
> > +       probe_fd(bpf_load_program_xattr(&attr, NULL, 0));
> 
> probe_fd() calls close(fd) internally, which technically can interfere
> with errno, though close() shouldn't be called because syscall has to
> fail on correct kernels... So this should work, but I feel like
> open-coding that logic is better than ignoring probe_fd() result.

It will fail on all kernels.
That probe_fd was a left over of earlier detection approach where it would
proceed to load all the way, but then I switched to:

> > +       return errno == EPROTO;

since such style of probing is much cheaper for the kernel and user space.
But point taken. Will open code it.

> > +}
> > +
> 
> [...]
> 
> > @@ -7239,6 +7279,8 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
> >         struct bpf_program *prog;
> >         size_t i;
> >         int err;
> > +       struct bpf_map *map;
> > +       int *fd_array = NULL;
> >
> >         for (i = 0; i < obj->nr_programs; i++) {
> >                 prog = &obj->programs[i];
> > @@ -7247,6 +7289,16 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
> >                         return err;
> >         }
> >
> > +       if (kernel_supports(FEAT_FD_IDX) && obj->nr_maps) {
> > +               fd_array = malloc(sizeof(int) * obj->nr_maps);
> > +               if (!fd_array)
> > +                       return -ENOMEM;
> > +               for (i = 0; i < obj->nr_maps; i++) {
> > +                       map = &obj->maps[i];
> > +                       fd_array[i] = map->fd;
> 
> nit: obj->maps[i].fd will keep it a single line
> 
> > +               }
> > +       }
> > +
> >         for (i = 0; i < obj->nr_programs; i++) {
> >                 prog = &obj->programs[i];
> >                 if (prog_is_subprog(obj, prog))
> > @@ -7256,10 +7308,14 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
> >                         continue;
> >                 }
> >                 prog->log_level |= log_level;
> > +               prog->fd_array = fd_array;
> 
> you are not freeing this memory on success, as far as I can see. 

hmm. there is free on success below.

> And
> given multiple programs are sharing fd_array, it's a bit problematic
> for prog to have fd_array. This is per-object properly, so let's add
> it at bpf_object level and clean it up on bpf_object__close()? And by
> assigning to obj->fd_array at malloc() site, you won't need to do all
> the error-handling free()s below.

hmm. that sounds worse.
why add another 8 byte to bpf_object that won't be used
until this last step of bpf_object__load_progs.
And only for the duration of this loading.
It's cheaper to have this alloc here with two free()s below.

> 
> >                 err = bpf_program__load(prog, obj->license, obj->kern_version);
> > -               if (err)
> > +               if (err) {
> > +                       free(fd_array);
> >                         return err;
> > +               }
> >         }
> > +       free(fd_array);
> >         return 0;
> >  }
> >
> > diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> > index 6017902c687e..9114c7085f2a 100644
> > --- a/tools/lib/bpf/libbpf_internal.h
> > +++ b/tools/lib/bpf/libbpf_internal.h
> > @@ -204,6 +204,7 @@ struct bpf_prog_load_params {
> >         __u32 log_level;
> >         char *log_buf;
> >         size_t log_buf_sz;
> > +       int *fd_array;
> >  };
> >
> >  int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr);
> > --
> > 2.30.2
> >

-- 
