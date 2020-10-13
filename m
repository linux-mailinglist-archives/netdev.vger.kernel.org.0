Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BD728D616
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 23:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbgJMVDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 17:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgJMVDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 17:03:47 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A235EC061755;
        Tue, 13 Oct 2020 14:03:46 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id m20so883013ljj.5;
        Tue, 13 Oct 2020 14:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8E7i0ijGJqc7mZ92dyJTA6zEj/61pYu3UEGHjeYbStc=;
        b=jEeFSfmjoRMPSxXxDmkpc9dI31DAn+EKG8PEphM/ZCFbtp9WpkhOQeuf9xJCNoSsnI
         RoIrRvc/oulOC2ZhlWMYcb8TfDEUR15VUpiD7mf7gcohHBZRUZtuaJPzaL/X1T7aHcA+
         vmKT0fbYKdj5TvxRXrCFlvUmkFPx/1DPAmU2QBHuIAxybnWFv+WEm2K0UDdj+0mgt7+N
         0Ze0AX4w/tOWGqKptnUnZrDT4P9VOFohcmd3TUKKE8+ci9BEwkoEGjR2XkvYv6wsiqTF
         2s07pk5RwMIH6ZhnArmvXP06kGBzZ/KlfGbyX0zg8nOvBqXM4+l9YMvCiQfyK2skU3h2
         DXbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8E7i0ijGJqc7mZ92dyJTA6zEj/61pYu3UEGHjeYbStc=;
        b=mXtYmXEac+lZKP5I+IrQUFpb00ae/+xttul3z3n8REHuKNj+Pebbr+RnjfSqClwtuA
         tb6uzyq8nymjPCCA2iYdoYWIOjLpN40FUzqUvqpt1mOy1CVmbI9iDwT6E8JemDGQ8QrJ
         WoaArNgWgNh/pHVi4eKMYwB5epCgn0xsnOThKzoGdCJD/VSpEMDNZ3+EmVIcx/VYbMLP
         e9sEyXoMKpuPZyK9ArIQ2YYCTny52gyj9O35K8ptYAj4unwycoNOVi356nh2yI1aI8ms
         XAHXsVMXL4yeuHhyJf1zmVUxJcyTG66QPjZ9qZUyqXnF39Uj8sA4bsM7DkcN90ye13Y6
         c9vg==
X-Gm-Message-State: AOAM532RkwySQ/YgfGmZSzyeC+F0wTCfjHjVH81sfCpcFNs7+RErPcKJ
        NkgLVFyeNLSBCMZ49v3EPueAPrLrytL1quxbUt8=
X-Google-Smtp-Source: ABdhPJyC+0Nfdi9/QamjgkRtl1lSCJ+BrTIgQnllfz9eL0PVd77eaR8WwvWjKDaoJodZlMtbeXYyiqnfoXF+mAXMXV4=
X-Received: by 2002:a2e:b8cc:: with SMTP id s12mr554986ljp.2.1602623025058;
 Tue, 13 Oct 2020 14:03:45 -0700 (PDT)
MIME-Version: 1.0
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
 <20201009011240.48506-4-alexei.starovoitov@gmail.com> <20201013195622.GB1305928@krava>
In-Reply-To: <20201013195622.GB1305928@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 13 Oct 2020 14:03:33 -0700
Message-ID: <CAADnVQLYSk0YgK7_dUSF-5Rau10vOdDgosVhE9xmEr1dp+=2vg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] selftests/bpf: Add profiler test
To:     Jiri Olsa <jolsa@redhat.com>, Andrii Nakryiko <andrii@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 12:56 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Oct 08, 2020 at 06:12:39PM -0700, Alexei Starovoitov wrote:
>
> SNIP
>
> > +
> > +#ifdef UNROLL
> > +#pragma unroll
> > +#endif
> > +     for (int i = 0; i < MAX_CGROUPS_PATH_DEPTH; i++) {
> > +             filepart_length =
> > +                     bpf_probe_read_str(payload, MAX_PATH, BPF_CORE_READ(cgroup_node, name));
> > +             if (!cgroup_node)
> > +                     return payload;
> > +             if (cgroup_node == cgroup_root_node)
> > +                     *root_pos = payload - payload_start;
> > +             if (filepart_length <= MAX_PATH) {
> > +                     barrier_var(filepart_length);
> > +                     payload += filepart_length;
> > +             }
> > +             cgroup_node = BPF_CORE_READ(cgroup_node, parent);
> > +     }
> > +     return payload;
> > +}
> > +
> > +static ino_t get_inode_from_kernfs(struct kernfs_node* node)
> > +{
> > +     struct kernfs_node___52* node52 = (void*)node;
> > +
> > +     if (bpf_core_field_exists(node52->id.ino)) {
> > +             barrier_var(node52);
> > +             return BPF_CORE_READ(node52, id.ino);
> > +     } else {
> > +             barrier_var(node);
> > +             return (u64)BPF_CORE_READ(node, id);
> > +     }
> > +}
> > +
> > +int pids_cgrp_id = 1;
>
>
> hi,
> I'm getting compilation failure with this:
>
>           CLNG-LLC [test_maps] profiler2.o
>         In file included from progs/profiler2.c:6:
>         progs/profiler.inc.h:246:5: error: redefinition of 'pids_cgrp_id' as different kind of symbol
>         int pids_cgrp_id = 1;
>             ^
>         /home/jolsa/linux-qemu/tools/testing/selftests/bpf/tools/include/vmlinux.h:14531:2: note: previous definition is here
>                 pids_cgrp_id = 11,

Interesting.
You probably have CONFIG_CGROUP_PIDS in your .config?
I don't and bpf CI doesn't have it either, so this issue wasn't spotted earlier.

I can hard code 11, of course, but
but maybe Andrii has a cool way to use co-re to deal with this?
I think
"extern bool CONFIG_CGROUP_PIDS __kconfig"
won't work.
A good opportunity to try to use bpf_core_enum_value_exists() ?
