Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F102B74A2
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 04:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgKRDTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 22:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgKRDTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 22:19:34 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A06C0613D4;
        Tue, 17 Nov 2020 19:19:34 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id f11so654590oij.6;
        Tue, 17 Nov 2020 19:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mMvR71rN9SB/FAJRr1/hQhfMzQUaMTYk2lhmizB7+4M=;
        b=jyCyjTwqi2Bwoz6WweTPIpVofTcrWT8uNlhsBVSaxbPwkV2BoaNaMnClB64uNk09BT
         Rov6XC+ESfP3tB/5ltI18/UvX90VEKehfCE9el1W3l8vx2iQZDJVlaLQK2rBnhYlYEfW
         SlkRvCJ5gkVICIptrdf8yI8s8lI3diHJ981/uXvl10lpaUvHj75+nh2mCoIV8SaLQnS/
         9afiohinM2pg4k4db1Ka7+0L3zoGW/I7vYeJaCrMqE5EHPK6i6fafOtr2GcsKhonSoyf
         aNDirW8dlUKKrU70YFVVHMQ85u+1GzMEUtJHJIVBgcNkaha6dLqNQqhOIgp+SYXIvZyZ
         Fltw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mMvR71rN9SB/FAJRr1/hQhfMzQUaMTYk2lhmizB7+4M=;
        b=IIsO2q9DSWpbI+J/rV11OtM0A0hADbguMq5NHxFbUneEGc6Pp1IaXqm06czktX6JAx
         yJYmm+9+E6VBaNj5be7CB6Lwkj2eyCwjw8A9RFEwM4BG1j3+uhngTd+/PQzZaDuXF10N
         TQOTbqVkyknR0xkb+v7ZAkU1wL91YBbrjH4DGIUezl1ECOj4BJE5CR87tutD2hVMeOQS
         XOxtuy9lH+Uvh/aTezyVmfKFgGO1C7HDDGzdkEsv6IwotoVX9VNkgNdUPtDbRrUhdS3+
         vjj5dMYaF6JJMlvW0ij5eJyHFZClvVeE5C3kahVsBgj4Ltt0Q1EXPK9PpbnvE/4N3jE0
         rLcg==
X-Gm-Message-State: AOAM5329pOvtrG6jgMv8iEzXnHviJHD8OL6f5qBGkQJNqbPxi01bZWSA
        m85LIreNFl7120PeX38Yg/GawF8vFGbptbmn6A==
X-Google-Smtp-Source: ABdhPJwZN3gwXa6FAuVxBt2aAM8idx4rsEOpFn42iKEIbfCRHJGBiyrANklzPTklhqQomRYm0EKRWki1U9P34yOZKYw=
X-Received: by 2002:a05:6808:d0:: with SMTP id t16mr1417854oic.79.1605669573431;
 Tue, 17 Nov 2020 19:19:33 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
 <20201117145644.1166255-5-danieltimlee@gmail.com> <CAEf4BzaQOfGOvGnzqGRoQmnysoWZrEo=ZBS4RreV3OfcKB3uQQ@mail.gmail.com>
In-Reply-To: <CAEf4BzaQOfGOvGnzqGRoQmnysoWZrEo=ZBS4RreV3OfcKB3uQQ@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Wed, 18 Nov 2020 12:19:17 +0900
Message-ID: <CAEKGpzj-4X+OZNmjM+2ZJ+R_k=c_bNBTwiSfsXp2BQ4zV9YE5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/9] samples: bpf: refactor task_fd_query program
 with libbpf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 11:58 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Nov 17, 2020 at 6:57 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > This commit refactors the existing kprobe program with libbpf bpf
> > loader. To attach bpf program, this uses generic bpf_program__attach()
> > approach rather than using bpf_load's load_bpf_file().
> >
> > To attach bpf to perf_event, instead of using previous ioctl method,
> > this commit uses bpf_program__attach_perf_event since it manages the
> > enable of perf_event and attach of BPF programs to it, which is much
> > more intuitive way to achieve.
> >
> > Also, explicit close(fd) has been removed since event will be closed
> > inside bpf_link__destroy() automatically.
> >
> > DEBUGFS macro from trace_helpers has been used to control uprobe events.
> > Furthermore, to prevent conflict of same named uprobe events, O_TRUNC
> > flag has been used to clear 'uprobe_events' interface.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  samples/bpf/Makefile             |   2 +-
> >  samples/bpf/task_fd_query_user.c | 101 ++++++++++++++++++++++---------
> >  2 files changed, 74 insertions(+), 29 deletions(-)
> >
>
> [...]
>
> >  static int test_debug_fs_uprobe(char *binary_path, long offset, bool is_return)
> >  {
> > +       char buf[256], event_alias[sizeof("test_1234567890")];
> >         const char *event_type = "uprobe";
> >         struct perf_event_attr attr = {};
> > -       char buf[256], event_alias[sizeof("test_1234567890")];
> >         __u64 probe_offset, probe_addr;
> >         __u32 len, prog_id, fd_type;
> > -       int err, res, kfd, efd;
> > +       int err = -1, res, kfd, efd;
> > +       struct bpf_link *link;
> >         ssize_t bytes;
> >
> > -       snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/%s_events",
> > -                event_type);
> > -       kfd = open(buf, O_WRONLY | O_APPEND, 0);
> > +       snprintf(buf, sizeof(buf), DEBUGFS "%s_events", event_type);
> > +       kfd = open(buf, O_WRONLY | O_TRUNC, 0);
>
> O_TRUNC will also remove other events, created by users. Not a great
> experience. Let's leave the old behavior?
>

The reason why I used O_TRUNC is, it gets conflict error during tests.
I'm not sure if it is a bug of ftrace uprobes_events or not, but seems adding
same name of uprobe_events with another type seems not working.
(adding uretprobes after uprobes returns an error)

    samples/bpf # echo 'p:uprobes/test_500836 ./task_fd_query:0x3d80'
>> /sys/kernel/debug/tracing/uprobe_events
    samples/bpf # cat /sys/kernel/debug/tracing/uprobe_events
     p:uprobes/test_500836 ./task_fd_query:0x0000000000003d80
    samples/bpf# echo 'r:uprobes/test_500836 ./task_fd_query:0x3d80'
>> /sys/kernel/debug/tracing/uprobe_events
     bash: echo: write error: File exists

Since this gets error, I've just truncated on every open of this interface.

> >         CHECK_PERROR_RET(kfd < 0);
> >
> >         res = snprintf(event_alias, sizeof(event_alias), "test_%d", getpid());
> > @@ -240,8 +252,8 @@ static int test_debug_fs_uprobe(char *binary_path, long offset, bool is_return)
> >         close(kfd);
> >         kfd = -1;
> >
> > -       snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/events/%ss/%s/id",
> > -                event_type, event_alias);
> > +       snprintf(buf, sizeof(buf), DEBUGFS "events/%ss/%s/id", event_type,
>
> I'd leave the string verbatim here (and above), I think it's better
> that way and easier to figure out what's written where. And then no
> need to expose DEBUGFS.
>

Sounds great. I'll keep the string path as it was.

> > +                event_alias);
> >         efd = open(buf, O_RDONLY, 0);
> >         CHECK_PERROR_RET(efd < 0);
> >
>
> [...]



-- 
Best,
Daniel T. Lee
