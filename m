Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860A84371AD
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 08:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhJVGXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 02:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhJVGXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 02:23:52 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23843C061764;
        Thu, 21 Oct 2021 23:21:35 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id l7so3135329iln.8;
        Thu, 21 Oct 2021 23:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DNNio99druR0elADAAcPOSZ030zU5qLnFvTu9F38IWc=;
        b=YzmqNqCP9Cp5LVSD0RlIftB4FfWguOoayuSEE5WuopGyE58PlQpJqfCzxd6o6dGSWx
         2c48phwisYcERIRabzsPLq9sTCB4ulAUQp1rKYWnpgLSyvg2wq+RzWXS+LLoonIII9yt
         ZV6f+LXzWQBw9UfHVolmTh4brVy5PEGmLRvv83RTYDIytO7RkWncXdTB57cnHPC3vL0Y
         Qlsg1s5Ot77sKsM0FR0anmn1Sshqc5xk/kKJ8CUq4xDW4SWhd2z5omqORdVZDUhOnRFK
         E2hcEottlm4v5U+6EArh5ixT42zcGFtdfb0yNOF3HFvUjJsHf/y6rr0mUA2sHqyfDJRv
         /Ufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DNNio99druR0elADAAcPOSZ030zU5qLnFvTu9F38IWc=;
        b=cdgQ46VuFyJugBz2x2q//cS1Zt8BtS6hdkeqtgi2poEH/G9HIm26ym9MVuQaRnN4Ng
         oK1BpKRvfT3GkV/S+E4fqYfSLly5qcs6/ZiNw9ZA9/8vLiq84qlpiDvf/OxFkawG0X8x
         g0HOAtkfKjBG0Z/vPcu7C4+s5n/RsSqQUXJj39OWJ55HGBe7zv6BgrcZD8Lp1H2wvThe
         MB5QR6WUv+IuKwRAI+QwMEtyC9AO9iLM64OrvUyd3WCnKisl2ovXPnJ0b7LExzKAiaVl
         J3u2JtPXQCiUgl6wSWNdTZ7Fcmm0M9AjUzSgpyjioL1TE/+lPOGRnl3jsOhWExuILUnp
         Zz2A==
X-Gm-Message-State: AOAM533/XGhWUU1IjiYh06UJFjsqgT0KoylRTP46wiOe7T0pUemAZ1mL
        EaV119jpACNp+s3hyBcIE1MXBCc/E5/jHqs3s/A=
X-Google-Smtp-Source: ABdhPJxYd6/mVrd3hF58WmjOp1+WhbUVZs/+El8/eNM8DYtcP0VoJnRsr0TQYC2boeYvacEmMDLu2ZlA3P6c6lH6FTM=
X-Received: by 2002:a92:c24c:: with SMTP id k12mr6666555ilo.52.1634883694484;
 Thu, 21 Oct 2021 23:21:34 -0700 (PDT)
MIME-Version: 1.0
References: <20211021034516.4400-1-laoar.shao@gmail.com> <20211021205222.714a76c854cc0e7a7d6db890@linux-foundation.org>
 <202110212053.6F3BB603@keescook>
In-Reply-To: <202110212053.6F3BB603@keescook>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 22 Oct 2021 14:20:55 +0800
Message-ID: <CALOAHbDFy5sbAaWt=QoVKnq5jborrxEX1Gyzf5+kcomaXtX3rw@mail.gmail.com>
Subject: Re: [PATCH v5 00/15] extend task comm from 16 to 24 for CONFIG_BASE_FULL
To:     Kees Cook <keescook@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Qiang Zhang <qiang.zhang@windriver.com>,
        robdclark <robdclark@chromium.org>,
        christian <christian@brauner.io>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org,
        kafai@fb.com, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 12:00 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Oct 21, 2021 at 08:52:22PM -0700, Andrew Morton wrote:
> > On Thu, 21 Oct 2021 03:45:07 +0000 Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > > This patchset changes files among many subsystems. I don't know which
> > > tree it should be applied to, so I just base it on Linus's tree.
> >
> > I can do that ;)
> >
> > > There're many truncated kthreads in the kernel, which may make trouble
> > > for the user, for example, the user can't get detailed device
> > > information from the task comm.
> >
> > That sucked of us.
> >
> > > This patchset tries to improve this problem fundamentally by extending
> > > the task comm size from 16 to 24. In order to do that, we have to do
> > > some cleanups first.
> >
> > It's at v5 and there's no evidence of review activity?  C'mon, folks!
>
> It's on my list! :) It's a pretty subtle area that rarely changes, so I
> want to make sure I'm a full coffee to do the review. :)
>
> > > 1. Make the copy of task comm always safe no matter what the task
> > > comm size is. For example,
> > >
> > >   Unsafe                 Safe
> > >   strlcpy                strscpy_pad
> > >   strncpy                strscpy_pad
> > >   bpf_probe_read_kernel  bpf_probe_read_kernel_str
> > >                          bpf_core_read_str
> > >                          bpf_get_current_comm
> > >                          perf_event__prepare_comm
> > >                          prctl(2)
> > >
> > > 2. Replace the old hard-coded 16 with a new macro TASK_COMM_LEN_16 to
> > > make it more grepable.
> > >
> > > 3. Extend the task comm size to 24 for CONFIG_BASE_FULL case and keep it
> > > as 16 for CONFIG_BASE_SMALL.
> >
> > Is this justified?  How much simpler/more reliable/more maintainable/
> > would the code be if we were to make CONFIG_BASE_SMALL suffer with the
> > extra 8 bytes?
>
> Does anyone "own" CONFIG_BASE_SMALL? Gonna go with "no":
>
> $ git ann init/Kconfig| grep 'config BASE_SMALL'
> 1da177e4c3f41   (Linus Torvalds 2005-04-16 15:20:36 -0700 2054)config BASE_SMALL
>
> And it looks mostly unused:
>
> $ git grep CONFIG_BASE_SMALL | cut -d: -f1 | sort -u | xargs -n1 git ann -f | grep 'CONFIG_BASE_SMALL'
> b2af018ff26f1   (Ingo Molnar    2009-01-28 17:36:56 +0100       18)#if CONFIG_BASE_SMALL == 0
> fcdba07ee390d   ( Jiri Olsa     2011-02-07 19:31:25 +0100       54)#define CON_BUF_SIZE (CONFIG_BASE_SMALL ? 256 : PAGE_SIZE)
> Blaming lines: 100% (46/46), done.
> 1da177e4c3f41   (Linus Torvalds 2005-04-16 15:20:36 -0700       28)#define PID_MAX_DEFAULT (CONFIG_BASE_SMALL ? 0x1000 : 0x8000)
> 1da177e4c3f41   (Linus Torvalds 2005-04-16 15:20:36 -0700       34)#define PID_MAX_LIMIT (CONFIG_BASE_SMALL ? PAGE_SIZE * 8 : \
> Blaming lines: 100% (162/162), done.
> f86dcc5aa8c79   (Eric Dumazet   2009-10-07 00:37:59 +0000       31)#define UDP_HTABLE_SIZE_MIN     (CONFIG_BASE_SMALL ? 128 : 256)
> 02c02bf12c5d8   (Matthew Wilcox 2017-11-03 23:09:45 -0400       1110)#define XA_CHUNK_SHIFT        (CONFIG_BASE_SMALL ? 4 : 6)
> a52b89ebb6d44   (Davidlohr Bueso        2014-01-12 15:31:23 -0800       4249)#if CONFIG_BASE_SMALL
> 7b44ab978b77a   (Eric W. Biederman      2011-11-16 23:20:58 -0800       78)#define UIDHASH_BITS (CONFIG_BASE_SMALL ? 3 : 7)
>
>
> --

Right. CONFIG_BASE_SMALL is seldomly used in the kernel.
As you have already removed 64 bytes from task_struct, I think we can
extend the 8 bytes for CONFIG_BASE_SMALL as well.

-- 
Thanks
Yafang
