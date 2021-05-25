Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBA538F8A6
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 05:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhEYDSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 23:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhEYDSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 23:18:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C880C061756;
        Mon, 24 May 2021 20:16:55 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id u7so7077649plq.4;
        Mon, 24 May 2021 20:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5D5lClmoiHDN8GJXbRYmv5T/hyaUQszt2yF2BpoRw84=;
        b=InUw0wx5KGLBzZXNtPZp9BEWAAwiVXzycBuWcX9DWd71iNgh2OUuQo0mqIiX73A+VG
         hzcKlc2IKNwhppDVphDqTuzUzBXvhbxF94/D+SMLcpvgrVZU2dJuE6NOPPtvyvB+ZaLL
         XWNFLdmGIM63Xpqk+8H9wZFyTYW0t/cG0fv4/IGb6wXalOys2OAmdHSdvdEQ0en4zxPL
         6Pcxxxmm4rHu7CD2EbeGolEHZxHIgCSvsIpPhZg+K35eXIVCOQqTEYyI8NliD9EbvKvn
         OmEhFErzBV79eC4m/q1EjKKQ794XucE+F4MKbI60DiUzO9TYUJZifCxzj1ZzVKIAA1SM
         4eWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5D5lClmoiHDN8GJXbRYmv5T/hyaUQszt2yF2BpoRw84=;
        b=YNaZW4/pTANkBUso/CYs0OPHL4bwaWuEfHSuPntNNs05fyctsff5jlpfmfvsRmnFdy
         xcBK11Ou9OY2Tsw38wvg0GtKjngnT1RZEaF1NJuf1cSV8gbWAkQuDQ5zRM9NCYJ0FpDM
         3gRue5QQTH5BTSeyYdhA32czPtzm5gehBJRspzQJyVr57/kMQXl9yNP6YVrCwnm59gy7
         008GYaaEJCrQckAWnouNu3xpMFEzUZjxGv7sv+3BSrZtRkokwvVxfaJZ5aKwtTTnaEfo
         /x7r/RC0vkbwRp+ZAWHwSkkgnhwA+K00Lz8bGt2LHfS5lnPnDpL79EbUt/t/25mmd6/u
         jr6w==
X-Gm-Message-State: AOAM532J69oenRwpnQ8E4uY7zDSqAvbHRKQEA6sfqHTYsSLCu3dmFF42
        y9CPvD3Jf9s6kbNcOC941e2JKWwc47H8hM2uPkM=
X-Google-Smtp-Source: ABdhPJxhV+/3jzN7SsR524ngafVuzLP4MjKZyjdL1CcMh3i9shkNs7Ce+C9LW8SaKXJqAWZjal6uXQaKT2v9nmquYaY=
X-Received: by 2002:a17:90a:c38c:: with SMTP id h12mr2530177pjt.145.1621912615031;
 Mon, 24 May 2021 20:16:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com> <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
In-Reply-To: <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 24 May 2021 20:16:44 -0700
Message-ID: <CAM_iQpU-Cvpf-+9R0ZdZY+5Dv+stfodrH0MhvSgryv_tGiX7pA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Sun, May 23, 2021 at 9:01 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, May 21, 2021 at 2:37 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > Hi, Alexei
> >
> > On Thu, May 20, 2021 at 11:52 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Why do you intentionally keep people in the original discussion
> > out of your CC? Remember you are the one who objected the
> > idea by questioning its usefulness no matter how I hard I tried
> > to explain? I am glad you changed your mind, but it does not
> > mean you should forget to credit other people.
>
> I didn't change my mind and I still object to your stated
> _reasons_ for timers.

What is _your reason_ to introduce timers? Clearly you provide
absolutely nothing here. ;)


>
> > >
> > > Introduce 'struct bpf_timer' that can be embedded in most BPF map types
> > > and helpers to operate on it:
> > > long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)
> > > long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> > > long bpf_timer_del(struct bpf_timer *timer)
> >
> > Like we discussed, this approach would make the timer harder
> > to be independent of other eBPF programs, which is a must-have
> > for both of our use cases (mine and Jamal's). Like you explained,
> > this requires at least another program array, a tail call, a mandatory
> > prog pinning to work.
>
> That is simply not true.

Which part is not true? The above is what I got from your explanation.

Thanks.
