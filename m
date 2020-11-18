Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCEA2B7475
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 03:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbgKRC6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 21:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgKRC6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 21:58:50 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF135C0613D4;
        Tue, 17 Nov 2020 18:58:49 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id v92so290845ybi.4;
        Tue, 17 Nov 2020 18:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uPfT5v6jdvUJRHiJLBvMYc9coVP1GGihVQJ7E5yJpnk=;
        b=oiR8RgHa/P2CCWQUtH89FL/NSCdEUjAJfw893+4kG0yO5KaEsvBf/++vmgMuCqJirm
         dTrrUQar7Q4WbzB1MyGdEFoVAgGizT4rjK7UTVf4uoZsFWoF2KzBJpWVVv1fIpwaAY8S
         rGi7uurhOxD/4Ils7XyPXLgyz1HUY7sHSvDNanI+nW549tMpSTT1ac9pbijmPc43LE+Y
         Qg26npB1u5RWErkUbnBgNU6aIAN5xx7/qeCHn6cTLsLr9t118Kvcc1WQyTBAaS+qKYRx
         XULW8EnV+hwF3E0pEBEsWw2pJKNuNTBvOZjkF9uQNF5gzOKA/U7Uxos7yBKVWfnCYQPi
         lO+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uPfT5v6jdvUJRHiJLBvMYc9coVP1GGihVQJ7E5yJpnk=;
        b=VfxBJr3oOGvRsq+juVFcfrAqWFCLEqlyi/nSVgCUFFGeBJ3QUUuSpsXeeN8VMOoPu4
         7mM0vOH0ZQCbLM8pZ035zNQj5e9SymlBlXBHP4eGeCpgvMOoPdwJP4ieYKW7A12eoE2s
         v+REwC8mjhruNnlql0V2g+/ovQirb2amNQcQpr9s/MStyxgJZwhrYQUXg9a9Bf+5/OQE
         G59BREs04KR2scwJSfPdqeTceOC5Pf3dW3Vq15YNYlSbW46r89wrtj62H1AU2aC5Gv7z
         iSEehiaoYFg1GpM+9LiZo8kIL4OBob8kBzmd4FvIsa3d8FNYHJmcm9zLxVeR2ogdPcSo
         Zlyg==
X-Gm-Message-State: AOAM532bpdFgAEULq3PiqVHJ1QR3eZkkVSmUg8JPcAZc8MbOjmxkptbz
        bHbl57NvhtCox+yScY0nyciGVkKL2KAPcJWdC78=
X-Google-Smtp-Source: ABdhPJySTB4nYcQ9v88mfrPYSdoKvixD3SFAOHlDvBhUbt3dCAxwLpuXV1EHDC+md+np/dnGHzmwOJYzaBeHNKgSPFY=
X-Received: by 2002:a25:7717:: with SMTP id s23mr4643237ybc.459.1605668329081;
 Tue, 17 Nov 2020 18:58:49 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com> <20201117145644.1166255-5-danieltimlee@gmail.com>
In-Reply-To: <20201117145644.1166255-5-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Nov 2020 18:58:38 -0800
Message-ID: <CAEf4BzaQOfGOvGnzqGRoQmnysoWZrEo=ZBS4RreV3OfcKB3uQQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/9] samples: bpf: refactor task_fd_query program
 with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
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

On Tue, Nov 17, 2020 at 6:57 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> This commit refactors the existing kprobe program with libbpf bpf
> loader. To attach bpf program, this uses generic bpf_program__attach()
> approach rather than using bpf_load's load_bpf_file().
>
> To attach bpf to perf_event, instead of using previous ioctl method,
> this commit uses bpf_program__attach_perf_event since it manages the
> enable of perf_event and attach of BPF programs to it, which is much
> more intuitive way to achieve.
>
> Also, explicit close(fd) has been removed since event will be closed
> inside bpf_link__destroy() automatically.
>
> DEBUGFS macro from trace_helpers has been used to control uprobe events.
> Furthermore, to prevent conflict of same named uprobe events, O_TRUNC
> flag has been used to clear 'uprobe_events' interface.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/Makefile             |   2 +-
>  samples/bpf/task_fd_query_user.c | 101 ++++++++++++++++++++++---------
>  2 files changed, 74 insertions(+), 29 deletions(-)
>

[...]

>  static int test_debug_fs_uprobe(char *binary_path, long offset, bool is_return)
>  {
> +       char buf[256], event_alias[sizeof("test_1234567890")];
>         const char *event_type = "uprobe";
>         struct perf_event_attr attr = {};
> -       char buf[256], event_alias[sizeof("test_1234567890")];
>         __u64 probe_offset, probe_addr;
>         __u32 len, prog_id, fd_type;
> -       int err, res, kfd, efd;
> +       int err = -1, res, kfd, efd;
> +       struct bpf_link *link;
>         ssize_t bytes;
>
> -       snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/%s_events",
> -                event_type);
> -       kfd = open(buf, O_WRONLY | O_APPEND, 0);
> +       snprintf(buf, sizeof(buf), DEBUGFS "%s_events", event_type);
> +       kfd = open(buf, O_WRONLY | O_TRUNC, 0);

O_TRUNC will also remove other events, created by users. Not a great
experience. Let's leave the old behavior?

>         CHECK_PERROR_RET(kfd < 0);
>
>         res = snprintf(event_alias, sizeof(event_alias), "test_%d", getpid());
> @@ -240,8 +252,8 @@ static int test_debug_fs_uprobe(char *binary_path, long offset, bool is_return)
>         close(kfd);
>         kfd = -1;
>
> -       snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/events/%ss/%s/id",
> -                event_type, event_alias);
> +       snprintf(buf, sizeof(buf), DEBUGFS "events/%ss/%s/id", event_type,

I'd leave the string verbatim here (and above), I think it's better
that way and easier to figure out what's written where. And then no
need to expose DEBUGFS.

> +                event_alias);
>         efd = open(buf, O_RDONLY, 0);
>         CHECK_PERROR_RET(efd < 0);
>

[...]
