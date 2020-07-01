Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5188A2100D1
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 02:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgGAABe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 20:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgGAABe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 20:01:34 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C28C03E979
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 17:01:33 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id d13so11014549ybk.8
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 17:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XKc0i29ur8bZ3QP5tHtJmPHNVBdp2DJUaH455nkGk4s=;
        b=GDMwtKQ+H/jIvrSzz12y4L6SpqnTjq6z16AaR9iUU/G80hyILg7zCLy8m/9ECUJPcz
         /Jr4LSIFh0xiTXtiH4+dzVwzmNoC2mNW0f2ZwiHzBYeN2rnNPDFeVd7Q0cSynOMxPaar
         p64b73DOlTJf8SxO5xsnR9UsOUJVdYJQLM9yWP1WUZvCylChUXX67KJ8dKVtufyzq9rb
         5/N0moL9Yhk8Vh9rqWTyIHh9k+2jKEEByttbH1Ww166ld0CzLMdNTXHMobgYIA96gJOJ
         BT3GHsN0NTZS8qQONc/Z4oEU2ifY8LDigwIzT+wanKzBSNKD7DbZyIRT0Oy9FpFqJnBr
         Xjng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XKc0i29ur8bZ3QP5tHtJmPHNVBdp2DJUaH455nkGk4s=;
        b=jhQeoMci6JuND1ip10m3079o34kGOJQszn6C9XDV225S+u/pbmQh4rVqf3jZVb+gIh
         lFbwAf6RpxnV/NzZDUzAWL9cN+NE1gcLgudBcKNLw+/Q0ka+eygw7qTjFf8OlFYRRRe7
         njgVlGo8DPQ6GYsnvywaeQDXRPgHsmmJagkDk0e7zRxZlo0t/jTqU4PBGcB4YA3oB+NK
         WqaWNtCc1ifT1C5oe3JpNR92bf7n7JNLA+EH5FQIdCtp618KF54Y5i+vWmtVjOgyTXhH
         CmsFXukCZEZ1mt44E3yFrOs7JX/AbJxp6cXkD2JUR3YzMHH2SzGckyxGa+ad2kDBeW1h
         4ATw==
X-Gm-Message-State: AOAM531LcxLydd8TnrQSoAxsWWSf2VT+SGZ5gbco1MHLEKjCjInKJpTG
        kQwWDH/FNY1qw4QZB2nJUTOTJUwDnY+pqmuFKg3bZA==
X-Google-Smtp-Source: ABdhPJzwiaAEoJlLUXgcx2Je5sfgdYP4Cc3XmW/lp0GaOLJvy1YnkiYPkJ/Z8tot1orkQMc/4IM9t5rSuo3ymSVkN9w=
X-Received: by 2002:a25:b7cc:: with SMTP id u12mr22675401ybj.173.1593561692346;
 Tue, 30 Jun 2020 17:01:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjEghg5_pX_GhNP+BfcUK6CRZ+4mh3bciitm9JwXvR7aQ@mail.gmail.com>
 <20200630.134429.1590957032456466647.davem@davemloft.net> <CANn89i+b-LeaPvaaHvj0yc0mJ2qwZ0981fQHVp0+sqXYp=kdkA@mail.gmail.com>
 <474095696.17969.1593551866537.JavaMail.zimbra@efficios.com>
 <CANn89iKK2+pznYZoKZzdCu4qkA7BjJZFqc6ABof4iaS-T-9_aw@mail.gmail.com>
 <CANn89i+_DUrKROb1Zkk_nmngkD=oy9UjbxwnkgyzGB=z+SKg3g@mail.gmail.com>
 <CANn89iJJ_WR-jGQogU3-arjD6=xcU9VWzJYSOLbyD94JQo-zAQ@mail.gmail.com>
 <CANn89iLPqtJG0iESCHF+RcOjo95ukan1oSzjkPjoSJgKpO2wSQ@mail.gmail.com> <416125262.18159.1593560661355.JavaMail.zimbra@efficios.com>
In-Reply-To: <416125262.18159.1593560661355.JavaMail.zimbra@efficios.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Jun 2020 17:01:20 -0700
Message-ID: <CANn89iKjggLK8u=E-1guVUuvO4cV3JY4bXcw63We1rNqTyWixA@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     paulmck <paulmck@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 4:44 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> ----- On Jun 30, 2020, at 6:38 PM, Eric Dumazet edumazet@google.com wrote:
> [...]
> >
> > For updates of keys, it seems existing code lacks some RCU care.
> >
> > MD5 keys use RCU for lookups/hashes, but the replacement of a key does
> > not allocate a new piece of memory.
>
> How is that RCU-safe ?
>
> Based on what I see here:
>
> tcp_md5_do_add() has a comment stating:
>
> "/* This can be called on a newly created socket, from other files */"
>
> which appears to be untrue if this can indeed be called on a live socket.

"This can be called" is not the same than "this is always called for
newly created socket"

>
> The path for pre-existing keys does:
>
>         key = tcp_md5_do_lookup_exact(sk, addr, family, prefixlen, l3index);
>         if (key) {
>                 /* Pre-existing entry - just update that one. */
>                 memcpy(key->key, newkey, newkeylen);
>                 key->keylen = newkeylen;
>                 return 0;
>         }
>
> AFAIU, this works only if you assume there are no concurrent readers
> accessing key->key, else they can see a corrupted key.

This is fine.

>
> The change you are proposing adds smp_wmb/smp_rmb to pair stores
> to key before key_len with loads of key_len before key. I'm not sure
> what this is trying to achieve, and how it prevents the readers from
> observing a corrupted state if the key is updated on a live socket ?



By definition if you change the MD5 key on a socket while packets are
flying, the incoming packet could either

1) See old key (packet is dropped)
2) See new key.

So any other decision (catching intermediate state) is really not an
issue, since you already accepted the fact that a packet could be
dropped,
and TCP will retransmit.

TCP MD5 implementation does not support multiple keys  for one flow,
you can not have both old and new keys being checked.


>
> Based on my understanding, this path which deals with pre-existing keys
> in-place should only ever be used when there are no concurrent readers,
> else a new memory allocation would be needed to guarantee that readers
> always observe a valid copy.

This is not _needed,_ and since memory allocations can fail, we would
potentially break applications
assuming that changing MD5 key would never fail.

Patch has been sent for review on netdev@ (
https://patchwork.ozlabs.org/project/netdev/patch/20200630234101.3259179-1-edumazet@google.com/
)
