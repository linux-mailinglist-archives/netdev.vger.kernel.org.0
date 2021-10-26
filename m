Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6AD43A9DD
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 03:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbhJZBvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 21:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhJZBvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 21:51:46 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B1EC061745;
        Mon, 25 Oct 2021 18:49:24 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id s20so4420358ioa.4;
        Mon, 25 Oct 2021 18:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q9ixNJMryetrNkf64Gif/9S4GmDdPd1m0A8YYlrDxDA=;
        b=TBnfJZ2THlgi6EJWoe2MO5u+LFFM0EWaiS+gotcqJjfIh8zd+i2c6molpxOgo/9s4D
         dFOGYLm+q0OhSm73HgMzBOqjy2LkiZ+kuDPMyr4SFVGL5gxwrAXFIhbwonRW2eC7qEAi
         2K8GtjicsqXI4vzFSsCcedGOgub8jloVy1yjHvaPn9352ZIndl5Ea4DrrTu7ZAAqMD6J
         QogrxjLepRtyf4KjhS9R4PcbYPfrlWzBubvr+fLQWsihUtby/5E+e0AX6/dw9h9USG1r
         A5SxerUB1p4uMYV8rL9Pf7naaoIsGCSa6jAI2ewjP+7NXDjJEMyjy+fqlQ0t6wtZiIpc
         /BXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q9ixNJMryetrNkf64Gif/9S4GmDdPd1m0A8YYlrDxDA=;
        b=x+VBGtmcVhXarrTfCv5jki00LJBVb7N8Q7oyZyh3qRML7v8Hnf+qnUGEBpCjQvQnqc
         UWYr5CWD3DDF9M88dWN18IrPc7sLFGNdFPBkI1iHbvGUttIPUMJYE5gH236dsLrAfLOR
         V3zFv2hSz4q70p2VL3/sfrw3hjhmxy4gRhM1otQ26UqxIHPLBCKFdSjkWm01+ljZac4r
         BIlwEQzg3Gxr5WjkKIfvRC68Zjiji9Jni68Tnqt2N1/Fn88w5qPNX5RgClHUYw9pRZv6
         I/i/yBmoWvtJHLMpgCHu7e+izNGBub+b9GUu0d2mwgUFftqr6pw6ac/lxoVoTdVHZ3PW
         3BEw==
X-Gm-Message-State: AOAM531rkXc9CofYeWFBiNZ16HoVVoHyLBW12usTaIo4YBrJZgDTlQkD
        V5PoE/YSFvtxp5Kv6TysJpa4KP/bj7JO60p5D4M=
X-Google-Smtp-Source: ABdhPJxyqz6JE4o8mcyL8jtdYd9fyB0EJ9+xMphQ3cQq2Z6znTX7NDxCDSShbtRLSLDUkJdu8VHSeeQUDN0xgh39/eo=
X-Received: by 2002:a05:6602:1514:: with SMTP id g20mr13536302iow.9.1635212963546;
 Mon, 25 Oct 2021 18:49:23 -0700 (PDT)
MIME-Version: 1.0
References: <20211025083315.4752-1-laoar.shao@gmail.com> <20211025083315.4752-2-laoar.shao@gmail.com>
 <202110251407.6FD1411ECB@keescook>
In-Reply-To: <202110251407.6FD1411ECB@keescook>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 26 Oct 2021 09:48:47 +0800
Message-ID: <CALOAHbB43jP=TKfCNqNRaEhFj-JyYhSO-3udYYQvjDST=jUoDw@mail.gmail.com>
Subject: Re: [PATCH v6 01/12] fs/exec: make __set_task_comm always set a nul
 ternimated string
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
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 5:07 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Oct 25, 2021 at 08:33:04AM +0000, Yafang Shao wrote:
> > Make sure the string set to task comm is always nul ternimated.
>
> typo nit: "terminated"
>

Thanks for pointing this out. I will correct lt.

> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
>

Thanks for the review.

-- 
Thanks
Yafang
