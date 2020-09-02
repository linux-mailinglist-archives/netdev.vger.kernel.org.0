Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DE525A24D
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 02:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgIBAeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 20:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBAee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 20:34:34 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22F6C061244;
        Tue,  1 Sep 2020 17:34:33 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id p6so1881118ybk.10;
        Tue, 01 Sep 2020 17:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=94J5H2V1Wl7afJZxlxyWNQrXiP/JmS+4G4HVRafLchE=;
        b=IwesV9G15u1XXdDxSxcDcovKneWjVyxjNHjhDspp5VDNxuuFw3emgnfFtg6T59InIv
         Folh5QbyvUVkTr0pHeBMhSatO4NXAyYOBy+Yus2AhLUjKg/Z34Sip0ca8P9ncMRow51W
         e3cnPcrT2ZU4P5JQxBGKjDzRbwRfjgx/AFnc3h31+sTyl6zhQzxsVVXxQ2xGN5LqnLkb
         MqtNRD1VMNWPun8dconQEq586qxBnqlqwOCFVGZvsQ+l4Ln3DsEXequ0QVETAAmg6Q+L
         KhDm6ZNY9KowRiOGCFdVnZhI1ure9viAxrDGkt2T9NxJYxGXlCUQosiJG2hMel+ZyVNw
         B8/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=94J5H2V1Wl7afJZxlxyWNQrXiP/JmS+4G4HVRafLchE=;
        b=A1oLgoAch9Xic222Gz2dlZ+A0gIUJwE3yIjXwPNTltU7pibCBn0stjcExeAivForP/
         j8CFzmktPnuerLuRhOESK1KALiWpB/Ll05Flhsike6XKU3/7ZtJranebuzF6KP0uSI3B
         gkppi8ukNTXJcKXfCTktvUUa8H3PtABYga3+uBebv8GH+G+5ReqBwiT6ebTOZwsM9qwT
         fPTsSLvaktE523DLa05cU0HRXnIBCL8lItN1fZQQ1sqEdRbP3eOVwj3bMIv4juDnzExJ
         A5mVKdm9Wasbk1xjaNqG6OQqOxnET6QWa+dZKduYWRB9EyfRUxo/8tOAvguZyEec+hVQ
         Hu1A==
X-Gm-Message-State: AOAM532NDhiyAqcNRK8rqGHCC+Q8nOHJaRJZn+BgeGVl3dEyminDOd90
        TJM6QW+YD/iBUr0McqB4piGBHLbaCNgOAfnkhgA=
X-Google-Smtp-Source: ABdhPJzwSBZY4kddq1fiBHkcVLkL5+x/z/WsKQYmSiF+pIzN1kyDusKDltzq3atXxf/yAhPMN8liEtmJv+gZz/k6a4Q=
X-Received: by 2002:a25:c4c2:: with SMTP id u185mr7007701ybf.347.1599006871995;
 Tue, 01 Sep 2020 17:34:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200827000618.2711826-1-yhs@fb.com> <20200827000620.2711963-1-yhs@fb.com>
 <CAEf4BzYBQVX-YQyZiJe+xrMUmk_k+mU=Q-RNULeS4pt-YyzQUA@mail.gmail.com> <784f27f8-552a-41e8-c8c4-a4ea0b590884@fb.com>
In-Reply-To: <784f27f8-552a-41e8-c8c4-a4ea0b590884@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Sep 2020 17:34:21 -0700
Message-ID: <CAEf4BzbW20hYtFqTf+cynVqbOtVJK7oO7ySBB+WP6yRRYdQoNw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] bpf: add main_thread_only customization for
 task/task_file iterators
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

On Thu, Aug 27, 2020 at 11:09 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/26/20 10:07 PM, Andrii Nakryiko wrote:
> > On Wed, Aug 26, 2020 at 5:07 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> Currently, task and task_file by default iterates through
> >> all tasks. For task_file, by default, all files from all tasks
> >> will be traversed.
> >>
> >> But for a user process, the file_table is shared by all threads
> >> of that process. So traversing the main thread per process should
> >> be enough to traverse all files and this can save a lot of cpu
> >> time if some process has large number of threads and each thread
> >> has lots of open files.
> >>
> >> This patch implemented a customization for task/task_file iterator,
> >> permitting to traverse only the kernel task where its pid equal
> >> to tgid in the kernel. This includes some kernel threads, and
> >> main threads of user processes. This will solve the above potential
> >> performance issue for task_file. This customization may be useful
> >> for task iterator too if only traversing main threads is enough.
> >>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >>   include/linux/bpf.h            |  3 ++-
> >>   include/uapi/linux/bpf.h       |  5 ++++
> >>   kernel/bpf/task_iter.c         | 46 +++++++++++++++++++++++-----------
> >>   tools/include/uapi/linux/bpf.h |  5 ++++
> >>   4 files changed, 43 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> >> index a6131d95e31e..058eb9b0ba78 100644
> >> --- a/include/linux/bpf.h
> >> +++ b/include/linux/bpf.h
> >> @@ -1220,7 +1220,8 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
> >>          int __init bpf_iter_ ## target(args) { return 0; }
> >>
> >>   struct bpf_iter_aux_info {
> >> -       struct bpf_map *map;
> >> +       struct bpf_map *map;    /* for iterator traversing map elements */
> >> +       bool main_thread_only;  /* for task/task_file iterator */
> >
> > As a user of task_file iterator I'd hate to make this decision,
> > honestly, especially if I can't prove that all processes share the
> > same file table (I think clone() syscall allows to do weird
> > combinations like that, right?). It does make sense for a task/
>
> Right. the clone() syscall permits different kinds of sharing,
> sharing address space and sharing files are separated. It is possible
> that address space is shared and files are not shared. That is
> why I want to add flags for task_file so that if user knows
> they do not have cases where address space shared and files not
> shared, they can use main_thread_only to improve performance.

The problem with such options is that for a lot of users it won't be
clear at all when and if those options can be used. E.g., when I
imagine myself building some generic tool utilizing task_file bpf_iter
that is supposed to be run on any server, how do I know if it's safe
to specify "main_thread_only"? I can't guarantee that. So I'll be
forced to either risk it or fallback to default and unnecessarily slow
behavior.

This is different for task/ bpf_iter, though, so I support that for
task/ only. But you've already done that split, so thank you! :)

>
> > iterator, though, if I need to iterate a user-space process (group of
> > tasks). So can we do this:
> >
> > 1a. Either add a new bpf_iter type process/ (or in kernel lingo
> > task_group/) to iterate only main threads (group_leader in kernel
> > lingo);
> > 1b. Or make this main_thread_only an option for only a task/ iterator
> > (and maybe call it "group_leader_only" or something to reflect kernel
> > terminology?)
>
> The following is the kernel pid_type definition,
>
> enum pid_type
> {
>          PIDTYPE_PID,
>          PIDTYPE_TGID,
>          PIDTYPE_PGID,
>          PIDTYPE_SID,
>          PIDTYPE_MAX,
> };
>
> Right now, task iterator is traversed following
> PIDTYPE_PID, i.e., every tasks in the system.
>
> To iterate through main thread, we need to traverse following
> PIDTYPE_TGID.
>
> In the future, it is possible, people want to traverse
> following PIDTYPE_PGID (process group) or PIDTYPE_SID (session).
>
> Or we might have other customization, e.g., cgroup_id, which can
> be filtered in the bpf program, but in-kernel filtering can
> definitely improve performance.
>
> So I prefer 1b.

Sounds good, but let's use a proper enum, not a set of bit fields. We
can support all 4 from the get go. There is no need to wait for the
actual use case to appear, as the iteration semantics is pretty clear.

>
> Yes, naming is hard.
> The name "main_thread_only" is mostly from userspace perspective.
> "group_leader_only" might not be good as it may be confused with
> possible future process group.
>
> >
> > 2. For task/file iterator, still iterate all tasks, but if the task's
> > files struct is the same as group_leader's files struct, then go to
> > the next one. This should eliminate tons of duplication of iterating
> > the same files over and over. It would still iterate a bunch of tasks,
> > but compared to the number of files that's generally a much smaller
> > number, so should still give sizable savings. I don't think we need an
> > extra option for this, tbh, this behavior was my intuitive
> > expectation, so I don't think you'll be breaking any sane user of this
> > iterator.
>
> What you suggested makes sense. for task_file iterator, we only promise
> to visit all files from all tasks. We can do necessary filtering to
> remove duplicates in the kernel and did not break promise.
> I will remove customization from task_file iterator.

Thanks for doing that!

>
> >
> > Disclaimer: I haven't got a chance to look through kernel code much,
> > so I'm sorry if what I'm proposing is something that is impossible to
> > implement or extremely hard/unreliable. But thought I'll put this idea
> > out there before we decide on this.
> >
> > WDYT?
> >
> > [...]
> >
