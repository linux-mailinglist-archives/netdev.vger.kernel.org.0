Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012563BEE96
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 20:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhGGSXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 14:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbhGGSXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 14:23:47 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA08C061574;
        Wed,  7 Jul 2021 11:21:06 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id p22so4593728yba.7;
        Wed, 07 Jul 2021 11:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0UsMR6dgbLAQ7a3v8mrVQ2c0/k46Bj91GFDCBaSCAW8=;
        b=BmamxN7I7rJaC329iBWVyQyIczteQMFU3PqfDweMvffVAgXQB0hIfegSQCYp7/EDcu
         33Cy2hxSqR8BclpCp8CPoIwbV7Rl0TPR5dAa7kqUSRX421oz2WA84zQ6+ypSa8oM5vwC
         Ll8vAYRtiult7QIWRee0+w3XM1BJtokcCpIu1UQxq18542mZDQF7oP5WsyYLsSUS0RkL
         dsuc/C00mCmqKHdcQmv8OaM3fHCMa5ZxjndYIYnoJUUDa5SzRYxeG6V8dI/xChHmeYlI
         1cft7sLsyYNfr1Nnf5OUJyJPCCEEYJ6/SAhwpE0gUMqTxBrk9S4bNk32keLs9hQ7PCdv
         ZVwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0UsMR6dgbLAQ7a3v8mrVQ2c0/k46Bj91GFDCBaSCAW8=;
        b=SXARANUREwZ58+bmOXr0RMrj9Emrd2M9jw5iRXCBEZ46LE1hUkIXQmssuK/lXBQNel
         YuB2PqTCvsIbPbgets81NxamSlbuXUj/dR2O6GGzJ6VTTjEi5vzHn/O2IT19TL3sBszk
         Uxk5OTzRfzjEhRm1Oo1v3JprbOilGM/Je+1Gq0E/jn9nj9rqEP+Ceeu7tR/ZhDPvFfqP
         k4LgsnyrTrVj4+3FVEp/Yufcu5hruBQA2echUIUDzKrdarHZyUTrOnC3LL54T7LD0Bet
         Nqq++87fK1W8Il3h2AqKHptkkJZzcQKChamraJjp3dp4n4ZYNWnwaZC2AOeq8kwosH5I
         XU7w==
X-Gm-Message-State: AOAM531vGAsKX8yRDAf5i53hZ0kdc/ktGeqqk0UcUfi5erl1fq+Cm7C4
        Q2ONwPunVdsz3KWBLP6Eko66XHVHGTWa7wUBCRY=
X-Google-Smtp-Source: ABdhPJxG8Um+aWqqNQ0d5o811N/Wy+woMR8wf8ICYG23RYwDvaAnPXg4AO1H0FQyV88Ez1SVlYXpyB348CcJv7N0ZiI=
X-Received: by 2002:a25:be02:: with SMTP id h2mr34971749ybk.91.1625682065253;
 Wed, 07 Jul 2021 11:21:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210627131134.5434-1-penguin-kernel@I-love.SAKURA.ne.jp> <9deece33-5d7f-9dcb-9aaa-94c60d28fc9a@i-love.sakura.ne.jp>
In-Reply-To: <9deece33-5d7f-9dcb-9aaa-94c60d28fc9a@i-love.sakura.ne.jp>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 7 Jul 2021 11:20:54 -0700
Message-ID: <CABBYNZ+Vpzy2+u=xYR-7Kxx5M6pAQFQ8TJHYV1-Jr-FvqZ8=OQ@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: call lock_sock() outside of spinlock section
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Lin Ma <linma@zju.edu.cn>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tetsuo,

On Wed, Jul 7, 2021 at 2:43 AM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> syzbot is hitting might_sleep() warning at hci_sock_dev_event() due to
> calling lock_sock() with rw spinlock held [1]. Defer calling lock_sock()
> via sock_hold().
>
> Link: https://syzkaller.appspot.com/bug?extid=a5df189917e79d5e59c9 [1]
> Reported-by: syzbot <syzbot+a5df189917e79d5e59c9@syzkaller.appspotmail.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Tested-by: syzbot <syzbot+a5df189917e79d5e59c9@syzkaller.appspotmail.com>
> Fixes: e305509e678b3a4a ("Bluetooth: use correct lock to prevent UAF of hdev object")
> ---
> Changes in v2:
>   Take hci_sk_list.lock for write in case bt_sock_unlink() is called after
>   sk_hashed(sk) test, and defer hci_dev_put(hdev) till schedulable context.
>
>  net/bluetooth/hci_sock.c | 32 +++++++++++++++++++++++++++++---
>  1 file changed, 29 insertions(+), 3 deletions(-)
>
> diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
> index b04a5a02ecf3..d8e1ac1ae10d 100644
> --- a/net/bluetooth/hci_sock.c
> +++ b/net/bluetooth/hci_sock.c
> @@ -758,20 +758,46 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
>
>         if (event == HCI_DEV_UNREG) {
>                 struct sock *sk;
> +               bool put_dev;
>
> +restart:
> +               put_dev = false;
>                 /* Detach sockets from device */
>                 read_lock(&hci_sk_list.lock);
>                 sk_for_each(sk, &hci_sk_list.head) {
> +                       /* hci_sk_list.lock is preventing hci_sock_release()
> +                        * from calling bt_sock_unlink().
> +                        */
> +                       if (hci_pi(sk)->hdev != hdev || sk_unhashed(sk))
> +                               continue;
> +                       /* Take a ref because we can't call lock_sock() with
> +                        * hci_sk_list.lock held.
> +                        */
> +                       sock_hold(sk);
> +                       read_unlock(&hci_sk_list.lock);
>                         lock_sock(sk);
> -                       if (hci_pi(sk)->hdev == hdev) {
> +                       /* Since hci_sock_release() might have already called
> +                        * bt_sock_unlink() while waiting for lock_sock(),
> +                        * use sk_hashed(sk) for checking that bt_sock_unlink()
> +                        * is not yet called.
> +                        */
> +                       write_lock(&hci_sk_list.lock);
> +                       if (sk_hashed(sk) && hci_pi(sk)->hdev == hdev) {
>                                 hci_pi(sk)->hdev = NULL;
>                                 sk->sk_err = EPIPE;
>                                 sk->sk_state = BT_OPEN;
>                                 sk->sk_state_change(sk);
> -
> -                               hci_dev_put(hdev);
> +                               put_dev = true;
>                         }
> +                       write_unlock(&hci_sk_list.lock);
>                         release_sock(sk);
> +                       sock_put(sk);
> +                       if (put_dev)
> +                               hci_dev_put(hdev);
> +                       /* Restarting is safe, for hci_pi(sk)->hdev != hdev if
> +                        * condition met and sk_unhashed(sk) == true otherwise.
> +                        */
> +                       goto restart;

This sounds a little too complicated, afaik backward goto is not even
consider a good practice either, since it appears we don't unlink the
sockets here we could perhaps don't release the reference to hdev
either and leave hci_sock_release to deal with it and then perhaps we
can take away the backward goto, actually why are you restarting to
begin with? It is also weird that this only manifests in the Bluetooth
HCI sockets or other subsystems don't use such locking mechanism
anymore?


>                 }
>                 read_unlock(&hci_sk_list.lock);
>         }
> --
> 2.18.4
>
>


-- 
Luiz Augusto von Dentz
