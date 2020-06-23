Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF182048F8
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 07:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgFWFJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 01:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgFWFJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 01:09:31 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E75EC061573;
        Mon, 22 Jun 2020 22:09:31 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id u8so2044980qvj.12;
        Mon, 22 Jun 2020 22:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s9f/p29ohWj4FvY/+powBlWlSrIwViVzf8xNOW0hWec=;
        b=gYWsA0J1xXgDR/zQw/9AhF9NrKhV95kNKYYO3mcT/4zgiatQqNM1LKjXAFMjAxH+hD
         +WaTQqon4nnFxc3C28YMYNX6SnTTIOrRkv+kB5aNf4iWMOGkwIWdAJx9RtHLPebh+voQ
         l8czbT9yc+8/666kDzjVdJHYSKX2LVxVO0uIkb5IixUg3UlJbR1ipswfUXUA0gU8o+kA
         D4cbRvhtKBANJ68EcqXnar+qhF7qm8/eqrt4BjX+JyKWGcrwrB3TuymerphUvddPmYot
         AI4rJKY3X/DZmK4n8LiP2POugMBGXhbirZLdxxGG4xgzhJBC5YIMtozuAKDa0iq6ojKF
         N4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s9f/p29ohWj4FvY/+powBlWlSrIwViVzf8xNOW0hWec=;
        b=WPS8FGsv2qBIPDansl6MZGu3E+iGvsnkqFQ8NHJQWM0Q8kdpsYe+TAWssOZ0xOu4Ox
         tlmA5Wv87mK1JfodMxXBx+vSyMWfz0x9YBpOa6R+FO1hlCfshc0hZOT7NbxzhBfm0qaW
         867h9nKbY6RhawJ/b29aFGijeygmFxme79+sOhDV5v4GqJhTTnGYAxbSPDjoDnSxUxaj
         LmXAzBho/wCWZnseDlTI5DX2bQmME5cLY2J9FO8n91sVxQJgxeBk3740rEx4Vghvoq6S
         se1Va/vmsFh2PVtPvu6pGLil1p8fOGaQtoJ78gGiVvsKgdQSj6qC2+kTJPG5WnCKCqgP
         kcUQ==
X-Gm-Message-State: AOAM5338MrEpY1Ezsl4k9nmKNfI6fX3/DmYIj96GLj8K3Sueukz1d4A1
        EPizYW3em6z6O1rFWM3Zu5tzCNEI09l37jd3Xac=
X-Google-Smtp-Source: ABdhPJys2bF+XkgobWL69PfleUqVyBRM4h6D5j7P7P7BnW+IhYZ11nqvximWJlsU5rC86p7Kc20cG5mATo/x58+Nvqs=
X-Received: by 2002:ad4:598f:: with SMTP id ek15mr24864170qvb.196.1592888970665;
 Mon, 22 Jun 2020 22:09:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200619231703.738941-1-andriin@fb.com> <20200619231703.738941-9-andriin@fb.com>
 <20200623002451.egxxppsm35q2dg5l@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200623002451.egxxppsm35q2dg5l@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Jun 2020 22:09:19 -0700
Message-ID: <CAEf4BzYYas7Lz3cxUhUigo=f-PKCfa-ZOwsD_cfmVkbSVy3qCQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 8/9] tools/bpftool: show info for processes
 holding BPF map/prog/link/btf FDs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 5:24 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jun 19, 2020 at 04:17:02PM -0700, Andrii Nakryiko wrote:
> > Add bpf_iter-based way to find all the processes that hold open FDs against
> > BPF object (map, prog, link, btf). bpftool always attempts to discover this,
> > but will silently give up if kernel doesn't yet support bpf_iter BPF programs.
> > Process name and PID are emitted for each process (task group).
> >
> > Sample output for each of 4 BPF objects:
> >
> > $ sudo ./bpftool prog show
> > 2694: cgroup_device  tag 8c42dee26e8cd4c2  gpl
> >         loaded_at 2020-06-16T15:34:32-0700  uid 0
> >         xlated 648B  jited 409B  memlock 4096B
> >         pids systemd(1)
> > 2907: cgroup_skb  name egress  tag 9ad187367cf2b9e8  gpl
> >         loaded_at 2020-06-16T18:06:54-0700  uid 0
> >         xlated 48B  jited 59B  memlock 4096B  map_ids 2436
> >         btf_id 1202
> >         pids test_progs(2238417), test_progs(2238445)
> >
> > $ sudo ./bpftool map show
> > 2436: array  name test_cgr.bss  flags 0x400
> >         key 4B  value 8B  max_entries 1  memlock 8192B
> >         btf_id 1202
> >         pids test_progs(2238417), test_progs(2238445)
> > 2445: array  name pid_iter.rodata  flags 0x480
> >         key 4B  value 4B  max_entries 1  memlock 8192B
> >         btf_id 1214  frozen
> >         pids bpftool(2239612)
>
> Overall it's a massive improvement, so I've applied the set.
>
> But above 'map show' probably needs a comment in the output.
> bpftool is showing a map that was loaded temporarily.
> It doesn't do so for programs though.

Yeah, and that confused me enough to just spend a bunch of time trying
to understand why. It seems like all the files are closed properly and
it just so happens that program and link is cleaned up in kernel soon
enough for bpftool to never get it with BPF_PROG_GET_NEXT_ID, while
map and btf destruction is delayed and they do get returned.

> I think somehow highlighting that above map is bpftool's own map
> that was used to generate this output would be good.
> Filtering it completely out is probably not correct.

If you have an example of a message you'd like to see, let me know.
But given detecting that this is a "special bpftool's" map/btf is the
same as filtering out in terms of reliability (e.g., by PID or by
map/btf id), I actually think that filtering it out would be less
confusing (and simpler for bpftool output code).

>
> > $ sudo ./bpftool btf show
> > 1202: size 1527B  prog_ids 2908,2907  map_ids 2436
> >         pids test_progs(2238417), test_progs(2238445)
> > 1242: size 34684B
> >         pids bpftool(2258892)
>
> similar.
>
> I've also noticed that 'test_progs -t btf_map_in_map' leaks 'inner_map2'.
> Doesn't look like the test is pinning it, so I'm guessing
> a recent kernel regression? I haven't debugged it.

Yep, neither it's pinned, nor any process has an FD open against it,
so must be kernel reference leak...
