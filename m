Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D185C4569E2
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 07:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbhKSGEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 01:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhKSGEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 01:04:31 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD84C061574;
        Thu, 18 Nov 2021 22:01:29 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id m27so38023535lfj.12;
        Thu, 18 Nov 2021 22:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cpacwUyzE+yZQi2HRsigmJjkmcIiIOSGZw3OzHsfooo=;
        b=RldlS2C/ckDa2ilqyd5cvlc3AjbT6JqCEXn82gXQCs6cELL7iYMIp14cSXKt0Pkve1
         jTesFFg+9gJSMX1G5oBdXRmcbNMdvb2tp21b0Cny/h3y4O81NUztrQExa82xCOsaoSYp
         ZUTJhomesLSaZWLLRMRpB+jgTQkwqv7IEDCbLcEBADbtKyUw6915Z5srh7D55OKNossi
         h0dcACKcphWlDBXg6grG4gE7CPxc7kyPmJwHgO8qCxXOWCpyvmhf3cQRglqv5k807Hd9
         x9bareYiM2HG5ucRSP21DZl0qs3ZYj8HICCV5GfknAxsyJYEJmZNSkr1YDswhBvmK47K
         GNKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cpacwUyzE+yZQi2HRsigmJjkmcIiIOSGZw3OzHsfooo=;
        b=S/v/ZwkLwAnq5eOdCAVsxxFMAO6Jz+izzQO3aTsvT/Vq3qfkhgyR/aPxWWXmkvf6fe
         WYfEO1zGmniQJ1odysjUt34HNABP5RI3yEElfoBDP7QdbNYefsN/UQJ0evdIUR5xfMmm
         J88BGcgDiVPIImwIzKosFw7imylZaXTgiWZckkIJvV8bw1wZfEvws5Q8WmuskXJwOsV6
         vD1M5JxJc3YAkDMANbrsPPpWyaTl0pmu+KT6dhwjKx+4Mx8gn2FZIum4Tk2yudjYoO5Z
         19TG1CXWxfxiSUaeNMW0HFb55dHwrTaxKz+GrmFbJIE11gKxUaW095WigOSMvdA1edbI
         KKaw==
X-Gm-Message-State: AOAM533Nywbhy8TECdAa3YqrkvNKYOE3SVP7R+KMaLxuSPiiK6KI7weN
        shwMqHueOxbzZ5LHJDZqRk+j70ign6PxGVhchskLlqA3DB0XWKyi
X-Google-Smtp-Source: ABdhPJwlfHbZdUmS+LrGu/838FzHKha8BHY1wMTXd2lj5AAMagnhC97ToIXsmSKtjIb5cKExksbkS2+JiTQteRHu6FM=
X-Received: by 2002:a2e:b6d4:: with SMTP id m20mr23968361ljo.471.1637301687274;
 Thu, 18 Nov 2021 22:01:27 -0800 (PST)
MIME-Version: 1.0
References: <20211118202840.1001787-1-Kenny.Ho@amd.com> <20211118202840.1001787-5-Kenny.Ho@amd.com>
 <20211119043326.a4pmgitlkljpamgh@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20211119043326.a4pmgitlkljpamgh@ast-mbp.dhcp.thefacebook.com>
From:   Kenny Ho <y2kenny@gmail.com>
Date:   Fri, 19 Nov 2021 01:01:15 -0500
Message-ID: <CAOWid-dFFjrBx1YxRxssP=uAWAjQ75iU2jj_uRkBnx4Vt5YrpA@mail.gmail.com>
Subject: Re: [PATCH RFC 4/4] bpf,cgroup,perf: extend bpf-cgroup to support
 tracepoint attachment
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kenny Ho <Kenny.Ho@amd.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        amd-gfx list <amd-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 11:33 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Nov 18, 2021 at 03:28:40PM -0500, Kenny Ho wrote:
> > +     for_each_possible_cpu(cpu) {
> > +             /* allocate first, connect the cgroup later */
> > +             events[i] = perf_event_create_kernel_counter(attr, cpu, NULL, NULL, NULL);
>
> This is a very heavy hammer for this task.
> There is really no need for perf_event to be created.
> Did you consider using raw_tp approach instead?

I came across raw_tp but I don't have a good understanding of it yet.
Initially I was hoping perf event/tracepoint is a stepping stone to
raw tp but that doesn't seem to be the case (and unfortunately I
picked the perf event/tracepoint route to dive in first because I saw
cgroup usage.)  Can you confirm if the following statements are true?

- is raw_tp related to writable tracepoint
- are perf_event/tracepoint/kprobe/uprobe and fentry/fexit/raw_tp
considered two separate 'things' (even though both of their purpose is
tracing)?

> It doesn't need this heavy stuff.
> Also I suspect in follow up you'd be adding tracepoints to GPU code?
> Did you consider just leaving few __weak global functions in GPU code
> and let bpf progs attach to them as fentry?
There are already tracepoints in the GPU code.  And I do like fentry
way of doing things more but my head was very much focused on cgroup,
and tracepoint/kprobe path seems to have something for it.  I
suspected this would be a bit too heavy after seeing the scalability
discussion but I wasn't sure so I whip this up quickly to get some
feedback (while learning more about perf/bpf/cgroup.)

> I suspect the true hierarchical nature of bpf-cgroup framework isn't necessary.
> The bpf program itself can filter for given cgroup.
> We have bpf_current_task_under_cgroup() and friends.
Is there a way to access cgroup local storage from a prog that is not
attached to a bpf-cgroup?  Although, I guess I can just store/read
things using a map with the cg id as key.  And with the
bpf_get_current_ancestor_cgroup_id below I can just simulate the
values being propagated if the hierarchy ends up being relevant.  Then
again, is there a way to atomically update multiple elements of a map?
 I am trying to figure out how to support a multi-user multi-app
sharing use case (like user A given quota X and user B given quota Y
with app 1 and 2 each having a quota assigned by A and app 8 and 9
each having quota assigned by B.)  Is there some kind of 'lock'
mechanism for me to keep quota 1,2,X in sync? (Same for 8,9,Y.)

> I suggest to sprinkle __weak empty funcs in GPU and see what
> you can do with it with fentry and bpf_current_task_under_cgroup.
> There is also bpf_get_current_ancestor_cgroup_id().
