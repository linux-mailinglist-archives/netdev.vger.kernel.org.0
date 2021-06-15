Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FF43A767F
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 07:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhFOFdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 01:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhFOFdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 01:33:42 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8412C061574;
        Mon, 14 Jun 2021 22:31:38 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id p184so18711589yba.11;
        Mon, 14 Jun 2021 22:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vCAAD8dFLhLIw0l9zI/dZbevKEGS7pIIm9uUJPvGPk0=;
        b=dBlpxsDlLDJjLMrqPUHF93B4x6QQQ/oX0EifiAvaSaxDAJTIV9eZcD4oggWbKt6UC7
         Z4ISz1rDqxdKRv42dgMJyM1QYHSeZfHPyCNOqFQFWGam8P4v3TzjLN1Mz06pjEfFm69q
         4nTXYt+ifp1XuTLdd4+Qtn9OLX89MRQeP0utiwJSy5Abmr7nnnOpVWHTS6dazoWqYR00
         p+bAWScvgatePOXIv+WARuxiZQP3oFj3smzkSNb8GwAg1TIZnrCJQbwYmGTOrWUqQo8w
         3GF68vX+KW3YDoCcRJNN4xt5o2WC0HkRoNztg5qRpbC92TVCMLDNxvgIBPodkvLoHLk3
         eJ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vCAAD8dFLhLIw0l9zI/dZbevKEGS7pIIm9uUJPvGPk0=;
        b=Qx+d1syqJKQyOS9dpdr5B0znU5oKshOpXJfkU2P4yaJ7UXmrUH8QjVvse2lKL/YzyL
         PxOfkGVWc3gswpY+pyzVaIoMw9eInlEiRafrKAyMltMzZhNov4/txba/gw/trvGgI+WA
         CyELRhtbOy+PFviEXcRGUrI+eBmG7ym8z7ZVGlGk9oG53Fufv+OoPrnTFt9+zoC/6b3m
         LxgpmEa/2klnUnf7lA3oLOqweQF/Ewb4deU5HJk5kFPz8goEEJ3H+8c//Ua2vJKiMOfS
         Nv/eGyD/7vb5bkU2Zk0ghx8C9wCNDej7LfVYXm2LTTmkJI0DmsB/eyNuDmtW2T+gjk9w
         GgaQ==
X-Gm-Message-State: AOAM533eHgOKgiEmypGwNBkEkv82j+upgdrCwP8Co5zYdghUhX9Kbbr2
        JkD1UdgjmewjwNjZX8W2t6D09eDHVPsDzztTyt4=
X-Google-Smtp-Source: ABdhPJyPWMS+S8pvf6KmyTWiR82iqihph/NUiB49mxdV++ZfRhiZonizCqYfOmHfsTXra0TpQUAIz4IPxs16LzSeCMQ=
X-Received: by 2002:a25:6612:: with SMTP id a18mr30457260ybc.347.1623735098122;
 Mon, 14 Jun 2021 22:31:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
 <20210611042442.65444-2-alexei.starovoitov@gmail.com> <9b23b2c6-28b2-3ab3-4e8b-1fa0c926c4d2@fb.com>
 <CAADnVQLS=Jx9=znx6XAtrRoY08bTQHTipXQwvnPNo0SRSJsK0Q@mail.gmail.com>
In-Reply-To: <CAADnVQLS=Jx9=znx6XAtrRoY08bTQHTipXQwvnPNo0SRSJsK0Q@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Jun 2021 22:31:27 -0700
Message-ID: <CAEf4BzZ159NfuGJo0ig9i=7eGNgvQkq8TnZi09XHSZST17A0zQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 8:29 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jun 14, 2021 at 9:51 AM Yonghong Song <yhs@fb.com> wrote:
> > > +     ret = BPF_CAST_CALL(t->callback_fn)((u64)(long)map,
> > > +                                         (u64)(long)key,
> > > +                                         (u64)(long)t->value, 0, 0);
> > > +     WARN_ON(ret != 0); /* Next patch disallows 1 in the verifier */
> >
> > I didn't find that next patch disallows callback return value 1 in the
> > verifier. If we indeed disallows return value 1 in the verifier. We
> > don't need WARN_ON here. Did I miss anything?
>
> Ohh. I forgot to address this bit in the verifier. Will fix.
>
> > > +     if (!hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer))
> > > +             /* If the timer wasn't active or callback already executing
> > > +              * bump the prog refcnt to keep it alive until
> > > +              * callback is invoked (again).
> > > +              */
> > > +             bpf_prog_inc(t->prog);
> >
> > I am not 100% sure. But could we have race condition here?
> >     cpu 1: running bpf_timer_start() helper call
> >     cpu 2: doing hrtimer work (calling callback etc.)
> >
> > Is it possible that
> >    !hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer)
> > may be true and then right before bpf_prog_inc(t->prog), it becomes
> > true? If hrtimer_callback_running() is called, it is possible that
> > callback function could have dropped the reference count for t->prog,
> > so we could already go into the body of the function
> > __bpf_prog_put()?
>
> you're correct. Indeed there is a race.
> Circular dependency is a never ending headache.
> That's the same design mistake as with tail_calls.
> It felt that this case would be simpler than tail_calls and a bpf program
> pinning itself with bpf_prog_inc can be made to work... nope.
> I'll get rid of this and switch to something 'obviously correct'.
> Probably a link list with a lock to keep a set of init-ed timers and
> auto-cancel them on prog refcnt going to zero.
> To do 'bpf daemon' the prog would need to be pinned.

Hm.. wouldn't this eliminate that race:

switch (hrtimer_try_to_cancel(&t->timer))
{
case 0:
    /* nothing was queued */
    bpf_prog_inc(t->prog);
    break;
case 1:
    /* already have refcnt and it won't be bpf_prog_put by callback */
    break;
case -1:
    /* callback is running and will bpf_prog_put, so we need to take
another refcnt */
    bpf_prog_inc(t->prog);
    break;
}
hrtimer_start(&t->timer, ns_to_ktime(nsecs), HRTIMER_MODE_REL_SOFT);

So instead of guessing (racily) whether there is a queued callback or
not, try to cancel just in case there is. Then rely on the nice
guarantees that hrtimer cancellation API provides.

Reading a bit more of hrtimer API, I'm more concerned now with the
per-cpu variable (hrtimer_running). Seems like the timer can get
migrated from one CPU to another, so all the auxiliary per-CPU state
might get invalidated without us knowing about that.

But it's getting late, I'll think about all this a bit more tomorrow
with a fresh head.

>
> > > +     if (val) {
> > > +             /* This restriction will be removed in the next patch */
> > > +             verbose(env, "bpf_timer field can only be first in the map value element\n");
> > > +             return -EINVAL;
> > > +     }
> > > +     WARN_ON(meta->map_ptr);
> >
> > Could you explain when this could happen?
>
> Only if there is a verifier bug or new helper is added with arg to timer
> and arg to map. I'll switch to verbose() + efault instead.
