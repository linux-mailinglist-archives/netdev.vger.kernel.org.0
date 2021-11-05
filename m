Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE39445FBE
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 07:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhKEGiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 02:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbhKEGiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 02:38:14 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A966C061714;
        Thu,  4 Nov 2021 23:35:35 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id bq14so7975951qkb.1;
        Thu, 04 Nov 2021 23:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=471eGmUxaF67diQu9fpSiCy6uokW6qtVpUcaxV0sWLg=;
        b=jS5yXBDc4yq8hyj2cMX5ZzypfkbcLj9UWr5FarIDV8R/zKENQbna+Jo8HNO42CtEMt
         RiopFHwHRn4GwPkE5mt3IdSzakYbUGSj2lbLs/YAsoK0ar9yVUh09Yhl8a4WWyQOjwZ+
         ZMVvmuhWqz7vNgHbChGOHuDkC5/GG4HCHnSqsF5E+6MK0hng9T+RlaxODaBfqkN6w0KD
         OKWDtzvX8pHGd6kiigIdwo/20u19Uex8DStSUaqEFXYlC/NevQSYREnt+slq5II6jC87
         rVCtpwgcKIuv2TtDWCxHgQLpa/HJ7hMsWJ5Fd6j9a8IyeYP3DdbyGWKU3ZTxpURg3r5p
         g1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=471eGmUxaF67diQu9fpSiCy6uokW6qtVpUcaxV0sWLg=;
        b=3uKCzCu8VTWNV0wcXvreoSKjyaPUYwX+7g8ZHMmE4Gh/6bLk4yF67y7VrzFzDf4wGN
         CvuMUN6rJbCccamfauVszu6psGrsEpRrSZp4AxspfJV7HL5+ck6xGhI5IIXoWj7wV7oG
         ouDjI5GzkGQoTZ0RzA4zs3cYeDU5CH1NclNomSVGbeC5EVHzsntXvhZyUlyN51k2k/GZ
         ArraNeeCslddLWWjJhtNlBvs2VZQqc+ULoxPodOvRtE+r6ciYdl2qlfBIR858cFNVxVi
         D46ubnVZfsWUQGxzR4oj+GbsuLbBEDjII3dTjd6xSYUzXlhMa11WstLnrWwOVLMy6ZAc
         YiSA==
X-Gm-Message-State: AOAM532MCZ0nymC6+h4cFbaYCBuLzuDAt5n/2FZqqSF7GNvWkQNaLeTw
        g1uE9gdYeLGqOa6CEDc5p4uqeEanBkuFZz1xNuw=
X-Google-Smtp-Source: ABdhPJyGlAK/4T0maCDIO1vKCkl3dt4UGJclujZc/WZfgwdBVMPOmko9selD7aq7tjVzpVvwBlKU0yeFneDO8orvn9Y=
X-Received: by 2002:a05:620a:408:: with SMTP id 8mr16641290qkp.116.1636094134305;
 Thu, 04 Nov 2021 23:35:34 -0700 (PDT)
MIME-Version: 1.0
References: <20211101060419.4682-1-laoar.shao@gmail.com> <YYM5R95a7jgB2TPO@qmqm.qmqm.pl>
In-Reply-To: <YYM5R95a7jgB2TPO@qmqm.qmqm.pl>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 5 Nov 2021 14:34:58 +0800
Message-ID: <CALOAHbDtoBEr8TuuUEMAnw3aeOf=S10Lh_eBCS=5Ty+JHgdj0Q@mail.gmail.com>
Subject: Re: [PATCH v7 00/11] extend task comm from 16 to 24
To:     =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 4, 2021 at 9:37 AM Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.q=
mqm.pl> wrote:
>
> On Mon, Nov 01, 2021 at 06:04:08AM +0000, Yafang Shao wrote:
> > There're many truncated kthreads in the kernel, which may make trouble
> > for the user, for example, the user can't get detailed device
> > information from the task comm.
> >
> > This patchset tries to improve this problem fundamentally by extending
> > the task comm size from 16 to 24, which is a very simple way.
> [...]
>
> Hi,
>
> I've tried something like this a few years back. My attempt got mostly
> lost in the mailing lists, but I'm still carrying the patches in my
> tree [1]. My target was userspace thread names, and it turned out more
> involved than I had time for.
>
> [1] https://rere.qmqm.pl/git/?p=3Dlinux;a=3Dcommit;h=3D2c3814268caf2b1fee=
6d1a0b61fd1730ce135d4a
>     and its parents
>

Hi Michal,

Thanks for the information.

I have looked through your patches.  It seems to contain six patches
now and can be divided into three parts per my understanding.

1. extend task comm len
This parts contains below 4 patches:
[prctl: prepare for bigger
TASK_COMM_LEN](https://rere.qmqm.pl/git/?p=3Dlinux;a=3Dcommit;h=3Dcfd99db9c=
f911bb4d106889aeba1dfe89b6527d0)
[bluetooth: prepare for bigger
TASK_COMM_LEN](https://rere.qmqm.pl/git/?p=3Dlinux;a=3Dcommit;h=3Dba2805f51=
96865b81cc6fc938ea53af2c7c2c892)
[taskstats: prepare for bigger
TASK_COMM_LEN](https://rere.qmqm.pl/git/?p=3Dlinux;a=3Dcommit;h=3D4d29bfedc=
57b36607915a0171f4864ec504908ca)
[mm: make TASK_COMM_LEN
configurable](https://rere.qmqm.pl/git/?p=3Dlinux;a=3Dcommit;h=3D362acc3558=
2445174589184c738c4d86ec7d174b)

What kind of userspace issues makes you extend the task comm length ?
Why not just use /proc/[pid]/cmdline ?

2.  A fix
Below patch:
[procfs: signal /proc/PID/comm write
truncation](https://rere.qmqm.pl/git/?p=3Dlinux;a=3Dcommit;h=3Dd72027388d4d=
95db5438a7a574e0a03ae4b5d6d7)

It seems this patch is incomplete ?   I don't know what it means to do.

3. A feature provided for pthread_getname_np
Below patch:
[procfs: lseek(/proc/PID/comm, 0,
SEEK_END)](https://rere.qmqm.pl/git/?p=3Dlinux;a=3Dcommit;h=3D2c3814268caf2=
b1fee6d1a0b61fd1730ce135d4a)

It seems this patch is useful. With this patch the userspace can
directly get the TASK_COMM_LEN through the API.

--=20
Thanks
Yafang
