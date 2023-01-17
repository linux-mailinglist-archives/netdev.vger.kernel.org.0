Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4E866E563
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjAQR43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbjAQRyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:54:10 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255D01A943;
        Tue, 17 Jan 2023 09:44:10 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id ss4so69857230ejb.11;
        Tue, 17 Jan 2023 09:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TA34HdS02MGu46+TO05+/vvzp3AfhSpajSPNbjUWb7o=;
        b=PIurS4tTIDsh1LgYiZ6lAzpHwEPzQCG7diztvQt9EkhJbf1Ykj9vqpUijaMgFLv56Y
         SDaR1lWaeJnPXDOGv7DJAmdmFjv/0eIlFd7Cj5I7jvvR+FX6EI6DvvwR8Ror4P4dpQ9+
         yDdx5m6hHh2p/My1kjZycfyNmZ3z1H4RIaPTQUWgLUUK/VVkjx7hqTp4l80yYAdkx11W
         9nKB5OKNstHjdlcshEvwhHWrmxn0XlmQvOp9B9yLmcFJYAMWdpua9VV1+BWuplW8VGs4
         7Mj2/Cw1QuilDlYWWlWZ/WqSyAEhvp97koj8TgEqEKSwmxNoXJe/4PyFd0zu4prRL1ih
         OWbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TA34HdS02MGu46+TO05+/vvzp3AfhSpajSPNbjUWb7o=;
        b=b7z79Xc6KgEzIc0Y4FOvTSijC4GXGpUNtwk2e6e2ORPTnYVIKS95bkQXZlgu7TJYTU
         j6rz5UEgiri0DJ//biA/uizeubU5FqBCv9VPxndQ9ffKGUGRru4xgq1vcbXa1u8VctII
         bau7XdwIuERY1UYCRzjtreFOl4PF1yUUvZnR0PvcRPkAWP4vJVYUkK/kypACroZC6KdF
         WDReJ0/v98pDA/NKZL4YmhQHLZ5oWtIpwATTrUKEx3bfuygtx6JMt511uAosLL/eKRKQ
         61nhzqdb4Z+MsBpwTtQTcV7OYBT5wm+ky6JQnX7zCQkUyoqb15cFlMRUw7bok1PXHL8R
         jsQg==
X-Gm-Message-State: AFqh2koHDvoqXxUVDK952m5hJ0Rhs6nKwUwWGwU8FSDxESZ+PY446abn
        BH2q2DKlg+t9+Bms5+7gZ45v1pNqtEqzkbA0cWdhNPh53AZ8dw==
X-Google-Smtp-Source: AMrXdXvcUBbFCAa7TH+xHKQPMPLQYqp8b/nA9HYPJGCvSWzcMM6RY4U/9e7fssKS++Fm8Br1z8SMZZFFhg0b+uFLZrM=
X-Received: by 2002:a17:906:5e09:b0:84d:4eae:d35b with SMTP id
 n9-20020a1709065e0900b0084d4eaed35bmr268723eju.73.1673977448660; Tue, 17 Jan
 2023 09:44:08 -0800 (PST)
MIME-Version: 1.0
References: <CAL+tcoB1-MqMf3Yn_qBTbTC9UNBhVW+93j30KJ9zaangkfQHWA@mail.gmail.com>
 <20230117163413.6162-1-kuniyu@amazon.com>
In-Reply-To: <20230117163413.6162-1-kuniyu@amazon.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 18 Jan 2023 01:43:32 +0800
Message-ID: <CAL+tcoAq2ozHfgh9L7K+-uqxXNr2vUWRRve-QJzBfWQRMVT=HA@mail.gmail.com>
Subject: Re: [PATCH v5 net] tcp: avoid the lookup process failing to get sk in
 ehash table
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kernelxing@tencent.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 12:36 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Jason Xing <kerneljasonxing@gmail.com>
> Date:   Tue, 17 Jan 2023 10:15:45 +0800
> > On Tue, Jan 17, 2023 at 12:54 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > From:   Jason Xing <kerneljasonxing@gmail.com>
> > > Date:   Mon, 16 Jan 2023 18:33:41 +0800
> > > > From: Jason Xing <kernelxing@tencent.com>
> > > >
> > > > While one cpu is working on looking up the right socket from ehash
> > > > table, another cpu is done deleting the request socket and is about
> > > > to add (or is adding) the big socket from the table. It means that
> > > > we could miss both of them, even though it has little chance.
> > > >
> > > > Let me draw a call trace map of the server side.
> > > >    CPU 0                           CPU 1
> > > >    -----                           -----
> > > > tcp_v4_rcv()                  syn_recv_sock()
> > > >                             inet_ehash_insert()
> > > >                             -> sk_nulls_del_node_init_rcu(osk)
> > > > __inet_lookup_established()
> > > >                             -> __sk_nulls_add_node_rcu(sk, list)
> > > >
> > > > Notice that the CPU 0 is receiving the data after the final ack
> > > > during 3-way shakehands and CPU 1 is still handling the final ack.
> > > >
> > > > Why could this be a real problem?
> > > > This case is happening only when the final ack and the first data
> > > > receiving by different CPUs. Then the server receiving data with
> > > > ACK flag tries to search one proper established socket from ehash
> > > > table, but apparently it fails as my map shows above. After that,
> > > > the server fetches a listener socket and then sends a RST because
> > > > it finds a ACK flag in the skb (data), which obeys RST definition
> > > > in RFC 793.
> > > >
> > > > Besides, Eric pointed out there's one more race condition where it
> > > > handles tw socket hashdance. Only by adding to the tail of the list
> > > > before deleting the old one can we avoid the race if the reader has
> > > > already begun the bucket traversal and it would possibly miss the head.
> > > >
> > > > Many thanks to Eric for great help from beginning to end.
> > > >
> > > > Fixes: 5e0724d027f0 ("tcp/dccp: fix hashdance race for passive sessions")
> > > > Suggested-by: Eric Dumazet <edumazet@google.com>
> > > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > > > Link: https://lore.kernel.org/lkml/20230112065336.41034-1-kerneljasonxing@gmail.com/
> > >
> > > I guess there could be regression if a workload has many long-lived
> >
> > Sorry, I don't understand. This patch does not add two kinds of
> > sockets into the ehash table all the time, but reverses the order of
> > deleting and adding sockets only.
>
> Not really.  It also reverses the order of sockets in ehash.  We were
> able to find newer sockets faster than older ones.  If a workload has
> many long-lived sockets, they would add constant time on newer socket's
> lookup.
>
>
> > The final result is the same as the
> > old time. I'm wondering why it could cause some regressions if there
> > are loads of long-lived connections.
> >
> > > connections, but the change itself looks good.  I left a minor comment
> > > below.
> > >
> > > Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > >
> >
> > Thanks for reviewing :)
> >
> > >
> > > > ---
> > > > v5:
> > > > 1) adjust the style once more.
> > > >
> > > > v4:
> > > > 1) adjust the code style and make it easier to read.
> > > >
> > > > v3:
> > > > 1) get rid of else-if statement.
> > > >
> > > > v2:
> > > > 1) adding the sk node into the tail of list to prevent the race.
> > > > 2) fix the race condition when handling time-wait socket hashdance.
> > > > ---
> > > >  net/ipv4/inet_hashtables.c    | 17 +++++++++++++++--
> > > >  net/ipv4/inet_timewait_sock.c |  6 +++---
> > > >  2 files changed, 18 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > > > index 24a38b56fab9..f58d73888638 100644
> > > > --- a/net/ipv4/inet_hashtables.c
> > > > +++ b/net/ipv4/inet_hashtables.c
> > > > @@ -650,8 +650,20 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
> > > >       spin_lock(lock);
> > > >       if (osk) {
> > > >               WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
> > > > -             ret = sk_nulls_del_node_init_rcu(osk);
> > > > -     } else if (found_dup_sk) {
> > > > +             ret = sk_hashed(osk);
> > > > +             if (ret) {
> > > > +                     /* Before deleting the node, we insert a new one to make
> > > > +                      * sure that the look-up-sk process would not miss either
> > > > +                      * of them and that at least one node would exist in ehash
> > > > +                      * table all the time. Otherwise there's a tiny chance
> > > > +                      * that lookup process could find nothing in ehash table.
> > > > +                      */
> > > > +                     __sk_nulls_add_node_tail_rcu(sk, list);
> > > > +                     sk_nulls_del_node_init_rcu(osk);
> > > > +             }
> > > > +             goto unlock;
> > > > +     }
> > > > +     if (found_dup_sk) {
> > > >               *found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
> > > >               if (*found_dup_sk)
> > > >                       ret = false;
> > > > @@ -660,6 +672,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
> > > >       if (ret)
> > > >               __sk_nulls_add_node_rcu(sk, list);
> > > >
> > > > +unlock:
> > > >       spin_unlock(lock);
> > > >
> > > >       return ret;
> > > > diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> > > > index 1d77d992e6e7..6d681ef52bb2 100644
> > > > --- a/net/ipv4/inet_timewait_sock.c
> > > > +++ b/net/ipv4/inet_timewait_sock.c
> > > > @@ -91,10 +91,10 @@ void inet_twsk_put(struct inet_timewait_sock *tw)
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(inet_twsk_put);
> > > >
> > > > -static void inet_twsk_add_node_rcu(struct inet_timewait_sock *tw,
> > > > +static void inet_twsk_add_node_tail_rcu(struct inet_timewait_sock *tw,
> > > >                                  struct hlist_nulls_head *list)
> > >
> > > nit: Please indent here.
> > >
> >
> > Before I submitted the patch, I did the check through
> > ./script/checkpatch.py and it outputted some information (no warning,
> > no error) as you said.
> > The reason I didn't change that is I would like to leave this part
> > untouch as it used to be. I have no clue about whether I should send a
> > v7 patch to adjust the format if necessary.
>
> checkpatch.pl does not check everything.  You will find most functions
> under net/ipv4/*.c have same indentation in arguments.  I would recommend
> enforcing such styles on editor like
>

Well, there are two other lines which have the same indent problem.
I'm going to clean them both up as below.
1) inet_twsk_add_bind_node()
2) inet_twsk_add_bind2_node()

Thanks,
Jason

>   $ cat ~/.emacs.d/init.el
>   (setq-default c-default-style "linux")
>
> Thanks,
> Kuniyuki
>
> >
> > Thanks,
> > Jason
> >
> > >
> > > >  {
> > > > -     hlist_nulls_add_head_rcu(&tw->tw_node, list);
> > > > +     hlist_nulls_add_tail_rcu(&tw->tw_node, list);
> > > >  }
> > > >
> > > >  static void inet_twsk_add_bind_node(struct inet_timewait_sock *tw,
> > > > @@ -147,7 +147,7 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
> > > >
> > > >       spin_lock(lock);
> > > >
> > > > -     inet_twsk_add_node_rcu(tw, &ehead->chain);
> > > > +     inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
> > > >
> > > >       /* Step 3: Remove SK from hash chain */
> > > >       if (__sk_nulls_del_node_init_rcu(sk))
> > > > --
> > > > 2.37.3
