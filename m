Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3C43C1A4D
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 22:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhGHUHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 16:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbhGHUHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 16:07:45 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55EAC061574;
        Thu,  8 Jul 2021 13:05:01 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id v189so2455606ybg.3;
        Thu, 08 Jul 2021 13:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v9mFL73hyfBnHeCf3O+fdzT4RqaAE3l3GXfOoZRyFbk=;
        b=hz6B3W8BkH4+gfMkhPQvWkZeJaoyx/mYs+WlVL4jCipUkKS8/ordYYU7618wVb1o0+
         yq5JoMP8dr3rJYXBiDqdqlb4IG2Rgzre2SNjlaZ/Y5V4VpGqENHxr20nFRF7XRexMr6R
         aNo7dFTzGr+84h4mecshUZG7ZjNwB38IleCDFRwQA264Wbj/uyhHxKY795rSHI8d8hmt
         gvHKnlBpvtVHSZdkr1sT+5UKvsTKiXPbHYp1Vp0LBpB6x4P9WzOUJw9A0rKLyS8gTOmE
         jqNqciA3OTZvXnUwF2OylIrVtCd07p/vTQfxDMWpxFrwl3Bkraux12/UDokVXxfIzwq/
         dtyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v9mFL73hyfBnHeCf3O+fdzT4RqaAE3l3GXfOoZRyFbk=;
        b=D2sNOFfepISXHS6z+eMVf7bNWqaKEvF4AVCRDVpOVVR1dRl8MMyjnfzfN7vqIe11IM
         chQZEs11w+OX9m6Nd9FiBgOWkmpC6PC+a/iGfpPDDHobeDXFHQ0ploPGnU/YspToFEI9
         Z/15fRLUKrwox6ODPOIvk9W9lDk1yr2oWEauEAD4dCJZZnWwevPNnTJA9yeAnD5mTcq4
         1jNtgoKaN0FbVWkV3niSnaysitUBeEUxWh1jKoB+hKDR6TIXzbZ+MTn+EZzwEK1lZffF
         NAiV6IGl6jyTprMIlWCgS40iImUASIHvyyMTz1LG0QycMHYom1c2rdyvXLV3Mb1I2GJy
         +ysw==
X-Gm-Message-State: AOAM5318N5X6HmlsjQoeLFnCBpFnGqCnM5bx35Dyvn0aCr8HUpRVDsRy
        6yhmA6tOZeHplRplRsMwhleCzTyzE2BpzNjUZUA=
X-Google-Smtp-Source: ABdhPJxIh7+oFIjH7F2x89tOGomIDrt7GQd8Jr9QcP62lhUIJXVvURLcOmi6nU8f5EYgmjuHvBaLb5OBXMhe5UabkLk=
X-Received: by 2002:a25:d349:: with SMTP id e70mr41601962ybf.510.1625774701134;
 Thu, 08 Jul 2021 13:05:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210629095543.391ac606@oasis.local.home> <CAEf4BzZPb=cPf9V1Bz+USiq+b5opUTNkj4+CRjXdHcmExW3jVg@mail.gmail.com>
 <20210707184518.618ae497@rorschach.local.home> <CAEf4BzZ=hFZw1RNx0Pw=kMNq2xRrqHYCQQ_TY_pt86Zg9HFJfA@mail.gmail.com>
 <20210707200544.1fbfd42b@rorschach.local.home> <CAEf4BzYRxRW8qR3oENuVEMBYtcvK0bUDEkoq+e4TRT5Hh0pV_Q@mail.gmail.com>
 <20210707204339.5f415991@rorschach.local.home>
In-Reply-To: <20210707204339.5f415991@rorschach.local.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 8 Jul 2021 13:04:48 -0700
Message-ID: <CAEf4BzY9VyvQSXv4AiX6m85gcvwAqfXxKcRFDpsLe=yucL5MPA@mail.gmail.com>
Subject: Re: [PATCH] tracepoint: Add tracepoint_probe_register_may_exist() for
 BPF tracing
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        syzbot+721aa903751db87aa244@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 5:43 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 7 Jul 2021 17:23:54 -0700
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > On Wed, Jul 7, 2021 at 5:05 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > On Wed, 7 Jul 2021 16:49:26 -0700
> > > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > >
> > > > As for why the user might need that, it's up to the user and I don't
> > > > want to speculate because it will always sound contrived without a
> > > > specific production use case. But people are very creative and we try
> > > > not to dictate how and what can be done if it doesn't break any
> > > > fundamental assumption and safety.
> > >
> > > I guess it doesn't matter, because if they try to do it, the second
> > > attachment will simply fail to attach.
> > >
> >
> > But not for the kprobe case.
>
> What do you mean "not for the kprobe case"? What kprobe case?
>
> You attach the same program twice to the same kprobe? Or do you create
> two kprobes at the same location?
>

I meant attaching the same BPF program twice to the same kernel
function through the kprobe mechanism (through perf_event_open()
syscall). From user perspective it's one BPF program attached twice to
the same kprobe. Not entirely sure if two perf_event_open() calls will
create two kprobes or re-use one internally.

> >
> > And it might not always be possible to know that the same BPF program
> > is being attached. It could be attached by different processes that
> > re-use pinned program (without being aware of each other). Or it could
> > be done from some generic library that just accepts prog_fd and
> > doesn't really know the exact BPF program and whether it was already
> > attached.
> >
> > Not sure why it doesn't matter that attachment will fail where it is
> > expected to succeed. The question is rather why such restriction?
>
> Why is it expected to succeed? It never did. And why such a
> restriction? Because it complicates the code, and there's no good use
> case to do so. Why complicate something for little reward?

See above about kprobe for why it was my expectation.

But it was my original question whether this causes some complications
or it's just an attempt to detect API mis-use. Seems like it's the
former, alright.

>
> -- Steve
