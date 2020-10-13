Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B0328DD63
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 11:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgJNJYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 05:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731103AbgJNJU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 05:20:57 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343BEC0613B2;
        Tue, 13 Oct 2020 14:56:24 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id c3so960694ybl.0;
        Tue, 13 Oct 2020 14:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3srl/cIIgDrdXLp/zbv78C5Fc414aniZHGOaeUr9AnI=;
        b=k2L4SEZEfHDRirOEZZnI1rdeggzljt1zXv4YNShr01co4HRTZjbG9uHrFUA968f3bT
         GCB/gFBdFlSjPV9Re0dS4iz0F5b1vs2hJXibKVnTKYpKjsdJoJzvijvIeIO3hEufV/Dn
         uku0l9fUmXoUzKmVMtbJ5LKQ9sNpSZu9CZv8NYi5KGYEOwwr6aYyHUC0CmGBV3pWIJ1k
         IuU6X3bHkrTEsfwXWt0harQ9QHhr4p2UDqOEvloYk7HOm8ygNNlcEX/C/cGPymwxd4zW
         VU2xoLWGzr/Uv1hlN2PwWuMFMRhANasSAOytra9o13fov34YUnGkPy7iz+v+HZ55ZxIg
         gU2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3srl/cIIgDrdXLp/zbv78C5Fc414aniZHGOaeUr9AnI=;
        b=V6YEW/sXznM6ZsVXao0BLTLIeRyHf0wCA7NVdY+EEh7BbU7Dth+PsuT/5IHqhSBUfl
         1GENNhb1fuvRpqHB0nCmoqy8PmNF/UvVCo8yn4bDYysxgsuzzByWem812zCZEp1RYVYU
         7fvUJn+UQ6fojls9xonkDhzYqXoIbnnGcTe0tYQoT0w5oFFWiaPqcPdMIiG5L47VZb7y
         YFViu3XG8ALZ11pwR6HyNl/2cK55ds2xcQ3FYHGOw20hz2s9xVls7qwURAKDIoQkBmSL
         Mev4hZRzqx2jd7gxH24tEj6kxKxqGQyTnjW6Oj/LjpIcTw/k744jGn8Z+5ThZ3HFbCjk
         vSuQ==
X-Gm-Message-State: AOAM530RE3R41pOAyJUPxerlx1k602cOXcrrvX1ZtWPxA0lnzLS9VKmG
        cFUuDuyWoVyWEdV+oRJkFGOAMGhBK4GDWWQlcTQpk6mnhhI=
X-Google-Smtp-Source: ABdhPJzWy/1g2k56AhRnwZ3+lqezHCoHFqVPRObay3gPHalmD1dC3N1gi0WhFFNYQtUnVyS8XeoY2vOxBH3ysM8K1JE=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr2958476ybl.347.1602626183316;
 Tue, 13 Oct 2020 14:56:23 -0700 (PDT)
MIME-Version: 1.0
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
 <20201009011240.48506-4-alexei.starovoitov@gmail.com> <20201013195622.GB1305928@krava>
 <CAADnVQLYSk0YgK7_dUSF-5Rau10vOdDgosVhE9xmEr1dp+=2vg@mail.gmail.com>
In-Reply-To: <CAADnVQLYSk0YgK7_dUSF-5Rau10vOdDgosVhE9xmEr1dp+=2vg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Oct 2020 14:56:12 -0700
Message-ID: <CAEf4BzbWO3fgWxAWQw4Pee=F7=UqU+N6LtKYV7V9ZZrfkPZ3gw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] selftests/bpf: Add profiler test
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 2:03 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Oct 13, 2020 at 12:56 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Thu, Oct 08, 2020 at 06:12:39PM -0700, Alexei Starovoitov wrote:
> >
> > SNIP
> >
> > > +
> > > +#ifdef UNROLL
> > > +#pragma unroll
> > > +#endif
> > > +     for (int i = 0; i < MAX_CGROUPS_PATH_DEPTH; i++) {
> > > +             filepart_length =
> > > +                     bpf_probe_read_str(payload, MAX_PATH, BPF_CORE_READ(cgroup_node, name));
> > > +             if (!cgroup_node)
> > > +                     return payload;
> > > +             if (cgroup_node == cgroup_root_node)
> > > +                     *root_pos = payload - payload_start;
> > > +             if (filepart_length <= MAX_PATH) {
> > > +                     barrier_var(filepart_length);
> > > +                     payload += filepart_length;
> > > +             }
> > > +             cgroup_node = BPF_CORE_READ(cgroup_node, parent);
> > > +     }
> > > +     return payload;
> > > +}
> > > +
> > > +static ino_t get_inode_from_kernfs(struct kernfs_node* node)
> > > +{
> > > +     struct kernfs_node___52* node52 = (void*)node;
> > > +
> > > +     if (bpf_core_field_exists(node52->id.ino)) {
> > > +             barrier_var(node52);
> > > +             return BPF_CORE_READ(node52, id.ino);
> > > +     } else {
> > > +             barrier_var(node);
> > > +             return (u64)BPF_CORE_READ(node, id);
> > > +     }
> > > +}
> > > +
> > > +int pids_cgrp_id = 1;
> >
> >
> > hi,
> > I'm getting compilation failure with this:
> >
> >           CLNG-LLC [test_maps] profiler2.o
> >         In file included from progs/profiler2.c:6:
> >         progs/profiler.inc.h:246:5: error: redefinition of 'pids_cgrp_id' as different kind of symbol
> >         int pids_cgrp_id = 1;
> >             ^
> >         /home/jolsa/linux-qemu/tools/testing/selftests/bpf/tools/include/vmlinux.h:14531:2: note: previous definition is here
> >                 pids_cgrp_id = 11,
>
> Interesting.
> You probably have CONFIG_CGROUP_PIDS in your .config?
> I don't and bpf CI doesn't have it either, so this issue wasn't spotted earlier.
>
> I can hard code 11, of course, but
> but maybe Andrii has a cool way to use co-re to deal with this?

Cool or not, but we do have a way to deal with it. :)

> I think
> "extern bool CONFIG_CGROUP_PIDS __kconfig"
> won't work.
> A good opportunity to try to use bpf_core_enum_value_exists() ?

There are fews parts here.

First, we can't rely that vmlinux.h has pids_cgrp_id enum defined, so
we need to define our own. But in such a way that it doesn't collide
with enum cgroup_subsys_id in vmlinux.h. ___suffix for the rescue
here:

enum cgroup_subsys_id___local {
    pids_cgrp_id___local = 1, /* anything but zero */
};

If value is zero, built-in will complain. Need to check with Yonghong
on why that is. For all things CO-RE, ___local suffix is going to be
ignored.

Second, detecting if the kernel even has this pids_cgrp_id defined.
That could be done with __kconfig as you mentioned, actually (but need
__weak as well). But one can also use bpf_core_enum_value_exists as
well. So it's either:

extern bool CONFIG_CGROUP_PIDS __kconfig __weak;

...

if (ENABLE_CGROUP_V1_RESOLVER && CONFIG_CGROUP_PIDS) {
   ...
}


Or a bit more verbose way with relos:

if (ENABLE_CGROUP_V1_RESOLVER &&
    bpf_core_enum_value_exists(enum cgroup_subsys_id___local,
pids_cgrp_id___local)) {
   ...
}

Third, actually getting the value of enum. This one would be
impossible without CO-RE reloc, but that's exactly what
bpf_core_enum_value() exists for:


int cgrp_id = bpf_core_enum_value(enum cgroup_subsys_id___local,
pids_cgrp_id___local);


I'd go with Kconfig + bpf_core_enum_value(), as it's shorter and
nicer. This compiles and works with my Kconfig, but I haven't checked
with CONFIG_CGROUP_PIDS defined.


diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h
b/tools/testing/selftests/bpf/progs/profiler.inc.h
index 00578311a423..79b8d2860a5c 100644
--- a/tools/testing/selftests/bpf/progs/profiler.inc.h
+++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
@@ -243,7 +243,11 @@ static ino_t get_inode_from_kernfs(struct
kernfs_node* node)
        }
 }

-int pids_cgrp_id = 1;
+extern bool CONFIG_CGROUP_PIDS __kconfig __weak;
+
+enum cgroup_subsys_id___local {
+       pids_cgrp_id___local = 1, /* anything but zero */
+};

 static INLINE void* populate_cgroup_info(struct cgroup_data_t* cgroup_data,
                                         struct task_struct* task,
@@ -253,7 +257,9 @@ static INLINE void* populate_cgroup_info(struct
cgroup_data_t* cgroup_data,
                BPF_CORE_READ(task, nsproxy, cgroup_ns, root_cset,
dfl_cgrp, kn);
        struct kernfs_node* proc_kernfs = BPF_CORE_READ(task, cgroups,
dfl_cgrp, kn);

-       if (ENABLE_CGROUP_V1_RESOLVER) {
+       if (ENABLE_CGROUP_V1_RESOLVER && CONFIG_CGROUP_PIDS) {
+               int cgrp_id = bpf_core_enum_value(enum
cgroup_subsys_id___local, pids_cgrp_id___local);
+
 #ifdef UNROLL
 #pragma unroll
 #endif
@@ -262,7 +268,7 @@ static INLINE void* populate_cgroup_info(struct
cgroup_data_t* cgroup_data,
                                BPF_CORE_READ(task, cgroups, subsys[i]);
                        if (subsys != NULL) {
                                int subsys_id = BPF_CORE_READ(subsys, ss, id);
-                               if (subsys_id == pids_cgrp_id) {
+                               if (subsys_id == cgrp_id) {
                                        proc_kernfs =
BPF_CORE_READ(subsys, cgroup, kn);
                                        root_kernfs =
BPF_CORE_READ(subsys, ss, root, kf_root, kn);
                                        break;
