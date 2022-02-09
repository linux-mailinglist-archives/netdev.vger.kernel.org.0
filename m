Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F1F4AE6B1
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 03:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242263AbiBICkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 21:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241862AbiBIBHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 20:07:08 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A037C06157B;
        Tue,  8 Feb 2022 17:07:07 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id c6so1652710ybk.3;
        Tue, 08 Feb 2022 17:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gWLpVKRgj6qNlwd6T0x0f3bWJlz86m3X+7fitr5avvo=;
        b=XQ5aPXyPPfTSGU97cIuuPkKprxaQDHXXpynMhRQNnPgBpmO1VP8qa5kw894N47Dy44
         nZdGu6B2qEyq+wVnQGglFxldwcRVd2f2bGcdoA3OJpQH9qIMZPuZZO8ONRcyvoYwUf66
         jhZcNpLH7VPHrEmrQvLGLrbV4dnkWQHJtaTnzIlqbqWbA/Cze3rs2GtmMv+AwuLZsxMZ
         Gsn2adro83f7UCEbqwIEzbg6pg1ea4FpHoSDwdISH24kRkrtnX4qo4bYzPPwlHtpocUF
         m24JYYUjpqnhjBtQm0J3EzeVL5fhibf0EG6IH/51z5AVo7d/1pq76yaQU+TVMHSNHC5t
         lE5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gWLpVKRgj6qNlwd6T0x0f3bWJlz86m3X+7fitr5avvo=;
        b=cdIpBhW1HRcZI1fuzowGCTZO7gB35EovVPCinQljZ6+y0o/eTjlMxmN2pB2getZj6P
         X8mRXmgZ3+SWaCz3K55CZ3+U2XwQOw5wEpX0M9Cr+tPRtcVRA7GJh/CSp8iMRS92y+qI
         HSa0hVB0KRkLlclQKxCaujFKiJJe1deyNpcGtJ8nQe0UGJ3lOPGekYoVWfdAF/Q+fmrI
         9ptdNYzV0/+XvEadac4wC5OltPRGW0rbKW3zCkS6aWH4EON+J6CbYeMHe28sEAMusExN
         uq6WHr417U3pCNVdNGWi//TeZzUREWl164U9T7gumnnta6YTYPY6XdMLeLTDA5zEV2qS
         m4Mg==
X-Gm-Message-State: AOAM533chkE/iFxAvnvvpjm1yC9DxrhQ7ukGPiIR2yHQ7s6ykz+tr3w8
        4B8vaXfmO8dzUVO6SF3jVzkOaEfe74LP5GNwV7w=
X-Google-Smtp-Source: ABdhPJzlQO7sorUpjUtav9AXsUukam3TPueefNCr8aWMRldfUKZZsyZ6hujYAVIXOSJOmcjlqOuIysdRK2Eg5Rf4S5w=
X-Received: by 2002:a0d:c542:: with SMTP id h63mr7621202ywd.376.1644368826567;
 Tue, 08 Feb 2022 17:07:06 -0800 (PST)
MIME-Version: 1.0
References: <20220208221911.57058-1-pmenzel@molgen.mpg.de> <20220208221911.57058-2-pmenzel@molgen.mpg.de>
In-Reply-To: <20220208221911.57058-2-pmenzel@molgen.mpg.de>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 8 Feb 2022 17:06:55 -0800
Message-ID: <CABBYNZ+33DB=r6w-aLw=+7S6Ryo0zM54A7gx0XpfsFx65Pxh4Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] Revert "Bluetooth: RFCOMM: Replace use of
 memcpy_from_msg with bt_skb_sendmmsg"
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

On Tue, Feb 8, 2022 at 2:20 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> This reverts commit 81be03e026dc0c16dc1c64e088b2a53b73caa895.
>
> Since the commit, transferring files greater than some bytes to the
> Nokia N9 (MeeGo) or Jolla (Sailfish OS) is not possible anymore.
>
>     # obexctl
>     [NEW] Client /org/bluez/obex
>     [obex]# connect 40:98:4E:5B:CE:XX
>     Attempting to connect to 40:98:4E:5B:CE:XX
>     [NEW] Session /org/bluez/obex/client/session0 [default]
>     [NEW] ObjectPush /org/bluez/obex/client/session0
>     Connection successful
>     [40:98:4E:5B:CE:XX]# send /lib/systemd/systemd
>     Attempting to send /lib/systemd/systemd to /org/bluez/obex/client/session0
>     [NEW] Transfer /org/bluez/obex/client/session0/transfer0
>     Transfer /org/bluez/obex/client/session0/transfer0
>         Status: queued
>         Name: systemd
>         Size: 1841712
>         Filename: /lib/systemd/systemd
>         Session: /org/bluez/obex/client/session0
>     [CHG] Transfer /org/bluez/obex/client/session0/transfer0 Status: active
>     [CHG] Transfer /org/bluez/obex/client/session0/transfer0 Transferred: 32737 (@32KB/s 00:55)
>     [CHG] Transfer /org/bluez/obex/client/session0/transfer0 Status: error
>     [DEL] Transfer /org/bluez/obex/client/session0/transfer0

Would you please create a github issue
(https://github.com/bluez/bluez/issues/) and attach the btmon trace so
we can check what is the error, you might as well attach the obexd
logs.

> Reverting it, fixes the regression.
>
> Link: https://lore.kernel.org/linux-bluetooth/aa3ee7ac-6c52-3861-1798-3cc1a37f6ebf@molgen.mpg.de/T/#m1f9673e4ab0d55a7dccf87905337ab2e67d689f1
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
> ---
>  net/bluetooth/rfcomm/core.c | 50 ++++++-------------------------------
>  net/bluetooth/rfcomm/sock.c | 46 ++++++++++++++++++++++++++--------
>  2 files changed, 43 insertions(+), 53 deletions(-)
>
> diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
> index 7324764384b6..f2bacb464ccf 100644
> --- a/net/bluetooth/rfcomm/core.c
> +++ b/net/bluetooth/rfcomm/core.c
> @@ -549,58 +549,22 @@ struct rfcomm_dlc *rfcomm_dlc_exists(bdaddr_t *src, bdaddr_t *dst, u8 channel)
>         return dlc;
>  }
>
> -static int rfcomm_dlc_send_frag(struct rfcomm_dlc *d, struct sk_buff *frag)
> -{
> -       int len = frag->len;
> -
> -       BT_DBG("dlc %p mtu %d len %d", d, d->mtu, len);
> -
> -       if (len > d->mtu)
> -               return -EINVAL;
> -
> -       rfcomm_make_uih(frag, d->addr);
> -       __skb_queue_tail(&d->tx_queue, frag);
> -
> -       return len;
> -}
> -
>  int rfcomm_dlc_send(struct rfcomm_dlc *d, struct sk_buff *skb)
>  {
> -       unsigned long flags;
> -       struct sk_buff *frag, *next;
> -       int len;
> +       int len = skb->len;
>
>         if (d->state != BT_CONNECTED)
>                 return -ENOTCONN;
>
> -       frag = skb_shinfo(skb)->frag_list;
> -       skb_shinfo(skb)->frag_list = NULL;
> -
> -       /* Queue all fragments atomically. */
> -       spin_lock_irqsave(&d->tx_queue.lock, flags);
> -
> -       len = rfcomm_dlc_send_frag(d, skb);
> -       if (len < 0 || !frag)
> -               goto unlock;
> -
> -       for (; frag; frag = next) {
> -               int ret;
> -
> -               next = frag->next;
> -
> -               ret = rfcomm_dlc_send_frag(d, frag);
> -               if (ret < 0) {
> -                       kfree_skb(frag);
> -                       goto unlock;
> -               }
> +       BT_DBG("dlc %p mtu %d len %d", d, d->mtu, len);
>
> -               len += ret;
> -       }
> +       if (len > d->mtu)
> +               return -EINVAL;
>
> -unlock:
> -       spin_unlock_irqrestore(&d->tx_queue.lock, flags);
> +       rfcomm_make_uih(skb, d->addr);
> +       skb_queue_tail(&d->tx_queue, skb);
>
> -       if (len > 0 && !test_bit(RFCOMM_TX_THROTTLED, &d->flags))
> +       if (!test_bit(RFCOMM_TX_THROTTLED, &d->flags))
>                 rfcomm_schedule();
>         return len;
>  }
> diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
> index 5938af3e9936..2c95bb58f901 100644
> --- a/net/bluetooth/rfcomm/sock.c
> +++ b/net/bluetooth/rfcomm/sock.c
> @@ -575,20 +575,46 @@ static int rfcomm_sock_sendmsg(struct socket *sock, struct msghdr *msg,
>         lock_sock(sk);
>
>         sent = bt_sock_wait_ready(sk, msg->msg_flags);
> +       if (sent)
> +               goto done;
>
> -       release_sock(sk);
> +       while (len) {
> +               size_t size = min_t(size_t, len, d->mtu);
> +               int err;
>
> -       if (sent)
> -               return sent;
> +               skb = sock_alloc_send_skb(sk, size + RFCOMM_SKB_RESERVE,
> +                               msg->msg_flags & MSG_DONTWAIT, &err);
> +               if (!skb) {
> +                       if (sent == 0)
> +                               sent = err;
> +                       break;
> +               }
> +               skb_reserve(skb, RFCOMM_SKB_HEAD_RESERVE);
> +
> +               err = memcpy_from_msg(skb_put(skb, size), msg, size);
> +               if (err) {
> +                       kfree_skb(skb);
> +                       if (sent == 0)
> +                               sent = err;
> +                       break;
> +               }
> +
> +               skb->priority = sk->sk_priority;
> +
> +               err = rfcomm_dlc_send(d, skb);
> +               if (err < 0) {
> +                       kfree_skb(skb);
> +                       if (sent == 0)
> +                               sent = err;
> +                       break;
> +               }
>
> -       skb = bt_skb_sendmmsg(sk, msg, len, d->mtu, RFCOMM_SKB_HEAD_RESERVE,
> -                             RFCOMM_SKB_TAIL_RESERVE);
> -       if (IS_ERR_OR_NULL(skb))
> -               return PTR_ERR(skb);
> +               sent += size;
> +               len  -= size;
> +       }
>
> -       sent = rfcomm_dlc_send(d, skb);
> -       if (sent < 0)
> -               kfree_skb(skb);
> +done:
> +       release_sock(sk);
>
>         return sent;
>  }
> --
> 2.34.1
>


-- 
Luiz Augusto von Dentz
