Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B51107B1F
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 00:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfKVXK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 18:10:57 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:46735 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVXK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 18:10:56 -0500
Received: by mail-qv1-f67.google.com with SMTP id w11so3568011qvu.13;
        Fri, 22 Nov 2019 15:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x5Jp99m7olIxfMcap9MR5Thk4YdA/gYYsa0cis3GROA=;
        b=R7gSxqe9o9s0JdDzmFuGpR4se2yRB6gGiIw9MMF60bPTfJVFBBx6Za/bPokgZgRpTa
         uT62Vvbayxh0kihZ0vCaC0uSm92a1FcWUPIeqAqx2gLlQkaemnvVaQx1+tPeMzrN7ZhZ
         M3fItZlsrCI5YnR+NwhC8+LNnql6e+2Kh/5FJf+OhwBEkZXvrNUSRjQgM4uhMk9a3PD7
         G8zFxV89UdYGfpQFWAoX+sSEos4HvNxq9m82kNcAQ7rVrexVWo8koyK0tqQayXIsAsyo
         7snhgdjOeKeeHoVXhXzpfrQcoxMq8AikwWb6eLHgUHAuz0YunPVTIhL6uOP7OUPHDeFR
         MMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x5Jp99m7olIxfMcap9MR5Thk4YdA/gYYsa0cis3GROA=;
        b=RT5WBgHpKy3yCdXwIQikl4czcAR7GwJG9Xwu+3BpSDc+IPdlbAyuuVLEbXTblk1Wyy
         yecgaF/TqNERW6sq1ipbJ5RGuLIB/Qrp1oEf5OGN7XcDOJOU3OD0TFAZOb4uUEHSfGRr
         l/unCV9sRr7iZpfVbCVdtspazROWx4ft+CfWja/a7fHqP8RXLUD93PL1iNiNoFDu/4jt
         i8BqoC1Lk/p8k0E1jILCrcuBmVuAfhUE1GtZt5GuDXhZ3kr0YpDY4SnoN5VU9zHmeo5d
         6AdgWoYVsYyhXdq8nY0UKSUijP+HIUZV/D5jNL95vn2lhvKZw+3pxfVzgWuEFaB7ujIe
         F3fQ==
X-Gm-Message-State: APjAAAWqj/I1CpMpd54sZI8jjfTZjluHuepQsjmwb8lyqrGudF9+s9QU
        mMjTHuzFD4FbHcLYkzc8CJK/kAwpyLKeSkz5EX0mYQ==
X-Google-Smtp-Source: APXvYqy6GQRUvtzm1t+to6X1ms6rSU9I0B1f8KoUrT5m7NkXZK8bv16i1ODjUL3DzajQ0V0mcYlRe4G8k0K9HjJDrXM=
X-Received: by 2002:ad4:4042:: with SMTP id r2mr16624477qvp.196.1574464255606;
 Fri, 22 Nov 2019 15:10:55 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574452833.git.daniel@iogearbox.net> <1fb364bb3c565b3e415d5ea348f036ff379e779d.1574452833.git.daniel@iogearbox.net>
 <CAEf4BzaZf+_WyARsmZ_rgO_+Ug1iSKsqaoWpB-dPXS6uejT=Qg@mail.gmail.com> <d019af80-e6ac-fbd5-f4fd-4743d4df5119@iogearbox.net>
In-Reply-To: <d019af80-e6ac-fbd5-f4fd-4743d4df5119@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 Nov 2019 15:10:44 -0800
Message-ID: <CAEf4BzZ8A9+3jrLLAXm4qyy=GHPmXq1j6THoO0=XYOM=fYvkdg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/8] bpf: add poke dependency tracking for
 prog array maps
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 3:06 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/22/19 11:55 PM, Andrii Nakryiko wrote:
> > On Fri, Nov 22, 2019 at 12:08 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>
> >> This work adds program tracking to prog array maps. This is needed such
> >> that upon prog array updates/deletions we can fix up all programs which
> >> make use of this tail call map. We add ops->map_poke_{un,}track()
> >> helpers to maps to maintain the list of programs and ops->map_poke_run()
> >> for triggering the actual update.
> >>
> >> bpf_array_aux is extended to contain the list head and poke_mutex in
> >> order to serialize program patching during updates/deletions.
> >> bpf_free_used_maps() will untrack the program shortly before dropping
> >> the reference to the map. For clearing out the prog array once all urefs
> >> are dropped we need to use schedule_work() to have a sleepable context.
> >>
> >> The prog_array_map_poke_run() is triggered during updates/deletions and
> >> walks the maintained prog list. It checks in their poke_tabs whether the
> >> map and key is matching and runs the actual bpf_arch_text_poke() for
> >> patching in the nop or new jmp location. Depending on the type of update,
> >> we use one of BPF_MOD_{NOP_TO_JUMP,JUMP_TO_NOP,JUMP_TO_JUMP}.
> >>
> >> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> >> ---
> >>   include/linux/bpf.h   |  12 +++
> >>   kernel/bpf/arraymap.c | 183 +++++++++++++++++++++++++++++++++++++++++-
> >>   kernel/bpf/core.c     |   9 ++-
> >>   kernel/bpf/syscall.c  |  20 +++--
> >>   4 files changed, 212 insertions(+), 12 deletions(-)
> >>
> >
> > [...]
> >
> >> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> >> index 5a9873e58a01..bb002f15b32a 100644
> >> --- a/kernel/bpf/syscall.c
> >> +++ b/kernel/bpf/syscall.c
> >> @@ -26,12 +26,13 @@
> >>   #include <linux/audit.h>
> >>   #include <uapi/linux/btf.h>
> >>
> >> -#define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PROG_ARRAY || \
> >> -                          (map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
> >> -                          (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
> >> -                          (map)->map_type == BPF_MAP_TYPE_ARRAY_OF_MAPS)
> >> +#define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
> >> +                         (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
> >> +                         (map)->map_type == BPF_MAP_TYPE_ARRAY_OF_MAPS)
> >> +#define IS_FD_PROG_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PROG_ARRAY)
> >>   #define IS_FD_HASH(map) ((map)->map_type == BPF_MAP_TYPE_HASH_OF_MAPS)
> >> -#define IS_FD_MAP(map) (IS_FD_ARRAY(map) || IS_FD_HASH(map))
> >> +#define IS_FD_MAP(map) (IS_FD_ARRAY(map) || IS_FD_PROG_ARRAY(map) || \
> >> +                       IS_FD_HASH(map))
> >>
> >>   #define BPF_OBJ_FLAG_MASK   (BPF_F_RDONLY | BPF_F_WRONLY)
> >>
> >> @@ -878,7 +879,7 @@ static int map_lookup_elem(union bpf_attr *attr)
> >>                  err = bpf_percpu_cgroup_storage_copy(map, key, value);
> >>          } else if (map->map_type == BPF_MAP_TYPE_STACK_TRACE) {
> >>                  err = bpf_stackmap_copy(map, key, value);
> >> -       } else if (IS_FD_ARRAY(map)) {
> >> +       } else if (IS_FD_ARRAY(map) || IS_FD_PROG_ARRAY(map)) {
> >
> > Why BPF_MAP_TYPE_PROG_ARRAY couldn't still stay as "IS_FD_ARRAY"?
> > Seems like it's still handled the same here and is technically an
> > array containing FDs, no? You can still have more precise
>
> For the update and delete method we need to hold the mutex in prog array
> which is why we cannot be under RCU there. For the lookup itself it can
> stay as-is since it's not a modification hence the or above.
>
> > IS_FD_PROG_ARRAY, for cases like in map_update_elem(), where you need
> > to special-handle just that map type.
> >
> >>                  err = bpf_fd_array_map_lookup_elem(map, key, value);
> >>          } else if (IS_FD_HASH(map)) {
> >>                  err = bpf_fd_htab_map_lookup_elem(map, key, value);
> >> @@ -1005,6 +1006,10 @@ static int map_update_elem(union bpf_attr *attr)
> >>                     map->map_type == BPF_MAP_TYPE_SOCKMAP) {
> >>                  err = map->ops->map_update_elem(map, key, value, attr->flags);
> >>                  goto out;
> >> +       } else if (IS_FD_PROG_ARRAY(map)) {
> >> +               err = bpf_fd_array_map_update_elem(map, f.file, key, value,
> >> +                                                  attr->flags);
> >> +               goto out;
> >>          }
> >>
> >>          /* must increment bpf_prog_active to avoid kprobe+bpf triggering from
> >> @@ -1087,6 +1092,9 @@ static int map_delete_elem(union bpf_attr *attr)
> >>          if (bpf_map_is_dev_bound(map)) {
> >>                  err = bpf_map_offload_delete_elem(map, key);
> >>                  goto out;
> >> +       } else if (IS_FD_PROG_ARRAY(map)) {
> >> +               err = map->ops->map_delete_elem(map, key);
> >
> > map->ops->map_delete_elem would be called below anyways, except under
> > rcu_read_lock() with preempt_disable() (maybe_wait_bpf_programs() is
> > no-op for prog_array). So if there is specific reason we want to avoid
> > preempt_disable and rcu_read_lock(), would be nice to have a comment
> > explaining that.
>
> See answer above. I didn't add an explicit comment there since it's not done
> for all the others either, but seems obvious when looking at the map implementation
> and prog_array_map_poke_run() / bpf_arch_text_poke().

Ok, fair enough. I was a bit lazy in trying to figure this out :)

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> Thanks,
> Daniel
