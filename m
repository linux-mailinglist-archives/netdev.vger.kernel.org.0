Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3168744F40B
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 16:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbhKMPvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 10:51:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhKMPvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 10:51:15 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C153DC061766;
        Sat, 13 Nov 2021 07:48:22 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id bu11so8359946qvb.0;
        Sat, 13 Nov 2021 07:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oXbQA6YsK/Yb8I1ufwTowmeWehU5ZLa6WqLwd/WJnR0=;
        b=ImBzKERFqdjBGrGwyXdvLPxokVVH/YOD6syxy5Ry7EoZ7JA1ZgRpH36/Ir2IBUSx8W
         gS0HmCEFLrPn8WeyKPwEHIKMJ8MsoQKXk07euxX0IcdQLNiTUxjGZQqX9d7aI435mJq7
         QePMM1Q6vqImAExonnt61+8iV7HOUhqKsJvwCo+s5DSG0p8dfVub4pnX3y3g9rWeXJGP
         s9Mi2AmGn/L6seJC8NjdI8dnnTh/v07eZIEcb9LSYEY+5wguwcQdBUGlxdKg1fR7SASX
         PlYXoa7CPenBQheitAgVSHtWNxpkfdc6wMn6uumIY9JQJs7Eb1xfWp0PpdG4DXYQNu/x
         ADAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oXbQA6YsK/Yb8I1ufwTowmeWehU5ZLa6WqLwd/WJnR0=;
        b=Gk/WIU2vM07u3Zx6rEpgVFkjLlWAMk/MWTkuCjka30m4LQZGnLWqzbzMDMv6E1UllS
         ihwXA/9gtyQUHELXOKx+KSrvrPSxr0lxLoFMhe2gLXOvd7Xef9mSKhYvSsTk3BX4Ytpj
         BPMxZl8PChFqowG88kF/0bxsSPNUfGZ0qMUa4GFV1MWA7B9Fiin6uWmCI5VMBCASjFWx
         lmyCapcRQOLv8LmCN1t4zArH3HaRo7qok6UzXpm+3JC6In1gdhvCJTPblhDcONtAo9BS
         EGfS5GlQbsjpw9kLl1vGLedPh6hlUvwetHMxU86q8a77csS0tbLISRGPp4H6U4o9+r3u
         HOGA==
X-Gm-Message-State: AOAM531SEEUOXfA1ss0BGonTBbQ8kl6lo5bFZc8OBCevLOyozQ4rGt+8
        CM6W8SKzoGhAJxF/82OaX7TrB/Usws++vsuuPzs=
X-Google-Smtp-Source: ABdhPJwHPNIdUDZB1WofY0EyhE09P++WglgHkH4uOkSjWwuZbEIP1MOmjqdsr8nWmrB6p2F41NZVSXMsSppxTlGYQ68=
X-Received: by 2002:a05:6214:f2d:: with SMTP id iw13mr23317601qvb.13.1636818501919;
 Sat, 13 Nov 2021 07:48:21 -0800 (PST)
MIME-Version: 1.0
References: <20211108084142.4692-1-laoar.shao@gmail.com> <YY6JhZK/oiLUwHyZ@alley>
In-Reply-To: <YY6JhZK/oiLUwHyZ@alley>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 13 Nov 2021 23:47:45 +0800
Message-ID: <CALOAHbA5LBHyJn=EC1roHYt7ar-QqHzLE=KHQ6uC=a__3Pwxfw@mail.gmail.com>
Subject: Re: [PATCH] kthread: dynamically allocate memory to store kthread's
 full name
To:     Petr Mladek <pmladek@suse.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 11:34 PM Petr Mladek <pmladek@suse.com> wrote:
>
> On Mon 2021-11-08 08:41:42, Yafang Shao wrote:
> > When I was implementing a new per-cpu kthread cfs_migration, I found the
> > comm of it "cfs_migration/%u" is truncated due to the limitation of
> > TASK_COMM_LEN. For example, the comm of the percpu thread on CPU10~19 are
> > all with the same name "cfs_migration/1", which will confuse the user. This
> > issue is not critical, because we can get the corresponding CPU from the
> > task's Cpus_allowed. But for kthreads correspoinding to other hardware
> > devices, it is not easy to get the detailed device info from task comm,
> > for example,
> >
> > After this change, the full name of these truncated kthreads will be
> > displayed via /proc/[pid]/comm:
> >
> > --- a/fs/proc/array.c
> > +++ b/fs/proc/array.c
> > @@ -102,6 +103,8 @@ void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
> >
> >       if (p->flags & PF_WQ_WORKER)
> >               wq_worker_comm(tcomm, sizeof(tcomm), p);
>
> Just for record. I though that this patch obsoleted wq_worker_comm()
> but it did not. wq_worker_comm() returns different values
> depending on the last proceed work item and has to stay.
>

Right. worker comm is changed dynamically, which is combined by
(task_comm+worker_desc) or (task_comm-worker_desc).
I planned to remove the whole worker->desc and set it dynamically to
the new kthread full_name but I found it may not be a good idea.


> > +     else if (p->flags & PF_KTHREAD)
> > +             get_kthread_comm(tcomm, sizeof(tcomm), p);
> >       else
> >               __get_task_comm(tcomm, sizeof(tcomm), p);
> >
> > --- a/kernel/kthread.c
> > +++ b/kernel/kthread.c
> > @@ -121,6 +135,7 @@ void free_kthread_struct(struct task_struct *k)
>
> Hmm, there is the following comment:
>
>         /*
>          * Can be NULL if this kthread was created by kernel_thread()
>          * or if kmalloc() in kthread() failed.
>          */
>         kthread = to_kthread(k);
>
> And indeed, set_kthread_struct() is called only by kthread()
> and init_idle().
>
> For example, call_usermodehelper_exec_sync() calls kernel_thread()
> but given @fn does not call set_kthread_struct(). Also init_idle()
> continues even when the allocation failed.
>

Yes, it really can be NULL.

>
> >  #ifdef CONFIG_BLK_CGROUP
> >       WARN_ON_ONCE(kthread && kthread->blkcg_css);
> >  #endif
> > +     kfree(kthread->full_name);
>
> Hence, we have to make sure that it is not NULL here. I suggest
> something like:
>

Agreed.  I will do it.

> void free_kthread_struct(struct task_struct *k)
> {
>         struct kthread *kthread;
>
>         /*
>          * Can be NULL if this kthread was created by kernel_thread()
>          * or if kmalloc() in kthread() failed.
>          */
>         kthread = to_kthread(k);
>         if (!kthread)
>                 return;
>
> #ifdef CONFIG_BLK_CGROUP
>         WARN_ON_ONCE(kthread->blkcg_css);
> #endif
>         kfree(kthread->full_name);
>         kfree(kthread);
> }
>
>
> Side note: The possible NULL pointer looks dangerous to
>     me. to_kthread() is dereferenced without any check on
>     several locations.
>
>     For example, kthread_create_on_cpu() looks safe. It is a kthread
>     crated by kthread(). It will exists only when the allocation
>     succeeded.
>
>     kthread_stop() is probably safe only because it used only for
>     the classic kthreads created by kthread(). But the API
>     is not safe.
>
>     kthread_use_mm() is probably used only by classic kthreads as
>     well. But it is less clear to me.
>
>     All this unsafe APIs looks like a ticking bomb to me. But
>     it is beyond this patchset.
>

I will analyze it in depth and try to dismantle this ticking bomb.


-- 
Thanks
Yafang
