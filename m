Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65693E4A23
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 18:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbhHIQms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 12:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhHIQmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 12:42:47 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9804FC0613D3;
        Mon,  9 Aug 2021 09:42:26 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id a201so30639433ybg.12;
        Mon, 09 Aug 2021 09:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4UD967RcjbxyD35Ue9BbSVa+PVHU86PK1T77CUN9OWc=;
        b=siw2kCOOntvOHok2OZvJ3cP0wQ5FUaNTsZZ0JdXNIrcGUjPO7ZZgojwSA/mfGlqFZ/
         esYG89m+I6+mXKXM7Wvp+tOResfzbCDWRN0tja1qv0dwunAJ+Wgp1oqoH/X2Srjm/2io
         2D5RRHIcBk9UolXuAZxFpCbeZ7S90c2ljg9nqgP650XQTHeP2bTmWYsNRNgB9ftzfYk4
         g5RUBIp4RgtyLtDkGm+Zz8rxpyFfKASu2jLrNEjovg5lqgBH0UM7N4CyeroLeUQo/uCM
         9tPpNiLErY0kLBs85AV9QBJCxQ6hR9GEWkqylS58+By4dwBobamWrcPyJANZhOQiyTrF
         p7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4UD967RcjbxyD35Ue9BbSVa+PVHU86PK1T77CUN9OWc=;
        b=C2cWSqLiuBClTq87HlUAjVDZZIsnnsSSHK4xLcK272sWakUB16dYYbO5i0hIaeJNjw
         UlEZOW6ufOmMFefZvWAemKHU0x+gLOhd4AaGKGGpvMQoVdkpEPR2HY5F+oY1oRnsJ8jJ
         LgFwdFSmI1ym0byB/Bh6BZiw3bBLLfU4XGufDUT/9sK1VUUqqIINsLLFyP+S2FPQRKv5
         +8jtaaTBN08+jam1naWXzKHp35SSKBlJvc+K+wM61FQCjbs6UZw15dV3omvCob9EGaiD
         UXIJOC7pCUAJ9iiG8CSnCyxfI9ggps7zI6KcRhMi/UvXhlVtS91uUgHmedXx8Y+sfsIh
         B8ww==
X-Gm-Message-State: AOAM5336Z08aMjSyOQ9pYOlqmdywQ4XIoHhX/vbowEKigJ/QB8DgBId5
        x1NS6jEUMSRDvE/1I8oQlUa4B3VDV14ktjuQOoc=
X-Google-Smtp-Source: ABdhPJxyXf9BPtX7V36e3R1B7Vlb5SL2jCeCA+q8HG99AmGOBhK704STyMNnRdJ/RoVI4jjMlu8JCEePheYE3Ze8t6Y=
X-Received: by 2002:a25:9b03:: with SMTP id y3mr30133017ybn.264.1628527345735;
 Mon, 09 Aug 2021 09:42:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210804154712.929986-1-desmondcheongzx@gmail.com>
 <20210804154712.929986-2-desmondcheongzx@gmail.com> <CABBYNZ+5-wEyLJDUU0fC3fogAkJiXD+8np_8c_M0yfYZVUYbww@mail.gmail.com>
 <0fc64ddd-45f0-667f-b8cb-bd958280586f@gmail.com>
In-Reply-To: <0fc64ddd-45f0-667f-b8cb-bd958280586f@gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 9 Aug 2021 09:42:14 -0700
Message-ID: <CABBYNZ+21nHQ5j+B2WBgJoZRiZckhKhbiQ8y=-MGqojtO_p47Q@mail.gmail.com>
Subject: Re: [RESEND PATCH v5 1/6] Bluetooth: schedule SCO timeouts with delayed_work
To:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, sudipm.mukherjee@gmail.com,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        skhan@linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Desmond,

On Sun, Aug 8, 2021 at 9:04 PM Desmond Cheong Zhi Xi
<desmondcheongzx@gmail.com> wrote:
>
> On 6/8/21 3:06 am, Luiz Augusto von Dentz wrote:
> > Hi Desmond,
> >
> > On Wed, Aug 4, 2021 at 8:48 AM Desmond Cheong Zhi Xi
> > <desmondcheongzx@gmail.com> wrote:
> >>
> >> struct sock.sk_timer should be used as a sock cleanup timer. However,
> >> SCO uses it to implement sock timeouts.
> >>
> >> This causes issues because struct sock.sk_timer's callback is run in
> >> an IRQ context, and the timer callback function sco_sock_timeout takes
> >> a spin lock on the socket. However, other functions such as
> >> sco_conn_del and sco_conn_ready take the spin lock with interrupts
> >> enabled.
> >>
> >> This inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} lock usage could
> >> lead to deadlocks as reported by Syzbot [1]:
> >>         CPU0
> >>         ----
> >>    lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
> >>    <Interrupt>
> >>      lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
> >>
> >> To fix this, we use delayed work to implement SCO sock timouts
> >> instead. This allows us to avoid taking the spin lock on the socket in
> >> an IRQ context, and corrects the misuse of struct sock.sk_timer.
> >>
> >> As a note, cancel_delayed_work is used instead of
> >> cancel_delayed_work_sync in sco_sock_set_timer and
> >> sco_sock_clear_timer to avoid a deadlock. In the future, the call to
> >> bh_lock_sock inside sco_sock_timeout should be changed to lock_sock to
> >> synchronize with other functions using lock_sock. However, since
> >> sco_sock_set_timer and sco_sock_clear_timer are sometimes called under
> >> the locked socket (in sco_connect and __sco_sock_close),
> >> cancel_delayed_work_sync might cause them to sleep until an
> >> sco_sock_timeout that has started finishes running. But
> >> sco_sock_timeout would also sleep until it can grab the lock_sock.
> >>
> >> Using cancel_delayed_work is fine because sco_sock_timeout does not
> >> change from run to run, hence there is no functional difference
> >> between:
> >> 1. waiting for a timeout to finish running before scheduling another
> >> timeout
> >> 2. scheduling another timeout while a timeout is running.
> >>
> >> Link: https://syzkaller.appspot.com/bug?id=9089d89de0502e120f234ca0fc8a703f7368b31e [1]
> >> Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
> >> Tested-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
> >> Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
> >> ---
> >>   net/bluetooth/sco.c | 41 +++++++++++++++++++++++++++++++++++------
> >>   1 file changed, 35 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> >> index ffa2a77a3e4c..89cb987ca9eb 100644
> >> --- a/net/bluetooth/sco.c
> >> +++ b/net/bluetooth/sco.c
> >> @@ -48,6 +48,8 @@ struct sco_conn {
> >>          spinlock_t      lock;
> >>          struct sock     *sk;
> >>
> >> +       struct delayed_work     timeout_work;
> >> +
> >>          unsigned int    mtu;
> >>   };
> >>
> >> @@ -74,9 +76,20 @@ struct sco_pinfo {
> >>   #define SCO_CONN_TIMEOUT       (HZ * 40)
> >>   #define SCO_DISCONN_TIMEOUT    (HZ * 2)
> >>
> >> -static void sco_sock_timeout(struct timer_list *t)
> >> +static void sco_sock_timeout(struct work_struct *work)
> >>   {
> >> -       struct sock *sk = from_timer(sk, t, sk_timer);
> >> +       struct sco_conn *conn = container_of(work, struct sco_conn,
> >> +                                            timeout_work.work);
> >> +       struct sock *sk;
> >> +
> >> +       sco_conn_lock(conn);
> >> +       sk = conn->sk;
> >> +       if (sk)
> >> +               sock_hold(sk);
> >> +       sco_conn_unlock(conn);
> >> +
> >> +       if (!sk)
> >> +               return;
> >>
> >>          BT_DBG("sock %p state %d", sk, sk->sk_state);
> >>
> >> @@ -91,14 +104,27 @@ static void sco_sock_timeout(struct timer_list *t)
> >>
> >>   static void sco_sock_set_timer(struct sock *sk, long timeout)
> >>   {
> >> +       struct delayed_work *work;
> >
> > Minor nitpick but I don't think using a dedicated variable here makes
> > much sense.
> >
>
> Thanks for the feedback, Luiz. Agreed, I can make the change in the next
> version of the series after the other patches are reviewed.

Others look good, so please go ahead and send the new version once you
address these comments.

> Best wishes,
> Desmond
>
> >> +       if (!sco_pi(sk)->conn)
> >> +               return;
> >> +       work = &sco_pi(sk)->conn->timeout_work;
> >> +
> >>          BT_DBG("sock %p state %d timeout %ld", sk, sk->sk_state, timeout);
> >> -       sk_reset_timer(sk, &sk->sk_timer, jiffies + timeout);
> >> +       cancel_delayed_work(work);
> >> +       schedule_delayed_work(work, timeout);
> >>   }
> >>
> >>   static void sco_sock_clear_timer(struct sock *sk)
> >>   {
> >> +       struct delayed_work *work;
> >
> > Ditto.
> >
> >> +       if (!sco_pi(sk)->conn)
> >> +               return;
> >> +       work = &sco_pi(sk)->conn->timeout_work;
> >> +
> >>          BT_DBG("sock %p state %d", sk, sk->sk_state);
> >> -       sk_stop_timer(sk, &sk->sk_timer);
> >> +       cancel_delayed_work(work);
> >>   }
> >>
> >>   /* ---- SCO connections ---- */
> >> @@ -179,6 +205,9 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
> >>                  bh_unlock_sock(sk);
> >>                  sco_sock_kill(sk);
> >>                  sock_put(sk);
> >> +
> >> +               /* Ensure no more work items will run before freeing conn. */
> >> +               cancel_delayed_work_sync(&conn->timeout_work);
> >>          }
> >>
> >>          hcon->sco_data = NULL;
> >> @@ -193,6 +222,8 @@ static void __sco_chan_add(struct sco_conn *conn, struct sock *sk,
> >>          sco_pi(sk)->conn = conn;
> >>          conn->sk = sk;
> >>
> >> +       INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
> >> +
> >>          if (parent)
> >>                  bt_accept_enqueue(parent, sk, true);
> >>   }
> >> @@ -500,8 +531,6 @@ static struct sock *sco_sock_alloc(struct net *net, struct socket *sock,
> >>
> >>          sco_pi(sk)->setting = BT_VOICE_CVSD_16BIT;
> >>
> >> -       timer_setup(&sk->sk_timer, sco_sock_timeout, 0);
> >> -
> >>          bt_sock_link(&sco_sk_list, sk);
> >>          return sk;
> >>   }
> >> --
> >> 2.25.1
> >>
> >
> >
>


-- 
Luiz Augusto von Dentz
