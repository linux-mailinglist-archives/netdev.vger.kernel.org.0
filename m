Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC8B439E2F
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 20:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhJYSMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 14:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhJYSMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 14:12:43 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACA6C061745;
        Mon, 25 Oct 2021 11:10:20 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id f5so11710232pgc.12;
        Mon, 25 Oct 2021 11:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+d0Qbu1iomeuu1b0XB1a5sl30MKuGON4H+QXA4yUgY8=;
        b=WCK5zsT3weZzmYfIBAoy+kmVYDC0BYJ6lommblY/oHQV/xnwun3Uuo6iPEc6fribAy
         uKfJmIaAC8d2IH9Fa1mmRfoYRrwRwP1b1mR941fuqAckUxtMloqQ/4udOb2NtHd52T4x
         btUqWEi40v7aAJ/kn0eITbpogV53PIPoZkWn5/fHVTFIfHYplnOkqXwvA6l4R+9yB/kA
         ZCzwpDyVG2JvfWhgzh+GsPs4pXSG5nwwiXWwa5IeI0FTbNTdvvfoNGPkZusYqQAVJ3VF
         seJzxEu8gZIw4wV8yg4cJdTvrUfUi0Edyo4hqlpILDOBWjDUk12ctSH48FWpUaDBvut0
         TZHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+d0Qbu1iomeuu1b0XB1a5sl30MKuGON4H+QXA4yUgY8=;
        b=A/wDxE88GQsjbHmTLlAzLMgegmBqezWNRhYgfJtwOh+wRVBYwln9twexl3w/ibVfUj
         2FvccSjGPdKu1uaO0Px/hvobzKFMF/xcW+0ULsfrhKJaXXz63Nu8+lTyAeXBpYcyEWZ8
         biJ8lfENGrY5xRYB047sWsGnUfVsoUHZChlUxBlu95G80LX3GJJdqu1S9H8sga5EoTe+
         q61UQWcsLXs1lDenuvagcURYmJzT8cbkh2bwgHgxiPmFcGSry47b3iew8WlvkF9refUl
         t6s50krWJlwJX0apv7/aZW7aZNg4O721Ts/fNlxhkGoNzuvIvVSc0GlpgnY7aH7x6Ccj
         XO/Q==
X-Gm-Message-State: AOAM531t8kIhvEfjp5fmcWVRxg/kDqzGb8rr5OtGrwuFRPtbz7o3zH+c
        opr/nDFk7Suu0qB2zOlfPLDt7A6+bPgxkdZdfKo=
X-Google-Smtp-Source: ABdhPJzwioKhEvGpI9odjpTyYQzGvhTJexObl6tmfLM4u6lVqCdB58boI2emDBXKBO3+eM8Bu2Wsfnb0z1J4L4F8xhg=
X-Received: by 2002:a65:4008:: with SMTP id f8mr14907559pgp.310.1635185420342;
 Mon, 25 Oct 2021 11:10:20 -0700 (PDT)
MIME-Version: 1.0
References: <20211025083315.4752-1-laoar.shao@gmail.com>
In-Reply-To: <20211025083315.4752-1-laoar.shao@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 25 Oct 2021 11:10:09 -0700
Message-ID: <CAADnVQKm0Ljj-w5PbkAu1ugLFnZRRPt-Vk-J7AhXxDD5xVompA@mail.gmail.com>
Subject: Re: [PATCH v6 00/12] extend task comm from 16 to 24
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Zhang, Qiang" <qiang.zhang@windriver.com>, robdclark@chromium.org,
        Christian Brauner <christian@brauner.io>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, linux-perf-users@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 1:33 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> There're many truncated kthreads in the kernel, which may make trouble
> for the user, for example, the user can't get detailed device
> information from the task comm.
>
> This patchset tries to improve this problem fundamentally by extending
> the task comm size from 16 to 24. In order to do that, we have to do
> some cleanups first.

It looks like a churn that doesn't really address the problem.
If we were to allow long names then make it into a pointer and use 16 byte
as an optimized storage for short names. Any longer name would be a pointer.
In other words make it similar to dentry->d_iname.
