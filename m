Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261AB2CCEB8
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 06:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgLCFjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 00:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgLCFjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 00:39:13 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF85C061A4D;
        Wed,  2 Dec 2020 21:38:33 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id o71so980385ybc.2;
        Wed, 02 Dec 2020 21:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LG5EEUr29IhQIKadWjoYDgVnJTBb6ZwFm/wYOR2Jerk=;
        b=osUNEk85QVYNd7DeUeT6LAvmc9dgIL89+dPqsLjFmcyRcF1ajW4GRWSMUMuK6BjYAN
         slXsBbeqHyuHaJwXZF7klJU4XdnkjHCDXhmhCi69O37dMwgLKuG5NuwO8RLAVm3KdGhZ
         oX6dDQkT+vMRVXGAyH0qHkHk8u4pnQtbTampimjRWG8NxfMMyugU8bcs4U/VolhA+Ozf
         D0RN1ev6KJRetdVfzUfGJSbHZ6bhYJILapyjm8OlG8byfxEeXrRH7y80n6xogmQGj+4l
         pU2CBsGk/JzAaDD+avK30NxsWAeuvsglE8Ao2CLDxjdgl2JbDEKHD/rWnYWkxH8Xo8Ix
         CXeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LG5EEUr29IhQIKadWjoYDgVnJTBb6ZwFm/wYOR2Jerk=;
        b=q9SbYgSYkgHPuu8540H732uEr4J5ZTKxK/7U2EyxyDaaDHltBcq+yrPGjjY7fynVen
         j1dGIG5xQJbv/pq6PFNF9tZV1cIXao0Blu9ZdtyoA1vUMshOBVA/2LQFbnHxSQ10oaAe
         FtvGpZX7Mc5h7HP2C30VoRmW/zyTZYiFTL2orPnFaqGziGjwIIALzkd+XjJcXTeHeqQh
         ezG/Y3tInZnY2n6eAnve8ykG20YvIA3zUHy++X1zXwRMFEayfsR4ytk4TfsBofIhN8E0
         zD1n2x+LJh2GW25zKxCmjZ9zjToPPWLvyQTBzQgbzq1CblBtARtr+WQciq5KxaiybSKL
         jV5g==
X-Gm-Message-State: AOAM531aWIUtws/mXFZO4HLe2WBC9E9e7fGPTBu30Bg9B4E6eyAgURAa
        d3s5HnWeTqxUVu/HvjAYqUmn3J5seoBTTU0pbnLXnMHqRNA=
X-Google-Smtp-Source: ABdhPJxslFi3EECh5n6E62T/JBisd9/tpVUvje6LttfaRoGdlAnbLXtA3Tt0kQKf8W5QAWv41y2GXl+QfGLaNbLqWlE=
X-Received: by 2002:a25:3d7:: with SMTP id 206mr2185195ybd.27.1606973912667;
 Wed, 02 Dec 2020 21:38:32 -0800 (PST)
MIME-Version: 1.0
References: <20201203035204.1411380-1-andrii@kernel.org> <20201203035204.1411380-6-andrii@kernel.org>
 <5fc877ec37f7d_1123e208e8@john-XPS-13-9370.notmuch>
In-Reply-To: <5fc877ec37f7d_1123e208e8@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Dec 2020 21:38:21 -0800
Message-ID: <CAEf4BzbxGvExEnrYMxqpyuS-8_rLFMQ5EJnKs_=obHn1VYeq2g@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 05/14] libbpf: add kernel module BTF support
 for CO-RE relocations
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 2, 2020 at 9:30 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > Teach libbpf to search for candidate types for CO-RE relocations across kernel
> > modules BTFs, in addition to vmlinux BTF. If at least one candidate type is
> > found in vmlinux BTF, kernel module BTFs are not iterated. If vmlinux BTF has
> > no matching candidates, then find all kernel module BTFs and search for all
> > matching candidates across all of them.
> >
> > Kernel's support for module BTFs are inferred from the support for BTF name
> > pointer in BPF UAPI.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
>
> small typo and missing close maybe? Otherwise,
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
>
> > +static int load_module_btfs(struct bpf_object *obj)
> > +{
> > +     struct bpf_btf_info info;
> > +     struct module_btf *mod_btf;
> > +     struct btf *btf;
> > +     char name[64];
> > +     __u32 id = 0, len;
> > +     int err, fd;
> > +
> > +     if (obj->btf_modules_loaded)
> > +             return 0;
> > +
> > +     /* don't do this again, even if we find no module BTFs */
>
> I wonder a bit if we might load modules at some point and want
> to then run this, but I wouldn't worry about it. Its likely
> easy enough to just reload or delay load until module is in place.

right, internal function, super easy to adjust later

>
> > +     obj->btf_modules_loaded = true;
> > +
> > +     /* kernel too old to support module BTFs */
> > +     if (!kernel_supports(FEAT_MODULE_BTF))
> > +             return 0;
> > +
> > +     while (true) {
> > +             err = bpf_btf_get_next_id(id, &id);
> > +             if (err && errno == ENOENT)
> > +                     return 0;
> > +             if (err) {
> > +                     err = -errno;
> > +                     pr_warn("failed to iterate BTF objects: %d\n", err);
> > +                     return err;
> > +             }
> > +
> > +             fd = bpf_btf_get_fd_by_id(id);
> > +             if (fd < 0) {
> > +                     if (errno == ENOENT)
> > +                             continue; /* expected race: BTF was unloaded */
> > +                     err = -errno;
> > +                     pr_warn("failed to get BTF object #%d FD: %d\n", id, err);
> > +                     return err;
> > +             }
> > +
> > +             len = sizeof(info);
> > +             memset(&info, 0, sizeof(info));
> > +             info.name = ptr_to_u64(name);
> > +             info.name_len = sizeof(name);
> > +
> > +             err = bpf_obj_get_info_by_fd(fd, &info, &len);
> > +             if (err) {
>
> do we also need to close(fd) here? If not then we don't need the close in xsk.c
> I guess.

Yes, we do. Nice catch! I added FD tracking for each module BTF in
patch #12 and adjusted the clean up code there, so it's already fixed
there. If I happen to do v6, I'll add close(fd) here just for
completeness/correctness, but otherwise probably not worth it to
respin just for that.

>
> > +                     err = -errno;
> > +                     pr_warn("failed to get BTF object #%d info: %d\n", id, err);
> > +                     return err;
> > +             }
> > +
> > +             /* ignore non-module BTFs */
> > +             if (!info.kernel_btf || strcmp(name, "vmlinux") == 0) {
> > +                     close(fd);
> > +                     continue;
> > +             }
> > +
> > +             btf = btf_get_from_fd(fd, obj->btf_vmlinux);
> > +             close(fd);
> > +             if (IS_ERR(btf)) {
> > +                     pr_warn("failed to load module [%s]'s BTF object #%d: %ld\n",
> > +                             name, id, PTR_ERR(btf));
> > +                     return PTR_ERR(btf);
> > +             }
> > +
> > +             err = btf_ensure_mem((void **)&obj->btf_modules, &obj->btf_module_cap,
> > +                                  sizeof(*obj->btf_modules), obj->btf_module_cnt + 1);
> > +             if (err)
> > +                     return err;
> > +
> > +             mod_btf = &obj->btf_modules[obj->btf_module_cnt++];
> > +
> > +             mod_btf->btf = btf;
> > +             mod_btf->id = id;
> > +             mod_btf->name = strdup(name);
> > +             if (!mod_btf->name)
> > +                     return -ENOMEM;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> >  static struct core_cand_list *
> >  bpf_core_find_cands(struct bpf_object *obj, const struct btf *local_btf, __u32 local_type_id)
> >  {
> >       struct core_cand local_cand = {};
> >       struct core_cand_list *cands;
> > +     const struct btf *main_btf;
> >       size_t local_essent_len;
> > -     int err;
> > +     int err, i;
> >
> >       local_cand.btf = local_btf;
> >       local_cand.t = btf__type_by_id(local_btf, local_type_id);
> > @@ -4697,15 +4824,38 @@ bpf_core_find_cands(struct bpf_object *obj, const struct btf *local_btf, __u32 l
> >               return ERR_PTR(-ENOMEM);
> >
> >       /* Attempt to find target candidates in vmlinux BTF first */
> > -     err = bpf_core_add_cands(&local_cand, local_essent_len,
> > -                              obj->btf_vmlinux_override ?: obj->btf_vmlinux,
> > -                              "vmlinux", 1, cands);
> > -     if (err) {
> > -             bpf_core_free_cands(cands);
> > -             return ERR_PTR(err);
> > +     main_btf = obj->btf_vmlinux_override ?: obj->btf_vmlinux;
> > +     err = bpf_core_add_cands(&local_cand, local_essent_len, main_btf, "vmlinux", 1, cands);
> > +     if (err)
> > +             goto err_out;
> > +
> > +     /* if vmlinux BTF has any candidate, don't got for module BTFs */
>
> small typo: don't got for -> don't go for
>

oops

> > +     if (cands->len)
> > +             return cands;
> > +
> > +     /* if vmlinux BTF was overridden, don't attempt to load module BTFs */
> > +     if (obj->btf_vmlinux_override)
> > +             return cands;
> > +
> > +     /* now look through module BTFs, trying to still find candidates */
> > +     err = load_module_btfs(obj);
> > +     if (err)
> > +             goto err_out;
> > +
> > +     for (i = 0; i < obj->btf_module_cnt; i++) {
> > +             err = bpf_core_add_cands(&local_cand, local_essent_len,
> > +                                      obj->btf_modules[i].btf,
> > +                                      obj->btf_modules[i].name,
> > +                                      btf__get_nr_types(obj->btf_vmlinux) + 1,
> > +                                      cands);
> > +             if (err)
> > +                     goto err_out;
> >       }
> >
> >       return cands;
> > +err_out:
> > +     bpf_core_free_cands(cands);
> > +     return ERR_PTR(err);
> >  }
> >
