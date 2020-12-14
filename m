Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78212D9F6A
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 19:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440871AbgLNSlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 13:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407595AbgLNSlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 13:41:42 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0177C061285;
        Mon, 14 Dec 2020 10:40:45 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id x18so3050878pln.6;
        Mon, 14 Dec 2020 10:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E59vUJRHARpM5qnRhm8uSqnDlr5PHTJoFFNSvBA9cyg=;
        b=UjV3j1+SFiFJ3ALH+KJOYggs2VB6x5/bSjvG5rflSSAN2K/gRoyf05+1QgapQIfzyB
         Co058Ka8ZDJ+Cy5Lv/Eeec6a8XJrBgoLDq04qYiejxW5BsRntM/RUodXXJCiRKsQVnQ9
         MZeekft55vyywoOxesYV8Ty20nszpA1Yhn2/0E4KVrNAo7T3G88+bkqg0Qp7qXjTRk44
         ps23ke8OSekoetLd9zZ8UpftTAx3n0BCS0DHOhQ43RAwOGATpGsYk70AB3+A9Kv3PU8U
         FPIHaRzEtnjkQQxAV4tC+4z8fmnyQB/EAhB+/vycLJkg56mvNW1jsNfjfzRGxoOkOynb
         Ru3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E59vUJRHARpM5qnRhm8uSqnDlr5PHTJoFFNSvBA9cyg=;
        b=smsCzOiER3Wb7vw4h9SFtXqms7abQ33Fv7KXvdWwlLNMDlYP0/+AKD4igRUUR6kgve
         0c5c0rdM0cnxqTbbutDoVNgWhair1Ldqxb0vqVK0g2v3wIQzpcKX0nEVyI/O/a4ch05t
         DkCr8d8zL9TtjUgLB1+gWS6KXLUk/VTXYG4CHjuX/9aEWpCkB6tRARY+lFY/DhwOrxGi
         bfBumK7TOmYXsZfzWsNwf/qAhodeuHgl80Di7CrNWT4Df5VOZPuagVbc6GFWdi0bPvjT
         cfIa3xmtZ3mbeFkni7O5QNz5fb/3J3NVxIuXF4CQQvu1PUS210myM3Xc4VRUqnPqts2C
         e9Qg==
X-Gm-Message-State: AOAM532NYvFyz5++3cIh+Z0WhAhLpgLaoQuEEbzElULBdW6Xs7aJeHvR
        sOe0O+kEv9E3ZQ4SdvoupCYytBfr9swkLjiL/BY=
X-Google-Smtp-Source: ABdhPJw9sQAMenPwTBh8/hfvHi/IOlLZHMM9q4BcaQB1mpIGvPcnASXbNRLMzkrzkfq98UagJZHkxdLaeEM1CymI/oU=
X-Received: by 2002:a17:902:7242:b029:db:d1ae:46bb with SMTP id
 c2-20020a1709027242b02900dbd1ae46bbmr23334124pll.77.1607971245335; Mon, 14
 Dec 2020 10:40:45 -0800 (PST)
MIME-Version: 1.0
References: <20201211000649.236635-1-xiyou.wangcong@gmail.com>
 <CAEf4BzY_497=xXkfok4WFsMRRrC94Q6WwdUWZA_HezXaTtb5GQ@mail.gmail.com>
 <CAM_iQpV2ZoODE+Thr77oYCOYrsuDji28=3g8LrP29VKun3+B-A@mail.gmail.com>
 <CAM_iQpWA_F5XkaYvp6wekr691Vd-3MUkV-aWx4KWP4Y1qo4W_Q@mail.gmail.com> <X9bA/pSYxW079eYm@rdna-mbp.dhcp.thefacebook.com>
In-Reply-To: <X9bA/pSYxW079eYm@rdna-mbp.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 14 Dec 2020 10:40:34 -0800
Message-ID: <CAM_iQpX9TDN0RQuhSHsk72fy5akAh-iiB3e2A6PE6KqAfiV=pw@mail.gmail.com>
Subject: Re: [Patch bpf-next 0/3] bpf: introduce timeout map
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 5:33 PM Andrey Ignatov <rdna@fb.com> wrote:
>
> Cong Wang <xiyou.wangcong@gmail.com> [Sat, 2020-12-12 15:18 -0800]:
> > On Sat, Dec 12, 2020 at 2:25 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Fri, Dec 11, 2020 at 11:55 AM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Fri, Dec 11, 2020 at 2:28 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > >
> > > > > This patchset introduces a new bpf hash map which has timeout.
> > > > > Patch 1 is a preparation, patch 2 is the implementation of timeout
> > > > > map, patch 3 contains a test case for timeout map. Please check each
> > > > > patch description for more details.
> > > > >
> > > > > ---
> > > >
> > > > This patch set seems to be breaking existing selftests. Please take a
> > > > look ([0]).
> > >
> > > Interesting, looks unrelated to my patches but let me double check.
> >
> > Cc'ing Andrey...
> >
> > Looks like the failure is due to the addition of a new member to struct
> > htab_elem. Any reason why it is hard-coded as 64 in check_hash()?
> > And what's the point of verifying its size? htab_elem should be only
> > visible to the kernel itself.
> >
> > I can certainly change 64 to whatever its new size is, but I do wonder
> > why the test is there.
>
> Cong, the test is there to make sure that access to map pointers from
> BPF program works.
>
> Please see (41c48f3a9823 "bpf: Support access to bpf map fields") for
> more details on what "access to map pointer" means, but it's basically a
> way to access any field (e.g. max_entries) of common `struct bpf_map` or
> any type-specific struct like `struct bpf_htab` from BPF program, i.e.
> these structs are visible to not only kernel but also to BPF programs.

I see, I was not aware of this.

>
> The point of the test is to access a few fields from every map struct
> and make sure it works. Changing `struct htab_elem` indeed breaks the
> `VERIFY(hash->elem_size == 64);` check. But it can be easily updated
> (from 64 to whatever new size is) or replaced by some other field check.
> `htab->elem_size` was chosen semi-randomly since any bpf_htab-specific
> field would work for the test's purposes.

Good to know it is useful, I will have to change 64 to 72, as I tried to use
sizeof but struct htab_elem is not visible to that test.

>
> Hope it clarifies.
>
> Also since you add a new map type it would be great to cover it in
> tools/testing/selftests/bpf/progs/map_ptr_kern.c as well.

Yeah, will do.

Thanks.
