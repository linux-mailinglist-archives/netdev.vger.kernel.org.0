Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43BC63A7526
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 05:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhFODbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 23:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhFODbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 23:31:49 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1651C061574;
        Mon, 14 Jun 2021 20:29:44 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id d2so22897465ljj.11;
        Mon, 14 Jun 2021 20:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IXQWaYly8JM4VmslPhoY/L6f5WRG/3PghUxhYVVe4TQ=;
        b=owNKoxVx9EzVp8r8fXJSCNE2CGbITHw7vfEKqZkwWV+BU8v7gZq+GjDrVwQ/iU3ICj
         NFFZMJa7kTW8nHw7PpR4nWLNoDu/C8n8ZH4Fq43ra/cQdJH1CkRa8d/RA4TyWxMDLqZX
         S85Uxba535Z6aY0X6H+2C+QEEDKmFb4wpSbumOfYwT1luH302JNFe6sd+uUiNZj5sEz+
         s3bg/krQO/ORC0yOJc12FcKBBdR1CULG8oLpTQomPi/2UzWHxysOIHRKdxAUw4gNeFZT
         QnMUN7jEQ9rpUq68UpiCjTee4hjR82xGIEtKgqx3qggKbps+5XFe60INonFfFW1QrjXM
         S1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IXQWaYly8JM4VmslPhoY/L6f5WRG/3PghUxhYVVe4TQ=;
        b=fXuqLVf1SIJBVSJZ7rAja3sDDugkl3+qoWT/okdgrF+lhrLBH2IzLL89jMparD36YM
         OGrCdG6FviLYmX9Qn6aN1aMo8Xjb4avvpChpwXnZsZCG2ticAjy51fHrdbosRISAP1Eo
         kF34s7Gw0A6581u5/xpgP0hdgqXmGZeVxu9pwa2dO5nrS3n2WkuAuEjO6JPQ0DnTogq3
         /uWMGPzfKlYoBFUVYwptuuAmgm6G4WxwjynX30jNrorKmjzSDFBnMHWaJ8Ch3eZlqxvy
         +Z06Z6yfAerAHZ/7wsNviwaBHd8/QSu/N1XY1Sm0GlMLqQLIIMUnjUSoplXd+d7zccWz
         abbA==
X-Gm-Message-State: AOAM530qR1jaRqfNsSV2vAFR8JYTIbr0E0yuXHPQVKOCzlQ25CHZnbhQ
        ls7w5GDzJOPEujYQxzm8X1VpwtUDJIWvVly/LR4=
X-Google-Smtp-Source: ABdhPJyoP8EIaBnGrO30rKf+pq5dHlcP6NxDCPJUC8K2vlIeK8JBCl5+3w3SkMtIzMEbbiRNqh3QXvuUqWOJuBCb2ho=
X-Received: by 2002:a2e:a4a5:: with SMTP id g5mr15353735ljm.32.1623727783201;
 Mon, 14 Jun 2021 20:29:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
 <20210611042442.65444-2-alexei.starovoitov@gmail.com> <9b23b2c6-28b2-3ab3-4e8b-1fa0c926c4d2@fb.com>
In-Reply-To: <9b23b2c6-28b2-3ab3-4e8b-1fa0c926c4d2@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 14 Jun 2021 20:29:31 -0700
Message-ID: <CAADnVQLS=Jx9=znx6XAtrRoY08bTQHTipXQwvnPNo0SRSJsK0Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
To:     Yonghong Song <yhs@fb.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 9:51 AM Yonghong Song <yhs@fb.com> wrote:
> > +     ret = BPF_CAST_CALL(t->callback_fn)((u64)(long)map,
> > +                                         (u64)(long)key,
> > +                                         (u64)(long)t->value, 0, 0);
> > +     WARN_ON(ret != 0); /* Next patch disallows 1 in the verifier */
>
> I didn't find that next patch disallows callback return value 1 in the
> verifier. If we indeed disallows return value 1 in the verifier. We
> don't need WARN_ON here. Did I miss anything?

Ohh. I forgot to address this bit in the verifier. Will fix.

> > +     if (!hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer))
> > +             /* If the timer wasn't active or callback already executing
> > +              * bump the prog refcnt to keep it alive until
> > +              * callback is invoked (again).
> > +              */
> > +             bpf_prog_inc(t->prog);
>
> I am not 100% sure. But could we have race condition here?
>     cpu 1: running bpf_timer_start() helper call
>     cpu 2: doing hrtimer work (calling callback etc.)
>
> Is it possible that
>    !hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer)
> may be true and then right before bpf_prog_inc(t->prog), it becomes
> true? If hrtimer_callback_running() is called, it is possible that
> callback function could have dropped the reference count for t->prog,
> so we could already go into the body of the function
> __bpf_prog_put()?

you're correct. Indeed there is a race.
Circular dependency is a never ending headache.
That's the same design mistake as with tail_calls.
It felt that this case would be simpler than tail_calls and a bpf program
pinning itself with bpf_prog_inc can be made to work... nope.
I'll get rid of this and switch to something 'obviously correct'.
Probably a link list with a lock to keep a set of init-ed timers and
auto-cancel them on prog refcnt going to zero.
To do 'bpf daemon' the prog would need to be pinned.

> > +     if (val) {
> > +             /* This restriction will be removed in the next patch */
> > +             verbose(env, "bpf_timer field can only be first in the map value element\n");
> > +             return -EINVAL;
> > +     }
> > +     WARN_ON(meta->map_ptr);
>
> Could you explain when this could happen?

Only if there is a verifier bug or new helper is added with arg to timer
and arg to map. I'll switch to verbose() + efault instead.
