Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC2638CFFE
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhEUVjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhEUVjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 17:39:15 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83FFC061574;
        Fri, 21 May 2021 14:37:51 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b13-20020a17090a8c8db029015cd97baea9so7748801pjo.0;
        Fri, 21 May 2021 14:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UbBJ360u7LKeJqo+1ElI1LkQNAGNqJN8ugGsYfQKge4=;
        b=ssn0sSJWy/9PvK7HW9oSR1JalN98rO/dBT0dhrW9W7sl2SEeFjQNbq63fOiDOxSIgc
         +pcDlrkj3hZQD3FDgnrUSxF8ZHM/EQKpn1ldkirH35sDDBEfnaKfXN6xlXmQokNjpr8d
         SWrPRvfEdfbFpGkvxvQ0cI0Qlorkb7VNzY7zkjw6AjX+TcRhEyucgBqFUzcxaREJxuoH
         k/8RfZP2ZX64uII6+hTGc/3N2ojwpYG+D3a9HIN54TAiwbp0ONInoORG7ROFgzCeChWo
         0rjo30//rtoaonzVTYK1SfXJ/+H23sIa8Sf2ppuotIeXJnfS6Hsm7+uMn+ooow/FVxcl
         p59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UbBJ360u7LKeJqo+1ElI1LkQNAGNqJN8ugGsYfQKge4=;
        b=Eu7QIjee5iV1ztweMCqHNbkIHfYhPrtaa3OVR3T4o71P8pozjN7XKkEv+SpPXVL5dK
         4F2VZJDY2P9vu37rsbPVF77EaHnrFdU5T9OnxV16beJjR7PqK7JLIQeP853zNSc7dIgv
         UTk+sIFS3ZTeS//W9coZOpER4xUShrFbTAuPEz8igzVIGiE7s9r3sIAMfXSJJMVd48aJ
         BLXaQZY+a8VP2l9jlq6REpFrrpwiFxO+eJ3mt9h/9E3N/74VDLnMJ6QhQf3Ru9Q4AI3p
         8g/ssoTA8iXLv2F6p1EFT/x0p6Yb30UDQir38Qmv2phKsZZQuBZBpS90CztT5I0XUT7x
         ZD5Q==
X-Gm-Message-State: AOAM5302JyWCmL/2MVg5e1ojt0gGVmLkk1bKeqPu61DGRv2EVyxWkVlY
        6NMX178YC96svXGQQYISkq4Hm7frzOMZs2y1kKtERWW7q/Y=
X-Google-Smtp-Source: ABdhPJxG0/0ZgXJKdvxR7bapebIafEeIl9jhjyDx67lzhMp0zrFJa4ZBMCWxrr0kyrIGINgIeHXaOaXaPkb4pl8ITF8=
X-Received: by 2002:a17:90a:e2cb:: with SMTP id fr11mr12910520pjb.56.1621633071526;
 Fri, 21 May 2021 14:37:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 21 May 2021 14:37:40 -0700
Message-ID: <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com>
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

Hi, Alexei

On Thu, May 20, 2021 at 11:52 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>

Why do you intentionally keep people in the original discussion
out of your CC? Remember you are the one who objected the
idea by questioning its usefulness no matter how I hard I tried
to explain? I am glad you changed your mind, but it does not
mean you should forget to credit other people.

>
> Introduce 'struct bpf_timer' that can be embedded in most BPF map types
> and helpers to operate on it:
> long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)
> long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> long bpf_timer_del(struct bpf_timer *timer)

Like we discussed, this approach would make the timer harder
to be independent of other eBPF programs, which is a must-have
for both of our use cases (mine and Jamal's). Like you explained,
this requires at least another program array, a tail call, a mandatory
prog pinning to work.

So, why do you prefer to make it harder to use?

BTW, I have a V2 to send out soon and will keep you in CC, which
still creates timers from user-space.

Thanks.
