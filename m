Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC222D836B
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 01:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407318AbgLLA3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 19:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728491AbgLLA3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 19:29:01 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A75C0613CF;
        Fri, 11 Dec 2020 16:28:21 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id o144so9192108ybc.0;
        Fri, 11 Dec 2020 16:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BDG+xZHQqMZdcSUls3ikA30hvFyPsfKiOeU+X969T1A=;
        b=WlecsQ9vMeLyIgCBs0jV0m2N0Mm0z+F5OMcLTYPse4U3NQ7x9nZGxQw2bycmpiQ2By
         42qSznD5A8VDX6aEve6EA28tGdA/P24mBcS+WTQ2M10Egx4PUej1NQbMBI96CQosbIsG
         aD31kST+2fYomHtrg6KHb4x4h3OkM6Mo4iWBza7H3PfmR8afeB7j7zVylOtM3dVjF3Dt
         dhWYzD+nZ2vTqdMeZkJP5i/h7DX6vV/3iINN7ugpdLI3zCGUAY8+AtHTjmvezNy/WEbU
         RnPW/vYsbrfYud8uLP7y3G0x24qaJ4Xf5fTy0FDE9QdqQrpgg+aSrpjYbfcbVtp3FOXe
         5CBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BDG+xZHQqMZdcSUls3ikA30hvFyPsfKiOeU+X969T1A=;
        b=tYVqUcz1pcFpXkND+W2cYALRAoyTiEPwmLTHj10VjkDgWAFu1uaIVusL4uNfZV7u/Z
         eSYv/zQV39J+PV1T2GSZyvpllvMBqJt2Vhxt8Ts9KEj8Dnj9ff7J/KXtT7DCNqZsyHEP
         kR/4kP0MWvtEQXiOU0ngMbfvUFK+KJdhoGEdJ2cLvKsWM4LLt2chwRpeD6iGOkiecNkX
         icKHqIUT0oJmNbjGYgBg+cuKPFUGxq4SEjs8M4A4S/hlS2zUWdZKUbmnOEmBWq16KAVb
         3AshBTtA3kma7x/vheXYozkow/2gsJYUhHSNCSaUPP2Y5nmGhU6FsfcK9Qy1Mw2/0AE1
         p0ng==
X-Gm-Message-State: AOAM531Hnt0DGfKz7LCG/ANEsDiGtQWFAQNtaMRxkU4W7VIoa+S4fd7V
        7PGVbOQPFb6JzW9thxtDYeUle8v5FCM6O368T90=
X-Google-Smtp-Source: ABdhPJw38//QZu1nI6EvdaYgjpqgf23gW3F0kOuRUNvbkke9MRzwS6VW5Muqnr8LSzTHcH2UDFQF6R6YkSspq5bfRfI=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr22397897ybe.403.1607732900133;
 Fri, 11 Dec 2020 16:28:20 -0800 (PST)
MIME-Version: 1.0
References: <20201211171138.63819-1-jonathan.lemon@gmail.com>
 <20201211171138.63819-2-jonathan.lemon@gmail.com> <CAEf4BzYswHcuQNdqyOymB5MTFDKJy0xkG4+Yo_CpUGH4BVqjzg@mail.gmail.com>
 <20201211230134.qswet7pfrda23ooa@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201211230134.qswet7pfrda23ooa@bsd-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Dec 2020 16:28:09 -0800
Message-ID: <CAEf4BzaA48yB5mnX5VAfLdUMa54Fq_pxpT__s0DbB7nYPzenMg@mail.gmail.com>
Subject: Re: [PATCH 1/1 v3 bpf-next] bpf: increment and use correct thread iterator
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 3:01 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On Fri, Dec 11, 2020 at 12:23:34PM -0800, Andrii Nakryiko wrote:
> > > @@ -164,7 +164,7 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info)
> > >                 curr_files = get_files_struct(curr_task);
> > >                 if (!curr_files) {
> > >                         put_task_struct(curr_task);
> > > -                       curr_tid = ++(info->tid);
> > > +                       curr_tid = curr_tid + 1;
> >
> > Yonghong might know definitively, but it seems like we need to update
> > info->tid here as well:
> >
> > info->tid = curr_tid;
> >
> > If the search eventually yields no task, then info->tid will stay at
> > some potentially much smaller value, and we'll keep re-searching tasks
> > from the same TID on each subsequent read (if user keeps reading the
> > file). So corner case, but good to have covered.
>
> That applies earlier as well:
>
>                 curr_task = task_seq_get_next(ns, &curr_tid, true);
>                 if (!curr_task) {
>                         info->task = NULL;
>                         info->files = NULL;
>                         return NULL;
>                 }
>

True, info->tid = curr_tid + 1; seems to be needed here?

> The logic seems to be "if task == NULL, then return NULL and stop".
> Is the seq_iterator allowed to continue/restart if seq_next returns NULL?

I don't think we allow seeking, so no restarts. But nothing will
prevent the user to keep calling read() after it returns 0 byte, so
yes, continuation is possible.

> --
> Jonathan
