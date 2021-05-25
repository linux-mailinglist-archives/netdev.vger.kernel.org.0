Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D485C390A21
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 21:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbhEYT7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 15:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhEYT73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 15:59:29 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB98C061574;
        Tue, 25 May 2021 12:57:57 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id e2so33448135ljk.4;
        Tue, 25 May 2021 12:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4s7vCGqH0XmF+l5T0ZZ65rm+cCf196bb9Q/4DckFJcg=;
        b=cAXVMGYah5V9RlRZ3EBNnOceo2itK3w+IW+xPAMqU2D6u4YGXBqerZni5pcuJB+NxV
         7rzC9482okTVr+e+0jqx8t12+aX91S5oT7hlD3fTWi9RSoF540Qti865/8QHLNLVjgE3
         qMbhjuM7HChXgxfwLYlrPHVeOF5Mf8x60+tiGHN0fmyhTIHSRGnEhl1fdVo7/yL5zyp2
         9pP7juyMcC5sD1V/oqVjfT0pMtPj1Cihv5U85a02M62ktAvOmETMLArADanADmwU6xdE
         SwtB6I8jayKXQ3/8Ns91GK0jS9DIvgscpG1XjRx/qugGZiQbKIVXvhog2LawbWt5R/39
         KnNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4s7vCGqH0XmF+l5T0ZZ65rm+cCf196bb9Q/4DckFJcg=;
        b=XnY04Wo9j0g6azwHXWMytiG91y6uzBYOU12asRAoNiNzEIj6Z5PJiClEEXM+BT4Xox
         Z78NjCrc4l8bfgiS+hWEx1dgQS3qAkrcBeaZA1/YyYlDXKpxkjs3sJEvM0o12Bhue+cv
         ermF8/rLDFY6qWOBreZpjrwNh2QTsYAsutpHj19b2CMhz5LZz4/UfKFXjkQGD6T3MSqZ
         n0hCBRYBcMTWDFHfyH1SWojUv4VSQ/6W/aAuR+qSfjIWwmnTiZ6y6HM8U00hHuS2GDon
         4jZlM4IzFR6XD/ytyrF5tTjmWzlbWtQTJSqrAaKG6Ql8rZTPyBGWc3A5aNSok7oR1xY7
         I2iA==
X-Gm-Message-State: AOAM530jImx7qyT6PFIFTaw1lUTab6XPM0jhwoVcRcXngg3V0IBeVD63
        yZnxNbd4i74MwzEVh8Lz7iqhPir/FMrKvJBigqq6WmaQ
X-Google-Smtp-Source: ABdhPJwfnnuCdxpZ2xllj1yM84DF3TTXPxxxfJDxAdKeBGjipAsgTG83zCIv82LwvnK1Es0Klq+o/bMYZnfgEjV2LTk=
X-Received: by 2002:a2e:a489:: with SMTP id h9mr22497417lji.21.1621972676337;
 Tue, 25 May 2021 12:57:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com>
 <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
 <CAM_iQpU-Cvpf-+9R0ZdZY+5Dv+stfodrH0MhvSgryv_tGiX7pA@mail.gmail.com>
 <CAM_iQpVYBNkjDeo+2CzD-qMnR4-2uW+QdMSf_7ohwr0NjgipaQ@mail.gmail.com>
 <CAADnVQJUHydpLwtj9hRWWNGx3bPbdk-+cQiSe3MDFQpwkKmkSw@mail.gmail.com> <bcbf76c3-34d4-d550-1648-02eda587ccd7@mojatatu.com>
In-Reply-To: <bcbf76c3-34d4-d550-1648-02eda587ccd7@mojatatu.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 25 May 2021 12:57:45 -0700
Message-ID: <CAADnVQLWj-=B2TfJp7HEsiUY3rqmd6-YMDAGdyL6RgZ=_b2CXg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
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

On Tue, May 25, 2021 at 12:35 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2021-05-25 2:21 p.m., Alexei Starovoitov wrote:
> > On Mon, May 24, 2021 at 9:59 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
>
> [..]
> > In general the garbage collection in any form doesn't scale.
> > The conntrack logic doesn't need it. The cillium conntrack is a great
> > example of how to implement a conntrack without GC.
>
> For our use case, we need to collect info on all the flows
> for various reasons (one of which is accounting of every byte and
> packet).
> So as a consequence - built-in GC (such as imposed by LRU)
> cant interfere without our consent.

The outcome of the last bpf office hours was a general agreement
that we need new hooks in map update/delete operations
(including auto-delete by LRU) that will trigger a bpf subprog.
It might look very similar to the timer callback that is part of this patch,
but instead of being called by the timer the LRU logic will call it.
This way the subprog can transfer the data stored in the
about-to-be-deleted map element into some other map or pass
to user space via ringbuf or do any other logic.
