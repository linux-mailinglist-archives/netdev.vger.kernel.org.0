Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D7F442522
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhKBB3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhKBB3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 21:29:47 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9287BC061714;
        Mon,  1 Nov 2021 18:27:12 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id i12so14135511ila.12;
        Mon, 01 Nov 2021 18:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1A7HDzhjdY5hn/pnJsq/whbXnb304U4AQcYBouiJz5U=;
        b=gVAfAFQLVbuCYZGlc3nitOWxinUlm2TcBUuG/WlQGM3BrLv5p4TXRDeodF26CWvRzs
         ZGoGjmKunynS9wI1VaetPAatDYGmGJHYGKakCPE7PdTAGHIowtgrLF8h/wBOMRpSmkCb
         h/nLqK0DU9zeU/OwhhKE90uSO4CvWpQm9iqyCuXODjos8g2s1kMZesERgRTUZgBZD3hA
         bQc949JPfUmv2wtymyRRvl4GWMCziqOLyoYioMRGj/UOo0gPWXWfr8aqG3uh3K8MlYYU
         7i5UGljnYemx6aIldJ5YDFDeSCl9AcggxU81rjZqNGVsyR+s5CPE+VNzSLVbI8Ux/vQ/
         zeLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1A7HDzhjdY5hn/pnJsq/whbXnb304U4AQcYBouiJz5U=;
        b=BPP4MAwJJbN55XQ2uUHVoXEAaZhhWTYrWHPiJi1OOnXeiE4EzYGMs0N3EcfgQ01Xcm
         hyzrcidDfgUy/epJBkbLIrh5RZgP9kJw7aSK3CHZKQdp0NqXzU8OjUoid5/anI1wrBCm
         G4kjiUxuzgkJvLnv4d1S+b7Pxyv5bGWzpPhB5JlGHzCXx4spYKtw1dXBd94YTx3E2WCo
         AWuvTTQfEHsMSI9ubEGQMRvxE2wAU9smoMAo6ReSXLIRRa16NSOcVEFS1xGUI1Tz38V0
         /5GfKlySCtKu47dzafnkIJykmzhoPvGj6CF4HijloCE9ImM56VJjSPF+mxGMD3su2tmU
         ap9Q==
X-Gm-Message-State: AOAM532k/lYdwXizavHtzqNSoPe4KWp5t1NMoavObu8aBnSitsNqstno
        szPgK4RrunHvRN/tV7ox0JvhFfFT6cPx18xgLqg=
X-Google-Smtp-Source: ABdhPJwJBgI9aj//vf3EJRPnVnyMFDHNeTLdubr4rkK45Z1kExg7tk3zFAbc3ycTSpUCPYjcZYjJcVnOD/l3RuhtfVg=
X-Received: by 2002:a92:c112:: with SMTP id p18mr18365849ile.52.1635816431697;
 Mon, 01 Nov 2021 18:27:11 -0700 (PDT)
MIME-Version: 1.0
References: <20211101060419.4682-1-laoar.shao@gmail.com> <YX/0h7j/nDwoBA+J@alley>
 <CALOAHbA61RyGVzG8SVcNG=0rdqnUCt4AxCKmtuxRnbS_SH=+MQ@mail.gmail.com>
 <YYAPhE9uX7OYTlpv@alley> <CALOAHbAx55AUo3bm8ZepZSZnw7A08cvKPdPyNTf=E_tPqmw5hw@mail.gmail.com>
 <20211101211845.20ff5b2e@gandalf.local.home>
In-Reply-To: <20211101211845.20ff5b2e@gandalf.local.home>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 2 Nov 2021 09:26:35 +0800
Message-ID: <CALOAHbCgaJ83qZVj6qt8tgJBd4ojuLfgSp2Ce7CgzQYshM-amQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/11] extend task comm from 16 to 24
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Petr Mladek <pmladek@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
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
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 2, 2021 at 9:18 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 2 Nov 2021 09:09:50 +0800
> Yafang Shao <laoar.shao@gmail.com> wrote:
>
> > So if no one against, I will do it in two steps,
> >
> > 1. Send the task comm cleanups in a separate patchset named "task comm cleanups"
> >     This patchset includes patch #1, #2, #4,  #5, #6, #7 and #9.
> >     Cleaning them up can make it less error prone, and it will be
> > helpful if we want to extend task comm in the future :)
>
> Agreed.
>
> >
> > 2.  Keep the current comm[16] as-is and introduce a separate pointer
> > to store kthread's long name
>
> I'm OK with this. Hopefully more would chime in too.
>
> >      Now we only care about kthread, so we can put the pointer into a
> > kthread specific struct.
> >      For example in the struct kthread, or in kthread->data (which may
> > conflict with workqueue).
>
> No, add a new field to the structure. "full_name" or something like that.
> I'm guessing it should be NULL if the name fits in TASK_COMM_LEN and
> allocated if the name had to be truncated.
>
> Do not overload data with this. That will just make things confusing.
> There's not that many kthreads, where an addition of an 8 byte pointer is
> going to cause issues.
>

Sure, I will add a new field named "full_name", which only be
allocated if the kthread's comm is truncated.

> >
> >      And then dynamically allocate a longer name if it is truncated,
> > for example,
> >      __kthread_create_on_node
> >          len = vsnprintf(name, sizeof(name), namefmt, args);
> >          if (len >= TASK_COMM_LEN) {
> >              /* create a longer name */
>
> And make sure you have it fail the kthread allocation if it fails to
> allocate.
>
> >          }
> >
> >      And then we modify proc_task_name(), so the user can get
> > kthread's longer name via /proc/[pid]/comm.
>
> Agreed.
>
> >
> >      And then free the allocated memory when the kthread is destroyed.
>
> Correct.
>
> Thanks,
>
> -- Steve



-- 
Thanks
Yafang
