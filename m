Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C783A1AFFF3
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 04:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgDTCtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 22:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725988AbgDTCtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 22:49:14 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD14C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 19:49:14 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id e26so9287982wmk.5
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 19:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XF4ZBNY8eOltoWS9DH59FU+3eJBejRyDMSM+6kiUWqs=;
        b=sIdmnxUmhis69w8p6uw4qmYP2Z5v6mqLxYksEbF/6q/iomvUq7MkebfX+6r4hNQtal
         nNRM3pLi5spDPsCuJdQUSaweESsriBDcscu9ILu+qw8SXNpkdpjE9ZbNcpK4/AjZzahU
         zgpBYkoUT8c4dNz102AQ7IP1+7o5pPQkQJILX/qBu3ZycrmeCcxJnWsGJSrkcsFZLpuu
         4XQycMOdPQR/32xwQ1yw9rOZS6SUno7a5wu4N4dnzrdaia/NTEjicPrKa0vyJRiAIn5O
         V0andon9Y84RJ17UaLC51x7qsGNU9mhLKZ98PqMq/W9jPzLpS7nkSi48uR+CiEqVZjZw
         ALyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XF4ZBNY8eOltoWS9DH59FU+3eJBejRyDMSM+6kiUWqs=;
        b=HIaDV9WveAg03YlArPUd/SAdZ/mkcVB1u/HBuX0b1KkdLUcGfAFwrQVs2ZojDJzuZy
         mc0fOuxG4WRl9l4va+Jgp5VvEM56Th2S+Z9ed5HPJPyLujQ020TP81ttCfcrlApO6m/2
         5q7QEHBn8f9ewJga1hEG1vLDHqin0TY/QrDfBKspLmlYu03uKR0V0USykbldz0x7+Eol
         2l/ap8M3r5A8NHZSSvqmhXubYOOzNtOIMt3pCRCxC89Iawp1SlnfAnPUVZf/5XIofxSa
         BOLwp92xIfiu+wefm4txCpo2QgSBJ1DoAsUy2xLJTh1pAkeAfh3jkhGbas3dxArqA3XY
         BQ0A==
X-Gm-Message-State: AGi0PuaO1AHeZglhIdqJTr8jIBdnX8+moo2ruCa2wrBnMj7Txq92+MiV
        St061/j1mjZsJrAZajKAGTV3vYHiK+pMIF+xOzH+IA==
X-Google-Smtp-Source: APiQypJD4f70XggReG9ai4HI1qrC5N8k0+rIXKntIyZBl9gMP9tGuxcdatP5lyiSjxCWOTDefnNPkW96yX1rkLY7e/w=
X-Received: by 2002:a1c:2e91:: with SMTP id u139mr14898263wmu.18.1587350952435;
 Sun, 19 Apr 2020 19:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200414160758.v1.1.Idab9dcdc7da549ed1fd5c66341fb8baffaee8d10@changeid>
In-Reply-To: <20200414160758.v1.1.Idab9dcdc7da549ed1fd5c66341fb8baffaee8d10@changeid>
From:   Archie Pusaka <apusaka@google.com>
Date:   Mon, 20 Apr 2020 10:49:01 +0800
Message-ID: <CAJQfnxF+Sw2tDf4-WwUdJNV9nxjjwr3H48=pt8Ja0eTt8jEdeA@mail.gmail.com>
Subject: Re: [PATCH v1] Bluetooth: L2CAP: add support for waiting
 disconnection resp
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Re-sending in plain text]
Hi bluetooth maintainers,

May I ask for your review on this?

Thanks,
Archie


On Tue, 14 Apr 2020 at 16:09, Archie Pusaka <apusaka@google.com> wrote:
>
> From: Archie Pusaka <apusaka@chromium.org>
>
> Whenever we disconnect a L2CAP connection, we would immediately
> report a disconnection event (EPOLLHUP) to the upper layer, without
> waiting for the response of the other device.
>
> This patch offers an option to wait until we receive a disconnection
> response before reporting disconnection event, by using the "how"
> parameter in l2cap_sock_shutdown(). Therefore, upper layer can opt
> to wait for disconnection response by shutdown(sock, SHUT_WR).
>
> This can be used to enforce proper disconnection order in HID,
> where the disconnection of the interrupt channel must be complete
> before attempting to disconnect the control channel.
>
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> ---
>
>  net/bluetooth/l2cap_sock.c | 30 +++++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
>
> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> index 1cea42ee1e922..a995d2c51fa7f 100644
> --- a/net/bluetooth/l2cap_sock.c
> +++ b/net/bluetooth/l2cap_sock.c
> @@ -1271,14 +1271,21 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
>         struct l2cap_conn *conn;
>         int err = 0;
>
> -       BT_DBG("sock %p, sk %p", sock, sk);
> +       BT_DBG("sock %p, sk %p, how %d", sock, sk, how);
> +
> +       /* 'how' parameter is mapped to sk_shutdown as follows:
> +        * SHUT_RD   (0) --> RCV_SHUTDOWN  (1)
> +        * SHUT_WR   (1) --> SEND_SHUTDOWN (2)
> +        * SHUT_RDWR (2) --> SHUTDOWN_MASK (3)
> +        */
> +       how++;
>
>         if (!sk)
>                 return 0;
>
>         lock_sock(sk);
>
> -       if (sk->sk_shutdown)
> +       if ((sk->sk_shutdown & how) == how)
>                 goto shutdown_already;
>
>         BT_DBG("Handling sock shutdown");
> @@ -1301,11 +1308,20 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
>                  * has already been actioned to close the L2CAP
>                  * link such as by l2cap_disconnection_req().
>                  */
> -               if (sk->sk_shutdown)
> -                       goto has_shutdown;
> +               if ((sk->sk_shutdown & how) == how)
> +                       goto shutdown_matched;
>         }
>
> -       sk->sk_shutdown = SHUTDOWN_MASK;
> +       /* Try setting the RCV_SHUTDOWN bit, return early if SEND_SHUTDOWN
> +        * is already set
> +        */
> +       if ((how & RCV_SHUTDOWN) && !(sk->sk_shutdown & RCV_SHUTDOWN)) {
> +               sk->sk_shutdown |= RCV_SHUTDOWN;
> +               if ((sk->sk_shutdown & how) == how)
> +                       goto shutdown_matched;
> +       }
> +
> +       sk->sk_shutdown |= SEND_SHUTDOWN;
>         release_sock(sk);
>
>         l2cap_chan_lock(chan);
> @@ -1335,7 +1351,7 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
>                 err = bt_sock_wait_state(sk, BT_CLOSED,
>                                          sk->sk_lingertime);
>
> -has_shutdown:
> +shutdown_matched:
>         l2cap_chan_put(chan);
>         sock_put(sk);
>
> @@ -1363,7 +1379,7 @@ static int l2cap_sock_release(struct socket *sock)
>
>         bt_sock_unlink(&l2cap_sk_list, sk);
>
> -       err = l2cap_sock_shutdown(sock, 2);
> +       err = l2cap_sock_shutdown(sock, SHUT_RDWR);
>         chan = l2cap_pi(sk)->chan;
>
>         l2cap_chan_hold(chan);
> --
> 2.26.0.110.g2183baf09c-goog
>
