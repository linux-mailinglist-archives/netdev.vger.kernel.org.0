Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7CE9123559
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 20:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfLQTDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 14:03:51 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35895 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfLQTDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 14:03:51 -0500
Received: by mail-qk1-f194.google.com with SMTP id a203so8170843qkc.3;
        Tue, 17 Dec 2019 11:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z0QJIGyUGn5BEJc8rg5MhNb/nTRQiFDqhn9BJB2B5gk=;
        b=DCu/zH4XrFRbPyzKoavf03lYkM3nYSbQfgM+r1QvnbPCJncVQZRvNV7rKA+dNjN1rj
         FnOt0JsLFY7PTo1bVP8DYUms0aZgs1TEjwnGrW9olrr+P78I2mR2Y2pG0CRCJoeMNwjD
         B/Mf7BwmGORgU89/VdZRQi1MWBab7ISG22wW/KiCgVSnQdzYg90MZSXTc5T4vJ6VDva7
         RD1FvUX0Mv+jx055PaXgJlyO2U8xO69OmZVDjgMxuHXUZD4gTfQDcdr3Bb7/rIXUZHgN
         OTx9obMElAviZ1vf3RkBrGTLh7QhJ2vxVBOErQoqR7VPScrNDmlDij5EgtRHhGFHcSzc
         JNcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z0QJIGyUGn5BEJc8rg5MhNb/nTRQiFDqhn9BJB2B5gk=;
        b=DmgrZO23R0Ajmw8JY8Ixs+DIAxHdodkKGZVJ2o9Yt8NcgzOv30s3DOFG5nzkxFJIca
         7QY9lFeyNvpqSdxU7i6q7gEt8tW83CrYr1aYR/CjPLdll82ZeDMxLI9MIPI4pnmsxwuf
         /0GPBBx/dDal5Mew+Ues+hwsn8bHJjhRIQJtH4bCO93rbkFPFr4j+lip5oNfiOWsCKxR
         dA7NtCZCMNvp5MariiJ/aPgjAy0haiNsaXPj82zZtpyyAyfI5FT0UUjYQGGLxw/yfVIj
         lcuNQdVUmue1pCUxxeQBlcczsCaM+nH1wuscsT9MTSoQkDBcKthXTkoltOrP6EPhofaN
         9DkQ==
X-Gm-Message-State: APjAAAWMGiHSrcLm1hQIN/r0TG/DUSLmWMPu8cDt6kxPjs5iB3hnMIa7
        sTpdXx90X2I4xhF0gBQv6NpsKfloggU2bAZTpH8kGA==
X-Google-Smtp-Source: APXvYqzP+FnkvIIXpdqOc68VnTFndenTIEi8Pn8kfHEOxb2u3iRIQ8Qnbny0WKcWl6GdwtqF4negIDFdzaAFtVWhrb0=
X-Received: by 2002:a05:620a:14a2:: with SMTP id x2mr6827045qkj.36.1576609429907;
 Tue, 17 Dec 2019 11:03:49 -0800 (PST)
MIME-Version: 1.0
References: <20191214014710.3449601-1-andriin@fb.com> <20191214014710.3449601-3-andriin@fb.com>
 <20191216111736.GA14887@linux.fritz.box> <CAEf4Bzbx+2Fot9NYzGJS-pUF5x5zvcfBnb7fcO_s9_gCQQVuLg@mail.gmail.com>
 <7bf339cf-c746-a780-3117-3348fb5997f1@iogearbox.net>
In-Reply-To: <7bf339cf-c746-a780-3117-3348fb5997f1@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Dec 2019 11:03:38 -0800
Message-ID: <CAEf4BzYAWknN1HGHd0vREtQLHU-z3iTLJWBteRK6q7zkhySBBg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/4] libbpf: support libbpf-provided extern variables
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 6:42 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 12/16/19 8:29 PM, Andrii Nakryiko wrote:
> > On Mon, Dec 16, 2019 at 3:17 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >> On Fri, Dec 13, 2019 at 05:47:08PM -0800, Andrii Nakryiko wrote:
> >>> Add support for extern variables, provided to BPF program by libbpf. Currently
> >>> the following extern variables are supported:
> >>>    - LINUX_KERNEL_VERSION; version of a kernel in which BPF program is
> >>>      executing, follows KERNEL_VERSION() macro convention, can be 4- and 8-byte
> >>>      long;
> >>>    - CONFIG_xxx values; a set of values of actual kernel config. Tristate,
> >>>      boolean, strings, and integer values are supported.
> >>>
> >> [...]
> >>>
> >>> All detected extern variables, are put into a separate .extern internal map.
> >>> It, similarly to .rodata map, is marked as read-only from BPF program side, as
> >>> well as is frozen on load. This allows BPF verifier to track extern values as
> >>> constants and perform enhanced branch prediction and dead code elimination.
> >>> This can be relied upon for doing kernel version/feature detection and using
> >>> potentially unsupported field relocations or BPF helpers in a CO-RE-based BPF
> >>> program, while still having a single version of BPF program running on old and
> >>> new kernels. Selftests are validating this explicitly for unexisting BPF
> >>> helper.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >> [...]
> >>> +static int bpf_object__resolve_externs(struct bpf_object *obj,
> >>> +                                    const char *config_path)
> >>> +{
> >>> +     bool need_config = false;
> >>> +     struct extern_desc *ext;
> >>> +     int err, i;
> >>> +     void *data;
> >>> +
> >>> +     if (obj->nr_extern == 0)
> >>> +             return 0;
> >>> +
> >>> +     data = obj->maps[obj->extern_map_idx].mmaped;
> >>> +
> >>> +     for (i = 0; i < obj->nr_extern; i++) {
> >>> +             ext = &obj->externs[i];
> >>> +
> >>> +             if (strcmp(ext->name, "LINUX_KERNEL_VERSION") == 0) {
> >>> +                     void *ext_val = data + ext->data_off;
> >>> +                     __u32 kver = get_kernel_version();
> >>> +
> >>> +                     if (!kver) {
> >>> +                             pr_warn("failed to get kernel version\n");
> >>> +                             return -EINVAL;
> >>> +                     }
> >>> +                     err = set_ext_value_num(ext, ext_val, kver);
> >>> +                     if (err)
> >>> +                             return err;
> >>> +                     pr_debug("extern %s=0x%x\n", ext->name, kver);
> >>> +             } else if (strncmp(ext->name, "CONFIG_", 7) == 0) {
> >>> +                     need_config = true;
> >>> +             } else {
> >>> +                     pr_warn("unrecognized extern '%s'\n", ext->name);
> >>> +                     return -EINVAL;
> >>> +             }
> >>
> >> I don't quite like that this is (mainly) tracing-only specific, and that
> >> for everything else we just bail out - there is much more potential than
> >> just completing above vars. But also, there is also no way to opt-out
> >> for application developers of /this specific/ semi-magic auto-completion
> >> of externs.
> >
> > What makes you think it's tracing only? While non-tracing apps
> > probably don't need to care about LINUX_KERNEL_VERSION, all of the
> > CONFIG_ stuff is useful and usable for any type of application.
>
> Ok, just curious, do you have a concrete example e.g. for tc/xdp networking
> programs where you have a specific CONFIG_* extern that you're using in your
> programs currently?

So one good example will be CONFIG_HZ, used by latest Martin's work on
tcp_congestion_ops, as well as used by other networking BPF programs
for network stats.

>
> > As for opt-out, you can easily opt out by not using extern variables.
> >
> >> bpf_object__resolve_externs() should be changed instead to invoke a
> >> callback obj->resolve_externs(). Former can be passed by the application
> >> developer to allow them to take care of extern resolution all by themself,
> >> and if no callback has been passed, then we default to the one above
> >> being set as obj->resolve_externs.
> >
> > Can you elaborate on the use case you have in mind? The way I always
> > imagined BPF applications provide custom read-only parameters to BPF
> > side is through using .rodata variables. With skeleton it's super easy
> > to initialize them before BPF program is loaded, and their values will
> > be well-known by verifier and potentially optimized.
>
> We do set the map with .extern contents as read-only memory as well in
> libbpf as I understand it. So same dead code optimization from the
> verifier as well in this case. It feels the line with passing external
> config via .rodata variables vs .extern variables gets therefore a bit
> blurry.
>
> Are we saying that in libbpf convention is that .extern contents must
> *only* ever be kernel-provided but cannot come from some other configuration
> data such as env/daemon?

You are right that .rodata and .extern are both read-only and allow
dead code optimization, which was a requirement for both. The line is
between who "owns" the data. .rodata should be parameters owned and
set up by BPF program and its userspace counterpart. While .extern is
something that's owned and provided by some external party. It is
libbpf for Kconfig, in the future it might be also kernel variables
(e.g., jiffies). With static and dynamic linking, extern variables
will be variables defined in some other BPF object, that we are
linking with.

>
> [...]
> > So for application-specific stuff, there isn't really a need to use
> > externs to do that. Furthermore, I think allowing using externs as
> > just another way to specify application-specific configuration is
> > going to create a problem, potentially, as we'll have higher
> > probability of collisions with kernel-provided extersn (variables
> > and/or functions), or even externs provided by other
> > dynamically/statically linked BPF programs (once we have dynamic and
> > static linking, of course).
>
> Yes, that makes more sense, but then we are already potentially colliding
> with current CONFIG_* variables once we handle dynamically / statically
> linked BPF programs. Perhaps that's my confusion in the first place. Would
> have been good if 166750bc1dd2 had a discussion on that as part of the
> commit message.
>
> So, naive question, what's the rationale of not using .rodata variables
> for CONFIG_* case and how do we handle these .extern collisions in future?
> Should these vars rather have had some sort of annotation or be moved into
> special ".extern.config" section or the like where we explicitly know that
> these are handled differently so they don't collide with future ".extern"
> content once we have linked BPF programs?

Yes, name collision is a possibility, which means users should
restrain from using LINUX_KERNEL_VERSION and CONFIG_XXX names for
their variables. But if that is ever actually the problem, the way to
resolve this collision/ambiguity would be to put externs in a separate
sections. It's possible to annotate extern variable with custom
section.

But I guess putting Kconfig-provided externs into ".extern.kconfig"
might be a good idea, actually. That will make it possible to have
writable externs in the future.

>
> > So if you still insist we need user to provide custom extern-parsing
> > logic, can you please elaborate on the use case details?
> >
> > BTW, from discussion w/ Alexei on another thread, I think I'm going to
> > change kconfig_path option to just `kconfig`, which will specify
> > additional config in Kconfig format. This could be used by
> > applications to provide their own config, augmenting Kconfig with
> > custom overrides.
>
> Ok.
>
> Thanks,
> Daniel
