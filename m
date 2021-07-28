Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0F83D9906
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 00:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhG1WuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 18:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbhG1WuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 18:50:23 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1775CC061757;
        Wed, 28 Jul 2021 15:50:20 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id j77so4725685ybj.3;
        Wed, 28 Jul 2021 15:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xDglts5u6VpbhAGOZw3Y55QgpbppwZZ4z2QzwRWYIMw=;
        b=eIhxy57lYiIrdgmnFC7BRTAEesLAb4gLsJQeoG/65b1YzdtHwDXRSbxJTnVcG0EASf
         kbp4e47lKcmtOq2+Di7E6T5iH4+/IVc1scAG2IWA0Us2wPph7L/4g8KQVUuh6fA5vbiV
         xKVhazCDLSddziWs1wTtasX2qOrAlLApeOzb3p/57+9XfkrtRpNSpP2DtALyARHkIDVn
         851552cmTNttBrfFx3JpMe988uT/CUVskrbD4bY8e/ibJzV27GRzLwNCsEcsy+TArL1W
         Rm+ZFboyIkiRvmb63IFr7OZE/feFe9wnq8W9GjxsU+u+NYWXRbNuFGyNkheXgWFZeaij
         dqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xDglts5u6VpbhAGOZw3Y55QgpbppwZZ4z2QzwRWYIMw=;
        b=Tj3Ikcw9x0PhhQ45cgfTdQPpNXRqAyt7+DOJb/T1vNf0E+3iZA5Dky9AbqsKZ47OpG
         iQMSjk3CcRlPRav/FVxMGGzb+8puBXxyrGOdq8yZ7rL6cFWCrdshba6JNVmzpeR6eekM
         vbYOp5CHbibhQQG4Zy+a2SrJQJkhKLj64qo+M1kwo8ufgeRAZ4rIw5rkhdM2Fts2dLCc
         IHwj2CGR8hhMPCyDoZMZNT4LU+1YBIvf+iFGJyxQ+1az4nRHrJxxadFneDaOf7cDUx4Q
         qaSyfNFi6d1PZP3UjhsJII20JxqveQqbbro+j57beCG1keCvNHieRsy74EhcZ5vJDwQg
         Qdfw==
X-Gm-Message-State: AOAM5306BiXCmN2Zj3B52a2YJpvKa/yESikpqKg1FPtw+EF7iUalXYhJ
        iaMDr1kTpYkocfS6dKjAPKahQJdNYcEuobzpJw0=
X-Google-Smtp-Source: ABdhPJygSR7K8iQnG/zIAjQnp2X206xR9Ica52iAlCPgC8m7bMf1qoOiLsIIJjJeMk87sEjwdFqBRsYU2LrPAnFE92U=
X-Received: by 2002:a25:8205:: with SMTP id q5mr2678137ybk.440.1627512619052;
 Wed, 28 Jul 2021 15:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210728071721.411669-1-desmondcheongzx@gmail.com>
In-Reply-To: <20210728071721.411669-1-desmondcheongzx@gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 28 Jul 2021 15:50:08 -0700
Message-ID: <CABBYNZJcSS+fnTtF4S4UqASaG2DSN4DxwC-8AZAOaEkfu68uew@mail.gmail.com>
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

Is there a way to trigger syzbot to know if this change really fixes it?

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
