Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB5A2D15F5
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgLGQ3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgLGQ3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:29:01 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F484C061749;
        Mon,  7 Dec 2020 08:28:21 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id x15so12752963ilq.1;
        Mon, 07 Dec 2020 08:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LnL3r5xO3/fx7Z2QtNr7MP9X1jy1UpH6c8wI0kRJVnU=;
        b=vRQotTdQ72iJTBqQPpmsoH+8dVTjUI576M40I4FfCXlRtAESaiSd7YPk3O83pr02ml
         4/Y2VMY1uZOZB8ZcB5z+IsX5FdltqM1WPZYCkUMVzwEV+AGd9StHtGFKaeHlYUbQob4Y
         hp9aptvyKZo+tvwG6NE6ORWQfju5M/BNA8l0fAuzCVOroY9EV49heOMWgV6NliaLrGlv
         5O+zo3NkovEQ2VcQNn7cMZ3Uwz8TTce0D5aP1Ksk+Si588cX5uOwElBJtuJ4o5OnQ1oo
         9Y0yupH3QuFLjDSvEtDFssQKJ7HRF33F7iv7RnbfnKSgHNeDUYUpljM2zO3DK+1YTaaS
         roWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LnL3r5xO3/fx7Z2QtNr7MP9X1jy1UpH6c8wI0kRJVnU=;
        b=IsNjxFUgrciSWjNl4LTugic6auNW836JUz+Gld7wg1TUL5kpf3VBJCBrDBLfgsbL9h
         US2Bzl0IkZ/D7S793bsSOxYjzEGHTFlxJaj9bh9RWgg5ebLMZe3S2suMVCedFs75AdqB
         FspEblqsRMRrLZGhYXiYHodzBi6uNG7G28L8KwikwvR1uqYrbw77M0a4+wEQpmPni90Y
         ijK1h8IN7ylwnaTC4pbK4wrXZuSroKugdZMdgUlwJnV/G2E//EW4WB/ex/EkBH08i+Xz
         O8RoRhJQG7cKztine2vZMSUbavYd7xUO5LvBbgL46cZuw53dgtyauEJ9HDUTJgInDQAf
         HjsQ==
X-Gm-Message-State: AOAM533dUfVNFDBFeZZeRDF8LiWehx6r/Yyz674nZ9eE8kymSPyvBOc6
        SgrgBwaNhCq7btL54ZWEC/WwG2ckfaxGHxAdwHY=
X-Google-Smtp-Source: ABdhPJzAPIkJv6/oiUZrILoK9k6D0gpWLBTZWT6CddYFBbvPG6eaBCYlqu8ziMMCme2b6s5WI0RSQUsOQ0bE17XczdM=
X-Received: by 2002:a92:8587:: with SMTP id f129mr22302422ilh.251.1607358500532;
 Mon, 07 Dec 2020 08:28:20 -0800 (PST)
MIME-Version: 1.0
References: <20201207123720.19111-1-lukas.bulwahn@gmail.com> <480e9a0f-0a27-aec2-e8c6-a73b46069ba8@fb.com>
In-Reply-To: <480e9a0f-0a27-aec2-e8c6-a73b46069ba8@fb.com>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Mon, 7 Dec 2020 17:28:15 +0100
Message-ID: <CAKXUXMxy92jnARL-ibh1BDqSE3VvzKFMpo8YsC+40JMjFpcSHg@mail.gmail.com>
Subject: Re: [PATCH] bpf: propagate __user annotations properly
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 5:12 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/7/20 4:37 AM, Lukas Bulwahn wrote:
> > __htab_map_lookup_and_delete_batch() stores a user pointer in the local
> > variable ubatch and uses that in copy_{from,to}_user(), but ubatch misses a
> > __user annotation.
> >
> > So, sparse warns in the various assignments and uses of ubatch:
> >
> >    kernel/bpf/hashtab.c:1415:24: warning: incorrect type in initializer
> >      (different address spaces)
> >    kernel/bpf/hashtab.c:1415:24:    expected void *ubatch
> >    kernel/bpf/hashtab.c:1415:24:    got void [noderef] __user *
> >
> >    kernel/bpf/hashtab.c:1444:46: warning: incorrect type in argument 2
> >      (different address spaces)
> >    kernel/bpf/hashtab.c:1444:46:    expected void const [noderef] __user *from
> >    kernel/bpf/hashtab.c:1444:46:    got void *ubatch
> >
> >    kernel/bpf/hashtab.c:1608:16: warning: incorrect type in assignment
> >      (different address spaces)
> >    kernel/bpf/hashtab.c:1608:16:    expected void *ubatch
> >    kernel/bpf/hashtab.c:1608:16:    got void [noderef] __user *
> >
> >    kernel/bpf/hashtab.c:1609:26: warning: incorrect type in argument 1
> >      (different address spaces)
> >    kernel/bpf/hashtab.c:1609:26:    expected void [noderef] __user *to
> >    kernel/bpf/hashtab.c:1609:26:    got void *ubatch
> >
> > Add the __user annotation to repair this chain of propagating __user
> > annotations in __htab_map_lookup_and_delete_batch().
>
> Add fix tag?
>
> Fixes: 057996380a42 ("bpf: Add batch ops to all htab bpf map")
>

Fixes tag can be added by the maintainers when they pick it, but I
personally am not a fan of adding a Fixes tag for such a minor fix
here.

It is purely a syntactic change and change for the sparse semantic
parser, but it really does not need to be backported and nothing
observable in the binary was broken.

That is my rationale for not adding a Fixes: tag here. It is your final call.

> >
> > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
>
> Thanks for the fix. LGTM. I guess either bpf or bpf-next tree is fine
> since this is not a correctness issue.
>

Agree, and it is no functional change, nor a change in the object
code. So risks of regressions are very, very low (zero).

Thanks for the review,

Lukas
