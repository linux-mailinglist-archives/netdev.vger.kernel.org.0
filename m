Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A943239EA3
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 07:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgHCFLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 01:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgHCFLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 01:11:50 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A58C06174A;
        Sun,  2 Aug 2020 22:11:50 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id e14so5674758ybf.4;
        Sun, 02 Aug 2020 22:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4zSYeHmHBrAULPhrlcnHcpw93NzjhvpFppyq9dOmG2k=;
        b=EBEwfQErxLfOxZFdh8Tt+SQcYHdUhffRAuPXaX210bXdiQdYDJz88oppBQQPioYC7+
         fhfksn4RebuOCC8JcC4oPOgfrMWgEr0TAFtte5reg9R7gHMTjj2wC8i/FdagHxqy9sIa
         szSBIBCY3mHTAmUOcLFLN8Tv4RE+ioh+6zSFp9EzKQTlpmJqO1s16bDDJhiA/7oAHNMk
         G8E+B5THvVXDNKJU9wJXrxx2NGmKgaeKc61ymIoT8cfKLuZ8bd6fGCBKuntDsjSWM93h
         ++xQCMDFdfXBYqcjmAaxF/YukpqkYomjdt2cEIGkJmMr1K4baqt2Szo5Icq6gaqAEdrY
         L4sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4zSYeHmHBrAULPhrlcnHcpw93NzjhvpFppyq9dOmG2k=;
        b=FcjYrCaCG6NjwhjD9D2B0XZHg2GuUVYymY+5Mi72Pt2B5T6MoeHSgHh6fnUiOQnSSd
         VRPaLK9QLJ3Ev1mb8o684cyK3yATi8Pa2253o+FvMU5HpF6x/jssY80NMACV1aWIHgPS
         L18u3SzgsZup4ptBTCMzWAf0blHzJnQMEAUwt5k8zwp33jYC5CEtE3sj7CTHLZNV6MrU
         nVmo5je7hSTZBjhlI0+UKEhq+OTgftvccM4zpcMbMeuXyIBMlatTq2YNdqbyhhSdKZlC
         OzF6ejTUNmz/vMQfxRjGpW2I6UqsbDeOcszb0neZ5qJtanrthd35zO4ORZSIrWqjaSDM
         3fxw==
X-Gm-Message-State: AOAM532tIurwdt4+PQfDgVpm64V8jm2ypQZjaZrB3OeCE+M5IhSW70BC
        UfwQPCWmP+QcsQQPxUJloPTij/Fyy0dfcLPPXVU=
X-Google-Smtp-Source: ABdhPJwQEQk/WXvmqfK3ZzH0Ir/fWiuI0dEFJJYdUICZt3SPth+qGRB29RNLLxQvdRl5TLnfqjhRJcq+w4QgsKdRDUA=
X-Received: by 2002:a25:37c8:: with SMTP id e191mr21573154yba.230.1596431509242;
 Sun, 02 Aug 2020 22:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200802042126.2119783-1-yhs@fb.com> <20200802042126.2119843-1-yhs@fb.com>
 <CAEf4BzbaRXHpZ5b_6rojnk2dQxLFCOEwtGjNExdg5FEWadF+9g@mail.gmail.com> <bb01225b-d4a4-c76b-5e1f-3dc37135f637@fb.com>
In-Reply-To: <bb01225b-d4a4-c76b-5e1f-3dc37135f637@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 2 Aug 2020 22:11:38 -0700
Message-ID: <CAEf4Bzbr--=tbmLqrgbtA4ERy8KmCYvBDfP5PciXx9x3yWpmsQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: change uapi for bpf iterator map elements
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 2, 2020 at 7:23 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/2/20 6:25 PM, Andrii Nakryiko wrote:
> > On Sat, Aug 1, 2020 at 9:22 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> Commit a5cbe05a6673 ("bpf: Implement bpf iterator for
> >> map elements") added bpf iterator support for
> >> map elements. The map element bpf iterator requires
> >> info to identify a particular map. In the above
> >> commit, the attr->link_create.target_fd is used
> >> to carry map_fd and an enum bpf_iter_link_info
> >> is added to uapi to specify the target_fd actually
> >> representing a map_fd:
> >>      enum bpf_iter_link_info {
> >>          BPF_ITER_LINK_UNSPEC = 0,
> >>          BPF_ITER_LINK_MAP_FD = 1,
> >>
> >>          MAX_BPF_ITER_LINK_INFO,
> >>      };
> >>
> >> This is an extensible approach as we can grow
> >> enumerator for pid, cgroup_id, etc. and we can
> >> unionize target_fd for pid, cgroup_id, etc.
> >> But in the future, there are chances that
> >> more complex customization may happen, e.g.,
> >> for tasks, it could be filtered based on
> >> both cgroup_id and user_id.
> >>
> >> This patch changed the uapi to have fields
> >>          __aligned_u64   iter_info;
> >>          __u32           iter_info_len;
> >> for additional iter_info for link_create.
> >> The iter_info is defined as
> >>          union bpf_iter_link_info {
> >>                  struct {
> >>                          __u32   map_fd;
> >>                  } map;
> >>          };
> >>
> >> So future extension for additional customization
> >> will be easier. The bpf_iter_link_info will be
> >> passed to target callback to validate and generic
> >> bpf_iter framework does not need to deal it any
> >> more.
> >>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >>   include/linux/bpf.h            | 10 ++++---
> >>   include/uapi/linux/bpf.h       | 15 +++++-----
> >>   kernel/bpf/bpf_iter.c          | 52 +++++++++++++++-------------------
> >>   kernel/bpf/map_iter.c          | 37 ++++++++++++++++++------
> >>   kernel/bpf/syscall.c           |  2 +-
> >>   net/core/bpf_sk_storage.c      | 37 ++++++++++++++++++------
> >>   tools/include/uapi/linux/bpf.h | 15 +++++-----
> >>   7 files changed, 104 insertions(+), 64 deletions(-)
> >>
> >
> > [...]
> >
> >>   int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> >>   {
> >> +       union bpf_iter_link_info __user *ulinfo;
> >>          struct bpf_link_primer link_primer;
> >>          struct bpf_iter_target_info *tinfo;
> >> -       struct bpf_iter_aux_info aux = {};
> >> +       union bpf_iter_link_info linfo;
> >>          struct bpf_iter_link *link;
> >> -       u32 prog_btf_id, target_fd;
> >> +       u32 prog_btf_id, linfo_len;
> >>          bool existed = false;
> >> -       struct bpf_map *map;
> >>          int err;
> >>
> >> +       memset(&linfo, 0, sizeof(union bpf_iter_link_info));
> >> +
> >> +       ulinfo = u64_to_user_ptr(attr->link_create.iter_info);
> >> +       linfo_len = attr->link_create.iter_info_len;
> >> +       if (ulinfo && linfo_len) {
> >
> > We probably want to be more strict here: if either pointer or len is
> > non-zero, both should be present and valid. Otherwise we can have
> > garbage in iter_info, as long as iter_info_len is zero.
>
> yes, it is possible iter_info_len = 0 and iter_info is not null and
> if this happens, iter_info will not be examined.
>
> in kernel, we have places this is handled similarly. For example,
> for cgroup bpf_prog query.
>
> kernel/bpf/cgroup.c, function __cgroup_bpf_query
>
>    __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
>    ...
>    if (attr->query.prog_cnt == 0 || !prog_ids || !cnt)
>      return 0;
>
> In the above case, it is possible prog_cnt = 0 and prog_ids != NULL,
> or prog_ids == NULL and prog_cnt != 0, and we won't return error
> to user space.
>
> Not 100% sure whether we have convention here or not.

I don't know either, but I'd assume that we didn't think about 100%
strictness when originally implementing this. So I'd go with a very
strict check for this new functionality.

>
> >
> >> +               err = bpf_check_uarg_tail_zero(ulinfo, sizeof(linfo),
> >> +                                              linfo_len);
> >> +               if (err)
> >> +                       return err;
> >> +               linfo_len = min_t(u32, linfo_len, sizeof(linfo));
> >> +               if (copy_from_user(&linfo, ulinfo, linfo_len))
> >> +                       return -EFAULT;
> >> +       }
> >> +
> >>          prog_btf_id = prog->aux->attach_btf_id;
> >>          mutex_lock(&targets_mutex);
> >>          list_for_each_entry(tinfo, &targets, list) {
> >> @@ -411,13 +425,6 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> >>          if (!existed)
> >>                  return -ENOENT;
> >>
> >> -       /* Make sure user supplied flags are target expected. */
> >> -       target_fd = attr->link_create.target_fd;
> >> -       if (attr->link_create.flags != tinfo->reg_info->req_linfo)
> >> -               return -EINVAL;
> >> -       if (!attr->link_create.flags && target_fd)
> >> -               return -EINVAL;
> >> -
> >
> > Please still ensure that no flags are specified.
>
> Make sense. I also need to ensure target_fd is 0 since it is not used
> any more.
>

yep, good catch

> >
> >
> >>          link = kzalloc(sizeof(*link), GFP_USER | __GFP_NOWARN);
> >>          if (!link)
> >>                  return -ENOMEM;
> >> @@ -431,28 +438,15 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> >>                  return err;
> >>          }
> >>
> >
> > [...]
> >
> >> -static int bpf_iter_check_map(struct bpf_prog *prog,
> >> -                             struct bpf_iter_aux_info *aux)
> >> +static int bpf_iter_attach_map(struct bpf_prog *prog,
> >> +                              union bpf_iter_link_info *linfo,
> >> +                              struct bpf_iter_aux_info *aux)
> >>   {
> >> -       struct bpf_map *map = aux->map;
> >> +       struct bpf_map *map;
> >> +       int err = -EINVAL;
> >>
> >> -       if (map->map_type != BPF_MAP_TYPE_SK_STORAGE)
> >> +       if (!linfo->map.map_fd)
> >>                  return -EINVAL;
> >
> > This could be -EBADF?
>
> Good suggestion. Will do.
>
> >
> >>
> >> -       if (prog->aux->max_rdonly_access > map->value_size)
> >> -               return -EACCES;
> >> +       map = bpf_map_get_with_uref(linfo->map.map_fd);
> >> +       if (IS_ERR(map))
> >> +               return PTR_ERR(map);
> >> +
> >> +       if (map->map_type != BPF_MAP_TYPE_SK_STORAGE)
> >> +               goto put_map;
> >> +
> >> +       if (prog->aux->max_rdonly_access > map->value_size) {
> >> +               err = -EACCES;
> >> +               goto put_map;
> >> +       }
> >
> > [...]
> >
