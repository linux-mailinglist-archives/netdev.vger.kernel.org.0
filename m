Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CACC441B89
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbhKANP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhKANPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 09:15:25 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08752C061714;
        Mon,  1 Nov 2021 06:12:52 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id p204so9815768iod.8;
        Mon, 01 Nov 2021 06:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LRGh6td70WGdmcMGRp1Cc0ENwiVhacG+3GURE37PQRY=;
        b=D1c3niaA50bwFpxIVPXswFp23Ns+FjPYl1hMI22JykdorR1b/ucEkfMwwKSD4aZg98
         dn3sayONdJC9VFmOi1EL/PVGFWgDLBFFxT+zWBe/d7JIZUKyfad70zLSk7V6Imkeaa3u
         zIIUfXU46UUcIlDJ6vj5XCl72FecPOv5raXwtIEpFGjmP5NNIkbJsqLsS618/p/qxuE+
         /x59PrEi0ypVfSfy+W/ZShyD2MIr4zqA/jaOBpltB81M8CaV8U2KgiqHuv8H/0unfN/h
         GG7/LLA8an1EIAjyfciAhAklGV3xdulIwie9XNx8+2UZqQee6lB+0fa9FU0bSrR40OQd
         toww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LRGh6td70WGdmcMGRp1Cc0ENwiVhacG+3GURE37PQRY=;
        b=mMGM+iZ2tGKPjPHMdEGz8jxIy7t9krvqzee5DSU3y9LsfNoz1tOIMUKAHhtHHFTEnL
         ybJK3bPxnsX+59vcKUdKeCUgNWUQZZ/HMJUI4S2jtmQcOAp9JRol/yHnkv7IQOIFXir2
         YzHrRSup2LErXATWAxfUmlXCAM9BVZJpUdO9SizfAna38O+taDKKsk90qDRXU8hK4tuZ
         21I1pOGNaWfvZ1LaML+qXLkdAFY+tfWss9purhUiUqY3TvLhQid0HvSvMI8ortaIK3pL
         QG9u5iKUb5PkHKP7J+TfSNIOt2LCqkxqBFNdo94FzaBTagw9LHJRxNXc86iW2VbRjQR0
         WnuQ==
X-Gm-Message-State: AOAM5307y6p4t6UlnZ8WnBGr7538axVsJQ0dgmfkZxAX2yNVrWBWT5gQ
        HSlWc5LXaubOovQs8X6vA9bxlf18zt2WNmfJR9fI+npaTzQKbCkO
X-Google-Smtp-Source: ABdhPJyIQzixlwZawM13KFKv+/9Vrhh6ZnO8DyH1IQEASFpfh82lPE9sWf9iZMZFsPo6igJmpnwc9DB1NFy4l16FgZI=
X-Received: by 2002:a05:6602:164b:: with SMTP id y11mr6027737iow.9.1635772371384;
 Mon, 01 Nov 2021 06:12:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211101060419.4682-1-laoar.shao@gmail.com> <YX/hS6nRisiiFiBD@casper.infradead.org>
In-Reply-To: <YX/hS6nRisiiFiBD@casper.infradead.org>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 1 Nov 2021 21:12:15 +0800
Message-ID: <CALOAHbB5Dhiep5DhpzQ2RsJee88MuADQ=-FMwmBCLDJ21by2dw@mail.gmail.com>
Subject: Re: [PATCH v7 00/11] extend task comm from 16 to 24
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
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

On Mon, Nov 1, 2021 at 8:46 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Nov 01, 2021 at 06:04:08AM +0000, Yafang Shao wrote:
> > There're many truncated kthreads in the kernel, which may make trouble
> > for the user, for example, the user can't get detailed device
> > information from the task comm.
> >
> > This patchset tries to improve this problem fundamentally by extending
> > the task comm size from 16 to 24, which is a very simple way.
>
> It can't be that simple if we're on v7 and at 11 patches!
>

Most of the changes are because of hard-coded 16 that can't be easily grepped.
In these 11 patches, patch #1, #2, #4, #5, #6, #7 and #9 are cleanups,
which can be a different patchset.

The core changes of these patchset are patch #3, #8 and #10.

#11 can also be a seperate patch.

> It would be helpful if you included links to earlier postings.  I can
> only find v5 and v6 in my inbox, so I fear I'm going to re-ask some
> questions which were already answered.
>

v1: https://lore.kernel.org/lkml/20210929115036.4851-1-laoar.shao@gmail.com/
v2: https://lore.kernel.org/lkml/20211007120752.5195-1-laoar.shao@gmail.com/
v3: https://lore.kernel.org/lkml/20211010102429.99577-1-laoar.shao@gmail.com/
v4: https://lore.kernel.org/lkml/20211013102346.179642-1-laoar.shao@gmail.com/
v5: https://lore.kernel.org/lkml/20211021034516.4400-1-laoar.shao@gmail.com/
v6: https://lore.kernel.org/lkml/20211025083315.4752-1-laoar.shao@gmail.com/


> Why can't we shorten the names of these kthreads?  You didn't
> give any examples, so I can't suggest any possibilities.
>

Take 'jbd2/nvme0n1p2-' for example, that's a nice name, which gives a
good description via the name.
And I don't think it is a good idea to shorten its name.

-- 
Thanks
Yafang
