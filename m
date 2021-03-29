Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D47B34C820
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbhC2IUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbhC2ITc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:19:32 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11F3C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 01:19:25 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id n138so17169929lfa.3
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 01:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T17UPyB49fQi81p3RjN5h9re4h1c9rcNiJmp3cH67jg=;
        b=q1LkIVeN1CSY5hosJXtoBv+Ux0JhJ27lW+Gm+sBS9dvD4Sw2R4apI4P5/0lR/NLEQR
         VIZ+gt088HzjytzKLP0IMIDXvGVjshPrKXBV/YdRScfYB9kBop09xAfYf0Mc/qm5RqMG
         ovmY11JV78D5bCh5lGmZc69wxuCOT1iyewBBI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T17UPyB49fQi81p3RjN5h9re4h1c9rcNiJmp3cH67jg=;
        b=lInUJJX7cowDSa4NKuOX29dOHhYIeI0qTvUwNLisoPqWfBLD02s++Ut1UoKxe6X9M+
         znnjmwuo5CcQ9haGX1qc5jjWqFYJKZwMP1RADjGdAH2pM+CsRP+61gpIDs5DTfsO9OE/
         92lvNDEkhIaDzG83qQEYbFMP1ZHM6aX17G9qKuAdI1C43wODvL6kI1Nva75lvSOTUdyA
         Kzdww/s5bHrx1uvY1lFqNgJOqeNMlB9KEIOZmHY3eBv27D2CL/Y8c26meTASbYCr5pOF
         XGH/hWzRAPaO0hAt8m0j4jkDRggtgCkrjVmgFDiyVlmlFVNPF2QiE88RhLeijDig0Nau
         686w==
X-Gm-Message-State: AOAM5312vb7HKy+x2thItmlk94lALTCfDvhIa5G07gCpps1Ii4GbO5NR
        sH9WQQJP+H17/uH9/z1i826FMidzpAqA3DWjnbH9tQ==
X-Google-Smtp-Source: ABdhPJxFOiDf3HdUzgGwB1o9orQWHoh/OXEAOPDSOIowsXvtXJ80dRVlkz8qGZfuEAA4/DB8oCyHi6o9BNhhc5MaJTY=
X-Received: by 2002:a19:521a:: with SMTP id m26mr16066250lfb.56.1617005964467;
 Mon, 29 Mar 2021 01:19:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210326160501.46234-1-lmb@cloudflare.com> <20210326160501.46234-2-lmb@cloudflare.com>
 <CAPhsuW7E4bhEGcboKQ5O=1o0iVNPLpJB1nrAgxweiZqGhZm-JQ@mail.gmail.com>
In-Reply-To: <CAPhsuW7E4bhEGcboKQ5O=1o0iVNPLpJB1nrAgxweiZqGhZm-JQ@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 29 Mar 2021 09:19:13 +0100
Message-ID: <CACAyw99NVbu0q-wh=r7ifoVUnny6gxXwf6LPGf0HUhg1CCQkUQ@mail.gmail.com>
Subject: Re: [PATCH bpf v2 2/2] bpf: program: refuse non-O_RDWR flags in BPF_OBJ_GET
To:     Song Liu <song@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Mar 2021 at 20:14, Song Liu <song@kernel.org> wrote:
>
> On Fri, Mar 26, 2021 at 9:07 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > As for bpf_link, refuse creating a non-O_RDWR fd. Since program fds
> > currently don't allow modifications this is a precaution, not a
> > straight up bug fix.
> >
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > ---
> >  kernel/bpf/inode.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> > index dc56237d6960..d2de2abec35b 100644
> > --- a/kernel/bpf/inode.c
> > +++ b/kernel/bpf/inode.c
> > @@ -543,7 +543,7 @@ int bpf_obj_get_user(const char __user *pathname, int flags)
> >                 return PTR_ERR(raw);
>
> For both patches, shall we do the check before bpf_obj_do_get(), which is a few
> lines above?

type is filled in by bpf_obj_do_get, so we can't avoid calling it. As
Andrii mentions we need to allow flags for map.

>
> Thanks,
> Song
>
> >
> >         if (type == BPF_TYPE_PROG)
> > -               ret = bpf_prog_new_fd(raw);
> > +               ret = (f_flags != O_RDWR) ? -EINVAL : bpf_prog_new_fd(raw);
> >         else if (type == BPF_TYPE_MAP)
> >                 ret = bpf_map_new_fd(raw, f_flags);
> >         else if (type == BPF_TYPE_LINK)
> > --
> > 2.27.0
> >



-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
