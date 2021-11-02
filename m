Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA2F442F57
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 14:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhKBNvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 09:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhKBNvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 09:51:21 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D1DC061714;
        Tue,  2 Nov 2021 06:48:46 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id bj20so8380332qkb.11;
        Tue, 02 Nov 2021 06:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wu+GXwP0q8/l280sPfS5y2dnw2tDTjbgcZxPcts0nWA=;
        b=YcR3IuaAtTNd5UTAQgUBmbub0s9rZKVwSQhTU6bWJJuuGdsbgVWzNuC9hWKqyxfIx3
         99mns3eEXlEacdvGFsKoPPJhXuggFk/5dE5jXNf97+xm8eN7len5sSHHLvp3lWncIqzh
         nqpTbP+Mq8ng1LNy3wXdOjEpj+jjzNB2OP/wuFZPk0/GaFXjhxctxfJRVTWOEq2Zc+SW
         DNyX54rGB6MewKL70f5/ukEdoSGntFVl195Te6GLkxv8TwgbyAW3u4004JSdT9R69nCM
         R+qKublTKycWSta+kv7uhK7PGTiFSv2r4mma2kG4TFzwKpMJAYoo/7RA//x4Akoe3VkM
         BmPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wu+GXwP0q8/l280sPfS5y2dnw2tDTjbgcZxPcts0nWA=;
        b=DQfoPoBAdpWQMso9xSRciPzgV4/MGb3Q5u+TnYEsDVADmO5xkmlNKOELVnXPNfb4wx
         XA50A8sjv5V8arZ2RVkdQX3ZU+jGcMyF9XnKjWaK6lNl7kvruTKphf55bi3SqcB+InF+
         gPADjVLdfSfChfMDAe/rHor3evr9+cuSKV6pwwKaIICP6oiDcZIkH7xR5qg/xKQEJrqc
         UaCQfq7yoydGj11Ihf1sUbCDgZD8J8wX7Nv9/Ntzm2O7GTage5F5yhz8qXMaoqvfCnYl
         SLmtcb+oQStw/tGJTOjbv2w/Ov5InGrgZCsPLoOMu6tGKOnzrjQAloCZ1lwNfAVV82Mg
         eniQ==
X-Gm-Message-State: AOAM530KDw9E+aJKX8vnOWR0jOxVEie91h1xnFX7JKVYmGUkLkNS06Tq
        TkFnco6aLwNhVa5Qn/MQ1HWkIBVCwdjG6cbsbOI=
X-Google-Smtp-Source: ABdhPJzdAcu/rqsJAHYEDYHQWB2i5R24SjAWs9ovT6Ku6QrCQM5eY4Gm09bilSgO5SNhaLL7ebVPVXMe4LoGH0IsBkk=
X-Received: by 2002:a05:620a:40d6:: with SMTP id g22mr29784297qko.104.1635860925969;
 Tue, 02 Nov 2021 06:48:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211101060419.4682-1-laoar.shao@gmail.com> <YX/0h7j/nDwoBA+J@alley>
 <CALOAHbA61RyGVzG8SVcNG=0rdqnUCt4AxCKmtuxRnbS_SH=+MQ@mail.gmail.com>
 <YYAPhE9uX7OYTlpv@alley> <CALOAHbAx55AUo3bm8ZepZSZnw7A08cvKPdPyNTf=E_tPqmw5hw@mail.gmail.com>
 <20211101211845.20ff5b2e@gandalf.local.home> <CALOAHbCgaJ83qZVj6qt8tgJBd4ojuLfgSp2Ce7CgzQYshM-amQ@mail.gmail.com>
 <YYDvHv76tJtJht8b@alley>
In-Reply-To: <YYDvHv76tJtJht8b@alley>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 2 Nov 2021 21:48:10 +0800
Message-ID: <CALOAHbBA4xjoebNcO2422wa34bgui_=PriPNfJdx2_CstoKQqg@mail.gmail.com>
Subject: Re: [PATCH v7 00/11] extend task comm from 16 to 24
To:     Petr Mladek <pmladek@suse.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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

On Tue, Nov 2, 2021 at 3:56 PM Petr Mladek <pmladek@suse.com> wrote:
>
> On Tue 2021-11-02 09:26:35, Yafang Shao wrote:
> > On Tue, Nov 2, 2021 at 9:18 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> > > On Tue, 2 Nov 2021 09:09:50 +0800
> > > Yafang Shao <laoar.shao@gmail.com> wrote:
> > > >      Now we only care about kthread, so we can put the pointer into a
> > > > kthread specific struct.
> > > >      For example in the struct kthread, or in kthread->data (which may
> > > > conflict with workqueue).
> > >
> > > No, add a new field to the structure. "full_name" or something like that.
> > > I'm guessing it should be NULL if the name fits in TASK_COMM_LEN and
> > > allocated if the name had to be truncated.
> > >
> > > Do not overload data with this. That will just make things confusing.
> > > There's not that many kthreads, where an addition of an 8 byte pointer is
> > > going to cause issues.
> >
> > Sure, I will add a new field named "full_name", which only be
> > allocated if the kthread's comm is truncated.
>
> The plan looks good to me.
>
> One more thing. It should obsolete the workqueue-specific solution.
> It would be great to clean up the workqueue code as the next step.
>

Agreed. The worker comm can be replaced by the new kthread full_name.
I will do it in the next step.

-- 
Thanks
Yafang
