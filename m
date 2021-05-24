Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A16C38ECF8
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 17:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbhEXPbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 11:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbhEXP3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 11:29:25 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9602C06138B;
        Mon, 24 May 2021 07:56:21 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id f12so33988230ljp.2;
        Mon, 24 May 2021 07:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qRk6AqLkz1cLg+MPPtjVo9TuUA/8FO+AIctkgMZCtvY=;
        b=JojCDPHSJR2G3TJGhyoTK8Akdo3XxsXrLNhkecZmcbUh337Yyzz02lrsW0GQVYMpp5
         t6R2ZV5gmSS5nIqww4fFDtg2gYtR6kFOuRgizKFSU7nWjyfnFg++OftUE7LlSGW/vx00
         pty5VkI3fqsCUrHonJl1O7zhWibr9RnX6bm0XTe7bna0UyIWDHZr7Fr6QG/jxp6AqNSU
         1+tyq2zSQgGDc/ku3ZeKOemulFev2+RWNQ7ug+fSiV1xcDwWDYdGovGw+5iZo9dtoXfy
         zGMIHA3WHqmeWXDHlTRqG/6otkGyEHy6p8PArN1OYG18ZSTrF+wTTw+IQeR6QIN6pP/l
         JI0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qRk6AqLkz1cLg+MPPtjVo9TuUA/8FO+AIctkgMZCtvY=;
        b=IgdzTDLgRkDI5hrH5EltpTlnDTSKVCuXwswD9eBYVaBlMB7UFCITFFm//LlrI38tn4
         AxdjLo9xDtSToagVq2YbFf8OtQJhktQmpK/m/GNubFVyCKgJOqj014q7dIOCcSSrMjhN
         v1nJfDwrADav23GTnehQl/uSAUgsXzPaiS5obCXdTL/WPZe6+jdNNtXLJJgo+iPlMYSO
         G4p8rhLxV4uyVb6bIKz6Of30LsHJI7+Iqi7eSvM+B0bkGhAjO+WkCvRBs/yjMl/Ov/Ph
         opMwa86CZguLTn0WDWthg6kAxs08lE0kMME1zCki/JrXwtVsjXNdvv6K8hyGCv+YT8ZV
         sWhg==
X-Gm-Message-State: AOAM530jy7fS4FCMm3Tg+mbJI0kz6XBu8W5rVqCbWksjBi30SbnJMMji
        XxPm4MVqNY4W9kPZ1DmBx3WKIDUluNvFgUOCNXA=
X-Google-Smtp-Source: ABdhPJx/Lk5O8yir1fik+p/q8G2VZh5wx5CBLrIjRh6uHFDQo0yiluxTN2Yq1uI9d03caztC9oPuIQVLsvjuiRWBWGU=
X-Received: by 2002:a2e:b610:: with SMTP id r16mr16812675ljn.486.1621868180328;
 Mon, 24 May 2021 07:56:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com> <CACAyw9-7dPx1vLNQeYP9Zqx=OwNcd2t1VK3XGD_aUZZG-twrOg@mail.gmail.com>
In-Reply-To: <CACAyw9-7dPx1vLNQeYP9Zqx=OwNcd2t1VK3XGD_aUZZG-twrOg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 24 May 2021 07:56:09 -0700
Message-ID: <CAADnVQLqa6skQKsUK=LO5JDZr8xM_rwZPOgA1F39UQRim1P8vw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 4:50 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Thu, 20 May 2021 at 19:55, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Introduce 'struct bpf_timer' that can be embedded in most BPF map types
> > and helpers to operate on it:
> > long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)
> > long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> > long bpf_timer_del(struct bpf_timer *timer)
>
> I like invoking the callback with a pointer to the map element it was
> defined in, since it solves lifetime of the context and user space
> introspection of the same. I'm not so sure about being able to put it
> into all different kinds of maps, is that really going to be used?

Certainly. At least in array and hash maps.
The global data is an array.
A single global timer is a simple and easy to use pattern.

>
> It would be useful if Cong Wang could describe their use case, it's
> kind of hard to tell what the end goal is. Should user space be able
> to create and arm timers? Or just BPF? In the other thread it seems
> like a primitive for waiting on a timer is proposed. Why? It also begs
> the question how we would wait on multiple timers.

In the proposed api the same callback can be invoked for multiple timers.
The user space can create/destroy timers via prog_run cmd.
It will also destroy timers by map_delete_elem cmd.

> > + *
> > + * long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)
>
> In your selftest the callback has a type (int)(*callback)(struct
> bpf_map *map, int *key, struct map_elem *val).

Correct. I'll update the comment.

> > + *     Description
> > + *             Initialize the timer to call given static function.
> > + *     Return
> > + *             zero
> > + *
> > + * long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> > + *     Description
> > + *             Set the timer expiration N msecs from the current time.
> > + *     Return
> > + *             zero
> > + *
> > + * long bpf_timer_del(struct bpf_timer *timer)
> > + *     Description
> > + *             Deactivate the timer.
> > + *     Return
> > + *             zero
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)          \
> >         FN(unspec),                     \
> > @@ -4932,6 +4950,9 @@ union bpf_attr {
> >         FN(sys_bpf),                    \
> >         FN(btf_find_by_name_kind),      \
> >         FN(sys_close),                  \
> > +       FN(timer_init),                 \
> > +       FN(timer_mod),                  \
> > +       FN(timer_del),                  \
> >         /* */
>
> How can user space force stopping of timers (required IMO)?

We can add new commands, of course, but I don't think it's
necessary, since test_run can be used to achieve the same
and map_delete_elem will stop them too.

> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > @@ -6038,6 +6059,10 @@ struct bpf_spin_lock {
> >         __u32   val;
> >  };
> >
> > +struct bpf_timer {
> > +       __u64 opaque;
> > +};
> > +
>
> This might be clear already, but we won't be able to modify the size
> of bpf_timer later since it would break uapi, right?

Correct. The internal implementation can change. The 'opaque'
is just the pointer to the internal struct.
When do you think we'd need to change this uapi struct?
