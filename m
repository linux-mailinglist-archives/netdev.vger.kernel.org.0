Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EE7241DBD
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 18:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgHKQCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 12:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728906AbgHKQCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 12:02:13 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFECC06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 09:02:12 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id z17so11060936ill.6
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 09:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HkmovgQ9IKXrubXlD0JfDcn0SKxvOQL705kqGZUtmxM=;
        b=EQX3NuLaJpz6uZe5eZqG7wJY2ykUK79ohnGJ45rZqX2do1pI7AFeEW/JNQXthEvi2l
         J/q/7CiNXD5H+nvSaedAmZG1jUPfNvrIq6/Di0teIZtH7S2dQ5dEpswuF9kK6b/zCe2v
         BuWbjpg5LX+zWVpJOPGvuYIQY33T8JQe8I2ETHmHNCcedQoL+YJt1wOwsUQDZvNykEUn
         3pmeRc4ZH58HZzMMyNyEjrIRk5g97fwQHTrrHOMQ0eMen+ygd1Idyz+ipadiwlj1lRZA
         yhlAoo2qhXMQzCJXVc/v+KzbmXhnLQ2hjDax7Viaw4kqHq/sAVztlJty7ISy9c4NmtYd
         F2Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HkmovgQ9IKXrubXlD0JfDcn0SKxvOQL705kqGZUtmxM=;
        b=GcXG4aLEqIh7HJp2TqO+ZA3fmLJNQ+0JPrPVfdELOm6716+l2YF73d/MyWiV1acAaP
         pWWGF9u7gQyYIADlJsbCt7i6x1aGOJ/I4HmgBOJtCtkAWkX8sk5D2OnN9vJDSf3NR2it
         wifUDM8k6nuVQoTySuEEatwUWo1i03u652YKS5N60znSVty/izm9ysOxQ0NDa6ZKg+E8
         NLx1vg1WU6y3nHHy6IEH178k1x8lSxf3Wd8qXYq6fa5uDGQHXWPvWT5BJf8cH21rk3mn
         gdoNmwXJ4G0i6vOGgHYcc4pP/ap+H+BD+T9K0iSex6dPPPY6OXyaNqQwHz66QRoaKjdP
         JgPA==
X-Gm-Message-State: AOAM531x16eP0/Dth9PjvI0Z5Xjj6J0e2XKIJs8mlc68PHi2LE7yBogI
        Em3JcVCD+lDN7ObxD/Odl8wWOlfQzu3ks7Abrps5JA==
X-Google-Smtp-Source: ABdhPJyyhURH3XMJ38HRQoJMT8ZhxQI1lbgsQZ6u694707OkTappFATPFzCBt8fL/f1iC2nTsVdglnDiu7b7NBi/vsw=
X-Received: by 2002:a05:6e02:dc3:: with SMTP id l3mr24140267ilj.137.1597161730733;
 Tue, 11 Aug 2020 09:02:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200808152628.GA27941@SDF.ORG> <20200808174451.GA7429@1wt.eu>
 <CAHk-=wjeRgAoKXo-oPOjLTppYOo5ZpXFG7h6meQz6-tP0gQuNg@mail.gmail.com>
 <20200808204729.GD27941@SDF.ORG> <CAHk-=whU-3rEAY551DeDsuVsZgLXyq37JX1kCvDzQFnuKzUXew@mail.gmail.com>
 <20200808222752.GG27941@SDF.ORG> <CAHk-=wh00nvUwT-yck2gt3eKgix-mBZ4RcGe1WJ6C5VDW4e6zw@mail.gmail.com>
In-Reply-To: <CAHk-=wh00nvUwT-yck2gt3eKgix-mBZ4RcGe1WJ6C5VDW4e6zw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 11 Aug 2020 09:01:58 -0700
Message-ID: <CANn89iJ-TC43k58BR63hQ-MEy1Civ=T5VWk50pBb+9QG9Kyy7A@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     George Spelvin <lkml@sdf.org>, Willy Tarreau <w@1wt.eu>,
        Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Marc Plumb <lkml.mplumb@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 8, 2020 at 7:07 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, Aug 8, 2020 at 3:28 PM George Spelvin <lkml@sdf.org> wrote:
> >
> > It's not a theoretical hole, it's a very real one.  Other than the cycles
> > to do the brute-force part, it's not even all that complicated.  The
> > theory part is that it's impossible to patch.
>
> We'll just disagree.
>
> I'm really fed up with security holes that are brought on by crypto
> people not being willing to just do reasonable things.
>
> > *If* you do the stupid thing.  WHICH YOU COULD JUST STOP DOING.
>
> We're not feeding all the same bits to the /dev/random that we're
> using to also update the pseudo-random state, so I think you're
> overreacting. Think of it as "/dev/random gets a few bits, and prandom
> gets a few other bits".
>
> The fact that there is overlap between the bits is immaterial, when
> other parts are disjoint. Fractonal bits of entropy and all that.
>
> > The explain it to me.  What is that actual *problem*?  Nobody's described
> > one, so I've been guessing.  What is this *monumentally stupid* abuse of
> > /dev/random allegedly fixing?
>
> The problem is that the networking people really want unguessable
> random state. There was a remote DNS spoofing poisoning attack because
> the UDP ports ended up being guessable.
>
> And that was actually reported to us back in early March.
>

Another typical use of prandom_u32() is the one in
tcp_conn_request(), when processing a SYN packet.

My fear was that adding much more cpu cycles to prandom_u32() would
reduce our ability to cope with a SYN flood attack,
but looking more closely to tcp_conn_request(), there might be a way
to remove the prandom_u32() call
when we generate a syncookie, reflecting incoming skb hash (if already
populated)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 184ea556f50e35141a4be5940c692db41e09f464..fc698a8ea13b1b6a6bd952308d11414eadfa4eaf
100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6740,10 +6740,12 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
                isn = cookie_init_sequence(af_ops, sk, skb, &req->mss);
                if (!tmp_opt.tstamp_ok)
                        inet_rsk(req)->ecn_ok = 0;
+               tcp_rsk(req)->txhash = skb->hash ?: 1;
+       } else {
+               tcp_rsk(req)->txhash = net_tx_rndhash();
        }

        tcp_rsk(req)->snt_isn = isn;
-       tcp_rsk(req)->txhash = net_tx_rndhash();
        tcp_openreq_init_rwin(req, sk, dst);
        sk_rx_queue_set(req_to_sk(req), skb);
        if (!want_cookie) {


BTW we could add a trace event so that the answer to 'who is using
prandom_u32' could be easily answered.

diff --git a/include/trace/events/random.h b/include/trace/events/random.h
index 32c10a515e2d5438e8d620a0c2313aab5f849b2b..9570a10cb949b5792c4290ba8e82a077ac655069
100644
--- a/include/trace/events/random.h
+++ b/include/trace/events/random.h
@@ -307,6 +307,23 @@ TRACE_EVENT(urandom_read,
                  __entry->pool_left, __entry->input_left)
 );

+TRACE_EVENT(prandom_u32,
+
+       TP_PROTO(unsigned int ret),
+
+       TP_ARGS(ret),
+
+       TP_STRUCT__entry(
+               __field(   unsigned int, ret)
+       ),
+
+       TP_fast_assign(
+               __entry->ret = ret;
+       ),
+
+       TP_printk("ret=%u" , __entry->ret)
+);
+
 #endif /* _TRACE_RANDOM_H */

 /* This part must be outside protection */
diff --git a/lib/random32.c b/lib/random32.c
index 3d749abb9e80d54d8e330e07fb8b773b7bec2b83..932345323af092a93fc2690b0ebbf4f7485ae4f3
100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -39,6 +39,7 @@
 #include <linux/random.h>
 #include <linux/sched.h>
 #include <asm/unaligned.h>
+#include <trace/events/random.h>

 #ifdef CONFIG_RANDOM32_SELFTEST
 static void __init prandom_state_selftest(void);
@@ -82,6 +83,7 @@ u32 prandom_u32(void)
        u32 res;

        res = prandom_u32_state(state);
+       trace_prandom_u32(res);
        put_cpu_var(net_rand_state);

        return res;
