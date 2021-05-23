Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E522D38DBC4
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 18:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhEWQDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 12:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbhEWQDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 12:03:16 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F9EC061574;
        Sun, 23 May 2021 09:01:48 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id w7so16874416lji.6;
        Sun, 23 May 2021 09:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CdueXP4s9bv1G0zwtUT7TV1yPyoLlrKrTIXbQ6r5GKs=;
        b=iOcCpwerWPKgxJNGktAMGz4m/8PWSYxv8/SmZrARYdfNcSpq5nZnD2o6n2m7Bv5hP1
         fGVIw6tDlb+jXCs7XETQPlA9yktmbu82YRseBllpVFXfy3sJ7M+6tTPU55eRMxfJhzv5
         wOlH5yk0kuFzwfIsb3u/KS+QGiG7s+NEV70KxXudicXnjc6YDK0ycSLhQl+ny+8woZMt
         NXkYuBUjUlRji07NFNBj8lLJ8zBKihkCrlKTy2SOcRsEEEJcVhx0bSXTHy4lMNAzVHDo
         dmZYgxs6nW4ewv8IMLdK3wB2riiM/Je+wRczk8cjAV5q+415pDru/GEf0v6GcxKAxGlX
         Z7rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CdueXP4s9bv1G0zwtUT7TV1yPyoLlrKrTIXbQ6r5GKs=;
        b=ZvkaGLNJL5zSdDby0/jKxOI43ToMoElvmQcSLGIlL7wpyV/W95ZTKUWjGsMH+uC2ku
         ggzfeoksKiPOXtYwKITLkI1ajAxWW8554OFXJWR/WvlVUEVwogbH5LJpa9nUzrx2pw0R
         AKOIP7MTmL06B6MikbbxLx3Y0G5aWCgwsAR3QcQjmWfb8HR5kabB0RcWcarHkZ9o2HVX
         XehgKi7HOPUYdWR74wIbFOeE8+EmQkpB7pdmXDTOEOpMcF/AusjeeV/kZ/DojLsQ2g7S
         LaEVcP59+TF+FgMS/0NvxVe8U0JmaFoQ6ZrnQi+A9IPY4/n7oyO2qeKkYKL/AXgw/SjW
         ym1A==
X-Gm-Message-State: AOAM531mMl65gsfaGoitEOvddrejC95E1VRM8OSQDu/W40FT0dLkqALh
        91YaqfZuW82H6/E4EXkLsIZe8rr+GE9OBnZSyzA=
X-Google-Smtp-Source: ABdhPJz8+tvNFL5KHF6LOHDBc4FmZMvCwX8pBhzyqB5HCIJ/zA7PgCMkhMh69SC2xqnamUU7hwSef+pYWSnlNmnJnCA=
X-Received: by 2002:a05:651c:2ca:: with SMTP id f10mr13966384ljo.236.1621785707265;
 Sun, 23 May 2021 09:01:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com> <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com>
In-Reply-To: <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 23 May 2021 09:01:35 -0700
Message-ID: <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 2:37 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Hi, Alexei
>
> On Thu, May 20, 2021 at 11:52 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > From: Alexei Starovoitov <ast@kernel.org>
>
> Why do you intentionally keep people in the original discussion
> out of your CC? Remember you are the one who objected the
> idea by questioning its usefulness no matter how I hard I tried
> to explain? I am glad you changed your mind, but it does not
> mean you should forget to credit other people.

I didn't change my mind and I still object to your stated
_reasons_ for timers.

> >
> > Introduce 'struct bpf_timer' that can be embedded in most BPF map types
> > and helpers to operate on it:
> > long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)
> > long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> > long bpf_timer_del(struct bpf_timer *timer)
>
> Like we discussed, this approach would make the timer harder
> to be independent of other eBPF programs, which is a must-have
> for both of our use cases (mine and Jamal's). Like you explained,
> this requires at least another program array, a tail call, a mandatory
> prog pinning to work.

That is simply not true.

> So, why do you prefer to make it harder to use?
>
> BTW, I have a V2 to send out soon and will keep you in CC, which
> still creates timers from user-space.

Don't bother.
