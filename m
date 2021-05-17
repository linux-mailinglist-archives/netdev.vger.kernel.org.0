Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECDF383A29
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 18:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbhEQQjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 12:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245682AbhEQQjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 12:39:13 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E4EC043142
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 08:43:34 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id k10so5128513qtp.9
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 08:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fpwxqREUy7ZeE/q9KBgH9prhaRfEbTg15gcbCdch4sk=;
        b=wPcyIQdb6L6RNeArvXK/uwluH0pzcyAL8Aqij4tYmSicv0ugqA8kc0c1vkWlRSw9HD
         kQwp//GzznxbjURrATi75vC8qO9PjX6OCjthLjKsnydVNqxEqf3e+1cTKKHoRDGcGWPv
         fOzmIzfFrxp6gvyq0RAuobhupEv0R4/q6Oaai7QIFe4V1lcc1P/Q6pHE11LChac3HMdF
         yda4N2qFUv/CphPoic4G30/bY3uUYJzwAM6zmoCUj8syPdlpefxsFB/2Me74BEa9WIQO
         MMedIHxaxrpX6l076PK4OiNtA3hGmU1Cn6TXp2NRq6FY1wvU30gUANfMZjE8UKa2by1Z
         6m0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fpwxqREUy7ZeE/q9KBgH9prhaRfEbTg15gcbCdch4sk=;
        b=SSVFAA15V3oQ4/TY1wWWrUnmpKla0NpHZ3rlbJWACEUxtjqjZ+Ohk3Bfa2ZUyh7eUw
         mhgfAckNDcKOvJuC7PsEvkYuMY0yLwJkZzsi/ifORtUwJZW73hinMzuInpEWWPHtL6pl
         6DuoO+GNy0LYlJI322siHeu84td5bbwSS0jE7NqwouEmzn95xpIknt/WZO8Whs9MYcRf
         q+0piar3IKnmFvATNuuWjwpVteaiu8m2e27kOKP1Jqxpogp0q0iycFy+Mv69HnleCZsN
         DFO7GWlEUUaGHrVW8m9d/g9sZ8FunX6FNnrBKw9Az3E1wnKsPKqsJF9HA+ECurXRztaz
         kpdw==
X-Gm-Message-State: AOAM531XG49JAA0/ULNApV06MylkgsBb6/MIW0k+3ylCtyIsI8SxJ2/5
        VZNqjVtK7/z9j4mmTqw/I46g8eczTkN/5HSIdGfF2g==
X-Google-Smtp-Source: ABdhPJz4M51L12IN2jSsEKmY7vORLRZl8ZEZji/O7ODhRvj5zpW2uVnQHLDOpExGgw04gxs51m8VSuLlvKUEDrdbq4A=
X-Received: by 2002:ac8:518a:: with SMTP id c10mr162925qtn.66.1621266213535;
 Mon, 17 May 2021 08:43:33 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000b3d89a05c284718f@google.com> <YKJTNcpqVN6gNIHV@hirez.programming.kicks-ass.net>
 <CACT4Y+bucS5_6=rcEEpe+t8p_m3PQVzU5U+u+++ZSVG8E9zzmg@mail.gmail.com>
In-Reply-To: <CACT4Y+bucS5_6=rcEEpe+t8p_m3PQVzU5U+u+++ZSVG8E9zzmg@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 17 May 2021 17:43:22 +0200
Message-ID: <CACT4Y+Z8VjfOU=eR-ijhkXJJuZLM4NC+ui5ce0R=OH6WVWwB1w@mail.gmail.com>
Subject: Re: [syzbot] WARNING in __perf_install_in_context
To:     Peter Zijlstra <peterz@infradead.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-riscv <linux-riscv@lists.infradead.org>
Cc:     syzbot <syzbot+0fb24f56fa707081e4f2@syzkaller.appspotmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 2:46 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Mon, May 17, 2021 at 1:28 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Mon, May 17, 2021 at 03:56:22AM -0700, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    18a3c5f7 Merge tag 'for_linus' of git://git.kernel.org/pub..
> > > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=1662c153d00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=b8ac1fe5995f69d7
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=0fb24f56fa707081e4f2
> > > userspace arch: riscv64
> > >
> > > Unfortunately, I don't have any reproducer for this issue yet.
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+0fb24f56fa707081e4f2@syzkaller.appspotmail.com
> > >
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 1 PID: 8643 at kernel/events/core.c:2781 __perf_install_in_context+0x1c0/0x47c kernel/events/core.c:2781
> > > Modules linked in:
> > > CPU: 1 PID: 8643 Comm: syz-executor.0 Not tainted 5.12.0-rc8-syzkaller-00011-g18a3c5f7abfd #0
> > > Hardware name: riscv-virtio,qemu (DT)
> >
> > How serious should I take this thing? ARM64 and x86_64 don't show these
> > errors.
>
> +riscv mainters for this question
> Is perf on riscv considered stable?

Another perf/riscv64 warning just come in:
https://syzkaller.appspot.com/bug?extid=30189c98403be62bc05a
