Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A78A8BCBA
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 17:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbfHMPMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 11:12:38 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36140 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729873AbfHMPMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 11:12:38 -0400
Received: by mail-ot1-f68.google.com with SMTP id k18so41658865otr.3
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 08:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wiTJg1mLp3QjrILHchoTxtvBRp92tUbdtvUgIPj4jZI=;
        b=eukH0ZvAq0Z/wJukiPnGAveU4NqGN1rOLpWgo59UNQr2Kr3dsmvnVkS9hGSvWc9x84
         N4hPSFfAKSFJphg75rQK0bSD6ettvyg9qOyHvnH5VFJ2btgjz2L87NdVDLMzZnmakp1/
         3b9Wynyv4B4mDETv6tOYQCJ0oT0oYoAXzMYw/qnF7p1kUGCcOeAomfb/Vth/Vt4ciThG
         QJviy4mF6oIeCFe68NI8ZMXgx4LQx82MPY3vs8UdACABMW76uLAFN2icAiuZLzK2c7K8
         FKTkfl8gJsFlFSyQ7YgiF/3wVqnBfEaMLNKh3uYO87kKci2ljCu7aqorE9s8SCvvljlg
         D8Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wiTJg1mLp3QjrILHchoTxtvBRp92tUbdtvUgIPj4jZI=;
        b=Px/i6OY6nlCaaBrnrMCVZLBG5gmUCw2hjqkS4hxiFTOek5eJEX7l57khorAEvW57Wr
         lb+1iNCoa7N/wPnhp215+7LtrXnCQbpgsWwAEKx+PT60DfAUQX+dUf7eltbYUyYqATYN
         flQXv/JqbP4ilmKOhzyHgwGNMNeUyMRyj/D8i1ybMvnU9cKjZziMDeNIj6FF3KC4DJrL
         IwKC6Rz30jdcc4FjVKn5ZKulFGtQO5IZE6TA2/2CgbGrwAqi5oxng4t+tgFJAiGvMDcW
         6D9ZFX4ytJlBJ2prRQIPaEzaQHL7iKDgtQslU0sK0uD0Wx6w2dcnZxGCUjiOAOxI4qX6
         fnrw==
X-Gm-Message-State: APjAAAULiIfYS/87xw2x8F9ikL67prJ8gpjzKwmHW4Omj91tI4vSpu+w
        RUO4JGk0PpiPkwxmq+ihOcNfrqRDnwmHoigv2tF96g==
X-Google-Smtp-Source: APXvYqzQnZJK6locyARjrnTPWygMC68+xT/2wddNBsIcOxIE2NHQLBxjLMW4a7ENxNYUO+uupEP5Jx85MgzUb73QrME=
X-Received: by 2002:a5e:de0d:: with SMTP id e13mr3368687iok.144.1565709156970;
 Tue, 13 Aug 2019 08:12:36 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000004c2416058c594b30@google.com> <24282.1562074644@warthog.procyon.org.uk>
 <CACT4Y+YjdV8CqX5=PzKsHnLsJOzsydqiq3igYDm_=nSdmFo2YQ@mail.gmail.com>
 <20330.1564583454@warthog.procyon.org.uk> <CACT4Y+Y4cRgaRPJ_gz_53k85inDKq+X+bWmOTv1gPLo=Yod1=A@mail.gmail.com>
 <22318.1564586386@warthog.procyon.org.uk> <CACT4Y+bjLBwVK_6fz2H8fXm0baAVX+vRJ4UbVWG_7yNUO-SOUg@mail.gmail.com>
 <3135.1565706180@warthog.procyon.org.uk> <CACT4Y+YCB3o5Ps9RNq9KpMcmGCwBM4R9DeX67prQ9Q3UppGowQ@mail.gmail.com>
 <8013.1565708810@warthog.procyon.org.uk>
In-Reply-To: <8013.1565708810@warthog.procyon.org.uk>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 13 Aug 2019 17:12:24 +0200
Message-ID: <CACT4Y+YVyaTrwpaZfpfi9LKA=5TOdKSL60pjAH04dMPNCZTMSQ@mail.gmail.com>
Subject: Re: kernel BUG at net/rxrpc/local_object.c:LINE!
To:     David Howells <dhowells@redhat.com>
Cc:     syzbot <syzbot+1e0edc4b8b7494c28450@syzkaller.appspotmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 5:06 PM David Howells <dhowells@redhat.com> wrote:
>
> Dmitry Vyukov <dvyukov@google.com> wrote:
>
> > > I meant that I don't know how to turn a tracepoint on from inside the kernel.
> >
> > This /sys/kernel/debug/tracing/events/rxrpc/rxrpc_local/enable in:
> >         echo 1 > /sys/kernel/debug/tracing/events/rxrpc/rxrpc_local/enable
> > should map to some global variable, right? If so, it should be
> > possible to initialize that var to 1 statically. Or that won't work
> > for some reason?
>
> As I understand it, it's all hidden inside of tracing macros and ftrace
> infrastructure and involves runtime patching the code to enable tracepoints
> (they're effectively NOP'ed out when not in use).
>
> So, no, it's not that simple.
>
> I asked Steven and he says:
>
>         trace_set_clr_event("sched", "sched_switch", 1);
>
> is the same as
>
>         echo 1 > events/sched/sched_switch/enable
>
> So it can be done.  Will syzbot actually collect the trace log?

It only collects console output. I don't know what is trace log. If
the trace log is not console output, then it won't.
