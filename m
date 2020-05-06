Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690431C6632
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 05:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgEFDKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 23:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgEFDKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 23:10:05 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBBEC061A0F;
        Tue,  5 May 2020 20:10:03 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id g185so562475qke.7;
        Tue, 05 May 2020 20:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pV/ZL32hviuPWhiulKnGp8Sn0pIBnn99XtNkeTnvSho=;
        b=QTfPyZjxILfBXSZhZ1M+0PIh5X84MlHr5/yfp+46e4oboaqYhqThQW1YxyEqDWZO9n
         c7eW//0vF27XtWDaisnozQbDHqGVAOD+nc1BVzkYn7GLDgBvt58amKPVXqB0Z/ObTLZS
         mBE0Pa5qfEsmo49BaZYxW1LdGek37MgoDZk/56fUff+2GG0G+YU3RehijzIeZPY5FRw+
         xyqVZ74omfli1Ul9JehzojOmwpbt9ktJ3LZAAgDNH+BCKpMNmS6NgGzaibnm6Wkq+vNd
         Aw4qnuEMI3LBaByC5bRqp1gIGoxNVIbKrB5juo3l5u4zn3ub/zU+EUTPwRtWiViwpX2+
         aSUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pV/ZL32hviuPWhiulKnGp8Sn0pIBnn99XtNkeTnvSho=;
        b=bpdW8tI2rEc8iJMeK7sYIzMwNfHTMSjhpB/IRsB+2i7uQov7lNF465LpvDQqLiU49s
         R77YBsypWr9wEtwhgX7dREq/GomcfLiKIsUymYm/0pkUI7B899XlCOQoULf2+f/5/eOx
         S5ei8TVW9lj+sTpu6oegQ8FqizQJ1iMxSoTNPpScrjc8+cLgHsboeKkgQoziPJSTeKyB
         6W8Wp4pRRIRbf7/a/MPGw7Ii7XCykymbNU0+fVVchRjNcpuIre0gh1ECxZiryw3W0lQp
         Tuwz0KOe3MPMYLA2BOliY8GzgVSIGi10x2BQsnLZDzeehRJrtXO5Unkw+Smg8qdxd16C
         MPwg==
X-Gm-Message-State: AGi0PuZUXL/lsr6JHRBTsKS48T6U2bjqJwBZmDTkwLUzgZajMPsKD9jQ
        GKKVPrrbVDl2+AxaKpmT5tWamSPZXS54qHeog+34Qqzn
X-Google-Smtp-Source: APiQypJ7vAIoTlH71ReWYo0xTrHB2gpuL1AmR1jbSEIXZNnsno7GCoOZoHblW0FHPqUTgUgsHex2kfR4cgzQPno4+vg=
X-Received: by 2002:ae9:e10b:: with SMTP id g11mr7232988qkm.449.1588734602827;
 Tue, 05 May 2020 20:10:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062549.2047531-1-yhs@fb.com>
 <CAEf4BzYxTwmxEVk6DG9GzkqHDF--VqvZWik0YJigzdrn3whcXA@mail.gmail.com>
 <e71a26e7-1a78-7e4d-23d6-20070541524d@fb.com> <fe5d8d02-b263-c373-9ab8-c709f4c5841f@fb.com>
In-Reply-To: <fe5d8d02-b263-c373-9ab8-c709f4c5841f@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 20:09:51 -0700
Message-ID: <CAEf4BzZFqPkq=E0c1eMFoKzUQF7h+aMufE3XEpcXXEQkTvYEPA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 03/20] bpf: support bpf tracing/iter programs
 for BPF_LINK_CREATE
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 5:54 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 5/5/20 5:14 PM, Yonghong Song wrote:
> >
> >
> > On 5/5/20 2:30 PM, Andrii Nakryiko wrote:
> >> On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
> >>>
> >>> Given a bpf program, the step to create an anonymous bpf iterator is:
> >>>    - create a bpf_iter_link, which combines bpf program and the target.
> >>>      In the future, there could be more information recorded in the
> >>> link.
> >>>      A link_fd will be returned to the user space.
> >>>    - create an anonymous bpf iterator with the given link_fd.
> >>>
> >>> The bpf_iter_link can be pinned to bpffs mount file system to
> >>> create a file based bpf iterator as well.
> >>>
> >>> The benefit to use of bpf_iter_link:
> >>>    - using bpf link simplifies design and implementation as bpf link
> >>>      is used for other tracing bpf programs.
> >>>    - for file based bpf iterator, bpf_iter_link provides a standard
> >>>      way to replace underlying bpf programs.
> >>>    - for both anonymous and free based iterators, bpf link query
> >>>      capability can be leveraged.
> >>>
> >>> The patch added support of tracing/iter programs for BPF_LINK_CREATE.
> >>> A new link type BPF_LINK_TYPE_ITER is added to facilitate link
> >>> querying. Currently, only prog_id is needed, so there is no
> >>> additional in-kernel show_fdinfo() and fill_link_info() hook
> >>> is needed for BPF_LINK_TYPE_ITER link.
> >>>
> >>> Signed-off-by: Yonghong Song <yhs@fb.com>
> >>> ---
> >>
> >> LGTM. See small nit about __GFP_NOWARN.
> >>
> >> Acked-by: Andrii Nakryiko <andriin@fb.com>
> >>
> >>
> >>>   include/linux/bpf.h            |  1 +
> >>>   include/linux/bpf_types.h      |  1 +
> >>>   include/uapi/linux/bpf.h       |  1 +
> >>>   kernel/bpf/bpf_iter.c          | 62 ++++++++++++++++++++++++++++++++++
> >>>   kernel/bpf/syscall.c           | 14 ++++++++
> >>>   tools/include/uapi/linux/bpf.h |  1 +
> >>>   6 files changed, 80 insertions(+)
> >>>
> >>
> >> [...]
> >>
> >>> +int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog
> >>> *prog)
> >>> +{
> >>> +       struct bpf_link_primer link_primer;
> >>> +       struct bpf_iter_target_info *tinfo;
> >>> +       struct bpf_iter_link *link;
> >>> +       bool existed = false;
> >>> +       u32 prog_btf_id;
> >>> +       int err;
> >>> +
> >>> +       if (attr->link_create.target_fd || attr->link_create.flags)
> >>> +               return -EINVAL;
> >>> +
> >>> +       prog_btf_id = prog->aux->attach_btf_id;
> >>> +       mutex_lock(&targets_mutex);
> >>> +       list_for_each_entry(tinfo, &targets, list) {
> >>> +               if (tinfo->btf_id == prog_btf_id) {
> >>> +                       existed = true;
> >>> +                       break;
> >>> +               }
> >>> +       }
> >>> +       mutex_unlock(&targets_mutex);
> >>> +       if (!existed)
> >>> +               return -ENOENT;
> >>> +
> >>> +       link = kzalloc(sizeof(*link), GFP_USER | __GFP_NOWARN);
> >>
> >> nit: all existing link implementation don't specify __GFP_NOWARN,
> >> wonder if bpf_iter_link should be special?
> >
> > Nothing special. Just feel __GFP_NOWARN is the right thing to do to
> > avoid pollute dmesg since -ENOMEM is returned to user space. But in
> > reality, unlike some key/value allocation where the size could be huge
> > and __GFP_NOWARN might be more useful, here, sizeof(*link) is fixed
> > and small, __GFP_NOWARN probably not that useful.
> >
> > Will drop it.
>
> actually all existing user space driven allocation have nowarn.

Can you define "user space driven"? I understand why for map, map key,
map value, program we want to do that, because it's way too easy for
user-space to specify huge sizes and allocation is proportional to
that size. But in this case links are fixed-sized objects, same as
struct file and struct inode. From BPF world, for instance, there is
struct bpf_prog_list, which is created when user is attaching BPF
program to cgroup, so it is user-space driven in similar sense. Yet we
allocate it without __GFP_NOWARN.

> If we missed it in other link allocs we should probably add it.

Before bpf_link was formalized, raw_tracepoint_open was creating
struct bpf_raw_tracepoint, without NOWARN.
