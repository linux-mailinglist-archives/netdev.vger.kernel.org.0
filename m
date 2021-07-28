Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDE43D993E
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 01:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbhG1XHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 19:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhG1XHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 19:07:21 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236CCC061757;
        Wed, 28 Jul 2021 16:07:18 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id g76so6785767ybf.4;
        Wed, 28 Jul 2021 16:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YB8k0/fiFBr2NsCXH8EWlSJZG1gcH0AVu3WpdkGNwJk=;
        b=C8kE4oIo6Wr42OXo5/ZVvLx0ILTtlT2j/Q9aLJqXKaFfWTXpEJBHWB6ET3Zj5MEebB
         813BUXtkZRlxzCmbGLcIBRV4mUK3UeNNjoM8POfHBQimvP6Uxdyq7xxsJPFGWY5lkEe4
         ZDkBD1hDb7AmsKoxty8t1YDnwiXIpSig/r6POruExbWOqhZE4MZVZWEzDHMBoLlJWvx+
         Rb16rA6PpRtj+vwMDFWj1pzfFxLqaoo0eGMQst5h4qHmxwOo/QhpyiDbxMVmrkTU9vZ7
         3l+x/nufF/52QUeLJxm9jzBerjnVTfezH/xWieCihkusir96q/fFSvPfrZoLSepd0lR2
         EFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YB8k0/fiFBr2NsCXH8EWlSJZG1gcH0AVu3WpdkGNwJk=;
        b=HowHvdhyjqwI6I2BGaIT2fRTQwYRwpxfvJcjKSF4JdQTQxUJC1QeEeMkxKr+Wgp/JP
         qOHT7LBLemU0Yk9pHg+nLxQNRvk+KyYa/aNhrsTjMpbNJVdHh3/wlQpy35WXsuheqP5s
         oJcl4qneVMyyLP+oYrGcaaT6cg5qSHE6G2wH/EFnK2E66jU00Gc1gjxzif7rfkHOPfyL
         CdJHtxIpUN4tgZqQ3ubHmB6YxsvZYROufX1bzXe2WlcLkFUdwp8ff+W6Coo3SH1yW1qa
         0ZPBJH+4A2LZw6ZTU79h00fN3uabufuKjp/yOWv1XT93o3XwOCLcarGw1OfPeVHy6oAk
         Kr+A==
X-Gm-Message-State: AOAM532mEc4wDdQ2glbcKam6/ds6QEUunvsEfWn0GUskYhoKoSwyvmSB
        e8hx75ifrEXeY6oRYrqf1nMkOcvrH2yWULRzs20=
X-Google-Smtp-Source: ABdhPJyO2Mz5NYMVPl04ypqxQjsgE6mymiY1/QbRnSTHk3uyyA5qpydtvrUK8zlq/rQh0FzqnS/UyHoU0Ou5jgaMjG8=
X-Received: by 2002:a25:7e86:: with SMTP id z128mr2805604ybc.222.1627513636722;
 Wed, 28 Jul 2021 16:07:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210728071721.411669-1-desmondcheongzx@gmail.com>
In-Reply-To: <20210728071721.411669-1-desmondcheongzx@gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 28 Jul 2021 16:07:05 -0700
Message-ID: <CABBYNZ+_mYB=r3B-f0Pu214ZmKVAM2EmpSFYQksTDbdm61Q4Bw@mail.gmail.com>
Subject: Re: [PATCH v4] Bluetooth: schedule SCO timeouts with delayed_work
To:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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

On Wed, Jul 28, 2021 at 12:17 AM Desmond Cheong Zhi Xi
<desmondcheongzx@gmail.com> wrote:
>
> struct sock.sk_timer should be used as a sock cleanup timer. However,
> SCO uses it to implement sock timeouts.
>
> This causes issues because struct sock.sk_timer's callback is run in
> an IRQ context, and the timer callback function sco_sock_timeout takes
> a spin lock on the socket. However, other functions such as
> sco_conn_del, sco_conn_ready, rfcomm_connect_ind, and
> bt_accept_enqueue also take the spin lock with interrupts enabled.
>
> This inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} lock usage could
> lead to deadlocks as reported by Syzbot [1]:
>        CPU0
>        ----
>   lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>   <Interrupt>
>     lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>
> To fix this, we use delayed work to implement SCO sock timouts
> instead. This allows us to avoid taking the spin lock on the socket in
> an IRQ context, and corrects the misuse of struct sock.sk_timer.
>
> Link: https://syzkaller.appspot.com/bug?id=9089d89de0502e120f234ca0fc8a703f7368b31e [1]
> Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
> Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
> ---
>
> Hi,
>
> As suggested, this patch addresses the inconsistent lock state while
> avoiding having to deal with local_bh_disable.
>
> Now that sco_sock_timeout is no longer run in IRQ context, it might
> be the case that bh_lock_sock is no longer needed to sync between
> SOFTIRQ and user contexts, so we can switch to lock_sock.
>
> I'm not too certain about this, or if there's any benefit to using
> lock_sock instead, so I've left that out of this patch.
>
> v3 -> v4:
> - Switch to using delayed_work to schedule SCO sock timeouts instead
> of using local_bh_disable. As suggested by Luiz Augusto von Dentz.
>
> v2 -> v3:
> - Split SCO and RFCOMM code changes, as suggested by Luiz Augusto von
> Dentz.
> - Simplify local bh disabling in SCO by using local_bh_disable/enable
> inside sco_chan_del since local_bh_disable/enable pairs are reentrant.
>
> v1 -> v2:
> - Instead of pulling out the clean-up code out from sco_chan_del and
> using it directly in sco_conn_del, disable local softirqs for relevant
> sections.
> - Disable local softirqs more thoroughly for instances of
> bh_lock_sock/bh_lock_sock_nested in the bluetooth subsystem.
> Specifically, the calls in af_bluetooth.c and rfcomm/sock.c are now made
> with local softirqs disabled as well.
>
> Best wishes,
> Desmond
>
>  net/bluetooth/sco.c | 39 ++++++++++++++++++++++++---------------
>  1 file changed, 24 insertions(+), 15 deletions(-)
>
> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> index 3bd41563f118..b6dd16153d38 100644
> --- a/net/bluetooth/sco.c
> +++ b/net/bluetooth/sco.c
> @@ -48,6 +48,8 @@ struct sco_conn {
>         spinlock_t      lock;
>         struct sock     *sk;
>
> +       struct delayed_work     sk_timer;
> +
>         unsigned int    mtu;
>  };
>
> @@ -74,9 +76,11 @@ struct sco_pinfo {
>  #define SCO_CONN_TIMEOUT       (HZ * 40)
>  #define SCO_DISCONN_TIMEOUT    (HZ * 2)
>
> -static void sco_sock_timeout(struct timer_list *t)
> +static void sco_sock_timeout(struct work_struct *work)
>  {
> -       struct sock *sk = from_timer(sk, t, sk_timer);
> +       struct sco_conn *conn = container_of(work, struct sco_conn,
> +                                            sk_timer.work);
> +       struct sock *sk = conn->sk;
>
>         BT_DBG("sock %p state %d", sk, sk->sk_state);
>
> @@ -89,16 +93,18 @@ static void sco_sock_timeout(struct timer_list *t)
>         sock_put(sk);
>  }
>
> -static void sco_sock_set_timer(struct sock *sk, long timeout)
> +static void sco_sock_set_timer(struct sock *sk, struct delayed_work *work,
> +                              long timeout)
>  {
>         BT_DBG("sock %p state %d timeout %ld", sk, sk->sk_state, timeout);
> -       sk_reset_timer(sk, &sk->sk_timer, jiffies + timeout);
> +       cancel_delayed_work(work);
> +       schedule_delayed_work(work, timeout);

I guess if you want to really guarantee cancel takes effect you must
call cancel_delayed_work_sync

>  }
>
> -static void sco_sock_clear_timer(struct sock *sk)
> +static void sco_sock_clear_timer(struct sock *sk, struct delayed_work *work)
>  {
>         BT_DBG("sock %p state %d", sk, sk->sk_state);
> -       sk_stop_timer(sk, &sk->sk_timer);
> +       cancel_delayed_work(work);
>  }
>
>  /* ---- SCO connections ---- */
> @@ -174,7 +180,7 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
>         if (sk) {
>                 sock_hold(sk);
>                 bh_lock_sock(sk);
> -               sco_sock_clear_timer(sk);
> +               sco_sock_clear_timer(sk, &conn->sk_timer);
>                 sco_chan_del(sk, err);
>                 bh_unlock_sock(sk);
>                 sco_sock_kill(sk);
> @@ -193,6 +199,8 @@ static void __sco_chan_add(struct sco_conn *conn, struct sock *sk,
>         sco_pi(sk)->conn = conn;
>         conn->sk = sk;
>
> +       INIT_DELAYED_WORK(&conn->sk_timer, sco_sock_timeout);
> +
>         if (parent)
>                 bt_accept_enqueue(parent, sk, true);
>  }
> @@ -260,11 +268,11 @@ static int sco_connect(struct sock *sk)
>                 goto done;
>
>         if (hcon->state == BT_CONNECTED) {
> -               sco_sock_clear_timer(sk);
> +               sco_sock_clear_timer(sk, &conn->sk_timer);
>                 sk->sk_state = BT_CONNECTED;
>         } else {
>                 sk->sk_state = BT_CONNECT;
> -               sco_sock_set_timer(sk, sk->sk_sndtimeo);
> +               sco_sock_set_timer(sk, &conn->sk_timer, sk->sk_sndtimeo);
>         }
>
>  done:
> @@ -419,7 +427,8 @@ static void __sco_sock_close(struct sock *sk)
>         case BT_CONFIG:
>                 if (sco_pi(sk)->conn->hcon) {
>                         sk->sk_state = BT_DISCONN;
> -                       sco_sock_set_timer(sk, SCO_DISCONN_TIMEOUT);
> +                       sco_sock_set_timer(sk, &sco_pi(sk)->conn->sk_timer,
> +                                          SCO_DISCONN_TIMEOUT);
>                         sco_conn_lock(sco_pi(sk)->conn);
>                         hci_conn_drop(sco_pi(sk)->conn->hcon);
>                         sco_pi(sk)->conn->hcon = NULL;
> @@ -443,7 +452,8 @@ static void __sco_sock_close(struct sock *sk)
>  /* Must be called on unlocked socket. */
>  static void sco_sock_close(struct sock *sk)
>  {
> -       sco_sock_clear_timer(sk);
> +       if (sco_pi(sk)->conn)
> +               sco_sock_clear_timer(sk, &sco_pi(sk)->conn->sk_timer);
>         lock_sock(sk);
>         __sco_sock_close(sk);
>         release_sock(sk);
> @@ -500,8 +510,6 @@ static struct sock *sco_sock_alloc(struct net *net, struct socket *sock,
>
>         sco_pi(sk)->setting = BT_VOICE_CVSD_16BIT;
>
> -       timer_setup(&sk->sk_timer, sco_sock_timeout, 0);
> -
>         bt_sock_link(&sco_sk_list, sk);
>         return sk;
>  }
> @@ -1036,7 +1044,8 @@ static int sco_sock_shutdown(struct socket *sock, int how)
>
>         if (!sk->sk_shutdown) {
>                 sk->sk_shutdown = SHUTDOWN_MASK;
> -               sco_sock_clear_timer(sk);
> +               if (sco_pi(sk)->conn)
> +                       sco_sock_clear_timer(sk, &sco_pi(sk)->conn->sk_timer);

It probably makes it simpler if we can have the check for
sco_pi(sk)->conn inside sco_sock_{clear,set}_timer, that way we don't
need to keep checking like in the code above.

>                 __sco_sock_close(sk);
>
>                 if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
> @@ -1083,7 +1092,7 @@ static void sco_conn_ready(struct sco_conn *conn)
>         BT_DBG("conn %p", conn);
>
>         if (sk) {
> -               sco_sock_clear_timer(sk);
> +               sco_sock_clear_timer(sk, &conn->sk_timer);
>                 bh_lock_sock(sk);
>                 sk->sk_state = BT_CONNECTED;
>                 sk->sk_state_change(sk);
> --
> 2.25.1
>


-- 
Luiz Augusto von Dentz
